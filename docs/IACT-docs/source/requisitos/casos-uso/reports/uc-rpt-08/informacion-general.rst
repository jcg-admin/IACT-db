.. _uc-rpt-08-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_08
 * - **Nombre**
   - Ver Reportes Programados
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-007
 * - **Funcion RBAC**
   - ``view_scheduled_reports``

1.2 Proposito
=============

UI de administracion para los schedules
creados con UC_RPT_07. List + detalle +
acciones (pause/resume/delete/run-now).

1.3 Endpoints
=============

- ``GET /api/reports/scheduled/`` — list
- ``GET /api/reports/scheduled/{id}/`` —
  detalle + ultimo execution log
- ``GET /api/reports/scheduled/{id}/runs/``
  — historico de ejecuciones (30d)
- Acciones (pause/resume/delete/run-now):
  ver UC_RPT_07.

1.4 Restricciones
=================

- CNST-008: solo schedules del propio User.
  Auditores con scope amplio ven todos los
  segmentos accesibles.
- CNST-009: JWT.

1.5 Out of scope
================

- Crear / editar (UC_RPT_07).
