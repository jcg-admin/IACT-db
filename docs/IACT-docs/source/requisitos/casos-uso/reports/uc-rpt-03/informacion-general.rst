.. _uc-rpt-03-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_RPT_03
 * - **Nombre**
   - Ver Reportes Historicos
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001, BReq-003
 * - **Funcion RBAC**
   - ``view_historical_reports``

1.2 Proposito
=============

Permitir analisis retrospectivo: tendencias
mes a mes, comparativos periodo vs periodo,
detalle por dia / hora.

1.3 Periodos soportados
=======================

- last_24h
- last_7d
- last_30d
- last_90d
- custom (date_from, date_to)
- year-to-date

Maximo: 2 anos online; rangos > 2 anos
sirven via UC_RPT_04 (export con
include_archive).

1.4 Dimensiones disponibles
===========================

- segmento (siempre filtrado por
  CNST-008 + opcional sub-filtro)
- agente (UC_RPT_12 detalle)
- cola (UC_RPT_13 detalle)
- campana (UC_RPT_14 detalle)
- hora del dia / dia de la semana

1.5 Granularidad
================

- last_24h: por hora
- last_7d: por dia
- last_30d: por dia
- last_90d: por semana
- custom: auto segun rango

1.6 Restricciones
=================

CNST-007, CNST-008, CNST-009, CNST-013.

1.7 Out of scope
================

- Realtime (UC_RPT_02).
- Export (UC_RPT_04).
- Filtros guardables (UC_RPT_09).
- Vistas guardables (UC_RPT_10).
