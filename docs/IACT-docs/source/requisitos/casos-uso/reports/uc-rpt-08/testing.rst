.. _uc-rpt-08-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

Unit, integration, E2E, security.

12.2 Tests unitarios
====================

UT-01: ScopeFilter.for(user_normal) →
filtro actor_id.
UT-02: ScopeFilter.for(auditor) → filtro
segmentos.

12.3 Tests de integracion
=========================

IT-01: list de User normal → solo propios.
IT-02: filter status=active.
IT-03: detalle valido.
IT-04: detalle no existe → 404.
IT-05: historico runs.
IT-06: paginacion.
IT-07: BD timeout.

12.4 Tests E2E
==============

E2E-01: User abre vista programados.
E2E-02: Click en schedule abre detalle.
E2E-03: Sin permiso 403.

12.5 Tests de seguridad
=======================

SEC-01: User intenta ver schedules de
otro via id → 404 (no leak existence).
SEC-02: Auditor con scope amplio funciona.

12.6 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..03
   - List/filtros
   - IT-01, IT-02, IT-06
 * - CA-04..06
   - Detalle/runs
   - IT-03, IT-04, IT-05
 * - CA-07..08
   - Ownership
   - UT-01, UT-02, SEC-01, SEC-02
 * - CA-09
   - Sin permiso
   - E2E-03
 * - CA-10
   - Timeout
   - IT-07

12.7 Cobertura
==============

- 2 unit tests
- 7 integration tests
- 3 E2E tests
- 2 security tests
- 100% de los 10 CAs
