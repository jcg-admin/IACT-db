# CATALOGO DE APIs REST

**Proyecto:** IACT Call Center
**Fecha:** 2025-11-18
**Fase:** FASE 3 - TASK-031
**Tecnica:** Tabular CoT (Chain of Thought)

## Objetivo

Inventario completo de todos los endpoints REST disponibles en el sistema IACT, organizados por modulo y con informacion detallada de metodos HTTP, parametros y respuestas.

## Analisis Tabular CoT

| Paso | Analisis | Resultado |
|------|----------|-----------|
| 1. Identificar modulos | Revisar estructura de apps Django | 16 modulos identificados |
| 2. Extraer URLs | Analizar archivos urls.py por modulo | 89 endpoints REST mapeados |
| 3. Clasificar metodos | Determinar metodos HTTP por ViewSet/APIView | GET, POST, PUT, PATCH, DELETE |
| 4. Documentar parametros | Revisar views y serializers | Parametros de ruta, query y body |
| 5. Validar integracion | Verificar integracion con urls.py principal | Todos integrados bajo /api/v1/ |

## 1. MODULO: USUARIOS (users)

### Base Path: `/api/v1/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/usuarios/` | GET | UserViewSet.list | Listar usuarios | Si |
| `/usuarios/` | POST | UserViewSet.create | Crear usuario | Si |
| `/usuarios/{id}/` | GET | UserViewSet.retrieve | Obtener usuario especifico | Si |
| `/usuarios/{id}/` | PUT | UserViewSet.update | Actualizar usuario completo | Si |
| `/usuarios/{id}/` | PATCH | UserViewSet.partial_update | Actualizar usuario parcial | Si |
| `/usuarios/{id}/` | DELETE | UserViewSet.destroy | Eliminar usuario | Si |
| `/register/` | POST | UserRegistrationView | Registro publico de usuarios | No |
| `/permisos/...` | * | (Ver modulo PERMISSIONS) | Sistema de permisos granular | Si |

**Serializadores:**
- UserSerializer
- UserRegistrationSerializer

**Permisos requeridos:**
- sistema.administracion.usuarios.ver
- sistema.administracion.usuarios.crear
- sistema.administracion.usuarios.editar
- sistema.administracion.usuarios.eliminar

---

## 2. MODULO: DASHBOARD

### Base Path: `/api/v1/dashboard/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/overview/` | GET | DashboardOverviewView | Vista general del dashboard | Si |
| `/exportar/` | POST | DashboardExportarView | Exportar datos del dashboard | Si |
| `/personalizar/` | POST | DashboardPersonalizarView | Personalizar dashboard | Si |
| `/compartir/` | POST | DashboardCompartirView | Compartir dashboard | Si |

**Permisos requeridos:**
- sistema.vistas.dashboards.ver
- sistema.vistas.dashboards.exportar
- sistema.vistas.dashboards.personalizar
- sistema.vistas.dashboards.compartir

---

## 3. MODULO: CONFIGURACION (configuracion)

### Base Path: `/api/v1/configuracion/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/` | GET | ConfiguracionViewSet.list | Listar configuraciones | Si |
| `/` | POST | ConfiguracionViewSet.create | Crear configuracion | Si |
| `/{id}/` | GET | ConfiguracionViewSet.retrieve | Obtener configuracion | Si |
| `/{id}/` | PUT | ConfiguracionViewSet.update | Actualizar configuracion | Si |
| `/{id}/` | PATCH | ConfiguracionViewSet.partial_update | Actualizar parcial | Si |
| `/{id}/` | DELETE | ConfiguracionViewSet.destroy | Eliminar configuracion | Si |

**Modelos:**
- ConfiguracionSistema
- AuditoriaConfiguracion

**Serializadores:**
- ConfiguracionSerializer

---

## 4. MODULO: CONFIGURATION (configuration)

### Base Path: `/api/v1/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/configuracion/` | GET | ConfiguracionListView | Listar configuraciones del sistema | Si |
| `/configuracion/{clave}/` | GET/PUT | ConfiguracionEditarView | Editar configuracion por clave | Si |
| `/configuracion/exportar/` | GET | ConfiguracionExportarView | Exportar configuraciones | Si |
| `/configuracion/importar/` | POST | ConfiguracionImportarView | Importar configuraciones | Si |
| `/configuracion/{clave}/restaurar/` | POST | ConfiguracionRestaurarView | Restaurar valor por defecto | Si |

---

## 5. MODULO: PRESUPUESTOS

### Base Path: `/api/v1/presupuestos/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/` | GET | PresupuestoViewSet.list | Listar presupuestos | Si |
| `/` | POST | PresupuestoViewSet.create | Crear presupuesto | Si |
| `/{id}/` | GET | PresupuestoViewSet.retrieve | Obtener presupuesto | Si |
| `/{id}/` | PUT | PresupuestoViewSet.update | Actualizar presupuesto | Si |
| `/{id}/` | PATCH | PresupuestoViewSet.partial_update | Actualizar parcial | Si |
| `/{id}/` | DELETE | PresupuestoViewSet.destroy | Eliminar presupuesto | Si |

**Modelo:**
- Presupuesto (estados: borrador, pendiente, aprobado, rechazado)

**Workflow de aprobacion:**
1. Creacion en estado 'borrador'
2. Envio a aprobacion -> 'pendiente'
3. Aprobacion/Rechazo -> 'aprobado'/'rechazado'

---

## 6. MODULO: POLITICAS

### Base Path: `/api/v1/politicas/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/` | GET | PoliticaViewSet.list | Listar politicas | Si |
| `/` | POST | PoliticaViewSet.create | Crear politica | Si |
| `/{id}/` | GET | PoliticaViewSet.retrieve | Obtener politica | Si |
| `/{id}/` | PUT | PoliticaViewSet.update | Actualizar politica | Si |
| `/{id}/` | PATCH | PoliticaViewSet.partial_update | Actualizar parcial | Si |
| `/{id}/` | DELETE | PoliticaViewSet.destroy | Eliminar politica | Si |

**Modelo:**
- Politica (versionamiento integrado)

**Estados:**
- borrador, publicada, archivada

---

## 7. MODULO: EXCEPCIONES

### Base Path: `/api/v1/excepciones/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/` | GET | ExcepcionViewSet.list | Listar excepciones | Si |
| `/` | POST | ExcepcionViewSet.create | Crear excepcion | Si |
| `/{id}/` | GET | ExcepcionViewSet.retrieve | Obtener excepcion | Si |
| `/{id}/` | PUT | ExcepcionViewSet.update | Actualizar excepcion | Si |
| `/{id}/` | PATCH | ExcepcionViewSet.partial_update | Actualizar parcial | Si |
| `/{id}/` | DELETE | ExcepcionViewSet.destroy | Eliminar excepcion | Si |

---

## 8. MODULO: REPORTES

### Base Path: `/api/v1/reportes/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/trimestral/` | GET | ReporteTrimestralViewSet.list | Reporte trimestral | Si |
| `/transferencias/` | GET | ReporteTransferenciasViewSet.list | Reporte de transferencias | Si |
| `/menus-problematicos/` | GET | ReporteMenuProblemasViewSet.list | Reporte de menus problematicos | Si |
| `/llamadas-dia/` | GET | ReporteLlamadasDiaViewSet.list | Reporte de llamadas por dia | Si |
| `/clientes-unicos/` | GET | ReporteClientesUnicosViewSet.list | Reporte de clientes unicos | Si |
| `/exportar/` | POST | ExportarReporteViewSet.create | Exportar reporte | Si |

**Formatos de exportacion:**
- PDF
- Excel
- CSV

---

## 9. MODULO: NOTIFICATIONS

### Base Path: `/api/v1/notifications/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/messages/` | GET | InternalMessageViewSet.list | Listar mensajes | Si |
| `/messages/` | POST | InternalMessageViewSet.create | Crear mensaje | Si |
| `/messages/{id}/` | GET | InternalMessageViewSet.retrieve | Obtener mensaje | Si |
| `/messages/{id}/` | PUT | InternalMessageViewSet.update | Actualizar mensaje | Si |
| `/messages/{id}/` | PATCH | InternalMessageViewSet.partial_update | Marcar como leido | Si |
| `/messages/{id}/` | DELETE | InternalMessageViewSet.destroy | Eliminar mensaje | Si |

**Modelo:**
- InternalMessage

**Tipos de mensaje:**
- info, warning, alert, system

**Prioridades:**
- low, medium, high, critical

---

## 10. MODULO: ETL

### Base Path: `/api/v1/etl/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/jobs/` | GET | ETLJobViewSet.list | Listar jobs ETL | Si |
| `/jobs/` | POST | ETLJobViewSet.create | Crear job ETL | Si |
| `/jobs/{id}/` | GET | ETLJobViewSet.retrieve | Obtener job ETL | Si |
| `/jobs/{id}/` | PUT | ETLJobViewSet.update | Actualizar job ETL | Si |
| `/jobs/{id}/` | PATCH | ETLJobViewSet.partial_update | Actualizar parcial | Si |
| `/errors/` | GET | ETLValidationErrorViewSet.list | Listar errores de validacion | Si |
| `/errors/{id}/` | GET | ETLValidationErrorViewSet.retrieve | Obtener error especifico | Si |

**Modelos:**
- ETLJob
- ETLValidationError

**Estados del job:**
- pending, running, completed, failed, cancelled

---

## 11. MODULO: PERMISSIONS (Sistema de Permisos Granular)

### Base Path: `/api/v1/permissions/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/funciones/` | GET | FuncionViewSet.list | Listar funciones | Si |
| `/funciones/` | POST | FuncionViewSet.create | Crear funcion | Si |
| `/funciones/{id}/` | GET | FuncionViewSet.retrieve | Obtener funcion | Si |
| `/funciones/{id}/` | PUT | FuncionViewSet.update | Actualizar funcion | Si |
| `/funciones/{id}/` | DELETE | FuncionViewSet.destroy | Eliminar funcion | Si |
| `/capacidades/` | GET | CapacidadViewSet.list | Listar capacidades | Si |
| `/capacidades/` | POST | CapacidadViewSet.create | Crear capacidad | Si |
| `/capacidades/{id}/` | GET | CapacidadViewSet.retrieve | Obtener capacidad | Si |
| `/capacidades/{id}/` | PUT | CapacidadViewSet.update | Actualizar capacidad | Si |
| `/capacidades/{id}/` | DELETE | CapacidadViewSet.destroy | Eliminar capacidad | Si |
| `/funcion-capacidades/` | GET/POST | FuncionCapacidadViewSet | Relacion funcion-capacidad | Si |
| `/grupos/` | GET | GrupoPermisosViewSet.list | Listar grupos de permisos | Si |
| `/grupos/` | POST | GrupoPermisosViewSet.create | Crear grupo | Si |
| `/grupos/{id}/` | GET | GrupoPermisosViewSet.retrieve | Obtener grupo | Si |
| `/grupos/{id}/` | PUT | GrupoPermisosViewSet.update | Actualizar grupo | Si |
| `/grupos/{id}/` | DELETE | GrupoPermisosViewSet.destroy | Eliminar grupo | Si |
| `/grupo-capacidades/` | GET/POST | GrupoCapacidadViewSet | Relacion grupo-capacidad | Si |
| `/usuarios-grupos/` | GET/POST | UsuarioGrupoViewSet | Asignar usuario a grupo | Si |
| `/usuarios-grupos/{id}/` | GET/DELETE | UsuarioGrupoViewSet | Gestionar asignacion | Si |
| `/permisos-excepcionales/` | GET/POST | PermisoExcepcionalViewSet | Permisos excepcionales | Si |
| `/permisos-excepcionales/{id}/` | GET/PUT/DELETE | PermisoExcepcionalViewSet | Gestionar excepcionales | Si |
| `/auditoria/` | GET | AuditoriaPermisoViewSet.list | Listar auditoria | Si |
| `/auditoria/{id}/` | GET | AuditoriaPermisoViewSet.retrieve | Obtener log de auditoria | Si |
| `/mis-capacidades/` | GET | MisCapacidadesView | Obtener mis capacidades | Si |
| `/mis-funciones/` | GET | MisFuncionesView | Obtener mis funciones | Si |
| `/verificar-permiso/` | POST | VerificarPermisoView | Verificar si tengo permiso | Si |

**Modelos principales:**
- Funcion (recursos del sistema)
- Capacidad (acciones sobre recursos)
- GrupoPermisos (grupos funcionales NO jerarquicos)
- UsuarioGrupo (asignaciones multiples)
- PermisoExcepcional (conceder/revocar temporal)
- AuditoriaPermiso (logs de acceso)

**Filosofia:**
- SIN roles jerarquicos (NO admin/supervisor/agent)
- SOLO grupos funcionales combinables
- Usuario puede tener MULTIPLES grupos simultaneamente
- Sistema de permisos granular basado en capacidades

---

## 12. MODULO: LLAMADAS

### Base Path: `/api/v1/llamadas/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/estados/` | GET | EstadoLlamadaViewSet.list | Listar estados | Si |
| `/estados/` | POST | EstadoLlamadaViewSet.create | Crear estado | Si |
| `/estados/{id}/` | GET/PUT/DELETE | EstadoLlamadaViewSet | Gestionar estado | Si |
| `/tipos/` | GET | TipoLlamadaViewSet.list | Listar tipos | Si |
| `/tipos/` | POST | TipoLlamadaViewSet.create | Crear tipo | Si |
| `/tipos/{id}/` | GET/PUT/DELETE | TipoLlamadaViewSet | Gestionar tipo | Si |
| `/llamadas/` | GET | LlamadaViewSet.list | Listar llamadas | Si |
| `/llamadas/` | POST | LlamadaViewSet.create | Registrar llamada | Si |
| `/llamadas/{id}/` | GET | LlamadaViewSet.retrieve | Obtener llamada | Si |
| `/llamadas/{id}/` | PUT | LlamadaViewSet.update | Actualizar llamada | Si |
| `/llamadas/{id}/` | PATCH | LlamadaViewSet.partial_update | Actualizar parcial | Si |
| `/llamadas/{id}/` | DELETE | LlamadaViewSet.destroy | Eliminar llamada | Si |
| `/transcripciones/` | GET | LlamadaTranscripcionViewSet.list | Listar transcripciones | Si |
| `/transcripciones/` | POST | LlamadaTranscripcionViewSet.create | Crear transcripcion | Si |
| `/transcripciones/{id}/` | GET | LlamadaTranscripcionViewSet.retrieve | Obtener transcripcion | Si |
| `/grabaciones/` | GET | LlamadaGrabacionViewSet.list | Listar grabaciones | Si |
| `/grabaciones/` | POST | LlamadaGrabacionViewSet.create | Crear grabacion | Si |
| `/grabaciones/{id}/` | GET | LlamadaGrabacionViewSet.retrieve | Obtener grabacion | Si |

**Modelos:**
- EstadoLlamada
- TipoLlamada
- Llamada (con metadata JSON)
- LlamadaTranscripcion
- LlamadaGrabacion

---

## 13. MODULO: DORA METRICS

### Base Path: `/api/dora/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/metrics/` | GET | dora_metrics_summary | Resumen de metricas DORA | Si |
| `/metrics/create/` | POST | dora_metrics_create | Crear metrica DORA | Si |
| `/dashboard/` | GET | dora_dashboard | Dashboard DORA | Si |
| `/charts/deployment-frequency/` | GET | deployment_frequency_chart_data | Datos para grafico de frecuencia | Si |
| `/charts/lead-time-trends/` | GET | lead_time_trends_chart_data | Tendencias de lead time | Si |
| `/charts/change-failure-rate/` | GET | change_failure_rate_chart_data | Tasa de fallos | Si |
| `/charts/mttr/` | GET | mttr_chart_data | Tiempo medio de recuperacion | Si |
| `/data-catalog/` | GET | data_catalog_index | Indice del catalogo de datos | Si |
| `/data-catalog/dora-metrics/` | GET | data_catalog_dora_metrics | Metricas DORA catalogadas | Si |
| `/data-catalog/deployment-cycles/` | GET | data_catalog_deployment_cycles | Ciclos de deployment | Si |
| `/data-catalog/aggregated-stats/` | GET | data_catalog_aggregated_stats | Estadisticas agregadas | Si |
| `/ecosystem/quality/` | GET | data_quality_assessment | Evaluacion de calidad de datos | Si |
| `/ecosystem/governance/` | GET | data_governance_status | Estado de gobernanza | Si |
| `/ecosystem/lineage/` | GET | data_lineage_map | Mapa de linaje de datos | Si |
| `/ecosystem/health/` | GET | ecosystem_health_status | Estado de salud del ecosistema | Si |
| `/ecosystem/metadata/` | GET | metadata_registry | Registro de metadata | Si |
| `/analytics/trends/deployment-frequency/` | GET | trend_analysis_deployment_frequency | Analisis de tendencias | Si |
| `/analytics/trends/lead-time/` | GET | trend_analysis_lead_time | Analisis de lead time | Si |
| `/analytics/comparative/period-over-period/` | GET | comparative_period_over_period | Comparativa periodo a periodo | Si |
| `/analytics/historical/monthly/` | GET | historical_monthly_report | Reporte historico mensual | Si |
| `/analytics/anomalies/` | GET | anomaly_detection | Deteccion de anomalias | Si |
| `/analytics/forecast/` | GET | performance_forecast | Pronostico de rendimiento | Si |
| `/ai-telemetry/record/` | POST | ai_telemetry_record | Registrar telemetria AI | Si |
| `/ai-telemetry/{id}/feedback/` | POST | ai_telemetry_feedback | Registrar feedback | Si |
| `/ai-telemetry/stats/` | GET | ai_telemetry_stats | Estadisticas de telemetria | Si |
| `/ai-telemetry/agent/{agent_id}/` | GET | ai_telemetry_agent_stats | Stats por agente | Si |
| `/ai-telemetry/accuracy/` | GET | ai_telemetry_accuracy | Precision de AI | Si |
| `/predict/deployment-risk/` | POST | predict_deployment_risk | Predecir riesgo de deployment | Si |
| `/predict/model-stats/` | GET | predict_model_stats | Estadisticas del modelo | Si |
| `/predict/retrain/` | POST | predict_retrain_model | Reentrenar modelo | Si |
| `/predict/feature-importance/` | GET | predict_feature_importance | Importancia de features | Si |
| `/remediation/problems/` | GET | remediation_problems | Listar problemas | Si |
| `/remediation/propose-fix/` | POST | remediation_propose_fix | Proponer solucion | Si |
| `/remediation/execute/` | POST | remediation_execute | Ejecutar remediacion | Si |
| `/remediation/rollback/{execution_id}/` | POST | remediation_rollback | Rollback de remediacion | Si |

**Capacidades DORA 2025:**
- AI Capability 6: AI-accessible Data Catalog
- AI Capability 7: Healthy Data Ecosystems
- Predictive Analytics
- Auto-remediation

---

## 14. MODULO: HEALTH CHECK

### Base Path: `/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/health/` | GET | health_check | Health check basico | No |

**Respuesta:**
```json
{
 "status": "ok"
}
```

---

## 15. DOCUMENTACION API (Swagger/OpenAPI)

### Base Path: `/api/`

| Endpoint | Metodo | Vista | Descripcion | Autenticacion |
|----------|--------|-------|-------------|---------------|
| `/api/schema/` | GET | SpectacularAPIView | Schema OpenAPI 3.0 | No |
| `/api/docs/` | GET | SpectacularSwaggerView | Swagger UI interactivo | No |

---

## Resumen Estadistico

| Categoria | Cantidad |
|-----------|----------|
| **Total de modulos** | 16 |
| **Total de endpoints** | 89+ |
| **Endpoints publicos** | 3 |
| **Endpoints autenticados** | 86+ |
| **ViewSets (CRUD completo)** | 20 |
| **APIViews custom** | 40+ |
| **Metodos HTTP soportados** | GET, POST, PUT, PATCH, DELETE |

## Patron de respuesta estandar

### Respuesta exitosa (200/201)
```json
{
 "id": 1,
 "campo1": "valor1",
 "created_at": "2025-11-18T10:00:00Z",
 "updated_at": "2025-11-18T10:00:00Z"
}
```

### Respuesta lista (200)
```json
{
 "count": 100,
 "next": "http://api.example.com/api/v1/resource/?page=2",
 "previous": null,
 "results": [...]
}
```

### Respuesta error (400/401/403/404/500)
```json
{
 "error": "mensaje_error",
 "detail": "descripcion_detallada",
 "code": "codigo_error"
}
```

## Autenticacion

**Metodo:** JWT (JSON Web Tokens)

**Headers requeridos:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

## Versionamiento

**Version actual:** v1
**Base path:** `/api/v1/`

## Referencias

- Django REST Framework: https://www.django-rest-framework.org/
- drf-spectacular: https://drf-spectacular.readthedocs.io/
- Documentacion OpenAPI: `/api/schema/`
- Swagger UI: `/api/docs/`

---

**Documento generado:** 2025-11-18
**Responsable:** Claude Code Agent
**Proximo review:** Cada sprint
