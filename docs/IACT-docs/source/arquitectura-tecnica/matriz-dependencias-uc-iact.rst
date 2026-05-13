.. meta::
 :artefacto: MATRIZ_DEPENDENCIAS_UC_IACT
 :tipo: Analisis Arquitectonico
 :dominio: arquitectura_tecnica
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-05-01
 :ultimo_cambio: 2026-05-01
 :autor: NestorMonroy
 :clasificacion: Critico

.. _matriz-dependencias-uc-iact:

==============================
MATRIZ DEPENDENCIAS UC IACT
==============================

.. note::

 **Analisis canonico de dependencias** entre los 61 casos de uso
 vigentes del catalogo IACT. Producido por el WP
 ``2026-05-01-05-17-20-uc-dependency-matrix-iact`` y promovido a
 ``source/`` por el WP
 ``2026-05-01-06-24-28-promote-matriz-dependencias-to-source``.

 **Documentos vinculados:**

 - :doc:`/arquitectura-tecnica/modelo-dominio-iact` v1.0.0
   (25 clases canonicas, 7 bounded contexts).
 - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` v5.4.0
   (61 funciones RBAC).

 **Convencion de nombres**: identificadores en ingles (clases,
 funciones, atributos); prosa, comentarios y notas en espanol.

----

PARTE 1 — Resumen ejecutivo
===========================

1.1 Resumen ejecutivo
---------------------

El catalogo IACT esta formado por **61 casos de uso** agrupados en
**9 clusters funcionales** (AUTH, USR, ACC, PERM, RPT, ALR, PIP, AUD,
LOG) que operan sobre **25 clases de dominio** distribuidas en
**7 bounded contexts** (Auth, RBAC, Calls, Reports & Metrics,
Pipeline ETL, Alerts, Audit, Logs).

Esta matriz analiza las dependencias estructurales entre los 61 UCs
para identificar:

- **Cuales UCs son criticos** — sin ellos el sistema no entrega su
  valor de negocio (call-center analytics + RBAC granular +
  auditoria compliance).
- **Cual es el flujo minimo end-to-end** que el sistema debe soportar
  para considerarse operativo.
- **Que dependencias son transversales** — invocadas implicitamente
  por casi todos los UCs (autenticacion, verificacion de permiso,
  emision de auditoria).
- **Que dependencias son cuellos de botella** — puntos del grafo cuya
  falla deja sin servicio a varios consumidores aguas abajo.

1.2 Distribucion por criticidad
-------------------------------

.. list-table::
 :widths: 25 15 60
 :header-rows: 1

 * - Criticidad
   - UCs
   - Definicion operativa
 * - CRITICOS
   - 8 (13%)
   - Sin estos, IACT no opera. Bloquean cualquier ruta de valor.
 * - ALTOS
   - 27 (44%)
   - Esenciales operativos. Sin ellos el sistema funciona en modo
     degradado.
 * - MEDIOS
   - 18 (30%)
   - Funcionalidades importantes prescindibles en una primera
     version funcional.
 * - BAJOS
   - 8 (13%)
   - Opcionales / sub-features avanzadas.

**Total verificado: 8 + 27 + 18 + 8 = 61 UCs.**

1.2.1 Los 8 UCs CRITICOS
~~~~~~~~~~~~~~~~~~~~~~~~

::

   UC_AUTH_01  Iniciar Sesion        (entrada universal)
   UC_AUTH_04  Cambiar Contrasena    (forzado primer login, CNST-003)
   UC_PERM_07  Verificar Permiso     (gate seguridad universal)
   UC_USR_02   Consultar Usuarios    (baseline admin RBAC)
   UC_ACC_03   Consultar Permisos    (visibilidad RBAC minima)
   UC_PIP_01   Supervisar ETL        (sin ETL no hay analytics)
   UC_RPT_01   Ver Dashboard         (UI principal del producto)
   UC_AUD_01   Consultar Auditoria   (compliance mandatorio CNST-025)

1.3 Flujo critico identificado
------------------------------

A diferencia de un ecommerce (Login → Catalogo → Carrito → Pago), el
flujo critico de IACT no es un unico pipeline lineal. IACT es una
**plataforma de analytics + RBAC** con **cuatro caminos criticos
paralelos** segun el actor:

**Ruta A — Sistema (background)**: pre-requisito de todos los demas
caminos.

::

   ETL externo (background)
        ↓
   UC_PIP_01  Supervisar ETL
   (carga datos en BD analitica segun ventana CNST-006/008)
        ↓
   Datos analiticos disponibles

**Ruta B — Operador / Supervisor**: camino de valor de negocio.

::

   UC_AUTH_01 → [primer login: UC_AUTH_04] → UC_PERM_07
        ↓
   UC_RPT_01  Ver Dashboard

**Ruta C — Administrador RBAC**: camino de bootstrap.

::

   UC_AUTH_01 → UC_PERM_07
        ↓
   UC_USR_02 + UC_ACC_03 (visibilidad RBAC minima)

**Ruta D — Auditor**: camino de compliance (CNST-025).

::

   UC_AUTH_01 → UC_PERM_07
        ↓
   UC_AUD_01  Consultar Auditoria

1.4 Tres dependencias transversales
-----------------------------------

.. list-table::
 :widths: 15 25 60
 :header-rows: 1

 * - ID
   - Nombre
   - Cobertura
 * - **T-01**
   - Sesion activa (CNST-003)
   - 59 / 61 UCs (todos no publicos). Pre-condicion universal.
 * - **T-02**
   - Verificar permiso (UC_PERM_07)
   - 59 / 61 UCs. Invocado implicitamente en cada request.
 * - **T-03**
   - Emitir AuditEvent (CNST-025)
   - 35 / 61 UCs (todas las operaciones de escritura).

1.5 Densidad del grafo
----------------------

::

   Nodos:                       61 UCs
   Aristas REQUIERE explicitas: ~70
   Aristas T-01:                59
   Aristas T-02:                59
   Aristas T-03:                35
   UCs raiz (REQUIERE = none):  18
   Camino critico minimo:       4 UCs
   Centralidad alta:            UC_AUTH_01, UC_PERM_07, UC_PIP_01

----

PARTE 2 — Tabla maestra de los 61 UCs
=====================================

Ficha por UC organizada por los 9 clusters. Cada ficha incluye los
campos clave para analisis de dependencias.

2.0 Convenciones de la ficha
----------------------------

Cada UC se documenta con:

- **Criticidad** — CRITICO / ALTO / MEDIO / BAJO.
- **Complejidad** — ALTA / MEDIA / BAJA y dias estimados.
- **Actor** — actor primario.
- **Incluye** — operaciones internas.
- **Patrones** — patrones de diseno aplicables.
- **Clase Dominio** — clases canonicas tocadas.
- **Funcion RBAC** — funciones de modelo-rbac-iact v5.4.0.
- **Dependencias** — UCs que invoca o requiere.
- **Cat Z.2.A** — categoria del programa Z.2.A (1..5).

2.1 Cluster AUTH (5 UCs)
------------------------

Responsabilidad: gate de entrada al sistema, gestion del ciclo de
vida de Session, y notificacion de cambios sensibles via
InternalMailbox. **2 CRITICOS + 2 ALTOS + 1 MEDIO**.

.. list-table::
 :widths: 18 12 10 25 35
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio (primaria + secundarias)
 * - UC_AUTH_01 Iniciar Sesion
   - CRITICO
   - 5
   - publico (post-login AUTH-001)
   - ``Session``, ``User``, ``AuditEvent``
 * - UC_AUTH_02 Cerrar Sesion
   - ALTO
   - 1
   - sesion propia
   - ``Session``, ``AuditEvent``
 * - UC_AUTH_03 Recuperar Contrasena
   - MEDIO
   - 3
   - AUTH-003 ``reset_password``
   - ``User``, ``InternalMailbox``, ``AuditEvent``
 * - UC_AUTH_04 Cambiar Contrasena
   - CRITICO
   - 2
   - usuario sobre si mismo
   - ``User``, ``AuditEvent``
 * - UC_AUTH_05 Gestionar Sesiones
   - ALTO
   - 3
   - AUTH-001/002/004
   - ``Session``, ``User``, ``AuditEvent``

2.2 Cluster USR (4 UCs)
-----------------------

Responsabilidad: CRUD del catalogo de usuarios. Toda modificacion
con ciclo de vida soft-delete (BR-009 v2.0.0). **1 CRITICO + 3 ALTOS**.

.. list-table::
 :widths: 18 12 10 25 35
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_USR_01 Crear Usuario
   - ALTO
   - 4
   - USR-001 ``create_users``
   - ``User``, ``Assignment``, ``AccessGroup``, ``AuditEvent``
 * - UC_USR_02 Consultar Usuarios
   - CRITICO
   - 3
   - USR-005, USR-009
   - ``User``, ``Assignment``, ``AccessGroup``
 * - UC_USR_03 Modificar Usuario
   - ALTO
   - 3
   - USR-002 ``update_users``
   - ``User``, ``Session``, ``AuditEvent``
 * - UC_USR_04 Eliminar (Deactivate) Usuario
   - ALTO
   - 2
   - USR-003 ``deactivate_users`` (rename Z.2 D-01)
   - ``User``, ``Session``, ``AuditEvent``

2.3 Cluster ACC (7 UCs)
-----------------------

Responsabilidad: asignar/revocar funciones, agrupadores
predefinidos, permisos excepcionales y reglas SoD.
**1 CRITICO + 4 ALTOS + 1 MEDIO + 1 BAJO**.

.. list-table::
 :widths: 18 12 10 25 35
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_ACC_01 Asignar Funciones
   - ALTO
   - 4
   - ACC-001 ``assign_functions``
   - ``Assignment``, ``Function``, ``User``, ``AuditEvent``
 * - UC_ACC_02 Revocar Funciones
   - ALTO
   - 2
   - ACC-002 ``revoke_functions``
   - ``Assignment``, ``Function``, ``User``, ``AuditEvent``
 * - UC_ACC_03 Consultar Permisos
   - CRITICO
   - 3
   - ACC-003 ``view_assignments``
   - ``Assignment``, ``Function``, ``User``
 * - UC_ACC_04 Asignar Agrupador
   - ALTO
   - 2
   - ACC-004 ``assign_function_groups``
   - ``Assignment``, ``AccessGroup``, ``User``, ``AuditEvent``
 * - UC_ACC_05 Gestionar SoD
   - ALTO
   - 5
   - ACC-005/011/012 (per Z.2 D-01)
   - ``SeparationRule``, ``Function``, ``AuditEvent``
 * - UC_ACC_08 Permiso Temporal
   - MEDIO
   - 3
   - ACC-001 (reuso)
   - ``ExceptionalPermission``, ``User``, ``Function``, ``AuditEvent``
 * - UC_ACC_09 Auditar Cambios de Acceso
   - BAJO
   - 2
   - AUD-001 ``view_audit_log``
   - ``AuditEvent``, ``User``, ``Assignment``

2.4 Cluster PERM (10 UCs) — vista tecnica del RBAC
--------------------------------------------------

Responsabilidad: vista tecnica de las operaciones RBAC, coexistencia
con ACC declarada en ADR-GOB-008. **1 CRITICO + 5 ALTOS + 2 MEDIOS +
2 BAJOS**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio (primaria)
 * - UC_PERM_01 Asignar Grupo a Usuario
   - ALTO
   - 2
   - ACC-004
   - ``Assignment``
 * - UC_PERM_02 Revocar Grupo a Usuario
   - ALTO
   - 2
   - ACC-008
   - ``Assignment``
 * - UC_PERM_03 Conceder Permiso Excepcional
   - MEDIO
   - 3
   - ACC-009
   - ``ExceptionalPermission``
 * - UC_PERM_04 Revocar Permiso Excepcional
   - MEDIO
   - 1
   - ACC-010
   - ``ExceptionalPermission``
 * - UC_PERM_05 Crear Grupo de Permisos
   - ALTO
   - 2
   - ACC-006
   - ``FunctionGroup``
 * - UC_PERM_06 Asignar Funciones a Grupo
   - ALTO
   - 3
   - ACC-007
   - ``FunctionGroup``, ``Function``
 * - UC_PERM_07 Verificar Permiso de Usuario
   - CRITICO
   - 4
   - ACC-003
   - ``Assignment``, ``ExceptionalPermission``
 * - UC_PERM_08 Generar Menu Dinamico
   - ALTO
   - 3
   - CNST-032 SQL ``get_user_menu``
   - ``Assignment``, ``Function``
 * - UC_PERM_09 Auditar Acceso
   - BAJO
   - 1
   - AUD-001
   - ``AuditEvent``
 * - UC_PERM_10 Consultar Auditoria de Permisos
   - BAJO
   - 2
   - AUD-002
   - ``AuditEvent``

2.5 Cluster RPT (15 UCs)
------------------------

Responsabilidad: visualizacion de metricas del call center,
exportacion, programacion, vistas guardadas, instancias por scope.
**1 CRITICO + 3 ALTOS + 9 MEDIOS + 2 BAJOS**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio (primaria)
 * - UC_RPT_01 Ver Dashboard
   - CRITICO
   - 5
   - RPT-001 ``view_reports``
   - ``Report`` (scope=GENERAL)
 * - UC_RPT_02 Ver Metricas Tiempo Real
   - ALTO
   - 4
   - RPT-002 ``view_dashboard``
   - ``Report``
 * - UC_RPT_03 Ver Reportes Historicos
   - ALTO
   - 4
   - RPT-003 ``filter_reports``
   - ``Report``
 * - UC_RPT_04 Exportar Reporte (Larman)
   - ALTO
   - 6
   - RPT-004/005/006
   - ``ExportJob``
 * - UC_RPT_07 Programar Reporte
   - MEDIO
   - 3
   - RPT-009 ``schedule_report`` (restaurada)
   - ``ScheduledReport``
 * - UC_RPT_08 Ver Reportes Programados
   - MEDIO
   - 2
   - RPT-001 (filtrada)
   - ``ScheduledReport``
 * - UC_RPT_09 Configurar Filtros
   - BAJO
   - 2
   - RPT-003 (preset)
   - ``Report``
 * - UC_RPT_10 Guardar Vista
   - BAJO
   - 2
   - RPT-010 ``save_view``
   - ``SavedView``
 * - UC_RPT_11 Compartir Reporte
   - MEDIO
   - 3
   - RPT-010 ``share_report``
   - ``Report``, ``InternalMailbox``
 * - UC_RPT_12 Ver Reporte Agentes
   - MEDIO
   - 2
   - RPT-001 (variante AGENTS)
   - ``Report``, ``Call``
 * - UC_RPT_13 Ver Reporte Colas
   - MEDIO
   - 2
   - RPT-001 (variante QUEUES)
   - ``Report``, ``Call``
 * - UC_RPT_14 Ver Reporte Campanas
   - MEDIO
   - 2
   - RPT-001 (variante CAMPAIGNS)
   - ``Report``, ``Campaign``
 * - UC_RPT_15 Reporte Transferencias Centro
   - MEDIO
   - 3
   - RPT-001 (instancia D-10)
   - ``Report`` (scope=TRANSFERENCES)
 * - UC_RPT_16 Reporte Menus IVR
   - MEDIO
   - 3
   - RPT-001 (instancia D-10)
   - ``Report`` (scope=IVR_MENUS)
 * - UC_RPT_17 Reporte Clientes Unicos
   - MEDIO
   - 3
   - RPT-001 (instancia D-10)
   - ``Report`` (scope=UNIQUE_CLIENTS)

2.6 Cluster ALR (5 UCs)
-----------------------

Responsabilidad: closed-loop alerting. **0 CRITICOS + 3 ALTOS +
2 MEDIOS**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_ALR_01 Configurar Umbrales
   - ALTO
   - 3
   - ALR-002 ``configure_thresholds``
   - ``Threshold``, ``Metric``
 * - UC_ALR_02 Ver Alertas Activas
   - ALTO
   - 2
   - ALR-001 ``view_alerts``
   - ``Alert``
 * - UC_ALR_03 Reconocer Alerta
   - ALTO
   - 2
   - ALR-007 ``acknowledge_alert`` (NUEVA Z.2 D-02)
   - ``Alert``, ``AuditEvent``
 * - UC_ALR_04 Ver Historial Alertas
   - MEDIO
   - 2
   - ALR-006
   - ``Alert``
 * - UC_ALR_05 Gestionar Suscripciones (Larman)
   - MEDIO
   - 4
   - ALR-008/009/010 (split Z.2 D-03)
   - ``Subscription``, ``Alert``, ``InternalMailbox``

2.7 Cluster PIP (4 UCs)
-----------------------

Responsabilidad: supervision del pipeline ETL. **1 CRITICO + 3 ALTOS**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_PIP_01 Supervisar ETL
   - CRITICO
   - 4
   - PIP-001 ``view_etl_executions``
   - ``ETLExecution``
 * - UC_PIP_02 Consultar Errores ETL
   - ALTO
   - 2
   - PIP-002 ``view_etl_errors``
   - ``ETLError``, ``ETLExecution``
 * - UC_PIP_03 Consultar Disponibilidad
   - ALTO
   - 2
   - PIP-003 ``check_availability``
   - ``ETLExecution``
 * - UC_PIP_04 Solicitar Reintento
   - ALTO
   - 3
   - PIP-004 ``request_retry``
   - ``ETLExecution``, ``AuditEvent``

2.8 Cluster AUD (4 UCs)
-----------------------

Responsabilidad: auditoria inmutable (CNST-025). **1 CRITICO +
2 ALTOS + 1 MEDIO**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_AUD_01 Consultar Auditoria
   - CRITICO
   - 3
   - AUD-001 ``view_audit_log``
   - ``AuditEvent``
 * - UC_AUD_02 Buscar Auditoria
   - ALTO
   - 3
   - AUD-002 ``search_audit_log``
   - ``AuditEvent``
 * - UC_AUD_03 Exportar Auditoria
   - ALTO
   - 3
   - AUD-003 ``export_audit_log``
   - ``AuditEvent``, ``ExportJob``
 * - UC_AUD_04 Generar Reporte Compliance
   - MEDIO
   - 5
   - AUD-004 ``generate_compliance_report``
   - ``AuditEvent``

2.9 Cluster LOG (7 UCs)
-----------------------

Responsabilidad: logs aplicativos / ETL / infraestructura mas
SystemHealth (snapshot) y TechnicalMetric (agregacion, no log per
Z.2 D-05). **0 CRITICOS + 2 ALTOS + 2 MEDIOS + 3 BAJOS**.

.. list-table::
 :widths: 22 12 10 26 30
 :header-rows: 1

 * - UC
   - Criticidad
   - Dias
   - Funcion RBAC
   - Clase Dominio
 * - UC_LOG_01 Consultar Logs Sistema
   - ALTO
   - 2
   - LOG-001 ``view_application_logs`` (rename Z.2 D-05)
   - ``ApplicationLog``
 * - UC_LOG_02 Consultar Logs ETL
   - ALTO
   - 2
   - LOG-004 ``view_etl_logs`` (NUEVA)
   - ``ETLLog``, ``ETLExecution``
 * - UC_LOG_03 Buscar Logs
   - BAJO
   - 3
   - LOG-003 ``search_logs`` (NUEVA)
   - ``ApplicationLog``
 * - UC_LOG_04 Exportar Logs
   - MEDIO
   - 3
   - LOG-002 ``export_logs``
   - ``ApplicationLog``, ``ExportJob``
 * - UC_LOG_05 Ver Logs Infraestructura
   - MEDIO
   - 2
   - LOG-005 ``view_infrastructure_logs`` (NUEVA)
   - ``InfrastructureLog``
 * - UC_LOG_06 Ver Estado Sistema
   - BAJO
   - 2
   - LOG-006 ``view_system_health`` (NUEVA)
   - ``SystemHealth``
 * - UC_LOG_07 Ver Metricas Tecnicas
   - BAJO
   - 3
   - LOG-007 ``view_technical_metrics`` (NUEVA)
   - ``TechnicalMetric``

2.10 Verificacion cuantitativa
------------------------------

.. list-table::
 :widths: 14 10 10 10 10 12
 :header-rows: 1

 * - Cluster
   - Criticos
   - Altos
   - Medios
   - Bajos
   - Total
 * - AUTH
   - 2
   - 2
   - 1
   - 0
   - 5
 * - USR
   - 1
   - 3
   - 0
   - 0
   - 4
 * - ACC
   - 1
   - 4
   - 1
   - 1
   - 7
 * - PERM
   - 1
   - 5
   - 2
   - 2
   - 10
 * - RPT
   - 1
   - 3
   - 9
   - 2
   - 15
 * - ALR
   - 0
   - 3
   - 2
   - 0
   - 5
 * - PIP
   - 1
   - 3
   - 0
   - 0
   - 4
 * - AUD
   - 1
   - 2
   - 1
   - 0
   - 4
 * - LOG
   - 0
   - 2
   - 2
   - 3
   - 7
 * - **Total**
   - **8**
   - **27**
   - **18**
   - **8**
   - **61**

----

PARTE 3 — Matriz compacta UC → INCLUYE → EXTIENDE → REQUIERE
============================================================

Vista tecnica una linea por UC. Las dependencias transversales (T-01,
T-02, T-03) se omiten aqui — viven en Parte 4.

3.1 UCs raiz (REQUIERE = ninguno)
---------------------------------

18 UCs no requieren otro UC explicito (solo transversales):

::

   UC_AUTH_01, UC_USR_02, UC_ACC_03, UC_ACC_05,
   UC_PERM_05, UC_PERM_07, UC_RPT_01 (con prereq datos),
   UC_ALR_01, UC_PIP_01, UC_AUD_01,
   UC_LOG_01, UC_LOG_05, UC_LOG_06, UC_LOG_07
   + 4 menores

3.2 UCs con mayor in-degree
---------------------------

::

   UC_AUTH_01      universal (T-01, todos los UCs no publicos)
   UC_PERM_07      universal (T-02)
   UC_RPT_01       14 invocaciones (todo el cluster RPT)
   UC_PIP_01       4 invocaciones (PIP_02..04, LOG_02)
   UC_AUD_01       4 invocaciones (AUD_02..04, ACC_09, PERM_09)
   UC_USR_02       3 invocaciones (USR_03, USR_04, ACC_04)
   UC_AUTH_05      3 invocaciones (USR_03, USR_04, AUTH_02)

3.3 Cadenas de dependencia por cluster
--------------------------------------

**Cluster AUTH (intra)**::

   UC_AUTH_01 → (raiz)
   UC_AUTH_02 → UC_AUTH_01
   UC_AUTH_03 → UC_USR_03 (cross USR)
   UC_AUTH_04 → UC_AUTH_01
   UC_AUTH_05 → UC_AUTH_01, UC_AUTH_02

**Cluster USR (intra + cross)**::

   UC_USR_01 → UC_ACC_01, UC_ACC_04
   UC_USR_02 → (raiz)
   UC_USR_03 → UC_USR_02, UC_AUTH_05
   UC_USR_04 → UC_USR_02, UC_AUTH_05

**Cluster ACC (intra + cross AUD)**::

   UC_ACC_01 → UC_ACC_05
   UC_ACC_02 → UC_ACC_01
   UC_ACC_03 → (raiz)
   UC_ACC_04 → UC_USR_02, UC_ACC_03
   UC_ACC_05 → (raiz)
   UC_ACC_08 → UC_ACC_03
   UC_ACC_09 → UC_AUD_01

**Cluster PERM (vista tecnica del RBAC)**::

   UC_PERM_01 → UC_PERM_05
   UC_PERM_02 → UC_PERM_01
   UC_PERM_03 → UC_PERM_04 (caso inverso)
   UC_PERM_04 → UC_PERM_03
   UC_PERM_05 → (raiz)
   UC_PERM_06 → UC_PERM_05, UC_ACC_05
   UC_PERM_07 → (raiz, requerido por TODO UC operativo)
   UC_PERM_08 → UC_PERM_07
   UC_PERM_09 → UC_AUD_01
   UC_PERM_10 → UC_AUD_02

**Cluster RPT (15 UCs, hub: RPT_01 + cross PIP)**::

   UC_RPT_01 → UC_PIP_01 (datos analiticos)
   UC_RPT_02 → UC_RPT_01, UC_ALR_01, UC_ALR_02
   UC_RPT_03 → UC_RPT_01
   UC_RPT_04 → UC_RPT_01
   UC_RPT_07 → UC_RPT_01, UC_RPT_04
   UC_RPT_08 → UC_RPT_07
   UC_RPT_09 → UC_RPT_03, UC_RPT_10
   UC_RPT_10 → UC_RPT_03, UC_RPT_09
   UC_RPT_11 → UC_RPT_01
   UC_RPT_12 → UC_RPT_01
   UC_RPT_13 → UC_RPT_01
   UC_RPT_14 → UC_RPT_01
   UC_RPT_15 → UC_RPT_03, UC_RPT_04
   UC_RPT_16 → UC_RPT_03, UC_RPT_04
   UC_RPT_17 → UC_RPT_03, UC_RPT_04

**Cluster ALR (closed-loop)**::

   UC_ALR_01 → (raiz)
   UC_ALR_02 → UC_ALR_01
   UC_ALR_03 → UC_ALR_02
   UC_ALR_04 → UC_ALR_02
   UC_ALR_05 → UC_ALR_01, UC_ALR_02

**Cluster PIP (cluster cerrado + 1 cross LOG)**::

   UC_PIP_01 → (raiz, prereq de RPT)
   UC_PIP_02 → UC_PIP_01
   UC_PIP_03 → UC_PIP_01
   UC_PIP_04 → UC_PIP_01, UC_PIP_02

**Cluster AUD (consumidor universal de AuditEvent)**::

   UC_AUD_01 → (raiz, hub de auditoria)
   UC_AUD_02 → UC_AUD_01
   UC_AUD_03 → UC_AUD_01 o UC_AUD_02
   UC_AUD_04 → UC_AUD_01, UC_AUD_03

**Cluster LOG (con cross PIP)**::

   UC_LOG_01 → (raiz)
   UC_LOG_02 → UC_PIP_01 (cross-cluster)
   UC_LOG_03 → UC_LOG_01
   UC_LOG_04 → UC_LOG_01 o UC_LOG_03
   UC_LOG_05 → (raiz)
   UC_LOG_06 → (raiz)
   UC_LOG_07 → (raiz)

----

PARTE 4 — Dependencias transversales en detalle
===============================================

4.1 Dependencia T-01 — Sesion activa
------------------------------------

**Definicion**: cualquier UC operativo (no publico) requiere una
``Session.state = ACTIVE`` valida.

**Cobertura**: 59 / 61. Excepciones: UC_AUTH_01 (crea la Session) y
UC_AUTH_03 (paso de validacion de token de recuperacion).

**Mecanismo**: middleware HTTP que extrae JWT del header
``Authorization``, valida firma + expiracion (CNST-002), resuelve
Session, verifica ``state = ACTIVE``, aplica CNST-003 (sesion unica).
Falla → 401.

**Riesgo**: SPOF del producto. Mitigado con replica BD, cache local
TTL CNST-002, health check en UC_LOG_06.

4.2 Dependencia T-02 — Verificar permiso
----------------------------------------

**Definicion**: cualquier UC operativo invoca implicitamente
UC_PERM_07 con el par ``(user_id, function_id)`` antes de ejecutar
su flujo.

**Cobertura**: 59 / 61.

**Orden de precedencia interno** (UC_PERM_07):

1. Revocaciones excepcionales (state ACTIVE, fecha vigente) →
   DENEGADO.
2. Concesiones excepcionales (CNST-031) → AUTORIZADO.
3. Asignaciones por FunctionGroup → AUTORIZADO.
4. Asignaciones directas → AUTORIZADO.
5. Sin match → DENEGADO.

**Mecanismo**: decorador ``@require_function('FUNC-NNN')`` sobre cada
controller. Cache LRU TTL ~60s. Invalidacion al ejecutar UC_ACC_01,
_02, UC_PERM_01..04, _06.

**Performance target**: < 50 ms (per cabecera de UC_PERM_07).

**Riesgo**: politica IACT es **fail-closed estricto** (CNST-030). Si
T-02 falla deniega — peor que T-01 pero mejor que bypass total RBAC.

4.3 Dependencia T-03 — Emitir AuditEvent
----------------------------------------

**Definicion**: toda operacion de **escritura** en cualquier cluster
emite uno o mas ``AuditEvent`` inmutables (CNST-025).

**Cobertura**: 35 / 61 UCs (los de escritura). Los 26 UCs restantes
son lectura pura.

**Mecanismo**: middleware "audit emitter" como observer de los
metodos de servicio de escritura. Cada metodo declara ``EventType``
via decorador ``@audits('PERMISSION_GRANT')``. Insercion **post-commit**
en transaccion separada (la falla del audit no aborta la operacion
pero genera alarma).

**Riesgo**: si T-03 falla silenciosamente, perdida de compliance.
Mitigado con health check del servicio audit en UC_LOG_06, alerta
automatica si rate baja debajo de baseline (UC_ALR_03), reconciliacion
periodica via UC_AUD_04.

----

PARTE 5 — Matriz de criticidad y duracion
=========================================

5.1 Metodo de estimacion
------------------------

.. list-table::
 :widths: 20 20 60
 :header-rows: 1

 * - Complejidad
   - Dias tipicos
   - Criterio
 * - BAJA
   - 1-2
   - Un solo flujo principal, sin alternos significativos, ≤3
     constraints, ≤2 clases tocadas.
 * - MEDIA
   - 3-4
   - 1-2 flujos alternos, 3-5 constraints, hasta 4 clases, validacion
     moderada.
 * - ALTA
   - 5-7
   - Flujos asincronos, transacciones distribuidas (Saga),
     multiples clases, integracion externa, performance critico.

Asumido: 1 desarrollador full-time (~6h productivas/dia). Incluye
analisis + implementacion + tests + code review + documentacion.

5.2 Totales por criticidad
--------------------------

.. list-table::
 :widths: 30 15 25 15
 :header-rows: 1

 * - Criticidad
   - UCs
   - Person-days
   - Porcentaje
 * - CRITICOS
   - 8
   - 29
   - 17%
 * - ALTOS
   - 27
   - 75
   - 44%
 * - MEDIOS
   - 18
   - 49
   - 29%
 * - BAJOS
   - 8
   - 17
   - 10%
 * - **Total UCs**
   - **61**
   - **170**
   - **100%**

5.3 Overhead del proyecto
-------------------------

::

   Modelo de datos (migraciones para 25 clases)        15 dias
   Middleware Auth + RBAC (T-01 + T-02)                10 dias
   Middleware Audit Emitter (T-03)                      5 dias
   Diseno de UI / componentes compartidos              20 dias
   ETL pipeline (background)                           15 dias
   Setup infraestructura (ADR-DEVOPS-001)               8 dias
   Tests E2E + ambientes                               10 dias
   Documentacion + ADRs                                 5 dias
   ----------------------------------------------------------
   Subtotal overhead                                   88 dias

   Total proyecto = 170 + 88 = 258 person-days

   Con 1 dev:                       ~52 sem  (~12 meses)
   Con 2 devs:                      ~30 sem  (~7 meses)
   Con 4 devs:                      ~15 sem  (~3.5 meses)

5.4 Timeline propuesto (15 sprints, 2 devs)
-------------------------------------------

::

   Sprint 1-2     Setup + Auth/RBAC core            4 sem
   Sprint 3       Pipeline + Dashboard              2 sem
   Sprint 4-5     Admin RBAC                        4 sem
   Sprint 6       Auditoria                         2 sem
   Sprint 7-8     RBAC avanzado / PERM              4 sem
   Sprint 9-11    Reportes (cluster RPT completo)   6 sem
   Sprint 12      Alertas                           2 sem
   Sprint 13      Pipeline avanzado                 2 sem
   Sprint 14      Logs + monitoring                 2 sem
   Sprint 15      Compliance avanzado               2 sem
   ----------------------------------------------------
   Total          15 sprints                        30 sem

5.5 Reglas de orden topologico
------------------------------

1. UCs con REQUIERE = ninguno se implementan primero.
2. **UC_PERM_07** antes que cualquier UC con T-02.
3. **UC_AUTH_01** antes que cualquier UC con T-01.
4. **UC_PIP_01** antes que cualquier UC del cluster RPT que dependa
   de datos.
5. **UC_RPT_01** antes que UC_RPT_02..17.
6. **UC_AUD_01** antes que UC_AUD_02, _03, _04 y UC_PERM_09, _10,
   UC_ACC_09.

----

PARTE 6 — Patrones de diseno aplicados a IACT
=============================================

6.1 Patrones GoF/POSA aplicados
-------------------------------

.. list-table::
 :widths: 22 12 66
 :header-rows: 1

 * - Patron
   - UCs
   - Funcion en IACT
 * - **Command**
   - 17
   - Audit trail — toda escritura es Command serializado como
     AuditEvent.
 * - **Facade**
   - 16
   - Vista unificada para consultas que agregan datos de multiples
     clases.
 * - **Strategy**
   - 14
   - Algoritmos intercambiables — formato export, search engines,
     cache backends, scope filters.
 * - **Observer**
   - 14
   - Eventos cross-cutting — invalidacion de caches, propagacion de
     cambios, streaming.
 * - **Specification**
   - 14
   - Encapsulacion de criterios de busqueda compuestos.
 * - **State**
   - 7
   - Toda clase con state enum y BR-009 v2.0.0.
 * - **Visitor**
   - 6
   - Operaciones agregadas sobre estructuras complejas (resolucion
     RBAC, metricas).
 * - **Decorator**
   - 4
   - Cache, rate limiting, caducidad.
 * - **Composite**
   - 4
   - Estructuras jerarquicas (menus, dashboards, services_status).
 * - **Memento**
   - 3
   - Snapshots persistentes (SavedView, SystemHealth).
 * - **Builder**
   - 4
   - Construccion paso a paso (username generator, PDF, presets).
 * - **Factory**
   - 2
   - Construccion centralizada de entidades complejas.
 * - **Template Method**
   - 2
   - Workflows con pasos fijos y partes variables.
 * - **Chain of Responsibility**
   - 2
   - Validaciones / precedencia de permisos.
 * - **Saga**
   - 3
   - Transacciones distribuidas async (export jobs).

6.2 Patrones cross-cutting IACT-especificos
-------------------------------------------

Ocho patrones propios del proyecto que emergen del analisis:

**Patron P-01 — RBAC Decorator** (59 UCs):
Decorador ``@require_function('FUNC-NNN')`` sobre cada controller.
Materializa T-02 a nivel de codigo. Reduce duplicacion.

**Patron P-02 — Audit Emitter** (35 UCs):
Middleware observer que se suscribe a metodos de escritura. Cada
metodo declara ``EventType`` via decorador. Insercion post-commit en
transaccion separada. Materializa T-03.

**Patron P-03 — BR-009 Soft Delete** (~35 clases):
Cada entidad con ciclo de vida expone atributo ``state`` con enum
especifico y operacion ``deactivate()`` o ``disable()``. Cero clases
con ``delete()``. Materializa BR-009 v2.0.0 alcance global.

**Patron P-04 — Filtered Variant (Camino C)** (5 UCs):
Una unica funcion RBAC (``view_reports``) mas un atributo ``scope``
en ``Report``. Las variantes (RPT_08, _09, _12, _13, _14) no son UCs
autonomos sino instancias filtradas. Materializa Z.2 D-10.

**Patron P-05 — ACC-PERM Coexistence** (10 UCs):
Cada UC_PERM_NN cita la funcion RBAC backing del cluster ACC (1:1
mapping). Operan sobre las mismas clases del dominio (Assignment,
FunctionGroup, ExceptionalPermission). Materializa ADR-GOB-008.

**Patron P-06 — Larman Consolidation** (2 UCs):
Un solo UC (UC_RPT_04 "Exportar Reporte") con flujos alternativos
por formato; tres funciones RBAC distintas (RPT-004/005/006) para
SoD. Capa UC y capa RBAC son ortogonales. Mismo patron en
UC_ALR_05.

**Patron P-07 — Async Throttled Export** (3 UCs):
Cola asincrona abstracta (CNST-019 v3.0.0) + throttling abstracto
por recursos (CNST-020 v3.0.0) + notificacion via InternalMailbox.
UC_RPT_04, UC_AUD_03, UC_LOG_04.

**Patron P-08 — Internal Mailbox Delivery** (6 UCs):
Clase ``InternalMailbox`` 1:1 con ``User``. Toda notificacion
(export listo, recovery password, alerta suscrita, reporte
compartido) entregada via ``InternalMailbox.deliver_message()``.
Materializa CNST-001.

6.3 Componentes infra reutilizables (Stage 7 DESIGN futuro)
-----------------------------------------------------------

Cinco componentes capturan ~80% de la infraestructura cross-cutting:

1. **Decorador** ``@require_function`` (~30 LOC, reutilizado por 59
   UCs).
2. **Middleware** ``AuditEmitter`` (~50 LOC, reutilizado por 35 UCs).
3. **Mixin** ``LifecycleEntity`` con ``state`` + ``deactivate()``
   (~35 clases).
4. **Servicio** ``ExportJobScheduler`` (CNST-019/020 v3.0.0,
   reutilizado por UC_RPT_04, UC_AUD_03, UC_LOG_04).
5. **Servicio** ``InternalMailbox`` (CNST-001, reutilizado por 6 UCs).

----

Conclusion — metricas y proximos pasos
======================================

C.1 Metricas globales
---------------------

::

   Casos de uso vigentes:           61 (verificado)
   Clusters funcionales:            9
   Clases canonicas de dominio:     25
   Bounded contexts:                7
   Funciones RBAC:                  61 (v5.4.0)

   Distribucion criticidad:         8 / 27 / 18 / 8

   Aristas REQUIERE explicitas:     ~70
   Aristas T-01:                    59
   Aristas T-02:                    59
   Aristas T-03:                    35
   UCs raiz:                        18
   Camino critico minimo:            4 UCs

   Person-days UCs:                 170
   Person-days overhead:             88
   Person-days total:               258
   Sprints propuestos:               15

   Patrones GoF/POSA aplicados:     15 distintos
   Patrones cross-cutting IACT:      8
   Componentes infra reutilizables:  5

C.2 Hallazgos consolidados
--------------------------

.. list-table::
 :widths: 8 15 77
 :header-rows: 1

 * - ID
   - Tipo
   - Descripcion
 * - H-M01
   - OBSERVABLE
   - Los 8 CRITICOS son solo 13% del catalogo pero concentran las 4
     rutas criticas. Su fallo deja el sistema sin valor.
 * - H-M02
   - OBSERVABLE
   - 59/61 UCs requieren T-01 + T-02. El middleware Auth + RBAC es
     el componente con mayor leverage del proyecto.
 * - H-M03
   - OBSERVABLE
   - UC_PERM_07 es el cuello de botella mas critico. Performance
     <50ms requerido; sin cache LRU + invalidacion correcta el
     sistema no escala.
 * - H-M04
   - OBSERVABLE
   - UC_PIP_01 es prerequisito background de todos los UCs RPT y
     ALR. Si el ETL falla, dashboard muestra datos stale. Requiere
     health check + alerta automatica.
 * - H-M05
   - INFERRED
   - Cluster RPT (15 UCs, 41 person-days) es el mas voluminoso. 14
     de 15 UCs RPT extienden UC_RPT_01 — paralelizable tras
     UC_RPT_01.
 * - H-M06
   - OBSERVABLE
   - Los 8 patterns cross-cutting IACT capturan ~80% de la
     infraestructura del sistema. Implementarlos bien es decisivo.
 * - H-M07
   - OBSERVABLE
   - Solo 18 UCs son raices. Implementacion debe respetar orden
     topologico per Parte 5 § 5.5.
 * - H-M08
   - INFERRED
   - Cluster AUD tiene UC_AUD_01 como hub: extendido por UC_AUD_02,
     _03, _04 + UC_PERM_09, _10, UC_ACC_09. Hub mas concentrado del
     sistema.

C.3 Proximos pasos
------------------

**Inmediato:**

1. Cierre del WP analitico
   ``2026-05-01-05-17-20-uc-dependency-matrix-iact``.
2. Promocion del documento a ``source/arquitectura-tecnica/`` (este
   archivo).

**Corto plazo:**

3. Stage 7 DESIGN para implementacion: usar el orden topologico de
   Parte 5 § 5.5 + los 5 componentes cross-cutting de § 6.3 como
   guia de diseno tecnico (Django models / services / middleware).
4. Materializar los 8 CRITICOS primero (sprints 1-3).
5. Implementar el middleware T-02 / T-03 junto con UC_PERM_07.

**Mediano plazo:**

6. Validacion con stakeholders reales (cuando esten disponibles).
7. Refinamiento de estimaciones tras los primeros sprints.
8. Visualizaciones PlantUML adicionales del grafo si requeridas.

**Largo plazo:**

9. WP de implementacion real: ADRs de implementacion (Django apps,
   modelos, vistas, tests) usando ADR-DEVOPS-001.
10. Operacion y monitoreo: aplicar UCs LOG_05/06/07 como
    observabilidad del sistema en produccion.

C.4 Trazabilidad
----------------

Anclajes verificados:

- :doc:`/arquitectura-tecnica/modelo-dominio-iact` v1.0.0.
- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` v5.4.0.
- WP fundacional: ``2026-05-01-02-01-06-domain-model-canonization``
  (cerrado).
- WP de correcciones:
  ``2026-05-01-03-29-03-uc-corrections-against-canonical-model``
  (cerrado, 61/61 UCs).
- WP analitico:
  ``2026-05-01-05-17-20-uc-dependency-matrix-iact`` (cerrado, 6
  partes + conclusion).
- ADR-GOB-008 — coexistencia ACC ↔ PERM.
- BR-009 v2.0.0, BR-011 v2.0.0.
- CNST-001, _002, _003, _006/007/008, _015, _019 v3.0.0, _020
  v3.0.0, _024, _025, _030, _031, _032.
- Programa Z: Z.1.C, Z.2 (D-01..D-11), Z.2.A (5 categorias Cat 1..5).

C.5 Evolucion del documento
---------------------------

Este es el primer analisis canonico de dependencias del proyecto.
Versionado SemVer 2.0.0 a partir de v1.0.0:

- **MAJOR** cuando cambien las clases del modelo de dominio o el
  catalogo de UCs.
- **MINOR** cuando se agreguen UCs o se refinen criticidades.
- **PATCH** para correcciones documentales sin cambios estructurales.
