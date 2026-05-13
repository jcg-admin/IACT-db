.. _uc-rpt-13-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

CA-01: List basico → items.
CA-02: Filtro multi-cola → subset.
CA-03: ASA = sum(wait)/count(answered).
CA-04: SL = within/total × 100.
CA-05: Abandon rate.
CA-06: Detalle con trends por hora.
CA-07: Cross-segmento → 403.
CA-08: Sin colas → items=[].
CA-09: Periodo invalido → 400.
CA-10: BD timeout → 503.
CA-11: Sort por SL.
CA-12: Sin permiso → 403.

Resumen
=======

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02, 11
   - List + filtros + sort
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
