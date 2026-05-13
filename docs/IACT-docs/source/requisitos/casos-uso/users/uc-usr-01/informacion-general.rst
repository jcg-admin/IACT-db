.. _uc-usr-01-parte-01:

============================================
Parte 1 — Informacion general de UC_USR_01
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_USR_01
 * - **Nombre**
   - Crear Usuario
 * - **Version spec**
   - 5.0.0
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - ALTO
 * - **Modulo**
   - MOD_Users
 * - **WP origen**
   - ``2026-05-01-16-36-56-uc-usr-01-spec-completa``

1.2 Proposito
=============

UC_USR_01 permite que un administrador con AGR-006
**de alta una nueva cuenta de usuario**. La cuenta
queda en estado ``ACTIVE`` con
``first_login=true``, y la contrasena temporal
se entrega exclusivamente al
``InternalMailbox`` del nuevo User.

Desde la perspectiva del admin, el proposito es
dar acceso al sistema a una nueva persona —
operador, supervisor, auditor — sin compartir
credenciales por canales externos.

Desde el sistema:

- Generar ``username`` automatico per CNST-029
  (formato ``nombre.apellido.NNNN``).
- Generar contrasena temporal segura (12+ chars
  mixtos).
- Hashear bcrypt cost 12.
- Crear ``User`` y opcionalmente asignar
  ``AccessGroup`` (AGR-001..010) inicial.
- Emitir ``InternalMessage`` con username +
  contrasena temporal.
- Emitir ``AuditEvent USER_CREATED``.

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- Validacion de funcion RBAC ``create_users``.
- Validacion de email unico (BR-USR-03).
- Generacion de username automatico (CNST-029).
- Generacion de contrasena temporal segura.
- Hash bcrypt cost 12 + persistencia.
- Asignacion opcional de AGR inicial.
- Emision de InternalMessage al nuevo User con
  credenciales (CNST-001 + CNST-002).
- AuditEvent USER_CREATED con admin creador.

1.3.2 OUT (excluido)
--------------------

- Modificacion de usuario — UC_USR_03.
- Eliminacion / desactivacion — UC_USR_04.
- Asignacion granular de funciones (no via AGR)
  — UC_ACC_01 / UC_PERM_*.
- Reset de contrasena de usuario existente —
  UC_AUTH_03.
- Self-service signup — NO existe en IACT
  (CNST-001 prohibe canales externos para
  identificacion).

1.3.3 Posicion en el flujo
--------------------------

UC_USR_01 es **operacion administrativa**
upstream. Su salida (User con first_login=true)
alimenta:

- UC_AUTH_01 (primer login) → FA-01 (first_login)
  → UC_AUTH_04 (cambio obligatorio).
- UC_ACC_01 / UC_PERM_* (asignacion adicional de
  permisos).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
     (BReq-004)
 * - **BRQ legacy**
   - BRQ-USR-001 → mapeado a BReq-004 (ver index
     BReq § Mapping)
 * - **Reglas de Negocio**
   - BR-USR-01..06 (legacy del UC monolitico —
     formalizar en WP futuro de armonizacion BR)
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-001 prohibicion email/SMTP;
     CNST-002 buzon obligatorio;
     CNST-009 autenticacion DRF;
     CNST-013 manejo estandarizado;
     CNST-025 auditoria inmutable;
     CNST-026 sin PII;
     CNST-029 username autogenerado +
     first_login.
 * - **Funcion RBAC**
   - ``create_users`` (incluida en AGR-006
     user_admin_group).
 * - **UC Relacionados**
   - UC_AUTH_01 (login con first_login),
     UC_AUTH_03 (admin reset analogo),
     UC_AUTH_04 (cambio post first_login),
     UC_USR_03 (modificar),
     UC_ACC_01 (asignar funciones adicionales).
 * - **Clase primaria**
   - ``User``
 * - **Clases secundarias**
   - ``Assignment``, ``AccessGroup``,
     ``InternalMailbox``, ``AuditEvent``
