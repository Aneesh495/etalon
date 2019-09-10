"""
test_pyetalon.py: Comprehensive test suite for the pyetalon Python bindings and CLI.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import subprocess
import sys
from pathlib import Path

# Add bindings/python to sys.path
REPO_ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(REPO_ROOT / "bindings" / "python"))

from pyetalon.core import (
    EtalonStatus,
    ModulationFormat,
    FecType,
    SignalState,
    ProtectionMode,
    has_native_lib,
)
from pyetalon.gn_model import (
    FiberSpan,
    OpticalAmplifier,
    evaluate_lightpath,
    compute_nli,
)
from pyetalon.otn import (
    OtnFrame,
    compute_bip8,
    rs255_239_encode,
    rs255_239_decode,
)
from pyetalon.protection import (
    ProtectionPair,
    trigger_failover,
    benchmark_failover_latency,
)
from pyetalon.topology import (
    OpticalTopology,
    load_standard_topology,
)

def test_native_library_loaded():
    assert has_native_lib(), "libetalon native library must be compiled and loaded"

def test_bip8_parity():
    # One-hot powers of 2 XOR to 0xFF
    data1 = bytes([0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80])
    assert compute_bip8(data1) == 0xFF

    # Duplicate pairs XOR to 0x00
    data2 = bytes([0xAA, 0x55, 0xAA, 0x55])
    assert compute_bip8(data2) == 0x00

def test_rs255_239_codeword():
    codeword = bytearray(255)
    for i in range(239):
        codeword[i] = (i * 3 + 7) & 0xFF
    rs255_239_encode(codeword)
    assert any(b != 0 for b in codeword[239:255]), "Parity bytes must be populated"

    # Inject 3 byte errors
    codeword[10] ^= 0x55
    codeword[50] ^= 0xAA
    codeword[120] ^= 0x33

    ok, errors_corrected = rs255_239_decode(codeword)
    assert ok, "RS(255, 239) must correct up to 8 symbol errors"
    assert errors_corrected == 3, f"Expected 3 errors corrected, got {errors_corrected}"

def test_otn_frame_fec():
    frame = OtnFrame(frame_index=42)
    payload = b"ETALON_TEST_PAYLOAD_" * 200
    frame.set_payload(payload)
    frame.encode_fec()
    assert frame.fec_encoded

    # Corrupt two bytes in different rows
    frame.raw_data[100] ^= 0x01
    frame.raw_data[5000] ^= 0x02

    ok, errors_corrected = frame.decode_fec()
    assert ok, "16-way interleaved FEC must correct injected errors"
    assert errors_corrected == 2

def test_gn_model_evaluation():
    spans = [FiberSpan(length_km=80.0, loss_db_per_km=0.20) for _ in range(5)]
    amplifiers = [OpticalAmplifier(gain_db=16.0, noise_figure_db=4.5) for _ in range(5)]

    metrics = evaluate_lightpath(
        spans=spans,
        amplifiers=amplifiers,
        launch_power_dbm=0.0,
        symbol_rate_baud=64e9,
        modulation=ModulationFormat.DP_16QAM,
        fec=FecType.SOFT_DECISION_15,
    )

    assert metrics.snr_db > 20.0, f"Expected SNR > 20 dB, got {metrics.snr_db}"
    assert metrics.fec_margin_db > 0.0, "Expected positive FEC operating margin"
    assert metrics.feasible, "5x80km lightpath must be feasible under 16-QAM and 15% SD-FEC"

def test_protection_switching():
    pair = ProtectionPair(service_id=202, primary_path_id=10, backup_path_id=20)
    assert pair.primary_active

    ok, latency_us = trigger_failover(pair, SignalState.LOSS_OF_SIGNAL)
    assert ok
    assert not pair.primary_active
    assert pair.switch_count == 1
    assert latency_us < 50000.0, f"Failover latency must be < 50ms, got {latency_us / 1000.0} ms"

def test_topologies_loading():
    usnet = load_standard_topology("usnet")
    assert usnet.node_count == 24
    assert usnet.link_count == 28
    assert usnet.total_fiber_km > 20000.0

    tokyo = load_standard_topology("tokyo")
    assert tokyo.node_count == 16
    assert tokyo.link_count == 32

def test_cli_execution():
    cli_path = REPO_ROOT / "bin" / "etalon-cli"
    # Test status
    res = subprocess.run([sys.executable, str(cli_path), "status"], capture_output=True, text=True)
    assert res.returncode == 0
    assert "ETALON OPTICAL TRANSPORT NETWORK ENGINE" in res.stdout

    # Test gn-sim
    res = subprocess.run([sys.executable, str(cli_path), "gn-sim", "--spans", "3"], capture_output=True, text=True)
    assert res.returncode == 0
    assert "Generalized OSNR" in res.stdout

    # Test failover-bench
    res = subprocess.run([sys.executable, str(cli_path), "failover-bench", "--iterations", "50"], capture_output=True, text=True)
    assert res.returncode == 0
    assert "PASS (SUB-50MS GUARANTEE MET)" in res.stdout

if __name__ == "__main__":
    test_native_library_loaded()
    print("[PASS] test_native_library_loaded")
    test_bip8_parity()
    print("[PASS] test_bip8_parity")
    test_rs255_239_codeword()
    print("[PASS] test_rs255_239_codeword")
    test_otn_frame_fec()
    print("[PASS] test_otn_frame_fec")
    test_gn_model_evaluation()
    print("[PASS] test_gn_model_evaluation")
    test_protection_switching()
    print("[PASS] test_protection_switching")
    test_topologies_loading()
    print("[PASS] test_topologies_loading")
    test_cli_execution()
    print("[PASS] test_cli_execution")
    print("ALL PYTHON TESTS PASSED.")
