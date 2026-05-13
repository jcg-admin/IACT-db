.. _uc-acc-01-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Specification
--------------------

**Aplica a**: cada ``SoDRule`` se modela como
una ``Specification`` evaluable contra un
conjunto de funciones. Permite componer
reglas:

::

   abstraccion SoDRule:
     is_violated_by(function_set) returns bool
     find_conflict(function_set) returns Pair?

   AND/OR para combinar reglas (raro en SoD,
   pero posible).

10.1.2 Strategy
---------------

**Aplica a**:

- ``IdempotencyPolicy`` para FA-01 (NOOP vs
  retornar 409 conflict en politica strict).
- ``ExpirationPolicy`` (default unbounded vs
  default 90-dias vs custom).
- ``NotifyOnAssignStrategy`` (notify yes/no).

10.1.3 Repository
-----------------

``AssignmentRepository``,
``FunctionRepository``,
``SoDRuleRepository`` abstraen el acceso a
datos. La capa de aplicacion no conoce la BD.

10.1.4 Chain of Responsibility
------------------------------

Pipeline:
authentication → permission(assign_functions)
→ throttle → request validator → user
existence → user state → function existence
→ SoD validator → persistence.

Cada etapa puede rechazar con excepcion
mapeada a status.

10.1.5 Observer
---------------

``AuditLog`` y consumidores externos
(UC_ALR_*) observan eventos
FUNCTIONS_ASSIGNED / FAILED.

10.1.6 Template Method
----------------------

Secuencia rigida del flujo. Sub-flujos (FA-01
NOOP, FA-02 con expires_at, FA-03 mix)
sobreescriben sub-pasos especificos.

10.1.7 Composite of Side-Effects
--------------------------------

La asignacion exitosa agrupa multiples efectos:

- INSERT N Assignments
- INSERT AuditEvent
- INSERT InternalMessage (opcional)
- Cache invalidate (post-COMMIT)

Cada efecto es injectable y puede extenderse
sin modificar el flujo.

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

PASOS 11-13 atomicos. Si alguno falla,
ROLLBACK total. **NUNCA** asignacion parcial
ante violacion SoD u otro error.

10.2.2 P-09 Audit-or-abort
--------------------------

EX-10 — sin AuditEvent, no se acepta la
asignacion (CNST-025).

10.2.3 P-11 Anti-self-action
----------------------------

EX-05 (configurable) — invocante no puede
auto-asignarse funciones. Defensa contra
escalada en cascada.

10.2.4 P-15 RBAC granular (funciones canonicas)
-----------------------------------------------

Funcion ``assign_functions`` distinta de
``revoke_functions`` (UC_ACC_02) y de
``configure_sod`` (UC_ACC_05). El UC se
deende de la funcion atomica, no de un AGR
(DEC-USR04-01).

10.2.5 P-22 Idempotencia parcial
--------------------------------

Re-asignacion de funcion ya activa es no-op.
Permite retries seguros (red intermitente,
doble click) sin duplicados.

10.2.6 P-27 SoD enforcement en write-time
-----------------------------------------

CNST-005: SoD se evalua en el momento de
asignar (no diferido / post-hoc). Una
violacion bloquea la operacion. Garantiza que
el sistema NUNCA esta en estado inconsistente
de SoD (asumiendo que UC_ACC_01 + UC_ACC_04
+ UC_PERM_03 son las unicas vias de
asignacion — todas validan SoD).

10.2.7 P-28 All-or-nothing en SoD violation
-------------------------------------------

Cuando un payload con N funciones genera SoD
violation, ninguna se asigna (rollback total).
Defensa contra "asignacion parcial silenciosa"
que dejaria al admin con falsa sensacion de
exito.

10.2.8 P-29 Cache invalidation post-COMMIT
------------------------------------------

La invalidacion del PermissionCache ocurre
DESPUES del COMMIT exitoso, no dentro de la
transaccion. Razon: si la transaccion falla,
el cache no debe haberse invalidado (se
entregaria stale-but-consistent vs
fresh-but-stale-with-rollback).

10.2.9 P-30 Notificacion al destino con info legible
----------------------------------------------------

InternalMessage al User destino expone nombres
legibles de funciones (display_name), no IDs
internos. Usabilidad sin filtrar
implementacion.

10.3 Anti-patrones evitados
===========================

10.3.1 Asignacion parcial silenciosa
------------------------------------

**No aplica**: P-28 all-or-nothing. Si alguna
funcion del payload viola SoD, NINGUNA se
asigna.

10.3.2 SoD diferido (post-hoc)
------------------------------

**No aplica**: CNST-005 + P-27 — SoD se valida
en write-time. Algunos sistemas validan SoD
solo en compliance reviews; IACT lo bloquea
en tiempo real.

10.3.3 Permitir AGR-006 como requisito
--------------------------------------

**No aplica**: DEC-USR04-01 — el UC depende
de la funcion ``assign_functions``, no del
AGR. Permite que una organizacion cree AGRs
custom con esa funcion.

10.3.4 Cache invalidation dentro de TX
--------------------------------------

**No aplica**: P-29. Si TX rollbackea, cache
queda stale (consistente con BD). Si la
invalidacion estuviera dentro, podria
dejarse inconsistente en escenarios de fallo.

10.3.5 expires_at sin upper bound
---------------------------------

**No aplica**: politica fuerza ≤ 1 anio para
forzar revisiones periodicas (compliance).

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Specification
   - GoF
   - SoDRule.is_violated_by
 * - Strategy
   - GoF
   - Idempotency / Expiration / Notify
 * - Repository
   - GoF
   - Assignment / Function / SoDRule
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Observer
   - GoF
   - AuditLog
 * - Template Method
   - GoF
   - Flujo + sub-flujos
 * - Composite Side-Effects
   - GoF
   - INSERT N + audit + cache + notify
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-10
 * - P-11 Anti-self-action
   - IACT
   - EX-05 (configurable)
 * - P-15 RBAC granular
   - IACT
   - assign_functions atomica
 * - P-22 Idempotencia parcial
   - IACT
   - FA-01, FA-03
 * - P-27 SoD write-time
   - IACT
   - CNST-005 enforcement
 * - P-28 All-or-nothing SoD
   - IACT
   - rollback total
 * - P-29 Cache post-COMMIT
   - IACT
   - PermissionCache.invalidate
 * - P-30 Notif legible
   - IACT
   - display_name en mailbox
