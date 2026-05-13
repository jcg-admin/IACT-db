.. _uc-auth-01-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

Secuencia normal cuando un ``User`` con state
ACTIVE, password correcto, sin sesiones previas
y sin condiciones de cambio forzado, completa el
login con exito. Todos los demas caminos viven
en Parte 4 (FA-NN) o Parte 5 (EX-NN).

3.1 Resumen del flujo
=====================

::

   PASO 1   Usuario abre /login                        (Frontend)
   PASO 2   Usuario completa username + password       (Frontend)
   PASO 3   Usuario submit del formulario              (Frontend)
   PASO 4   Frontend envia POST /api/auth/login/       (Frontend → Backend)
   PASO 5   Backend valida formato (Serializer)        (Backend)
   PASO 6   Backend aplica throttling CNST-011         (Backend)
   PASO 7   Backend localiza User por username         (Backend → BD)
   PASO 8   Backend valida state del User              (Backend)
   PASO 9   Backend verifica password (bcrypt)         (Backend)
   PASO 10  Backend cierra Sessions previas CNST-004   (Backend → BD)
   PASO 11  Backend crea Session nueva CNST-003        (Backend → BD)
   PASO 12  Backend genera tokens JWT                  (Backend)
   PASO 13  Backend emite AuditEvent LOGIN CNST-025    (Backend → BD)
   PASO 14  Backend actualiza User.last_login_at       (Backend → BD)
   PASO 15  Backend retorna 200 OK con tokens          (Backend → Frontend)
   PASO 16  Frontend almacena tokens                   (Frontend)
   PASO 17  Frontend redirige al landing               (Frontend → Usuario)

3.2 Detalle paso a paso
=======================

PASO 1 — Usuario abre /login
----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Usuario
 * - **Accion**
   - Navega a ``https://iact.example.com/login``
 * - **Sistema responde**
   - Frontend (React) renderiza ``<LoginForm>``
     con dos campos (username, password) +
     boton "Iniciar sesion"
 * - **Clase tocada**
   - ninguna (UI sin estado del dominio)
 * - **CNST**
   - HTTPS obligatorio (ADR-DEVOPS-001)

PASO 2 — Usuario completa credenciales
--------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Usuario
 * - **Accion**
   - Ingresa ``username`` y ``password`` en los
     campos del formulario
 * - **Sistema responde**
   - Frontend valida campo a campo: longitud
     minima del username (>= 3), longitud minima
     del password (>= 8), no campo vacio
 * - **Clase tocada**
   - ninguna
 * - **CNST**
   - CNST-012 validacion via Serializer (en
     paso 5 backend revalida)

PASO 3 — Usuario submit
------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Usuario
 * - **Accion**
   - Click en "Iniciar sesion" o Enter
 * - **Sistema responde**
   - Frontend deshabilita boton (anti
     doble-submit) y muestra spinner
 * - **Clase tocada**
   - ninguna

PASO 4 — Frontend envia request
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - HTTP POST a ``/api/auth/login/`` con body
     JSON ``{username, password, client_info?}``
 * - **Sistema responde**
   - Backend Django recibe la request en la vista
     ``LoginView`` (CNST-009 autenticacion DRF)
 * - **Headers requeridos**
   - ``Content-Type: application/json``;
     ``X-Forwarded-For`` o equivalente para IP real
 * - **CNST**
   - HTTPS obligatorio; CNST-009; CNST-013
     manejo estandarizado de respuestas

PASO 5 — Backend valida formato
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - DRF Serializer valida tipo y rango de cada
     campo
 * - **Sistema responde**
   - Si valido pasa a paso 6; si no, retorna
     ``400 Bad Request`` con detalle de campo
     invalido (CNST-013)
 * - **Clase tocada**
   - ninguna (validacion de input, no del modelo)
 * - **CNST**
   - CNST-012 validacion via Serializer

PASO 6 — Backend aplica throttling
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Decorador ``@throttle_classes`` aplica
     CNST-011: cuenta intentos por IP y por
     ``username``
 * - **Sistema responde**
   - Si dentro del limite, pasa a paso 7. Si
     excedido, va a EX-05 (Parte 5) y retorna
     ``429 Too Many Requests``
 * - **CNST**
   - CNST-011 throttling endpoints publicos

PASO 7 — Localizar User por username
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Query ``User.objects.get(username=...)``
 * - **Sistema responde**
   - Si existe, pasa a paso 8. Si no existe,
     va a EX-01.
 * - **Clase tocada**
   - ``User`` (lectura)
 * - **Mensaje al cliente en EX-01**
   - generico ``"Credenciales invalidas"`` (no
     revelar enumeracion de usernames)

PASO 8 — Validar state del User
-------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Verifica ``User.state``
 * - **Sistema responde**
   - ACTIVE → pasa a paso 9.
     INACTIVE → EX-04 (cuenta desactivada).
     BLOCKED → EX-03 (cuenta bloqueada).
 * - **Clase tocada**
   - ``User``
 * - **CNST**
   - BR-009 v2.0.0 (alcance global de
     soft-delete)

PASO 9 — Verificar password
---------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``bcrypt.check_password(password,
     User.password_hash)`` — comparacion
     constant-time
 * - **Sistema responde**
   - Match → pasa a paso 10.
     No match → EX-02 (incrementa contador
     CNST-011).
 * - **Clase tocada**
   - ``User`` (lectura)
 * - **Decisiones de derivacion**
   - Si ``User.first_login = true`` → FA-01.
     Si ``User.password_expired_at <= NOW()`` →
     FA-02.

PASO 10 — Cerrar Sessions previas (CNST-004)
--------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``Session.objects.filter(user_id=user.id,
     state='ACTIVE').update(state='CLOSED',
     closed_at=NOW(), close_reason='SUPERSEDED')``
 * - **Sistema responde**
   - Por cada Session cerrada, emite
     ``AuditEvent SESSION_CLOSED`` con causa
     SUPERSEDED. Si hay InternalMailbox al
     usuario, deja mensaje "Tu sesion en otro
     dispositivo se cerro" (CNST-002 canal
     interno).
 * - **Clase tocada**
   - ``Session`` (escritura), ``AuditEvent``
     (escritura), ``InternalMailbox`` (escritura
     opcional)
 * - **CNST**
   - CNST-004 sesion unica por usuario;
     CNST-002 buzon interno; CNST-025 auditoria

PASO 11 — Crear Session nueva (CNST-003)
----------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``Session.objects.create(user_id, state =
     'ACTIVE', started_at = NOW(),
     last_activity_at = NOW(), expires_at = NOW() +
     15 min, client_info)``
 * - **Sistema responde**
   - BD persiste la Session — ``Session.id``
     queda disponible para usar como subject del
     token
 * - **Clase tocada**
   - ``Session`` (escritura)
 * - **CNST**
   - CNST-003 sesiones persistidas en BD (no
     en memoria de la app); CNST-005 timeout
     15 min

PASO 12 — Generar tokens JWT
----------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Genera access token (TTL corto, e.g.
     15 min) y refresh token (TTL largo, e.g.
     7 dias). Payload del access incluye
     ``user_id``, ``session_id``, ``access_groups``,
     ``iat``, ``exp``.
 * - **Sistema responde**
   - Tokens firmados quedan listos para
     respuesta
 * - **Clase tocada**
   - ninguna (los tokens no son entidad del
     dominio — son representacion criptografica
     de la Session)

PASO 13 — Emitir AuditEvent LOGIN (CNST-025)
--------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``AuditEvent.objects.create(event_type =
     'LOGIN', actor_user_id, occurred_at = NOW(),
     payload = {ip, user_agent, session_id})``
 * - **Sistema responde**
   - Registro inmutable en tabla audit_event
 * - **Clase tocada**
   - ``AuditEvent`` (escritura append-only)
 * - **CNST**
   - CNST-025 auditoria inmutable; CNST-026 no
     PII en payload (sin password, sin tokens)

PASO 14 — Actualizar User.last_login_at
---------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - ``user.last_login_at = NOW()`` y guarda
 * - **Sistema responde**
   - BD persiste el cambio
 * - **Clase tocada**
   - ``User`` (escritura)

PASO 15 — Retornar 200 OK
-------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Backend
 * - **Accion**
   - Construye respuesta JSON estandar
     (CNST-013) con tokens y metadata del usuario
 * - **Sistema responde**
   - Frontend recibe ``200 OK`` con body de
     Parte 7 § 7.2
 * - **CNST**
   - CNST-013 manejo estandarizado de
     respuestas

PASO 16 — Frontend almacena tokens
----------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - Guarda access token en memoria de la SPA
     y refresh token en cookie httpOnly secure
 * - **Sistema responde**
   - State global del frontend marca
     ``isAuthenticated = true``

PASO 17 — Redirigir al landing
------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Actor**
   - Frontend
 * - **Accion**
   - Navega al landing segun el AccessGroup
     primario del usuario (e.g. AGR-001 →
     ``/dashboard``; AGR-008 → ``/audit``)
 * - **Sistema responde**
   - Usuario ve la UI con su contenido
     personalizado

3.3 Atomicidad y orden
======================

Los pasos 10-14 viven dentro de una **transaccion
atomica** en BD:

::

   BEGIN
     -- Paso 10: invalidar Sessions previas
     UPDATE session SET state='CLOSED', ...
       WHERE user_id=X AND state='ACTIVE';
     -- Paso 10b (por cada Session cerrada)
     INSERT INTO audit_event (event_type='SESSION_CLOSED', ...);
     -- Paso 11: crear Session nueva
     INSERT INTO session (state='ACTIVE', ...) RETURNING id;
     -- Paso 13: AuditEvent LOGIN
     INSERT INTO audit_event (event_type='LOGIN', ...);
     -- Paso 14: User.last_login_at
     UPDATE "user" SET last_login_at=NOW() WHERE id=X;
   COMMIT

Si cualquier paso 10-14 falla, ROLLBACK.
``Session`` queda como antes; tokens no se
emiten al cliente; se ejecuta EX-06 (BD timeout
o error transitorio).

Los pasos 12 (generacion de tokens) y 15
(respuesta) ocurren **fuera** de la transaccion
— solo despues del COMMIT exitoso.
