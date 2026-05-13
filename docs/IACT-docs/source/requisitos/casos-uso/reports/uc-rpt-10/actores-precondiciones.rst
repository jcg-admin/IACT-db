.. _uc-rpt-10-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User autenticado**
- **SavedViewRepo**

2.2 Precondiciones
==================

- Auth + segmento.
- < 30 vistas existentes.

2.3 Postcondiciones
===================

SavedView creada / updated / deleted.

2.4 Datos de entrada (create)
=============================

::

   POST /api/me/views/
   body: {
     name, report_type,
     filters, period_relative,
     columns: list[col_id],
     sort_by, group_by,
     chart_config?
   }

2.5 Datos de salida
===================

SavedView con metadata.
