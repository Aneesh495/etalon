"""
core.py: CFFI/ctypes bindings and enumeration mappings for libetalon.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import ctypes
import os
import platform
import sys
from enum import IntEnum
from pathlib import Path

# Enumerations matching include/etalon.h
class EtalonStatus(IntEnum):
    OK = 0
    INVALID_PARAM = -1
    SPECTRUM_BLOCKED = -2
    OSNR_INSUFFICIENT = -3
    REACH_EXCEEDED = -4
    LINK_DOWN = -5
    PROTECTION_FAILED = -6
    FRAMING_FAULT = -7
    FEC_UNCORRECTABLE = -8

class ModulationFormat(IntEnum):
    DP_BPSK = 0
    DP_QPSK = 1
    DP_8QAM = 2
    DP_16QAM = 3
    DP_32QAM = 4
    DP_64QAM = 5

    @property
    def bits_per_symbol(self) -> int:
        return [2, 4, 6, 8, 10, 12][self.value]

    @property
    def min_osnr_db(self) -> float:
        return [7.0, 10.5, 14.5, 18.0, 22.0, 26.0][self.value]

class FecType(IntEnum):
    NONE = 0
    HARD_DECISION_7 = 1
    SOFT_DECISION_15 = 2
    SOFT_DECISION_27 = 3

    @property
    def overhead_percent(self) -> float:
        return [0.0, 7.0, 15.0, 27.0][self.value]

    @property
    def net_coding_gain_db(self) -> float:
        return [0.0, 6.2, 9.5, 11.8][self.value]

    @property
    def ber_threshold(self) -> float:
        return [1e-12, 3.8e-3, 1.5e-2, 2.4e-2][self.value]

class SignalState(IntEnum):
    HEALTHY = 0
    DEGRADED = 1
    LOSS_OF_SIGNAL = 2
    LOSS_OF_FRAME = 3
    ALARM_INDICATION = 4

class ProtectionMode(IntEnum):
    UNPROTECTED = 0
    PROT_1_PLUS_1_OCH = 1
    PROT_1_FOR_1_SHARED = 2
    SHARED_MESH_RESTORE = 3

# C structures matching include/etalon.h
class CFiberSpan(ctypes.Structure):
    _fields_ = [
        ("length_km", ctypes.c_double),
        ("loss_db_per_km", ctypes.c_double),
        ("dispersion_ps_nm_km", ctypes.c_double),
        ("dispersion_slope", ctypes.c_double),
        ("pmd_ps_sqrt_km", ctypes.c_double),
        ("effective_area_um2", ctypes.c_double),
        ("non_linear_index_n2", ctypes.c_double),
        ("launch_power_dbm", ctypes.c_double),
    ]

class CEdfa(ctypes.Structure):
    _fields_ = [
        ("gain_db", ctypes.c_double),
        ("noise_figure_db", ctypes.c_double),
        ("max_output_power_dbm", ctypes.c_double),
        ("dynamic_gain_tilt", ctypes.c_double),
        ("ase_enabled", ctypes.c_bool),
    ]

class CLightpathMetrics(ctypes.Structure):
    _fields_ = [
        ("carrier_freq_hz", ctypes.c_double),
        ("symbol_rate_baud", ctypes.c_double),
        ("modulation", ctypes.c_int),
        ("fec_type", ctypes.c_int),
        ("signal_power_w", ctypes.c_double),
        ("ase_noise_power_w", ctypes.c_double),
        ("nli_noise_power_w", ctypes.c_double),
        ("snr_linear", ctypes.c_double),
        ("snr_db", ctypes.c_double),
        ("q_factor_db", ctypes.c_double),
        ("estimated_ber", ctypes.c_double),
        ("fec_margin_db", ctypes.c_double),
        ("feasible", ctypes.c_bool),
    ]

class COtnOverhead(ctypes.Structure):
    _fields_ = [
        ("fas", ctypes.c_uint8 * 6),
        ("mfas", ctypes.c_uint8),
        ("sm_tti", ctypes.c_uint8 * 64),
        ("sm_bip8", ctypes.c_uint8),
        ("sm_bei_bdi", ctypes.c_uint8),
        ("pm_tti", ctypes.c_uint8 * 64),
        ("pm_bip8", ctypes.c_uint8),
        ("pm_bei_bdi_stat", ctypes.c_uint8),
    ]

class COtnFrame(ctypes.Structure):
    _fields_ = [
        ("raw_data", ctypes.c_uint8 * 16320),
        ("parsed_overhead", COtnOverhead),
        ("frame_index", ctypes.c_uint32),
        ("fec_encoded", ctypes.c_bool),
        ("corrected_bit_errors", ctypes.c_uint32),
        ("uncorrectable_blocks", ctypes.c_uint32),
    ]

class CProtectionPair(ctypes.Structure):
    _fields_ = [
        ("service_id", ctypes.c_uint32),
        ("primary_path_id", ctypes.c_uint32),
        ("backup_path_id", ctypes.c_uint32),
        ("mode", ctypes.c_int),
        ("primary_active", ctypes.c_bool),
        ("failover_latency_us", ctypes.c_double),
        ("switch_count", ctypes.c_uint64),
    ]

# Dynamic library loader
def _find_libetalon():
    search_paths = [
        Path(__file__).resolve().parent.parent.parent.parent / "build",
        Path(__file__).resolve().parent.parent.parent / "build",
        Path(__file__).resolve().parent / "lib",
        Path("/usr/local/lib"),
        Path("/opt/homebrew/lib"),
    ]

    ext = ".dylib" if platform.system() == "Darwin" else ".so"
    lib_name = f"libetalon{ext}"

    for p in search_paths:
        candidate = p / lib_name
        if candidate.exists():
            return str(candidate)

    return None

_LIB_PATH = _find_libetalon()
_LIB = None

if _LIB_PATH:
    try:
        _LIB = ctypes.CDLL(_LIB_PATH)
        # Function prototypes
        _LIB.etalon_version.restype = ctypes.c_char_p

        _LIB.etalon_gn_compute_nli.argtypes = [
            ctypes.POINTER(CFiberSpan),
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_uint32,
            ctypes.c_double,
            ctypes.POINTER(ctypes.c_double),
        ]
        _LIB.etalon_gn_compute_nli.restype = ctypes.c_int

        _LIB.etalon_evaluate_lightpath.argtypes = [
            ctypes.POINTER(CFiberSpan),
            ctypes.POINTER(CEdfa),
            ctypes.c_uint32,
            ctypes.c_double,
            ctypes.c_double,
            ctypes.c_int,
            ctypes.c_int,
            ctypes.POINTER(CLightpathMetrics),
        ]
        _LIB.etalon_evaluate_lightpath.restype = ctypes.c_int

        _LIB.etalon_otn_init_frame.argtypes = [ctypes.POINTER(COtnFrame)]
        _LIB.etalon_otn_init_frame.restype = ctypes.c_int

        _LIB.etalon_otn_set_payload.argtypes = [
            ctypes.POINTER(COtnFrame),
            ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t,
        ]
        _LIB.etalon_otn_set_payload.restype = ctypes.c_int

        _LIB.etalon_otn_compute_bip8.argtypes = [
            ctypes.POINTER(ctypes.c_uint8),
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_uint8),
        ]
        _LIB.etalon_otn_compute_bip8.restype = ctypes.c_int

        _LIB.etalon_rs255_239_encode.argtypes = [ctypes.POINTER(ctypes.c_uint8)]
        _LIB.etalon_rs255_239_encode.restype = ctypes.c_int

        _LIB.etalon_rs255_239_decode.argtypes = [
            ctypes.POINTER(ctypes.c_uint8),
            ctypes.POINTER(ctypes.c_uint32),
        ]
        _LIB.etalon_rs255_239_decode.restype = ctypes.c_int

        _LIB.etalon_otn_encode_fec.argtypes = [ctypes.POINTER(COtnFrame)]
        _LIB.etalon_otn_encode_fec.restype = ctypes.c_int

        _LIB.etalon_otn_decode_fec.argtypes = [ctypes.POINTER(COtnFrame)]
        _LIB.etalon_otn_decode_fec.restype = ctypes.c_int

        _LIB.etalon_protection_trigger_failover.argtypes = [
            ctypes.POINTER(CProtectionPair),
            ctypes.c_int,
            ctypes.POINTER(ctypes.c_uint64),
        ]
        _LIB.etalon_protection_trigger_failover.restype = ctypes.c_int

    except Exception as exc:
        _LIB = None

def get_lib():
    """Returns the loaded C shared library instance, or None if pure Python fallback is active."""
    return _LIB

def has_native_lib() -> bool:
    """Returns True if the native C99 libetalon shared library is available."""
    return _LIB is not None
