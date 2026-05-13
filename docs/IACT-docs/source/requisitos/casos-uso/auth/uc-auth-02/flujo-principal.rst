.. _uc-auth-02-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

Secuencia normal cuando un ``User`` autenticado
cierra voluntariamente su ``Session`` activa.

3.1 Resumen del flujo
=====================

::

   PASO 1   Usuario click "Cerrar sesion"          (Frontend)
   PASO 2   Frontend confirma (modal opcional)     (Frontend)
   PASO 3   Frontend envia POST /api/auth/logout/  (Frontend → Backend)
   PASO 4   Backend valida token (CNST-009)        (Backend)
   PASO 5   Backend localiza Session activa        (Backend → BD)
   PASO 6   Backend transita Session a CLOSED      (Backend → BD)
   PASO 7   Backend agrega tokens a blacklist      (Backend → BD/cache)
   PASO 8   Backend emite AuditEvent LOGOUT        (Backend → BD)
   PASO 9   Backend retorna 200 OK                 (Backend → Frontend)
   PASO 10  Frontend limpia localStorage/cookies   (Frontend)
   PASO 11  Frontend redirige a /login             (Frontend → Usuario)

3.2 Detalle paso a paso
=======================

PASO 1 — Usuario click cerrar sesion
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Usuario
 * - **Accion**
   - Click en boton "Cerrar sesion" del header
     o menu de usuario
 * - **Sistema responde**
   - Frontend captura el evento click

PASO 2 — Frontend confirma
--------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - Muestra modal "¿Estas seguro de cerrar
     sesion?" con dos botones (Cancelar /
     Confirmar)
 * - **Sistema responde**
   - Espera confirmacion del usuario. Si
     cancela, no se ejecuta nada mas.

Esta confirmacion es opcional segun politica
del producto — el modal evita cierres
accidentales pero anade friccion. El frontend
puede saltarlo si el boton requiere doble click
o esta colocado en una zona protegida.

PASO 3 — Frontend envia request
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - HTTP POST a ``/api/auth/logout/`` con
     header ``Authorization: Bearer <access-token>``
     y body opcional con ``refresh_token``
 * - **Sistema responde**
   - Backend recibe request en ``LogoutView``
 * - **CNST**
   - HTTPS obligatorio; CNST-009 autenticacion;
     CNST-013 manejo estandarizado

PASO 4 — Backend valida token
-----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - DRF middleware valida firma JWT, expiracion,
     no en blacklist
 * - **Sistema responde**
   - Si valido, extrae ``user_id`` y
     ``session_id`` del payload. Si invalido,
     va a EX-01 (401).
 * - **CNST**
   - CNST-009 autenticacion DRF

PASO 5 — Localizar Session activa
---------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Query
     ``Session.objects.get(session_id=...,
     state='ACTIVE')``
 * - **Sistema responde**
   - Si existe y matchea con ``user_id`` del
     token, pasa a paso 6. Si no existe o ya
     esta CLOSED, va a EX-01 (idempotente —
     200 OK con aviso o 401 segun politica).
 * - **Clase tocada**
   - ``Session`` (lectura)

PASO 6 — Transitar Session a CLOSED
-----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``session.state = 'CLOSED'``;
     ``session.closed_at = NOW()``;
     ``session.close_reason = 'USER_LOGOUT'``;
     ``session.save()``
 * - **Sistema responde**
   - BD persiste el cambio
 * - **Clase tocada**
   - ``Session`` (escritura)
 * - **CNST**
   - BR-009 v2.0.0 (soft-delete via state, no
     DELETE)

PASO 7 — Agregar tokens a blacklist
-----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``BlacklistedToken.objects.create(jti, expires_at)``
     para el access token y para el refresh
     token (si se recibio en el body)
 * - **Sistema responde**
   - Tokens registrados como invalidados; el
     middleware de validacion JWT los rechazara
     en requests subsiguientes
 * - **Clase tocada**
   - ``BlacklistedToken`` (escritura)

PASO 8 — Emitir AuditEvent LOGOUT
---------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``AuditEvent.objects.create(event_type='LOGOUT',
     actor_user_id, occurred_at=NOW(),
     payload={ip, user_agent, session_id,
     close_reason='USER_LOGOUT'})``
 * - **Sistema responde**
   - Registro inmutable
 * - **Clase tocada**
   - ``AuditEvent`` (escritura append-only)
 * - **CNST**
   - CNST-025 auditoria inmutable; CNST-026 no
     PII en payload

PASO 9 — Retornar 200 OK
------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Construye respuesta JSON minima
     (CNST-013): ``{"message": "Sesion cerrada",
     "logout_at": "ISO timestamp"}``
 * - **Sistema responde**
   - Frontend recibe 200 OK

PASO 10 — Frontend limpia almacenamiento local
----------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - ``localStorage.removeItem('access_token')``;
     ``localStorage.removeItem('refresh_token')``;
     limpia state de Redux (``isAuthenticated =
     false``).

PASO 11 — Frontend redirige a /login
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - ``navigate('/login')``
 * - **Sistema responde**
   - Usuario ve pagina de login con mensaje
     opcional "Tu sesion fue cerrada
     correctamente"

3.3 Atomicidad
==============

Los pasos 6-8 viven dentro de una transaccion
atomica:

::

   BEGIN
     UPDATE session SET state='CLOSED',
       close_reason='USER_LOGOUT',
       closed_at=NOW()
       WHERE session_id=X;
     INSERT INTO blacklisted_token (jti, ...);
     INSERT INTO audit_event (
       event_type='LOGOUT', ...);
   COMMIT

Si cualquier paso falla, ROLLBACK. La ``Session``
queda ACTIVE; el cliente puede reintentar.
