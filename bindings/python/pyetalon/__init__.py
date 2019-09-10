"""
PyEtalon: High-performance Python interface to the Etalon Optical Transport Network Engine.

Provides carrier-grade DWDM physical-layer impairment simulation (Gaussian Noise Model),
sub-50ms protection failover benchmarking, and ITU-T G.709 OTN frame processing.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from .core import EtalonStatus, ModulationFormat, FecType, SignalState, ProtectionMode
from .gn_model import FiberSpan, OpticalAmplifier, LightpathMetrics, evaluate_lightpath, compute_nli
from .otn import OtnFrame, compute_bip8, rs255_239_encode, rs255_239_decode
from .protection import ProtectionPair, trigger_failover, benchmark_failover_latency
from .topology import OpticalTopology, load_standard_topology

__version__ = "1.0.0-carrier-grade"
__author__ = "Aneesh Krishna"

__all__ = [
    "EtalonStatus",
    "ModulationFormat",
    "FecType",
    "SignalState",
    "ProtectionMode",
    "FiberSpan",
    "OpticalAmplifier",
    "LightpathMetrics",
    "evaluate_lightpath",
    "compute_nli",
    "OtnFrame",
    "compute_bip8",
    "rs255_239_encode",
    "rs255_239_decode",
    "ProtectionPair",
    "trigger_failover",
    "benchmark_failover_latency",
    "OpticalTopology",
    "load_standard_topology",
]
