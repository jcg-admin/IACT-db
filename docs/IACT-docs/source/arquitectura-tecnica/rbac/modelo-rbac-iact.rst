.. meta::
 :artefacto: MODELO_RBAC_IACT
 :tipo: Modelo Arquitectonico
 :dominio: arquitectura_tecnica
 :subdominio: rbac
 :estado: Vigente
 :version: 5.4.0
 :fecha_creacion: 2026-01-13
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Critico

.. _modelo-rbac-iact:

================
MODELO RBAC IACT
================

.. note::

 **Migrado desde** `:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`` (1793 lineas) en
 WP #7 v1 (2026-04-29). El nombre del archivo NO incluye version
 (per :doc:`/normativa/estandares/std-006-versionado-semantico`);
 la version vive en metadata (``:version: 5.2.1``).

 Este es el **modelo conceptual canonico** del RBAC IACT. Las
 reglas operativas formales viven en CNST_029, CNST_030, CNST_031
 del cajon :doc:`/normativa/restricciones/index`.



Sistema IACT - IVR Analytics Customer Tracking
===============================================

**Proyecto:** IACT-2025-001
**Documento:** IACT-RBAC-001-v5.2.1 
**Título:** Modelo de Control de Acceso Basado en Funciones Atómicas 
**Versión:** 5.2.1 - Clean Code Completo + 42 Funciones 
**Fecha:** 13 de enero de 2026 
**Estado:** Listo para Implementación

----

CONTROL DE CAMBIOS
==================



.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Versión
   - Fecha
   - Cambios
   - Autor
 * - 1.0-3.0
   - 17-18 Oct 2025
   - Versiones preliminares
   - Equipo
 * - 4.0
   - 19 Oct 2025
   - Modelo híbrido con 18 roles
   - Equipo
 * - 5.0
   - 03 Ene 2026
   - Enfoque Sin Pretensiones
   - Equipo
 * - 5.1
   - 03 Ene 2026
   - Adaptación a 8 módulos IACT
   - Equipo
 * - 5.2.0
   - 13 Ene 2026
   - Clean Code + 42 funciones + Sin segmentos
   - Equipo
 * - 5.2.1
   - 13 Ene 2026
   - Corrección: nombres funciones/grupos en INGLÉS
   - Equipo
 * - 5.3.0
   - 30 Abr 2026
   - Corrección error v5.1.1 + funciones nuevas (42 → 51 funciones)
   - NestorMonroy
 * - **5.4.0**
   - **30 Abr 2026**
   - **SRP audit + principio "no eliminar nada" + Larman + L4-SRP Logs (51 → 61 funciones)**
   - **NestorMonroy**



Cambios v5.3.0 → v5.4.0
-----------------------

Bump MAJOR motivado por hallazgos del programa
``rbac-modelo-conceptual-cleanup`` (Z.2):

1. **Auditoría SRP global** detectó violaciones de Single
   Responsibility Principle en funciones con verbo ``manage_*``
   (AUTH-001, ACC-005, ALR-008 propuesta). Resolución: split
   semántico preservando IDs cuando posible.
2. **Principio "no eliminar nada"** (BR-009 ampliada a alcance
   global) requirió rename de funciones con verbo ``delete_*``
   que en realidad implementan soft delete (``USR-003``,
   ``ALR-005``).
3. **L4-SRP MOD_Logs:** una sola función ``view_technical_logs``
   cubría 3 conceptos distintos (app + ETL + infra) violando
   SRP. Split en funciones específicas + 2 nuevas para gaps
   (health, métricas técnicas).
4. **Anti-patrón Larman** en MOD_Reports (uc-rpt-04/05/06 por
   formato) consolidado en uc-rpt-04 con flujos alternativos.
   Funciones RBAC RPT-004/005/006 preservadas para SoD por formato.
5. **Cat E suscripciones de alertas:** uc-alr-03 reconocer y
   uc-alr-05 suscripciones no tenían función backing canónica.
   Resolución: agregar ``acknowledge_alert`` + split de
   ``manage_alert_subscriptions`` en 3 funciones SRP-compliant.

.. list-table::
 :widths: 30 18 18 34
 :header-rows: 1

 * - Función v5.4.0
   - ID
   - Tipo
   - Origen
 * - ``deactivate_users``
   - USR-003
   - **RENAME**
   - era ``delete_users`` (soft delete; BR-009 global)
 * - ``view_own_sessions``
   - AUTH-001
   - **RENAME**
   - era ``manage_sessions`` (SRP — scope propio)
 * - ``view_all_active_sessions``
   - AUTH-004
   - **RENAME**
   - era ``view_active_sessions`` (SRP — scope sistema, distinción con AUTH-001)
 * - ``view_separation_rules``
   - ACC-005
   - **RENAME + SPLIT**
   - era ``manage_separation_rules`` (SRP)
 * - ``update_separation_rule``
   - ACC-011
   - NUEVA
   - SoD admin (split SRP de ACC-005)
 * - ``disable_separation_rule``
   - ACC-012
   - NUEVA
   - SoD admin toggle (split SRP de ACC-005)
 * - ``disable_alerts``
   - ALR-005
   - **RENAME**
   - era ``delete_alerts`` (toggle on/off; no eliminar)
 * - ``acknowledge_alert``
   - ALR-007
   - NUEVA
   - closed-loop alerts (uc-alr-03)
 * - ``subscribe_to_alert``
   - ALR-008
   - NUEVA
   - gestión suscripciones (uc-alr-05 FA-Subscribe)
 * - ``unsubscribe_from_alert``
   - ALR-009
   - NUEVA
   - gestión suscripciones (uc-alr-05 FA-Unsubscribe)
 * - ``configure_subscription_severity``
   - ALR-010
   - NUEVA
   - gestión suscripciones (uc-alr-05 FA-Configure)
 * - ``view_application_logs``
   - LOG-001
   - **RENAME**
   - era ``view_technical_logs`` (SRP — solo app logs)
 * - ``view_etl_logs``
   - LOG-004
   - NUEVA
   - SRP — logs ETL (uc-log-02 re-mapeo)
 * - ``view_infrastructure_logs``
   - LOG-005
   - NUEVA
   - SRP — logs infraestructura (uc-log-05 nuevo)
 * - ``view_system_health``
   - LOG-006
   - NUEVA
   - gap UC_081 ARQ-MOD-008 (uc-log-06 nuevo)
 * - ``view_technical_metrics``
   - LOG-007
   - NUEVA
   - gap UC_083 ARQ-MOD-008 (uc-log-07 nuevo)

**Total catálogo v5.4.0:** 61 funciones (+10 nuevas vs v5.3.0;
0 eliminadas; 6 renames preservando IDs).

Distribución actualizada por módulo:

::

   MOD_Auth         4 funciones (sin cambio numérico, 2 renames)
   MOD_Users        9 funciones (sin cambio numérico, 1 rename)
   MOD_Access      12 funciones (10 + 2 nuevas, 1 rename)
   MOD_Pipeline     4 funciones (sin cambio)
   MOD_Reports     11 funciones (sin cambio)
   MOD_Alerts      10 funciones (6 + 4 nuevas, 1 rename)
   MOD_Audit        4 funciones (sin cambio)
   MOD_Logs         7 funciones (3 + 4 nuevas, 1 rename)
   ────────────────────────────────────
   TOTAL          61 funciones

Cambios v5.2.1 → v5.3.0
-----------------------

Bump MAJOR motivado por dos hallazgos del programa
``modelo-rbac-improvement`` (Z.2.A deep review):

1. **Corrección de error heredado de v5.1.1:** la consolidación
   v5.1 → v5.1.1 eliminó funciones legítimas (``programa_reportes``,
   ``comparte_reportes``) sin actualizar UCs. Drift de 4 meses.
2. **Funciones nuevas** requeridas para sustentar UCs vivos del
   corpus (UC_PERM admin + features Reports/Logs).

.. list-table::
 :widths: 30 18 18 34
 :header-rows: 1

 * - Función
   - ID
   - Tipo
   - Origen
 * - ``schedule_report``
   - RPT-009
   - **RESTAURACIÓN**
   - era ``programa_reportes`` v5.0_1/v5.1
 * - ``save_view``
   - RPT-010
   - NUEVA
   - feature UI/UX (uc-rpt-10)
 * - ``share_report``
   - RPT-011
   - **RESTAURACIÓN**
   - era ``comparte_reportes`` v5.0_1/v5.1
 * - ``search_logs``
   - LOG-003
   - NUEVA
   - análogo a ``search_users`` (uc-log-03)
 * - ``create_function_group``
   - ACC-006
   - NUEVA
   - admin UC_PERM-05 (slot libre post-Z.1.C)
 * - ``assign_functions_to_group``
   - ACC-007
   - NUEVA
   - admin UC_PERM-06
 * - ``grant_exceptional_permission``
   - ACC-008
   - NUEVA
   - admin UC_PERM-03 (CNST-031)
 * - ``revoke_exceptional_permission``
   - ACC-009
   - NUEVA
   - admin UC_PERM-04
 * - ``revoke_function_group``
   - ACC-010
   - NUEVA
   - admin UC_PERM-02

**Total catálogo v5.3.0:** 51 funciones (+9 vs v5.2.1).

Distribución actualizada por módulo:

::

   MOD_Auth         4 funciones (sin cambio)
   MOD_Users        9 funciones (sin cambio)
   MOD_Access      10 funciones (5 + 5 admin nuevas)
   MOD_Pipeline     4 funciones (sin cambio)
   MOD_Reports     11 funciones (8 + 3 nuevas)
   MOD_Alerts       6 funciones (sin cambio)
   MOD_Audit        4 funciones (sin cambio)
   MOD_Logs         3 funciones (2 + 1 nueva)
   ────────────────────────────────────
   TOTAL          51 funciones

Cambios v5.2.0 → v5.2.1 (preservado por trazabilidad)
-----------------------------------------------------



.. list-table::
 :widths: 33 33 33
 :header-rows: 1

 * - Aspecto
   - v5.2.0
   - v5.2.1
 * - Nombres funciones
   - Español
   - **Inglés** (manage_sessions, view_reports)
 * - Nombres grupos
   - Español con `agr_`
   - **Inglés** sin prefijo (basic_operator_group)
 * - Nombres reglas SoD
   - Español con `sod_`
   - **Inglés** sin prefijo (pipeline_audit_separation)
 * - Consistencia
   - Parcial
   - **Completa**


----

ESTÁNDAR DE NOMENCLATURA v5.2.1
===============================



.. code-block:: text

 [OK] CÓDIGO: Inglés (clases, métodos, variables, NOMBRES DE FUNCIONES)
 [OK] COMENTARIOS: Español (docstrings, help_text, comments)
 
 NINGUNA EXCEPCIÓN - TODO el código en inglés


**Ejemplo:**

.. code-block:: python

 class FunctionGroup(models.Model):
 """Grupo de funciones que se asignan juntas.""" # ← Español
 group_id = models.CharField( # ← Inglés
 help_text="Identificador único (AGR-001)" # ← Español
 )
 name = models.CharField( # ← Inglés
 help_text="Nombre: basic_operator_group" # ← Español con ejemplo inglés
 )


----

TABLA DE CONTENIDO
==================

.. contents::
   :depth: 2
   :local:


1. FILOSOFÍA DEL MODELO
=======================



1.1 Principio Central
---------------------


   **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona**


1.2 Enfoque Sin Pretensiones
----------------------------


**[NO] INCORRECTO - Con Pretensiones:**


.. code-block:: text

 Roles basados en títulos:
 - USERS_FULL_MANAGER → Define QUÉ ES la persona
 - SYSTEM_ADMIN → Cargo jerárquico


**[OK] CORRECTO - Sin Pretensiones:**


.. code-block:: text

 Funciones basadas en acciones (INGLÉS):
 - create_users → Describe QUÉ PUEDE HACER
 - view_reports → Acción concreta
 - export_csv → Capacidad específica


----


2. ARQUITECTURA IACT
====================



2.1 Distribución de 61 Funciones (v5.4.0)
-----------------------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - Módulo
   - Código
   - Funciones
   - %
   - Propósito
 * - MOD_Auth
   - AUTH
   - 4
   - 6.6%
   - Sesiones y autenticación
 * - MOD_Users
   - USR
   - 9
   - 14.8%
   - Gestión de identidades
 * - MOD_Access
   - ACC
   - 12
   - 19.7%
   - RBAC core + SEC_RULES
 * - MOD_Pipeline
   - PIP
   - 4
   - 6.6%
   - Supervisión ETL
 * - **MOD_Reports**
   - **RPT**
   - **11**
   - **18.0%**
   - **Reportes/Dashboards**
 * - MOD_Alerts
   - ALR
   - 10
   - 16.4%
   - Alertas internas
 * - MOD_Audit
   - AUD
   - 4
   - 6.6%
   - Auditoría funcional
 * - MOD_Logs
   - LOG
   - 7
   - 11.5%
   - Logs técnicos + health + métricas
 * - **TOTAL**
   - -
   - **61**
   - **100%**
   - -


----


3. CATÁLOGO DE 61 FUNCIONES
===========================



3.1 MOD_Auth (4 funciones)
--------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - AUTH-001
   - `view_own_sessions`
   - auth:view_own_sessions
   - UC-005
   - Ve sesiones activas propias del usuario (RENAME v5.4.0 desde ``manage_sessions`` — SRP scope propio)
 * - AUTH-002
   - `close_user_session`
   - auth:close_session
   - UC-005
   - Cierra sesión de otro usuario
 * - AUTH-003
   - `reset_password`
   - auth:reset_password
   - UC-003
   - Genera contraseña temporal
 * - AUTH-004
   - `view_all_active_sessions`
   - auth:view_all_sessions
   - UC-005
   - Ve TODAS las sesiones activas del sistema (RENAME v5.4.0 desde ``view_active_sessions`` — SRP scope sistema; admin)


**CNST aplicables:**
- CNST-001: NO email (recuperación por buzón interno)
- CNST-002: Sesión única por usuario, timeout 15 min

**Implementación Django:**

.. code-block:: python

 from apps.access.decorators import require_function
 
 @require_function('AUTH-001') # view_own_sessions
 def view_own_sessions_view(request):
 """Sesiones activas propias del usuario."""
 pass


----

3.2 MOD_Users (9 funciones)
---------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - USR-001
   - `create_users`
   - users:create
   - UC-006
   - Crea nuevos usuarios
 * - USR-002
   - `update_users`
   - users:update
   - UC-007
   - Modifica datos de usuarios
 * - USR-003
   - `deactivate_users`
   - users:deactivate
   - UC-008
   - Baja lógica de usuarios (RENAME v5.4.0 desde ``delete_users`` — semántica soft delete; BR-009 global)
 * - USR-004
   - `list_users`
   - users:list
   - UC-009
   - Lista usuarios con filtros
 * - USR-005
   - `search_users`
   - users:search
   - UC-009
   - Busca usuarios por criterios
 * - USR-006
   - `block_users`
   - users:block
   - UC-007
   - Bloquea acceso de usuario
 * - USR-007
   - `unblock_users`
   - users:unblock
   - UC-007
   - Desbloquea usuario
 * - USR-008
   - `reactivate_users`
   - users:reactivate
   - UC-007
   - Reactiva usuario inactivo
 * - USR-009
   - `view_users`
   - users:view
   - UC-009
   - Consulta información de usuarios


**CAMBIO v5.2.1:**
- Todos los nombres en inglés
- ``update_users`` (NO "modify")
- Sin función USR-010 (eliminada en v5.2.0)

**CNST aplicables:**
- CNST-001: NO email (notificaciones por buzón interno)
- CNST-005: Bajas siempre lógicas, nunca físicas
- CNST-005: Username autogenerado

**Implementación Django:**

.. code-block:: python

 @require_function('USR-001') # create_users
 def create_user_view(request):
 """Creación de usuario."""
 pass


----

3.3 MOD_Access (12 funciones)
-----------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - ACC-001
   - `assign_functions`
   - access:assign
   - UC-010, UC-042
   - Asigna funciones a usuarios
 * - ACC-002
   - `revoke_functions`
   - access:revoke
   - UC-010
   - Revoca funciones de usuarios
 * - ACC-003
   - `view_assignments`
   - access:view
   - UC-011, UC-044
   - Ve asignaciones de funciones
 * - ACC-004
   - `assign_function_groups`
   - access:assign_group
   - UC-010
   - Asigna grupos de funciones
 * - ACC-005
   - `view_separation_rules`
   - access:view_sod
   - UC-043
   - Ve reglas SoD configuradas (RENAME v5.4.0 desde ``manage_separation_rules`` — split SRP B2)
 * - ACC-006
   - `create_function_group`
   - access:create_group
   - UC_PERM_05
   - Crea grupo de funciones custom (admin tech) (NUEVA v5.3.0)
 * - ACC-007
   - `assign_functions_to_group`
   - access:assign_to_group
   - UC_PERM_06
   - Asigna funciones a un grupo (custom o predefinido) (NUEVA v5.3.0)
 * - ACC-008
   - `grant_exceptional_permission`
   - access:grant_exceptional
   - UC_PERM_03
   - Otorga permiso temporal excepcional con justificación (CNST-031) (NUEVA v5.3.0)
 * - ACC-009
   - `revoke_exceptional_permission`
   - access:revoke_exceptional
   - UC_PERM_04
   - Revoca permiso excepcional antes del vencimiento (NUEVA v5.3.0)
 * - ACC-010
   - `revoke_function_group`
   - access:revoke_group
   - UC_PERM_02
   - Revoca grupo asignado a usuario (NUEVA v5.3.0)
 * - ACC-011
   - `update_separation_rule`
   - access:update_sod
   - UC-043
   - Actualiza parámetros de regla SoD existente (NUEVA v5.4.0 — split SRP de ACC-005)
 * - ACC-012
   - `disable_separation_rule`
   - access:disable_sod
   - UC-043
   - Desactiva regla SoD temporalmente (toggle on/off; BR-009 global) (NUEVA v5.4.0 — split SRP de ACC-005)


**CAMBIO v5.4.0:**
- ACC-005 RENAME ``manage_separation_rules`` → ``view_separation_rules``
- ACC-011/012 NUEVAS (split SRP B2; gestión SoD ahora granular)

**CAMBIO v5.2.1:**
- ``assign_function_groups`` (completo, NO "assign_groupers")
- Sin función ACC-006 (eliminada en v5.2.0)

**Componente SEC_RULES:**
- Middleware automático de enforcement
- No visible al usuario
- Valida permisos en cada request

**CNST aplicables:**
- CNST-005: Flat RBAC (sin jerarquías)
- CNST-005: SoD obligatorio
- CNST-005: Permisos temporales: justificación mín 20 chars, vencimiento máx 6 meses

----

3.4 MOD_Pipeline (4 funciones)
------------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - PIP-001
   - `view_pipeline_status`
   - pipeline:view_status
   - UC-050
   - Ve estado actual del ETL
 * - PIP-002
   - `view_pipeline_errors`
   - pipeline:view_errors
   - UC-051
   - Consulta errores del ETL
 * - PIP-003
   - `view_data_availability`
   - pipeline:availability
   - UC-052
   - Ve disponibilidad de datos
 * - PIP-004
   - `request_pipeline_retry`
   - pipeline:retry
   - UC-053
   - Solicita reintento de ETL


**CAMBIO v5.2.1:**
- ``view_pipeline_status`` (NO "ve_estado_etl", evita acrónimo ETL en nombre)
- ``request_pipeline_retry`` (NO "solicita_reintento_etl")

**CNST aplicables:**
- CNST-003: BD IVR solo lectura
- CNST-003: ETL cada 6-12 horas
- CNST-003: NO real-time
- CNST-009: Auditar cambios críticos

------------------------------------------

3.5 MOD_Reports (11 funciones) CORE NEGOCIO
-------------------------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - RPT-001
   - `view_reports`
   - reports:view
   - UC-017, UC-018, UC-019
   - Ve reportes tabulares
 * - RPT-002
   - `view_dashboard`
   - reports:dashboard
   - UC-025
   - Ve dashboard principal
 * - RPT-003
   - `filter_reports`
   - reports:filter
   - UC-020, UC-021
   - Aplica filtros a reportes
 * - RPT-004
   - `export_csv`
   - reports:export_csv
   - UC-022
   - Exporta a CSV (límite: 100K registros)
 * - RPT-005
   - `export_excel`
   - reports:export_excel
   - UC-023
   - Exporta a Excel (límite: 50K registros)
 * - RPT-006
   - `export_pdf`
   - reports:export_pdf
   - UC-024
   - Exporta a PDF (límite: 10K registros)
 * - RPT-007
   - `view_kpis`
   - reports:kpis
   - UC-025
   - Ve KPIs estáticos
 * - RPT-008
   - `view_charts`
   - reports:charts
   - UC-027, UC-028, UC-029
   - Ve gráficos predefinidos
 * - RPT-009
   - `schedule_report`
   - reports:schedule
   - UC_RPT_07
   - Programa generación automática de reportes (NUEVA v5.3.0 — restaura ``programa_reportes`` v5.0_1/v5.1)
 * - RPT-010
   - `save_view`
   - reports:save_view
   - UC_RPT_10
   - Persiste configuración de filtros como vista personalizada (NUEVA v5.3.0)
 * - RPT-011
   - `share_report`
   - reports:share
   - UC_RPT_11
   - Comparte reporte con otros usuarios via URL/buzón interno (NUEVA v5.3.0 — restaura ``comparte_reportes`` v5.0_1/v5.1)


**CAMBIO v5.3.0:**

- Agregadas 3 funciones nuevas (RPT-009..011): ``schedule_report``,
  ``save_view``, ``share_report``.
- ``schedule_report`` y ``share_report`` son **restauraciones** del
  catálogo v5.0_1/v5.1 (eliminadas erróneamente en v5.1.1).
- ``save_view`` es feature nueva (no existía en versiones previas).

**CAMBIO v5.2.1:**

- ``view_charts`` (NO "ve_graficos", "charts" es estándar para gráficos de datos)
- ``filter_reports`` (NO "filtra_reportes")

**CNST aplicables:**
- CNST-003: Datos desfasados 6-12h, NO real-time
- CNST-006: Rango máximo 2 años en filtros
- CNST-007: Límites por formato (CSV: 100K, Excel: 50K, PDF: 10K)
- CNST-007: Throttling por rol

**Límites de exportación:**


.. list-table::
 :widths: 25 25 25 25
 :header-rows: 1

 * - Formato
   - Max Registros
   - Límite Diario
   - Timeout
 * - CSV
   - 100,000
   - 10 exportaciones
   - 60s
 * - Excel
   - 50,000
   - 5 exportaciones
   - 90s
 * - PDF
   - 10,000
   - 3 exportaciones
   - 120s


----

3.6 MOD_Alerts (10 funciones)
-----------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - ALR-001
   - `view_alerts`
   - alerts:view
   - UC-039
   - Ve alertas propias
 * - ALR-002
   - `configure_alerts`
   - alerts:configure
   - UC-036
   - Configura alertas personales
 * - ALR-003
   - `configure_team_alerts`
   - alerts:config_team
   - UC-040
   - Configura alertas de equipo
 * - ALR-004
   - `pause_alerts`
   - alerts:pause
   - UC-038
   - Pausa alertas temporalmente
 * - ALR-005
   - `disable_alerts`
   - alerts:disable
   - UC-038
   - Desactiva alerta (toggle on/off; BR-009 global) (RENAME v5.4.0 desde ``delete_alerts`` — no eliminar)
 * - ALR-006
   - `view_alert_history`
   - alerts:history
   - UC-039
   - Ve historial de alertas
 * - ALR-007
   - `acknowledge_alert`
   - alerts:acknowledge
   - uc-alr-03
   - Reconoce alerta (state transition ACTIVE → ACKNOWLEDGED) (NUEVA v5.4.0 — closed-loop alerts)
 * - ALR-008
   - `subscribe_to_alert`
   - alerts:subscribe
   - uc-alr-05
   - Suscribe usuario a tipo de alerta (NUEVA v5.4.0 — split SRP suscripciones)
 * - ALR-009
   - `unsubscribe_from_alert`
   - alerts:unsubscribe
   - uc-alr-05
   - Desuscribe usuario de tipo de alerta (NUEVA v5.4.0 — split SRP suscripciones)
 * - ALR-010
   - `configure_subscription_severity`
   - alerts:config_severity
   - uc-alr-05
   - Configura nivel mínimo de severidad para notificación (NUEVA v5.4.0 — split SRP suscripciones)


**CAMBIO v5.4.0:**
- ALR-005 RENAME ``delete_alerts`` → ``disable_alerts`` (BR-009 no eliminar)
- ALR-007 NUEVA acknowledge_alert (closed-loop)
- ALR-008/009/010 NUEVAS (split SRP de ``manage_alert_subscriptions`` propuesta)

**CAMBIO v5.2.1:**
- ``configure_team_alerts`` (NO "configura_alertas_equipo")
- ``view_alert_history`` (NO "ve_historial_alertas")

**CNST aplicables:**
- CNST-001: NO email (solo buzón interno)
- CNST-004: Máximo 50 destinatarios por alerta
- CNST-009: Auditar configuración de alertas

----

3.7 MOD_Audit (4 funciones)
---------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - AUD-001
   - `view_audit_log`
   - audit:view
   - UC-061
   - Ve registros de auditoría
 * - AUD-002
   - `search_audit_log`
   - audit:search
   - UC-061
   - Busca en auditoría
 * - AUD-003
   - `export_audit_log`
   - audit:export
   - UC-063
   - Exporta registros de auditoría
 * - AUD-004
   - `generate_compliance_report`
   - audit:compliance
   - UC-062
   - Genera reporte de cumplimiento


**CAMBIO v5.2.1:**
- ``view_audit_log`` (NO "ve_auditoria", "log" explícito)
- ``generate_compliance_report`` (NO "genera_reporte_compliance")

**CNST aplicables:**
- CNST-008: Registros inmutables (append-only)
- CNST-008: Retención mínima 2 años
- CNST-008: Sin PII innecesaria
- CNST-009: Checksum SHA-256 por registro

----

3.8 MOD_Logs (7 funciones)
--------------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Función
   - Capacidad
   - UC
   - Descripción
 * - LOG-001
   - `view_application_logs`
   - logs:view_app
   - uc-log-01
   - Ve logs de aplicación (errores 500, INFO/WARN/ERROR, tracebacks) (RENAME v5.4.0 desde ``view_technical_logs`` — SRP, ya no genérico)
 * - LOG-002
   - `export_logs`
   - logs:export
   - uc-log-04
   - Exporta paquete de logs a CSV/JSON
 * - LOG-003
   - `search_logs`
   - logs:search
   - uc-log-03
   - Busca logs por criterios (timestamp, severity, source) (NUEVA v5.3.0)
 * - LOG-004
   - `view_etl_logs`
   - logs:view_etl
   - uc-log-02
   - Ve logs específicos del proceso ETL (sync IVR→Analytics, métricas carga) (NUEVA v5.4.0 — SRP)
 * - LOG-005
   - `view_infrastructure_logs`
   - logs:view_infra
   - uc-log-05
   - Ve logs de infraestructura (timeouts, up/down, conectividad DB) (NUEVA v5.4.0 — SRP)
 * - LOG-006
   - `view_system_health`
   - logs:view_health
   - uc-log-06
   - Ve estado de salud del sistema y servicios externos (UP/DOWN/DEGRADED) (NUEVA v5.4.0 — gap UC_081)
 * - LOG-007
   - `view_technical_metrics`
   - logs:view_metrics
   - uc-log-07
   - Ve métricas técnicas agregadas (CPU, memoria, latencia P95) (NUEVA v5.4.0 — gap UC_083)


**CAMBIO v5.4.0:**

- LOG-001 RENAME ``view_technical_logs`` → ``view_application_logs``
  (SRP: ya no cubre ETL ni infra)
- LOG-004 NUEVA ``view_etl_logs`` (uc-log-02 deja de ser instancia)
- LOG-005 NUEVA ``view_infrastructure_logs`` (uc-log-05 nuevo)
- LOG-006 NUEVA ``view_system_health`` (gap UC_081 ARQ-MOD-008)
- LOG-007 NUEVA ``view_technical_metrics`` (gap UC_083 ARQ-MOD-008)

**CAMBIO v5.3.0:**

- Agregada ``search_logs`` (LOG-003) para sustentar UC_LOG_03 que
  citaba función inexistente.

**CAMBIO v5.2.1:**
- Nombres en inglés (NO "ve_logs_tecnicos")

**CNST aplicables:**
- CNST-008: Sin PII (contraseñas, tokens enmascarados)
- CNST-008: Formato JSON estructurado
- CNST-008: Retención 30-90 días según tipo

**Diferencia con MOD_Audit:**
- **MOD_Audit:** Eventos de negocio (quién hizo qué)
- **MOD_Logs:** Eventos técnicos (errores, performance)

----


4. LOS 10 GRUPOS DE FUNCIONES
=============================



4.1 Catálogo de Grupos
----------------------



.. list-table::
 :widths: 20 20 20 20 20
 :header-rows: 1

 * - ID
   - Nombre
   - Funciones
   - Actor Típico
   - Descripción
 * - **AGR-001**
   - `basic_operator_group`
   - 6
   - Operador
   - Visualización básica
 * - **AGR-002**
   - `report_viewer_group`
   - 8
   - Analista
   - Análisis sin exportación
 * - **AGR-003**
   - `quality_supervisor_group`
   - 11
   - Supervisor
   - Análisis + filtros avanzados
 * - **AGR-004**
   - `data_exporter_group`
   - 14
   - Data Analyst
   - Exportación autorizada
 * - **AGR-005**
   - `alert_manager_group`
   - 6
   - Gestor Alertas
   - Gestión completa alertas
 * - **AGR-006**
   - `user_admin_group`
   - 9
   - Admin Usuarios
   - Gestión de identidades
 * - **AGR-007**
   - `permission_admin_group`
   - 5
   - Admin Permisos
   - Gestión RBAC
 * - **AGR-008**
   - `auditor_group`
   - 4
   - Auditor
   - Solo auditoría (SoD)
 * - **AGR-009**
   - `pipeline_admin_group`
   - 4
   - Admin Pipeline
   - Supervisión ETL
 * - **AGR-010**
   - `system_admin_group`
   - 6
   - Sysadmin
   - Administración completa


**CAMBIO v5.2.1:**
- Todos los nombres en inglés
- Sin prefijo redundante ``agr_``
- Sufijo ``_group`` explícito


4.2 Detalle de Grupos
---------------------



AGR-001 basic_operator_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (6):**

.. code-block:: text

 AUTH-001: manage_sessions (propias)
 AUTH-004: view_active_sessions (propias)
 RPT-001: view_reports
 RPT-002: view_dashboard
 RPT-007: view_kpis
 RPT-008: view_charts


**Propósito:** Usuario básico que solo visualiza información.

----

AGR-002 report_viewer_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (8):**

.. code-block:: text

 Todas de AGR-001 +
 RPT-003: filter_reports
 USR-009: view_users


**Propósito:** Analista que puede aplicar filtros pero no exportar.

----

AGR-003 quality_supervisor_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (11):**

.. code-block:: text

 Todas de AGR-002 +
 ALR-001: view_alerts
 ALR-002: configure_alerts
 ALR-006: view_alert_history


**Propósito:** Supervisor con capacidad de configurar alertas propias.

----

AGR-004 data_exporter_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (14):**

.. code-block:: text

 Todas de AGR-003 +
 RPT-004: export_csv
 RPT-005: export_excel
 RPT-006: export_pdf


**Propósito:** Analista autorizado para exportar con límites CNST-007.

----

AGR-005 alert_manager_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (6):**

.. code-block:: text

 ALR-001: view_alerts
 ALR-002: configure_alerts
 ALR-003: configure_team_alerts
 ALR-004: pause_alerts
 ALR-005: delete_alerts
 ALR-006: view_alert_history


**Propósito:** Gestor de alertas de equipo/departamento.

----

AGR-006 user_admin_group
^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (9):**

.. code-block:: text

 USR-001: create_users
 USR-002: update_users
 USR-003: delete_users
 USR-004: list_users
 USR-005: search_users
 USR-006: block_users
 USR-007: unblock_users
 USR-008: reactivate_users
 USR-009: view_users


**Propósito:** Administración completa de identidades.

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

----

AGR-007 permission_admin_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (5):**

.. code-block:: text

 ACC-001: assign_functions
 ACC-002: revoke_functions
 ACC-003: view_assignments
 ACC-004: assign_function_groups
 ACC-005: manage_separation_rules


**Propósito:** Administración de RBAC.

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

----

AGR-008 auditor_group
^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (4):**

.. code-block:: text

 AUD-001: view_audit_log
 AUD-002: search_audit_log
 AUD-003: export_audit_log
 AUD-004: generate_compliance_report


**Propósito:** Auditoría y compliance.

**SoD CRÍTICA:** NO puede combinarse con:
- AGR-006 (user_admin_group)
- AGR-007 (permission_admin_group)
- AGR-009 (pipeline_admin_group)

----

AGR-009 pipeline_admin_group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (4):**

.. code-block:: text

 PIP-001: view_pipeline_status
 PIP-002: view_pipeline_errors
 PIP-003: view_data_availability
 PIP-004: request_pipeline_retry


**Propósito:** Administración de ETL.

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

----

AGR-010 system_admin_group
^^^^^^^^^^^^^^^^^^^^^^^^^^


**Funciones incluidas (6):**

.. code-block:: text

 AUTH-001: manage_sessions (de todos)
 AUTH-002: close_user_session
 AUTH-003: reset_password
 AUTH-004: view_active_sessions
 LOG-001: view_technical_logs
 LOG-002: export_logs


**Propósito:** Administración técnica del sistema.

----


5. SEPARACIÓN DE FUNCIONES (SoD)
================================



5.1 Las 3 Restricciones SoD
---------------------------



SOD-001 pipeline_audit_separation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Restricción:** Un usuario NO puede tener funciones de Pipeline Y de Auditoría.

**Grupo A (Pipeline):**

.. code-block:: text

 PIP-001: view_pipeline_status
 PIP-002: view_pipeline_errors
 PIP-003: view_data_availability
 PIP-004: request_pipeline_retry


**Grupo B (Auditoría):**

.. code-block:: text

 AUD-001: view_audit_log
 AUD-002: search_audit_log
 AUD-003: export_audit_log
 AUD-004: generate_compliance_report


**Razón:** Evitar que quien opera el ETL audite sus propias acciones.

**CNST:** CNST-005

----

SOD-002 user_audit_separation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Restricción:** Un usuario NO puede tener funciones de gestión de Usuarios Y de Auditoría.

**Grupo A (Usuarios - críticas):**

.. code-block:: text

 USR-001: create_users
 USR-003: delete_users
 USR-004: list_users
 USR-007: unblock_users


**Grupo B (Auditoría):**

.. code-block:: text

 AUD-001: view_audit_log
 AUD-002: search_audit_log
 AUD-003: export_audit_log


**Razón:** Evitar que quien gestiona usuarios vea auditoría de sus acciones.

**CNST:** CNST-005

----

SOD-003 access_audit_separation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


**Restricción:** Un usuario NO puede tener funciones de gestión de Acceso Y de Auditoría.

**Grupo A (Acceso):**

.. code-block:: text

 ACC-001: assign_functions
 ACC-002: revoke_functions
 ACC-005: manage_separation_rules


**Grupo B (Auditoría):**

.. code-block:: text

 AUD-001: view_audit_log
 AUD-002: search_audit_log


**Razón:** Separación de poderes entre quien asigna permisos y quien audita.

**CNST:** CNST-005

----


6. PERMISOS TEMPORALES
======================



6.1 Concepto
------------


Una función puede asignarse **temporalmente** con:
- **Justificación obligatoria** (mín 20 caracteres)
- **Fecha de vencimiento** (máx 6 meses)

**Casos de uso:**
- Cobertura de vacaciones
- Proyectos temporales
- Pruebas controladas


6.2 Reglas
----------


1. **Justificación:** Mínimo 20 caracteres
2. **Vencimiento:** Máximo 6 meses desde asignación
3. **Auditoría:** Registro obligatorio (CNST-009)
4. **Renovación:** Requiere nueva justificación
5. **Revocación:** Automática al vencer o manual


6.3 Ejemplo
-----------



.. code-block:: python

 # Asignar export_csv temporalmente por 3 meses
 UserFunctionAssignment.objects.create(
 user=user,
 function=Function.objects.get(function_id='RPT-004'), # export_csv
 assigned_by=admin,
 justification="Cobertura vacaciones analista principal",
 expiration_date=date.today + timedelta(days=90)
 )


----


7. MODELO DE DATOS
==================



7.1 Tablas
----------


1. **``functions``** - 42 funciones atómicas
2. **``function_groups``** - 10 grupos predefinidos
3. **``function_group_membership``** - M2M funciones-grupos
4. **``user_function_assignments``** - Asignaciones directas
5. **``user_function_group_assignments``** - Asignaciones de grupos
6. **``function_separation_rules``** - 3 reglas SoD
7. **``function_separation_rule_details``** - Detalle SoD (grupos A/B)

----


8. IMPLEMENTACIÓN SQL
=====================



8.1 Tabla functions
-------------------



.. code-block:: sql

 CREATE TABLE functions (
 function_id VARCHAR(20) PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 description TEXT NOT NULL,
 category VARCHAR(50) NOT NULL,
 
 CONSTRAINT uk_function_name UNIQUE (name),
 CONSTRAINT chk_category CHECK (category IN (
 'auth', 'users', 'access', 'pipeline',
 'reports', 'alerts', 'audit', 'logs'
 ))
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 CREATE INDEX idx_function_category ON functions(category);



8.2 Tabla function_groups
-------------------------



.. code-block:: sql

 CREATE TABLE function_groups (
 group_id VARCHAR(20) PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 description TEXT NOT NULL,
 
 CONSTRAINT uk_group_name UNIQUE (name)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



8.3 Tabla function_group_membership
-----------------------------------



.. code-block:: sql

 CREATE TABLE function_group_membership (
 id INT AUTO_INCREMENT PRIMARY KEY,
 group_id VARCHAR(20) NOT NULL,
 function_id VARCHAR(20) NOT NULL,
 
 CONSTRAINT fk_fgm_group FOREIGN KEY (group_id)
 REFERENCES function_groups(group_id),
 CONSTRAINT fk_fgm_function FOREIGN KEY (function_id)
 REFERENCES functions(function_id),
 CONSTRAINT uk_group_function UNIQUE (group_id, function_id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



8.4 Tabla user_function_assignments
-----------------------------------



.. code-block:: sql

 CREATE TABLE user_function_assignments (
 id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL,
 function_id VARCHAR(20) NOT NULL,
 assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 assigned_by INT NULL,
 justification TEXT,
 expiration_date DATE NULL,
 
 CONSTRAINT fk_ufa_user FOREIGN KEY (user_id)
 REFERENCES auth_user(id),
 CONSTRAINT fk_ufa_function FOREIGN KEY (function_id)
 REFERENCES functions(function_id),
 CONSTRAINT fk_ufa_assigned_by FOREIGN KEY (assigned_by)
 REFERENCES auth_user(id),
 CONSTRAINT uk_user_function UNIQUE (user_id, function_id),
 CONSTRAINT chk_justification_length 
 CHECK (justification IS NULL OR LENGTH(justification) >= 20),
 CONSTRAINT chk_expiration_date
 CHECK (expiration_date IS NULL OR 
 expiration_date <= DATE_ADD(assigned_at, INTERVAL 6 MONTH))
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 CREATE INDEX idx_ufa_user ON user_function_assignments(user_id);
 CREATE INDEX idx_ufa_expiration ON user_function_assignments(expiration_date);


**CAMBIO v5.2.1:** ``assigned_at`` (NO ``assigned_date``, convención ``*_at`` para datetime)


8.5 Tabla user_function_group_assignments
-----------------------------------------



.. code-block:: sql

 CREATE TABLE user_function_group_assignments (
 id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL,
 group_id VARCHAR(20) NOT NULL,
 assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 assigned_by INT NULL,
 
 CONSTRAINT fk_ufga_user FOREIGN KEY (user_id)
 REFERENCES auth_user(id),
 CONSTRAINT fk_ufga_group FOREIGN KEY (group_id)
 REFERENCES function_groups(group_id),
 CONSTRAINT fk_ufga_assigned_by FOREIGN KEY (assigned_by)
 REFERENCES auth_user(id),
 CONSTRAINT uk_user_group UNIQUE (user_id, group_id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 
 CREATE INDEX idx_ufga_user ON user_function_group_assignments(user_id);


**CAMBIO v5.2.1:** ``assigned_at`` (convención datetime)


8.6 Tabla function_separation_rules
-----------------------------------



.. code-block:: sql

 CREATE TABLE function_separation_rules (
 restriction_id VARCHAR(20) PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 description TEXT NOT NULL,
 reason TEXT NOT NULL,
 cnst_reference VARCHAR(20) NOT NULL,
 active BOOLEAN NOT NULL DEFAULT TRUE,
 
 CONSTRAINT uk_sod_name UNIQUE (name)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



8.7 Tabla function_separation_rule_details
------------------------------------------



.. code-block:: sql

 CREATE TABLE function_separation_rule_details (
 id INT AUTO_INCREMENT PRIMARY KEY,
 restriction_id VARCHAR(20) NOT NULL,
 function_id VARCHAR(20) NOT NULL,
 rule_group CHAR(1) NOT NULL,
 
 CONSTRAINT fk_fsrd_restriction FOREIGN KEY (restriction_id)
 REFERENCES function_separation_rules(restriction_id),
 CONSTRAINT fk_fsrd_function FOREIGN KEY (function_id)
 REFERENCES functions(function_id),
 CONSTRAINT chk_group CHECK (rule_group IN ('A', 'B')),
 CONSTRAINT uk_restriction_function UNIQUE (restriction_id, function_id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


**CAMBIO v5.2.1:** ``rule_group`` (NO ``separation_group``, más conciso)


8.8 Datos Iniciales - 61 Funciones (v5.4.0)
-------------------------------------------



.. code-block:: sql

 -- MOD_Auth (4 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('AUTH-001', 'view_own_sessions', 'Ve sesiones activas propias del usuario', 'auth'),
 ('AUTH-002', 'close_user_session', 'Cierra sesión de otro usuario', 'auth'),
 ('AUTH-003', 'reset_password', 'Genera contraseña temporal', 'auth'),
 ('AUTH-004', 'view_all_active_sessions', 'Ve TODAS las sesiones activas del sistema (admin)', 'auth');

 -- MOD_Users (9 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('USR-001', 'create_users', 'Crea nuevos usuarios', 'users'),
 ('USR-002', 'update_users', 'Modifica datos de usuarios', 'users'),
 ('USR-003', 'deactivate_users', 'Baja lógica de usuarios (BR-009)', 'users'),
 ('USR-004', 'list_users', 'Lista usuarios con filtros', 'users'),
 ('USR-005', 'search_users', 'Busca usuarios por criterios', 'users'),
 ('USR-006', 'block_users', 'Bloquea acceso de usuario', 'users'),
 ('USR-007', 'unblock_users', 'Desbloquea usuario', 'users'),
 ('USR-008', 'reactivate_users', 'Reactiva usuario inactivo', 'users'),
 ('USR-009', 'view_users', 'Consulta información de usuarios', 'users');

 -- MOD_Access (12 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('ACC-001', 'assign_functions', 'Asigna funciones a usuarios', 'access'),
 ('ACC-002', 'revoke_functions', 'Revoca funciones de usuarios', 'access'),
 ('ACC-003', 'view_assignments', 'Ve asignaciones de funciones', 'access'),
 ('ACC-004', 'assign_function_groups', 'Asigna grupos de funciones', 'access'),
 ('ACC-005', 'view_separation_rules', 'Ve reglas SoD configuradas', 'access'),
 ('ACC-006', 'create_function_group', 'Crea grupo de funciones custom', 'access'),
 ('ACC-007', 'assign_functions_to_group', 'Asigna funciones a un grupo', 'access'),
 ('ACC-008', 'grant_exceptional_permission', 'Otorga permiso temporal excepcional (CNST-031)', 'access'),
 ('ACC-009', 'revoke_exceptional_permission', 'Revoca permiso excepcional', 'access'),
 ('ACC-010', 'revoke_function_group', 'Revoca grupo asignado', 'access'),
 ('ACC-011', 'update_separation_rule', 'Actualiza parámetros de regla SoD', 'access'),
 ('ACC-012', 'disable_separation_rule', 'Desactiva regla SoD (toggle on/off; BR-009)', 'access');

 -- MOD_Pipeline (4 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('PIP-001', 'view_pipeline_status', 'Ve estado actual del ETL', 'pipeline'),
 ('PIP-002', 'view_pipeline_errors', 'Consulta errores del ETL', 'pipeline'),
 ('PIP-003', 'view_data_availability', 'Ve disponibilidad de datos', 'pipeline'),
 ('PIP-004', 'request_pipeline_retry', 'Solicita reintento de ETL', 'pipeline');

 -- MOD_Reports (11 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('RPT-001', 'view_reports', 'Ve reportes tabulares', 'reports'),
 ('RPT-002', 'view_dashboard', 'Ve dashboard principal', 'reports'),
 ('RPT-003', 'filter_reports', 'Aplica filtros a reportes', 'reports'),
 ('RPT-004', 'export_csv', 'Exporta a CSV', 'reports'),
 ('RPT-005', 'export_excel', 'Exporta a Excel', 'reports'),
 ('RPT-006', 'export_pdf', 'Exporta a PDF', 'reports'),
 ('RPT-007', 'view_kpis', 'Ve KPIs estáticos', 'reports'),
 ('RPT-008', 'view_charts', 'Ve gráficos predefinidos', 'reports'),
 ('RPT-009', 'schedule_report', 'Programa generación automática de reportes', 'reports'),
 ('RPT-010', 'save_view', 'Persiste configuración de filtros como vista', 'reports'),
 ('RPT-011', 'share_report', 'Comparte reporte vía URL/buzón interno', 'reports');

 -- MOD_Alerts (10 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('ALR-001', 'view_alerts', 'Ve alertas propias', 'alerts'),
 ('ALR-002', 'configure_alerts', 'Configura alertas personales', 'alerts'),
 ('ALR-003', 'configure_team_alerts', 'Configura alertas de equipo', 'alerts'),
 ('ALR-004', 'pause_alerts', 'Pausa alertas temporalmente', 'alerts'),
 ('ALR-005', 'disable_alerts', 'Desactiva alerta (toggle on/off; BR-009)', 'alerts'),
 ('ALR-006', 'view_alert_history', 'Ve historial de alertas', 'alerts'),
 ('ALR-007', 'acknowledge_alert', 'Reconoce alerta (state transition)', 'alerts'),
 ('ALR-008', 'subscribe_to_alert', 'Suscribe usuario a tipo de alerta', 'alerts'),
 ('ALR-009', 'unsubscribe_from_alert', 'Desuscribe usuario de tipo de alerta', 'alerts'),
 ('ALR-010', 'configure_subscription_severity', 'Configura severidad mínima', 'alerts');

 -- MOD_Audit (4 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('AUD-001', 'view_audit_log', 'Ve registros de auditoría', 'audit'),
 ('AUD-002', 'search_audit_log', 'Busca en auditoría', 'audit'),
 ('AUD-003', 'export_audit_log', 'Exporta registros de auditoría', 'audit'),
 ('AUD-004', 'generate_compliance_report', 'Genera reporte de cumplimiento', 'audit');

 -- MOD_Logs (7 funciones)
 INSERT INTO functions (function_id, name, description, category) VALUES
 ('LOG-001', 'view_application_logs', 'Ve logs de aplicación (errores 500, INFO/WARN/ERROR)', 'logs'),
 ('LOG-002', 'export_logs', 'Exporta paquete de logs', 'logs'),
 ('LOG-003', 'search_logs', 'Busca logs por criterios', 'logs'),
 ('LOG-004', 'view_etl_logs', 'Ve logs del proceso ETL (sync IVR→Analytics)', 'logs'),
 ('LOG-005', 'view_infrastructure_logs', 'Ve logs de infraestructura (timeouts, up/down)', 'logs'),
 ('LOG-006', 'view_system_health', 'Ve estado de salud del sistema y servicios', 'logs'),
 ('LOG-007', 'view_technical_metrics', 'Ve métricas técnicas agregadas (CPU, memoria)', 'logs');



8.9 Datos Iniciales - 10 Grupos
-------------------------------



.. code-block:: sql

 INSERT INTO function_groups (group_id, name, description) VALUES
 ('AGR-001', 'basic_operator_group', 'Visualización básica de reportes y dashboard'),
 ('AGR-002', 'report_viewer_group', 'Análisis de reportes con filtros'),
 ('AGR-003', 'quality_supervisor_group', 'Supervisión con alertas'),
 ('AGR-004', 'data_exporter_group', 'Exportación autorizada de datos'),
 ('AGR-005', 'alert_manager_group', 'Gestión completa de alertas'),
 ('AGR-006', 'user_admin_group', 'Administración de usuarios'),
 ('AGR-007', 'permission_admin_group', 'Administración de permisos RBAC'),
 ('AGR-008', 'auditor_group', 'Auditoría y compliance'),
 ('AGR-009', 'pipeline_admin_group', 'Administración del ETL'),
 ('AGR-010', 'system_admin_group', 'Administración técnica del sistema');



8.10 Datos Iniciales - 3 Reglas SoD
-----------------------------------



.. code-block:: sql

 -- Insertar restricciones SoD
 INSERT INTO function_separation_rules 
 (restriction_id, name, description, reason, cnst_reference) VALUES
 ('SOD-001', 'pipeline_audit_separation', 
 'Pipeline operations cannot audit themselves', 
 'Evitar que quien opera el ETL audite sus propias acciones', 
 'CNST-005'),
 ('SOD-002', 'user_audit_separation', 
 'User management cannot audit themselves', 
 'Evitar que quien administra usuarios vea auditoría de sus acciones', 
 'CNST-005'),
 ('SOD-003', 'access_audit_separation', 
 'Permission management cannot audit themselves', 
 'Separación de poderes entre asignación y auditoría', 
 'CNST-005');
 
 -- SOD-001 detalles
 INSERT INTO function_separation_rule_details 
 (restriction_id, function_id, rule_group) VALUES
 ('SOD-001', 'PIP-001', 'A'),
 ('SOD-001', 'PIP-002', 'A'),
 ('SOD-001', 'PIP-003', 'A'),
 ('SOD-001', 'PIP-004', 'A'),
 ('SOD-001', 'AUD-001', 'B'),
 ('SOD-001', 'AUD-002', 'B'),
 ('SOD-001', 'AUD-003', 'B'),
 ('SOD-001', 'AUD-004', 'B');
 
 -- SOD-002 detalles
 INSERT INTO function_separation_rule_details 
 (restriction_id, function_id, rule_group) VALUES
 ('SOD-002', 'USR-001', 'A'),
 ('SOD-002', 'USR-003', 'A'),
 ('SOD-002', 'USR-004', 'A'),
 ('SOD-002', 'USR-007', 'A'),
 ('SOD-002', 'AUD-001', 'B'),
 ('SOD-002', 'AUD-002', 'B'),
 ('SOD-002', 'AUD-003', 'B');
 
 -- SOD-003 detalles
 INSERT INTO function_separation_rule_details 
 (restriction_id, function_id, rule_group) VALUES
 ('SOD-003', 'ACC-001', 'A'),
 ('SOD-003', 'ACC-002', 'A'),
 ('SOD-003', 'ACC-005', 'A'),
 ('SOD-003', 'AUD-001', 'B'),
 ('SOD-003', 'AUD-002', 'B');


----


9. IMPLEMENTACIÓN DJANGO
========================



9.1 Models (appsaccessmodels.py)
--------------------------------



.. code-block:: python

 """
 Modelos de control de acceso RBAC v5.2.1
 Sistema IACT - 42 funciones atómicas
 """
 from django.db import models
 from django.contrib.auth import get_user_model
 
 User = get_user_model
 
 
 class Function(models.Model):
 """
 Función atómica del sistema (42 funciones).
 
 Una función representa una capacidad específica que puede 
 realizar un usuario. Ejemplos:
 - view_reports
 - export_csv
 - create_users
 """
   function_id = models.CharField(
   max_length=20,
   unique=True,
   help_text="Identificador único (AUTH-001, USR-001, etc.)"
   )
   name = models.CharField(
   max_length=100,
   help_text="Nombre descriptivo (view_reports, export_csv, create_users)"
   )
   description = models.TextField(
   help_text="Descripción de qué hace la función"
   )
   category = models.CharField(
   max_length=50,
   choices=[
   ('auth', 'Autenticación'),
   ('users', 'Usuarios'),
   ('access', 'Acceso'),
   ('pipeline', 'Pipeline'),
   ('reports', 'Reportes'),
   ('alerts', 'Alertas'),
   ('audit', 'Auditoría'),
   ('logs', 'Logs'),
   ],
   help_text="Módulo al que pertenece"
   )
 
 class Meta:
 db_table = 'functions'
 verbose_name = 'Función'
 verbose_name_plural = 'Funciones'
 ordering = ['function_id']
 
 def __str__(self):
 return f"{self.function_id}: {self.name}"
 
 
 class FunctionGroup(models.Model):
 """
 Grupo de funciones que se asignan juntas (10 grupos).
 
 Un grupo agrupa múltiples funciones relacionadas. Ejemplos:
 - basic_operator_group (view_reports + view_dashboard)
 - user_admin_group (create + update + delete users)
 """
   group_id = models.CharField(
   max_length=20,
   unique=True,
   help_text="Identificador único (AGR-001 a AGR-010)"
   )
   name = models.CharField(
   max_length=100,
   help_text="Nombre del grupo (basic_operator_group, user_admin_group)"
   )
   description = models.TextField(
   help_text="Descripción del grupo"
   )
   functions = models.ManyToManyField(
   Function,
   through='FunctionGroupMembership',
   related_name='groups',
   help_text="Funciones incluidas en este grupo"
   )
 
 class Meta:
 db_table = 'function_groups'
 verbose_name = 'Grupo de Funciones'
 verbose_name_plural = 'Grupos de Funciones'
 ordering = ['group_id']
 
 def __str__(self):
 return f"{self.group_id}: {self.name}"
 
 
 class FunctionGroupMembership(models.Model):
 """Pertenencia de una función a un grupo (tabla intermedia M2M)."""
 group = models.ForeignKey(
 FunctionGroup,
 on_delete=models.CASCADE,
 help_text="Grupo de funciones"
 )
 function = models.ForeignKey(
 Function,
 on_delete=models.CASCADE,
 help_text="Función que pertenece al grupo"
 )
 
 class Meta:
 db_table = 'function_group_membership'
 unique_together = [['group', 'function']]
 verbose_name = 'Pertenencia a Grupo'
 verbose_name_plural = 'Pertenencias a Grupos'
 
 
 class UserFunctionAssignment(models.Model):
 """
 Asignación directa de una función a un usuario.
 
 Tiene MAYOR precedencia que los grupos.
 Puede ser permanente o temporal (con vencimiento máx 6 meses).
 """
 user = models.ForeignKey(
 User,
 on_delete=models.CASCADE,
 related_name='function_assignments',
 help_text="Usuario al que se asigna la función"
 )
 function = models.ForeignKey(
 Function,
 on_delete=models.CASCADE,
 help_text="Función asignada"
 )
 assigned_at = models.DateTimeField(
 auto_now_add=True,
 help_text="Fecha y hora de asignación"
 )
 assigned_by = models.ForeignKey(
 User,
 on_delete=models.SET_NULL,
 null=True,
 related_name='functions_assigned_by_me',
 help_text="Usuario que realizó la asignación"
 )
 justification = models.TextField(
 blank=True,
 help_text="Justificación obligatoria si es temporal (mín 20 caracteres)"
 )
 expiration_date = models.DateField(
 null=True,
 blank=True,
 help_text="Fecha de vencimiento (máx 6 meses desde asignación)"
 )
 
 class Meta:
 db_table = 'user_function_assignments'
 unique_together = [['user', 'function']]
 verbose_name = 'Asignación de Función'
 verbose_name_plural = 'Asignaciones de Funciones'
 ordering = ['-assigned_at']
 
 def __str__(self):
 return f"{self.user.username} → {self.function.function_id}"
 
 
 class UserFunctionGroupAssignment(models.Model):
 """
 Asignación de un grupo de funciones a un usuario.
 
 El usuario obtiene automáticamente TODAS las funciones del grupo.
 Tiene MENOR precedencia que las asignaciones directas.
 """
 user = models.ForeignKey(
 User,
 on_delete=models.CASCADE,
 related_name='group_assignments',
 help_text="Usuario al que se asigna el grupo"
 )
 group = models.ForeignKey(
 FunctionGroup,
 on_delete=models.CASCADE,
 help_text="Grupo de funciones asignado"
 )
 assigned_at = models.DateTimeField(
 auto_now_add=True,
 help_text="Fecha y hora de asignación"
 )
 assigned_by = models.ForeignKey(
 User,
 on_delete=models.SET_NULL,
 null=True,
 related_name='groups_assigned_by_me',
 help_text="Usuario que realizó la asignación"
 )
 
 class Meta:
 db_table = 'user_function_group_assignments'
 unique_together = [['user', 'group']]
 verbose_name = 'Asignación de Grupo'
 verbose_name_plural = 'Asignaciones de Grupos'
 ordering = ['-assigned_at']
 
 def __str__(self):
 return f"{self.user.username} → {self.group.group_id}"
 
 
 class FunctionSeparationRule(models.Model):
 """
 Regla que define funciones que NO pueden coexistir (3 reglas).
 
 Un usuario NO puede tener simultáneamente funciones de 
 ambos grupos (A y B) de la misma regla.
 
 Ejemplo: pipeline_audit_separation
 - Grupo A: Funciones de pipeline (PIP-001 a PIP-004)
 - Grupo B: Funciones de auditoría (AUD-001 a AUD-004)
 """
   restriction_id = models.CharField(
   max_length=20,
   unique=True,
   help_text="Identificador único (SOD-001, SOD-002, SOD-003)"
   )
   name = models.CharField(
   max_length=100,
   help_text="Nombre de la regla (pipeline_audit_separation)"
   )
   description = models.TextField(
   help_text="Descripción de la restricción"
   )
   reason = models.TextField(
   help_text="Razón de negocio para la separación"
   )
   cnst_reference = models.CharField(
   max_length=20,
   help_text="Restricción CNST relacionada (CNST-005)"
   )
   active = models.BooleanField(
   default=True,
   help_text="Si la regla está activa"
   )
 
 class Meta:
 db_table = 'function_separation_rules'
 verbose_name = 'Regla de Separación de Funciones'
 verbose_name_plural = 'Reglas de Separación de Funciones'
 ordering = ['restriction_id']
 
 def __str__(self):
 return f"{self.restriction_id}: {self.name}"
 
 
 class FunctionSeparationRuleDetail(models.Model):
 """
 Detalle de una regla de separación.
 
 Define qué función pertenece a qué grupo (A o B) 
 dentro de una regla de separación.
 """
 rule = models.ForeignKey(
 FunctionSeparationRule,
 on_delete=models.CASCADE,
 related_name='details',
 help_text="Regla a la que pertenece"
 )
 function = models.ForeignKey(
 Function,
 on_delete=models.CASCADE,
 help_text="Función incluida en la regla"
 )
 rule_group = models.CharField(
 max_length=1,
 choices=[
 ('A', 'Grupo A'),
 ('B', 'Grupo B')
 ],
 help_text="Grupo al que pertenece la función en esta regla"
 )
 
 class Meta:
 db_table = 'function_separation_rule_details'
 unique_together = [['rule', 'function']]
 verbose_name = 'Detalle de Regla de Separación'
 verbose_name_plural = 'Detalles de Reglas de Separación'
 
 def __str__(self):
 return f"{self.rule.restriction_id} - {self.function.function_id} (Grupo {self.rule_group})"



9.2 Service (appsaccessservices.py)
-----------------------------------



.. code-block:: python

 """
 Servicio de permisos RBAC v5.2.1
 """
 from typing import Set, Tuple
 from django.contrib.auth import get_user_model
 from django.core.exceptions import ValidationError
 from django.utils import timezone
 from .models import (
 Function,
 FunctionGroup,
 UserFunctionAssignment,
 UserFunctionGroupAssignment,
 FunctionSeparationRule,
 FunctionSeparationRuleDetail,
 )
 
 User = get_user_model
 
 
 class PermissionService:
 """
 Servicio para gestión de permisos (RBAC v5.2.1).
 
 Clean Code v2.0.0:
 - Nombre descriptivo (NO "RBACService")
 - Métodos en inglés
 - Comentarios en español
 """
 
 def __init__(self, request_user: User = None):
 """
 Inicializa el servicio.
 
 Args:
 request_user: Usuario que realiza la operación
 """
 self.request_user = request_user
 
 def calculate_effective_functions(self, user: User) -> Set[str]:
 """
 Calcula funciones efectivas de un usuario.
 
 Precedencia:
 1. Funciones directas (UserFunctionAssignment)
 2. Funciones de grupos (UserFunctionGroupAssignment)
 
 Args:
 user: Usuario para calcular funciones
 
 Returns:
 Set of function_id: {'RPT-001', 'RPT-002', ...}
 """
 functions = set
 
 # 1. Funciones directas (mayor precedencia)
 direct_assignments = UserFunctionAssignment.objects.filter(
 user=user,
 ).select_related('function')
 
 for assignment in direct_assignments:
 # Validar vencimiento
 if assignment.expiration_date:
 if assignment.expiration_date >= timezone.now.date:
 functions.add(assignment.function.function_id)
 else:
 functions.add(assignment.function.function_id)
 
 # 2. Funciones de grupos (menor precedencia)
 group_assignments = UserFunctionGroupAssignment.objects.filter(
 user=user
 ).prefetch_related('group__functions')
 
 for assignment in group_assignments:
 functions.update(
 f.function_id 
 for f in assignment.group.functions.all
 )
 
 return functions
 
 def validate_separation_rules(
 self,
 user: User,
 new_function_id: str
 ) -> Tuple[bool, str]:
 """
 Valida reglas SoD antes de asignar función.
 
 Args:
 user: Usuario
 new_function_id: ID de función a asignar (ej: 'RPT-001')
 
 Returns:
 (valid, error_message)
 """
 current_functions = self.calculate_effective_functions(user)
 
 # Obtener reglas SoD activas
 active_rules = FunctionSeparationRule.objects.filter(
 active=True
 )
 
 for rule in active_rules:
 # Obtener funciones de grupos A y B
 details = FunctionSeparationRuleDetail.objects.filter(
 rule=rule
 ).select_related('function')
 
 group_a = set(
 d.function.function_id 
 for d in details 
 if d.rule_group == 'A'
 )
 group_b = set(
 d.function.function_id 
 for d in details 
 if d.rule_group == 'B'
 )
 
 # Validar conflicto
 if new_function_id in group_a:
 if current_functions & group_b:
 return False, (
 f"Violación SoD: {rule.name}. "
 f"Razón: {rule.reason}"
 )
 
 if new_function_id in group_b:
 if current_functions & group_a:
 return False, (
 f"Violación SoD: {rule.name}. "
 f"Razón: {rule.reason}"
 )
 
 return True, ""
 
 def assign_function_group(
 self,
 user: User,
 group_id: str,
 assigned_by: User
 ) -> UserFunctionGroupAssignment:
 """
 Asigna grupo de funciones a usuario validando SoD.
 
 Args:
 user: Usuario destino
 group_id: ID del grupo (ej: 'AGR-001')
 assigned_by: Usuario que asigna
 
 Returns:
 Asignación creada
 
 Raises:
 ValidationError: Si viola SoD
 """
 group = FunctionGroup.objects.get(group_id=group_id)
 
 # Validar SoD para cada función del grupo
 for function in group.functions.all:
 valid, message = self.validate_separation_rules(
 user,
 function.function_id
 )
 if not valid:
 raise ValidationError(message)
 
 # Asignar grupo
 assignment = UserFunctionGroupAssignment.objects.create(
 user=user,
 group=group,
 assigned_by=assigned_by
 )
 
 # Auditar (CNST-009)
 from apps.audit.services import AuditService
 AuditService.record_action(
 user=assigned_by,
 action='ASSIGN_FUNCTION_GROUP',
 resource_type='User',
 resource_id=str(user.id),
 details={
 'group_id': group_id,
 'group_name': group.name
 }
 )
 
 return assignment



9.3 Decorator (appsaccessdecorators.py)
---------------------------------------



.. code-block:: python

 """
 Decoradores para control de acceso RBAC v5.2.1
 """
 from functools import wraps
 from django.core.exceptions import PermissionDenied
 
 
 def require_function(*required_function_ids):
 """
 Decorator que valida función RBAC.
 
 El usuario debe tener AL MENOS UNA de las funciones requeridas.
 
 Args:
 *required_function_ids: IDs de funciones requeridas
 
 Uso:
 @require_function('RPT-001') # view_reports
 def list_reports(request):
 ...
 
 CNST-009: Audita intentos de acceso denegado.
 """
 def decorator(view_func):
 @wraps(view_func)
 def wrapper(request, *args, **kwargs):
 # Validar autenticación
 if not request.user.is_authenticated:
 raise PermissionDenied("Usuario no autenticado")
 
 # Obtener funciones del usuario
 user_functions = getattr(request, 'user_functions', set)
 
 # Validar si tiene alguna función requerida
 has_permission = any(
 fid in user_functions 
 for fid in required_function_ids
 )
 
 if not has_permission:
 # Auditar acceso denegado
 from apps.audit.services import AuditService
 AuditService.record_action(
 user=request.user,
 action='ACCESS_DENIED',
 resource_type='Endpoint',
 resource_id=request.path,
 result='FAIL',
 details={
 'required_functions': list(required_function_ids),
 'user_functions': list(user_functions)
 }
 )
 
 raise PermissionDenied(
 f"Requiere una de: {', '.join(required_function_ids)}"
 )
 
 return view_func(request, *args, **kwargs)
 
 return wrapper
 return decorator



9.4 Middleware (appsaccessmiddleware.py)
----------------------------------------



.. code-block:: python

 """
 Middleware de permisos RBAC v5.2.1
 """
 from django.utils.deprecation import MiddlewareMixin
 from .services import PermissionService
 
 
 class PermissionMiddleware(MiddlewareMixin):
 """
 Middleware que inyecta funciones efectivas en cada request.
 
 Inyecta `request.user_functions` con las funciones del usuario.
 
 CNST-002: Valida sesión única por usuario.
 """
 
 def __init__(self, get_response):
 """Inicializa el middleware."""
 self.get_response = get_response
 self.permission_service = PermissionService
 
 def __call__(self, request):
 """
 Procesa el request.
 
 Args:
 request: HttpRequest
 
 Returns:
 HttpResponse
 """
 if request.user.is_authenticated:
 # Calcular funciones efectivas
 request.user_functions = (
 self.permission_service.calculate_effective_functions(
 request.user
 )
 )
 
 # CNST-002: Validar sesión única
 self._validate_single_session(request)
 else:
 request.user_functions = set
 
 response = self.get_response(request)
 return response
 
 def _validate_single_session(self, request):
 """
 CNST-002: Solo una sesión activa por usuario.
 
 Si detecta sesión duplicada, invalida la anterior.
 """
 from django.contrib.sessions.models import Session
 from django.utils import timezone
 
 current_session_key = request.session.session_key
 
 # Buscar otras sesiones del mismo usuario
 active_sessions = Session.objects.filter(
 expire_date__gte=timezone.now
 )
 
 for session in active_sessions:
 data = session.get_decoded
 session_user_id = data.get('_auth_user_id')
 
 if session_user_id == str(request.user.id):
 if session.session_key != current_session_key:
 # Invalidar sesión anterior
 session.delete



9.5 Management Command
----------------------



.. code-block:: bash

 # Inicializar RBAC v5.2.1
 python manage.py initialize_permissions
 
 # O paso a paso:
 python manage.py initialize_functions # 42 funciones
 python manage.py initialize_function_groups # 10 grupos
 python manage.py initialize_separation_rules # 3 reglas SoD


----


10. MAPEO FUNCIONES → CASOS DE USO
==================================



10.1 Tabla Completa
-------------------



.. list-table::
 :widths: 33 33 33
 :header-rows: 1

 * - Función
   - Casos de Uso
   - Módulo
 * - view_own_sessions
   - UC-005
   - Auth
 * - close_user_session
   - UC-005
   - Auth
 * - reset_password
   - UC-003
   - Auth
 * - view_all_active_sessions
   - UC-005
   - Auth
 * - create_users
   - UC-006
   - Users
 * - update_users
   - UC-007
   - Users
 * - deactivate_users
   - UC-008
   - Users
 * - list_users
   - UC-009
   - Users
 * - search_users
   - UC-009
   - Users
 * - block_users
   - UC-007
   - Users
 * - unblock_users
   - UC-007
   - Users
 * - reactivate_users
   - UC-007
   - Users
 * - view_users
   - UC-009
   - Users
 * - assign_functions
   - UC-010, UC-042
   - Access
 * - revoke_functions
   - UC-010
   - Access
 * - view_assignments
   - UC-011, UC-044
   - Access
 * - assign_function_groups
   - UC-010
   - Access
 * - view_separation_rules
   - UC-043
   - Access
 * - update_separation_rule
   - UC-043
   - Access
 * - disable_separation_rule
   - UC-043
   - Access
 * - view_pipeline_status
   - UC-050
   - Pipeline
 * - view_pipeline_errors
   - UC-051
   - Pipeline
 * - view_data_availability
   - UC-052
   - Pipeline
 * - request_pipeline_retry
   - UC-053
   - Pipeline
 * - view_reports
   - UC-017, UC-018, UC-019
   - Reports
 * - view_dashboard
   - UC-025
   - Reports
 * - filter_reports
   - UC-020, UC-021
   - Reports
 * - export_csv
   - UC-022
   - Reports
 * - export_excel
   - UC-023
   - Reports
 * - export_pdf
   - UC-024
   - Reports
 * - view_kpis
   - UC-025
   - Reports
 * - view_charts
   - UC-027, UC-028, UC-029
   - Reports
 * - view_alerts
   - UC-039
   - Alerts
 * - configure_alerts
   - UC-036
   - Alerts
 * - configure_team_alerts
   - UC-040
   - Alerts
 * - pause_alerts
   - UC-038
   - Alerts
 * - disable_alerts
   - UC-038
   - Alerts
 * - view_alert_history
   - UC-039
   - Alerts
 * - acknowledge_alert
   - uc-alr-03
   - Alerts
 * - subscribe_to_alert
   - uc-alr-05
   - Alerts
 * - unsubscribe_from_alert
   - uc-alr-05
   - Alerts
 * - configure_subscription_severity
   - uc-alr-05
   - Alerts
 * - view_audit_log
   - UC-061
   - Audit
 * - search_audit_log
   - UC-061
   - Audit
 * - export_audit_log
   - UC-063
   - Audit
 * - generate_compliance_report
   - UC-062
   - Audit
 * - view_application_logs
   - uc-log-01
   - Logs
 * - export_logs
   - uc-log-04
   - Logs
 * - search_logs
   - uc-log-03
   - Logs
 * - view_etl_logs
   - uc-log-02
   - Logs
 * - view_infrastructure_logs
   - uc-log-05
   - Logs
 * - view_system_health
   - uc-log-06
   - Logs
 * - view_technical_metrics
   - uc-log-07
   - Logs


----


11. MIGRACIÓN DESDE v5.2.0
==========================



11.1 Cambios Breaking
---------------------



.. list-table::
 :widths: 33 33 33
 :header-rows: 1

 * - Aspecto
   - v5.2.0
   - v5.2.1
 * - **Nombres funciones**
   - Español
   - Inglés
 * - **Nombres grupos**
   - Español con `agr_`
   - Inglés sin prefijo
 * - **Nombres reglas SoD**
   - Español con `sod_`
   - Inglés sin prefijo
 * - **Campos**
   - `assigned_date`
   - `assigned_at`



11.2 Script de Migración SQL
----------------------------



.. code-block:: sql

 -- Actualizar 42 funciones
 UPDATE functions SET name = 'manage_sessions' WHERE function_id = 'AUTH-001';
 UPDATE functions SET name = 'close_user_session' WHERE function_id = 'AUTH-002';
 UPDATE functions SET name = 'reset_password' WHERE function_id = 'AUTH-003';
 UPDATE functions SET name = 'view_active_sessions' WHERE function_id = 'AUTH-004';
 
 UPDATE functions SET name = 'create_users' WHERE function_id = 'USR-001';
 UPDATE functions SET name = 'update_users' WHERE function_id = 'USR-002';
 UPDATE functions SET name = 'delete_users' WHERE function_id = 'USR-003';
 UPDATE functions SET name = 'list_users' WHERE function_id = 'USR-004';
 UPDATE functions SET name = 'search_users' WHERE function_id = 'USR-005';
 UPDATE functions SET name = 'block_users' WHERE function_id = 'USR-006';
 UPDATE functions SET name = 'unblock_users' WHERE function_id = 'USR-007';
 UPDATE functions SET name = 'reactivate_users' WHERE function_id = 'USR-008';
 UPDATE functions SET name = 'view_users' WHERE function_id = 'USR-009';
 
 UPDATE functions SET name = 'assign_functions' WHERE function_id = 'ACC-001';
 UPDATE functions SET name = 'revoke_functions' WHERE function_id = 'ACC-002';
 UPDATE functions SET name = 'view_assignments' WHERE function_id = 'ACC-003';
 UPDATE functions SET name = 'assign_function_groups' WHERE function_id = 'ACC-004';
 UPDATE functions SET name = 'manage_separation_rules' WHERE function_id = 'ACC-005';
 
 UPDATE functions SET name = 'view_pipeline_status' WHERE function_id = 'PIP-001';
 UPDATE functions SET name = 'view_pipeline_errors' WHERE function_id = 'PIP-002';
 UPDATE functions SET name = 'view_data_availability' WHERE function_id = 'PIP-003';
 UPDATE functions SET name = 'request_pipeline_retry' WHERE function_id = 'PIP-004';
 
 UPDATE functions SET name = 'view_reports' WHERE function_id = 'RPT-001';
 UPDATE functions SET name = 'view_dashboard' WHERE function_id = 'RPT-002';
 UPDATE functions SET name = 'filter_reports' WHERE function_id = 'RPT-003';
 UPDATE functions SET name = 'export_csv' WHERE function_id = 'RPT-004';
 UPDATE functions SET name = 'export_excel' WHERE function_id = 'RPT-005';
 UPDATE functions SET name = 'export_pdf' WHERE function_id = 'RPT-006';
 UPDATE functions SET name = 'view_kpis' WHERE function_id = 'RPT-007';
 UPDATE functions SET name = 'view_charts' WHERE function_id = 'RPT-008';
 
 UPDATE functions SET name = 'view_alerts' WHERE function_id = 'ALR-001';
 UPDATE functions SET name = 'configure_alerts' WHERE function_id = 'ALR-002';
 UPDATE functions SET name = 'configure_team_alerts' WHERE function_id = 'ALR-003';
 UPDATE functions SET name = 'pause_alerts' WHERE function_id = 'ALR-004';
 UPDATE functions SET name = 'delete_alerts' WHERE function_id = 'ALR-005';
 UPDATE functions SET name = 'view_alert_history' WHERE function_id = 'ALR-006';
 
 UPDATE functions SET name = 'view_audit_log' WHERE function_id = 'AUD-001';
 UPDATE functions SET name = 'search_audit_log' WHERE function_id = 'AUD-002';
 UPDATE functions SET name = 'export_audit_log' WHERE function_id = 'AUD-003';
 UPDATE functions SET name = 'generate_compliance_report' WHERE function_id = 'AUD-004';
 
 UPDATE functions SET name = 'view_technical_logs' WHERE function_id = 'LOG-001';
 UPDATE functions SET name = 'export_logs' WHERE function_id = 'LOG-002';
 
 -- Actualizar 10 grupos
 UPDATE function_groups SET name = 'basic_operator_group' WHERE group_id = 'AGR-001';
 UPDATE function_groups SET name = 'report_viewer_group' WHERE group_id = 'AGR-002';
 UPDATE function_groups SET name = 'quality_supervisor_group' WHERE group_id = 'AGR-003';
 UPDATE function_groups SET name = 'data_exporter_group' WHERE group_id = 'AGR-004';
 UPDATE function_groups SET name = 'alert_manager_group' WHERE group_id = 'AGR-005';
 UPDATE function_groups SET name = 'user_admin_group' WHERE group_id = 'AGR-006';
 UPDATE function_groups SET name = 'permission_admin_group' WHERE group_id = 'AGR-007';
 UPDATE function_groups SET name = 'auditor_group' WHERE group_id = 'AGR-008';
 UPDATE function_groups SET name = 'pipeline_admin_group' WHERE group_id = 'AGR-009';
 UPDATE function_groups SET name = 'system_admin_group' WHERE group_id = 'AGR-010';
 
 -- Actualizar 3 reglas SoD
 UPDATE function_separation_rules 
 SET name = 'pipeline_audit_separation',
 description = 'Pipeline operations cannot audit themselves'
 WHERE restriction_id = 'SOD-001';
 
 UPDATE function_separation_rules 
 SET name = 'user_audit_separation',
 description = 'User management cannot audit themselves'
 WHERE restriction_id = 'SOD-002';
 
 UPDATE function_separation_rules 
 SET name = 'access_audit_separation',
 description = 'Permission management cannot audit themselves'
 WHERE restriction_id = 'SOD-003';
 
 -- Renombrar columnas (si es necesario)
 ALTER TABLE user_function_assignments 
 CHANGE assigned_date assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
 
 ALTER TABLE user_function_group_assignments 
 CHANGE assigned_date assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;
 
 ALTER TABLE function_separation_rule_details 
 CHANGE separation_group rule_group CHAR(1) NOT NULL;


----

12. RESUMEN
===========



12.1 Métricas del Modelo v5.2.1
-------------------------------



.. list-table::
 :widths: 50 50
 :header-rows: 1

 * - Aspecto
   - Valor
 * - **Filosofía**
   - Sin Pretensiones
 * - **Módulos IACT**
   - 8
 * - **Funciones atómicas**
   - 42
 * - **Grupos**
   - 10
 * - **Restricciones SoD**
   - 3
 * - **Segmentos de datos**
   - 0
 * - **Restricciones CNST**
   - 8
 * - **Nomenclatura**
   - Inglés (Clean Code v2.0.0)
 * - **Consistencia**
   - 100%



12.2 Cambios Clave v5.2.1
-------------------------


1. **[OK] 100% Inglés en código:**
   - Funciones: ``manage_sessions``, ``view_reports``, ``export_csv``
   - Grupos: ``basic_operator_group``, ``user_admin_group``
   - Reglas SoD: ``pipeline_audit_separation``

2. **[OK] Clean Code completo:**
   - Sin prefijos redundantes (``agr_``, ``sod_``)
   - Sin acrónimos en nombres (ETL en descripción OK)
   - Nombres descriptivos completos

3. **[OK] Convenciones SQL:**
   - ``assigned_at`` (NO ``assigned_date``)
   - ``rule_group`` (NO ``separation_group``)

4. **[OK] Comentarios español:**
   - Docstrings en español
   - ``help_text`` en español
   - ``description`` en español

----

**FIN DEL DOCUMENTO**

**Versión:** 5.2.1 
**Fecha:** 13 de enero de 2026 
**Estado:** [OK] Listo para Implementación 
**Changelog:**
- v5.2.0 → v5.2.1: Consistencia 100% inglés en código
- Nombres funciones: español → inglés
- Nombres grupos: español + ``agr_`` → inglés sin prefijo
- Nombres reglas SoD: español + ``sod_`` → inglés sin prefijo
- Campos: ``assigned_date`` → ``assigned_at``, ``separation_group`` → ``rule_group``
- Base: Clean Code v2.0.0 + MODELO_RBAC_IACT_v5_1_1.rst
