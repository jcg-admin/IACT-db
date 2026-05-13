.. _uc-rpt-12-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: List basico
======================

200 con N agentes del segmento.

9.2 CA-02: Filtro por team
==========================

Subset.

9.3 CA-03: Sort
===============

sort_by + sort_order respetados.

9.4 CA-04: TMO calculado
========================

sum_handle/answered correcto.

9.5 CA-05: Occupancy calculado
==============================

busy/total_time correcto.

9.6 CA-06: Detalle requiere view_agent_detail
=============================================

Sin la funcion → 403.

9.7 CA-07: Detalle cross-segmento
=================================

agent_id fuera del segmento del invoker
→ 403.

9.8 CA-08: Detalle audit
========================

AGENT_DETAIL_VIEWED emitido.

9.9 CA-09: Sin agentes
======================

items=[].

9.10 CA-10: Periodo invalido
============================

400.

9.11 CA-11: BD timeout
======================

503.

9.12 CA-12: Sin PII
===================

Response no contiene email / telefono.

9.13 Resumen
============

.. list-table::
 :widths: 12 50 38

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - List + filtros
   - Funcional
 * - CA-04..05
   - KPIs
   - Funcional
 * - CA-06..08
   - Detalle privilegiado
   - Seguridad
 * - CA-09
   - Sin datos
   - UX
 * - CA-10..11
   - Robustez
   - Errores
 * - CA-12
   - Sin PII
   - Cumplimiento
