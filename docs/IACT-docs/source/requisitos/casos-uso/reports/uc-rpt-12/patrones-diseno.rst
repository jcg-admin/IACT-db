.. _uc-rpt-12-parte-10:

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
   - 2 funciones (list vs
     detail)
 * - **P-25**
   - Read replicas
   -
 * - **P-29**
   - Cache invalidate
   - on ETL
 * - **P-44**
   - Visibility audit prio
   - detail audited
 * - **P-51**
   - Read-no-audit
   - list no audita
 * - **P-58**
   - Segment-bound
   -
 * - **P-73** (nuevo)
   - Two-tier RBAC
     (list vs detail)
   - granular access:
     ver agregados team
     vs ver datos por agente

10.2 P-73: Two-tier RBAC
========================

**Problema**: ver KPIs agregados de un team
es razonable para muchos roles. Pero ver
performance individual de un agente es mas
sensitivo (HR-like).

**Solucion**: dos funciones distintas:

- ``view_agent_reports``: list / aggregates.
- ``view_agent_detail``: drill-down a 1
  agente, audit reforzado.

Mismo modelo aplicable a UC_RPT_13/14.

10.3 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-15
   - PASO 3, D3
 * - P-44
   - PASO D6
 * - P-51
   - lista
 * - P-58
   - segmento
 * - P-73
   - 2 funciones
