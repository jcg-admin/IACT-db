.. _uc-alr-02-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Alert
=========

.. list-table::
 :widths: 25 25 50

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   - PK
 * - rule_id
   - uuid
   - FK AlertRule
 * - rule_name
   - string
   - snapshot
 * - metric, scope
   - JSON
   - snapshot
 * - severity
   - enum
   -
 * - state
   - firing|acknowledged|
     resolved|closed
   -
 * - fired_at
   - timestamp
   -
 * - acknowledged_by
   - int | null
   -
 * - acknowledged_at
   - timestamp | null
   -
 * - resolved_at
   - timestamp | null
   -
 * - current_value
   - number
   - en momento de query
 * - threshold
   - number
   - snapshot

7.2 Indices
===========

- ``Alert(state, severity, fired_at DESC)``.
- ``Alert(rule_id, fired_at DESC)``.

7.3 Datos NO involucrados
=========================

- Email externo.
