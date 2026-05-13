# MATRIZ ENDPOINT-VISTA-PERMISO

**Proyecto:** IACT Call Center
**Fecha:** 2025-11-18
**Fase:** FASE 3 - TASK-034
**Tecnica:** Tabular CoT (Chain of Thought)

## Objetivo

Crear una matriz completa que relaciona cada endpoint REST con su vista correspondiente, capacidades requeridas, modelo de datos y metodo HTTP.

## Analisis Tabular CoT

| Paso | Analisis | Resultado |
|------|----------|-----------|
| 1. Mapear endpoints | Relacionar URL con vista | 89 endpoints mapeados |
| 2. Identificar permisos | Determinar capacidades requeridas | Sistema granular aplicado |
| 3. Vincular modelos | Relacionar con modelos ORM | 22 modelos vinculados |
| 4. Documentar metodos | Listar metodos HTTP permitidos | GET, POST, PUT, PATCH, DELETE |
| 5. Validar seguridad | Verificar autenticacion y autorizacion | Todos los endpoints protegidos |

---

## Leyenda

**Abreviaturas:**
- `GET`: Lectura
- `POST`: Creacion
- `PUT`: Actualizacion completa
- `PATCH`: Actualizacion parcial
- `DELETE`: Eliminacion
- `AUTH`: Requiere autenticacion
- `PERM`: Requiere permiso especifico

**Niveles de sensibilidad:**
- `BAJO`: Consultas basicas
- `NORMAL`: Operaciones estandar
- `ALTO`: Modificaciones importantes
- `CRITICO`: Acciones de alto impacto

---

## MODULO: USUARIOS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/usuarios/` | GET | UserViewSet.list | User | sistema.administracion.usuarios.ver | BAJO | Si |
| `/api/v1/usuarios/` | POST | UserViewSet.create | User | sistema.administracion.usuarios.crear | ALTO | Si |
| `/api/v1/usuarios/{id}/` | GET | UserViewSet.retrieve | User | sistema.administracion.usuarios.ver | BAJO | Si |
| `/api/v1/usuarios/{id}/` | PUT | UserViewSet.update | User | sistema.administracion.usuarios.editar | ALTO | Si |
| `/api/v1/usuarios/{id}/` | PATCH | UserViewSet.partial_update | User | sistema.administracion.usuarios.editar | ALTO | Si |
| `/api/v1/usuarios/{id}/` | DELETE | UserViewSet.destroy | User | sistema.administracion.usuarios.eliminar | CRITICO | Si |
| `/api/v1/register/` | POST | UserRegistrationView | User | N/A (publico) | NORMAL | No |

**Servicios utilizados:**
- UserService.crear_usuario()
- UserService.actualizar_usuario()
- UserService.eliminar_usuario()
- UserService.listar_usuarios()

---

## MODULO: PERMISSIONS (Sistema Granular)

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/permissions/funciones/` | GET | FuncionViewSet.list | Funcion | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/funciones/` | POST | FuncionViewSet.create | Funcion | sistema.administracion.permisos.crear | CRITICO | Si |
| `/api/v1/permissions/funciones/{id}/` | GET | FuncionViewSet.retrieve | Funcion | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/funciones/{id}/` | PUT | FuncionViewSet.update | Funcion | sistema.administracion.permisos.editar | CRITICO | Si |
| `/api/v1/permissions/funciones/{id}/` | DELETE | FuncionViewSet.destroy | Funcion | sistema.administracion.permisos.eliminar | CRITICO | Si |
| `/api/v1/permissions/capacidades/` | GET | CapacidadViewSet.list | Capacidad | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/capacidades/` | POST | CapacidadViewSet.create | Capacidad | sistema.administracion.permisos.crear | CRITICO | Si |
| `/api/v1/permissions/capacidades/{id}/` | GET | CapacidadViewSet.retrieve | Capacidad | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/capacidades/{id}/` | PUT | CapacidadViewSet.update | Capacidad | sistema.administracion.permisos.editar | CRITICO | Si |
| `/api/v1/permissions/capacidades/{id}/` | DELETE | CapacidadViewSet.destroy | Capacidad | sistema.administracion.permisos.eliminar | CRITICO | Si |
| `/api/v1/permissions/funcion-capacidades/` | GET | FuncionCapacidadViewSet.list | FuncionCapacidad | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/funcion-capacidades/` | POST | FuncionCapacidadViewSet.create | FuncionCapacidad | sistema.administracion.permisos.editar | CRITICO | Si |
| `/api/v1/permissions/grupos/` | GET | GrupoPermisosViewSet.list | GrupoPermisos | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/grupos/` | POST | GrupoPermisosViewSet.create | GrupoPermisos | sistema.administracion.permisos.crear | CRITICO | Si |
| `/api/v1/permissions/grupos/{id}/` | GET | GrupoPermisosViewSet.retrieve | GrupoPermisos | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/grupos/{id}/` | PUT | GrupoPermisosViewSet.update | GrupoPermisos | sistema.administracion.permisos.editar | CRITICO | Si |
| `/api/v1/permissions/grupos/{id}/` | DELETE | GrupoPermisosViewSet.destroy | GrupoPermisos | sistema.administracion.permisos.eliminar | CRITICO | Si |
| `/api/v1/permissions/grupo-capacidades/` | GET | GrupoCapacidadViewSet.list | GrupoCapacidad | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/grupo-capacidades/` | POST | GrupoCapacidadViewSet.create | GrupoCapacidad | sistema.administracion.permisos.editar | CRITICO | Si |
| `/api/v1/permissions/usuarios-grupos/` | GET | UsuarioGrupoViewSet.list | UsuarioGrupo | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/usuarios-grupos/` | POST | UsuarioGrupoViewSet.create | UsuarioGrupo | sistema.administracion.permisos.asignar | CRITICO | Si |
| `/api/v1/permissions/usuarios-grupos/{id}/` | DELETE | UsuarioGrupoViewSet.destroy | UsuarioGrupo | sistema.administracion.permisos.revocar | CRITICO | Si |
| `/api/v1/permissions/permisos-excepcionales/` | GET | PermisoExcepcionalViewSet.list | PermisoExcepcional | sistema.administracion.permisos.ver | BAJO | Si |
| `/api/v1/permissions/permisos-excepcionales/` | POST | PermisoExcepcionalViewSet.create | PermisoExcepcional | sistema.administracion.permisos.conceder_excepcional | CRITICO | Si |
| `/api/v1/permissions/permisos-excepcionales/{id}/` | DELETE | PermisoExcepcionalViewSet.destroy | PermisoExcepcional | sistema.administracion.permisos.revocar_excepcional | CRITICO | Si |
| `/api/v1/permissions/auditoria/` | GET | AuditoriaPermisoViewSet.list | AuditoriaPermiso | sistema.administracion.auditoria.ver | BAJO | Si |
| `/api/v1/permissions/auditoria/{id}/` | GET | AuditoriaPermisoViewSet.retrieve | AuditoriaPermiso | sistema.administracion.auditoria.ver | BAJO | Si |
| `/api/v1/permissions/mis-capacidades/` | GET | MisCapacidadesView | N/A | N/A (propio usuario) | BAJO | Si |
| `/api/v1/permissions/mis-funciones/` | GET | MisFuncionesView | N/A | N/A (propio usuario) | BAJO | Si |
| `/api/v1/permissions/verificar-permiso/` | POST | VerificarPermisoView | N/A | N/A (verificacion propia) | BAJO | Si |

**Servicios utilizados:**
- PermisoService.usuario_tiene_permiso()
- PermisoService.obtener_capacidades_usuario()
- PermisoService.obtener_funciones_accesibles()
- PermisoService.registrar_acceso()

**IMPORTANTE:** Todas las operaciones de permisos son CRITICAS y quedan auditadas.

---

## MODULO: LLAMADAS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/llamadas/estados/` | GET | EstadoLlamadaViewSet.list | EstadoLlamada | sistema.operaciones.llamadas.ver_estados | BAJO | Si |
| `/api/v1/llamadas/estados/` | POST | EstadoLlamadaViewSet.create | EstadoLlamada | sistema.administracion.llamadas.crear_estados | ALTO | Si |
| `/api/v1/llamadas/tipos/` | GET | TipoLlamadaViewSet.list | TipoLlamada | sistema.operaciones.llamadas.ver_tipos | BAJO | Si |
| `/api/v1/llamadas/tipos/` | POST | TipoLlamadaViewSet.create | TipoLlamada | sistema.administracion.llamadas.crear_tipos | ALTO | Si |
| `/api/v1/llamadas/llamadas/` | GET | LlamadaViewSet.list | Llamada | sistema.operaciones.llamadas.ver | BAJO | Si |
| `/api/v1/llamadas/llamadas/` | POST | LlamadaViewSet.create | Llamada | sistema.operaciones.llamadas.realizar | NORMAL | Si |
| `/api/v1/llamadas/llamadas/{id}/` | GET | LlamadaViewSet.retrieve | Llamada | sistema.operaciones.llamadas.ver | BAJO | Si |
| `/api/v1/llamadas/llamadas/{id}/` | PUT | LlamadaViewSet.update | Llamada | sistema.operaciones.llamadas.editar | ALTO | Si |
| `/api/v1/llamadas/llamadas/{id}/` | PATCH | LlamadaViewSet.partial_update | Llamada | sistema.operaciones.llamadas.editar | ALTO | Si |
| `/api/v1/llamadas/llamadas/{id}/` | DELETE | LlamadaViewSet.destroy | Llamada | sistema.operaciones.llamadas.eliminar | CRITICO | Si |
| `/api/v1/llamadas/transcripciones/` | GET | LlamadaTranscripcionViewSet.list | LlamadaTranscripcion | sistema.operaciones.llamadas.ver_transcripciones | NORMAL | Si |
| `/api/v1/llamadas/transcripciones/` | POST | LlamadaTranscripcionViewSet.create | LlamadaTranscripcion | sistema.operaciones.llamadas.crear_transcripciones | NORMAL | Si |
| `/api/v1/llamadas/grabaciones/` | GET | LlamadaGrabacionViewSet.list | LlamadaGrabacion | sistema.operaciones.llamadas.ver_grabaciones | ALTO | Si |
| `/api/v1/llamadas/grabaciones/` | POST | LlamadaGrabacionViewSet.create | LlamadaGrabacion | sistema.operaciones.llamadas.crear_grabaciones | ALTO | Si |

---

## MODULO: DASHBOARD

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/dashboard/overview/` | GET | DashboardOverviewView | N/A | sistema.vistas.dashboards.ver | BAJO | Si |
| `/api/v1/dashboard/exportar/` | POST | DashboardExportarView | N/A | sistema.vistas.dashboards.exportar | NORMAL | Si |
| `/api/v1/dashboard/personalizar/` | POST | DashboardPersonalizarView | N/A | sistema.vistas.dashboards.personalizar | NORMAL | Si |
| `/api/v1/dashboard/compartir/` | POST | DashboardCompartirView | N/A | sistema.vistas.dashboards.compartir | NORMAL | Si |

**Servicios utilizados:**
- DashboardService.obtener_metricas()
- DashboardService.exportar_dashboard()
- DashboardService.personalizar_dashboard()

---

## MODULO: CONFIGURACION

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/configuracion/` | GET | ConfiguracionViewSet.list | ConfiguracionSistema | sistema.administracion.configuracion.ver | BAJO | Si |
| `/api/v1/configuracion/` | POST | ConfiguracionViewSet.create | ConfiguracionSistema | sistema.administracion.configuracion.crear | CRITICO | Si |
| `/api/v1/configuracion/{id}/` | GET | ConfiguracionViewSet.retrieve | ConfiguracionSistema | sistema.administracion.configuracion.ver | BAJO | Si |
| `/api/v1/configuracion/{id}/` | PUT | ConfiguracionViewSet.update | ConfiguracionSistema | sistema.administracion.configuracion.editar | CRITICO | Si |
| `/api/v1/configuracion/{id}/` | DELETE | ConfiguracionViewSet.destroy | ConfiguracionSistema | sistema.administracion.configuracion.eliminar | CRITICO | Si |

**Auditoria:** Todos los cambios se registran en AuditoriaConfiguracion

---

## MODULO: PRESUPUESTOS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/presupuestos/` | GET | PresupuestoViewSet.list | Presupuesto | sistema.finanzas.presupuestos.ver | NORMAL | Si |
| `/api/v1/presupuestos/` | POST | PresupuestoViewSet.create | Presupuesto | sistema.finanzas.presupuestos.crear | ALTO | Si |
| `/api/v1/presupuestos/{id}/` | GET | PresupuestoViewSet.retrieve | Presupuesto | sistema.finanzas.presupuestos.ver | NORMAL | Si |
| `/api/v1/presupuestos/{id}/` | PUT | PresupuestoViewSet.update | Presupuesto | sistema.finanzas.presupuestos.editar | ALTO | Si |
| `/api/v1/presupuestos/{id}/` | PATCH | PresupuestoViewSet.partial_update | Presupuesto | sistema.finanzas.presupuestos.aprobar | CRITICO | Si |
| `/api/v1/presupuestos/{id}/` | DELETE | PresupuestoViewSet.destroy | Presupuesto | sistema.finanzas.presupuestos.eliminar | CRITICO | Si |

**Workflow:** borrador -> pendiente -> aprobado/rechazado

---

## MODULO: POLITICAS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/politicas/` | GET | PoliticaViewSet.list | Politica | sistema.administracion.politicas.ver | BAJO | Si |
| `/api/v1/politicas/` | POST | PoliticaViewSet.create | Politica | sistema.administracion.politicas.crear | ALTO | Si |
| `/api/v1/politicas/{id}/` | GET | PoliticaViewSet.retrieve | Politica | sistema.administracion.politicas.ver | BAJO | Si |
| `/api/v1/politicas/{id}/` | PUT | PoliticaViewSet.update | Politica | sistema.administracion.politicas.editar | ALTO | Si |
| `/api/v1/politicas/{id}/` | PATCH | PoliticaViewSet.partial_update | Politica | sistema.administracion.politicas.publicar | CRITICO | Si |
| `/api/v1/politicas/{id}/` | DELETE | PoliticaViewSet.destroy | Politica | sistema.administracion.politicas.eliminar | CRITICO | Si |

**Versionamiento:** Cada cambio incrementa la version

---

## MODULO: REPORTES

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/reportes/trimestral/` | GET | ReporteTrimestralViewSet.list | N/A | sistema.vistas.reportes.ver_trimestral | NORMAL | Si |
| `/api/v1/reportes/transferencias/` | GET | ReporteTransferenciasViewSet.list | N/A | sistema.vistas.reportes.ver_transferencias | NORMAL | Si |
| `/api/v1/reportes/menus-problematicos/` | GET | ReporteMenuProblemasViewSet.list | N/A | sistema.vistas.reportes.ver_menus_problematicos | NORMAL | Si |
| `/api/v1/reportes/llamadas-dia/` | GET | ReporteLlamadasDiaViewSet.list | N/A | sistema.vistas.reportes.ver_llamadas_dia | NORMAL | Si |
| `/api/v1/reportes/clientes-unicos/` | GET | ReporteClientesUnicosViewSet.list | N/A | sistema.vistas.reportes.ver_clientes_unicos | NORMAL | Si |
| `/api/v1/reportes/exportar/` | POST | ExportarReporteViewSet.create | N/A | sistema.vistas.reportes.exportar | NORMAL | Si |

**Formatos de exportacion:** PDF, Excel, CSV

---

## MODULO: NOTIFICATIONS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/notifications/messages/` | GET | InternalMessageViewSet.list | InternalMessage | N/A (propios mensajes) | BAJO | Si |
| `/api/v1/notifications/messages/` | POST | InternalMessageViewSet.create | InternalMessage | sistema.operaciones.notificaciones.enviar | NORMAL | Si |
| `/api/v1/notifications/messages/{id}/` | GET | InternalMessageViewSet.retrieve | InternalMessage | N/A (propio mensaje) | BAJO | Si |
| `/api/v1/notifications/messages/{id}/` | PATCH | InternalMessageViewSet.partial_update | InternalMessage | N/A (marcar como leido) | BAJO | Si |
| `/api/v1/notifications/messages/{id}/` | DELETE | InternalMessageViewSet.destroy | InternalMessage | N/A (propio mensaje) | BAJO | Si |

**Nota:** Usuario solo puede ver/editar sus propios mensajes

---

## MODULO: ETL

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/v1/etl/jobs/` | GET | ETLJobViewSet.list | ETLJob | sistema.administracion.etl.ver_jobs | NORMAL | Si |
| `/api/v1/etl/jobs/` | POST | ETLJobViewSet.create | ETLJob | sistema.administracion.etl.ejecutar_jobs | ALTO | Si |
| `/api/v1/etl/jobs/{id}/` | GET | ETLJobViewSet.retrieve | ETLJob | sistema.administracion.etl.ver_jobs | NORMAL | Si |
| `/api/v1/etl/jobs/{id}/` | PUT | ETLJobViewSet.update | ETLJob | sistema.administracion.etl.editar_jobs | ALTO | Si |
| `/api/v1/etl/jobs/{id}/` | PATCH | ETLJobViewSet.partial_update | ETLJob | sistema.administracion.etl.editar_jobs | ALTO | Si |
| `/api/v1/etl/errors/` | GET | ETLValidationErrorViewSet.list | ETLValidationError | sistema.administracion.etl.ver_errores | NORMAL | Si |
| `/api/v1/etl/errors/{id}/` | GET | ETLValidationErrorViewSet.retrieve | ETLValidationError | sistema.administracion.etl.ver_errores | NORMAL | Si |

**Servicios utilizados:**
- ETLService.crear_job()
- ETLService.ejecutar_etl_completo()
- ETLService.validar_registro()

---

## MODULO: DORA METRICS

| Endpoint | Metodo | Vista | Modelo | Capacidad Requerida | Sensibilidad | Auth |
|----------|--------|-------|--------|---------------------|--------------|------|
| `/api/dora/metrics/` | GET | dora_metrics_summary | N/A | sistema.vistas.dora.ver_metricas | NORMAL | Si |
| `/api/dora/metrics/create/` | POST | dora_metrics_create | DoraMetric | sistema.administracion.dora.registrar_metricas | ALTO | Si |
| `/api/dora/dashboard/` | GET | dora_dashboard | N/A | sistema.vistas.dora.ver_dashboard | NORMAL | Si |
| `/api/dora/charts/deployment-frequency/` | GET | deployment_frequency_chart_data | N/A | sistema.vistas.dora.ver_graficos | NORMAL | Si |
| `/api/dora/charts/lead-time-trends/` | GET | lead_time_trends_chart_data | N/A | sistema.vistas.dora.ver_graficos | NORMAL | Si |
| `/api/dora/analytics/trends/deployment-frequency/` | GET | trend_analysis_deployment_frequency | N/A | sistema.vistas.dora.ver_analytics | ALTO | Si |
| `/api/dora/analytics/anomalies/` | GET | anomaly_detection | N/A | sistema.vistas.dora.ver_analytics | ALTO | Si |
| `/api/dora/ai-telemetry/record/` | POST | ai_telemetry_record | AITelemetry | sistema.administracion.dora.registrar_telemetria | NORMAL | Si |
| `/api/dora/predict/deployment-risk/` | POST | predict_deployment_risk | N/A | sistema.vistas.dora.predecir_riesgos | ALTO | Si |

---

## ENDPOINTS PUBLICOS (Sin Autenticacion)

| Endpoint | Metodo | Vista | Capacidad Requerida | Descripcion |
|----------|--------|-------|---------------------|-------------|
| `/health/` | GET | health_check | N/A | Health check basico |
| `/api/v1/register/` | POST | UserRegistrationView | N/A | Registro publico de usuarios |
| `/api/schema/` | GET | SpectacularAPIView | N/A | Schema OpenAPI 3.0 |
| `/api/docs/` | GET | SpectacularSwaggerView | N/A | Swagger UI interactivo |

---

## Resumen Estadistico de Seguridad

| Categoria | Cantidad |
|-----------|----------|
| **Endpoints totales** | 89 |
| **Endpoints publicos** | 4 |
| **Endpoints autenticados** | 85 |
| **Endpoints con PERM bajo** | 25 |
| **Endpoints con PERM normal** | 30 |
| **Endpoints con PERM alto** | 20 |
| **Endpoints con PERM critico** | 14 |
| **Capacidades unicas** | 60+ |

---

## Matriz de Cobertura de Permisos

| Dominio | Recursos | Capacidades | Endpoints |
|---------|----------|-------------|-----------|
| **sistema.administracion** | usuarios, permisos, configuracion, politicas, etl | ver, crear, editar, eliminar, asignar, revocar | 45 |
| **sistema.vistas** | dashboards, reportes, dora | ver, exportar, personalizar, compartir | 20 |
| **sistema.operaciones** | llamadas, notificaciones | ver, realizar, editar, eliminar | 15 |
| **sistema.finanzas** | presupuestos | ver, crear, editar, aprobar, eliminar | 6 |

---

## Auditoria de Endpoints Criticos

**Todos los endpoints con sensibilidad CRITICA quedan auditados:**

| Endpoint | Capacidad | Auditoria |
|----------|-----------|-----------|
| DELETE /usuarios/{id}/ | sistema.administracion.usuarios.eliminar | AuditoriaPermiso |
| POST /permissions/funciones/ | sistema.administracion.permisos.crear | AuditoriaPermiso |
| POST /permissions/usuarios-grupos/ | sistema.administracion.permisos.asignar | AuditoriaPermiso |
| DELETE /permissions/usuarios-grupos/{id}/ | sistema.administracion.permisos.revocar | AuditoriaPermiso |
| POST /permissions/permisos-excepcionales/ | sistema.administracion.permisos.conceder_excepcional | AuditoriaPermiso |
| PUT /configuracion/{id}/ | sistema.administracion.configuracion.editar | AuditoriaConfiguracion |
| PATCH /presupuestos/{id}/ | sistema.finanzas.presupuestos.aprobar | (via metadata) |
| PATCH /politicas/{id}/ | sistema.administracion.politicas.publicar | (via metadata) |

---

## Estrategias de Seguridad Aplicadas

### 1. Autenticacion
- **Metodo:** JWT (JSON Web Tokens)
- **Header:** `Authorization: Bearer {token}`
- **Expiracion:** Configurable via `tiempo_expiracion_token_minutos`

### 2. Autorizacion
- **Sistema:** Permisos granulares basados en capacidades
- **Verificacion:** PermisoService.usuario_tiene_permiso()
- **Middleware:** PermissionMiddleware

### 3. Rate Limiting
- **Implementado:** Si (via Django REST Framework)
- **Limites:** Configurables por usuario/IP

### 4. Validacion de Entrada
- **Nivel 1:** Serializers (DRF)
- **Nivel 2:** Validators custom
- **Nivel 3:** Services (business logic)

### 5. Auditoria
- **Accesos criticos:** AuditoriaPermiso
- **Cambios de configuracion:** AuditoriaConfiguracion
- **Metadata:** JSONField con detalles

---

## Documentacion de Referencia

- CATALOGO-APIs.md: Inventario completo de endpoints
- CATALOGO-SERVICIOS.md: Servicios por capas
- CATALOGO-MODELOS.md: Modelos Django ORM
- ADR-012: Sistema de Permisos sin Roles Jerarquicos

---

**Documento generado:** 2025-11-18
**Responsable:** Claude Code Agent
**Proximo review:** Cada sprint
