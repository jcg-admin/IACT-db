.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06

.. _actores:

=============================================
Catálogo de Actores - Agrupadores RBAC v5.1.1
=============================================

1. Introducción
===============

Este documento define los **actores** del sistema IACT, implementados como 
**Agrupadores RBAC** según el modelo RBAC v5.1.1.

.. important::
   
   En IACT, los actores de casos de uso corresponden a **Agrupadores RBAC**, 
   no a roles tradicionales ni a personas físicas.
   
   Un agrupador es un mecanismo de asignación masiva de funciones atómicas.

2. Catálogo de Agrupadores (10)
===============================

2.1 AGR-001: agr_operador_basico
--------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-001
   * - **Nombre**
     - agr_operador_basico
   * - **Descripción**
     - Funciones mínimas para operador de consulta básica
   * - **Funciones (5)**
     - RPT-001, RPT-002, RPT-003, ALR-001, ALR-006
   * - **Usuarios Estimados**
     - 50-100
   * - **UC Principales**
     - UC_RPT_09 (Ver Dashboard)

**Funciones Incluidas:**

.. code-block:: text

   - ve_reportes (RPT-001)
   - ve_dashboard (RPT-002)
   - filtra_reportes (RPT-003)
   - ve_alertas (ALR-001)
   - ve_historial_alertas (ALR-006)

2.2 AGR-002: agr_operador_reportes
----------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-002
   * - **Nombre**
     - agr_operador_reportes
   * - **Descripción**
     - Acceso completo a reportes (sin exportación)
   * - **Funciones (8)**
     - RPT-001 a RPT-003, RPT-007, RPT-008, ALR-001, ALR-002, ALR-006
   * - **Usuarios Estimados**
     - 30-50
   * - **UC Principales**
     - UC_RPT_01 a UC_RPT_05, UC_RPT_09 a UC_RPT_14

**Funciones Incluidas:**

.. code-block:: text

   - ve_reportes (RPT-001)
   - ve_dashboard (RPT-002)
   - filtra_reportes (RPT-003)
   - ve_kpis (RPT-007)
   - ve_graficos (RPT-008)
   - ve_alertas (ALR-001)
   - configura_alertas (ALR-002)
   - ve_historial_alertas (ALR-006)

2.3 AGR-003: agr_supervisor
---------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-003
   * - **Nombre**
     - agr_supervisor
   * - **Descripción**
     - Supervisor de equipo con alertas y exportación básica
   * - **Funciones (12)**
     - RPT-001 a RPT-005, RPT-007, RPT-008, ALR-001 a ALR-004, ALR-006
   * - **Usuarios Estimados**
     - 20-40
   * - **UC Principales**
     - UC_RPT_01 a UC_RPT_14, UC_ALR_01 a UC_ALR_03

**Funciones Incluidas:**

.. code-block:: text

   # Reportes
   - ve_reportes (RPT-001)
   - ve_dashboard (RPT-002)
   - filtra_reportes (RPT-003)
   - exporta_csv (RPT-004)
   - exporta_excel (RPT-005)
   - ve_kpis (RPT-007)
   - ve_graficos (RPT-008)
   
   # Alertas
   - ve_alertas (ALR-001)
   - configura_alertas (ALR-002)
   - configura_alertas_equipo (ALR-003)
   - pausa_alertas (ALR-004)
   - ve_historial_alertas (ALR-006)

2.4 AGR-004: agr_exportador
---------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-004
   * - **Nombre**
     - agr_exportador
   * - **Descripción**
     - Capacidades de exportación (se combina con otros agrupadores)
   * - **Funciones (3)**
     - RPT-004, RPT-005, RPT-006
   * - **Usuarios Estimados**
     - 30-50 (combinado)
   * - **UC Principales**
     - UC_RPT_06, UC_RPT_07, UC_RPT_08

**Funciones Incluidas:**

.. code-block:: text

   - exporta_csv (RPT-004)
   - exporta_excel (RPT-005)
   - exporta_pdf (RPT-006)

.. note::
   Este agrupador típicamente se asigna junto con AGR-002 o AGR-003
   para habilitar capacidades de exportación.

2.5 AGR-005: agr_gestor_alertas
-------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-005
   * - **Nombre**
     - agr_gestor_alertas
   * - **Descripción**
     - Gestión completa de alertas y notificaciones
   * - **Funciones (6)**
     - ALR-001 a ALR-006
   * - **Usuarios Estimados**
     - 10-20
   * - **UC Principales**
     - UC_ALR_01 a UC_ALR_05

**Funciones Incluidas:**

.. code-block:: text

   - ve_alertas (ALR-001)
   - configura_alertas (ALR-002)
   - configura_alertas_equipo (ALR-003)
   - pausa_alertas (ALR-004)
   - elimina_alertas (ALR-005)
   - ve_historial_alertas (ALR-006)

.. warning::
   **CNST-001:** Las alertas SOLO notifican vía buzón interno (InternalMessage).
   NO se permite email, SMS, webhook ni ningún canal externo.

2.6 AGR-006: agr_admin_usuarios
-------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-006
   * - **Nombre**
     - agr_admin_usuarios
   * - **Descripción**
     - Administración completa de usuarios
   * - **Funciones (12)**
     - USR-001 a USR-010, ACC-001, ACC-002
   * - **Usuarios Estimados**
     - 2-5
   * - **UC Principales**
     - UC_AUTH_03, UC_AUTH_05, UC_USR_01 a UC_USR_04

**Funciones Incluidas:**

.. code-block:: text

   # Usuarios
   - crea_usuarios (USR-001)
   - ve_usuarios (USR-002)
   - modifica_usuarios (USR-003)
   - elimina_usuarios (USR-004)
   - lista_usuarios (USR-005)
   - busca_usuarios (USR-006)
   - bloquea_usuarios (USR-007)
   - desbloquea_usuarios (USR-008)
   - reactiva_usuarios (USR-009)
   - asigna_segmento (USR-010)
   
   # Acceso básico
   - asigna_funciones (ACC-001)
   - revoca_funciones (ACC-002)

.. danger::
   **SoD (CNST-005):** Este agrupador es INCOMPATIBLE con AGR-008 (agr_auditor).
   Un usuario NO puede tener ambos agrupadores simultáneamente.

2.7 AGR-007: agr_admin_acceso
-----------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-007
   * - **Nombre**
     - agr_admin_acceso
   * - **Descripción**
     - Administración del modelo RBAC (funciones, agrupadores, SoD)
   * - **Funciones (6)**
     - ACC-001 a ACC-006
   * - **Usuarios Estimados**
     - 2-3
   * - **UC Principales**
     - UC_ACC_01 a UC_ACC_08

**Funciones Incluidas:**

.. code-block:: text

   - asigna_funciones (ACC-001)
   - revoca_funciones (ACC-002)
   - ve_asignaciones (ACC-003)
   - asigna_agrupadores (ACC-004)
   - gestiona_sod (ACC-005)
   - gestiona_segmentos (ACC-006)

2.8 AGR-008: agr_auditor
------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-008
   * - **Nombre**
     - agr_auditor
   * - **Descripción**
     - Auditoría y compliance (SOLO LECTURA)
   * - **Funciones (4)**
     - AUD-001 a AUD-004
   * - **Usuarios Estimados**
     - 2-5
   * - **UC Principales**
     - UC_AUD_01 a UC_AUD_03, UC_ACC_09

**Funciones Incluidas:**

.. code-block:: text

   - ve_auditoria (AUD-001)
   - busca_auditoria (AUD-002)
   - exporta_auditoria (AUD-003)
   - genera_reporte_compliance (AUD-004)

.. danger::
   **SoD (CNST-005):** Este agrupador es INCOMPATIBLE con:
   
   - AGR-006 (agr_admin_usuarios)
   - AGR-009 (agr_admin_pipeline)
   
   Quien audita NO puede ser quien opera.

.. important::
   **CNST-009:** Los logs de auditoría son INMUTABLES.
   El auditor solo puede LEER y EXPORTAR, nunca modificar o eliminar.

2.9 AGR-009: agr_admin_pipeline
-------------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-009
   * - **Nombre**
     - agr_admin_pipeline
   * - **Descripción**
     - Supervisión y administración del proceso ETL
   * - **Funciones (4)**
     - PIP-001 a PIP-004
   * - **Usuarios Estimados**
     - 2-3
   * - **UC Principales**
     - UC_PIP_01 a UC_PIP_04, UC_LOG_04

**Funciones Incluidas:**

.. code-block:: text

   - ve_estado_etl (PIP-001)
   - ve_errores_etl (PIP-002)
   - ve_disponibilidad_datos (PIP-003)
   - solicita_reintento_etl (PIP-004)

.. warning::
   **CNST-003:** El ETL solo EXTRAE datos de IVR (MariaDB, readonly).
   NO se permite escritura directa a la base IVR bajo ninguna circunstancia.

2.10 AGR-010: agr_admin_logs
----------------------------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - AGR-010
   * - **Nombre**
     - agr_admin_logs
   * - **Descripción**
     - Consulta y gestión de bitácoras técnicas
   * - **Funciones (2)**
     - LOG-001, LOG-002
   * - **Usuarios Estimados**
     - 2-3
   * - **UC Principales**
     - UC_LOG_01 a UC_LOG_03

**Funciones Incluidas:**

.. code-block:: text

   - ve_logs_tecnicos (LOG-001)
   - exporta_logs (LOG-002)

.. note::
   **CNST-008:** Los logs técnicos NO deben contener PII (información 
   personal identificable). Contraseñas y tokens están prohibidos.

3. Matriz Agrupador → Funciones
===============================

.. code-block:: text

                          AUT  USR  ACC  PIP  RPT  ALR  AUD  LOG
   Funciones disponibles:  4   10    6    4    8    6    4    2
   ─────────────────────────────────────────────────────────────
   AGR-001 operador_basico    -    -    -    -    3    2    -    -
   AGR-002 operador_reportes  -    -    -    -    5    3    -    -
   AGR-003 supervisor         -    -    -    -    7    5    -    -
   AGR-004 exportador         -    -    -    -    3    -    -    -
   AGR-005 gestor_alertas     -    -    -    -    -    6    -    -
   AGR-006 admin_usuarios     -   10    2    -    -    -    -    -
   AGR-007 admin_acceso       -    -    6    -    -    -    -    -
   AGR-008 auditor            -    -    -    -    -    -    4    -
   AGR-009 admin_pipeline     -    -    -    4    -    -    -    -
   AGR-010 admin_logs         -    -    -    -    -    -    -    2

4. Restricciones SoD (Separación de Funciones)
==============================================

.. list-table::
   :widths: 15 25 25 35
   :header-rows: 1

   * - ID
     - Grupo A
     - Grupo B
     - Razón
   * - SOD-001
     - AGR-009 (admin_pipeline)
     - AGR-008 (auditor)
     - Quien opera NO audita
   * - SOD-002
     - AGR-006 (admin_usuarios)
     - AGR-008 (auditor)
     - Quien gestiona usuarios NO audita
   * - SOD-003
     - AGR-007 (admin_acceso)
     - AGR-008 (auditor)
     - Quien gestiona acceso NO audita

5. Actor Especial: Sistema
==========================

Además de los agrupadores humanos, existe un actor especial:

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - SISTEMA
   * - **Nombre**
     - Sistema (Actor Automático)
   * - **Descripción**
     - Procesos automáticos sin intervención humana
   * - **Ejemplos**
     - ETL programado, evaluación de alertas, limpieza de sesiones
   * - **UC Principales**
     - UC_AUD_04 (Registrar Evento)

6. Diagrama de Actores
======================

.. uml::
   :caption: Diagrama de Actores del Sistema IACT

   @startuml
   
   left to right direction
   
   package "Operadores" {
     actor "AGR-001\nagr_operador_basico" as AGR001 <<AGR_OPERADOR>>
     actor "AGR-002\nagr_operador_reportes" as AGR002 <<AGR_OPERADOR>>
     actor "AGR-003\nagr_supervisor" as AGR003 <<AGR_OPERADOR>>
     actor "AGR-004\nagr_exportador" as AGR004 <<AGR_OPERADOR>>
     actor "AGR-005\nagr_gestor_alertas" as AGR005 <<AGR_OPERADOR>>
   }
   
   package "Administradores" {
     actor "AGR-006\nagr_admin_usuarios" as AGR006 <<AGR_ADMIN>>
     actor "AGR-007\nagr_admin_acceso" as AGR007 <<AGR_ADMIN>>
     actor "AGR-009\nagr_admin_pipeline" as AGR009 <<AGR_ADMIN>>
     actor "AGR-010\nagr_admin_logs" as AGR010 <<AGR_ADMIN>>
   }
   
   package "Auditoría" {
     actor "AGR-008\nagr_auditor" as AGR008 <<AGR_AUDITOR>>
   }
   
   package "Sistema" {
     actor "SISTEMA\n(Automático)" as SISTEMA <<SISTEMA>>
   }
   
   note bottom of AGR008
     **SoD:** Incompatible con
     AGR-006, AGR-007, AGR-009
   end note
   
   @enduml

7. Historial de Cambios
=======================

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Versión inicial basada en RBAC v5.1.1
