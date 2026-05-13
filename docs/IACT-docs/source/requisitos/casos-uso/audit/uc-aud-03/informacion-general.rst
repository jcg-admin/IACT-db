.. _uc-aud-03-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_AUD_03
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC**
   - ``export_audit``

1.1 Proposito
=============

Generar archivo (CSV/JSON) con AuditEvents
para entrega a auditores externos. Soporta
include_archive (acceso > 90 dias).

1.2 Restricciones
=================

CNST-001 NO email externo. CNST-002 mailbox.
CNST-026 sin PII. CNST-025 inmutable
(read-only export).

1.3 Audit reforzado
===================

P-39 + meta-audit del export.

1.4 Out of scope
================

- Search (UC_AUD_02).
