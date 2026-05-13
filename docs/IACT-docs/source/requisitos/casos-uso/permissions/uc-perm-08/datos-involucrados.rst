.. _uc-perm-08-parte-07:

================================
Parte 7 — Datos involucrados
================================

7.1 Entidades leidas
====================

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Entidad
   - Uso
 * - **User**
   - validar autenticacion
 * - **Function (registry)**
   - listado + metadata jerarquica
 * - **ExceptionalPermission**
   - via UC_PERM_07 bulk
 * - **Assignment**
   - via UC_PERM_07 bulk
 * - **AccessGroup**
   - via UC_PERM_07 bulk
 * - **AccessGroupFunction**
   - via UC_PERM_07 bulk
 * - **MenuCache**
   - lookup / write

7.2 Entidades escritas
======================

NINGUNA.

7.3 FunctionRegistry — metadata adicional
=========================================

Para que UC_PERM_08 funcione, la entidad
``Function`` tiene campos adicionales
(extension del modelo de UC_PERM_07):

.. list-table::
 :widths: 30 30 40
 :header-rows: 1

 * - Campo
   - Tipo
   - Descripcion
 * - menu_visible
   - bool
   - true si aparece en menu
 * - menu_domain
   - string
   - vistas / administracion / ...
 * - menu_section
   - string
   - dashboards / users / ...
 * - menu_action
   - string
   - view / edit / export / ...
 * - menu_label_es
   - string
   - texto en español
 * - menu_label_en
   - string
   - texto en ingles
 * - menu_icon
   - string
   - identificador iconografico
 * - menu_order
   - int
   - orden dentro de section

7.4 Modelo de cache
===================

Key:

::

   menu:{user_id}:{locale}

Value:

::

   {
     domains: [...arbol completo...],
     allowed_codes_count: int,
     written_at: timestamp
   }

TTL: 300s. Invalidate via evento.

7.5 Datos NO involucrados
=========================

- AuditEvent — no se emite.
- PII detallada — no necesaria.
