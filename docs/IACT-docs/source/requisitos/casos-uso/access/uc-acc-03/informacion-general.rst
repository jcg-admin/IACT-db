.. _uc-acc-03-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_03
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_03
 * - **Nombre**
   - Consultar Permisos Efectivos
 * - **Version spec**
   - 5.0.0
 * - **Modulo**
   - MOD_Access
 * - **WP**
   - ``2026-05-01-18-15-47-uc-acc-03-spec-completa``

1.2 Proposito
=============

UC_ACC_03 entrega la **vista consolidada** de los
permisos efectivos de un User, agregando tres
fuentes:

1. **Funciones directas** (Assignments con
   ``state=ACTIVE`` directos sobre funciones
   atomicas — UC_ACC_01).
2. **Funciones heredadas** de los AGRs ACTIVE
   asignados al User (UC_ACC_04).
3. **Permisos excepcionales** vigentes
   (UC_PERM_03 — fuera del modelo RBAC
   estandar, con expires_at frecuente).

El UC consolida estas tres fuentes y produce un
``effective_function_set`` deduplicado con
metadata de origen por funcion (cual la otorgo).

1.3 Alcance
===========

1.3.1 IN
--------

- Consulta del set efectivo de funciones
  para un User.
- Identificacion de origen de cada funcion:
  ``direct``, ``via_agr:{agr_id}``, o
  ``exceptional:{permiso_id}``.
- Identificacion de funciones expiradas
  pendientes de purga.
- Conteo y agrupacion por categoria.
- Indicacion de violaciones SoD potenciales
  (auditoria — no bloqueo, eso es UC_ACC_01).

1.3.2 OUT
---------

- Asignacion → UC_ACC_01.
- Revocacion → UC_ACC_02.
- Asignacion masiva via AGR → UC_ACC_04.
- Configuracion SoD → UC_ACC_05.
- Permisos excepcionales → UC_PERM_03.

1.3.3 Posicion en el flujo
--------------------------

UC_ACC_03 es **operacion de lectura
administrativa continua**, sustenta:

- Decisiones operacionales (UC_ACC_01 / 02 /
  04 — admin necesita ver el estado actual
  antes de modificar).
- Compliance review.
- Triage de tickets de soporte ("¿por que el
  user X no puede hacer Y?").
- Auditoria (UC_AUD_*).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - BReq-004 Cumplimiento de Seguridad
 * - **BRQ legacy**
   - BRQ-ACC-003 → BReq-004
 * - **Reglas de Negocio**
   - BR-006 RBAC Flat NIST, BR-008 Permisos
     con Vencimiento (incluye expirados),
     BR-009 (REVOKED preservados pero NO en
     vista efectiva).
 * - **Restricciones (CNST canonicas)**
   - CNST-009 autenticacion;
     CNST-013 manejo estandar;
     CNST-025 audit selectivo (P-16);
     CNST-026 sin PII en payload.
 * - **Funcion RBAC (canonica)**
   - ``view_assignments``
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group y AGR-008
     auditor_group la contienen.
 * - **UC Relacionados**
   - UC_ACC_01 (asignar — consume vista
     antes), UC_ACC_02 (revocar),
     UC_ACC_04 (asignar AGR),
     UC_USR_02 (vista detalle del User —
     puede embeber UC_ACC_03 como sub-vista),
     UC_PERM_03 (permisos excepcionales).
 * - **Clase primaria**
   - ``Assignment`` (lectura)
 * - **Clases secundarias**
   - ``User``, ``Function``,
     ``AccessGroup``, ``ExceptionalPermission``.
