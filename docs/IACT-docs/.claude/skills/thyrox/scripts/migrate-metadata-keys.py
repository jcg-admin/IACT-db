#!/usr/bin/env python3
"""
migrate-metadata-keys.py — Migra keys de metadata YAML en frontmatter markdown.

Transforma keys en español (con espacios/tildes) a inglés snake_case.
Solo modifica el bloque frontmatter (entre ```yml y ```).
El cuerpo del documento NO se toca.

Uso:
    python scripts/migrate-metadata-keys.py --layer 1 [--dry-run]
    python scripts/migrate-metadata-keys.py --layer 1 --layer 2 [--dry-run]
    python scripts/migrate-metadata-keys.py --file path/to/file.md [--dry-run]
    python scripts/migrate-metadata-keys.py --all [--dry-run]
    python scripts/migrate-metadata-keys.py --verify-only [--layer N | --all]
"""

import argparse
import re
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# KEY MAP — español → inglés
# Orden: los keys más largos primero para evitar sustituciones parciales.
# Ejemplo: "Fecha creación" debe procesarse antes que "Fecha".
# ---------------------------------------------------------------------------
_KEY_MAP_RAW = {
    # Grupo A — universales
    "Tipo": "type",
    "Categoría": "category",
    "Versión": "version",
    "Propósito": "purpose",
    "Objetivo": "goal",
    "Fase": "phase",
    "Estado": "status",
    "Autor": "author",
    "Proyecto": "project",
    "Activar si": "activate_if",
    "ID": "id",
    "Sistema": "system",
    "Uso": "usage",
    "Herramientas": "tools",
    "Formato": "format",
    "Ejemplos": "examples",
    "WP": "wp",
    "Scope": "scope",
    "Epic": "epic",
    "Feature": "feature",
    "Rama": "branch",
    # Grupo B — fechas (más largos primero — crítico)
    "Fecha creación tareas": "created_at",
    "Fecha última actualización": "updated_at",
    "Fecha inicio categorización": "started_at",
    "Fecha inicio correcciones": "started_at",
    "Fecha fin correcciones": "ended_at",
    "Fecha inicio prevista": "planned_start",
    "Fecha fin prevista": "planned_end",
    "Fecha inicio estimada": "estimated_start",
    "Fecha fin estimada": "estimated_end",
    "Fecha inicio sesión": "session_started_at",
    "Fecha fin sesión": "session_ended_at",
    "Fecha identificación": "created_at",
    "Fecha actualización": "updated_at",
    "Última actualización": "updated_at",
    "Fecha completación": "completed_at",
    "Fecha estrategia": "created_at",
    "Fecha documento": "created_at",
    "Fecha creación": "created_at",
    "Fecha análisis": "created_at",
    "Fecha diseño": "created_at",
    "Fecha inicio": "started_at",
    "Fecha cierre": "closed_at",
    "Fecha plan": "created_at",
    "Fecha fin": "ended_at",
    "Fecha": "created_at",
    # Grupo C — contadores
    "Total issues a categorizar": "total_issues",
    "Total issues encontrados": "total_issues_found",
    "Total stakeholders": "total_stakeholders",
    "Total lecciones": "total_lessons",
    "Total tareas": "total_tasks",
    "Requisitos totales": "total_requirements",
    "Estimacion total": "total_estimate",
    "Riesgos mitigados": "mitigated_risks",
    "Riesgos abiertos": "open_risks",
    "Riesgos cerrados": "closed_risks",
    # Grupo D — roles
    "Responsable análisis": "analysis_owner",
    "Responsable implementación": "implementation_owner",
    "Responsable proceso": "process_owner",
    "Revisor designado": "assigned_reviewer",
    "Coordinación con": "coordination_with",
    "Creador tareas": "tasks_creator",
    "Aprobado por": "approved_by",
    "Validado por": "validated_by",
    "Corregido por": "fixed_by",
    "Reportado por": "reported_by",
    "Responsable": "owner",
    "Revisor": "reviewer",
    "Ejecutor": "executor",
    "Planificador": "planner",
    "Diseñador": "designer",
    "Arquitecto": "architect",
    # Grupo E — versiones y tracking
    "Versión Quality Goals": "quality_goals_version",
    "Versión stakeholder map": "stakeholder_map_version",
    "Versión categorización": "categorization_version",
    "Versión arquitectura": "architecture_version",
    "Versión constitution": "constitution_version",
    "Versión constraints": "constraints_version",
    "Versión requisitos": "requirements_version",
    "Versión breakdown": "breakdown_version",
    "Versión análisis": "analysis_version",
    "Versión contexto": "context_version",
    "Versión reporte": "report_version",
    "Versión diseño": "design_version",
    "Versión flujo": "flow_version",
    "Versión docs": "docs_version",
    "Stack versión": "stack_version",
    "ID work package": "work_package_id",
    "Fase de origen": "source_phase",
    "Fases activas": "active_phases",
    "Fase actual": "current_phase",
    # Grupo F — específicos
    "Tiempo total sesión": "total_session_time",
    "Issues tratados hoy": "issues_handled_today",
    "Issues en progreso": "in_progress_issues",
    "Issues pendientes": "pending_issues",
    "Issues demorados": "delayed_issues",
    "Issues resueltos": "resolved_issues",
    "Siguiente sesión": "next_session",
    "Tasa resolución": "resolution_rate",
    "Período evaluación": "evaluation_period",
    "Período vigencia": "validity_period",
    "Dependencias críticas": "critical_dependencies",
    "Dependencias externas": "external_dependencies",
    "Clasificación": "classification",
    "Budget utilizado": "budget_used",
    "Horas dedicadas": "hours_spent",
    "Severidad": "severity",
    "Recurrencia": "recurrence",
    "Componentes": "components",
    "Componente": "component",
}

# Ordenar por longitud descendente — crítico para evitar sustituciones parciales
KEY_MAP = dict(
    sorted(_KEY_MAP_RAW.items(), key=lambda x: len(x[0]), reverse=True)
)

# ---------------------------------------------------------------------------
# Capas de migración
# ---------------------------------------------------------------------------
REPO_ROOT = Path(__file__).parent.parent.parent  # .claude/skills/thyrox/scripts/ → repo root

LAYERS = {
    1: {
        "name": "templates (assets/)",
        "patterns": [".claude/skills/thyrox/assets/*.template",
                     ".claude/skills/thyrox/assets/*.md.template"],
    },
    2: {
        "name": "references/",
        "patterns": [".claude/skills/thyrox/references/*.md"],
    },
    4: {
        "name": "context activo",
        "files": [
            ".thyrox/context/focus.md",
            ".thyrox/context/now.md",
            ".thyrox/context/project-state.md",
            ".thyrox/context/technical-debt.md",
            ".thyrox/context/decisions.md",
        ],
    },
    5: {
        "name": "ADRs",
        "patterns": [".thyrox/context/decisions/adr-*.md"],
    },
    6: {
        "name": "error reports",
        "patterns": [".thyrox/context/errors/ERR-*.md"],
    },
    7: {
        "name": "WP activo thyrox-capabilities-integration",
        "patterns": [
            ".thyrox/context/work/2026-04-05-01-09-22-thyrox-capabilities-integration/**/*.md",
            ".thyrox/context/work/2026-04-05-01-09-22-thyrox-capabilities-integration/*.md",
        ],
    },
}

# ---------------------------------------------------------------------------
# Core: extrae y transforma el frontmatter
# ---------------------------------------------------------------------------
FRONTMATTER_RE = re.compile(
    r"^(```yml\n)(.*?)(^```)", re.MULTILINE | re.DOTALL
)


def migrate_frontmatter(content: str) -> tuple[str, list[str]]:
    """
    Transforma los keys del frontmatter YAML. Retorna (nuevo_contenido, cambios).
    Si no hay frontmatter, retorna el contenido original sin cambios.
    """
    match = FRONTMATTER_RE.search(content)
    if not match:
        return content, []

    open_fence, block, close_fence = match.group(1), match.group(2), match.group(3)
    new_block = block
    changes = []

    for old_key, new_key in KEY_MAP.items():
        # Matchea exactamente "Old Key:" al inicio de una línea dentro del bloque
        pattern = re.compile(r"^(" + re.escape(old_key) + r")(\s*:)", re.MULTILINE)
        if pattern.search(new_block):
            new_block = pattern.sub(new_key + r"\2", new_block)
            changes.append(f"  {old_key} → {new_key}")

    new_content = content[: match.start()] + open_fence + new_block + close_fence + content[match.end():]
    return new_content, changes


# ---------------------------------------------------------------------------
# Operaciones sobre archivos
# ---------------------------------------------------------------------------

def process_file(path: Path, dry_run: bool) -> tuple[bool, list[str]]:
    """Procesa un archivo. Retorna (modificado, lista_de_cambios)."""
    try:
        original = path.read_text(encoding="utf-8")
    except Exception as e:
        print(f"  ERROR leyendo {path}: {e}", file=sys.stderr)
        return False, []

    new_content, changes = migrate_frontmatter(original)

    if not changes:
        return False, []

    if dry_run:
        print(f"\n[DRY-RUN] {path.relative_to(REPO_ROOT)}")
        for c in changes:
            print(c)
    else:
        path.write_text(new_content, encoding="utf-8")
        print(f"  [OK] {path.relative_to(REPO_ROOT)}")
        for c in changes:
            print(c)

    return True, changes


def get_files_for_layer(layer_num: int) -> list[Path]:
    """Resuelve los archivos para una capa dada."""
    layer = LAYERS.get(layer_num)
    if not layer:
        print(f"ERROR: capa {layer_num} no definida.", file=sys.stderr)
        return []

    files = []
    if "files" in layer:
        for f in layer["files"]:
            p = REPO_ROOT / f
            if p.exists():
                files.append(p)
            else:
                print(f"  WARNING: {f} no encontrado", file=sys.stderr)
    if "patterns" in layer:
        for pattern in layer["patterns"]:
            files.extend(REPO_ROOT.glob(pattern))

    return sorted(set(files))


# ---------------------------------------------------------------------------
# Verificación
# ---------------------------------------------------------------------------
SPANISH_KEY_PATTERN = re.compile(
    r"^(Tipo|Categoría|Versión|Propósito|Objetivo|Fase|Estado|Autor|Proyecto|"
    r"Fecha|Última actualización|ID work package|Total |Requisitos|Estimacion|"
    r"Riesgos|Responsable|Revisor|Aprobado|Validado|Corregido|Reportado|"
    r"Ejecutor|Planificador|Diseñador|Arquitecto|Creador|Coordinación|"
    r"Versión |Stack versión|Fase actual|Fase de origen|Fases activas|"
    r"Tiempo total|Issues |Siguiente sesión|Tasa|Período|Dependencias|"
    r"Clasificación|Budget|Horas|Severidad|Recurrencia|Componente|"
    r"Activar si)\s*:",
    re.MULTILINE,
)


def verify_files(files: list[Path]) -> int:
    """Verifica que los archivos no tengan keys en español. Retorna nº de archivos con problemas."""
    issues = 0
    for path in files:
        try:
            content = path.read_text(encoding="utf-8")
        except Exception:
            continue
        # Solo verificar dentro del frontmatter
        match = FRONTMATTER_RE.search(content)
        if not match:
            continue
        block = match.group(2)
        hits = SPANISH_KEY_PATTERN.findall(block)
        if hits:
            print(f"  FAIL {path.relative_to(REPO_ROOT)}: {hits}")
            issues += 1
    return issues


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Migra keys de metadata YAML español → inglés")
    parser.add_argument("--layer", type=int, action="append", dest="layers",
                        help="Número de capa a procesar (puede repetirse: --layer 1 --layer 2)")
    parser.add_argument("--file", type=Path, dest="single_file",
                        help="Procesar un archivo específico")
    parser.add_argument("--all", action="store_true",
                        help="Procesar todas las capas en orden")
    parser.add_argument("--dry-run", action="store_true",
                        help="Mostrar cambios sin escribir archivos")
    parser.add_argument("--verify-only", action="store_true",
                        help="Solo verificar, no migrar")
    args = parser.parse_args()

    if not any([args.layers, args.single_file, args.all]):
        parser.print_help()
        sys.exit(1)

    dry_run = args.dry_run
    if dry_run:
        print("=== DRY-RUN — no se escriben archivos ===\n")

    # Recolectar archivos según modo
    if args.single_file:
        files = [args.single_file.resolve()]
    elif args.all:
        files = []
        for layer_num in sorted(LAYERS.keys()):
            files.extend(get_files_for_layer(layer_num))
    else:
        files = []
        for layer_num in sorted(args.layers):
            layer_files = get_files_for_layer(layer_num)
            layer_name = LAYERS.get(layer_num, {}).get("name", f"capa {layer_num}")
            print(f"\n--- Capa {layer_num}: {layer_name} ({len(layer_files)} archivos) ---")
            files.extend(layer_files)

    if args.verify_only:
        print("\n=== VERIFICACIÓN ===")
        issues = verify_files(files)
        if issues == 0:
            print(f"  OK: cero keys en español en {len(files)} archivos")
        else:
            print(f"\n  FAIL: {issues} archivo(s) con keys en español")
            sys.exit(1)
        return

    # Migrar
    total_modified = 0
    for path in files:
        modified, _ = process_file(path, dry_run)
        if modified:
            total_modified += 1

    action = "modificarían" if dry_run else "modificados"
    print(f"\n{'DRY-RUN: ' if dry_run else ''}Total {action}: {total_modified}/{len(files)} archivos")

    # Verificación post-migración (solo si no es dry-run)
    if not dry_run and total_modified > 0:
        print("\n=== Verificación post-migración ===")
        issues = verify_files(files)
        if issues == 0:
            print(f"  OK: cero keys en español")
        else:
            print(f"  WARNING: {issues} archivo(s) con keys residuales — revisar manualmente")


if __name__ == "__main__":
    main()
