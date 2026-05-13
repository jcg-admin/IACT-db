.. meta::
 :artefacto: UC_RPT_02
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

.. _uc-rpt-02:

==============================================
UC_RPT_02 — Ver Metricas en Tiempo Real
==============================================

Resumen
=======

Vista en tiempo real (refresh ≤ 5s) de
metricas operacionales del call center.
Diferenciacion vs UC_RPT_01: granularidad
sub-minuto, datos de stream Analytics
(near-realtime), conexion persistente
(SSE / WebSocket / long-polling).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - UC_RPT_02
 * - **Funcion RBAC**
   - ``view_realtime_metrics``
 * - **BReq**
   - BReq-001 + BReq-006

Documentos vinculados
=====================

- :doc:`/requisitos/casos-uso/reports/uc-rpt-01/index`

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
