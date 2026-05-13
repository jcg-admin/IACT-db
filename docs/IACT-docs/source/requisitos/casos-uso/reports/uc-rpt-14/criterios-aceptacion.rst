.. _uc-rpt-14-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: List basico.
CA-02: Filtro type.
CA-03: Conversion rate calculado.
CA-04: Calls/hour.
CA-05: Disposition mix presente.
CA-06: Detalle con trends.
CA-07: Cross-segmento → 403.
CA-08: Sin campanas → items=[].
CA-09: Periodo invalido → 400.
CA-10: BD timeout → 503.
CA-11: Sort por conversion.
CA-12: Sin permiso → 403.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02, 11
   - List
   - Funcional
 * - CA-03..05
   - KPIs
   - Funcional
 * - CA-06
   - Detalle
   - Funcional
 * - CA-07, 12
   - Auth/segmento
   - Seguridad
 * - CA-08..10
   - Robustez
   - Errores
