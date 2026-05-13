.. _uc-pip-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Datasets retornados.
CA-02: Status fresh.
CA-03: Status stale (> threshold).
CA-04: Status critical_stale.
CA-05: Sin permiso 403.
CA-06: Cache hit.
CA-07: BD timeout 503.

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Status
   - Funcional
 * - CA-05
   - Auth
   - Seguridad
 * - CA-06..07
   - Robustez
   - Performance/errores
