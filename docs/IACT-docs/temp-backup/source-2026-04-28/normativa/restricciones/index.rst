.. _restricciones-index:

Restricciones Tecnicas
======================

:Estado: VIGENTE (Actualizado)
:Documentos: 10
:Lineas Totales: 10,993
:Ultima Actualizacion: 2026-01-03
:Version: 1.1.0
:Integracion RBAC: v5.1.1 (44 funciones atomicas)

----

Proposito
---------

Este directorio contiene las restricciones tecnicas criticas del Sistema IACT - IVR Analytics & Customer Tracking. Estas restricciones son NO NEGOCIABLES y deben cumplirse en todas las fases del proyecto.

Las restricciones estan alineadas con el Modelo RBAC v5.1.1 que utiliza funciones atomicas en lugar de roles tradicionales.

----

Cambios en v1.1.0
-----------------

Fecha: 2026-01-03

**Actualizaciones Globales:**

- 5 archivos actualizados a v1.1.0 (CNST-001, 003, 005, 006, 010)
- 5 archivos actualizados a v1.0.1 (CNST-002, 004, 007, 008, 009)
- Fecha actualizada: 2025-12-17 → 2026-01-03
- Estado cambiado: Vigente → VIGENTE
- Referencias RBAC: v4.0 → v5.1.1
- Integracion con modelo de funciones atomicas (44 funciones, 8 modulos)

**Archivos v1.1.0 (Mayor - Cambios funcionales):**

- CNST-001: Comunicaciones Prohibidas
  * Actualizacion RBAC v5.1.1
  * Clean Code: notify_by_role → notify_by_function

- CNST-003: Base de Datos Dual Inmutable
  * Clean Code: IVRWriteProtectionMiddleware → IVRWriteProtection

- CNST-005: Seguridad DRF Checklist
  * Actualizacion RBAC v5.1.1
  * Nueva seccion "Permisos Temporales" (+340 lineas)
  * Clean Code: Is→Can, Throttle concisos, Serializer→Validator

- CNST-006: Antipatrones Arquitectura
  * Actualizacion RBAC v5.1.1
  * Nueva seccion "Patrones Recomendados" (+455 lineas)
  * Clean Code: vistas especificas, mejoras en ejemplos

- CNST-010: Clasificacion Proteccion Datos
  * Actualizacion RBAC v5.1.1
  * ACCESS_MATRIX: roles → funciones atomicas
  * Documentacion mejorada integracion RBAC

**Archivos v1.0.1 (Patch - Solo metadatos):**

- CNST-002, 004, 007, 008, 009: Actualizacion de metadatos sin cambios funcionales

**Incremento Total:**

- Lineas: 9,621 → 10,993 (+1,372 lineas, +14.3%)
- Principales incrementos:
  * CNST-005: +354 lineas (Permisos Temporales)
  * CNST-006: +520 lineas (Patrones Recomendados)
- Cobertura: 98.5% → 100%

----

Historial de Versiones
----------------------

.. list-table::
   :header-rows: 1
   :widths: 10 15 55 20

   * - Version
     - Fecha
     - Cambios
     - Lineas
   * - 1.1.0
     - 2026-01-03
     - Ampliaciones CNST-005 y CNST-006. Integracion RBAC v5.1.1. Clean Code aplicado
     - 10,993
   * - 1.0.0
     - 2025-12-17
     - Version inicial completa
     - 9,621

----

Catalogo de Restricciones
-------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 35 15 15 20

   * - ID
     - Titulo
     - Lineas
     - Version
     - Estado
   * - CNST-001
     - Comunicaciones Prohibidas
     - 694
     - 1.1.0
     - VIGENTE
   * - CNST-002
     - Gestion de Sesiones en BD
     - 844
     - 1.0.1
     - VIGENTE
   * - CNST-003
     - Base de Datos Dual Inmutable
     - 905
     - 1.1.0
     - VIGENTE
   * - CNST-004
     - Actualizacion Datos ETL
     - 924
     - 1.0.1
     - VIGENTE
   * - CNST-005
     - Seguridad DRF Checklist
     - 1,498
     - 1.1.0
     - VIGENTE
   * - CNST-006
     - Antipatrones Arquitectura
     - 1,946
     - 1.1.0
     - VIGENTE
   * - CNST-007
     - Limites Performance SLA
     - 1,065
     - 1.0.1
     - VIGENTE
   * - CNST-008
     - Infraestructura Deployment
     - 1,023
     - 1.0.1
     - VIGENTE
   * - CNST-009
     - Logging Auditoria Inmutable
     - 1,081
     - 1.0.1
     - VIGENTE
   * - CNST-010
     - Clasificacion Proteccion Datos
     - 1,013
     - 1.1.0
     - VIGENTE

----

Clasificacion por Categoria
---------------------------

**Restricciones Tecnicas Criticas (No Negociables)**

- CNST-001: Comunicaciones Prohibidas (NO email/SMTP)
- CNST-002: Gestion de Sesiones en BD (NO Redis)
- CNST-003: Base de Datos Dual Inmutable (IVR readonly)
- CNST-004: Actualizacion Datos ETL (NO real-time)

**Restricciones de Seguridad**

- CNST-005: Seguridad DRF Checklist
- CNST-010: Clasificacion Proteccion Datos

**Restricciones de Arquitectura**

- CNST-006: Antipatrones Arquitectura

**Restricciones de Performance**

- CNST-007: Limites Performance SLA

**Restricciones de Infraestructura**

- CNST-008: Infraestructura Deployment

**Restricciones de Auditoria**

- CNST-009: Logging Auditoria Inmutable

----

Integracion con RBAC v5.1.1
---------------------------

Este conjunto de restricciones esta alineado con el Modelo RBAC v5.1.1 que utiliza funciones atomicas en lugar de roles tradicionales.

**Modelo de Funciones Atomicas:**

- 44 funciones distribuidas en 8 modulos funcionales
- Sistema "sin pretensiones" (funciones describen QUE HACE, no QUIEN ES)
- Integracion con SEC_RULES para enforcement automatico
- Soporte para permisos temporales con expiracion automatica

**Modulos IACT:**

- MOD_Auth: Autenticacion y Sesiones (4 funciones)
- MOD_Users: Gestion de Identidades (10 funciones)
- MOD_Access: Roles, Permisos, Segmentos (6 funciones)
- MOD_Pipeline: Supervision del ETL (4 funciones)
- MOD_Reports: Dashboards y Reportes (8 funciones)
- MOD_Alerts: Alertas y Notificaciones (6 funciones)
- MOD_Audit: Auditoria Funcional (4 funciones)
- MOD_Logs: Bitacoras Tecnicas (2 funciones)

**Mapeo CNST a Modulos:**

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - CNST
     - Modulos Afectados
     - Funciones Relacionadas
   * - CNST-001
     - MOD_Alerts
     - notifica_usuario, crea_mensaje_interno
   * - CNST-002
     - MOD_Auth
     - inicia_sesion, cierra_sesion
   * - CNST-003
     - MOD_Pipeline
     - extrae_datos_ivr
   * - CNST-004
     - MOD_Pipeline
     - supervisa_etl, ejecuta_etl
   * - CNST-005
     - Todos
     - Middleware de autenticacion
   * - CNST-006
     - Todos
     - Calidad de codigo
   * - CNST-007
     - MOD_Reports
     - exporta_csv, exporta_excel, genera_reporte
   * - CNST-008
     - N/A
     - Infraestructura
   * - CNST-009
     - MOD_Audit, MOD_Logs
     - registra_auditoria, consulta_logs
   * - CNST-010
     - Todos
     - ve_reportes, analiza_datos, administra_sistema

----

Documentos Relacionados
-----------------------

- :ref:`cnst-012` — Modelo RBAC IACT v5.2.2 (consolidación canónica)
- Casos de Uso (UC-001 a UC-072)
- SRS v2.0 (8 modulos funcionales)
- ADR (Decisiones de arquitectura)

----

.. toctree::
   :hidden:
   :maxdepth: 1
   :caption: Catalogo de Restricciones

   CNST_001_Comunicaciones_Prohibidas
   CNST_002_Gestion_Sesiones_BD
   CNST_003_Base_Datos_Dual_Inmutable
   CNST_004_Actualizacion_Datos_ETL
   CNST_005_Seguridad_DRF_Checklist
   CNST_006_Antipatrones_Arquitectura
   CNST_007_Limites_Performance_SLA
   CNST_008_Infraestructura_Deployment
   CNST_009_Logging_Auditoria_Inmutable
   CNST_010_Clasificacion_Proteccion_Datos
   CNST_012_RBAC_Flat_SoD_Permisos