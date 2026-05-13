# REFERENCIA GLOBAL: Módulos del Sistema IACT

> **Documento de trabajo** - No es documentación formal
> **Propósito**: Fuente consolidada para generar documentos .rst con PlantUML
> **Basado en**: Análisis de 19 documentos de decisiones arquitectónicas (2025-12-09)

---

## DECISIÓN FINAL: 8 MÓDULOS FUNCIONALES

| Código | Nombre Doc | Nombre Código | Descripción |
|--------|------------|---------------|-------------|
| MOD_Auth | Auth | auth | Autenticación y Sesiones |
| MOD_Users | Users | users | Gestión de Identidades |
| MOD_Access | Access | access | Roles, Permisos, Segmentos + SEC_RULES |
| MOD_Pipeline | Pipeline | pipeline | Supervisión del ETL |
| MOD_Reports | Reports | reports | Dashboards y Reportes |
| MOD_Alerts | Alerts | alerts | Alertas y Notificaciones |
| MOD_Audit | Audit | audit | Auditoría Funcional |
| MOD_Logs | Logs | logs | Bitácoras Técnicas |

---

## MOD_Auth

### Propósito
Controlar el acceso inicial al sistema y la vigencia de las sesiones.

### PUEDE hacer
- Login con credenciales (usuario + contraseña)
- Logout (cierre de sesión)
- Generación y validación de JWT (access + refresh)
- Gestión de sesiones en BD
- Timeout de sesión (15 min inactividad)
- Throttling de intentos fallidos (5 intentos / 5 min)
- Validación de IP + User-Agent
- Recuperación de contraseña vía preguntas de seguridad
- Cambio de contraseña (usuario autenticado)
- Sesión única por usuario

### NO PUEDE hacer
- Definir roles ni permisos (eso es MOD_Access)
- Gestionar datos de usuario más allá de credenciales (eso es MOD_Users)
- Enviar emails (recuperación solo por buzón interno)
- Lógica de alertas por intentos fallidos (eso es MOD_Alerts)
- Implementar reglas avanzadas de acceso (eso es MOD_Access/SEC_RULES)

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-001 | Inicio de sesión | Must |
| UC-002 | Cierre de sesión | Must |
| UC-003 | Recuperación de contraseña | Must |
| UC-004 | Cambio de contraseña | Must |
| UC-005 | Gestión de sesiones en BD | Must |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_001 | NO email - recuperación solo vía buzón interno |
| CNST_002 | Sesiones en BD (django.contrib.sessions.backends.db), no Redis |
| CNST_002 | Sesión única por usuario |
| CNST_002 | Timeout 15 minutos |
| CNST_007 | Throttling: 5 intentos / 5 min |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Users | Consume | Obtiene ID de usuario autenticado |
| MOD_Access | Consume | Solicita resolución inicial de permisos |
| MOD_Audit | Produce | Envía eventos de login/logout |

---

## MOD_Users

### Propósito
Gestionar la existencia, estado y datos básicos de las cuentas de usuario.

### PUEDE hacer
- Alta de usuario (crear cuenta)
- Modificación de datos de usuario
- Baja lógica de usuario (nunca eliminación física)
- Listar usuarios con filtros
- Gestionar estados de cuenta (activo, bloqueado, pendiente_configuración)
- Configurar preguntas de seguridad
- Generar contraseña temporal
- Notificar vía buzón interno

### NO PUEDE hacer
- Asignar roles (eso es MOD_Access)
- Asignar segmentos de datos (eso es MOD_Access)
- Asignar permisos directos (eso es MOD_Access)
- Calcular permisos efectivos (eso es MOD_Access)
- Validar reglas SoD (eso es MOD_Access)
- Enviar emails

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-006 | Crear usuario | Must |
| UC-007 | Modificar usuario | Must |
| UC-008 | Baja lógica de usuario | Must |
| UC-009 | Listar usuarios | Must |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_001 | NO email - notificaciones solo buzón interno |
| CNST_005 | Bajas siempre lógicas, nunca físicas |
| CNST_005 | Username autogenerado |
| CNST_005 | Estado inicial PENDIENTE_CONFIGURACION |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Auth | Productor | Provee identidad para autenticación |
| MOD_Access | Consume | Solicita asignación de roles/segmentos |
| MOD_Audit | Produce | Envía eventos de creación/modificación |
| MOD_Alerts | Consume | Usa buzón interno para notificaciones |

---

## MOD_Access

### Propósito
Definir y administrar qué puede hacer cada usuario (roles, permisos, segmentos) y aplicar las reglas de seguridad en tiempo de ejecución.

### Componentes Internos

#### 1. RBAC_CORE (Administración) - VISIBLE AL USUARIO
- Pantallas de administración de roles
- Endpoints CRUD para roles, permisos, segmentos
- Configuración de permisos por rol
- Asignación de roles a usuarios
- Gestión de segmentos de datos
- Gestión de permisos directos (con justificación + vencimiento)
- Configuración de reglas SoD

#### 2. SEC_RULES (Enforcement) - AUTOMÁTICO, NO VISIBLE
- Middleware de validación de permisos
- Decoradores DRF para protección de endpoints
- Cálculo de permisos efectivos
- Aplicación de precedencia (Directo > Rol > Segmento)
- Validación de SoD en tiempo real
- Enforcement de restricciones globales:
  - NO email
  - BD IVR solo lectura
  - Límites de exportación
  - Throttling
  - NO real-time

### PUEDE hacer
- Administrar catálogo de roles (R001-R018)
- Asignar/quitar roles a usuarios
- Configurar permisos por rol
- Gestionar segmentos de datos (DataSegment)
- Gestionar permisos directos (DirectPermission) con justificación
- Aplicar reglas SoD (Separation of Duties)
- Calcular permisos efectivos por usuario/contexto
- Bloquear acciones que violen restricciones
- Aplicar precedencia: Permiso Directo > Rol > Segmento

### NO PUEDE hacer
- Mostrar UI funcional de negocio (reportes, dashboards)
- Crear/modificar datos de usuario (eso es MOD_Users)
- Autenticar usuarios (eso es MOD_Auth)
- Ejecutar lógica de negocio de otros dominios

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-010 | Asignar roles | Must |
| UC-011 | Gestionar permisos por rol | Must |
| UC-041 | Asignar segmento de datos | Must |
| UC-042 | Asignar permisos directos | Must |
| UC-043 | Configurar reglas SoD | Should |
| UC-044 | Consultar permisos efectivos | Should |
| UC-045 | Gestionar catálogo de roles | Must |
| UC-046 | Gestionar catálogo de permisos | Must |
| UC-047 | Auditar cambios de permisos | Must |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_005 | Flat RBAC NIST (sin jerarquías) |
| CNST_005 | 18 roles funcionales máximo |
| CNST_005 | Precedencia: Directo > Rol > Segmento |
| CNST_005 | SoD obligatorio (SYSTEM_ADMIN ⚔️ AUDIT_VIEWER) |
| CNST_005 | Permisos directos: justificación mín. 20 chars |
| CNST_005 | Permisos directos: vencimiento máx. 6 meses |

### Reglas SoD Definidas

| Rol A | Rol B | Razón |
|-------|-------|-------|
| SYSTEM_ADMIN | AUDIT_VIEWER | Separar administración de auditoría |
| REPORT_ADMIN | REPORT_EXPORTER | Separar configuración de extracción |
| USER_ADMIN | PERMISSION_ADMIN | Separar gestión usuarios de permisos |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Users | Consume | Recibe solicitudes de asignación |
| MOD_Auth | Productor | Provee permisos efectivos |
| MOD_Audit | Produce | Envía eventos de cambios de permisos |
| TODOS | Consume | Todos consultan permisos vía SEC_RULES |

---

## MOD_Pipeline

### Propósito
Supervisar, monitorear y validar el estado del proceso ETL y la disponibilidad de datos para reportes.

### PUEDE hacer
- Consultar histórico de ejecuciones ETL (ETLExecution)
- Consultar errores del ETL (ETLError)
- Ver última ejecución exitosa
- Ver próxima ejecución programada
- Consultar disponibilidad de datos por período
- Ver qué trimestres/fechas están cargados
- Identificar desfasajes de datos (>48h sin carga)
- Mostrar indicadores de calidad básica (% nulos, inconsistencias)
- Solicitar reintento controlado (solo roles autorizados)

### NO PUEDE hacer
- Ejecutar el ETL directamente (lo hace el scheduler)
- Modificar la configuración del pipeline
- Hacer reportes de negocio (eso es MOD_Reports)
- Consultar BD IVR directamente
- Transformar datos
- Exponer logs técnicos crudos (eso es MOD_Logs)

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-050 | Supervisar ejecuciones del ETL | Must |
| UC-051 | Consultar errores del ETL | Must |
| UC-052 | Consultar disponibilidad de datos | Must |
| UC-053 | Solicitar reintento ETL | Should |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_003 | BD IVR = solo SELECT (readonly) |
| CNST_003 | ETL no puede escribir en MySQL |
| CNST_003 | Frecuencia ETL: 6-12 horas |
| CNST_003 | NO real-time, NO WebSockets, NO SSE |
| CNST_003 | Mostrar "Última actualización" / "Próxima actualización" |

### Tablas/Modelos Relacionados

| Tabla | Descripción |
|-------|-------------|
| ETLExecution | Registro de ejecuciones |
| ETLError | Errores por ejecución |
| DataAvailability | Períodos/fechas cargados |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Logs | Produce | Envía logs técnicos de ejecución |
| MOD_Reports | Productor | Alimenta datos para reportes |
| Scheduler | Externo | APScheduler/Celery dispara ETL |

---

## MOD_Reports

### Propósito
Entregar información visual y tabular al usuario final mediante dashboards predefinidos, reportes operativos y exportaciones controladas.

### PUEDE hacer
- Mostrar dashboards operativos predefinidos
- Mostrar reportes tabulares basados en SQL
- Aplicar filtros por fecha, centro, servicio
- Visualizar gráficos (por hora, día, centro)
- Visualizar KPIs estáticos
- Exportar a CSV (con límites)
- Exportar a Excel (con límites)
- Exportar a PDF (con límites)
- Respetar segmentos de datos del usuario
- Mostrar "Última actualización" de datos

### NO PUEDE hacer
- Ejecutar ETL o agendar jobs
- Consultar BD IVR directamente
- Mostrar datos en tiempo real
- Personalizar dashboards por usuario
- Crear queries ad-hoc (Query Builder)
- Análisis exploratorio interactivo
- OLAP / Drill-down dinámico
- Enviar reportes por email

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-017 | Reporte trimestral | Must |
| UC-018 | Reporte de problemas de menú | Must |
| UC-019 | Reporte de transferencias | Must |
| UC-020 | Filtro por fecha | Must |
| UC-021 | Filtro por centro | Must |
| UC-022 | Exportación CSV | Must |
| UC-023 | Exportación Excel | Must |
| UC-024 | Exportación PDF | Should |
| UC-025 | Dashboard principal | Must |
| UC-027 | Gráficos por hora | Should |
| UC-028 | Gráficos por día | Should |
| UC-029 | Distribución por centro | Should |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_003 | Datos siempre desfasados según último ETL |
| CNST_003 | NO real-time |
| CNST_006 | Rango máximo de fechas: 2 años |
| CNST_006 | Tiempos de respuesta máximos definidos |
| CNST_007 | Límites de registros por tipo exportación |
| CNST_007 | Límites diarios por rol |
| CNST_001 | Sin envío por email |

### Límites de Exportación

| Tipo | Límite Registros | Límite Diario |
|------|------------------|---------------|
| CSV | 100,000 | 10 por día |
| Excel | 50,000 | 5 por día |
| PDF | 10,000 | 3 por día |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Access | Consume | Consulta permisos VIEW/EXPORT |
| MOD_Pipeline | Consume | Usa datos procesados del ETL |
| MOD_Audit | Produce | Registra cada exportación |

---

## MOD_Alerts

### Propósito
Detectar condiciones sobre datos/eventos y notificar a usuarios mediante buzón interno.

### PUEDE hacer
- Crear/configurar alertas con reglas
- Definir umbrales (threshold, trend)
- Configurar destinatarios (máx. 50)
- Evaluar condiciones periódicamente
- Enviar notificaciones vía buzón interno
- Pausar/reanudar alertas (snooze)
- Consultar historial de alertas disparadas
- Consolidar alertas repetidas
- Gestionar severidades (INFO, WARNING, CRITICAL)

### NO PUEDE hacer
- Enviar emails
- Consultar BD IVR directamente
- Evaluación en tiempo real extremo
- Generar reportes (eso es MOD_Reports)
- Implementar lógica de permisos

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-036 | Crear alerta | Must |
| UC-037 | Recibir notificación interna | Must |
| UC-038 | Pausar alerta (snooze) | Should |
| UC-039 | Historial de alertas | Must |
| UC-040 | Gestión de destinatarios | Must |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_001 | TODO por buzón interno, NADA de correo |
| CNST_004 | Máximo 50 destinatarios por alerta |
| CNST_004 | Consolidación de alertas repetidas |
| CNST_004 | Frecuencias definidas (no real-time extremo) |
| CNST_004 | Severidades: INFO, WARNING, CRITICAL |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| MOD_Pipeline | Consume | Usa métricas procesadas |
| MOD_Access | Consume | Valida permisos de configuración |
| MOD_Audit | Produce | Registra creación/modificación alertas |

---

## MOD_Audit

### Propósito
Registrar y consultar acciones de negocio relevantes para cumplimiento, trazabilidad y seguridad funcional.

### PUEDE hacer
- Registrar eventos de negocio (append-only)
- Capturar: quién, qué, cuándo, sobre qué, resultado
- Almacenar valores antes/después para cambios críticos
- Consultar registros con filtros (usuario, acción, período)
- Generar reportes de auditoría
- Mantener registros por años (cumplimiento)

### NO PUEDE hacer
- Modificar registros existentes (inmutable)
- Eliminar registros
- Registrar logs técnicos (eso es MOD_Logs)
- Definir reglas de acceso (usa MOD_Access)

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-060 | Registrar evento de auditoría | Must |
| UC-061 | Consultar bitácora de auditoría | Must |
| UC-062 | Generar reporte de auditoría | Should |
| UC-063 | Exportar auditoría | Should |

### Eventos que se Auditan

| Evento | Módulo Origen | Datos Capturados |
|--------|---------------|------------------|
| Login/Logout | MOD_Auth | user, IP, timestamp, resultado |
| Crear usuario | MOD_Users | user_creador, user_creado, datos |
| Modificar usuario | MOD_Users | user, cambios antes/después |
| Asignar rol | MOD_Access | user, rol, asignador |
| Cambiar permisos | MOD_Access | user, permiso, justificación |
| Exportar reporte | MOD_Reports | user, reporte, registros, formato |
| Crear alerta | MOD_Alerts | user, alerta, config |
| Modificar alerta | MOD_Alerts | user, alerta, cambios |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_008 | Registros inmutables (append-only) |
| CNST_008 | Retención: 2+ años |
| CNST_008 | SoD: auditores ≠ administradores |
| CNST_008 | No PII innecesaria |

### Campos del Registro de Auditoría

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | UUID | Identificador único |
| timestamp | DateTime | Momento del evento |
| user_id | FK | Usuario que realizó acción |
| action | Enum | Tipo de acción |
| resource_type | String | Tipo de recurso afectado |
| resource_id | String | ID del recurso |
| ip_address | String | IP del usuario |
| user_agent | String | Navegador/cliente |
| result | Enum | SUCCESS / FAIL |
| details | JSON | Detalles adicionales |
| values_before | JSON | Estado anterior (si aplica) |
| values_after | JSON | Estado posterior (si aplica) |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| TODOS | Consume | Todos los módulos envían eventos |
| MOD_Access | Consume | Consulta permisos de visualización |

---

## MOD_Logs

### Propósito
Registrar y consultar eventos técnicos para debugging, monitoreo y soporte operativo.

### PUEDE hacer
- Registrar logs estructurados (JSON)
- Manejar niveles: DEBUG, INFO, WARNING, ERROR, CRITICAL
- Capturar stack traces en errores
- Registrar métricas de performance
- Registrar eventos de infraestructura
- Rotar logs por política (30-90 días)
- Consultar logs con filtros técnicos
- Integrar con sistemas externos (ELK, Loki)

### NO PUEDE hacer
- Registrar eventos de negocio (eso es MOD_Audit)
- Exponer PII sin enmascarar
- Retener logs indefinidamente
- Definir reglas de seguridad

### Casos de Uso

| UC | Nombre | Prioridad |
|----|--------|-----------|
| UC-070 | Consultar logs del sistema | Should |
| UC-071 | Filtrar logs por nivel/servicio | Should |
| UC-072 | Exportar logs técnicos | Could |

### Tipos de Logs

| Tipo | Nivel Típico | Ejemplo |
|------|--------------|---------|
| ETL | INFO/ERROR | "ETL run_id=123 completado en 182s" |
| API | INFO/WARN | "Timeout en endpoint /api/reports" |
| Auth | WARN/ERROR | "JWT mal formado" |
| DB | ERROR | "Conexión rechazada a MySQL" |
| System | INFO/CRIT | "Espacio disco >80%" |

### Restricciones Aplicables

| CNST | Descripción |
|------|-------------|
| CNST_008 | No loggear contraseñas, tokens |
| CNST_008 | PII enmascarada |
| CNST_008 | Formato JSON estructurado |
| CNST_008 | Retención: 30-90 días según tipo |

### Campos del Log Técnico

| Campo | Tipo | Descripción |
|-------|------|-------------|
| timestamp | DateTime | Momento del evento |
| level | Enum | DEBUG/INFO/WARN/ERROR/CRIT |
| service | String | Servicio origen |
| module | String | Módulo del sistema |
| message | String | Mensaje descriptivo |
| request_id | UUID | Para correlación |
| trace_id | UUID | Para distributed tracing |
| stack_trace | Text | Si es error |
| duration_ms | Int | Si es métrica |
| extra | JSON | Datos adicionales |

### Dependencias

| Módulo | Tipo | Descripción |
|--------|------|-------------|
| TODOS | Consume | Todos los módulos envían logs |
| MOD_Pipeline | Principal | Mayor volumen de logs ETL |

---

## DIFERENCIACIÓN CLAVE: AUDIT vs LOGS

| Aspecto | MOD_Audit | MOD_Logs |
|---------|-----------|----------|
| Pregunta | "¿Quién hizo qué?" | "¿Qué pasó técnicamente?" |
| Vista | Negocio/Cumplimiento | Técnico/Operación |
| Audiencia | Auditores, seguridad | Devs, SRE, soporte |
| Mutabilidad | Inmutable | Rotable |
| Retención | Años | 30-90 días |
| Ejemplo | "Usuario X exportó reporte Y" | "Query tardó 5200ms (SLA: 5000ms)" |

---

## RESUMEN DE DEPENDENCIAS ENTRE MÓDULOS

```
MOD_Auth ──────► MOD_Users (consulta identidad)
    │
    └─────────► MOD_Access (consulta permisos)
    │
    └─────────► MOD_Audit (envía eventos)

MOD_Users ─────► MOD_Access (solicita asignación roles)
    │
    └─────────► MOD_Audit (envía eventos)
    │
    └─────────► MOD_Alerts (buzón interno)

MOD_Access ────► MOD_Audit (envía eventos)
    │
    └─────────► TODOS (provee permisos via SEC_RULES)

MOD_Pipeline ──► MOD_Logs (envía logs técnicos)
    │
    └─────────► MOD_Reports (alimenta datos)

MOD_Reports ───► MOD_Access (consulta permisos)
    │
    └─────────► MOD_Audit (registra exportaciones)
    │
    └─────────► MOD_Pipeline (consume datos ETL)

MOD_Alerts ────► MOD_Audit (envía eventos)
    │
    └─────────► MOD_Access (valida permisos)

MOD_Audit ─────► MOD_Access (consulta permisos visualización)

MOD_Logs ──────► (sin dependencias, solo recibe de todos)
```

---

## FLUJOS DE DATOS PRINCIPALES

| FD | Nombre | Módulos |
|----|--------|---------|
| FD-01 | Autenticación | Auth → Users → Access |
| FD-02 | Resolución Permisos | Auth → Access |
| FD-03 | Gestión Identidades | Users → Access → Audit |
| FD-04 | Ejecución ETL | Pipeline → Logs |
| FD-05 | Supervisión ETL | Pipeline |
| FD-06 | Visualización | Reports → Access |
| FD-07 | Exportación | Reports → Access → Audit |
| FD-08 | Alertas | Alerts → Access → Audit |
| FD-09 | Auditoría | Audit (transversal) |
| FD-10 | Bitácoras | Logs (transversal) |
| FD-11 | Enforcement | Access/SEC_RULES → Audit/Logs |
| FD-12 | Mensajería | Alerts → Users |

---

## MÓDULOS QUE NO EXISTEN

Explícitamente excluidos del Sistema IACT:

- ❌ Exploración interactiva de datos
- ❌ Query Builder para el usuario
- ❌ Modelos analíticos / Machine Learning
- ❌ Identificación automatizada de patrones
- ❌ Series de tiempo avanzadas
- ❌ Detección de anomalías
- ❌ Interfaz OLAP / Drill-down dinámico
- ❌ Tableros configurables por usuario
- ❌ KPIs autogenerados con lógica dinámica
- ❌ Métricas no incluidas en los SQL existentes
- ❌ Envío de emails (ningún módulo)

---

## RESTRICCIONES GLOBALES (CNST)

| CNST | Descripción | Módulos Afectados |
|------|-------------|-------------------|
| CNST_001 | NO email bajo ninguna circunstancia | TODOS |
| CNST_002 | Sesiones en BD, única, 15 min timeout | Auth |
| CNST_003 | BD IVR solo lectura, ETL 6-12h, NO real-time | Pipeline, Reports |
| CNST_004 | Alertas solo buzón interno, máx 50 destinatarios | Alerts |
| CNST_005 | Flat RBAC, 18 roles, SoD, permisos con vencimiento | Access |
| CNST_006 | Reportes: rango máx 2 años, timeouts definidos | Reports |
| CNST_007 | Límites exportación por tipo y rol, throttling | Reports, Access |
| CNST_008 | Audit inmutable, logs sin PII, retención definida | Audit, Logs |

---

*Documento de referencia generado: 2026-01-03*
*Fuente: Análisis consolidado de 19 documentos de decisiones arquitectónicas*
*Uso: Base para generar documentación formal en RST con PlantUML*
