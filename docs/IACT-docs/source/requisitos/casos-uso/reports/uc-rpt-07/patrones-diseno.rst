.. _uc-rpt-07-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - schedule_reports
 * - **P-39**
   - Audit reforzado
   - lifecycle eventos
 * - **P-64**
   - Re-check at execution
   - permiso re-validado
 * - **P-66** (nuevo)
   - Auto-pause on
     consecutive failure
   - 3 fallos → pause
 * - **P-67** (nuevo)
   - Idempotent scheduler tick
   - reuso de next_run_at;
     advisory lock por job

10.2 P-66: Auto-pause on consecutive failure
============================================

**Problema**: schedules que fallan
repetidamente (e.g., permiso permanente
revocado, datos inaccesibles) inundan la
cola y mailbox.

**Solucion**: tras N fallos consecutivos
auto-pause + notify. User debe revisar y
resume manualmente.

10.3 P-67: Idempotent scheduler tick
====================================

**Problema**: si el scheduler corre en
multi-replica o reinicia mid-tick, mismo
schedule podria ejecutarse 2x.

**Solucion**:

- Advisory lock (DB row lock) o leasing
  por job_id antes de enqueue.
- Update de ``next_run_at`` atomico con
  enqueue.
- Worker chequea ``execution_id`` para
  evitar doble pickup.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-39
   - audit eventos
 * - P-64
   - PASO E3
 * - P-66
   - FA-04
 * - P-67
   - PASO E1-E2
