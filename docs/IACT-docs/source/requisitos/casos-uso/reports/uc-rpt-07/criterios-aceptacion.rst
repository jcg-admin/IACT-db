.. _uc-rpt-07-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Crear daily
======================

POST con frequency=daily → 201 +
next_run_at correcto.

9.2 CA-02: Crear weekly
=======================

frequency=weekly + day_of_week → next_run
en el dia correcto.

9.3 CA-03: Crear monthly
========================

frequency=monthly + day_of_month → next_run
correcto.

9.4 CA-04: Crear cron
=====================

cron_expr valido aceptado.

9.5 CA-05: Cron invalido
========================

400 INVALID_CRON.

9.6 CA-06: Frecuencia < 1h
==========================

400.

9.7 CA-07: > 10 schedules
=========================

11ª → 429.

9.8 CA-08: Ejecucion automatica
===============================

Llega next_run_at → ExportJob creado.

9.9 CA-09: Permiso revocado entre runs
======================================

Skip + audit; schedule continua activo.

9.10 CA-10: 3 fallos auto-pause
===============================

Tras 3 ejecuciones fallidas → status=
auto_paused + mailbox notify.

9.11 CA-11: Update existente
============================

PATCH actualiza next_run_at.

9.12 CA-12: Delete
==================

DELETE remueve del scheduler.

9.13 CA-13: Pause / resume
==========================

Cambios reflejados en proxima evaluacion.

9.14 CA-14: Run-now manual
==========================

POST run-now → ExportJob inmediato.

9.15 CA-15: Audit completo
==========================

CREATED, EXECUTED, FAILED, PAUSED,
RESUMED, DELETED.

9.16 CA-16: Sin permiso
=======================

403 + UNAUTHORIZED.

9.17 CA-17: Idempotencia
========================

Re-tick del scheduler no duplica
ejecucion.

9.18 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Crear frecuencias
   - Funcional
 * - CA-05..07
   - Validacion
   - Robustez
 * - CA-08
   - Ejecucion auto
   - Funcional
 * - CA-09..10
   - Recovery
   - Confiabilidad
 * - CA-11..14
   - CRUD + run-now
   - Funcional
 * - CA-15
   - Audit
   - Compliance
 * - CA-16
   - Sin permiso
   - Seguridad
 * - CA-17
   - Idempotencia
   - Confiabilidad
