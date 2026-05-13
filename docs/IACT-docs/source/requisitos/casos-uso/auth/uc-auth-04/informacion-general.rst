.. _uc-auth-04-parte-01:

============================================
Parte 1 — Informacion general de UC_AUTH_04
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_AUTH_04
 * - **Nombre**
   - Cambiar Contrasena
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
   - ``2026-05-01-07-52-23-uc-auth-04-spec-completa``

1.2 Proposito
=============

UC_AUTH_04 permite que un ``User`` autenticado
**cambie su propia contrasena** ingresando la
contrasena actual y proponiendo una nueva.

Tres modos de invocacion:

- **Voluntario**: el User decide rotar su
  contrasena por higiene de seguridad.
- **Obligatorio post-creacion / post-reset**:
  ``User.first_login = true`` (UC_USR_01 o
  UC_AUTH_03 lo dejaron asi). UC_AUTH_01
  detecta y dispara FA-01 → fuerza UC_AUTH_04
  antes de habilitar la sesion plena.
- **Obligatorio por expiracion**: politica de
  rotacion (definida en ADR de password
  policy). UC_AUTH_01 emite warning cuando se
  acerca y bloquea cuando se cumple.

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- Validacion de contrasena actual (no se
  permite cambiar sin demostrar conocimiento
  de la actual).
- Validacion de complejidad de la nueva
  contrasena (longitud, charset, no en
  diccionario).
- Verificacion de historial: la nueva no debe
  coincidir con las ultimas N (N=5 por
  default).
- Hash bcrypt cost 12 y persistencia.
- Actualizacion de ``first_login=false``
  (cuando aplica).
- Almacenamiento de la nueva entrada en
  ``PasswordHistory``.
- Cierre opcional de OTRAS Sessions del User
  (politica configurable).
- AuditEvent ``PASSWORD_CHANGED``.

1.3.2 OUT (excluido)
--------------------

- Reset administrativo — UC_AUTH_03.
- Recuperacion sin conocer la actual — no
  existe en IACT (CNST-001 prohibe canales
  externos para recuperacion).
- Cambio para terceros — UC_USR_03 (admin) o
  UC_AUTH_03.
- Verificacion 2FA — fuera del scope de v1.

1.3.3 Posicion en el flujo
--------------------------

UC_AUTH_04 es **convergencia** de varios flujos:

- UC_AUTH_01 + FA-01 (first_login true) →
  UC_AUTH_04
- UC_AUTH_03 (admin reset) → primer login →
  UC_AUTH_04
- UC_USR_01 (creacion) → primer login →
  UC_AUTH_04
- Voluntario standalone

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq origen**
   - BRQ-AUTH-004 — el sistema debe permitir al
     usuario cambiar su contrasena.
 * - **Reglas de Negocio**
   - BR-AUTH-30 (validar actual), BR-AUTH-31
     (complejidad), BR-AUTH-32 (no reuso N),
     BR-AUTH-33 (cierre other sessions),
     BR-AUTH-34 (first_login=false).
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-003 sesiones persistidas en BD;
     CNST-009 autenticacion DRF; CNST-013
     manejo estandarizado; CNST-025 auditoria
     inmutable; CNST-026 sin PII en payload.
 * - **Funcion RBAC**
   - sesion propia (no requiere AGR
     especifico).
 * - **UC Relacionados**
   - UC_AUTH_01 (FA-01 dispara este UC),
     UC_AUTH_03 (admin reset que crea
     first_login=true).
 * - **Clase de Dominio primaria**
   - ``User``
 * - **Clases secundarias**
   - ``PasswordHistory``, ``Session``,
     ``AuditEvent``
