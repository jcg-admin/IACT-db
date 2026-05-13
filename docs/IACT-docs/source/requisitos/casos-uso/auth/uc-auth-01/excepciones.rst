.. _uc-auth-01-parte-05:

======================================
Parte 5 — Excepciones (casos de error)
======================================

Caminos hacia falla con diagnostico claro. A
diferencia de los flujos alternos (Parte 4), las
excepciones **no producen Session activa**. El
cliente recibe respuesta 4xx o 5xx con
``error_code`` estandar (CNST-013).

5.1 Excepciones de validacion (4xx)
===================================

EX-01: Usuario no existe
------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 7 — query ``User.objects.get(username=...)``
     no encuentra registro
 * - **Status HTTP**
   - 401 Unauthorized
 * - **error_code**
   - ``INVALID_CREDENTIALS``
 * - **Mensaje al cliente**
   - "Credenciales invalidas" (generico — no
     revelar enumeracion de usernames)
 * - **AuditEvent**
   - ``LOGIN_FAILED`` con causa
     ``USER_NOT_FOUND`` y payload
     ``{username, ip, user_agent}``
 * - **Throttling**
   - Incrementa contador CNST-011 por IP
 * - **Recuperacion**
   - Usuario corrige el username y reintenta

EX-02: Password incorrecto
--------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 9 — ``bcrypt.check_password()`` retorna
     ``False``
 * - **Status HTTP**
   - 401 Unauthorized
 * - **error_code**
   - ``INVALID_CREDENTIALS`` (mismo que EX-01
     por anti-enumeracion)
 * - **Mensaje al cliente**
   - "Credenciales invalidas"
 * - **AuditEvent**
   - ``LOGIN_FAILED`` con causa
     ``BAD_PASSWORD`` y payload con ``user_id``,
     IP, user agent (sin password)
 * - **Throttling**
   - Incrementa contador por IP **y** por
     ``user_id``
 * - **Recuperacion**
   - Usuario corrige password; o usa UC_AUTH_03
     para recuperarla

EX-03: Cuenta bloqueada (state = BLOCKED)
-----------------------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 8 — ``User.state == 'BLOCKED'``
 * - **Status HTTP**
   - 403 Forbidden
 * - **error_code**
   - ``ACCOUNT_BLOCKED``
 * - **Mensaje al cliente**
   - "Cuenta bloqueada. Contacta a un
     administrador." (especifico — no hay
     riesgo de enumeracion porque ya se valido
     existencia y password en pasos 7-9; aunque
     en este UC el orden hace que paso 8 vaya
     **antes** que paso 9, exponiendo
     existencia. Decision DEC-A11: aceptar el
     trade-off por usabilidad — un usuario con
     cuenta bloqueada necesita saberlo)
 * - **AuditEvent**
   - ``LOGIN_BLOCKED`` con ``user_id``, IP
 * - **Throttling**
   - No incrementa (la cuenta ya esta bloqueada)
 * - **Recuperacion**
   - Usuario contacta AGR-006 ``user_admin_group``
     para desbloqueo

EX-04: Cuenta inactiva (state = INACTIVE)
-----------------------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 8 — ``User.state == 'INACTIVE'`` (per
     BR-009 v2.0.0 soft-delete)
 * - **Status HTTP**
   - 403 Forbidden
 * - **error_code**
   - ``ACCOUNT_INACTIVE``
 * - **Mensaje al cliente**
   - "Cuenta inactiva. Contacta a un
     administrador."
 * - **AuditEvent**
   - ``LOGIN_INACTIVE`` con ``user_id``, IP
 * - **Throttling**
   - No incrementa
 * - **Recuperacion**
   - Usuario contacta AGR-006 ``user_admin_group``
     para reactivar (si politica lo permite)

EX-05: Throttling excedido (CNST-011)
-------------------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 6 — el contador de intentos por IP o
     por ``username`` excedio el limite definido
     por CNST-011 (cifras concretas en ADR de
     implementacion)
 * - **Status HTTP**
   - 429 Too Many Requests
 * - **error_code**
   - ``RATE_LIMITED``
 * - **Mensaje al cliente**
   - "Demasiados intentos. Intenta nuevamente en
     {retry_after} segundos."
 * - **Headers especiales**
   - ``Retry-After: <seconds>``
 * - **AuditEvent**
   - ``LOGIN_THROTTLED`` con IP, payload con
     ``attempt_count`` y ``window_started_at``
 * - **Throttling**
   - El contador no se incrementa adicionalmente
     — ya esta en su tope
 * - **Recuperacion**
   - Esperar la ventana de cooldown

EX-06: Datos malformados
------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 5 — DRF Serializer rechaza el body
     (campo faltante, tipo invalido, longitud
     fuera de rango)
 * - **Status HTTP**
   - 400 Bad Request
 * - **error_code**
   - ``VALIDATION_ERROR``
 * - **Mensaje al cliente**
   - estructura JSON con detalle de campos
     invalidos: ``{errors: {username: [...],
     password: [...]}}``
 * - **AuditEvent**
   - No emite (el request ni siquiera identifico
     un User)
 * - **Throttling**
   - Incrementa contador por IP (anti-fuzzing)
 * - **Recuperacion**
   - Cliente corrige y reenvia

5.2 Excepciones de infraestructura (5xx)
========================================

EX-07: BD timeout o error transitorio
-------------------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASOS 10-14 — alguna escritura a BD falla
     (deadlock, timeout, perdida de conexion)
 * - **Status HTTP**
   - 503 Service Unavailable
 * - **error_code**
   - ``DB_TRANSIENT_ERROR``
 * - **Mensaje al cliente**
   - "Servicio temporalmente no disponible.
     Intenta en unos segundos."
 * - **Headers especiales**
   - ``Retry-After: 5``
 * - **AuditEvent**
   - Si el AuditEvent LOGIN ya se inserto antes
     del fallo, queda registrado. Si no, no se
     emite (no se puede). En caso de ROLLBACK
     completo de la transaccion, el evento se
     pierde — el log de la aplicacion (CNST-024
     logs estructurados JSON) lo registra.
 * - **Throttling**
   - No incrementa (no es falla del usuario)
 * - **Recuperacion**
   - Cliente reintenta; si persiste, el equipo
     de operaciones investiga via UC_PIP_01 /
     UC_LOG_01

EX-08: InternalMailbox service offline (parcial)
------------------------------------------------

.. list-table::
 :widths: 22 78
 :header-rows: 0

 * - **Activador**
   - PASO 10.2 (FA-03) — al intentar dejar
     mensaje en InternalMailbox del usuario por
     cierre de sesion previa, el servicio no
     responde
 * - **Status HTTP**
   - 200 OK (el login en si tuvo exito; la
     notificacion al usuario es best-effort)
 * - **error_code**
   - ninguno (no es falla del UC desde
     perspectiva del usuario actual)
 * - **Estrategia de manejo**
   - El backend registra el incidente en log
     (CNST-024) y emite ``AuditEvent``
     ``MAILBOX_DELIVERY_FAILED`` con detalle.
     El mensaje queda en una cola de reintento
     o se pierde segun politica del Mailbox
     service.
 * - **Decision DEC-A12**
   - El login no falla por falla del Mailbox.
     La perdida del mensaje al "usuario en otro
     dispositivo" es trade-off aceptado: la
     prioridad es que el usuario actual obtenga
     su Session.
 * - **Recuperacion**
   - Reintento async del Mailbox service o
     intervencion manual

5.3 Tabla resumen de excepciones
================================

.. list-table::
 :widths: 8 25 14 22 31
 :header-rows: 1

 * - ID
   - Causa
   - Status
   - error_code
   - AuditEvent
 * - EX-01
   - Usuario no existe
   - 401
   - ``INVALID_CREDENTIALS``
   - ``LOGIN_FAILED`` (USER_NOT_FOUND)
 * - EX-02
   - Password incorrecto
   - 401
   - ``INVALID_CREDENTIALS``
   - ``LOGIN_FAILED`` (BAD_PASSWORD)
 * - EX-03
   - Cuenta bloqueada
   - 403
   - ``ACCOUNT_BLOCKED``
   - ``LOGIN_BLOCKED``
 * - EX-04
   - Cuenta inactiva
   - 403
   - ``ACCOUNT_INACTIVE``
   - ``LOGIN_INACTIVE``
 * - EX-05
   - Throttling excedido
   - 429
   - ``RATE_LIMITED``
   - ``LOGIN_THROTTLED``
 * - EX-06
   - Datos malformados
   - 400
   - ``VALIDATION_ERROR``
   - (no emite)
 * - EX-07
   - BD transient error
   - 503
   - ``DB_TRANSIENT_ERROR``
   - parcial (si llego a insertar)
 * - EX-08
   - Mailbox offline
   - 200 (no falla)
   - n/a
   - ``MAILBOX_DELIVERY_FAILED``

5.4 Estructura JSON de respuesta de error
=========================================

Todas las excepciones de la familia 4xx/5xx
retornan el mismo shape estandar (CNST-013):

::

   {
     "error": {
       "code": "INVALID_CREDENTIALS",
       "message": "Credenciales invalidas",
       "fields": {           // opcional, presente solo en VALIDATION_ERROR
         "username": ["Campo requerido"],
         "password": ["Longitud minima 8"]
       },
       "retry_after": 30      // opcional, presente solo en RATE_LIMITED y DB_TRANSIENT_ERROR
     },
     "request_id": "uuid",
     "timestamp": "2026-05-01T07:30:00Z"
   }

El campo ``request_id`` correlaciona con los logs
estructurados (CNST-024) para troubleshooting.
