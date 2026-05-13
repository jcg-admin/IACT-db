.. _uc-rpt-13-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **QueueDailyStat** (Analytics): agregado
  por cola y dia.
- **Queue** (catalog): name + segment_code.

7.2 Modelo
==========

::

   QueueDailyStat:
     queue_id, date, segment_code,
     calls_offered,
     calls_answered,
     calls_abandoned,
     sum_wait_seconds,
     count_within_sl,
     max_wait_seconds,
     peak_queue_depth

7.3 Indices
===========

- ``QueueDailyStat(queue_id, date DESC)``.
- ``QueueDailyStat(segment_code, date)``.

7.4 Datos NO involucrados
=========================

- PII.
- Audio / transcripciones.
