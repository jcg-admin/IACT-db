.. _uc-rpt-15-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_15
 * - **Nombre**
   - Reporte de Transferencias
 * - **BReq**
   - BReq-001, BReq-002
 * - **Funcion RBAC**
   - ``view_transfer_reports``

1.2 Proposito
=============

Identificar patrones de transferencias:
exceso de transfers (skill misrouting),
transferencias circulares, agentes con
alta tasa de transfer-out (capacitacion).

1.3 Metricas
============

- Total transfers (in / out)
- Avg time pre-transfer (handle time
  antes de transferir)
- Disposition post-transfer (resolved /
  abandoned)
- Top reasons (skill, language, escalation)
- Inter-queue heatmap

1.4 Restricciones
=================

CNST-007, CNST-008, CNST-009.

1.5 Out of scope
================

- Configurar reglas de transfer
  (operacional).
