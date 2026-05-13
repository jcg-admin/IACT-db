.. _uc-auth-01-parte-10:

========================================
Parte 10 — Patrones de diseno aplicables
========================================

Patrones de diseno (GoF / arquitectonicos / DDD)
identificados como aplicables a UC_AUTH_01.
Importados de
:doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
§ 6.1-6.2 con aterrizaje al UC.

10.1 Patrones GoF
=================

10.1.1 Strategy — proveedor de autenticacion
--------------------------------------------

**Problema**: en el futuro, IACT podria soportar
multiples mecanismos de autenticacion (LDAP
corporativo, SSO con identity provider externo,
2FA), no solo username + password local.

**Solucion**: definir interfaz
``AuthenticationStrategy`` con metodo
``authenticate(credentials) -> User | None``.
Implementaciones concretas:

- ``LocalPasswordStrategy`` — la actual,
  bcrypt sobre ``User.password_hash``.
- ``LDAPStrategy`` — futura.
- ``SSOStrategy`` — futura.

El ``LoginView`` de Django delega al strategy
configurado, sin conocer detalles.

**Beneficio**: agregar nuevos mecanismos sin
modificar el flujo del UC; cada strategy es
testeable en aislamiento.

**Aplicacion v1.0**: solo ``LocalPasswordStrategy``
implementada; el patron prepara la extensibilidad.

10.1.2 Decorator — throttling
-----------------------------

**Problema**: CNST-011 exige throttling en
endpoints publicos. Repetir la verificacion en
cada vista produce duplicacion.

**Solucion**: decorador
``@throttle_classes([AnonRateThrottle,
UserRateThrottle])`` de DRF aplicado al
``LoginView``.

**Beneficio**: la logica de throttling vive en
una sola clase; cualquier cambio en la politica
no toca el flujo del UC.

10.1.3 Chain of Responsibility — validaciones
---------------------------------------------

**Problema**: el UC tiene multiples
validaciones secuenciales (formato, throttling,
existencia, state, password). Si una falla, las
siguientes no deben ejecutarse y la respuesta
debe ser especifica.

**Solucion**: cadena de handlers, cada uno
responsable de una validacion. Si pasa, llama al
siguiente; si falla, retorna su error
especifico.

::

   FormatHandler -> ThrottleHandler ->
   UserExistsHandler -> StateHandler ->
   PasswordHandler -> SuccessHandler

**Beneficio**: agregar validaciones nuevas
(e.g. captcha) es agregar un handler; el orden
es declarativo.

**Aplicacion v1.0**: implementado de forma
implicita en el flujo de la View. Refactor a
chain explicito es mejora futura no requerida
para v1.0.

10.1.4 Observer — emision de AuditEvent
---------------------------------------

**Problema**: T-03 (transversal del sistema)
exige que toda escritura emita AuditEvent. Si
el codigo del UC tiene calls explicitas
``audit_log.write(...)``, hay duplicacion y
riesgo de olvido.

**Solucion**: middleware "audit emitter" como
observer suscrito a los metodos de escritura
del servicio. Cada metodo declara su EventType
via decorador
``@audits('LOGIN')``.

**Beneficio**: separacion limpia entre logica
de negocio y emision de auditoria. El UC
"ignora" la auditoria; el middleware se
encarga.

**Aplicacion v1.0**: idem 10.1.3; aplicacion
explicita en flujo (no via middleware todavia)
es aceptable para v1.0.

10.1.5 Template Method — estructura del flujo de auth
-----------------------------------------------------

**Problema**: UC_AUTH_01 (login) y UC_AUTH_02
(logout) y UC_AUTH_05 (admin close session)
comparten estructura: validar input → buscar
entidad → operar → audit → respuesta.

**Solucion**: clase abstracta
``AuthFlowTemplate`` con metodos hook
sobrescritos por cada UC.

**Beneficio**: estructura consistente; menos
duplicacion entre UCs del cluster AUTH.

**Aplicacion v1.0**: futuro. v1.0 implementa
cada UC independientemente; refactor a
template es WP de unificacion posterior.

10.2 Patrones cross-cutting IACT-especificos
============================================

Patrones del proyecto (no GoF) identificados en
la matriz de dependencias § 6.2 que aplican a
UC_AUTH_01:

10.2.1 P-02 Audit Emitter (T-03)
--------------------------------

Materializa la transversal T-03 (emision de
AuditEvent en cada escritura). Aplicado al
UC_AUTH_01 emite ``LOGIN``, ``LOGIN_FAILED``,
``LOGIN_BLOCKED``, ``LOGIN_INACTIVE``,
``LOGIN_THROTTLED``, ``SESSION_CLOSED`` segun
el camino del flujo.

10.2.2 P-03 BR-009 Soft Delete
------------------------------

Aplicado a la clase ``Session``: state pasa de
ACTIVE → CLOSED (no se elimina) con
``close_reason``. Tambien aplicado a ``User``:
state INACTIVE en lugar de DELETE.

10.2.3 P-08 Internal Mailbox Delivery
-------------------------------------

Aplicado en FA-03 cuando se cierra una Session
anterior: el mensaje al usuario en otro
dispositivo se entrega via ``InternalMailbox``
(CNST-002), no email externo (CNST-001).

10.2.4 P-09 Sesion unica (nuevo, especifico de UC_AUTH_01)
----------------------------------------------------------

**Problema**: CNST-004 sesion unica obliga a
que solo una Session activa exista por User.

**Solucion**: en el flujo principal, antes de
crear la Session nueva, hacer UPDATE en bloque
de las Sessions activas previas a state CLOSED
con ``close_reason='SUPERSEDED'``.

**Beneficio**: enforcement automatico del
constraint sin necesidad de validacion explicita
post-hoc.

**Aplicacion**: solo UC_AUTH_01 (los demas UCs
de AUTH no crean Sessions — UC_AUTH_02 cierra,
UC_AUTH_05 lista/cierra-admin, etc.).

10.3 Patrones NO aplicables (decisiones
explicitas)
========================================

Patrones que el ejemplo del ejecutor lista pero
que **no aplican** a UC_AUTH_01:

- **Saga**: el flujo de UC_AUTH_01 es
  transaccional ACID en BD local, no
  distribuido. Saga aplicaria si el UC tuviera
  llamadas a servicios externos con
  compensacion (no es el caso aqui).
- **Factory**: la creacion de ``Session`` y
  ``AuditEvent`` es directa via ORM. Factory
  agregaria complejidad sin beneficio.
- **Memento**: no hay snapshots de estado
  reversibles aqui.

10.4 Resumen de patrones aplicables
===================================

.. list-table::
 :widths: 30 14 56
 :header-rows: 1

 * - Patron
   - Aplicado v1.0
   - Funcion en UC_AUTH_01
 * - Strategy
   - SI (1 strategy)
   - Authentication provider (extensible)
 * - Decorator
   - SI
   - Throttling CNST-011 via
     ``@throttle_classes``
 * - Chain of Responsibility
   - implicito
   - Validaciones secuenciales (paso 5..9)
 * - Observer (Audit Emitter)
   - implicito
   - Emision de AuditEvent (T-03)
 * - Template Method
   - NO v1.0
   - Estructura comun de UCs Auth (futuro)
 * - State (Session lifecycle)
   - SI
   - state ACTIVE/CLOSED/EXPIRED de Session
 * - P-03 BR-009 Soft Delete
   - SI
   - state en lugar de DELETE
 * - P-08 Internal Mailbox Delivery
   - SI (FA-03)
   - Notificacion via InternalMailbox
 * - P-09 Sesion unica
   - SI
   - UPDATE en bloque previo a INSERT (CNST-004)
