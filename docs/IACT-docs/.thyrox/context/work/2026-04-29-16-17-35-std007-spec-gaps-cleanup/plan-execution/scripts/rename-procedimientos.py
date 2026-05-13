#!/usr/bin/env python3
"""rename-procedimientos.py — F-01: 9 procedimiento-* → proc-<MOD>-<NNN>.

Idempotente: corre múltiples veces sin daño.
"""
from __future__ import annotations
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
PROCED_DIR = REPO_ROOT / "source" / "normativa" / "procedimientos"

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


def git_mv(src: Path, dst: Path):
    subprocess.run(["git", "mv", str(src), str(dst)], check=True, cwd=REPO_ROOT)


def main():
    dry = "--dry-run" in sys.argv
    moved = 0
    for old_stem, new_stem in MAPPING.items():
        old = PROCED_DIR / (old_stem + ".rst")
        new = PROCED_DIR / (new_stem + ".rst")
        if not old.exists():
            if new.exists():
                print(f"  [skip] ya renombrado: {new_stem}.rst")
                continue
            print(f"  [WARN] no existe: {old_stem}.rst")
            continue
        if dry:
            print(f"  {old_stem}.rst -> {new_stem}.rst")
            continue
        git_mv(old, new)
        moved += 1
        print(f"  ✓ {old_stem}.rst -> {new_stem}.rst")
    if not dry:
        print(f"\n==> {moved} archivos renombrados")


if __name__ == "__main__":
    main()
