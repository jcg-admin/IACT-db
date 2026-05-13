.. _uc-aud-02-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Index FTS
=============

- AuditEvent indexado en FTS engine
  (Elasticsearch / Postgres FTS / similar).
- Campos indexados: event_type, payload
  (sanitized), actor_username (hash).

7.2 Sync con AuditEvent
=======================

ETL o trigger sincronico al escribir
AuditEvent: indexar en FTS.

7.3 Sin PII
===========

Index NO contiene PII raw (sanitized
upstream).
