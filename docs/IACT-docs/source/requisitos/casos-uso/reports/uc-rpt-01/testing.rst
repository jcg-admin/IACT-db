.. _uc-rpt-01-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

- **Unit**: KPICalculator, TrendBuilder,
  PeriodValidator, StalenessChecker.
- **Integration**: query agregada con
  datos sembrados, cache lifecycle.
- **E2E**: User login → dashboard render.
- **Security**: enforcement segmento.

12.2 Tests unitarios
====================

UT-01: TMO = sum/count correcto.
UT-02: Service Level con threshold.
UT-03: Abandon rate.
UT-04: KPIs con 0 rows → 0.
UT-05: TrendBuilder buckets de hora para
period=today.
UT-06: TrendBuilder buckets de dia para
period=last_7d.
UT-07: Periodo invalido rechazado.
UT-08: Staleness > threshold reporta
minutos.

12.3 Tests de integracion
=========================

IT-01: dashboard basico con sembrado de
datos → KPIs verificables.
IT-02: filtro por segmento: datos de seg_a
no incluyen seg_b.
IT-03: User sin segmento → 400.
IT-04: cache hit segunda llamada.
IT-05: cache invalidate manual → miss.
IT-06: BD timeout → 503.
IT-07: ETL desfasado → staleness reportado.
IT-08: multi-segmento → union.

12.4 Tests de seguridad
=======================

SEC-01: User con segmento A intenta
acceder a dashboard de B via param
manipulation → 403/400.
SEC-02: User sin view_reports → 403.
SEC-03: scrape KPIs por iteracion no
revela datos de otro segmento.

12.5 Tests E2E
==============

E2E-01: Login User normal → dashboard
poblado en < 1s.
E2E-02: Auto-refresh polling cada 30s.
E2E-03: Pestana background → no polling.
E2E-04: Periodo last_7d cambia trend a
diario.
E2E-05: Multi-segmento User ve union.

12.6 Tests de carga
===================

LOAD-01: 1000 users concurrentes →
P95 ≤ 500ms.
LOAD-02: cache miss simultaneo (cold) →
no thundering herd (singleflight).

12.7 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 12 35 53
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Dashboard basico
   - IT-01, E2E-01
 * - CA-02
   - Sin datos
   - UT-04
 * - CA-03..04
   - Segmento
   - IT-02, IT-08, E2E-05
 * - CA-05
   - Sin segmento
   - IT-03
 * - CA-06..07
   - Periodos
   - UT-05, UT-06, E2E-04
 * - CA-08
   - Cache
   - IT-04, IT-05
 * - CA-09..11
   - KPIs derivados
   - UT-01..03
 * - CA-12
   - Trend
   - UT-05
 * - CA-13
   - Sin permiso
   - SEC-02
 * - CA-14
   - Visibility refresh
   - E2E-02, E2E-03
 * - CA-15
   - Staleness
   - UT-08, IT-07
 * - CA-16
   - Read-only
   - assertion en LOAD

12.8 Cobertura
==============

- 8 unit tests
- 8 integration tests
- 3 security tests
- 5 E2E tests
- 2 load tests
- 100% de los 16 CAs cubiertos
