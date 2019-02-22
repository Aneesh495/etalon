"""
Clean Module Runner and Verification Harness.
Scans and parses all .dcl and .icl Clean modules in the repository,
verifies uniqueness typing invariants, and reports AST statistics.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import sys
from pathlib import Path
from .parser import parse_clean_source
from .uniqueness_checker import UniquenessChecker

def run_verification(clean_src_dir: Path) -> int:
    clean_files = sorted(list(clean_src_dir.rglob("*.dcl")) + list(clean_src_dir.rglob("*.icl")))
    if not clean_files:
        print(f"No Clean files found in {clean_src_dir}")
        return 0

    print("=================================================================")
    print("Concurrent Clean AST and Uniqueness Verification Harness")
    print(f"Scanning: {clean_src_dir}")
    print("=================================================================")

    total_modules = 0
    total_types = 0
    total_records = 0
    total_signatures = 0
    total_functions = 0
    total_violations = 0

    for path in clean_files:
        try:
            content = path.read_text(encoding="utf-8")
            module = parse_clean_source(content)
            total_modules += 1
            total_types += len(module.types)
            total_records += len(module.records)
            total_signatures += len(module.signatures)
            total_functions += sum(len(fdefs) for fdefs in module.functions.values())

            # Check uniqueness types
            checker = UniquenessChecker(module)
            violations = checker.check()
            if violations:
                print(f"[WARN] Uniqueness issues in {path.name}: {violations}")
                total_violations += len(violations)

        except Exception as e:
            print(f"[ERROR] Failed parsing {path.name}: {e}")
            return 1

    print(f"Verified {total_modules} Clean modules across repository.")
    print(f"  - Algebraic Data Types: {total_types}")
    print(f"  - Strict Records:        {total_records}")
    print(f"  - Function Signatures:  {total_signatures}")
    print(f"  - Function Definitions: {total_functions}")
    print(f"  - Uniqueness Violations: {total_violations}")
    print("=================================================================")

    if total_violations == 0:
        print("OK: All Clean modules successfully parsed with valid uniqueness semantics.")
        return 0
    else:
        print(f"FAILED: Found {total_violations} uniqueness typing violation(s).")
        return 1

if __name__ == "__main__":
    src_dir = Path(__file__).resolve().parent.parent.parent / "src" / "clean"
    sys.exit(run_verification(src_dir))
