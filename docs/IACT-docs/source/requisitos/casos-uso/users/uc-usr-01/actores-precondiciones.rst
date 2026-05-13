.. _uc-usr-01-parte-02:

============================================================
Parte 2 — Actores, precondiciones y postcondiciones
============================================================

2.1 Actor Principal
===================

**Admin con AGR-006 user_admin_group** — User
con Assignment activo a la funcion
``create_users`` via AGR-006.

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Tipo**
   - Persona (humano)
 * - **Iniciador**
   - SI
 * - **Beneficiario directo**
   - NO — el beneficiario es el nuevo User
 * - **Responsabilidad**
   - presentar token valido; ingresar datos
     correctos del nuevo User; seleccionar AGR
     inicial apropiado

2.2 Actores Secundarios
=======================

2.2.1 Nuevo User (creado)
-------------------------

Receptor pasivo durante el flujo. Posteriormente:

- Lee InternalMessage en su buzon → obtiene
  credenciales.
- Inicia sesion via UC_AUTH_01 → detectara
  first_login → forzar UC_AUTH_04.

2.2.2 Sistema (Backend Django)
------------------------------

Responsabilidades:

- Validar ``create_users`` en AGRs del admin.
- Validar email unico, formato valido.
- Generar username (CNST-029).
- Generar password temporal seguro.
- Hashear bcrypt cost 12.
- Crear User + Assignments + InternalMessage +
  AuditEvent en transaccion atomica.

2.2.3 BD MySQL
--------------

- Atomicidad ACID en pasos 11-15.
- UNIQUE constraint en ``email`` y ``username``.
- Append-only en AuditEvent (CNST-025).

2.2.4 InternalMailbox
---------------------

- Recibe el INSERT del mensaje con credenciales.
- El nuevo User las consulta al primer login.

2.2.5 Frontend (React)
----------------------

- Pagina de creacion con form (visible solo con
  AGR-006).
- Validaciones client-side (email format).
- NO muestra la contrasena temporal generada al
  admin.

2.2.6 Auditor (beneficiario indirecto)
--------------------------------------

Consume AuditEvent USER_CREATED para detectar:

- Volumen de creaciones por admin.
- Patrones anomalos (creacion masiva fuera de
  horario, etc.).

2.3 Precondiciones
==================

2.3.1 Sistema disponible
------------------------

- Backend respondiendo en ``/api/users/``.
- BD MySQL accesible.
- HTTPS configurado.

2.3.2 Admin autenticado y autorizado
------------------------------------

- Session ACTIVE del admin.
- Funcion ``create_users`` (via AGR-006).

2.3.3 Datos de entrada validos
------------------------------

- ``nombre``, ``apellido``: no vacios.
- ``email``: formato valido,
  unico (no existente en sistema).
- ``access_group_id``: opcional, existente y
  activo.

2.4 Postcondiciones
===================

2.4.1 Postcondiciones de exito
------------------------------

- 1 nuevo ``User`` con
  ``state='ACTIVE'``,
  ``first_login=true``,
  ``password_changed_at=NOW()``,
  ``password_hash=bcrypt(temp)``,
  ``username=<generado>``.
- Si se asigno AGR: 1 ``Assignment`` activo
  (``user``, ``access_group``,
  ``granted_at=NOW()``,
  ``granted_by=admin``).
- 1 ``InternalMessage`` en buzon del nuevo User
  con subject "Bienvenido a IACT" y body con
  username + contrasena temporal.
- 1 ``AuditEvent``
  ``event_type='USER_CREATED'``,
  ``actor_user_id=admin``,
  ``payload={target_user_id, ip, user_agent,
  access_group_id, has_initial_agr}``.
- Frontend muestra confirmacion al admin con el
  username generado, **sin mostrar la
  contrasena**.

2.4.2 Postcondiciones de fallo
------------------------------

- EX-01..EX-08: rollback completo. Sin User
  creado, sin Assignment, sin InternalMessage,
  sin AuditEvent USER_CREATED. Posible
  AuditEvent USER_CREATE_FAILED.

2.4.3 Postcondiciones secundarias
---------------------------------

- El proximo login del nuevo User dispara
  UC_AUTH_01 + FA-01 (first_login=true) →
  fuerza UC_AUTH_04.
- El email queda reservado en el sistema (no
  reutilizable por otro User).
