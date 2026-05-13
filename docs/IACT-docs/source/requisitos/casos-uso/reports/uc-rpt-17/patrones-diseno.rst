.. _uc-rpt-17-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-15**
   - RBAC granular
   -
 * - **P-25**
   - Read replicas
   -
 * - **P-51**
   - Read-no-audit
   -
 * - **P-58**
   - Segment-bound
   -
 * - **P-75** (nuevo)
   - PII via hash at ingest
   - hash precalculado por ETL,
     reportes nunca tocan raw
 * - **P-76** (nuevo)
   - Cardinality estimation
     for scale
   - HLL para distinct counts
     de alto volumen

10.2 P-75: PII via hash at ingest
=================================

**Problema**: contar clientes unicos
requiere identificador, pero CNST-026
prohibe PII en analytics.

**Solucion**: ETL hashea ``client_id``
con ``tenant_salt`` antes de escribir
Analytics. Reportes solo ven el hash.
Hash es deterministico (cuenta distinct
y recurrencias) pero NO reidentificable
sin la salt.

10.3 P-76: Cardinality estimation
=================================

**Problema**: COUNT(DISTINCT) sobre billones
de eventos es lento y memory-intensive.

**Solucion**: HyperLogLog (HLL) sketch
precalculado por ETL. Precision ~1%
suficiente para reporting; performance
constante.

Trade-off explicito:

- (+) Constante en memoria; minimal
  latencia.
- (-) ~1% error.

10.4 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3
 * - P-58
   - PASO 4
 * - P-75
   - datos 7.2
 * - P-76
   - FA-01, datos 7.4
