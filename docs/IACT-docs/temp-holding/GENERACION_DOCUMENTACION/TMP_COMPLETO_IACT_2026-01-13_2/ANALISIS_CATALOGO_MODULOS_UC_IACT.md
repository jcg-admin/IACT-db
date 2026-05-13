# ANALISIS: CATALOGO DE MODULOS Y CASOS DE USO IACT
## Basado en: Casos_de_Usos_desde_la_perspectiva_modular_v_0_0_1

Fecha: 2025-12-22
Fuente: Casos_de_Usos_desde_la_perspectiva_modular__-_v_0_0_1_-_091225.md
Estado: DOCUMENTO OFICIAL DE REFERENCIA PARA UC

--------------------------------------------------------------------------------

## 1. RESUMEN EJECUTIVO

El documento define **8 MODULOS** con **42 CASOS DE USO** distribuidos asi:

| Modulo | ID | Nombre Corto | Casos de Uso | Rango UC |
|--------|----|--------------|--------------| ---------|
| MOD-01 | AUTH | Autenticacion y Sesiones | 5 | UC-001 a UC-005 |
| MOD-02 | USER_IDENTITY | Gestion de Identidades | 5 | UC-006 a UC-010 |
| MOD-03 | RBAC_CORE | Roles, Segmentos, Permisos | 7 | UC-041 a UC-047 |
| MOD-04 | ETL_MONITORING | Supervision ETL | 5 | UC-051 a UC-055 |
| MOD-05 | VIS_REPORTS | Visualizacion y Reportes | 14 | UC-017 a UC-030 |
| MOD-06 | ALERTS | Alertas y Notificaciones | 5 | UC-036 a UC-040 |
| MOD-07 | AUDIT | Auditoria Funcional | 4 | UC-070 a UC-073 |
| MOD-08 | SYS_LOGS | Bitacoras Tecnicas | 4 | UC-080 a UC-083 |
| **TOTAL** | | | **49 UC** | |

Nota: SEC_RULES NO es modulo separado, vive dentro de RBAC_CORE.

--------------------------------------------------------------------------------

## 2. DETALLE POR MODULO

### 2.1 MOD-01 - AUTH (Autenticacion y Sesiones)

Enfoque: Login, logout, sesiones y contrasenas.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-001 | Iniciar sesion en el sistema | Login de usuario |
| UC-002 | Cerrar sesion del sistema | Logout |
| UC-003 | Recuperar contrasena mediante preguntas de seguridad | Recovery sin email |
| UC-004 | Cambiar contrasena | Cambio de password |
| UC-005 | Gestionar sesiones activas del usuario | Ver/cerrar sesiones, timeout |

Apps Django relacionadas: apps.users (views.py - LoginView, LogoutView)
CNST relacionadas: CNST_002 (Gestion Sesiones BD)


### 2.2 MOD-02 - USER_IDENTITY (Gestion de Identidades)

Enfoque: Cuenta, datos, estado, seguridad de perfil.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-006 | Crear cuenta de usuario | Username autogenerado, estado PENDIENTE_CONFIGURACION |
| UC-007 | Actualizar datos de usuario | Nombre, apellidos, estado, unidad organizacional |
| UC-008 | Dar de baja logica a un usuario | Baja logica, deleted_at, deleted_by |
| UC-009 | Gestionar preguntas de seguridad del usuario | Minimo 3 preguntas |
| UC-010 | Consultar perfil de usuario | Datos basicos, roles, estado |

Apps Django relacionadas: apps.users (models.py)
CNST relacionadas: CNST_001 (Comunicaciones Prohibidas - preguntas seguridad)


### 2.3 MOD-03 - RBAC_CORE (Roles, Segmentos y Permisos)

Enfoque: Todo el RBAC, incluye enforcers automaticos.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-041 | Administrar catalogo de roles funcionales | CRUD roles (REPORTS_VIEWER, etc.) |
| UC-042 | Calcular permisos efectivos de un usuario | Precedencia: directo > rol > segmento; SoD |
| UC-043 | Asignar y retirar roles a un usuario | Asignacion de roles |
| UC-044 | Configurar segmentos de datos (Data Segments) | Por centro, servicio, region |
| UC-045 | Asignar permisos directos a un usuario con vigencia | Justificacion obligatoria, max 6 meses |
| UC-046 | Simular acceso de un usuario a un recurso | "Que veria este usuario?" |
| UC-047 | Consultar matriz de roles, segmentos y permisos | Vista consolidada PMO |

Apps Django relacionadas: apps.common.permissions
CNST relacionadas: CNST_005 (Seguridad DRF Checklist)
BR relacionadas: BR_003 (RBAC Flat)


### 2.4 MOD-04 - ETL_MONITORING (Supervision ETL)

Enfoque: Supervisa y valida, NO ejecuta ETL manual.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-051 | Consultar ejecuciones del ETL | Historico jobs, duracion, resultado |
| UC-052 | Ver detalle de una ejecucion de ETL | Rangos, tablas, metricas, errores |
| UC-053 | Consultar disponibilidad de datos por periodo | Trimestres completos/parciales/faltantes |
| UC-054 | Consultar incidencias de calidad de datos | Nulos, inconsistencias, duplicados |
| UC-055 | Reintentar procesamiento logico sobre datos ya extraidos | Reprocesar sin tocar MySQL origen |

Apps Django relacionadas: apps.etl, apps.monitoring
CNST relacionadas: CNST_004 (Actualizacion Datos ETL)
BR relacionadas: BR_002 (ETL Nocturno)


### 2.5 MOD-05 - VIS_REPORTS (Visualizacion y Reportes)

Enfoque: Dashboards + reportes. RBAC decide si ve o exporta.

**Subcategoria: Reportes Tabulares**

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-017 | Consultar reporte trimestral consolidado | Reporte consolidado |
| UC-018 | Consultar reporte de problemas de menu/errores | Errores IVR |
| UC-019 | Consultar reporte de transferencias y rutas de llamada | Rutas de llamadas |

**Subcategoria: Filtros y Criterios**

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-020 | Aplicar filtros de fecha a reportes y dashboards | Presets, rango, limite 2 anos |
| UC-021 | Aplicar filtros por centro, servicio, cola u otros | Filtros de negocio |

**Subcategoria: Exportaciones**

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-022 | Exportar reporte a CSV | Exportacion CSV |
| UC-023 | Exportar reporte a Excel | Exportacion Excel |
| UC-024 | Exportar reporte a PDF | Exportacion PDF |

**Subcategoria: Dashboards**

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-025 | Consultar dashboard principal del IVR | Widgets, ultima actualizacion |
| UC-026 | Consultar widgets de resumen operativo | Llamadas, distribucion, top centros |
| UC-027 | Ver graficos por hora | Grafico temporal |
| UC-028 | Ver graficos por dia | Grafico temporal |
| UC-029 | Ver distribucion por centro/servicio/menu | Grafico distribucion |
| UC-030 | Personalizar layout del dashboard | Max 10 widgets |

Apps Django relacionadas: apps.analytics, apps.reports, apps.exports
CNST relacionadas: CNST_003 (Base Datos Dual Inmutable), CNST_007 (Limites Performance)
BR relacionadas: BR_001 (Inmutabilidad Fuente)


### 2.6 MOD-06 - ALERTS (Alertas y Notificaciones)

Enfoque: Alertas + buzon interno. Todo via InternalMessage, SIN email.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-036 | Configurar alerta operativa | THRESHOLD/ANOMALY/TREND, severidad |
| UC-037 | Recibir notificacion en el buzon interno | Mensaje generico reutilizable |
| UC-038 | Consultar bandeja de notificaciones | Filtrar severidad, tipo, estado |
| UC-039 | Silenciar o posponer una alerta (snooze) | 1h, 8h, 24h, personalizado |
| UC-040 | Confirmar, cerrar o marcar como atendida una alerta | Gestion de alertas |

Apps Django relacionadas: apps.common.notifications, apps.common.models (InternalMessage)
CNST relacionadas: CNST_001 (Comunicaciones Prohibidas - sin email)


### 2.7 MOD-07 - AUDIT (Auditoria Funcional)

Enfoque: Que hizo quien, sobre que, cuando. Acciones de negocio y seguridad.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-070 | Consultar bitacora de auditoria funcional | Login, cambios permisos, exportaciones |
| UC-071 | Filtrar auditoria por usuario, fecha, recurso o tipo | Filtros de busqueda |
| UC-072 | Exportar eventos de auditoria | CSV/Excel con limites |
| UC-073 | Generar reporte de cambios de permisos y roles | Cumplimiento periodico |

Apps Django relacionadas: apps.common.audit
CNST relacionadas: CNST_009 (Logging Auditoria Inmutable)


### 2.8 MOD-08 - SYS_LOGS (Bitacoras Tecnicas)

Enfoque: Logs aplicacion, health, metricas tecnicas. Para soporte/NOC/devops.

| UC ID | Nombre | Descripcion |
|-------|--------|-------------|
| UC-080 | Consultar bitacoras tecnicas del sistema | Logs, errores, warnings |
| UC-081 | Consultar estado de salud del sistema | Health endpoints, servicios |
| UC-082 | Descargar paquetes de logs para analisis externo | Paquete comprimido |
| UC-083 | Consultar metricas tecnicas agregadas | Uso recursos, tiempos respuesta |

Apps Django relacionadas: apps.monitoring
CNST relacionadas: CNST_009 (Logging Auditoria Inmutable)

--------------------------------------------------------------------------------

## 3. MAPEO MODULOS A ESTRUCTURA EXISTENTE

### 3.1 Comparacion con ESTRUCTURA v2.0.0

ESTRUCTURA v2.0.0 define solo 3 UC:
- UC_001_Consultar_Dashboard.rst
- UC_002_Exportar_Reporte.rst
- UC_003_Gestionar_Roles.rst

El documento de modulos define 49 UC.

DISCREPANCIA CRITICA: 3 UC vs 49 UC

### 3.2 Mapeo UC Modulos -> UC ESTRUCTURA v2.0.0

| UC ESTRUCTURA | Equivalente en Modulos |
|---------------|------------------------|
| UC_001_Consultar_Dashboard | UC-025, UC-026, UC-027, UC-028, UC-029 (MOD-05) |
| UC_002_Exportar_Reporte | UC-022, UC-023, UC-024 (MOD-05) |
| UC_003_Gestionar_Roles | UC-041, UC-043 (MOD-03) |

Los 3 UC de ESTRUCTURA son AGREGACIONES de multiples UC de modulos.


### 3.3 Mapeo Apps Django -> Modulos

| App Django | Modulo(s) |
|------------|-----------|
| apps.users | MOD-01 (AUTH), MOD-02 (USER_IDENTITY) |
| apps.common.permissions | MOD-03 (RBAC_CORE) |
| apps.etl | MOD-04 (ETL_MONITORING) |
| apps.analytics | MOD-05 (VIS_REPORTS) |
| apps.reports | MOD-05 (VIS_REPORTS) |
| apps.exports | MOD-05 (VIS_REPORTS) |
| apps.common.notifications | MOD-06 (ALERTS) |
| apps.common.audit | MOD-07 (AUDIT) |
| apps.monitoring | MOD-08 (SYS_LOGS) |
| apps.ivr | Transversal (solo lectura) |

--------------------------------------------------------------------------------

## 4. TRAZABILIDAD PROPUESTA

### 4.1 Cadena Completa con Modulos

```
CNST (Restricciones)
    |
    v
MOD (Modulos) <-- NUEVO NIVEL
    |
    v
BR (Reglas de Negocio)
    |
    v
BReq (Requisitos de Negocio)
    |
    v
UC (Casos de Uso) <-- 49 UC por modulo
    |
    v
FR (Requisitos Funcionales)
    |
    v
TST (Test Cases)
    |
    v
RTM (Matriz Trazabilidad)
```

### 4.2 Mapeo CNST -> MOD

| CNST | Modulo(s) Afectados |
|------|---------------------|
| CNST_001 (Comunicaciones Prohibidas) | MOD-02, MOD-06 |
| CNST_002 (Gestion Sesiones BD) | MOD-01 |
| CNST_003 (Base Datos Dual Inmutable) | MOD-04, MOD-05 |
| CNST_004 (Actualizacion Datos ETL) | MOD-04 |
| CNST_005 (Seguridad DRF Checklist) | MOD-03 |
| CNST_006 (Antipatrones Arquitectura) | Todos |
| CNST_007 (Limites Performance SLA) | MOD-05 |
| CNST_008 (Infraestructura Deployment) | MOD-08 |
| CNST_009 (Logging Auditoria Inmutable) | MOD-07, MOD-08 |
| CNST_010 (Clasificacion Proteccion Datos) | Todos |


### 4.3 Mapeo BR -> MOD

| BR | Modulo(s) Afectados |
|----|---------------------|
| BR_001 (Inmutabilidad Fuente) | MOD-04, MOD-05 |
| BR_002 (ETL Nocturno) | MOD-04 |
| BR_003 (RBAC Flat) | MOD-03 |

--------------------------------------------------------------------------------

## 5. GAPS DE NUMERACION UC

### 5.1 Rangos No Utilizados

| Rango | Estado | Modulo Reservado |
|-------|--------|------------------|
| UC-011 a UC-016 | LIBRE | (reserva futura USER_IDENTITY) |
| UC-031 a UC-035 | LIBRE | (reserva futura VIS_REPORTS) |
| UC-048 a UC-050 | LIBRE | (reserva futura RBAC_CORE) |
| UC-056 a UC-069 | LIBRE | (reserva futura ETL/general) |
| UC-074 a UC-079 | LIBRE | (reserva futura AUDIT) |
| UC-084 a UC-099 | LIBRE | (reserva futura SYS_LOGS) |

Los gaps permiten agregar UC futuros sin renumerar.

--------------------------------------------------------------------------------

## 6. DECISION REQUERIDA

### 6.1 Opciones

**OPCION A: Adoptar los 49 UC de Modulos**
- Reemplaza los 3 UC de ESTRUCTURA v2.0.0
- Granularidad fina, trazabilidad precisa
- Requiere actualizar ESTRUCTURA a v3.0.0
- Trabajo considerable pero completo

**OPCION B: Mantener 3 UC de ESTRUCTURA como agregadores**
- Los 3 UC existentes son "UC padre"
- Los 49 UC de modulos son "UC hijo" o subflujos
- Ejemplo: UC_001 agrupa UC-025 a UC-030
- Menos cambios pero estructura hibrida

**OPCION C: Crear catalogo MOD_ como nuevo dominio**
- Agregar dominio arquitectura_tecnica/modulos/
- Crear MOD_001 a MOD_008 como artefactos
- Los UC referencian su modulo padre
- Mantiene ESTRUCTURA v2.0.0 pero la extiende


### 6.2 Recomendacion

**Se recomienda OPCION C** porque:
1. Respeta ESTRUCTURA v2.0.0 existente
2. Agrega capa de modulos sin romper trazabilidad
3. Los 49 UC se organizan bajo su modulo
4. Permite crear UC detallados gradualmente
5. Compatible con el trabajo ya realizado (BR, BReq, etc.)

--------------------------------------------------------------------------------

## 7. PROXIMOS PASOS

Si se aprueba trabajar por modulos:

1. **Crear catalogo MOD_** (8 artefactos)
   - MOD_001_AUTH.rst
   - MOD_002_USER_IDENTITY.rst
   - MOD_003_RBAC_CORE.rst
   - MOD_004_ETL_MONITORING.rst
   - MOD_005_VIS_REPORTS.rst
   - MOD_006_ALERTS.rst
   - MOD_007_AUDIT.rst
   - MOD_008_SYS_LOGS.rst

2. **Crear UC por modulo** (49 UC usando TPL_002)
   - Iniciar con MOD-01 AUTH (5 UC)
   - O iniciar con MOD-05 VIS_REPORTS (14 UC)

3. **Actualizar SBVR** con IDs de modulos formales

4. **Actualizar trazabilidad BR/BReq** para referenciar modulos

--------------------------------------------------------------------------------

## 8. CONTEO FINAL

| Concepto | Cantidad |
|----------|----------|
| Modulos definidos | 8 |
| Casos de Uso totales | 49 |
| UC por MOD-01 AUTH | 5 |
| UC por MOD-02 USER_IDENTITY | 5 |
| UC por MOD-03 RBAC_CORE | 7 |
| UC por MOD-04 ETL_MONITORING | 5 |
| UC por MOD-05 VIS_REPORTS | 14 |
| UC por MOD-06 ALERTS | 5 |
| UC por MOD-07 AUDIT | 4 |
| UC por MOD-08 SYS_LOGS | 4 |

--------------------------------------------------------------------------------

Fin del Analisis
