.. _uc-usr-01-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Strategy
---------------

**Aplica a**: ``UsernameGenerator`` y
``PasswordGenerator``. Ambos son injectables,
permitiendo politicas alternativas (entropia
mayor, formato distinto).

::

   class UsernameGenerator(ABC):
       def generate(self, first, last) -> str: ...

   class StandardUsernameGenerator(UsernameGenerator):
       """nombre.apellido.NNNN per CNST-029."""

10.1.2 Factory Method
---------------------

**Aplica a**: ``UserFactory.create()`` encapsula
la construccion del User con todos sus
side-effects (Assignment, InternalMessage,
AuditEvent).

10.1.3 Template Method
----------------------

**Aplica a**: secuencia rigida del flujo
(validar → generar username → generar password
→ hashear → INSERT atomic). Sub-flujos (FA-01,
FA-02) sobrescriben pasos especificos.

10.1.4 Chain of Responsibility
------------------------------

**Aplica a**: pipeline DRF
authentication → permission(create_users)
→ throttle → serializer validation → view.

10.1.5 Observer
---------------

**Aplica a**: AuditEvent + UC_ALR_*

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

PASOS 10-13 atomicos. Si cualquiera falla,
ROLLBACK. NO se acepta User sin notificacion en
buzon (CNST-002).

10.2.2 P-09 Audit-or-abort
--------------------------

EX-07 — sin AuditEvent no se permite la
creacion (CNST-025).

10.2.3 P-10 Mailbox-or-abort
----------------------------

EX-06 — sin InternalMessage no se completa la
creacion. CNST-002 hace del buzon canal
obligatorio para entrega de credenciales.

10.2.4 P-12 No-leak channel separation
--------------------------------------

Las credenciales del nuevo User llegan
exclusivamente al InternalMailbox del NUEVO
USER. NUNCA en:

- Response al admin creador
- UI del admin
- Logs
- AuditEvent payload
- Stacktraces

10.2.5 P-17 Username autogenerado (CNST-029)
--------------------------------------------

El admin no elige el username — lo genera el
sistema deterministicamente. Esto:

- Evita squatting / dispute de identidad.
- Garantiza unicidad sistematica.
- Permite enumeracion controlada para audit
  (por sufijo creciente).

10.2.6 P-18 Force-first-login
-----------------------------

``first_login=true`` obliga UC_AUTH_04 al primer
login. Garantiza que el admin NUNCA conoce la
contrasena efectiva del User — solo la temporal,
que el User cambia inmediatamente.

10.3 Anti-patrones evitados
===========================

10.3.1 Self-service signup
--------------------------

**No aplica**: prohibido en IACT. CNST-001 no
permite verificar identidad por canales
externos.

10.3.2 Username elegible por usuario
------------------------------------

**No aplica**: CNST-029 — username
autogenerado, no editable.

10.3.3 Password elegible al crear
---------------------------------

**No aplica**: el sistema genera la temporal.
El admin NO conoce la contrasena, el User la
cambia en su primer login.

10.3.4 Mostrar contrasena al admin
----------------------------------

**No aplica**: P-12. El admin NUNCA ve la
contrasena.

10.3.5 Notificar credenciales por email
---------------------------------------

**No aplica**: CNST-001 lo prohibe. Solo
InternalMailbox.

10.4 Resumen
============

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Strategy
   - GoF
   - UsernameGen / PasswordGen
 * - Factory Method
   - GoF
   - UserFactory.create
 * - Template Method
   - GoF
   - Flujo rigido
 * - Chain of Responsibility
   - GoF
   - DRF middleware
 * - Observer
   - GoF
   - AuditEvent
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-07
 * - P-10 Mailbox-or-abort
   - IACT
   - EX-06
 * - P-12 No-leak
   - IACT
   - Defensa profundidad
 * - P-17 Username autogenerado
   - IACT
   - CNST-029
 * - P-18 Force-first-login
   - IACT
   - first_login=true → UC_AUTH_04
