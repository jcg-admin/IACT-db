.. _uc-perm-05-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

4.1 FA-01: Crear con composicion inicial
========================================

**Activador**: payload incluye
``initial_function_ids: [...]``.

**Diferencia**: tras crear el AGR,
internamente delega a UC_PERM_06 para
asignar las funciones iniciales (mismo
backend, atomico).

4.2 FA-02: Retirar AGR con Users asignados
==========================================

**Activador**: PASO 5 — count > 0.

**Diferencia**: politica configurable:

- Default warn-only: response incluye
  warning con count y sample de
  ``users_with_agr_sample``.
- Strict block: setting
  ``BLOCK_RETIRE_WITH_USERS=true`` →
  EX-XX 409.

4.3 FA-03: Modificar predefinido bloqueado
==========================================

**Activador**: PATCH/DELETE sobre AGR
predefinido.

**Diferencia**: EX-XX 400
PREDEFINED_NOT_MUTABLE.

4.4 FA-04: Code colision
========================

**Activador**: code provisto ya existe en
catalogo.

**Diferencia**: EX-XX 409
CODE_DUPLICATE.

4.5 Resumen
===========

.. list-table::
 :widths: 12 35 35 18
 :header-rows: 1

 * - ID
   - Activador
   - Diferencia
   - Status
 * - FA-01
   - Crear con composicion
   - delega UC_PERM_06 atomico
   - 201
 * - FA-02
   - Retirar con Users
   - warn / block segun politica
   - 200 / 409
 * - FA-03
   - Modificar predefinido
   - PREDEFINED_NOT_MUTABLE
   - 400
 * - FA-04
   - Code colision
   - CODE_DUPLICATE
   - 409
