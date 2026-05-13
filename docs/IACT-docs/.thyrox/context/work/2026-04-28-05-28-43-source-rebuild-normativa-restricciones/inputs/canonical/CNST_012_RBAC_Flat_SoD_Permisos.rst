.. _cnst-012:

CNST-012: Modelo RBAC Flat + SoD + Permisos Temporales
======================================================

:ID: CNST-012
:Versión: 1.0.0
:Fecha: 2026-04-27
:Estado: VIGENTE
:Clasificación: CRÍTICO - NO NEGOCIABLE
:Origen: Decisión arquitectónica de seguridad (ADR-BACK-004)
:Base: MODELO_RBAC_IACT v5.2.2 (consolidación)

----

Propósito
---------

Este documento establece el modelo de control de acceso basado en funciones
atómicas (RBAC v5.2.2) del Sistema IACT — IVR Analytics & Customer Tracking.
Define el catálogo completo de **42 funciones**, **10 grupos de funciones**,
**3 reglas de separación de funciones (SoD)** y la política de **permisos
temporales** con justificación y vencimiento obligatorios.

Esta restricción consolida en un único documento canónico la información que
hasta ahora estaba distribuida entre :ref:`br-006` (regla de negocio),
:ref:`mtm-03` (metamodelo formal) y los nueve casos de uso del módulo Access.

Contexto
--------

Origen de la Restricción
~~~~~~~~~~~~~~~~~~~~~~~~

Decisión arquitectónica documentada en ADR-BACK-004 (sistema de permisos sin
roles jerárquicos). El sistema rechaza el modelo tradicional de roles
jerárquicos (Admin / Supervisor / Operador) por las siguientes razones
documentadas:

- Rigidez en la asignación (un usuario, un rol)
- Explosión combinatoria de roles cuando se requieren capacidades cruzadas
- Estigmatización por etiquetas de cargo
- Mantenimiento complejo (cambiar un rol afecta a todos los que lo tengan)

Filosofía del Modelo
~~~~~~~~~~~~~~~~~~~~

**Principio central:** los nombres de funciones describen QUÉ HACE la función,
NO QUIÉN es la persona.

- Incorrecto (con pretensiones): ``ADMIN``, ``SUPERVISOR``, ``USERS_FULL_MANAGER``
- Correcto (sin pretensiones): ``create_users``, ``view_reports``, ``export_csv``

Aplicable a
~~~~~~~~~~~

- Todos los módulos del sistema IACT (8 módulos)
- Todos los endpoints autenticados (validación por SEC_RULES)
- Todas las decisiones de autorización en runtime
- Todas las fases del ciclo de vida (desarrollo, QA, producción)

----

Restricciones
-------------

Modelo RBAC Flat (NIST RBAC Level 0)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OBLIGATORIO:

- El modelo de acceso DEBE seguir NIST RBAC Level 0 (Flat) con extensión SoD
- NO existe herencia entre roles, grupos ni funciones
- Los usuarios reciben funciones atómicas directamente o vía grupos
- Los grupos NO heredan de otros grupos

PROHIBIDO:

- Jerarquías de roles (Admin > Supervisor > Operador)
- Herencia transitiva de permisos
- Roles abstractos sin función concreta
- Wildcards de permisos (``*``, ``all``, ``admin``)

Separación de Funciones (SoD) Obligatoria
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OBLIGATORIO:

- Validar las 3 reglas SoD ANTES de cada asignación de función
- Validar SoD también al asignar grupos (todas las funciones del grupo)
- Bloquear la asignación si viola SoD
- Auditar el intento bloqueado (CNST-009)

PROHIBIDO:

- Bypass de SoD por usuarios privilegiados
- Desactivar SoD globalmente sin proceso de excepción formal
- Funciones del Grupo A coexistiendo con funciones del Grupo B en un mismo
  usuario para cualquier regla SoD activa

Permisos Temporales con Vencimiento
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

OBLIGATORIO:

- Justificación de mínimo 20 caracteres
- Fecha de vencimiento de máximo 6 meses desde la asignación
- Revocación automática al vencer (proceso programado)
- Auditoría completa del ciclo: asignación, uso, revocación

PROHIBIDO:

- Permisos temporales sin justificación
- Permisos temporales sin fecha de vencimiento
- Vencimientos superiores a 6 meses
- Renovación automática sin nueva justificación

----

Arquitectura: 8 Módulos Funcionales
-----------------------------------

Distribución de las 42 Funciones
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 20 10 10 60

   * - Módulo
     - Prefijo
     - Funciones
     - Propósito
   * - MOD_Auth
     - AUT
     - 4
     - Sesiones y autenticación
   * - MOD_Users
     - USR
     - 9
     - Gestión de identidades
   * - MOD_Access
     - ACC
     - 5
     - RBAC core + SEC_RULES
   * - MOD_Pipeline
     - PIP
     - 4
     - Supervisión ETL
   * - MOD_Reports
     - RPT
     - 8
     - Dashboards y reportes (núcleo de negocio)
   * - MOD_Alerts
     - ALR
     - 6
     - Alertas internas
   * - MOD_Audit
     - AUD
     - 4
     - Auditoría funcional
   * - MOD_Logs
     - LOG
     - 2
     - Logs técnicos
   * - **TOTAL**
     - —
     - **42**
     - —

----

Catálogo de 42 Funciones
------------------------

Convención: ``function_id`` es identificador estable; ``name`` está en inglés
(snake_case) y describe la acción atómica; ``description`` está en español y
documenta la semántica para auditoría y formación.

MOD_Auth (4 funciones)
~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 25 25 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - AUT-001
     - ``manage_sessions``
     - auth:sessions
     - Gestiona sesiones activas del sistema
   * - AUT-002
     - ``close_user_session``
     - auth:close_session
     - Cierra la sesión de otro usuario
   * - AUT-003
     - ``reset_password``
     - auth:reset_password
     - Genera contraseña temporal de recuperación
   * - AUT-004
     - ``view_active_sessions``
     - auth:view_sessions
     - Consulta sesiones activas del sistema

CNST aplicables: CNST-001 (notificación por buzón interno),
CNST-002 (sesión única, timeout 15 min).

MOD_Users (9 funciones)
~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 25 25 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - USR-001
     - ``create_users``
     - users:create
     - Crea nuevos usuarios
   * - USR-002
     - ``update_users``
     - users:update
     - Modifica datos de usuarios
   * - USR-003
     - ``delete_users``
     - users:delete
     - Baja lógica de usuarios
   * - USR-004
     - ``list_users``
     - users:list
     - Lista usuarios con filtros
   * - USR-005
     - ``search_users``
     - users:search
     - Busca usuarios por criterios
   * - USR-006
     - ``block_users``
     - users:block
     - Bloquea acceso de un usuario
   * - USR-007
     - ``unblock_users``
     - users:unblock
     - Desbloquea un usuario
   * - USR-008
     - ``reactivate_users``
     - users:reactivate
     - Reactiva un usuario inactivo
   * - USR-009
     - ``view_users``
     - users:view
     - Consulta información de usuarios

CNST aplicables: CNST-001 (notificación por buzón interno),
bajas siempre lógicas.

MOD_Access (5 funciones)
~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 28 22 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - ACC-001
     - ``assign_functions``
     - access:assign
     - Asigna funciones a usuarios
   * - ACC-002
     - ``revoke_functions``
     - access:revoke
     - Revoca funciones de usuarios
   * - ACC-003
     - ``view_assignments``
     - access:view
     - Consulta asignaciones efectivas
   * - ACC-004
     - ``assign_function_groups``
     - access:assign_group
     - Asigna grupos de funciones (asignación en bloque)
   * - ACC-005
     - ``manage_separation_rules``
     - access:sod
     - Configura reglas de separación de funciones (SoD)

Componente complementario interno: **SEC_RULES** (middleware de enforcement
automático sin pantallas visibles al usuario).

MOD_Pipeline (4 funciones)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 26 24 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - PIP-001
     - ``view_pipeline_status``
     - pipeline:view_status
     - Consulta estado actual del proceso ETL
   * - PIP-002
     - ``view_pipeline_errors``
     - pipeline:view_errors
     - Consulta errores del ETL
   * - PIP-003
     - ``view_data_availability``
     - pipeline:availability
     - Consulta disponibilidad de datos
   * - PIP-004
     - ``request_pipeline_retry``
     - pipeline:retry
     - Solicita un reintento del ETL

CNST aplicables: CNST-003 (BD IVR readonly, ETL 6-12h, NO real-time),
CNST-009 (auditar acciones críticas).

MOD_Reports (8 funciones — núcleo de negocio)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 22 22 44

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - RPT-001
     - ``view_reports``
     - reports:view
     - Visualiza reportes tabulares
   * - RPT-002
     - ``view_dashboard``
     - reports:dashboard
     - Visualiza el dashboard principal
   * - RPT-003
     - ``filter_reports``
     - reports:filter
     - Aplica filtros a reportes (rango, centro, etc.)
   * - RPT-004
     - ``export_csv``
     - reports:export_csv
     - Exporta a CSV (límite 100 000 registros)
   * - RPT-005
     - ``export_excel``
     - reports:export_excel
     - Exporta a Excel (límite 50 000 registros)
   * - RPT-006
     - ``export_pdf``
     - reports:export_pdf
     - Exporta a PDF (límite 10 000 registros)
   * - RPT-007
     - ``view_kpis``
     - reports:kpis
     - Visualiza KPIs estáticos
   * - RPT-008
     - ``view_charts``
     - reports:charts
     - Visualiza gráficos predefinidos

CNST aplicables: CNST-003 (datos desfasados 6-12h),
CNST-006 (rango máximo 2 años), CNST-007 (límites por formato y throttling).

MOD_Alerts (6 funciones)
~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 26 24 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - ALR-001
     - ``view_alerts``
     - alerts:view
     - Consulta alertas propias
   * - ALR-002
     - ``configure_alerts``
     - alerts:configure
     - Configura alertas personales
   * - ALR-003
     - ``configure_team_alerts``
     - alerts:config_team
     - Configura alertas de equipo
   * - ALR-004
     - ``pause_alerts``
     - alerts:pause
     - Pausa alertas temporalmente
   * - ALR-005
     - ``delete_alerts``
     - alerts:delete
     - Elimina alertas propias
   * - ALR-006
     - ``view_alert_history``
     - alerts:history
     - Consulta historial de alertas

CNST aplicables: CNST-001 (solo buzón interno), CNST-004 (máximo 50
destinatarios por alerta), CNST-009 (auditar configuración).

MOD_Audit (4 funciones)
~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 28 22 38

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - AUD-001
     - ``view_audit_log``
     - audit:view
     - Consulta registros de auditoría
   * - AUD-002
     - ``search_audit_log``
     - audit:search
     - Busca en registros de auditoría
   * - AUD-003
     - ``export_audit_log``
     - audit:export
     - Exporta registros de auditoría
   * - AUD-004
     - ``generate_compliance_report``
     - audit:compliance
     - Genera reporte de cumplimiento

CNST aplicables: CNST-008/CNST-009 (registros inmutables, retención mínima
2 años, sin PII innecesaria, checksum SHA-256 por registro).

MOD_Logs (2 funciones)
~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 12 26 22 40

   * - ID
     - name (inglés)
     - capability
     - Descripción
   * - LOG-001
     - ``view_technical_logs``
     - logs:view
     - Consulta logs técnicos del sistema
   * - LOG-002
     - ``export_logs``
     - logs:export
     - Exporta logs técnicos

CNST aplicables: CNST-008/CNST-009 (sin PII, formato JSON estructurado,
retención 30-90 días según tipo).

Diferencia con MOD_Audit
^^^^^^^^^^^^^^^^^^^^^^^^

- MOD_Audit registra **eventos de negocio** (quién hizo qué, cuándo, sobre
  qué recurso) — relevante para compliance y forense.
- MOD_Logs registra **eventos técnicos** (errores, performance, latencia) —
  relevante para SRE y debugging.

----

Catálogo de 10 Grupos de Funciones
----------------------------------

Un grupo agrupa varias funciones para asignarlas en bloque a un usuario. Los
grupos NO heredan entre sí; cada grupo lista explícitamente sus funciones.

.. list-table::
   :header-rows: 1
   :widths: 10 28 12 50

   * - ID
     - name (inglés)
     - Funciones
     - Propósito
   * - AGR-001
     - ``basic_operator_group``
     - 6
     - Visualización básica
   * - AGR-002
     - ``report_viewer_group``
     - 8
     - Análisis con filtros, sin exportación
   * - AGR-003
     - ``quality_supervisor_group``
     - 11
     - Análisis avanzado y alertas propias
   * - AGR-004
     - ``data_exporter_group``
     - 14
     - Exportación autorizada (CSV/Excel/PDF)
   * - AGR-005
     - ``alert_manager_group``
     - 6
     - Gestión completa de alertas
   * - AGR-006
     - ``user_admin_group``
     - 9
     - Administración de identidades
   * - AGR-007
     - ``permission_admin_group``
     - 5
     - Administración de RBAC
   * - AGR-008
     - ``auditor_group``
     - 4
     - Auditoría y compliance
   * - AGR-009
     - ``pipeline_admin_group``
     - 4
     - Supervisión del ETL
   * - AGR-010
     - ``system_admin_group``
     - 6
     - Administración técnica del sistema

Membresía detallada
~~~~~~~~~~~~~~~~~~~

AGR-001 ``basic_operator_group`` (6 funciones)::

   AUT-001 manage_sessions
   AUT-004 view_active_sessions
   RPT-001 view_reports
   RPT-002 view_dashboard
   RPT-007 view_kpis
   RPT-008 view_charts

AGR-002 ``report_viewer_group`` (8 funciones)::

   AGR-001 completo +
   RPT-003 filter_reports
   USR-009 view_users

AGR-003 ``quality_supervisor_group`` (11 funciones)::

   AGR-002 completo +
   ALR-001 view_alerts
   ALR-002 configure_alerts
   ALR-006 view_alert_history

AGR-004 ``data_exporter_group`` (14 funciones)::

   AGR-003 completo +
   RPT-004 export_csv
   RPT-005 export_excel
   RPT-006 export_pdf

AGR-005 ``alert_manager_group`` (6 funciones)::

   ALR-001 view_alerts
   ALR-002 configure_alerts
   ALR-003 configure_team_alerts
   ALR-004 pause_alerts
   ALR-005 delete_alerts
   ALR-006 view_alert_history

AGR-006 ``user_admin_group`` (9 funciones)::

   USR-001 create_users
   USR-002 update_users
   USR-003 delete_users
   USR-004 list_users
   USR-005 search_users
   USR-006 block_users
   USR-007 unblock_users
   USR-008 reactivate_users
   USR-009 view_users

AGR-007 ``permission_admin_group`` (5 funciones)::

   ACC-001 assign_functions
   ACC-002 revoke_functions
   ACC-003 view_assignments
   ACC-004 assign_function_groups
   ACC-005 manage_separation_rules

AGR-008 ``auditor_group`` (4 funciones)::

   AUD-001 view_audit_log
   AUD-002 search_audit_log
   AUD-003 export_audit_log
   AUD-004 generate_compliance_report

AGR-009 ``pipeline_admin_group`` (4 funciones)::

   PIP-001 view_pipeline_status
   PIP-002 view_pipeline_errors
   PIP-003 view_data_availability
   PIP-004 request_pipeline_retry

AGR-010 ``system_admin_group`` (6 funciones)::

   AUT-001 manage_sessions
   AUT-002 close_user_session
   AUT-003 reset_password
   AUT-004 view_active_sessions
   LOG-001 view_technical_logs
   LOG-002 export_logs

----

Reglas de Separación de Funciones (SoD)
---------------------------------------

Tres reglas SoD activas. Cada regla define dos grupos de funciones (A y B)
mutuamente excluyentes para un mismo usuario.

SOD-001: ``pipeline_audit_separation``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Restricción:** un usuario NO puede tener funciones de Pipeline Y de
Auditoría simultáneamente.

**Razón:** evitar que quien opera el ETL audite sus propias acciones —
pérdida de objetividad e independencia del control.

**Grupo A (Pipeline):**

- PIP-001 ``view_pipeline_status``
- PIP-002 ``view_pipeline_errors``
- PIP-003 ``view_data_availability``
- PIP-004 ``request_pipeline_retry``

**Grupo B (Auditoría):**

- AUD-001 ``view_audit_log``
- AUD-002 ``search_audit_log``
- AUD-003 ``export_audit_log``
- AUD-004 ``generate_compliance_report``

SOD-002: ``user_audit_separation``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Restricción:** un usuario NO puede tener funciones críticas de gestión de
usuarios Y de auditoría simultáneamente.

**Razón:** evitar que quien crea, elimina o desbloquea usuarios audite las
trazas de esas mismas acciones.

**Grupo A (Usuarios — funciones críticas):**

- USR-001 ``create_users``
- USR-003 ``delete_users``
- USR-004 ``list_users``
- USR-007 ``unblock_users``

**Grupo B (Auditoría):**

- AUD-001 ``view_audit_log``
- AUD-002 ``search_audit_log``
- AUD-003 ``export_audit_log``

SOD-003: ``access_audit_separation``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Restricción:** un usuario NO puede tener funciones de gestión de acceso Y
de auditoría simultáneamente.

**Razón:** separación de poderes entre quien asigna o revoca permisos y
quien audita esos cambios.

**Grupo A (Acceso):**

- ACC-001 ``assign_functions``
- ACC-002 ``revoke_functions``
- ACC-005 ``manage_separation_rules``

**Grupo B (Auditoría):**

- AUD-001 ``view_audit_log``
- AUD-002 ``search_audit_log``

----

Permisos Temporales
-------------------

Una función puede asignarse de forma **temporal** con vencimiento
obligatorio. Casos de uso típicos: cobertura de vacaciones, proyecto
acotado, prueba controlada, auditoría externa puntual.

Reglas
~~~~~~

1. Justificación obligatoria, mínimo 20 caracteres.
2. Fecha de vencimiento obligatoria, máximo 6 meses desde la asignación.
3. Auditoría obligatoria del ciclo completo (CNST-009).
4. Renovación requiere nueva justificación; no hay auto-renovación.
5. Revocación automática al vencer (proceso programado diario).
6. Validación SoD aplica también a permisos temporales.

Precedencia
~~~~~~~~~~~

De mayor a menor precedencia:

1. Asignación directa temporal vigente (con vencimiento futuro).
2. Asignación directa permanente (sin vencimiento).
3. Asignación heredada de un grupo de funciones.

Si un usuario tiene la misma función por más de un origen, se usa el origen
con mayor precedencia para la auditoría del acceso.

----

Modelo de Datos (Apéndice DDL de Referencia)
--------------------------------------------

Schema lógico de las 7 tablas que materializan el modelo. Los nombres de
tabla y columna están en inglés (Clean Code v2.0.0); los comentarios de
``description`` y ``reason`` están en español.

Tabla ``functions``
~~~~~~~~~~~~~~~~~~~

Catálogo inmutable de las 42 funciones atómicas.

.. code-block:: sql

   CREATE TABLE functions (
       function_id  VARCHAR(20) PRIMARY KEY,
       name         VARCHAR(100) NOT NULL UNIQUE,
       description  TEXT NOT NULL,
       category     VARCHAR(50) NOT NULL,
       CONSTRAINT chk_category CHECK (category IN (
           'auth','users','access','pipeline',
           'reports','alerts','audit','logs'
       ))
   );

Tabla ``function_groups``
~~~~~~~~~~~~~~~~~~~~~~~~~

Catálogo de los 10 grupos.

.. code-block:: sql

   CREATE TABLE function_groups (
       group_id     VARCHAR(20) PRIMARY KEY,
       name         VARCHAR(100) NOT NULL UNIQUE,
       description  TEXT NOT NULL
   );

Tabla ``function_group_membership``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pertenencia M:N entre funciones y grupos.

.. code-block:: sql

   CREATE TABLE function_group_membership (
       group_id     VARCHAR(20) NOT NULL,
       function_id  VARCHAR(20) NOT NULL,
       PRIMARY KEY (group_id, function_id),
       FOREIGN KEY (group_id)    REFERENCES function_groups(group_id),
       FOREIGN KEY (function_id) REFERENCES functions(function_id)
   );

Tabla ``user_function_assignments``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Asignaciones directas usuario-función. ``expiration_date`` se mantiene como
DATE (no datetime) porque la convención ``*_at`` se reserva para timestamps
exactos; este campo representa "vence el día N completo".

.. code-block:: sql

   CREATE TABLE user_function_assignments (
       user_id          BIGINT NOT NULL,
       function_id      VARCHAR(20) NOT NULL,
       assigned_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       assigned_by      BIGINT NULL,
       justification    TEXT,
       expiration_date  DATE NULL,
       PRIMARY KEY (user_id, function_id),
       FOREIGN KEY (function_id) REFERENCES functions(function_id),
       CONSTRAINT chk_justification_length
           CHECK (justification IS NULL OR LENGTH(justification) >= 20),
       CONSTRAINT chk_expiration_date
           CHECK (expiration_date IS NULL OR
                  expiration_date <= DATE_ADD(assigned_at, INTERVAL 6 MONTH))
   );

Tabla ``user_function_group_assignments``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Asignaciones de grupo a usuario.

.. code-block:: sql

   CREATE TABLE user_function_group_assignments (
       user_id      BIGINT NOT NULL,
       group_id     VARCHAR(20) NOT NULL,
       assigned_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       assigned_by  BIGINT NULL,
       PRIMARY KEY (user_id, group_id),
       FOREIGN KEY (group_id) REFERENCES function_groups(group_id)
   );

Tabla ``function_separation_rules``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Catálogo de las 3 reglas SoD. PK ``rule_id`` por consistencia con
``rule_group`` de la tabla detalle.

.. code-block:: sql

   CREATE TABLE function_separation_rules (
       rule_id         VARCHAR(20) PRIMARY KEY,
       name            VARCHAR(100) NOT NULL UNIQUE,
       description     TEXT NOT NULL,
       reason          TEXT NOT NULL,
       cnst_reference  VARCHAR(20) NOT NULL,
       active          BOOLEAN NOT NULL DEFAULT TRUE
   );

Tabla ``function_separation_rule_details``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Membresía función-regla con grupo A o B.

.. code-block:: sql

   CREATE TABLE function_separation_rule_details (
       rule_id      VARCHAR(20) NOT NULL,
       function_id  VARCHAR(20) NOT NULL,
       rule_group   CHAR(1) NOT NULL,
       PRIMARY KEY (rule_id, function_id),
       FOREIGN KEY (rule_id)     REFERENCES function_separation_rules(rule_id),
       FOREIGN KEY (function_id) REFERENCES functions(function_id),
       CONSTRAINT chk_group CHECK (rule_group IN ('A','B'))
   );

----

Datos Iniciales (Seed)
----------------------

42 Funciones
~~~~~~~~~~~~

.. code-block:: sql

   INSERT INTO functions (function_id, name, description, category) VALUES
   ('AUT-001','manage_sessions','Gestiona sesiones activas del sistema','auth'),
   ('AUT-002','close_user_session','Cierra la sesión de otro usuario','auth'),
   ('AUT-003','reset_password','Genera contraseña temporal de recuperación','auth'),
   ('AUT-004','view_active_sessions','Consulta sesiones activas del sistema','auth'),
   ('USR-001','create_users','Crea nuevos usuarios','users'),
   ('USR-002','update_users','Modifica datos de usuarios','users'),
   ('USR-003','delete_users','Baja lógica de usuarios','users'),
   ('USR-004','list_users','Lista usuarios con filtros','users'),
   ('USR-005','search_users','Busca usuarios por criterios','users'),
   ('USR-006','block_users','Bloquea acceso de un usuario','users'),
   ('USR-007','unblock_users','Desbloquea un usuario','users'),
   ('USR-008','reactivate_users','Reactiva un usuario inactivo','users'),
   ('USR-009','view_users','Consulta información de usuarios','users'),
   ('ACC-001','assign_functions','Asigna funciones a usuarios','access'),
   ('ACC-002','revoke_functions','Revoca funciones de usuarios','access'),
   ('ACC-003','view_assignments','Consulta asignaciones efectivas','access'),
   ('ACC-004','assign_function_groups','Asigna grupos de funciones en bloque','access'),
   ('ACC-005','manage_separation_rules','Configura reglas de separación de funciones','access'),
   ('PIP-001','view_pipeline_status','Consulta estado actual del proceso ETL','pipeline'),
   ('PIP-002','view_pipeline_errors','Consulta errores del ETL','pipeline'),
   ('PIP-003','view_data_availability','Consulta disponibilidad de datos','pipeline'),
   ('PIP-004','request_pipeline_retry','Solicita un reintento del ETL','pipeline'),
   ('RPT-001','view_reports','Visualiza reportes tabulares','reports'),
   ('RPT-002','view_dashboard','Visualiza el dashboard principal','reports'),
   ('RPT-003','filter_reports','Aplica filtros a reportes','reports'),
   ('RPT-004','export_csv','Exporta a CSV (límite 100 000 registros)','reports'),
   ('RPT-005','export_excel','Exporta a Excel (límite 50 000 registros)','reports'),
   ('RPT-006','export_pdf','Exporta a PDF (límite 10 000 registros)','reports'),
   ('RPT-007','view_kpis','Visualiza KPIs estáticos','reports'),
   ('RPT-008','view_charts','Visualiza gráficos predefinidos','reports'),
   ('ALR-001','view_alerts','Consulta alertas propias','alerts'),
   ('ALR-002','configure_alerts','Configura alertas personales','alerts'),
   ('ALR-003','configure_team_alerts','Configura alertas de equipo','alerts'),
   ('ALR-004','pause_alerts','Pausa alertas temporalmente','alerts'),
   ('ALR-005','delete_alerts','Elimina alertas propias','alerts'),
   ('ALR-006','view_alert_history','Consulta historial de alertas','alerts'),
   ('AUD-001','view_audit_log','Consulta registros de auditoría','audit'),
   ('AUD-002','search_audit_log','Busca en registros de auditoría','audit'),
   ('AUD-003','export_audit_log','Exporta registros de auditoría','audit'),
   ('AUD-004','generate_compliance_report','Genera reporte de cumplimiento','audit'),
   ('LOG-001','view_technical_logs','Consulta logs técnicos del sistema','logs'),
   ('LOG-002','export_logs','Exporta logs técnicos','logs');

10 Grupos
~~~~~~~~~

.. code-block:: sql

   INSERT INTO function_groups (group_id, name, description) VALUES
   ('AGR-001','basic_operator_group','Visualización básica de reportes y dashboard'),
   ('AGR-002','report_viewer_group','Análisis de reportes con filtros'),
   ('AGR-003','quality_supervisor_group','Supervisión con alertas propias'),
   ('AGR-004','data_exporter_group','Exportación autorizada de datos'),
   ('AGR-005','alert_manager_group','Gestión completa de alertas'),
   ('AGR-006','user_admin_group','Administración de usuarios'),
   ('AGR-007','permission_admin_group','Administración de permisos RBAC'),
   ('AGR-008','auditor_group','Auditoría y compliance'),
   ('AGR-009','pipeline_admin_group','Administración del ETL'),
   ('AGR-010','system_admin_group','Administración técnica del sistema');

3 Reglas SoD
~~~~~~~~~~~~

.. code-block:: sql

   INSERT INTO function_separation_rules
       (rule_id, name, description, reason, cnst_reference) VALUES
   ('SOD-001','pipeline_audit_separation',
    'Quien opera el ETL no puede auditar sus propias acciones',
    'Evitar que el operador del ETL audite las trazas de su propia operación',
    'CNST-012'),
   ('SOD-002','user_audit_separation',
    'Quien gestiona usuarios no puede auditar las trazas de esa gestión',
    'Evitar que quien crea, elimina o desbloquea usuarios revise su auditoría',
    'CNST-012'),
   ('SOD-003','access_audit_separation',
    'Quien gestiona el acceso no puede auditar los cambios de permisos',
    'Separar a quien asigna o revoca permisos de quien audita esos cambios',
    'CNST-012');

----

Impacto en Sistema
------------------

Módulos Afectados
~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Módulo
     - Impacto
   * - MOD_Access (RBAC_CORE)
     - Implementa el catálogo, los grupos, las reglas SoD y la API de
       asignación.
   * - MOD_Access (SEC_RULES)
     - Middleware que evalúa las funciones efectivas en cada request y
       deniega accesos no autorizados.
   * - MOD_Audit
     - Recibe eventos de cada asignación, revocación, intento bloqueado y
       cambio de regla SoD.
   * - Resto de módulos (Auth, Users, Pipeline, Reports, Alerts, Logs)
     - Cada endpoint declara la función requerida; SEC_RULES la valida.

Casos de Uso Cubiertos
~~~~~~~~~~~~~~~~~~~~~~

Los nueve casos de uso del módulo Access materializan operacionalmente las
reglas de este CNST: asignar funciones, revocar funciones, consultar
permisos, asignar grupos, gestionar SoD, gestionar segmentos (no aplica en
v5.2.2 — eliminados), asignar segmento (no aplica), permisos temporales y
auditar cambios de acceso.

Lo que NO se Puede Hacer
~~~~~~~~~~~~~~~~~~~~~~~~

- Crear roles jerárquicos sobre el modelo Flat
- Otorgar permisos sin pasar por el catálogo de 42 funciones
- Desactivar las reglas SoD globalmente sin proceso de excepción
- Asignar permisos temporales sin justificación o sin vencimiento
- Vencimientos superiores a 6 meses
- Wildcards de permisos

----

Business Rules Derivadas
------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 40 45

   * - BR
     - Nombre
     - Relación con CNST-012
   * - BR-006
     - RBAC Flat NIST
     - Establece formalmente el modelo Flat (regla de negocio que este CNST
       implementa técnicamente).
   * - BR-007
     - Separación de Funciones (SoD)
     - Establece la obligatoriedad de SoD activa en asignaciones.
   * - BR-012
     - Usuario - Segmento Único
     - No aplica en v5.2.2 (segmentos eliminados); referencia conservada
       para historial.

----

Excepciones
-----------

NO existen excepciones automáticas a esta restricción. Cualquier excepción
requiere:

1. Solicitud formal con justificación de negocio.
2. Análisis de riesgo documentado.
3. Aprobación de Tech Lead + Responsable de Seguridad.
4. Vigencia acotada (máximo 6 meses).
5. Auditoría obligatoria de cada uso durante la vigencia.

----

Verificación
------------

Criterios de Cumplimiento
~~~~~~~~~~~~~~~~~~~~~~~~~

- La tabla ``functions`` contiene exactamente 42 registros activos.
- La tabla ``function_groups`` contiene exactamente 10 registros activos.
- La tabla ``function_separation_rules`` contiene exactamente 3 registros
  activos.
- Cada endpoint autenticado declara la función requerida vía
  ``@require_function``.
- Toda asignación con ``expiration_date`` tiene ``justification`` no nula y
  con ``LENGTH(justification) >= 20``.
- Ninguna asignación viola las 3 reglas SoD vigentes.

Método
~~~~~~

- Tipo: automático.
- Frecuencia: continuo (SEC_RULES en cada request) + verificación nocturna
  programada (revoca permisos vencidos y reporta violaciones SoD).
- Herramienta: middleware ``PermissionMiddleware`` + comando
  ``manage.py validate_rbac``.

----

Trazabilidad
------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ADRs relacionadas**
     - ADR-BACK-004 (sistema de permisos sin roles jerárquicos)
   * - **Reglas de negocio derivadas**
     - :ref:`br-006`
   * - **Metamodelos relacionados**
     - :ref:`mtm-03`
   * - **Casos de uso afectados**
     - UC_ACC_01 a UC_ACC_09 (módulo Access completo)
   * - **Módulos afectados**
     - MOD_Access (núcleo) + los otros 7 módulos (consumidores)
   * - **CNST relacionadas**
     - CNST-001 (NO email), CNST-002 (sesiones), CNST-005 (Seguridad DRF),
       CNST-009 (auditoría inmutable)

----

Historial de Cambios
--------------------

.. list-table::
   :widths: 12 12 76
   :header-rows: 1

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-04-27
     - Versión inicial. Consolidación canónica del Modelo RBAC IACT v5.2.2:
       42 funciones, 10 grupos, 3 reglas SoD, permisos temporales con
       vencimiento. Sin segmentos de datos (eliminados desde v5.2.0).
       Nomenclatura: identifiers en inglés (snake_case), descripciones en
       español, prefijo ``AUT-`` conservado por compatibilidad con
       referencias del repositorio.
