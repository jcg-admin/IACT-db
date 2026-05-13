.. _uc-rpt-10-parte-10:

==========================
Parte 10 — Patrones
==========================

10.1 Patrones aplicados
=======================

.. list-table::
 :widths: 18 32 50

 * - Patron
   - Nombre
   - Aplicacion
 * - **P-58**
   - Segment-bound
   -
 * - **P-68**
   - Ownership
   -
 * - **P-69**
   - Re-validate scope
   - heredado UC_RPT_09
 * - **P-70** (nuevo)
   - Catalog-decoupled view
   - vista referencia col_ids
     contra catalog externo

10.2 P-70: Catalog-decoupled view
=================================

**Problema**: si una vista hard-codea
columnas, deprecate de columnas requiere
migrar todas las vistas guardadas.

**Solucion**: vista referencia col_ids.
Catalog vive en codigo / config. Si
columna se remueve, vistas afectadas
muestran ``unavailable`` para esa col;
funcionalidad degradada pero no rompe.

10.3 Trazabilidad
=================

.. list-table::
 :widths: 30 70

 * - Origen
   - Implementado en
 * - P-58
   - PASO 3
 * - P-68
   - CRUD ownership
 * - P-69
   - validacion al apply
 * - P-70
   - FA-02, datos 7.2
