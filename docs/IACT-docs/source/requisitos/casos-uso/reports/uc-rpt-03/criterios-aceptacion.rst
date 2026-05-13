.. _uc-rpt-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Periodo last_30d
===========================

last_30d con datos → buckets diarios.

9.2 CA-02: Custom date range
============================

date_from + date_to validos → buckets segun
auto-granularity.

9.3 CA-03: Range > 2 anos rechazado
===================================

400 RANGE_TOO_LARGE.

9.4 CA-04: Filtro segmento
==========================

Solo datos de segmentos del User.

9.5 CA-05: Sub-filtros
======================

filter[campaign]=X → solo datos de X.

9.6 CA-06: Comparative basico
=============================

Periodo prior calculado correctamente.

9.7 CA-07: Comparative insufficient
===================================

Sin datos en prior → flag
``insufficient_data``.

9.8 CA-08: Group by day
=======================

last_7d → 7 buckets.

9.9 CA-09: Group by hour
========================

last_24h → 24 buckets.

9.10 CA-10: Group multi-dimension
=================================

day,campaign → 2D buckets.

9.11 CA-11: Cache hit
=====================

Segunda llamada idéntica → cache=true.

9.12 CA-12: Sin permiso 403
===========================

403 + UNAUTHORIZED audit.

9.13 CA-13: Sin segmento 400
============================

400.

9.14 CA-14: BD timeout 503
==========================

503.

9.15 CA-15: Paginacion
======================

Total buckets > page_size → has_next=true.

9.16 CA-16: Read-only Analytics
===============================

0 writes.

9.17 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Periodos
   - Funcional
 * - CA-04..05
   - Filtros
   - Funcional
 * - CA-06..07
   - Comparative
   - Funcional
 * - CA-08..10
   - group_by
   - Funcional
 * - CA-11
   - Cache
   - Performance
 * - CA-12..13
   - Auth/segmento
   - Seguridad
 * - CA-14
   - BD timeout
   - Robustez
 * - CA-15
   - Paginacion
   - Funcional
 * - CA-16
   - CNST-007
   - Cumplimiento
