.. _uc-perm-06-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Solo agregar functions
=================================

**Activador**: payload con
``add_function_ids`` no vacio,
``remove_function_ids`` vacio.

**Diferencia**: PASO 13 NO ejecuta DELETE.

4.2 FA-02: Solo quitar functions
================================

**Activador**: payload con
``add_function_ids`` vacio,
``remove_function_ids`` no vacio.

**Diferencia**: PASO 12 NO ejecuta INSERT.

4.3 FA-03: Idempotencia parcial
===============================

**Activador**: subset de add ya presentes,
subset de remove ya ausentes.

**Diferencia**: PASO 9 filtra. Response
incluye:

- ``added``: nuevas insertadas.
- ``removed``: efectivamente quitadas.
- ``skipped_add``: ya presentes.
- ``skipped_remove``: no presentes.

4.4 FA-04: Cascade SoD violations (permissive)
==============================================

**Activador**: politica permissive +
violacion para algunos Users.

**Diferencia**: cambio procede; response
incluye ``cascade_violations`` lista.
AuditEvent con ``cascade_violations_count``.

4.5 FA-05: Sin cascade (AGR sin Users)
======================================

**Activador**: AGR no asignado a ningun User
ACTIVE.

**Diferencia**:
``cascade_affected_user_count = 0``. Cambio
sin impact directo.

4.6 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - Solo add
   - INSERT solo
   - 200
 * - FA-02
   - Solo remove
   - DELETE solo
   - 200
 * - FA-03
   - Idempotencia parcial
   - skipped lists
   - 200
 * - FA-04
   - Cascade violations permissive
   - cambio + lista violaciones
   - 200 con warning
 * - FA-05
   - AGR sin Users
   - cascade_count = 0
   - 200
