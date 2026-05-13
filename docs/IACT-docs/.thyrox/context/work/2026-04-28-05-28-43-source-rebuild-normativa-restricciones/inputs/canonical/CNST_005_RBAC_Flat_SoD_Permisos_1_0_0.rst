.. _CNST_005:

============================================================
CNST_005 - Modelo RBAC Flat + SoD + Permisos Temporales
============================================================

:Restricción: CNST_005
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: Sistema completo IACT
:Módulo_Principal: MOD_Access (RBAC_CORE + SEC_RULES)
:Base: NIST RBAC (Flat, no jerárquico)
:Proyecto: IACT-2025-001
:Documento_Fuente: MODELO_RBAC_IACT_v5_1_1.md

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Objetivo de la Restricción
--------------------------------

Definir el modelo completo de control de acceso basado en funciones atómicas 
(RBAC v5.1.1) para el Sistema IACT, estableciendo:

- **44 funciones atómicas** distribuidas en 8 módulos funcionales
- **10 agrupadores** para asignación masiva de funciones
- **3 restricciones SoD** (Separation of Duties) obligatorias
- **5 segmentos de datos** para particionamiento automático
- **Permisos temporales** con justificación y vencimiento obligatorios

1.2 Cambio Fundamental vs v4.0
--------------------------------

.. code-block:: text

   ANTES (v4.0 - Roles abstractos):
      Código:    if user.has_role(['R004', 'R005']):
      Problema:  ¿Qué puede hacer un usuario con R004?
      
   AHORA (v5.1 - Funciones descriptivas):
      Código:    if user.has_function('ve_reportes'):
      Claridad:  El usuario puede ver reportes

**Filosofía:** "Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona"

1.3 Impacto en el Sistema
---------------------------

Esta restricción afecta **TODOS los módulos** del sistema IACT:

- MOD_Auth: 4 funciones
- MOD_Users: 10 funciones
- MOD_Access: 6 funciones (+ SEC_RULES automático)
- MOD_Pipeline: 4 funciones
- MOD_Reports: 8 funciones (core negocio)
- MOD_Alerts: 6 funciones
- MOD_Audit: 4 funciones
- MOD_Logs: 2 funciones

**TOTAL: 44 funciones atómicas**

============================================================
2. FILOSOFÍA DEL MODELO "SIN PRETENSIONES"
============================================================

2.1 Principio Central
----------------------

   **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona.**

   Esta filosofía evita:
   
   - Roles abstractos: "ADMIN", "MANAGER", "SUPERVISOR"
   - Ambigüedades: ¿Qué puede hacer un "SUPERVISOR"?
   - Nombres genéricos que no describen la capacidad

   En su lugar, usa:
   
   - Funciones descriptivas: ``ve_reportes``, ``exporta_csv``, ``gestiona_sesiones``
   - Claridad inmediata: El nombre describe la acción
   - Composición flexible: Combinar funciones según necesidad

2.2 Arquitectura Flat (No Jerárquica)
---------------------------------------

.. code-block:: text

   ❌ RBAC Jerárquico (NO usado):
   
      ADMIN
        └── MANAGER
              └── SUPERVISOR
                    └── OPERATOR
                    
      Problema: Herencia compleja, difícil de auditar

   ✅ RBAC Flat (usado en IACT):
   
      Funciones atómicas independientes:
      - ve_reportes
      - exporta_csv
      - gestiona_sesiones
      - ...
      
      Ventaja: Asignación explícita, trazabilidad clara

2.3 Precedencia de Permisos
-----------------------------

Cuando un usuario tiene múltiples fuentes de permisos, se aplica la siguiente precedencia:

.. code-block:: text

   PRECEDENCIA (de mayor a menor):
   
   1. Permiso Directo Temporal (con vencimiento)
   2. Función Asignada Permanente
   3. Función del Segmento de Datos
   
   Ejemplo:
      Usuario: maria.lopez
      - Función permanente: ve_reportes
      - Permiso temporal: exporta_csv (vence 2026-01-31)
      
      Resultado: Puede ver reportes (permanente) + exportar CSV (hasta 31 ene)

============================================================
3. ARQUITECTURA DE 8 MÓDULOS IACT
============================================================

3.1 Vista General
------------------

El Sistema IACT está organizado en **8 módulos funcionales**:

.. code-block:: text

   ┌─────────────────────────────────────────────────────────┐
   │                  SISTEMA IACT v1.0                       │
   │         IVR Analytics & Customer Tracking                │
   ├─────────────────────────────────────────────────────────┤
   │                                                          │
   │  CAPA 1: AUTENTICACIÓN Y CONTROL                        │
   │  ┌──────────┬────────────┬──────────────┐               │
   │  │MOD_Auth  │MOD_Users   │MOD_Access    │               │
   │  │4 func    │10 func     │6 func        │               │
   │  │          │            │+ SEC_RULES   │               │
   │  └──────────┴────────────┴──────────────┘               │
   │                                                          │
   │  CAPA 2: DATOS Y PROCESAMIENTO                          │
   │  ┌──────────────────┬────────────────────┐              │
   │  │MOD_Pipeline      │MOD_Reports         │              │
   │  │4 func            │8 func              │              │
   │  │(Supervisión ETL) │(Dashboards/Reportes│              │
   │  └──────────────────┴────────────────────┘              │
   │                                                          │
   │  CAPA 3: COMUNICACIÓN                                   │
   │  ┌────────────────────────┐                             │
   │  │MOD_Alerts              │                             │
   │  │6 func                  │                             │
   │  │(Solo buzón interno)    │                             │
   │  └────────────────────────┘                             │
   │                                                          │
   │  CAPA 4: OBSERVABILIDAD                                 │
   │  ┌──────────────────┬────────────────────┐              │
   │  │MOD_Audit         │MOD_Logs            │              │
   │  │4 func            │2 func              │              │
   │  │(Negocio/Complian)│(Técnico/DevOps)    │              │
   │  └──────────────────┴────────────────────┘              │
   │                                                          │
   └─────────────────────────────────────────────────────────┘

3.2 Distribución de Funciones
-------------------------------

.. list-table:: Funciones RBAC por Módulo
   :header-rows: 1
   :widths: 30 15 15 40

   * - Módulo
     - Código
     - Funciones
     - Propósito
   * - MOD_Auth
     - AUT
     - 4 (9%)
     - Autenticación y sesiones
   * - MOD_Users
     - USR
     - 10 (23%)
     - Gestión de identidades
   * - MOD_Access
     - ACC
     - 6 (14%)
     - RBAC core + SEC_RULES
   * - MOD_Pipeline
     - PIP
     - 4 (9%)
     - Supervisión del ETL
   * - **MOD_Reports**
     - **RPT**
     - **8 (18%)**
     - **Dashboards y reportes**
   * - MOD_Alerts
     - ALR
     - 6 (14%)
     - Alertas y notificaciones
   * - MOD_Audit
     - AUD
     - 4 (9%)
     - Auditoría funcional
   * - MOD_Logs
     - LOG
     - 2 (5%)
     - Bitácoras técnicas
   * - **TOTAL**
     - **-**
     - **44 (100%)**
     - **-**

**Observación:** MOD_Reports + MOD_Alerts (32% de funciones) conforman el núcleo operativo del sistema.

============================================================
4. LAS 44 FUNCIONES ATÓMICAS
============================================================

4.1 MOD_Auth: Autenticación y Sesiones (4 funciones)
------------------------------------------------------

.. list-table:: Funciones MOD_Auth
   :header-rows: 1
   :widths: 15 25 25 10 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - AUT-001
     - ``gestiona_sesiones``
     - auth:sesiones
     - UC-005
     - Gestiona sesiones activas de usuarios
   * - AUT-002
     - ``cierra_sesion_usuario``
     - auth:cerrar_sesion
     - UC-005
     - Cierra sesión de otro usuario
   * - AUT-003
     - ``resetea_password``
     - auth:reset_password
     - UC-003
     - Genera contraseña temporal
   * - AUT-004
     - ``ve_sesiones_activas``
     - auth:ver_sesiones
     - UC-005
     - Ve todas las sesiones activas

**CNST aplicables:** CNST_001 (NO email), CNST_002 (sesión única, 15 min timeout)

**Detalle AUT-001: gestiona_sesiones**

.. code-block:: yaml

   Función: gestiona_sesiones
   Capacidad: auth:sesiones
   Módulo: MOD_Auth
   
   Acciones permitidas:
     - Ver todas las sesiones activas
     - Ver detalles: IP, User-Agent, última actividad
     - Cerrar sesión de usuario específico
     - Cerrar todas las sesiones (emergencia)
   
   Restricciones CNST:
     - CNST_002: Sesión única por usuario
     - CNST_002: Timeout 15 minutos inactividad
   
   Caso de Uso: UC-005
   Auditoría: Nivel CRITICAL - SESSION_MANAGE

**Detalle AUT-003: resetea_password**

.. code-block:: yaml

   Función: resetea_password
   Capacidad: auth:reset_password
   Módulo: MOD_Auth
   
   Proceso:
     1. Generar contraseña temporal (12+ chars)
     2. Actualizar hash en BD
     3. Marcar debe_cambiar_password = TRUE
     4. Notificar vía BUZÓN INTERNO (CNST_001: NO email)
   
   Restricciones CNST:
     - CNST_001: Notificación SOLO por buzón interno
     - Contraseña expira en 24 horas
   
   Caso de Uso: UC-003
   Auditoría: Nivel WARNING - PASSWORD_RESET

4.2 MOD_Users: Gestión de Identidades (10 funciones)
------------------------------------------------------

.. list-table:: Funciones MOD_Users
   :header-rows: 1
   :widths: 15 25 25 10 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - USR-001
     - ``crea_usuarios``
     - users:crear
     - UC-006
     - Crea nuevos usuarios
   * - USR-002
     - ``ve_usuarios``
     - users:leer
     - UC-009
     - Consulta información de usuarios
   * - USR-003
     - ``modifica_usuarios``
     - users:modificar
     - UC-007
     - Modifica datos de usuarios
   * - USR-004
     - ``elimina_usuarios``
     - users:eliminar
     - UC-008
     - Baja lógica de usuarios
   * - USR-005
     - ``lista_usuarios``
     - users:listar
     - UC-009
     - Lista usuarios con filtros
   * - USR-006
     - ``busca_usuarios``
     - users:buscar
     - UC-009
     - Busca usuarios por criterios
   * - USR-007
     - ``bloquea_usuarios``
     - users:bloquear
     - UC-007
     - Bloquea acceso de usuario
   * - USR-008
     - ``desbloquea_usuarios``
     - users:desbloquear
     - UC-007
     - Desbloquea usuario
   * - USR-009
     - ``reactiva_usuarios``
     - users:reactivar
     - UC-007
     - Reactiva usuario inactivo
   * - USR-010
     - ``asigna_segmento``
     - users:asignar_segmento
     - UC-041
     - Asigna segmento de datos

**CNST aplicables:** CNST_001 (NO email), CNST_005 (bajas lógicas)

**Detalle USR-001: crea_usuarios**

.. code-block:: yaml

   Función: crea_usuarios
   Capacidad: users:crear
   Módulo: MOD_Users
   
   Datos requeridos:
     - email (único, dominio corporativo)
     - nombre, apellido
     - segmento_id (obligatorio)
   
   Proceso:
     1. Validar email único
     2. Generar username automático (CNST_005)
     3. Crear con estado PENDIENTE_CONFIGURACION (CNST_005)
     4. Generar contraseña temporal
     5. Notificar vía buzón interno (CNST_001: NO email)
   
   Restricciones CNST:
     - CNST_001: Notificación solo buzón interno
     - CNST_005: Username autogenerado
     - CNST_005: Estado inicial PENDIENTE_CONFIGURACION
   
   Caso de Uso: UC-006
   Auditoría: Nivel INFO - USER_CREATE

**Detalle USR-004: elimina_usuarios**

.. code-block:: yaml

   Función: elimina_usuarios
   Capacidad: users:eliminar
   Módulo: MOD_Users
   
   Proceso:
     1. Cambiar estado a ELIMINADO
     2. Revocar todas las funciones activas
     3. Cerrar sesiones activas
     4. Registrar en auditoría
   
   Restricciones CNST:
     - CNST_005: Bajas siempre LÓGICAS, nunca físicas
     - Datos se mantienen para auditoría
   
   Caso de Uso: UC-008
   Auditoría: Nivel WARNING - USER_DELETE

4.3 MOD_Access: Roles, Permisos, Segmentos (6 funciones)
----------------------------------------------------------

.. list-table:: Funciones MOD_Access
   :header-rows: 1
   :widths: 15 25 25 15 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - ACC-001
     - ``asigna_funciones``
     - access:asignar
     - UC-010, UC-042
     - Asigna funciones a usuarios
   * - ACC-002
     - ``revoca_funciones``
     - access:revocar
     - UC-010
     - Revoca funciones de usuarios
   * - ACC-003
     - ``ve_asignaciones``
     - access:ver
     - UC-011, UC-044
     - Ve asignaciones y permisos efectivos
   * - ACC-004
     - ``asigna_agrupadores``
     - access:asignar_agrupador
     - UC-010
     - Asigna agrupadores completos
   * - ACC-005
     - ``gestiona_sod``
     - access:sod
     - UC-043
     - Configura restricciones SoD
   * - ACC-006
     - ``gestiona_segmentos``
     - access:segmentos
     - UC-045, UC-046
     - Gestiona catálogo de segmentos

**Componente SEC_RULES:** Middleware automático de validación (no visible al usuario)

**Detalle ACC-001: asigna_funciones**

.. code-block:: yaml

   Función: asigna_funciones
   Capacidad: access:asignar
   Módulo: MOD_Access (RBAC_CORE)
   
   Tipos de asignación:
     1. Función permanente (sin vencimiento)
     2. Permiso directo temporal (con vencimiento)
   
   Validaciones:
     - Usuario debe estar ACTIVO
     - Función debe existir en catálogo
     - No violar restricciones SoD
     - Si temporal: justificación mín. 20 chars
     - Si temporal: vencimiento máx. 6 meses
   
   Casos de Uso: UC-010 (asignación permanente), UC-042 (permiso temporal)
   Auditoría: Nivel WARNING - FUNCTION_ASSIGN

4.4 MOD_Pipeline: Supervisión del ETL (4 funciones)
-----------------------------------------------------

.. list-table:: Funciones MOD_Pipeline
   :header-rows: 1
   :widths: 15 25 25 10 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - PIP-001
     - ``ve_estado_etl``
     - pipeline:ver_estado
     - UC-050
     - Ve estado y ejecuciones del ETL
   * - PIP-002
     - ``ve_errores_etl``
     - pipeline:ver_errores
     - UC-051
     - Consulta errores del ETL
   * - PIP-003
     - ``ve_disponibilidad_datos``
     - pipeline:disponibilidad
     - UC-052
     - Consulta disponibilidad de datos
   * - PIP-004
     - ``solicita_reintento_etl``
     - pipeline:reintento
     - UC-053
     - Solicita reintento controlado del ETL

**CNST aplicables:** CNST_003 (BD IVR readonly, ETL 6-12h, NO real-time)

**Detalle PIP-001: ve_estado_etl**

.. code-block:: yaml

   Función: ve_estado_etl
   Capacidad: pipeline:ver_estado
   Módulo: MOD_Pipeline
   
   Información visible:
     - Última ejecución exitosa
     - Próxima ejecución programada
     - Estado actual (ejecutando, idle, error)
     - Histórico de ejecuciones
   
   Restricciones CNST:
     - CNST_003: ETL cada 6-12 horas
     - CNST_003: BD IVR solo lectura
     - CNST_003: NO real-time
   
   Caso de Uso: UC-050
   Auditoría: Nivel INFO - ETL_VIEW

4.5 MOD_Reports: Dashboards y Reportes (8 funciones)
------------------------------------------------------

.. list-table:: Funciones MOD_Reports
   :header-rows: 1
   :widths: 15 25 25 15 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - RPT-001
     - ``ve_reportes``
     - reports:ver
     - UC-017,018,019
     - Ve reportes tabulares
   * - RPT-002
     - ``ve_dashboard``
     - reports:dashboard
     - UC-025
     - Ve dashboard principal
   * - RPT-003
     - ``filtra_reportes``
     - reports:filtrar
     - UC-020, UC-021
     - Aplica filtros fecha/centro
   * - RPT-004
     - ``exporta_csv``
     - reports:exportar_csv
     - UC-022
     - Exporta a CSV
   * - RPT-005
     - ``exporta_excel``
     - reports:exportar_excel
     - UC-023
     - Exporta a Excel
   * - RPT-006
     - ``exporta_pdf``
     - reports:exportar_pdf
     - UC-024
     - Exporta a PDF
   * - RPT-007
     - ``ve_kpis``
     - reports:kpis
     - UC-025
     - Ve KPIs estáticos
   * - RPT-008
     - ``ve_graficos``
     - reports:graficos
     - UC-027,028,029
     - Ve gráficos (hora, día, centro)

**CNST aplicables:** CNST_003 (datos desfasados), CNST_006 (rango máx 2 años), CNST_007 (límites exportación)

**Límites de Exportación:**

.. list-table:: Límites por Formato
   :header-rows: 1
   :widths: 20 25 25 30

   * - Formato
     - Max Registros
     - Límite Diario
     - Timeout
   * - CSV
     - 100,000
     - 10 exportaciones
     - 60 segundos
   * - Excel
     - 50,000
     - 5 exportaciones
     - 90 segundos
   * - PDF
     - 10,000
     - 3 exportaciones
     - 120 segundos

**Detalle RPT-001: ve_reportes**

.. code-block:: yaml

   Función: ve_reportes
   Capacidad: reports:ver
   Módulo: MOD_Reports
   
   Reportes accesibles:
     - Reporte trimestral de llamadas (UC-017)
     - Reporte de problemas de menú (UC-018)
     - Reporte de transferencias por centro (UC-019)
   
   Restricciones CNST:
     - CNST_003: Datos desfasados según último ETL
     - CNST_003: NO real-time
     - CNST_006: Rango máximo 2 años
     - Segmento de datos del usuario aplicado automáticamente
   
   Casos de Uso: UC-017, UC-018, UC-019
   Auditoría: Nivel INFO - REPORT_VIEW

**Detalle RPT-004: exporta_csv**

.. code-block:: yaml

   Función: exporta_csv
   Capacidad: reports:exportar_csv
   Módulo: MOD_Reports
   
   Características:
     - Delimitador: coma
     - Encoding: UTF-8 con BOM
     - Fechas: YYYY-MM-DD
   
   Límites (CNST_007):
     - Máximo: 100,000 registros
     - Límite diario: 10 exportaciones
     - Timeout: 60 segundos
   
   Restricciones CNST:
     - CNST_001: NO envío por email
     - CNST_007: Throttling aplicado
   
   Caso de Uso: UC-022
   Auditoría: Nivel WARNING - EXPORT_CSV

4.6 MOD_Alerts: Alertas y Notificaciones (6 funciones)
--------------------------------------------------------

.. list-table:: Funciones MOD_Alerts
   :header-rows: 1
   :widths: 15 25 25 10 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - ALR-001
     - ``ve_alertas``
     - alerts:ver
     - UC-039
     - Ve alertas propias
   * - ALR-002
     - ``configura_alertas``
     - alerts:configurar
     - UC-036
     - Configura alertas personales
   * - ALR-003
     - ``configura_alertas_equipo``
     - alerts:config_equipo
     - UC-040
     - Alertas para equipo
   * - ALR-004
     - ``pausa_alertas``
     - alerts:pausar
     - UC-038
     - Pausa alertas (snooze)
   * - ALR-005
     - ``elimina_alertas``
     - alerts:eliminar
     - UC-036
     - Elimina alertas propias
   * - ALR-006
     - ``ve_historial_alertas``
     - alerts:historial
     - UC-039
     - Ve historial de alertas

**CNST aplicables:** CNST_001 (NO email), CNST_004 (máx 50 destinatarios, buzón interno)

**Detalle ALR-002: configura_alertas**

.. code-block:: yaml

   Función: configura_alertas
   Capacidad: alerts:configurar
   Módulo: MOD_Alerts
   
   Configuración:
     - Nombre descriptivo
     - Métrica a monitorear
     - Tipo de umbral (absoluto, porcentual)
     - Severidad (INFO, WARNING, CRITICAL)
     - Destinatario: Solo yo
   
   Restricciones CNST:
     - CNST_001: Notificación SOLO buzón interno (NO email)
     - CNST_004: Máximo 50 destinatarios por alerta
     - CNST_004: Consolidación de alertas repetidas
     - CNST_004: NO real-time extremo
   
   Caso de Uso: UC-036
   Auditoría: Nivel INFO - ALERT_CONFIGURE

4.7 MOD_Audit: Auditoría Funcional (4 funciones)
--------------------------------------------------

.. list-table:: Funciones MOD_Audit
   :header-rows: 1
   :widths: 15 25 25 10 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - AUD-001
     - ``ve_auditoria``
     - audit:ver
     - UC-061
     - Ve logs de auditoría
   * - AUD-002
     - ``busca_auditoria``
     - audit:buscar
     - UC-061
     - Busca en logs con filtros
   * - AUD-003
     - ``exporta_auditoria``
     - audit:exportar
     - UC-063
     - Exporta logs de auditoría
   * - AUD-004
     - ``genera_reporte_compliance``
     - audit:compliance
     - UC-062
     - Genera reportes de compliance

**CNST aplicables:** CNST_008 (inmutable, retención 2+ años, NO PII)

**Detalle AUD-001: ve_auditoria**

.. code-block:: yaml

   Función: ve_auditoria
   Capacidad: audit:ver
   Módulo: MOD_Audit
   
   Información visible:
     - Timestamp del evento
     - Usuario que realizó la acción
     - Tipo de acción
     - Recurso afectado
     - Resultado (SUCCESS/FAIL)
     - IP de origen
     - Valores antes/después (si aplica)
   
   Restricciones CNST:
     - CNST_008: Solo lectura (inmutable)
     - CNST_008: No puede modificar ni eliminar
     - CNST_008: Retención mínima 2 años
     - CNST_008: No PII innecesaria
   
   SoD:
     - ⚔️ Incompatible con gestiona_sesiones (admin_pipeline)
     - ⚔️ Incompatible con crea_usuarios (admin_usuarios)
   
   Caso de Uso: UC-061
   Auditoría: Nivel INFO - AUDIT_VIEW

4.8 MOD_Logs: Bitácoras Técnicas (2 funciones)
------------------------------------------------

.. list-table:: Funciones MOD_Logs
   :header-rows: 1
   :widths: 15 25 25 15 25

   * - ID
     - Función
     - Capacidad
     - UC
     - Descripción
   * - LOG-001
     - ``ve_logs_tecnicos``
     - logs:ver
     - UC-070, UC-071
     - Ve logs técnicos del sistema
   * - LOG-002
     - ``exporta_logs``
     - logs:exportar
     - UC-072
     - Exporta logs técnicos

**CNST aplicables:** CNST_008 (PII enmascarada, retención 30-90 días)

**Detalle LOG-001: ve_logs_tecnicos**

.. code-block:: yaml

   Función: ve_logs_tecnicos
   Capacidad: logs:ver
   Módulo: MOD_Logs
   
   Tipos de logs:
     - ETL (INFO/ERROR)
     - API (INFO/WARN)
     - Auth (WARN/ERROR)
     - DB (ERROR)
     - System (INFO/CRIT)
   
   Filtros disponibles:
     - Por nivel (DEBUG, INFO, WARN, ERROR, CRIT)
     - Por servicio/módulo
     - Por rango de fechas
     - Por request_id (correlación)
   
   Restricciones CNST:
     - CNST_008: PII enmascarada
     - CNST_008: Retención 30-90 días
     - CNST_008: No contraseñas ni tokens
   
   Casos de Uso: UC-070, UC-071
   Auditoría: Nivel INFO - LOGS_VIEW

============================================================
5. LOS 10 AGRUPADORES
============================================================

5.1 Concepto
-------------

   **Agrupador = Mecanismo de asignación masiva de funciones**
   
   - NO es un rol tradicional
   - Internamente crea N asignaciones individuales de funciones
   - Facilita gestión: en vez de asignar 12 funciones una por una, 
     se asigna 1 agrupador que internamente crea 12 asignaciones

5.2 Catálogo de Agrupadores
-----------------------------

.. list-table:: Los 10 Agrupadores IACT
   :header-rows: 1
   :widths: 15 30 15 15 25

   * - ID
     - Agrupador
     - Funciones
     - Usuarios Est.
     - Descripción
   * - AGR-001
     - ``agr_operador_basico``
     - 5
     - 50-100
     - Consulta básica de reportes
   * - AGR-002
     - ``agr_operador_reportes``
     - 8
     - 30-50
     - Acceso completo a reportes
   * - AGR-003
     - ``agr_supervisor``
     - 12
     - 20-40
     - Supervisor con alertas de equipo
   * - AGR-004
     - ``agr_exportador``
     - 3
     - 30-50
     - Exportación de reportes
   * - AGR-005
     - ``agr_gestor_alertas``
     - 6
     - 15-30
     - Gestión de alertas
   * - AGR-006
     - ``agr_admin_usuarios``
     - 12
     - 5-10
     - Administración de usuarios
   * - AGR-007
     - ``agr_admin_acceso``
     - 6
     - 2-5
     - Administración de acceso RBAC
   * - AGR-008
     - ``agr_auditor``
     - 4
     - 3-5
     - Auditoría y compliance
   * - AGR-009
     - ``agr_admin_pipeline``
     - 4
     - 2-3
     - Supervisión del ETL
   * - AGR-010
     - ``agr_admin_logs``
     - 2
     - 2-3
     - Bitácoras técnicas

5.3 Detalle de Agrupadores Operativos
---------------------------------------

**AGR-001: agr_operador_basico**

.. code-block:: yaml

   Agrupador: agr_operador_basico
   Descripción: Funciones mínimas para operador de consulta
   Cantidad: 5 funciones
   
   Funciones incluidas:
     - ve_reportes (RPT-001)
     - ve_dashboard (RPT-002)
     - filtra_reportes (RPT-003)
     - ve_alertas (ALR-001)
     - ve_historial_alertas (ALR-006)
   
   Usuarios estimados: 50-100
   Casos de uso: UC-017, UC-018, UC-019, UC-025, UC-039

**AGR-002: agr_operador_reportes**

.. code-block:: yaml

   Agrupador: agr_operador_reportes
   Descripción: Acceso completo a reportes (sin exportación)
   Cantidad: 8 funciones
   
   Funciones incluidas:
     - ve_reportes (RPT-001)
     - ve_dashboard (RPT-002)
     - filtra_reportes (RPT-003)
     - ve_kpis (RPT-007)
     - ve_graficos (RPT-008)
     - ve_alertas (ALR-001)
     - configura_alertas (ALR-002)
     - ve_historial_alertas (ALR-006)
   
   Usuarios estimados: 30-50

**AGR-003: agr_supervisor**

.. code-block:: yaml

   Agrupador: agr_supervisor
   Descripción: Supervisor de equipo con alertas
   Cantidad: 12 funciones
   
   Funciones incluidas:
     # Reportes (7)
     - ve_reportes (RPT-001)
     - ve_dashboard (RPT-002)
     - filtra_reportes (RPT-003)
     - exporta_csv (RPT-004)
     - exporta_excel (RPT-005)
     - ve_kpis (RPT-007)
     - ve_graficos (RPT-008)
     
     # Alertas (5)
     - ve_alertas (ALR-001)
     - configura_alertas (ALR-002)
     - configura_alertas_equipo (ALR-003)
     - pausa_alertas (ALR-004)
     - ve_historial_alertas (ALR-006)
   
   Usuarios estimados: 20-40

5.4 Detalle de Agrupadores Administrativos
--------------------------------------------

**AGR-006: agr_admin_usuarios**

.. code-block:: yaml

   Agrupador: agr_admin_usuarios
   Descripción: Administración completa de usuarios
   Cantidad: 12 funciones
   
   Funciones incluidas:
     # Usuarios (10)
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
     
     # Acceso (2)
     - asigna_funciones (ACC-001)
     - revoca_funciones (ACC-002)
   
   SoD: ⚔️ Incompatible con agr_auditor
   Usuarios estimados: 5-10

**AGR-007: agr_admin_acceso**

.. code-block:: yaml

   Agrupador: agr_admin_acceso
   Descripción: Administración completa de RBAC
   Cantidad: 6 funciones
   
   Funciones incluidas:
     - asigna_funciones (ACC-001)
     - revoca_funciones (ACC-002)
     - ve_asignaciones (ACC-003)
     - asigna_agrupadores (ACC-004)
     - gestiona_sod (ACC-005)
     - gestiona_segmentos (ACC-006)
   
   SoD: ⚔️ Incompatible con agr_auditor
   Usuarios estimados: 2-5

**AGR-008: agr_auditor**

.. code-block:: yaml

   Agrupador: agr_auditor
   Descripción: Auditoría y compliance
   Cantidad: 4 funciones
   
   Funciones incluidas:
     - ve_auditoria (AUD-001)
     - busca_auditoria (AUD-002)
     - exporta_auditoria (AUD-003)
     - genera_reporte_compliance (AUD-004)
   
   SoD: ⚔️ Incompatible con:
     - agr_admin_pipeline
     - agr_admin_usuarios
     - agr_admin_acceso
   
   Usuarios estimados: 3-5

**AGR-009: agr_admin_pipeline**

.. code-block:: yaml

   Agrupador: agr_admin_pipeline
   Descripción: Supervisión y gestión del ETL
   Cantidad: 4 funciones
   
   Funciones incluidas:
     - ve_estado_etl (PIP-001)
     - ve_errores_etl (PIP-002)
     - ve_disponibilidad_datos (PIP-003)
     - solicita_reintento_etl (PIP-004)
   
   SoD: ⚔️ Incompatible con agr_auditor
   Usuarios estimados: 2-3

5.5 Matriz Agrupador → Módulos
--------------------------------

.. code-block:: text

                          AUT  USR  ACC  PIP  RPT  ALR  AUD  LOG
   Agrupador               4   10    6    4    8    6    4    2
   ─────────────────────────────────────────────────────────────
   AGR-001 operador_basico -    -    -    -    3    2    -    -
   AGR-002 operador_report -    -    -    -    5    3    -    -
   AGR-003 supervisor      -    -    -    -    7    5    -    -
   AGR-004 exportador      -    -    -    -    3    -    -    -
   AGR-005 gestor_alertas  -    -    -    -    -    6    -    -
   AGR-006 admin_usuarios  -   10    2    -    -    -    -    -
   AGR-007 admin_acceso    -    -    6    -    -    -    -    -
   AGR-008 auditor         -    -    -    -    -    -    4    -
   AGR-009 admin_pipeline  -    -    -    4    -    -    -    -
   AGR-010 admin_logs      -    -    -    -    -    -    -    2

============================================================
6. SEPARACIÓN DE FUNCIONES (SoD)
============================================================

6.1 Concepto
-------------

   **SoD (Separation of Duties):** Restricciones obligatorias que impiden 
   combinaciones de funciones riesgosas.
   
   Principio: "Quien ejecuta NO debe auditar sus propias acciones"

6.2 Las 3 Restricciones SoD
----------------------------

.. list-table:: Restricciones SoD IACT
   :header-rows: 1
   :widths: 15 25 25 25 10

   * - ID
     - Nombre
     - Grupo A
     - Grupo B
     - Razón
   * - SOD-001
     - sod_admin_auditoria
     - PIP-001,002,003,004
     - AUD-001,002,003,004
     - Quien opera NO audita
   * - SOD-002
     - sod_usuarios_auditoria
     - USR-001,003,004,007
     - AUD-001,002,003
     - Quien gestiona users NO audita
   * - SOD-003
     - sod_acceso_auditoria
     - ACC-001,002,005
     - AUD-001,002
     - Quien gestiona acceso NO audita

6.3 Detalle SOD-001: sod_admin_auditoria
------------------------------------------

.. code-block:: yaml

   Restricción: sod_admin_auditoria
   Descripción: Quien opera/administra el pipeline NO debe auditarlo
   Base: CNST_005 (principio de separación)
   
   Grupo A (Administración Pipeline):
     - ve_estado_etl (PIP-001)
     - ve_errores_etl (PIP-002)
     - ve_disponibilidad_datos (PIP-003)
     - solicita_reintento_etl (PIP-004)
   
   Grupo B (Auditoría):
     - ve_auditoria (AUD-001)
     - busca_auditoria (AUD-002)
     - exporta_auditoria (AUD-003)
     - genera_reporte_compliance (AUD-004)
   
   Agrupadores afectados:
     - agr_admin_pipeline ⚔️ agr_auditor
   
   Enforcement:
     - SEC_RULES valida en asignación
     - Bloquea si usuario ya tiene funciones del otro grupo
     - Registra intento violación en MOD_Audit

6.4 Detalle SOD-002: sod_usuarios_auditoria
---------------------------------------------

.. code-block:: yaml

   Restricción: sod_usuarios_auditoria
   Descripción: Quien gestiona usuarios NO debe auditar sus propias acciones
   
   Grupo A (Gestión Usuarios - críticas):
     - crea_usuarios (USR-001)
     - modifica_usuarios (USR-003)
     - elimina_usuarios (USR-004)
     - bloquea_usuarios (USR-007)
   
   Grupo B (Auditoría - parcial):
     - ve_auditoria (AUD-001)
     - busca_auditoria (AUD-002)
     - exporta_auditoria (AUD-003)
   
   Agrupadores afectados:
     - agr_admin_usuarios ⚔️ agr_auditor
   
   Nota: Usuario puede tener ve_usuarios, lista_usuarios 
         (solo lecturas) sin violar SoD

6.5 Detalle SOD-003: sod_acceso_auditoria
-------------------------------------------

.. code-block:: yaml

   Restricción: sod_acceso_auditoria
   Descripción: Quien gestiona acceso NO debe auditar cambios de permisos
   
   Grupo A (Gestión Acceso):
     - asigna_funciones (ACC-001)
     - revoca_funciones (ACC-002)
     - gestiona_sod (ACC-005)
   
   Grupo B (Auditoría):
     - ve_auditoria (AUD-001)
     - busca_auditoria (AUD-002)
   
   Agrupadores afectados:
     - agr_admin_acceso ⚔️ agr_auditor

============================================================
7. SEGMENTOS DE DATOS
============================================================

7.1 Catálogo de Segmentos IACT
--------------------------------

.. list-table:: Los 5 Segmentos de Datos
   :header-rows: 1
   :widths: 15 35 50

   * - Código
     - Nombre
     - Descripción
   * - OP
     - DATOS_OPERATIVOS
     - Datos operación IVR: llamadas, menús, navegación
   * - FI
     - DATOS_FINANCIEROS
     - Costos, facturación, presupuestos
   * - TE
     - DATOS_TECNICOS
     - Infraestructura, rendimiento, disponibilidad
   * - SU
     - DATOS_SUPERVISION
     - Supervisión, control, gestión operativa
   * - CA
     - DATOS_CALIDAD
     - Métricas de calidad, satisfacción, NPS

7.2 Reglas de Segmentación
----------------------------

.. code-block:: yaml

   Regla 1: Usuario = 1 Segmento
     - Cada usuario pertenece a EXACTAMENTE un segmento
     - Campo segmento_id es NOT NULL
     - Asignado en creación de usuario (USR-001 + USR-010)
   
   Regla 2: Filtro Automático (SEC_RULES)
     - MOD_Access/SEC_RULES aplica:
       WHERE segmento_id = @usuario_segmento
     - Usuario solo ve datos de su segmento
     - Automático, transparente
     - No requiere código en módulos
   
   Regla 3: Cross-Segment (Excepcional)
     - Solo con función especial (por definir)
     - Auditado en MOD_Audit
     - Justificación obligatoria
   
   Regla 4: Restricciones CNST
     - CNST_003: Datos según último ETL
     - CNST_006: Rango máximo 2 años

7.3 Ejemplo de Aplicación
---------------------------

.. code-block:: python

   # Código en MOD_Reports/views.py
   # SEC_RULES automáticamente aplica filtro de segmento
   
   @require_function('ve_reportes')
   def ver_reporte_trimestral(request):
       # SEC_RULES intercepta y aplica:
       # WHERE segmento_id = request.user.segmento_id
       
       queryset = LlamadasIVR.objects.filter(
           fecha__gte=fecha_inicio,
           fecha__lte=fecha_fin
       )
       # El filtro de segmento YA está aplicado automáticamente
       # Usuario con segmento_id=OP solo ve datos OP
       # Usuario con segmento_id=FI solo ve datos FI
       
       return render(request, 'reportes/trimestral.html', {
           'datos': queryset
       })

============================================================
8. PERMISOS TEMPORALES
============================================================

8.1 Concepto
-------------

   **Permiso Directo Temporal:** Función otorgada con vencimiento obligatorio.
   
   Casos de uso:
   - Cobertura de vacaciones
   - Auditorías externas
   - Proyectos temporales
   - Emergencias operativas

8.2 Restricciones CNST_005
----------------------------

.. code-block:: yaml

   Justificación:
     - OBLIGATORIA
     - Mínimo 20 caracteres
     - Debe explicar razón de negocio
   
   Vencimiento:
     - OBLIGATORIO
     - Máximo 6 meses
     - Sistema revoca automáticamente al vencer
   
   Precedencia:
     Permiso Directo Temporal > Función Asignada Permanente > Segmento

8.3 Casos de Uso Reales
-------------------------

**Caso 1: Cobertura de vacaciones**

.. code-block:: yaml

   Usuario: maria.lopez
   Función temporal: crea_usuarios (USR-001)
   Duración: 15 días (2026-01-15 a 2026-01-30)
   Justificación: "Cobertura vacaciones admin principal 15-30 enero 2026"
   
   Asignación:
     funcion_id: USR-001
     usuario_id: maria.lopez
     fecha_inicio: 2026-01-15 00:00:00
     fecha_vencimiento: 2026-01-30 23:59:59
     justificacion: "Cobertura vacaciones admin principal 15-30 enero 2026"
     origen: PERMISO_DIRECTO
   
   Revocación:
     - Automática: 2026-01-31 00:00:00
     - Manual: Antes del vencimiento si es necesario

**Caso 2: Auditoría externa**

.. code-block:: yaml

   Usuario: auditor.externo
   Función temporal: exporta_auditoria (AUD-003)
   Duración: 1 mes
   Justificación: "Auditoría externa SOX Q1 2026 - Contrato #AUD-2026-001"
   
   Asignación:
     funcion_id: AUD-003
     usuario_id: auditor.externo
     fecha_inicio: 2026-01-10 00:00:00
     fecha_vencimiento: 2026-02-10 23:59:59
     justificacion: "Auditoría externa SOX Q1 2026 - Contrato #AUD-2026-001"
     origen: PERMISO_DIRECTO
   
   Validación:
     - No viola SoD (auditor.externo no tiene funciones admin)
     - Duración < 6 meses: ✓
     - Justificación > 20 chars: ✓

============================================================
9. MODELO DE DATOS
============================================================

9.1 Diagrama Entidad-Relación
-------------------------------

.. code-block:: text

   ┌─────────────────────┐
   │      usuarios       │
   ├─────────────────────┤
   │ usuario_id (PK)     │
   │ username            │
   │ email               │
   │ estado              │
   │ segmento_id (FK)    │◄──────┐
   └─────────────────────┘       │
             │                   │
             │ N:M               │
             ▼                   │
   ┌─────────────────────┐       │
   │ usuarios_funciones  │       │
   ├─────────────────────┤       │
   │ usuario_id (FK)     │       │
   │ funcion_id (FK)     │───┐   │
   │ origen_agrupador    │   │   │
   │ justificacion       │   │   │
   │ fecha_inicio        │   │   │
   │ fecha_vencimiento   │   │   │
   └─────────────────────┘   │   │
                             │   │
                             ▼   │
               ┌─────────────────────┐
               │      funciones      │
               ├─────────────────────┤
               │ funcion_id (PK)     │
               │ nombre              │
               │ modulo              │
               │ capacidad           │
               │ descripcion         │
               │ activa              │
               └─────────────────────┘
                             │
                             │ N:M
                             ▼
               ┌─────────────────────┐
               │ agrupador_funciones │
               ├─────────────────────┤
               │ agrupador_id (FK)   │
               │ funcion_id (FK)     │
               │ orden               │
               └─────────────────────┘
                             │
                             ▼
               ┌─────────────────────┐
               │    agrupadores      │
               ├─────────────────────┤
               │ agrupador_id (PK)   │
               │ nombre              │
               │ descripcion         │
               │ activo              │
               └─────────────────────┘
   
   ┌─────────────────────┐
   │  restricciones_sod  │
   ├─────────────────────┤
   │ sod_id (PK)         │
   │ nombre              │
   │ funciones_grupo_a   │◄─── JSON array
   │ funciones_grupo_b   │◄─── JSON array
   │ activa              │
   └─────────────────────┘
   
   ┌─────────────────────┐
   │  segmentos_datos    │
   ├─────────────────────┤
   │ segmento_id (PK)    │
   │ codigo              │
   │ nombre              │
   │ descripcion         │
   │ activo              │
   └─────────────────────┘
   
   ┌─────────────────────┐
   │  audit_logs         │
   ├─────────────────────┤
   │ log_id (PK)         │
   │ fecha_evento        │
   │ usuario_id          │
   │ tipo_accion         │
   │ modulo              │
   │ resultado           │
   │ checksum_registro   │
   └─────────────────────┘

============================================================
10. IMPLEMENTACIÓN SQL
============================================================

10.1 Tabla: funciones (44 funciones IACT)
-------------------------------------------

.. code-block:: sql

   CREATE TABLE funciones (
       funcion_id VARCHAR(20) PRIMARY KEY,
       nombre VARCHAR(100) NOT NULL,
       modulo VARCHAR(50) NOT NULL,
       capacidad VARCHAR(100) NOT NULL,
       descripcion VARCHAR(500),
       activa BOOLEAN NOT NULL DEFAULT TRUE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       CONSTRAINT uk_funcion_nombre UNIQUE (nombre),
       INDEX idx_funcion_modulo (modulo),
       INDEX idx_funcion_activa (activa)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   -- Insertar 44 funciones IACT
   INSERT INTO funciones (funcion_id, nombre, modulo, capacidad, descripcion) VALUES
   -- MOD_Auth (4)
   ('AUT-001', 'gestiona_sesiones', 'auth', 'auth:sesiones', 'Gestiona sesiones activas'),
   ('AUT-002', 'cierra_sesion_usuario', 'auth', 'auth:cerrar_sesion', 'Cierra sesión de otro usuario'),
   ('AUT-003', 'resetea_password', 'auth', 'auth:reset_password', 'Genera contraseña temporal'),
   ('AUT-004', 've_sesiones_activas', 'auth', 'auth:ver_sesiones', 'Ve sesiones activas'),
   
   -- MOD_Users (10)
   ('USR-001', 'crea_usuarios', 'users', 'users:crear', 'Crea nuevos usuarios'),
   ('USR-002', 've_usuarios', 'users', 'users:leer', 'Consulta información de usuarios'),
   ('USR-003', 'modifica_usuarios', 'users', 'users:modificar', 'Modifica datos de usuarios'),
   ('USR-004', 'elimina_usuarios', 'users', 'users:eliminar', 'Baja lógica de usuarios'),
   ('USR-005', 'lista_usuarios', 'users', 'users:listar', 'Lista usuarios con filtros'),
   ('USR-006', 'busca_usuarios', 'users', 'users:buscar', 'Busca usuarios por criterios'),
   ('USR-007', 'bloquea_usuarios', 'users', 'users:bloquear', 'Bloquea acceso de usuario'),
   ('USR-008', 'desbloquea_usuarios', 'users', 'users:desbloquear', 'Desbloquea usuario'),
   ('USR-009', 'reactiva_usuarios', 'users', 'users:reactivar', 'Reactiva usuario inactivo'),
   ('USR-010', 'asigna_segmento', 'users', 'users:asignar_segmento', 'Asigna segmento de datos'),
   
   -- MOD_Access (6)
   ('ACC-001', 'asigna_funciones', 'access', 'access:asignar', 'Asigna funciones a usuarios'),
   ('ACC-002', 'revoca_funciones', 'access', 'access:revocar', 'Revoca funciones de usuarios'),
   ('ACC-003', 've_asignaciones', 'access', 'access:ver', 'Ve asignaciones usuario-función'),
   ('ACC-004', 'asigna_agrupadores', 'access', 'access:asignar_agrupador', 'Asigna agrupadores'),
   ('ACC-005', 'gestiona_sod', 'access', 'access:sod', 'Configura restricciones SoD'),
   ('ACC-006', 'gestiona_segmentos', 'access', 'access:segmentos', 'Gestiona catálogo de segmentos'),
   
   -- MOD_Pipeline (4)
   ('PIP-001', 've_estado_etl', 'pipeline', 'pipeline:ver_estado', 'Ve estado del ETL'),
   ('PIP-002', 've_errores_etl', 'pipeline', 'pipeline:ver_errores', 'Consulta errores del ETL'),
   ('PIP-003', 've_disponibilidad_datos', 'pipeline', 'pipeline:disponibilidad', 'Consulta disponibilidad de datos'),
   ('PIP-004', 'solicita_reintento_etl', 'pipeline', 'pipeline:reintento', 'Solicita reintento ETL'),
   
   -- MOD_Reports (8)
   ('RPT-001', 've_reportes', 'reports', 'reports:ver', 'Ve reportes tabulares'),
   ('RPT-002', 've_dashboard', 'reports', 'reports:dashboard', 'Ve dashboard principal'),
   ('RPT-003', 'filtra_reportes', 'reports', 'reports:filtrar', 'Aplica filtros a reportes'),
   ('RPT-004', 'exporta_csv', 'reports', 'reports:exportar_csv', 'Exporta a CSV'),
   ('RPT-005', 'exporta_excel', 'reports', 'reports:exportar_excel', 'Exporta a Excel'),
   ('RPT-006', 'exporta_pdf', 'reports', 'reports:exportar_pdf', 'Exporta a PDF'),
   ('RPT-007', 've_kpis', 'reports', 'reports:kpis', 'Ve KPIs estáticos'),
   ('RPT-008', 've_graficos', 'reports', 'reports:graficos', 'Ve gráficos'),
   
   -- MOD_Alerts (6)
   ('ALR-001', 've_alertas', 'alerts', 'alerts:ver', 'Ve alertas propias'),
   ('ALR-002', 'configura_alertas', 'alerts', 'alerts:configurar', 'Configura alertas personales'),
   ('ALR-003', 'configura_alertas_equipo', 'alerts', 'alerts:config_equipo', 'Alertas para equipo'),
   ('ALR-004', 'pausa_alertas', 'alerts', 'alerts:pausar', 'Pausa alertas'),
   ('ALR-005', 'elimina_alertas', 'alerts', 'alerts:eliminar', 'Elimina alertas propias'),
   ('ALR-006', 've_historial_alertas', 'alerts', 'alerts:historial', 'Ve historial de alertas'),
   
   -- MOD_Audit (4)
   ('AUD-001', 've_auditoria', 'audit', 'audit:ver', 'Ve logs de auditoría'),
   ('AUD-002', 'busca_auditoria', 'audit', 'audit:buscar', 'Busca en logs'),
   ('AUD-003', 'exporta_auditoria', 'audit', 'audit:exportar', 'Exporta logs'),
   ('AUD-004', 'genera_reporte_compliance', 'audit', 'audit:compliance', 'Genera reportes compliance'),
   
   -- MOD_Logs (2)
   ('LOG-001', 've_logs_tecnicos', 'logs', 'logs:ver', 'Ve logs técnicos'),
   ('LOG-002', 'exporta_logs', 'logs', 'logs:exportar', 'Exporta logs técnicos');

10.2 Tabla: agrupadores (10 agrupadores IACT)
-----------------------------------------------

.. code-block:: sql

   CREATE TABLE agrupadores (
       agrupador_id VARCHAR(20) PRIMARY KEY,
       nombre VARCHAR(100) NOT NULL,
       descripcion VARCHAR(500),
       activo BOOLEAN NOT NULL DEFAULT TRUE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       CONSTRAINT uk_agrupador_nombre UNIQUE (nombre)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   INSERT INTO agrupadores (agrupador_id, nombre, descripcion) VALUES
   ('AGR-001', 'agr_operador_basico', 'Funciones mínimas para consulta'),
   ('AGR-002', 'agr_operador_reportes', 'Acceso completo a reportes'),
   ('AGR-003', 'agr_supervisor', 'Supervisor con alertas de equipo'),
   ('AGR-004', 'agr_exportador', 'Exportación de reportes'),
   ('AGR-005', 'agr_gestor_alertas', 'Gestión de alertas'),
   ('AGR-006', 'agr_admin_usuarios', 'Administración de usuarios'),
   ('AGR-007', 'agr_admin_acceso', 'Administración de acceso RBAC'),
   ('AGR-008', 'agr_auditor', 'Auditoría y compliance'),
   ('AGR-009', 'agr_admin_pipeline', 'Supervisión del ETL'),
   ('AGR-010', 'agr_admin_logs', 'Bitácoras técnicas');

10.3 Tabla: agrupador_funciones
---------------------------------

.. code-block:: sql

   CREATE TABLE agrupador_funciones (
       id INT AUTO_INCREMENT PRIMARY KEY,
       agrupador_id VARCHAR(20) NOT NULL,
       funcion_id VARCHAR(20) NOT NULL,
       orden SMALLINT NOT NULL DEFAULT 0,
       
       CONSTRAINT fk_af_agrupador FOREIGN KEY (agrupador_id) 
           REFERENCES agrupadores(agrupador_id),
       CONSTRAINT fk_af_funcion FOREIGN KEY (funcion_id) 
           REFERENCES funciones(funcion_id),
       CONSTRAINT uk_agrupador_funcion UNIQUE (agrupador_id, funcion_id)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   -- AGR-001: agr_operador_basico (5)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-001', 'RPT-001', 1), ('AGR-001', 'RPT-002', 2), ('AGR-001', 'RPT-003', 3),
   ('AGR-001', 'ALR-001', 4), ('AGR-001', 'ALR-006', 5);
   
   -- AGR-002: agr_operador_reportes (8)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-002', 'RPT-001', 1), ('AGR-002', 'RPT-002', 2), ('AGR-002', 'RPT-003', 3),
   ('AGR-002', 'RPT-007', 4), ('AGR-002', 'RPT-008', 5), ('AGR-002', 'ALR-001', 6),
   ('AGR-002', 'ALR-002', 7), ('AGR-002', 'ALR-006', 8);
   
   -- AGR-003: agr_supervisor (12)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-003', 'RPT-001', 1), ('AGR-003', 'RPT-002', 2), ('AGR-003', 'RPT-003', 3),
   ('AGR-003', 'RPT-004', 4), ('AGR-003', 'RPT-005', 5), ('AGR-003', 'RPT-007', 6),
   ('AGR-003', 'RPT-008', 7), ('AGR-003', 'ALR-001', 8), ('AGR-003', 'ALR-002', 9),
   ('AGR-003', 'ALR-003', 10), ('AGR-003', 'ALR-004', 11), ('AGR-003', 'ALR-006', 12);
   
   -- AGR-004: agr_exportador (3)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-004', 'RPT-004', 1), ('AGR-004', 'RPT-005', 2), ('AGR-004', 'RPT-006', 3);
   
   -- AGR-005: agr_gestor_alertas (6)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-005', 'ALR-001', 1), ('AGR-005', 'ALR-002', 2), ('AGR-005', 'ALR-003', 3),
   ('AGR-005', 'ALR-004', 4), ('AGR-005', 'ALR-005', 5), ('AGR-005', 'ALR-006', 6);
   
   -- AGR-006: agr_admin_usuarios (12)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-006', 'USR-001', 1), ('AGR-006', 'USR-002', 2), ('AGR-006', 'USR-003', 3),
   ('AGR-006', 'USR-004', 4), ('AGR-006', 'USR-005', 5), ('AGR-006', 'USR-006', 6),
   ('AGR-006', 'USR-007', 7), ('AGR-006', 'USR-008', 8), ('AGR-006', 'USR-009', 9),
   ('AGR-006', 'USR-010', 10), ('AGR-006', 'ACC-001', 11), ('AGR-006', 'ACC-002', 12);
   
   -- AGR-007: agr_admin_acceso (6)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-007', 'ACC-001', 1), ('AGR-007', 'ACC-002', 2), ('AGR-007', 'ACC-003', 3),
   ('AGR-007', 'ACC-004', 4), ('AGR-007', 'ACC-005', 5), ('AGR-007', 'ACC-006', 6);
   
   -- AGR-008: agr_auditor (4)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-008', 'AUD-001', 1), ('AGR-008', 'AUD-002', 2),
   ('AGR-008', 'AUD-003', 3), ('AGR-008', 'AUD-004', 4);
   
   -- AGR-009: agr_admin_pipeline (4)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-009', 'PIP-001', 1), ('AGR-009', 'PIP-002', 2),
   ('AGR-009', 'PIP-003', 3), ('AGR-009', 'PIP-004', 4);
   
   -- AGR-010: agr_admin_logs (2)
   INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
   ('AGR-010', 'LOG-001', 1), ('AGR-010', 'LOG-002', 2);

10.4 Tabla: usuarios_funciones
--------------------------------

.. code-block:: sql

   CREATE TABLE usuarios_funciones (
       id INT AUTO_INCREMENT PRIMARY KEY,
       usuario_id INT NOT NULL,
       funcion_id VARCHAR(20) NOT NULL,
       origen VARCHAR(50) NOT NULL, -- 'DIRECTO', 'AGRUPADOR', 'SEGMENTO'
       origen_agrupador VARCHAR(20), -- Solo si origen='AGRUPADOR'
       justificacion TEXT, -- OBLIGATORIO si origen='DIRECTO'
       fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       fecha_vencimiento DATETIME, -- OBLIGATORIO si origen='DIRECTO'
       activa BOOLEAN NOT NULL DEFAULT TRUE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       creado_por INT NOT NULL,
       
       CONSTRAINT fk_uf_usuario FOREIGN KEY (usuario_id) 
           REFERENCES usuarios(usuario_id),
       CONSTRAINT fk_uf_funcion FOREIGN KEY (funcion_id) 
           REFERENCES funciones(funcion_id),
       CONSTRAINT fk_uf_creador FOREIGN KEY (creado_por) 
           REFERENCES usuarios(usuario_id),
       CONSTRAINT uk_usuario_funcion UNIQUE (usuario_id, funcion_id),
       INDEX idx_uf_usuario (usuario_id),
       INDEX idx_uf_vencimiento (fecha_vencimiento)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

10.5 Tabla: restricciones_sod
-------------------------------

.. code-block:: sql

   CREATE TABLE restricciones_sod (
       sod_id VARCHAR(20) PRIMARY KEY,
       nombre VARCHAR(100) NOT NULL,
       descripcion VARCHAR(500),
       funciones_grupo_a JSON NOT NULL, -- Array de funcion_id
       funciones_grupo_b JSON NOT NULL, -- Array de funcion_id
       activa BOOLEAN NOT NULL DEFAULT TRUE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       CONSTRAINT uk_sod_nombre UNIQUE (nombre)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   INSERT INTO restricciones_sod (sod_id, nombre, descripcion, funciones_grupo_a, funciones_grupo_b) VALUES
   ('SOD-001', 'sod_admin_auditoria', 
    'Quien opera pipeline NO audita',
    '["PIP-001","PIP-002","PIP-003","PIP-004"]',
    '["AUD-001","AUD-002","AUD-003","AUD-004"]'),
   
   ('SOD-002', 'sod_usuarios_auditoria',
    'Quien gestiona usuarios NO audita',
    '["USR-001","USR-003","USR-004","USR-007"]',
    '["AUD-001","AUD-002","AUD-003"]'),
   
   ('SOD-003', 'sod_acceso_auditoria',
    'Quien gestiona acceso NO audita',
    '["ACC-001","ACC-002","ACC-005"]',
    '["AUD-001","AUD-002"]');

10.6 Tabla: segmentos_datos
-----------------------------

.. code-block:: sql

   CREATE TABLE segmentos_datos (
       segmento_id VARCHAR(10) PRIMARY KEY,
       codigo VARCHAR(10) NOT NULL,
       nombre VARCHAR(100) NOT NULL,
       descripcion VARCHAR(500),
       activo BOOLEAN NOT NULL DEFAULT TRUE,
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       CONSTRAINT uk_segmento_codigo UNIQUE (codigo)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
   
   INSERT INTO segmentos_datos (segmento_id, codigo, nombre, descripcion) VALUES
   ('OP', 'OP', 'DATOS_OPERATIVOS', 'Datos operación IVR: llamadas, menús'),
   ('FI', 'FI', 'DATOS_FINANCIEROS', 'Costos y facturación'),
   ('TE', 'TE', 'DATOS_TECNICOS', 'Infraestructura y rendimiento'),
   ('SU', 'SU', 'DATOS_SUPERVISION', 'Supervisión y control'),
   ('CA', 'CA', 'DATOS_CALIDAD', 'Métricas de calidad');

============================================================
11. IMPLEMENTACIÓN DJANGO
============================================================

11.1 Decorador @require_function
----------------------------------

.. code-block:: python

   # file: core/decorators.py
   from functools import wraps
   from django.http import HttpResponseForbidden
   from django.shortcuts import redirect
   from .rbac import RBACManager
   
   def require_function(function_name):
       """
       Decorador que valida si el usuario tiene la función RBAC requerida.
       
       Uso:
           @require_function('ve_reportes')
           def ver_reporte(request):
               ...
       """
       def decorator(view_func):
           @wraps(view_func)
           def _wrapped_view(request, *args, **kwargs):
               if not request.user.is_authenticated:
                   return redirect('login')
               
               rbac = RBACManager()
               
               # Validar función
               if not rbac.user_has_function(request.user, function_name):
                   # Registrar intento fallido en auditoría
                   rbac.log_access_denied(
                       user=request.user,
                       function=function_name,
                       ip=request.META.get('REMOTE_ADDR')
                   )
                   return HttpResponseForbidden(
                       f"Acceso denegado: Requiere función '{function_name}'"
                   )
               
               # Registrar acceso exitoso
               rbac.log_access_granted(
                   user=request.user,
                   function=function_name,
                   ip=request.META.get('REMOTE_ADDR')
               )
               
               return view_func(request, *args, **kwargs)
           return _wrapped_view
       return decorator

11.2 Middleware SEC_RULES (Filtro de Segmentos)
-------------------------------------------------

.. code-block:: python

   # file: core/middleware.py
   from django.utils.deprecation import MiddlewareMixin
   
   class DataSegmentMiddleware(MiddlewareMixin):
       """
       Middleware que aplica automáticamente el filtro de segmento de datos.
       
       Para TODOS los querysets:
           queryset.filter(segmento_id=request.user.segmento_id)
       """
       
       def process_request(self, request):
           if request.user.is_authenticated:
               # Inyectar segmento en request para uso posterior
               request.user_segment = request.user.segmento_id
       
       def process_template_response(self, request, response):
           # Validar que no se filtren datos de otros segmentos
           # (implementación específica según modelo ORM)
           return response

11.3 RBACManager - Clase Principal
------------------------------------

.. code-block:: python

   # file: core/rbac.py
   from django.db import models
   from django.utils import timezone
   from datetime import timedelta
   import json
   
   class RBACManager:
       """
       Gestor del modelo RBAC v5.1.1
       """
       
       def user_has_function(self, user, function_name):
           """
           Verifica si el usuario tiene la función requerida.
           
           Precedencia:
               1. Permiso directo temporal (activo)
               2. Función asignada permanente
               3. Función del segmento
           """
           from .models import UsuarioFuncion, Funcion
           
           try:
               funcion = Funcion.objects.get(nombre=function_name, activa=True)
           except Funcion.DoesNotExist:
               return False
           
           # Verificar permisos directos temporales
           permiso_directo = UsuarioFuncion.objects.filter(
               usuario=user,
               funcion=funcion,
               origen='DIRECTO',
               activa=True,
               fecha_vencimiento__gte=timezone.now()
           ).exists()
           
           if permiso_directo:
               return True
           
           # Verificar funciones permanentes (de agrupador o directas sin vencimiento)
           permiso_permanente = UsuarioFuncion.objects.filter(
               usuario=user,
               funcion=funcion,
               activa=True
           ).filter(
               models.Q(fecha_vencimiento__isnull=True) |
               models.Q(fecha_vencimiento__gte=timezone.now())
           ).exists()
           
           return permiso_permanente
       
       def assign_function(self, user, function_name, by_user, 
                          justification=None, expires_in_days=None):
           """
           Asigna una función a un usuario.
           
           Args:
               user: Usuario destino
               function_name: Nombre de la función
               by_user: Usuario que realiza la asignación
               justification: Justificación (OBLIGATORIO si temporal)
               expires_in_days: Días de vigencia (None = permanente)
           """
           from .models import UsuarioFuncion, Funcion
           
           funcion = Funcion.objects.get(nombre=function_name, activa=True)
           
           # Validaciones CNST_005
           if expires_in_days:
               # Permiso temporal
               if not justification or len(justification) < 20:
                   raise ValueError("Justificación mínima 20 caracteres")
               
               if expires_in_days > 180:  # 6 meses
                   raise ValueError("Vencimiento máximo 6 meses")
               
               fecha_vencimiento = timezone.now() + timedelta(days=expires_in_days)
               origen = 'DIRECTO'
           else:
               # Permiso permanente
               fecha_vencimiento = None
               origen = 'ASIGNADO'
           
           # Validar SoD
           if not self._validate_sod(user, funcion):
               raise ValueError(f"Violación SoD: Usuario ya tiene funciones incompatibles")
           
           # Crear asignación
           UsuarioFuncion.objects.create(
               usuario=user,
               funcion=funcion,
               origen=origen,
               justificacion=justification,
               fecha_vencimiento=fecha_vencimiento,
               creado_por=by_user
           )
       
       def assign_agrupador(self, user, agrupador_name, by_user):
           """
           Asigna un agrupador completo a un usuario.
           
           Crea N asignaciones individuales (una por función del agrupador).
           """
           from .models import Agrupador, AgrupadorFuncion, UsuarioFuncion
           
           agrupador = Agrupador.objects.get(nombre=agrupador_name, activo=True)
           funciones = AgrupadorFuncion.objects.filter(
               agrupador=agrupador
           ).select_related('funcion').order_by('orden')
           
           # Validar SoD para TODAS las funciones del agrupador
           for af in funciones:
               if not self._validate_sod(user, af.funcion):
                   raise ValueError(
                       f"Violación SoD: Agrupador contiene funciones incompatibles"
                   )
           
           # Crear asignaciones
           for af in funciones:
               UsuarioFuncion.objects.get_or_create(
                   usuario=user,
                   funcion=af.funcion,
                   defaults={
                       'origen': 'AGRUPADOR',
                       'origen_agrupador': agrupador.agrupador_id,
                       'creado_por': by_user
                   }
               )
       
       def _validate_sod(self, user, funcion):
           """
           Valida restricciones SoD.
           
           Returns:
               True si no hay violación, False si viola SoD
           """
           from .models import RestriccionSoD, UsuarioFuncion
           
           # Obtener funciones actuales del usuario
           funciones_usuario = set(
               UsuarioFuncion.objects.filter(
                   usuario=user,
                   activa=True
               ).values_list('funcion__funcion_id', flat=True)
           )
           
           # Verificar cada restricción SoD
           for sod in RestriccionSoD.objects.filter(activa=True):
               grupo_a = json.loads(sod.funciones_grupo_a)
               grupo_b = json.loads(sod.funciones_grupo_b)
               
               # Si la función a asignar está en grupo A
               if funcion.funcion_id in grupo_a:
                   # Verificar que usuario no tenga funciones de grupo B
                   if any(f in grupo_b for f in funciones_usuario):
                       return False
               
               # Si la función a asignar está en grupo B
               if funcion.funcion_id in grupo_b:
                   # Verificar que usuario no tenga funciones de grupo A
                   if any(f in grupo_a for f in funciones_usuario):
                       return False
           
           return True
       
       def revoke_expired_permissions(self):
           """
           Revoca automáticamente permisos vencidos.
           
           Ejecutar diariamente via cron/celery.
           """
           from .models import UsuarioFuncion
           
           count = UsuarioFuncion.objects.filter(
               activa=True,
               fecha_vencimiento__lt=timezone.now()
           ).update(activa=False)
           
           return count

============================================================
12. MAPEO FUNCIONES → CASOS DE USO
============================================================

12.1 Vista General
-------------------

.. list-table:: Mapeo Funciones RBAC → Casos de Uso
   :header-rows: 1
   :widths: 15 30 55

   * - Módulo
     - Funciones
     - Casos de Uso
   * - MOD_Auth
     - 4 funciones
     - UC-001 a UC-005
   * - MOD_Users
     - 10 funciones
     - UC-006 a UC-009, UC-041
   * - MOD_Access
     - 6 funciones
     - UC-010, UC-011, UC-042 a UC-047
   * - MOD_Pipeline
     - 4 funciones
     - UC-050 a UC-053
   * - MOD_Reports
     - 8 funciones
     - UC-017 a UC-029
   * - MOD_Alerts
     - 6 funciones
     - UC-036 a UC-040
   * - MOD_Audit
     - 4 funciones
     - UC-060 a UC-063
   * - MOD_Logs
     - 2 funciones
     - UC-070 a UC-072

12.2 Mapeo Detallado por Módulo
---------------------------------

**MOD_Auth:**

- ``gestiona_sesiones`` → UC-005
- ``cierra_sesion_usuario`` → UC-005
- ``resetea_password`` → UC-003
- ``ve_sesiones_activas`` → UC-005

**MOD_Users:**

- ``crea_usuarios`` → UC-006
- ``modifica_usuarios`` → UC-007
- ``elimina_usuarios`` → UC-008
- ``lista_usuarios, busca_usuarios`` → UC-009
- ``bloquea_usuarios, desbloquea_usuarios`` → UC-007
- ``asigna_segmento`` → UC-041

**MOD_Access:**

- ``asigna_funciones`` → UC-010, UC-042
- ``revoca_funciones`` → UC-010
- ``ve_asignaciones`` → UC-011, UC-044
- ``gestiona_sod`` → UC-043
- ``gestiona_segmentos`` → UC-045, UC-046

**MOD_Reports:**

- ``ve_reportes`` → UC-017, UC-018, UC-019
- ``ve_dashboard`` → UC-025
- ``filtra_reportes`` → UC-020, UC-021
- ``exporta_csv`` → UC-022
- ``exporta_excel`` → UC-023
- ``exporta_pdf`` → UC-024
- ``ve_graficos`` → UC-027, UC-028, UC-029

============================================================
13. MIGRACIÓN v4.0 → v5.1
============================================================

13.1 Mapeo de Roles Antiguos
------------------------------

.. list-table:: Migración Roles v4.0 → Agrupadores v5.1
   :header-rows: 1
   :widths: 30 35 35

   * - Rol v4.0
     - Agrupador v5.1-IACT
     - Notas
   * - USERS_FULL_MANAGER
     - AGR-006 agr_admin_usuarios
     - Asignación directa
   * - USERS_VIEWER
     - ve_usuarios + lista_usuarios
     - Funciones individuales
   * - REPORTS_VIEWER
     - AGR-001 agr_operador_basico
     - Asignación directa
   * - REPORTS_EXPORTER
     - AGR-001 + AGR-004
     - Combinar agrupadores
   * - SYSTEM_ADMIN
     - AGR-009 agr_admin_pipeline
     - Asignación directa
   * - AUDIT_VIEWER
     - AGR-008 agr_auditor
     - SoD con SYSTEM_ADMIN
   * - ALERTS_MANAGER
     - AGR-005 agr_gestor_alertas
     - Asignación directa

13.2 Script de Migración
--------------------------

.. code-block:: python

   # file: scripts/migrate_rbac_v4_to_v51.py
   """
   Migración de RBAC v4.0 (roles) a RBAC v5.1 (funciones atómicas)
   """
   from django.core.management.base import BaseCommand
   from core.models import Usuario, UsuarioRol, UsuarioFuncion, Agrupador
   from core.rbac import RBACManager
   
   class Command(BaseCommand):
       help = 'Migra de RBAC v4.0 a v5.1'
       
       MAPEO_ROLES = {
           'USERS_FULL_MANAGER': 'AGR-006',
           'REPORTS_VIEWER': 'AGR-001',
           'SYSTEM_ADMIN': 'AGR-009',
           'AUDIT_VIEWER': 'AGR-008',
           'ALERTS_MANAGER': 'AGR-005',
       }
       
       def handle(self, *args, **options):
           rbac = RBACManager()
           migrated = 0
           errors = 0
           
           for usuario in Usuario.objects.filter(activo=True):
               try:
                   # Obtener roles v4.0 del usuario
                   roles_antiguos = UsuarioRol.objects.filter(
                       usuario=usuario
                   ).values_list('rol__codigo', flat=True)
                   
                   for rol_codigo in roles_antiguos:
                       if rol_codigo in self.MAPEO_ROLES:
                           agrupador_id = self.MAPEO_ROLES[rol_codigo]
                           agrupador = Agrupador.objects.get(
                               agrupador_id=agrupador_id
                           )
                           
                           # Asignar agrupador
                           rbac.assign_agrupador(
                               user=usuario,
                               agrupador_name=agrupador.nombre,
                               by_user=usuario  # migración automática
                           )
                           
                           self.stdout.write(
                               f"✓ {usuario.username}: {rol_codigo} → {agrupador.nombre}"
                           )
                           migrated += 1
                       else:
                           self.stdout.write(
                               self.style.WARNING(
                                   f"⚠ {usuario.username}: Rol '{rol_codigo}' sin mapeo"
                               )
                           )
               
               except Exception as e:
                   self.stdout.write(
                       self.style.ERROR(f"✗ {usuario.username}: {str(e)}")
                   )
                   errors += 1
           
           self.stdout.write(
               self.style.SUCCESS(
                   f"\n✓ Migración completada: {migrated} asignaciones, {errors} errores"
               )
           )

============================================================
14. REFERENCIAS
============================================================

14.1 Documentos Fuente
-----------------------

:Documento_Base: MODELO_RBAC_IACT_v5_1_1.md
:Alineación_Módulos: REFERENCIA_GLOBAL_MODULOS_IACT_v1.md
:Fecha_Fuentes: 2026-01-03

14.2 Documentos Relacionados
------------------------------

:NOM_001: Nomenclatura del Proyecto v2.0.0
:STD_001: Estándares de Documentación v1.1.0
:CNST_001: NO Email bajo ninguna circunstancia
:CNST_002: Sesiones en BD, única, timeout 15 min
:CNST_003: BD IVR readonly, ETL 6-12h, NO real-time
:CNST_004: Alertas buzón interno, máx 50 destinatarios
:CNST_006: Reportes: rango máx 2 años
:CNST_007: Límites exportación, throttling
:CNST_008: Audit inmutable, logs sin PII

14.3 Casos de Uso
------------------

Ver sección 12 para mapeo completo UC → Funciones RBAC

============================================================
15. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Migración completa a modelo RBAC v5.1.1 con:
       44 funciones atómicas, 10 agrupadores, 3 restricciones SoD,
       5 segmentos de datos. Incluye implementación SQL y Django completa.

============================================================

.. note::
   Este documento define el **CORE** del sistema RBAC v5.1.1 y es
   **FUNDACIONAL** para toda la documentación del proyecto IACT.
   
   Cualquier modificación a este documento requiere aprobación del
   Tech Lead y actualización de TODOS los casos de uso relacionados.

**FIN DEL DOCUMENTO CNST_005**
