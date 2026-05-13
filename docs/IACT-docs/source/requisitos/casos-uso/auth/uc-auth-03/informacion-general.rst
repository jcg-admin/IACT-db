.. _uc-auth-03-parte-01:

============================================
Parte 1 — Informacion general de UC_AUTH_03
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_AUTH_03
 * - **Nombre**
   - Recuperar Contrasena
 * - **Version spec**
   - 5.0.0 (estructura 12-partes)
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - ALTO
 * - **Modulo**
   - MOD_Auth
 * - **WP origen**
   - ``2026-05-01-07-43-53-uc-auth-03-spec-completa``

1.2 Proposito
=============

UC_AUTH_03 permite que un administrador con
funcion RBAC ``reset_password`` (granted via
``AGR-006 user_admin_group``) **genere una
contrasena temporal** para un ``User`` que
olvido su contrasena.

Desde la perspectiva del administrador, el
proposito es **desbloquear el acceso del usuario
sin compartir secrets fuera del sistema** — la
nueva contrasena no transita por email, SMS,
chat o llamada telefonica; aparece en el buzon
interno del usuario (``InternalMailbox``).

Desde el sistema, el proposito es:

- Sobrescribir ``User.password_hash`` con la
  contrasena temporal hasheada con bcrypt cost
  12.
- Marcar ``User.first_login = true`` para
  forzar UC_AUTH_04 (cambiar contrasena) en el
  proximo login.
- Cerrar todas las Sessions activas del usuario
  (CNST-004 + invalidacion preventiva).
- Emitir ``InternalMessage`` con la contrasena
  temporal (CNST-002 obligatorio; CNST-001
  prohibe canales externos).
- Emitir ``AuditEvent PASSWORD_RESET``
  (CNST-025).

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- Validacion de funcion RBAC ``reset_password``
  del admin invocador.
- Validacion de que el ``User`` destino existe y
  no esta ELIMINADO.
- Generacion de contrasena temporal segura (12+
  caracteres, mixta, no diccionario).
- Hash bcrypt cost 12 y persistencia.
- Cierre forzado de Sessions activas del User
  destino.
- Emision de InternalMessage al User destino con
  la contrasena temporal.
- AuditEvent PASSWORD_RESET con admin y User
  destino.

1.3.2 OUT (excluido)
--------------------

- Cambio voluntario de contrasena por el propio
  usuario — eso es UC_AUTH_04.
- Auto-reset (admin reseteandose a si mismo) —
  prohibido (EX-03).
- Recuperacion via "preguntas secretas",
  "magic link" por email, codigos OTP por SMS —
  todos prohibidos por CNST-001.
- Notificacion al admin via canal externo —
  CNST-001 aplica.

1.3.3 Posicion en el flujo
--------------------------

UC_AUTH_03 es un UC de **operacion administrativa**
que produce el estado inicial para que el User
afectado pueda re-ingresar via UC_AUTH_01 +
UC_AUTH_04 (FA-01 first login). El user afectado
no es el actor principal — es beneficiario.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq origen**
   - BRQ-AUTH-003 — el sistema debe permitir
     recuperacion de contrasenas a traves de un
     administrador.
 * - **Reglas de Negocio**
   - BR-AUTH-20..25 (ver Parte 10 mapping
     parcial).
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-001 prohibicion email/SMTP/canal
     externo; CNST-002 buzon interno
     obligatorio; CNST-009 autenticacion DRF;
     CNST-013 manejo estandarizado; CNST-025
     auditoria inmutable.
 * - **Funcion RBAC**
   - ``reset_password`` (incluida en
     AGR-006 user_admin_group).
 * - **UC Relacionados**
   - UC_AUTH_01 (login con first_login true),
     UC_AUTH_04 (cambio obligatorio
     post-reset).
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``InternalMailbox``, ``Session``,
     ``AuditEvent``
