# ESTRUCTURA COMPLETA - MODELO DOCUMENTAL IACT v2.0.2
## Proyecto IACT Dashboard Analytics

**Fecha:** 2025-12-22
**Version:** 2.0.2
**Estado:** FUENTE DE VERDAD OFICIAL

---

## CHANGELOG

### v2.0.2 (2025-12-22)
- CORRECCION: Modulos cambian de MOD_ a ARQ_MOD_ (documentos de DISENO, no RTM)
- CLARIFICACION: Separacion explicita entre Arquitectura del Sistema vs Arquitectura Documental
- ARQ_MOD_ ahora vive en arquitectura_tecnica/arquitectura/modulos/
- Los UC referencian ARQ_MOD_ en su metadata
- Eliminado TAX_002_Taxonomia_Modulos (innecesario, ARQ_MOD_ ya documenta)

### v2.0.1 (2025-12-22)
- Incorporacion de 8 Modulos Funcionales
- Expansion de 3 UC a 49 UC organizados por modulo

### v2.0.0 (2025-12-17)
- Version inicial con estructura 5 dominios

---

## PRINCIPIO FUNDAMENTAL

```
+------------------------------------------------------------------+
|                    SEPARACION DE CONCEPTOS                        |
+------------------------------------------------------------------+
|                                                                   |
|   ARQUITECTURA DEL SISTEMA          ARQUITECTURA DOCUMENTAL       |
|   (Software)                        (RTM/PMO)                     |
|                                                                   |
|   ARQ_MOD_001 AUTH                  CNST_001, CNST_002...         |
|   ARQ_MOD_002 USER_IDENTITY         BR_001, BR_002, BR_003        |
|   ARQ_MOD_003 RBAC_CORE             BReq_001, BReq_002...         |
|   ARQ_MOD_004 ETL_MONITORING        UC_001, UC_002...             |
|   ARQ_MOD_005 VIS_REPORTS           FR_001, FR_002...             |
|   ARQ_MOD_006 ALERTS                TST_001, TST_002...           |
|   ARQ_MOD_007 AUDIT                 RTM_Master                    |
|   ARQ_MOD_008 SYS_LOGS                                            |
|                                                                   |
|   = Servicios, APIs, Capas         = Documentos de trazabilidad   |
|   = Funcionalidades del sistema    = Artefactos PMO               |
|   = NO son artefactos RTM          = Bloques A/B/C                |
|                                                                   |
+------------------------------------------------------------------+
```

**Los ARQ_MOD_ documentan la arquitectura logica del sistema.**
**Los UC_, FR_, BR_ son artefactos de trazabilidad que REFERENCIAN los ARQ_MOD_.**

---

## 1. ARBOL COMPLETO CON ESTADO

```
IACT/
|
+-- base_cognitiva/                              # DOMINIO 1: Conocimiento Fundamental
|   |
|   +-- index.rst
|   |
|   +-- glosario/                                # [CONGELADO]
|   |   +-- index.rst
|   |   +-- GLO_001_Glosario_IACT.rst            # PENDIENTE
|   |
|   +-- taxonomias_y_metamodelos/                # [DESCONGELADO]
|   |   +-- index.rst
|   |   +-- taxonomias/
|   |   |   +-- TAX_001_Taxonomia_Roles.rst      # PENDIENTE
|   |   +-- metamodelos/
|   |       +-- META_001_Metamodelo_RBAC.rst     # PENDIENTE
|   |
|   +-- _metadata/                               # [PRIVADO - exclude_patterns]
|       +-- index.rst                            # COMPLETADO
|       +-- 00_indice.rst                        # COMPLETADO
|       +-- 01_sbvr_fundamentos.rst              # COMPLETADO
|       +-- 02_larman_metodologia.rst            # COMPLETADO
|       +-- 03_derivacion_br_uc.rst              # COMPLETADO
|       +-- 04_derivacion_uc_fr.rst              # COMPLETADO
|       +-- 05_trazabilidad_rtm.rst              # COMPLETADO
|
+-- requisitos/                                  # DOMINIO 2: Requerimientos
|   |
|   +-- index.rst
|   |
|   +-- reglas_negocio/                          # [CONGELADO] *** COMPLETADO ***
|   |   +-- index.rst
|   |   +-- BR_001_Inmutabilidad_Fuente.rst      # COMPLETADO
|   |   +-- BR_002_ETL_Nocturno.rst              # COMPLETADO
|   |   +-- BR_003_RBAC_Flat.rst                 # COMPLETADO
|   |
|   +-- requisitos_negocio/                      # [CONGELADO] *** COMPLETADO ***
|   |   +-- index.rst
|   |   +-- BReq_001_Visualizar_Metricas.rst     # COMPLETADO
|   |   +-- BReq_002_Exportar_Datos.rst          # COMPLETADO
|   |   +-- BReq_003_Gestionar_Accesos.rst       # COMPLETADO
|   |
|   +-- casos_uso/                               # [DESCONGELADO] *** 49 UC ***
|   |   +-- index.rst
|   |   |
|   |   +-- auth/                                # Ref: ARQ_MOD_001 (5 UC)
|   |   |   +-- UC_001_Iniciar_Sesion.rst            # PENDIENTE
|   |   |   +-- UC_002_Cerrar_Sesion.rst             # PENDIENTE
|   |   |   +-- UC_003_Recuperar_Contrasena.rst      # PENDIENTE
|   |   |   +-- UC_004_Cambiar_Contrasena.rst        # PENDIENTE
|   |   |   +-- UC_005_Gestionar_Sesiones_Activas.rst # PENDIENTE
|   |   |
|   |   +-- user_identity/                       # Ref: ARQ_MOD_002 (5 UC)
|   |   |   +-- UC_006_Crear_Cuenta_Usuario.rst      # PENDIENTE
|   |   |   +-- UC_007_Actualizar_Datos_Usuario.rst  # PENDIENTE
|   |   |   +-- UC_008_Baja_Logica_Usuario.rst       # PENDIENTE
|   |   |   +-- UC_009_Gestionar_Preguntas_Seguridad.rst # PENDIENTE
|   |   |   +-- UC_010_Consultar_Perfil_Usuario.rst  # PENDIENTE
|   |   |
|   |   +-- rbac_core/                           # Ref: ARQ_MOD_003 (7 UC)
|   |   |   +-- UC_041_Administrar_Catalogo_Roles.rst    # PENDIENTE
|   |   |   +-- UC_042_Calcular_Permisos_Efectivos.rst   # PENDIENTE
|   |   |   +-- UC_043_Asignar_Retirar_Roles.rst         # PENDIENTE
|   |   |   +-- UC_044_Configurar_Segmentos_Datos.rst    # PENDIENTE
|   |   |   +-- UC_045_Asignar_Permisos_Directos.rst     # PENDIENTE
|   |   |   +-- UC_046_Simular_Acceso_Usuario.rst        # PENDIENTE
|   |   |   +-- UC_047_Consultar_Matriz_Roles.rst        # PENDIENTE
|   |   |
|   |   +-- etl_monitoring/                      # Ref: ARQ_MOD_004 (5 UC)
|   |   |   +-- UC_051_Consultar_Ejecuciones_ETL.rst     # PENDIENTE
|   |   |   +-- UC_052_Ver_Detalle_Ejecucion_ETL.rst     # PENDIENTE
|   |   |   +-- UC_053_Consultar_Disponibilidad_Datos.rst # PENDIENTE
|   |   |   +-- UC_054_Consultar_Incidencias_Calidad.rst # PENDIENTE
|   |   |   +-- UC_055_Reintentar_Procesamiento.rst      # PENDIENTE
|   |   |
|   |   +-- vis_reports/                         # Ref: ARQ_MOD_005 (14 UC)
|   |   |   +-- UC_017_Consultar_Reporte_Trimestral.rst  # PENDIENTE
|   |   |   +-- UC_018_Consultar_Reporte_Errores.rst     # PENDIENTE
|   |   |   +-- UC_019_Consultar_Reporte_Transferencias.rst # PENDIENTE
|   |   |   +-- UC_020_Aplicar_Filtros_Fecha.rst         # PENDIENTE
|   |   |   +-- UC_021_Aplicar_Filtros_Negocio.rst       # PENDIENTE
|   |   |   +-- UC_022_Exportar_Reporte_CSV.rst          # PENDIENTE
|   |   |   +-- UC_023_Exportar_Reporte_Excel.rst        # PENDIENTE
|   |   |   +-- UC_024_Exportar_Reporte_PDF.rst          # PENDIENTE
|   |   |   +-- UC_025_Consultar_Dashboard_Principal.rst # PENDIENTE
|   |   |   +-- UC_026_Consultar_Widgets_Resumen.rst     # PENDIENTE
|   |   |   +-- UC_027_Ver_Graficos_Hora.rst             # PENDIENTE
|   |   |   +-- UC_028_Ver_Graficos_Dia.rst              # PENDIENTE
|   |   |   +-- UC_029_Ver_Distribucion_Centro.rst       # PENDIENTE
|   |   |   +-- UC_030_Personalizar_Layout_Dashboard.rst # PENDIENTE
|   |   |
|   |   +-- alerts/                              # Ref: ARQ_MOD_006 (5 UC)
|   |   |   +-- UC_036_Configurar_Alerta_Operativa.rst   # PENDIENTE
|   |   |   +-- UC_037_Recibir_Notificacion_Buzon.rst    # PENDIENTE
|   |   |   +-- UC_038_Consultar_Bandeja_Notificaciones.rst # PENDIENTE
|   |   |   +-- UC_039_Silenciar_Posponer_Alerta.rst     # PENDIENTE
|   |   |   +-- UC_040_Confirmar_Cerrar_Alerta.rst       # PENDIENTE
|   |   |
|   |   +-- audit/                               # Ref: ARQ_MOD_007 (4 UC)
|   |   |   +-- UC_070_Consultar_Bitacora_Auditoria.rst  # PENDIENTE
|   |   |   +-- UC_071_Filtrar_Auditoria.rst             # PENDIENTE
|   |   |   +-- UC_072_Exportar_Eventos_Auditoria.rst    # PENDIENTE
|   |   |   +-- UC_073_Generar_Reporte_Cambios_Permisos.rst # PENDIENTE
|   |   |
|   |   +-- sys_logs/                            # Ref: ARQ_MOD_008 (4 UC)
|   |       +-- UC_080_Consultar_Bitacoras_Tecnicas.rst  # PENDIENTE
|   |       +-- UC_081_Consultar_Estado_Salud.rst        # PENDIENTE
|   |       +-- UC_082_Descargar_Paquetes_Logs.rst       # PENDIENTE
|   |       +-- UC_083_Consultar_Metricas_Tecnicas.rst   # PENDIENTE
|   |
|   +-- requisitos_funcionales/                  # [CONGELADO] *** 36 FR ***
|       +-- index.rst
|       |
|       +-- auth/                                # FR de ARQ_MOD_001
|       |   +-- FR_001_Validar_Credenciales.rst          # PENDIENTE
|       |   +-- FR_002_Generar_Token_JWT.rst             # PENDIENTE
|       |   +-- FR_003_Registrar_Sesion_BD.rst           # PENDIENTE
|       |   +-- FR_004_Invalidar_Token.rst               # PENDIENTE
|       |   +-- FR_005_Verificar_Preguntas_Seguridad.rst # PENDIENTE
|       |
|       +-- user_identity/                       # FR de ARQ_MOD_002
|       |   +-- FR_006_Generar_Username_Automatico.rst   # PENDIENTE
|       |   +-- FR_007_Validar_Datos_Usuario.rst         # PENDIENTE
|       |   +-- FR_008_Ejecutar_Baja_Logica.rst          # PENDIENTE
|       |   +-- FR_009_Almacenar_Preguntas_Seguridad.rst # PENDIENTE
|       |   +-- FR_010_Cargar_Perfil_Usuario.rst         # PENDIENTE
|       |
|       +-- rbac_core/                           # FR de ARQ_MOD_003
|       |   +-- FR_011_CRUD_Roles.rst                    # PENDIENTE
|       |   +-- FR_012_Calcular_Permisos_Efectivos.rst   # PENDIENTE
|       |   +-- FR_013_Asignar_Rol_Usuario.rst           # PENDIENTE
|       |   +-- FR_014_Configurar_Segmento.rst           # PENDIENTE
|       |   +-- FR_015_Asignar_Permiso_Directo.rst       # PENDIENTE
|       |
|       +-- etl_monitoring/                      # FR de ARQ_MOD_004
|       |   +-- FR_016_Listar_Ejecuciones_ETL.rst        # PENDIENTE
|       |   +-- FR_017_Cargar_Detalle_ETL.rst            # PENDIENTE
|       |   +-- FR_018_Consultar_Disponibilidad.rst      # PENDIENTE
|       |   +-- FR_019_Listar_Incidencias_Calidad.rst    # PENDIENTE
|       |
|       +-- vis_reports/                         # FR de ARQ_MOD_005
|       |   +-- FR_020_Cargar_Dashboard.rst              # PENDIENTE
|       |   +-- FR_021_Aplicar_Filtros.rst               # PENDIENTE
|       |   +-- FR_022_Generar_CSV.rst                   # PENDIENTE
|       |   +-- FR_023_Generar_Excel.rst                 # PENDIENTE
|       |   +-- FR_024_Generar_PDF.rst                   # PENDIENTE
|       |   +-- FR_025_Renderizar_Widgets.rst            # PENDIENTE
|       |   +-- FR_026_Guardar_Layout_Personalizado.rst  # PENDIENTE
|       |
|       +-- alerts/                              # FR de ARQ_MOD_006
|       |   +-- FR_027_Crear_Configuracion_Alerta.rst    # PENDIENTE
|       |   +-- FR_028_Enviar_Notificacion_Interna.rst   # PENDIENTE
|       |   +-- FR_029_Listar_Notificaciones.rst         # PENDIENTE
|       |   +-- FR_030_Aplicar_Snooze_Alerta.rst         # PENDIENTE
|       |
|       +-- audit/                               # FR de ARQ_MOD_007
|       |   +-- FR_031_Listar_Eventos_Auditoria.rst      # PENDIENTE
|       |   +-- FR_032_Filtrar_Auditoria.rst             # PENDIENTE
|       |   +-- FR_033_Exportar_Auditoria.rst            # PENDIENTE
|       |
|       +-- sys_logs/                            # FR de ARQ_MOD_008
|           +-- FR_034_Listar_Logs_Sistema.rst           # PENDIENTE
|           +-- FR_035_Consultar_Health_Check.rst        # PENDIENTE
|           +-- FR_036_Empaquetar_Logs.rst               # PENDIENTE
|
+-- arquitectura_tecnica/                        # DOMINIO 3: Arquitectura
|   |
|   +-- index.rst
|   |
|   +-- arquitectura/                            # [DESCONGELADO]
|   |   +-- index.rst
|   |   |
|   |   +-- modulos/                             # *** MODULOS FUNCIONALES (DISENO) ***
|   |   |   +-- index.rst
|   |   |   +-- ARQ_MOD_001_AUTH.rst                 # PENDIENTE - Autenticacion y Sesiones
|   |   |   +-- ARQ_MOD_002_USER_IDENTITY.rst        # PENDIENTE - Gestion Identidades
|   |   |   +-- ARQ_MOD_003_RBAC_CORE.rst            # PENDIENTE - Roles y Permisos
|   |   |   +-- ARQ_MOD_004_ETL_MONITORING.rst       # PENDIENTE - Supervision ETL
|   |   |   +-- ARQ_MOD_005_VIS_REPORTS.rst          # PENDIENTE - Visualizacion/Reportes
|   |   |   +-- ARQ_MOD_006_ALERTS.rst               # PENDIENTE - Alertas/Notificaciones
|   |   |   +-- ARQ_MOD_007_AUDIT.rst                # PENDIENTE - Auditoria Funcional
|   |   |   +-- ARQ_MOD_008_SYS_LOGS.rst             # PENDIENTE - Bitacoras Tecnicas
|   |   |
|   |   +-- decisiones/                          # ADRs
|   |   |   +-- ADR_001_Stack_Django_React.rst       # PENDIENTE
|   |   |   +-- ADR_002_BD_Dual_MySQL_PG.rst         # PENDIENTE
|   |   |   +-- ADR_003_UML_No_C4.rst                # PENDIENTE
|   |   |
|   |   +-- vistas/                              # Vistas UML
|   |       +-- ARQ_VIS_001_Componentes.rst          # PENDIENTE
|   |       +-- ARQ_VIS_002_Deployment.rst           # PENDIENTE
|   |       +-- ARQ_VIS_003_Secuencia_ETL.rst        # PENDIENTE
|   |
|   +-- diseno_detallado/                        # [DESCONGELADO]
|   |   +-- index.rst
|   |   +-- apis/
|   |   |   +-- API_001_Auth_Endpoints.rst           # PENDIENTE (ARQ_MOD_001)
|   |   |   +-- API_002_Users_Endpoints.rst          # PENDIENTE (ARQ_MOD_002)
|   |   |   +-- API_003_RBAC_Endpoints.rst           # PENDIENTE (ARQ_MOD_003)
|   |   |   +-- API_004_ETL_Endpoints.rst            # PENDIENTE (ARQ_MOD_004)
|   |   |   +-- API_005_Dashboard_Endpoints.rst      # PENDIENTE (ARQ_MOD_005)
|   |   |   +-- API_006_Reports_Endpoints.rst        # PENDIENTE (ARQ_MOD_005)
|   |   |   +-- API_007_Alerts_Endpoints.rst         # PENDIENTE (ARQ_MOD_006)
|   |   |   +-- API_008_Audit_Endpoints.rst          # PENDIENTE (ARQ_MOD_007)
|   |   |   +-- API_009_Health_Endpoints.rst         # PENDIENTE (ARQ_MOD_008)
|   |   +-- modelos/
|   |   |   +-- DSC_MOD_001_User.rst                 # PENDIENTE
|   |   |   +-- DSC_MOD_002_Role.rst                 # PENDIENTE
|   |   |   +-- DSC_MOD_003_Permission.rst           # PENDIENTE
|   |   |   +-- DSC_MOD_004_Session.rst              # PENDIENTE
|   |   |   +-- DSC_MOD_005_ETLExecution.rst         # PENDIENTE
|   |   |   +-- DSC_MOD_006_DailyMetrics.rst         # PENDIENTE
|   |   |   +-- DSC_MOD_007_Alert.rst                # PENDIENTE
|   |   |   +-- DSC_MOD_008_AuditLog.rst             # PENDIENTE
|   |   |   +-- DSC_MOD_009_InternalMessage.rst      # PENDIENTE
|   |   +-- esquemas/
|   |       +-- ESQ_001_Request_Auth.rst             # PENDIENTE
|   |       +-- ESQ_002_Response_Dashboard.rst       # PENDIENTE
|   |       +-- ESQ_003_Response_Pagination.rst      # PENDIENTE
|   |
|   +-- restricciones/                           # [CONGELADO] *** COMPLETADO ***
|       +-- index.rst
|       +-- CNST_001_Comunicaciones_Prohibidas.rst       # COMPLETADO
|       +-- CNST_002_Gestion_Sesiones_BD.rst             # COMPLETADO
|       +-- CNST_003_Base_Datos_Dual_Inmutable.rst       # COMPLETADO
|       +-- CNST_004_Actualizacion_Datos_ETL.rst         # COMPLETADO
|       +-- CNST_005_Seguridad_DRF_Checklist.rst         # COMPLETADO
|       +-- CNST_006_Antipatrones_Arquitectura.rst       # COMPLETADO
|       +-- CNST_007_Limites_Performance_SLA.rst         # COMPLETADO
|       +-- CNST_008_Infraestructura_Deployment.rst      # COMPLETADO
|       +-- CNST_009_Logging_Auditoria_Inmutable.rst     # COMPLETADO
|       +-- CNST_010_Clasificacion_Proteccion_Datos.rst  # COMPLETADO
|
+-- normativa/                                   # DOMINIO 4: Estandares y Politicas
|   |
|   +-- index.rst
|   |
|   +-- estandares/                              # [DESCONGELADO]
|   |   +-- index.rst
|   |   +-- STD_001_Suite_Calidad_Codigo.rst         # PENDIENTE
|   |   +-- STD_002_Metodologia_SBVR_UML_Larman.rst  # PENDIENTE
|   |   +-- STD_003_Clean_Code_Naming.rst            # PENDIENTE
|   |   +-- STD_004_Nomenclatura_Proyecto.rst        # PENDIENTE
|   |   +-- STD_005_Estilo_Documentacion_Sphinx.rst  # PENDIENTE
|   |   +-- plantillas/                          # *** COMPLETADO ***
|   |       +-- TPL_001_Plantilla_BR.rst             # COMPLETADO
|   |       +-- TPL_002_Plantilla_UC.rst             # COMPLETADO
|   |       +-- TPL_003_Plantilla_ADR.rst            # COMPLETADO
|   |       +-- TPL_004_Plantilla_CNST.rst           # COMPLETADO
|   |       +-- TPL_005_Plantilla_ARQ_MOD.rst        # PENDIENTE (NUEVO v2.0.2)
|   |
|   +-- politicas/                               # [CONGELADO]
|       +-- index.rst
|       +-- POL_001_Seguridad_Informacion.rst        # PENDIENTE
|       +-- POL_002_Control_Acceso.rst               # PENDIENTE
|
+-- evidencia/                                   # DOMINIO 5: Verificacion
    |
    +-- index.rst
    |
    +-- pruebas/                                 # [CONGELADO]
    |   +-- index.rst
    |   +-- TST_001_Test_Plan_Auth.rst               # PENDIENTE (ARQ_MOD_001)
    |   +-- TST_002_Test_Plan_User_Identity.rst      # PENDIENTE (ARQ_MOD_002)
    |   +-- TST_003_Test_Plan_RBAC.rst               # PENDIENTE (ARQ_MOD_003)
    |   +-- TST_004_Test_Plan_ETL.rst                # PENDIENTE (ARQ_MOD_004)
    |   +-- TST_005_Test_Plan_Dashboard.rst          # PENDIENTE (ARQ_MOD_005)
    |   +-- TST_006_Test_Plan_Alerts.rst             # PENDIENTE (ARQ_MOD_006)
    |   +-- TST_007_Test_Plan_Audit.rst              # PENDIENTE (ARQ_MOD_007)
    |   +-- TST_008_Test_Plan_SysLogs.rst            # PENDIENTE (ARQ_MOD_008)
    |
    +-- trazabilidad/                            # [CONGELADO]
        +-- index.rst
        +-- RTM_Master_v1_0_0.rst                    # PENDIENTE
```

---

## 2. CATALOGO DE MODULOS FUNCIONALES (ARQ_MOD_)

### 2.1 Proposito de ARQ_MOD_

Los documentos ARQ_MOD_ son **documentos de diseno arquitectonico** que:

1. **Definen** la arquitectura logica de cada modulo del sistema
2. **Son referenciados** por los UC, FR, API, TST
3. **NO son artefactos RTM/PMO** (no van en Bloque A/B/C)
4. **Documentan** servicios, APIs, capas, componentes

### 2.2 Listado Oficial de Modulos

| ID | Codigo | Nombre Completo | Apps Django |
|----|--------|-----------------|-------------|
| ARQ_MOD_001 | AUTH | Autenticacion y Sesiones | apps.users |
| ARQ_MOD_002 | USER_IDENTITY | Gestion de Identidades | apps.users |
| ARQ_MOD_003 | RBAC_CORE | Roles, Segmentos y Permisos | apps.common.permissions |
| ARQ_MOD_004 | ETL_MONITORING | Supervision ETL y Calidad | apps.etl, apps.monitoring |
| ARQ_MOD_005 | VIS_REPORTS | Visualizacion y Reportes | apps.analytics, apps.reports, apps.exports |
| ARQ_MOD_006 | ALERTS | Alertas y Notificaciones | apps.common.notifications |
| ARQ_MOD_007 | AUDIT | Auditoria Funcional | apps.common.audit |
| ARQ_MOD_008 | SYS_LOGS | Bitacoras Tecnicas | apps.monitoring |

### 2.3 Contenido de cada ARQ_MOD_

Cada documento ARQ_MOD_ contiene:

```
1. Proposito
   - Que hace este modulo
   - Que problema resuelve

2. Alcance
   - Que INCLUYE
   - Que NO INCLUYE (exclusiones explicitas)

3. Componentes
   - Apps Django asociadas
   - Modelos de datos
   - Servicios

4. Dependencias
   - Otros ARQ_MOD_ requeridos
   - Orden de dependencia

5. Interfaces
   - APIs expuestas (referencia a API_XXX)
   - Eventos emitidos/consumidos

6. Restricciones Aplicables
   - CNST que afectan este modulo

7. Casos de Uso Asociados
   - Lista de UC_XXX que pertenecen a este modulo

8. Requisitos Funcionales Asociados
   - Lista de FR_XXX derivados
```

### 2.4 Mapeo CNST -> ARQ_MOD_

| CNST | Modulos Afectados |
|------|-------------------|
| CNST_001 | ARQ_MOD_002, ARQ_MOD_006 |
| CNST_002 | ARQ_MOD_001 |
| CNST_003 | ARQ_MOD_004, ARQ_MOD_005 |
| CNST_004 | ARQ_MOD_004 |
| CNST_005 | ARQ_MOD_003 |
| CNST_006 | TODOS |
| CNST_007 | ARQ_MOD_005 |
| CNST_008 | ARQ_MOD_008 |
| CNST_009 | ARQ_MOD_007, ARQ_MOD_008 |
| CNST_010 | TODOS |

### 2.5 Mapeo ARQ_MOD_ -> UC

| ARQ_MOD_ | UC Asignados | Cantidad |
|----------|--------------|----------|
| ARQ_MOD_001 | UC_001 - UC_005 | 5 |
| ARQ_MOD_002 | UC_006 - UC_010 | 5 |
| ARQ_MOD_003 | UC_041 - UC_047 | 7 |
| ARQ_MOD_004 | UC_051 - UC_055 | 5 |
| ARQ_MOD_005 | UC_017 - UC_030 | 14 |
| ARQ_MOD_006 | UC_036 - UC_040 | 5 |
| ARQ_MOD_007 | UC_070 - UC_073 | 4 |
| ARQ_MOD_008 | UC_080 - UC_083 | 4 |
| **TOTAL** | | **49** |

---

## 3. CATALOGO COMPLETO DE CASOS DE USO (49 UC)

### 3.1 ARQ_MOD_001 - AUTH (5 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_001 | Iniciar_Sesion | BReq_001 | Login con credenciales |
| UC_002 | Cerrar_Sesion | BReq_001 | Logout del sistema |
| UC_003 | Recuperar_Contrasena | BReq_003 | Via preguntas de seguridad |
| UC_004 | Cambiar_Contrasena | BReq_003 | Cambio de password |
| UC_005 | Gestionar_Sesiones_Activas | BReq_003 | Ver/cerrar sesiones |

### 3.2 ARQ_MOD_002 - USER_IDENTITY (5 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_006 | Crear_Cuenta_Usuario | BReq_003 | Alta con username autogenerado |
| UC_007 | Actualizar_Datos_Usuario | BReq_003 | Modificar datos perfil |
| UC_008 | Baja_Logica_Usuario | BReq_003 | Soft delete |
| UC_009 | Gestionar_Preguntas_Seguridad | BReq_003 | Min 3 preguntas |
| UC_010 | Consultar_Perfil_Usuario | BReq_003 | Ver datos y roles |

### 3.3 ARQ_MOD_003 - RBAC_CORE (7 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_041 | Administrar_Catalogo_Roles | BReq_003 | CRUD roles funcionales |
| UC_042 | Calcular_Permisos_Efectivos | BReq_003 | Precedencia y SoD |
| UC_043 | Asignar_Retirar_Roles | BReq_003 | Gestion de roles usuario |
| UC_044 | Configurar_Segmentos_Datos | BReq_003 | Data segments |
| UC_045 | Asignar_Permisos_Directos | BReq_003 | Con vigencia max 6 meses |
| UC_046 | Simular_Acceso_Usuario | BReq_003 | Preview de permisos |
| UC_047 | Consultar_Matriz_Roles | BReq_003 | Vista consolidada PMO |

### 3.4 ARQ_MOD_004 - ETL_MONITORING (5 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_051 | Consultar_Ejecuciones_ETL | BReq_001 | Historico de jobs |
| UC_052 | Ver_Detalle_Ejecucion_ETL | BReq_001 | Metricas y errores |
| UC_053 | Consultar_Disponibilidad_Datos | BReq_001 | Por periodo |
| UC_054 | Consultar_Incidencias_Calidad | BReq_001 | Nulos, duplicados |
| UC_055 | Reintentar_Procesamiento | BReq_001 | Reprocesar metricas |

### 3.5 ARQ_MOD_005 - VIS_REPORTS (14 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_017 | Consultar_Reporte_Trimestral | BReq_001 | Consolidado |
| UC_018 | Consultar_Reporte_Errores | BReq_001 | Problemas menu |
| UC_019 | Consultar_Reporte_Transferencias | BReq_001 | Rutas llamada |
| UC_020 | Aplicar_Filtros_Fecha | BReq_001 | Presets y rangos |
| UC_021 | Aplicar_Filtros_Negocio | BReq_001 | Centro, servicio, cola |
| UC_022 | Exportar_Reporte_CSV | BReq_002 | Formato CSV |
| UC_023 | Exportar_Reporte_Excel | BReq_002 | Formato XLSX |
| UC_024 | Exportar_Reporte_PDF | BReq_002 | Formato PDF |
| UC_025 | Consultar_Dashboard_Principal | BReq_001 | Vista principal IVR |
| UC_026 | Consultar_Widgets_Resumen | BReq_001 | KPIs operativos |
| UC_027 | Ver_Graficos_Hora | BReq_001 | Temporal por hora |
| UC_028 | Ver_Graficos_Dia | BReq_001 | Temporal por dia |
| UC_029 | Ver_Distribucion_Centro | BReq_001 | Por centro/servicio |
| UC_030 | Personalizar_Layout_Dashboard | BReq_001 | Max 10 widgets |

### 3.6 ARQ_MOD_006 - ALERTS (5 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_036 | Configurar_Alerta_Operativa | BReq_001 | THRESHOLD/ANOMALY/TREND |
| UC_037 | Recibir_Notificacion_Buzon | BReq_001 | InternalMessage |
| UC_038 | Consultar_Bandeja_Notificaciones | BReq_001 | Filtros y estados |
| UC_039 | Silenciar_Posponer_Alerta | BReq_001 | Snooze 1h/8h/24h |
| UC_040 | Confirmar_Cerrar_Alerta | BReq_001 | Marcar atendida |

### 3.7 ARQ_MOD_007 - AUDIT (4 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_070 | Consultar_Bitacora_Auditoria | BReq_003 | Eventos funcionales |
| UC_071 | Filtrar_Auditoria | BReq_003 | Por usuario, fecha, tipo |
| UC_072 | Exportar_Eventos_Auditoria | BReq_002 | CSV/Excel |
| UC_073 | Generar_Reporte_Cambios_Permisos | BReq_003 | Cumplimiento |

### 3.8 ARQ_MOD_008 - SYS_LOGS (4 UC)

| UC ID | Nombre | Deriva de | Descripcion |
|-------|--------|-----------|-------------|
| UC_080 | Consultar_Bitacoras_Tecnicas | BReq_001 | Logs aplicacion |
| UC_081 | Consultar_Estado_Salud | BReq_001 | Health endpoints |
| UC_082 | Descargar_Paquetes_Logs | BReq_002 | Comprimido |
| UC_083 | Consultar_Metricas_Tecnicas | BReq_001 | Recursos, tiempos |

---

## 4. JERARQUIA DE TRAZABILIDAD

### 4.1 Flujo Completo

```
+------------------------------------------------------------------+
|                    FLUJO DE TRAZABILIDAD                          |
+------------------------------------------------------------------+

    RESTRICCIONES (CNST)                 MODULOS (ARQ_MOD_)
    [10 docs - COMPLETADO]               [8 docs - PENDIENTE]
              |                                   |
              |  informan                         | definen arquitectura
              v                                   v
    +----------------------------------------------------------+
    |                                                          |
    |     REGLAS DE NEGOCIO (BR)                               |
    |     [3 docs - COMPLETADO]                                |
    |                                                          |
    +----------------------------------------------------------+
                              |
                              | derivan
                              v
    +----------------------------------------------------------+
    |                                                          |
    |     REQUISITOS DE NEGOCIO (BReq)                         |
    |     [3 docs - COMPLETADO]                                |
    |                                                          |
    +----------------------------------------------------------+
                              |
                              | derivan
                              v
    +----------------------------------------------------------+
    |                                                          |
    |     CASOS DE USO (UC)                                    |
    |     [49 docs - PENDIENTE]                                |
    |     metadata: :modulo: ARQ_MOD_XXX                       |
    |                                                          |
    +----------------------------------------------------------+
                              |
                              | derivan
                              v
    +----------------------------------------------------------+
    |                                                          |
    |     REQUISITOS FUNCIONALES (FR)                          |
    |     [36 docs - PENDIENTE]                                |
    |     metadata: :modulo: ARQ_MOD_XXX                       |
    |                                                          |
    +----------------------------------------------------------+
                              |
                              | verifican
                              v
    +----------------------------------------------------------+
    |                                                          |
    |     TEST CASES (TST)                                     |
    |     [8 docs - PENDIENTE]                                 |
    |     1 TST por ARQ_MOD_                                   |
    |                                                          |
    +----------------------------------------------------------+
                              |
                              | registran en
                              v
    +----------------------------------------------------------+
    |                                                          |
    |     MATRIZ TRAZABILIDAD (RTM)                            |
    |     [1 doc - PENDIENTE]                                  |
    |                                                          |
    +----------------------------------------------------------+
```

### 4.2 Ejemplo: UC con referencia a ARQ_MOD_

```rst
UC_001_Iniciar_Sesion
=====================

.. metadata::
   :id: UC_001
   :nombre: Iniciar Sesion
   :modulo: ARQ_MOD_001_AUTH
   :version: 1.0.0
   :estado: BORRADOR
   :deriva_de: BReq_001_Visualizar_Metricas
   :fecha: 2025-12-22

1. Descripcion
--------------
El usuario inicia sesion en el sistema IACT proporcionando
sus credenciales (username y password).

2. Actores
----------
- Usuario registrado (principal)
- Sistema de autenticacion (secundario)

3. Precondiciones
-----------------
- PRE-01: Usuario existe en el sistema
  (ver ARQ_MOD_002_USER_IDENTITY)
- PRE-02: Usuario tiene estado ACTIVO
- PRE-03: Usuario no esta bloqueado por intentos fallidos

4. Flujo Principal
------------------
[...]

5. Restricciones Aplicables
---------------------------
- CNST_002: Sesion unica por usuario
- CNST_005: Validacion JWT

6. Requisitos Funcionales Derivados
-----------------------------------
- FR_001_Validar_Credenciales
- FR_002_Generar_Token_JWT
- FR_003_Registrar_Sesion_BD
```

---

## 5. CONTEO FINAL v2.0.2

### 5.1 Por Tipo de Documento

| Prefijo | Nombre | Completados | Pendientes | Total |
|---------|--------|-------------|------------|-------|
| CNST | Restricciones | 10 | 0 | 10 |
| ARQ_MOD | Modulos Funcionales | 0 | 8 | 8 |
| BR | Reglas Negocio | 3 | 0 | 3 |
| BReq | Requisitos Negocio | 3 | 0 | 3 |
| UC | Casos de Uso | 0 | 49 | 49 |
| FR | Requisitos Funcionales | 0 | 36 | 36 |
| ADR | Decisiones Arquitectura | 0 | 3 | 3 |
| ARQ_VIS | Vistas UML | 0 | 3 | 3 |
| API | Documentacion APIs | 0 | 9 | 9 |
| DSC_MOD | Modelos Datos | 0 | 9 | 9 |
| ESQ | Esquemas | 0 | 3 | 3 |
| STD | Estandares | 0 | 5 | 5 |
| TPL | Plantillas | 4 | 1 | 5 |
| POL | Politicas | 0 | 2 | 2 |
| TST | Test Plans | 0 | 8 | 8 |
| RTM | Trazabilidad | 0 | 1 | 1 |
| GLO | Glosario | 0 | 1 | 1 |
| TAX | Taxonomias | 0 | 1 | 1 |
| META | Metamodelos | 0 | 1 | 1 |
| _metadata | Metodologia | 6 | 0 | 6 |
| **TOTAL** | | **26** | **140** | **166** |

### 5.2 Por Dominio

| Dominio | Subdominios | Completados | Pendientes | Total |
|---------|-------------|-------------|------------|-------|
| base_cognitiva | 4 | 6 | 3 | 9 |
| requisitos | 4 | 6 | 85 | 91 |
| arquitectura_tecnica | 4 | 10 | 35 | 45 |
| normativa | 2 | 4 | 8 | 12 |
| evidencia | 2 | 0 | 9 | 9 |
| **TOTAL** | **16** | **26** | **140** | **166** |

### 5.3 Progreso Visual

```
COMPLETADO                                              PENDIENTE
[████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 16%

Por dominio:
base_cognitiva       [██████████████████████████░░░░░░░░░░░░░░] 67%
requisitos           [███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  7%
arquitectura_tecnica [█████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 22%
normativa            [█████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░] 33%
evidencia            [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  0%
```

---

## 6. NUMERACION UC (RESERVAS)

Los gaps en numeracion son INTENCIONALES para futuras expansiones:

| Rango | Modulo | Estado |
|-------|--------|--------|
| UC_001-UC_005 | ARQ_MOD_001 AUTH | Asignado (5) |
| UC_006-UC_010 | ARQ_MOD_002 USER_IDENTITY | Asignado (5) |
| UC_011-UC_016 | (Reserva futura) | Libre |
| UC_017-UC_030 | ARQ_MOD_005 VIS_REPORTS | Asignado (14) |
| UC_031-UC_035 | (Reserva futura) | Libre |
| UC_036-UC_040 | ARQ_MOD_006 ALERTS | Asignado (5) |
| UC_041-UC_047 | ARQ_MOD_003 RBAC_CORE | Asignado (7) |
| UC_048-UC_050 | (Reserva futura) | Libre |
| UC_051-UC_055 | ARQ_MOD_004 ETL_MONITORING | Asignado (5) |
| UC_056-UC_069 | (Reserva futura) | Libre |
| UC_070-UC_073 | ARQ_MOD_007 AUDIT | Asignado (4) |
| UC_074-UC_079 | (Reserva futura) | Libre |
| UC_080-UC_083 | ARQ_MOD_008 SYS_LOGS | Asignado (4) |
| UC_084-UC_099 | (Reserva futura) | Libre |

---

## 7. ORDEN DE CREACION SUGERIDO v2.0.2

### Fase 1: Modulos Funcionales (PRIORIDAD ALTA)
```
1. TPL_005_Plantilla_ARQ_MOD.rst    <- Plantilla primero
2. ARQ_MOD_001_AUTH.rst
3. ARQ_MOD_002_USER_IDENTITY.rst
4. ARQ_MOD_003_RBAC_CORE.rst
5. ARQ_MOD_004_ETL_MONITORING.rst
6. ARQ_MOD_005_VIS_REPORTS.rst
7. ARQ_MOD_006_ALERTS.rst
8. ARQ_MOD_007_AUDIT.rst
9. ARQ_MOD_008_SYS_LOGS.rst
```

### Fase 2: UC por Modulo
```
1. UC de ARQ_MOD_001 AUTH (5 UC)
2. UC de ARQ_MOD_003 RBAC_CORE (7 UC)
3. UC de ARQ_MOD_005 VIS_REPORTS (14 UC)
4. UC restantes por modulo
```

### Fase 3: FR derivados
```
1. FR de auth/ (5 FR)
2. FR de rbac_core/ (5 FR)
3. FR de vis_reports/ (7 FR)
4. FR restantes por modulo
```

### Fase 4: APIs por Modulo
```
1. API_001 a API_009
```

### Fase 5: Evidencia
```
1. TST_001 a TST_008 (uno por modulo)
2. RTM_Master_v1_0_0.rst
```

---

## 8. CAMBIOS v2.0.1 -> v2.0.2

| Cambio | v2.0.1 | v2.0.2 |
|--------|--------|--------|
| Prefijo modulos | MOD_ | ARQ_MOD_ |
| Ubicacion modulos | arquitectura_tecnica/modulos/ | arquitectura_tecnica/arquitectura/modulos/ |
| Tipo de documento | Artefacto RTM | Documento de DISENO |
| TAX_002_Taxonomia_Modulos | Incluido | ELIMINADO (innecesario) |
| TPL_005 | Plantilla_MOD | Plantilla_ARQ_MOD |
| Total APIs | 6 | 9 |
| Total DSC_MOD | 6 | 9 |
| Total ESQ | 2 | 3 |
| **Total documentos** | **160** | **166** |

---

## 9. VALIDACION ARQUITECTONICA

### 9.1 Principios Aplicados

| Principio | Validacion |
|-----------|------------|
| SOLID - Single Responsibility | Cada ARQ_MOD_ tiene una responsabilidad unica |
| Clean Architecture | Capas separadas por modulo |
| Onion Architecture | Dependencias hacia adentro |
| NIST RBAC | ARQ_MOD_003 implementa RBAC completo |
| Django Best Practices | Mapeo directo a apps Django |
| Modular Domain Segregation | 8 dominios funcionales independientes |

### 9.2 No Hay Solapamientos

| Par de Modulos | Validacion |
|----------------|------------|
| AUTH vs USER_IDENTITY | AUTH = sesiones, USER_IDENTITY = datos cuenta |
| USER_IDENTITY vs RBAC_CORE | USER_IDENTITY = identidad, RBAC_CORE = permisos |
| VIS_REPORTS vs ETL_MONITORING | VIS_REPORTS = visualiza, ETL_MONITORING = supervisa carga |
| AUDIT vs SYS_LOGS | AUDIT = acciones usuario, SYS_LOGS = logs tecnicos |
| ALERTS vs todos | ALERTS = notificaciones, independiente |

---

*Documento generado: 2025-12-22*
*Proyecto: IACT Dashboard Analytics*
*Version Modelo: 2.0.2*
*Cambio principal: ARQ_MOD_ como documentos de diseno arquitectonico*
