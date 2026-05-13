.. _uc-rpt-07-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Crear schedule
==================

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — RBAC ``schedule_reports`` +
``export_reports``.
PASO 4 — Validar payload (cron parseable,
period_relative valido para frequency).
PASO 5 — Validar User no excede 10
schedules.
PASO 6 — Calcular ``next_run_at``.
PASO 7 — INSERT ScheduledReport.
PASO 8 — Audit SCHEDULED_REPORT_CREATED.
PASO 9 — Response 201.

3.2 Ejecucion automatica
========================

PASO E1 — Scheduler tick: query schedules
con next_run_at <= now().
PASO E2 — Para cada match: enqueue
ExportJob (con filtros y period_relative
expandido a fechas concretas).
PASO E3 — Re-check permiso del User
(P-64). Si revocado, skip + audit
SCHEDULED_REPORT_PERMISSION_LOST.
PASO E4 — Worker procesa (UC_RPT_04
flujo W).
PASO E5 — Mailbox notify al completar.
PASO E6 — Update ScheduledReport:
``last_run_at = now()``,
``next_run_at = compute_next()``.
PASO E7 — Audit
SCHEDULED_REPORT_EXECUTED.

3.3 Update schedule
===================

PATCH /api/reports/scheduled/{id}/.
Auth + RBAC + validar + UPDATE.
Audit SCHEDULED_REPORT_UPDATED.

3.4 Delete schedule
===================

DELETE /api/reports/scheduled/{id}/.
Audit SCHEDULED_REPORT_DELETED. Scheduler
remove from active list.

3.5 Pause / resume
==================

POST /api/reports/scheduled/{id}/pause/
POST /api/reports/scheduled/{id}/resume/
Audit cambio.

3.6 Resumen
===========

.. list-table::
 :widths: 12 50 38

 * - Paso
   - Accion
   - Componente
 * - C1-C9
   - Crear
   - Endpoint + ScheduleRepo
 * - E1-E7
   - Ejecucion auto
   - Scheduler + Worker
 * - U
   - Update
   - Endpoint
 * - D
   - Delete
   - Endpoint
 * - P/R
   - Pause/Resume
   - Endpoint
