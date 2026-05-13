.. _uc-pip-01-parte-12:

==================
Parte 12 — Testing
==================

UT-01: SummaryBuilder agrega.
UT-02: Stale detection.

IT-01: Get summary.
IT-02: Stale pipeline marked.
IT-03: Filter status.
IT-04: Cache hit.
IT-05: BD timeout 503.

E2E-01: Operations dashboard.

SEC-01: Sin permiso → 403.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..03
   - Datos
   - IT-01, IT-02, IT-03
 * - CA-04
   - Cache
   - IT-04
 * - CA-05..06
   - Robustez
   - IT-05, SEC-01

Cobertura: 2 unit, 5 integration, 1 E2E,
1 security. 100% de los 6 CAs.
