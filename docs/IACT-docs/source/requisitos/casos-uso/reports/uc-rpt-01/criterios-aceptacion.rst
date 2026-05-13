.. _uc-rpt-01-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Dashboard basico
===========================

**DADO** User autenticado con
view_reports + segmento + datos,
**ENTONCES** 200 con KPIs poblados.

9.2 CA-02: Sin datos
====================

**DADO** sin rows en periodo,
**ENTONCES** 200 con KPIs en 0; mensaje
frontend "Sin datos para hoy".

9.3 CA-03: Filtro por segmento (CNST-008)
=========================================

**DADO** segmentos = [seg_a],
**ENTONCES** kpis solo de seg_a.

9.4 CA-04: Multi-segmento
=========================

**DADO** segmentos = [a, b],
**ENTONCES** union; segments_applied=[a,b].

9.5 CA-05: Sin segmento bloquea
===============================

**DADO** User sin segmento,
**ENTONCES** 400 USER_WITHOUT_SEGMENT.

9.6 CA-06: Periodo today default
================================

**DADO** sin param period,
**ENTONCES** datos del dia actual.

9.7 CA-07: Periodo custom
=========================

``period=last_7d``: 7 dias completos
incluyendo hoy.

9.8 CA-08: Cache hit
====================

**DADO** segunda llamada en < 30s,
**ENTONCES** cache=true.

9.9 CA-09: TMO calculado
========================

**DADO** answered=10, sum_duration=1800,
**ENTONCES** tmo_seconds=180.

9.10 CA-10: Service Level calculado
===================================

**DADO** answered_within=80, total=100,
**ENTONCES** service_level_pct=80.

9.11 CA-11: Abandon rate calculado
==================================

**DADO** abandoned=20, total=100,
**ENTONCES** abandon_rate_pct=20.

9.12 CA-12: Trend buckets correctos
===================================

**DADO** period=today,
**ENTONCES** trend con buckets de hora.

9.13 CA-13: Sin permiso 403
===========================

**DADO** User sin view_reports,
**ENTONCES** 403 + UNAUTHORIZED audit.

9.14 CA-14: Auto-refresh respeta visibility
===========================================

**DADO** pestana en background,
**ENTONCES** frontend NO hace polling.

9.15 CA-15: ETL desfasado banner
================================

**DADO** Analytics atrasado > X min,
**ENTONCES** response incluye
staleness_minutes > 0.

9.16 CA-16: Read-only Analytics (CNST-007)
==========================================

**DADO** N invocaciones,
**ENTONCES** 0 writes a BD operativa o
Analytics.

9.17 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Dashboard basico
   - Funcional
 * - CA-03..05
   - CNST-008
   - Cumplimiento
 * - CA-06..07
   - Periodos
   - Funcional
 * - CA-08
   - Cache
   - Performance
 * - CA-09..11
   - KPIs derivados
   - Funcional
 * - CA-12
   - Trend
   - Funcional
 * - CA-13
   - Sin permiso
   - Seguridad
 * - CA-14
   - Visibility refresh
   - Usabilidad
 * - CA-15
   - ETL staleness
   - Confiabilidad
 * - CA-16
   - CNST-007
   - Cumplimiento
