.. _uc-perm-04-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401.

5.2 EX-02: Sin revoke_exceptional_permission
============================================

403 FORBIDDEN. AuditEvent UNAUTHORIZED
ALERTA ALTA.

5.3 EX-03: Permission no encontrado
===================================

404 PERMISSION_NOT_FOUND.

5.4 EX-04: Permission ya REVOKED (FA-01)
========================================

200 informativo (idempotente) — no es error.

5.5 EX-05: Permission EXPIRED (FA-02)
=====================================

400 INVALID_STATE (no se revoca lo expirado).

5.6 EX-06: User mismatch (URL)
==============================

400 URL_MISMATCH si el ``permission_id`` no
pertenece al ``user_id`` del path.

5.7 EX-07: Auto-revocacion P-11
===============================

400 SELF_REVOKE_FORBIDDEN si invoker == user
y politica activa.

5.8 EX-08: revoke_reason ausente / corta
========================================

400 VALIDATION_ERROR.

5.9 EX-09: Mailbox HARD
=======================

500 MAILBOX_FAILED + ROLLBACK total (P-10).

5.10 EX-10: BD timeout
======================

503.

5.11 EX-11: Audit fail
======================

500 AUDIT_FAILED.

5.12 EX-12: Throttling
======================

429 (limite estricto: 30/hora — operacion
correctiva infrecuente).

5.13 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - Token invalido
   - 401
   - middleware
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED ALERTA
 * - EX-03
   - Permission no existe
   - 404
   - REVOKE_FAILED
 * - EX-04
   - Ya REVOKED
   - 200
   - REVOKE_NOOP
 * - EX-05
   - EXPIRED
   - 400
   - REVOKE_FAILED
 * - EX-06
   - URL mismatch
   - 400
   - REVOKE_FAILED
 * - EX-07
   - Auto-revoke
   - 400
   - REVOKE_FAILED ALERTA
 * - EX-08
   - reason invalida
   - 400
   - validation
 * - EX-09
   - Mailbox HARD
   - 500
   - REVOKE_FAILED (rollback)
 * - EX-10
   - BD timeout
   - 503
   - REVOKE_FAILED
 * - EX-11
   - Audit fail
   - 500
   - (no se emite)
 * - EX-12
   - Rate limit
   - 429
   - middleware
