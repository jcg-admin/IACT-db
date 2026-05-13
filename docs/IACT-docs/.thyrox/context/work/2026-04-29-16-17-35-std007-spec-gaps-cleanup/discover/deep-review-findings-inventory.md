```yml
created_at: 2026-04-29 16:17:35
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Deep-Review Findings Inventory — F-01..F-12

## Calibración

- **OBSERVABLE:** 44 claims (todos los conteos via `find`/`grep`/`make`)
- **INFERRED:** 8 claims (clasificaciones MAJOR/INFO basadas en spec)
- **SPECULATIVE:** 0
- **Ratio (OBS+INF)/total:** 52/52 = 1.0 ≥ 0.75 ✓

## Tests pasados (no genera findings)

| Test | Resultado |
|------|-----------|
| Archivos `.rst` con uppercase/`_` | **0** ✓ |
| Directorios con uppercase/`_` (ex `_*`) | **0** ✓ |
| `.puml` con violación | **0** ✓ |
| Tildes/eñe/espacios/parens | **0** ✓ |
| Archivos > 100 chars | **0** ✓ |
| Filenames con versión (v1, 1-0-0) | **0** ✓ |
| Anchor labels con uppercase | **0** ✓ |
| Anchor labels duplicados | **0** ✓ |
| Refs `:doc:`/`:ref:` rotas | **0** ✓ |
| Archivos huérfanos (no en toctree) | **0** ✓ |
| Build `SPHINX_NITPICKY=1` | **0/0/0** ✓ |
| Patrones canónicos por prefijo (uc/br/breq/cnst/std/tpl/...) | **100%** ✓ |
| proc-gob 001-010 sin gaps/dups | ✓ |

## F-01 MAJOR — 9 archivos `procedimiento-*` mal clasificados

**Ubicación:** `source/normativa/procedimientos/`

```
procedimiento-analisis-seguridad.rst
procedimiento-desarrollo-local.rst
procedimiento-diseno-tecnico.rst
procedimiento-gestion-cambios.rst
procedimiento-instalacion-entorno.rst
procedimiento-qa.rst
procedimiento-release.rst
procedimiento-revision-documental.rst
procedimiento-trazabilidad-requisitos.rst
```

**Por qué es violación:** STD_007 §4 dice procedimientos usan
`proc-<MOD>-<NNN>-<desc>.rst`. Estos son procedimientos
(directorio + contenido) pero usan `procedimiento-<desc>` sin
módulo ni número.

**Reproducible:** `find source/normativa/procedimientos -name "procedimiento-*"`

**Propuesta de reclasificación:**

| Actual | Destino | MOD |
|--------|---------|-----|
| procedimiento-analisis-seguridad | proc-qa-003-analisis-seguridad | qa |
| procedimiento-desarrollo-local | proc-dev-003-desarrollo-local | dev |
| procedimiento-diseno-tecnico | proc-dev-004-diseno-tecnico | dev |
| procedimiento-gestion-cambios | proc-gob-011-gestion-cambios | gob |
| procedimiento-instalacion-entorno | proc-ops-003-instalacion-entorno | ops |
| procedimiento-qa | proc-qa-004-qa | qa |
| procedimiento-release | proc-devops-002-release | devops |
| procedimiento-revision-documental | proc-gob-012-revision-documental | gob |
| procedimiento-trazabilidad-requisitos | proc-req-019-trazabilidad-requisitos | req |

## F-02 MAJOR — 8 archivos `arq-mod-NNN-*` con prefijo no documentado

**Ubicación:** `source/arquitectura-tecnica/modulos/`

```
arq-mod-001-auth.rst        arq-mod-005-vis-reports.rst
arq-mod-002-user-identity.rst   arq-mod-006-alerts.rst
arq-mod-003-rbac-core.rst   arq-mod-007-audit.rst
arq-mod-004-etl-monitoring.rst  arq-mod-008-sys-logs.rst
```

**Por qué es violación:** STD_007 v2.0.1 §4 enumera taxativamente
los prefijos. `arq` no aparece. Como tienen `<NNN>`, no son guías
sin prefijo.

**Opciones de remediación:**

| Opción | Patrón | Pros | Contras |
|--------|--------|------|---------|
| **A** | `mod-NNN-<desc>.rst` | Prefijo de 3 letras simétrico con `mtm`/`txm` | Cambio físico: 8 renames + 8 ref updates |
| B | `arq-NNN-<desc>.rst` | Drop redundante "mod-" (dir ya dice modulos) | Renames + introducir prefijo `arq` en spec |
| C | Documentar `arq` en spec sin renombrar | 0 cambios físicos | Introduce prefijo de 3 letras + módulo ficticio "mod" |

**Recomendada:** Opción A.

## F-03 MAJOR — Módulos no documentados en STD_007 §4

| Prefijo | Módulos en uso | En spec | Faltan documentar |
|---------|----------------|---------|-------------------|
| `proc-` | dev, devops, doc, gob, ops, qa, req | ✅ todos | — |
| `proced-` | dev, devops, gob, qa | ✅ todos | — |
| `adr-` | back, devops, front, gob, qa | ⚠️ parcial | **back, front** |
| `rnf-` | proc | ❌ no documentado | **proc** |

**Reproducible:** `find source -name "adr-*" -exec basename {} \; | sed -E 's/^adr-([a-z]+)-.*/\1/' | sort -u`

**Propuesta:** STD_007 v2.0.1 → v2.0.2 (PATCH) extiende §4 con
tabla de módulos para `adr-` y `rnf-` (sin contradecir spec
existente).

## F-04 INFO — `:artefacto:` metadata mantiene PascalCase legacy

**Ejemplos:**

```
source/requisitos/index.rst:2: :artefacto: INDEX_REQUISITOS
source/requisitos/reglas-negocio/br-009-bajas-logicas.rst:2: :artefacto: BR_009
source/normativa/estandares/std-008-naming-identificadores.rst:2: :artefacto: STD_008
```

**Por qué NO es violación de STD_007:** §3 aplica a *archivos y
directorios*. El campo `:artefacto:` es un ID semántico (código
del artefacto), no un filename.

**Por qué es ambiguo:** STD_007 v2.0.1 §2 alcance NO clarifica
explícitamente que `:artefacto:` queda fuera de scope. Un
lector estricto podría interpretarlo como inconsistencia.

**Propuesta:** STD_007 v2.0.2 §2 agrega nota explícita:
"Esta convención NO aplica a campos de metadata YAML como
`:artefacto:`, `:tipo:`, etc. — éstos son códigos semánticos
del artefacto, conceptualmente independientes del filename."

## F-05 INFO — Duplicados de filename en distintos paths

```
conventions.rst   en frontend/ y backend/
overview.rst      en frontend/ y backend/
etl-pipeline.rst  en databases/ y plantuml-guide/ejemplos/
```

**Por qué NO es violación:** paths distintos resuelven sin
ambigüedad cuando refs son absolutas (`/frontend/conventions`).

**Por qué es deuda de claridad:** refs relativas (`conventions`)
son ambiguas. STD_007 actual no prohíbe ni regula.

**Propuesta:** STD_007 v2.0.2 §3 agrega regla "filenames únicos
en todo `source/`" — o documenta excepción para casos paralelos
intencionales (frontend/backend mirror).

## F-06 INFO — 3 guías sin prefijo en `normativa/estandares/`

```
source/normativa/estandares/guia-estilo.rst
source/normativa/estandares/estandares-codigo.rst
source/normativa/estandares/shell-scripting-guide.rst
```

**Por qué NO es violación de naming:** kebab-lowercase OK.

**Por qué es deuda categorial:** el directorio `estandares/` se
espera contenga STDs numerados (`std-NNN-*`) o templates
(`tpl-*`). Guías sin prefijo en este directorio rompen la
expectativa.

**Propuestas:**

- Reubicar a `source/_metadata/` o equivalente.
- Asignar prefijo (¿`std-010-guia-estilo.rst`? — pero no es STD).
- Aceptar como excepción documentada en STD_007.

## F-07 MAJOR — 37 archivos sin frontmatter `.. meta::`

**Reproducible:** `for f in $(find source -type f -name "*.rst" ! -name "index.rst"); do head -3 "$f" | grep -q "^\.\. meta::" || echo "$f"; done | wc -l`

**Ejemplos:**

```
source/gestion/plantilla-adr.rst
source/gestion/git-workflow.rst
source/plantuml-guide/{guidelines,metadata-standard,color-palette}.rst
source/requisitos/requisitos-no-funcionales/rnf-proc-001-proceso-sdlc.rst
source/normativa/gobernanza/adr-front-004-arquitectura-microfrontends.rst
source/plantuml-guide/ejemplos/test-uc-diagram.rst
```

**Por qué es violación:** convención implícita del proyecto
documentada en `.claude/rules/metadata-standards.md` exige
frontmatter en artefactos. Falta de metadata impide trazabilidad
y cumplimiento de STD_006 (versionado en metadata).

## F-08 MAJOR — 35 archivos sin `:version:` en metadata

**Reproducible:** `COUNT=0; for f in $(find source -type f -name "*.rst" ! -name "index.rst"); do head -15 "$f" | grep -q ":version:" || COUNT=$((COUNT+1)); done; echo $COUNT`

**Por qué es violación:** STD_006 §3.4 dice "versión vive en
metadata YAML". 35 archivos no tienen `:version:` → versionado
no aplicable.

## F-09 MAJOR — 133 archivos sin `:fecha_creacion:`

**Reproducible:** mismo patrón con `:fecha_creacion:`.

**Por qué es violación grave:** la trazabilidad temporal
desaparece para 1/3 del corpus (133 / 401 = 33%).

## F-10 CRITICAL — Archivos parcialmente convertidos de MD a RST

**Detectado:** `source/requisitos/requisitos-no-funcionales/rnf-proc-001-proceso-sdlc.rst`
empieza con:

```
RNF-PROC-001_PROCESO_SDLC.md
============================

Requisito No Funcional: ...
```

**Análisis:**

- El primer header `RNF-PROC-001_PROCESO_SDLC.md` parece ser un
  título antiguo del MD original.
- Falta frontmatter `.. meta::`.
- Estructura mantiene patrones MD (no RST puro).

**Por qué es CRITICAL:** son archivos que pasaron el saneamiento
md→rst sin completar la migración semántica. Build verde no los
detecta porque RST acepta el formato. Son "RST sintáctico, MD
semántico".

**Estimación:** ≥2 archivos rnf confirmados, posibles más.
Requiere scan dirigido.

## F-11 INFO — 0 anchor labels duplicados ✓

`grep -rh "^\.\. _" source --include="*.rst" | sort | uniq -d`
retorna 0. **Clean.**

## F-12 INFO — 0 archivos huérfanos en toctrees ✓

`SPHINX_NITPICKY=1 make html | grep "isn't included"` retorna 0.
**Clean.**

## Síntesis para el plan

**Findings que requieren acción:**

| Tipo | Findings | Acción |
|------|----------|--------|
| Renames | F-01 (9), F-02 (8), F-06 (3) | bulk renames + ref updates |
| Spec extension | F-03, F-04, F-05 | STD_007 v2.0.1 → v2.0.2 |
| Metadata remediation | F-07 (37), F-08 (35), F-09 (133), F-10 (≥2) | scripted + manual review |

**Findings que cierran sin acción:**

- F-11, F-12 (limpios)
