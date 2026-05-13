.. _uc-aud-01-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Cursor encode/decode.

IT-01: List basico.
IT-02: Filtro module.
IT-03: Cursor stable bajo writes
concurrentes.
IT-04: Meta-audit emitido.
IT-05: Meta-audit fail → 503.
IT-06: BD timeout.

E2E-01: Compliance officer revisa.

SEC-01: Sin permiso 403.

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..04
   - List + cursor
   - IT-01..03, UT-01
 * - CA-05
   - Range
   - integration
 * - CA-06
   - Meta-audit
   - IT-04, IT-05
 * - CA-07..08
   - Auth/errores
   - SEC-01, IT-06

Cobertura: 1 unit, 6 integration, 1 E2E,
1 security. 100% de los 8 CAs.
