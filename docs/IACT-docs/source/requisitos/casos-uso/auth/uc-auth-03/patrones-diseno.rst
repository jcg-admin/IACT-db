.. _uc-auth-03-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Strategy
---------------

**Aplica a**: ``PasswordGenerator`` — la
estrategia de generacion (longitud, charset,
politicas de complejidad) es injectable.

::

   class PasswordGenerator(ABC):
       def generate(self, length: int) -> str: ...

   class StandardPasswordGenerator(PasswordGenerator): ...
   class HighEntropyPasswordGenerator(PasswordGenerator): ...

10.1.2 Command
--------------

**Aplica a**: el reset es un comando aislable
con metadata (admin, target, timestamp). Util
para implementar undo (no aplicable aqui — el
reset no es reversible) o queue de comandos
batch.

10.1.3 Observer
---------------

**Aplica a**: AuditEvent + UC_ALR_* observa
PASSWORD_RESET para alertas de seguridad.

10.1.4 Chain of Responsibility
------------------------------

**Aplica a**: pipeline DRF authentication →
permission (AGR-006) → throttle → view.

10.1.5 Template Method
----------------------

**Aplica a**: secuencia rigida de validaciones
(token → permiso → user → no-self → state)
seguida de la transaccion atomica.

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

**Aplica a**: pasos 10-13 todos en la
transaccion. Si CUALQUIERA falla, ROLLBACK
completo. Preferimos no resetear que dejar
estados parciales.

10.2.2 P-09 Audit-or-abort
--------------------------

**Aplica a**: EX-09 — sin AuditEvent no se
permite el cambio (CNST-025).

10.2.3 P-10 Mailbox-or-abort (CNST-002)
---------------------------------------

**Aplica a**: EX-07 — sin InternalMessage no se
completa el reset. CNST-002 hace del buzon un
canal obligatorio.

10.2.4 P-11 Anti-self-action
----------------------------

**Aplica a**: EX-04. Acciones administrativas
sobre cuentas privilegiadas requieren
separacion de funciones — un admin no puede
ejecutar sobre su propia cuenta operaciones
que cambian su estado de seguridad.

10.2.5 P-12 No-leak channel separation
--------------------------------------

**Aplica a**: la contrasena temporal se
entrega SOLO via InternalMailbox del User
afectado. NUNCA en:

- Response al admin
- UI del admin
- Logs
- AuditEvent payload
- Stacktraces

Defensa en profundidad: un admin comprometido
no obtiene la nueva contrasena del User
afectado por interceptar response/log.

10.3 Anti-patrones evitados
===========================

10.3.1 "Magic link" por email
-----------------------------

**No aplica**: prohibido por CNST-001. La
recuperacion de cuenta no transita por canales
externos.

10.3.2 Auto-reset
-----------------

**No aplica**: EX-04 hard. Defensa contra
escalada.

10.3.3 Mostrar contrasena al admin
----------------------------------

**No aplica**: el admin nunca ve la contrasena.
Esta es una decision deliberada — el admin no
necesita conocerla para que la operacion sea
exitosa.

10.3.4 "Olvide mi contrasena" self-service
------------------------------------------

**No aplica**: en IACT no existe self-service
de recuperacion. Solo admin via UC_AUTH_03.
Razon: CNST-001 prohibe email/SMS y sin canal
externo no hay forma segura de identificar al
usuario solicitante en self-service.

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
   - PasswordGenerator
 * - Command
   - GoF
   - Reset action object
 * - Observer
   - GoF
   - AuditEvent → consumers
 * - Chain of Responsibility
   - GoF
   - DRF middleware
 * - Template Method
   - GoF
   - Validacion → transaccion
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-09
 * - P-10 Mailbox-or-abort
   - IACT
   - EX-07
 * - P-11 Anti-self-action
   - IACT
   - EX-04
 * - P-12 No-leak channel sep
   - IACT
   - Solo InternalMailbox
