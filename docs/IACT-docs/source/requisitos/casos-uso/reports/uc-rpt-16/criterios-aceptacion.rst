.. _uc-rpt-16-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: Totales correctos.
CA-02: Distribucion root.
CA-03: Drop-off por nodo.
CA-04: Top paths (top 10).
CA-05: Cross-segmento → 403.
CA-06: Sin sesiones → 0s.
CA-07: Periodo invalido → 400.
CA-08: BD timeout → 503.
CA-09: Sin permiso → 403.
CA-10: Filtro ivr_id.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - Datos
   - Funcional
 * - CA-05, 09
   - Auth
   - Seguridad
 * - CA-06..08
   - Robustez
   - Errores
 * - CA-10
   - Filtros
   - Funcional
