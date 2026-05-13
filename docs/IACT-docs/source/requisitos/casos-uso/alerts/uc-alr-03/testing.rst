.. _uc-alr-03-parte-12:

==================
Parte 12 — Testing
==================

UT-01: Note > 500 char rechazado.

IT-01: Ack basico.
IT-02: Note guardado.
IT-03: Cross-segmento → 403.
IT-04: Ya ack → 409.
IT-05: Resolved → 409.
IT-06: Audit emitido.
IT-07: Suprime notify.
IT-08: Bulk ack.
IT-09: Audit fail → rollback (sin
cambio en alert).

E2E-01: Supervisor ack desde UC_ALR_02.

SEC-01: Sin permiso → 403.

Mapeo CA → Tests:

.. list-table::
 :widths: 12 35 53

 * - CA
   - Concepto
   - Tests
 * - CA-01..02
   - Ack
   - IT-01, IT-02
 * - CA-03..05
   - Validation
   - IT-03..05
 * - CA-06..07
   - Audit + suppress
   - IT-06, IT-07
 * - CA-08
   - Bulk
   - IT-08
 * - CA-09
   - Auth
   - SEC-01
 * - CA-10
   - Atomicidad
   - IT-09

Cobertura: 1 unit, 9 integration, 1 E2E,
1 security. 100% de los 10 CAs.
