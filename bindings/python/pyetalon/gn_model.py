"""
gn_model.py: Gaussian Noise (GN) Physical-Layer Impairment Model.

Calculates ASE noise accumulation, Kerr non-linear interference (NLI) power spectral density,
generalized OSNR (gOSNR), and pre-FEC Bit Error Rate (BER).

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import math
from dataclasses import dataclass
from typing import List, Optional, Tuple
from .core import (
    CFiberSpan,
    CEdfa,
    CLightpathMetrics,
    EtalonStatus,
    ModulationFormat,
    FecType,
    get_lib,
    has_native_lib,
)

PLANCK_H = 6.62607015e-34
SPEED_OF_LIGHT = 299792458.0

@dataclass
class FiberSpan:
    length_km: float = 80.0
    loss_db_per_km: float = 0.20
    dispersion_ps_nm_km: float = 16.5
    dispersion_slope: float = 0.08
    pmd_ps_sqrt_km: float = 0.04
    effective_area_um2: float = 80.0
    non_linear_index_n2: float = 2.6e-20
    launch_power_dbm: float = 0.0

    @property
    def total_loss_db(self) -> float:
        return self.length_km * self.loss_db_per_km

    @property
    def gamma(self) -> float:
        # Non-linear coefficient gamma = (2 * pi * n2) / (lambda * A_eff)
        # At 1550 nm:
        lam = 1550e-9
        a_eff_m2 = self.effective_area_um2 * 1e-12
        return (2.0 * math.pi * self.non_linear_index_n2) / (lam * a_eff_m2)

    @property
    def beta2(self) -> float:
        # beta2 = - (D * lambda^2) / (2 * pi * c)
        lam = 1550e-9
        d_si = self.dispersion_ps_nm_km * 1e-6
        return - (d_si * lam * lam) / (2.0 * math.pi * SPEED_OF_LIGHT)

    @property
    def alpha_neper(self) -> float:
        return (self.loss_db_per_km / 4.343) * 1e-3

    def to_c_struct(self) -> CFiberSpan:
        return CFiberSpan(
            length_km=self.length_km,
            loss_db_per_km=self.loss_db_per_km,
            dispersion_ps_nm_km=self.dispersion_ps_nm_km,
            dispersion_slope=self.dispersion_slope,
            pmd_ps_sqrt_km=self.pmd_ps_sqrt_km,
            effective_area_um2=self.effective_area_um2,
            non_linear_index_n2=self.non_linear_index_n2,
            launch_power_dbm=self.launch_power_dbm,
        )

@dataclass
class OpticalAmplifier:
    gain_db: float = 16.0
    noise_figure_db: float = 5.0
    max_output_power_dbm: float = 23.0
    dynamic_gain_tilt: float = 0.0
    ase_enabled: bool = True

    def to_c_struct(self) -> CEdfa:
        return CEdfa(
            gain_db=self.gain_db,
            noise_figure_db=self.noise_figure_db,
            max_output_power_dbm=self.max_output_power_dbm,
            dynamic_gain_tilt=self.dynamic_gain_tilt,
            ase_enabled=self.ase_enabled,
        )

@dataclass
class LightpathMetrics:
    carrier_freq_hz: float
    symbol_rate_baud: float
    modulation: ModulationFormat
    fec_type: FecType
    signal_power_w: float
    ase_noise_power_w: float
    nli_noise_power_w: float
    snr_linear: float
    snr_db: float
    q_factor_db: float
    estimated_ber: float
    fec_margin_db: float
    feasible: bool

    @classmethod
    def from_c_struct(cls, c_val: CLightpathMetrics) -> "LightpathMetrics":
        return cls(
            carrier_freq_hz=c_val.carrier_freq_hz,
            symbol_rate_baud=c_val.symbol_rate_baud,
            modulation=ModulationFormat(c_val.modulation),
            fec_type=FecType(c_val.fec_type),
            signal_power_w=c_val.signal_power_w,
            ase_noise_power_w=c_val.ase_noise_power_w,
            nli_noise_power_w=c_val.nli_noise_power_w,
            snr_linear=c_val.snr_linear,
            snr_db=c_val.snr_db,
            q_factor_db=c_val.q_factor_db,
            estimated_ber=c_val.estimated_ber,
            fec_margin_db=c_val.fec_margin_db,
            feasible=c_val.feasible,
        )

def compute_nli(
    span: FiberSpan,
    center_freq_hz: float = 193.1e12,
    symbol_rate_baud: float = 64e9,
    channel_power_w: float = 1e-3,
    num_channels: int = 80,
    channel_spacing_hz: float = 50e9,
) -> float:
    """Computes Non-Linear Interference (NLI) power in Watts for a fiber span using the GN model."""
    if has_native_lib():
        lib = get_lib()
        c_span = span.to_c_struct()
        out_nli = (CLightpathMetrics._fields_[6][1])(0.0)
        import ctypes
        c_nli = ctypes.c_double(0.0)
        status = lib.etalon_gn_compute_nli(
            ctypes.byref(c_span),
            center_freq_hz,
            symbol_rate_baud,
            channel_power_w,
            num_channels,
            channel_spacing_hz,
            ctypes.byref(c_nli),
        )
        if status == EtalonStatus.OK:
            return float(c_nli.value)

    # Pure Python Analytical GN Model formula
    gamma = span.gamma
    beta2_abs = abs(span.beta2)
    alpha = span.alpha_neper
    b_opt = num_channels * channel_spacing_hz

    # Asinh analytical GN formula
    prefactor = (16.0 / 27.0) * (gamma * gamma * (channel_power_w ** 3)) / (math.pi * beta2_abs * (symbol_rate_baud ** 2))
    arg = (math.pi * math.pi / 2.0) * (beta2_abs / alpha) * (b_opt * b_opt)
    nli_psd = prefactor * math.asinh(arg)
    nli_power = nli_psd * symbol_rate_baud
    return nli_power

def evaluate_lightpath(
    spans: List[FiberSpan],
    amplifiers: List[OpticalAmplifier],
    launch_power_dbm: float = 0.0,
    symbol_rate_baud: float = 64e9,
    modulation: ModulationFormat = ModulationFormat.DP_16QAM,
    fec: FecType = FecType.SOFT_DECISION_15,
    carrier_freq_hz: float = 193.1e12,
) -> LightpathMetrics:
    """Evaluates the generalized OSNR (gOSNR), Q-factor, and reach feasibility for an optical path."""
    span_count = len(spans)
    assert span_count == len(amplifiers), "Number of spans and amplifiers must match"

    if has_native_lib() and span_count > 0:
        import ctypes
        lib = get_lib()
        c_spans = (CFiberSpan * span_count)(*(s.to_c_struct() for s in spans))
        c_amplifiers = (CEdfa * span_count)(*(a.to_c_struct() for a in amplifiers))
        c_metrics = CLightpathMetrics()

        status = lib.etalon_evaluate_lightpath(
            c_spans,
            c_amplifiers,
            span_count,
            launch_power_dbm,
            symbol_rate_baud,
            modulation.value,
            fec.value,
            ctypes.byref(c_metrics),
        )
        if status == EtalonStatus.OK:
            return LightpathMetrics.from_c_struct(c_metrics)

    # High-precision Python fallback calculation
    signal_power_w = (10.0 ** (launch_power_dbm / 10.0)) * 1e-3
    ase_noise_total = 0.0
    nli_noise_total = 0.0

    b_ref = 12.5e9 # 0.1 nm reference bandwidth

    for span, edfa in zip(spans, amplifiers):
        # Accumulated ASE noise per amplifier
        g_linear = 10.0 ** (edfa.gain_db / 10.0)
        nf_linear = 10.0 ** (edfa.noise_figure_db / 10.0)
        p_ase = nf_linear * PLANCK_H * carrier_freq_hz * (g_linear - 1.0) * b_ref
        ase_noise_total += p_ase

        # Accumulated NLI noise per span
        p_nli = compute_nli(span, carrier_freq_hz, symbol_rate_baud, signal_power_w)
        nli_noise_total += p_nli

    total_noise = ase_noise_total + nli_noise_total
    snr_lin = signal_power_w / max(1e-15, total_noise)
    snr_db = 10.0 * math.log10(max(1e-6, snr_lin))

    # Q-factor from SNR
    q_factor = snr_db - 3.01
    q_lin = 10.0 ** (q_factor / 20.0)
    ber = 0.5 * math.erfc(q_lin / math.sqrt(2.0))

    target_snr = modulation.min_osnr_db - fec.net_coding_gain_db
    fec_margin = snr_db - target_snr
    feasible = fec_margin >= 1.5 and ber <= fec.ber_threshold

    return LightpathMetrics(
        carrier_freq_hz=carrier_freq_hz,
        symbol_rate_baud=symbol_rate_baud,
        modulation=modulation,
        fec_type=fec,
        signal_power_w=signal_power_w,
        ase_noise_power_w=ase_noise_total,
        nli_noise_power_w=nli_noise_total,
        snr_linear=snr_lin,
        snr_db=snr_db,
        q_factor_db=q_factor,
        estimated_ber=ber,
        fec_margin_db=fec_margin,
        feasible=feasible,
    )
