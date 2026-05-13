.. _uc-auth-05-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Listado paginado
===========================

**DADO** un admin con
``view_all_active_sessions`` y 134 Sessions
ACTIVE,

**CUANDO** GET ``/api/auth/sessions/?page=1``,

**ENTONCES**:

- Status = 200
- ``count == 134``
- ``results.length == 50`` (default page_size)
- ``next`` no NULL

9.2 CA-02: Filtro por user_id
=============================

**DADO** filtro ``?user_id=42``,

**ENTONCES**:

- Cada item en ``results`` tiene
  ``user_id == 42``
- AuditEvent ``SESSIONS_VIEWED_FOR_USER`` con
  ``payload.target_user_id=42``

9.3 CA-03: Sin PII en listado
=============================

**DADO** cualquier listado,

**ENTONCES**:

- Items NO contienen email, full_name, RUT
- Items contienen username (no PII directa
  segun politica) y user_id

9.4 CA-04: Cierre individual
============================

**DADO** una Session ACTIVE de User=42,

**CUANDO** admin envia POST close,

**ENTONCES**:

- Status = 200
- Session ``state == 'CLOSED'``,
  ``close_reason == 'ADMIN_REVOKED'``,
  ``closed_by_admin_id == admin.id``
- 1 AuditEvent SESSION_CLOSED
- Tokens activos en blacklist

9.5 CA-05: Cierre idempotente (FA-02)
=====================================

**DADO** una Session CLOSED,

**CUANDO** admin envia POST close,

**ENTONCES**:

- Status = 200
- ``close_reason`` original preservado
- AuditEvent SESSION_CLOSE_NOOP

9.6 CA-06: Cierre masivo
========================

**DADO** un User con 3 Sessions ACTIVE,

**CUANDO** admin envia POST close-all-sessions,

**ENTONCES**:

- Status = 200
- ``sessions_closed == 3``
- 3 Sessions con state CLOSED
- 3 AuditEvent SESSION_CLOSED + 1
  BULK_SESSION_CLOSE

9.7 CA-07: Auto-bulk-close prohibido (EX-04)
============================================

**DADO** admin con AGR-006,

**CUANDO** intenta close-all-sessions sobre si
mismo,

**ENTONCES**:

- Status = 400
- Body ``error == 'SELF_BULK_CLOSE_FORBIDDEN'``
- Sin cambios en BD

9.8 CA-08: Sin permiso lectura (EX-02)
======================================

**DADO** admin sin
``view_all_active_sessions``,

**CUANDO** GET ``/api/auth/sessions/``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

9.9 CA-09: Sin permiso cierre (EX-03)
=====================================

**DADO** admin sin ``close_user_session``,

**CUANDO** intenta cerrar Session,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

9.10 CA-10: Token rechazado post-cierre
=======================================

**DADO** una Session cerrada por admin,

**CUANDO** el User intenta usar su access
token,

**ENTONCES**:

- Status = 401 (token blacklisteado)

9.11 CA-11: Notificacion al User (FA-04)
========================================

**DADO** setting NOTIFY_USER=True y cierre
admin,

**ENTONCES**:

- 1 InternalMessage en buzon del User con
  subject "Sesion cerrada por administrador"
- Body NO expone identidad del admin

9.12 CA-12: Vista propia (FA-06)
================================

**DADO** un User regular sin AGR-006 pero con
``view_own_sessions``,

**CUANDO** GET ``/api/auth/sessions/own/``,

**ENTONCES**:

- Status = 200
- Cada item ``user_id == request.user.id``

9.13 CA-13: Atomicidad bulk
===========================

**DADO** una falla en INSERT AuditEvent en
medio del bulk,

**CUANDO** se procesa close-all-sessions,

**ENTONCES**:

- Status = 500
- TODAS las Sessions del User permanecen
  ACTIVE (rollback)

9.14 CA-14: Rate limit (EX-09)
==============================

**DADO** admin que ha hecho > 100 req/min,

**ENTONCES**:

- Status = 429

9.15 CA-15: Filtro malformado (EX-10)
=====================================

**DADO** ``?created_after=invalid``,

**ENTONCES**:

- Status = 400
- ``details.created_after`` con descripcion

9.16 CA-16: Performance listado
===============================

**DADO** 134 Sessions ACTIVE,

**ENTONCES**:

- P50 ≤ 150 ms para listado paginado

9.17 CA-17: Audit inmutable (CNST-025)
======================================

**DADO** un AuditEvent SESSION_CLOSED,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.18 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Listado, filtros, sin PII
   - Funcional / cumplimiento
 * - CA-04..06
   - Cierre individual / idempotente / masivo
   - Funcional
 * - CA-07
   - Auto-bulk-close prohibido
   - Seguridad
 * - CA-08..09
   - Sin permisos
   - Seguridad
 * - CA-10
   - Token rechazado post-cierre
   - Seguridad
 * - CA-11
   - Notificacion User
   - Funcional
 * - CA-12
   - Vista propia
   - Funcional
 * - CA-13
   - Atomicidad bulk
   - Confiabilidad
 * - CA-14
   - Rate limit
   - Seguridad
 * - CA-15
   - Filtro malformado
   - Funcional
 * - CA-16
   - P50
   - Performance
 * - CA-17
   - Audit inmutable
   - CNST-025
