.. _uc-rpt-09-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 SavedFilter
===============

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
 * - filters
   - JSON
   -
 * - period_relative
   - enum
   -
 * - applies_to
   - list[report_type]
   -
 * - is_default
   - bool
   - max 1 default por report_type
 * - is_invalid
   - bool
   - true si segmentos cambiaron
 * - description
   - string
   -
 * - created_at
   - timestamp
   -
 * - updated_at
   - timestamp
   -

7.2 Indices
===========

- ``SavedFilter(actor_id, name)`` unique.

7.3 Datos NO involucrados
=========================

- Email externo.
