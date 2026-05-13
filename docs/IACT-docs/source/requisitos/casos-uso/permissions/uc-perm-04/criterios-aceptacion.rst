.. _uc-perm-04-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Revocacion exitosa
=============================

**DADO** invoker con
``revoke_exceptional_permission`` y permission
ACTIVE,

**ENTONCES**:

- Status = 200
- Permission state == REVOKED
- ``revoked_by_admin_id == invoker.id``
- ``revoke_reason`` registrado
- AuditEvent EXCEPTIONAL_PERMISSION_REVOKED
- InternalMessage al User
- Cache invalidada

9.2 CA-02: Diferencia con EXPIRED
=================================

**DADO** revocacion exitosa,

**ENTONCES**:

- ``revoked_by_admin_id != NULL``
- AuditEvent.event_type ==
  EXCEPTIONAL_PERMISSION_REVOKED
  (NOT _EXPIRED)

9.3 CA-03: Idempotencia (FA-01)
===============================

**DADO** permission ya REVOKED,

**ENTONCES**:

- Status = 200 informativo
- AuditEvent
  EXCEPTIONAL_PERMISSION_REVOKE_NOOP

9.4 CA-04: EXPIRED no revocable (FA-02)
=======================================

**DADO** permission EXPIRED por cron,

**ENTONCES**:

- Status = 400 INVALID_STATE

9.5 CA-05: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin
``revoke_exceptional_permission``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED ALERTA ALTA

9.6 CA-06: revoke_reason obligatoria (EX-08)
============================================

**DADO** payload sin reason o < 20 chars,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.7 CA-07: Auto-revocacion P-11 (EX-07)
=======================================

**DADO** invoker == target con politica
activa,

**ENTONCES**:

- Status = 400 SELF_REVOKE_FORBIDDEN
- Audit ALERTA

9.8 CA-08: Mailbox HARD (EX-09)
===============================

**DADO** mailbox INSERT lanza,

**ENTONCES**:

- Status = 500 MAILBOX_FAILED
- ROLLBACK total

9.9 CA-09: URL mismatch (EX-06)
===============================

**DADO** ``permission_id`` no pertenece al
``user_id`` del path,

**ENTONCES**:

- Status = 400 URL_MISMATCH

9.10 CA-10: Atomicidad audit fail
=================================

**DADO** AuditLog.emit lanza,

**ENTONCES**:

- Status = 500
- ROLLBACK total

9.11 CA-11: Cache post-COMMIT
=============================

Cache invalidate llamado DESPUES de COMMIT.

9.12 CA-12: Performance
=======================

P50 ≤ 150 ms.

9.13 CA-13: Throttling
======================

> 30 DELETE/hora → 429.

9.14 CA-14: Audit reforzado high-priority
=========================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- Tagged como high-priority en compliance
  reports
- Payload contiene
  ``previous_expires_at`` para indicar que
  la revocacion fue anticipada

9.15 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Revocacion exitosa
   - Funcional
 * - CA-02
   - Diferencia con EXPIRED
   - Auditabilidad
 * - CA-03..04
   - Idempotencia / EXPIRED
   - Funcional
 * - CA-05..09
   - Excepciones auth/data
   - Seguridad
 * - CA-10..11
   - Atomicidad + cache
   - Confiabilidad
 * - CA-12..13
   - Performance + throttling
   - NFR
 * - CA-14
   - Audit reforzado
   - Cumplimiento
