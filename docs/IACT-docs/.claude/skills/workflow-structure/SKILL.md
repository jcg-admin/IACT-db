---
name: workflow-structure
description: "Use when specifying requirements with Given/When/Then after plan is approved. Phase 7 DESIGN/SPECIFY — produce requirements-spec.md y opcionalmente design.md para WPs complejos."
allowed-tools: Read Glob Grep Bash Write Edit
disable-model-invocation: true
effort: high
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 7'"
updated_at: 2026-04-20 13:30:36
---

# /workflow-structure — Phase 7: DESIGN/SPECIFY

Inicia o retoma Phase 7 DESIGN/SPECIFY del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer plan y solution-strategy del WP para entender el scope
3. Leer `context/now.md` — verificar `phase`
4. Verificar si ya existe `*-requirements-spec.md` sin `[NEEDS CLARIFICATION]`:
   - Si existe con spec-checklist al 100% → Phase 7 ya completó. Proponer `/thyrox:decompose`.
5. Listar tech skills activos para orientar la spec técnica.

---

## Fase a ejecutar: Phase 7 DESIGN/SPECIFY

Especificar antes de descomponer previene ambigüedad en las tareas.

**Determinar complejidad:**
- < 10 tareas estimadas → **Simple**
- 10+ tareas estimadas → **Complejo** (requiere también design.md)

**Simple:** Crear `work/.../design/{nombre-wp}-requirements-spec.md` usando `assets/requirements-specification.md.template`
  - Con overview, user stories, acceptance criteria (Given/When/Then)
  - Nombre descriptivo: `skill-activation-requirements-spec.md`, no `requirements-spec.md`

**Complejo:** Crear ambos:
1. `work/.../design/{nombre-wp}-requirements-spec.md` — qué construir (SPECs con Given/When/Then)
2. `work/.../design/{nombre-wp}-design.md` — cómo construirlo usando `assets/design.md.template`:
   - Visión arquitectónica, componentes afectados, decisiones de diseño
   - Ver [spec-driven-development](references/spec-driven-development.md) para guía completa

**Reglas de formato:**
- Todos los flujos, modelos y diagramas deben usar **Mermaid** (no ASCII art)
- Para docs técnicos sin template específico: `assets/document.md.template`

REQUERIDO al finalizar: completar `{nombre-wp}-spec-checklist.md` usando `assets/spec-quality-checklist.md.template` (20 ítems).
NO avanzar si quedan ítems sin +o marcadores `[NEEDS CLARIFICATION]` sin resolver.

---

## Validaciones pre-gate (TD-029, TD-031, TD-033)

Antes de presentar el gate 7→8:
- **TD-031 deep review**: revisar `{nombre-wp}-plan.md` de Phase 6 — ¿la spec cubre TODO el scope aprobado?
- **TD-029 criterios**: spec sin `[NEEDS CLARIFICATION]` · spec-checklist 100% · diseño técnico si era complejo
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes de commits y gates

## Gate humano

⏸ STOP — Presentar la especificación completa (user stories, acceptance criteria, diseño si aplica).
Esperar confirmación explícita. NO continuar sin respuesta.
Excepción: si el WP es `reversibility: documentation` y la spec no tiene ambigüedades, el gate puede ser ligero.
Al aprobar:
1. Actualizar `context/now.md::phase` a `Phase 8`
2. Actualizar `{nombre-wp}-requirements-spec.md::status` a `Aprobado — {fecha}`

---

## Exit criteria

Phase 7 completa cuando:
- `work/.../design/*-requirements-spec.md` existe sin `[NEEDS CLARIFICATION]`
- `{nombre-wp}-spec-checklist.md` completado al 100%
- Usuario confirmó la especificación explícitamente en esta sesión

**Detectar:** Si `work/.../design/*-requirements-spec.md` tiene user stories y acceptance criteria sin `[NEEDS CLARIFICATION]`, Phase 7 ya completó.
Al terminar: proponer `/thyrox:decompose` para Phase 8.
