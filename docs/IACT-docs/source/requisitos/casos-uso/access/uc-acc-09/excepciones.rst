.. _uc-acc-09-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: Token invalido
=========================

401.

5.2 EX-02: Sin view_access_audit
================================

403 FORBIDDEN. AuditEvent
UNAUTHORIZED_ACCESS_ATTEMPT.

5.3 EX-03: Filtros invalidos
============================

400 BAD_FILTER (anti-SQLi P-20).

5.4 EX-04: Throttling
=====================

429. Limite alto: 200 GET/min/invoker.

5.5 EX-05: Evento no existe (vista detalle)
===========================================

404 EVENT_NOT_FOUND.

5.6 EX-06: Evento fuera de scope MOD_Access
===========================================

404 (404, no 403, para no filtrar info).

5.7 Resumen
===========

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
   - UNAUTHORIZED
 * - EX-03
   - Filtros invalidos
   - 400
   - (validation)
 * - EX-04
   - Rate limit
   - 429
   - middleware
 * - EX-05
   - Evento no existe
   - 404
   - (sin audit)
 * - EX-06
   - Fuera de scope ACC
   - 404
   - (sin audit)
