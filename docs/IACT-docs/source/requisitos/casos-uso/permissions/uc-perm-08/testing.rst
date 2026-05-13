.. _uc-perm-08-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- **Unit**: MenuBuilder, ordenamiento,
  filtrado, supresion de vacios.
- **Integration**: bulk check + cache
  lifecycle.
- **E2E**: login → menu → render esperado.
- **Security**: cada accion del menu
  protegida en endpoint.

12.2 Tests unitarios
====================

UT-01: build con 0 codes allowed → domains=[].
UT-02: build con 1 code → 1 domain, 1 section,
1 action.
UT-03: 5 codes en mismo domain/section →
1 section con 5 actions ordenadas.
UT-04: 3 codes en distintos domains →
3 domains, ordenados por order_global.
UT-05: locale=es retorna labels español.
UT-06: locale=en retorna labels ingles.
UT-07: locale invalido → fallback es.
UT-08: domain sin sections (todas vacias)
suprimido.
UT-09: section sin actions suprimida.
UT-10: orden estable: dos builds identicos →
mismo JSON.

12.3 Tests de integracion
=========================

IT-01: User con AGR + funciones → menu refleja.
IT-02: User sin AGR → domains=[].
IT-03: User con concesion sin AGR → menu
incluye la concesion.
IT-04: User con revocacion → funcion no
aparece.
IT-05: Function sin metadata menu_visible=true
no aparece (aun teniendo permiso).
IT-06: Cache hit segunda llamada.
IT-07: Cache invalidate post UC_ACC_01 →
miss en proxima.
IT-08: Hot reload registry → cache global
invalidate.
IT-09: BD timeout → 503.
IT-10: Multi-segmento User → menu union.

12.4 Tests E2E
==============

E2E-01: Login User normal → menu con dominios
esperados.
E2E-02: Admin login → menu admin (mas
opciones).
E2E-03: Cambio en permisos → refresh menu →
nuevo menu visible.
E2E-04: User cambia locale → menu re-cargado
en nuevo idioma.

12.5 Tests de seguridad (P-52)
==============================

SEC-01: para cada action en menu de User U,
verificar que el endpoint correspondiente
gateado tiene decorator/guard.
SEC-02: User U sin funcion F intenta hit
endpoint directo → 403.
SEC-03: scrape menu de User para listar
endpoints → no debe revelar capacidades de
otros Users.

12.6 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Multi-domain
   - UT-04, IT-01
 * - CA-02
   - Sin funciones
   - UT-01, IT-02
 * - CA-03
   - REVOKED
   - IT-04
 * - CA-04
   - GRANT
   - IT-03
 * - CA-05
   - Sin metadata
   - IT-05
 * - CA-06..08
   - Locale
   - UT-05..07
 * - CA-09..10
   - Cache
   - IT-06, IT-07
 * - CA-11..12
   - Orden / supresion
   - UT-08..10
 * - CA-13
   - UI != sec
   - SEC-01..03
 * - CA-14
   - BD timeout
   - IT-09
 * - CA-15
   - Sin audit
   - assertion en E2E

12.7 Cobertura
==============

- 10 unit tests
- 10 integration tests
- 4 E2E tests
- 3 security tests
- 100% de los 15 CAs cubiertos
