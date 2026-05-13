.. _uc-rpt-10-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 SavedView
=============

.. list-table::
 :widths: 25 25 50

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - actor_id
   - int
   - owner
 * - name
   - string
   - unique por User
 * - report_type
   - enum
   -
 * - filters
   - JSON
   -
 * - period_relative
   - enum
   -
 * - columns
   - list[col_id]
   -
 * - sort_by
   - JSON
   -
 * - group_by
   - list[Dimension]
   -
 * - chart_config
   - JSON
   -
 * - is_default
   - bool
   -
 * - created_at, updated_at
   - timestamp
   -

7.2 Catalog de columnas
=======================

Externo (vive en codigo / config). Vista
referencia col_ids; si col removida del
catalog, vista lo trata como
``unavailable``.

7.3 Indices
===========

- ``SavedView(actor_id, name)`` unique.
