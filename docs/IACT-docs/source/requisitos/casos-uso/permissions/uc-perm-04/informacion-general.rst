.. _uc-perm-04-parte-01:

============================================
Parte 1 — Informacion general de UC_PERM_04
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_PERM_04
 * - **Nombre**
   - Revocar Permiso Excepcional
 * - **Funcion RBAC**
   - ``revoke_exceptional_permission``

1.2 Proposito
=============

Revocacion explicita anticipada de
ExceptionalPermissions (otorgados por
UC_PERM_03 / UC_ACC_08). Permite cierre
temprano cuando el motivo del grant ya no
aplica:

- Emergencia operativa resuelta.
- Deteccion de abuso o uso inapropiado.
- Cambio de criterio organizacional.
- Compliance review identifica riesgo.

Diferencia con expiracion natural (cron):
UC_PERM_04 transita ``state → REVOKED`` con
``revoked_at`` ≤ ``expires_at``.

1.3 Alcance
===========

1.3.1 IN
--------

- Revocacion de 1..N ExceptionalPermissions
  ACTIVE de un User.
- ``revoke_reason`` obligatoria.
- AuditEvent
  ``EXCEPTIONAL_PERMISSION_REVOKED``
  high-priority.
- InternalMessage al User OBLIGATORIO
  (consistencia con grant).
- Cache invalidate post-COMMIT.

1.3.2 OUT
---------

- Otorgar excepcionales → UC_PERM_03.
- Expirar por cron → proceso async.
- Ver excepcionales vigentes → UC_ACC_03.

1.3.3 Posicion en flujo
-----------------------

Operacion correctiva. Disparada por:

- Investigacion post-incidente.
- Resolucion temprana de motivo
  (ticket cerrado).
- Compliance review reactiva.

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
   - BR-009 Bajas Logicas, BR-010 Auditoria.
 * - **CNST**
   - CNST-009/013/025/026.
 * - **Funcion RBAC**
   - ``revoke_exceptional_permission`` (P-15
     distinta de
     ``grant_exceptional_permission``)
 * - **AGR de conveniencia**
   - AGR-006 + AGR de compliance
 * - **UCs relacionados**
   - UC_PERM_03 / UC_ACC_08 (grant —
     inverso), UC_ACC_03 (vista efectiva),
     proceso async de expiracion.
