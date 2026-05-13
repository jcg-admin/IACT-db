.. _uc-rpt-03-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   - view_historical_reports
 * - **P-25**
   - Read replicas
   - Analytics
 * - **P-29**
   - Cache invalidate
   - on ETL completion
 * - **P-51**
   - Read-no-audit
   - sin audit por consulta
 * - **P-58**
   - Segment-bound
   - filtro CNST-008
 * - **P-62** (nuevo)
   - Adaptive TTL caching
   - TTL escalado segun
     volatilidad de datos
 * - **P-63** (nuevo)
   - Comparative period
     auto-derived
   - prior period calculado
     desde current

10.2 P-62: Adaptive TTL caching
===============================

**Problema**: TTL fijo es ineficiente —
last_24h cambia constantemente, last_90d
casi no cambia.

**Solucion**: TTL escalado segun rango:

- last_24h: 60s (cambia rapido)
- last_7d: 5 min
- last_30d/90d: 15 min

Mejora hit ratio en periodos largos sin
sacrificar frescura en cortos.

10.3 P-63: Comparative period
=============================

**Problema**: el "periodo anterior" debe
ser comparable (same length, same offset).

**Solucion**: derivar automaticamente:

- last_24h → prior 24h-48h
- last_7d → prior 8-14 dias
- last_30d → prior 31-60 dias
- custom (X dias) → prior X dias antes

Si prior cae en archive y no esta accesible,
flag ``insufficient_data`` en lugar de
fallar.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-25
   - NFR 6.2
 * - P-29
   - PASO 10
 * - P-51
   - sin audit
 * - P-58
   - PASO 4
 * - P-62
   - PASO 10
 * - P-63
   - PASO 7-9
