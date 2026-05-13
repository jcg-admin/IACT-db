.. _uc-acc-01-parte-01:

============================================
Parte 1 — Informacion general de UC_ACC_01
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_ACC_01
 * - **Nombre**
   - Asignar Funciones a Usuario
 * - **Version spec**
   - 5.0.0 (12-partes)
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - CRITICA
 * - **Modulo**
   - MOD_Access
 * - **WP origen**
   - ``2026-05-01-17-55-31-uc-acc-01-spec-completa``

1.2 Proposito
=============

UC_ACC_01 permite asignar **funciones RBAC
individuales** a un User: cada asignacion
otorga una capacidad atomica (ej.
``view_users``, ``modify_users``,
``deactivate_users``). El UC garantiza que
toda asignacion respeta:

- **BR-006 (RBAC Flat NIST)**: las funciones
  son atomicas, no jerarquicas.
- **BR-007 (Separacion de Funciones)**:
  ninguna asignacion crea conflicto SoD per
  las reglas vigentes.
- **BR-008 (Permisos con Vencimiento)**:
  permite asignacion temporal con
  ``expires_at``.
- **CNST-005**: enforcement de SoD en tiempo
  de asignacion.

A diferencia de UC_ACC_04 (asignar AGR
completo), este UC opera a nivel de funcion
individual — granularidad maxima.

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- Asignacion de 1..N funciones a un User en
  una sola invocacion.
- Validacion de existencia y estado activo de
  cada funcion.
- Validacion de existencia y estado del User
  destino (ACTIVE/INACTIVE permitido,
  ELIMINATED/BLOCKED no).
- Validacion SoD por cada funcion contra el
  conjunto actual de funciones del User.
- Asignacion temporal opcional (``expires_at``).
- Idempotencia: re-asignar funcion ya activa
  retorna 200 sin duplicar.
- AuditEvent ``FUNCTIONS_ASSIGNED`` con
  detalle por funcion.

1.3.2 OUT (excluido)
--------------------

- Revocacion → UC_ACC_02.
- Asignacion masiva via AGR → UC_ACC_04
  (asigna 1 AGR que internamente contiene N
  funciones).
- Permisos excepcionales fuera del modelo RBAC
  estandar → UC_PERM_03.
- Creacion de funciones nuevas → UC_PERM_05
  (custom AGRs / functions).
- Configuracion de reglas SoD → UC_ACC_05.

1.3.3 Posicion en el flujo
--------------------------

UC_ACC_01 es **operacion administrativa
continua**. Disparadores tipicos:

- Onboarding parcial (UC_USR_01 + asignaciones
  selectivas si AGR predefinido no calza).
- Cambio de rol del User (asignar funciones
  nuevas + UC_ACC_02 para revocar las
  anteriores).
- Compliance reviews (re-asignar/revocar
  segun politica).

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
     (BReq-004)
 * - **BRQ legacy**
   - BRQ-ACC-001 → BReq-004 (mapping)
 * - **Reglas de Negocio**
   - BR-006 (RBAC Flat NIST), BR-007 (SoD),
     BR-008 (Permisos con Vencimiento),
     BR-010 (Auditoria Inmutable), BR-USR-* y
     BR-ACC-* legacy del monolitico —
     formalizar en WP futuro.
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-005 enforcement SoD en tiempo de
     asignacion;
     CNST-009 autenticacion DRF;
     CNST-013 manejo estandarizado;
     CNST-025 auditoria inmutable;
     CNST-026 sin PII en payload.
 * - **Funcion RBAC (canonica)**
   - ``assign_functions`` — la dependencia
     del UC es la funcion, no un AGR
     especifico.
 * - **AGR de conveniencia**
   - AGR-006 user_admin_group contiene esta
     funcion en el catalogo predefinido. AGRs
     custom (creados via UC_PERM_05) tambien
     pueden contenerla.
 * - **UC Relacionados**
   - UC_ACC_02 (revocar — operacion inversa),
     UC_ACC_03 (consultar permisos efectivos),
     UC_ACC_04 (asignar AGR — masivo via
     agrupador), UC_ACC_05 (configurar SoD —
     reglas que este UC valida),
     UC_ACC_08 (permiso temporal especifico),
     UC_ACC_09 (auditar cambios).
 * - **Clase primaria**
   - ``Assignment`` (escritura — N inserts)
 * - **Clases secundarias**
   - ``User`` (lectura),
     ``Function`` (lectura),
     ``SoDRule`` (lectura — validacion),
     ``AuditEvent`` (escritura).
