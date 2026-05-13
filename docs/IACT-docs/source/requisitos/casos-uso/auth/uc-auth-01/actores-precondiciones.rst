.. _uc-auth-01-parte-02:

==========================================================
Parte 2 — Actores, precondiciones y postcondiciones
==========================================================

2.1 Actor Principal
===================

**Usuario** — cualquier persona registrada en el
catalogo de ``User`` con state ∈ {ACTIVE,
INACTIVE, BLOCKED}.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Identificacion en sistema**
   - ``user_id`` (UUID) + ``username`` (login id)
 * - **Iniciador**
   - SI — quien dispara el caso de uso
 * - **Beneficiario**
   - SI — recibe la ``Session`` que habilita el
     resto del trabajo
 * - **Responsabilidad**
   - presentar credenciales correctas;
     custodiar password en lugar seguro;
     respetar el cierre de sesiones anteriores
     al iniciar una nueva (CNST-004)

Sub-tipos del Usuario por ``AccessGroup``
asignado (catalogo canonico de
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
v5.4.0 lineas 1090-1135):

.. list-table::
 :widths: 18 30 52
 :header-rows: 1

 * - AGR
   - Nombre canonico
   - Rol operativo
 * - AGR-001
   - ``basic_operator_group``
   - Operador con acceso minimo (dashboard,
     alertas activas)
 * - AGR-002
   - ``report_viewer_group``
   - Operador con acceso a reportes historicos
 * - AGR-003
   - ``quality_supervisor_group``
   - Supervisor que opera reportes especificos,
     reconoce alertas
 * - AGR-004
   - ``data_exporter_group``
   - Usuario con permiso de exportar
 * - AGR-005
   - ``alert_manager_group``
   - Gestor de umbrales y suscripciones de
     alertas
 * - AGR-006
   - ``user_admin_group``
   - Administrador del catalogo de usuarios
 * - AGR-007
   - ``permission_admin_group``
   - Administrador del modelo RBAC granular
 * - AGR-008
   - ``auditor_group``
   - Auditor de eventos inmutables
 * - AGR-009
   - ``pipeline_admin_group``
   - Supervisor del pipeline ETL
 * - AGR-010
   - ``system_admin_group``
   - Administrador de infraestructura

UC_AUTH_01 es **publico en su acceso** (cualquier
``User`` con credenciales validas puede invocarlo
independientemente de su AccessGroup). El
``AccessGroup`` solo determina **que puede hacer
despues** de iniciada la sesion, no si puede
iniciarla.

2.2 Actores Secundarios
=======================

2.2.1 Sistema (Backend Django)
------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Sistema interno (no humano)
 * - **Rol**
   - Validacion automatica + persistencia +
     auditoria
 * - **Responsabilidades**
   - Recibir request HTTPS, validar via DRF
     Serializer (CNST-012), aplicar throttling
     (CNST-011), buscar ``User`` en BD, verificar
     password (bcrypt), aplicar CNST-004 sesion
     unica (invalidar Sessions previas del User),
     crear ``Session`` (CNST-003), generar tokens
     JWT, emitir AuditEvent LOGIN (CNST-025),
     retornar respuesta JSON estandar (CNST-013).

2.2.2 Base de datos analitica (MySQL)
-------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Sistema externo persistente
 * - **Rol**
   - Almacenamiento ACID de ``User``,
     ``Session``, ``AuditEvent``
 * - **Responsabilidades**
   - 1) Garantizar transaccion ACID en el
     bloque de pasos 5-9;
     2) Cumplir CNST-003 (sesiones persistidas
     en BD, no en memoria de la aplicacion);
     3) Cumplir CNST-025 (auditoria
     append-only — sin UPDATE ni DELETE);
     4) Validar constraints (UNIQUE
     ``username``, FK ``user_id`` en Session).

2.2.3 InternalMailbox service
-----------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Sistema interno
 * - **Rol**
   - Canal de notificacion al usuario
     (CNST-002)
 * - **Responsabilidades**
   - 1) Recibir mensaje de notificacion (e.g.
     "se cerro tu sesion en otro dispositivo");
     2) Persistir el mensaje en buzon del
     ``User``;
     3) NO usar email externo (CNST-001).

2.2.4 Frontend (React)
----------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Sistema cliente
 * - **Rol**
   - UI del formulario de login + manejo de la
     respuesta
 * - **Responsabilidades**
   - Renderizar formulario en /login, validar
     input cliente-side (formato, completitud),
     enviar request HTTPS POST a
     ``/api/auth/login/``, almacenar tokens en
     localStorage o cookie httpOnly segun policy,
     redirigir al landing del usuario segun su
     AccessGroup principal.

2.2.5 Auditor (beneficiario indirecto)
--------------------------------------

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (rol AGR-008 ``auditor_group``)
 * - **Rol**
   - Beneficiario del registro inmutable
     producido por UC_AUTH_01
 * - **Responsabilidades**
   - Ninguna sincrona en este UC. Posteriormente
     consume el ``AuditEvent LOGIN`` via
     UC_AUD_01..04.
 * - **Justificacion para listarlo**
   - CNST-025 lo declara beneficiario; el
     diagrama vigente lo omitia (corregido per
     DEC-A07).

2.3 Precondiciones
==================

Lo que **debe ser verdad antes** de iniciar
UC_AUTH_01:

2.3.1 Sistema disponible
------------------------

- Backend Django respondiendo en
  ``/api/auth/login/``.
- BD analitica MySQL accesible y consistente.
- HTTPS configurado (sin HTTP plano —
  ADR-DEVOPS-001).
- InternalMailbox service operativo (necesario
  solo si el flujo desemboca en notificacion;
  no bloqueante para el login en si).
- Reloj sincronizado (NTP) — la generacion de
  tokens JWT y la verificacion de expiracion
  dependen de timestamps consistentes.

2.3.2 Usuario registrado
------------------------

- Existe registro ``User`` en BD con el
  ``username`` recibido.
- ``User.state`` ∈ {ACTIVE, INACTIVE, BLOCKED}.
  Solo ACTIVE permite login exitoso; INACTIVE y
  BLOCKED van a EX-04 / EX-03.
- ``User.password_hash`` poblado (bcrypt).
- Si es primer login (``User.first_login =
  true``): la ruta alterna FA-01 forza cambio de
  contrasena.

2.3.3 Cliente con conectividad
------------------------------

- HTTPS disponible (TLS 1.2+ minimo).
- JavaScript habilitado (la UI lo requiere; el
  endpoint en si funciona sin JS pero la
  experiencia se degrada).
- IP del cliente no bloqueada por throttling
  global (CNST-011).
- localStorage o cookies habilitadas para
  almacenar el token resultante.

2.3.4 Datos de entrada validos esperados
----------------------------------------

- ``username``: string no vacio, longitud 3-50
  caracteres, segun NOM_001.
- ``password``: string no vacio, longitud 8-128
  caracteres.
- ``client_info`` (opcional): user agent y
  metadata del dispositivo, util para auditoria
  pero no requerido.

2.3.5 Estado del catalogo RBAC
------------------------------

- El ``User`` tiene al menos un ``Assignment``
  vigente con un ``AccessGroup`` (AGR-001..010)
  o con un ``FunctionGroup`` que le otorgue al
  menos una funcion. De lo contrario login
  exitoso pero el usuario veria UI vacia (no
  bloquea login pero degrada UX). Esto se
  documenta como FA-04 (vease Parte 4).

2.4 Postcondiciones
===================

Lo que **debe ser verdad despues** de UC_AUTH_01.

2.4.1 Postcondiciones de exito
------------------------------

- ``Session`` nueva persistida en BD con
  ``state = ACTIVE``, ``user_id`` apuntando al
  ``User`` autenticado, ``started_at = NOW()``,
  ``expires_at = NOW() + 15 min`` (CNST-005),
  ``last_activity_at = NOW()``.
- Sessions previas del mismo ``User`` con state
  ACTIVE ahora estan en state CLOSED por
  CNST-004 sesion unica; cada cambio genera su
  propio ``AuditEvent``.
- Tokens JWT firmados emitidos: access (TTL
  corto) y refresh (TTL mas largo).
- ``AuditEvent`` con event_type=LOGIN registrado
  apuntando al ``user_id``, con
  ``occurred_at = NOW()``, ``actor_user_id =
  user_id``, payload con IP del cliente y user
  agent (sin password — CNST-026 PII).
- ``User.last_login_at`` actualizado a NOW().
- Frontend recibe respuesta 200 OK con la
  estructura JSON de Parte 7.
- localStorage / cookie del cliente almacena el
  token de acceso.

2.4.2 Postcondiciones de fallo
------------------------------

Para cada uno de los EX-01..EX-07 documentados
en Parte 5:

- Ninguna ``Session`` nueva creada.
- Sessions existentes del usuario (si las hay)
  permanecen sin cambios.
- ``AuditEvent`` con event_type=LOGIN_FAILED
  registrado con la causa (CREDENTIAL_INVALID,
  USER_INACTIVE, USER_BLOCKED, RATE_LIMITED,
  etc.).
- Contador de intentos fallidos del
  ``username`` y/o IP incrementado para
  CNST-011 throttling.
- Frontend recibe respuesta 4xx con ``error_code``
  estandar (CNST-013).
- Token JWT NO emitido al cliente.

2.4.3 Postcondiciones de extension a UC_AUTH_04
-----------------------------------------------

Si el flujo deriva a FA-01 (primer login) o
FA-02 (password expirado):

- ``Session`` nueva creada con state ACTIVE
  pero con bandera ``requires_password_change =
  true``.
- El frontend redirige a /change-password
  (UC_AUTH_04) en lugar del landing del usuario.
- Hasta que UC_AUTH_04 complete con exito, las
  funciones RBAC del usuario quedan limitadas a
  las del flujo de cambio de contrasena.
