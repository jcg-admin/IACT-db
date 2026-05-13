.. _uc-auth-01-parte-07:

==================================
Parte 7 — Datos involucrados
==================================

Detalle de la entrada (request), salida
(response), datos persistidos en BD y errores
estructurados. Toda la representacion de
datos se atiene a la convencion del proyecto:
identificadores en ingles (snake_case), prosa y
labels en espanol.

7.1 Endpoint y request
======================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Metodo**
   - POST
 * - **URL**
   - ``/api/auth/login/``
 * - **Protocolo**
   - HTTPS obligatorio (TLS 1.2+)
 * - **Content-Type**
   - ``application/json``
 * - **Authentication**
   - ninguna (endpoint publico)
 * - **Throttling**
   - CNST-011

Headers esperados:

::

   Content-Type: application/json
   Accept: application/json
   X-Forwarded-For: <ip-real-cliente>     (si tras proxy)
   User-Agent: <browser-info>              (informativo)

Body (JSON):

::

   {
     "username": "string (3-50 chars)",
     "password": "string (8-128 chars)",
     "client_info": {                       (opcional)
       "device": "string",
       "platform": "string"
     }
   }

7.2 Response — exito (200 OK)
=============================

::

   {
     "tokens": {
       "access": "<JWT>",
       "refresh": "<JWT>",
       "access_expires_at": "2026-05-01T07:45:00Z",
       "refresh_expires_at": "2026-05-08T07:30:00Z"
     },
     "user": {
       "user_id": "<uuid>",
       "username": "string",
       "full_name": "string",
       "primary_access_group_id": "AGR-NNN",
       "access_groups": ["AGR-NNN", ...],
       "first_login": false
     },
     "session": {
       "session_id": "<uuid>",
       "started_at": "2026-05-01T07:30:00Z",
       "expires_at": "2026-05-01T07:45:00Z"
     },
     "next_step": null,                     // o "change_password" en FA-01/FA-02
     "warning": null,                       // o estructura de aviso en FA-02/FA-04
     "request_id": "<uuid>",
     "timestamp": "2026-05-01T07:30:00Z"
   }

Notas:

- ``access_expires_at`` refleja CNST-005
  (timeout de sesion 15 min).
- ``access_groups`` es la lista de AGR del
  usuario; el frontend la usa para decidir el
  landing.
- ``next_step`` es ``null`` en flujo principal;
  ``"change_password"`` en FA-01 o FA-02 cuando
  el usuario opte por cambiar.

7.3 Response — error (4xx / 5xx)
================================

Estructura unificada per CNST-013:

::

   {
     "error": {
       "code": "<error_code>",
       "message": "<mensaje en espanol>",
       "fields": {                            // solo en VALIDATION_ERROR
         "username": ["..."],
         "password": ["..."]
       },
       "retry_after": <seconds>               // solo en RATE_LIMITED y DB_TRANSIENT_ERROR
     },
     "request_id": "<uuid>",
     "timestamp": "2026-05-01T07:30:00Z"
   }

Catalogo de error codes (referencia a Parte 5):

.. list-table::
 :widths: 30 14 56
 :header-rows: 1

 * - error_code
   - HTTP
   - Causa (excepcion)
 * - ``INVALID_CREDENTIALS``
   - 401
   - EX-01 / EX-02
 * - ``ACCOUNT_BLOCKED``
   - 403
   - EX-03
 * - ``ACCOUNT_INACTIVE``
   - 403
   - EX-04
 * - ``RATE_LIMITED``
   - 429
   - EX-05
 * - ``VALIDATION_ERROR``
   - 400
   - EX-06
 * - ``DB_TRANSIENT_ERROR``
   - 503
   - EX-07

7.4 Datos persistidos — clases tocadas
======================================

Por cada login exitoso, el UC escribe en cuatro
clases del modelo de dominio
(:doc:`/arquitectura-tecnica/modelo-dominio-iact`):

.. list-table::
 :widths: 18 18 64
 :header-rows: 1

 * - Clase
   - Operacion
   - Resumen
 * - ``Session``
   - INSERT (PASO 11) y UPDATE (PASO 10 — sobre
     Sessions previas)
   - Una nueva Session con state ACTIVE; las
     anteriores del mismo user transitan a
     CLOSED (CNST-004)
 * - ``User``
   - UPDATE (PASO 14)
   - ``last_login_at`` actualizado a NOW()
 * - ``AuditEvent``
   - INSERT (PASO 13 + por cada Session cerrada
     en PASO 10)
   - LOGIN + opcionalmente N x SESSION_CLOSED
 * - ``InternalMailbox``
   - INSERT mensaje (FA-03 cuando hay Session
     anterior)
   - Notificacion al "usuario en otro dispositivo"

7.5 Atributos relevantes por clase
==================================

7.5.1 Session
-------------

Campos tocados por UC_AUTH_01 (definicion
canonica en
:doc:`/arquitectura-tecnica/modelo-dominio-iact`):

- ``session_id`` — UUID generado.
- ``user_id`` — FK a ``User``.
- ``started_at`` — NOW() al crear.
- ``last_activity_at`` — NOW() al crear; se
  actualiza en cada request autenticado
  posterior.
- ``expires_at`` — ``started_at + 15 min``
  (CNST-005). Se extiende en cada actividad
  del usuario.
- ``state`` — enum SessionState; ACTIVE al
  crear; CLOSED al cerrar; EXPIRED si supera
  ``expires_at`` sin actividad.
- ``client_info`` — string informativo del
  dispositivo; usado para FA-03 mensaje al
  cerrar.
- ``closed_at`` — NULL al crear; NOW() cuando
  transita a CLOSED.
- ``close_reason`` — NULL al crear; valores
  posibles al cerrar: ``USER_LOGOUT`` (UC_AUTH_02),
  ``SUPERSEDED`` (CNST-004), ``ADMIN_CLOSE``
  (UC_AUTH_05), ``EXPIRED`` (timeout).

7.5.2 User
----------

Campos consultados/escritos:

- ``user_id``, ``username`` — para localizar
  (paso 7).
- ``password_hash`` — para verificar (paso 9,
  bcrypt).
- ``state`` — para validar elegibilidad (paso 8).
- ``first_login`` — para decidir FA-01.
- ``password_expires_at`` — para decidir FA-02.
- ``last_login_at`` — escrito en paso 14.

Campos NO consultados por este UC:

- ``primary_access_group_id`` — se incluye en la
  respuesta pero no afecta el flujo de
  autenticacion.
- ``email``, ``full_name``, ``created_at``,
  ``updated_at`` — informativos.

7.5.3 AuditEvent
----------------

Campos del evento ``LOGIN``:

- ``event_id`` — UUID generado.
- ``event_type`` — ``"LOGIN"`` o
  ``"LOGIN_FAILED"`` / ``"LOGIN_BLOCKED"`` /
  ``"LOGIN_INACTIVE"`` / ``"LOGIN_THROTTLED"``.
- ``actor_user_id`` — el ``user_id``
  identificado (NULL en EX-01 si nunca se
  identifico).
- ``occurred_at`` — NOW().
- ``payload`` — JSON con ``ip``, ``user_agent``,
  ``session_id`` (en exito), ``cause`` (en
  fallo). NUNCA password ni tokens (CNST-026).

CNST-025: el AuditEvent es **append-only**. No
hay UPDATE ni DELETE — si la transaccion del
flujo principal falla en paso 14, el INSERT del
paso 13 (si ya se hizo) queda comiteado en su
propia transaccion separada para garantizar
que el log no se pierde por el rollback.

7.5.4 InternalMailbox
---------------------

Mensaje opcional en FA-03:

- ``mailbox_id`` — el del ``User``.
- ``message`` — texto en espanol: "Tu sesion en
  {client_info_anterior} se cerro porque
  iniciaste sesion en otro dispositivo. Si no
  fuiste tu, contacta a un administrador."
- ``delivered_at`` — NOW().
- ``read`` — false.

7.6 Datos NO involucrados (separacion explicita)
================================================

Para evitar confusion sobre el alcance:

- **No** se modifican Assignments / FunctionGroups
  / AccessGroups del usuario. Su cambio es
  responsabilidad de UCs ACC y PERM.
- **No** se modifica el catalogo de
  ``Function``. Las funciones RBAC son
  inmutables salvo via WPs explicitos del
  programa Z.
- **No** se modifica ``ExceptionalPermission``.
- **No** hay datos de Calls / Reports / Alerts /
  ETL involucrados — el UC es puramente de
  autenticacion.

7.7 Diagrama relacional simplificado
====================================

.. uml::
 :caption: Clases tocadas por UC_AUTH_01

 @startuml
 !include ../../../_static/plantuml-styles.puml

 class User {
   + user_id : UUID
   + username : String
   + state : UserState
   + last_login_at : DateTime
   + first_login : Boolean
   + password_expires_at : DateTime
 }

 class Session {
   + session_id : UUID
   + user_id : UUID
   + started_at : DateTime
   + expires_at : DateTime
   + state : SessionState
   + close_reason : String
 }

 class AuditEvent {
   + event_id : UUID
   + event_type : String
   + actor_user_id : UUID
   + occurred_at : DateTime
   + payload : JSON
 }

 class InternalMailbox {
   + mailbox_id : UUID
   + owner_user_id : UUID
 }

 User "1" -- "0..*" Session     : posee
 User "1" -- "1"    InternalMailbox : posee
 User "1" -- "0..*" AuditEvent  : actor de

 note bottom of Session
   CNST-003: persistida en BD
   CNST-004: solo una ACTIVE por user
   CNST-005: expires_at = started_at + 15 min
 end note

 note bottom of AuditEvent
   CNST-025: inmutable, append-only
   CNST-026: sin PII en payload
 end note

 @enduml
