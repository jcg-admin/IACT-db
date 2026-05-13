.. _uc-rpt-09-parte-03:

==========================
Parte 3 — Flujo principal
==========================

3.1 Crear
=========

PASO 1 — POST.
PASO 2 — JWT.
PASO 3 — Validar:

- nombre no vacio, ≤ 100 char
- nombre unico por User
- filtros estructuralmente validos
- filtros NO violan segmento del User
- ``applies_to`` ⊆ {historical,
  agents, queues, ...}

PASO 4 — Validar User no excede 50.
PASO 5 — INSERT SavedFilter.
PASO 6 — Response 201.

3.2 List / Get / Update / Delete
================================

CRUD estandar sobre ``/me/filters/`` con
ownership por defecto.

3.3 Aplicar
===========

Aplicar filtro guardado:

::

   GET /api/reports/historical/
       ?saved_filter_id=X

Backend resuelve saved_filter, expande
filtros + period_relative, y ejecuta como
si el User hubiera enviado los parametros.

3.4 Resumen
===========

.. list-table::
 :widths: 8 50 22 20

 * - Paso
   - Accion
   - Componente
   - CNST
 * - 1-2
   - POST + JWT
   - Endpoint
   - 009
 * - 3
   - Validar
   - Validator
   - 008
 * - 4
   - Limite
   - Limiter
   - —
 * - 5
   - INSERT
   - Repo
   - —
 * - 6
   - 201
   - View
   - —
