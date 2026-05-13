---
name: workflow-decompose
description: "Use when breaking down approved specs into atomic executable tasks. Phase 8 PLAN EXECUTION — produce task-plan.md con T-NNN, DAG de dependencias y trazabilidad SPEC→tarea."
allowed-tools: Read Glob Grep Bash Write Edit
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 8'"
updated_at: 2026-04-20 13:51:04
---

# /workflow-decompose — Phase 8: PLAN EXECUTION

Inicia o retoma Phase 8 PLAN EXECUTION del work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer `*-requirements-spec.md` del WP para obtener los SPECs
3. Leer `context/now.md` — verificar `phase`
4. Verificar si ya existe `*-task-plan.md` con checkboxes `- [ ] [T-NNN]`:
   - Si existe → Phase 8 ya completó. Proponer `/thyrox:execute`.

---

## Fase a ejecutar: Phase 8 PLAN EXECUTION

Tareas atómicas con trazabilidad previenen trabajo duplicado o perdido.

1. Leer `work/.../*-requirements-spec.md` del WP activo
   - Si el usuario pide descomposición directa sin spec previo: crear WP y descomponer desde la descripción — no cuestionar si el proyecto existe

2. REQUERIDO: Crear `work/../plan-execution/{nombre-descriptivo}-task-plan.md` usando `assets/plan-execution.md.template`
   - Nombre descriptivo: `skill-activation-task-plan.md`, no `task-plan.md`
   - Cajón: `plan-execution/` (Phase 8). Los planes estratégicos van en `plan/` — son distintos.
   - Si existe `plan/` con un plan de nivel superior, referenciar en el frontmatter como `Generado desde:`

3. Crear lista de tareas con IDs trazables:
   ```
   - [ ] [T-NNN] Descripción de la tarea (SPEC-N)
   - [ ] [T-NNN] [P] Tarea paralelizable (SPEC-N)
   ```
   Cada tarea necesita ID + referencia a su requisito — permite detectar tareas huérfanas.

4. Marcar tareas paralelas `[P]`
   - En ejecución paralela: usar `[~]` para reclamar tareas antes de ejecutarlas
   - Ver [conventions — parallel-agent-execution](../../references/conventions.md#parallel-agent-execution)

5. Definir checkpoints de validación por grupo de tareas
   - Si hay >50 issues: usar `assets/categorization-plan.md.template` para categorizar primero

6. Incluir en el task-plan:
   - **DAG de dependencias** en Mermaid — qué bloquea qué
   - **Fases de ejecución** agrupadas lógicamente
   - **Cobertura SPEC→Task** — tabla de trazabilidad inversa

7. **Verificar atomicidad antes de presentar al usuario:**
   - [ ] Cada tarea toca exactamente 1 ubicación (1 archivo O 1 sección de 1 archivo)
   - [ ] Ninguna descripción de tarea contiene "y" conectando dos operaciones distintas
   - [ ] Cada tarea puede commitearse y marcarse [x] de forma independiente
   Si algún ítem falla: descomponer la tarea infractora antes de continuar.

---

## Validaciones pre-gate (TD-029, TD-031, TD-033)

Antes de presentar el gate 8→9/10:
- **TD-031 deep review**: revisar `{nombre-wp}-requirements-spec.md` de Phase 7 — ¿el task-plan cubre TODO lo especificado? ¿hay SPECs sin tareas?
- **TD-029 criterios**: task-plan.md con checkboxes · DAG documentado · atomicidad verificada · cobertura SPEC→tarea 100%
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes de commits y gates

## Gate humano

⏸ GATE CRÍTICO — STOP obligatorio antes de ejecutar.
Presentar el task-plan completo con TODAS las tareas listadas.
Esperar confirmación explícita. Este gate NO tiene excepciones.
Razón: Phase 10 modifica el repositorio — el usuario debe aprobar antes de que se ejecute.
Al aprobar: actualizar `context/now.md::phase` a `Phase 9` (si hay supuestos de alto riesgo que validar) o `Phase 10` (ejecución directa).

---

## Exit criteria

Phase 8 completa cuando:
- `work/.../plan-execution/*-task-plan.md` existe usando `plan-execution.md.template`, con checkboxes `- [ ] [T-NNN]`
- Todas las tareas tienen referencia a su SPEC
- DAG de dependencias documentado en Mermaid
- Atomicidad verificada (3 ítems del checklist)
- Usuario aprobó el plan explícitamente en esta sesión

**Detectar:** Si `work/.../plan-execution/*-task-plan.md` tiene checkboxes `- [ ] [T-NNN]`, Phase 8 ya completó.
Al terminar: proponer `/thyrox:pilot` para Phase 9 (riesgo técnico alto) o `/thyrox:execute` para Phase 10.

---

## Referencias de calibración

> Para análisis de flujos agentic con calibración real (6 patrones operacionales con evidencia de sesión): ver `.claude/references/agentic-calibration-workflow-example.md`
