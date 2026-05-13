```yml
project: IACT-docs
work_package: 2026-05-01-06-24-28-promote-matriz-dependencias-to-source
created_at: 2026-05-01 06:24:28
current_phase: Phase 12 — STANDARDIZE (closed)
closed_at: 2026-05-01 06:35:00
status: Cerrado v1.0.0 — RST publicado en source/, build 0/0/0
author: NestorMonroy
flow: rm
methodology_step: rm-management
predecessor_wp: 2026-05-01-05-17-20-uc-dependency-matrix-iact
```

# WP — Promoción de la matriz de dependencias UC a source/

## Propósito

Consolidar el entregable del WP predecesor (6
partes + conclusión, ~2 630 líneas) en un único
artefacto RST publicable, ubicarlo en
``source/arquitectura-tecnica/`` junto al modelo
de dominio y al modelo RBAC, y verificar build
verde.

## Insumos

- ``analyze/parte-01-resumen-ejecutivo.md``
- ``analyze/parte-02-tabla-maestra.md``
- ``analyze/parte-03-matriz-compacta.md``
- ``analyze/parte-04-dependencias-criticas.md``
- ``analyze/parte-05-criticidad-duracion.md``
- ``analyze/parte-06-patrones-diseno.md``
- ``analyze/conclusion.md``

Origen: WP predecesor
``2026-05-01-05-17-20-uc-dependency-matrix-iact``.

## Scope

### IN

- Crear
  ``source/arquitectura-tecnica/matriz-dependencias-uc-iact.rst``
  consolidado.
- Convertir markdown → RST (headings, tablas,
  bloques de código).
- Preservar identifiers en inglés (clases,
  funciones RBAC).
- Mantener prosa en español (NOM_001 § 2.3).
- Actualizar
  ``source/arquitectura-tecnica/index.rst``
  toctree.
- Build incremental 0/0/0.

### OUT

- Cambios al contenido analítico (las
  decisiones, métricas y hallazgos quedan tal
  cual fueron decididos en el WP predecesor).
- Modificación de los UCs en
  ``source/requisitos/casos-uso/``.
- Modificación del modelo de dominio o RBAC.

## Definición de éxito

- 1 archivo RST publicado con las 6 partes +
  conclusión.
- Toctree de
  ``arquitectura-tecnica/index.rst`` actualizado.
- ``make html`` incremental con 0 warnings, 0
  errors.
- Gate I-015 satisfecho.

## Cierre

WP cerrado por orden del ejecutor (I-011) tras
verificación de build verde.
