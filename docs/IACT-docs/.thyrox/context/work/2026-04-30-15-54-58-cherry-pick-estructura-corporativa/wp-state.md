```yml
project: IACT-docs
work_package: 2026-04-30-15-54-58-cherry-pick-estructura-corporativa
created_at: 2026-04-30 15:54:58
current_phase: Phase 1 — DISCOVER
status: Abierto (a aplicar más adelante)
author: NestorMonroy
```

# WP State — cherry-pick estructura corporativa

## Propósito

Adoptar **selectivamente** las mejoras infra/proceso de la
propuesta de "estructura corporativa de 3 niveles" sin
reorganizar la jerarquía de `source/`.

## Origen

Durante el WP `2026-04-30-09-06-01-requisitos-update` el
ejecutor pasó una propuesta completa de reorganización a 3
niveles. El análisis (
`.thyrox/context/work/2026-04-30-09-06-01-requisitos-update/
analyze/estructura-corporativa-3-niveles-analysis.md`)
concluyó:

- Camino A (adopción total): rechazado — costo 80–120 h,
  rompe convenciones, IACT-docs es single-project.
- Camino C (rechazo total): rechazado — descarta mejoras
  reales.
- **Camino B (cherry-pick): aceptado** — adoptar lo valioso
  sin reorganizar.

Este WP materializa el Camino B.

## Estado

**Abierto, en hold** — se aplicará cuando se cierre el scope
actual del WP `requisitos-update` (documentación de
``source/requisitos/*``). Hay que confirmar primero qué
elementos del cherry-pick **ya están implementados** antes de
ejecutar.

## Scope del cherry-pick (in-scope provisional)

Adoptar **selectivamente**:

1. **Scripts de validación** en `.claude/scripts/` o
   `scripts/`:
   - `validate_metadata.py` — valida frontmatter canónico per
     STD-007 v2.0.2 § 6.
   - `check_staleness.py` — detecta docs sin actualizar en
     N días.
   - `detect_conflicts.py` — detecta refs duplicadas o
     conflictos.
   - `check_links.py` — valida `:doc:` y links externos.
   - `validate_conventions.py` — lint de naming kebab per
     STD-007.
   - `validate_ownership.py` — verifica CODEOWNERS.

2. **GitHub workflows** en `.github/workflows/`:
   - `validate-docs.yml` — pipeline de validación.
   - `check-staleness.yml` — detección periódica.
   - `detect-conflicts.yml` — chequeo de PRs.

3. **CODEOWNERS** en `.github/CODEOWNERS`.

4. **Convención `_archive/`** para docs deprecated formales.

5. **PR template** en `.github/pull_request_template.md`.

## Out-of-scope (rechazado en el análisis)

- Renombrar cajones top-level (`requisitos/` → `specifications/`,
  `arquitectura-tecnica/` → `architecture/`, etc.).
- Migrar idioma español → inglés.
- Mover `base-cognitiva/` → `knowledge/` (pérdida semántica).
- Crear top-level `news/`, `teams/`, `reports/`.
- Encapsular IACT-docs en `projects/iact/` (single-project).
- Reorganización a 3 niveles.

## Pendientes antes de ejecutar

- [ ] Confirmar qué elementos del cherry-pick **ya están
  implementados** en el repo actual (puede haber overlap).
- [ ] Decidir ubicación: `scripts/` (top-level) vs
  `.claude/scripts/` (THYROX namespace) vs ambos.
- [ ] Verificar si ya existen workflows en `.github/workflows/`
  que cubran parte del scope.
- [ ] Decidir granularidad de `CODEOWNERS` (por cajón / por
  proyecto / por subdomain).
- [ ] Establecer N para `check_staleness.py` (¿90 días? ¿180?).

## Conexión con WP anterior

- WP origen: `2026-04-30-09-06-01-requisitos-update`.
- Análisis fundacional:
  `.thyrox/context/work/2026-04-30-09-06-01-requisitos-update/
   analyze/estructura-corporativa-3-niveles-analysis.md`.
- Cuando se aplique, este WP no debe interferir con el
  trabajo del WP requisitos-update — son ortogonales.

## Decisiones tomadas

1. **No** reorganizar `source/` (Camino A descartado).
2. **Sí** adoptar mejoras infra/proceso (Camino B).
3. **Postpone** la ejecución hasta cerrar
   `requisitos-update`.

## Próximos pasos

1. Cuando se vuelva a este WP: hacer Phase 2 MEASURE inventario
   de qué del cherry-pick **ya existe** en el repo.
2. Phase 3 ANALYZE: gap entre lo existente y lo propuesto.
3. Phase 6 PLAN: priorizar (high-value first).
4. Phase 10 EXECUTE: implementar selectivamente.
