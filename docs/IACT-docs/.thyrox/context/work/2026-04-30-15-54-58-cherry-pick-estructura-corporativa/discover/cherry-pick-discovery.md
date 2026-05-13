```yml
created_at: 2026-04-30 15:54:58
project: IACT-docs
work_package: 2026-04-30-15-54-58-cherry-pick-estructura-corporativa
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 1 DISCOVER — cherry-pick estructura corporativa

## Premisa

Análisis previo en
`2026-04-30-09-06-01-requisitos-update/analyze/
estructura-corporativa-3-niveles-analysis.md` identificó
ventajas reales en la propuesta de 3 niveles que valen ser
adoptadas selectivamente sin reorganizar `source/`.

## Items del cherry-pick

### CP-1 — Scripts de validación

Propuesta original:

::

 scripts/
   ├── validate_metadata.py
   ├── check_staleness.py
   ├── detect_conflicts.py
   ├── check_links.py
   ├── validate_conventions.py
   ├── validate_ownership.py
   ├── migrate_doc.py
   ├── create_project.py
   └── health_check.py

**Pendiente verificar (Phase 2 MEASURE):**

- ¿Hay scripts equivalentes en `.claude/scripts/` ya?
- ¿Hay validación de metadata en hooks?
- ¿Hay link-check en build de Sphinx (existe extensión
  `sphinx.ext.intersphinx` y `linkcheck` builder)?

### CP-2 — GitHub workflows

Propuesta original:

::

 .github/workflows/
   ├── build-docs.yml
   ├── validate-docs.yml
   ├── check-staleness.yml
   └── detect-conflicts.yml

**Pendiente verificar:** estado actual de
`.github/workflows/` en el repo.

### CP-3 — CODEOWNERS

Propuesta original: `.github/CODEOWNERS` para enforcement de
ownership por cajón.

**Pendiente verificar:** existe ya? Granularidad apropiada?

### CP-4 — Convención `_archive/`

Para docs deprecated formales — separar de los vigentes sin
borrar el historial.

**Pendiente:** definir si será un cajón global
(`source/_archive/`) o por subdomain
(`source/<dominio>/_archive/`).

### CP-5 — PR template

`.github/pull_request_template.md` con checklist de:

- [ ] Build verde local.
- [ ] Cross-refs no rotos.
- [ ] Metadata canónica per STD-007 v2.0.2 § 6.
- [ ] Cambios en CHANGELOG / WP-changelog.
- [ ] Skill aplicada documentada.

### CP-6 — Sphinx extensions custom

Propuesta original:

::

 _extensions/
   ├── breadcrumb_extension.py
   ├── autotoctree.py
   ├── metadata_schema.py
   └── version_injection.py

**Pendiente verificar:** ¿hay equivalentes en `conf.py`
actual? (probablemente parcial — Sphinx ya hace breadcrumbs
y tocs).

### CP-7 — `_templates/` custom (Jinja)

Propuesta original:

::

 _templates/
   ├── layout.html
   ├── page.html
   └── search.html

**Pendiente verificar:** ya existe `source/_templates/`?

## Items NO en el cherry-pick (descartados)

| Item propuesta | Razón rechazo |
|----------------|---------------|
| Renombrar cajones top-level | Rompe 340+ refs, idioma ES→EN, single-project no necesita |
| Crear `news/`, `teams/`, `reports/` top-level | IACT-docs es single-project, no portal corporativo |
| Migrar `base-cognitiva/` → `knowledge/` | Pérdida semántica (ontología SBVR, metamodelos formales ≠ knowledge base) |
| `projects/iact/` con 12 sub-cajones | Single-project no necesita encapsulamiento por proyecto |
| `_support/_methodology/_archive/_tools/` con doble underscore | Inconsistente con convención existente (1 underscore para sub-cajones internos) |
| Migración a inglés | STD-007 + BReqs/BRs/UCs/CNSTs en español ya establecidos |

## Riesgos del cherry-pick

| Riesgo | Mitigación |
|--------|------------|
| Algunos scripts ya pueden existir → duplicación | Phase 2 MEASURE inventaría primero |
| Workflows pueden conflictuar con CI existente | Reviso `.github/workflows/` antes de agregar |
| `_archive/` global vs per-subdomain — decisión arquitectónica | Decidir en Phase 5 STRATEGY |
| CODEOWNERS sin previa definición de equipos puede bloquear PRs | Empezar con un solo owner global, refinar |

## Estado del WP

**ABIERTO, en hold** hasta cerrar el WP
`2026-04-30-09-06-01-requisitos-update`.

## Próximas fases

- **Phase 2 MEASURE** — inventario de qué ya existe.
- **Phase 3 ANALYZE** — gap entre existente y propuesto.
- **Phase 4 CONSTRAINTS** — restricciones técnicas
  (compatibilidad Sphinx, GitHub Actions caps, etc.).
- **Phase 5 STRATEGY** — priorizar items high-value.
- **Phase 6 PLAN** — scope acordado.
- **Phase 10 EXECUTE** — implementar.

## Trazabilidad

- **Skill aplicada**: `workflow-discover` (Phase 1 DISCOVER).
- **WP origen**: `2026-04-30-09-06-01-requisitos-update`.
- **Análisis fundacional**:
  `analyze/estructura-corporativa-3-niveles-analysis.md`
  del WP origen.
