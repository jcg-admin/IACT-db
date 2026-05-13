.. _uc-acc-08-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401.

5.2 EX-02: Sin grant_exceptional_permission
===========================================

403 FORBIDDEN. AuditEvent
UNAUTHORIZED_ACCESS_ATTEMPT alta severidad
(intento de escalada).

5.3 EX-03: User no encontrado
=============================

404.

5.4 EX-04: User estado invalido
===============================

400 INVALID_USER_STATE.

5.5 EX-05: Auto-grant prohibido (P-11)
======================================

400 SELF_GRANT_FORBIDDEN. AuditEvent ALERTA
ALTA — intento de auto-otorgar privilegios
excepcionales.

5.6 EX-06: justification ausente / corta
========================================

400 VALIDATION_ERROR.

5.7 EX-07: expires_at fuera de bounds
=====================================

400 VALIDATION_ERROR. Bounds:
NOW()+1h ≤ x ≤ NOW()+30d.

5.8 EX-08: Funcion no existe / inactiva
=======================================

400 FUNCTION_NOT_FOUND / FUNCTION_INACTIVE.

5.9 EX-09: SoD violation
========================

409 SOD_VIOLATION. All-or-nothing.

5.10 EX-10: ticket_reference required (FA-04)
=============================================

400 TICKET_REFERENCE_REQUIRED si politica.

5.11 EX-11: Mailbox fail
========================

500 MAILBOX_FAILED. **Hard policy** — ROLLBACK
total (P-10).

5.12 EX-12: BD timeout
======================

503.

5.13 EX-13: Audit fail
======================

500 AUDIT_FAILED.

5.14 EX-14: Throttling
======================

429 — limite mas estricto que UC_ACC_01:
10/hora/invoker (operacion excepcional).

5.15 Resumen
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
   - UNAUTHORIZED ALERTA ALTA
 * - EX-03
   - User no existe
   - 404
   - GRANT_FAILED
 * - EX-04
   - User state invalido
   - 400
   - GRANT_FAILED
 * - EX-05
   - Auto-grant
   - 400
   - GRANT_FAILED ALERTA ALTA
 * - EX-06
   - justification corta
   - 400
   - validation
 * - EX-07
   - expires_at out of bounds
   - 400
   - validation
 * - EX-08
   - Funcion invalida
   - 400
   - GRANT_FAILED
 * - EX-09
   - SoD violation
   - 409
   - GRANT_FAILED ALERTA
 * - EX-10
   - Sin ticket_reference
   - 400
   - validation
 * - EX-11
   - Mailbox fail
   - 500
   - GRANT_FAILED (rollback)
 * - EX-12
   - BD timeout
   - 503
   - GRANT_FAILED
 * - EX-13
   - Audit fail
   - 500
   - (no se emite)
 * - EX-14
   - Rate limit
   - 429
   - middleware
