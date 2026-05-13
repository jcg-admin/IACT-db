.. _uc-rpt-17-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Distinct count correcto.
CA-02: HLL para volumen alto.
CA-03: Recurrence distribution.
CA-04: New vs returning vs prior.
CA-05: Top N solo prefix hash.
CA-06: Sin client_id raw en response.
CA-07: Cross-segmento → 403.
CA-08: Sin clientes → 0.
CA-09: Periodo invalido → 400.
CA-10: BD timeout → 503.
CA-11: Sin permiso → 403.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - Datos
   - Funcional
 * - CA-06
   - Sin PII
   - Cumplimiento
 * - CA-07, 11
   - Auth
   - Seguridad
 * - CA-08..10
   - Robustez
   - Errores
