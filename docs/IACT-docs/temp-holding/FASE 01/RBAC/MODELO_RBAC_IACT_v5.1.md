# MODELO RBAC IACT - v5.1

## Sistema IACT - IVR Analytics & Customer Tracking

---

**Proyecto:** IACT-2025-001  
**Documento:** IACT-RBAC-001-v5.1  
**Título:** Modelo de Control de Acceso Basado en Funciones Atómicas  
**Versión:** 5.1 - ENFOQUE SIN PRETENSIONES (Adaptado IACT)  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación

---

## CONTROL DE CAMBIOS

| Versión | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0-3.0 | 17-18 Oct 2025 | Versiones preliminares | Equipo |
| 4.0 | 19 Oct 2025 | Modelo híbrido con 18 roles | Equipo |
| 5.0 | 03 Ene 2026 | Enfoque Sin Pretensiones | Equipo |
| **5.1** | **03 Ene 2026** | **Adaptación a 8 módulos IACT + Clean Code** | **Equipo** |

### Cambios v5.0 → v5.1-IACT

| Aspecto | v5.0 | v5.1-IACT |
|---------|------|-----------|
| Funciones | 57 genéricas | 48 alineadas a módulos IACT |
| Dominios | 9 genéricos | 8 módulos IACT |
| Análisis | Incluido | **ELIMINADO** (no existe en IACT) |
| Nomenclatura | bundles | agrupadores |
| SoD | JSON | Tablas normalizadas 3FN |

---

## ALINEACIÓN CON MÓDULOS IACT

Este modelo RBAC está diseñado para los **8 módulos funcionales** del sistema IACT:

| Código | Módulo | Funciones RBAC |
|--------|--------|----------------|
| MOD_Auth | Autenticación y Sesiones | 4 funciones |
| MOD_Users | Gestión de Identidades | 10 funciones |
| MOD_Access | Roles, Permisos, Segmentos | 6 funciones |
| MOD_Pipeline | Supervisión del ETL | 4 funciones |
| MOD_Reports | Dashboards y Reportes | 8 funciones |
| MOD_Alerts | Alertas y Notificaciones | 6 funciones |
| MOD_Audit | Auditoría Funcional | 4 funciones |
| MOD_Logs | Bitácoras Técnicas | 2 funciones |
| **TOTAL** | - | **44 funciones** |

### Restricciones Globales Aplicables (CNST)

| CNST | Restricción | Impacto en RBAC |
|------|-------------|-----------------|
| CNST_001 | NO email bajo ninguna circunstancia | Notificaciones solo buzón interno |
| CNST_002 | Sesión única, 15 min timeout | Gestión de sesiones en MOD_Auth |
| CNST_003 | BD IVR solo lectura, NO real-time | Sin funciones de escritura IVR |
| CNST_004 | Alertas solo buzón interno, máx 50 dest. | Límites en funciones de alertas |
| CNST_005 | Flat RBAC, SoD, permisos con vencimiento | Modelo base del documento |
| CNST_006 | Reportes: rango máx 2 años | Límites en funciones de reportes |
| CNST_007 | Límites exportación, throttling | Control en funciones de export |
| CNST_008 | Audit inmutable, logs sin PII | Funciones de auditoría solo lectura |

### Lo que NO existe en IACT (sin funciones RBAC)

- ❌ Query Builder / Consultas ad-hoc
- ❌ Análisis exploratorio interactivo
- ❌ OLAP / Drill-down dinámico
- ❌ Machine Learning / Detección de anomalías
- ❌ Dashboards personalizables por usuario
- ❌ Envío de emails
- ❌ Consulta directa a BD IVR

---

## TABLA DE CONTENIDO

1. [Filosofía del Modelo](#1-filosofia)
2. [Arquitectura IACT](#2-arquitectura)
3. [Catálogo de Funciones por Módulo](#3-catalogo-funciones)
4. [Catálogo de Agrupadores](#4-catalogo-agrupadores)
5. [Separación de Funciones (SoD)](#5-sod)
6. [Segmentos de Datos](#6-segmentos)
7. [Permisos Temporales](#7-permisos-temporales)
8. [Modelo de Datos](#8-modelo-datos)
9. [Implementación SQL](#9-sql)
10. [Mapeo Funciones → Casos de Uso](#10-mapeo-uc)
11. [Migración](#11-migracion)

---

<a name="1-filosofia"></a>

## 1. FILOSOFÍA DEL MODELO

### 1.1 Principio Central

> **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona**

### 1.2 Enfoque Sin Pretensiones

**❌ INCORRECTO - Con Pretensiones:**

```
Roles basados en títulos:
- USERS_FULL_MANAGER      → Define QUÉ ES la persona
- SYSTEM_ADMIN            → Cargo jerárquico
```

**✅ CORRECTO - Sin Pretensiones:**

```
Funciones basadas en acciones:
- crea_usuarios           → Describe QUÉ PUEDE HACER
- ve_reportes             → Acción concreta
- exporta_csv             → Capacidad específica
```

### 1.3 Integración con SEC_RULES

El módulo **MOD_Access** tiene dos componentes:

| Componente | Visible | Descripción |
|------------|---------|-------------|
| RBAC_CORE | Sí | Pantallas de administración de funciones |
| SEC_RULES | No | Middleware de enforcement automático |

Las funciones atómicas son administradas por RBAC_CORE y validadas por SEC_RULES.

---

<a name="2-arquitectura"></a>

## 2. ARQUITECTURA IACT

### 2.1 Diagrama de Módulos y Funciones

```
┌─────────────────────────────────────────────────────────────┐
│                        USUARIO                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ tiene asignadas (N:M)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   FUNCIONES ATÓMICAS (44)                    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ MOD_Auth (4)     │ MOD_Users (10)  │ MOD_Access (6) │    │
│  ├──────────────────┼─────────────────┼────────────────┤    │
│  │ gestiona_sesiones│ crea_usuarios   │ asigna_funcion │    │
│  │ cierra_sesion    │ modifica_usuario│ revoca_funcion │    │
│  │ resetea_password │ elimina_usuario │ ve_asignaciones│    │
│  │ ve_sesiones      │ lista_usuarios  │ asigna_agrup   │    │
│  │                  │ busca_usuarios  │ gestiona_sod   │    │
│  │                  │ bloquea_usuario │ gestiona_segm  │    │
│  │                  │ desbloquea_usr  │                │    │
│  │                  │ reactiva_usuario│                │    │
│  │                  │ asigna_segmento │                │    │
│  │                  │ ve_usuarios     │                │    │
│  └──────────────────┴─────────────────┴────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ MOD_Pipeline (4) │ MOD_Reports (8) │ MOD_Alerts (6) │    │
│  ├──────────────────┼─────────────────┼────────────────┤    │
│  │ ve_estado_etl    │ ve_reportes     │ ve_alertas     │    │
│  │ ve_errores_etl   │ ve_dashboard    │ configura_alrt │    │
│  │ ve_disponibilidad│ filtra_reportes │ conf_alrt_eqpo │    │
│  │ solicita_reintnt │ exporta_csv     │ pausa_alertas  │    │
│  │                  │ exporta_excel   │ elimina_alertas│    │
│  │                  │ exporta_pdf     │ ve_historial   │    │
│  │                  │ ve_kpis         │                │    │
│  │                  │ ve_graficos     │                │    │
│  └──────────────────┴─────────────────┴────────────────┘    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ MOD_Audit (4)              │ MOD_Logs (2)           │    │
│  ├────────────────────────────┼────────────────────────┤    │
│  │ ve_auditoria               │ ve_logs_tecnicos       │    │
│  │ busca_auditoria            │ exporta_logs           │    │
│  │ exporta_auditoria          │                        │    │
│  │ genera_reporte_compliance  │                        │    │
│  └────────────────────────────┴────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Flujo de Autorización (SEC_RULES)

```
┌─────────────────────────────────────────────────────────────┐
│ CAPA 1: AUTENTICACIÓN (MOD_Auth)                             │
│ ─────────────────────────────────                            │
│ • Login → JWT (access + refresh)                             │
│ • Sesión única por usuario (CNST_002)                        │
│ • Timeout 15 minutos (CNST_002)                              │
│ • Throttling: 5 intentos / 5 min (CNST_007)                  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 2: AUTORIZACIÓN (MOD_Access/SEC_RULES)                  │
│ ─────────────────────────────────────────────                │
│ • ¿Usuario tiene función requerida? → Sí/No                  │
│ • Precedencia: Permiso Temporal > Función Asignada           │
│ • Validación SoD en tiempo real                              │
│ • Enforcement de CNST (límites exportación, etc.)            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 3: SEGREGACIÓN DE DATOS                                 │
│ ─────────────────────────────                                │
│ • Usuario pertenece a 1 segmento                             │
│ • Filtro automático WHERE segmento_id = @usuario_segmento    │
│ • Cross-segment solo con función especial                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 4: AUDITORÍA (MOD_Audit)                                │
│ ─────────────────────────────                                │
│ • Registro inmutable de toda acción (CNST_008)               │
│ • Checksum SHA-256 por registro                              │
│ • Retención mínima 2 años                                    │
└─────────────────────────────────────────────────────────────┘
```

---

<a name="3-catalogo-funciones"></a>

## 3. CATÁLOGO DE FUNCIONES POR MÓDULO

### 3.1 Resumen

| Módulo | Código | Cantidad |
|--------|--------|----------|
| MOD_Auth | AUT | 4 |
| MOD_Users | USR | 10 |
| MOD_Access | ACC | 6 |
| MOD_Pipeline | PIP | 4 |
| MOD_Reports | RPT | 8 |
| MOD_Alerts | ALR | 6 |
| MOD_Audit | AUD | 4 |
| MOD_Logs | LOG | 2 |
| **TOTAL** | - | **44** |

---

### 3.2 MOD_Auth: Autenticación y Sesiones (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUT-001 | `gestiona_sesiones` | auth:sesiones | UC-005 | Gestiona sesiones activas de usuarios |
| AUT-002 | `cierra_sesion_usuario` | auth:cerrar_sesion | UC-005 | Cierra sesión de otro usuario |
| AUT-003 | `resetea_password` | auth:reset_password | UC-003 | Genera contraseña temporal |
| AUT-004 | `ve_sesiones_activas` | auth:ver_sesiones | UC-005 | Ve todas las sesiones activas |

**Detalle:**

#### AUT-001: gestiona_sesiones

```yaml
Función: gestiona_sesiones
Capacidad: auth:sesiones
Módulo: MOD_Auth
Descripción: Gestiona sesiones activas de usuarios

Acciones permitidas:
  - Ver todas las sesiones activas
  - Ver detalles: IP, User-Agent, última actividad
  - Cerrar sesión de usuario específico
  - Cerrar todas las sesiones (emergencia)

Restricciones CNST:
  - CNST_002: Sesión única por usuario
  - CNST_002: Timeout 15 minutos

Caso de Uso: UC-005
Auditoría: Nivel CRITICAL - SESSION_MANAGE
```

#### AUT-003: resetea_password

```yaml
Función: resetea_password
Capacidad: auth:reset_password
Módulo: MOD_Auth
Descripción: Genera contraseña temporal para usuario

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
```

---

### 3.3 MOD_Users: Gestión de Identidades (10 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| USR-001 | `crea_usuarios` | users:crear | UC-006 | Crea nuevos usuarios |
| USR-002 | `ve_usuarios` | users:leer | UC-009 | Consulta información de usuarios |
| USR-003 | `modifica_usuarios` | users:modificar | UC-007 | Modifica datos de usuarios |
| USR-004 | `elimina_usuarios` | users:eliminar | UC-008 | Baja lógica de usuarios |
| USR-005 | `lista_usuarios` | users:listar | UC-009 | Lista usuarios con filtros |
| USR-006 | `busca_usuarios` | users:buscar | UC-009 | Busca usuarios por criterios |
| USR-007 | `bloquea_usuarios` | users:bloquear | UC-007 | Bloquea acceso de usuario |
| USR-008 | `desbloquea_usuarios` | users:desbloquear | UC-007 | Desbloquea usuario |
| USR-009 | `reactiva_usuarios` | users:reactivar | UC-007 | Reactiva usuario inactivo |
| USR-010 | `asigna_segmento` | users:asignar_segmento | UC-041 | Asigna segmento de datos |

**Detalle de funciones clave:**

#### USR-001: crea_usuarios

```yaml
Función: crea_usuarios
Capacidad: users:crear
Módulo: MOD_Users
Descripción: Crea nuevos usuarios en el sistema

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
```

#### USR-004: elimina_usuarios

```yaml
Función: elimina_usuarios
Capacidad: users:eliminar
Módulo: MOD_Users
Descripción: Baja lógica de usuarios (NUNCA eliminación física)

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
```

---

### 3.4 MOD_Access: Roles, Permisos, Segmentos (6 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ACC-001 | `asigna_funciones` | access:asignar | UC-010, UC-042 | Asigna funciones a usuarios |
| ACC-002 | `revoca_funciones` | access:revocar | UC-010 | Revoca funciones de usuarios |
| ACC-003 | `ve_asignaciones` | access:ver | UC-011, UC-044 | Ve asignaciones y permisos efectivos |
| ACC-004 | `asigna_agrupadores` | access:asignar_agrupador | UC-010 | Asigna agrupadores completos |
| ACC-005 | `gestiona_sod` | access:sod | UC-043 | Configura restricciones SoD |
| ACC-006 | `gestiona_segmentos` | access:segmentos | UC-045, UC-046 | Gestiona catálogo de segmentos |

**Detalle:**

#### ACC-001: asigna_funciones

```yaml
Función: asigna_funciones
Capacidad: access:asignar
Módulo: MOD_Access (RBAC_CORE)
Descripción: Asigna funciones atómicas o permisos directos a usuarios

Tipos de asignación:
  1. Función permanente (sin vencimiento)
  2. Permiso directo temporal (con vencimiento)

Validaciones:
  - Usuario debe estar ACTIVO
  - Función debe estar activa
  - NO debe violar restricciones SoD
  - Para permisos directos:
    - Justificación mínimo 20 caracteres (CNST_005)
    - Vencimiento máximo 6 meses (CNST_005)

Precedencia (CNST_005):
  - Permiso Directo > Función Asignada > Segmento

Casos de Uso: UC-010, UC-042
Auditoría: Nivel WARNING - FUNCTION_ASSIGN
```

#### ACC-005: gestiona_sod

```yaml
Función: gestiona_sod
Capacidad: access:sod
Módulo: MOD_Access (RBAC_CORE)
Descripción: Configura restricciones de Separación de Funciones

Acciones:
  - Ver restricciones SoD existentes
  - Crear nueva restricción
  - Modificar restricción
  - Desactivar restricción

SoD Obligatorio (CNST_005):
  - SYSTEM_ADMIN ⚔️ AUDIT_VIEWER
  - USER_ADMIN ⚔️ PERMISSION_ADMIN

Caso de Uso: UC-043
Auditoría: Nivel CRITICAL - SOD_CONFIGURE
```

---

### 3.5 MOD_Pipeline: Supervisión del ETL (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| PIP-001 | `ve_estado_etl` | pipeline:ver_estado | UC-050 | Ve estado y ejecuciones del ETL |
| PIP-002 | `ve_errores_etl` | pipeline:ver_errores | UC-051 | Consulta errores del ETL |
| PIP-003 | `ve_disponibilidad_datos` | pipeline:disponibilidad | UC-052 | Consulta disponibilidad de datos |
| PIP-004 | `solicita_reintento_etl` | pipeline:reintento | UC-053 | Solicita reintento controlado |

**Detalle:**

#### PIP-001: ve_estado_etl

```yaml
Función: ve_estado_etl
Capacidad: pipeline:ver_estado
Módulo: MOD_Pipeline
Descripción: Ve estado y ejecuciones del ETL

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
```

#### PIP-004: solicita_reintento_etl

```yaml
Función: solicita_reintento_etl
Capacidad: pipeline:reintento
Módulo: MOD_Pipeline
Descripción: Solicita reintento controlado del ETL

Restricciones:
  - Solo roles autorizados
  - Requiere justificación
  - No puede ejecutar directamente (solo solicita)
  - Warning si fuera de horario normal

Caso de Uso: UC-053
Auditoría: Nivel WARNING - ETL_RETRY_REQUEST
```

---

### 3.6 MOD_Reports: Dashboards y Reportes (8 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| RPT-001 | `ve_reportes` | reports:ver | UC-017,018,019 | Ve reportes tabulares |
| RPT-002 | `ve_dashboard` | reports:dashboard | UC-025 | Ve dashboard principal |
| RPT-003 | `filtra_reportes` | reports:filtrar | UC-020, UC-021 | Aplica filtros fecha/centro |
| RPT-004 | `exporta_csv` | reports:exportar_csv | UC-022 | Exporta a CSV |
| RPT-005 | `exporta_excel` | reports:exportar_excel | UC-023 | Exporta a Excel |
| RPT-006 | `exporta_pdf` | reports:exportar_pdf | UC-024 | Exporta a PDF |
| RPT-007 | `ve_kpis` | reports:kpis | UC-025 | Ve KPIs estáticos |
| RPT-008 | `ve_graficos` | reports:graficos | UC-027,028,029 | Ve gráficos (hora, día, centro) |

**Detalle de funciones clave:**

#### RPT-001: ve_reportes

```yaml
Función: ve_reportes
Capacidad: reports:ver
Módulo: MOD_Reports
Descripción: Ve reportes tabulares predefinidos

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
```

#### RPT-004: exporta_csv

```yaml
Función: exporta_csv
Capacidad: reports:exportar_csv
Módulo: MOD_Reports
Descripción: Exporta reportes a formato CSV

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
```

#### RPT-005: exporta_excel

```yaml
Función: exporta_excel
Capacidad: reports:exportar_excel
Módulo: MOD_Reports
Descripción: Exporta reportes a formato Excel (.xlsx)

Límites (CNST_007):
  - Máximo: 50,000 registros
  - Límite diario: 5 exportaciones
  - Timeout: 90 segundos

Caso de Uso: UC-023
Auditoría: Nivel WARNING - EXPORT_EXCEL
```

#### RPT-006: exporta_pdf

```yaml
Función: exporta_pdf
Capacidad: reports:exportar_pdf
Módulo: MOD_Reports
Descripción: Exporta reportes a formato PDF

Límites (CNST_007):
  - Máximo: 10,000 registros
  - Límite diario: 3 exportaciones
  - Timeout: 120 segundos

Caso de Uso: UC-024
Auditoría: Nivel WARNING - EXPORT_PDF
```

---

### 3.7 MOD_Alerts: Alertas y Notificaciones (6 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ALR-001 | `ve_alertas` | alerts:ver | UC-039 | Ve alertas propias |
| ALR-002 | `configura_alertas` | alerts:configurar | UC-036 | Configura alertas personales |
| ALR-003 | `configura_alertas_equipo` | alerts:config_equipo | UC-040 | Alertas para equipo |
| ALR-004 | `pausa_alertas` | alerts:pausar | UC-038 | Pausa alertas (snooze) |
| ALR-005 | `elimina_alertas` | alerts:eliminar | UC-036 | Elimina alertas propias |
| ALR-006 | `ve_historial_alertas` | alerts:historial | UC-039 | Ve historial de alertas |

**Detalle:**

#### ALR-002: configura_alertas

```yaml
Función: configura_alertas
Capacidad: alerts:configurar
Módulo: MOD_Alerts
Descripción: Configura alertas personales con umbrales

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
```

#### ALR-003: configura_alertas_equipo

```yaml
Función: configura_alertas_equipo
Capacidad: alerts:config_equipo
Módulo: MOD_Alerts
Descripción: Configura alertas para usuarios del mismo segmento

Restricciones CNST:
  - CNST_004: Máximo 50 destinatarios
  - Solo usuarios del mismo segmento
  - Notificación solo buzón interno

Caso de Uso: UC-040
Auditoría: Nivel WARNING - ALERT_CONFIGURE_TEAM
```

---

### 3.8 MOD_Audit: Auditoría Funcional (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUD-001 | `ve_auditoria` | audit:ver | UC-061 | Ve logs de auditoría |
| AUD-002 | `busca_auditoria` | audit:buscar | UC-061 | Busca en logs con filtros |
| AUD-003 | `exporta_auditoria` | audit:exportar | UC-063 | Exporta logs de auditoría |
| AUD-004 | `genera_reporte_compliance` | audit:compliance | UC-062 | Genera reportes de compliance |

**Detalle:**

#### AUD-001: ve_auditoria

```yaml
Función: ve_auditoria
Capacidad: audit:ver
Módulo: MOD_Audit
Descripción: Ve logs de auditoría del sistema

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
  - ⚔️ Incompatible con administra_sistema
  - ⚔️ Incompatible con gestión de usuarios

Caso de Uso: UC-061
Auditoría: Nivel INFO - AUDIT_VIEW
```

---

### 3.9 MOD_Logs: Bitácoras Técnicas (2 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| LOG-001 | `ve_logs_tecnicos` | logs:ver | UC-070, UC-071 | Ve logs técnicos del sistema |
| LOG-002 | `exporta_logs` | logs:exportar | UC-072 | Exporta logs técnicos |

**Detalle:**

#### LOG-001: ve_logs_tecnicos

```yaml
Función: ve_logs_tecnicos
Capacidad: logs:ver
Módulo: MOD_Logs
Descripción: Ve logs técnicos del sistema

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
```

---

### 3.10 Tabla Resumen: 44 Funciones IACT

| # | ID | Función | Módulo |
|---|-----|---------|--------|
| 1 | AUT-001 | gestiona_sesiones | MOD_Auth |
| 2 | AUT-002 | cierra_sesion_usuario | MOD_Auth |
| 3 | AUT-003 | resetea_password | MOD_Auth |
| 4 | AUT-004 | ve_sesiones_activas | MOD_Auth |
| 5 | USR-001 | crea_usuarios | MOD_Users |
| 6 | USR-002 | ve_usuarios | MOD_Users |
| 7 | USR-003 | modifica_usuarios | MOD_Users |
| 8 | USR-004 | elimina_usuarios | MOD_Users |
| 9 | USR-005 | lista_usuarios | MOD_Users |
| 10 | USR-006 | busca_usuarios | MOD_Users |
| 11 | USR-007 | bloquea_usuarios | MOD_Users |
| 12 | USR-008 | desbloquea_usuarios | MOD_Users |
| 13 | USR-009 | reactiva_usuarios | MOD_Users |
| 14 | USR-010 | asigna_segmento | MOD_Users |
| 15 | ACC-001 | asigna_funciones | MOD_Access |
| 16 | ACC-002 | revoca_funciones | MOD_Access |
| 17 | ACC-003 | ve_asignaciones | MOD_Access |
| 18 | ACC-004 | asigna_agrupadores | MOD_Access |
| 19 | ACC-005 | gestiona_sod | MOD_Access |
| 20 | ACC-006 | gestiona_segmentos | MOD_Access |
| 21 | PIP-001 | ve_estado_etl | MOD_Pipeline |
| 22 | PIP-002 | ve_errores_etl | MOD_Pipeline |
| 23 | PIP-003 | ve_disponibilidad_datos | MOD_Pipeline |
| 24 | PIP-004 | solicita_reintento_etl | MOD_Pipeline |
| 25 | RPT-001 | ve_reportes | MOD_Reports |
| 26 | RPT-002 | ve_dashboard | MOD_Reports |
| 27 | RPT-003 | filtra_reportes | MOD_Reports |
| 28 | RPT-004 | exporta_csv | MOD_Reports |
| 29 | RPT-005 | exporta_excel | MOD_Reports |
| 30 | RPT-006 | exporta_pdf | MOD_Reports |
| 31 | RPT-007 | ve_kpis | MOD_Reports |
| 32 | RPT-008 | ve_graficos | MOD_Reports |
| 33 | ALR-001 | ve_alertas | MOD_Alerts |
| 34 | ALR-002 | configura_alertas | MOD_Alerts |
| 35 | ALR-003 | configura_alertas_equipo | MOD_Alerts |
| 36 | ALR-004 | pausa_alertas | MOD_Alerts |
| 37 | ALR-005 | elimina_alertas | MOD_Alerts |
| 38 | ALR-006 | ve_historial_alertas | MOD_Alerts |
| 39 | AUD-001 | ve_auditoria | MOD_Audit |
| 40 | AUD-002 | busca_auditoria | MOD_Audit |
| 41 | AUD-003 | exporta_auditoria | MOD_Audit |
| 42 | AUD-004 | genera_reporte_compliance | MOD_Audit |
| 43 | LOG-001 | ve_logs_tecnicos | MOD_Logs |
| 44 | LOG-002 | exporta_logs | MOD_Logs |

---

<a name="4-catalogo-agrupadores"></a>

## 4. CATÁLOGO DE AGRUPADORES

### 4.1 Concepto

> **Agrupador = Mecanismo de asignación masiva de funciones**
> - NO es un rol
> - Internamente crea N asignaciones individuales

### 4.2 Lista de 10 Agrupadores IACT

| ID | Agrupador | Funciones | Descripción |
|----|-----------|-----------|-------------|
| AGR-001 | agr_operador_basico | 5 | Consulta básica de reportes |
| AGR-002 | agr_operador_reportes | 8 | Acceso completo a reportes |
| AGR-003 | agr_supervisor | 12 | Supervisor con alertas de equipo |
| AGR-004 | agr_exportador | 3 | Exportación de reportes |
| AGR-005 | agr_gestor_alertas | 6 | Gestión de alertas |
| AGR-006 | agr_admin_usuarios | 12 | Administración de usuarios |
| AGR-007 | agr_admin_acceso | 6 | Administración de acceso |
| AGR-008 | agr_auditor | 4 | Auditoría y compliance |
| AGR-009 | agr_admin_pipeline | 4 | Supervisión de ETL |
| AGR-010 | agr_admin_logs | 2 | Bitácoras técnicas |

### 4.3 Detalle de Agrupadores

#### AGR-001: agr_operador_basico

```yaml
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
```

#### AGR-002: agr_operador_reportes

```yaml
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
```

#### AGR-003: agr_supervisor

```yaml
Agrupador: agr_supervisor
Descripción: Supervisor de equipo con alertas
Cantidad: 12 funciones

Funciones incluidas:
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

Usuarios estimados: 20-40
```

#### AGR-004: agr_exportador

```yaml
Agrupador: agr_exportador
Descripción: Capacidades de exportación
Cantidad: 3 funciones

Funciones incluidas:
  - exporta_csv (RPT-004)
  - exporta_excel (RPT-005)
  - exporta_pdf (RPT-006)

Nota: Se combina con otros agrupadores
Usuarios estimados: 30-50
```

#### AGR-006: agr_admin_usuarios

```yaml
Agrupador: agr_admin_usuarios
Descripción: Administración completa de usuarios
Cantidad: 12 funciones

Funciones incluidas:
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

Usuarios estimados: 2-5

SoD: ⚔️ Incompatible con agr_auditor
```

#### AGR-008: agr_auditor

```yaml
Agrupador: agr_auditor
Descripción: Auditoría y compliance (solo lectura)
Cantidad: 4 funciones

Funciones incluidas:
  - ve_auditoria (AUD-001)
  - busca_auditoria (AUD-002)
  - exporta_auditoria (AUD-003)
  - genera_reporte_compliance (AUD-004)

Restricciones:
  - Solo lectura (CNST_008)
  - Inmutable

SoD (CNST_005):
  - ⚔️ Incompatible con agr_admin_usuarios
  - ⚔️ Incompatible con agr_admin_pipeline

Usuarios estimados: 2-5
```

#### AGR-009: agr_admin_pipeline

```yaml
Agrupador: agr_admin_pipeline
Descripción: Supervisión del ETL
Cantidad: 4 funciones

Funciones incluidas:
  - ve_estado_etl (PIP-001)
  - ve_errores_etl (PIP-002)
  - ve_disponibilidad_datos (PIP-003)
  - solicita_reintento_etl (PIP-004)

SoD: ⚔️ Incompatible con agr_auditor

Usuarios estimados: 2-3
```

---

### 4.4 Matriz Agrupador → Módulos

```
                          AUT  USR  ACC  PIP  RPT  ALR  AUD  LOG
Agrupador                  4   10    6    4    8    6    4    2
───────────────────────────────────────────────────────────────
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
```

---

<a name="5-sod"></a>

## 5. SEPARACIÓN DE FUNCIONES (SoD)

### 5.1 Concepto

> **SoD (Separation of Duties):** Restricciones obligatorias que impiden combinaciones de funciones riesgosas. Definido en CNST_005.

### 5.2 Restricciones SoD IACT

| ID | Nombre | Grupo A | Grupo B | Razón | CNST |
|----|--------|---------|---------|-------|------|
| SOD-001 | sod_admin_auditoria | PIP-001,PIP-002,PIP-003,PIP-004 | AUD-001,AUD-002,AUD-003,AUD-004 | Quien opera NO audita | CNST_005 |
| SOD-002 | sod_usuarios_auditoria | USR-001,USR-003,USR-004,USR-007 | AUD-001,AUD-002,AUD-003 | Quien gestiona usuarios NO audita | CNST_005 |
| SOD-003 | sod_acceso_auditoria | ACC-001,ACC-002,ACC-005 | AUD-001,AUD-002 | Quien gestiona acceso NO audita | CNST_005 |

### 5.3 Detalle de Restricciones

#### SOD-001: sod_admin_auditoria

```yaml
Restricción: sod_admin_auditoria
Descripción: Quien opera/administra el pipeline NO debe auditarlo
Base: CNST_005 (SYSTEM_ADMIN ⚔️ AUDIT_VIEWER)

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
```

#### SOD-002: sod_usuarios_auditoria

```yaml
Restricción: sod_usuarios_auditoria
Descripción: Quien gestiona usuarios NO debe auditar sus propias acciones
Base: CNST_005 (USER_ADMIN ⚔️ PERMISSION_ADMIN)

Grupo A (Gestión Usuarios):
  - crea_usuarios (USR-001)
  - modifica_usuarios (USR-003)
  - elimina_usuarios (USR-004)
  - bloquea_usuarios (USR-007)

Grupo B (Auditoría):
  - ve_auditoria (AUD-001)
  - busca_auditoria (AUD-002)
  - exporta_auditoria (AUD-003)

Agrupadores afectados:
  - agr_admin_usuarios ⚔️ agr_auditor
```

---

<a name="6-segmentos"></a>

## 6. SEGMENTOS DE DATOS

### 6.1 Catálogo de Segmentos IACT

| Código | Nombre | Descripción |
|--------|--------|-------------|
| OP | DATOS_OPERATIVOS | Datos operación IVR: llamadas, menús |
| FI | DATOS_FINANCIEROS | Costos y facturación |
| TE | DATOS_TECNICOS | Infraestructura y rendimiento |
| SU | DATOS_SUPERVISION | Supervisión y control |
| CA | DATOS_CALIDAD | Métricas de calidad |

### 6.2 Reglas de Segmento

```yaml
Regla 1: Usuario = 1 Segmento
  - Cada usuario pertenece a exactamente un segmento
  - Campo segmento_id es NOT NULL

Regla 2: Filtro Automático (SEC_RULES)
  - MOD_Access/SEC_RULES aplica WHERE segmento_id = @usuario_segmento
  - Usuario solo ve datos de su segmento
  - Automático y transparente

Regla 3: Restricciones CNST
  - CNST_003: Datos según último ETL
  - CNST_006: Rango máximo 2 años
```

---

<a name="7-permisos-temporales"></a>

## 7. PERMISOS TEMPORALES

### 7.1 Concepto (CNST_005)

> **Permiso Directo Temporal:** Función otorgada con vencimiento obligatorio.

### 7.2 Restricciones CNST_005

```yaml
Justificación:
  - Obligatoria
  - Mínimo 20 caracteres

Vencimiento:
  - Obligatorio
  - Máximo 6 meses

Precedencia:
  - Permiso Directo > Función Asignada > Segmento
```

### 7.3 Casos de Uso

```yaml
Caso 1: Cobertura vacaciones
  Usuario: maria.lopez
  Función: crea_usuarios (USR-001)
  Duración: 15 días
  Justificación: "Cobertura vacaciones admin principal 15-30 enero"

Caso 2: Auditoría externa
  Usuario: auditor.externo
  Función: exporta_auditoria (AUD-003)
  Duración: 1 mes
  Justificación: "Auditoría externa SOX Q1 2026"
```

---

<a name="8-modelo-datos"></a>

## 8. MODELO DE DATOS

### 8.1 Diagrama Entidad-Relación

```
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
│  usuarios_funciones │       │
├─────────────────────┤       │
│ usuario_id (FK)     │       │
│ funcion_id (FK)     │───────┼──────┐
│ origen_agrupador    │       │      │
│ justificacion       │       │      │
└─────────────────────┘       │      │
                              │      │
┌─────────────────────┐       │      │
│  segmentos_datos    │◄──────┘      │
├─────────────────────┤              │
│ segmento_id (PK)    │              │
│ codigo              │              │
│ nombre              │              │
└─────────────────────┘              │
                                     │
┌─────────────────────┐              │
│     funciones       │◄─────────────┘
├─────────────────────┤
│ funcion_id (PK)     │
│ nombre              │
│ modulo              │
│ capacidad           │
└─────────────────────┘
          │
          │ N:M
          ▼
┌─────────────────────┐       ┌─────────────────────┐
│agrupador_funciones  │       │    agrupadores      │
├─────────────────────┤       ├─────────────────────┤
│ agrupador_id (FK)   │──────►│ agrupador_id (PK)   │
│ funcion_id (FK)     │       │ nombre              │
└─────────────────────┘       └─────────────────────┘

┌─────────────────────┐       ┌─────────────────────┐
│separacion_funciones │       │ sep_funciones_det   │
├─────────────────────┤       ├─────────────────────┤
│ restriccion_id (PK) │◄─────►│ restriccion_id (FK) │
│ nombre              │       │ funcion_id (FK)     │
│ razon               │       │ grupo (A/B)         │
└─────────────────────┘       └─────────────────────┘

┌─────────────────────┐
│ permisos_temporales │
├─────────────────────┤
│ usuario_id (FK)     │
│ funcion_id (FK)     │
│ fecha_vencimiento   │
│ justificacion       │
│ estado              │
└─────────────────────┘

┌─────────────────────┐
│   log_auditoria     │  ← INMUTABLE (CNST_008)
├─────────────────────┤
│ log_id (PK)         │
│ fecha_evento        │
│ usuario_id          │
│ tipo_accion         │
│ modulo              │
│ resultado           │
│ checksum_registro   │
└─────────────────────┘
```

---

<a name="9-sql"></a>

## 9. IMPLEMENTACIÓN SQL

### 9.1 Tabla: funciones (44 funciones IACT)

```sql
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
```

### 9.2 Tabla: agrupadores (10 agrupadores IACT)

```sql
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
```

### 9.3 Tabla: agrupador_funciones

```sql
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
('AGR-001', 'RPT-001', 1),
('AGR-001', 'RPT-002', 2),
('AGR-001', 'RPT-003', 3),
('AGR-001', 'ALR-001', 4),
('AGR-001', 'ALR-006', 5);

-- AGR-002: agr_operador_reportes (8)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-002', 'RPT-001', 1),
('AGR-002', 'RPT-002', 2),
('AGR-002', 'RPT-003', 3),
('AGR-002', 'RPT-007', 4),
('AGR-002', 'RPT-008', 5),
('AGR-002', 'ALR-001', 6),
('AGR-002', 'ALR-002', 7),
('AGR-002', 'ALR-006', 8);

-- AGR-003: agr_supervisor (12)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-003', 'RPT-001', 1),
('AGR-003', 'RPT-002', 2),
('AGR-003', 'RPT-003', 3),
('AGR-003', 'RPT-004', 4),
('AGR-003', 'RPT-005', 5),
('AGR-003', 'RPT-007', 6),
('AGR-003', 'RPT-008', 7),
('AGR-003', 'ALR-001', 8),
('AGR-003', 'ALR-002', 9),
('AGR-003', 'ALR-003', 10),
('AGR-003', 'ALR-004', 11),
('AGR-003', 'ALR-006', 12);

-- AGR-004: agr_exportador (3)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-004', 'RPT-004', 1),
('AGR-004', 'RPT-005', 2),
('AGR-004', 'RPT-006', 3);

-- AGR-005: agr_gestor_alertas (6)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-005', 'ALR-001', 1),
('AGR-005', 'ALR-002', 2),
('AGR-005', 'ALR-003', 3),
('AGR-005', 'ALR-004', 4),
('AGR-005', 'ALR-005', 5),
('AGR-005', 'ALR-006', 6);

-- AGR-006: agr_admin_usuarios (12)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-006', 'USR-001', 1),
('AGR-006', 'USR-002', 2),
('AGR-006', 'USR-003', 3),
('AGR-006', 'USR-004', 4),
('AGR-006', 'USR-005', 5),
('AGR-006', 'USR-006', 6),
('AGR-006', 'USR-007', 7),
('AGR-006', 'USR-008', 8),
('AGR-006', 'USR-009', 9),
('AGR-006', 'USR-010', 10),
('AGR-006', 'ACC-001', 11),
('AGR-006', 'ACC-002', 12);

-- AGR-007: agr_admin_acceso (6)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-007', 'ACC-001', 1),
('AGR-007', 'ACC-002', 2),
('AGR-007', 'ACC-003', 3),
('AGR-007', 'ACC-004', 4),
('AGR-007', 'ACC-005', 5),
('AGR-007', 'ACC-006', 6);

-- AGR-008: agr_auditor (4)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-008', 'AUD-001', 1),
('AGR-008', 'AUD-002', 2),
('AGR-008', 'AUD-003', 3),
('AGR-008', 'AUD-004', 4);

-- AGR-009: agr_admin_pipeline (4)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-009', 'PIP-001', 1),
('AGR-009', 'PIP-002', 2),
('AGR-009', 'PIP-003', 3),
('AGR-009', 'PIP-004', 4);

-- AGR-010: agr_admin_logs (2)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-010', 'LOG-001', 1),
('AGR-010', 'LOG-002', 2);
```

### 9.4 Tablas SoD (Normalizadas)

```sql
CREATE TABLE separacion_funciones (
    restriccion_id VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    razon VARCHAR(500) NOT NULL,
    cnst_referencia VARCHAR(20) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT uk_sod_nombre UNIQUE (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE separacion_funciones_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restriccion_id VARCHAR(20) NOT NULL,
    funcion_id VARCHAR(20) NOT NULL,
    grupo CHAR(1) NOT NULL,
    
    CONSTRAINT fk_sfd_restriccion FOREIGN KEY (restriccion_id) 
        REFERENCES separacion_funciones(restriccion_id),
    CONSTRAINT fk_sfd_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT chk_sfd_grupo CHECK (grupo IN ('A', 'B'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar restricciones SoD IACT
INSERT INTO separacion_funciones (restriccion_id, nombre, descripcion, razon, cnst_referencia) VALUES
('SOD-001', 'sod_admin_auditoria', 'Quien opera pipeline NO audita', 'SYSTEM_ADMIN ⚔️ AUDIT_VIEWER', 'CNST_005'),
('SOD-002', 'sod_usuarios_auditoria', 'Quien gestiona usuarios NO audita', 'USER_ADMIN ⚔️ auditoría', 'CNST_005'),
('SOD-003', 'sod_acceso_auditoria', 'Quien gestiona acceso NO audita', 'Separación de poderes', 'CNST_005');

-- SOD-001 detalle
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-001', 'PIP-001', 'A'),
('SOD-001', 'PIP-002', 'A'),
('SOD-001', 'PIP-003', 'A'),
('SOD-001', 'PIP-004', 'A'),
('SOD-001', 'AUD-001', 'B'),
('SOD-001', 'AUD-002', 'B'),
('SOD-001', 'AUD-003', 'B'),
('SOD-001', 'AUD-004', 'B');

-- SOD-002 detalle
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-002', 'USR-001', 'A'),
('SOD-002', 'USR-003', 'A'),
('SOD-002', 'USR-004', 'A'),
('SOD-002', 'USR-007', 'A'),
('SOD-002', 'AUD-001', 'B'),
('SOD-002', 'AUD-002', 'B'),
('SOD-002', 'AUD-003', 'B');

-- SOD-003 detalle
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-003', 'ACC-001', 'A'),
('SOD-003', 'ACC-002', 'A'),
('SOD-003', 'ACC-005', 'A'),
('SOD-003', 'AUD-001', 'B'),
('SOD-003', 'AUD-002', 'B');
```

---

<a name="10-mapeo-uc"></a>

## 10. MAPEO FUNCIONES → CASOS DE USO

### 10.1 Por Módulo

#### MOD_Auth

| Función | Casos de Uso |
|---------|--------------|
| gestiona_sesiones | UC-005 |
| cierra_sesion_usuario | UC-005 |
| resetea_password | UC-003 |
| ve_sesiones_activas | UC-005 |

#### MOD_Users

| Función | Casos de Uso |
|---------|--------------|
| crea_usuarios | UC-006 |
| modifica_usuarios | UC-007 |
| elimina_usuarios | UC-008 |
| lista_usuarios, busca_usuarios | UC-009 |
| bloquea_usuarios, desbloquea_usuarios | UC-007 |
| asigna_segmento | UC-041 |

#### MOD_Access

| Función | Casos de Uso |
|---------|--------------|
| asigna_funciones | UC-010, UC-042 |
| revoca_funciones | UC-010 |
| ve_asignaciones | UC-011, UC-044 |
| gestiona_sod | UC-043 |
| gestiona_segmentos | UC-045, UC-046 |

#### MOD_Pipeline

| Función | Casos de Uso |
|---------|--------------|
| ve_estado_etl | UC-050 |
| ve_errores_etl | UC-051 |
| ve_disponibilidad_datos | UC-052 |
| solicita_reintento_etl | UC-053 |

#### MOD_Reports

| Función | Casos de Uso |
|---------|--------------|
| ve_reportes | UC-017, UC-018, UC-019 |
| ve_dashboard | UC-025 |
| filtra_reportes | UC-020, UC-021 |
| exporta_csv | UC-022 |
| exporta_excel | UC-023 |
| exporta_pdf | UC-024 |
| ve_graficos | UC-027, UC-028, UC-029 |

#### MOD_Alerts

| Función | Casos de Uso |
|---------|--------------|
| configura_alertas | UC-036 |
| ve_alertas | UC-037 |
| pausa_alertas | UC-038 |
| ve_historial_alertas | UC-039 |
| configura_alertas_equipo | UC-040 |

#### MOD_Audit

| Función | Casos de Uso |
|---------|--------------|
| ve_auditoria, busca_auditoria | UC-061 |
| genera_reporte_compliance | UC-062 |
| exporta_auditoria | UC-063 |

#### MOD_Logs

| Función | Casos de Uso |
|---------|--------------|
| ve_logs_tecnicos | UC-070, UC-071 |
| exporta_logs | UC-072 |

---

<a name="11-migracion"></a>

## 11. MIGRACIÓN

### 11.1 Desde v4.0 (18 roles) a v5.1-IACT (44 funciones)

| Rol v4.0 | Agrupador v5.1-IACT | Notas |
|----------|---------------------|-------|
| USERS_FULL_MANAGER | AGR-006 agr_admin_usuarios | |
| USERS_VIEWER | ve_usuarios + lista_usuarios | Funciones individuales |
| REPORTS_VIEWER | AGR-001 agr_operador_basico | |
| REPORTS_EXPORTER | AGR-001 + AGR-004 | Combinar agrupadores |
| SYSTEM_ADMIN | AGR-009 agr_admin_pipeline | |
| AUDIT_VIEWER | AGR-008 agr_auditor | SoD con SYSTEM_ADMIN |
| ALERTS_MANAGER | AGR-005 agr_gestor_alertas | |

### 11.2 Pasos de Migración

1. Crear tablas v5.1-IACT
2. Insertar 44 funciones alineadas a módulos
3. Insertar 10 agrupadores
4. Insertar restricciones SoD con referencia CNST
5. Migrar asignaciones
6. Verificar SoD
7. Desactivar tablas v4.0

---

## 12. RESUMEN

### 12.1 Métricas del Modelo

| Aspecto | Valor |
|---------|-------|
| **Filosofía** | Sin Pretensiones |
| **Módulos IACT** | 8 |
| **Funciones atómicas** | 44 |
| **Agrupadores** | 10 |
| **Restricciones SoD** | 3 |
| **Segmentos** | 5 |
| **Restricciones CNST** | 8 |

### 12.2 Alineación con Restricciones CNST

| CNST | Funciones Afectadas |
|------|---------------------|
| CNST_001 (NO email) | resetea_password, configura_alertas |
| CNST_002 (Sesión única) | gestiona_sesiones |
| CNST_003 (BD IVR readonly) | ve_estado_etl, ve_reportes |
| CNST_004 (Alertas buzón) | configura_alertas, configura_alertas_equipo |
| CNST_005 (Flat RBAC, SoD) | Todo el modelo |
| CNST_006 (Rango 2 años) | filtra_reportes |
| CNST_007 (Límites export) | exporta_csv, exporta_excel, exporta_pdf |
| CNST_008 (Audit inmutable) | ve_auditoria, busca_auditoria |

### 12.3 Lo que NO existe (sin funciones)

- ❌ Query Builder
- ❌ Análisis exploratorio
- ❌ OLAP / Drill-down
- ❌ Machine Learning
- ❌ Dashboards personalizables
- ❌ Envío de emails

---

**FIN DEL DOCUMENTO**

**Versión:** 5.1 - IACT (Adaptado a 8 módulos)  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación  
**Base:** REFERENCIA_GLOBAL_MODULOS_IACT.md
