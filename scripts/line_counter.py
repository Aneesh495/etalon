#!/usr/bin/env python3
"""
Etalon Line of Code (LOC) counter and language breakdown auditor.
"""

from pathlib import Path
from collections import defaultdict

EXTENSIONS = {
    ".icl": "Clean (Implementation)",
    ".dcl": "Clean (Definition)",
    ".c": "C99 Source",
    ".h": "C Header",
    ".py": "Python",
    ".md": "Markdown Docs",
    ".sh": "Shell Script",
}

IGNORE_DIRS = {".git", "__pycache__", "build", "dist", ".pytest_cache", "venv", ".venv"}

def count_lines(repo_root: Path):
    counts = defaultdict(lambda: {"files": 0, "lines": 0, "code": 0, "comments": 0, "blank": 0})
    total = {"files": 0, "lines": 0, "code": 0, "comments": 0, "blank": 0}

    for path in sorted(repo_root.rglob("*")):
        if any(ignored in path.parts for ignored in IGNORE_DIRS):
            continue
        if not path.is_file():
            continue
        ext = path.suffix
        if ext not in EXTENSIONS and path.name != "Makefile":
            continue
        
        lang = EXTENSIONS.get(ext, "Makefile")
        try:
            lines = path.read_text(encoding="utf-8").splitlines()
        except (UnicodeDecodeError, PermissionError):
            continue
        
        total_lines = len(lines)
        blank = 0
        comments = 0
        code = 0
        
        for line in lines:
            stripped = line.strip()
            if not stripped:
                blank += 1
            elif stripped.startswith("//") or stripped.startswith("/*") or stripped.startswith("*") or stripped.startswith("#"):
                comments += 1
            else:
                code += 1
                
        counts[lang]["files"] += 1
        counts[lang]["lines"] += total_lines
        counts[lang]["code"] += code
        counts[lang]["comments"] += comments
        counts[lang]["blank"] += blank
        
        total["files"] += 1
        total["lines"] += total_lines
        total["code"] += code
        total["comments"] += comments
        total["blank"] += blank

    clean_total = counts["Clean (Implementation)"]["lines"] + counts["Clean (Definition)"]["lines"]

    print(f"{'Language':<25} | {'Files':<6} | {'Lines':<8} | {'Code':<8} | {'Comment':<8} | {'Blank':<6}")
    print("-" * 75)
    for lang, stat in sorted(counts.items(), key=lambda x: -x[1]["lines"]):
        print(f"{lang:<25} | {stat['files']:<6} | {stat['lines']:<8} | {stat['code']:<8} | {stat['comments']:<8} | {stat['blank']:<6}")
    print("-" * 75)
    print(f"{'TOTAL':<25} | {total['files']:<6} | {total['lines']:<8} | {total['code']:<8} | {total['comments']:<8} | {total['blank']:<6}")
    print(f"\nTotal Clean Lines (dcl + icl): {clean_total}")
    return clean_total, total["lines"]

if __name__ == "__main__":
    repo_root = Path(__file__).resolve().parent.parent
    count_lines(repo_root)
