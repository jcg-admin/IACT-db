.. _uc-alr-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User con funcion**
  ``view_active_alerts``
- **AlertRepo**

2.2 Precondiciones
==================

Auth + RBAC + segmento.

2.3 Postcondiciones
===================

Sin escrituras.

2.4 Datos de entrada
====================

::

   GET /api/alerts/active/
       ?severity=critical|warning|info
       &state=firing|acknowledged

2.5 Datos de salida
===================

::

   {
     items: [
       { id, rule_name, metric,
         severity, scope, fired_at,
         acknowledged_by?,
         acknowledged_at?,
         current_value,
         threshold }, ...
     ],
     total, refresh_recommended_seconds: 10
   }
