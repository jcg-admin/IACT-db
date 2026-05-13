#!/usr/bin/env python3
"""
check-control-limits.py — Detect Western Electric Rules violations in process data.

Usage:
    python check-control-limits.py <csv_file> [column]

Arguments:
    csv_file   Path to CSV file with sequential measurement data
    column     Column name (default: first numeric column)

Western Electric Rules implemented (all 8):
    Rule 1: 1 point beyond 3-sigma
    Rule 2: 2 of 3 consecutive points beyond 2-sigma (same side)
    Rule 3: 4 of 5 consecutive points beyond 1-sigma (same side)
    Rule 4: 8 consecutive points on same side of centerline
    Rule 5: 6 consecutive points trending (all increasing or decreasing)
    Rule 6: 15 consecutive points within 1-sigma (stratification)
    Rule 7: 14 consecutive points alternating up-down (mixture)
    Rule 8: 8 consecutive points beyond 1-sigma (both sides — bimodal)

Output:
    Control chart statistics and list of violations with reaction guidance.
"""

import sys
import csv
import math
import argparse
from dataclasses import dataclass


@dataclass
class Violation:
    rule: int
    description: str
    indices: list[int]
    reaction: str


def read_csv_column(filepath: str, column: str | None) -> list[float]:
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        sys.exit("ERROR: CSV file is empty or has no data rows.")

    fieldnames = reader.fieldnames or []

    if column is None:
        for name in fieldnames:
            try:
                float(rows[0][name])
                column = name
                break
            except (ValueError, TypeError):
                continue
        if column is None:
            sys.exit("ERROR: No numeric column found. Specify column name explicitly.")

    if column not in fieldnames:
        sys.exit(f"ERROR: Column '{column}' not found. Available: {', '.join(fieldnames)}")

    values = []
    for i, row in enumerate(rows, start=2):
        raw = row.get(column, "").strip()
        if raw == "":
            continue
        try:
            values.append(float(raw))
        except ValueError:
            print(f"WARNING: Row {i} — skipping non-numeric value '{raw}'", file=sys.stderr)

    if len(values) < 8:
        sys.exit("ERROR: Need at least 8 data points to apply Western Electric Rules.")

    return values


def compute_stats(data: list[float]) -> tuple[float, float]:
    n = len(data)
    mu = sum(data) / n
    sigma = math.sqrt(sum((x - mu) ** 2 for x in data) / (n - 1))
    return mu, sigma


def check_rules(data: list[float], mu: float, sigma: float) -> list[Violation]:
    violations: list[Violation] = []
    n = len(data)
    z = [(x - mu) / sigma for x in data]  # z-scores

    # Rule 1: 1 point beyond ±3σ
    for i in range(n):
        if abs(z[i]) > 3:
            violations.append(Violation(
                rule=1,
                description="1 point beyond ±3σ",
                indices=[i],
                reaction="Stop process immediately. Investigate special cause. Do not restart until root cause identified.",
            ))

    # Rule 2: 2 of 3 consecutive points beyond ±2σ (same side)
    for i in range(n - 2):
        window = z[i:i + 3]
        pos = sum(1 for z_ in window if z_ > 2)
        neg = sum(1 for z_ in window if z_ < -2)
        if pos >= 2:
            violations.append(Violation(
                rule=2,
                description="2 of 3 consecutive points beyond +2σ",
                indices=list(range(i, i + 3)),
                reaction="Investigate upward shift in process mean. Check for material or method change.",
            ))
        if neg >= 2:
            violations.append(Violation(
                rule=2,
                description="2 of 3 consecutive points beyond -2σ",
                indices=list(range(i, i + 3)),
                reaction="Investigate downward shift in process mean. Check for equipment or environment change.",
            ))

    # Rule 3: 4 of 5 consecutive points beyond ±1σ (same side)
    for i in range(n - 4):
        window = z[i:i + 5]
        pos = sum(1 for z_ in window if z_ > 1)
        neg = sum(1 for z_ in window if z_ < -1)
        if pos >= 4:
            violations.append(Violation(
                rule=3,
                description="4 of 5 consecutive points beyond +1σ",
                indices=list(range(i, i + 5)),
                reaction="Process mean has likely shifted upward. Verify measurement system and process settings.",
            ))
        if neg >= 4:
            violations.append(Violation(
                rule=3,
                description="4 of 5 consecutive points beyond -1σ",
                indices=list(range(i, i + 5)),
                reaction="Process mean has likely shifted downward. Verify measurement system and process settings.",
            ))

    # Rule 4: 8 consecutive points on same side of centerline
    for i in range(n - 7):
        window = z[i:i + 8]
        if all(z_ > 0 for z_ in window):
            violations.append(Violation(
                rule=4,
                description="8 consecutive points above centerline",
                indices=list(range(i, i + 8)),
                reaction="Sustained upward shift. Investigate process change or equipment drift.",
            ))
        if all(z_ < 0 for z_ in window):
            violations.append(Violation(
                rule=4,
                description="8 consecutive points below centerline",
                indices=list(range(i, i + 8)),
                reaction="Sustained downward shift. Investigate process change or equipment drift.",
            ))

    # Rule 5: 6 consecutive points all increasing or all decreasing (trend)
    for i in range(n - 5):
        window = data[i:i + 6]
        if all(window[j] < window[j + 1] for j in range(5)):
            violations.append(Violation(
                rule=5,
                description="6 consecutive points trending upward",
                indices=list(range(i, i + 6)),
                reaction="Tool wear or process drift upward. Schedule maintenance. Check raw material lot.",
            ))
        if all(window[j] > window[j + 1] for j in range(5)):
            violations.append(Violation(
                rule=5,
                description="6 consecutive points trending downward",
                indices=list(range(i, i + 6)),
                reaction="Process drifting downward. Check consumables, temperature, or operator fatigue.",
            ))

    # Rule 6: 15 consecutive points within ±1σ (stratification — suspiciously tight)
    for i in range(n - 14):
        window = z[i:i + 15]
        if all(abs(z_) < 1 for z_ in window):
            violations.append(Violation(
                rule=6,
                description="15 consecutive points within ±1σ (stratification)",
                indices=list(range(i, i + 15)),
                reaction="Data may be stratified (mixing subgroups). Review sampling strategy. Check if subgroups are homogeneous.",
            ))

    # Rule 7: 14 consecutive points alternating up-down (mixture)
    for i in range(n - 13):
        window = data[i:i + 14]
        alternating = all(
            (window[j] > window[j - 1]) != (window[j + 1] > window[j])
            for j in range(1, 13)
        )
        if alternating:
            violations.append(Violation(
                rule=7,
                description="14 consecutive points alternating up-down (mixture)",
                indices=list(range(i, i + 14)),
                reaction="Two different populations mixed in data. Review subgroup formation or measurement sources.",
            ))

    # Rule 8: 8 consecutive points beyond ±1σ (no points near centerline — bimodal)
    for i in range(n - 7):
        window = z[i:i + 8]
        if all(abs(z_) > 1 for z_ in window):
            violations.append(Violation(
                rule=8,
                description="8 consecutive points beyond ±1σ on either side",
                indices=list(range(i, i + 8)),
                reaction="Bimodal distribution suspected. Data from two different processes or operators mixed.",
            ))

    return violations


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Detect Western Electric Rules violations in process data.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("csv_file", help="Path to CSV file with sequential measurements")
    parser.add_argument("column", nargs="?", default=None, help="Column name (default: first numeric)")
    args = parser.parse_args()

    data = read_csv_column(args.csv_file, args.column)
    mu, sigma = compute_stats(data)

    print(f"\n{'='*60}")
    print(f"  Western Electric Rules — Control Chart Analysis")
    print(f"{'='*60}")
    print(f"  n            = {len(data)}")
    print(f"  Mean (CL)    = {mu:.6f}")
    print(f"  StdDev       = {sigma:.6f}")
    print(f"  UCL (+3σ)    = {mu + 3*sigma:.6f}")
    print(f"  LCL (-3σ)    = {mu - 3*sigma:.6f}")
    print()

    violations = check_rules(data, mu, sigma)

    if not violations:
        print("  ✅ No Western Electric Rules violations detected.")
        print("  Process appears to be in statistical control.")
    else:
        print(f"  ⚠️  {len(violations)} violation(s) detected:\n")
        seen = set()
        for v in violations:
            key = (v.rule, tuple(v.indices))
            if key in seen:
                continue
            seen.add(key)
            idx_display = [i + 1 for i in v.indices]  # 1-based for display
            print(f"  Rule {v.rule}: {v.description}")
            print(f"    Points (1-based): {idx_display}")
            print(f"    Reaction: {v.reaction}")
            print()

    print(f"{'='*60}\n")


if __name__ == "__main__":
    main()
