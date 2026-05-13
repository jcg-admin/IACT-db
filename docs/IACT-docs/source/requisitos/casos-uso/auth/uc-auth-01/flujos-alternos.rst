.. _uc-auth-01-parte-04:

==============================================
Parte 4 — Flujos alternos (rutas alternativas)
==============================================

Variaciones del flujo principal que **no son
falla**, sino caminos distintos hacia el exito o
hacia un siguiente caso de uso. Las fallas viven
en Parte 5.

4.1 FA-01: Primer login con cambio forzado
==========================================

**Activador**: en el PASO 9 del flujo principal
(verificacion de password), el sistema detecta
``User.first_login = true``.

**Justificacion**: las cuentas creadas via
UC_USR_01 nacen con un password temporal y la
bandera ``first_login = true``. CNST-004 (sesion
unica) implicitamente requiere que el usuario
asuma una contrasena propia antes de operar
plenamente — riesgo de cuenta compartida con el
admin que la creo.

**Punto de divergencia**: PASO 9 → PASO 10A.

**Pasos:**

::

   PASO 10A (FA-01)  Backend NO crea Session estandar.
                     En su lugar, crea Session con
                     bandera requires_password_change=true
                     y access_groups limitados al flujo
                     de cambio de contrasena.

   PASO 11A          Backend emite AuditEvent LOGIN con
                     payload {first_login: true}.

   PASO 12A          Backend retorna 200 OK con tokens y
                     campo "next_step": "change_password"
                     en el body.

   PASO 13A          Frontend recibe la respuesta, almacena
                     tokens, y redirige a /change-password
                     (UC_AUTH_04) en lugar de al landing.

   PASO 14A          UC_AUTH_04 ejecuta. Al completarse
                     con exito, User.first_login se setea
                     a false y la Session pasa a state
                     ACTIVE pleno; el usuario navega a
                     su landing normal.

**Postcondiciones especiales:**

- ``User.first_login`` permanece ``true`` hasta
  que UC_AUTH_04 complete con exito.
- El access token emitido tiene scope reducido —
  solo permite invocar UC_AUTH_04 y UC_AUTH_02.
  Cualquier otra invocacion responde 403.

4.2 FA-02: Password proximo a expirar
=====================================

**Activador**: PASO 9, sistema detecta
``User.password_expires_at <= NOW() +
PASSWORD_EXPIRY_WARNING_WINDOW`` (ventana de
aviso).

**Justificacion**: politica de rotacion de
contrasena. La ventana es definida en el ADR de
implementacion, no en este UC.

**Diferencia con FA-01**: el cambio NO es
obligatorio — el usuario puede declinar y
continuar con la sesion estandar. La proxima
invocacion de UC_AUTH_01 volvera a ofrecer la
opcion hasta que se cumpla la fecha hard-stop o
el usuario cambie la contrasena.

**Pasos:**

::

   PASO 10B (FA-02)  Backend continua flujo principal
                     paso 10..14 con normalidad pero
                     marca el access token con un campo
                     password_warning con dias restantes.

   PASO 15B          Backend retorna 200 OK; el body
                     incluye "warning": {
                       "type": "password_expiring",
                       "days_remaining": N
                     }.

   PASO 16B          Frontend muestra modal "Tu password
                     expira en N dias. Cambiar ahora?"
                     con dos botones: "Cambiar ahora"
                     (extiende a UC_AUTH_04) o
                     "Recordarme luego" (navega al
                     landing normal).

**Postcondiciones especiales:**

- Si el usuario elige "Cambiar ahora": flujo
  similar a FA-01 PASO 13A pero la Session ya
  esta activa plena (no scope reducido).
- Si declina: la sesion sigue normal; la proxima
  invocacion de UC_AUTH_01 mostrara el aviso de
  nuevo.

4.3 FA-03: Sesion previa activa cerrada por CNST-004
====================================================

**Activador**: PASO 10 del flujo principal —
existen Sessions con state ACTIVE para el
mismo ``User``.

**Justificacion**: CNST-004 sesion unica —
solo una Session activa simultaneamente por
``User``. Al iniciar una nueva sesion, las
anteriores se cierran automaticamente.

**Diferencia con flujo principal**: este caso
**es** parte del flujo principal (no se desvia)
pero merece documentarse como FA por sus
postcondiciones de notificacion.

**Pasos extras (extienden PASO 10 del flujo principal):**

::

   PASO 10.1  Antes de UPDATE Session,
              identifica las Sessions ACTIVE del usuario.

   PASO 10.2  Por cada Session activa anterior:
              - Marca state=CLOSED, close_reason='SUPERSEDED'.
              - Emite AuditEvent SESSION_CLOSED con causa.
              - Si la Session tiene client_info distinto
                al del request actual, deja un mensaje en
                InternalMailbox del usuario:
                "Tu sesion en {client_info} se cerro porque
                iniciaste sesion en otro dispositivo."

   PASO 10.3  Despues de cerrarlas, continua con PASO 11
              del flujo principal (crea Session nueva).

**Postcondiciones especiales:**

- Sessions previas en state CLOSED, con
  ``closed_at = NOW()``, ``close_reason =
  'SUPERSEDED'``.
- Por cada Session cerrada hay un AuditEvent
  SESSION_CLOSED y posiblemente un mensaje en
  InternalMailbox.
- El usuario actual no ve ningun mensaje
  adicional — la operacion es transparente para
  el. La notificacion es para el "usuario en el
  otro dispositivo" (que es el mismo User pero
  desde otra Session).

4.4 FA-04: Login exitoso pero User sin permisos
===============================================

**Activador**: PASOS 10-14 completan con exito;
en el momento de construir la respuesta el
sistema detecta que el ``User`` no tiene ningun
``Assignment`` con state ACTIVE — ni
``FunctionGroup``, ni ``AccessGroup``, ni
``ExceptionalPermission``.

**Justificacion**: caso edge. Tecnicamente login
exitoso, pero la UI no tendria nada que mostrar.

**Diferencia con flujo principal**: la sesion se
crea y los tokens se emiten, pero la respuesta
incluye un aviso.

**Pasos:**

::

   PASO 15D  Backend retorna 200 OK con body extendido:
             {
               "tokens": {...},
               "user": {...},
               "warning": {
                 "type": "no_permissions",
                 "message": "Tu cuenta no tiene permisos
                            asignados. Contacta a un
                            administrador."
               }
             }

   PASO 16D  Frontend almacena tokens; navega a una
             pagina de "cuenta sin permisos" que ofrece
             link para contactar al admin
             (AGR-006 user_admin_group).

**Postcondiciones especiales:**

- Session activa creada (igual que en flujo
  principal).
- AuditEvent LOGIN registrado normalmente.
- AuditEvent extra LOGIN_NO_PERMISSIONS registrado
  para que el AGR-006 admin pueda detectar el
  caso.

4.5 Resumen de flujos alternos
==============================

.. list-table::
 :widths: 12 35 18 35
 :header-rows: 1

 * - ID
   - Activador
   - Resultado
   - UC siguiente
 * - FA-01
   - User.first_login = true
   - Sesion limitada
   - UC_AUTH_04 obligatorio
 * - FA-02
   - Password proximo a expirar
   - Sesion plena + aviso
   - UC_AUTH_04 opcional
 * - FA-03
   - Sessions previas activas
   - Sesion plena, otras cerradas
   - (continua en PASO 11)
 * - FA-04
   - User sin Assignments
   - Sesion plena pero UI vacia
   - (espera intervencion admin)

Cada FA produce su propio AuditEvent
identificable por payload (e.g. ``first_login: true``)
para que UC_AUD_01..04 los pueda filtrar y el
admin de seguridad pueda reaccionar.
