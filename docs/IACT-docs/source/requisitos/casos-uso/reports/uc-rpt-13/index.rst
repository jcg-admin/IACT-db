.. meta::
 :artefacto: UC_RPT_13
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-007, CNST-008, CNST-009

.. _uc-rpt-13:

==============================================
UC_RPT_13 — Reporte de Colas
==============================================

Resumen
=======

Reporte por cola con metricas: ASA
(average speed of answer), abandono, SL,
calls offered/answered. Drill por cola
individual.

.. list-table::
 :widths: 25 75

 * - **Funcion RBAC**
   - ``view_queue_reports``

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
