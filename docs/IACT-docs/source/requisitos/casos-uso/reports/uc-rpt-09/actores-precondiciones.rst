.. _uc-rpt-09-parte-02:

=====================================
Parte 2 — Actores y precondiciones
=====================================

2.1 Actores
===========

- **User autenticado**
- **SavedFilterRepo**

2.2 Precondiciones
==================

- User autenticado.
- Para create: User no excede 50 filtros.

2.3 Postcondiciones
===================

- SavedFilter creado / updated / deleted.

2.4 Datos de entrada (create)
=============================

::

   POST /api/me/filters/
   body: {
     name: string,
     filters: { campaign?, queue?, ... },
     period_relative?: enum,
     description?: string,
     applies_to: list[report_type]
   }

2.5 Datos de salida
===================

::

   {
     id, name, filters, period_relative,
     applies_to, created_at, updated_at
   }
