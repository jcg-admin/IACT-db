.. _uc-perm-08-parte-11:

=================================
Parte 11 — Implementacion tecnica
=================================

11.1 Componentes logicos
========================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Componente
   - Responsabilidad
 * - **MenuEndpoint**
   - GET /api/me/menu/
 * - **AuthMiddleware**
   - JWT
 * - **LocaleResolver**
   - resolver locale efectivo
 * - **MenuCache**
   - get / set / invalidate
 * - **FunctionRegistry**
   - listado + metadata
 * - **MenuBuilder**
   - construye arbol jerarquico
 * - **PermissionService**
   - delegacion a UC_PERM_07
     (check_bulk)
 * - **MenuInvalidator**
   - listener de eventos de cambio

11.2 Contratos
==============

::

   contract MenuBuilder:
     build(user_id: int,
           locale: string)
       returns: Menu
       throws: BDTimeout, RegistryError

   data Menu:
     domains: list[Domain]
     user_id: int
     locale_used: string
     generated_at: timestamp
     cache: bool

   data Domain:
     code: string
     label: string
     order: int
     sections: list[Section]

   data Section:
     code: string
     label: string
     icon: string
     order: int
     actions: list[Action]

   data Action:
     code: string
     label: string
     function_code: string
     order: int

11.3 Pseudocodigo
=================

::

   procedure build_menu(user_id, locale):
       key = "menu:" + user_id + ":" + locale

       if MenuCache.has(key):
           return MenuCache.get(key)
                          + cache: true

       # Lista de codes navegables
       registry_entries =
         FunctionRegistry.list(menu_visible=true)
       codes = [e.function_code
                for e in registry_entries]

       # Bulk check (UC_PERM_07)
       results =
         PermissionService.check_bulk(
           user_id, codes)
       allowed_codes =
         { r.function_code
           for r in results
           if r.allowed }

       # Construir arbol
       domains_map = {}
       for entry in registry_entries:
           if entry.function_code not in
                                   allowed_codes:
               continue
           d = entry.menu_domain
           s = entry.menu_section
           a = entry.menu_action
           label = entry.label_for(locale)
           ensure_domain(domains_map, d, locale)
           ensure_section(
             domains_map[d], s, entry.icon,
             entry.section_order, locale)
           append_action(
             domains_map[d][s],
             code=a, label=label,
             function_code=entry.function_code,
             order=entry.menu_order)

       # Ordenar y suprimir vacios
       domains = sorted(
         [d for d in domains_map
            if not is_empty(d)],
         key=lambda d: d.order)
       for d in domains:
           d.sections = sorted(
             [s for s in d.sections
                if s.actions],
             key=lambda s: s.order)
           for s in d.sections:
               s.actions = sorted(
                 s.actions,
                 key=lambda a: a.order)

       menu = Menu(domains, user_id, locale,
                    now(), cache=false)

       MenuCache.set(key, menu, ttl=300)
       return menu

11.4 Mapeo excepcion → HTTP
===========================

.. list-table::
 :widths: 40 20 40
 :header-rows: 1

 * - Excepcion
   - Status
   - Body code
 * - JWT invalido
   - 401
   - middleware
 * - User no existe
   - 404
   - USER_NOT_FOUND
 * - BDTimeout
   - 503
   - SERVICE_UNAVAILABLE
 * - RegistryError
   - 500
   - REGISTRY_CORRUPTED
 * - Throttle
   - 429
   - RATE_LIMITED

11.5 Restricciones cross-cutting
================================

- Read-only.
- P-51 read-no-audit.
- P-52 UI != security: NO confiar en menu
  para enforcement.
- P-29 cache invalidate por evento.

11.6 Stack-agnostico
================================

- Frontend renderiza la estructura
  retornada en cualquier framework.
- Backend: cualquier servidor HTTP con
  acceso al cache + BD + UC_PERM_07.
