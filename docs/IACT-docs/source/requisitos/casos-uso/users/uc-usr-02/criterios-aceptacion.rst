.. _uc-usr-02-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: Listado paginado
===========================

**DADO** invocante con ``list_users`` y 187 Users
en sistema,

**CUANDO** GET ``/api/users/?page=1``,

**ENTONCES**:

- Status = 200
- ``count == 187``
- ``results.length == 50`` (default page_size)
- ``next != null``

9.2 CA-02: Restriccion campos PII en listado (CNST-026)
=======================================================

**DADO** cualquier listado,

**ENTONCES**:

- Items NO contienen ``email`` completo
  (mascarado o ausente segun politica)
- Items NO contienen ``password_hash``,
  ``first_name``/``last_name`` completos

9.3 CA-03: Detalle con todos los campos no-secretos
===================================================

**DADO** invocante con ``view_users`` y User
existente,

**CUANDO** GET ``/api/users/{id}/``,

**ENTONCES**:

- Status = 200
- Body contiene ``email`` completo, AGRs activos
- Body NO contiene ``password_hash``

9.4 CA-04: Sin list_users 403 (EX-02)
=====================================

**DADO** invocante sin ``list_users``,

**ENTONCES**:

- Status = 403
- AuditEvent UNAUTHORIZED_ACCESS_ATTEMPT
- Sin lectura

9.5 CA-05: Sin view_users 403 (EX-03)
=====================================

**DADO** invocante con ``list_users`` pero sin
``view_users``,

**CUANDO** GET ``/api/users/{id}/``,

**ENTONCES**:

- Status = 403 (granularidad RBAC)

9.6 CA-06: User no existe 404 (EX-04)
=====================================

**DADO** ``user_id`` inexistente,

**ENTONCES**:

- Status = 404

9.7 CA-07: Audit selectivo P-16 (FA-02)
=======================================

**DADO** invocante con ``list_users``,

**CUANDO** GET ``/api/users/?user_id=42``,

**ENTONCES**:

- Status = 200
- AuditEvent USERS_VIEWED_FOR_USER con
  ``target_user_id=42``

9.8 CA-08: Listado amplio NO se audita
======================================

**DADO** invocante con ``list_users``,

**CUANDO** GET ``/api/users/`` (sin filter
user_id),

**ENTONCES**:

- Status = 200
- ZERO AuditEvent USERS_VIEWED_FOR_USER

9.9 CA-09: Detalle se audita siempre
====================================

**DADO** invocante con ``view_users``,

**CUANDO** GET ``/api/users/{id}/`` (cualquier
id),

**ENTONCES**:

- AuditEvent USER_DETAIL_VIEWED con
  ``target_user_id``

9.10 CA-10: Self-view marcado
=============================

**DADO** invocante con ``view_users``,

**CUANDO** GET ``/api/users/{invocante.id}/``,

**ENTONCES**:

- Status = 200
- AuditEvent payload contiene ``self_view=true``

9.11 CA-11: Filtro malformado 400 (EX-05)
=========================================

**DADO** ``?ordering=arbitrary_field``,

**ENTONCES**:

- Status = 400 BAD_FILTER

9.12 CA-12: Anti-SQLi en ordering
=================================

**DADO** ``?ordering='; DROP TABLE users; --``,

**ENTONCES**:

- Status = 400
- DB intacta

9.13 CA-13: Performance P50 listado
===================================

**DADO** 187 Users con indices,

**ENTONCES**:

- P50 ≤ 150 ms

9.14 CA-14: Audit inmutable (CNST-025)
======================================

**DADO** AuditEvent emitido,

**ENTONCES**:

- BD rechaza UPDATE/DELETE

9.15 CA-15: Throttling (EX-06)
==============================

**DADO** > 150 GET/min/invocante,

**ENTONCES**:

- Status = 429

9.16 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..03
   - Listado paginado, PII restriction, detalle
   - Funcional / cumplimiento
 * - CA-04..05
   - RBAC granular list vs view
   - Seguridad
 * - CA-06
   - User no existe
   - Funcional
 * - CA-07..09
   - Audit selectivo P-16
   - Auditabilidad
 * - CA-10
   - Self-view
   - Funcional / audit
 * - CA-11..12
   - Filtros + anti-SQLi
   - Seguridad
 * - CA-13
   - P50
   - Performance
 * - CA-14
   - Audit inmutable
   - CNST-025
 * - CA-15
   - Rate limit
   - Seguridad
