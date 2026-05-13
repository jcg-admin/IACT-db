.. meta::
 :artefacto: UC_RPT_04
 :tipo: Caso de Uso (Spec Completa)
 :dominio: requisitos
 :subdominio: casos_uso/reports
 :estado: Vigente
 :version: 5.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Importante
 :normativa: CNST-001, CNST-002, CNST-007, CNST-008, CNST-009, CNST-013

.. _uc-rpt-04:

==============================================
UC_RPT_04 — Exportar Reporte
==============================================

Resumen
=======

Genera un archivo (CSV / XLSX / JSON / PDF)
con los datos de un reporte. Async via
ExportWorker, notifica al User via mailbox
interno (CNST-002), URL firmado para
descarga (P-57).

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Funcion RBAC**
   - ``export_reports``

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
