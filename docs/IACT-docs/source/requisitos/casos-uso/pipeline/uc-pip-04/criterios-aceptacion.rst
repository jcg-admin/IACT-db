.. _uc-pip-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Retry basico → 202 + new_run_id.
CA-02: Pipeline already running → 409.
CA-03: Reason missing → 400.
CA-04: Audit P-39 emitido.
CA-05: Doble retry mismo run → 409.
CA-06: High priority encola al frente.
CA-07: Sin permiso 403.
CA-08: Pipeline no existe 404.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Funcional
   - Funcional
 * - CA-04
   - Audit
   - Compliance
 * - CA-05..06
   - Idempotencia/priority
   - Robustez
 * - CA-07..08
   - Auth/robustez
   - varios
