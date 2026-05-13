.. _uc-perm-03-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_03
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_03
 * - **Nombre**
   - Conceder Permiso Excepcional (vista PERM)
 * - **UC backing**
   - UC_ACC_08
 * - **Funcion RBAC**
   - ``grant_exceptional_permission``

1.2 Proposito
=============

Otorgar funciones temporales con
``expires_at`` y ``justification``
obligatorios desde la vista PERM. Caso de uso
de governance — admin de seguridad / compliance
maneja accesos ad-hoc.

Diferencia vs UC_PERM_01 (asignacion AGR):
UC_PERM_03 trabaja a nivel de **functions
individuales** con expiracion forzada vs
UC_PERM_01 que asigna AGR completo
(permanentes por default).

1.3 Alcance
===========

1.3.1 IN
--------

- Otorgar 1..N funciones excepcionales con
  ``expires_at`` (1h-30d) y
  ``justification`` (≥ 20 chars) obligatorios.
- Validacion SoD write-time (CNST-005).
- Mailbox-or-abort HARD (P-10).
- AuditEvent EXCEPTIONAL_PERMISSION_GRANTED.

1.3.2 OUT
---------

- Asignacion permanente → UC_PERM_01.
- Revocacion de excepcional → UC_PERM_04.
- Configuracion del catalogo de funciones →
  UC_PERM_05/06.

1.3.3 Posicion en el flujo
--------------------------

Disparado por solicitud documentada
(ticket). Audiencia: admin de seguridad,
compliance officer.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **Origen legacy**
   - PRIORIDAD_01 + RNF-002
 * - **Reglas**
   - BR-007 SoD, BR-008 Permisos con
     vencimiento, BR-010 Auditoria
 * - **CNST**
   - CNST-005, CNST-009/013/025/026
 * - **Funcion RBAC**
   - ``grant_exceptional_permission``
 * - **AGR de conveniencia**
   - AGR-006 + AGR de compliance
 * - **UCs relacionados**
   - UC_ACC_08 (backing), UC_PERM_04
     (revocar excepcional), UC_ACC_03 (vista
     efectiva incluye estos permisos).
