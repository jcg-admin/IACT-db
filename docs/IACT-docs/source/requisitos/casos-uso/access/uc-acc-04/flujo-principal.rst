.. _uc-acc-04-parte-03:

==========================================
Parte 3 — Flujo principal (Camino feliz)
==========================================

3.1 Resumen del flujo
=====================

::

   PASO 1   Invoker selecciona AGR + User      (Frontend)
   PASO 2   Define expires_at opcional          (Frontend)
   PASO 3   Modal de confirmacion               (Frontend)
   PASO 4   POST /api/users/{user_id}/
            access-groups/                       (FE → BE)
   PASO 5   Validar JWT (CNST-009)              (Backend)
   PASO 6   Validar funcion
            assign_function_groups              (Backend)
   PASO 7   Validar User destino                (Backend → BD)
   PASO 8   Validar P-11 anti-self
            (configurable)                       (Backend)
   PASO 9   Validar AGR existe + ACTIVE         (Backend → BD)
   PASO 10  Verificar idempotencia
            (AGR ya asignado ACTIVE?)            (Backend → BD)
   PASO 11  Expandir funciones del AGR          (Backend → BD)
   PASO 12  Validar SoD del conjunto
            efectivo resultante                  (Backend → BD)
   PASO 13  INSERT Assignment AGR                (Backend → BD)
   PASO 14  Invalidar cache de permisos         (post-COMMIT)
   PASO 15  Emitir AuditEvent AGR_ASSIGNED      (Backend → BD)
   PASO 16  (Opcional) InternalMessage al User  (Backend → BD)
   PASO 17  201 Created con resumen             (BE → FE)
   PASO 18  Frontend confirma                    (Frontend)

3.2 Detalle paso a paso
=======================

PASO 4 — Request
----------------

.. code-block:: http

   POST /api/users/42/access-groups/ HTTP/1.1
   Host: iact.example.com
   Authorization: Bearer eyJhbGc...
   Content-Type: application/json

.. code-block:: json

   {
     "access_group_id": 6,
     "expires_at": "2026-12-31T23:59:59Z"
   }

PASO 9 — Validar AGR
--------------------

``AccessGroupRepository.get(agr_id)``;
verificar ``state == ACTIVE``. Si no existe,
EX-04. Si inactivo, EX-05.

PASO 10 — Idempotencia
----------------------

``AssignmentRepository.exists_active(
user=target, target_type='AccessGroup',
target_id=agr_id)``. Si exists, FA-01 (NOOP).

PASO 11 — Expandir funciones
----------------------------

``AGRRepository.list_functions(agr_id)``.

PASO 12 — Validar SoD
---------------------

``current_effective`` = funciones efectivas
actuales del User (UC_ACC_03 internamente).
``effective_post_assign`` =
``current_effective ∪ agr_functions``.
``SoDValidator.validate(effective_post_assign,
sod_rules)``. Si viola, EX-08.

**Important**: el SoD se evalua sobre el
**conjunto efectivo de funciones**, no sobre
el AGR como entidad (porque el conflicto SoD
es entre funciones).

PASO 13 — INSERT Assignment AGR
-------------------------------

::

   Assignment.create(
     user_id=target.id,
     target_type='AccessGroup',
     target_id=agr_id,
     state='ACTIVE',
     granted_at=NOW(),
     granted_by_admin_id=invoker.id,
     expires_at=payload.expires_at)

PASOS 14-16: idem UC_ACC_01 (cache, audit,
notify).

3.3 Atomicidad
==============

PASOS 13, 15, 16 atomicos. Cache invalidate
post-COMMIT (P-29).
