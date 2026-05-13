.. _uc-pip-02-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

- **User con funcion** ``view_etl_errors``
- **ETLErrorRepo**

::

   GET /api/etl/errors/?period=last_7d&pipeline_id=X

Response: list de errors con detalle.
