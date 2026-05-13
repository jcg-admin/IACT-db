.. _uc-rpt-16-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **IVRSessionEvent** (Analytics).

7.2 Modelo
==========

::

   IVRSessionEvent:
     session_id, occurred_at,
     ivr_id, segment_code,
     event_type:
       entry|node_visit|option_selected|
       complete|drop|timeout
     node_id?,
     option_selected?,
     time_in_node_seconds?

7.3 Indices
===========

- ``IVRSessionEvent(ivr_id,
  occurred_at DESC)``.
- ``IVRSessionEvent(session_id,
  occurred_at)``.

7.4 Datos NO involucrados
=========================

- DTMF tones / audio.
- PII del caller.
