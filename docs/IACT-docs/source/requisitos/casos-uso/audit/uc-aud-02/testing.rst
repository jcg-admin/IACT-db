.. _uc-aud-02-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Query escaping.
UT-02: Range validator.

IT-01: Search basico.
IT-02: Range > 90 → 400.
IT-03: Cap 1000 hits.
IT-04: Throttling activado.
IT-05: Meta-audit.
IT-06: FTS timeout.

E2E-01: Auditor busca.

SEC-01: Sin permiso 403.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - Search + limites
   - IT-01..03
 * - CA-05
   - Sanitize
   - integration
 * - CA-06
   - Audit
   - IT-05
 * - CA-07..08
   - Throttle/Auth
   - IT-04, SEC-01

Cobertura: 2 unit, 6 integration, 1 E2E,
1 security. 100% de los 8 CAs.
