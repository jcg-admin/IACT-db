.. _uc-perm-08-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Pasos
=========

**PASO 1 — Recepcion**

Frontend envia ``GET /api/me/menu/`` con JWT.

**PASO 2 — Autenticacion**

Middleware valida JWT (CNST-009).
Falla → 401.

**PASO 3 — Resolver locale**

Locale = query.locale ??
header.Accept-Language.first ??
User.preferred_locale ??
"es" (default).

**PASO 4 — Cache lookup**

::

   key = menu:{user_id}:{locale}
   if MenuCache.has(key):
       return cached + cache: true

Si hit, ir a PASO 9.

**PASO 5 — Bulk resolver effective_set**

Invoca PermissionService.check_bulk
(UC_PERM_07) con TODAS las
``function_codes`` registradas en
FunctionRegistry como visibles en menu (las
que tienen metadata de menu).

Resultado: lista de codes con
``allowed = true`` para este User.

**PASO 6 — Filtrar por segmento (CNST-008)**

Funciones de visibilidad (``view_*``)
filtradas por segmento del User. Ya
encapsulado en check_bulk.

**PASO 7 — Construir jerarquia**

Por cada code allowed:

- Lookup en FunctionRegistry → metadata
  ``{domain, section, action, labels,
  icon, order}``
- Insertar en arbol:
  ``domains[d].sections[s].actions[a]``

**PASO 8 — Ordenar**

- Domains por ``order_global``.
- Sections por ``order_in_domain``.
- Actions por ``order_in_section``.

Suprimir domains / sections vacios.

**PASO 9 — Cache write**

::

   MenuCache.set(key, menu, ttl=300)

TTL 5 min default. Invalidate por evento de
cambio (UC_ACC_*, UC_PERM_05/06):
``MenuCache.invalidate(user_id)``.

**PASO 10 — Respuesta**

200 OK con estructura del menu.

**PASO 11 — NO AUDIT**

P-51: no se audita por invocacion del menu.

3.2 Resumen
===========

.. list-table::
 :widths: 8 50 22 20
 :header-rows: 1

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1
   - GET /api/me/menu/
   - View
   - —
 * - 2
   - JWT
   - Middleware
   - 009
 * - 3
   - Resolver locale
   - LocaleResolver
   - —
 * - 4
   - Cache lookup
   - MenuCache
   - —
 * - 5
   - Bulk effective_set
   - PermissionService
   - —
 * - 6
   - Filtrar segmento
   - check_bulk
   - 008
 * - 7
   - Construir arbol
   - MenuBuilder
   - —
 * - 8
   - Ordenar
   - MenuBuilder
   - —
 * - 9
   - Cache write
   - MenuCache
   - —
 * - 10
   - Response 200
   - View
   - —
 * - 11
   - SIN audit
   - —
   - —
