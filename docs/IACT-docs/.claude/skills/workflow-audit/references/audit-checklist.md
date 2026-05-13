---
name: audit-checklist
description: Checklist detallado de qué verificar por dimensión en cada auditoría de WP.
updated_at: 2026-04-17 22:01:55
---

# Audit Checklist — Por dimensión

Referencia para el auditor. Leer completo antes de iniciar la auditoría.

---

## Dimensión 1: Task Plan (30%)

### Cómo encontrar el task plan

```bash
find "$WP_DIR" -name "*task-plan*" -o -name "*plan-execution*" | head -5
# También puede estar en plan-execution/ subdirectory
find "$WP_DIR" -path "*/plan-execution/*task-plan*" | head -3
```

### Ítems a verificar

| Ítem | PASS | FAIL | PARTIAL |
|------|------|------|---------|
| Task plan existe | Archivo `*-task-plan.md` encontrado | No encontrado | — |
| Todos los T-NNN tienen estado | Todos `[x]` o `[ ]` con razón documentada | T-NNN sin checkbox | Algunos sin estado |
| T-NNN `[x]` tienen evidencia | Archivo, commit, o cambio observable existe | No existe nada para el T | Cambio parcial |
| T-NNN `[ ]` tienen justificación | Marcado como SKIP con razón, o documentado como pendiente | Sin razón clara | — |
| Numeración continua | T-001, T-002… sin saltos inexplicables | Saltos sin ADR | Saltos con nota |

### Señales de PARTIAL en task plan

- T-NNN marcado `[x]` pero el archivo tiene contenido placeholder (`TODO`, `[YYYY-MM-DD]`)
- T-NNN marcado `[x]` pero el commit correspondiente no existe en `git log`
- T-NNN marcado `[ ]` que debería estar completado según el contexto del WP

---

## Dimensión 2: Artifacts (25%)

### Artefactos por tipo de WP

**WP completo (Stages 1-12):**

| Artefacto | Path esperado | Obligatorio |
|-----------|--------------|-------------|
| Analysis/Discover | `discover/{wp}-analysis.md` | Sí |
| Risk register | `{wp}-risk-register.md` | Sí (mediano/grande) |
| Exit conditions | `{wp}-exit-conditions.md` | Sí (mediano/grande) |
| Task plan | `plan-execution/{wp}-task-plan.md` | Sí |
| Execution log | `execute/{wp}-execution-log.md` | Sí |
| Lessons learned | `track/{wp}-lessons-learned.md` | Sí |
| WP changelog | `track/{wp}-changelog.md` | Sí |

### Verificar naming

```bash
# Listar todos los artefactos del WP
find "$WP_DIR" -name "*.md" | sort
```

**Patrones correctos:**
- Síntesis: `{wp-name}-{tipo}.md` (con prefijo del WP)
- Sub-análisis: `{contenido}-{subtipo}.md` (sin prefijo del WP)
- Stage directory correcto según fase

**Anti-patrones a detectar:**

| Anti-patrón | Descripción | Veredicto |
|-------------|-------------|-----------|
| `final-validation.md` | Término temporal en nombre | PARTIAL |
| `analysis-v2.md` | Versión en nombre de archivo | PARTIAL |
| `deep-review-*.md` | Tipo al principio del nombre | PARTIAL |
| Archivo en directorio equivocado | `track/` contiene análisis | PARTIAL |

### Verificar metadata

Para cada archivo `.md` en el WP:

```bash
head -10 "$FILE"
```

**Campos obligatorios en bloques `yml`:**

| Campo | Formato | Aplica a |
|-------|---------|----------|
| `created_at` | `YYYY-MM-DD HH:MM:SS` | Todos |
| `project` | Nombre del proyecto | Todos |
| `author` | Nombre del autor | Todos |
| `status` | `Borrador` \| `Aprobado` | Todos |
| `phase` | `Phase N — PHASE_NAME` | Stage directories |

**Anti-patrón crítico:** usar `---` YAML frontmatter en lugar de bloques ` ```yml ``` ` → FAIL.

---

## Dimensión 3: Commits (20%)

### Cómo obtener commits del WP

```bash
# Commits desde creación del WP (aproximado — últimos 50)
git log --oneline -50
# Con más detalle
git log --format="%H %s" -50
```

### Verificar conventional commits

**Formato:** `type(scope): description`

| Verificación | PASS | FAIL |
|-------------|------|------|
| Tiene `type(scope):` | `feat(wp-name): ...` | `"update"`, `"WIP"`, sin scope |
| Tipo válido | `feat/fix/refactor/docs/chore/test/perf` | Tipo inventado |
| Scope relevante | Coincide con WP o componente | Scope genérico o vacío |
| Descripción informativa | Describe el cambio claramente | `"changes"`, `"stuff"`, `"misc"` |
| Sin punto final | `feat(x): add feature` | `feat(x): add feature.` |
| ≤72 caracteres | Subject line corta | Subject > 72 chars |

### Señales de PARTIAL en commits

- Scope correcto pero descripción vaga
- Tipo `docs` para cambios que en realidad son `feat`
- Múltiples cambios no relacionados en un solo commit

---

## Dimensión 4: Scripts (15%)

### Encontrar scripts del WP

```bash
# Scripts creados o modificados en el WP
git log --name-only --format="" -50 | grep "\.sh$" | sort -u
# Scripts existentes en el proyecto
find .claude/scripts/ .claude/skills/*/scripts/ -name "*.sh" | head -20
```

### Verificar cada script

```bash
# Verificar sintaxis
bash -n "$SCRIPT" && echo "PASS" || echo "FAIL: syntax error"

# Verificar shebang
head -1 "$SCRIPT"

# Verificar permisos
ls -la "$SCRIPT"
```

| Verificación | PASS | FAIL |
|-------------|------|------|
| Shebang presente | `#!/bin/bash` o `#!/usr/bin/env bash` | Sin shebang |
| Sintaxis válida | `bash -n script.sh` → 0 | exit code != 0 |
| Ejecutable | `-rwxr-xr-x` | `-rw-r--r--` |
| Sin hardcoded paths | Usa `PROJECT_ROOT` o `$(dirname ...)` | `/home/user/...` literal |
| `sed -i` compatible | `sed -i'' -e 's/...'` | `sed -i 's/...'` (falla en BSD) |
| Variables entre comillas | `"$VAR"` | `$VAR` en contextos con espacios |

---

## Dimensión 5: State (10%)

### Verificar now.md

```bash
cat .thyrox/context/now.md | head -15
```

| Campo | Correcto | Incorrecto |
|-------|---------|------------|
| `current_work` | Path del WP activo o `null` | WP ya cerrado pero aún activo |
| `stage` | Stage actual del WP | Stage de un WP anterior |
| `flow` | Metodología activa o `null` | Flow de WP anterior |
| `methodology_step` | Paso `{ns}:{step}` o `null` | Step inválido para el flow |
| `updated_at` | Timestamp reciente | Fecha antigua sin actualizar |

### Verificar ROADMAP.md

```bash
grep -A 10 "$(basename $WP_DIR | sed 's/.*-//')" ROADMAP.md | head -15
```

- ¿El WP aparece en ROADMAP?
- ¿Los stages completados tienen `[x]`?
- ¿El WP tiene fecha si está completado?

### Verificar focus.md

```bash
cat .thyrox/context/focus.md
```

- ¿Refleja el estado actual del WP?
- ¿"Completado" lista lo realmente completado en este WP?

---

## Notas para el auditor

- **SKIP** se usa solo para tareas explícitamente marcadas como opcionales en el task plan, o para dimensiones que no aplican al WP (ej: WP sin scripts → Dimensión 4 = SKIP).
- **Hallazgo sistémico** — si el mismo error aparece en 3+ ítems del mismo tipo, documentarlo como patrón, no como 3 FAILs individuales.
- **Drift positivo** — trabajo implementado fuera del task plan que aporta valor. No es FAIL, pero debe documentarse.
- **Drift negativo** — trabajo en el task plan no implementado, marcado `[x]` sin evidencia. Es FAIL directo.
