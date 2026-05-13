.. _uc-rpt-01-parte-10:

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
   - view_reports
 * - **P-25**
   - Read replicas
   - BD Analytics
 * - **P-29**
   - Cache invalidate
   - TTL corto
 * - **P-51**
   - Read-no-audit
   - sin audit por
     invocacion
 * - **P-58** (nuevo)
   - Segment-bound aggregation
   - filtro CNST-008
     enforced en query
 * - **P-59** (nuevo)
   - ETL freshness banner
   - staleness explicito
     al usuario

10.2 P-58: Segment-bound aggregation
====================================

**Problema**: dashboards multi-tenant /
multi-segmento pueden filtrar visible UI
pero query original retorna todo →
performance issue + risk de filtracion.

**Solucion**: el filtro por segmento se
aplica en el WHERE de la query, no en el
post-procesado. Aprovechado por indices.
Conditions adicionales en JWT del User
declaran scope.

10.3 P-59: ETL freshness banner
===============================

**Problema**: dashboards muestran datos
"frescos" pero el ETL puede estar
atrasado. El usuario ve numeros estables
y asume que estan al dia.

**Solucion**:

- Cada response incluye
  ``last_etl_run_at``.
- Si ``now - last_etl_run > threshold``,
  setear ``staleness_minutes``.
- Frontend muestra banner amarillo
  "Datos atrasados X min".

Trade-off explicito: prefieres datos
estables atrasados vs datos en tiempo real
incompletos.

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
   - PASO 6, 10
 * - P-51
   - PASO 11
 * - P-58
   - PASO 4, 7
 * - P-59
   - FA-05, CA-15
