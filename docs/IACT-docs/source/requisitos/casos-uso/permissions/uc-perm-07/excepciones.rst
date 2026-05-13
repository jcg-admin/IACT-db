.. _uc-perm-07-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT invalido (admin)
===============================

401. Solo aplica al endpoint admin.

5.2 EX-02: Sin view_assignments (admin)
=======================================

403 + AuditEvent UNAUTHORIZED.

5.3 EX-03: User no existe
=========================

404 USER_NOT_FOUND.

5.4 EX-04: Funcion no existe
============================

400 FUNCTION_NOT_FOUND. NO retornar
``allowed=false`` silencioso — oculta typos.

5.5 EX-05: Parametros invalidos
===============================

400 VALIDATION_ERROR
(``user_id`` no numerico,
``function_code`` vacio o > 100 char).

5.6 EX-06: Cache stale (mitigado)
=================================

Si por algun motivo el cache devuelve un valor
contradictorio con BD (race rara), el caller
puede invocar ``check`` con flag
``bypass_cache=true``. Solo usado en
endpoints de re-confirmacion critica.

5.7 EX-07: BD timeout
=====================

503 SERVICE_UNAVAILABLE. Modo fail-closed:
si no podemos verificar, NO autorizamos.
P-08.

5.8 EX-08: Bulk excede limite
=============================

400 BULK_LIMIT_EXCEEDED si > 200 codes.

5.9 EX-09: Throttling abusive caller
====================================

Solo en endpoint admin. 429 si rate >
100 req/s por IP.

5.10 Resumen
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
   - Sin permiso admin
   - 403
   - UNAUTHORIZED
 * - EX-03
   - User no existe
   - 404
   - (sin audit)
 * - EX-04
   - Funcion no existe
   - 400
   - validation
 * - EX-05
   - Params invalidos
   - 400
   - validation
 * - EX-06
   - Cache stale
   - bypass flag
   - —
 * - EX-07
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-08
   - Bulk excede
   - 400
   - validation
 * - EX-09
   - Rate limit
   - 429
   - middleware
