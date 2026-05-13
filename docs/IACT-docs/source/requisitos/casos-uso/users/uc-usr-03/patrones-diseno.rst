.. _uc-usr-03-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 State Machine
--------------------

**Aplica a**: ``User.state`` con transiciones
permitidas codificadas como tabla. Cada
transicion conoce sus side-effects (ej.
``→ BLOCKED`` dispara cierre de Sessions).

::

   abstraccion StateTransitionTable:
     allowed: dict[(from_state, to_state)
                  -> Transition]

     class Transition:
       side_effects: list[SideEffectExecutor]
       audit_metadata: dict

10.1.2 Strategy
---------------

**Aplica a**: ``NotifyOnModifyStrategy`` —
politica de notificacion del User modificado.
Algunas configuraciones notifican siempre,
otras solo en cambios de state, otras nunca.

10.1.3 Observer
---------------

**Aplica a**: side-effects post-cambio.
``state → BLOCKED`` notifica a observadores
(SessionService cierra Sessions, AuditLog,
opcional InternalMailbox). Permite agregar
observadores futuros sin tocar UC_USR_03.

10.1.4 Command
--------------

**Aplica a**: el PATCH se modela como ``Modify
UserCommand`` con metadata (admin, target,
campos modificados, timestamp). Util para
posible undo (no aplicable aqui — los cambios
se preservan en historial via AuditEvent) o
queue de comandos batch en UCs futuros.

10.1.5 Chain of Responsibility
------------------------------

**Aplica a**: pipeline
authentication → permission(modify_users) →
throttle → request validator → state machine
validator → email uniqueness validator → view.

10.1.6 Template Method
----------------------

**Aplica a**: secuencia rigida del flujo
(validar → resolver → modificar → side-effect
→ audit). Sub-flujos (FA-01..06) sobreescriben
sub-pasos especificos.

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

PASOS 8-10 atomicos. Si cualquiera falla,
ROLLBACK. Preferimos no aplicar el cambio que
dejar el sistema con state inconsistente.

10.2.2 P-09 Audit-or-abort
--------------------------

EX-09 — sin AuditEvent, no se acepta el cambio.
CNST-025 obliga.

10.2.3 P-11 Anti-self-action
----------------------------

EX-04 — admin no puede cambiar su propio
state. Defensa contra escalada y lockout
accidental.

10.2.4 P-12 No-leak channel separation
--------------------------------------

InternalMessage al User es opcional (politica)
y NO contiene datos sensibles del cambio (no
se incluye lista de campos modificados al User
para evitar exposicion de quien modifico que).

10.2.5 P-21 State machine validada
----------------------------------

Tabla de transiciones permitidas explicita y
verificada en cada PATCH (no se permite
cualquier-a-cualquier). Defensa contra
estados inconsistentes.

10.2.6 P-22 PATCH semantica idempotente
---------------------------------------

PATCH parcial: solo se modifican campos
provistos. Mismo payload dos veces = mismo
estado. AuditEvent se emite igualmente
(registro de intencion).

10.3 Anti-patrones evitados
===========================

10.3.1 PUT en vez de PATCH
--------------------------

**No aplica**: PUT obliga a enviar todos los
campos. PATCH parcial reduce riesgo de
sobrescribir campos por error.

10.3.2 Transiciones de state libres
-----------------------------------

**No aplica**: tabla de transiciones permitidas
explicita. ``ELIMINATED → ACTIVE`` rechazado
incluso si la BD lo permitiera.

10.3.3 Auto-cambio de state por admin
-------------------------------------

**No aplica**: P-11. Defensa contra
desperfectos.

10.3.4 Cambio de username
-------------------------

**No aplica**: CNST-029 inmutable. El username
se genera una vez y no se cambia.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - State Machine
   - GoF
   - User.state transitions
 * - Strategy
   - GoF
   - NotifyOnModifyStrategy
 * - Observer
   - GoF
   - Side-effects (Sessions, Audit, Mailbox)
 * - Command
   - GoF
   - ModifyUserCommand
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Template Method
   - GoF
   - Flujo rigido
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-09
 * - P-11 Anti-self-action
   - IACT
   - EX-04
 * - P-12 No-leak channel
   - IACT
   - InternalMessage seguro
 * - P-21 State machine validada
   - IACT
   - Transiciones explicitas
 * - P-22 PATCH idempotente
   - IACT
   - Semantica RFC 5789
