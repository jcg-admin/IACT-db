.. _uc-aud-01-parte-01:

==============================
Parte 1 — Informacion general
==============================

.. list-table::
 :widths: 30 70

 * - **ID**
   - UC_AUD_01
 * - **BReq**
   - BReq-004
 * - **Funcion RBAC**
   - ``view_general_audit``

1.1 Proposito
=============

List paginado timeline-style de TODOS los
AuditEvents (todos los modulos), con filtros.

1.2 Diferencia con UC_PERM_10
=============================

UC_PERM_10: scope = eventos RBAC/auth.
UC_AUD_01: scope = TODOS los modulos
(incluyendo operacionales).

Funcion separada para tener granularidad:
puede haber compliance officer con audit
general pero no necesariamente
``view_audit_log`` (RBAC-specific).

1.3 Restricciones
=================

CNST-008, CNST-009, CNST-013, CNST-025
(no UPDATE/DELETE), CNST-026 (sin PII).

1.4 Audit del audit (P-44)
==========================

Igual que UC_PERM_10: meta-audit
``GENERAL_AUDIT_QUERIED``.
