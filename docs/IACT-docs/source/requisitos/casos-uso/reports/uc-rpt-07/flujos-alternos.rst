.. _uc-rpt-07-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: Cron expression invalido
===================================

PASO 4 detecta. 400 INVALID_CRON.

4.2 FA-02: User excede 10 schedules
===================================

PASO 5. 429 SCHEDULE_LIMIT_EXCEEDED.

4.3 FA-03: Permiso revocado entre creacion y ejecucion
======================================================

PASO E3. Skip ejecucion + audit. Scheduled
NO se borra (User puede recuperar permiso);
si vuelve, ejecuta normal.

4.4 FA-04: Tras N ejecuciones fallidas, pause auto
==================================================

Tras 3 fallos consecutivos (configurable),
schedule auto-paused; mailbox notify.
Audit SCHEDULED_REPORT_AUTO_PAUSED.

4.5 FA-05: Schedule en horario de mantenimiento
===============================================

Si Analytics esta en mantenimiento,
ejecucion postpuesta hasta ventana proxima
disponible.

4.6 FA-06: Backfill manual
==========================

User pide ejecucion ad-hoc:

::

   POST /api/reports/scheduled/{id}/run-now/

Crea ExportJob inmediato con filtros del
schedule.

4.7 Resumen
===========

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Cron invalido
   - 400
   - validation
 * - FA-02
   - > 10 schedules
   - 429
   - limite
 * - FA-03
   - Permiso revocado
   - skip
   - resume si vuelve
 * - FA-04
   - 3 fallos
   - auto-pause
   - mailbox
 * - FA-05
   - Mantenimiento
   - postpone
   - resume
 * - FA-06
   - Run-now
   - ExportJob inmediato
   - manual
