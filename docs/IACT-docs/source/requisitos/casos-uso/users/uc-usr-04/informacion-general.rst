.. _uc-usr-04-parte-01:

============================================
Parte 1 — Informacion general de UC_USR_04
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_USR_04
 * - **Nombre**
   - Eliminar Usuario (baja logica)
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Users
 * - **WP**
   - ``2026-05-01-17-02-53-uc-usr-04-spec-completa``

1.2 Proposito
=============

UC_USR_04 ejecuta la **baja logica** de un User:
transicion de su ``state`` a ``ELIMINATED``,
revocacion logica de todos sus Assignments (
``state → REVOKED``), cierre de sus Sessions
activas y blacklist de tokens vivos.

**Nunca hay DELETE fisico** del registro
``User`` — BR-009 (Bajas Logicas) y CNST-006
(Retencion 2 anios). El registro permanece para:

- Trazabilidad historica (auditoria de eventos
  pasados sigue resoluble).
- Reconstruccion de actividad para investigacion
  posterior.
- Cumplimiento regulatorio (retencion minima).

1.3 Alcance
===========

1.3.1 IN
--------

- Transicion ``User.state → ELIMINATED`` desde
  cualquier estado origen permitido (ACTIVE,
  INACTIVE, BLOCKED).
- Revocacion logica de TODOS los Assignments
  activos del User (``state → REVOKED``).
- Cierre de todas las Sessions ACTIVE
  (``state → CLOSED``,
  ``close_reason='USER_ELIMINATED'``) +
  blacklist de tokens vivos.
- Emision de ``AuditEvent USER_ELIMINATED`` con
  contadores (sessions_closed, assignments_revoked).
- (Opcional) InternalMessage al User notificando
  la eliminacion (politica).

1.3.2 OUT
---------

- DELETE fisico — prohibido (BR-009).
- Restauracion de un User ELIMINATED — no
  permitida en este UC. Requiere otro UC
  administrativo (``uc-usr-restore`` futuro,
  fuera del cluster actual).
- Reasignacion de datos pertenecientes al User
  (mensajes, registros) — esos quedan asociados
  al user_id ELIMINATED por integridad
  referencial.
- Cambio de estado distinto a ELIMINATED →
  UC_USR_03.

1.3.3 Posicion en flujo
-----------------------

UC_USR_04 es **operacion administrativa
terminal**. Caso de uso tipico:

- Empleado deja la organizacion definitivamente.
- Cuenta comprometida sin posibilidad de
  recuperacion.
- Incidente de seguridad que requiere "borrar"
  acceso.

Despues de UC_USR_04, el User nunca podra
volver a iniciar sesion. Cualquier intento
responde 401 (token blacklisteado, Sessions
cerradas, state inhabil).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - BReq-004 (Cumplimiento) + BReq-005
     (Integridad y Trazabilidad).
 * - **BRQ legacy**
   - BRQ-USR-003 → BReq-004 (mapping)
 * - **Reglas de Negocio**
   - BR-009 (Bajas Logicas obligatorias),
     BR-USR-30..32 (legacy — formalizar en WP
     futuro).
 * - **Restricciones (CNST canonicas)**
   - CNST-006 retencion 2 anios;
     CNST-009 autenticacion;
     CNST-013 manejo estandar;
     CNST-025 audit inmutable;
     CNST-026 sin PII.
 * - **Funcion RBAC (canonica)**
   - ``deactivate_users`` — la dependencia del
     UC es la funcion, no un AGR especifico.
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group contiene esta
     funcion en el catalogo predefinido. Otros
     AGRs pueden contenerla tambien — el UC no
     se ata a un AGR.
 * - **UC Relacionados**
   - UC_USR_03 (modificacion — alternativa
     no-terminal), UC_AUTH_05 (gestion de
     Sessions — patron similar de cierre
     masivo), UC_AUD_* (consulta historica
     post-eliminacion).
 * - **Clase primaria**
   - ``User`` (escritura state)
 * - **Clases secundarias**
   - ``Assignment`` (escritura masiva),
     ``Session`` (escritura masiva),
     ``BlacklistedToken`` (INSERT N),
     ``InternalMessage`` (opcional),
     ``AuditEvent``
