.. _uc-alr-02-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Order severity DESC.

IT-01: List firing.
IT-02: Filtro severity.
IT-03: Cross-segmento bloqueado.
IT-04: Sin alertas.
IT-05: BD timeout.

E2E-01: Supervisor ve criticas.
E2E-02: Auto-refresh.

SEC-01: Cross-segmento bloqueado.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..03
   - List
   - IT-01, IT-02, IT-04
 * - CA-04
   - Segmento
   - SEC-01
 * - CA-05..06
   - UX
   - UT-01, E2E-02
 * - CA-07..08
   - Auth/robustez
   - integration

Cobertura: 1 unit, 5 integration, 2 E2E,
1 security. 100% de los 8 CAs.
