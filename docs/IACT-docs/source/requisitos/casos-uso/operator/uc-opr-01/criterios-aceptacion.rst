.. _uc-opr-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: available → break con reason.
CA-02: busy auto al atender llamada.
CA-03: ACW auto al colgar.
CA-04: Reason missing (break) → 400.
CA-05: Transicion invalida → 409.
CA-06: Audit emitido con from/to/duration.
CA-07: CallRouter notificado.
CA-08: Logout fuerza offline.
CA-09: Inactividad N min → offline forzado.
CA-10: Break exceeded → 409.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Transitions
   - Funcional
 * - CA-04..05
   - Validation
   - Robustez
 * - CA-06
   - Audit
   - Compliance
 * - CA-07
   - Routing
   - Funcional
 * - CA-08..09
   - Auto-transitions
   - Operacional
 * - CA-10
   - Politicas
   - Cumplimiento
