.. _uc-aud-01-parte-04:

==========================
Parte 4 — Flujos alternos
==========================

FA-01: Filtro module — solo eventos del
modulo.
FA-02: Filtro multi-modulo.
FA-03: Range > 90 dias rechazado online;
sugerir UC_AUD_03 export con archive.
FA-04: Cursor invalido → 400.
FA-05: Sin eventos → items=[].

.. list-table::
 :widths: 12 38 30 20

 * - FA
   - Disparador
   - Comportamiento
   - Notas
 * - FA-01..02
   - Filtros
   - subset
   -
 * - FA-03
   - > 90 dias
   - 400 + sugerencia
   - export
 * - FA-04
   - Cursor
   - 400
   -
 * - FA-05
   - Sin eventos
   - items=[]
   - mensaje
