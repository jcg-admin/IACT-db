.. _uc-rpt-01-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT invalido
=======================

401.

5.2 EX-02: User sin segmento
============================

400 USER_WITHOUT_SEGMENT con mensaje
"Contacte administrador" (no hay datos
filtrables sin segmento).

5.3 EX-03: Sin view_reports
===========================

403 + UNAUTHORIZED audit.

5.4 EX-04: Periodo invalido
===========================

400 VALIDATION_ERROR.

5.5 EX-05: BD Analytics timeout
===============================

503. NO mostrar dashboard vacio (parecera
bug); banner explicito.

5.6 EX-06: Throttling
=====================

429.

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
   - JWT
   - 401
   - middleware
 * - EX-02
   - Sin segmento
   - 400
   - validation
 * - EX-03
   - Sin permiso
   - 403
   - UNAUTHORIZED
 * - EX-04
   - Periodo invalido
   - 400
   - validation
 * - EX-05
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-06
   - Rate limit
   - 429
   - middleware
