.. _uc-auth-02-parte-02:

==========================================================
Parte 2 — Actores, precondiciones y postcondiciones
==========================================================

2.1 Actor Principal
===================

**Usuario autenticado** — cualquier ``User`` con
una ``Session`` activa que decide finalizarla
voluntariamente.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Identificacion en sistema**
   - Token JWT en header ``Authorization`` que
     resuelve a un ``user_id`` y ``session_id``
 * - **Iniciador**
   - SI — quien dispara el caso de uso
 * - **Beneficiario**
   - SI — recibe la confirmacion de cierre y
     puede dejar el dispositivo desocupado de
     forma segura
 * - **Responsabilidad**
   - presentar token valido; aceptar la
     finalizacion del estado autenticado en este
     dispositivo

Cualquier ``User`` (independiente de su
``AccessGroup``) puede invocar UC_AUTH_02 sobre
su propia ``Session``. No requiere funcion RBAC
explicita.

2.2 Actores Secundarios
=======================

2.2.1 Sistema (Backend Django)
------------------------------

Responsabilidades:

- Validar el token JWT recibido (CNST-009).
- Localizar la ``Session`` correspondiente.
- Verificar que ``Session.state = ACTIVE`` y que
  ``Session.user_id`` matchea con el del token.
- Transitar la ``Session`` a state CLOSED con
  ``close_reason = 'USER_LOGOUT'``.
- Anadir el refresh token al blacklist (segun
  strategy de invalidacion).
- Emitir ``AuditEvent LOGOUT`` (CNST-025).
- Retornar respuesta 200 OK estandar (CNST-013).

2.2.2 Base de datos analitica (MySQL)
-------------------------------------

Responsabilidades:

- Atomicidad ACID en pasos 4-6 del flujo
  principal.
- Append-only en ``AuditEvent`` (CNST-025).
- UPDATE de ``Session`` con check de optimistic
  concurrency (no race condition al cerrar
  simultaneamente con UC_AUTH_05 o CNST-005
  expiracion).

2.2.3 Frontend (React)
----------------------

Responsabilidades:

- Renderizar boton "Cerrar sesion" visible en
  cualquier pagina autenticada (header / menu
  de usuario).
- Confirmar accion (modal opcional para evitar
  cierres accidentales por click de usuario
  cansado).
- Enviar request POST a
  ``/api/auth/logout/`` con header
  ``Authorization: Bearer <access-token>``.
- Limpiar localStorage / cookies de tokens.
- Redirigir a ``/login``.

2.2.4 Auditor (beneficiario indirecto)
--------------------------------------

Responsabilidades sincronas: ninguna.
Posteriormente consume el ``AuditEvent LOGOUT``
via UC_AUD_01..04 para reconstruir patrones de
uso de los usuarios.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend Django respondiendo en
  ``/api/auth/logout/``.
- BD analitica MySQL accesible y consistente.
- HTTPS configurado (ADR-DEVOPS-001).

2.3.2 Usuario autenticado
-------------------------

- Existe ``Session`` con ``state = ACTIVE`` para
  el ``user_id`` del token.
- ``Session.expires_at > NOW()`` (no expirada
  por CNST-005).
- Token JWT valido (firma OK, no en blacklist,
  no expirado).
- ``User.state ∈ {ACTIVE, INACTIVE, BLOCKED}`` —
  incluso usuarios INACTIVE / BLOCKED pueden
  cerrar su sesion (asegura limpieza incluso si
  fueron desactivados despues del login).

2.3.3 Cliente con conectividad
------------------------------

- HTTPS disponible.
- Token presente en localStorage / cookie.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ``Session.state = CLOSED``,
  ``close_reason = 'USER_LOGOUT'``,
  ``closed_at = NOW()``.
- Refresh token agregado a blacklist (o
  equivalente).
- ``AuditEvent`` con
  ``event_type = 'LOGOUT'``,
  ``actor_user_id = user_id``, payload
  con IP y user_agent.
- Frontend recibe respuesta 200 OK con un
  cuerpo minimo de confirmacion.
- Frontend limpia localStorage / cookies y
  redirige a ``/login``.
- Cualquier request subsiguiente con el token
  invalidado responde 401.

2.4.2 Postcondiciones de fallo
------------------------------

- Si EX-01 (token invalido / Session ya
  cerrada): no hay cambios en BD; ``AuditEvent``
  ``LOGOUT_FAILED`` opcional segun politica.
- Si EX-02 (BD timeout): rollback; la Session
  permanece ACTIVE; el cliente puede reintentar
  o se cerrara por CNST-005 timeout.

2.4.3 Postcondiciones idempotentes
----------------------------------

UC_AUTH_02 es **idempotente sobre Session ya
cerrada**: invocarlo dos veces sobre la misma
Session retorna exito en la primera y 401 en la
segunda (la Session ya no esta ACTIVE). Esto
evita errores confusos al usuario que clickea
"Cerrar sesion" varias veces.
