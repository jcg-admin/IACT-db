.. _uc-pip-03-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_PIP_03
 * - **BReq**
   - BReq-005
 * - **Funcion RBAC**
   - ``view_data_availability``

1.1 Proposito
=============

Mostrar timestamp del ultimo refresh por
dataset (CallSummary, AgentDailyStat,
QueueDailyStat, ...). Util para usuarios
de reportes que quieren saber si datos
del periodo solicitado estan listos.

1.2 Restricciones
=================

CNST-007, CNST-009.

1.3 Out of scope
================

- Detalle de errores (UC_PIP_02).
