.. _uc-alr-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Crear basico → 201.
CA-02: Cross-segmento bloqueado.
CA-03: Validation metric desconocida.
CA-04: Validation action invalido.
CA-05: Update incrementa version.
CA-06: Pause/resume sin perder rule.
CA-07: Delete CASCADE.
CA-08: Test rule dry-run no crea
alertas reales.
CA-09: Cooldown evita re-fire.
CA-10: Audit completo CRUD.
CA-11: Sin permiso 403.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - CRUD + validation
   - Funcional
 * - CA-06..07
   - State / cleanup
   - Robustez
 * - CA-08..09
   - Test / cooldown
   - UX
 * - CA-10
   - Audit
   - Compliance
 * - CA-11
   - Auth
   - Seguridad
