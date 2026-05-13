#!/usr/bin/env python3
"""
extract-agent-output.py — Extract the final text response from a large agent task output file.

Usage:
    python3 .claude/scripts/extract-agent-output.py <task-output-file> [output-file]

When Claude Code agent task output files exceed 256KB, the Read tool refuses to open them.
This script reads only the last assistant message from the JSONL and writes the text content
to stdout (or to output-file if provided).

Example:
    python3 .claude/scripts/extract-agent-output.py /tmp/claude-0/.../tasks/abc123.output
    python3 .claude/scripts/extract-agent-output.py /tmp/claude-0/.../tasks/abc123.output /tmp/result.md
"""

import json
import sys
from pathlib import Path


def extract(task_file: str, output_file: str | None = None) -> None:
    lines = Path(task_file).read_text(encoding="utf-8").splitlines()

    # Walk from end to find last assistant message with text content
    for line in reversed(lines):
        line = line.strip()
        if not line:
            continue
        try:
            record = json.loads(line)
        except json.JSONDecodeError:
            continue

        if record.get("type") != "assistant":
            continue

        content = record.get("message", {}).get("content", "")
        if isinstance(content, str):
            text = content
        elif isinstance(content, list):
            parts = [c.get("text", "") for c in content if isinstance(c, dict) and c.get("type") == "text"]
            text = "\n".join(parts)
        else:
            continue

        if not text.strip():
            continue

        if output_file:
            Path(output_file).write_text(text, encoding="utf-8")
            print(f"Written to {output_file} ({len(text)} bytes)", file=sys.stderr)
        else:
            print(text)
        return

    print("ERROR: no assistant text content found in file", file=sys.stderr)
    sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    task_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    extract(task_file, output_file)
