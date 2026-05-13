.. _uc-rpt-07-parte-06:

==========================================
Parte 6 — Requisitos no funcionales
==========================================

6.1 Performance
===============

- Crear / update: ≤ 100 ms.
- Scheduler tick interval: 1 min.
- Latencia de ejecucion vs scheduled time:
  ≤ 1 min P95.

6.2 Confiabilidad
=================

- Disponibilidad scheduler ≥ 99.9%.
- Recuperacion automatica tras restart
  (next_run_at persistido).
- Idempotencia: re-ejecucion del mismo
  trigger no duplica.

6.3 Seguridad
=================

- ``schedule_reports`` enforcement.
- Re-check al ejecutar (P-64).
- Schedules limitados a segmento del User.

6.4 Auditabilidad
=================

- CREATED, UPDATED, DELETED, PAUSED,
  RESUMED, EXECUTED, AUTO_PAUSED.
- Failed ejecuciones registran motivo.

6.5 Usabilidad
==============

- UI de cron amigable (selector de
  frecuencia).
- Preview de proximas ejecuciones (next 5).
- Indicador de salud por schedule.

6.6 Mantenibilidad
==================

- Scheduler como servicio independiente.
- Compatibilidad con cron estandar (libreria).
