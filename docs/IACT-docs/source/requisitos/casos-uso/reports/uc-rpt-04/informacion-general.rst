.. _uc-rpt-04-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_RPT_04
 * - **Nombre**
   - Exportar Reporte
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001, BReq-003
 * - **Funcion RBAC**
   - ``export_reports``

1.2 Proposito
=============

Generar archivos descargables a partir de
los reportes que el User ya puede ver
(UC_RPT_01/02/03 y derivados). Para
auditoría externa, analisis offline,
distribucion controlada.

1.3 Formatos soportados
=======================

- CSV (default)
- XLSX
- JSON
- PDF (resumen visual, no datos masivos)

1.4 Limites
===========

- Max rows por export: 1M (configurable).
- Max archivo: 200 MB.
- Retencion archivo: 24h.
- Max jobs simultaneos por User: 5.
- TTL de URL firmado: 24h.

1.5 Restricciones
=================

- CNST-001: NO email externo. URL firmado
  + mailbox interno.
- CNST-002: notificacion en mailbox.
- CNST-007: read Analytics.
- CNST-008: filtro segmento.
- CNST-009: JWT.

1.6 Audit reforzado (P-39)
==========================

Cada export es operacion sensitiva (datos
salen del sistema). P-39 reforzado:

- ``REPORT_EXPORT_QUEUED`` con filtros
  + format
- ``REPORT_EXPORT_COMPLETED`` con
  byte_count + row_count
- ``REPORT_EXPORT_FAILED`` con motivo

1.7 Out of scope
================

- Programar exports recurrentes →
  UC_RPT_07.
- Compartir export a otros Users →
  UC_RPT_11.
