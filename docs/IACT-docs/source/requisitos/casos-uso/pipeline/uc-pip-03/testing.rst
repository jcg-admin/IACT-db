.. _uc-pip-03-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Status fresh.
UT-02: Status stale.
UT-03: Status critical_stale.

IT-01: Get datasets.
IT-02: Cache hit.
IT-03: BD timeout.

E2E-01: Banner se muestra cuando stale.

SEC-01: Sin permiso 403.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - Status
   - UT-01..03, IT-01
 * - CA-05
   - Auth
   - SEC-01
 * - CA-06..07
   - Robustez
   - IT-02, IT-03

Cobertura: 3 unit, 3 integration, 1 E2E,
1 security. 100% de los 7 CAs.
