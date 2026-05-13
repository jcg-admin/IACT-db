```yml
project: IACT-docs
work_package: 2026-04-30-09-06-01-requisitos-update
created_at: 2026-04-30 09:06:01
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# WP State — requisitos-update

## Propósito

Actualización de los artefactos de `source/requisitos/` (BReq, BR,
UC, FR, NFR) basada en los cambios que el ejecutor pasará durante
la ejecución del WP.

## Punto de entrada

El move de `plantuml-guide` a `base-cognitiva/` se ejecutó como
trabajo preparatorio antes de abrir este WP (ver commit
`2f9d2d4`). No forma parte del scope de este WP.

## In-scope (provisional)

- Análisis del contenido actual de `source/requisitos/`:
  inventario de artefactos por categoría, cobertura, gaps,
  consistencia interna.
- Recibir y consolidar los cambios concretos que el ejecutor
  pasará.
- Actualización de los artefactos correspondientes.

## Out-of-scope (provisional)

- Refactor estructural de `source/requisitos/` (si surge,
  abrir WP separado).
- Cambios en otros dominios (`base-cognitiva/`, `normativa/`,
  etc.) salvo que sean consecuencia directa de actualizar un
  requisito.

## Estado

- [x] WP creado
- [ ] Análisis Phase 1 DISCOVER de `source/requisitos/`
- [ ] Recepción de cambios del ejecutor
- [ ] Plan de actualización
- [ ] Ejecución
- [ ] Build verde + commit
