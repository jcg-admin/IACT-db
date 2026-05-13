.. _uc-perm-02-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_02
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_02
 * - **Nombre**
   - Revocar Grupo a Usuario (vista PERM)
 * - **UC backing**
   - UC_ACC_02 sobre Assignment(target_type=
     AccessGroup)
 * - **Funcion RBAC**
   - ``revoke_function_groups``

1.2 Proposito
=============

Quitar un AGR previamente asignado a un User.
``Assignment.state`` transita ACTIVE → REVOKED
preservando historial (BR-009 soft-delete).

Diferencia con UC_PERM_01 (asignacion):
operacion inversa. Diferencia con UC_ACC_02:
solo opera sobre target_type=AccessGroup
(UC_ACC_02 es generico — funciones directas).

1.3 Alcance
===========

1.3.1 IN
--------

- Revocacion de un AGR especifico de un User.
- ``revoke_reason`` obligatoria.
- Idempotencia: revocar AGR ya REVOKED es
  no-op.
- AuditEvent ``AGR_REVOKED``.
- Cache invalidate post-COMMIT.

1.3.2 OUT
---------

- Revocacion de funciones individuales →
  UC_PERM_01 inverso (UC_ACC_02 directo).
- Eliminar AGR del catalogo → UC_PERM_05.

1.3.3 Posicion en el flujo
--------------------------

Operacion de governance: admin de seguridad
revoca AGRs de Users por:

- Cambio de rol (revocar AGR previo).
- Compliance review (revocar AGRs no
  utilizados).
- Resolver conflictos SoD (UC_PERM_01 con
  AGR alternativo).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq**
   - BReq-004
 * - **Origen legacy**
   - PRIORIDAD_01 + RNF-002 — reconciliado
     a BReq-004 canonico.
 * - **Reglas**
   - BR-009 Bajas Logicas, BR-010 Auditoria.
 * - **CNST**
   - CNST-009/013/025/026 (heredados de
     UC_ACC_02).
 * - **Funcion RBAC**
   - ``revoke_function_groups``
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group
 * - **UCs relacionados**
   - UC_ACC_02 (backing), UC_PERM_01
     (asignar — inverso), UC_PERM_05/06
     (catalogo AGR).
