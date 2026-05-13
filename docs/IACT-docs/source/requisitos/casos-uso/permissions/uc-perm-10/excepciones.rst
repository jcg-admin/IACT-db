.. _uc-perm-10-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT invalido
=======================

401.

5.2 EX-02: Sin view_audit_log
=============================

403 + AuditEvent UNAUTHORIZED.

5.3 EX-03: Filtros invalidos
============================

400 VALIDATION_ERROR. Mensajes especificos:

- date range invertido
- date range > 90 dias sin archive flag
- page_size > 200
- event_type desconocido
- IP no parseable

5.4 EX-04: Cursor invalido
==========================

400 CURSOR_INVALID.

5.5 EX-05: ID no existe (detalle)
=================================

404 AUDIT_EVENT_NOT_FOUND.

5.6 EX-06: Aggregate excede limite
==================================

400 AGGREGATE_LIMIT_EXCEEDED si > 100K
rows estimadas sin filtros.

5.7 EX-07: BD timeout
=====================

503.

5.8 EX-08: Throttling
=====================

429.

5.9 EX-09: Export queue full
============================

503 EXPORT_QUEUE_FULL si export tiene
backlog. Caller debe reintentar mas tarde.

5.10 EX-10: Audit emit fail
===========================

UC_PERM_09 falla en meta-audit. Por P-09
audit-or-abort (en este caso para read), el
endpoint NO retorna datos — devuelve 503
con mensaje "audit logging unavailable".

Razón: si no podemos auditar quien consulto
audit, la consulta NO procede.

5.11 Resumen
============

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - AuditEvent
 * - EX-01
   - JWT
   - 401
   - middleware
 * - EX-02
   - Sin permiso
   - 403
   - UNAUTHORIZED
 * - EX-03
   - Filtros
   - 400
   - validation
 * - EX-04
   - Cursor
   - 400
   - validation
 * - EX-05
   - ID no existe
   - 404
   - (sin audit)
 * - EX-06
   - Aggregate limite
   - 400
   - validation
 * - EX-07
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-08
   - Rate limit
   - 429
   - middleware
 * - EX-09
   - Export queue full
   - 503
   - operacion FAILED
 * - EX-10
   - Meta-audit fail
   - 503
   - (audit unavailable)
