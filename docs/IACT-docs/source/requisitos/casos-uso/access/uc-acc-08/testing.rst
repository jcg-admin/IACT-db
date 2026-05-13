.. _uc-acc-08-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests Given/When/Then. Stack-agnostico.

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
   - 12
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujos UI completos

12.2 Tests unitarios
====================

12.2.1 grant happy (CA-01)
--------------------------

::

   GIVEN invoker con grant_exceptional_permission
     AND payload valido (functions,
         expires_at en bounds, justification
         ≥ 20 chars)
   WHEN  grant_exceptional_permission
   THEN  ExceptionalPermission ACTIVE creados
   AND   InternalMessage emitido
   AND   AuditEvent
         EXCEPTIONAL_PERMISSION_GRANTED
   AND   PermissionCache invalidate llamado

12.2.2 justification corta (CA-02)
----------------------------------

::

   GIVEN justification con 10 chars
   WHEN  grant
   THEN  raise ValidationError

12.2.3 expires_at out of bounds (CA-03)
---------------------------------------

::

   GIVEN expires_at = NOW()+100 dias
   WHEN  grant
   THEN  raise ValidationError

12.2.4 expires_at obligatorio (CA-04)
-------------------------------------

::

   GIVEN payload sin expires_at
   WHEN  grant
   THEN  raise ValidationError

12.2.5 Auto-grant prohibido (CA-05)
-----------------------------------

::

   GIVEN invoker.id == target.id
   WHEN  grant
   THEN  raise SelfGrantForbidden

12.2.6 SoD violation (CA-06)
----------------------------

::

   GIVEN funcion en conflicto SoD
   WHEN  grant
   THEN  raise SoDViolation
   AND   ningun ExceptionalPermission creado

12.2.7 Mailbox-or-abort hard (CA-07)
------------------------------------

::

   GIVEN InternalMailbox.send lanza
   WHEN  grant
   THEN  excepcion propagada
   AND   ROLLBACK total
   AND   ningun ExceptionalPermission

12.2.8 Idempotencia parcial (CA-09)
-----------------------------------

::

   GIVEN target ya tiene ExceptionalPermission
         ACTIVE para function 1
     AND payload [1, 2]
   WHEN  grant
   THEN  granted = [2]
   AND   skipped = [1]

12.2.9 Re-grant post EXPIRED (CA-10)
------------------------------------

::

   GIVEN ExceptionalPermission(user, fn=1,
         state=EXPIRED)
   WHEN  grant con [1]
   THEN  nuevo ExceptionalPermission ACTIVE
   AND   EXPIRED preservado

12.2.10 ticket_reference required (CA-11)
-----------------------------------------

::

   GIVEN politica REQUIRE_TICKET=true
     AND justification sin TKT-
   WHEN  grant
   THEN  raise TicketReferenceRequired

12.2.11 Audit reforzado (CA-12)
-------------------------------

::

   GIVEN grant exitoso
   WHEN  inspecciono AuditEvent.payload
   THEN  contiene justification, expires_at,
         ticket_reference, function_ids,
         target_user_id
   AND   no contiene email/full_name
         (CNST-026)

12.2.12 Cache post-COMMIT (CA-13)
---------------------------------

::

   GIVEN flujo exitoso
   WHEN  TransactionManager.atomic retorna
   THEN  PermissionCache.invalidate DESPUES

12.3 Integracion
================

12.3.1 POST 201
---------------

::

   GIVEN invoker autenticado con la funcion
         + payload valido
   WHEN  POST
   THEN  status == 201

12.3.2 Sin permiso 403 (CA-08)
------------------------------

::

   GIVEN invoker sin grant_exceptional_permission
   WHEN  POST
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED ALERTA ALTA

12.3.3 Auto-grant 400 (CA-05)
-----------------------------

::

   GIVEN invoker == target
   WHEN  POST
   THEN  status == 400 SELF_GRANT_FORBIDDEN
   AND   AuditEvent ALERTA CRITICA

12.3.4 justification corta 400
------------------------------

::

   GIVEN justification = "ok"
   WHEN  POST
   THEN  status == 400 VALIDATION_ERROR

12.3.5 expires_at bounds 400
----------------------------

::

   GIVEN expires_at = NOW()+200 dias
   WHEN  POST
   THEN  status == 400 VALIDATION_ERROR

12.3.6 SoD 409
--------------

::

   GIVEN conflicto SoD
   WHEN  POST
   THEN  status == 409 SOD_VIOLATION

12.3.7 Mailbox fail 500 rollback (CA-07)
----------------------------------------

::

   GIVEN mailbox simulado falla
   WHEN  POST
   THEN  status == 500 MAILBOX_FAILED
   AND   ningun ExceptionalPermission creado

12.3.8 ticket_reference 400
---------------------------

::

   GIVEN politica activa + sin TKT-
   WHEN  POST
   THEN  status == 400
         TICKET_REFERENCE_REQUIRED

12.3.9 Idempotencia parcial 201
-------------------------------

::

   GIVEN function 1 ya granted ACTIVE
   WHEN  POST con [1, 2]
   THEN  body.granted = [2]
   AND   body.skipped = [1]

12.3.10 Cache invalidada (CA-13)
--------------------------------

::

   GIVEN grant exitoso
   WHEN  target hace request inmediato
   THEN  permisos efectivos incluyen las
         excepcionales

12.3.11 Throttling 429 (CA-14)
------------------------------

::

   GIVEN invoker > 10 grants/hora
   WHEN  POST 11
   THEN  status == 429

12.3.12 Cron expiracion (CA-15)
-------------------------------

::

   GIVEN ExceptionalPermission con expires_at
         < NOW()
   WHEN  cron job corre
   THEN  state transita a EXPIRED
   AND   AuditEvent
         EXCEPTIONAL_PERMISSION_EXPIRED

12.4 E2E
========

12.4.1 Admin otorga permiso temporal
------------------------------------

::

   GIVEN admin con la funcion en UI
   WHEN  selecciona functions, fija expires_at,
         escribe justification con TKT-,
         confirma
   THEN  toast con resumen
   AND   target ve nuevas capacidades temporales
         + InternalMessage en buzon

12.4.2 Modal de SoD bloquea
---------------------------

::

   GIVEN funcion en conflicto
   WHEN  click Otorgar
   THEN  modal con detalle SoD
   AND   sin grant

12.4.3 Boton oculto sin la funcion
----------------------------------

::

   GIVEN admin sin grant_exceptional_permission
   WHEN  abre vista
   THEN  boton "Otorgar permiso temporal" no
         visible

12.5 Cobertura
==============

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessService.grant_exceptional_permission
   - ≥ 95%
   - ≥ 90%
 * - JustificationValidator
   - 100%
   - 100%
 * - ExpirationPolicy
   - 100%
   - 100%
 * - MailboxFailurePolicy (HARD)
   - 100%
   - 100%
