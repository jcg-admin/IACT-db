.. _uc-alr-03-parte-05:

==========================
Parte 5 — Excepciones
==========================

EX-01: JWT — 401.
EX-02: Sin permiso — 403.
EX-03: Alert no existe — 404.
EX-04: Alert cross-segmento — 403.
EX-05: Alert ya ack / resolved — 409.
EX-06: Note > 500 char — 400.
EX-07: BD timeout — 503.
EX-08: Audit fail — 500.

Resumen
=======

.. list-table::
 :widths: 12 40 18 30
 :header-rows: 1

 * - ID
   - Condicion
   - Status
   - Audit
 * - EX-01..08
   - varios
   - 401/403/404/409/400/503/500
   - middleware/validation
