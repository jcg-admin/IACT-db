#!/usr/bin/env python3
"""update-procedimiento-refs.py — text-level replacement post-rename F-01."""
from __future__ import annotations
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"

MAPPING = {
    "procedimiento-analisis-seguridad": "proc-qa-003-analisis-seguridad",
    "procedimiento-desarrollo-local": "proc-dev-003-desarrollo-local",
    "procedimiento-diseno-tecnico": "proc-dev-004-diseno-tecnico",
    "procedimiento-gestion-cambios": "proc-gob-011-gestion-cambios",
    "procedimiento-instalacion-entorno": "proc-ops-003-instalacion-entorno",
    "procedimiento-qa": "proc-qa-004-qa",
    "procedimiento-release": "proc-devops-002-release",
    "procedimiento-revision-documental": "proc-gob-012-revision-documental",
    "procedimiento-trazabilidad-requisitos": "proc-req-019-trazabilidad-requisitos",
}

# Sort by length desc para evitar prefix collisions
ITEMS = sorted(MAPPING.items(), key=lambda x: -len(x[0]))


def main():
    total_files = 0
    total_changes = 0
    for rst in SOURCE.rglob("*.rst"):
        text = rst.read_text()
        original = text
        changes = 0
        for old, new in ITEMS:
            if old in text:
                count = text.count(old)
                text = text.replace(old, new)
                changes += count
        if text != original:
            rst.write_text(text)
            total_files += 1
            total_changes += changes
            print(f"  {rst.relative_to(REPO_ROOT)}: {changes}")
    print(f"\n==> {total_files} archivos modificados, {total_changes} replacements")


if __name__ == "__main__":
    main()
