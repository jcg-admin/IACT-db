#!/usr/bin/env python3
"""
lint-agents.py — Validator for native Claude Code agents.

Validates frontmatter of .claude/agents/*.md files against the agent-spec.md rules:
  - REQUIRED fields: name, description, tools
  - PROHIBITED fields: model, category, skill_template, system_prompt
  - description: non-empty, >= 20 chars
  - description pattern WARN: should follow "{what}. Usar cuando {condition}."

Usage:
  python3 lint-agents.py                    # Validate all .claude/agents/*.md
  python3 lint-agents.py path/to/agent.md  # Validate specific file(s)
"""

import sys
import re
from pathlib import Path

REQUIRED_FIELDS = {"name", "description", "tools"}
PROHIBITED_FIELDS = {"model", "category", "skill_template", "system_prompt"}
DESCRIPTION_MIN_CHARS = 20
USAR_CUANDO_PATTERN = re.compile(r".+\.\s*[Uu]sar cuando .+", re.DOTALL)


def find_agents(paths: list[str]) -> list[Path]:
    """Resolve the list of agent files to validate."""
    if paths:
        files = []
        for p in paths:
            path = Path(p)
            if path.is_file():
                files.append(path)
            elif path.is_dir():
                files.extend(sorted(path.glob("*.md")))
            else:
                print(f"Warning: path not found — {p}", file=sys.stderr)
        return files
    # Default: .claude/agents/*.md relative to cwd
    agents_dir = Path(".claude/agents")
    if not agents_dir.exists():
        print(f"Error: directory not found — {agents_dir}", file=sys.stderr)
        sys.exit(2)
    return sorted(agents_dir.glob("*.md"))


def parse_frontmatter(text: str) -> tuple[dict | None, list[str]]:
    """
    Extract YAML frontmatter from a markdown file.
    Returns (fields_dict, parse_errors).
    fields_dict is None if no frontmatter block found.
    """
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None, ["no frontmatter block found (file does not start with '---')"]

    end_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        return None, ["frontmatter block not closed (missing closing '---')"]

    frontmatter_lines = lines[1:end_idx]
    fields: dict = {}
    parse_errors: list[str] = []
    current_key: str | None = None
    list_values: list[str] = []

    i = 0
    while i < len(frontmatter_lines):
        line = frontmatter_lines[i]

        # List item under current key
        if line.startswith("  - ") and current_key is not None:
            list_values.append(line[4:].strip())
            i += 1
            continue

        # New key
        if ":" in line:
            # Flush previous list
            if current_key is not None and list_values:
                fields[current_key] = list_values
                list_values = []

            key, _, value = line.partition(":")
            key = key.strip()
            value = value.strip()

            # Detect block scalar `>` or `|`
            if value in (">", "|", ">-", "|-", ">+", "|+"):
                # Collect indented lines that follow
                block_lines = []
                i += 1
                while i < len(frontmatter_lines):
                    next_line = frontmatter_lines[i]
                    if next_line.startswith("  ") or next_line == "":
                        block_lines.append(next_line.strip())
                        i += 1
                    else:
                        break
                fields[key] = " ".join(bl for bl in block_lines if bl).strip()
                current_key = None
                continue
            else:
                fields[key] = value
                current_key = key

        i += 1

    # Flush trailing list
    if current_key is not None and list_values:
        fields[current_key] = list_values

    return fields, parse_errors


def validate_agent(file_path: Path) -> tuple[list[str], list[str]]:
    """
    Validate a single agent file.
    Returns (errors, warnings).
    """
    errors: list[str] = []
    warnings: list[str] = []

    try:
        text = file_path.read_text(encoding="utf-8")
    except OSError as e:
        return [f"cannot read file: {e}"], []

    fields, parse_errors = parse_frontmatter(text)
    if parse_errors:
        return [f"frontmatter parse error: {e}" for e in parse_errors], []
    if fields is None:
        return ["no frontmatter block found"], []

    # --- REQUIRED fields ---
    for req in sorted(REQUIRED_FIELDS):
        if req not in fields:
            errors.append(f"missing required field '{req}'")

    # --- PROHIBITED fields ---
    for prohibited in sorted(PROHIBITED_FIELDS):
        if prohibited in fields:
            errors.append(f"prohibited field '{prohibited}' found in frontmatter")

    # --- description quality ---
    if "description" in fields:
        desc = fields["description"]

        # Block scalar with empty content produces empty string
        if desc == "" or desc is None:
            errors.append(
                "description is empty (block scalar '>' with no content) — "
                "agent is invisible for routing"
            )
        elif len(desc) < DESCRIPTION_MIN_CHARS:
            errors.append(
                f"description too short ({len(desc)} chars, minimum {DESCRIPTION_MIN_CHARS}) — "
                f"value: '{desc}'"
            )
        else:
            # Check recommended pattern (WARN only)
            if not USAR_CUANDO_PATTERN.match(desc):
                warnings.append(
                    f"description does not follow recommended pattern "
                    f"'{{qué hace}}. Usar cuando {{condición}}.' — "
                    f"value: '{desc[:60]}...'" if len(desc) > 60 else
                    f"description does not follow recommended pattern "
                    f"'{{qué hace}}. Usar cuando {{condición}}.' — "
                    f"value: '{desc}'"
                )

    # --- tools: at least one element ---
    if "tools" in fields:
        tools_val = fields["tools"]
        if not isinstance(tools_val, list) or len(tools_val) == 0:
            errors.append("'tools' field must be a non-empty list")

    return errors, warnings


def main() -> int:
    args = sys.argv[1:]
    files = find_agents(args)

    if not files:
        print("No agent files found.")
        return 0

    total = len(files)
    total_errors = 0
    total_warnings = 0

    for file_path in files:
        errors, warnings = validate_agent(file_path)
        total_errors += len(errors)
        total_warnings += len(warnings)

        if not errors and not warnings:
            print(f"[OK] {file_path}")
        elif not errors and warnings:
            print(f"[OK] {file_path} ({len(warnings)} warning(s))")
            for w in warnings:
                print(f"    WARN: {w}")
        else:
            print(f"[FAIL] {file_path}: {len(errors)} error(s), {len(warnings)} warning(s)")
            for e in errors:
                print(f"    ERROR: {e}")
            for w in warnings:
                print(f"    WARN: {w}")

    print()
    print(
        f"{total} file(s) checked, {total_errors} error(s), {total_warnings} warning(s)"
    )

    return 0 if total_errors == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
