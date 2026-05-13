```yml
created_at: 2026-05-01 06:33:29
project: IACT-docs
work_package: 2026-05-01-06-33-29-uc-auth-01-analisis
phase: Phase 11 — TRACK
author: NestorMonroy
status: Aprobado
version: 1.0.0
language: es
```

# Lessons Learned — UC_AUTH_01 Análisis (CRÍTICO 1/8)

## Resultado entregado

Tres análisis complementarios sobre UC_AUTH_01:

1. ``analyze/uc-auth-01-analisis-uml-06.md``
   (~310 líneas, 6 hallazgos H-A06-01..06)
2. ``analyze/uc-auth-01-analisis-uml-07.md``
   (~280 líneas, 5 hallazgos H-A07-01..05)
3. ``analyze/uc-auth-01-analisis-template-completo.md``
   (~415 líneas, 6 hallazgos H-T-01..06)

Total: ~1 005 líneas, 17 hallazgos
(16 OBSERVABLE + 1 INFERRED + 0 SPECULATIVE).

## Decisiones tomadas

- **DEC-01** — Producir TRES análisis (no uno
  monolítico): uml-06 introductorio, uml-07
  diagrámatico, template-completo gap analysis.
  Ventaja: cada uno con foco propio; permite
  reutilizar el patrón en otros UCs si se
  decide.
- **DEC-02** — Aplicar la metodología del
  proyecto (uml-06, uml-07) en lugar de
  improvisar. Las dos guías ya existen como
  material canónico interno.
- **DEC-03** — Corrección de inconsistencia
  AGR (uso de español residual): aplicar
  catálogo canónico inglés de
  ``modelo-rbac-iact.rst`` v5.4.0; registrar
  hallazgo H-A06-06 documentando deuda en el
  cuerpo de los UCs vigentes.
- **DEC-04** — No desarrollar flujos completos
  en este WP — esos son trabajo del WP futuro
  de spec completa (que se abre tras este
  cierre).
- **DEC-05** — Recomendar Propuesta A
  (directorio por UC con 12 archivos) en el
  análisis 3 — alineada con la directiva del
  ejecutor *"no todo va en el mismo archivo"*.

## Hallazgos clave heredables

- H-A06-06 — deuda AGR español residual en cuerpo
  de UCs vigentes (recomienda WP de saneamiento).
- H-A07-01 — diagrama UC vigente modela 4
  sub-pasos como UCs separados (corregir per
  D-A07-01).
- H-T-01 — gap de 6 partes parciales + 4
  ausentes para llegar a spec completa de 12
  partes (~33 person-days adicionales).

## Transición al WP siguiente

El ejecutor confirmó (2026-05-01) la opción (a):
**los 61 UCs adoptan la estructura de 12 partes
completa**. Esfuerzo total estimado: ~2 000
person-days (~100 sem-dev). Aproximación
incremental:

- WP siguiente: UC_AUTH_01 spec completa (1 de 61).
- Iteración: aprender del primer ciclo antes de
  estandarizar el patrón para los 60 restantes.

Las 6 decisiones D-T01..D-T06 del análisis 3
(estructura archivos, migración, dónde viven
cifras, granularidad) son insumo directo del
WP siguiente.

## Cierre

WP cerrado por orden del ejecutor (I-011) el
2026-05-01. Cero cambios al corpus ``source/``
en este WP — analítico puro.
