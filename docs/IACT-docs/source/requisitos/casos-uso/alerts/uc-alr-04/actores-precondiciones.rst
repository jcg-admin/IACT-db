.. _uc-alr-04-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion** ``view_alert_history``
- **AlertRepo**

Auth + RBAC + segmento.

::

   GET /api/alerts/history/
       ?period=last_30d
       &filter[rule_id]=...
       &filter[severity]=...

Response:

::

   {
     items: [
       { id, rule_name, severity,
         fired_at, acknowledged_at,
         resolved_at,
         time_to_ack_seconds,
         time_to_resolve_seconds }, ...
     ],
     pagination,
     summary: {
       total, avg_time_to_ack,
       avg_time_to_resolve,
       top_rules_by_count
     }
   }
