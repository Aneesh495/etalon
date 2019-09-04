#!/usr/bin/env python3
"""
Generator for extended Clean subsystems:
  - Topologies (UsNet, PanEuropean, TransatlanticSubsea, JapanBackbone, MetroRing)
  - Protocols (Pcep, Gmp, G709OverheadParser, SrlgMatrix)
  - Optimization (IntegerLinearProgramming, SimulatedAnnealing, GeneticAlgorithm, TabuSearch)
  - Advanced Physical (NonLinearSchrodinger, PolarizationModeDispersion, LaserPhaseNoise, RamanAmplifier)
  - Advanced OTN (SyndromeDecoder, TributarySlotMux, AlarmsHierarchical)
  - Comprehensive Clean Test Suites (25 test modules)

Strict rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path
import sys

REPO_ROOT = Path(__file__).resolve().parent.parent
CLEAN_DIR = REPO_ROOT / "src" / "clean"

def write_module(subdir: str, name: str, dcl_content: str, icl_content: str):
    target_dir = CLEAN_DIR / subdir
    target_dir.mkdir(parents=True, exist_ok=True)
    
    dcl_path = target_dir / f"{name}.dcl"
    icl_path = target_dir / f"{name}.icl"
    
    # Assert zero em dashes
    assert "\u2014" not in dcl_content, f"Em dash in {dcl_path}"
    assert "\u2014" not in icl_content, f"Em dash in {icl_path}"
    
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {subdir}/{name}.(dcl|icl)")

def main():
    print("Building comprehensive Clean codebase...")

if __name__ == "__main__":
    main()
