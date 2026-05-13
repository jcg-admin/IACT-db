.. _uc-rpt-09-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_RPT_09
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001
 * - **Funcion RBAC**
   - implícita ``manage_own_filters``

1.2 Proposito
=============

Permitir al User guardar combinaciones de
filtros usados frecuentemente (e.g.
"campana X + ultimo mes") y reaplicarlos
en uno o varios reportes con un click.

1.3 Alcance
===========

- Filtros aplican a:
  UC_RPT_03 (historicos) y subtipos.
- Hasta 50 filtros guardados por User.
- Nombre obligatorio.
- Pueden compartirse via UC_RPT_11.

1.4 Restricciones
=================

- CNST-008: filtros NO pueden bypassear
  segmento del User. Si filtro intenta
  cross-segmento, rechazado.
- CNST-009: JWT.

1.5 Out of scope
================

- Compartir (UC_RPT_11).
- Vistas completas con layout (UC_RPT_10).
