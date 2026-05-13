#!/usr/bin/env python3
"""assign-modules.py — assign REQ/DOC/GOB modules to transversal procs.

Renombra los 39 archivos proc-* sin <MOD>-<NNN> al patrón canónico
proc-<mod>-<nnn>-<descripcion>.rst conforme STD_007 v2.0.1.

Idempotente: corre múltiples veces sin daño.
"""
from __future__ import annotations
import os
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[6]
SOURCE = REPO_ROOT / "source"
PROCED_DIR = SOURCE / "normativa" / "procedimientos"

# Mapping: nombre actual -> nombre nuevo (sin .rst)
MAPPING = {
    # REQ — 18
    "proc-generacion-breq": "proc-req-001-generacion-breq",
    "proc-derivacion-breq-br": "proc-req-002-derivacion-breq-br",
    "proc-generacion-br": "proc-req-003-generacion-br",
    "proc-generacion-cnst": "proc-req-004-generacion-cnst",
    "proc-derivacion-br-uc": "proc-req-005-derivacion-br-uc",
    "proc-revision-uc-previo-derivacion": "proc-req-006-revision-uc-previo-derivacion",
    "proc-generacion-uc": "proc-req-007-generacion-uc",
    "proc-derivacion-uc-fr": "proc-req-008-derivacion-uc-fr",
    "proc-generacion-fr": "proc-req-009-generacion-fr",
    "proc-generacion-nfr": "proc-req-010-generacion-nfr",
    "proc-derivacion-fr-tst": "proc-req-011-derivacion-fr-tst",
    "proc-derivacion-fr-code": "proc-req-012-derivacion-fr-code",
    "proc-elaboracion-completa-requisitos": "proc-req-013-elaboracion-completa-requisitos",
    "proc-cambio-requisitos": "proc-req-014-cambio-requisitos",
    "proc-excepciones-cnst": "proc-req-015-excepciones-cnst",
    "proc-identificar-gaps-huerfanos": "proc-req-016-identificar-gaps-huerfanos",
    "proc-verificacion-cobertura": "proc-req-017-verificacion-cobertura",
    "proc-crear-plan-analisis": "proc-req-018-crear-plan-analisis",
    # DOC — 14
    "proc-generacion-std": "proc-doc-001-generacion-std",
    "proc-generacion-adr": "proc-doc-002-generacion-adr",
    "proc-generacion-pol": "proc-doc-003-generacion-pol",
    "proc-generacion-mod": "proc-doc-004-generacion-mod",
    "proc-generacion-fd": "proc-doc-005-generacion-fd",
    "proc-generacion-view": "proc-doc-006-generacion-view",
    "proc-generacion-rtm": "proc-doc-007-generacion-rtm",
    "proc-generacion-api": "proc-doc-008-generacion-api",
    "proc-generacion-tst": "proc-doc-009-generacion-tst",
    "proc-generacion-index": "proc-doc-010-generacion-index",
    "proc-revision-tpl-previo-generacion": "proc-doc-011-revision-tpl-previo-generacion",
    "proc-revision-artefactos": "proc-doc-012-revision-artefactos",
    "proc-validacion-sphinx": "proc-doc-013-validacion-sphinx",
    "proc-crear-estructura-directorios-tmp": "proc-doc-014-crear-estructura-directorios-tmp",
    # GOB extends — 7
    "proc-aprobacion-documentos": "proc-gob-003-aprobacion-documentos",
    "proc-congelamiento-subdominio": "proc-gob-004-congelamiento-subdominio",
    "proc-descongelamiento-subdominio": "proc-gob-005-descongelamiento-subdominio",
    "proc-actualizacion-modelo-documental": "proc-gob-006-actualizacion-modelo-documental",
    "proc-publicacion-documentacion": "proc-gob-007-publicacion-documentacion",
    "proc-auditoria-documental": "proc-gob-009-auditoria-documental",
    "proc-versionado-semantico": "proc-gob-010-versionado-semantico",
}


def git_mv(src: Path, dst: Path):
    subprocess.run(["git", "mv", str(src), str(dst)], check=True, cwd=REPO_ROOT)


def main():
    dry = "--dry-run" in sys.argv
    print(f"==> {len(MAPPING)} renames planeados")
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
