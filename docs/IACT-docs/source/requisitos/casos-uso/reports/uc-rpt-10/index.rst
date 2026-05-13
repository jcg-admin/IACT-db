.. meta::
 :artefacto: UC_RPT_10
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-008, CNST-009

.. _uc-rpt-10:

==============================================
UC_RPT_10 — Guardar Vista
==============================================

Resumen
=======

Vista guardada = filtros + layout
(columnas, orden, charts) + period
relativo. Permite al User reabrir
exactamente como dejo el reporte.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - implícita ``manage_own_views``

Estructura de la spec
=====================

.. toctree::
 :maxdepth: 1
 :caption: Las 12 partes

 informacion-general
 actores-precondiciones
 flujo-principal
 flujos-alternos
 excepciones
 requisitos-no-funcionales
 datos-involucrados
 diagramas-uml
 criterios-aceptacion
 patrones-diseno
 implementacion-tecnica
 testing
