.. _uc-pip-02-parte-12:

==================
Parte 12 — Testing
==================

UT-01: PIIScanner detecta email en stack.

IT-01: List basico.
IT-02: Filter pipeline_id.
IT-03: Sanitize aplicado.
IT-04: BD timeout.

E2E-01: Diagnostico real.

SEC-01: Sin permiso 403.
SEC-02: Stack no contiene PII.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..05
   - Datos
   - IT-01..03, UT-01
 * - CA-06..07
   - Robustez
   - SEC-01, IT-04

Cobertura: 1 unit, 4 integration, 1 E2E,
2 security. 100% de los 7 CAs.
