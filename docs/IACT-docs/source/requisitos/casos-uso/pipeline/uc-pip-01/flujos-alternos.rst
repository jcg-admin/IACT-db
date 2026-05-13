.. _uc-pip-01-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Pipeline sin runs recientes →
status=stale.
FA-02: Filter status — solo failed.
FA-03: Drill por pipeline →
UC_PIP_02 errores.
FA-04: SSE push en lugar de polling.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin runs
   - status=stale
   - alerta posible
 * - FA-02
   - Filter
   - subset
   -
 * - FA-03
   - Drill
   - UC_PIP_02
   - link
 * - FA-04
   - SSE
   - push
   - reuso P-61
