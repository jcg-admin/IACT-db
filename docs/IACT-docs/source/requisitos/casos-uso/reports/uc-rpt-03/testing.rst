.. _uc-rpt-03-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- Unit: PeriodResolver, ComparativeBuilder,
  KPICalculator, FilterValidator.
- Integration: query agregada con datos
  sembrados, paginacion.
- E2E: User → reporte historico.
- Security: segmento.
- Load: rangos largos.

12.2 Tests unitarios
====================

UT-01: PeriodResolver.prior(last_30d) →
correcto.
UT-02: PeriodResolver.prior(custom) →
mismo length antes.
UT-03: ComparativeBuilder con datos
sufficientes → diff_pct.
UT-04: ComparativeBuilder sin datos prior
→ insufficient_data flag.
UT-05: FilterValidator rechaza range > 2
anos.
UT-06: FilterValidator rechaza group_by=
minute con range > 6h.
UT-07: TTL_for_period(last_24h) = 60s.
UT-08: TTL_for_period(last_30d) = 900s.
UT-09: KPI derivacion (TMO, SL, abandono).

12.3 Tests de integracion
=========================

IT-01: last_30d basico.
IT-02: filtro segmento aplicado.
IT-03: sub-filtro campaign.
IT-04: comparative calculado.
IT-05: cache hit.
IT-06: paginacion.
IT-07: range > 2 anos rechazado.
IT-08: BD timeout 503.
IT-09: ETL completion invalidate cache.

12.4 Tests E2E
==============

E2E-01: User abre historicos last_30d.
E2E-02: Comparativo visible.
E2E-03: Filtra por campaign.
E2E-04: Paginacion siguiente.
E2E-05: Sin permiso 403.

12.5 Tests de seguridad
=======================

SEC-01: Segmento enforcement no eludible
via filtros UI.
SEC-02: Auditor con scope ve solo su
segmento.

12.6 Tests de carga
===================

LOAD-01: 100 users concurrentes con
last_30d → P95 ≤ 2s.
LOAD-02: Cache miss thundering herd evitado.

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01..02
   - Periodos
   - IT-01, IT-08
 * - CA-03
   - > 2 anos
   - UT-05, IT-07
 * - CA-04..05
   - Filtros
   - IT-02, IT-03, SEC-01
 * - CA-06..07
   - Comparative
   - UT-03, UT-04
 * - CA-08..10
   - group_by
   - UT-05, integration
 * - CA-11
   - Cache
   - IT-05
 * - CA-12..13
   - Auth
   - E2E-05
 * - CA-14
   - BD timeout
   - IT-08
 * - CA-15
   - Paginacion
   - IT-06
 * - CA-16
   - Read-only
   - assertion E2E

12.8 Cobertura
==============

- 9 unit tests
- 9 integration tests
- 5 E2E tests
- 2 security tests
- 2 load tests
- 100% de los 16 CAs cubiertos
