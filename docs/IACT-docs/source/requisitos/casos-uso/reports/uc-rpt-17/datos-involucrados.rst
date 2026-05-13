.. _uc-rpt-17-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

- **CallEvent / CallSummary** con
  ``client_hash`` ya pre-calculado por
  ETL (UC_PIP_*).

7.2 Hash precalculado
=====================

ETL genera ``client_hash`` al ingresar el
evento a Analytics. Sha256 con tenant_salt.
Reportes leen ``client_hash``, NUNCA
``client_id`` raw.

7.3 Indices
===========

- ``CallSummary(segment_code,
  bucket_date)``.
- ``CallSummary(client_hash)`` para count
  distinct.

7.4 HLL sketch
==============

Si volumen > umbral (10M+/dia), usar HLL
sketch precalculado por dia / segmento:

::

   CallHourlyHLL:
     segment_code, hour, hll_sketch

7.5 Datos NO involucrados
=========================

- ``client_id`` raw (PII).
- ``client_phone``.
- Nombres / emails.
