# ESTRUCTURA COMPLETA - MODELO DOCUMENTAL IACT v2.0.1
## Proyecto IACT Dashboard Analytics

**Fecha:** 2025-12-22
**Version:** 2.0.1
**Cambios desde v2.0.0:**
- Incorporacion de 8 Modulos Funcionales (MOD_)
- Expansion de 3 UC a 49 UC organizados por modulo
- Nuevo subdominio: arquitectura_tecnica/modulos/
- Actualizacion de trazabilidad: CNST -> MOD -> BR -> BReq -> UC -> FR

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
|   |   |   +-- TAX_002_Taxonomia_Modulos.rst    # NUEVO v2.0.1
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
|   +-- casos_uso/                               # [DESCONGELADO] *** EXPANDIDO v2.0.1 ***
|   |   +-- index.rst
|   |   |
|   |   +-- auth/                                # MOD_001 - Autenticacion (5 UC)
|   |   |   +-- UC_001_Iniciar_Sesion.rst            # PENDIENTE
|   |   |   +-- UC_002_Cerrar_Sesion.rst             # PENDIENTE
|   |   |   +-- UC_003_Recuperar_Contrasena.rst      # PENDIENTE
|   |   |   +-- UC_004_Cambiar_Contrasena.rst        # PENDIENTE
|   |   |   +-- UC_005_Gestionar_Sesiones_Activas.rst # PENDIENTE
|   |   |
|   |   +-- user_identity/                       # MOD_002 - Identidades (5 UC)
|   |   |   +-- UC_006_Crear_Cuenta_Usuario.rst      # PENDIENTE
|   |   |   +-- UC_007_Actualizar_Datos_Usuario.rst  # PENDIENTE
|   |   |   +-- UC_008_Baja_Logica_Usuario.rst       # PENDIENTE
|   |   |   +-- UC_009_Gestionar_Preguntas_Seguridad.rst # PENDIENTE
|   |   |   +-- UC_010_Consultar_Perfil_Usuario.rst  # PENDIENTE
|   |   |
|   |   +-- rbac_core/                           # MOD_003 - RBAC (7 UC)
|   |   |   +-- UC_041_Administrar_Catalogo_Roles.rst    # PENDIENTE
|   |   |   +-- UC_042_Calcular_Permisos_Efectivos.rst   # PENDIENTE
|   |   |   +-- UC_043_Asignar_Retirar_Roles.rst         # PENDIENTE
|   |   |   +-- UC_044_Configurar_Segmentos_Datos.rst    # PENDIENTE
|   |   |   +-- UC_045_Asignar_Permisos_Directos.rst     # PENDIENTE
|   |   |   +-- UC_046_Simular_Acceso_Usuario.rst        # PENDIENTE
|   |   |   +-- UC_047_Consultar_Matriz_Roles.rst        # PENDIENTE
|   |   |
|   |   +-- etl_monitoring/                      # MOD_004 - ETL (5 UC)
|   |   |   +-- UC_051_Consultar_Ejecuciones_ETL.rst     # PENDIENTE
|   |   |   +-- UC_052_Ver_Detalle_Ejecucion_ETL.rst     # PENDIENTE
|   |   |   +-- UC_053_Consultar_Disponibilidad_Datos.rst # PENDIENTE
|   |   |   +-- UC_054_Consultar_Incidencias_Calidad.rst # PENDIENTE
|   |   |   +-- UC_055_Reintentar_Procesamiento.rst      # PENDIENTE
|   |   |
|   |   +-- vis_reports/                         # MOD_005 - Visualizacion (14 UC)
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
|   |   +-- alerts/                              # MOD_006 - Alertas (5 UC)
|   |   |   +-- UC_036_Configurar_Alerta_Operativa.rst   # PENDIENTE
|   |   |   +-- UC_037_Recibir_Notificacion_Buzon.rst    # PENDIENTE
|   |   |   +-- UC_038_Consultar_Bandeja_Notificaciones.rst # PENDIENTE
|   |   |   +-- UC_039_Silenciar_Posponer_Alerta.rst     # PENDIENTE
|   |   |   +-- UC_040_Confirmar_Cerrar_Alerta.rst       # PENDIENTE
|   |   |
|   |   +-- audit/                               # MOD_007 - Auditoria (4 UC)
|   |   |   +-- UC_070_Consultar_Bitacora_Auditoria.rst  # PENDIENTE
|   |   |   +-- UC_071_Filtrar_Auditoria.rst             # PENDIENTE
|   |   |   +-- UC_072_Exportar_Eventos_Auditoria.rst    # PENDIENTE
|   |   |   +-- UC_073_Generar_Reporte_Cambios_Permisos.rst # PENDIENTE
|   |   |
|   |   +-- sys_logs/                            # MOD_008 - Logs Tecnicos (4 UC)
|   |       +-- UC_080_Consultar_Bitacoras_Tecnicas.rst  # PENDIENTE
|   |       +-- UC_081_Consultar_Estado_Salud.rst        # PENDIENTE
|   |       +-- UC_082_Descargar_Paquetes_Logs.rst       # PENDIENTE
|   |       +-- UC_083_Consultar_Metricas_Tecnicas.rst   # PENDIENTE
|   |
|   +-- requisitos_funcionales/                  # [CONGELADO]
|       +-- index.rst
|       |
|       +-- auth/                                # FR derivados de UC auth/
|       |   +-- FR_001_Validar_Credenciales.rst          # PENDIENTE
|       |   +-- FR_002_Generar_Token_JWT.rst             # PENDIENTE
|       |   +-- FR_003_Registrar_Sesion_BD.rst           # PENDIENTE
|       |   +-- FR_004_Invalidar_Token.rst               # PENDIENTE
|       |   +-- FR_005_Verificar_Preguntas_Seguridad.rst # PENDIENTE
|       |
|       +-- user_identity/                       # FR derivados de UC user_identity/
|       |   +-- FR_006_Generar_Username_Automatico.rst   # PENDIENTE
|       |   +-- FR_007_Validar_Datos_Usuario.rst         # PENDIENTE
|       |   +-- FR_008_Ejecutar_Baja_Logica.rst          # PENDIENTE
|       |   +-- FR_009_Almacenar_Preguntas_Seguridad.rst # PENDIENTE
|       |   +-- FR_010_Cargar_Perfil_Usuario.rst         # PENDIENTE
|       |
|       +-- rbac_core/                           # FR derivados de UC rbac_core/
|       |   +-- FR_011_CRUD_Roles.rst                    # PENDIENTE
|       |   +-- FR_012_Calcular_Permisos_Efectivos.rst   # PENDIENTE
|       |   +-- FR_013_Asignar_Rol_Usuario.rst           # PENDIENTE
|       |   +-- FR_014_Configurar_Segmento.rst           # PENDIENTE
|       |   +-- FR_015_Asignar_Permiso_Directo.rst       # PENDIENTE
|       |
|       +-- etl_monitoring/                      # FR derivados de UC etl_monitoring/
|       |   +-- FR_016_Listar_Ejecuciones_ETL.rst        # PENDIENTE
|       |   +-- FR_017_Cargar_Detalle_ETL.rst            # PENDIENTE
|       |   +-- FR_018_Consultar_Disponibilidad.rst      # PENDIENTE
|       |   +-- FR_019_Listar_Incidencias_Calidad.rst    # PENDIENTE
|       |
|       +-- vis_reports/                         # FR derivados de UC vis_reports/
|       |   +-- FR_020_Cargar_Dashboard.rst              # PENDIENTE
|       |   +-- FR_021_Aplicar_Filtros.rst               # PENDIENTE
|       |   +-- FR_022_Generar_CSV.rst                   # PENDIENTE
|       |   +-- FR_023_Generar_Excel.rst                 # PENDIENTE
|       |   +-- FR_024_Generar_PDF.rst                   # PENDIENTE
|       |   +-- FR_025_Renderizar_Widgets.rst            # PENDIENTE
|       |   +-- FR_026_Guardar_Layout_Personalizado.rst  # PENDIENTE
|       |
|       +-- alerts/                              # FR derivados de UC alerts/
|       |   +-- FR_027_Crear_Configuracion_Alerta.rst    # PENDIENTE
|       |   +-- FR_028_Enviar_Notificacion_Interna.rst   # PENDIENTE
|       |   +-- FR_029_Listar_Notificaciones.rst         # PENDIENTE
|       |   +-- FR_030_Aplicar_Snooze_Alerta.rst         # PENDIENTE
|       |
|       +-- audit/                               # FR derivados de UC audit/
|       |   +-- FR_031_Listar_Eventos_Auditoria.rst      # PENDIENTE
|       |   +-- FR_032_Filtrar_Auditoria.rst             # PENDIENTE
|       |   +-- FR_033_Exportar_Auditoria.rst            # PENDIENTE
|       |
|       +-- sys_logs/                            # FR derivados de UC sys_logs/
|           +-- FR_034_Listar_Logs_Sistema.rst           # PENDIENTE
|           +-- FR_035_Consultar_Health_Check.rst        # PENDIENTE
|           +-- FR_036_Empaquetar_Logs.rst               # PENDIENTE
|
+-- arquitectura_tecnica/                        # DOMINIO 3: Arquitectura
|   |
|   +-- index.rst
|   |
|   +-- modulos/                                 # [NUEVO v2.0.1] *** CATALOGO MODULOS ***
|   |   +-- index.rst
|   |   +-- MOD_001_AUTH.rst                         # PENDIENTE - Autenticacion y Sesiones
|   |   +-- MOD_002_USER_IDENTITY.rst                # PENDIENTE - Gestion Identidades
|   |   +-- MOD_003_RBAC_CORE.rst                    # PENDIENTE - Roles y Permisos
|   |   +-- MOD_004_ETL_MONITORING.rst               # PENDIENTE - Supervision ETL
|   |   +-- MOD_005_VIS_REPORTS.rst                  # PENDIENTE - Visualizacion/Reportes
|   |   +-- MOD_006_ALERTS.rst                       # PENDIENTE - Alertas/Notificaciones
|   |   +-- MOD_007_AUDIT.rst                        # PENDIENTE - Auditoria Funcional
|   |   +-- MOD_008_SYS_LOGS.rst                     # PENDIENTE - Bitacoras Tecnicas
|   |
|   +-- arquitectura/                            # [DESCONGELADO]
|   |   +-- index.rst
|   |   +-- decisiones/
|   |   |   +-- ADR_001_Stack_Django_React.rst       # PENDIENTE
|   |   |   +-- ADR_002_BD_Dual_MySQL_PG.rst         # PENDIENTE
|   |   |   +-- ADR_003_UML_No_C4.rst                # PENDIENTE
|   |   +-- vistas/
|   |       +-- ARQ_VIS_001_Componentes.rst          # PENDIENTE
|   |       +-- ARQ_VIS_002_Deployment.rst           # PENDIENTE
|   |       +-- ARQ_VIS_003_Secuencia_ETL.rst        # PENDIENTE
|   |
|   +-- diseno_detallado/                        # [DESCONGELADO]
|   |   +-- index.rst
|   |   +-- apis/
|   |   |   +-- API_001_Auth_Endpoints.rst           # PENDIENTE
|   |   |   +-- API_002_Dashboard_Endpoints.rst      # PENDIENTE
|   |   |   +-- API_003_Reports_Endpoints.rst        # PENDIENTE
|   |   |   +-- API_004_Users_Endpoints.rst          # NUEVO v2.0.1
|   |   |   +-- API_005_Alerts_Endpoints.rst         # NUEVO v2.0.1
|   |   |   +-- API_006_Audit_Endpoints.rst          # NUEVO v2.0.1
|   |   +-- modelos/
|   |   |   +-- DSC_MOD_001_User.rst                 # PENDIENTE
|   |   |   +-- DSC_MOD_002_IVRCallDetail.rst        # PENDIENTE
|   |   |   +-- DSC_MOD_003_DailyMetrics.rst         # PENDIENTE
|   |   |   +-- DSC_MOD_004_Role.rst                 # NUEVO v2.0.1
|   |   |   +-- DSC_MOD_005_AuditLog.rst             # NUEVO v2.0.1
|   |   |   +-- DSC_MOD_006_Alert.rst                # NUEVO v2.0.1
|   |   +-- esquemas/
|   |       +-- ESQ_001_Request_Auth.rst             # PENDIENTE
|   |       +-- ESQ_002_Response_Dashboard.rst       # PENDIENTE
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
|   |       +-- TPL_005_Plantilla_MOD.rst            # NUEVO v2.0.1
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
    |   +-- TST_001_Test_Plan_Auth.rst               # PENDIENTE (MOD_001)
    |   +-- TST_002_Test_Plan_User_Identity.rst      # NUEVO v2.0.1 (MOD_002)
    |   +-- TST_003_Test_Plan_RBAC.rst               # NUEVO v2.0.1 (MOD_003)
    |   +-- TST_004_Test_Plan_ETL.rst                # PENDIENTE (MOD_004)
    |   +-- TST_005_Test_Plan_Dashboard.rst          # PENDIENTE (MOD_005)
    |   +-- TST_006_Test_Plan_Alerts.rst             # NUEVO v2.0.1 (MOD_006)
    |   +-- TST_007_Test_Plan_Audit.rst              # NUEVO v2.0.1 (MOD_007)
    |   +-- TST_008_Test_Plan_SysLogs.rst            # NUEVO v2.0.1 (MOD_008)
    |
    +-- trazabilidad/                            # [CONGELADO]
        +-- index.rst
        +-- RTM_Master_v1_0_0.rst                    # PENDIENTE
```

---

## 2. CATALOGO DE MODULOS FUNCIONALES

### 2.1 Listado Oficial de Modulos

| ID | Codigo | Nombre Completo | UC Asignados | App Django |
|----|--------|-----------------|--------------|------------|
| MOD_001 | AUTH | Autenticacion y Sesiones | UC_001-UC_005 | apps.users |
| MOD_002 | USER_IDENTITY | Gestion de Identidades | UC_006-UC_010 | apps.users |
| MOD_003 | RBAC_CORE | Roles, Segmentos y Permisos | UC_041-UC_047 | apps.common.permissions |
| MOD_004 | ETL_MONITORING | Supervision ETL y Calidad | UC_051-UC_055 | apps.etl, apps.monitoring |
| MOD_005 | VIS_REPORTS | Visualizacion y Reportes | UC_017-UC_030 | apps.analytics, apps.reports |
| MOD_006 | ALERTS | Alertas y Notificaciones | UC_036-UC_040 | apps.common.notifications |
| MOD_007 | AUDIT | Auditoria Funcional | UC_070-UC_073 | apps.common.audit |
| MOD_008 | SYS_LOGS | Bitacoras Tecnicas | UC_080-UC_083 | apps.monitoring |

### 2.2 Mapeo CNST -> MOD

| CNST | Modulos Afectados |
|------|-------------------|
| CNST_001 | MOD_002, MOD_006 |
| CNST_002 | MOD_001 |
| CNST_003 | MOD_004, MOD_005 |
| CNST_004 | MOD_004 |
| CNST_005 | MOD_003 |
| CNST_006 | TODOS |
| CNST_007 | MOD_005 |
| CNST_008 | MOD_008 |
| CNST_009 | MOD_007, MOD_008 |
| CNST_010 | TODOS |

---

## 3. CATALOGO COMPLETO DE CASOS DE USO (49 UC)

### 3.1 MOD_001 - AUTH (5 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_001 | Iniciar_Sesion | Login con credenciales |
| UC_002 | Cerrar_Sesion | Logout del sistema |
| UC_003 | Recuperar_Contrasena | Via preguntas de seguridad |
| UC_004 | Cambiar_Contrasena | Cambio de password |
| UC_005 | Gestionar_Sesiones_Activas | Ver/cerrar sesiones |

### 3.2 MOD_002 - USER_IDENTITY (5 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_006 | Crear_Cuenta_Usuario | Alta con username autogenerado |
| UC_007 | Actualizar_Datos_Usuario | Modificar datos perfil |
| UC_008 | Baja_Logica_Usuario | Soft delete |
| UC_009 | Gestionar_Preguntas_Seguridad | Min 3 preguntas |
| UC_010 | Consultar_Perfil_Usuario | Ver datos y roles |

### 3.3 MOD_003 - RBAC_CORE (7 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_041 | Administrar_Catalogo_Roles | CRUD roles funcionales |
| UC_042 | Calcular_Permisos_Efectivos | Precedencia y SoD |
| UC_043 | Asignar_Retirar_Roles | Gestion de roles usuario |
| UC_044 | Configurar_Segmentos_Datos | Data segments |
| UC_045 | Asignar_Permisos_Directos | Con vigencia max 6 meses |
| UC_046 | Simular_Acceso_Usuario | Preview de permisos |
| UC_047 | Consultar_Matriz_Roles | Vista consolidada PMO |

### 3.4 MOD_004 - ETL_MONITORING (5 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_051 | Consultar_Ejecuciones_ETL | Historico de jobs |
| UC_052 | Ver_Detalle_Ejecucion_ETL | Metricas y errores |
| UC_053 | Consultar_Disponibilidad_Datos | Por periodo |
| UC_054 | Consultar_Incidencias_Calidad | Nulos, duplicados |
| UC_055 | Reintentar_Procesamiento | Reprocesar metricas |

### 3.5 MOD_005 - VIS_REPORTS (14 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_017 | Consultar_Reporte_Trimestral | Consolidado |
| UC_018 | Consultar_Reporte_Errores | Problemas menu |
| UC_019 | Consultar_Reporte_Transferencias | Rutas llamada |
| UC_020 | Aplicar_Filtros_Fecha | Presets y rangos |
| UC_021 | Aplicar_Filtros_Negocio | Centro, servicio, cola |
| UC_022 | Exportar_Reporte_CSV | Formato CSV |
| UC_023 | Exportar_Reporte_Excel | Formato XLSX |
| UC_024 | Exportar_Reporte_PDF | Formato PDF |
| UC_025 | Consultar_Dashboard_Principal | Vista principal IVR |
| UC_026 | Consultar_Widgets_Resumen | KPIs operativos |
| UC_027 | Ver_Graficos_Hora | Temporal por hora |
| UC_028 | Ver_Graficos_Dia | Temporal por dia |
| UC_029 | Ver_Distribucion_Centro | Por centro/servicio |
| UC_030 | Personalizar_Layout_Dashboard | Max 10 widgets |

### 3.6 MOD_006 - ALERTS (5 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_036 | Configurar_Alerta_Operativa | THRESHOLD/ANOMALY/TREND |
| UC_037 | Recibir_Notificacion_Buzon | InternalMessage |
| UC_038 | Consultar_Bandeja_Notificaciones | Filtros y estados |
| UC_039 | Silenciar_Posponer_Alerta | Snooze 1h/8h/24h |
| UC_040 | Confirmar_Cerrar_Alerta | Marcar atendida |

### 3.7 MOD_007 - AUDIT (4 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_070 | Consultar_Bitacora_Auditoria | Eventos funcionales |
| UC_071 | Filtrar_Auditoria | Por usuario, fecha, tipo |
| UC_072 | Exportar_Eventos_Auditoria | CSV/Excel |
| UC_073 | Generar_Reporte_Cambios_Permisos | Cumplimiento |

### 3.8 MOD_008 - SYS_LOGS (4 UC)

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC_080 | Consultar_Bitacoras_Tecnicas | Logs aplicacion |
| UC_081 | Consultar_Estado_Salud | Health endpoints |
| UC_082 | Descargar_Paquetes_Logs | Comprimido |
| UC_083 | Consultar_Metricas_Tecnicas | Recursos, tiempos |

---

## 4. JERARQUIA DE DERIVACION ACTUALIZADA

```
                         RESTRICCIONES (CNST)
                    [10 documentos - COMPLETADO]
                              |
                              | informan
                              v
                      MODULOS (MOD)           <-- NUEVO NIVEL v2.0.1
                    [8 documentos - PENDIENTE]
                              |
                              | contextualizan
                              v
                    REGLAS DE NEGOCIO (BR)
                    [3 documentos - COMPLETADO]
                              |
                              | derivan
                              v
                 REQUISITOS DE NEGOCIO (BReq)
                    [3 documentos - COMPLETADO]
                              |
                              | derivan
                              v
                      CASOS DE USO (UC)
                   [49 documentos - PENDIENTE]
                              |
                              | derivan
                              v
                REQUISITOS FUNCIONALES (FR)
                   [36 documentos - PENDIENTE]
                              |
                              | verifican
                              v
                       TEST CASES (TST)
                    [8 documentos - PENDIENTE]
                              |
                              | registran en
                              v
                 MATRIZ TRAZABILIDAD (RTM)
                    [1 documento - PENDIENTE]
```

---

## 5. CONTEO FINAL v2.0.1

### 5.1 Por Tipo de Documento

| Prefijo | Nombre | Completados | Pendientes | Total |
|---------|--------|-------------|------------|-------|
| CNST | Restricciones | 10 | 0 | 10 |
| MOD | Modulos Funcionales | 0 | 8 | 8 |
| BR | Reglas Negocio | 3 | 0 | 3 |
| BReq | Requisitos Negocio | 3 | 0 | 3 |
| UC | Casos de Uso | 0 | 49 | 49 |
| FR | Requisitos Funcionales | 0 | 36 | 36 |
| ADR | Decisiones Arquitectura | 0 | 3 | 3 |
| ARQ_VIS | Vistas UML | 0 | 3 | 3 |
| API | Documentacion APIs | 0 | 6 | 6 |
| DSC_MOD | Modelos Datos | 0 | 6 | 6 |
| ESQ | Esquemas | 0 | 2 | 2 |
| STD | Estandares | 0 | 5 | 5 |
| TPL | Plantillas | 4 | 1 | 5 |
| POL | Politicas | 0 | 2 | 2 |
| TST | Test Plans | 0 | 8 | 8 |
| RTM | Trazabilidad | 0 | 1 | 1 |
| GLO | Glosario | 0 | 1 | 1 |
| TAX | Taxonomias | 0 | 2 | 2 |
| META | Metamodelos | 0 | 1 | 1 |
| _metadata | Metodologia | 6 | 0 | 6 |
| **TOTAL** | | **26** | **134** | **160** |

### 5.2 Por Dominio

| Dominio | Subdominios | Completados | Pendientes | Total |
|---------|-------------|-------------|------------|-------|
| base_cognitiva | 4 | 6 | 4 | 10 |
| requisitos | 4 | 6 | 85 | 91 |
| arquitectura_tecnica | 4 | 10 | 28 | 38 |
| normativa | 2 | 4 | 8 | 12 |
| evidencia | 2 | 0 | 9 | 9 |
| **TOTAL** | **16** | **26** | **134** | **160** |

### 5.3 Progreso Visual

```
COMPLETADO                                              PENDIENTE
[████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 16%

Por dominio:
base_cognitiva       [████████████████████████░░░░░░░░░░░░░░░░] 60%
requisitos           [███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  7%
arquitectura_tecnica [██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 26%
normativa            [█████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░] 33%
evidencia            [░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  0%
```

---

## 6. CAMBIOS RESPECTO A v2.0.0

### 6.1 Nuevos Artefactos

| Tipo | Cantidad | Descripcion |
|------|----------|-------------|
| MOD_ | +8 | Catalogo de modulos funcionales |
| UC_ | +46 | Expansion de 3 a 49 casos de uso |
| FR_ | +31 | Expansion de 5 a 36 requisitos funcionales |
| API_ | +3 | Nuevos endpoints (Users, Alerts, Audit) |
| DSC_MOD_ | +3 | Nuevos modelos (Role, AuditLog, Alert) |
| TST_ | +5 | Test plans por modulo |
| TPL_ | +1 | Plantilla de modulo |
| TAX_ | +1 | Taxonomia de modulos |

### 6.2 Reorganizacion de Carpetas

| Cambio | Detalle |
|--------|---------|
| casos_uso/ | Subcarpetas por modulo (auth/, rbac_core/, etc.) |
| requisitos_funcionales/ | Subcarpetas por modulo |
| arquitectura_tecnica/modulos/ | Nuevo subdominio |

### 6.3 Numeracion UC Preservada

Los gaps en numeracion son INTENCIONALES para futuras expansiones:

| Rango | Modulo | Estado |
|-------|--------|--------|
| UC_001-UC_005 | MOD_001 AUTH | Asignado |
| UC_006-UC_010 | MOD_002 USER_IDENTITY | Asignado |
| UC_011-UC_016 | (Reserva futura) | Libre |
| UC_017-UC_030 | MOD_005 VIS_REPORTS | Asignado |
| UC_031-UC_035 | (Reserva futura) | Libre |
| UC_036-UC_040 | MOD_006 ALERTS | Asignado |
| UC_041-UC_047 | MOD_003 RBAC_CORE | Asignado |
| UC_048-UC_050 | (Reserva futura) | Libre |
| UC_051-UC_055 | MOD_004 ETL_MONITORING | Asignado |
| UC_056-UC_069 | (Reserva futura) | Libre |
| UC_070-UC_073 | MOD_007 AUDIT | Asignado |
| UC_074-UC_079 | (Reserva futura) | Libre |
| UC_080-UC_083 | MOD_008 SYS_LOGS | Asignado |
| UC_084-UC_099 | (Reserva futura) | Libre |

---

## 7. ORDEN DE CREACION SUGERIDO v2.0.1

### Fase 1: Catalogo de Modulos (SIGUIENTE)
```
1. MOD_001_AUTH.rst
2. MOD_002_USER_IDENTITY.rst
3. MOD_003_RBAC_CORE.rst
4. MOD_004_ETL_MONITORING.rst
5. MOD_005_VIS_REPORTS.rst
6. MOD_006_ALERTS.rst
7. MOD_007_AUDIT.rst
8. MOD_008_SYS_LOGS.rst
```

### Fase 2: UC por Modulo (Prioridad Alta)
```
1. UC de MOD_001 AUTH (5 UC)
2. UC de MOD_003 RBAC_CORE (7 UC)
3. UC de MOD_005 VIS_REPORTS (14 UC)
4. UC restantes por modulo
```

### Fase 3: FR derivados
```
1. FR de auth/ (5 FR)
2. FR de rbac_core/ (5 FR)
3. FR de vis_reports/ (7 FR)
4. FR restantes por modulo
```

### Fase 4: Arquitectura y Diseno
```
1. ADR_001, ADR_002, ADR_003
2. API_001 a API_006
3. DSC_MOD_001 a DSC_MOD_006
```

### Fase 5: Evidencia
```
1. TST_001 a TST_008 (uno por modulo)
2. RTM_Master_v1_0_0.rst
```

---

## 8. TRAZABILIDAD EJEMPLO COMPLETA

### Ejemplo: Flujo de Autenticacion

```
CNST_002_Gestion_Sesiones_BD
         |
         v
    MOD_001_AUTH
         |
         v
    BR_001_Inmutabilidad_Fuente (parcial)
         |
         v
    BReq_001_Visualizar_Metricas (parcial)
         |
         v
    UC_001_Iniciar_Sesion
         |
    +----+----+----+
    |    |    |    |
    v    v    v    v
FR_001 FR_002 FR_003 ...
         |
         v
    TST_001_Test_Plan_Auth
         |
         v
    RTM_Master_v1_0_0
```

---

*Documento generado: 2025-12-22*
*Proyecto: IACT Dashboard Analytics*
*Version Modelo: 2.0.1*
*Cambio principal: Integracion de 8 modulos y 49 casos de uso*
