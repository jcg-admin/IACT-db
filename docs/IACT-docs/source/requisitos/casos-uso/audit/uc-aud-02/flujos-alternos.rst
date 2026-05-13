.. _uc-aud-02-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Query con caracteres especiales
escapados.
FA-02: Sin matches → items=[].
FA-03: Demasiados resultados → 1000 hits
maximo retornados; sugerir refinar query.
FA-04: Range > 90 dias → 400 + sugerir
export.

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01
   - Caracteres especiales
   - escape
   -
 * - FA-02
   - Sin match
   - items=[]
   -
 * - FA-03
   - > 1000 hits
   - cap + sugerencia
   -
 * - FA-04
   - > 90 dias
   - 400
   -
