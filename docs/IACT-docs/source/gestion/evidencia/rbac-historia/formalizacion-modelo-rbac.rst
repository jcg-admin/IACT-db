.. meta::
 :artefacto: FORMALIZACION_MODELO_RBAC
 :tipo: Evidencia
 :dominio: gestion
 :subdominio: evidencia/rbac-historia
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================
Formalización del Modelo RBAC IACT
==================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-requisitos (Phase 1 DISCOVER — formalización
 arquitectónica). Aplica skill ``ba-elicitation``.

1. Premisa
==========

Tras decisión arquitectónica aprobada (Hipótesis 1 —
:doc:`decision-coexistencia-acc-perm`), el siguiente paso es
**formalizar el modelo RBAC IACT**: consolidar el modelo legacy
``MODELO_RBAC_IACT_v5_2_1`` (42 funciones, 10 grupos predefinidos,
3 SoD, permisos temporales) con la **implementación PERM granular**
del backend (8 modelos Django, 5 funciones SQL, menú dinámico) en
un solo modelo coherente con vocabulario unificado.

2. Objetivo
===========

Producir el modelo formal que será la **fuente de verdad** del
RBAC IACT, integrando:

1. **Filosofía** — funciones describen acciones, no títulos.
2. **Vocabulario unificado** — diccionario de términos canónico.
3. **Modelo de datos formal** — 7+ tablas backend.
4. **Catálogo cerrado** (10 grupos predefinidos AGR-001..010) +
   **catálogo abierto** (grupos creables admin).
5. **3 reglas SoD** atómicas declarativas.
6. **Permisos temporales** con justificación + vencimiento.
7. **Menú dinámico** runtime basado en capacidades del usuario.
8. **Auditoría** runtime + admin.
9. **Mapeo UCs** (ACC funcional + PERM técnico).
10. **CNSTs aplicables** del rebuild SRP.

3. Filosofía del Modelo
=======================

  **Los nombres describen QUÉ HACE, NO QUIÉN es.**

.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Anti-patrón (con pretensiones)
   - Patrón correcto (sin pretensiones)
 * - ``USERS_FULL_MANAGER`` (cargo)
   - ``manage_users`` (acción)
 * - ``SYSTEM_ADMIN`` (jerarquía)
   - ``view_audit_log + manage_sessions`` (capabilities)
 * - ``REPORT_VIEWER`` (rol)
   - ``view_reports + filter_reports`` (capabilities)

Origen: ``MODELO_RBAC_IACT_v5_2_1.md`` § 1.2.

4. Vocabulario unificado (canónico)
===================================

Reconciliación del vocabulario entre modelo legacy y PERM
granular. **Esta tabla es la fuente única de verdad** para todo
el rebuild.

.. list-table::
 :widths: 18 18 18 22 24
 :header-rows: 1

 * - Concepto
   - Término canónico
   - Término legacy v5.2.1
   - Término PERM backend
   - Definición
 * - Capacidad atómica
   - **Función**
   - Función (``functions``)
   - Capacidad (``Capacidad``)
   - Una acción concreta verificable (verbo + recurso). Ej:
     ``view_audit_log``.
 * - Conjunto agrupado de capacidades
   - **Grupo**
   - Grupo (``function_groups``)
   - GrupoPermiso (``GrupoPermiso``)
   - Set de funciones asignables como bloque. Predefinido
     (AGR-001..010) o creable.
 * - Modelo grupo → funciones
   - **Membresía**
   - ``function_group_membership``
   - ``GrupoCapacidad``
   - Tabla M2M que define qué funciones contiene cada grupo.
 * - Asignación grupo → usuario
   - **Asignación de Grupo**
   - ``user_function_group_assignments``
   - ``UsuarioGrupo``
   - Asocia un usuario con uno o más grupos.
 * - Asignación directa
   - **Asignación Directa**
   - ``user_function_assignments``
   - (parte de ``PermisoExcepcional``)
   - Asignación de capabilities individuales fuera de grupos.
 * - Override one-off
   - **Permiso Excepcional / Temporal**
   - (asignación con ``expires_at``)
   - ``PermisoExcepcional``
   - Capabilities con justificación + vencimiento ≤ 6 meses.
 * - Restricción mutual exclusion
   - **Regla SoD**
   - ``function_separation_rules``
   - (sin equivalente PERM)
   - Prohibición de tener simultáneamente funciones de A y B.
 * - Validación runtime
   - **Verificación de Permiso**
   - ``usuario_tiene_permiso()`` SQL
   - ``verificar_permiso_y_auditar()`` SQL
   - Función SQL que evalúa si un usuario tiene una capability.
 * - UI adaptativa
   - **Menú Dinámico**
   - (no existía en v5.2.1)
   - ``obtener_menu_usuario()`` SQL
   - Estructura jerárquica calculada en runtime según
     capabilities.
 * - Registro de cada acceso
   - **Auditoría runtime**
   - (no existía formalmente)
   - ``AuditoriaPermiso``
   - Registro append-only de cada verificación de permiso.

**Decisión:** documentar en :doc:`/base-cognitiva/glosario` (W-1
cross-WP debt — base-cognitiva ya cerrado v2, requiere v3 para
integrar este vocabulario).

5. Modelo de Datos formal
=========================

5.1 Diagrama conceptual (textual)
---------------------------------

::

 ┌─────────────────────┐                ┌──────────────────────┐
 │      Usuario        │                │       Función        │
 │ (django auth user)  │                │  (capability atómic) │
 └──────────┬──────────┘                └──────────┬───────────┘
            │ N:M                                  │ N:M
            ▼                                      ▼
 ┌─────────────────────────┐              ┌──────────────────────┐
 │ Asignación de Grupo     │              │ Membresía de Grupo   │
 │ (UsuarioGrupo)          │◄────N:M──────┤ (function_group_     │
 └──────────┬──────────────┘              │  membership)         │
            │ N:1                          └──────────┬───────────┘
            ▼                                         │ N:1
 ┌─────────────────────────┐                          ▼
 │         Grupo           │              ┌──────────────────────┐
 │  (function_groups +     │◄─────────────┤ Categoría del Grupo  │
 │   GrupoPermiso)         │              │ - predefinido (AGR-) │
 │                         │              │ - creable (admin)    │
 └─────────────────────────┘              └──────────────────────┘

          ┌──────────────────────┐
          │  Asignación Directa  │  ← Capability sin grupo
          │  (PermisoExcepcional)│    (con justificación + venc.)
          └──────────────────────┘

          ┌──────────────────────┐
          │      Regla SoD       │  ← Si tiene función de A,
          │  - grupo_a, grupo_b  │    no puede tener de B
          └──────────────────────┘

          ┌──────────────────────┐
          │   AuditoriaPermiso   │  ← Append-only: cada
          │  - usuario, capab.   │    verificación runtime
          └──────────────────────┘

5.2 Tablas backend (consolidado)
--------------------------------

.. list-table::
 :widths: 35 20 45
 :header-rows: 1

 * - Tabla
   - Origen
   - Propósito
 * - ``functions``
   - v5.2.1
   - Catálogo de las 42 funciones atómicas
 * - ``function_groups``
   - v5.2.1
   - Catálogo de grupos (10 predefinidos + creables)
 * - ``function_group_membership``
   - v5.2.1
   - M2M funciones-grupos
 * - ``user_function_assignments``
   - v5.2.1
   - Asignaciones directas (legacy)
 * - ``user_function_group_assignments``
   - v5.2.1
   - Asignaciones de grupos a usuarios
 * - ``function_separation_rules``
   - v5.2.1
   - 3 reglas SoD
 * - ``function_separation_rule_details``
   - v5.2.1
   - Detalle SoD (grupos A vs B)
 * - ``Capacidad`` (Django model)
   - PERM backend
   - Vista granular de función
 * - ``PermisoExcepcional``
   - PERM backend
   - Override one-off con justificación + vencimiento
 * - ``AuditoriaPermiso``
   - PERM backend
   - Audit log runtime de cada verificación
 * - ``UserFunctionAssignment`` (Django)
   - v5.2.1 (UC_ACC_08)
   - Asignaciones temporales con vencimiento

**Nota:** ``Capacidad`` ≡ ``Función`` en el modelo legacy (vista
distinta del mismo concepto). Decisión Phase 2: usar **un solo
nombre** en código y documentación (``Función``).

6. Catálogo de Funciones (42 atómicas)
======================================

Distribución por módulo (de ``MODELO_RBAC_IACT_v5_2_1`` § 3):

.. list-table::
 :widths: 18 12 10 60
 :header-rows: 1

 * - Módulo
   - Prefix
   - #
   - Ejemplos
 * - MOD_Auth
   - AUTH-NNN
   - 4
   - manage_sessions, view_active_sessions
 * - MOD_Users
   - USR-NNN
   - 10
   - create_users, modify_users, delete_users, list_users,
     view_users, unblock_users, configure_security_questions
 * - MOD_Access
   - ACC-NNN
   - 6
   - assign_functions, revoke_functions, query_permissions,
     manage_sod, manage_segments
 * - MOD_Reports
   - RPT-NNN
   - 8
   - view_reports, view_dashboard, view_kpis, view_charts,
     filter_reports, export_csv, export_excel, export_pdf
 * - MOD_Alerts
   - ALR-NNN
   - 6
   - view_alerts, configure_alerts, manage_subscriptions,
     view_alert_history
 * - MOD_Pipeline
   - PIP-NNN
   - 4
   - view_pipeline_status, view_pipeline_errors,
     view_data_availability, request_pipeline_retry
 * - MOD_Audit
   - AUD-NNN
   - 4
   - view_audit_log, search_audit_log, export_audit_log,
     generate_compliance_report
 * - MOD_Logs
   - LOG-NNN
   - 2
   - view_system_logs, search_logs
 * - **TOTAL (estado actual)**
   -
   - **42** (v5.2.1)
   - catálogo evolutivo (v5.1.1 = 44, v5.2.1 = 42 tras eliminar
     2 redundantes)

**Catálogo evolutivo:** el número exacto puede variar. El rebuild
Phase 2 debe inventariar el set vigente.

7. Catálogo de Grupos predefinidos (AGR-001..010)
=================================================

10 grupos del modelo legacy, todos con suffix ``_group`` en inglés
(v5.2.1):

.. list-table::
 :widths: 8 28 8 18 38
 :header-rows: 1

 * - ID
   - Nombre
   - # fn
   - Actor típico
   - Descripción
 * - AGR-001
   - basic_operator_group
   - 6
   - Operador
   - Visualización básica
 * - AGR-002
   - report_viewer_group
   - 8
   - Analista
   - Análisis sin exportar
 * - AGR-003
   - quality_supervisor_group
   - 11
   - Supervisor
   - Análisis + filtros + alertas
 * - AGR-004
   - data_exporter_group
   - 14
   - Data Analyst
   - Exportación autorizada
 * - AGR-005
   - alert_manager_group
   - 6
   - Gestor Alertas
   - Gestión completa alertas
 * - AGR-006
   - user_admin_group
   - 9
   - Admin Usuarios
   - Gestión identidades
 * - AGR-007
   - permission_admin_group
   - 5
   - Admin Permisos
   - Gestión RBAC
 * - AGR-008
   - auditor_group
   - 4
   - Auditor
   - Solo auditoría (SoD)
 * - AGR-009
   - pipeline_admin_group
   - 4
   - Admin Pipeline
   - Supervisión ETL
 * - AGR-010
   - system_admin_group
   - 6
   - Sysadmin
   - Administración completa

**Nota PERM:** además, admin puede crear grupos custom vía
UC_PERM_05. Los predefinidos quedan como "system groups" no
editables.

8. Reglas SoD (3 atómicas)
==========================

Origen: ``MODELO_RBAC_IACT_v5_2_1`` § 5.

.. list-table::
 :widths: 12 28 22 22 16
 :header-rows: 1

 * - ID
   - Nombre v5.2.1
   - Grupo A
   - Grupo B
   - Razón
 * - **SOD-001**
   - pipeline_audit_separation
   - Pipeline (PIP-001..004)
   - Auditoría (AUD-001..004)
   - Quien opera ETL no debe auditarlo
 * - **SOD-002**
   - user_audit_separation
   - Gestión Users críticas (USR-001/003/004/007)
   - Auditoría parcial (AUD-001..003)
   - Quien gestiona usuarios no debe auditar acciones
 * - **SOD-003**
   - access_audit_separation
   - Gestión Acceso (ACC-001/002/004)
   - Auditoría (AUD-001/002)
   - Quien gestiona acceso no debe auditar cambios

**Enforcement:** signal ``pre_save`` de ``UserGroup`` valida en
runtime y rechaza con ``ValidationError`` si la asignación crea
conflicto. Vínculo a
:doc:`/normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod`.

9. Permisos Temporales
======================

Origen: v5.2.1 § 6 + PERM ``PermisoExcepcional``.

**Restricciones:**

- Vigencia máxima: **6 meses** (180 días).
- Justificación obligatoria: mínimo **20 caracteres**.
- Revocación automática al vencer (cron diario).
- Sin auto-renovación: cada renovación = nueva justificación + nueva
  aprobación.
- Validación SoD aplica también a permisos temporales.
- Cada uso del permiso temporal genera registro en
  ``AuditoriaPermiso``.

**Mapeo a UCs:**

- UC_ACC_08 Permiso Temporal (vista admin del catálogo cerrado)
- UC_PERM_03 Conceder Permiso Excepcional (vista admin granular)
- UC_PERM_04 Revocar Permiso Excepcional

**CNST canónico:** CNST_031 (Permisos Temporales Máximo 6 Meses).

10. Menú Dinámico (CORE)
========================

Origen: PERM backend, función SQL ``obtener_menu_usuario()``.

**Algoritmo:**

::

 1. Obtener todas las capacidades del usuario:
    - Vía grupos asignados (UsuarioGrupo → GrupoCapacidad → Capacidad)
    - Vía permisos excepcionales vigentes (PermisoExcepcional)
 2. Para cada capacidad con formato "dominio.subdominio.funcion.accion":
    - Agrupar por dominio → subdominio → función → [acciones]
 3. Construir estructura jerárquica tipo árbol
 4. Retornar JSON navegable

**Endpoint:** ``GET /api/permisos/verificar/<user_id>/menu/``.

**Consumidor:** Frontend invoca al renderizar navegación (cada
sesión + on permission change).

**Mapeo a UC:** UC_PERM_08 Generar Menú Dinámico.

**CNST canónico:**
:doc:`/normativa/restricciones/cnst-032-menu-dinamico-obligatorio`.

11. Auditoría
=============

**Dual:** runtime granular + admin general.

.. list-table::
 :widths: 22 28 22 28
 :header-rows: 1

 * - Capa
   - Tabla
   - UC
   - Foco
 * - Runtime granular
   - ``AuditoriaPermiso``
   - UC_PERM_09 Auditar Acceso
   - Cada verificación de capability
 * - Admin permisos
   - (vista de ``AuditoriaPermiso``)
   - UC_PERM_10
   - Vista admin de logs PERM
 * - Cambios de acceso
   - ``AuditLog``
   - UC_ACC_09
   - Asignaciones/revocaciones
 * - Sistema general
   - ``AuditLog``
   - UC_AUD_01..04
   - Todos los eventos sensibles

**CNSTs canónicos:** CNST_025 (Auditoría Inmutable Append-Only),
CNST_026 (PII Prohibida en Logs).

**Decisión D-RBAC-3:** ``AuditoriaPermiso`` y ``AuditLog`` son
tablas separadas con foreign key a entidad raíz (Usuario), pero
**misma política inmutable**.

12. Mapeo UCs ↔ Modelo RBAC
===========================

12.1 Vista funcional (MOD_Access — admin no-tech)
-------------------------------------------------

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - UC
   - Operación en modelo
 * - UC_ACC_01 Asignar Funciones
   - INSERT en ``user_function_assignments``
 * - UC_ACC_02 Revocar Funciones
   - DELETE de ``user_function_assignments``
 * - UC_ACC_03 Consultar Permisos
   - SELECT a vista ``vista_capacidades_usuario``
 * - UC_ACC_04 Asignar Agrupador
   - INSERT en ``user_function_group_assignments`` con AGR-NNN
 * - UC_ACC_05 Gestionar SoD
   - CRUD sobre ``function_separation_rules``
 * - UC_ACC_06 Gestionar Segmentos
   - (modelo de datos separado, ortogonal al RBAC)
 * - UC_ACC_07 Asignar Segmento
   - (idem)
 * - UC_ACC_08 Permiso Temporal
   - INSERT en ``user_function_assignments`` con ``expires_at``
 * - UC_ACC_09 Auditar Cambios Acceso
   - SELECT a ``AuditLog`` filtrado por entidad

12.2 Vista técnica (MOD_Permissions — admin tech / runtime)
-----------------------------------------------------------

.. list-table::
 :widths: 35 65
 :header-rows: 1

 * - UC
   - Operación en modelo
 * - UC_PERM_01 Asignar Grupo a Usuario
   - INSERT en ``UsuarioGrupo``
 * - UC_PERM_02 Revocar Grupo
   - DELETE de ``UsuarioGrupo``
 * - UC_PERM_03 Conceder Permiso Excepcional
   - INSERT en ``PermisoExcepcional`` con justificación + venc.
 * - UC_PERM_04 Revocar Permiso Excepcional
   - UPDATE ``PermisoExcepcional`` (revocado=true)
 * - UC_PERM_05 Crear Grupo de Permisos
   - INSERT en ``function_groups`` con flag ``is_custom=true``
 * - UC_PERM_06 Asignar Capacidades a Grupo
   - INSERT en ``function_group_membership``
 * - UC_PERM_07 Verificar Permiso de Usuario
   - CALL ``usuario_tiene_permiso(user_id, capability_code)``
 * - UC_PERM_08 Generar Menú Dinámico
   - CALL ``obtener_menu_usuario(user_id)``
 * - UC_PERM_09 Auditar Acceso
   - INSERT en ``AuditoriaPermiso`` (automático)
 * - UC_PERM_10 Consultar Auditoría de Permisos
   - SELECT a ``AuditoriaPermiso`` con filtros

13. CNSTs canónicos aplicables
==============================

.. list-table::
 :widths: 18 42 40
 :header-rows: 1

 * - CNST
   - Descripción
   - Aplicable a
 * - CNST_025
   - Auditoría Inmutable Append-Only
   - AuditoriaPermiso, AuditLog
 * - CNST_026
   - PII Prohibida en Logs
   - logs SQL, JSON, audit
 * - CNST_029
   - RBAC Modelo Plano (sin jerarquía)
   - function_groups, GrupoPermiso
 * - CNST_030
   - Reglas SoD Atómicas Declarativas
   - function_separation_rules
 * - CNST_031
   - Permisos Temporales Máximo 6 Meses
   - PermisoExcepcional, user_function_assignments
 * - CNST_032
   - Menú Dinámico Obligatorio
   - frontend → ``obtener_menu_usuario()``
 * - CNST_033
   - Vocabulario Unificado RBAC
   - código + docs (función ≡ capacidad, grupo ≡ grupopermiso)

14. Decisiones D-RBAC (cerradas 2026-04-29)
===========================================

- **D-RBAC-1**: ``Capacidad`` (PERM) y ``Función`` (v5.2.1) se
  unifican en ``Función`` como término canónico.
- **D-RBAC-2**: ``UsuarioGrupo`` (PERM) y
  ``user_function_group_assignments`` (v5.2.1) son LA misma tabla.
  Unificar en migración.
- **D-RBAC-3**: ``AuditoriaPermiso`` y ``AuditLog`` separadas con
  misma política inmutable.
- **D-RBAC-4**: 10 grupos predefinidos AGR-001..010 son inmutables
  (system groups). Custom adicional vía UC_PERM_05.
- **D-RBAC-5**: Crear CNST_032 (menú dinámico obligatorio).
- **D-RBAC-6**: Crear CNST_033 (vocabulario unificado).
- **D-RBAC-7**: ``function_separation_rules`` aplican también a
  grupos custom creados vía UC_PERM_05.
- **D-RBAC-8**: Migración ``Capacidad`` → ``Función`` reemplazo
  en una sola fase (sin coexistencia).

15. Estado actual del catálogo
==============================

Estado documentado como **referencia**, no compromiso inmutable:

- **9 módulos funcionales** (Auth, Users, Access, Permissions,
  Reports, Alerts, Pipeline, Audit, Logs).
- **2 vistas del RBAC**: ACC (funcional) y PERM (técnico).
- **42 funciones atómicas** (catálogo cerrado v5.2.1, puede crecer).
- **10 grupos predefinidos** AGR-001..010 + grupos custom creables
  vía UC_PERM_05.
- **3 reglas SoD** atómicas (catálogo cerrado v5.2.1).
- **Permisos temporales** máximo 6 meses con justificación ≥ 20 ch.

16. Trazabilidad
================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``ba-elicitation`` (BABOK — Elicitation)
 * - **WP origen**
   - source-rebuild-requisitos (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **Decisión origen**
   - :doc:`decision-coexistencia-acc-perm`
 * - **ADR canónico**
   - :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
 * - **Modelo técnico**
   - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
