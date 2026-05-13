.. _uc-pip-04-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Reason ≥ 20.

IT-01: Retry basico.
IT-02: Already running → 409.
IT-03: Reason missing → 400.
IT-04: Audit emitido.
IT-05: Doble retry → 409.
IT-06: High priority encola al frente.
IT-07: BD timeout 503.

E2E-01: Operador retry tras error.

SEC-01: Sin permiso 403.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Retry
   - IT-01
 * - CA-02
   - Already running
   - IT-02
 * - CA-03
   - Reason
   - UT-01, IT-03
 * - CA-04
   - Audit
   - IT-04
 * - CA-05
   - Doble retry
   - IT-05
 * - CA-06
   - Priority
   - IT-06
 * - CA-07..08
   - Auth/robustez
   - SEC-01, IT-07

Cobertura: 1 unit, 7 integration, 1 E2E,
1 security. 100% de los 8 CAs.
