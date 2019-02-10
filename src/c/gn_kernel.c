/**
 * gn_kernel.c: Gaussian Noise (GN) physical-layer optical impairment model.
 *
 * Closed-form analytical non-linear interference (NLI) calculations,
 * EDFA amplified spontaneous emission (ASE) noise accumulation,
 * generalized OSNR (gOSNR), Q-factor, and pre-FEC BER estimation.
 *
 * References:
 *   - P. Poggiolini et al., "The GN-Model of Non-Linear Propagation in
 *     Uncompensated Coherent Systems", J. Lightwave Technol., vol. 30, 2012.
 *   - Carena et al., "EGN model of non-linear fiber transmission", Optics Express, 2014.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#include "etalon.h"
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

/* Standard error function approximation */
static double compute_erfc(double x) {
    /* Abramowitz and Stegun approximation (formula 7.1.26) */
    double t = 1.0 / (1.0 + 0.3275911 * fabs(x));
    double poly = t * (0.254829592 + t * (-0.284496736 + t * (1.421413741 + t * (-1.453152027 + t * 1.061405429))));
    double ans = poly * exp(-x * x);
    return x >= 0 ? ans : 2.0 - ans;
}

etalon_status_t etalon_gn_compute_nli(
    const etalon_fiber_span_t* span,
    double center_freq_hz,
    double symbol_rate_baud,
    double channel_power_w,
    uint32_t num_channels,
    double channel_spacing_hz,
    double* out_nli_w) {

    if (!span || !out_nli_w || symbol_rate_baud <= 0 || channel_power_w <= 0) {
        return ETALON_ERROR_INVALID_PARAM;
    }

    /* Attenuation in Np/m */
    double alpha_db_per_m = span->loss_db_per_km / 1000.0;
    double alpha_np_per_m = alpha_db_per_m * log(10.0) / 20.0;

    /* Effective length in meters */
    double length_m = span->length_km * 1000.0;
    double l_eff_m = (1.0 - exp(-2.0 * alpha_np_per_m * length_m)) / (2.0 * alpha_np_per_m);

    /* Group velocity dispersion parameter beta2 in s^2/m */
    double lambda_m = ETALON_SPEED_OF_LIGHT / center_freq_hz;
    double d_si = span->dispersion_ps_nm_km * 1e-6; /* s / (m^2) */
    double beta2 = -(d_si * lambda_m * lambda_m) / (2.0 * M_PI * ETALON_SPEED_OF_LIGHT);
    double abs_beta2 = fabs(beta2);

    if (abs_beta2 < 1e-30) {
        abs_beta2 = 1e-30; /* Prevent division by zero */
    }

    /* Non-linear Kerr coefficient gamma in 1 / (W * m) */
    double a_eff_m2 = span->effective_area_um2 * 1e-12;
    double gamma = (2.0 * M_PI * span->non_linear_index_n2) / (lambda_m * a_eff_m2);

    /* Signal power spectral density G_tx in W / Hz */
    double b_ch = symbol_rate_baud;
    double g_tx = channel_power_w / b_ch;

    /* Self-Phase Modulation (SPM) power spectral density */
    double asinh_arg = (M_PI * M_PI / (2.0 * alpha_np_per_m)) * abs_beta2 * (b_ch * b_ch);
    double asinh_val = asinh(asinh_arg);

    double g_spm_factor = (16.0 / 27.0) * (gamma * gamma) * (g_tx * g_tx * g_tx) * (l_eff_m * l_eff_m);
    double g_nli_spm = g_spm_factor * (asinh_val / (M_PI * abs_beta2 * b_ch));

    /* Cross-Phase Modulation (XPM) power spectral density */
    double g_nli_xpm = 0.0;
    int half_channels = (int)num_channels / 2;

    for (int k = -half_channels; k <= half_channels; ++k) {
        if (k == 0) continue;
        double delta_f = fabs((double)k * channel_spacing_hz);
        if (delta_f <= b_ch / 2.0) continue;

        double log_arg = (delta_f + b_ch / 2.0) / (delta_f - b_ch / 2.0);
        if (log_arg > 1.0) {
            double xpm_term = g_spm_factor * (log(log_arg) / (M_PI * abs_beta2 * delta_f));
            g_nli_xpm += xpm_term;
        }
    }

    /* Integrate PSD over optical channel bandwidth */
    *out_nli_w = (g_nli_spm + g_nli_xpm) * b_ch;
    return ETALON_STATUS_OK;
}

etalon_status_t etalon_evaluate_lightpath(
    const etalon_fiber_span_t* spans,
    const etalon_edfa_t* amplifiers,
    uint32_t span_count,
    double launch_power_dbm,
    double symbol_rate_baud,
    etalon_modulation_t mod,
    etalon_fec_type_t fec,
    etalon_lightpath_metrics_t* out_metrics) {

    if (!spans || !amplifiers || !out_metrics || span_count == 0) {
        return ETALON_ERROR_INVALID_PARAM;
    }

    double channel_power_w = pow(10.0, (launch_power_dbm - 30.0) / 10.0);
    double center_freq = ETALON_REF_FREQ_HZ;
    double total_ase_w = 0.0;
    double total_nli_w = 0.0;

    /* Optical reference noise bandwidth for OSNR: 0.1 nm = 12.5 GHz */
    double b_ref_hz = 12.5e9;

    for (uint32_t i = 0; i < span_count; ++i) {
        /* Compute NLI for the span */
        double span_nli = 0.0;
        etalon_status_t st = etalon_gn_compute_nli(&spans[i], center_freq, symbol_rate_baud, channel_power_w, 80, 50e9, &span_nli);
        if (st != ETALON_STATUS_OK) return st;
        total_nli_w += span_nli;

        /* EDFA ASE noise generation */
        if (amplifiers[i].ase_enabled) {
            double gain_linear = pow(10.0, amplifiers[i].gain_db / 10.0);
            double nf_linear = pow(10.0, amplifiers[i].noise_figure_db / 10.0);
            /* ASE noise power in both polarizations: P_ase = 2 * n_sp * (G - 1) * h * f * B */
            double n_sp = nf_linear / 2.0;
            double span_ase = 2.0 * n_sp * (gain_linear - 1.0) * ETALON_PLANCK_CONSTANT * center_freq * b_ref_hz;
            total_ase_w += span_ase;
        }
    }

    double total_noise_w = total_ase_w + total_nli_w;
    if (total_noise_w < 1e-30) total_noise_w = 1e-30;

    double snr_linear = channel_power_w / total_noise_w;
    double snr_db = 10.0 * log10(snr_linear);

    /* Q-factor and pre-FEC BER estimation based on modulation format */
    double bits_per_symbol = 2.0; /* Default DP-QPSK */
    double ber_threshold = 3.8e-3; /* Default HD-FEC 7% */

    switch (mod) {
        case ETALON_MOD_DP_BPSK:  bits_per_symbol = 1.0; break;
        case ETALON_MOD_DP_QPSK:  bits_per_symbol = 2.0; break;
        case ETALON_MOD_DP_8QAM:  bits_per_symbol = 3.0; break;
        case ETALON_MOD_DP_16QAM: bits_per_symbol = 4.0; break;
        case ETALON_MOD_DP_32QAM: bits_per_symbol = 5.0; break;
        case ETALON_MOD_DP_64QAM: bits_per_symbol = 6.0; break;
    }

    switch (fec) {
        case ETALON_FEC_NONE:             ber_threshold = 1.0e-12; break;
        case ETALON_FEC_HARD_DECISION_7:  ber_threshold = 3.8e-3; break;
        case ETALON_FEC_SOFT_DECISION_15: ber_threshold = 1.5e-2; break;
        case ETALON_FEC_SOFT_DECISION_27: ber_threshold = 2.4e-2; break;
    }

    double q_linear = sqrt(2.0 * snr_linear / (bits_per_symbol * 0.5 + 0.5));
    double q_factor_db = 20.0 * log10(q_linear);
    double estimated_ber = 0.5 * compute_erfc(q_linear / sqrt(2.0));

    double req_snr_linear = 2.0; /* Base margin calculation */
    double fec_margin_db = snr_db - (10.0 * log10(req_snr_linear) + bits_per_symbol * 2.0);

    out_metrics->carrier_freq_hz = center_freq;
    out_metrics->symbol_rate_baud = symbol_rate_baud;
    out_metrics->modulation = mod;
    out_metrics->fec_type = fec;
    out_metrics->signal_power_w = channel_power_w;
    out_metrics->ase_noise_power_w = total_ase_w;
    out_metrics->nli_noise_power_w = total_nli_w;
    out_metrics->snr_linear = snr_linear;
    out_metrics->snr_db = snr_db;
    out_metrics->q_factor_db = q_factor_db;
    out_metrics->estimated_ber = estimated_ber;
    out_metrics->fec_margin_db = fec_margin_db;
    out_metrics->feasible = (estimated_ber <= ber_threshold && fec_margin_db >= 0.0);

    return ETALON_STATUS_OK;
}
