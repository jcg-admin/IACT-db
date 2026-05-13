.. _uc-rpt-13-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_13
 * - **Nombre**
   - Reporte de Colas
 * - **BReq**
   - BReq-001, BReq-006
 * - **Funcion RBAC**
   - ``view_queue_reports``

1.2 Proposito
=============

Analizar performance por cola: ASA, SL,
abandono, calls offered/answered. Detectar
colas saturadas o con SL bajo.

1.3 Metricas por cola
=====================

- Calls offered
- Calls answered / abandoned
- ASA (Average Speed of Answer)
- SL % (within threshold)
- Abandon rate %
- Max wait time
- Queue depth peak

1.4 Restricciones
=================

CNST-007, CNST-008, CNST-009.

1.5 Out of scope
================

- Realtime de colas (UC_RPT_02).
- Configurar colas (operacional, no
  reports).
