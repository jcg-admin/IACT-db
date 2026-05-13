#!/usr/bin/env python3
"""
calculate-capability.py — Compute Cp/Cpk process capability from CSV data.

Usage:
    python calculate-capability.py <csv_file> [column] [--lsl LSL] [--usl USL]

Arguments:
    csv_file   Path to CSV file with measurement data
    column     Column name containing measurements (default: first numeric column)
    --lsl      Lower Specification Limit
    --usl      Upper Specification Limit

Examples:
    python calculate-capability.py measurements.csv --lsl 9.5 --usl 10.5
    python calculate-capability.py data.csv diameter --lsl 49.8 --usl 50.2

Output:
    Mean, StdDev, Cp, Cpk, Pp, Ppk and interpretation per DMAIC thresholds.
"""

import sys
import csv
import math
import argparse


def read_csv_column(filepath: str, column: str | None) -> list[float]:
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        sys.exit("ERROR: CSV file is empty or has no data rows.")

    fieldnames = reader.fieldnames or []

    if column is None:
        # Auto-select first numeric-looking column
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
        raw = row[column].strip()
        if raw == "":
            continue
        try:
            values.append(float(raw))
        except ValueError:
            print(f"WARNING: Row {i} — skipping non-numeric value '{raw}'", file=sys.stderr)

    if len(values) < 2:
        sys.exit("ERROR: Need at least 2 numeric values to compute capability.")

    return values


def mean(data: list[float]) -> float:
    return sum(data) / len(data)


def stdev_sample(data: list[float], mu: float) -> float:
    variance = sum((x - mu) ** 2 for x in data) / (len(data) - 1)
    return math.sqrt(variance)


def interpret_cpk(cpk: float) -> str:
    if cpk >= 1.67:
        return "Excellent (Six Sigma capable)"
    elif cpk >= 1.33:
        return "Good (capable — meets spec)"
    elif cpk >= 1.00:
        return "Marginal (barely capable — monitor closely)"
    elif cpk >= 0.67:
        return "Poor (not capable — improvement required)"
    else:
        return "Critical (highly incapable — immediate action)"


def compute_capability(
    data: list[float],
    lsl: float | None,
    usl: float | None,
) -> None:
    n = len(data)
    mu = mean(data)
    sigma = stdev_sample(data, mu)

    print(f"\n{'='*50}")
    print(f"  Process Capability Analysis")
    print(f"{'='*50}")
    print(f"  n        = {n}")
    print(f"  Mean (μ) = {mu:.6f}")
    print(f"  StdDev   = {sigma:.6f}")

    if lsl is None and usl is None:
        print("\nWARNING: No specification limits provided. Cp/Cpk cannot be computed.")
        print("  Use --lsl and/or --usl to specify limits.")
        return

    print(f"  LSL      = {lsl if lsl is not None else 'N/A'}")
    print(f"  USL      = {usl if usl is not None else 'N/A'}")
    print()

    cp = None
    if lsl is not None and usl is not None:
        cp = (usl - lsl) / (6 * sigma)
        print(f"  Cp       = {cp:.4f}  (potential capability — both limits)")

    cpu = (usl - mu) / (3 * sigma) if usl is not None else None
    cpl = (mu - lsl) / (3 * sigma) if lsl is not None else None

    if cpu is not None and cpl is not None:
        cpk = min(cpu, cpl)
    elif cpu is not None:
        cpk = cpu
    elif cpl is not None:
        cpk = cpl
    else:
        cpk = None

    if cpk is not None:
        print(f"  Cpu      = {cpu:.4f}" if cpu is not None else "  Cpu      = N/A")
        print(f"  Cpl      = {cpl:.4f}" if cpl is not None else "  Cpl      = N/A")
        print(f"  Cpk      = {cpk:.4f}  (actual capability — process centering)")
        print(f"\n  Interpretation: {interpret_cpk(cpk)}")

    # Performance indices (using overall sigma — equivalent for normal distribution)
    if cp is not None:
        pp = cp
        ppk = cpk if cpk is not None else None
        print(f"\n  Pp       = {pp:.4f}  (overall performance — equals Cp for this calc)")
        if ppk is not None:
            print(f"  Ppk      = {ppk:.4f}  (overall performance with centering)")

    # Percentage outside specification
    out_of_spec = 0
    if lsl is not None:
        out_of_spec += sum(1 for x in data if x < lsl)
    if usl is not None:
        out_of_spec += sum(1 for x in data if x > usl)
    pct = out_of_spec / n * 100
    print(f"\n  Out of spec: {out_of_spec}/{n} ({pct:.2f}%)")

    print(f"\n  DMAIC Thresholds:")
    print(f"    Cpk >= 1.67 → Six Sigma capable (target)")
    print(f"    Cpk >= 1.33 → Capable (minimum acceptable)")
    print(f"    Cpk  < 1.33 → Improvement required")
    print(f"{'='*50}\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Compute Cp/Cpk process capability from CSV data.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument("csv_file", help="Path to CSV file with measurement data")
    parser.add_argument("column", nargs="?", default=None, help="Column name (default: first numeric)")
    parser.add_argument("--lsl", type=float, default=None, help="Lower Specification Limit")
    parser.add_argument("--usl", type=float, default=None, help="Upper Specification Limit")
    args = parser.parse_args()

    data = read_csv_column(args.csv_file, args.column)
    compute_capability(data, args.lsl, args.usl)


if __name__ == "__main__":
    main()
