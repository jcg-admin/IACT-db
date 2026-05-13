.. _uc-usr-04-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**User con funcion** ``deactivate_users``.

La dependencia canonica del UC es **la
funcion**, no un AGR especifico. La funcion
``deactivate_users`` es distinta de
``modify_users`` (UC_USR_03) y
``create_users`` (UC_USR_01) — granularidad
RBAC P-15: "eliminar" es accion mas peligrosa
que "modificar".

En el catalogo predefinido, la funcion
``deactivate_users`` esta agrupada en AGR-006
user_admin_group; sin embargo el UC no requiere
membresia a ese AGR — requiere posesion de la
funcion, sea via AGR-006 u otro AGR custom
creado por UC_PERM_05.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Iniciador**
   - SI
 * - **Beneficiario directo**
   - NO — el User eliminado pierde acceso
 * - **Responsabilidad**
   - confirmar deliberadamente la operacion
     (modal robusto + opcional doble
     confirmacion)

2.2 Actores Secundarios
=======================

2.2.1 User eliminado
--------------------

Receptor pasivo. Tras la operacion:

- Sessions cerradas inmediatamente (sin
  oportunidad de cerrar limpiamente).
- Tokens blacklisteados.
- Recibe (politica) InternalMessage en buzon
  notificando la eliminacion.
- En proximo intento de login, responde 401
  con motivo ``account_eliminated``.

2.2.2 Sistema (Backend)
-----------------------

Responsabilidades:

- Validar funcion ``deactivate_users``.
- Validar que ``user_id != admin.id``
  (P-11 anti-self-elimination).
- Validar que User existe y ``state !=
  ELIMINATED`` (idempotencia).
- Transicion atomica de estados (User,
  Assignments, Sessions).
- Blacklist de tokens activos.
- AuditEvent USER_ELIMINATED.

2.2.3 BD analitica
------------------

- Atomicidad ACID en pasos masivos.
- BR-009 enforcement: NO hay DELETE de la fila
  User, solo UPDATE de state.
- Append-only en AuditEvent.

2.2.4 Frontend (React)
----------------------

- Boton "Eliminar" visible solo con
  ``deactivate_users``.
- Modal robusto OBLIGATORIO con doble
  confirmacion (operacion irreversible).
- Mensaje claro: "Esta operacion no se puede
  deshacer. El usuario perdera acceso
  inmediatamente."
- Feedback post-operacion con resumen
  (Sessions cerradas, Assignments revocados).

2.2.5 Auditor
-------------

Beneficiario indirecto. Consume AuditEvent
USER_ELIMINATED para detectar:

- Eliminaciones masivas sospechosas.
- Eliminaciones en horario inusual.
- Eliminaciones de cuentas privilegiadas.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend respondiendo en
  ``/api/users/{id}/`` (DELETE — semantica
  baja logica).
- BD MySQL accesible.
- HTTPS configurado.

2.3.2 Invocante autenticado y con la funcion
--------------------------------------------

- Session ACTIVE del invocante.
- Invocante posee la funcion
  ``deactivate_users`` (granted via cualquier
  AGR, tipicamente AGR-006).

2.3.3 User destino valido
-------------------------

- ``User`` existe en BD.
- ``User.state != 'ELIMINATED'`` (no doble
  eliminacion — idempotente vs falla
  segun politica; ver FA-02).
- ``user_id != admin.id`` (P-11).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ``User.state == 'ELIMINATED'``,
  ``User.eliminated_at = NOW()``,
  ``User.eliminated_by_admin_id = admin.id``.
- Todos los ``Assignment`` activos del User
  con ``state = 'REVOKED'``,
  ``revoked_at = NOW()``,
  ``revoked_by_admin_id = admin.id``,
  ``revoke_reason = 'USER_ELIMINATED'``.
- Todas las Sessions ACTIVE del User con
  ``state = 'CLOSED'``,
  ``close_reason = 'USER_ELIMINATED'``,
  ``closed_at = NOW()``.
- N ``BlacklistedToken`` (uno por token activo
  de cada Session cerrada).
- 1 ``AuditEvent`` con
  ``event_type = 'USER_ELIMINATED'``,
  ``actor_user_id = admin.id``,
  ``payload = {target_user_id, ip, user_agent,
  sessions_closed_count,
  assignments_revoked_count,
  prior_state}``.
- (Opcional) InternalMessage al User en buzon.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-08: rollback completo. ``User``
  intacto. Sin assignments revocados, sin
  sessions cerradas, sin tokens blacklisteados.
  Posible AuditEvent USER_ELIMINATE_FAILED.

2.4.3 Postcondiciones permanentes (irreversibles)
-------------------------------------------------

- El registro ``User`` permanece en BD —
  consultable via UC_USR_02 con filtro
  ``state=ELIMINATED`` (visible solo para
  quienes tienen funcion explicita).
- Datos historicos (mensajes enviados,
  AuditEvents generados por este User)
  permanecen referenciables por user_id.
- El email original NO queda libre — sigue
  asociado al User ELIMINATED. NO se permite
  reutilizar el email para otro User
  (politica anti-impersonacion).
- El username NO queda libre tampoco
  (CNST-029 + politica).
