.. _uc-perm-10-parte-09:

=================================
Parte 9 — Criterios de aceptacion
=================================

9.1 CA-01: List basico
======================

**DADO** filtros validos,
**ENTONCES** 200 con events ordenados
created_at DESC.

9.2 CA-02: Paginacion cursor
============================

**DADO** > page_size resultados,
**ENTONCES** next_cursor presente y
funcional.

9.3 CA-03: Cursor estable
=========================

**DADO** misma query con mismos filtros,
**CUANDO** se siguen multiples paginas,
**ENTONCES** sin duplicados ni omisiones.

9.4 CA-04: Cursor invalidado al cambiar filtros
===============================================

**DADO** filtros distintos al issuance,
**ENTONCES** 400 CURSOR_INVALID.

9.5 CA-05: Filtro actor_id
==========================

**DADO** filtro actor_id=42,
**ENTONCES** todos los events tienen
actor_id=42.

9.6 CA-06: Filtro event_type lista
==================================

**DADO** event_type=AGR_ASSIGNED,AGR_REVOKED,
**ENTONCES** events son uno de esos dos.

9.7 CA-07: Filtro date range
============================

**DADO** date_from=X, date_to=Y,
**ENTONCES** todos los events ∈ [X, Y].

9.8 CA-08: Range > 90 dias rechazado
====================================

**DADO** range > 90 sin archive,
**ENTONCES** 400 con sugerencia export.

9.9 CA-09: Detalle exitoso
==========================

**DADO** id existe online,
**ENTONCES** 200 con AuditEvent completo
(payload sin truncar).

9.10 CA-10: Detalle archive
===========================

**DADO** id en archive,
**ENTONCES** 200 (latencia mayor pero
funcional).

9.11 CA-11: Detalle no existe
=============================

**ENTONCES** 404.

9.12 CA-12: Aggregate
=====================

**DADO** group_by=event_type,
**ENTONCES** buckets con counts.

9.13 CA-13: Aggregate excede limite
===================================

**ENTONCES** 400 AGGREGATE_LIMIT_EXCEEDED.

9.14 CA-14: Export queued
=========================

**ENTONCES** 202 con job_id; job en estado
queued.

9.15 CA-15: Export complete notifica
====================================

**DADO** job done,
**ENTONCES** notification interna con
file_url firmado.

9.16 CA-16: Sin permiso 403
===========================

**DADO** caller sin view_audit_log,
**ENTONCES** 403 + UNAUTHORIZED audit
emitido.

9.17 CA-17: Meta-audit obligatorio
==================================

**DADO** consulta exitosa,
**ENTONCES** AUDIT_LOG_QUERIED emitido por
UC_PERM_09 con filtros sanitizados.

9.18 CA-18: Meta-audit fail bloquea
===================================

**DADO** UC_PERM_09 falla,
**ENTONCES** 503 — los datos NO se
retornan.

9.19 CA-19: Sin PII en respuesta
================================

**DADO** payload original con PII (no
debio existir, pero defensa),
**ENTONCES** sanitizado en truncate.

9.20 Resumen
============

.. list-table::
 :widths: 12 50 38
 :header-rows: 1

 * - ID
   - Concepto
   - Tipo
 * - CA-01..04
   - List + cursor
   - Funcional
 * - CA-05..08
   - Filtros
   - Funcional
 * - CA-09..11
   - Detalle
   - Funcional
 * - CA-12..13
   - Aggregate
   - Funcional
 * - CA-14..15
   - Export
   - Funcional
 * - CA-16
   - Sin permiso
   - Seguridad
 * - CA-17..18
   - Meta-audit
   - Compliance
 * - CA-19
   - Sin PII
   - Cumplimiento
