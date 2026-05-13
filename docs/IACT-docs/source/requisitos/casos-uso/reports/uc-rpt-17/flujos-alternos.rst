.. _uc-rpt-17-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Volumen alto → HyperLogLog
=================================

Para periodos largos / alto volumen,
COUNT(DISTINCT) puede ser caro. Usar
estimacion via HLL (precision ~1%).
Indicar en response ``count_method: hll``.

FA-02: Sin clientes → 0
=======================

distinct_clients_count = 0; demas en
null o 0.

FA-03: Comparativo prior
========================

new_vs_returning calculado contra periodo
inmediatamente anterior (P-63).

FA-04: Top N
============

Solo client_hash_prefix (8 char) — no full
hash, no PII reidentificable.

Resumen
=======

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Alto volumen
   - HLL
   - precision
 * - FA-02
   - Sin clientes
   - 0
   - mensaje
 * - FA-03
   - Comparativo
   - prior auto
   - P-63
 * - FA-04
   - Top N
   - prefix hash
   - sin PII
