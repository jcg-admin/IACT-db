.. _uc-perm-04-parte-12:

==========================
Parte 12 — Testing
==========================

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura
 * - Unit
   - 12
   - ≥ 90%
 * - Integration
   - 11
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujos UI

12.2 Tests unitarios
====================

12.2.1 revoke happy (CA-01)
---------------------------

::

   GIVEN invoker con
         revoke_exceptional_permission
     AND permission ACTIVE
   WHEN  revoke_exceptional_permission
   THEN  state = REVOKED
   AND   revoked_by_admin_id == invoker.id
   AND   AuditEvent
         EXCEPTIONAL_PERMISSION_REVOKED
   AND   InternalMessage emitido

12.2.2 Idempotencia (CA-03, FA-01)
----------------------------------

::

   GIVEN permission state=REVOKED
   WHEN  revoke
   THEN  AuditEvent REVOKE_NOOP
   AND   sin cambios en BD

12.2.3 EXPIRED no revocable (CA-04)
-----------------------------------

::

   GIVEN permission state=EXPIRED
   WHEN  revoke
   THEN  raise InvalidState

12.2.4 URL mismatch (CA-09)
---------------------------

::

   GIVEN permission_id no pertenece al
         user_id del path
   WHEN  revoke
   THEN  raise URLMismatch

12.2.5 P-11 anti-self (CA-07)
-----------------------------

::

   GIVEN invoker.id == permission.user_id
   WHEN  revoke
   THEN  raise SelfRevokeForbidden

12.2.6 reason corta (CA-06)
---------------------------

::

   GIVEN reason con 10 chars
   WHEN  revoke
   THEN  raise ValidationError

12.2.7 Mailbox HARD (CA-08)
---------------------------

::

   GIVEN InternalMailbox.send lanza
   WHEN  revoke
   THEN  raise MailboxFailure
   AND   ROLLBACK total

12.2.8 Atomicidad audit fail (CA-10)
------------------------------------

::

   GIVEN AuditLog.emit lanza
   WHEN  revoke
   THEN  ROLLBACK total

12.2.9 Cache post-COMMIT (CA-11)
--------------------------------

::

   GIVEN flujo exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  PermissionCache.invalidate llamado
         DESPUES

12.2.10 Diferencia con EXPIRED (CA-02)
--------------------------------------

::

   GIVEN flujo exitoso
   WHEN  inspecciono Permission
   THEN  revoked_by_admin_id != NULL
   AND   AuditEvent.event_type ==
         EXCEPTIONAL_PERMISSION_REVOKED

12.2.11 previous_expires_at preservado
--------------------------------------

::

   GIVEN permission con expires_at futuro
   WHEN  revoke
   THEN  AuditEvent.payload.previous_expires_at
         == expires_at original

12.2.12 Audit reforzado (CA-14)
-------------------------------

::

   GIVEN AuditEvent emitido
   WHEN  inspecciono priority tag
   THEN  high-priority

12.3 Integracion
================

12.3.1 DELETE 200 (CA-01)
-------------------------

::

   GIVEN payload valido
   WHEN  DELETE
   THEN  status == 200

12.3.2 Sin permiso 403 (CA-05)
------------------------------

::

   GIVEN invoker sin
         revoke_exceptional_permission
   WHEN  DELETE
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED ALERTA

12.3.3 Permission no existe 404 (EX-03)
---------------------------------------

::

   GIVEN permission_id inexistente
   WHEN  DELETE
   THEN  status == 404

12.3.4 Idempotencia 200 NOOP (CA-03)
------------------------------------

::

   GIVEN permission ya REVOKED
   WHEN  DELETE
   THEN  status == 200 informativo

12.3.5 EXPIRED 400 (CA-04)
--------------------------

::

   GIVEN permission EXPIRED
   WHEN  DELETE
   THEN  status == 400 INVALID_STATE

12.3.6 URL mismatch 400 (CA-09)
-------------------------------

::

   GIVEN url con user_id incorrecto
   WHEN  DELETE
   THEN  status == 400 URL_MISMATCH

12.3.7 Auto-revoke 400 (CA-07)
------------------------------

::

   GIVEN politica P-11 activa
     AND invoker == target
   WHEN  DELETE
   THEN  status == 400

12.3.8 reason vacio 400 (CA-06)
-------------------------------

::

   GIVEN payload sin reason
   WHEN  DELETE
   THEN  status == 400

12.3.9 Mailbox HARD rollback (CA-08)
------------------------------------

::

   GIVEN mailbox simulado falla
   WHEN  DELETE
   THEN  status == 500 MAILBOX_FAILED
   AND   permission permanece ACTIVE

12.3.10 Throttling 429 (CA-13)
------------------------------

::

   GIVEN > 30 DELETE/hora
   WHEN  DELETE
   THEN  status == 429

12.3.11 AuditEvent diferenciado de EXPIRED
------------------------------------------

::

   GIVEN un permission revocado por
         UC_PERM_04
     AND otro EXPIRED por cron
   WHEN  inspecciono AuditEvents
   THEN  primer event_type ==
         EXCEPTIONAL_PERMISSION_REVOKED
   AND   segundo event_type ==
         EXCEPTIONAL_PERMISSION_EXPIRED

12.4 E2E
========

12.4.1 Admin revoca via UI
--------------------------

::

   GIVEN admin con
         revoke_exceptional_permission
   WHEN  abre lista de excepcionales del User,
         selecciona uno, ingresa reason,
         confirma
   THEN  toast confirma
   AND   permission marcado REVOKED en lista

12.4.2 Modal robusto con reason
-------------------------------

::

   GIVEN modal abierto
   WHEN  invoker no escribe reason
   THEN  boton confirmar deshabilitado

12.4.3 Boton oculto sin permiso
-------------------------------

::

   GIVEN invoker sin permiso
   WHEN  abre lista
   THEN  boton "Revocar" no visible

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessService.revoke_exceptional
   - ≥ 95%
   - ≥ 90%
 * - HTTPDeleteEndpoint
   - ≥ 90%
   - ≥ 85%
 * - AntiSelfActionPolicy
   - 100%
   - 100%
