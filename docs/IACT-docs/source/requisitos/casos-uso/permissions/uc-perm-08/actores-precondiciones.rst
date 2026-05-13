.. _uc-perm-08-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **User autenticado**
   - Humano
   - Pide su propio menu
 * - **Frontend**
   - Sistema
   - Invoca el endpoint
 * - **PermissionService**
   - Sistema
   - Bulk-resuelve effective_set
     (UC_PERM_07)
 * - **FunctionRegistry**
   - Sistema
   - Aporta metadata jerárquica de
     cada Function
 * - **MenuCache**
   - Sistema
   - Cache de la estructura

2.2 Precondiciones
==================

- User autenticado (JWT valido).
- BD accesible.
- Function registry disponible.

2.3 Postcondiciones
===================

- Sin escritura a BD.
- MenuCache puede haberse poblado.
- Response con estructura del menu del User.

2.4 Datos de entrada
====================

Implícitos del JWT:

- ``user_id`` (caller)
- locale (Accept-Language) — opcional, para
  labels traducidos

Sin body. Endpoint:

::

   GET /api/me/menu/

Variante con locale:

::

   GET /api/me/menu/?locale=es

2.5 Datos de salida
===================

::

   {
     domains: [...],
     user_id, generated_at, cache,
     locale_used
   }
