.. _uc-alr-03-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Alert ya acknowledged → 409 con
info de quien y cuando.
FA-02: Alert resolved → 409 ya cerrada.
FA-03: Bulk ack: POST /alerts/bulk-ack/
con lista de ids → ack todos los validos,
report failures.
FA-04: Re-firing despues de resolved: si
metric vuelve a violar, nueva Alert
record (NO se "reabre" la vieja).

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Ya ack
   - 409
   - idempotencia
 * - FA-02
   - Resolved
   - 409
   - estado
 * - FA-03
   - Bulk
   - bulk endpoint
   - convenience
 * - FA-04
   - Re-firing
   - nueva alert
   - history
