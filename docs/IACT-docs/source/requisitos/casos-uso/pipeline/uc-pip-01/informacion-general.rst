.. _uc-pip-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_PIP_01
 * - **BReq**
   - BReq-005, BReq-006
 * - **Funcion RBAC**
   - ``view_etl_supervision``

1.1 Proposito
=============

Mostrar al equipo de operaciones / ingeniería
de datos la salud del ETL que pobla
Analytics. Lag, throughput, errores.

1.2 Metricas
============

- Jobs running / completed / failed
- Lag por source (last successful run)
- Throughput rows/min
- Bytes processed
- Avg latency

1.3 Restricciones
=================

CNST-007 (read-only Analytics + ETL
metadata), CNST-009.

1.4 Out of scope
================

- Errores detallados (UC_PIP_02).
- Disponibilidad (UC_PIP_03).
- Reintento (UC_PIP_04).
