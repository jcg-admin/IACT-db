.. _uc-pip-02-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Sin errores → items=[].
FA-02: Filter por error_type.
FA-03: Drill por error individual.
FA-04: Group by error_type para
identificar root cause comun.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin errores
   - items=[]
   - mensaje
 * - FA-02
   - Filter
   - subset
   -
 * - FA-03
   - Drill
   - detalle
   -
 * - FA-04
   - Group
   - root cause
   -
