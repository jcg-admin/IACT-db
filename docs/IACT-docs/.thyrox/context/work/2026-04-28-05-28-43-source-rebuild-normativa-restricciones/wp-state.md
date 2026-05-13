```yml
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #4 of 16
created_at: 2026-04-28 05:28:43
current_phase: Phase 11 — TRACK (CERRADO — 0 warnings, 0 errors, 4 deep-reviews resueltos)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO — 2026-04-28 10:05 (31 CNSTs atómicas SRP, build limpio)
opened_at: 2026-04-28 08:00:00
closed_at: 2026-04-28 10:05:00
```

# WP-hijo #4 — Source Rebuild: normativa/restricciones (CNST)

## Propósito

Reconstruir `source/normativa/restricciones/` reconciliando la
**divergencia profunda** detectada entre `source/` actual (12 CNSTs)
y `temp-holding/` (8 CNSTs distintas con misma numeración). Producir
un set canónico de CNSTs sin gaps ni solapes.

## Capa

**Methodology / Governance** (capa 1).

## Pre-condiciones

- WP #2 `source-rebuild-normativa-estandares` cerrado (template
  `TPL_CNST_Restricciones.rst` disponible).

## Decisiones del padre que aplican

- **Idea 7 (CNST como input arquitectónico).**
- **Decision 7 (CNST en WP propio, antes de requisitos).**

## Pre-tareas absorbidas

| Pre-tarea | Acción esperada en Phase 1 DISCOVER |
|-----------|-------------------------------------|
| **Lectura del documento maestro consolidado** | `temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` — punto de partida canónico. |
| **Lectura de propuesta previa de reorganización** | `temp-holding/FASE 01/CNST RESTRICCIONES/ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md`. |
| **Inspección de v2.0.0 standalone** | `temp-holding/FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst` — entender qué representa. |
| **Mapeo source ↔ temp-holding ↔ documento maestro** | Para cada CNST de cada lado: identificar concepto subyacente y solapes. |
| **Tabla de mapeo viejo→nuevo** | Output crítico: `requisitos` (WP #6) la consume para migrar refs en UCs. |

## 5 Sub-decisiones D-CNST a resolver en este WP

Heredadas del padre `strategy/restricciones-divergence-analysis.md`
§4.2:

- **D-CNST-1:** ¿Numeración nueva consistente, o respetar la de
  source/?
- **D-CNST-2:** ¿Cómo se manejan las CNSTs huérfanas (presentes
  en uno solo de los lados)? ¿Se incorporan, descartan, fusionan?
- **D-CNST-3:** ¿Qué hacer con `CNST_05_Restriccion_Creacion_
  Iterativa_2_0_0.rst` (v2.0.0 standalone)?
- **D-CNST-4:** Llenar el gap CNST_011 — ¿con qué contenido?
- **D-CNST-5:** Sub-categorías (seguridad, performance, datos,
  infra) — ¿flat por número o agrupadas?

## Riesgos críticos heredados (del plan del padre §"Riesgos")

- **R1:** WP #6 requisitos se rebuilda con CNSTs viejas si #4
  no cierra antes (bloqueante).
- **R2:** Pérdida de CNST huérfana durante reconciliación.

## Alcance

**In-scope:** Set canónico de CNSTs con numeración consistente,
sin gaps; tabla de mapeo viejo→nuevo; aplicar `TPL_CNST` + STD_007.

**Out-of-scope:** Crear nuevas restricciones que no estén
documentadas en alguno de los inputs.

## Pre-condición de cierre del padre que activa este WP-hijo

- Salida es **input hard de WP #6 requisitos** (H2 cross-WP).

## Estado

**Borrador (no iniciado).** Spawneado por T-011.
