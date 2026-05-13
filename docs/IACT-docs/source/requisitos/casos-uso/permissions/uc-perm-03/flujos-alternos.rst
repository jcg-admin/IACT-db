.. _uc-perm-03-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01..FA-05: heredados UC_ACC_08
=====================================

Idempotencia, mix nuevas + activas, re-grant
post EXPIRED, ticket_reference,
revocacion explicita (UC separado).

4.2 FA-06 (PERM): preview pre-grant
===================================

**Activador**: GET preview-exceptional sin
persistir.

**Diferencia**: preview con composicion +
SoD impact + warnings.

4.3 FA-07 (PERM): vista catalogo funciones
==========================================

**Activador**: invoker entra desde catalogo
de funciones (no desde User).

**Diferencia**: UI orden inverso.
Backend identico.

4.4 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01..05
   - heredados UC_ACC_08
   - identicos
   - segun cada uno
 * - FA-06
   - preview pre-grant
   - GET sin persistir
   - 200
 * - FA-07
   - desde catalogo functions
   - UI inversa
   - 201
