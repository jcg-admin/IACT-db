.. _uc-acc-05-parte-07:

============================
Parte 7 — Datos involucrados
============================

7.1 Endpoints
=============

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Endpoint
   - Metodo
   - RBAC
 * - ``/api/access/sod-rules/``
   - GET
   - ``view_separation_rules``
 * - ``/api/access/sod-rules/{id}/``
   - GET
   - ``view_separation_rules``
 * - ``/api/access/sod-rules/``
   - POST
   - ``manage_separation_rules``
 * - ``/api/access/sod-rules/{id}/``
   - PATCH
   - ``manage_separation_rules``
 * - ``/api/access/sod-rules/{id}/``
   - DELETE
   - ``manage_separation_rules``

7.2 Listar — Request
====================

Query params:

- ``state`` (default ACTIVE)
- ``rule_id`` (audit P-16)
- ``includes_function_id``
- ``page``, ``page_size``
- ``ordering``

7.3 Listar — Response 200
=========================

.. code-block:: json

   {
     "count": 12,
     "next": null,
     "previous": null,
     "results": [
       {
         "id": "sod-001",
         "name": "Admin no auditor",
         "description": "modify_users no
                          coexiste con
                          audit_users",
         "function_ids": [1, 42],
         "function_codes": ["modify_users",
                             "audit_users"],
         "severity": "CRITICAL",
         "state": "ACTIVE",
         "created_at": "2026-04-15T...",
         "created_by_admin_id": 1,
         "violations_today_count": 0
       }
     ]
   }

7.4 Crear — Request
===================

.. code-block:: json

   {
     "name": "Admin no auditor",
     "description": "...",
     "function_ids": [1, 42],
     "severity": "CRITICAL"
   }

7.5 Crear — Response 201
========================

.. code-block:: json

   {
     "id": "sod-002",
     "name": "...",
     "function_ids": [1, 42],
     "state": "ACTIVE",
     "created_at": "...",
     "existing_violations_count": 0
   }

Si FA-03, response incluye
``existing_violations_count > 0`` y sample de
``violating_user_ids`` (max 10).

7.6 Modificar — Request
=======================

.. code-block:: json

   {
     "display_name": "Nuevo nombre",
     "description": "...",
     "severity": "HIGH"
   }

PATCH parcial. ``function_ids`` NO permitido
(EX-09).

7.7 Retirar — Request
=====================

.. code-block:: json

   {
     "retire_reason": "Politica de seguridad
                       cambio en 2026-Q3"
   }

7.8 Modelo de datos tocado
==========================

7.8.1 SoDRule
-------------

.. list-table::
 :widths: 30 25 45
 :header-rows: 1

 * - Campo
   - Tipo
   - Notas
 * - id
   - VARCHAR (PK)
   - generado: ``sod-NNN``
 * - name
   - VARCHAR
   - identificador legible
 * - description
   - TEXT
   - explicacion
 * - function_ids
   - JSON / Array
   - inmutable post-create (EX-09)
 * - severity
   - ENUM
   - CRITICAL / HIGH / MEDIUM / LOW
 * - state
   - ENUM
   - ACTIVE / RETIRED
 * - created_at
   - DATETIME
   - NOW() en create
 * - created_by_admin_id
   - BIGINT
   - invoker.id
 * - last_modified_at
   - DATETIME
   - PATCH update
 * - last_modified_by_admin_id
   - BIGINT
   - PATCH
 * - retired_at
   - DATETIME (nullable)
   - DELETE
 * - retired_by_admin_id
   - BIGINT (nullable)
   - DELETE
 * - retire_reason
   - VARCHAR (nullable)
   - DELETE

7.8.2 AuditEvent
----------------

::

   event_type ∈ {SOD_RULES_VIEWED,
                 SOD_RULE_CREATED,
                 SOD_RULE_MODIFIED,
                 SOD_RULE_RETIRED,
                 SOD_RULE_*_FAILED}
   payload incluye:
     - rule_id
     - changes (en MODIFIED)
     - retire_reason (en RETIRED)
     - existing_violations_count (en CREATED)
     - residual_violations_count (en RETIRED)

7.8.3 SoDRuleCache (post-COMMIT)
--------------------------------

``invalidate_active_rules()`` notifica a
consumidores (UC_ACC_01/04/PERM_03) para
recargar.

7.9 Volumetria estimada
=======================

- Reglas SoD totales: ~10-50 (catalogo
  pequeño).
- Operaciones/dia: ~0-2 (cambio infrequente).
- Lecturas/dia: ~50 (UC_ACC_01/04 cargan
  cache, refrescos periodicos).

7.10 FR derivados — preliminar
==============================

Por sub-flujo. Listado preliminar:

- FR-ACC-05-01..04: lectura (validar auth,
  query, paginar, audit selectivo).
- FR-ACC-05-05..09: crear (validar payload,
  funciones, no-duplicado, INSERT, cache,
  audit).
- FR-ACC-05-10..14: modificar (PATCH parcial,
  validar campos modificables, UPDATE, cache,
  audit).
- FR-ACC-05-15..19: retirar (validar ACTIVE,
  retire_reason, UPDATE state, cache, audit).
