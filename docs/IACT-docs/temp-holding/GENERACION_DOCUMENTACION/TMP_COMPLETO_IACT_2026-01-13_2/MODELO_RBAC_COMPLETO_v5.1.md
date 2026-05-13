# MODELO RBAC COMPLETO - v5.1

## Sistema IACT - IVR Analytics & Customer Tracking

---

**Proyecto:** IACT-2025-001  
**Documento:** IACT-RBAC-001-v5.1  
**Título:** Modelo de Control de Acceso Basado en Funciones Atómicas  
**Versión:** 5.1 - ENFOQUE SIN PRETENSIONES (Clean Code)  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación

---

## CONTROL DE CAMBIOS

| Versión | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0-3.0 | 17-18 Oct 2025 | Versiones preliminares | Equipo |
| 4.0 | 19 Oct 2025 | Modelo híbrido con 18 roles | Equipo |
| 5.0 | 03 Ene 2026 | Enfoque Sin Pretensiones con funciones atómicas | Equipo |
| **5.1** | **03 Ene 2026** | **Clean Code: Tablas normalizadas 3FN, nomenclatura consistente** | **Equipo** |

### Cambios Principales v5.0 → v5.1

| Aspecto | v5.0 | v5.1 (Clean Code) |
|---------|------|-------------------|
| Nombre agrupadores | bundles | agrupadores |
| SoD en BD | JSON arrays | Tablas relacionales normalizadas |
| Nomenclatura | Mixta inglés/español | Español consistente |
| Estructura BD | Parcialmente normalizada | 3FN completa |

---

## TABLA DE CONTENIDO

1. [Filosofía del Modelo](#1-filosofia)
2. [Arquitectura Sin Pretensiones](#2-arquitectura)
3. [Catálogo de Funciones Atómicas](#3-catalogo-funciones)
4. [Catálogo de Agrupadores](#4-catalogo-agrupadores)
5. [Separación de Funciones (SoD)](#5-sod)
6. [Segmentos de Datos](#6-segmentos)
7. [Permisos Directos Temporales](#7-permisos-directos)
8. [Modelo de Datos](#8-modelo-datos)
9. [Implementación SQL Completa](#9-sql)
10. [Ejemplos de Uso](#10-ejemplos)
11. [Migración v4.0 → v5.1](#11-migracion)
12. [Casos de Uso Relacionados](#12-casos-uso)

---

<a name="1-filosofia"></a>

## 1. FILOSOFÍA DEL MODELO

### 1.1 Principio Central

> **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona**

### 1.2 Enfoque Sin Pretensiones

**❌ INCORRECTO - Con Pretensiones (v4.0):**

```
Roles basados en títulos/cargos:
- USERS_FULL_MANAGER      → Pretende definir QUÉ ES la persona
- REPORTS_VIEWER          → Título organizacional
- SYSTEM_ADMIN            → Cargo jerárquico
- DATA_ANALYST            → Puesto de trabajo
```

**✅ CORRECTO - Sin Pretensiones (v5.1):**

```
Funciones basadas en acciones:
- crea_usuarios           → Describe QUÉ PUEDE HACER
- ve_reportes             → Acción concreta
- exporta_csv             → Capacidad específica
- configura_alertas       → Función del sistema
```

### 1.3 Ventajas del Enfoque

| Ventaja | Descripción |
|---------|-------------|
| **Claridad** | Nombre = Acción (sin ambigüedad) |
| **Auditoría** | "¿Puede exportar PDF?" → Buscar `exporta_pdf` → Sí/No |
| **Flexibilidad** | Combinaciones únicas por usuario |
| **Mantenibilidad** | Cambio de cargo ≠ cambio de funciones |
| **Mínimo privilegio** | Asignar solo lo necesario |
| **Escalabilidad** | Agregar función no afecta existentes |
| **Compliance** | Cumple SOX, ISO 27001 |

### 1.4 Agrupadores ≠ Roles

**Importante:** Los agrupadores son **mecanismos de conveniencia** para asignación masiva, NO son roles.

```
Agrupador "agr_operador_reportes":
  → Internamente asigna: ve_reportes, filtra_reportes, ve_dashboard
  → El usuario NO "es" operador_reportes
  → El usuario TIENE las 3 funciones individualmente
  → En BD: 3 registros en tabla usuarios_funciones
```

---

<a name="2-arquitectura"></a>

## 2. ARQUITECTURA SIN PRETENSIONES

### 2.1 Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                        USUARIO                               │
│  (persona del sistema)                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ tiene asignadas (N:M)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   FUNCIONES ATÓMICAS                         │
│  (57 funciones - cada una = 1 capacidad)                     │
│                                                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │crea_usuarios│ │ ve_usuarios │ │modif_usuario│            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │ ve_reportes │ │filtra_report│ │ exporta_csv │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │ ve_dashboard│ │config_alerts│ │ ve_auditoria│            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ cada función otorga
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      CAPACIDAD                               │
│  (recurso:operación - relación 1:1 con función)              │
│                                                              │
│  crea_usuarios  → usuarios:crear                             │
│  ve_reportes    → reportes:leer                              │
│  exporta_csv    → reportes:exportar_csv                      │
└─────────────────────────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────┐
│                     AGRUPADORES                              │
│  (mecanismos de conveniencia - NO son roles)                 │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ agr_operador_reportes                                │    │
│  │   → ve_reportes                                      │    │
│  │   → filtra_reportes                                  │    │
│  │   → ve_dashboard                                     │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  Al asignar agrupador, sistema crea 3 registros individuales │
│  en usuarios_funciones                                       │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Capas de Seguridad

```
┌─────────────────────────────────────────────────────────────┐
│ CAPA 1: AUTENTICACIÓN                                        │
│ ─────────────────────                                        │
│ • Username + Password                                        │
│ • Validación de estado (ACTIVO)                              │
│ • Sesión única por usuario                                   │
│ • Bloqueo por intentos fallidos (3 intentos → 15 min)        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 2: AUTORIZACIÓN (Funciones Atómicas)                    │
│ ─────────────────────────────────────────                    │
│ • Verificar si usuario tiene función requerida               │
│ • Consulta directa: ¿tiene exporta_pdf? → Sí/No              │
│ • Sin JOINs complejos (función = capacidad)                  │
│ • Precedencia: Permiso Temporal > Función Asignada           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 3: SEGREGACIÓN DE DATOS                                 │
│ ─────────────────────────────                                │
│ • Usuario pertenece a 1 segmento                             │
│ • Filtro automático por segmento                             │
│ • Funciones cross-segment requieren función especial         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ CAPA 4: AUDITORÍA                                            │
│ ─────────────────                                            │
│ • Registro de toda acción                                    │
│ • Logs inmutables (sin UPDATE/DELETE)                        │
│ • Checksum SHA-256 por registro                              │
│ • Trazabilidad completa                                      │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Relaciones del Modelo

```
┌──────────────┐       N:M        ┌──────────────────┐
│   usuarios   │◄────────────────►│    funciones     │
└──────────────┘                  └──────────────────┘
       │                                   │
       │ N:1                               │ 1:1
       ▼                                   ▼
┌──────────────┐                  ┌──────────────────┐
│  segmentos   │                  │   capacidades    │
└──────────────┘                  └──────────────────┘

┌──────────────────┐      N:M     ┌──────────────────┐
│   agrupadores    │◄────────────►│    funciones     │
└──────────────────┘              └──────────────────┘
```

---

<a name="3-catalogo-funciones"></a>

## 3. CATÁLOGO DE FUNCIONES ATÓMICAS

### 3.1 Resumen por Dominio

| Dominio | Cantidad | Código |
|---------|----------|--------|
| Usuarios | 10 | USR |
| Funciones RBAC | 6 | FUN |
| Reportes | 10 | RPT |
| Dashboard | 5 | DSH |
| Alertas | 8 | ALR |
| Análisis | 6 | ANL |
| Auditoría | 4 | AUD |
| Sistema | 5 | SYS |
| Seguridad | 3 | SEC |
| **TOTAL** | **57** | - |

---

### 3.2 DOMINIO: Usuarios (10 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| USR-001 | `crea_usuarios` | usuarios:crear | Crea nuevos usuarios en el sistema |
| USR-002 | `ve_usuarios` | usuarios:leer | Consulta información de usuarios |
| USR-003 | `modifica_usuarios` | usuarios:modificar | Modifica datos de usuarios |
| USR-004 | `elimina_usuarios` | usuarios:eliminar | Da de baja usuarios (lógica) |
| USR-005 | `lista_usuarios` | usuarios:listar | Lista usuarios con filtros |
| USR-006 | `busca_usuarios` | usuarios:buscar | Busca usuarios por criterios |
| USR-007 | `resetea_passwords` | usuarios:reset_password | Genera contraseña temporal |
| USR-008 | `bloquea_usuarios` | usuarios:bloquear | Bloquea acceso de usuario |
| USR-009 | `desbloquea_usuarios` | usuarios:desbloquear | Desbloquea usuario bloqueado |
| USR-010 | `reactiva_usuarios` | usuarios:reactivar | Reactiva usuario inactivo |

**Detalle de cada función:**

#### USR-001: crea_usuarios

```yaml
Función: crea_usuarios
Capacidad: usuarios:crear
Descripción: Crea nuevos usuarios en el sistema con información completa

Acciones permitidas:
  - Ingresar datos del nuevo usuario
  - Asignar segmento de datos
  - Generar contraseña temporal
  - Enviar notificación vía buzón interno

Datos requeridos:
  - username (único, formato: nombre.apellidoNNN)
  - email (único, dominio corporativo)
  - nombre
  - apellido
  - segmento_id

Restricciones:
  - Requiere función asigna_funciones para asignar funciones al nuevo usuario
  - Usuario creado inicia con estado ACTIVO
  - Contraseña temporal expira en 24 horas
  - Notificación SOLO vía buzón interno (NO email)

Casos de Uso: UC-006
Auditoría: Nivel INFO - USER_CREATE
```

#### USR-002: ve_usuarios

```yaml
Función: ve_usuarios
Capacidad: usuarios:leer
Descripción: Consulta información de usuarios sin modificar

Información visible:
  - Username
  - Nombre completo
  - Email
  - Estado (ACTIVO, INACTIVO, BLOQUEADO)
  - Segmento de datos
  - Funciones asignadas
  - Fecha de creación
  - Último acceso

Información NO visible:
  - Contraseña (hash)
  - Preguntas de seguridad
  - Intentos fallidos de login
  - Tokens de sesión

Restricciones:
  - Solo lectura
  - Respeta filtro de segmento (ve usuarios de su segmento)
  - Requiere ve_usuarios_global para ver todos los segmentos

Casos de Uso: UC-009
Auditoría: Nivel INFO - USER_VIEW
```

#### USR-003: modifica_usuarios

```yaml
Función: modifica_usuarios
Capacidad: usuarios:modificar
Descripción: Modifica datos de usuarios existentes

Campos modificables:
  - nombre
  - apellido
  - email
  - Información de contacto adicional

Campos NO modificables (requieren función específica):
  - username (inmutable)
  - password (requiere resetea_passwords)
  - estado (requiere bloquea/desbloquea/elimina)
  - segmento_id (requiere cambia_segmento)
  - funciones (requiere asigna_funciones)

Restricciones:
  - Requiere justificación (mín 20 caracteres)
  - Cambios registrados en auditoría con valores anteriores/nuevos

Casos de Uso: UC-007
Auditoría: Nivel INFO - USER_UPDATE
```

#### USR-004: elimina_usuarios

```yaml
Función: elimina_usuarios
Capacidad: usuarios:eliminar
Descripción: Da de baja usuarios (eliminación lógica)

Proceso:
  1. Cambiar estado a ELIMINADO
  2. Revocar todas las funciones activas
  3. Cerrar sesiones activas
  4. Registrar en auditoría

Restricciones:
  - Eliminación es LÓGICA (no física)
  - Requiere justificación obligatoria
  - Datos se mantienen para auditoría
  - Usuario NO puede reactivarse (requiere nueva creación)

Casos de Uso: UC-008
Auditoría: Nivel WARNING - USER_DELETE
```

#### USR-005: lista_usuarios

```yaml
Función: lista_usuarios
Capacidad: usuarios:listar
Descripción: Lista usuarios con filtros y paginación

Filtros disponibles:
  - Por estado (ACTIVO, INACTIVO, BLOQUEADO)
  - Por segmento
  - Por función asignada
  - Por fecha de creación
  - Por último acceso

Ordenamiento:
  - Por username (A-Z, Z-A)
  - Por nombre completo
  - Por fecha de creación
  - Por último acceso

Paginación:
  - Default: 20 registros por página
  - Máximo: 100 registros por página

Casos de Uso: UC-009
Auditoría: Nivel INFO - USER_LIST
```

#### USR-006: busca_usuarios

```yaml
Función: busca_usuarios
Capacidad: usuarios:buscar
Descripción: Búsqueda de usuarios por múltiples criterios

Criterios de búsqueda:
  - Username (parcial)
  - Nombre completo (parcial)
  - Email (parcial)
  - Segmento
  - Función asignada

Tipo de búsqueda:
  - Exacta
  - Contiene (LIKE)
  - Comienza con
  - Termina con

Casos de Uso: UC-009
Auditoría: Nivel INFO - USER_SEARCH
```

#### USR-007: resetea_passwords

```yaml
Función: resetea_passwords
Capacidad: usuarios:reset_password
Descripción: Genera contraseña temporal para usuario

Proceso:
  1. Generar contraseña temporal segura
  2. Actualizar password_hash en BD
  3. Marcar debe_cambiar_password = TRUE
  4. Notificar usuario vía buzón interno
  5. Registrar en auditoría

Contraseña temporal:
  - 12 caracteres mínimo
  - Mayúsculas + minúsculas + números + símbolos
  - Expira en 24 horas
  - Uso único (debe cambiarla al primer login)

Restricciones:
  - NO se envía por email
  - Solo vía buzón interno
  - Requiere justificación

Casos de Uso: UC-007 (flujo alternativo)
Auditoría: Nivel WARNING - PASSWORD_RESET
```

#### USR-008: bloquea_usuarios

```yaml
Función: bloquea_usuarios
Capacidad: usuarios:bloquear
Descripción: Bloquea acceso de usuario al sistema

Proceso:
  1. Cambiar estado a BLOQUEADO
  2. Cerrar sesiones activas inmediatamente
  3. Registrar razón del bloqueo
  4. Notificar usuario vía buzón interno
  5. Notificar a usuarios con ve_auditoria

Razones de bloqueo:
  - Manual por administrador
  - Actividad sospechosa
  - Solicitud del usuario
  - Violación de políticas

Restricciones:
  - Requiere justificación obligatoria
  - Usuario bloqueado NO puede iniciar sesión
  - Funciones permanecen asignadas (pero inactivas)

Casos de Uso: UC-007 (flujo alternativo)
Auditoría: Nivel CRITICAL - USER_BLOCKED
```

#### USR-009: desbloquea_usuarios

```yaml
Función: desbloquea_usuarios
Capacidad: usuarios:desbloquear
Descripción: Desbloquea usuario previamente bloqueado

Proceso:
  1. Verificar estado actual = BLOQUEADO
  2. Cambiar estado a ACTIVO
  3. Resetear contador de intentos fallidos
  4. Notificar usuario vía buzón interno
  5. Registrar en auditoría

Restricciones:
  - Solo aplica a usuarios BLOQUEADOS
  - Requiere justificación
  - Opcionalmente puede forzar cambio de contraseña

Casos de Uso: UC-007 (flujo alternativo)
Auditoría: Nivel WARNING - USER_UNBLOCKED
```

#### USR-010: reactiva_usuarios

```yaml
Función: reactiva_usuarios
Capacidad: usuarios:reactivar
Descripción: Reactiva usuario inactivo

Proceso:
  1. Verificar estado actual = INACTIVO
  2. Cambiar estado a ACTIVO
  3. Verificar funciones asignadas (pueden haber expirado)
  4. Notificar usuario vía buzón interno
  5. Registrar en auditoría

Restricciones:
  - Solo aplica a usuarios INACTIVOS
  - NO aplica a usuarios ELIMINADOS
  - Requiere justificación
  - Puede requerir reasignación de funciones

Casos de Uso: UC-007 (flujo alternativo)
Auditoría: Nivel INFO - USER_REACTIVATED
```

---

### 3.3 DOMINIO: Funciones RBAC (6 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| FUN-001 | `asigna_funciones` | funciones:asignar | Asigna funciones a usuarios |
| FUN-002 | `revoca_funciones` | funciones:revocar | Revoca funciones de usuarios |
| FUN-003 | `ve_funciones` | funciones:leer | Consulta catálogo de funciones |
| FUN-004 | `ve_asignaciones` | asignaciones:leer | Ve asignaciones usuario-función |
| FUN-005 | `asigna_agrupadores` | agrupadores:asignar | Asigna agrupadores completos |
| FUN-006 | `gestiona_sod` | sod:gestionar | Configura restricciones SoD |

**Detalle de cada función:**

#### FUN-001: asigna_funciones

```yaml
Función: asigna_funciones
Capacidad: funciones:asignar
Descripción: Asigna funciones atómicas a usuarios

Proceso:
  1. Seleccionar usuario destino
  2. Seleccionar función(es) a asignar
  3. Validar restricciones SoD
  4. Ingresar justificación
  5. Confirmar asignación
  6. Notificar usuario vía buzón interno

Validaciones:
  - Usuario debe estar ACTIVO
  - Función debe estar activa en catálogo
  - No debe violar restricciones SoD
  - Justificación mínimo 20 caracteres

Restricciones:
  - Una función no puede asignarse dos veces al mismo usuario
  - Validación SoD es bloqueante

Casos de Uso: UC-010
Auditoría: Nivel WARNING - FUNCTION_ASSIGN
```

#### FUN-002: revoca_funciones

```yaml
Función: revoca_funciones
Capacidad: funciones:revocar
Descripción: Revoca funciones asignadas a usuarios

Proceso:
  1. Seleccionar usuario
  2. Ver funciones asignadas
  3. Seleccionar función(es) a revocar
  4. Ingresar justificación
  5. Confirmar revocación
  6. Notificar usuario vía buzón interno

Tipos de revocación:
  - Inmediata (efecto instantáneo)
  - Programada (fecha futura)

Restricciones:
  - Requiere justificación obligatoria
  - No se puede revocar función no asignada
  - Historial de asignación se mantiene

Casos de Uso: UC-010
Auditoría: Nivel WARNING - FUNCTION_REVOKE
```

#### FUN-003: ve_funciones

```yaml
Función: ve_funciones
Capacidad: funciones:leer
Descripción: Consulta catálogo de funciones del sistema

Información visible:
  - ID de función
  - Nombre (snake_case)
  - Descripción
  - Dominio
  - Capacidad asociada
  - Estado (activa/inactiva)
  - Funciones incompatibles (SoD)

Filtros:
  - Por dominio
  - Por estado
  - Por texto en nombre/descripción

Casos de Uso: UC-011
Auditoría: Nivel INFO - FUNCTION_VIEW
```

#### FUN-004: ve_asignaciones

```yaml
Función: ve_asignaciones
Capacidad: asignaciones:leer
Descripción: Consulta asignaciones usuario-función

Vistas disponibles:
  - Por usuario: Todas las funciones de un usuario
  - Por función: Todos los usuarios con una función
  - Matriz completa: Usuarios × Funciones

Información mostrada:
  - Usuario
  - Función
  - Fecha de asignación
  - Asignado por
  - Justificación
  - Origen (manual / agrupador)

Casos de Uso: UC-011
Auditoría: Nivel INFO - ASSIGNMENT_VIEW
```

#### FUN-005: asigna_agrupadores

```yaml
Función: asigna_agrupadores
Capacidad: agrupadores:asignar
Descripción: Asigna agrupador completo de funciones a usuario

Proceso:
  1. Seleccionar usuario destino
  2. Seleccionar agrupador
  3. Sistema muestra funciones del agrupador
  4. Validar SoD para TODAS las funciones
  5. Ingresar justificación
  6. Confirmar asignación
  7. Sistema crea N registros individuales
  8. Notificar usuario

Comportamiento:
  - Agrupador es solo mecanismo de asignación
  - Internamente se crean asignaciones individuales
  - Se registra origen: "via_agrupador: nombre_agrupador"
  - Usuario puede tener funciones del agrupador revocadas individualmente

Casos de Uso: UC-010
Auditoría: Nivel WARNING - AGRUPADOR_ASSIGN (1) + FUNCTION_ASSIGN (N)
```

#### FUN-006: gestiona_sod

```yaml
Función: gestiona_sod
Capacidad: sod:gestionar
Descripción: Configura restricciones de Separación de Funciones

Acciones:
  - Ver restricciones SoD existentes
  - Crear nueva restricción SoD
  - Modificar restricción existente
  - Desactivar restricción

Estructura de restricción:
  - Nombre descriptivo
  - Funciones mutuamente excluyentes (Grupo A vs Grupo B)
  - Cardinalidad máxima
  - Razón/justificación
  - Estado (activa/inactiva)

Restricciones:
  - Cambios requieren justificación
  - No se pueden eliminar (solo desactivar)
  - Cambios no son retroactivos

Casos de Uso: UC-011
Auditoría: Nivel CRITICAL - SOD_CONFIGURE
```

---

### 3.4 DOMINIO: Reportes (10 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| RPT-001 | `ve_reportes` | reportes:leer | Ve reportes básicos |
| RPT-002 | `ve_reportes_avanzados` | reportes:leer_avanzados | Ve reportes avanzados |
| RPT-003 | `ve_reportes_cross_segment` | reportes:leer_cross | Ve reportes multi-segmento |
| RPT-004 | `filtra_reportes` | reportes:filtrar | Aplica filtros a reportes |
| RPT-005 | `exporta_csv` | reportes:exportar_csv | Exporta a formato CSV |
| RPT-006 | `exporta_excel` | reportes:exportar_excel | Exporta a formato Excel |
| RPT-007 | `exporta_pdf` | reportes:exportar_pdf | Exporta a formato PDF |
| RPT-008 | `crea_reportes` | reportes:crear | Crea reportes personalizados |
| RPT-009 | `programa_reportes` | reportes:programar | Programa generación automática |
| RPT-010 | `comparte_reportes` | reportes:compartir | Comparte reportes con usuarios |

**Detalle de funciones clave:**

#### RPT-001: ve_reportes

```yaml
Función: ve_reportes
Capacidad: reportes:leer
Descripción: Visualiza reportes básicos del sistema

Reportes accesibles:
  - Reporte trimestral de llamadas
  - Reporte de transferencias por centro
  - Reporte de problemas de menú
  - Reporte de llamadas diarias

Restricciones:
  - Solo datos de su segmento
  - Histórico según configuración (default: 2 años)
  - Datos pre-calculados (tablas de reportes)

Casos de Uso: UC-017, UC-018, UC-019
Auditoría: Nivel INFO - REPORT_VIEW
```

#### RPT-004: filtra_reportes

```yaml
Función: filtra_reportes
Capacidad: reportes:filtrar
Descripción: Aplica filtros a reportes

Filtros disponibles:
  Por fecha:
    - Presets: Hoy, Ayer, Últimos 7 días, Semana actual/anterior
    - Presets: Últimos 30 días, Mes actual/anterior
    - Presets: Trimestre actual/anterior, Año actual/anterior
    - Rango personalizado (máx 2 años)
  
  Por centro:
    - Todos
    - Nacional (19028031, 19020001)
    - Puebla (19020084)
    - Centro específico (dropdown)
  
  Por servicio:
    - Nacional
    - Puebla
    - Todos

Casos de Uso: UC-020, UC-021
Auditoría: Nivel INFO - REPORT_FILTER
```

#### RPT-005: exporta_csv

```yaml
Función: exporta_csv
Capacidad: reportes:exportar_csv
Descripción: Exporta reportes a formato CSV

Características del archivo:
  - Delimitador: coma (,)
  - Encoding: UTF-8 con BOM
  - Primera fila: Nombres de columnas
  - Fechas: YYYY-MM-DD
  - Números: Sin formato (punto decimal)

Límites:
  - Máximo: 100,000 registros
  - Timeout: 60 segundos
  - Límite diario según perfil

Casos de Uso: UC-022
Auditoría: Nivel WARNING - REPORT_EXPORT_CSV
```

#### RPT-006: exporta_excel

```yaml
Función: exporta_excel
Capacidad: reportes:exportar_excel
Descripción: Exporta reportes a formato Excel (.xlsx)

Características del archivo:
  - Formato profesional con colores
  - Encabezados en negrita
  - Filtros automáticos habilitados
  - Ancho de columnas ajustado
  - Hoja de metadatos incluida

Límites:
  - Máximo: 100,000 registros
  - Timeout: 90 segundos
  - Límite diario según perfil

Casos de Uso: UC-023
Auditoría: Nivel WARNING - REPORT_EXPORT_EXCEL
```

#### RPT-007: exporta_pdf

```yaml
Función: exporta_pdf
Capacidad: reportes:exportar_pdf
Descripción: Exporta reportes a formato PDF

Características del archivo:
  - Encabezado con logo y título
  - Pie de página con fecha y numeración
  - Gráficos incluidos (si aplica)
  - Tabla formateada
  - Orientación automática

Límites:
  - Máximo: 10,000 registros (por rendimiento)
  - Timeout: 120 segundos
  - Límite diario según perfil

Casos de Uso: UC-024
Auditoría: Nivel WARNING - REPORT_EXPORT_PDF
```

#### RPT-008: crea_reportes

```yaml
Función: crea_reportes
Capacidad: reportes:crear
Descripción: Crea reportes personalizados con constructor visual o SQL

Constructor visual:
  1. Selector de tabla base
  2. Selector de campos (multi-selección)
  3. Filtros (WHERE)
  4. Agrupaciones (GROUP BY)
  5. Ordenamiento (ORDER BY)
  6. Vista previa

SQL validado:
  - Solo SELECT permitido
  - Sin DML (INSERT, UPDATE, DELETE)
  - Sin DDL (CREATE, DROP, ALTER)
  - Timeout: 5 minutos
  - Límite: 50,000 registros

Casos de Uso: Creación de reportes personalizados
Auditoría: Nivel INFO - REPORT_CREATE
```

---

### 3.5 DOMINIO: Dashboard (5 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| DSH-001 | `ve_dashboard` | dashboard:leer | Ve dashboard estándar |
| DSH-002 | `personaliza_dashboard` | dashboard:personalizar | Personaliza disposición |
| DSH-003 | `guarda_vistas` | dashboard:guardar_vista | Guarda vistas personalizadas |
| DSH-004 | `configura_widgets` | dashboard:config_widgets | Configura widgets individuales |
| DSH-005 | `comparte_dashboard` | dashboard:compartir | Comparte vistas con usuarios |

**Detalle:**

#### DSH-001: ve_dashboard

```yaml
Función: ve_dashboard
Capacidad: dashboard:leer
Descripción: Visualiza dashboard principal con widgets estándar

Widgets incluidos (10):
  1. Llamadas del Último Período (Tarjeta)
  2. Distribución por Servicio (Pastel)
  3. Top 5 Centros de Transferencia (Barras)
  4. Estado de Datos ETL (Info)
  5. Alertas Activas (Contador)
  6. Gráfico Llamadas por Mes (Línea)
  7. Top 10 Centros (Barras)
  8. Tendencia 6 Meses (Línea)
  9. Menús con Mayor Incidencia (Tabla)
  10. Casos Especiales (Tarjetas)

Interacción:
  - Zoom en gráficos
  - Tooltips con detalles
  - Click para drill-down

Restricciones:
  - Vista estándar (no personalizable sin DSH-002)
  - Datos de su segmento únicamente

Casos de Uso: UC-025, UC-026, UC-027, UC-028, UC-029
Auditoría: Nivel INFO - DASHBOARD_VIEW
```

#### DSH-002: personaliza_dashboard

```yaml
Función: personaliza_dashboard
Capacidad: dashboard:personalizar
Descripción: Personaliza disposición de widgets en dashboard

Acciones permitidas:
  - Reordenar widgets (drag & drop)
  - Redimensionar widgets
  - Ocultar widgets
  - Mostrar widgets ocultos
  - Agregar widgets del catálogo

Restricciones:
  - Máximo 10 widgets por vista
  - Personalización solo afecta al usuario
  - No modifica dashboard de otros

Casos de Uso: UC-030
Auditoría: Nivel INFO - DASHBOARD_CUSTOMIZE
```

---

### 3.6 DOMINIO: Alertas (8 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| ALR-001 | `ve_alertas` | alertas:leer | Ve alertas propias |
| ALR-002 | `configura_alertas` | alertas:configurar | Configura alertas personales |
| ALR-003 | `configura_alertas_equipo` | alertas:config_equipo | Configura alertas para equipo |
| ALR-004 | `configura_alertas_globales` | alertas:config_global | Configura alertas globales |
| ALR-005 | `pausa_alertas` | alertas:pausar | Pausa alertas temporalmente |
| ALR-006 | `elimina_alertas` | alertas:eliminar | Elimina alertas propias |
| ALR-007 | `ve_historial_alertas` | alertas:historial | Ve historial de alertas |
| ALR-008 | `gestiona_destinatarios` | alertas:destinatarios | Gestiona destinatarios de alertas |

**Detalle de funciones clave:**

#### ALR-002: configura_alertas

```yaml
Función: configura_alertas
Capacidad: alertas:configurar
Descripción: Configura alertas personales con umbrales

Configuración de alerta:
  - Nombre descriptivo
  - Métrica a monitorear
  - Tipo de umbral:
    - Absoluto (> N, < N)
    - Porcentual (> N%, < N%)
    - Desviación estándar (> μ + Nσ)
  - Severidad (INFO, WARNING, CRITICAL)
  - Frecuencia de evaluación
  - Destinatario: Solo yo

Notificación:
  - EXCLUSIVAMENTE vía buzón interno
  - NO se envían correos electrónicos

Límites:
  - Máximo 20 alertas activas por usuario

Casos de Uso: UC-036
Auditoría: Nivel INFO - ALERT_CONFIGURE
```

#### ALR-003: configura_alertas_equipo

```yaml
Función: configura_alertas_equipo
Capacidad: alertas:config_equipo
Descripción: Configura alertas para usuarios del mismo segmento

Alcance:
  - Solo usuarios del mismo segmento de datos
  - Puede agregar múltiples destinatarios del segmento

Restricciones:
  - No puede agregar usuarios de otros segmentos
  - Límite de alertas compartido con equipo

Casos de Uso: UC-036
Auditoría: Nivel WARNING - ALERT_CONFIGURE_TEAM
```

#### ALR-004: configura_alertas_globales

```yaml
Función: configura_alertas_globales
Capacidad: alertas:config_global
Descripción: Configura alertas del sistema para todos los usuarios

Alcance:
  - Alertas visibles para todos los usuarios
  - Puede afectar todos los segmentos
  - Configuración de alertas críticas del sistema

Tipos de alertas globales:
  - Falla de ETL
  - Datos desactualizados
  - Umbrales de sistema
  - Mantenimiento programado

Restricciones:
  - Requiere justificación
  - Cambios notificados a administradores

Casos de Uso: UC-036, UC-040
Auditoría: Nivel CRITICAL - ALERT_CONFIGURE_GLOBAL
```

---

### 3.7 DOMINIO: Análisis (6 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| ANL-001 | `analiza_exploratorio` | analisis:exploratorio | Ejecuta análisis exploratorio |
| ANL-002 | `compara_periodos` | analisis:comparar | Compara períodos temporales |
| ANL-003 | `identifica_patrones` | analisis:patrones | Identifica patrones en datos |
| ANL-004 | `detecta_anomalias` | analisis:anomalias | Detecta anomalías estadísticas |
| ANL-005 | `ejecuta_queries` | analisis:queries | Ejecuta queries personalizadas |
| ANL-006 | `analiza_navegacion` | analisis:navegacion | Analiza inconsistencias de navegación |

**Detalle:**

#### ANL-001: analiza_exploratorio

```yaml
Función: analiza_exploratorio
Capacidad: analisis:exploratorio
Descripción: Ejecuta análisis exploratorio de datos con constructor visual

Constructor de consultas:
  1. Selección de fuente de datos
  2. Selección de campos
  3. Filtros personalizados
  4. Agrupaciones (hasta 3 niveles)
  5. Funciones de agregación (COUNT, SUM, AVG, MIN, MAX)
  6. Ordenamiento
  7. Límites

Restricciones:
  - Timeout: 300 segundos (5 minutos)
  - Máximo: 50,000 registros en pantalla
  - Solo consultas SELECT

Casos de Uso: UC-031
Auditoría: Nivel INFO - ANALYSIS_EXPLORATORY
```

#### ANL-004: detecta_anomalias

```yaml
Función: detecta_anomalias
Capacidad: analisis:anomalias
Descripción: Detecta anomalías estadísticas en datos

Método: Desviación estándar (±2σ)

Cálculo:
  1. Obtener histórico de métrica
  2. Calcular media (μ) y desviación (σ)
  3. Identificar valores fuera de μ ± 2σ
  4. Clasificar anomalías

Visualización:
  - Gráfico con banda de normalidad
  - Puntos rojos para anomalías
  - Tabla de detalle

Casos de Uso: UC-031
Auditoría: Nivel INFO - ANALYSIS_ANOMALY
```

---

### 3.8 DOMINIO: Auditoría (4 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| AUD-001 | `ve_auditoria` | auditoria:leer | Ve logs de auditoría |
| AUD-002 | `busca_auditoria` | auditoria:buscar | Busca en logs con filtros |
| AUD-003 | `exporta_auditoria` | auditoria:exportar | Exporta logs (solo lectura) |
| AUD-004 | `genera_compliance` | auditoria:compliance | Genera reportes de compliance |

**Detalle:**

#### AUD-001: ve_auditoria

```yaml
Función: ve_auditoria
Capacidad: auditoria:leer
Descripción: Visualiza logs de auditoría del sistema

Información visible:
  - Timestamp del evento
  - Usuario que realizó la acción
  - Tipo de acción
  - Módulo afectado
  - Recurso afectado
  - Resultado (EXITO, FALLO, PARCIAL)
  - IP de origen
  - Detalles adicionales

Restricciones:
  - Solo lectura (logs inmutables)
  - No puede modificar ni eliminar
  - Acceso según función ve_auditoria_global

SoD:
  - Incompatible con administra_sistema
  - Incompatible con gestión completa de usuarios

Casos de Uso: UC-060, UC-061
Auditoría: Nivel INFO - AUDIT_VIEW
```

#### AUD-004: genera_compliance

```yaml
Función: genera_compliance
Capacidad: auditoria:compliance
Descripción: Genera reportes de compliance predefinidos

Reportes disponibles:
  1. Accesos de usuarios (logins, duración, acciones)
  2. Cambios de configuración (antes/después)
  3. Exportaciones realizadas (usuario, fecha, volumen)
  4. Intentos fallidos (patrones de ataque)
  5. Gestión de permisos (asignaciones, revocaciones)

Formato de salida:
  - PDF con marca de agua "Solo lectura - Auditoría"
  - CSV para análisis externo

Casos de Uso: UC-062, UC-063
Auditoría: Nivel INFO - COMPLIANCE_REPORT
```

---

### 3.9 DOMINIO: Sistema (5 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| SYS-001 | `administra_sistema` | sistema:administrar | Administra configuración del sistema |
| SYS-002 | `gestiona_sesiones` | sistema:sesiones | Gestiona sesiones activas |
| SYS-003 | `ejecuta_etl` | sistema:etl | Ejecuta ETL manualmente |
| SYS-004 | `configura_parametros` | sistema:parametros | Configura parámetros globales |
| SYS-005 | `ve_estado_sistema` | sistema:estado | Ve estado del sistema |

**Detalle:**

#### SYS-001: administra_sistema

```yaml
Función: administra_sistema
Capacidad: sistema:administrar
Descripción: Administración completa del sistema

Acciones:
  - Configurar parámetros globales
  - Gestionar sesiones de usuarios
  - Ejecutar Jobs ETL manualmente
  - Ver logs del sistema
  - Configurar módulos

SoD:
  - ⚔️ INCOMPATIBLE con ve_auditoria
  - Razón: Quien opera NO debe auditar

Restricciones:
  - Todas las acciones requieren justificación
  - Cambios críticos requieren confirmación
  - Notificación automática a otros admins

Casos de Uso: UC-043 a UC-048
Auditoría: Nivel CRITICAL - SYSTEM_ADMIN_ACTION
```

#### SYS-002: gestiona_sesiones

```yaml
Función: gestiona_sesiones
Capacidad: sistema:sesiones
Descripción: Gestiona sesiones activas de usuarios

Acciones:
  - Ver todas las sesiones activas
  - Ver detalles de sesión (IP, User Agent, acciones)
  - Cerrar sesión de usuario (con justificación)
  - Cerrar todas las sesiones (emergencia)

Información de sesión:
  - ID de sesión
  - Usuario
  - IP de origen
  - User Agent
  - Hora de login
  - Última actividad
  - Acciones realizadas

Casos de Uso: UC-005
Auditoría: Nivel CRITICAL - SESSION_MANAGE
```

#### SYS-003: ejecuta_etl

```yaml
Función: ejecuta_etl
Capacidad: sistema:etl
Descripción: Ejecuta proceso ETL manualmente

Proceso:
  1. Mostrar estado actual del ETL
  2. Mostrar última ejecución y próxima programada
  3. Advertir sobre impacto en BD IVR
  4. Solicitar justificación
  5. Ejecutar sp_actualizar_reportes_iact
  6. Mostrar progreso y resultado

Restricciones:
  - Requiere justificación obligatoria
  - Warning si se ejecuta fuera de horario normal
  - Timeout: Configurable (default 45 min)

Casos de Uso: UC-043
Auditoría: Nivel WARNING - ETL_MANUAL_EXECUTE
```

---

### 3.10 DOMINIO: Seguridad (3 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| SEC-001 | `configura_politicas` | seguridad:politicas | Configura políticas de seguridad |
| SEC-002 | `ve_eventos_seguridad` | seguridad:eventos | Ve eventos de seguridad |
| SEC-003 | `gestiona_bloqueos` | seguridad:bloqueos | Gestiona bloqueos automáticos |

**Detalle:**

#### SEC-001: configura_politicas

```yaml
Función: configura_politicas
Capacidad: seguridad:politicas
Descripción: Configura políticas de seguridad del sistema

Políticas configurables:
  - Complejidad de contraseña
  - Expiración de contraseña
  - Intentos fallidos antes de bloqueo
  - Duración del bloqueo
  - Timeout de sesión
  - Políticas de auditoría

Restricciones:
  - Cambios requieren justificación
  - Algunos cambios requieren reinicio de sesiones
  - Notificación a administradores

Casos de Uso: Configuración de seguridad
Auditoría: Nivel CRITICAL - SECURITY_POLICY_CHANGE
```

---

### 3.11 Tabla Resumen de 57 Funciones

| # | ID | Función | Dominio |
|---|-----|---------|---------|
| 1 | USR-001 | crea_usuarios | Usuarios |
| 2 | USR-002 | ve_usuarios | Usuarios |
| 3 | USR-003 | modifica_usuarios | Usuarios |
| 4 | USR-004 | elimina_usuarios | Usuarios |
| 5 | USR-005 | lista_usuarios | Usuarios |
| 6 | USR-006 | busca_usuarios | Usuarios |
| 7 | USR-007 | resetea_passwords | Usuarios |
| 8 | USR-008 | bloquea_usuarios | Usuarios |
| 9 | USR-009 | desbloquea_usuarios | Usuarios |
| 10 | USR-010 | reactiva_usuarios | Usuarios |
| 11 | FUN-001 | asigna_funciones | Funciones RBAC |
| 12 | FUN-002 | revoca_funciones | Funciones RBAC |
| 13 | FUN-003 | ve_funciones | Funciones RBAC |
| 14 | FUN-004 | ve_asignaciones | Funciones RBAC |
| 15 | FUN-005 | asigna_agrupadores | Funciones RBAC |
| 16 | FUN-006 | gestiona_sod | Funciones RBAC |
| 17 | RPT-001 | ve_reportes | Reportes |
| 18 | RPT-002 | ve_reportes_avanzados | Reportes |
| 19 | RPT-003 | ve_reportes_cross_segment | Reportes |
| 20 | RPT-004 | filtra_reportes | Reportes |
| 21 | RPT-005 | exporta_csv | Reportes |
| 22 | RPT-006 | exporta_excel | Reportes |
| 23 | RPT-007 | exporta_pdf | Reportes |
| 24 | RPT-008 | crea_reportes | Reportes |
| 25 | RPT-009 | programa_reportes | Reportes |
| 26 | RPT-010 | comparte_reportes | Reportes |
| 27 | DSH-001 | ve_dashboard | Dashboard |
| 28 | DSH-002 | personaliza_dashboard | Dashboard |
| 29 | DSH-003 | guarda_vistas | Dashboard |
| 30 | DSH-004 | configura_widgets | Dashboard |
| 31 | DSH-005 | comparte_dashboard | Dashboard |
| 32 | ALR-001 | ve_alertas | Alertas |
| 33 | ALR-002 | configura_alertas | Alertas |
| 34 | ALR-003 | configura_alertas_equipo | Alertas |
| 35 | ALR-004 | configura_alertas_globales | Alertas |
| 36 | ALR-005 | pausa_alertas | Alertas |
| 37 | ALR-006 | elimina_alertas | Alertas |
| 38 | ALR-007 | ve_historial_alertas | Alertas |
| 39 | ALR-008 | gestiona_destinatarios | Alertas |
| 40 | ANL-001 | analiza_exploratorio | Análisis |
| 41 | ANL-002 | compara_periodos | Análisis |
| 42 | ANL-003 | identifica_patrones | Análisis |
| 43 | ANL-004 | detecta_anomalias | Análisis |
| 44 | ANL-005 | ejecuta_queries | Análisis |
| 45 | ANL-006 | analiza_navegacion | Análisis |
| 46 | AUD-001 | ve_auditoria | Auditoría |
| 47 | AUD-002 | busca_auditoria | Auditoría |
| 48 | AUD-003 | exporta_auditoria | Auditoría |
| 49 | AUD-004 | genera_compliance | Auditoría |
| 50 | SYS-001 | administra_sistema | Sistema |
| 51 | SYS-002 | gestiona_sesiones | Sistema |
| 52 | SYS-003 | ejecuta_etl | Sistema |
| 53 | SYS-004 | configura_parametros | Sistema |
| 54 | SYS-005 | ve_estado_sistema | Sistema |
| 55 | SEC-001 | configura_politicas | Seguridad |
| 56 | SEC-002 | ve_eventos_seguridad | Seguridad |
| 57 | SEC-003 | gestiona_bloqueos | Seguridad |

---

<a name="4-catalogo-agrupadores"></a>

## 4. CATÁLOGO DE AGRUPADORES

### 4.1 Concepto de Agrupador

> **Agrupador = Mecanismo de asignación masiva de funciones**
> 
> - NO es un rol
> - NO define qué "es" el usuario
> - Solo facilita asignar múltiples funciones relacionadas
> - Internamente crea N asignaciones individuales

### 4.2 Lista de 12 Agrupadores

| ID | Agrupador | Funciones | Descripción |
|----|-----------|-----------|-------------|
| AGR-001 | agr_operador_basico | 5 | Operador de consulta básica |
| AGR-002 | agr_operador_reportes | 7 | Operador con acceso a reportes |
| AGR-003 | agr_supervisor | 12 | Supervisor de equipo |
| AGR-004 | agr_analista | 18 | Analista de datos |
| AGR-005 | agr_exportador | 4 | Exportación de reportes |
| AGR-006 | agr_gestor_alertas | 6 | Gestión de alertas |
| AGR-007 | agr_admin_usuarios | 12 | Administración de usuarios |
| AGR-008 | agr_admin_funciones | 6 | Administración de funciones RBAC |
| AGR-009 | agr_auditor | 4 | Auditoría y compliance |
| AGR-010 | agr_admin_sistema | 8 | Administración del sistema |
| AGR-011 | agr_seguridad | 5 | Seguridad del sistema |
| AGR-012 | agr_completo | 45 | Acceso completo (excepto SoD) |

---

### 4.3 Detalle de Cada Agrupador

#### AGR-001: agr_operador_basico

```yaml
Agrupador: agr_operador_basico
Descripción: Funciones mínimas para operador de consulta
Cantidad de funciones: 5
Para quién: Operadores de call center, consulta básica

Funciones incluidas:
  - ve_reportes           # Ver reportes básicos
  - filtra_reportes       # Aplicar filtros
  - ve_dashboard          # Ver dashboard
  - ve_alertas            # Ver alertas propias
  - ve_historial_alertas  # Ver historial de alertas

Usuarios estimados: 50-100
```

#### AGR-002: agr_operador_reportes

```yaml
Agrupador: agr_operador_reportes
Descripción: Operador con acceso completo a reportes
Cantidad de funciones: 7
Para quién: Personal que necesita reportes pero no exportar

Funciones incluidas:
  - ve_reportes
  - ve_reportes_avanzados
  - filtra_reportes
  - ve_dashboard
  - personaliza_dashboard
  - ve_alertas
  - ve_historial_alertas

Usuarios estimados: 30-50
```

#### AGR-003: agr_supervisor

```yaml
Agrupador: agr_supervisor
Descripción: Supervisor de equipo con gestión de alertas
Cantidad de funciones: 12
Para quién: Supervisores, coordinadores de área

Funciones incluidas:
  # Reportes
  - ve_reportes
  - ve_reportes_avanzados
  - filtra_reportes
  - exporta_csv
  - exporta_excel
  
  # Dashboard
  - ve_dashboard
  - personaliza_dashboard
  - guarda_vistas
  
  # Alertas
  - ve_alertas
  - configura_alertas
  - configura_alertas_equipo
  - ve_historial_alertas

Usuarios estimados: 20-40
```

#### AGR-004: agr_analista

```yaml
Agrupador: agr_analista
Descripción: Analista de datos con capacidades avanzadas
Cantidad de funciones: 18
Para quién: Analistas, científicos de datos

Funciones incluidas:
  # Reportes completo
  - ve_reportes
  - ve_reportes_avanzados
  - ve_reportes_cross_segment
  - filtra_reportes
  - exporta_csv
  - exporta_excel
  - exporta_pdf
  - crea_reportes
  - programa_reportes
  
  # Dashboard completo
  - ve_dashboard
  - personaliza_dashboard
  - guarda_vistas
  - configura_widgets
  
  # Análisis
  - analiza_exploratorio
  - compara_periodos
  - identifica_patrones
  - detecta_anomalias
  - ejecuta_queries

Usuarios estimados: 5-15

Nota: Sin límite de exportaciones diarias
```

#### AGR-005: agr_exportador

```yaml
Agrupador: agr_exportador
Descripción: Capacidades de exportación de reportes
Cantidad de funciones: 4
Para quién: Usuarios que necesitan exportar datos

Funciones incluidas:
  - exporta_csv
  - exporta_excel
  - exporta_pdf
  - comparte_reportes

Nota: Usualmente se combina con agr_operador_reportes

Usuarios estimados: 30-50
```

#### AGR-006: agr_gestor_alertas

```yaml
Agrupador: agr_gestor_alertas
Descripción: Gestión completa de alertas
Cantidad de funciones: 6
Para quién: Responsables de configurar alertas

Funciones incluidas:
  - ve_alertas
  - configura_alertas
  - configura_alertas_equipo
  - pausa_alertas
  - elimina_alertas
  - gestiona_destinatarios

Usuarios estimados: 15-30
```

#### AGR-007: agr_admin_usuarios

```yaml
Agrupador: agr_admin_usuarios
Descripción: Administración completa de usuarios
Cantidad de funciones: 12
Para quién: Administradores de usuarios

Funciones incluidas:
  # Gestión de usuarios
  - crea_usuarios
  - ve_usuarios
  - modifica_usuarios
  - elimina_usuarios
  - lista_usuarios
  - busca_usuarios
  - resetea_passwords
  - bloquea_usuarios
  - desbloquea_usuarios
  - reactiva_usuarios
  
  # Funciones RBAC
  - asigna_funciones
  - revoca_funciones

Usuarios estimados: 2-5

SoD: Incompatible con agr_auditor
```

#### AGR-008: agr_admin_funciones

```yaml
Agrupador: agr_admin_funciones
Descripción: Administración de funciones y agrupadores RBAC
Cantidad de funciones: 6
Para quién: Administradores de seguridad RBAC

Funciones incluidas:
  - ve_funciones
  - ve_asignaciones
  - asigna_funciones
  - revoca_funciones
  - asigna_agrupadores
  - gestiona_sod

Usuarios estimados: 2-3
```

#### AGR-009: agr_auditor

```yaml
Agrupador: agr_auditor
Descripción: Auditoría y compliance (solo lectura)
Cantidad de funciones: 4
Para quién: Auditores internos/externos

Funciones incluidas:
  - ve_auditoria
  - busca_auditoria
  - exporta_auditoria
  - genera_compliance

Restricciones:
  - Solo lectura
  - No puede modificar sistema

SoD:
  - ⚔️ Incompatible con agr_admin_usuarios
  - ⚔️ Incompatible con agr_admin_sistema

Usuarios estimados: 2-5
```

#### AGR-010: agr_admin_sistema

```yaml
Agrupador: agr_admin_sistema
Descripción: Administración del sistema
Cantidad de funciones: 8
Para quién: Administradores del sistema

Funciones incluidas:
  - administra_sistema
  - gestiona_sesiones
  - ejecuta_etl
  - configura_parametros
  - ve_estado_sistema
  - ve_usuarios
  - lista_usuarios
  - busca_usuarios

SoD:
  - ⚔️ Incompatible con agr_auditor

Usuarios estimados: 1-2
```

#### AGR-011: agr_seguridad

```yaml
Agrupador: agr_seguridad
Descripción: Seguridad del sistema
Cantidad de funciones: 5
Para quién: Administradores de seguridad

Funciones incluidas:
  - configura_politicas
  - ve_eventos_seguridad
  - gestiona_bloqueos
  - ve_auditoria
  - busca_auditoria

Usuarios estimados: 1-2
```

#### AGR-012: agr_completo

```yaml
Agrupador: agr_completo
Descripción: Acceso a todas las funciones excepto las restringidas por SoD
Cantidad de funciones: 45
Para quién: Super administradores (casos excepcionales)

Funciones incluidas:
  - Todas las funciones de usuarios (10)
  - Todas las funciones RBAC (6)
  - Todas las funciones de reportes (10)
  - Todas las funciones de dashboard (5)
  - Todas las funciones de alertas (8)
  - Todas las funciones de sistema (5)
  - Una de: agr_auditor O agr_admin_sistema (por SoD)

Restricciones:
  - NO incluye simultáneamente auditoría + admin sistema
  - Asignación requiere aprobación especial

Usuarios estimados: 1 (emergencias)
```

---

### 4.4 Matriz Agrupador → Funciones

```
                          USR  FUN  RPT  DSH  ALR  ANL  AUD  SYS  SEC
Agrupador                 10   6    10   5    8    6    4    5    3
─────────────────────────────────────────────────────────────────────
AGR-001 operador_basico   -    -    2    1    2    -    -    -    -
AGR-002 operador_reportes -    -    3    2    2    -    -    -    -
AGR-003 supervisor        -    -    5    3    4    -    -    -    -
AGR-004 analista          -    -    9    4    -    5    -    -    -
AGR-005 exportador        -    -    4    -    -    -    -    -    -
AGR-006 gestor_alertas    -    -    -    -    6    -    -    -    -
AGR-007 admin_usuarios    10   2    -    -    -    -    -    -    -
AGR-008 admin_funciones   -    6    -    -    -    -    -    -    -
AGR-009 auditor           -    -    -    -    -    -    4    -    -
AGR-010 admin_sistema     2    -    -    -    -    -    -    5    -
AGR-011 seguridad         -    -    -    -    -    -    2    -    3
AGR-012 completo          10   6    10   5    8    6    *    *    3
                                                      (SoD)
```

---

<a name="5-sod"></a>

## 5. SEPARACIÓN DE FUNCIONES (SoD)

### 5.1 Concepto

> **SoD (Separation of Duties):** Restricciones que impiden que un usuario tenga combinaciones de funciones que representen riesgo de seguridad o conflicto de interés.

### 5.2 Restricciones Definidas

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| SOD-001 | sod_admin_auditoria | administra_sistema, gestiona_sesiones, ejecuta_etl, configura_parametros | ve_auditoria, busca_auditoria, exporta_auditoria, genera_compliance | Quien opera NO audita |
| SOD-002 | sod_usuarios_auditoria | crea_usuarios, modifica_usuarios, elimina_usuarios, bloquea_usuarios | ve_auditoria, busca_auditoria, exporta_auditoria | Quien gestiona usuarios NO audita |
| SOD-003 | sod_crea_elimina_usuarios | crea_usuarios | elimina_usuarios | Separar creación de eliminación |
| SOD-004 | sod_asigna_gestiona_sod | asigna_funciones | gestiona_sod | Separar asignación de configuración SoD |
| SOD-005 | sod_configura_ve_auditoria | configura_politicas | ve_auditoria | Quien configura no ve sus logs |

### 5.3 Detalle de Restricciones

#### SOD-001: sod_admin_auditoria

```yaml
Restricción: sod_admin_auditoria
Descripción: Quien opera el sistema NO debe auditarlo

Funciones mutuamente excluyentes:
  Grupo A: administra_sistema, gestiona_sesiones, ejecuta_etl, configura_parametros
  Grupo B: ve_auditoria, busca_auditoria, exporta_auditoria, genera_compliance

Cardinalidad: 1 (máximo 1 función de cada grupo)

Razón:
  - Principio de independencia del auditor
  - Prevenir manipulación de evidencia
  - Cumplimiento normativo (ISO 27001, SOC 2)

Agrupadores afectados:
  - agr_admin_sistema ⚔️ agr_auditor
```

#### SOD-002: sod_usuarios_auditoria

```yaml
Restricción: sod_usuarios_auditoria
Descripción: Quien gestiona usuarios NO debe auditar sus propias acciones

Funciones mutuamente excluyentes:
  Grupo A: crea_usuarios, modifica_usuarios, elimina_usuarios, bloquea_usuarios
  Grupo B: ve_auditoria, busca_auditoria, exporta_auditoria

Cardinalidad: 1

Razón:
  - Prevenir ocultar acciones propias
  - Garantizar trazabilidad independiente

Agrupadores afectados:
  - agr_admin_usuarios ⚔️ agr_auditor
```

#### SOD-003: sod_crea_elimina_usuarios

```yaml
Restricción: sod_crea_elimina_usuarios
Descripción: Quien crea usuarios NO debe poder eliminarlos

Funciones mutuamente excluyentes:
  Grupo A: crea_usuarios
  Grupo B: elimina_usuarios

Cardinalidad: 1

Razón:
  - Prevenir creación y eliminación fraudulenta
  - Dos personas deben intervenir en ciclo de vida
  - Control de cuatro ojos

Nota: Esta restricción puede relajarse en organizaciones pequeñas
      mediante configuración (desactivar SOD-003)
```

#### SOD-004: sod_asigna_gestiona_sod

```yaml
Restricción: sod_asigna_gestiona_sod
Descripción: Quien asigna funciones NO debe poder modificar las restricciones SoD

Funciones mutuamente excluyentes:
  Grupo A: asigna_funciones
  Grupo B: gestiona_sod

Cardinalidad: 1

Razón:
  - Prevenir que alguien se auto-asigne funciones
    después de deshabilitar la restricción que lo impide
  - Separación de poderes

Agrupadores afectados:
  - agr_admin_usuarios parcialmente
  - agr_admin_funciones parcialmente
```

#### SOD-005: sod_configura_ve_auditoria

```yaml
Restricción: sod_configura_ve_auditoria
Descripción: Quien configura políticas de seguridad NO debe ver sus propios logs

Funciones mutuamente excluyentes:
  Grupo A: configura_politicas
  Grupo B: ve_auditoria

Cardinalidad: 1

Razón:
  - Prevenir que quien cambia políticas oculte sus cambios
  - Independencia de la auditoría
```

### 5.4 Validación de SoD

```
Al asignar función F a usuario U:
  1. Obtener funciones actuales de U
  2. Para cada restricción SoD activa donde F participa:
     a. Determinar grupo de F (A o B)
     b. Verificar si U tiene funciones del grupo opuesto
     c. Si tiene → RECHAZAR asignación con mensaje claro
  3. Si pasa todas las validaciones → PERMITIR asignación
```
alertas', 'alertas:config_global', 'Configura alertas globales'),
('ALR-005', 'pausa_alertas', 'alertas', 'alertas:pausar', 'Pausa alertas temporalmente'),
('ALR-006', 'elimina_alertas', 'alertas', 'alertas:eliminar', 'Elimina alertas propias'),
('ALR-007', 've_historial_alertas', 'alertas', 'alertas:historial', 'Ve historial de alertas'),
('ALR-008', 'gestiona_destinatarios', 'alertas', 'alertas:destinatarios', 'Gestiona destinatarios'),

-- Dominio: Análisis
('ANL-001', 'analiza_exploratorio', 'analisis', 'analisis:exploratorio', 'Ejecuta análisis exploratorio'),
('ANL-002', 'compara_periodos', 'analisis', 'analisis:comparar', 'Compara períodos temporales'),
('ANL-003', 'identifica_patrones', 'analisis', 'analisis:patrones', 'Identifica patrones en datos'),
('ANL-004', 'detecta_anomalias', 'analisis', 'analisis:anomalias', 'Detecta anomalías estadísticas'),
('ANL-005', 'ejecuta_queries', 'analisis', 'analisis:queries', 'Ejecuta queries personalizadas'),
('ANL-006', 'analiza_navegacion', 'analisis', 'analisis:navegacion', 'Analiza inconsistencias de navegación'),

-- Dominio: Auditoría
('AUD-001', 've_auditoria', 'auditoria', 'auditoria:leer', 'Ve logs de auditoría'),
('AUD-002', 'busca_auditoria', 'auditoria', 'auditoria:buscar', 'Busca en logs con filtros'),
('AUD-003', 'exporta_auditoria', 'auditoria', 'auditoria:exportar', 'Exporta logs (solo lectura)'),
('AUD-004', 'genera_compliance', 'auditoria', 'auditoria:compliance', 'Genera reportes de compliance'),

-- Dominio: Sistema
('SYS-001', 'administra_sistema', 'sistema', 'sistema:administrar', 'Administra configuración del sistema'),
('SYS-002', 'gestiona_sesiones', 'sistema', 'sistema:sesiones', 'Gestiona sesiones activas'),
('SYS-003', 'ejecuta_etl', 'sistema', 'sistema:etl', 'Ejecuta ETL manualmente'),
('SYS-004', 'configura_parametros', 'sistema', 'sistema:parametros', 'Configura parámetros globales'),
('SYS-005', 've_estado_sistema', 'sistema', 'sistema:estado', 'Ve estado del sistema'),

-- Dominio: Seguridad
('SEC-001', 'configura_politicas', 'seguridad', 'seguridad:politicas', 'Configura políticas de seguridad'),
('SEC-002', 've_eventos_seguridad', 'seguridad', 'seguridad:eventos', 'Ve eventos de seguridad'),
('SEC-003', 'gestiona_bloqueos', 'seguridad', 'seguridad:bloqueos', 'Gestiona bloqueos automáticos');
```

### 9.4 Tabla: usuarios_funciones

```sql
CREATE TABLE usuarios_funciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    funcion_id VARCHAR(20) NOT NULL,
    asignado_por INT NOT NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    justificacion VARCHAR(500) NOT NULL,
    origen_agrupador VARCHAR(20) NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_revocacion DATETIME NULL,
    revocado_por INT NULL,
    
    CONSTRAINT fk_uf_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_uf_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT fk_uf_asignador FOREIGN KEY (asignado_por) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_uf_revocador FOREIGN KEY (revocado_por) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT uk_usuario_funcion UNIQUE (usuario_id, funcion_id),
    
    INDEX idx_uf_usuario_activo (usuario_id, activo),
    INDEX idx_uf_funcion (funcion_id),
    INDEX idx_uf_origen (origen_agrupador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 9.5 Tabla: agrupadores

```sql
CREATE TABLE agrupadores (
    agrupador_id VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_agrupador_nombre UNIQUE (nombre),
    INDEX idx_agrupador_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO agrupadores (agrupador_id, nombre, descripcion) VALUES
('AGR-001', 'agr_operador_basico', 'Funciones mínimas para operador de consulta'),
('AGR-002', 'agr_operador_reportes', 'Operador con acceso completo a reportes'),
('AGR-003', 'agr_supervisor', 'Supervisor de equipo con gestión de alertas'),
('AGR-004', 'agr_analista', 'Analista de datos con capacidades avanzadas'),
('AGR-005', 'agr_exportador', 'Capacidades de exportación de reportes'),
('AGR-006', 'agr_gestor_alertas', 'Gestión completa de alertas'),
('AGR-007', 'agr_admin_usuarios', 'Administración completa de usuarios'),
('AGR-008', 'agr_admin_funciones', 'Administración de funciones y agrupadores RBAC'),
('AGR-009', 'agr_auditor', 'Auditoría y compliance (solo lectura)'),
('AGR-010', 'agr_admin_sistema', 'Administración del sistema'),
('AGR-011', 'agr_seguridad', 'Seguridad del sistema'),
('AGR-012', 'agr_completo', 'Acceso completo (excepto SoD)');
```

### 9.6 Tabla: agrupador_funciones

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
    CONSTRAINT uk_agrupador_funcion UNIQUE (agrupador_id, funcion_id),
    
    INDEX idx_af_agrupador (agrupador_id),
    INDEX idx_af_funcion (funcion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- AGR-001: agr_operador_basico (5 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-001', 'RPT-001', 1),  -- ve_reportes
('AGR-001', 'RPT-004', 2),  -- filtra_reportes
('AGR-001', 'DSH-001', 3),  -- ve_dashboard
('AGR-001', 'ALR-001', 4),  -- ve_alertas
('AGR-001', 'ALR-007', 5);  -- ve_historial_alertas

-- AGR-002: agr_operador_reportes (7 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-002', 'RPT-001', 1),
('AGR-002', 'RPT-002', 2),
('AGR-002', 'RPT-004', 3),
('AGR-002', 'DSH-001', 4),
('AGR-002', 'DSH-002', 5),
('AGR-002', 'ALR-001', 6),
('AGR-002', 'ALR-007', 7);

-- AGR-003: agr_supervisor (12 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-003', 'RPT-001', 1),
('AGR-003', 'RPT-002', 2),
('AGR-003', 'RPT-004', 3),
('AGR-003', 'RPT-005', 4),
('AGR-003', 'RPT-006', 5),
('AGR-003', 'DSH-001', 6),
('AGR-003', 'DSH-002', 7),
('AGR-003', 'DSH-003', 8),
('AGR-003', 'ALR-001', 9),
('AGR-003', 'ALR-002', 10),
('AGR-003', 'ALR-003', 11),
('AGR-003', 'ALR-007', 12);

-- AGR-004: agr_analista (18 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-004', 'RPT-001', 1),
('AGR-004', 'RPT-002', 2),
('AGR-004', 'RPT-003', 3),
('AGR-004', 'RPT-004', 4),
('AGR-004', 'RPT-005', 5),
('AGR-004', 'RPT-006', 6),
('AGR-004', 'RPT-007', 7),
('AGR-004', 'RPT-008', 8),
('AGR-004', 'RPT-009', 9),
('AGR-004', 'DSH-001', 10),
('AGR-004', 'DSH-002', 11),
('AGR-004', 'DSH-003', 12),
('AGR-004', 'DSH-004', 13),
('AGR-004', 'ANL-001', 14),
('AGR-004', 'ANL-002', 15),
('AGR-004', 'ANL-003', 16),
('AGR-004', 'ANL-004', 17),
('AGR-004', 'ANL-005', 18);

-- AGR-005: agr_exportador (4 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-005', 'RPT-005', 1),
('AGR-005', 'RPT-006', 2),
('AGR-005', 'RPT-007', 3),
('AGR-005', 'RPT-010', 4);

-- AGR-006: agr_gestor_alertas (6 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-006', 'ALR-001', 1),
('AGR-006', 'ALR-002', 2),
('AGR-006', 'ALR-003', 3),
('AGR-006', 'ALR-005', 4),
('AGR-006', 'ALR-006', 5),
('AGR-006', 'ALR-008', 6);

-- AGR-007: agr_admin_usuarios (12 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-007', 'USR-001', 1),
('AGR-007', 'USR-002', 2),
('AGR-007', 'USR-003', 3),
('AGR-007', 'USR-004', 4),
('AGR-007', 'USR-005', 5),
('AGR-007', 'USR-006', 6),
('AGR-007', 'USR-007', 7),
('AGR-007', 'USR-008', 8),
('AGR-007', 'USR-009', 9),
('AGR-007', 'USR-010', 10),
('AGR-007', 'FUN-001', 11),
('AGR-007', 'FUN-002', 12);

-- AGR-008: agr_admin_funciones (6 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-008', 'FUN-001', 1),
('AGR-008', 'FUN-002', 2),
('AGR-008', 'FUN-003', 3),
('AGR-008', 'FUN-004', 4),
('AGR-008', 'FUN-005', 5),
('AGR-008', 'FUN-006', 6);

-- AGR-009: agr_auditor (4 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-009', 'AUD-001', 1),
('AGR-009', 'AUD-002', 2),
('AGR-009', 'AUD-003', 3),
('AGR-009', 'AUD-004', 4);

-- AGR-010: agr_admin_sistema (8 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-010', 'SYS-001', 1),
('AGR-010', 'SYS-002', 2),
('AGR-010', 'SYS-003', 3),
('AGR-010', 'SYS-004', 4),
('AGR-010', 'SYS-005', 5),
('AGR-010', 'USR-002', 6),
('AGR-010', 'USR-005', 7),
('AGR-010', 'USR-006', 8);

-- AGR-011: agr_seguridad (5 funciones)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-011', 'SEC-001', 1),
('AGR-011', 'SEC-002', 2),
('AGR-011', 'SEC-003', 3),
('AGR-011', 'AUD-001', 4),
('AGR-011', 'AUD-002', 5);
```

### 9.7 Tablas: Separación de Funciones (SoD) - NORMALIZADO

```sql
-- Tabla maestra de restricciones SoD
CREATE TABLE separacion_funciones (
    restriccion_id VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NOT NULL,
    cardinalidad_maxima TINYINT NOT NULL DEFAULT 1,
    razon VARCHAR(500) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_sod_nombre UNIQUE (nombre),
    INDEX idx_sod_activa (activa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla detalle de funciones en conflicto (NORMALIZADO - sin JSON)
CREATE TABLE separacion_funciones_detalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restriccion_id VARCHAR(20) NOT NULL,
    funcion_id VARCHAR(20) NOT NULL,
    grupo CHAR(1) NOT NULL,
    
    CONSTRAINT fk_sfd_restriccion FOREIGN KEY (restriccion_id) 
        REFERENCES separacion_funciones(restriccion_id),
    CONSTRAINT fk_sfd_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT uk_sfd_restriccion_funcion UNIQUE (restriccion_id, funcion_id),
    CONSTRAINT chk_sfd_grupo CHECK (grupo IN ('A', 'B')),
    
    INDEX idx_sfd_restriccion (restriccion_id),
    INDEX idx_sfd_funcion (funcion_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar restricciones SoD
INSERT INTO separacion_funciones (restriccion_id, nombre, descripcion, cardinalidad_maxima, razon) VALUES
('SOD-001', 'sod_admin_auditoria', 'Quien opera el sistema NO debe auditarlo', 1, 'Principio de independencia del auditor'),
('SOD-002', 'sod_usuarios_auditoria', 'Quien gestiona usuarios NO debe auditar sus acciones', 1, 'Prevenir ocultamiento de acciones propias'),
('SOD-003', 'sod_crea_elimina', 'Quien crea usuarios NO debe eliminarlos', 1, 'Control de cuatro ojos'),
('SOD-004', 'sod_asigna_sod', 'Quien asigna funciones NO debe gestionar SoD', 1, 'Separación de poderes'),
('SOD-005', 'sod_politicas_auditoria', 'Quien configura políticas NO debe auditar', 1, 'Independencia');

-- Detalle SOD-001
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-001', 'SYS-001', 'A'),
('SOD-001', 'SYS-002', 'A'),
('SOD-001', 'SYS-003', 'A'),
('SOD-001', 'SYS-004', 'A'),
('SOD-001', 'AUD-001', 'B'),
('SOD-001', 'AUD-002', 'B'),
('SOD-001', 'AUD-003', 'B'),
('SOD-001', 'AUD-004', 'B');

-- Detalle SOD-002
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-002', 'USR-001', 'A'),
('SOD-002', 'USR-003', 'A'),
('SOD-002', 'USR-004', 'A'),
('SOD-002', 'USR-008', 'A'),
('SOD-002', 'AUD-001', 'B'),
('SOD-002', 'AUD-002', 'B'),
('SOD-002', 'AUD-003', 'B');

-- Detalle SOD-003
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-003', 'USR-001', 'A'),
('SOD-003', 'USR-004', 'B');

-- Detalle SOD-004
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-004', 'FUN-001', 'A'),
('SOD-004', 'FUN-006', 'B');

-- Detalle SOD-005
INSERT INTO separacion_funciones_detalle (restriccion_id, funcion_id, grupo) VALUES
('SOD-005', 'SEC-001', 'A'),
('SOD-005', 'AUD-001', 'B');
```

### 9.8 Tabla: permisos_temporales

```sql
CREATE TABLE permisos_temporales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    funcion_id VARCHAR(20) NOT NULL,
    otorgado_por INT NOT NULL,
    fecha_otorgamiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATETIME NOT NULL,
    justificacion VARCHAR(500) NOT NULL,
    estado ENUM('ACTIVO', 'EXPIRADO', 'REVOCADO') NOT NULL DEFAULT 'ACTIVO',
    revocado_por INT NULL,
    fecha_revocacion DATETIME NULL,
    
    CONSTRAINT fk_pt_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_pt_funcion FOREIGN KEY (funcion_id) 
        REFERENCES funciones(funcion_id),
    CONSTRAINT fk_pt_otorgante FOREIGN KEY (otorgado_por) 
        REFERENCES usuarios(usuario_id),
    CONSTRAINT fk_pt_revocador FOREIGN KEY (revocado_por) 
        REFERENCES usuarios(usuario_id),
    
    INDEX idx_pt_usuario_estado (usuario_id, estado),
    INDEX idx_pt_vencimiento (fecha_vencimiento),
    INDEX idx_pt_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 9.9 Tabla: log_auditoria

```sql
CREATE TABLE log_auditoria (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    direccion_ip VARCHAR(45) NULL,
    agente_usuario VARCHAR(500) NULL,
    tipo_accion VARCHAR(100) NOT NULL,
    modulo VARCHAR(100) NOT NULL,
    tipo_recurso VARCHAR(100) NULL,
    recurso_id VARCHAR(100) NULL,
    resultado ENUM('EXITO', 'FALLO', 'PARCIAL') NOT NULL,
    mensaje_error TEXT NULL,
    datos_anteriores TEXT NULL,
    datos_nuevos TEXT NULL,
    id_sesion VARCHAR(255) NULL,
    checksum_registro VARCHAR(64) NOT NULL,
    
    INDEX idx_log_fecha (fecha_evento),
    INDEX idx_log_usuario (usuario_id, fecha_evento),
    INDEX idx_log_accion (tipo_accion, fecha_evento),
    INDEX idx_log_modulo (modulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 9.10 Triggers de Auditoría Inmutable

```sql
-- Trigger: Calcular checksum antes de insertar
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_checksum
BEFORE INSERT ON log_auditoria
FOR EACH ROW
BEGIN
    SET NEW.checksum_registro = SHA2(
        CONCAT_WS('|',
            NEW.fecha_evento,
            NEW.usuario_id,
            NEW.username,
            COALESCE(NEW.direccion_ip, ''),
            NEW.tipo_accion,
            NEW.modulo,
            COALESCE(NEW.tipo_recurso, ''),
            COALESCE(NEW.recurso_id, ''),
            NEW.resultado
        ), 256
    );
END$$
DELIMITER ;

-- Trigger: Prevenir modificación
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_no_update
BEFORE UPDATE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'ERROR: Los registros de auditoría son inmutables';
END$$
DELIMITER ;

-- Trigger: Prevenir eliminación
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_no_delete
BEFORE DELETE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'ERROR: Los registros de auditoría no se pueden eliminar';
END$$
DELIMITER ;
```

---

<a name="10-ejemplos"></a>

## 10. EJEMPLOS DE USO

### 10.1 Función: usuario_tiene_funcion

```sql
DELIMITER $$
CREATE FUNCTION usuario_tiene_funcion(
    p_usuario_id INT,
    p_nombre_funcion VARCHAR(100)
) RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_funcion_id VARCHAR(20);
    DECLARE v_tiene BOOLEAN DEFAULT FALSE;
    
    -- Obtener ID de la función por nombre
    SELECT funcion_id INTO v_funcion_id
    FROM funciones
    WHERE nombre = p_nombre_funcion
      AND activa = TRUE;
    
    IF v_funcion_id IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- 1. Verificar permiso temporal activo (mayor precedencia)
    SELECT TRUE INTO v_tiene
    FROM permisos_temporales
    WHERE usuario_id = p_usuario_id
      AND funcion_id = v_funcion_id
      AND estado = 'ACTIVO'
      AND fecha_vencimiento > NOW()
    LIMIT 1;
    
    IF v_tiene = TRUE THEN
        RETURN TRUE;
    END IF;
    
    -- 2. Verificar asignación directa de función
    SELECT TRUE INTO v_tiene
    FROM usuarios_funciones
    WHERE usuario_id = p_usuario_id
      AND funcion_id = v_funcion_id
      AND activo = TRUE
    LIMIT 1;
    
    RETURN COALESCE(v_tiene, FALSE);
END$$
DELIMITER ;
```

**Uso:**
```sql
-- ¿Puede el usuario 123 exportar a PDF?
SELECT usuario_tiene_funcion(123, 'exporta_pdf') AS puede_exportar;
-- Resultado: 1 (TRUE) o 0 (FALSE)
```

### 10.2 Función: validar_sod

```sql
DELIMITER $$
CREATE FUNCTION validar_sod(
    p_usuario_id INT,
    p_funcion_id VARCHAR(20)
) RETURNS VARCHAR(200)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_restriccion VARCHAR(100);
    DECLARE v_grupo CHAR(1);
    DECLARE v_conflicto INT DEFAULT 0;
    
    -- Buscar si la función está en alguna restricción SoD
    SELECT sf.nombre, sfd.grupo 
    INTO v_restriccion, v_grupo
    FROM separacion_funciones sf
    INNER JOIN separacion_funciones_detalle sfd 
        ON sf.restriccion_id = sfd.restriccion_id
    WHERE sfd.funcion_id = p_funcion_id
      AND sf.activa = TRUE
    LIMIT 1;
    
    IF v_restriccion IS NULL THEN
        RETURN 'OK';
    END IF;
    
    -- Verificar si usuario tiene funciones del grupo opuesto
    SELECT COUNT(*) INTO v_conflicto
    FROM usuarios_funciones uf
    INNER JOIN separacion_funciones_detalle sfd 
        ON uf.funcion_id = sfd.funcion_id
    INNER JOIN separacion_funciones sf 
        ON sfd.restriccion_id = sf.restriccion_id
    WHERE uf.usuario_id = p_usuario_id
      AND uf.activo = TRUE
      AND sf.nombre = v_restriccion
      AND sfd.grupo != v_grupo;
    
    IF v_conflicto > 0 THEN
        RETURN CONCAT('VIOLACION: ', v_restriccion);
    END IF;
    
    RETURN 'OK';
END$$
DELIMITER ;
```

**Uso:**
```sql
-- Validar antes de asignar función de auditoría
SELECT validar_sod(123, 'AUD-001') AS validacion;
-- Resultado: 'OK' o 'VIOLACION: sod_admin_auditoria'
```

### 10.3 Ver funciones de un usuario

```sql
SELECT 
    f.nombre AS funcion,
    f.dominio,
    uf.fecha_asignacion,
    CASE 
        WHEN uf.origen_agrupador IS NOT NULL 
        THEN CONCAT('via ', uf.origen_agrupador)
        ELSE 'asignación directa'
    END AS origen
FROM usuarios_funciones uf
INNER JOIN funciones f ON uf.funcion_id = f.funcion_id
WHERE uf.usuario_id = 123
  AND uf.activo = TRUE
ORDER BY f.dominio, f.nombre;
```

### 10.4 Ver usuarios con función específica

```sql
SELECT 
    u.username,
    u.nombre,
    u.apellido,
    uf.fecha_asignacion,
    uf.origen_agrupador
FROM usuarios u
INNER JOIN usuarios_funciones uf ON u.usuario_id = uf.usuario_id
INNER JOIN funciones f ON uf.funcion_id = f.funcion_id
WHERE f.nombre = 'exporta_pdf'
  AND uf.activo = TRUE
  AND u.estado = 'ACTIVO'
ORDER BY u.username;
```

---

<a name="11-migracion"></a>

## 11. MIGRACIÓN v4.0 → v5.1

### 11.1 Mapeo de Roles a Agrupadores

| Rol v4.0 | Agrupador v5.1 | Notas |
|----------|----------------|-------|
| USERS_FULL_MANAGER | AGR-007 agr_admin_usuarios | Similar pero sin pretensiones |
| USERS_VIEWER | Funciones individuales | ve_usuarios + lista_usuarios |
| USERS_TEAM_MANAGER | AGR-007 parcial | Sin elimina_usuarios por SoD |
| REPORTS_VIEWER | AGR-001 agr_operador_basico | Funciones básicas |
| REPORTS_EXPORTER | AGR-001 + AGR-005 | Combinación de agrupadores |
| REPORTS_ADVANCED_VIEWER | AGR-002 + ve_reportes_cross_segment | |
| REPORTS_CREATOR | AGR-004 parcial | |
| DASHBOARD_VIEWER | AGR-001 | |
| DASHBOARD_CUSTOMIZER | Funciones individuales | personaliza_dashboard + guarda_vistas |
| DATA_ANALYST | AGR-004 agr_analista | |
| ALERTS_VIEWER | Funciones individuales | ve_alertas + ve_historial_alertas |
| ALERTS_CONFIGURATOR | AGR-006 parcial | |
| ALERTS_TEAM_MANAGER | AGR-006 agr_gestor_alertas | |
| ALERTS_GLOBAL_ADMIN | AGR-006 + configura_alertas_globales | |
| MODULES_ADMIN | AGR-010 parcial | |
| SYSTEM_ADMIN | AGR-010 agr_admin_sistema | |
| AUDIT_VIEWER | AGR-009 agr_auditor | |
| SECURITY_ADMIN | AGR-011 agr_seguridad | |

### 11.2 Pasos de Migración

1. Crear nuevas tablas v5.1
2. Insertar catálogo de 57 funciones
3. Insertar 12 agrupadores y sus funciones
4. Insertar restricciones SoD normalizadas
5. Migrar asignaciones de roles a funciones individuales
6. Verificar integridad
7. Desactivar tablas v4.0 (no eliminar por auditoría)

---

<a name="12-casos-uso"></a>

## 12. CASOS DE USO RELACIONADOS

### 12.1 Mapeo Función → Caso de Uso

| Función | Casos de Uso |
|---------|--------------|
| crea_usuarios | UC-006 |
| modifica_usuarios | UC-007 |
| elimina_usuarios | UC-008 |
| lista_usuarios, busca_usuarios | UC-009 |
| asigna_funciones, revoca_funciones | UC-010 |
| ve_funciones, ve_asignaciones | UC-011 |
| ve_reportes | UC-017, UC-018, UC-019 |
| filtra_reportes | UC-020, UC-021 |
| exporta_csv | UC-022 |
| exporta_excel | UC-023 |
| exporta_pdf | UC-024 |
| ve_dashboard | UC-025 a UC-029 |
| personaliza_dashboard | UC-030 |
| analiza_exploratorio | UC-031 |
| compara_periodos | UC-032 |
| identifica_patrones | UC-033 |
| analiza_navegacion | UC-034 |
| configura_alertas | UC-036 |
| ve_alertas | UC-037 |
| ve_historial_alertas | UC-038 |
| pausa_alertas, elimina_alertas | UC-039 |
| configura_alertas_globales | UC-040 |
| ve_auditoria, busca_auditoria | UC-060, UC-061 |
| exporta_auditoria | UC-062 |
| genera_compliance | UC-063 |

---

## 13. CONCLUSIÓN

### 13.1 Resumen del Modelo v5.1

| Aspecto | Valor |
|---------|-------|
| **Filosofía** | Sin Pretensiones - Funciones describen acciones |
| **Funciones atómicas** | 57 funciones |
| **Agrupadores** | 12 agrupadores |
| **Dominios** | 9 dominios |
| **Restricciones SoD** | 5 restricciones (normalizadas) |
| **Segmentos de datos** | 6 segmentos |
| **Base de datos** | Normalizada 3FN, sin JSON |

### 13.2 Beneficios del Modelo

1. **Claridad:** `exporta_pdf` es claro, `REPORTS_EXPORTER` no lo es
2. **Auditoría:** "¿Puede X?" → Buscar función → Respuesta directa
3. **Flexibilidad:** Combinaciones únicas por usuario
4. **Mantenibilidad:** Agregar función no afecta existentes
5. **Compliance:** Cumple principio de mínimo privilegio
6. **Clean Code:** Tablas normalizadas, nomenclatura consistente

### 13.3 Próximos Pasos

1. Validar catálogo de funciones con stakeholders
2. Implementar modelo de datos en ambiente de desarrollo
3. Migrar usuarios existentes
4. Actualizar documentación de casos de uso
5. Capacitar administradores

---

**FIN DEL DOCUMENTO**

**Versión:** 5.1 - Enfoque Sin Pretensiones (Clean Code)  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación
