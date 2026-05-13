.. _uc-rpt-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

1.1 Identificacion
==================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - UC_RPT_01
 * - **Nombre**
   - Ver Dashboard
 * - **Categoria**
   - Visualizacion / KPIs
 * - **Modulo**
   - MOD_Reports
 * - **BReq**
   - BReq-001
 * - **Funcion RBAC**
   - ``view_reports``
 * - **Criticidad**
   - Importante (visibilidad
     operacional)

1.2 Proposito
=============

Mostrar al User una vista consolidada de
KPIs operacionales del call center con
filtrado automatico por segmento. Es el
**punto de entrada** principal de la
mayoria de Users.

1.3 KPIs mostrados
==================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - KPI
   - Definicion
 * - Total llamadas
   - count(calls) en periodo
 * - Atendidas / abandonadas
   - count(calls.status='answered')
     vs count(calls.status='abandoned')
 * - TMO
   - sum(call_duration) /
     count(answered)
 * - Nivel de Servicio
   - count(answered_within_threshold)
     / count(total) × 100
 * - Tiempo promedio de espera
   - avg(wait_time)
 * - Tasa de abandono
   - count(abandoned) /
     count(total) × 100

1.4 Periodo por defecto
=======================

Datos del **dia actual** (00:00 hasta
ahora, hora local del User).

Configurable: hoy / ayer / ultima hora /
ultimos 7 dias (limitado a vista
dashboard; periodos largos van a
UC_RPT_03).

1.5 Restricciones canonicas
===========================

.. list-table::
 :widths: 25 75
 :header-rows: 1

 * - CNST
   - Aplicacion
 * - **CNST-007**
   - solo lectura desde BD Analytics
     (BD operativa IVR no se toca)
 * - **CNST-008**
   - filtro por segmento del User
     automatico, no eludible via UI
 * - **CNST-009**
   - JWT
 * - **CNST-013**
   - excepciones estandar

1.6 Auto-refresh
================

- Default: cada 30 segundos.
- Suspende cuando la pestana esta
  invisible (Visibility API).
- Desactivable por User (preferencia
  guardada).

1.7 Out of scope
================

- Reportes historicos detallados →
  UC_RPT_03.
- Real-time tiempo > 1 min → UC_RPT_02.
- Export PDF/CSV → UC_RPT_04.
- Filtros custom (mas alla de periodo) →
  UC_RPT_09.
- Dashboards por agente → UC_RPT_12.
