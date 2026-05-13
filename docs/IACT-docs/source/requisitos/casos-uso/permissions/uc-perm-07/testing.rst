.. _uc-perm-07-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

Servicio core — pruebas exhaustivas:

- **Unit**: PrecedenceEvaluator (funcion
  pura), TTL calculator, cache wrapper.
- **Integration**: query agregada contra BD
  test, cache lifecycle.
- **E2E**: endpoint admin + decorator usage.
- **Load**: cumple targets de NFR.

12.2 Tests unitarios
====================

12.2.1 UT-01: Precedence revoke gana
------------------------------------

Inputs: revoke=true, grant=info,
agrs=[A,B] → allowed=false,
origin=REVOKED_EXCEPTIONAL.

12.2.2 UT-02: Precedence grant sin AGR
--------------------------------------

revoke=false, grant=info(valid_until=t),
agrs=[] → allowed=true,
origin=GRANTED_EXCEPTIONAL,
valid_until=t.

12.2.3 UT-03: Precedence AGR otorga
-----------------------------------

revoke=false, grant=null,
agrs=[A,B,C] → allowed=true,
origin=GRANTED_BY_AGR,
via_agr_codes=[A,B,C].

12.2.4 UT-04: Precedence ningun match
-------------------------------------

todos vacios → allowed=false,
origin=DENIED_NO_GRANT.

12.2.5 UT-05: TTL truncado por valid_until
------------------------------------------

valid_until=now+30s, default=60s →
ttl=30s.

12.2.6 UT-06: TTL default cuando null
-------------------------------------

valid_until=null → ttl=60s.

12.2.7 UT-07: Cache key construction
------------------------------------

(user=42, fn="x") → key="perm:42:x".

12.2.8 UT-08: Bypass cache no consulta cache
--------------------------------------------

Mock cache para verificar que NO se llama
si bypass_cache=true.

12.2.9 UT-09: Tie-breaker revoke vs grant
-----------------------------------------

Ambos activos para misma fn → revoke gana.
Determinismo verificado.

12.2.10 UT-10: Invalidate borra todas keys del User
---------------------------------------------------

invalidate(user_id=42) → cache.delete con
patron ``perm:42:*``.

12.3 Tests de integracion
=========================

12.3.1 IT-01: AGR otorga (cache miss)
-------------------------------------

Setup: User en AGR con F. check(F).

ENTONCES: query a BD ejecutada, response
GRANTED_BY_AGR, cache poblado.

12.3.2 IT-02: AGR INACTIVE no cuenta
------------------------------------

AGR.state=INACTIVE → DENIED_NO_GRANT.

12.3.3 IT-03: Assignment expirado no cuenta
-------------------------------------------

Assignment.valid_until pasado → DENIED.

12.3.4 IT-04: Concesion expirada no cuenta
------------------------------------------

GRANT con valid_until pasado → DENIED.

12.3.5 IT-05: Revocacion sobre AGR
----------------------------------

User en AGR + ExceptionalPermission REVOKE →
allowed=false, REVOKED_EXCEPTIONAL.

12.3.6 IT-06: Multi-AGR retorna lista
-------------------------------------

3 AGRs otorgan F → via_agr_codes tiene 3.

12.3.7 IT-07: Cache hit segunda llamada
---------------------------------------

check 1 (miss) → cache poblado. check 2
(hit). Response cache=true; sin query a BD.

12.3.8 IT-08: Cache invalidate revierte
---------------------------------------

check 1 → check 2 (hit). invalidate(U) →
check 3 = miss.

12.3.9 IT-09: Bulk con mix de hits y misses
-------------------------------------------

50 codes, 30 ya cacheados, 20 nuevos →
1 query a BD (solo para los 20).

12.3.10 IT-10: BD timeout fail-closed
-------------------------------------

Inyectar timeout en query → exception.
Caller decorator deniega accion.

12.3.11 IT-11: Function no existe
---------------------------------

function_code no en catalogo →
FunctionNotFound 400.

12.4 Tests E2E
==============

12.4.1 E2E-01: Endpoint admin happy path
----------------------------------------

GET .../check/?function=view_kpi_dashboard
con caller que tiene view_assignments →
200 con response completa.

12.4.2 E2E-02: Endpoint admin sin permiso
-----------------------------------------

Caller sin view_assignments → 403 +
audit UNAUTHORIZED.

12.4.3 E2E-03: Decorator deniega
--------------------------------

Endpoint con
``@require_function('manage_users')``,
User sin la funcion → 403.

12.4.4 E2E-04: Decorator concede
--------------------------------

User con la funcion via AGR → 200.

12.4.5 E2E-05: Concesion temporal funciona
------------------------------------------

User sin AGR para F → 403.
Admin emite GRANT (UC_ACC_06).
User intenta accion → 200 (allowed via
GRANTED_EXCEPTIONAL).

12.4.6 E2E-06: Cache stale mitigation
-------------------------------------

User permitido → cache poblado.
Revocacion emitida → cache invalidado por
evento.
Nueva accion del User → 403.

12.5 Tests de carga
===================

12.5.1 LOAD-01: Throughput cache hit
------------------------------------

Mismo (user, fn) repetido → ≥ 5000 req/s
por nodo, P50 ≤ 5 ms.

12.5.2 LOAD-02: Throughput cache miss
-------------------------------------

Pares (user, fn) unicos →
≥ 1500 req/s por nodo, P95 ≤ 30 ms.

12.5.3 LOAD-03: Bulk 50 codes
-----------------------------

P50 ≤ 30 ms, P95 ≤ 60 ms.

12.6 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - AGR otorga
   - UT-03, IT-01
 * - CA-02
   - Revoke gana
   - UT-01, UT-09, IT-05
 * - CA-03
   - GRANT sin AGR
   - UT-02, E2E-05
 * - CA-04
   - Sin nada DENIED
   - UT-04
 * - CA-05
   - AGR INACTIVE
   - IT-02
 * - CA-06
   - Assignment expirado
   - IT-03
 * - CA-07
   - GRANT expirado
   - IT-04
 * - CA-08
   - Multi-AGR
   - IT-06
 * - CA-09
   - Cache hit
   - IT-07
 * - CA-10
   - Invalidate
   - UT-10, IT-08, E2E-06
 * - CA-11
   - Bulk
   - IT-09, LOAD-03
 * - CA-12
   - Function not found
   - IT-11
 * - CA-13
   - User not found
   - (path 404)
 * - CA-14
   - Sin permiso admin
   - E2E-02
 * - CA-15
   - Fail-closed BD timeout
   - IT-10
 * - CA-16
   - Sin audit invocacion
   - (audit log assertion en E2E)
 * - CA-17
   - TTL truncado
   - UT-05

12.7 Cobertura
==============

- 10 unit tests
- 11 integration tests
- 6 E2E tests
- 3 load tests
- 100% de los 17 CAs cubiertos
- Path crítico: precedencia (UT) +
  cache (IT) + carga (LOAD).
