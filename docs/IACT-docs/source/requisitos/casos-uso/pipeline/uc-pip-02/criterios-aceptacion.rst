.. _uc-pip-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: List basico.
CA-02: Filter pipeline_id.
CA-03: Stack sanitizado (sin PII).
CA-04: Group by error_type.
CA-05: Drill por correlation_id.
CA-06: Sin permiso 403.
CA-07: BD timeout 503.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - Datos + sanitize
   - Funcional/Cumplimiento
 * - CA-06..07
   - Auth/robustez
   - varios
