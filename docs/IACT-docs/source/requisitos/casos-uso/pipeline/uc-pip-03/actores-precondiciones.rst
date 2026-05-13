.. _uc-pip-03-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion**
  ``view_data_availability``
- **DatasetMetadataRepo**

::

   GET /api/data/availability/

Response:

::

   {
     datasets: [
       { name, last_refresh_at,
         lag_minutes, status:
         fresh|stale|critical_stale }, ...
     ],
     overall_status
   }
