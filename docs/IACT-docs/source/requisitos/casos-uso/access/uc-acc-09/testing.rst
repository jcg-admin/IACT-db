.. _uc-acc-09-parte-12:

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
   - Cobertura objetivo
 * - Unit
   - 9
   - ≥ 90%
 * - Integration
   - 11
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujos UI completos

12.2 Tests unitarios
====================

12.2.1 ScopeFilter aplica ACCESS_EVENT_TYPES
--------------------------------------------

::

   GIVEN BD con eventos de ACCESS + AUTH +
         RPT
   WHEN  list_audit
   THEN  results solo contienen eventos
         ACCESS

12.2.2 FilterValidator whitelist (CA-07)
----------------------------------------

::

   GIVEN ordering = "x; DROP TABLE..."
   WHEN  validate
   THEN  raise BadFilter

12.2.3 Audit selectivo P-16 emit (CA-03)
----------------------------------------

::

   GIVEN filters.target_user_id = 42
   WHEN  list_audit
   THEN  AuditLog.emit
         ACCESS_AUDIT_VIEWED

12.2.4 Audit selectivo P-16 NO emit (CA-04)
-------------------------------------------

::

   GIVEN filters sin target_user_id
   WHEN  list_audit
   THEN  AuditLog.emit NO llamado

12.2.5 PIIMasking aplica
------------------------

::

   GIVEN row con email residual
   WHEN  mask_for_audit_view
   THEN  result no contiene email

12.2.6 list happy
-----------------

::

   GIVEN N eventos de ACCESS
   WHEN  list
   THEN  PaginatedResult con count = N

12.2.7 get_event happy
----------------------

::

   GIVEN event_id de ACCESS
   WHEN  get
   THEN  AuditEventDetail completo
   AND   AuditLog emit con
         viewed_event_id

12.2.8 get_event fuera de scope (CA-09)
---------------------------------------

::

   GIVEN event_id de AUTH
   WHEN  get desde access service
   THEN  raise EventNotFound (no leak)

12.2.9 aggregate group_by event_type (CA-10)
--------------------------------------------

::

   GIVEN BD con N eventos por type
   WHEN  aggregate(group_by='event_type')
   THEN  array de {event_type, count}
   AND   AuditLog NO llamado

12.3 Integracion
================

12.3.1 GET listado 200 (CA-01)
------------------------------

::

   GIVEN invoker con view_access_audit
   WHEN  GET /api/access/audit/
   THEN  status == 200

12.3.2 Solo eventos ACCESS (CA-02)
----------------------------------

::

   GIVEN BD con eventos AUTH + ACCESS
   WHEN  GET
   THEN  body.results todos
         event_type ∈ ACCESS_EVENT_TYPES

12.3.3 Sin permiso 403 (CA-05)
------------------------------

::

   GIVEN invoker sin view_access_audit
   WHEN  GET
   THEN  status == 403

12.3.4 Filter target_user_id audita (CA-03)
-------------------------------------------

::

   GIVEN GET ?target_user_id=42
   WHEN  GET
   THEN  AuditEvent ACCESS_AUDIT_VIEWED

12.3.5 Filter sin target NO audita (CA-04)
------------------------------------------

::

   GIVEN GET sin target
   WHEN  GET
   THEN  ZERO AuditEvent
         ACCESS_AUDIT_VIEWED

12.3.6 Anti-SQLi en ordering (CA-07)
------------------------------------

::

   GIVEN ordering = "; DROP TABLE..."
   WHEN  GET
   THEN  status == 400 BAD_FILTER

12.3.7 Detalle 200 (CA-08)
--------------------------

::

   GIVEN event_id ACCESS valido
   WHEN  GET /api/access/audit/{id}/
   THEN  status == 200

12.3.8 Detalle fuera de scope 404 (CA-09)
-----------------------------------------

::

   GIVEN event_id de AUTH
   WHEN  GET /api/access/audit/{id}/
   THEN  status == 404

12.3.9 Aggregations 200 (CA-10)
-------------------------------

::

   GIVEN GET aggregations group_by=event_type
   THEN  status == 200
   AND   ZERO AuditEvent

12.3.10 Filter function_id (CA-11)
----------------------------------

::

   GIVEN GET ?includes_function_id=42
   WHEN  GET
   THEN  body.results todos contienen 42 en
         payload.function_ids

12.3.11 Throttling 429 (CA-14)
------------------------------

::

   GIVEN > 200 GET/min
   WHEN  GET
   THEN  status == 429

12.4 E2E
========

12.4.1 Auditor consulta historial
---------------------------------

::

   GIVEN auditor en UI
   WHEN  abre vista, aplica filter
         occurred_after=hoy
   THEN  tabla con eventos del dia

12.4.2 Auditor investiga User especifico
----------------------------------------

::

   GIVEN auditor abre detalle del User X
   WHEN  filter target_user_id=X
   THEN  vista historica del User
   AND   AuditEvent
         ACCESS_AUDIT_VIEWED registra
         consulta

12.4.3 Sin permiso vista oculta
-------------------------------

::

   GIVEN user sin view_access_audit
   WHEN  intenta navegar a /admin/audit-access
   THEN  vista oculta o 403

12.5 Cobertura
==============

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessAuditService
   - ≥ 95%
   - ≥ 90%
 * - ScopeFilter
   - 100%
   - 100%
 * - FilterValidator
   - 100%
   - 100%
 * - PIIMaskingStrategy
   - 100%
   - 100%
 * - HTTPEndpoints
   - ≥ 90%
   - ≥ 85%
