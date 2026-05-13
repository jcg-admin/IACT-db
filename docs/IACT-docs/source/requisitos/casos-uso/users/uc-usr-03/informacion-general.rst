.. _uc-usr-03-parte-01:

============================================
Parte 1 — Informacion general de UC_USR_03
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_USR_03
 * - **Nombre**
   - Modificar Usuario
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Users
 * - **WP**
   - ``2026-05-01-16-54-27-uc-usr-03-spec-completa``

1.2 Proposito
=============

UC_USR_03 expone operaciones de modificacion
sobre atributos del User:

- Datos personales: ``first_name``,
  ``last_name``, ``email``.
- Estado: transiciones permitidas entre
  ``ACTIVE``, ``INACTIVE``, ``BLOCKED``
  (no permite ``ELIMINATED`` — eso es UC_USR_04).
- Segmento operacional (CNST-008).

NO se modifica: ``username`` (CNST-029
inmutable), ``password_hash`` (UC_AUTH_03 / 04),
``Assignments`` AGR (UC_ACC_*).

1.3 Alcance
===========

1.3.1 IN
--------

- PATCH parcial sobre datos personales.
- Transicion de state con validaciones (ej.
  no auto-bloqueo, no a ELIMINATED via este UC).
- Cambio de segmento.
- Side-effect: si ``state → BLOCKED``, cerrar
  Sessions activas (UC_AUTH_05 invocado
  internamente).

1.3.2 OUT
---------

- Eliminacion logica → UC_USR_04.
- Cambio de username → no aplica (CNST-029).
- Cambio de password → UC_AUTH_03 / UC_AUTH_04.
- Cambio de AGRs → UC_ACC_*.

1.3.3 Posicion en flujo
-----------------------

Operacion administrativa continua. Tipico
gatillo: cambio organizacional (cambio de area,
licencia prolongada → INACTIVE, suspensiones →
BLOCKED).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - BReq-004
 * - **BRQ legacy**
   - BRQ-USR-002
 * - **Reglas de Negocio**
   - BR-USR-20..25 (legacy — formalizar en WP
     futuro)
 * - **Restricciones (CNST canonicas)**
   - CNST-008 segmentacion;
     CNST-009 autenticacion;
     CNST-013 manejo estandar;
     CNST-025 audit inmutable;
     CNST-026 sin PII.
 * - **Funcion RBAC**
   - ``modify_users``
 * - **AGR**
   - AGR-006 user_admin_group
 * - **UC Relacionados**
   - UC_USR_01, UC_USR_04, UC_AUTH_03/05,
     UC_ACC_*
 * - **Clase primaria**
   - ``User``
