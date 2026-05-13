.. _uc-perm-09-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

4.1 FA-01: PII detectado en payload
===================================

Ejemplo: caller incluye email plano del User
en payload por error.

PASO 3 detecta → AuditPIIDetected. Caller
debe sanitizar y reintentar; mientras no lo
haga, la operacion principal NO procede
(P-09 audit-or-abort + CNST-026).

4.2 FA-02: BD timeout en INSERT
===============================

PASO 6 timeout → AuditWriteFailed. Caller
hace ROLLBACK. La operacion del usuario
falla con 500 + audit FAILED visible solo
en log operacional (UC_LOG).

4.3 FA-03: Batch parcialmente fallido
=====================================

Multi-row INSERT atomico: si la BD rechaza
una row, ROLLBACK del batch entero. Caller
investiga cual fue la culpable y reintenta.

4.4 FA-04: Alert engine caido
=============================

PASO 7 falla post-COMMIT. Operacion exitosa.
Evento ya persistido. AlertHook reintenta;
agotados los retries → DLQ + alerta interna
de operaciones (UC_LOG).

4.5 FA-05: Evento de tipo CRITICAL_ACTION
=========================================

Algunas funciones tienen
``audit_required=true`` y
``audit_priority=critical``.

Ejemplo: ``manage_users``,
``manage_access_groups``,
``view_audit_log``.

P-39 (audit reforzado): adicionalmente al
INSERT, el evento se replica
sincronamente a un log append-only
inmutable secundario (cold storage o
WORM-like — implementacion-dependent).

4.6 FA-06: Evento UNAUTHORIZED en denial
========================================

Cualquier UC con AuthorizationGuard que
deniega emite UNAUTHORIZED:

::

   {
     event_type: UNAUTHORIZED,
     actor_id: invoker.id,
     target_type: function,
     target_id: function_code_attempted,
     payload: { method, path, reason }
   }

Sirve para detectar probing.

4.7 FA-07: Evento anonimo (LOGIN_FAILED)
========================================

Antes de auth, ``actor_id`` puede ser null
o "username_attempted":

::

   {
     event_type: LOGIN_FAILED,
     actor_id: null,
     target_type: user_attempted,
     target_id: hash(username_attempted),
     payload: { ip, user_agent }
   }

Se usa hash del username para investigar
patrones sin revelar usernames si la BD se
filtrara.

4.8 FA-08: Evento heredado de otro contexto
===========================================

Caller en contexto async (job) sin
request_id natural. Generar request_id
sintetico:

::

   request_id = "job-" + job_id
                       + "-" + sequence

para correlacionar.

4.9 Resumen
===========

.. list-table::
 :widths: 12 38 30 20
 :header-rows: 1

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - PII detectado
   - bloqueo
   - CNST-026
 * - FA-02
   - BD timeout
   - rollback caller
   - P-09
 * - FA-03
   - Batch parcial
   - rollback batch
   - atomicidad
 * - FA-04
   - Alert engine caido
   - DLQ
   - best-effort
 * - FA-05
   - CRITICAL_ACTION
   - replicacion sincrona
   - P-39
 * - FA-06
   - UNAUTHORIZED
   - emit en denial
   - probing detection
 * - FA-07
   - LOGIN_FAILED
   - actor null + hash
   - patrones
 * - FA-08
   - Job async
   - request_id sintetico
   - correlacion
