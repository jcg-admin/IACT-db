```yml
created_at: 2026-04-30 09:06:01
project: IACT-docs
work_package: 2026-04-30-09-06-01-requisitos-update
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis — propuesta de estructura corporativa de 3 niveles

## Premisa

El ejecutor pasó una propuesta completa de estructura para
`source/` reorganizada en 3 niveles:

- **Nivel 1**: 10 categorías corporativas top-level
  (`guide/`, `news/`, `policies/`, `procedures/`, `planning/`,
  `knowledge/`, `projects/`, `reports/`, `teams/`,
  `resources/`).
- **Nivel 2**: múltiples proyectos dentro de `projects/`
  (`project-saas-platform/`, `project-mobile-app/`,
  `shared-components/`).
- **Nivel 3**: 12 cajones planos por proyecto
  (`specifications/`, `planning/`, `architecture/`,
  `backend/`, `frontend/`, `infrastructure/`, `operations/`,
  `onboarding/`, `quality-scenarios/`,
  `risks-technical-debt/`, `crosscutting-concepts/`,
  `glossary/`) + `_support/{_archive, _methodology, _tools}/`.

Ejecutor pide análisis de la propuesta.

## Hallazgos

### F-1 — La propuesta es para un *hub multi-proyecto*, no para IACT-docs single-project

El nivel 1 incluye `news/`, `teams/`, `reports/`,
`projects/index.rst` con metadata multi-proyecto, etc.

Esto es patrón típico de **portal corporativo de documentación
de TI** que aloja varios proyectos.

**IACT-docs es la documentación de UN proyecto** (call center
analytics IACT). No hay segundo proyecto previsto.

→ Adoptar esta estructura introduce capas vacías: `news/`,
`teams/`, `reports/`, `projects/` (con un solo hijo IACT).

### F-2 — Costo de migración prohibitivo

Inventario actual (verificable):

```
source/
├── arquitectura-tecnica/   (~30 archivos)
├── backend/                (~10)
├── base-cognitiva/         (~50, con _uml/, _ontologia-sbvr/,
│                            _taxonomias-y-metamodelos/,
│                            _ejemplos-pedagogicos/, _metadata/,
│                            _fundamentos-conceptuales/,
│                            plantuml-guide/)
├── databases/              (~5)
├── devops/                 (~10)
├── frontend/               (~10)
├── gestion/                (~30)
├── normativa/              (~80, con estándares + plantillas
│                            + ADRs + procedimientos)
├── onboarding/             (~3)
├── quality/                (~3)
├── requisitos/             (~150)
├── risks-technical-debt/   (~3)
└── _static/, _templates/, conf.py
```

Total ≈ **380+ archivos**.

Mapeo propuesta → actual:

| Propuesto | Cubre actual |
|-----------|--------------|
| `guide/` | (no existe en actual) |
| `news/` | (no existe) |
| `policies/` | parte de `normativa/` |
| `procedures/` | `normativa/procedimientos/` |
| `planning/` (top) | parte de `gestion/pm/` |
| `knowledge/` | parte de `base-cognitiva/` |
| `projects/iact/specifications/` | `requisitos/` (148 .rst) |
| `projects/iact/architecture/` | `arquitectura-tecnica/` |
| `projects/iact/backend/` | `backend/` |
| `projects/iact/frontend/` | `frontend/` |
| `projects/iact/infrastructure/` | `devops/` + `databases/` |
| `projects/iact/operations/` | parte de `devops/` |
| `projects/iact/quality-scenarios/` | `quality/` |
| `projects/iact/risks-technical-debt/` | `risks-technical-debt/` |
| `projects/iact/crosscutting-concepts/` | parte de `base-cognitiva/` |
| `projects/iact/glossary/` | `base-cognitiva/glosario.rst` |
| `projects/iact/_support/_methodology/` | `normativa/estandares/metodologia-*` |
| `reports/` | (no existe) |
| `teams/` | (no existe) |
| `resources/` | (parcial — fragmentos) |

**Migración implicaría:**

- Mover ~380 archivos.
- Cambiar ~340 refs `:doc:` cross-cajón.
- Renombrar 8 cajones top-level + crear 5 nuevos.
- Re-mapear `requisitos/` → `specifications/` (148 archivos).
- Fragmentar `base-cognitiva/` entre `knowledge/`,
  `crosscutting-concepts/`, `glossary/`,
  `_support/_methodology/`.
- Romper TODOS los cross-links existentes en cada
  metadata, ADR, procedimiento, BReq, BR, UC, FR, NFR.

Estimación: **80–120 horas** sólo para la mecánica del move +
update de refs, sin contar revisiones de coherencia.

### F-3 — Conflicto con convenciones THYROX establecidas

La propuesta entra en conflicto con:

1. **STD-007 v2.0.2** — convención de naming en español kebab.
   La propuesta es **inglés** (`guide/`, `news/`, `procedures/`,
   `specifications/`). Cambio de idioma del 100% de los
   filenames.

2. **adr-gob-001** — ya define la organización por dominio
   (`arquitectura-tecnica/`, `backend/`, `frontend/`, etc.).
   Esta propuesta lo invierte (cajones por *función organizacional*
   antes que por *dominio técnico*).

3. **Convención de underscore-prefix** — actual usa
   `_uml/`, `_ontologia-sbvr/`, `_taxonomias-y-metamodelos/`,
   `_ejemplos-pedagogicos/`, `_metadata/` para subcajones
   internos. Propuesta usa `_support/_archive/`,
   `_support/_methodology/`, `_support/_tools/` con
   *doble* underscore (anidado), lo cual es inconsistente.

4. **THYROX work packages** — los WPs están en
   `.thyrox/context/work/` que es separado de `source/`. La
   propuesta no toca esto, pero las refs `:doc:` desde
   evidencias migradas (que ya están en
   `gestion/evidencia/rbac-historia/`,
   `gestion/pm/audits/`, etc.) se romperían.

### F-4 — Pérdida de semántica

`base-cognitiva/` no es traducible a `knowledge/` sin perder
información. `base-cognitiva/` es un concepto específico:
**la base ontológica + vocabulario controlado + metamodelos
formales del dominio del proyecto** (SBVR, MTM, TXM).

`knowledge/` en la propuesta es genérico
(`how-to-guides/`, `best-practices/`, `lessons-learned/`,
`architecture-patterns/`, `faqs/`). Esto es **otra cosa** —
es base de conocimiento práctico, no ontología formal.

Migrar `base-cognitiva/` → `knowledge/` empobrecería el
modelo conceptual del proyecto.

### F-5 — Ventajas reales de la propuesta

A pesar de los problemas, hay ventajas:

1. **arc42 alignment**: los 12 cajones planos por proyecto
   reflejan la estructura arc42 (Architecture Documentation)
   + crosscutting-concepts + glossary + risks. Esto es
   estándar reconocido.

2. **Multi-proyecto ready**: si IACT-docs evoluciona a
   plataforma corporativa con varios proyectos, esta
   estructura escala mejor.

3. **Automatización**: `_extensions/`, `scripts/` con
   `validate_conventions.py`, `validate_metadata.py`,
   `check_staleness.py`, `detect_conflicts.py`,
   `check_links.py`, `migrate_doc.py`,
   `validate_ownership.py`. Esto es **muy bueno**.

4. **CODEOWNERS + workflows GitHub**: refuerza ownership
   y CI/CD. También bueno.

5. **`_archive/` formal**: separa docs deprecated de los
   vigentes. Útil.

6. **Onboarding por proyecto**: complementa onboarding
   corporativo. Útil para proyectos grandes.

### F-6 — Indicadores de origen no canónico

El texto pegado tiene artefactos:

```
├── README.md                              (Overview...)
├── README.md → [README.md](http://README.md)
├── conf.py → [conf.py](http://conf.py)
├── breadcrumb_extension.py → [extension.py](http://extension.py)
```

Sintaxis Markdown rota (paréntesis con URL `http://README.md`)
sugiere que la propuesta es un **draft externo no curado**, no
una decisión interna del proyecto IACT-docs.

## Tres caminos posibles

### Camino A — adoptar completa

Reorganización total. Costo 80–120 h. Idioma inglés.
Romper 340 refs. Justificable sólo si:
- IACT-docs evoluciona a multi-proyecto.
- Hay decisión organizacional de migrar a inglés.
- Hay capacidad de ejecutarlo sin parar trabajo activo.

### Camino B — adoptar parcialmente (cherry-pick)

Tomar las **ventajas concretas** sin la reorganización masiva:

1. **Scripts de validación** (Camino B-1): adoptar
   `validate_metadata.py`, `check_staleness.py`,
   `check_links.py`, `validate_conventions.py` en
   `.claude/scripts/` o `scripts/`. Sin cambiar estructura.

2. **`_archive/`** (Camino B-2): crear cajón de archived
   docs deprecated en cada subdomain o un global. Útil.

3. **Onboarding mejorado** (Camino B-3): expandir
   `source/onboarding/` con `quickstart`, `local-setup`,
   `first-contribution`. Sin cambiar el resto.

4. **`crosscutting-concepts/`** (Camino B-4): si emerge la
   necesidad, crear `arquitectura-tecnica/conceptos-transversales/`.

5. **Workflows GitHub** (Camino B-5): adoptar
   `validate-docs.yml`, `check-staleness.yml`,
   `detect-conflicts.yml` en `.github/workflows/`.

6. **CODEOWNERS** (Camino B-6): adoptar para enforcement
   de ownership.

**Estimación Camino B**: 8–20 horas, beneficio alto, sin
romper nada.

### Camino C — rechazar y documentar

Rechazar la reorganización porque:
- IACT-docs es single-project.
- Convenciones THYROX + STD-007 ya establecidas.
- Costo desproporcionado al beneficio para single-project.

Documentar la decisión en un ADR
(`adr-gob-XXX-rechazo-estructura-corporativa-3-niveles`)
que registre el análisis y razones.

## Recomendación

**Camino B (cherry-pick)**:

- ✓ Adoptar **scripts de validación** + workflows + CODEOWNERS
  (mejoras de proceso de alto valor, costo bajo).
- ✓ Considerar **`_archive/`** convención cuando aparezcan
  docs deprecated formales.
- ✓ Diferir reorganización completa hasta que IACT-docs
  evolucione a multi-proyecto (si ocurre).
- ✗ NO migrar a inglés — STD-007 y BReqs / BRs / UCs /
  CNSTs están en español.
- ✗ NO renombrar cajones top-level (rompe 340+ refs por
  cero ganancia funcional para single-project).
- ✗ NO mover `base-cognitiva/` → `knowledge/` (pérdida
  semántica).

Si en el futuro IACT-docs aloja más proyectos → reabrir el
debate con la propuesta como referencia base.

## Pendiente de aprobación del ejecutor

Confirmación del camino (A / B / C).

## Trazabilidad

- **Skill aplicada**: `workflow-analyze` (Phase 3 ANALYZE).
- **Origen**: propuesta externa pasada por el ejecutor en
  forma de árbol `source/` con 3 niveles.
- **Conexión con análisis previo**: la decisión sobre
  colocación de los 7 docs UML/OOP (
  `colocacion-docs-uml-oop-iact-analysis.md`) debe esperar
  a esta decisión más amplia, ya que un Camino A implicaría
  destinos completamente distintos.
