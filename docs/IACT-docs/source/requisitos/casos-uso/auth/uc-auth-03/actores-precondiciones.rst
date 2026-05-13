.. _uc-auth-03-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**Administrador con AGR-006 user_admin_group** —
``User`` con ``Assignment`` activo a la funcion
``reset_password`` via ``AGR-006``.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Identificacion**
   - JWT con ``user_id`` y ``access_groups``
     incluyendo AGR-006
 * - **Iniciador**
   - SI
 * - **Beneficiario directo**
   - NO — el beneficiario es el User afectado
 * - **Responsabilidad**
   - presentar token valido, identificar el
     User correcto a resetear, manejar la
     interfaz hasta confirmar la accion

2.2 Actores Secundarios
=======================

2.2.1 User afectado
-------------------

Receptor pasivo. No interactua durante la
ejecucion. Posteriormente lee su
``InternalMailbox`` para obtener la contrasena
temporal y entra al sistema con ella.

Responsabilidades posteriores:

- Leer InternalMessage en su buzon.
- Iniciar sesion via UC_AUTH_01 (que detectara
  ``first_login=true`` → FA-01 → forzar
  UC_AUTH_04).

2.2.2 Sistema (Backend Django)
------------------------------

Responsabilidades:

- Validar ``reset_password`` en los
  AccessGroups del admin (CNST-009).
- Validar User destino existe y permite reset.
- Generar contrasena temporal segura.
- Hashear bcrypt cost 12.
- UPDATE ``User.password_hash``,
  ``User.first_login=true``,
  ``User.password_changed_at=NOW()``.
- Cerrar Sessions activas del User destino.
- Crear ``InternalMessage`` con la contrasena.
- Emitir ``AuditEvent PASSWORD_RESET``.

2.2.3 Base de datos analitica (MySQL)
-------------------------------------

Responsabilidades:

- Atomicidad ACID en los pasos UPDATE User +
  cerrar Sessions + INSERT InternalMessage +
  INSERT AuditEvent.
- Append-only en AuditEvent (CNST-025).

2.2.4 InternalMailbox
---------------------

Responsabilidades:

- Recibir el INSERT del mensaje con la
  contrasena temporal.
- Notificar al User en su proximo login (UI).

2.2.5 Frontend (React)
----------------------

Responsabilidades:

- Pagina de gestion de usuarios (visible solo
  con AGR-006).
- Boton "Resetear contrasena" + modal de
  confirmacion robusto (operacion peligrosa).
- Mostrar feedback al admin (sin exponer la
  contrasena temporal — esa SOLO va al
  InternalMailbox del User).
- NUNCA mostrar la contrasena temporal en la UI
  del admin.

2.2.6 Auditor
-------------

Beneficiario indirecto. Consume AuditEvent
PASSWORD_RESET para detectar:

- Patrones de admins que resetean muchos
  usuarios (posible escalada).
- Reset de cuentas privilegiadas.
- Auto-resets atipicos.

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend Django respondiendo en
  ``/api/users/{id}/reset-password/``.
- BD MySQL accesible.
- HTTPS configurado.

2.3.2 Admin autenticado y autorizado
------------------------------------

- Session ACTIVE del admin.
- ``access_groups`` incluye AGR-006
  user_admin_group.
- Funcion ``reset_password`` en los permisos
  derivados del AGR.

2.3.3 User destino valido
-------------------------

- Existe ``User`` con id provisto.
- ``User.state`` no es ``ELIMINATED``.
- ``user_id != admin.user_id`` (no auto-reset).

2.3.4 InternalMailbox del User accesible
----------------------------------------

- El User tiene un ``InternalMailbox`` activo
  (cualquier User en el sistema lo tiene por
  default — UC_USR_01 lo crea).

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- ``User.password_hash`` actualizado con bcrypt
  del temp_password.
- ``User.first_login = true``.
- ``User.password_changed_at = NOW()``.
- Todas las Sessions del User con state ACTIVE
  pasan a CLOSED con
  ``close_reason='PASSWORD_RESET'``.
- 1 ``InternalMessage`` en el buzon del User
  con subject "Contrasena temporal" y body con
  la contrasena (texto plano dentro del buzon
  por necesidad operativa — el buzon esta
  encriptado en reposo).
- 1 ``AuditEvent`` con
  ``event_type='PASSWORD_RESET'``,
  ``actor_user_id=admin``,
  ``payload={target_user_id, ip, user_agent}``.
- Frontend muestra confirmacion al admin SIN
  mostrar la contrasena temporal.

2.4.2 Postcondiciones de fallo
------------------------------

- Si EX-01..EX-05: rollback completo;
  ``User`` y Sessions intactos; sin
  InternalMessage; sin AuditEvent
  PASSWORD_RESET (puede haber AuditEvent
  PASSWORD_RESET_FAILED segun politica).

2.4.3 Postcondiciones secundarias
---------------------------------

- El proximo login del User afectado
  (UC_AUTH_01) detectara ``first_login=true``
  y disparara FA-01: cambio obligatorio de
  contrasena (UC_AUTH_04).
- Cualquier intento de usar tokens previos del
  User responde 401 (Sessions CLOSED + tokens
  blacklisteados al cerrar Session).
