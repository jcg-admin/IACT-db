.. _uc-rpt-10-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_10
 * - **Nombre**
   - Guardar Vista
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001
 * - **Funcion RBAC**
   - implícita ``manage_own_views``

1.2 Proposito
=============

Una vista (SavedView) encapsula toda la
configuracion del reporte: filtros, period
relativo, columnas visibles, orden, group
by, chart configuration.

A diferencia de UC_RPT_09 (solo filtros),
una vista incluye toda la presentacion.

1.3 Alcance
===========

- Hasta 30 vistas por User.
- Aplicables a un report_type especifico.
- Compartible via UC_RPT_11.

1.4 Restricciones
=================

- CNST-008: validacion segmento (mismo que
  UC_RPT_09).
- CNST-009: JWT.

1.5 Out of scope
================

- Compartir (UC_RPT_11).
- Solo filtros (UC_RPT_09 mas simple).
