.. _uc-auth-02-parte-10:

=============================
Parte 10 — Patrones de diseno
=============================

10.1 Patrones GoF aplicables
============================

10.1.1 Strategy
---------------

**Aplica a**: estrategia de invalidacion de token
(blacklist DB vs blacklist en cache vs JWT
short-lived).

**Justificacion**: la implementacion concreta de
"invalidar token" depende del despliegue
(self-hosted MySQL vs Redis vs ambos). El UC no
prescribe — define la interfaz
``TokenInvalidator``.

::

   class TokenInvalidator(ABC):
       def invalidate(self, jti: str,
                      expires_at: datetime) -> None: ...

   class DBBlacklistStrategy(TokenInvalidator): ...
   class RedisBlacklistStrategy(TokenInvalidator): ...

10.1.2 Template Method
----------------------

**Aplica a**: el flujo principal sigue una
plantilla rigida (validar → localizar → cerrar →
blacklist → audit → respond) que es identica para
flujo principal y FAs; las FAs solo redefinen
pasos especificos.

::

   class LogoutFlow:
       def execute(self, request):
           self.validate_token(request)
           session = self.locate_session(request)
           self.close_session(session)        # FA-02 override
           self.blacklist_tokens(request)     # FA-01 override
           self.emit_audit(session)
           return self.build_response(session)

10.1.3 Observer
---------------

**Aplica a**: ``AuditEvent`` como observador del
cierre de Session. Multiples consumidores
(UC_AUD_01..04, UC_ALR_*) suscriben sin que
UC_AUTH_02 los conozca.

10.1.4 Chain of Responsibility
------------------------------

**Aplica a**: cadena de validacion DRF —
authentication classes → permission classes →
throttle classes → view. Cada eslabon decide
rechazar o pasar al siguiente.

10.2 Patrones THYROX/IACT especificos
=====================================

10.2.1 P-02 Idempotencia por estado terminal
--------------------------------------------

**Aplica a**: FA-02 — Session ya CLOSED es estado
terminal; reentrar a CLOSED es no-op excepto por
AuditEvent ``LOGOUT_REPLAY``.

10.2.2 P-03 Soft-delete via state field
---------------------------------------

**Aplica a**: BR-009 v2.0.0 — Session no se
elimina; transita ``state`` a CLOSED.
Trazabilidad preservada.

10.2.3 P-08 Fail-closed en transacciones criticas
-------------------------------------------------

**Aplica a**: si CUALQUIER paso de PASOS 6-8
falla, ROLLBACK completo. Preferimos dejar la
Session ACTIVE (que sera cerrada por timeout
CNST-005 eventualmente) que dejar tokens validos
contra Session ya CLOSED.

10.2.4 P-09 Audit-or-abort
--------------------------

**Aplica a**: si AuditEvent INSERT falla
(EX-06), abortar la operacion completa. CNST-025
no permite operacion sin auditoria.

10.3 Anti-patrones evitados
===========================

10.3.1 Logout silencioso
------------------------

**No aplica**: NO se permite "logout" que solo
limpia el frontend sin invalidar el token. El
backend SIEMPRE debe ser notificado para que
``Session.state`` sea consistente con el cliente.

10.3.2 Logout sin auditoria
---------------------------

**No aplica**: cada cierre se registra. CNST-025.

10.3.3 Hard-delete de Session
-----------------------------

**No aplica**: BR-009 v2.0.0 — soft-delete via
state.

10.4 Resumen de aplicacion
==========================

.. list-table::
 :widths: 25 20 55
 :header-rows: 1

 * - Patron
   - Categoria
   - Donde
 * - Strategy
   - GoF
   - Token invalidation
 * - Template Method
   - GoF
   - Flujo principal vs FAs
 * - Observer
   - GoF
   - AuditEvent → consumers
 * - Chain of Responsibility
   - GoF
   - DRF middleware pipeline
 * - P-02 Idempotencia
   - IACT
   - FA-02
 * - P-03 Soft-delete
   - IACT
   - state=CLOSED
 * - P-08 Fail-closed
   - IACT
   - Transaccion atomica
 * - P-09 Audit-or-abort
   - IACT
   - EX-06
