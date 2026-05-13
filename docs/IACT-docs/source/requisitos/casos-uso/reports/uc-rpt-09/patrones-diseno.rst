.. _uc-rpt-09-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50
 :header-rows: 1

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-58**
   - Segment-bound
   - filtros validados al
     write Y al apply
 * - **P-68**
   - Ownership-by-default
   - solo propios
 * - **P-69** (nuevo)
   - Re-validate saved scope
   - filtro invalid si segmentos
     cambian, no se silencian

10.2 P-69: Re-validate saved scope
==================================

**Problema**: filtro guardado puede tener
referencia a segmento / campana que el
User ya no tiene autorizado. Aplicarlo
silenciosamente da resultados sin contexto
o, peor, errores inexplicables.

**Solucion**:

- Al detectar cambio de segmentos del User
  (evento), marcar filtros afectados como
  ``is_invalid=true``.
- UI muestra badge "invalido" + razon.
- Aplicarlo da error con mensaje claro.

10.3 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-58
   - PASO 3, FA-02
 * - P-68
   - CA-07
 * - P-69
   - FA-03, CA-10
