.. _uc-aud-04-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 ComplianceReport
====================

::

   ComplianceReport:
     id, actor_id, template,
     period, format,
     status, file_path, file_url,
     file_hash (sha256),
     signature (HMAC),
     signed_at,
     created_at, completed_at

7.2 Lectura
===========

AuditEvent + AccessGroup + Function +
User (read-only).

7.3 HMAC key
============

Key vive en HSM / KMS (no en codigo).
Rotation periodica.
