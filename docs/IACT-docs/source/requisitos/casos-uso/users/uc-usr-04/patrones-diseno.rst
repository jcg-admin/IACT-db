.. _uc-usr-04-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 State Machine
--------------------

**Aplica a**: ``User.state`` con transiciones
permitidas. UC_USR_04 implementa las
transiciones ``{ACTIVE, INACTIVE, BLOCKED} →
ELIMINATED``. ``ELIMINATED`` es estado terminal
(no hay transicion saliente en este UC; un WP
futuro podria definir ``RestoreUser`` como UC
separado).

10.1.2 Composite (Composite of Side-Effects)
--------------------------------------------

**Aplica a**: la transicion ``→ ELIMINATED``
agrupa multiples side-effects que deben
ejecutarse atomicamente:

- revoke Assignments
- close Sessions
- blacklist tokens
- (opcional) notify mailbox
- audit

Cada side-effect es injectable y la lista
puede extenderse sin tocar el flujo principal.

10.1.3 Strategy
---------------

**Aplica a**:

- ``IdempotencyPolicy`` (default vs strict)
  para FA-02.
- ``NotifyOnEliminationStrategy`` (notify
  yes/no).
- ``MailboxFailurePolicy`` (abort vs
  continue-with-flag).

10.1.4 Command
--------------

**Aplica a**: la operacion se modela como
``EliminateUserCommand`` con metadata
(invoker, target, timestamp, reason). Util
para historico, posible undo via
``RestoreUser`` futuro.

10.1.5 Chain of Responsibility
------------------------------

**Aplica a**: pipeline
authentication → permission(deactivate_users) →
throttle → input validator → (no body) → view.

10.1.6 Observer
---------------

**Aplica a**: AuditLog observa la eliminacion;
otros consumidores futuros (alertas masivas,
metricas operacionales) pueden suscribirse sin
tocar el UC.

10.1.7 Template Method
----------------------

**Aplica a**: secuencia rigida del flujo
(validar → resolver → evaluar P-11 →
transaccion atomica → response). Sub-flujos
(FA-02, FA-03, FA-05) sobreescriben sub-pasos
especificos.

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

PASOS 9-14 atomicos. Si cualquier paso falla,
ROLLBACK total. NO se acepta User parcialmente
eliminado.

10.2.2 P-09 Audit-or-abort
--------------------------

EX-07 — sin AuditEvent, no se acepta la
eliminacion.

10.2.3 P-11 Anti-self-action
----------------------------

EX-04 — invocante no puede eliminarse a si
mismo. Defensa fundamental contra
escalada/lockout.

10.2.4 P-23 Soft-delete obligatorio (BR-009)
--------------------------------------------

**Aplica a**: NO hay DELETE fisico. La
"eliminacion" es UPDATE de state. Datos
historicos preservados.

10.2.5 P-24 Identidad reservada post-eliminacion
------------------------------------------------

**Aplica a**: ``email``, ``username`` del User
ELIMINATED NO quedan libres para reutilizacion.
Defensa anti-impersonacion.

10.2.6 P-25 Idempotencia configurable
-------------------------------------

**Aplica a**: doble eliminacion acepta dos
politicas (default idempotente con
USER_ELIMINATE_NOOP, strict con 409). Opcional
segun politica organizacional.

10.2.7 P-26 Mailbox-or-abort softer
-----------------------------------

**Aplica a**: a diferencia de UC_USR_01 y
UC_AUTH_03 donde el mailbox es **canal unico**
para entregar credenciales, en UC_USR_04 el
mailbox es **notificacion informativa**. La
eliminacion procede aun si el mailbox falla;
AuditEvent registra ``mailbox_failed=true``.

10.3 Anti-patrones evitados
===========================

10.3.1 DELETE fisico
--------------------

**No aplica**: BR-009 prohibe. ``DELETE FROM
users WHERE id=?`` jamas se ejecuta. Solo
UPDATE de state.

10.3.2 Auto-eliminacion permitida
---------------------------------

**No aplica**: P-11 hard. Cualquier admin que
quiera eliminarse debe pedirlo a otro.

10.3.3 Liberar email post-eliminacion
-------------------------------------

**No aplica**: P-24. Defensa
anti-impersonacion (un atacante podria
registrar el email "liberado" y reclamar la
identidad).

10.3.4 Mailbox-or-abort hard (como UC_USR_01)
---------------------------------------------

**No aplica**: en UC_USR_04 la notificacion no
contiene secretos. La operacion debe
completarse aun sin notificacion.

10.3.5 Confirmacion solo con un click
-------------------------------------

**No aplica**: doble confirmacion obligatoria
(modal + escribir "ELIMINAR" literal). La
operacion es destructiva.

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
   - User.state → ELIMINATED terminal
 * - Composite side-effects
   - GoF
   - revoke + close + blacklist + audit
 * - Strategy
   - GoF
   - Idempotency + Notify + MailboxFailure
 * - Command
   - GoF
   - EliminateUserCommand
 * - Chain of Responsibility
   - GoF
   - Pipeline middleware
 * - Observer
   - GoF
   - AuditLog
 * - Template Method
   - GoF
   - Flujo rigido + sub-flujos
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-07
 * - P-11 Anti-self-action
   - IACT
   - EX-04
 * - P-23 Soft-delete
   - IACT
   - BR-009
 * - P-24 Identidad reservada
   - IACT
   - email/username preservados
 * - P-25 Idempotencia config
   - IACT
   - default vs strict
 * - P-26 Mailbox-or-abort softer
   - IACT
   - notify falla no aborta
