.. meta::
 :artefacto: UC_RPT_01
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

.. _uc-rpt-01:

==============================================
UC_RPT_01 — Ver Dashboard
==============================================

Resumen
=======

Dashboard consolidado con KPIs del call
center. Datos read-only desde BD Analytics
(CNST-007), filtrados por segmento del User
(CNST-008). Auto-refresh.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_RPT_01
 * - **Modulo**
   - MOD_Reports
 * - **Funcion RBAC**
   - ``view_reports``
 * - **BReq satisfecho**
   - BReq-001 (visibilidad metricas)

Documentos vinculados
=====================

- :doc:`/requisitos/business-requirements/breq-001-visibilidad-metricas`
- :doc:`/requisitos/casos-uso/reports/uc-rpt-02/index`
  (real-time)
- :doc:`/requisitos/casos-uso/reports/uc-rpt-03/index`
  (historicos)

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
