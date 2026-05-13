.. _uc-acc-02-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_02
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_02
 * - **Nombre**
   - Revocar Funciones de Usuario
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access
 * - **WP**
   - ``2026-05-01-18-07-06-uc-acc-02-spec-completa``

1.2 Proposito
=============

UC_ACC_02 quita funciones RBAC previamente
asignadas a un User. La operacion es **soft**:
no hay DELETE fisico — los Assignments
correspondientes transicionan de
``state='ACTIVE'`` a ``state='REVOKED'`` con
metadata de quien revoco y por que (BR-009).

Operacion **inversa** de UC_ACC_01. Disparadores
tipicos:

- Cambio de rol del User (revocar permisos
  obsoletos).
- Compliance review (revocar permisos no
  utilizados).
- Resolucion de conflicto SoD (revocar una de
  las funciones en conflicto).
- Reduccion de privilegios temporal.

1.3 Alcance
===========

1.3.1 IN
--------

- Revocacion de 1..N funciones de un User en
  una sola invocacion.
- Especificacion de ``revoke_reason``
  obligatorio (auditabilidad).
- Idempotencia: revocar funcion ya REVOKED es
  no-op.
- Anti-lockout warning: si la revocacion deja
  al User sin funcion administrativa critica
  para si mismo (segun politica) o sin
  ninguna funcion, response incluye warning.
- AuditEvent FUNCTIONS_REVOKED.

1.3.2 OUT
---------

- Asignacion → UC_ACC_01.
- Revocacion masiva via AGR → UC_ACC_04
  (revocar AGR completo internamente revoca
  todas sus funciones).
- Eliminacion fisica de Assignments — prohibida
  (BR-009).
- Revocacion de permisos excepcionales
  (UC_PERM_*).

1.3.3 Posicion en flujo
-----------------------

UC_ACC_02 es **operacion administrativa
continua**. Tipicamente se invoca:

- Despues de UC_USR_03 (cambio de rol del User)
  para limpiar permisos previos.
- Antes de UC_ACC_01 cuando hay conflicto SoD
  (revocar primero una funcion, luego asignar
  la nueva).
- Como parte de UC_USR_04 (eliminacion del User)
  — internamente revoca todos sus Assignments.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **BRQ legacy**
   - BRQ-ACC-002 → BReq-004
 * - **Reglas de Negocio**
   - BR-006 (RBAC Flat NIST), BR-009 (Bajas
     Logicas), BR-010 (Auditoria Inmutable),
     BR-ACC-* legacy.
 * - **Restricciones (CNST canonicas)**
   - CNST-009 autenticacion;
     CNST-013 manejo estandar;
     CNST-025 audit inmutable;
     CNST-026 sin PII en payload.
 * - **Funcion RBAC (canonica)**
   - ``revoke_functions``
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group la contiene en
     el catalogo predefinido. AGRs custom
     pueden contenerla.
 * - **UC Relacionados**
   - UC_ACC_01 (asignar — inverso),
     UC_ACC_03 (consultar permisos efectivos),
     UC_ACC_04 (revocar AGR completo),
     UC_ACC_09 (auditar cambios),
     UC_USR_04 (eliminacion — invoca
     internamente).
 * - **Clase primaria**
   - ``Assignment`` (escritura — UPDATE state)
 * - **Clases secundarias**
   - ``User`` (lectura),
     ``Function`` (lectura),
     ``AuditEvent`` (escritura).
