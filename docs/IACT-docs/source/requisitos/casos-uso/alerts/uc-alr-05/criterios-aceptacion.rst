.. _uc-alr-05-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Sub propia → 201.
CA-02: Admin sub para otro User.
CA-03: Cross-segmento bloqueado.
CA-04: Duplicada → 409.
CA-05: Mute global pausa todas.
CA-06: Bulk add.
CA-07: Auto-pause cuando pierde segmento.
CA-08: Sin permiso 403.
CA-09: Audit de CRUD.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Crear self / admin
   - Funcional
 * - CA-03..04
   - Validation
   - Robustez
 * - CA-05..06
   - UX
   - Convenience
 * - CA-07
   - Auto-pause
   - Cumplimiento
 * - CA-08
   - Auth
   - Seguridad
 * - CA-09
   - Audit
   - Compliance
