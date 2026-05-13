.. _uc-rpt-08-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas
====================

- **ScheduledReport** (lista del User).
- **ScheduleExecutionLog** (historico
  ejecuciones).

7.2 Entidades escritas
======================

NINGUNA.

7.3 Indices
===========

- ``ScheduledReport(actor_id, status,
  next_run_at)``.
- ``ScheduleExecutionLog(scheduled_report_id,
  started_at DESC)``.

7.4 Datos NO involucrados
=========================

- Email externo.
- BD operativa.
