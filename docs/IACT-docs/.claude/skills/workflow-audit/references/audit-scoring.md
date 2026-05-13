---
name: audit-scoring
description: Criterios de clasificación PASS/FAIL/PARTIAL/SKIP con ejemplos y fórmula de scoring.
updated_at: 2026-04-17 22:01:55
---

# Audit Scoring — Criterios y ejemplos

---

## Clasificadores

| Clasificador | Símbolo | Criterio | Cuenta como |
|-------------|---------|---------|------------|
| **PASS** | ✅ | Existe, correcto, cumple spec | 1.0 punto |
| **PARTIAL** | ⚠️ | Existe pero incompleto o con problema menor | 0.5 puntos |
| **FAIL** | ❌ | No existe, malformado, o contradice spec | 0.0 puntos |
| **SKIP** | ⏭️ | No aplica al WP / era opcional | Excluido del cálculo |

---

## Fórmula de scoring

```
Score = Σ(PASS × 1.0 + PARTIAL × 0.5) / Σ(total items - SKIP) × 100
```

**Ejemplo:**
- 10 PASS, 3 PARTIAL, 2 FAIL, 1 SKIP
- Score = (10×1.0 + 3×0.5) / (10+3+2) × 100 = 11.5/15 × 100 = **76.7% — GRADE B**

---

## Grades

| Grade | Score | Interpretación | Acción |
|-------|-------|---------------|--------|
| **A** | 90-100% | WP excelente — todos los requisitos cumplidos | Puede cerrar directamente |
| **B** | 75-89% | WP aceptable — issues menores documentados | Cerrar con action plan |
| **C** | 60-74% | WP con gaps — revisión recomendada antes de cerrar | Corregir FAILs críticos primero |
| **F** | < 60% | WP deficiente — revisión obligatoria | No cerrar sin corrección |

---

## Ejemplos por clasificador

### ✅ PASS

```markdown
- T-001: close-wp.sh creado
  Evidencia: .claude/scripts/close-wp.sh — 45 líneas, chmod +x ✓, bash -n ✓
  Veredicto: ✅ PASS
```

```markdown
- Artifact: goto-problem-fix-analysis.md
  Path: discover/goto-problem-fix-analysis.md ✓
  Metadata: created_at, project, author, status presentes ✓
  Naming: síntesis con prefijo WP ✓
  Veredicto: ✅ PASS
```

### ⚠️ PARTIAL

```markdown
- T-007: README.md — 9 fixes aplicados
  Evidencia: README.md existe, 6/9 fixes verificables en git diff
  Gaps: Fix B-4 (comandos removidos) no aparece en diff — posible merge
  Veredicto: ⚠️ PARTIAL — 6/9 fixes verificados
```

```markdown
- Commit: "docs(goto-problem-fix): update state management"
  Tipo y scope correctos ✓
  Descripción: vaga — no especifica qué cambió ⚠️
  Veredicto: ⚠️ PARTIAL — scope OK, descripción mejorable
```

```markdown
- Artifact: lessons-learned.md
  Path: track/goto-problem-fix-lessons-learned.md ✓
  Metadata: created_at, author presentes ✓
  Contenido: sección "Qué haría diferente" vacía (placeholder: "TODO")
  Veredicto: ⚠️ PARTIAL — estructura OK, contenido incompleto
```

### ❌ FAIL

```markdown
- T-015: session-resume.sh — fix stage: fallback
  Evidencia: archivo existe, pero línea 36 aún usa grep original sin fallback
  git log: no hay commit con "session-resume" en los últimos 50
  Veredicto: ❌ FAIL — T-015 marcado [x] sin implementación
```

```markdown
- Artifact: goto-problem-fix-task-plan.md
  Path esperado: plan-execution/goto-problem-fix-task-plan.md
  Encontrado: ningún archivo *task-plan* en el WP
  Veredicto: ❌ FAIL — artefacto requerido faltante
```

```markdown
- Script: close-wp.sh metadata
  Shebang: #!/bin/bash ✓
  Sintaxis: bash -n → FAIL (línea 23: unexpected token)
  chmod: -rw-r--r-- (no ejecutable)
  Veredicto: ❌ FAIL — script con errores de sintaxis y sin permisos
```

### ⏭️ SKIP

```markdown
- Dimensión 4 (Scripts): Este WP no creó ni modificó scripts
  Veredicto: ⏭️ SKIP — dimensión excluida del score
```

```markdown
- T-012: Crear design.md (marcado opcional en task plan)
  Razón: WP pequeño — task plan indica "omitir si WP < 5 tareas"
  Veredicto: ⏭️ SKIP — tarea explícitamente opcional
```

---

## Hallazgos sistémicos

Cuando el mismo error aparece en 3+ ítems del mismo tipo, consolidar como hallazgo sistémico:

```markdown
### ⚠️ Hallazgo sistémico — Metadata incompleta

5 de 8 artefactos del WP tienen `status: Borrador` sin actualizar a `Aprobado`
después de pasar el gate correspondiente.

Archivos afectados:
- discover/goto-problem-fix-analysis.md
- analyze/coverage/audit-coverage-review.md
- analyze/naming/naming-ishikawa.md
- plan-execution/goto-problem-fix-task-plan.md
- track/goto-problem-fix-lessons-learned.md

Causa raíz probable: El proceso de gate no incluye actualizar `status` explícitamente.
Corrección sugerida: Actualizar status a `Aprobado` en cada artefacto al pasar su gate.
Mejora al framework: Agregar "actualizar status" al checklist de cada gate en workflow-*/SKILL.md.
```

---

## Drift de scope

### Drift positivo (informativo)

Trabajo implementado fuera del task plan que aporta valor. No penaliza el score.

```markdown
### ℹ️ Drift positivo — Trabajo adicional

- Se creó `analyze/audit-design/references-analysis.md` sin T-NNN correspondiente
  Evaluación: Trabajo de calidad que informa el diseño del skill — apropiado y valioso
  Acción: Agregar retroactivamente a task plan como T-026 [x] si el WP está abierto
```

### Drift negativo (FAIL)

T-NNN marcado `[x]` que no tiene evidencia real.

```markdown
### ❌ Drift negativo — T marcado sin implementación

- T-008 marcado [x]: "Actualizar ARCHITECTURE.md sección coordinators"
  git log: ningún commit con "ARCHITECTURE" en los últimos 30 commits
  Archivo: ARCHITECTURE.md sin sección "coordinators" (grep → 0 resultados)
  Veredicto: ❌ FAIL — checkbox marcado prematuramente
```

---

## Prioritización del action plan

Ordenar correcciones por impacto y urgencia:

| Prioridad | Tipo | Urgencia |
|-----------|------|---------|
| P1 — Crítico | FAIL en artefacto requerido o script con error de sintaxis | Bloquea cierre |
| P2 — Alto | FAIL en commit (misleading) o FAIL en state | Corregir antes de STANDARDIZE |
| P3 — Medio | PARTIAL en múltiples ítems del mismo tipo | Resolver en siguiente WP si es menor |
| P4 — Bajo | PARTIAL individual o hallazgo sistémico de proceso | Documentar como TD para framework |
