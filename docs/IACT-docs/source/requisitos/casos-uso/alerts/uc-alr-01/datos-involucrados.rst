.. _uc-alr-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 AlertRule
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
   -
 * - metric
   - enum
   -
 * - scope
   - JSON
   - segment/queue/campaign
 * - condition
   - JSON
   - op + threshold
 * - window_minutes
   - int
   -
 * - severity
   - enum
   -
 * - actions
   - JSON list
   -
 * - cooldown_minutes
   - int
   -
 * - status
   - active | paused
   -
 * - version
   - int
   - incrementado por update
 * - created_at, updated_at
   - timestamp
   -

7.2 AlertRuleHistory
====================

Snapshot por cada update — para auditoria.

7.3 Indices
===========

- ``AlertRule(actor_id)``.
- ``AlertRule(status, version)``.

7.4 Datos NO involucrados
=========================

- Email externo (CNST-001).
