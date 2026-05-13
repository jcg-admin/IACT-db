.. _uc-rpt-15-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **TransferEvent** (Analytics): row por
  cada transfer.

7.2 Modelo
==========

::

   TransferEvent:
     event_id, occurred_at,
     segment_code,
     direction: internal|external,
     from_agent_id, from_queue_id,
     to_agent_id, to_queue_id,
     reason_code,
     pre_transfer_seconds,
     post_transfer_outcome:
       resolved|abandoned|escalated

7.3 Indices
===========

- ``TransferEvent(segment_code,
  occurred_at DESC)``.
- ``TransferEvent(from_queue_id,
  to_queue_id)``.
- ``TransferEvent(reason_code)``.

7.4 Datos NO involucrados
=========================

- PII de cliente.
