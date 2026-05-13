.. _uc-alr-02-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Sin alertas → items=[].
FA-02: Filtro severity → subset.
FA-03: Auto-refresh cada 10s
(Visibility API suspende en background).
FA-04: Push via stream (UC_RPT_02 pattern):
si servidor soporta SSE, push instead of
polling.
FA-05: Inline actions: ack desde la lista
invoca UC_ALR_03.

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Sin alertas
   - items=[]
   - mensaje
 * - FA-02
   - Filtro severity
   - subset
   -
 * - FA-03
   - Auto-refresh
   - 10s polling
   - Visibility API
 * - FA-04
   - SSE push
   - alternative
   - reuso P-61
 * - FA-05
   - Inline ack
   - delega UC_ALR_03
   - UX
