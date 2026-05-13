---
name: workflow-track
description: "Use when evaluating results and closing a work package after execution. Phase 11 TRACK/EVALUATE — evalúa resultados vs baseline MEASURE, documenta lecciones aprendidas y genera changelog."
allowed-tools: Read Glob Grep Bash Write Edit
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 11'"
updated_at: 2026-04-20 13:53:09
---

# /workflow-track — Phase 11: TRACK/EVALUATE

Documenta lecciones aprendidas, genera changelog, y cierra el work package activo.

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Revisar progreso: `bash .claude/scripts/project-status.sh`
3. Verificar que todas las tareas están `[x]` en `*-task-plan.md`
4. Leer `context/now.md` — verificar `phase`
5. Gate soft: `bash .claude/skills/workflow-track/scripts/validate-phase-readiness.sh 11`

---

## Fase a ejecutar: Phase 11 TRACK/EVALUATE

Documentar lecciones previene repetir los mismos errores.

**En ejecución paralela:** Phase 7 es single-agent por diseño. El coordinador consolida lecciones de todos los WPs, actualiza ROADMAP y CHANGELOG como único escritor, y cierra los `now-{agent-id}.md` de todos los agentes.

**REQUERIDO — Artefactos a crear:**

1. REQUERIDO: `work/../{nombre-wp}-lessons-learned.md` usando `assets/lessons-learned.md.template`
   - Nombre descriptivo: `skill-activation-lessons-learned.md`, no `lessons-learned.md`
   - Qué salió bien, qué salió mal, qué haría diferente
   - Patrones reutilizables identificados
   - Errores encontrados y cómo se resolvieron

2. REQUERIDO: Generar `work/../{nombre-wp}-changelog.md` desde commits usando `assets/wp-changelog.md.template` — [D2]
   - Formato Keep a Changelog adaptado a WPs
   - Agrupar por tipo: Added, Changed, Fixed, Removed
   - NOTA: `CHANGELOG.md` (raíz) se actualiza SOLO en releases (cuando hay bump de versión)

**PAT-004 — Checkbox-at-commit:** Al hacer el commit que completa T-NNN, incluir en ese mismo commit el `[x]` en el task-plan. Nunca acumular checkboxes para una "sesión de auditoría" posterior — el drift crece exponencialmente con task-plans activos simultáneos.

**Deuda epistémica — paso obligatorio de evaluación:**
Antes de crear lessons-learned, revisar todos los stages anteriores del WP e identificar claims heredados que nunca se re-verificaron en ningún stage posterior. Listarlos en lessons-learned bajo la sección "Deuda epistémica":
- Claim heredado: texto del claim original
- Origen: Stage donde fue generado
- Estado: `nunca-reverificado` | `descartado-en-stage-N` | `confirmado-en-stage-N`
- Acción recomendada: convertir en TD si sigue siendo relevante, o documentar como descartado

Este paso implementa el `context_pruning_rule` del gate Stage 11→12 en exit-conditions.md.template.

3. Actualizar `work/../{nombre-wp}-risk-register.md`:
   - Cerrar riesgos que no se materializaron
   - Documentar los que sí ocurrieron con su impacto real

4. Si hay TDs cerrados o archivados en este WP: crear `work/../{nombre-wp}-technical-debt-resolved.md` usando `assets/technical-debt-resolved.md.template` — [D3]
   - Incluir TDs marcados `[x]` (cerrados en este WP)
   - Incluir TDs marcados `[-]` movidos desde `technical-debt.md` por REGLA-LONGEV-001
   - Eliminar esas entradas de `technical-debt.md` después de moverlas

5. Para proyectos grandes o con métricas relevantes: crear `{nombre-wp}-final-report.md` usando `assets/final-report.md.template`

6. Para deuda técnica identificada: usar `assets/refactors.md.template`

**Validaciones de cierre:**
```bash
bash .claude/scripts/validate-session-close.sh
bash .claude/scripts/project-status.sh
```

**REQUERIDO al cerrar WP — actualizar archivos de estado:**

| Archivo | Contenido mínimo requerido |
|---------|---------------------------|
| `context/now.md` | Ejecutar: `bash .claude/scripts/close-wp.sh` (setea phase y current_work a null) |
| `context/focus.md` | `## Completado`: FASE N + WP + qué se logró. `## Sin WP activo`: versión actual + próximo en ROADMAP |
| `context/project-state.md` | Ejecutar `bash .claude/scripts/update-state.sh` |

Ver [state-management](../../references/state-management.md) para tabla de triggers completa.

---

## Gate humano

⏸ STOP — Presentar resumen de Phase 11: artefactos creados, lecciones clave, métricas vs baseline.
Esperar confirmación explícita antes de transicionar a Phase 12 STANDARDIZE.
Razón: Phase 12 propaga cambios al sistema — el usuario debe confirmar el cierre del WP.
Al aprobar:
1. Actualizar `context/now.md::phase` a `Phase 12`
2. Ejecutar `bash .claude/scripts/close-wp.sh` — setea estado de cierre

---

## Validaciones pre-cierre (TD-029, TD-031, TD-033)

Antes de marcar Phase 11 completa:
- **TD-031 deep review**: revisar pre-flight de Phase 10 — ¿`validate-session-close.sh` pasa? ¿todos los artefactos existen?
- **TD-029 criterios**: lessons-learned · {wp}-changelog · risk-register actualizado · TDs movidos si aplica · estado actualizado
- **TD-033 now.md**: `git add .thyrox/context/now.md` antes del commit de cierre de FASE

---

## Exit criteria

Phase 11 completa cuando:
- `work/.../track/{nombre-wp}-lessons-learned.md` existe
- `work/.../track/{nombre-wp}-changelog.md` creado (CHANGELOG.md raíz solo si hay release)
- `{nombre-wp}-risk-register.md` actualizado
- Si hubo TDs cerrados: `work/.../track/{nombre-wp}-technical-debt-resolved.md` creado
- `validate-session-close.sh` pasa sin errores
- Archivos de estado actualizados: `now.md`, `focus.md`, `project-state.md`
- No quedaron archivos temporales fuera de `context/work/`

**Transition → Phase 12 STANDARDIZE**: proponer `/thyrox:standardize` para cerrar el WP definitivamente.
**La FASE cierra cuando Phase 12 STANDARDIZE completa** — `now.md::phase` → `null`, `now.md::current_work` → `null`.
Una nueva FASE empieza cuando se crea un nuevo WP (nuevo directorio en `context/work/`).
