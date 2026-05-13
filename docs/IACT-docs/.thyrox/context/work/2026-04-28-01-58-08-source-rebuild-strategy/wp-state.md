```yml
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
created_at: 2026-04-28 01:58:08
current_phase: Phase 11 — TRACK (CERRADO)
flow: thyrox
methodology_step: workflow-track
author: NestorMonroy
status: CERRADO — 2026-04-28 05:35:09 (16 hijos spawneados, ver CLOSURE-NOTICE.md)
```

# WP — Source Rebuild Strategy

## Propósito

`source/` contiene 379 archivos `.rst` con 34 patrones de naming
distintos (ver WP `source-references-audit`), 147 hyperlinks rotos
y heterogeneidad acumulada de múltiples ÉPICAs. El cleanup
incremental (renombrar y arreglar refs en sitio) requeriría
trabajo proporcional a la cantidad de inconsistencias y mantendría
el riesgo de regresión durante semanas.

Este WP propone una estrategia alternativa: **reconstrucción
controlada de `source/` dominio por dominio** sobre un snapshot
inmutable (`temp-backup/`).

## Alcance

**SOLO Phase 1 DISCOVER en este WP.** Ningún archivo de `source/`
se mueve, copia, renombra ni borra. Output esperado:

1. Inventario detallado por dominio.
2. Estrategia documentada y aprobada.
3. Orden de reconstrucción definido.
4. Criterios de aceptación por dominio.
5. Plan de bridge (cómo mantener build verde durante el rebuild).

**Fuera de alcance en este WP:** la ejecución del rebuild se
hará en WPs posteriores, uno por dominio.

## Referencias a WPs previos

- `2026-04-28-00-19-57-source-references-audit/` — inventario de
  976 refs y 34 patrones de naming.
- `source/normativa/estandares/STD_007_Convencion_Naming.rst` —
  convención canónica (la regla que aplicará el rebuild).
