.. _uc-auth-04-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Strategy
---------------

**Aplica a**: ``PasswordPolicyValidator`` y
``PasswordHistoryChecker``. La politica concreta
(longitud, charset, N=5) es injectable.

::

   class PasswordPolicy(ABC):
       def validate(self, password, user) -> list[str]: ...

   class StandardPasswordPolicy(PasswordPolicy): ...
   class StrictPasswordPolicy(PasswordPolicy): ...

10.1.2 Specification
--------------------

**Aplica a**: cada regla de complejidad
(longitud, mayuscula, etc.) es una
``Specification`` componible.

::

   class MinLengthSpec(Specification):
       def is_satisfied_by(self, password): ...

   policy = MinLengthSpec(12) & UpperCaseSpec() & DigitSpec()

10.1.3 Chain of Responsibility
------------------------------

**Aplica a**: pipeline de validaciones
(JWT → user → current_password → policy →
history) — cada etapa puede rechazar.

10.1.4 Template Method
----------------------

**Aplica a**: secuencia rigida del flujo;
PASOS 10-13 transaccion.

10.1.5 Observer
---------------

**Aplica a**: AuditEvent + UC_ALR_*

10.2 Patrones IACT especificos
==============================

10.2.1 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

PASOS 10-13 atomicos. Si cualquiera falla,
ROLLBACK; el User permanece con la contrasena
anterior (consistente).

10.2.2 P-09 Audit-or-abort
--------------------------

EX-09 — sin AuditEvent no se permite el cambio.

10.2.3 P-12 No-leak
-------------------

Las contrasenas no aparecen en logs, response,
audit, stacktrace. Filtros de logging adicionales
para defensa en profundidad.

10.2.4 P-13 Anti-bruteforce con backoff
---------------------------------------

EX-08 implementa lockout 5min tras 5 fallos.
Mitigacion contra ataques contra password actual
(p.ej. token robado pero password no conocida).

10.2.5 P-14 Constant-time + delay aleatorio
-------------------------------------------

bcrypt.checkpw es constant-time por diseno; el
delay aleatorio adicional 100-200ms evita
inferir validez de current_password por timing.

10.3 Anti-patrones evitados
===========================

10.3.1 Cambio sin password actual
---------------------------------

**No aplica**: para evitar que un attacker con
JWT robado cambie la contrasena, requerimos
demostrar conocimiento de la actual.

10.3.2 Self-service "olvide mi contrasena"
------------------------------------------

**No aplica**: prohibido por CNST-001
(no email/SMS).

10.3.3 Almacenar contrasena en plain
------------------------------------

**No aplica**: bcrypt cost 12 obligatorio. Solo
se almacenan hashes.

10.3.4 Listar la politica completa al frontend
----------------------------------------------

**No aplica**: el form solo muestra hints
generales ("12 caracteres minimo, mixto"). La
lista de violaciones EX-03 es post-validacion
backend (no le da pista al attacker en
form-time).

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
   - PasswordPolicy
 * - Specification
   - GoF
   - Reglas componibles
 * - Chain of Responsibility
   - GoF
   - Pipeline de validaciones
 * - Template Method
   - GoF
   - Flujo
 * - Observer
   - GoF
   - AuditEvent
 * - P-08 Fail-closed
   - IACT
   - Transaccion
 * - P-09 Audit-or-abort
   - IACT
   - EX-09
 * - P-12 No-leak
   - IACT
   - Defensa en profundidad
 * - P-13 Anti-bruteforce
   - IACT
   - EX-08
 * - P-14 Constant-time + delay
   - IACT
   - PASO 7
