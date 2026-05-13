.. _uc-alr-05-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Subscription
================

.. list-table::
 :widths: 25 25 50

 * - Campo
   - Tipo
   - Notas
 * - id
   - uuid
   -
 * - user_id
   - int
   -
 * - subscription_type
   - rule|severity|scope
   -
 * - rule_id
   - uuid | null
   -
 * - severity_filter
   - enum | null
   -
 * - scope_filter
   - JSON | null
   -
 * - status
   - active | paused
   -
 * - created_at
   - timestamp
   -

7.2 Indices
===========

- ``Subscription(user_id, status)``.
- ``Subscription(rule_id)``.

7.3 Auto-pause trigger
======================

Cuando User pierde segmento → trigger
en SegmentChangeListener pausa subs
afectadas.
