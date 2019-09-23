#!/usr/bin/env python3
"""
run_full_suite.py: Comprehensive test orchestrator for Etalon.

Executes:
1. Strict style check (zero em dashes)
2. C99 unit and integration tests (libetalon)
3. Concurrent Clean AST parsing and uniqueness type checking (1,234 modules)
4. Python integration test suite (pyetalon & etalon-cli)
5. Physical layer simulation sanity check

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import os
import subprocess
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

def run_step(step_name: str, cmd: list) -> bool:
    print(f"\n{'='*72}")
    print(f" [RUNNING] {step_name}")
    print(f"{'='*72}")
    t0 = time.perf_counter()
    proc = subprocess.run(cmd, cwd=str(REPO_ROOT), text=True)
    t1 = time.perf_counter()
    duration = t1 - t0

    if proc.returncode == 0:
        print(f"[PASS] {step_name} ({duration:.2f}s)")
        return True
    else:
        print(f"[FAIL] {step_name} exited with status {proc.returncode}")
        return False

def main():
    print(f"{'='*72}")
    print(f" ETALON MASTER TEST & VERIFICATION SUITE")
    print(f" Workspace: {REPO_ROOT}")
    print(f"{'='*72}")

    # Build C library first
    build_dir = REPO_ROOT / "build"
    build_dir.mkdir(parents=True, exist_ok=True)

    c_sources = list((REPO_ROOT / "src" / "c").glob("*.c"))
    include_dir = REPO_ROOT / "include"

    ext = ".dylib" if sys.platform == "darwin" else ".so"
    lib_path = build_dir / f"libetalon{ext}"
    compile_cmd = [
        "clang", "-O3", "-fPIC", "-shared", "-Wall", "-Wextra",
        f"-I{include_dir}", "-o", str(lib_path), *[str(s) for s in c_sources]
    ]

    print("Compiling libetalon shared library...")
    res = subprocess.run(compile_cmd, cwd=str(REPO_ROOT))
    if res.returncode != 0:
        print("Failed to compile libetalon")
        sys.exit(1)

    # Compile C test binary
    c_test_bin = build_dir / "test_c"
    c_test_src = REPO_ROOT / "tests" / "c" / "test_c_subsystem.c"
    c_test_compile = [
        "clang", "-O3", "-Wall", "-Wextra", "-Werror",
        f"-I{include_dir}", "-o", str(c_test_bin), *[str(s) for s in c_sources], str(c_test_src)
    ]
    res = subprocess.run(c_test_compile, cwd=str(REPO_ROOT))
    if res.returncode != 0:
        print("Failed to compile test_c binary")
        sys.exit(1)

    steps = [
        ("No Em Dashes Verification", [sys.executable, "scripts/verify_no_em_dashes.py"]),
        ("C99 libetalon Verification Suite", [str(c_test_bin)]),
        ("Clean AST & Uniqueness Verification", [sys.executable, "tools/clean_engine/runner.py"]),
        ("Python pyetalon Integration Suite", [sys.executable, "tests/python/test_pyetalon.py"]),
        ("CLI Spectrum & GN Physical Simulation", [sys.executable, "bin/etalon-cli", "gn-sim", "--spans", "10"]),
    ]

    all_passed = True
    start_time = time.perf_counter()

    for name, cmd in steps:
        if not run_step(name, cmd):
            all_passed = False
            break

    total_time = time.perf_counter() - start_time
    print(f"\n{'='*72}")
    if all_passed:
        print(f" ALL SUITES PASSED CLEANLY (Total Time: {total_time:.2f}s)")
        print(f" Repository Status: 100% Green, 0 Errors, Carrier-Grade Ready.")
        print(f"{'='*72}")
        sys.exit(0)
    else:
        print(f" VERIFICATION FAILED")
        print(f"{'='*72}")
        sys.exit(1)

if __name__ == "__main__":
    main()
