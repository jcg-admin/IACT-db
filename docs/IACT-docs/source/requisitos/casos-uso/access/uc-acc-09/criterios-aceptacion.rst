.. _uc-acc-09-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Listado paginado
===========================

**DADO** invoker con view_access_audit y N
eventos en BD,

**ENTONCES**:

- Status = 200
- count = N
- results paginados

9.2 CA-02: Solo eventos MOD_Access
==================================

**DADO** BD contiene eventos de
MOD_Access + MOD_Auth + MOD_Reports,

**ENTONCES**:

- Body solo contiene eventos cuyo
  ``event_type ∈ ACCESS_EVENT_TYPES``

9.3 CA-03: Filter target_user_id audita (FA-01)
===============================================

**DADO** GET con ``?target_user_id=42``,

**ENTONCES**:

- AuditEvent ACCESS_AUDIT_VIEWED con
  ``payload.target_user_id == 42``

9.4 CA-04: Filter sin target NO audita
======================================

**DADO** GET sin ``target_user_id``,

**ENTONCES**:

- ZERO AuditEvent ACCESS_AUDIT_VIEWED

9.5 CA-05: Sin permiso 403 (EX-02)
==================================

**DADO** invoker sin view_access_audit,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT

9.6 CA-06: Filter invalido 400 (EX-03)
======================================

**DADO** ordering invalido,

**ENTONCES**:

- Status = 400 BAD_FILTER

9.7 CA-07: Anti-SQLi en ordering
================================

**DADO** ``?ordering='; DROP TABLE...``,

**ENTONCES**:

- Status = 400
- BD intacta

9.8 CA-08: Vista detalle 200 (FA-03)
====================================

**DADO** event_id valido en MOD_Access,

**ENTONCES**:

- Status = 200
- Body con payload completo
- AuditEvent P-16 con ``viewed_event_id``

9.9 CA-09: Detalle fuera de scope 404 (EX-06)
=============================================

**DADO** event_id de MOD_Auth,

**ENTONCES**:

- Status = 404 (no 403, anti-info-leak)

9.10 CA-10: Agregaciones (FA-04)
================================

**DADO** GET aggregations group_by=event_type,

**ENTONCES**:

- Status = 200
- Array de {event_type, count}
- ZERO AuditEvent

9.11 CA-11: Filter por function_id (FA-05)
==========================================

**DADO** ``?includes_function_id=42``,

**ENTONCES**:

- Resultados solo eventos cuyo payload
  contiene 42 en ``function_ids``

9.12 CA-12: Sin PII en response (CNST-026)
==========================================

**DADO** cualquier response,

**ENTONCES**:

- Body NO contiene email/full_name (excepto
  username — ya no PII directa)

9.13 CA-13: Performance P50
===========================

**DADO** filtros con rango temporal de 30
dias e indices,

**ENTONCES**:

- P50 ≤ 200 ms

9.14 CA-14: Throttling (EX-04)
==============================

**DADO** > 200 GET/min,

**ENTONCES**:

- Status = 429

9.15 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..02
   - Listado + scope ACCESS
   - Funcional
 * - CA-03..04
   - Audit selectivo P-16
   - Auditabilidad
 * - CA-05..07
   - Permisos + filtros + anti-SQLi
   - Seguridad
 * - CA-08..09
   - Vista detalle + scope
   - Funcional
 * - CA-10
   - Agregaciones sin audit
   - Funcional
 * - CA-11
   - Filter function_id (JSON contains)
   - Funcional
 * - CA-12
   - Sin PII
   - Cumplimiento
 * - CA-13
   - Performance
   - Performance
 * - CA-14
   - Rate limit
   - Seguridad
