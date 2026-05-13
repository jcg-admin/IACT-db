.. _uc-acc-03-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Vista consolidada exitosa
====================================

**DADO** invoker con ``view_assignments`` y
target con 3 funciones directas + 1 AGR con
2 funciones + 0 excepcionales,

**ENTONCES**:

- Status = 200
- ``effective_total_count == 5``
- ``via_direct_count == 3``
- ``via_agr_count == 2``
- ``via_exceptional_count == 0``

9.2 CA-02: Deduplicacion con multiples sources
==============================================

**DADO** target con function_id=1 directo Y
via AGR-006 (que la contiene),

**ENTONCES**:

- ``effective_functions`` lista function_id=1
  UNA SOLA VEZ
- ``sources`` para esa funcion lista AMBAS:
  ``direct`` + ``via_agr:6``

9.3 CA-03: User sin permisos (FA-01)
====================================

**DADO** target sin Assignments activos,

**ENTONCES**:

- Status = 200
- ``effective_functions == []``
- todos los counts == 0

9.4 CA-04: Self-view permitida sin permiso (FA-02)
==================================================

**DADO** invoker SIN ``view_assignments``,

**CUANDO** GET ``/api/auth/me/permissions/`` o
``/api/users/{invoker.id}/effective-permissions/``,

**ENTONCES**:

- Status = 200
- ``self_view == true``
- AuditEvent con ``self_view=true``

9.5 CA-05: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin ``view_assignments`` y NO
es self-view,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

9.6 CA-06: User no existe 404 (EX-03)
=====================================

**DADO** user_id inexistente,

**ENTONCES**:

- Status = 404

9.7 CA-07: Expired pending purge detectado (FA-04)
==================================================

**DADO** target con Assignment ACTIVE pero
``expires_at < NOW()``,

**ENTONCES**:

- ``expired_pending_purge`` no vacio
- La funcion sigue en ``effective_functions``
  (no purgada por cron aun)

9.8 CA-08: SoD inconsistencia detectada (FA-05)
===============================================

**DADO** target con par conflictivo segun
SoDRule activa,

**ENTONCES**:

- ``sod_violations_detected`` lista la regla
  + ``conflict_pair``
- Status = 200 (informativo, no bloqueo)

9.9 CA-09: Audit selectivo P-16
===============================

**DADO** consulta a un user_id,

**ENTONCES**:

- AuditEvent ``EFFECTIVE_PERMISSIONS_VIEWED``
  emitido con ``target_user_id``,
  ``self_view``, counts

9.10 CA-10: Sin PII en payload (CNST-026)
=========================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- Payload sin email, full_name del target

9.11 CA-11: Sin PII en response
===============================

**DADO** response 200,

**ENTONCES**:

- Body NO contiene email, full_name del
  target completo (solo username y user_id)

9.12 CA-12: Performance P50
===========================

**DADO** target con < 5 AGRs y < 20 funciones
efectivas,

**ENTONCES**:

- P50 ≤ 100 ms

9.13 CA-13: Throttling (EX-04)
==============================

**DADO** invoker > 100 GET/min,

**ENTONCES**:

- Status = 429

9.14 CA-14: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.15 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Consolidacion + deduplicacion
   - Funcional
 * - CA-03
   - Sin permisos
   - FA-01
 * - CA-04
   - Self-view
   - FA-02 / RBAC
 * - CA-05..06
   - Excepciones permisos / no existe
   - Seguridad / Funcional
 * - CA-07..08
   - Warnings (expired, SoD)
   - Auditoria informativa
 * - CA-09
   - Audit selectivo P-16
   - Auditabilidad
 * - CA-10..11
   - Sin PII (audit + response)
   - Cumplimiento
 * - CA-12
   - Performance
   - Performance
 * - CA-13
   - Rate limit
   - Seguridad
 * - CA-14
   - Audit inmutable
   - CNST-025
