/**
 * etalon.h: Core C99 API for the Etalon Optical Transport Network Engine.
 *
 * Carrier-grade Dense Wavelength Division Multiplexing (DWDM) and
 * Optical Transport Network (OTN, ITU-T G.709) Control Plane and Execution Engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#ifndef ETALON_H
#define ETALON_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ========================================================================= */
/* Physical and Optical Constants                                            */
/* ========================================================================= */

#define ETALON_SPEED_OF_LIGHT          299792458.0       /* m/s in vacuum */
#define ETALON_PLANCK_CONSTANT         6.62607015e-34    /* J*s */
#define ETALON_BOLTZMANN_CONSTANT      1.380649e-23      /* J/K */
#define ETALON_REF_FREQ_HZ             193.1e12          /* 193.1 THz (1552.52 nm) */

/* ITU-T G.694.1 Flexible Grid Boundaries (C-band) */
#define ETALON_CBAND_START_FREQ_HZ     191.325e12        /* 191.325 THz */
#define ETALON_CBAND_END_FREQ_HZ       196.125e12        /* 196.125 THz */
#define ETALON_FLEX_GRID_SLICE_HZ      6.25e9            /* 6.25 GHz slice */
#define ETALON_FLEX_GRID_SLOT_HZ       12.5e9            /* 12.5 GHz slot granularity */
#define ETALON_MAX_SPECTRUM_SLICES     768               /* (196.125 - 191.325) THz / 6.25 GHz */

/* Standard OTN Frame Geometry (ITU-T G.709) */
#define ETALON_OTN_ROWS                4
#define ETALON_OTN_COLS                4080
#define ETALON_OTN_FRAME_SIZE          (ETALON_OTN_ROWS * ETALON_OTN_COLS) /* 16320 bytes */
#define ETALON_OTN_FAS_SIZE            6
#define ETALON_OTN_PAYLOAD_OFFSET      16
#define ETALON_OTN_FEC_OFFSET          3824
#define ETALON_OTN_FEC_PARITY_SIZE     256               /* 4 rows x 64 bytes */

/* ========================================================================= */
/* Enumerations and Types                                                    */
/* ========================================================================= */

typedef enum {
    ETALON_STATUS_OK = 0,
    ETALON_ERROR_INVALID_PARAM = -1,
    ETALON_ERROR_SPECTRUM_BLOCKED = -2,
    ETALON_ERROR_OSNR_INSUFFICIENT = -3,
    ETALON_ERROR_REACH_EXCEEDED = -4,
    ETALON_ERROR_LINK_DOWN = -5,
    ETALON_ERROR_PROTECTION_FAILED = -6,
    ETALON_ERROR_FRAMING_FAULT = -7,
    ETALON_ERROR_FEC_UNCORRECTABLE = -8
} etalon_status_t;

typedef enum {
    ETALON_MOD_DP_BPSK = 0,    /* 1 bit/symbol/pol, 2 bits/symbol total */
    ETALON_MOD_DP_QPSK,        /* 2 bits/symbol/pol, 4 bits/symbol total */
    ETALON_MOD_DP_8QAM,        /* 3 bits/symbol/pol, 6 bits/symbol total */
    ETALON_MOD_DP_16QAM,       /* 4 bits/symbol/pol, 8 bits/symbol total */
    ETALON_MOD_DP_32QAM,       /* 5 bits/symbol/pol, 10 bits/symbol total */
    ETALON_MOD_DP_64QAM        /* 6 bits/symbol/pol, 12 bits/symbol total */
} etalon_modulation_t;

typedef enum {
    ETALON_FEC_NONE = 0,
    ETALON_FEC_HARD_DECISION_7,     /* 7% HD-FEC, BER threshold 3.8e-3 */
    ETALON_FEC_SOFT_DECISION_15,    /* 15% SD-FEC, BER threshold 1.5e-2 */
    ETALON_FEC_SOFT_DECISION_27     /* 27% SD-FEC, BER threshold 2.4e-2 */
} etalon_fec_type_t;

typedef enum {
    ETALON_PORT_TYPE_LINE = 0,
    ETALON_PORT_TYPE_CLIENT,
    ETALON_PORT_TYPE_ADD_DROP,
    ETALON_PORT_TYPE_EXPRESS
} etalon_port_type_t;

typedef enum {
    ETALON_SIGNAL_HEALTHY = 0,
    ETALON_SIGNAL_DEGRADED,
    ETALON_SIGNAL_LOSS_OF_SIGNAL,     /* LOS */
    ETALON_SIGNAL_LOSS_OF_FRAME,      /* LOF */
    ETALON_SIGNAL_ALARM_INDICATION    /* AIS */
} etalon_signal_state_t;

typedef enum {
    ETALON_PROT_UNPROTECTED = 0,
    ETALON_PROT_1_PLUS_1_OCH,        /* 1+1 Optical Channel Dedicated */
    ETALON_PROT_1_FOR_1_SHARED,       /* 1:1 Shared Protection */
    ETALON_PROT_SHARED_MESH_RESTORE   /* Shared Mesh Restoration */
} etalon_protection_mode_t;

/* ========================================================================= */
/* Physical Layer Structures                                                 */
/* ========================================================================= */

typedef struct {
    double length_km;                 /* Fiber span length in km */
    double loss_db_per_km;            /* Attenuation alpha (e.g. 0.20 dB/km) */
    double dispersion_ps_nm_km;       /* Chromatic dispersion D (e.g. 17.0 ps/nm/km) */
    double dispersion_slope;          /* Dispersion slope S (ps/nm^2/km) */
    double pmd_ps_sqrt_km;            /* Polarization mode dispersion coefficient */
    double effective_area_um2;        /* Core effective area A_eff (um^2) */
    double non_linear_index_n2;       /* Kerr non-linear refractive index (m^2/W) */
    double launch_power_dbm;          /* Optical channel launch power in dBm */
} etalon_fiber_span_t;

typedef struct {
    double gain_db;                   /* Operational gain in dB */
    double noise_figure_db;           /* Noise figure NF in dB (e.g. 4.5 dB) */
    double max_output_power_dbm;      /* Saturated output power in dBm */
    double dynamic_gain_tilt;         /* Gain spectral tilt coefficient */
    bool ase_enabled;                 /* Whether ASE noise generation is active */
} etalon_edfa_t;

typedef struct {
    uint32_t node_id;
    char name[64];
    uint32_t degree;                  /* Number of line degrees / express directions */
    uint32_t add_drop_ports;          /* Number of transponder client/mux ports */
    double wss_insertion_loss_db;     /* Insertion loss across WSS pass */
    bool colorless;
    bool directionless;
    bool contentionless;
} etalon_roadm_node_t;

/* ========================================================================= */
/* Impairment and Signal Quality Metrics                                     */
/* ========================================================================= */

typedef struct {
    double carrier_freq_hz;           /* Center optical frequency */
    double symbol_rate_baud;          /* Baud rate (e.g. 64e9 = 64 GBaud) */
    etalon_modulation_t modulation;   /* Coherent modulation scheme */
    etalon_fec_type_t fec_type;       /* Forward error correction code */
    double signal_power_w;            /* Signal optical power (Watts) */
    double ase_noise_power_w;         /* Accumulated ASE noise in 0.1nm bandwidth */
    double nli_noise_power_w;         /* Non-linear interference noise (GN model) */
    double snr_linear;                /* Linear generalized SNR */
    double snr_db;                    /* Generalized OSNR (gOSNR) in dB */
    double q_factor_db;               /* Q-factor in dB */
    double estimated_ber;             /* Predicted pre-FEC Bit Error Rate */
    double fec_margin_db;             /* Operating margin above FEC limit */
    bool feasible;                    /* Physical reach validation status */
} etalon_lightpath_metrics_t;

/* ========================================================================= */
/* OTN Frame and Overhead Structures (ITU-T G.709)                           */
/* ========================================================================= */

typedef struct {
    uint8_t fas[6];                   /* Frame Alignment Signal: F6 F6 F6 28 28 28 */
    uint8_t mfas;                     /* Multi-frame Alignment Signal */
    uint8_t sm_tti[64];               /* Section Monitoring Trail Trace Identifier */
    uint8_t sm_bip8;                  /* Section Monitoring BIP-8 parity */
    uint8_t sm_bei_bdi;               /* Backward Error and Defect Indication */
    uint8_t pm_tti[64];               /* Path Monitoring Trail Trace Identifier */
    uint8_t pm_bip8;                  /* Path Monitoring BIP-8 parity */
    uint8_t pm_bei_bdi_stat;          /* Path Monitoring Status / BDI / BEI */
} etalon_otn_overhead_t;

typedef struct {
    uint8_t raw_data[ETALON_OTN_FRAME_SIZE];
    etalon_otn_overhead_t parsed_overhead;
    uint32_t frame_index;
    bool fec_encoded;
    uint32_t corrected_bit_errors;
    uint32_t uncorrectable_blocks;
} etalon_otn_frame_t;

/* ========================================================================= */
/* Cross-Connect and Protection Switching                                    */
/* ========================================================================= */

typedef struct {
    uint32_t connection_id;
    uint32_t ingress_port;
    uint32_t egress_port;
    uint16_t start_slice;             /* Start 6.25 GHz spectrum slice index */
    uint16_t slice_count;             /* Number of contiguous frequency slices */
    double attenuation_db;            /* Channel attenuation attenuation setting */
    bool active;
} etalon_cross_connect_entry_t;

typedef struct {
    uint32_t service_id;
    uint32_t primary_path_id;
    uint32_t backup_path_id;
    etalon_protection_mode_t mode;
    bool primary_active;
    double failover_latency_us;       /* Protection switchover time in microseconds */
    uint64_t switch_count;
} etalon_protection_pair_t;

/* ========================================================================= */
/* C API Function Declarations                                               */
/* ========================================================================= */

/* Physical Impairment Engine */
etalon_status_t etalon_gn_compute_nli(
    const etalon_fiber_span_t* span,
    double center_freq_hz,
    double symbol_rate_baud,
    double channel_power_w,
    uint32_t num_channels,
    double channel_spacing_hz,
    double* out_nli_w);

etalon_status_t etalon_evaluate_lightpath(
    const etalon_fiber_span_t* spans,
    const etalon_edfa_t* amplifiers,
    uint32_t span_count,
    double launch_power_dbm,
    double symbol_rate_baud,
    etalon_modulation_t mod,
    etalon_fec_type_t fec,
    etalon_lightpath_metrics_t* out_metrics);

/* OTN Framing and RS(255, 239) Engine */
etalon_status_t etalon_otn_init_frame(etalon_otn_frame_t* frame);
etalon_status_t etalon_otn_set_payload(etalon_otn_frame_t* frame, const uint8_t* payload, size_t len);
etalon_status_t etalon_otn_compute_bip8(const uint8_t* block, size_t len, uint8_t* out_bip8);
etalon_status_t etalon_rs255_239_encode(uint8_t* codeword_255);
etalon_status_t etalon_rs255_239_decode(uint8_t* codeword_255, uint32_t* out_errors_corrected);
etalon_status_t etalon_otn_encode_fec(etalon_otn_frame_t* frame);
etalon_status_t etalon_otn_decode_fec(etalon_otn_frame_t* frame);

/* Cross-Connect Switching and Protection */
etalon_status_t etalon_xc_switch_fast(
    etalon_cross_connect_entry_t* matrix,
    uint32_t matrix_size,
    uint32_t connection_id,
    uint32_t new_egress_port,
    uint64_t* out_switch_duration_ns);

etalon_status_t etalon_protection_trigger_failover(
    etalon_protection_pair_t* pair,
    etalon_signal_state_t defect,
    uint64_t* out_elapsed_ns);

/* Version and Metadata */
const char* etalon_version(void);

#ifdef __cplusplus
}
#endif

#endif /* ETALON_H */
