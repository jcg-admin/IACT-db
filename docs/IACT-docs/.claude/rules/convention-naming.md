```yml
type: Convención de Proyecto
category: Naming y Estructura de Archivos
version: 1.0.0
purpose: Define reglas de nombres para archivos, directorios, y identifiers
updated_at: 2026-04-22 21:20:00
applies_to: IACT-docs v1.0.0+
```

# CONVENCIÓN: NAMING — Nombres de Archivos y Directorios

## Principio Core

**NO usar prefijos numéricos en nombres de archivos.**

Los números pertenecen a:
- Versiones semánticas (en YAML frontmatter)
- IDs de tracking (UC-001, ADR-001, etc. en contenido)
- Timestamps (YYYY-MM-DD-HH-MM-SS en directorios de Work Packages)

**NO pertenecen a:**
- Nombres de archivos (NO: 01-file.md, 02-file.md)
- Nombres de directorios (NO: 01-feature/, 02-feature/)

---

## Reglas de Naming

### 1. Archivos de Documentación

**Formato:** `{descripcion-en-kebab-case}.md`

Ejemplos correctos:
- `problem-statement.md`
- `actors-stakeholders.md`
- `use-case-matrix.md`
- `deployment-strategy.md`
- `security-considerations.md`

Ejemplos INCORRECTOS:
- `01-problem-statement.md` ← ❌ NO prefijo numérico
- `2-actors-stakeholders.md` ← ❌ NO prefijo numérico
- `actors_and_stakeholders.md` ← ⚠ Usar kebab-case, no snake_case

---

### 2. Architecture Decision Records (ADRs)

**Formato:** `adr-{tema-en-kebab-case}.md`

Ejemplos:
- `adr-validation-strategy.md`
- `adr-error-handling.md`
- `adr-idempotence-approach.md`
- `adr-logging-format.md`

**Ubicación:** `.thyrox/context/decisions/`

Nunca: `adr-001.md`, `adr-1-validation.md`

---

### 3. Error Tracking

**Formato:** `{descripcion-error}.md`

Ejemplos:
- `offline-download-failure.md`
- `validation-timeout.md`
- `configuration-malformed.md`

**Ubicación:** `.thyrox/context/errors/`

---

### 4. Work Packages (Directorios)

**Formato:** `YYYY-MM-DD-HH-MM-SS-{nombre-en-kebab-case}`

Ejemplos:
- `2026-04-21-01-30-00-uc-documentation`
- `2026-04-22-14-00-00-phase1-discover-iact-docs`
- `2026-04-25-09-30-00-phase2-baseline`

**Ubicación:** `.thyrox/context/work/`

**Nota:** Timestamp OBLIGATORIO (precisión hasta segundos), nunca omitir.

---

### 5. Archivos dentro de Work Packages

**Formato:** `{tipo-artefacto}.md`

Ejemplos en Work Package:
- `wp-state.md` (metadata del WP)
- `input.md` (entrada para análisis)
- `deep-dive.md` (análisis adversarial)
- `calibration.md` (evaluación epistémica)

**NUNCA:**
- `01-wp-state.md` ← ❌
- `1-input.md` ← ❌

---

### 6. Directorios de Dominio (source/)

**Formato:** `{dominio-en-kebab-case}/`

Ejemplos:
- `requisitos/`
- `arquitectura_tecnica/`
- `base_cognitiva/`
- `normativa/`
- `gestion/`

**Nota:** Mantener consistencia con estructura Sphinx RST existente.

---

### 7. Archivos dentro de directorios de dominio

**Formato:** `{aspecto}.md` o `{aspecto}.rst`

Ejemplos en `requisitos/`:
- `index.rst`
- `funcionales.md`
- `no-funcionales.md`
- `casos-uso.md`

**NUNCA:**
- `01-funcionales.md` ← ❌
- `1-casos-uso.md` ← ❌

---

## Casos Edge

### Nombres muy similares
Si necesitas diferenciar archivos similares, usa prefijos conceptuales, NO números:

✓ Correcto:
- `analysis-current-state.md`
- `analysis-proposed-state.md`

❌ Incorrecto:
- `01-analysis.md`
- `02-analysis.md`

---

### Secuencia ordenada
Si documentas una secuencia de pasos, NO números en filenames:

✓ Correcto:
- `setup-environment.md`
- `configure-sphinx.md`
- `run-build.md`

❌ Incorrecto:
- `01-setup.md`
- `02-configure.md`
- `03-run.md`

**Alternativa:** Usar numeración DENTRO del contenido del archivo.

---

## RESUMEN

| Tipo | Patrón | Ejemplo | Ubicación |
|------|--------|---------|-----------|
| Documentación | `{desc}.md` | `problem-statement.md` | Flexible |
| ADR | `adr-{tema}.md` | `adr-idempotence.md` | `.thyrox/context/decisions/` |
| Error | `{desc}.md` | `offline-failure.md` | `.thyrox/context/errors/` |
| Work Package | `YYYY-MM-DD-HH-MM-SS-{nombre}` | `2026-04-22-21-15-30-phase1-discover` | `.thyrox/context/work/` |
| Archivo WP | `{tipo}.md` | `wp-state.md`, `input.md` | `.thyrox/context/work/{WP}/` |
| Dominio | `{dominio}/` | `requisitos/`, `arquitectura_tecnica/` | `source/` |
| Archivo dominio | `{aspecto}.md` | `funcionales.md` | `source/{dominio}/` |

---

## Verificación

Antes de commitear, verifica que NO haya archivos con estos patrones:

```bash
# NO debería haber archivos con prefijos numéricos
find . -name "0[0-9]-*.md"
find . -name "[0-9]-*.md"
find . -name "[0-9][0-9]-*.md"

# Si encuentra algo, renombra sin el prefijo numérico
mv 01-file.md file.md
```

---

Esta convención asegura:
- Consistencia en toda la base de código
- Alineación con THYROX conventions
- Claridad: números solo donde significan IDs (UC-001, ADR-001) o timestamps
- Flexibilidad: orden se maneja en contenido, no en filenames
