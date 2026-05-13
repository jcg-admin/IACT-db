.. _uc-rpt-07-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- Unit: ScheduleValidator, compute_next.
- Integration: tick + enqueue + permission
  recheck.
- E2E: User crea + scheduler ejecuta +
  recibe mailbox.
- Concurrency: doble tick no duplica.

12.2 Tests unitarios
====================

UT-01: cron expression valido aceptado.
UT-02: cron invalido rechazado.
UT-03: compute_next daily at 7am →
correcto.
UT-04: compute_next weekly Monday →
correcto.
UT-05: compute_next con DST transition.
UT-06: frequency < 1h rechazado.

12.3 Tests de integracion
=========================

IT-01: Crear schedule daily, simular
tick → ExportJob creado.
IT-02: Permiso revocado en re-check →
skip + audit.
IT-03: 3 fallos consecutivos → auto_paused.
IT-04: Pause / resume.
IT-05: Update cambia next_run_at.
IT-06: Delete remueve del pipeline.
IT-07: 11ª schedule → 429.
IT-08: Run-now → ExportJob inmediato.

12.4 Tests E2E
==============

E2E-01: User crea + 24h despues recibe
mailbox con archivo.
E2E-02: Update inline funciona.

12.5 Tests de concurrencia
==========================

CONC-01: 2 schedulers ticks simultaneos →
1 enqueue (lock).
CONC-02: Restart mid-tick → no duplica.

12.6 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - Crear frecuencias
   - UT-03..05, IT-01
 * - CA-05..06
   - Validacion
   - UT-02, UT-06
 * - CA-07
   - Limite
   - IT-07
 * - CA-08
   - Auto exec
   - IT-01, E2E-01
 * - CA-09
   - Re-check
   - IT-02
 * - CA-10
   - Auto pause
   - IT-03
 * - CA-11..14
   - CRUD
   - IT-04..06, IT-08
 * - CA-15
   - Audit
   - integration assertions
 * - CA-16
   - Sin permiso
   - E2E
 * - CA-17
   - Idempotencia
   - CONC-01..02

12.7 Cobertura
==============

- 6 unit tests
- 8 integration tests
- 2 E2E tests
- 2 concurrency tests
- 100% de los 17 CAs
