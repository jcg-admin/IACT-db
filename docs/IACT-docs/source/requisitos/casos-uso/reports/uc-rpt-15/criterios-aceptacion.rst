.. _uc-rpt-15-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Totales correctos.
CA-02: Filtro direction.
CA-03: Heatmap construido.
CA-04: Top reasons ordenados.
CA-05: Top origin agents.
CA-06: Cross-segmento → 403.
CA-07: Sin transfers → 0s.
CA-08: Periodo invalido → 400.
CA-09: BD timeout → 503.
CA-10: Sin permiso → 403.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..05
   - Totales / breakdowns
   - Funcional
 * - CA-06, 10
   - Auth/segmento
   - Seguridad
 * - CA-07..09
   - Robustez
   - Errores
