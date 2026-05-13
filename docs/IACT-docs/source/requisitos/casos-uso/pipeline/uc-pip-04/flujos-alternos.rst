.. _uc-pip-04-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Pipeline ya running → 409
ALREADY_RUNNING.
FA-02: Pipeline ultimo run = success
(no failed para retry) → 409 con
warning "ningun fallo a reintentar".
Permitir override con flag force=true.
FA-03: Run_id especifico ya re-encolado
una vez → 409 (evita doble retry).
FA-04: Priority=high → encola al frente
(con audit del privilegio).

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Already running
   - 409
   -
 * - FA-02
   - Ultimo success
   - 409 + force opt
   -
 * - FA-03
   - Doble retry
   - 409
   - idempotencia
 * - FA-04
   - High priority
   - front queue
   - audit
