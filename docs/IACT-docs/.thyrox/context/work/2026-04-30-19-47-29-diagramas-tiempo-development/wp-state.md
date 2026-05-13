```yml
project: IACT-docs
work_package: 2026-04-30-19-47-29-diagramas-tiempo-development
created_at: 2026-04-30 19:47:29
closed_at: 2026-04-30 22:45:55
current_phase: Phase 1 — DISCOVER (no completada)
status: Cerrado sin ejecución
author: NestorMonroy
```

# WP — Desarrollo de diagramas de tiempo (timing) en IACT

## Estado — Cerrado 2026-04-30 22:45:55

**CERRADO sin ejecución** por orden del ejecutor — el
proyecto cambia de scope hacia análisis RM real
(WP ``2026-04-30-22-45-55-rm-uc-relationships-analysis``).

El documento preliminar ``diagramas-tiempo.rst``
(v0.1.0 Borrador) **queda en su lugar** como referencia
en el cajón ``_metodologia-aplicacion/``. Si en el
futuro se necesita timing diagram canónico, este WP
se reabre o se crea uno nuevo.

## Estado original (preservado para historia)

**HOLD.** WP abierto sin ejecución hasta orden explícita
(I-011). Permanece dormido para no salirnos del scope
actual (generación de documentación de
``source/requisitos/*``).

## Origen

La integración de la clasificación UML
(:doc:`source/requisitos/_metodologia-aplicacion/diagramas-uml`)
identificó los **diagramas de tiempo (timing)** como la
única familia de la sub-familia "Interacción" que no estaba
cubierta por una guía aplicada al dominio IACT.

Se introdujo un documento preliminar
(``diagramas-tiempo.rst``, versión 0.1.0, estado Borrador)
con un único ejemplo introductorio (UC_RPT_01 vs SLA
CNST_017). El ejemplo es ilustrativo: los instantes son
arbitrarios y el catálogo de estados está simplificado.

## Scope (cuando se retome)

- IN: catálogo completo de UCs IACT donde un timing
  diagram aporta sobre secuencias/estados.
- IN: convenciones PlantUML del proyecto para timing
  (sintaxis ``robust``/``concise``, granularidad,
  resaltado de ventanas SLA).
- IN: integración explícita con CNST_017 (SLA),
  CNST_006/007/008 (ventana ETL), CNST_002 (sesión
  única), CNST_011 (throttling).
- IN: mediciones reales que reemplacen los instantes
  ilustrativos del ejemplo preliminar.
- IN: reglas de cuándo NO usar timing diagram (evitar
  diagramas decorativos sin restricción temporal real).
- IN: ascenso del documento preliminar de v0.1.0
  Borrador a v1.0.0 Vigente.
- OUT: cambios al stack canónico ADR_DEVOPS_001.
- OUT: implementación de medidores en runtime — eso
  pertenece a un WP de instrumentación posterior.
- OUT: cambios a otros diagramas hermanos (estados,
  secuencias, colaboraciones, actividades).

## Hipótesis iniciales (sin verificar)

1. UC_RPT_01 (consulta dashboard) vs CNST_017 SLA es el
   caso más claro para timing.
2. UC_PIP_01 (carga ETL) y la ventana CNST_006/008
   justifica un timing por su naturaleza temporal larga.
3. UC_AUTH_01 + caducidad de sesión (CNST_002) y UC_PERM_*
   con throttling (CNST_011) podrían beneficiarse, pero
   posiblemente alcance con secuencias.

Hipótesis SPECULATIVE hasta que se evalúen en MEASURE.

## Próximos pasos (no ejecutar ahora)

- Phase 1 DISCOVER: inventariar UCs IACT con
  restricciones temporales explícitas; revisar las
  guidelines existentes de PlantUML.
- Phase 2 MEASURE: si procede, recoger durations reales
  de los UCs candidatos (logs, traces) para anclar los
  diagramas.
- Phase 3 ANALYZE: descartar UCs donde un timing diagram
  no aporta sobre secuencias/estados.
- Phase 6 PLAN: definir alcance del documento final.
- Phase 7 DESIGN: convenciones PlantUML del proyecto
  para timing.
- Phase 10 EXECUTE: redactar la versión 1.0.0 del
  ``diagramas-tiempo.rst`` y archivar el ejemplo
  preliminar.

## Trazabilidad

- Documento preliminar:
  ``source/requisitos/_metodologia-aplicacion/diagramas-tiempo.rst``
  (v0.1.0, Borrador).
- Doc raíz que clasifica las familias UML:
  ``source/requisitos/_metodologia-aplicacion/diagramas-uml.rst``.
- WPs relacionados en hold:
  ``2026-04-30-15-54-58-cherry-pick-estructura-corporativa``,
  ``2026-04-30-19-30-24-token-consumption-analysis``.
- Restricciones potencialmente relevantes: CNST_002,
  CNST_006, CNST_007, CNST_008, CNST_011, CNST_017,
  CNST_019, CNST_020.

## Cierre

Este WP no se cierra por inferencia (I-011). Solo se
cierra cuando el ejecutor lo ordene explícitamente tras
completar las phases 1-10 y publicar la versión 1.0.0 de
``diagramas-tiempo.rst``.
