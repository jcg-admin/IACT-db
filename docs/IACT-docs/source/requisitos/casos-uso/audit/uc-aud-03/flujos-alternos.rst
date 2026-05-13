.. _uc-aud-03-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: include_archive=true → query a
cold storage (latencia mayor pero ok
async).
FA-02: > 5M rows → 400.
FA-03: > 5 jobs simultaneos User → 429.
FA-04: Cancel job en queued.
FA-05: Status check.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Archive
   - cold query
   -
 * - FA-02
   - > 5M
   - 400
   -
 * - FA-03
   - > 5 jobs
   - 429
   -
 * - FA-04
   - Cancel
   - graceful
   -
 * - FA-05
   - Status
   - GET /export/{id}/
   -
