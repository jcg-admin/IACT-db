---
name: workflow-audit
description: "Use when verifying that ALL work in a WP was completed correctly before closing. Critical auditor — evaluates task plan completion, artifact existence and naming, metadata standards, commit hygiene, and state consistency. Produces a scored audit-report.md with PASS/FAIL/PARTIAL per item and an ordered action plan."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
effort: medium
hooks:
  - event: UserPromptSubmit
    once: true
    type: command
    command: "bash .claude/scripts/set-session-phase.sh 'Phase 11'"
updated_at: 2026-04-17 22:01:55
---

# /workflow-audit — Auditor crítico de work packages

Verifica que el trabajo de un WP fue realizado correctamente. Emite un reporte con score y action plan. **No corrige — documenta.**

---

## Cuándo usar

- Antes de Stage 12 STANDARDIZE (gate de calidad)
- Cuando el ejecutor pide "audita el WP" / "verifica el trabajo" / "revisa que todo esté correcto"
- Después de una sesión larga con muchos cambios o múltiples agentes

---

## Contexto de sesión

1. Identificar WP activo: `ls -t .thyrox/context/work/ | head -1`
2. Leer el task plan del WP: `find "$WP_DIR" -name "*task-plan*" | head -5`
3. Revisar commits del WP: `git log --oneline --since="$(cat $WP_DIR/... created_at)" 2>/dev/null | head -30`
4. Leer `references/audit-checklist.md` completo antes de empezar
5. Leer `references/audit-scoring.md` para criterios de clasificación

---

## Proceso de auditoría

### Paso 0 — Identificar scope

```bash
WP_DIR=$(ls -td .thyrox/context/work/*/ | head -1)
WP_NAME=$(basename "$WP_DIR")
echo "Auditando: $WP_NAME"
```

Leer:
- Task plan: todos los T-NNN con su estado `[ ]` / `[x]`
- Artefactos existentes en el WP
- Commits desde la creación del WP

### Paso 1 — Auditar task plan (30%)

Para cada T-NNN en el task plan:
- `[x]` → verificar que el trabajo existe realmente (archivo, commit, o cambio observable)
- `[ ]` → verificar si era opcional (SKIP) o está incompleto (FAIL)
- Tarea no en el plan pero implementada → documentar como drift positivo o negativo

Ver `references/audit-checklist.md` sección "Task Plan".

### Paso 2 — Auditar artefactos (25%)

Para cada artefacto esperado según las fases del WP:
- ¿Existe en el path correcto?
- ¿El nombre sigue el patrón `{wp-name}-{tipo}.md` para síntesis, o `{contenido}-{subtipo}.md` para sub-análisis?
- ¿El metadata usa bloques `yml` (no YAML frontmatter `---`)?
- ¿Los campos obligatorios están presentes? (`created_at`, `project`, `author`, `status`)

Ver `references/audit-checklist.md` sección "Artifacts".

### Paso 3 — Auditar commits (20%)

Para cada commit del WP:
- ¿Sigue `type(scope): description`?
- ¿El scope corresponde al WP o componente afectado?
- ¿La descripción es informativa (no "update", "fix stuff", "WIP")?
- ¿Los archivos staged corresponden al scope declarado?

Ver `references/audit-checklist.md` sección "Commits".

### Paso 4 — Auditar scripts (15%)

Para cada script creado o modificado en el WP:
- ¿Tiene `#!/bin/bash` o `#!/usr/bin/env bash`?
- ¿Tiene `chmod +x`?
- ¿Usa paths relativos a `PROJECT_ROOT` (no hardcodeados)?
- ¿La sintaxis bash es válida? (`bash -n script.sh`)
- ¿Los `sed -i` usan `sed -i'' -e` para compatibilidad BSD/GNU?

Ver `references/audit-checklist.md` sección "Scripts".

### Paso 5 — Auditar estado (10%)

- `now.md`: ¿`current_work`, `stage`, `flow`, `methodology_step` son consistentes con el WP?
- `focus.md`: ¿refleja el estado real del proyecto?
- `ROADMAP.md`: ¿el WP aparece con stages correctamente marcados?
- `technical-debt.md`: ¿los TDs cerrados en el WP están marcados `[x]`?

Ver `references/audit-checklist.md` sección "State".

### Paso 6 — Calcular score y generar reporte

```
Score = Σ(items PASS + 0.5×items PARTIAL) / Σ(items totales) × 100

GRADE A: 90-100%  — WP excelente
GRADE B: 75-89%   — WP aceptable, issues menores
GRADE C: 60-74%   — WP con gaps, revisión recomendada
GRADE F: < 60%    — WP deficiente, revisión obligatoria
```

Crear `work/../{nombre-wp}-audit-report.md` usando `assets/audit-report.md.template`.

---

## Reglas del auditor

1. **Verificar — no inferir.** Si el archivo no existe en el path esperado, es FAIL. No asumir que está "en otro lado".
2. **Evidencia obligatoria.** Cada ítem FAIL o PARTIAL debe citar el path o commit que falta.
3. **No corregir.** El auditor documenta. La corrección es una tarea separada del ejecutor.
4. **Ser exhaustivo.** Revisar TODOS los T-NNN, no solo los últimos.
5. **Distinguir SKIP de FAIL.** Una tarea marcada `[ ]` que era opcional es SKIP. Una que era requerida es FAIL.
6. **PAT-001 en auditoría:** Si se descubren patrones de error recurrentes, documentarlos como "Hallazgo sistémico" — no solo como instancias individuales.

---

## Output esperado

Al finalizar la auditoría:

```
work/{wp}/
└── track/
    └── {nombre-wp}-audit-report.md    ← Reporte completo con score y action plan
```

El reporte va en `track/` (Stage 11) siguiendo la taxonomía de stage directories.

---

## Exit criteria

- `{nombre-wp}-audit-report.md` creado en `track/`
- Score calculado y grade asignado
- Todos los items FAIL tienen evidencia y corrección sugerida
- Action plan ordenado por prioridad

⏸ **STOP — Gate Stage 11→12:** Presentar reporte al ejecutor. Si hay FAILs, el ejecutor decide si corregir antes de STANDARDIZE o aceptar los gaps documentados. Continuar SOLO con aprobación explícita.
