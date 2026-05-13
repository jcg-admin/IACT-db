.. _uc-perm-08-parte-05:

==========================
Parte 5 — Excepciones
==========================

5.1 EX-01: JWT invalido
=======================

401.

5.2 EX-02: User no existe
=========================

404 (caso defensivo: JWT valido pero User
borrado entre auth y request).

5.3 EX-03: BD timeout
=====================

503. NO mostrar menu vacio (parecera bug);
mostrar error explicito.

5.4 EX-04: FunctionRegistry corrupto
====================================

500. Telemetria + alerta.

5.5 EX-05: Locale invalido
==========================

Sin error: fallback a default. Solo logged.

5.6 EX-06: Throttling
=====================

429. Aplicado solo si rate >> normal
(refresh menu < 1/min tipico).

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
   - User no existe
   - 404
   - (sin audit)
 * - EX-03
   - BD timeout
   - 503
   - operacion FAILED
 * - EX-04
   - Registry corrupto
   - 500
   - alerta
 * - EX-05
   - Locale invalido
   - fallback
   - log only
 * - EX-06
   - Rate limit
   - 429
   - middleware
