.. _uc-perm-07-parte-03:

==========================
Parte 3 — Flujo principal
==========================

Modo: variante admin (consulta explicita).
La variante interna omite los pasos 1-3
(authorization del caller).

3.1 Pasos
=========

**PASO 1 — Recepcion**

Caller envia
``GET /api/users/{user_id}/permissions/check/?function={code}``
con JWT.

**PASO 2 — Autenticacion**

Middleware valida JWT (CNST-009).
Falla → 401.

**PASO 3 — Autorizacion**

``AuthorizationGuard.has_function(invoker,
'view_assignments')``.
Falla → 403 + AuditEvent UNAUTHORIZED.

**PASO 4 — Validar parametros**

- ``user_id`` numerico.
- ``function_code`` no vacio.
- Existe User → si no, 404.
- Existe Function → si no, 400.

**PASO 5 — Cache lookup**

::

   key = perm:{user_id}:{function_code}
   if cache.has(key):
       return cache.get(key) + cache: true

Si hit, ir a PASO 11.

**PASO 6 — Buscar revocacion excepcional**

Query: ``ExceptionalPermission`` donde:

- ``user_id == user_id``
- ``function_code == function_code``
- ``type == REVOKE``
- ``state == ACTIVE``
- ``valid_until is null OR valid_until > now``

Si match → ``origin = REVOKED_EXCEPTIONAL``,
``allowed = false``. Ir a PASO 10.

**PASO 7 — Buscar concesion excepcional**

Misma query con ``type == GRANT``.

Si match → ``origin = GRANTED_EXCEPTIONAL``,
``allowed = true``,
``valid_until = match.valid_until``.
Ir a PASO 10.

**PASO 8 — Buscar AGR-via-Assignment**

Query: ``Assignment`` JOIN
``AccessGroupFunction`` donde:

- ``Assignment.user_id == user_id``
- ``Assignment.target_type == AGR``
- ``Assignment.state == ACTIVE``
- ``Assignment.valid_until is null OR
  Assignment.valid_until > now``
- ``AccessGroupFunction.function_code ==
  function_code``
- ``AccessGroup.state == ACTIVE``

Si match (uno o mas) →
``origin = GRANTED_BY_AGR``,
``allowed = true``,
``via_agr_codes = [agr.code, ...]``.
Ir a PASO 10.

**PASO 9 — Sin match**

``origin = DENIED_NO_GRANT``,
``allowed = false``.

**PASO 10 — Cache write**

::

   ttl =
     min(remaining_validity, default_ttl)
   cache.set(key, result, ttl=ttl)

TTL default = 60s.
Si hay ``valid_until`` proximo, TTL = min de
los dos. Si la respuesta es DENIED por falta
de grant, TTL puede ser corto (10s) para
reaccionar rapido a nuevas concesiones.

**PASO 11 — Respuesta**

Construir ``CheckPermissionOutput``:

::

   {
     user_id, function_code,
     allowed, origin,
     via_agr_codes (si aplica),
     valid_until (si aplica),
     cache: bool,
     checked_at: now()
   }

200 OK.

**PASO 12 — NO AUDIT por invocacion**

Por escala (millones/dia), este UC NO emite
audit por cada check. La auditoria de uso
esta en UC_PERM_09 (audita acciones que
pasaron el check, no los checks mismos).

Excepcion: si el endpoint admin se usa con
volumen anomalo, alertas via UC_LOG.

3.2 Sub-flujo: bulk check
=========================

Para soporte de UC_PERM_08 (menu) y para
optimizar:

::

   POST /api/users/{user_id}/permissions/check-bulk/
   body: { function_codes: [c1, c2, ..., cN] }

PASOS:

**PASO B1** — auth + RBAC + validar lista
≤ 200 codes.

**PASO B2** — bulk cache lookup. Separar
hits de misses.

**PASO B3** — para los misses, una sola query
agregada que retorna por code: revoke?
grant_excep? agr_set? Esto evita N round
trips.

**PASO B4** — combinar hits + nuevos
resultados.

**PASO B5** — bulk cache write.

**PASO B6** — response:

::

   {
     user_id,
     results: [
       { function_code, allowed, origin, ... },
       ...
     ],
     cache_stats: { hits, misses }
   }

3.3 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1
   - GET .../permissions/check/
   - View
   - —
 * - 2
   - JWT
   - Middleware
   - 009
 * - 3
   - RBAC ``view_assignments``
   - AuthorizationGuard
   - —
 * - 4
   - Validar parametros
   - PayloadValidator
   - —
 * - 5
   - Cache lookup
   - PermissionCache
   - —
 * - 6
   - Revocacion excepcional?
   - Repo
   - —
 * - 7
   - Concesion excepcional?
   - Repo
   - —
 * - 8
   - AGR-via-Assignment?
   - Repo
   - —
 * - 9
   - DENIED_NO_GRANT
   - Service
   - —
 * - 10
   - Cache write
   - PermissionCache
   - —
 * - 11
   - Response 200
   - View
   - —
 * - 12
   - SIN audit (por escala)
   - —
   - —
