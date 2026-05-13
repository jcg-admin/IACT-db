.. _uc-usr-02-parte-01:

============================================
Parte 1 — Informacion general de UC_USR_02
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_USR_02
 * - **Nombre**
   - Consultar Usuarios
 * - **Version spec**
   - 5.0.0
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - MEDIO
 * - **Modulo**
   - MOD_Users
 * - **WP origen**
   - ``2026-05-01-16-48-17-uc-usr-02-spec-completa``

1.2 Proposito
=============

UC_USR_02 expone dos sub-operaciones de lectura:

- **Listar** Users con filtros, ordenamiento y
  paginacion.
- **Ver detalle** de un User (incluyendo
  Assignments, AGRs vigentes, ultimo login).

Es la base para operaciones administrativas
posteriores: el admin localiza un User y luego
ejecuta UC_USR_03 (modificar), UC_USR_04
(eliminar), UC_AUTH_03 (resetear contrasena),
UC_AUTH_05 (cerrar sesiones), UC_ACC_*
(asignar permisos).

Tambien sustenta auditoria: el auditor (AGR-008)
investiga el estado de Users sospechosos.

1.3 Alcance
===========

1.3.1 IN (incluido)
-------------------

- GET de lista paginada de Users con filtros
  (state, AGR, fecha de creacion, busqueda
  fuzzy en username/email/nombre).
- GET de detalle de un User especifico.
- Restriccion de campos sensibles segun nivel
  de privilegio del invocante.
- Paginacion estandar (page, page_size).
- Ordenamiento por columna.

1.3.2 OUT (excluido)
--------------------

- Creacion — UC_USR_01.
- Modificacion — UC_USR_03.
- Eliminacion — UC_USR_04.
- Vista del propio perfil del User logueado —
  UC_USR_07 (perfil propio, separado).
- Exportacion masiva — UC_RPT_* (reporting).

1.3.3 Posicion en el flujo
--------------------------

UC_USR_02 es **operacion de lectura
administrativa continua**, sustenta:

- Investigacion / triage por admin o auditor.
- Localizacion de target para operaciones
  CRUD posteriores.
- Auditoria de estado del cluster USR.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq satisfecho**
   - :doc:`/requisitos/business-requirements/breq-004-cumplimiento-seguridad-auditoria`
     (BReq-004)
 * - **BRQ legacy**
   - BRQ-USR-009 → BReq-004 (mapping)
 * - **Reglas de Negocio**
   - BR-USR-10..13 (legacy del monolitico —
     formalizar en WP futuro)
 * - **Restricciones (CNST canonicas)**
   - CNST-009 autenticacion DRF;
     CNST-013 manejo estandarizado;
     CNST-025 auditoria (lecturas privilegiadas
     se auditan selectivamente — patron P-16);
     CNST-026 sin PII en payload de listado.
 * - **Funciones RBAC**
   - ``list_users`` (para listado),
     ``view_users`` (para detalle).
 * - **AGRs que tipicamente las contienen**
   - AGR-006 user_admin_group,
     AGR-008 auditor_group (lectura).
 * - **UC Relacionados**
   - UC_USR_01 (crear), UC_USR_03 (modificar),
     UC_USR_04 (eliminar), UC_AUTH_03 (reset),
     UC_AUTH_05 (gestionar sesiones — patron
     analogo).
 * - **Clase primaria**
   - ``User`` (lectura)
 * - **Clases secundarias**
   - ``Assignment``, ``AccessGroup`` (lectura)
