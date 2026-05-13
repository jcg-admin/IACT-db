.. _uc-acc-08-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Grant exitoso
========================

**DADO** invoker con funcion + payload valido,

**ENTONCES**:

- Status = 201
- N ExceptionalPermission ACTIVE creados
- InternalMessage al User obligatorio
- AuditEvent EXCEPTIONAL_PERMISSION_GRANTED
- Cache invalidada

9.2 CA-02: justification obligatoria (EX-06)
============================================

**DADO** payload sin justification o < 20
chars,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR
- Sin cambios en BD

9.3 CA-03: expires_at bounds (EX-07)
====================================

**DADO** ``expires_at = NOW()+100 dias`` (>
30 max),

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.4 CA-04: expires_at obligatorio
=================================

**DADO** payload sin ``expires_at``,

**ENTONCES**:

- Status = 400 VALIDATION_ERROR

9.5 CA-05: Auto-grant prohibido (EX-05)
=======================================

**DADO** invoker con la funcion,

**CUANDO** intenta grant sobre si mismo,

**ENTONCES**:

- Status = 400 SELF_GRANT_FORBIDDEN
- AuditEvent ALERTA CRITICA

9.6 CA-06: SoD violation (EX-09)
================================

**DADO** funcion en conflicto con permisos
actuales del target,

**ENTONCES**:

- Status = 409 SOD_VIOLATION
- All-or-nothing

9.7 CA-07: Mailbox-or-abort hard (EX-11, P-10)
==============================================

**DADO** mailbox INSERT lanza,

**ENTONCES**:

- Status = 500 MAILBOX_FAILED
- ROLLBACK total — sin
  ExceptionalPermission creado

9.8 CA-08: Sin la funcion 403 (EX-02)
=====================================

403 + UNAUTHORIZED ALERTA ALTA.

9.9 CA-09: Idempotencia parcial (FA-02)
=======================================

**DADO** mix nuevas + ya granted,

**ENTONCES**:

- granted (las nuevas) + skipped (las ya
  activas)

9.10 CA-10: Re-grant post EXPIRED (FA-03)
=========================================

Nuevo ACTIVE + EXPIRED previo preservado.

9.11 CA-11: ticket_reference required (FA-04)
=============================================

**DADO** politica activa,

**CUANDO** justification sin TKT-,

**ENTONCES**:

- Status = 400 TICKET_REFERENCE_REQUIRED

9.12 CA-12: Audit reforzado
===========================

**DADO** AuditEvent emitido,

**ENTONCES**:

- payload contiene ``justification``,
  ``expires_at``, ``ticket_reference``,
  ``function_ids``, ``target_user_id``
- payload NO contiene email/full_name
  (CNST-026)

9.13 CA-13: Cache post-COMMIT
=============================

Invalidate llamado DESPUES del COMMIT.

9.14 CA-14: Throttling estricto (EX-14)
=======================================

**DADO** > 10 grants/hora/invoker,

**ENTONCES**:

- Status = 429

9.15 CA-15: Cron expiracion (asincrono)
=======================================

**DADO** ExceptionalPermission con
``expires_at < NOW()``,

**CUANDO** cron corre,

**ENTONCES**:

- state transita a EXPIRED
- AuditEvent
  EXCEPTIONAL_PERMISSION_EXPIRED
- Cache invalidada

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01
   - Grant exitoso
   - Funcional
 * - CA-02..04
   - Validaciones obligatorias
   - Funcional / Auditabilidad
 * - CA-05
   - Auto-grant prohibido
   - Seguridad
 * - CA-06
   - SoD all-or-nothing
   - Cumplimiento
 * - CA-07
   - Mailbox-or-abort hard (P-10)
   - Confiabilidad
 * - CA-08
   - Sin permiso
   - Seguridad
 * - CA-09..11
   - Flujos alternos
   - Funcional
 * - CA-12
   - Audit reforzado
   - Cumplimiento
 * - CA-13
   - Cache post-COMMIT
   - Confiabilidad
 * - CA-14
   - Throttling estricto
   - Seguridad
 * - CA-15
   - Cron expiracion
   - Funcional / asincrono
