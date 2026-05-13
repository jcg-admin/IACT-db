.. _uc-acc-03-parte-12:

==========================
Parte 12 — Testing
==========================

.. note::

 Tests en pseudocodigo Given/When/Then.
 Stack-agnostico.

12.1 Pyramid
============

.. list-table::
 :widths: 25 25 50
 :header-rows: 1

 * - Capa
   - Cantidad
   - Cobertura objetivo
 * - Unit
   - 10
   - ≥ 90%
 * - Integration
   - 9
   - sub-flujos + EXs
 * - E2E
   - 3
   - flujos UI completos

12.2 Tests unitarios
====================

12.2.1 Aggregator deduplica con multiples sources
-------------------------------------------------

::

   GIVEN target con direct(func=1) Y AGR-6 que
         contiene func=1
   WHEN  Aggregator.aggregate
   THEN  result tiene 1 entry para func=1
   AND   sources tiene 2 elementos (direct +
         via_agr:6)

12.2.2 Aggregator combina 3 fuentes
-----------------------------------

::

   GIVEN target con direct=[1,2],
         AGR-6=[3,4],
         exceptional=[5]
   WHEN  aggregate
   THEN  effective_functions tiene 5 entries
   AND   via_direct_count=2,
         via_agr_count=2, via_exc_count=1

12.2.3 Aggregator sin permisos
------------------------------

::

   GIVEN target sin Assignments y sin
         exceptional
   WHEN  aggregate
   THEN  effective_functions == []

12.2.4 ExpiredPendingDetector identifica
----------------------------------------

::

   GIVEN Assignment ACTIVE con
         expires_at = NOW() - 1h
   WHEN  detect
   THEN  result incluye el Assignment

12.2.5 SoDValidator info-mode no lanza
--------------------------------------

::

   GIVEN par conflictivo en effective_set
   WHEN  find_violations_info_mode
   THEN  return list con violations
         (NO lanza SoDViolation)

12.2.6 get_effective_permissions happy
--------------------------------------

::

   GIVEN target con [direct:[1], agr:[6 con
         funcs [2,3]], exceptional:[4]]
   WHEN  get_effective_permissions
   THEN  effective_total_count == 4
   AND   AuditEvent EFFECTIVE_PERMISSIONS_VIEWED

12.2.7 Self-view bypass
-----------------------

::

   GIVEN invoker SIN view_assignments
   WHEN  get_effective_permissions(invoker.id,
                                    invoker)
   THEN  no lanza SinPermiso
   AND   self_view == true

12.2.8 No self → permission required
------------------------------------

::

   GIVEN invoker SIN view_assignments
   WHEN  get_effective_permissions(other_user_id,
                                    invoker)
   THEN  raise SinPermiso

12.2.9 Audit con counts correctos
---------------------------------

::

   GIVEN flujo exitoso con 3 direct + 5 agr +
         1 exceptional
   WHEN  inspecciono AuditEvent payload
   THEN  via_direct_count=3, via_agr_count=5,
         via_exceptional_count=1

12.2.10 Audit sin PII (CA-10)
-----------------------------

::

   GIVEN AuditEvent emitido
   THEN  payload NO contiene email,
         full_name del target

12.3 Tests de integracion
=========================

12.3.1 Endpoint GET 200 (CA-01)
-------------------------------

::

   GIVEN invoker con view_assignments
     AND target con permisos
   WHEN  GET /api/users/{id}/effective-permissions/
   THEN  status == 200
   AND   body.effective_total_count > 0

12.3.2 Self-view via /api/auth/me/permissions/
----------------------------------------------

::

   GIVEN cualquier user autenticado
   WHEN  GET /api/auth/me/permissions/
   THEN  status == 200
   AND   body.self_view == true

12.3.3 Sin permiso 403 (CA-05)
------------------------------

::

   GIVEN invoker sin view_assignments
   WHEN  GET /api/users/{other_id}/effective-permissions/
   THEN  status == 403
   AND   AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

12.3.4 User no existe 404 (CA-06)
---------------------------------

::

   GIVEN user_id inexistente
   WHEN  GET
   THEN  status == 404

12.3.5 Deduplicacion (CA-02)
----------------------------

::

   GIVEN target con func=1 directo + via AGR
   WHEN  GET
   THEN  body.effective_functions tiene 1
         entry para func=1
   AND   sources lista ambas

12.3.6 Sin permisos (CA-03)
---------------------------

::

   GIVEN target sin Assignments
   WHEN  GET
   THEN  status == 200
   AND   effective_functions == []

12.3.7 Expired pending detectado (CA-07)
----------------------------------------

::

   GIVEN target con Assignment ACTIVE
         expires_at < NOW()
   WHEN  GET
   THEN  body.expired_pending_purge incluye
         el Assignment

12.3.8 SoD violations informativas (CA-08)
------------------------------------------

::

   GIVEN target con par conflictivo segun
         SoDRule activa
   WHEN  GET
   THEN  body.sod_violations_detected incluye
         la regla

12.3.9 Throttling (CA-13)
-------------------------

::

   GIVEN invoker > 100 GET/min
   WHEN  GET
   THEN  status == 429

12.4 Tests E2E
==============

12.4.1 Admin consulta permisos
------------------------------

::

   GIVEN admin con view_assignments en UI
   WHEN  abre detalle del User
   THEN  tabla muestra funciones efectivas
         con badges de origen

12.4.2 User ve sus propios permisos
-----------------------------------

::

   GIVEN cualquier user autenticado
   WHEN  navega a "/profile/permissions"
   THEN  ve sus permisos (self-view)

12.4.3 Indicador visual SoD
---------------------------

::

   GIVEN target con violacion SoD detectada
   WHEN  admin abre vista
   THEN  alerta destacada con detalle

12.5 Cobertura objetivo
=======================

.. list-table::
 :widths: 50 25 25
 :header-rows: 1

 * - Componente
   - Lineas
   - Branches
 * - AccessService.get_effective_permissions
   - ≥ 95%
   - ≥ 90%
 * - EffectivePermissionsAggregator
   - 100%
   - 100%
 * - ExpiredPendingDetector
   - 100%
   - 100%
 * - SoDValidator (info-mode)
   - 100%
   - 100%
 * - HTTPGetEndpoint
   - ≥ 90%
   - ≥ 85%
