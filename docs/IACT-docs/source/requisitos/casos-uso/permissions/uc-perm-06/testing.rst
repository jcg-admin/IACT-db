.. _uc-perm-06-parte-12:

==================
Parte 12 — Testing
==================

12.1 Estrategia
===============

Cobertura por tipo:

- **Unit**: lógica pura — cascade SoD validator,
  filtrado idempotente, validacion predefinido.
- **Integration**: flujo completo contra repos
  reales (in-memory o test DB).
- **E2E**: HTTP contract — request → response.

Stack-agnostico: los tests describen
**comportamiento**, no framework.

12.2 Tests unitarios
====================

12.2.1 UT-01: Filtrado idempotente add
--------------------------------------

**DADO** current = [1,2,3], add = [2,4],

**CUANDO** se calcula to_add / skipped_add,

**ENTONCES** to_add = {4}, skipped_add = {2}.

12.2.2 UT-02: Filtrado idempotente remove
-----------------------------------------

**DADO** current = [1,2,3], remove = [2,5],

**ENTONCES** to_remove = {2}, skipped_remove
= {5}.

12.2.3 UT-03: AGR predefinido bloqueado
---------------------------------------

**DADO** agr.is_predefined == true,

**ENTONCES** PredefinedNotMutable raised.

12.2.4 UT-04: AGR RETIRED bloqueado
-----------------------------------

**DADO** agr.state == RETIRED,

**ENTONCES** AccessGroupRetired raised.

12.2.5 UT-05: Function inactiva bloqueada
-----------------------------------------

**DADO** function.state == INACTIVE,

**ENTONCES** FunctionInactive raised.

12.2.6 UT-06: Cascade SoD detecta violacion
-------------------------------------------

**DADO** User U con AGRs que con delta
crearia conflicto SoD,

**ENTONCES** validator retorna violacion
con violating_users = [U].

12.2.7 UT-07: Cascade SoD pasa cuando no hay conflicto
------------------------------------------------------

**DADO** delta no introduce conflicto,

**ENTONCES** ValidationResult.ok = true.

12.2.8 UT-08: Politica strict propaga
-------------------------------------

**DADO** cascade_policy = STRICT + violacion,

**ENTONCES** CascadeSoDViolation raised.

12.2.9 UT-09: Politica permissive continua
------------------------------------------

**DADO** cascade_policy = PERMISSIVE +
violacion,

**ENTONCES** flujo continua, violations
acumuladas.

12.2.10 UT-10: PayloadValidator rechaza reason vacia
----------------------------------------------------

**DADO** change_reason = "",

**ENTONCES** ValidationError raised.

12.2.11 UT-11: PayloadValidator rechaza ambos vacios
----------------------------------------------------

**DADO** add = [] AND remove = [],

**ENTONCES** ValidationError raised.

12.2.12 UT-12: Cache invalidate cascade
---------------------------------------

**DADO** users_with_agr = [U1, U2, U3],

**ENTONCES** PermissionCache.invalidate
llamado 3 veces post-COMMIT.

12.3 Tests de integracion
=========================

12.3.1 IT-01: Add exitoso
-------------------------

POST agr_id=42, add=[10,15],
reason="expandir".

**ENTONCES**:

- 200
- 2 rows en AccessGroupFunction
- AuditEvent COMPOSITION_CHANGED emitido

12.3.2 IT-02: Remove exitoso
----------------------------

POST agr_id=42, remove=[10].

**ENTONCES**:

- 200
- 1 row eliminada
- audit registra functions_removed

12.3.3 IT-03: Add + Remove combinado
------------------------------------

POST con ambos sets.

**ENTONCES**:

- ambos cambios aplicados
- response.added y response.removed
  correctos

12.3.4 IT-04: Idempotencia parcial
----------------------------------

AGR ya tiene function 10 + POST add=[10,15].

**ENTONCES**:

- only 15 inserted
- skipped_add incluye 10

12.3.5 IT-05: AGR predefinido 400
---------------------------------

POST sobre AGR-006.

**ENTONCES**: 400 PREDEFINED_NOT_MUTABLE.

12.3.6 IT-06: AGR RETIRED 400
-----------------------------

POST sobre AGR custom retirado.

**ENTONCES**: 400 ACCESS_GROUP_RETIRED.

12.3.7 IT-07: Function invalida 400
-----------------------------------

POST con function_id inexistente.

**ENTONCES**: 400 FUNCTION_NOT_FOUND.

12.3.8 IT-08: Cascade SoD strict bloquea
----------------------------------------

Setup: User U con AGR + delta crea SoD
violation. Politica strict.

**ENTONCES**:

- 409 CASCADE_SOD_VIOLATION
- violating_users sample en body
- audit event COMPOSITION_FAILED
- cero cambios en BD

12.3.9 IT-09: Cascade SoD permissive 200
----------------------------------------

Mismo setup, politica permissive.

**ENTONCES**:

- 200
- cambios aplicados
- audit cascade_violations_count > 0

12.3.10 IT-10: Cascade audit count
----------------------------------

AGR con 7 Users ACTIVE + cambio exitoso.

**ENTONCES**: audit.cascade_affected_user_count
== 7.

12.3.11 IT-11: Cache invalidate post-COMMIT
-------------------------------------------

Cambio exitoso con N Users.

**ENTONCES**:

- transaccion COMMIT
- PermissionCache.invalidate llamado N
  veces despues del COMMIT

12.3.12 IT-12: Sin permiso 403
------------------------------

Invoker sin
``manage_access_group_composition``.

**ENTONCES**: 403 + audit UNAUTHORIZED.

12.3.13 IT-13: Audit fail rollback
----------------------------------

Mock AuditLog.emit raise.

**ENTONCES**:

- 500
- AccessGroupFunction sin cambios

12.4 Tests E2E
==============

12.4.1 E2E-01: Composicion happy-path
-------------------------------------

Crear AGR custom (UC_PERM_05) → asignar
funciones (UC_PERM_06) → verificar via
GET catalogo.

**ENTONCES**: AGR aparece con composicion
correcta.

12.4.2 E2E-02: Cascade visible en User
--------------------------------------

User U con AGR custom → admin cambia
composicion → User permission check
incluye nuevas functions.

**ENTONCES**: effective_set actualizado.

12.4.3 E2E-03: Cascade SoD bloqueado
------------------------------------

User U con AGR_A (sensible) + admin agrega
function que crea SoD con AGR_B.

**ENTONCES**: 409, ningun cambio.

12.4.4 E2E-04: Permissive con audit trail
-----------------------------------------

Politica permissive + violacion + 200 →
auditor consulta logs.

**ENTONCES**: registro completo de
violations para revision posterior.

12.5 Mapeo CA → Tests
=====================

.. list-table::
 :widths: 15 25 60
 :header-rows: 1

 * - CA
   - Concepto
   - Tests
 * - CA-01
   - Add exitoso
   - IT-01, E2E-01
 * - CA-02
   - Remove exitoso
   - IT-02
 * - CA-03
   - Add + Remove
   - IT-03
 * - CA-04
   - Idempotencia parcial
   - UT-01, UT-02, IT-04
 * - CA-05
   - AGR no existe
   - IT (404 path)
 * - CA-06
   - Predefinido bloqueado
   - UT-03, IT-05
 * - CA-07
   - RETIRED bloqueado
   - UT-04, IT-06
 * - CA-08
   - Function invalida
   - UT-05, IT-07
 * - CA-09
   - reason obligatoria
   - UT-10, UT-11
 * - CA-10
   - Cascade SoD strict
   - UT-06, UT-08, IT-08, E2E-03
 * - CA-11
   - Cascade SoD permissive
   - UT-09, IT-09, E2E-04
 * - CA-12
   - Cascade audit count
   - IT-10
 * - CA-13
   - Sin permiso
   - IT-12
 * - CA-14
   - Cache cascade
   - UT-12, IT-11
 * - CA-15
   - Atomicidad
   - IT-13

12.6 Cobertura
==============

- 12 unit tests
- 13 integration tests
- 4 E2E tests
- 100% de los 15 CAs cubiertos
- Cascade SoD cubierto en 3 niveles
  (UT, IT, E2E)
