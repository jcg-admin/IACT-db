.. _uc-acc-08-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_08
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_08
 * - **Nombre**
   - Otorgar Permiso Temporal Excepcional
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access

1.2 Proposito
=============

UC_ACC_08 cubre el caso de **acceso ad-hoc**:
otorgar funciones a un User con duracion
limitada (BR-008 + CNST-005). Diferencia con
UC_ACC_01:

- ``expires_at`` **obligatorio** (no opcional).
- ``justification`` **obligatoria**
  (auditabilidad reforzada — la operacion sale
  del flujo estandar de RBAC).
- Persiste en clase
  ``ExceptionalPermission`` separada
  (visibilidad clara en UC_ACC_03 como
  ``via_exceptional``).
- Ventana mas corta (max 30 dias por default,
  vs 1 anio en UC_ACC_01).

Casos tipicos:

- Cobertura de licencia / vacaciones de un
  admin.
- Acceso temporal de soporte tecnico a logs.
- Emergencias operativas.
- Auditorias externas con scope limitado.

1.3 Alcance
===========

1.3.1 IN
--------

- Otorgar 1..N funciones excepcionales con
  ``expires_at`` y ``justification``.
- Validacion de funciones existentes y
  ACTIVE.
- Validacion SoD (CNST-005) sobre el set
  efectivo resultante.
- Notificacion obligatoria al User
  (InternalMessage explicando funciones,
  vigencia, motivo).
- AuditEvent ``EXCEPTIONAL_PERMISSION_GRANTED``
  con metadata reforzada.

1.3.2 OUT
---------

- Asignacion permanente → UC_ACC_01.
- Revocacion antes del vencimiento → UC_ACC_02
  o UC equivalente sobre
  ExceptionalPermission.
- Configuracion SoD → UC_ACC_05.

1.3.3 Posicion en el flujo
--------------------------

Caso especial. Tipicamente disparado por:

- Solicitud documentada (ticket).
- Aprobacion de jefatura (politica externa
  al sistema, pero la justification debe
  referenciar el ticket).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-ACC-008
 * - **Reglas**
   - BR-007 SoD, BR-008 Permisos con
     Vencimiento, BR-010 Auditoria
 * - **CNST**
   - CNST-005, CNST-009/013/025/026
 * - **Funcion RBAC**
   - ``grant_exceptional_permission``
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group y AGR de
     compliance la contienen.
 * - **UCs relacionados**
   - UC_ACC_01, UC_ACC_02, UC_ACC_03,
     UC_ACC_05.
 * - **Clase primaria**
   - ``ExceptionalPermission``
 * - **Clases secundarias**
   - ``User``, ``Function``, ``SoDRule``,
     ``InternalMessage``, ``AuditEvent``
