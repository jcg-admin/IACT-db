#!/usr/bin/env python3
"""
fix-agent-frontmatter.py — Batch-fix lint-agents.py errors in .claude/agents/*.md

Fixes:
  1. tools: "X, Y, Z"  →  YAML list format
  2. Remove prohibited field: model
  3. Restructure description to match: {qué hace}. Usar cuando {condición}.
"""

import re
import sys
from pathlib import Path

AGENTS_DIR = Path(".claude/agents")

# New descriptions: {name: description}
DESCRIPTIONS = {
    "agentic-reasoning": (
        "DEPRECATED — redirige a deep-dive (Capa 7). "
        "Usar cuando se invoque este agente por error — "
        "su funcionalidad de calibración THYROX fue absorbida por deep-dive."
    ),
    "agentic-validator": (
        "Valida código Python agentic contra el catálogo AP-01..AP-42, "
        "detectando anti-patrones en callbacks ADK (AP-01/02), type contracts (AP-03/06), "
        "temperatura clasificadores (AP-07/08), error handling (AP-09/12), "
        "observabilidad (AP-13/15), HITL decorativo (AP-16/17), "
        "imports deprecados (AP-18/22) y diseño agentic (AP-23/30). "
        "Usar cuando se necesite validar código agentic Python: "
        "retorna reporte con AP-ID, severidad, file:line y corrección."
    ),
    "ba-coordinator": (
        "Coordinator para BABOK — Business Analysis Body of Knowledge (v3), "
        "no-secuencial: selecciona el knowledge area más relevante "
        "o presenta los 6 para que el usuario elija. "
        "Usar cuando la metodología BABOK está activa. "
        "Corre en worktree aislado."
    ),
    "bpa-coordinator": (
        "Coordinator para BPA — Business Process Analysis: As-Is (BPMN), "
        "identificación de desperdicios VA/BVA/NVA, diseño To-Be (ESIA), "
        "6 fases con tollgates formales. "
        "Usar cuando la metodología BPA está activa. "
        "Worktree aislado."
    ),
    "cp-coordinator": (
        "Coordinator para Consulting Process (McKinsey/BCG): "
        "Issue Tree, MECE, hipótesis, Pyramid Principle, Recommendation Deck, "
        "7 fases con tollgates formales. "
        "Usar cuando la metodología CP está activa. "
        "Worktree aislado."
    ),
    "deep-dive": (
        "Análisis adversarial de cualquier artefacto — documentos, código, arquitecturas, "
        "decisiones, frameworks, problemas — determinando qué es verdadero, falso e incierto. "
        "Para artefactos WP de THYROX aplica automáticamente calibración "
        "(ratio OBSERVABLE+INFERRED/total ≥ 0.75). "
        "Usar cuando se necesite saber qué es verdad, qué es falso y qué es incierto — "
        "y POR QUÉ. Ejecuta mínimo 6 capas adversariales + Capa 7 de calibración THYROX."
    ),
    "deep-review": (
        "Analiza cobertura entre artefactos de fases consecutivas del WP, "
        "o profundidad de referencias externas en repos/docs. "
        "Usar cuando el usuario pide un deep-review antes de avanzar de Phase N a Phase N+1, "
        "o cuando quiere analizar patrones arquitectónicos en documentación externa. "
        "No usar para harvesting de corpus de análisis (usar pattern-harvester)."
    ),
    "dmaic-coordinator": (
        "Coordinator para DMAIC — Six Sigma process improvement, "
        "5 fases (Define/Measure/Analyze/Improve/Control) con tollgates formales. "
        "Usar cuando la metodología DMAIC está activa. "
        "Worktree aislado."
    ),
    "gate-consistency-evaluator": (
        "Evalúa claims de un artefacto contra decisiones previas "
        "y artefactos de stages anteriores; retorna output_key='consistencia' "
        "con {claims_contradictorios, claims_heredados_sin_verificar, gate_pasa, notas}. "
        "Usar cuando un gate de Stage THYROX requiere evaluación de consistencia."
    ),
    "lean-coordinator": (
        "Coordinator para Lean Six Sigma — eliminación de desperdicios, "
        "mejora de value stream, 5 fases con tollgates formales. "
        "Usar cuando la metodología Lean está activa. "
        "Worktree aislado."
    ),
    "mysql-expert": (
        "Tech-expert para MySQL y bases de datos relacionales. "
        "Usar cuando se trabaja con MySQL queries, schema design, "
        "migrations, indexes u optimización."
    ),
    "pattern-harvester": (
        "Extrae patrones accionables de un corpus de archivos de análisis deep-dive "
        "y calibración, mapeando hallazgos a componentes THYROX "
        "(skills, hooks, agentes, guidelines, templates). "
        "Produce harvest report distinguiendo qué está cubierto vs. qué es nuevo. "
        "Usar cuando se consolidan outputs de análisis en mejoras implementables. "
        "No usar para análisis fase-a-fase (usar deep-review)."
    ),
    "pdca-coordinator": (
        "Coordinator para PDCA — ciclo de mejora continua (Plan/Do/Check/Act), "
        "4 stages con updates de methodology_step. "
        "Usar cuando la metodología PDCA está activa. "
        "Worktree aislado."
    ),
    "pm-coordinator": (
        "Coordinator para PMBOK — gestión de proyectos PMI, "
        "5 grupos de proceso (Initiating/Planning/Executing/Monitoring & Controlling/Closing) "
        "con sus knowledge areas. "
        "Usar cuando la metodología PMBOK está activa."
    ),
    "postgresql-expert": (
        "Tech-expert para PostgreSQL. "
        "Usar cuando se trabaja con PostgreSQL queries, schema design, "
        "migrations, indexes o transacciones."
    ),
    "pps-coordinator": (
        "Coordinator para PPS — Practical Problem Solving (Toyota TBP): "
        "Go-and-See, 5 Whys, A3 Report, 6 fases con tollgates formales. "
        "Usar cuando la metodología PPS está activa. "
        "Worktree aislado."
    ),
    "rm-coordinator": (
        "Coordinator para RM — Requirements Management: "
        "elicitación, análisis, especificación, validación, gestión de cambios, "
        "con retornos condicionales (gaps → re-elicitación, change requests → re-análisis). "
        "Usar cuando la metodología RM está activa. "
        "Worktree aislado."
    ),
    "rup-coordinator": (
        "Coordinator para RUP — Rational Unified Process: "
        "4 fases iterativas (Inception/Elaboration/Construction/Transition) "
        "con milestones LCO/LCA/IOC/PD. "
        "Usar cuando la metodología RUP está activa. "
        "Worktree aislado."
    ),
    "sp-coordinator": (
        "Coordinator para Strategic Planning: PESTEL/SWOT, strategy formulation, "
        "Balanced Scorecard, OKRs, 8 fases con tollgates y ciclos estratégicos "
        "(sp:adjust → sp:analysis). "
        "Usar cuando la metodología SP está activa. "
        "Worktree aislado."
    ),
    "task-synthesizer": (
        "Consolida outputs existentes de análisis (cluster reports, gap analyses) "
        "en un task-plan: deduplica hallazgos, resuelve conflictos, construye el DAG correcto "
        "y asigna IDs T-NNN continuando el plan existente. "
        "Usar cuando se consolidan outputs de pattern-harvester o deep-dive "
        "en blocks de task-plan listos para ejecutar. "
        "No usar para planificación inicial desde cero (usar task-planner)."
    ),
    "thyrox-coordinator": (
        "Coordinator genérico para THYROX — lee el YAML de metodología dinámicamente "
        "y resuelve transiciones para cualquier tipo de flow "
        "(cíclico, secuencial, iterativo, no-secuencial, condicional). "
        "Usar cuando hay una metodología THYROX registrada activa "
        "que no tiene coordinator dedicado."
    ),
    "webpack-expert": (
        "Tech-expert para Webpack y bundling de assets. "
        "Conoce configuración de entry/output, loaders, plugins, "
        "code splitting, optimización de bundles y resolución de módulos. "
        "Usar cuando se trabaja con Webpack: configuración, "
        "optimización de bundles o resolución de módulos."
    ),
}


def fix_agent_file(path: Path) -> tuple[bool, list[str]]:
    """Fix a single agent file. Returns (changed, list_of_fixes)."""
    text = path.read_text()
    fixes = []

    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return False, ["no frontmatter"]

    # Find end of frontmatter
    end_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_idx = i
            break
    if end_idx is None:
        return False, ["frontmatter not closed"]

    fm_lines = lines[1:end_idx]
    body_lines = lines[end_idx + 1:]  # everything after closing ---

    # Parse frontmatter into structured form preserving order
    new_fm_lines = []
    i = 0
    changed = False

    while i < len(fm_lines):
        line = fm_lines[i]

        # Skip prohibited model field
        if re.match(r'^model\s*:', line):
            fixes.append("removed 'model' field")
            changed = True
            i += 1
            continue

        # Fix tools: string to list
        m = re.match(r'^(tools)\s*:\s*(.+)$', line)
        if m and not m.group(2).strip().startswith('['):
            key = m.group(1)
            val = m.group(2).strip().strip('"').strip("'")
            # Check if it's a comma-separated string (not a list value)
            if ',' in val or (val and not val.startswith('-')):
                items = [v.strip() for v in val.split(',') if v.strip()]
                new_fm_lines.append(f"{key}:")
                for item in items:
                    new_fm_lines.append(f"  - {item}")
                fixes.append(f"converted tools string to list: {items}")
                changed = True
                i += 1
                continue

        # Fix description if agent has a new description defined
        m = re.match(r'^(description)\s*:\s*(.*)$', line)
        if m:
            agent_name = None
            # Look up name from already-parsed lines
            for prev_line in fm_lines:
                nm = re.match(r'^name\s*:\s*(.+)$', prev_line)
                if nm:
                    agent_name = nm.group(1).strip()
                    break

            if agent_name and agent_name in DESCRIPTIONS:
                new_desc = DESCRIPTIONS[agent_name]
                new_fm_lines.append(f'description: "{new_desc}"')
                fixes.append(f"updated description for {agent_name}")
                changed = True
                i += 1
                continue

        new_fm_lines.append(line)
        i += 1

    if not changed:
        return False, []

    # Reconstruct file
    new_text = "---\n"
    new_text += "\n".join(new_fm_lines) + "\n"
    new_text += "---\n"
    if body_lines:
        new_text += "\n".join(body_lines)
        if not new_text.endswith("\n"):
            new_text += "\n"

    path.write_text(new_text)
    return True, fixes


def main():
    files = sorted(AGENTS_DIR.glob("*.md"))
    total_changed = 0
    for f in files:
        changed, fixes = fix_agent_file(f)
        if changed:
            total_changed += 1
            print(f"[FIXED] {f.name}")
            for fix in fixes:
                print(f"  - {fix}")
        else:
            print(f"[SKIP]  {f.name}")
    print(f"\n{total_changed} file(s) fixed.")


if __name__ == "__main__":
    main()
