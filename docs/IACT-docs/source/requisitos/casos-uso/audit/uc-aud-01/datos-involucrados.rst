.. _uc-aud-01-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades
=============

Lectura: AuditEvent (mismo modelo
de UC_PERM_09/10).

Escritura: meta-audit
``GENERAL_AUDIT_QUERIED`` via UC_PERM_09.

7.2 Indices criticos
====================

- ``AuditEvent(created_at DESC)``.
- ``AuditEvent(module, created_at)``.
- ``AuditEvent(actor_id, created_at)``.

7.3 Particiones
===============

Igual que UC_PERM_10.
