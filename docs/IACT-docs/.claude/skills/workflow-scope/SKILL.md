---
name: workflow-scope
description: "Use when defining scope after strategy is approved. Phase 6 PLAN — define scope in/out explícito, produce plan.md y actualiza ROADMAP.md."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 6'"
updated_at: 2026-04-20 13:08:54
---

# /workflow-plan — Stage 6: SCOPE

Inicia o retoma Stage 6 SCOPE del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer `context/now.md` — verificar `phase`
3. Verificar si ya existe `*-plan.md` con `[x] Scope aprobado`:
   - Si existe aprobado → Phase 6 ya completó. Proponer `/thyrox:design`.
4. Verificar que ROADMAP.md tiene el WP linkeado.

---

## Fase a ejecutar: Phase 6 PLAN

Definir scope antes de estructurar previene scope creep.

> **Nota metodológica:** Phase 5 define el *cómo* (estrategia, alternativas, decisiones). Phase 6 define el *qué* (scope statement, in-scope y out-of-scope explícitos). Phase 5 orienta el scope, pero el scope formal es artefacto de Phase 6.

1. Brainstorm: ¿qué problema? ¿quiénes son los usuarios? ¿qué es éxito? ¿qué está fuera?

2. Verificar que el work package existe: `ls context/work/`
   - Si no existe → volver a Phase 1 antes de continuar
   - Para trabajo grande que agrupa múltiples features: usar `assets/epic.md.template`

3. REQUERIDO: Crear `work/.../plan/{nombre-wp}-plan.md` usando `assets/plan.md.template`:
   - Scope statement (problema + usuarios + criterios de éxito)
   - In-scope: lista explícita de lo que entra
   - Out-of-scope: lista explícita con razón de cada exclusión
   - Estimación de esfuerzo por componente
   - **REQUERIDO** antes de crear el plan: verificar que los archivos que se planea modificar existen en el repositorio. Si no existen → planificar "crear" no "modificar".

4. Actualizar ROADMAP.md con features y link al WP

5. Si el plan deriva de `analyze/` con RC formales:
   - REQUERIDO: incluir tabla de trazabilidad RC→tarea antes de presentar al usuario
   - Cada RC de prioridad Alta o Media debe tener al menos una fila
   - NO presentar el plan si la tabla está incompleta
   - Si no hay RC formales (trabajo mecánico) → omitir la tabla

6. Obtener aprobación del scope — NO declarar Phase 6 completa hasta confirmación explícita

**Nota DECOMPOSE:** Si el plan tiene RC con prioridades distintas (Alta/Media/Baja) → Phase 8 NO puede saltarse, independientemente del tamaño del WP.

---

## Validaciones pre-gate (TD-029, TD-031, TD-033)

Antes de presentar el gate 6→7:
- **TD-031 deep review**: revisar `{nombre-wp}-solution-strategy.md` de Phase 5 — ¿el scope refleja todas las decisiones?
- **TD-029 criterios**: `{nombre-wp}-plan.md` existe · ROADMAP.md tiene el WP · scope sin ambigüedades pendientes
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes de commits y gates

---

## Gate humano

⏸ STOP — Presentar scope statement (problema, in-scope, out-of-scope, criterios de éxito) al usuario.
Esperar confirmación explícita. NO continuar sin respuesta.
Al aprobar:
1. Actualizar `context/now.md::phase` a `Phase 7`
2. Actualizar `{nombre-wp}-plan.md::status` a `Aprobado — {fecha}`
3. Marcar `[x] Scope aprobado por usuario — {fecha}` en `{nombre-wp}-plan.md`

---

## Exit criteria

Phase 6 completa cuando:
- `work/.../plan/{nombre-wp}-plan.md` existe con `[x] Scope aprobado`
- ROADMAP.md tiene el WP linkeado
- Si hay RC formales: tabla de trazabilidad RC→tarea incluida, cada RC Alta/Media con tarea asignada
- Usuario confirmó el scope explícitamente en esta sesión

**Detectar:** Si `work/.../*-plan.md` existe con `[x] Scope aprobado`, Phase 6 ya completó.
Al terminar: proponer `/thyrox:design` para Phase 7.
