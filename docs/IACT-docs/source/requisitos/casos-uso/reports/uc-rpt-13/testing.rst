.. _uc-rpt-13-parte-12:

==================
Parte 12 — Testing
==================

UT-01: ASA derivada.
UT-02: SL %.
UT-03: Abandon rate.
UT-04: Summary del segmento.

IT-01: List basico.
IT-02: Filtro multi-cola.
IT-03: Detalle con trends.
IT-04: Cross-segmento → 403.
IT-05: Cache hit.
IT-06: Sort por SL.
IT-07: BD timeout.

E2E-01: Supervisor ve colas, drill, ve
trends.
E2E-02: Sin permiso → 403.

SEC-01: Cross-segmento bloqueado.
SEC-02: Sin PII.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..02, 11
   - List/filtros
   - IT-01, IT-02, IT-06
 * - CA-03..05
   - KPIs
   - UT-01..03
 * - CA-06
   - Detalle
   - IT-03, E2E-01
 * - CA-07
   - Cross-segmento
   - IT-04, SEC-01
 * - CA-08..10
   - Robustez
   - integration
 * - CA-12
   - Sin permiso
   - E2E-02

Cobertura: 4 unit, 7 integration, 2 E2E,
2 security. 100% de los 12 CAs.
