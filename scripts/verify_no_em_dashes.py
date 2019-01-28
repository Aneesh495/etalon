#!/usr/bin/env python3
"""
Verification script to ensure NO em dashes (\u2014) exist in comments, docs, or code.
Rule: DO NOT use em dashes in comments or docs.
"""

import sys
from pathlib import Path

FORBIDDEN_CHARS = [
    ("\u2014", "EM DASH (\\u2014)"),
]

def scan_repo(root_dir: Path) -> int:
    violations = 0
    repo_files = []
    
    # Ignore git internal files and build artifacts
    ignore_dirs = {".git", "__pycache__", "build", "dist", ".pytest_cache", "venv", ".venv"}
    
    for path in root_dir.rglob("*"):
        if any(ignored in path.parts for ignored in ignore_dirs):
            continue
        if path.is_file():
            # Check text files
            try:
                content = path.read_text(encoding="utf-8")
            except (UnicodeDecodeError, PermissionError):
                continue
            
            for line_idx, line in enumerate(content.splitlines(), start=1):
                for char, desc in FORBIDDEN_CHARS:
                    if char in line:
                        print(f"VIOLATION: {desc} found at {path.relative_to(root_dir)}:{line_idx}")
                        print(f"  Line: {line.strip()}")
                        violations += 1
                        
    if violations == 0:
        print("OK: Zero em dashes detected across repository.")
        return 0
    else:
        print(f"FAILED: Found {violations} em dash violation(s).")
        return 1

if __name__ == "__main__":
    repo_root = Path(__file__).resolve().parent.parent
    sys.exit(scan_repo(repo_root))
