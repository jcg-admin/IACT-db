.. _uc-rpt-01-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Actor
   - Tipo
   - Rol
 * - **User con funcion**
     ``view_reports``
   - Humano
   - consume el dashboard
 * - **Frontend**
   - Sistema
   - render del UI
 * - **AnalyticsRepo**
   - Sistema
   - fuente de KPIs (BD Analytics)
 * - **SegmentResolver**
   - Sistema
   - obtiene scope del User
 * - **MetricsCache**
   - Sistema
   - cache de queries pesadas

2.2 Precondiciones
==================

- User autenticado.
- User tiene ``view_reports`` activa.
- BD Analytics accesible.
- User tiene al menos 1 segmento (ver
  EX-02).

2.3 Postcondiciones
===================

- Sin escritura: BD Analytics y
  operativa intactas.
- Cache puede haberse poblado.
- Auto-refresh agendado.

2.4 Datos de entrada
====================

::

   GET /api/dashboard/?period=today

Implícito por JWT: user_id, segment_codes.

2.5 Datos de salida
===================

::

   {
     period: "today",
     refreshed_at: timestamp,
     kpis: {
       total_calls: int,
       answered: int,
       abandoned: int,
       tmo_seconds: float,
       service_level_pct: float,
       avg_wait_seconds: float,
       abandon_rate_pct: float
     },
     trend: {
       interval_minutes: int,
       points: [
         { t, total, answered }, ...
       ]
     },
     segments_applied: list[code],
     cache: bool
   }
