.. _uc-usr-01-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Admin abre form "Crear usuario"        (Frontend)
   PASO 2   Admin ingresa datos + AGR opcional     (Frontend)
   PASO 3   Frontend valida client-side basico     (Frontend)
   PASO 4   POST /api/users/                       (Frontend → Backend)
   PASO 5   Backend valida JWT + RBAC              (Backend)
   PASO 6   Backend valida datos + email unico     (Backend → BD)
   PASO 7   Backend genera username (CNST-029)     (Backend → BD)
   PASO 8   Backend genera password temporal       (Backend)
   PASO 9   Backend hashea bcrypt cost 12          (Backend)
   PASO 10  Backend INSERT User                    (Backend → BD)
   PASO 11  Backend INSERT Assignment (si AGR)     (Backend → BD)
   PASO 12  Backend crea InternalMessage           (Backend → BD)
   PASO 13  Backend emite AuditEvent USER_CREATED  (Backend → BD)
   PASO 14  Backend retorna 201 + username         (Backend → Frontend)
   PASO 15  Frontend muestra confirmacion          (Frontend)

3.2 Detalle paso a paso
=======================

PASO 1 — Form abierto
---------------------

Admin navega a ``/admin/users/new`` (visible solo
con AGR-006).

PASO 2 — Ingreso de datos
-------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Campos obligatorios**
   - ``first_name``, ``last_name``, ``email``
 * - **Campos opcionales**
   - ``access_group_id`` (AGR a asignar
     inicialmente)

PASO 3 — Validacion client-side
-------------------------------

Frontend valida formato de email y campos no
vacios. Las validaciones de unicidad y politica
ocurren en backend (defensa contra bypass).

PASO 4 — POST /api/users/
-------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Request**
   - ``POST /api/users/`` con
     ``Authorization: Bearer <admin-token>``
 * - **Body**
   - ``{first_name, last_name, email,
     access_group_id?}``
 * - **CNST**
   - HTTPS, CNST-009, CNST-013

PASO 5 — Validar JWT + RBAC
---------------------------

DRF middleware valida JWT. ``HasCreateUsers``
permission verifica ``create_users`` en AGRs del
admin. Si falla, EX-01 (403).

PASO 6 — Validar datos + email unico
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - Serializer DRF valida formato email y
     campos. Backend hace
     ``User.objects.filter(email=email).exists()``
 * - **Sistema**
   - Si email existe, EX-02 (409). Si formato
     invalido, EX-03 (400).
 * - **Clase**
   - ``User`` (lectura)

PASO 7 — Generar username (CNST-029)
------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``UsernameGenerator.generate(first_name,
     last_name)``:

     1. Normalizar (lowercase, sin acentos).
     2. Base = ``"{first}.{last}"``.
     3. Contar usuarios con username = base
        prefix.
     4. Sufijo NNNN = count + 1 (zero-padded).
 * - **Resultado**
   - ``ana.gomez.0001``,
     ``ana.gomez.0002``, etc.
 * - **CNST**
   - CNST-029 username autogenerado, no
     editable.

PASO 8 — Generar password temporal
----------------------------------

``PasswordGenerator.generate(length=12)`` —
mismo generador que UC_AUTH_03 (Strategy
pattern). Charset mixto (mayus + minus + digit
+ symbol), entropia >= 72 bits.

**Critico**: la contrasena vive solo en memoria.
NO se loggea, NO se incluye en response.

PASO 9 — Hashear con bcrypt
---------------------------

``bcrypt.hashpw(temp_password, gensalt(12))``.

PASO 10 — INSERT User
---------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``User.objects.create(
     username, email, first_name, last_name,
     password_hash, state='ACTIVE',
     first_login=True,
     password_changed_at=NOW(),
     created_by_admin_id=admin.id)``
 * - **Clase**
   - ``User`` (escritura)

PASO 11 — Asignacion de AGR (si aplica)
---------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Condicion**
   - solo si ``access_group_id`` provisto y
     valido
 * - **Accion**
   - ``Assignment.objects.create(
     user=new_user, access_group_id=agr,
     state='ACTIVE',
     granted_at=NOW(),
     granted_by_admin_id=admin.id)``
 * - **Clase**
   - ``Assignment`` (escritura)

PASO 12 — InternalMessage con credenciales
------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``InternalMessage.objects.create(
     recipient=new_user, sender=None,
     subject='Bienvenido a IACT — Credenciales',
     body=...)``
 * - **Body**
   - "Tu cuenta IACT ha sido creada. Usuario:
     {username}. Contrasena temporal: {temp}.
     Debes cambiarla en tu primer inicio de
     sesion."
 * - **CNST**
   - CNST-001 (no envio externo); CNST-002
     (buzon obligatorio)

PASO 13 — AuditEvent USER_CREATED
---------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Accion**
   - ``AuditEvent.objects.create(
     event_type='USER_CREATED',
     actor_user_id=admin.id,
     occurred_at=NOW(),
     payload={target_user_id,
     access_group_id, ip, user_agent,
     has_initial_agr})``
 * - **CNST**
   - CNST-025 audit; CNST-026 sin PII (no
     incluir email/full_name del nuevo user en
     payload — solo IDs).

PASO 14 — Response 201 Created (sin password)
---------------------------------------------

.. list-table::
 :widths: 20 80
 :header-rows: 0

 * - **Response**
   - 201 Created,
     ``{"user_id": ..., "username":
     "ana.gomez.0001", "created_at": "...",
     "notification_sent": true}``
 * - **Critico**
   - La contrasena temporal NO va en response.
     Solo en el InternalMessage.

PASO 15 — Confirmacion al admin
-------------------------------

Frontend toast: "Usuario creado: ana.gomez.0001.
Las credenciales fueron enviadas a su buzon
interno." Sin mostrar contrasena.

3.3 Atomicidad
==============

Pasos 10-13 dentro de una transaccion atomica:

::

   BEGIN
     INSERT INTO user (username, email, ...,
       first_login=true, ...);
     INSERT INTO assignment (user_id, access_group_id, ...);  -- si aplica
     INSERT INTO internal_message (recipient_id, body=...);
     INSERT INTO audit_event (event_type='USER_CREATED', ...);
   COMMIT

Si cualquier paso falla, ROLLBACK. **No se acepta
un User sin notificacion en buzon** (CNST-002
obligatorio para la entrega de credenciales).
