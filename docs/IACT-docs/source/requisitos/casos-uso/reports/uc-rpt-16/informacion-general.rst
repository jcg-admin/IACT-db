.. _uc-rpt-16-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_16
 * - **Nombre**
   - Reporte de Menus IVR
 * - **BReq**
   - BReq-001, BReq-007
 * - **Funcion RBAC**
   - ``view_ivr_reports``

1.2 Proposito
=============

Identificar cuello de botella en menus
IVR: opcion confusa, drop-off alto en un
nodo, paths poco usados, tiempo en menu
excesivo. Insumo para optimizar IVR.

1.3 Metricas
============

- Total ingresos al IVR
- Distribucion por opcion del menu raiz
- Drop-off rate por nodo (cuelgan antes
  de avanzar)
- Avg time in menu antes de seleccionar
- Top paths (secuencia de opciones)

1.4 Restricciones
=================

CNST-007, CNST-008, CNST-009.

1.5 Out of scope
================

- Editar menus IVR (operacional).
- Audio recordings.
