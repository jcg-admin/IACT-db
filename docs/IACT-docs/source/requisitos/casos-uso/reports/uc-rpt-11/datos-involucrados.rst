.. _uc-rpt-11-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 ShareEntry
==============

.. list-table::
 :widths: 25 25 50

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - view_id
   - uuid
   - FK SavedView
 * - owner_id
   - int
   - el que comparte
 * - target_type
   - enum
   - user / agr / segment_public
 * - target_id
   - int / string
   -
 * - permission
   - enum
   - read / clone
 * - expires_at
   - timestamp | null
   -
 * - revoked_at
   - timestamp | null
   -
 * - created_at
   - timestamp
   -

7.2 Indices
===========

- ``ShareEntry(view_id)``.
- ``ShareEntry(target_type, target_id)``.
- ``ShareEntry(owner_id)``.

7.3 Cascade rules
=================

- Borrar SavedView → borra ShareEntries.
- Borrar User target → ShareEntries con
  ese target quedan inactivos (NO se
  borran para audit).

7.4 Datos NO involucrados
=========================

- Email externo (CNST-001).
