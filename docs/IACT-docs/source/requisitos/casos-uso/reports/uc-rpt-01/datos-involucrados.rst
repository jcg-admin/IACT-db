.. _uc-rpt-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas (BD Analytics)
===================================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Entidad
   - Uso
 * - **CallEvent / CallSummary**
   - aggregations de llamadas
 * - **SegmentDimension**
   - filtro por segmento del User
 * - **TimeBucket**
   - granularidad de trend (hora /
     dia)

7.2 Entidades NO leidas (CNST-007)
==================================

Operativa:

- ``Call`` (BD operativa) — UC_RPT_01 NO
  toca. Operacionales son responsabilidad
  del IVR.
- ``Conversation`` — idem.

7.3 Modelo conceptual del summary
=================================

::

   CallSummary (analytics):
     time_bucket: timestamp (hora o min)
     segment_code: string
     count_total: int
     count_answered: int
     count_abandoned: int
     sum_duration_seconds: bigint
     sum_wait_seconds: bigint
     count_within_sl: int (umbral SL)

ETL pobla por hora desde BD operativa
(UC_PIP_*). UC_RPT_01 lee de aqui.

7.4 Cache
=========

::

   key = "dashboard:" + user_id + ":"
                      + period + ":"
                      + segments_hash
   ttl: 30s (today) | 60s (yesterday)
        | 300s (last_7d)

7.5 Indices criticos
====================

- ``CallSummary(segment_code,
  time_bucket DESC)``
- Particionamiento por dia (Analytics).

7.6 Datos NO involucrados
=========================

- PII: telefonos de llamadas individuales.
- Audio / transcripciones.
- Datos personales del cliente.
- AuditEvents (uso de UC_PERM_10 separado).
