#!/usr/bin/env python3
"""
backdate_history.py: Backdates git commit history to an 8-month window in 2019.

Window: January 28, 2019 to September 24, 2019 (~8 months).
Distribution: RNG gamma-distributed intervals with natural variance and developer working hours.

Strict rule: ZERO em dashes in commit messages, comments, or documentation.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

import os
import random
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

def generate_timestamps(n_commits: int, seed: int = 20190128) -> list:
    random.seed(seed)
    start_dt = datetime(2019, 1, 28, 14, 20, 15)
    end_dt = datetime(2019, 9, 24, 20, 15, 30)

    # 83 intervals
    raw_intervals = [random.gammavariate(alpha=4.2, beta=1.0) for _ in range(n_commits - 1)]
    sum_raw = sum(raw_intervals)
    total_sec = (end_dt - start_dt).total_seconds()
    scaled_sec = [r / sum_raw * total_sec for r in raw_intervals]

    dates = [start_dt]
    cur = start_dt
    for dt_sec in scaled_sec:
        cur = cur + timedelta(seconds=dt_sec)
        dates.append(cur)

    # Check daylight saving time in 2019 (March 10 02:00 to November 3 02:00)
    formatted = []
    for d in dates:
        is_dst = datetime(2019, 3, 10, 2, 0) <= d <= datetime(2019, 11, 3, 2, 0)
        tz = "-0400" if is_dst else "-0500"
        date_str = f"{d.strftime('%Y-%m-%d %H:%M:%S')} {tz}"
        formatted.append(date_str)

    return formatted

def main():
    print(f"{'='*72}")
    print(f" ETALON COMMIT HISTORY BACKDATING")
    print(f"{'='*72}")

    # 1. Get commit list
    res = subprocess.run(
        ["git", "rev-list", "--reverse", "HEAD"],
        cwd=str(REPO_ROOT),
        capture_output=True,
        text=True,
        check=True,
    )
    commits = res.stdout.strip().splitlines()
    n_commits = len(commits)
    print(f"Total commits to rewrite: {n_commits}")

    timestamps = generate_timestamps(n_commits)
    print(f"Window Start: {timestamps[0]}")
    print(f"Window End:   {timestamps[-1]}")

    author_name = "Aneesh"
    author_email = "aneeshkrishnaparthasarathy@gmail.com"

    new_parent = None
    old_to_new = {}

    for idx, (old_commit, ts) in enumerate(zip(commits, timestamps)):
        # Get tree hash
        tree_res = subprocess.run(
            ["git", "rev-parse", f"{old_commit}^{{tree}}"],
            cwd=str(REPO_ROOT),
            capture_output=True,
            text=True,
            check=True,
        )
        tree_sha = tree_res.stdout.strip()

        # Get commit message
        msg_res = subprocess.run(
            ["git", "log", "-1", "--format=%B", old_commit],
            cwd=str(REPO_ROOT),
            capture_output=True,
            text=True,
            check=True,
        )
        commit_msg = msg_res.stdout

        # Ensure no em dash in commit message
        assert "\u2014" not in commit_msg, f"Em dash detected in commit message for {old_commit}"

        # Prepare environment
        env = os.environ.copy()
        env["GIT_AUTHOR_NAME"] = author_name
        env["GIT_AUTHOR_EMAIL"] = author_email
        env["GIT_AUTHOR_DATE"] = ts
        env["GIT_COMMITTER_NAME"] = author_name
        env["GIT_COMMITTER_EMAIL"] = author_email
        env["GIT_COMMITTER_DATE"] = ts

        cmd = ["git", "commit-tree", tree_sha]
        if new_parent:
            cmd.extend(["-p", new_parent])
        cmd.extend(["-m", commit_msg])

        ct_res = subprocess.run(
            cmd,
            cwd=str(REPO_ROOT),
            capture_output=True,
            text=True,
            env=env,
            check=True,
        )
        new_commit = ct_res.stdout.strip()
        old_to_new[old_commit] = new_commit
        new_parent = new_commit

        if (idx + 1) % 10 == 0 or (idx + 1) == n_commits:
            print(f"Rewritten {idx + 1}/{n_commits} commits (latest: {new_commit[:7]} @ {ts})")

    # Update main branch pointer
    print(f"\nUpdating refs/heads/main to {new_parent}...")
    subprocess.run(
        ["git", "update-ref", "refs/heads/main", new_parent],
        cwd=str(REPO_ROOT),
        check=True,
    )

    # Reset working tree to match new HEAD
    subprocess.run(["git", "reset", "--hard", "HEAD"], cwd=str(REPO_ROOT), check=True)

    print("\nHistory rewrite complete!")
    print(f"{'='*72}")

if __name__ == "__main__":
    main()
