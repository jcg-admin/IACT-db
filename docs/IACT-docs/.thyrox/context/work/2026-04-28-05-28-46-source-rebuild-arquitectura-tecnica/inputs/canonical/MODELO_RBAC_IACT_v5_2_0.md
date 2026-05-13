# MODELO RBAC IACT - v5.2.0

## Sistema IACT - IVR Analytics & Customer Tracking

---

**Proyecto:** IACT-2025-001  
**Documento:** IACT-RBAC-001-v5.2  
**Título:** Modelo de Control de Acceso Basado en Funciones Atómicas  
**Versión:** 5.2.0 - Clean Code + 42 Funciones  
**Fecha:** 13 de enero de 2026  
**Estado:** Listo para Implementación

---

## CONTROL DE CAMBIOS

| Versión | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0-3.0 | 17-18 Oct 2025 | Versiones preliminares | Equipo |
| 4.0 | 19 Oct 2025 | Modelo híbrido con 18 roles | Equipo |
| 5.0 | 03 Ene 2026 | Enfoque Sin Pretensiones | Equipo |
| 5.1 | 03 Ene 2026 | Adaptación a 8 módulos IACT | Equipo |
| **5.2** | **13 Ene 2026** | **Clean Code + 42 funciones + Sin segmentos** | **Equipo** |

### Cambios v5.1 → v5.2

| Aspecto | v5.1 | v5.2 |
|---------|------|------|
| Funciones | 44 | **42** (eliminadas USR-010, ACC-006) |
| Segmentos | 5 segmentos | ❌ **Eliminados** |
| Nomenclatura código | Español (dominio) | **Inglés** (Clean Code v2.0.0) |
| Nomenclatura funciones | Español | Español (sin cambio - dominio) |
| `Agrupador` | Español | `FunctionGroup` |
| `UsuarioAgrupador` | Español mixto | `UserFunctionGroupAssignment` |
| `SeparationOfDuties` | Inglés | `FunctionSeparationRule` |
| Comentarios | Mixto | **Español** (estándar) |

---

## TABLA DE CONTENIDO

1. [Filosofía del Modelo](#1-filosofia)
2. [Arquitectura IACT](#2-arquitectura)
3. [Catálogo de 42 Funciones](#3-catalogo-funciones)
4. [Los 10 Grupos de Funciones](#4-grupos)
5. [Separación de Funciones (SoD)](#5-sod)
6. [Permisos Temporales](#6-permisos-temporales)
7. [Modelo de Datos](#7-modelo-datos)
8. [Implementación SQL](#8-sql)
9. [Implementación Django](#9-django)
10. [Mapeo Funciones → Casos de Uso](#10-mapeo-uc)
11. [Migración desde v5.1](#11-migracion)

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

### 1.3 Estándar de Nomenclatura v5.2

**NUEVA REGLA (desde v5.2):**

```
✅ CÓDIGO: Inglés
✅ COMENTARIOS: Español
✅ NOMBRES FUNCIONES (dominio): Español

Ejemplo:
class FunctionGroup(models.Model):
    """Grupo de funciones que se asignan juntas."""
    group_id = models.CharField(help_text="ID: AGR-001")
    name = models.CharField(help_text="Nombre: agr_operador_basico")
```

### 1.4 Integración con SEC_RULES

El módulo **MOD_Access** tiene dos componentes:

| Componente | Visible | Descripción |
|------------|---------|-------------|
| RBAC_CORE | Sí | Pantallas de administración de funciones |
| SEC_RULES | No | Middleware de enforcement automático |

---

<a name="2-arquitectura"></a>

## 2. ARQUITECTURA IACT

### 2.1 Los 8 Módulos Funcionales

```
┌─────────────────────────────────────────────────────────────┐
│                    SISTEMA IACT v1.0                         │
│           IVR Analytics & Customer Tracking                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  CAPA 1: AUTENTICACIÓN Y CONTROL                            │
│  ┌────────────┬──────────────┬────────────────┐             │
│  │ MOD_Auth   │ MOD_Users    │ MOD_Access     │             │
│  │ 4 funciones│ 9 funciones  │ 5 funciones    │             │
│  │            │              │ + SEC_RULES    │             │
│  └────────────┴──────────────┴────────────────┘             │
│                                                              │
│  CAPA 2: DATOS Y PROCESAMIENTO                              │
│  ┌────────────────────┬──────────────────────┐              │
│  │ MOD_Pipeline       │ MOD_Reports          │              │
│  │ 4 funciones        │ 8 funciones          │              │
│  │ (Supervisión ETL)  │ (Dashboards/Reportes)│              │
│  └────────────────────┴──────────────────────┘              │
│                                                              │
│  CAPA 3: COMUNICACIÓN                                       │
│  ┌──────────────────────────┐                               │
│  │ MOD_Alerts               │                               │
│  │ 6 funciones              │                               │
│  │ (Solo buzón interno)     │                               │
│  └──────────────────────────┘                               │
│                                                              │
│  CAPA 4: OBSERVABILIDAD                                     │
│  ┌────────────────────┬──────────────────────┐              │
│  │ MOD_Audit          │ MOD_Logs             │              │
│  │ 4 funciones        │ 2 funciones          │              │
│  │ (Negocio/Compliance│ (Técnico/DevOps)     │              │
│  └────────────────────┴──────────────────────┘              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Distribución de 42 Funciones

| Módulo | Código | Funciones | % | Propósito |
|--------|--------|-----------|---|-----------|
| MOD_Auth | AUTH | 4 | 9.5% | Sesiones y autenticación |
| MOD_Users | USR | 9 | 21.4% | Gestión de identidades |
| MOD_Access | ACC | 5 | 11.9% | RBAC core + SEC_RULES |
| MOD_Pipeline | PIP | 4 | 9.5% | Supervisión ETL |
| **MOD_Reports** | **RPT** | **8** | **19.0%** | **Reportes/Dashboards** |
| MOD_Alerts | ALR | 6 | 14.3% | Alertas internas |
| MOD_Audit | AUD | 4 | 9.5% | Auditoría funcional |
| MOD_Logs | LOG | 2 | 4.8% | Logs técnicos |
| **TOTAL** | - | **42** | **100%** | - |

**Cambios desde v5.1:**
- ❌ Eliminada `USR-010: asigna_segmento_usuario` (no hay segmentos)
- ❌ Eliminada `ACC-006: gestiona_segmentos` (no hay segmentos)

---

<a name="3-catalogo-funciones"></a>

## 3. CATÁLOGO DE 42 FUNCIONES

### 3.1 MOD_Auth (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUTH-001 | `gestiona_sesiones` | auth:sesiones | UC-005 | Gestiona sesiones activas del sistema |
| AUTH-002 | `cierra_sesion_usuario` | auth:cerrar_sesion | UC-005 | Cierra sesión de otro usuario |
| AUTH-003 | `resetea_password` | auth:reset_password | UC-003 | Genera contraseña temporal |
| AUTH-004 | `ve_sesiones_activas` | auth:ver_sesiones | UC-005 | Ve sesiones activas del sistema |

**CNST aplicables:**
- CNST-001: NO email (recuperación por buzón interno)
- CNST-002: Sesión única por usuario, timeout 15 min

**Implementación Django:**
```python
from apps.access.decorators import require_function

@require_function('AUTH-001')
def manage_sessions(request):
    """Gestión de sesiones activas."""
    pass
```

---

### 3.2 MOD_Users (9 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| USR-001 | `crea_usuarios` | users:crear | UC-006 | Crea nuevos usuarios |
| USR-002 | `modifica_usuarios` | users:modificar | UC-007 | Modifica datos de usuarios |
| USR-003 | `elimina_usuarios` | users:eliminar | UC-008 | Baja lógica de usuarios |
| USR-004 | `lista_usuarios` | users:listar | UC-009 | Lista usuarios con filtros |
| USR-005 | `busca_usuarios` | users:buscar | UC-009 | Busca usuarios por criterios |
| USR-006 | `bloquea_usuarios` | users:bloquear | UC-007 | Bloquea acceso de usuario |
| USR-007 | `desbloquea_usuarios` | users:desbloquear | UC-007 | Desbloquea usuario |
| USR-008 | `reactiva_usuarios` | users:reactivar | UC-007 | Reactiva usuario inactivo |
| USR-009 | `ve_usuarios` | users:leer | UC-009 | Consulta información de usuarios |

**CAMBIO v5.2:**
- ❌ **ELIMINADA** `USR-010: asigna_segmento_usuario` (no hay segmentos de datos)

**CNST aplicables:**
- CNST-001: NO email (notificaciones por buzón interno)
- CNST-005: Bajas siempre lógicas, nunca físicas
- CNST-005: Username autogenerado

**Implementación Django:**
```python
@require_function('USR-001')
def create_user(request):
    """Creación de usuario."""
    pass
```

---

### 3.3 MOD_Access (5 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ACC-001 | `asigna_funciones` | access:asignar | UC-010, UC-042 | Asigna funciones a usuarios |
| ACC-002 | `revoca_funciones` | access:revocar | UC-010 | Revoca funciones de usuarios |
| ACC-003 | `ve_asignaciones` | access:ver | UC-011, UC-044 | Ve asignaciones de funciones |
| ACC-004 | `asigna_agrupadores` | access:asignar_grupo | UC-010 | Asigna grupos de funciones |
| ACC-005 | `gestiona_sod` | access:sod | UC-043 | Configura reglas SoD |

**CAMBIO v5.2:**
- ❌ **ELIMINADA** `ACC-006: gestiona_segmentos` (no hay segmentos de datos)

**Componente SEC_RULES:**
- Middleware automático de enforcement
- No visible al usuario
- Valida permisos en cada request

**CNST aplicables:**
- CNST-005: Flat RBAC (sin jerarquías)
- CNST-005: SoD obligatorio
- CNST-005: Permisos temporales: justificación mín 20 chars, vencimiento máx 6 meses

**Implementación Django:**
```python
@require_function('ACC-001')
def assign_function(request):
    """Asignación de función a usuario."""
    pass
```

---

### 3.4 MOD_Pipeline (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| PIP-001 | `ve_estado_etl` | pipeline:ver_estado | UC-050 | Ve estado actual del ETL |
| PIP-002 | `ve_errores_etl` | pipeline:ver_errores | UC-051 | Consulta errores del ETL |
| PIP-003 | `ve_disponibilidad_datos` | pipeline:disponibilidad | UC-052 | Ve disponibilidad de datos |
| PIP-004 | `solicita_reintento_etl` | pipeline:reintento | UC-053 | Solicita reintento de ETL |

**CNST aplicables:**
- CNST-003: BD IVR solo lectura
- CNST-003: ETL cada 6-12 horas
- CNST-003: NO real-time
- CNST-009: Auditar cambios críticos

**Implementación Django:**
```python
@require_function('PIP-001')
def view_etl_status(request):
    """Visualización estado ETL."""
    pass
```

---

### 3.5 MOD_Reports (8 funciones) ⭐ CORE NEGOCIO

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| RPT-001 | `ve_reportes` | reports:ver | UC-017, UC-018, UC-019 | Ve reportes tabulares |
| RPT-002 | `ve_dashboard` | reports:dashboard | UC-025 | Ve dashboard principal |
| RPT-003 | `filtra_reportes` | reports:filtrar | UC-020, UC-021 | Aplica filtros a reportes |
| RPT-004 | `exporta_csv` | reports:exportar_csv | UC-022 | Exporta a CSV (límite: 100K registros) |
| RPT-005 | `exporta_excel` | reports:exportar_excel | UC-023 | Exporta a Excel (límite: 50K registros) |
| RPT-006 | `exporta_pdf` | reports:exportar_pdf | UC-024 | Exporta a PDF (límite: 10K registros) |
| RPT-007 | `ve_kpis` | reports:kpis | UC-025 | Ve KPIs estáticos |
| RPT-008 | `ve_graficos` | reports:graficos | UC-027, UC-028, UC-029 | Ve gráficos predefinidos |

**CNST aplicables:**
- CNST-003: Datos desfasados 6-12h, NO real-time
- CNST-006: Rango máximo 2 años en filtros
- CNST-007: Límites por formato (CSV: 100K, Excel: 50K, PDF: 10K)
- CNST-007: Throttling por rol

**Límites de exportación:**

| Formato | Max Registros | Límite Diario | Timeout |
|---------|---------------|---------------|---------|
| CSV | 100,000 | 10 exportaciones | 60s |
| Excel | 50,000 | 5 exportaciones | 90s |
| PDF | 10,000 | 3 exportaciones | 120s |

**Implementación Django:**
```python
@require_function('RPT-004')
def export_csv(request):
    """Exportación a CSV con límites."""
    pass
```

---

### 3.6 MOD_Alerts (6 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ALR-001 | `ve_alertas` | alerts:ver | UC-039 | Ve alertas propias |
| ALR-002 | `configura_alertas` | alerts:configurar | UC-036 | Configura alertas personales |
| ALR-003 | `configura_alertas_equipo` | alerts:config_equipo | UC-040 | Configura alertas de equipo |
| ALR-004 | `pausa_alertas` | alerts:pausar | UC-038 | Pausa alertas temporalmente |
| ALR-005 | `elimina_alertas` | alerts:eliminar | UC-038 | Elimina alertas |
| ALR-006 | `ve_historial_alertas` | alerts:historial | UC-039 | Ve historial de alertas |

**CNST aplicables:**
- CNST-001: NO email (solo buzón interno)
- CNST-004: Máximo 50 destinatarios por alerta
- CNST-009: Auditar configuración de alertas

**Implementación Django:**
```python
@require_function('ALR-002')
def configure_alert(request):
    """Configuración de alerta."""
    pass
```

---

### 3.7 MOD_Audit (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUD-001 | `ve_auditoria` | audit:ver | UC-061 | Ve registros de auditoría |
| AUD-002 | `busca_auditoria` | audit:buscar | UC-061 | Busca en auditoría |
| AUD-003 | `exporta_auditoria` | audit:exportar | UC-063 | Exporta registros de auditoría |
| AUD-004 | `genera_reporte_compliance` | audit:compliance | UC-062 | Genera reporte de cumplimiento |

**CNST aplicables:**
- CNST-008: Registros inmutables (append-only)
- CNST-008: Retención mínima 2 años
- CNST-008: Sin PII innecesaria
- CNST-009: Checksum SHA-256 por registro

**Implementación Django:**
```python
@require_function('AUD-001')
def view_audit_log(request):
    """Visualización de auditoría."""
    pass
```

---

### 3.8 MOD_Logs (2 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| LOG-001 | `ve_logs_tecnicos` | logs:ver | UC-070, UC-071 | Ve logs técnicos del sistema |
| LOG-002 | `exporta_logs` | logs:exportar | UC-072 | Exporta logs técnicos |

**CNST aplicables:**
- CNST-008: Sin PII (contraseñas, tokens enmascarados)
- CNST-008: Formato JSON estructurado
- CNST-008: Retención 30-90 días según tipo

**Diferencia con MOD_Audit:**
- **MOD_Audit:** Eventos de negocio (quién hizo qué)
- **MOD_Logs:** Eventos técnicos (errores, performance)

**Implementación Django:**
```python
@require_function('LOG-001')
def view_technical_logs(request):
    """Visualización de logs técnicos."""
    pass
```

---

<a name="4-grupos"></a>

## 4. LOS 10 GRUPOS DE FUNCIONES

### 4.1 Concepto

Un **grupo de funciones** (antes "agrupador") agrupa múltiples funciones relacionadas para asignarlas en bloque.

**Beneficios:**
- Asignación masiva simplificada
- Configuraciones predefinidas por rol
- Mantenimiento centralizado

### 4.2 Catálogo de Grupos

| ID | Nombre | Funciones | Actor Típico | Descripción |
|----|--------|-----------|--------------|-------------|
| **AGR-001** | `agr_operador_basico` | 6 | Operador | Visualización básica |
| **AGR-002** | `agr_visualizador_reportes` | 8 | Analista | Análisis sin exportación |
| **AGR-003** | `agr_supervisor_calidad` | 11 | Supervisor | Análisis + filtros avanzados |
| **AGR-004** | `agr_exportador_datos` | 14 | Data Analyst | Exportación autorizada |
| **AGR-005** | `agr_gestor_alertas` | 6 | Gestor Alertas | Gestión completa alertas |
| **AGR-006** | `agr_admin_usuarios` | 9 | Admin Usuarios | Gestión de identidades |
| **AGR-007** | `agr_admin_permisos` | 5 | Admin Permisos | Gestión RBAC |
| **AGR-008** | `agr_auditor` | 4 | Auditor | Solo auditoría (SoD) |
| **AGR-009** | `agr_admin_pipeline` | 4 | Admin Pipeline | Supervisión ETL |
| **AGR-010** | `agr_admin_sistema` | 6 | Sysadmin | Administración completa |

### 4.3 Detalle de Grupos

#### AGR-001: Operador Básico

**Funciones incluidas (6):**
```
AUTH-001: gestiona_sesiones          (propias)
AUTH-004: ve_sesiones_activas        (propias)
RPT-001: ve_reportes
RPT-002: ve_dashboard
RPT-007: ve_kpis
RPT-008: ve_graficos
```

**Propósito:** Usuario básico que solo visualiza información.

---

#### AGR-002: Visualizador de Reportes

**Funciones incluidas (8):**
```
Todas de AGR-001 +
RPT-003: filtra_reportes
USR-009: ve_usuarios
```

**Propósito:** Analista que puede aplicar filtros pero no exportar.

---

#### AGR-003: Supervisor de Calidad

**Funciones incluidas (11):**
```
Todas de AGR-002 +
ALR-001: ve_alertas
ALR-002: configura_alertas
ALR-006: ve_historial_alertas
```

**Propósito:** Supervisor con capacidad de configurar alertas propias.

---

#### AGR-004: Exportador de Datos

**Funciones incluidas (14):**
```
Todas de AGR-003 +
RPT-004: exporta_csv
RPT-005: exporta_excel
RPT-006: exporta_pdf
```

**Propósito:** Analista autorizado para exportar con límites CNST-007.

---

#### AGR-005: Gestor de Alertas

**Funciones incluidas (6):**
```
ALR-001: ve_alertas
ALR-002: configura_alertas
ALR-003: configura_alertas_equipo
ALR-004: pausa_alertas
ALR-005: elimina_alertas
ALR-006: ve_historial_alertas
```

**Propósito:** Gestor de alertas de equipo/departamento.

---

#### AGR-006: Admin Usuarios

**Funciones incluidas (9):**
```
USR-001: crea_usuarios
USR-002: modifica_usuarios
USR-003: elimina_usuarios
USR-004: lista_usuarios
USR-005: busca_usuarios
USR-006: bloquea_usuarios
USR-007: desbloquea_usuarios
USR-008: reactiva_usuarios
USR-009: ve_usuarios
```

**Propósito:** Administración completa de identidades.

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

---

#### AGR-007: Admin Permisos

**Funciones incluidas (5):**
```
ACC-001: asigna_funciones
ACC-002: revoca_funciones
ACC-003: ve_asignaciones
ACC-004: asigna_agrupadores
ACC-005: gestiona_sod
```

**Propósito:** Administración de RBAC.

**CAMBIO v5.2:** Ya NO incluye `ACC-006: gestiona_segmentos` (eliminada).

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

---

#### AGR-008: Auditor

**Funciones incluidas (4):**
```
AUD-001: ve_auditoria
AUD-002: busca_auditoria
AUD-003: exporta_auditoria
AUD-004: genera_reporte_compliance
```

**Propósito:** Auditoría y compliance.

**SoD CRÍTICA:** NO puede combinarse con:
- AGR-006 (admin usuarios)
- AGR-007 (admin permisos)
- AGR-009 (admin pipeline)

---

#### AGR-009: Admin Pipeline

**Funciones incluidas (4):**
```
PIP-001: ve_estado_etl
PIP-002: ve_errores_etl
PIP-003: ve_disponibilidad_datos
PIP-004: solicita_reintento_etl
```

**Propósito:** Administración de ETL.

**SoD:** NO puede tener funciones de AGR-008 (auditoría).

---

#### AGR-010: Admin Sistema

**Funciones incluidas (6):**
```
AUTH-001: gestiona_sesiones          (de todos)
AUTH-002: cierra_sesion_usuario
AUTH-003: resetea_password
AUTH-004: ve_sesiones_activas
LOG-001: ve_logs_tecnicos
LOG-002: exporta_logs
```

**Propósito:** Administración técnica del sistema.

---

<a name="5-sod"></a>

## 5. SEPARACIÓN DE FUNCIONES (SoD)

### 5.1 Concepto

**Separation of Duties (SoD):** Restricciones que impiden que un usuario tenga simultáneamente funciones incompatibles.

**Razón:** Evitar conflictos de intereses y cumplir con controles internos.

### 5.2 Las 3 Restricciones SoD

#### SOD-001: Pipeline vs Auditoría

**Restricción:** Un usuario NO puede tener funciones de Pipeline Y de Auditoría.

**Grupo A (Pipeline):**
```
PIP-001: ve_estado_etl
PIP-002: ve_errores_etl
PIP-003: ve_disponibilidad_datos
PIP-004: solicita_reintento_etl
```

**Grupo B (Auditoría):**
```
AUD-001: ve_auditoria
AUD-002: busca_auditoria
AUD-003: exporta_auditoria
AUD-004: genera_reporte_compliance
```

**Razón:** Evitar que quien opera el ETL audite sus propias acciones.

**CNST:** CNST-005

---

#### SOD-002: Usuarios vs Auditoría

**Restricción:** Un usuario NO puede tener funciones de gestión de Usuarios Y de Auditoría.

**Grupo A (Usuarios - críticas):**
```
USR-001: crea_usuarios
USR-003: elimina_usuarios
USR-004: lista_usuarios
USR-007: desbloquea_usuarios
```

**Grupo B (Auditoría):**
```
AUD-001: ve_auditoria
AUD-002: busca_auditoria
AUD-003: exporta_auditoria
```

**Razón:** Evitar que quien gestiona usuarios vea auditoría de sus acciones.

**CNST:** CNST-005

---

#### SOD-003: Acceso vs Auditoría

**Restricción:** Un usuario NO puede tener funciones de gestión de Acceso Y de Auditoría.

**Grupo A (Acceso):**
```
ACC-001: asigna_funciones
ACC-002: revoca_funciones
ACC-005: gestiona_sod
```

**Grupo B (Auditoría):**
```
AUD-001: ve_auditoria
AUD-002: busca_auditoria
```

**Razón:** Separación de poderes entre quien asigna permisos y quien audita.

**CNST:** CNST-005

---

### 5.3 Validación de SoD

**Automática en asignación:**
```python
# Ejemplo de validación
def assign_function(user, function_id):
    current_functions = get_user_functions(user)
    
    # Validar SoD
    for rule in active_sod_rules():
        group_a = rule.get_group_a_functions()
        group_b = rule.get_group_b_functions()
        
        if function_id in group_a:
            if any(f in group_b for f in current_functions):
                raise ValidationError(f"SoD violation: {rule.reason}")
        
        if function_id in group_b:
            if any(f in group_a for f in current_functions):
                raise ValidationError(f"SoD violation: {rule.reason}")
    
    # Asignar
    UserFunctionAssignment.objects.create(...)
```

---

<a name="6-permisos-temporales"></a>

## 6. PERMISOS TEMPORALES

### 6.1 Concepto

Una función puede asignarse **temporalmente** con:
- **Justificación obligatoria** (mín 20 caracteres)
- **Fecha de vencimiento** (máx 6 meses)

**Casos de uso:**
- Cobertura de vacaciones
- Proyectos temporales
- Pruebas controladas

### 6.2 Reglas

1. **Justificación:** Mínimo 20 caracteres
2. **Vencimiento:** Máximo 6 meses desde asignación
3. **Auditoría:** Registro obligatorio (CNST-009)
4. **Renovación:** Requiere nueva justificación
5. **Revocación:** Automática al vencer o manual

### 6.3 Precedencia

**Orden de precedencia (mayor a menor):**
1. Función directa temporal (con vencimiento)
2. Función directa permanente (sin vencimiento)
3. Funciones del grupo asignado

### 6.4 Ejemplo

```python
# Asignar exporta_csv temporalmente por 3 meses
UserFunctionAssignment.objects.create(
    user=user,
    function=Function.objects.get(function_id='RPT-004'),
    assigned_by=admin,
    justification="Cobertura vacaciones analista principal",
    expiration_date=date.today() + timedelta(days=90)
)
```

---

<a name="7-modelo-datos"></a>

## 7. MODELO DE DATOS

### 7.1 Diagrama ER

```
┌─────────────────┐
│     User        │
│  (Django Auth)  │
└────────┬────────┘
         │
         ├──────────────────────────────────────┐
         │                                      │
         │ 1:N                              1:N │
         ▼                                      ▼
┌────────────────────────┐     ┌──────────────────────────────┐
│ UserFunctionAssignment │     │ UserFunctionGroupAssignment  │
│                        │     │                              │
│ - user                 │     │ - user                       │
│ - function             │     │ - group                      │
│ - assigned_by          │     │ - assigned_by                │
│ - assigned_date        │     │ - assigned_date              │
│ - justification        │     └──────────┬───────────────────┘
│ - expiration_date      │                │
└────────┬───────────────┘                │ N:1
         │ N:1                            ▼
         ▼                     ┌──────────────────┐
┌────────────────┐             │  FunctionGroup   │
│    Function    │             │                  │
│                │◄─────N:M────┤ - group_id       │
│ - function_id  │  through    │ - name           │
│ - name         │  Membership │ - description    │
│ - description  │             └──────────────────┘
│ - category     │
└────────┬───────┘
         │
         │ N:M (through SeparationDetail)
         ▼
┌──────────────────────────┐
│ FunctionSeparationRule   │
│                          │
│ - restriction_id         │
│ - name                   │
│ - description            │
│ - reason                 │
│ - cnst_reference         │
│ - active                 │
└──────────────────────────┘
```

### 7.2 Tablas

1. **`functions`** - 42 funciones atómicas
2. **`function_groups`** - 10 grupos predefinidos
3. **`function_group_membership`** - M2M funciones-grupos
4. **`user_function_assignments`** - Asignaciones directas
5. **`user_function_group_assignments`** - Asignaciones de grupos
6. **`function_separation_rules`** - 3 reglas SoD
7. **`function_separation_rule_details`** - Detalle SoD (grupos A/B)

### 7.3 Cambios desde v5.1

**ELIMINADAS:**
- ❌ `data_segments` (segmentos de datos)
- ❌ `user_data_segment` (asignación de segmentos)

**Razón:** No se usan segmentos de datos en el sistema.

---

<a name="8-sql"></a>

## 8. IMPLEMENTACIÓN SQL

### 8.1 Tabla: functions

```sql
CREATE TABLE functions (
    function_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    
    CONSTRAINT uk_function_name UNIQUE (name),
    CONSTRAINT chk_category CHECK (category IN (
        'auth', 'users', 'access', 'pipeline',
        'reports', 'alerts', 'audit', 'logs'
    ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices
CREATE INDEX idx_function_category ON functions(category);
```

### 8.2 Tabla: function_groups

```sql
CREATE TABLE function_groups (
    group_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    
    CONSTRAINT uk_group_name UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 8.3 Tabla: function_group_membership

```sql
CREATE TABLE function_group_membership (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id VARCHAR(20) NOT NULL,
    function_id VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_fgm_group FOREIGN KEY (group_id)
        REFERENCES function_groups(group_id),
    CONSTRAINT fk_fgm_function FOREIGN KEY (function_id)
        REFERENCES functions(function_id),
    CONSTRAINT uk_group_function UNIQUE (group_id, function_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 8.4 Tabla: user_function_assignments

```sql
CREATE TABLE user_function_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    function_id VARCHAR(20) NOT NULL,
    assigned_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT NULL,
    justification TEXT,
    expiration_date DATE NULL,
    
    CONSTRAINT fk_ufa_user FOREIGN KEY (user_id)
        REFERENCES auth_user(id),
    CONSTRAINT fk_ufa_function FOREIGN KEY (function_id)
        REFERENCES functions(function_id),
    CONSTRAINT fk_ufa_assigned_by FOREIGN KEY (assigned_by)
        REFERENCES auth_user(id),
    CONSTRAINT uk_user_function UNIQUE (user_id, function_id),
    CONSTRAINT chk_justification_length 
        CHECK (justification IS NULL OR LENGTH(justification) >= 20),
    CONSTRAINT chk_expiration_date
        CHECK (expiration_date IS NULL OR 
               expiration_date <= DATE_ADD(assigned_date, INTERVAL 6 MONTH))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices
CREATE INDEX idx_ufa_user ON user_function_assignments(user_id);
CREATE INDEX idx_ufa_expiration ON user_function_assignments(expiration_date);
```

### 8.5 Tabla: user_function_group_assignments

```sql
CREATE TABLE user_function_group_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    group_id VARCHAR(20) NOT NULL,
    assigned_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT NULL,
    
    CONSTRAINT fk_ufga_user FOREIGN KEY (user_id)
        REFERENCES auth_user(id),
    CONSTRAINT fk_ufga_group FOREIGN KEY (group_id)
        REFERENCES function_groups(group_id),
    CONSTRAINT fk_ufga_assigned_by FOREIGN KEY (assigned_by)
        REFERENCES auth_user(id),
    CONSTRAINT uk_user_group UNIQUE (user_id, group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices
CREATE INDEX idx_ufga_user ON user_function_group_assignments(user_id);
```

### 8.6 Tabla: function_separation_rules

```sql
CREATE TABLE function_separation_rules (
    restriction_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    reason TEXT NOT NULL,
    cnst_reference VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT uk_sod_name UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 8.7 Tabla: function_separation_rule_details

```sql
CREATE TABLE function_separation_rule_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restriction_id VARCHAR(20) NOT NULL,
    function_id VARCHAR(20) NOT NULL,
    separation_group CHAR(1) NOT NULL,
    
    CONSTRAINT fk_fsrd_restriction FOREIGN KEY (restriction_id)
        REFERENCES function_separation_rules(restriction_id),
    CONSTRAINT fk_fsrd_function FOREIGN KEY (function_id)
        REFERENCES functions(function_id),
    CONSTRAINT chk_group CHECK (separation_group IN ('A', 'B')),
    CONSTRAINT uk_restriction_function UNIQUE (restriction_id, function_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 8.8 Datos Iniciales - 42 Funciones

```sql
-- MOD_Auth (4 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('AUTH-001', 'gestiona_sesiones', 'Gestiona sesiones activas del sistema', 'auth'),
('AUTH-002', 'cierra_sesion_usuario', 'Cierra sesión de otro usuario', 'auth'),
('AUTH-003', 'resetea_password', 'Genera contraseña temporal', 'auth'),
('AUTH-004', 've_sesiones_activas', 'Ve sesiones activas del sistema', 'auth');

-- MOD_Users (9 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('USR-001', 'crea_usuarios', 'Crea nuevos usuarios', 'users'),
('USR-002', 'modifica_usuarios', 'Modifica datos de usuarios', 'users'),
('USR-003', 'elimina_usuarios', 'Baja lógica de usuarios', 'users'),
('USR-004', 'lista_usuarios', 'Lista usuarios con filtros', 'users'),
('USR-005', 'busca_usuarios', 'Busca usuarios por criterios', 'users'),
('USR-006', 'bloquea_usuarios', 'Bloquea acceso de usuario', 'users'),
('USR-007', 'desbloquea_usuarios', 'Desbloquea usuario', 'users'),
('USR-008', 'reactiva_usuarios', 'Reactiva usuario inactivo', 'users'),
('USR-009', 've_usuarios', 'Consulta información de usuarios', 'users');

-- MOD_Access (5 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('ACC-001', 'asigna_funciones', 'Asigna funciones a usuarios', 'access'),
('ACC-002', 'revoca_funciones', 'Revoca funciones de usuarios', 'access'),
('ACC-003', 've_asignaciones', 'Ve asignaciones de funciones', 'access'),
('ACC-004', 'asigna_agrupadores', 'Asigna grupos de funciones', 'access'),
('ACC-005', 'gestiona_sod', 'Configura reglas SoD', 'access');

-- MOD_Pipeline (4 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('PIP-001', 've_estado_etl', 'Ve estado actual del ETL', 'pipeline'),
('PIP-002', 've_errores_etl', 'Consulta errores del ETL', 'pipeline'),
('PIP-003', 've_disponibilidad_datos', 'Ve disponibilidad de datos', 'pipeline'),
('PIP-004', 'solicita_reintento_etl', 'Solicita reintento de ETL', 'pipeline');

-- MOD_Reports (8 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('RPT-001', 've_reportes', 'Ve reportes tabulares', 'reports'),
('RPT-002', 've_dashboard', 'Ve dashboard principal', 'reports'),
('RPT-003', 'filtra_reportes', 'Aplica filtros a reportes', 'reports'),
('RPT-004', 'exporta_csv', 'Exporta a CSV (límite: 100K)', 'reports'),
('RPT-005', 'exporta_excel', 'Exporta a Excel (límite: 50K)', 'reports'),
('RPT-006', 'exporta_pdf', 'Exporta a PDF (límite: 10K)', 'reports'),
('RPT-007', 've_kpis', 'Ve KPIs estáticos', 'reports'),
('RPT-008', 've_graficos', 'Ve gráficos predefinidos', 'reports');

-- MOD_Alerts (6 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('ALR-001', 've_alertas', 'Ve alertas propias', 'alerts'),
('ALR-002', 'configura_alertas', 'Configura alertas personales', 'alerts'),
('ALR-003', 'configura_alertas_equipo', 'Configura alertas de equipo', 'alerts'),
('ALR-004', 'pausa_alertas', 'Pausa alertas temporalmente', 'alerts'),
('ALR-005', 'elimina_alertas', 'Elimina alertas', 'alerts'),
('ALR-006', 've_historial_alertas', 'Ve historial de alertas', 'alerts');

-- MOD_Audit (4 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('AUD-001', 've_auditoria', 'Ve registros de auditoría', 'audit'),
('AUD-002', 'busca_auditoria', 'Busca en auditoría', 'audit'),
('AUD-003', 'exporta_auditoria', 'Exporta registros de auditoría', 'audit'),
('AUD-004', 'genera_reporte_compliance', 'Genera reporte de cumplimiento', 'audit');

-- MOD_Logs (2 funciones)
INSERT INTO functions (function_id, name, description, category) VALUES
('LOG-001', 've_logs_tecnicos', 'Ve logs técnicos del sistema', 'logs'),
('LOG-002', 'exporta_logs', 'Exporta logs técnicos', 'logs');
```

### 8.9 Datos Iniciales - 10 Grupos

```sql
INSERT INTO function_groups (group_id, name, description) VALUES
('AGR-001', 'agr_operador_basico', 'Visualización básica de reportes y dashboard'),
('AGR-002', 'agr_visualizador_reportes', 'Análisis de reportes con filtros'),
('AGR-003', 'agr_supervisor_calidad', 'Supervisión con alertas'),
('AGR-004', 'agr_exportador_datos', 'Exportación autorizada de datos'),
('AGR-005', 'agr_gestor_alertas', 'Gestión completa de alertas'),
('AGR-006', 'agr_admin_usuarios', 'Administración de usuarios'),
('AGR-007', 'agr_admin_permisos', 'Administración de permisos RBAC'),
('AGR-008', 'agr_auditor', 'Auditoría y compliance'),
('AGR-009', 'agr_admin_pipeline', 'Administración del ETL'),
('AGR-010', 'agr_admin_sistema', 'Administración técnica del sistema');
```

### 8.10 Datos Iniciales - 3 Reglas SoD

```sql
-- Insertar restricciones SoD
INSERT INTO function_separation_rules 
(restriction_id, name, description, reason, cnst_reference) VALUES
('SOD-001', 'sod_admin_auditoria', 
 'Quien opera pipeline NO audita', 
 'Evitar que quien ejecuta el ETL audite sus propias acciones', 
 'CNST-005'),
('SOD-002', 'sod_usuarios_auditoria', 
 'Quien gestiona usuarios NO audita', 
 'Evitar que quien administra usuarios vea auditoría de sus acciones', 
 'CNST-005'),
('SOD-003', 'sod_acceso_auditoria', 
 'Quien gestiona acceso NO audita', 
 'Separación de poderes entre asignación y auditoría', 
 'CNST-005');

-- SOD-001 detalles
INSERT INTO function_separation_rule_details 
(restriction_id, function_id, separation_group) VALUES
('SOD-001', 'PIP-001', 'A'),
('SOD-001', 'PIP-002', 'A'),
('SOD-001', 'PIP-003', 'A'),
('SOD-001', 'PIP-004', 'A'),
('SOD-001', 'AUD-001', 'B'),
('SOD-001', 'AUD-002', 'B'),
('SOD-001', 'AUD-003', 'B'),
('SOD-001', 'AUD-004', 'B');

-- SOD-002 detalles
INSERT INTO function_separation_rule_details 
(restriction_id, function_id, separation_group) VALUES
('SOD-002', 'USR-001', 'A'),
('SOD-002', 'USR-003', 'A'),
('SOD-002', 'USR-004', 'A'),
('SOD-002', 'USR-007', 'A'),
('SOD-002', 'AUD-001', 'B'),
('SOD-002', 'AUD-002', 'B'),
('SOD-002', 'AUD-003', 'B');

-- SOD-003 detalles
INSERT INTO function_separation_rule_details 
(restriction_id, function_id, separation_group) VALUES
('SOD-003', 'ACC-001', 'A'),
('SOD-003', 'ACC-002', 'A'),
('SOD-003', 'ACC-005', 'A'),
('SOD-003', 'AUD-001', 'B'),
('SOD-003', 'AUD-002', 'B');
```

---

<a name="9-django"></a>

## 9. IMPLEMENTACIÓN DJANGO

### 9.1 Models (apps/access/models.py)

**Ver sección 7 para modelos Django completos con Clean Code v2.0.0.**

```python
"""
Modelos de control de acceso RBAC v5.2.0
Sistema IACT - 42 funciones atómicas
"""
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Function(models.Model):
    """Función atómica del sistema (42 funciones)."""
    function_id = models.CharField(max_length=20, unique=True)
    # ... resto de campos


class FunctionGroup(models.Model):
    """Grupo de funciones (10 grupos)."""
    group_id = models.CharField(max_length=20, unique=True)
    # ... resto de campos


class UserFunctionAssignment(models.Model):
    """Asignación directa de función a usuario."""
    # ... campos


class UserFunctionGroupAssignment(models.Model):
    """Asignación de grupo a usuario."""
    # ... campos


class FunctionSeparationRule(models.Model):
    """Regla de separación de funciones (3 reglas)."""
    # ... campos


class FunctionSeparationRuleDetail(models.Model):
    """Detalle de regla SoD."""
    # ... campos
```

### 9.2 Service (apps/access/services.py)

```python
"""
Servicio de permisos RBAC v5.2.0
"""
from typing import Set, Tuple
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError
from django.utils import timezone
from .models import (
    Function,
    FunctionGroup,
    UserFunctionAssignment,
    UserFunctionGroupAssignment,
    FunctionSeparationRule,
    FunctionSeparationRuleDetail,
)

User = get_user_model()


class PermissionService:
    """
    Servicio para gestión de permisos (RBAC v5.2.0).
    
    Clean Code v2.0.0:
    - Nombre descriptivo (NO "RBACService")
    - Métodos en inglés
    - Comentarios en español
    """
    
    def __init__(self, request_user: User = None):
        """
        Inicializa el servicio.
        
        Args:
            request_user: Usuario que realiza la operación
        """
        self.request_user = request_user
    
    def calculate_effective_functions(self, user: User) -> Set[str]:
        """
        Calcula funciones efectivas de un usuario.
        
        Precedencia:
        1. Funciones directas (UserFunctionAssignment)
        2. Funciones de grupos (UserFunctionGroupAssignment)
        
        Args:
            user: Usuario para calcular funciones
        
        Returns:
            Set de function_id: {'RPT-001', 'RPT-002', ...}
        """
        functions = set()
        
        # 1. Funciones directas (mayor precedencia)
        direct_assignments = UserFunctionAssignment.objects.filter(
            user=user,
        ).select_related('function')
        
        for assignment in direct_assignments:
            # Validar vencimiento
            if assignment.expiration_date:
                if assignment.expiration_date >= timezone.now().date():
                    functions.add(assignment.function.function_id)
            else:
                functions.add(assignment.function.function_id)
        
        # 2. Funciones de grupos (menor precedencia)
        group_assignments = UserFunctionGroupAssignment.objects.filter(
            user=user
        ).prefetch_related('group__functions')
        
        for assignment in group_assignments:
            functions.update(
                f.function_id 
                for f in assignment.group.functions.all()
            )
        
        return functions
    
    def validate_separation_rules(
        self,
        user: User,
        new_function_id: str
    ) -> Tuple[bool, str]:
        """
        Valida reglas SoD antes de asignar función.
        
        Args:
            user: Usuario
            new_function_id: ID de función a asignar (ej: 'RPT-001')
        
        Returns:
            (valid, error_message)
        """
        current_functions = self.calculate_effective_functions(user)
        
        # Obtener reglas SoD activas
        active_rules = FunctionSeparationRule.objects.filter(
            active=True
        )
        
        for rule in active_rules:
            # Obtener funciones de grupos A y B
            details = FunctionSeparationRuleDetail.objects.filter(
                rule=rule
            ).select_related('function')
            
            group_a = set(
                d.function.function_id 
                for d in details 
                if d.separation_group == 'A'
            )
            group_b = set(
                d.function.function_id 
                for d in details 
                if d.separation_group == 'B'
            )
            
            # Validar conflicto
            if new_function_id in group_a:
                if current_functions & group_b:
                    return False, (
                        f"Violación SoD: {rule.name}. "
                        f"Razón: {rule.reason}"
                    )
            
            if new_function_id in group_b:
                if current_functions & group_a:
                    return False, (
                        f"Violación SoD: {rule.name}. "
                        f"Razón: {rule.reason}"
                    )
        
        return True, ""
    
    def assign_function_group(
        self,
        user: User,
        group_id: str,
        assigned_by: User
    ) -> UserFunctionGroupAssignment:
        """
        Asigna grupo de funciones a usuario validando SoD.
        
        Args:
            user: Usuario destino
            group_id: ID del grupo (ej: 'AGR-001')
            assigned_by: Usuario que asigna
        
        Returns:
            Asignación creada
        
        Raises:
            ValidationError: Si viola SoD
        """
        group = FunctionGroup.objects.get(group_id=group_id)
        
        # Validar SoD para cada función del grupo
        for function in group.functions.all():
            valid, message = self.validate_separation_rules(
                user,
                function.function_id
            )
            if not valid:
                raise ValidationError(message)
        
        # Asignar grupo
        assignment = UserFunctionGroupAssignment.objects.create(
            user=user,
            group=group,
            assigned_by=assigned_by
        )
        
        # Auditar (CNST-009)
        from apps.audit.services import AuditService
        AuditService.record_action(
            user=assigned_by,
            action='ASSIGN_FUNCTION_GROUP',
            resource_type='User',
            resource_id=str(user.id),
            details={
                'group_id': group_id,
                'group_name': group.name
            }
        )
        
        return assignment
```

### 9.3 Decorator (apps/access/decorators.py)

```python
"""
Decoradores para control de acceso RBAC v5.2.0
"""
from functools import wraps
from django.core.exceptions import PermissionDenied


def require_function(*required_function_ids):
    """
    Decorator que valida función RBAC.
    
    El usuario debe tener AL MENOS UNA de las funciones requeridas.
    
    Args:
        *required_function_ids: IDs de funciones requeridas
    
    Uso:
        @require_function('RPT-001', 'RPT-002')
        def list_reports(request):
            ...
    
    CNST-009: Audita intentos de acceso denegado.
    """
    def decorator(view_func):
        @wraps(view_func)
        def wrapper(request, *args, **kwargs):
            # Validar autenticación
            if not request.user.is_authenticated:
                raise PermissionDenied("Usuario no autenticado")
            
            # Obtener funciones del usuario
            user_functions = getattr(request, 'user_functions', set())
            
            # Validar si tiene alguna función requerida
            has_permission = any(
                fid in user_functions 
                for fid in required_function_ids
            )
            
            if not has_permission:
                # Auditar acceso denegado
                from apps.audit.services import AuditService
                AuditService.record_action(
                    user=request.user,
                    action='ACCESS_DENIED',
                    resource_type='Endpoint',
                    resource_id=request.path,
                    result='FAIL',
                    details={
                        'required_functions': list(required_function_ids),
                        'user_functions': list(user_functions)
                    }
                )
                
                raise PermissionDenied(
                    f"Requiere una de: {', '.join(required_function_ids)}"
                )
            
            return view_func(request, *args, **kwargs)
        
        return wrapper
    return decorator
```

### 9.4 Middleware (apps/access/middleware.py)

```python
"""
Middleware de permisos RBAC v5.2.0
"""
from django.utils.deprecation import MiddlewareMixin
from .services import PermissionService


class PermissionMiddleware(MiddlewareMixin):
    """
    Middleware que inyecta funciones efectivas en cada request.
    
    Inyecta `request.user_functions` con las funciones del usuario.
    
    CNST-002: Valida sesión única por usuario.
    """
    
    def __init__(self, get_response):
        """Inicializa el middleware."""
        self.get_response = get_response
        self.permission_service = PermissionService()
    
    def __call__(self, request):
        """
        Procesa el request.
        
        Args:
            request: HttpRequest
        
        Returns:
            HttpResponse
        """
        if request.user.is_authenticated:
            # Calcular funciones efectivas
            request.user_functions = (
                self.permission_service.calculate_effective_functions(
                    request.user
                )
            )
            
            # CNST-002: Validar sesión única
            self._validate_single_session(request)
        else:
            request.user_functions = set()
        
        response = self.get_response(request)
        return response
    
    def _validate_single_session(self, request):
        """
        CNST-002: Solo una sesión activa por usuario.
        
        Si detecta sesión duplicada, invalida la anterior.
        """
        from django.contrib.sessions.models import Session
        from django.utils import timezone
        
        current_session_key = request.session.session_key
        
        # Buscar otras sesiones del mismo usuario
        active_sessions = Session.objects.filter(
            expire_date__gte=timezone.now()
        )
        
        for session in active_sessions:
            data = session.get_decoded()
            session_user_id = data.get('_auth_user_id')
            
            if session_user_id == str(request.user.id):
                if session.session_key != current_session_key:
                    # Invalidar sesión anterior
                    session.delete()
```

### 9.5 Management Command

```bash
# Inicializar RBAC v5.2.0
python manage.py initialize_permissions

# O paso a paso:
python manage.py initialize_functions      # 42 funciones
python manage.py initialize_function_groups  # 10 grupos
python manage.py initialize_separation_rules  # 3 reglas SoD
```

---

<a name="10-mapeo-uc"></a>

## 10. MAPEO FUNCIONES → CASOS DE USO

### 10.1 Tabla Completa

| Función | Casos de Uso | Módulo |
|---------|--------------|--------|
| gestiona_sesiones | UC-005 | Auth |
| cierra_sesion_usuario | UC-005 | Auth |
| resetea_password | UC-003 | Auth |
| ve_sesiones_activas | UC-005 | Auth |
| crea_usuarios | UC-006 | Users |
| modifica_usuarios | UC-007 | Users |
| elimina_usuarios | UC-008 | Users |
| lista_usuarios | UC-009 | Users |
| busca_usuarios | UC-009 | Users |
| bloquea_usuarios | UC-007 | Users |
| desbloquea_usuarios | UC-007 | Users |
| reactiva_usuarios | UC-007 | Users |
| ve_usuarios | UC-009 | Users |
| asigna_funciones | UC-010, UC-042 | Access |
| revoca_funciones | UC-010 | Access |
| ve_asignaciones | UC-011, UC-044 | Access |
| asigna_agrupadores | UC-010 | Access |
| gestiona_sod | UC-043 | Access |
| ve_estado_etl | UC-050 | Pipeline |
| ve_errores_etl | UC-051 | Pipeline |
| ve_disponibilidad_datos | UC-052 | Pipeline |
| solicita_reintento_etl | UC-053 | Pipeline |
| ve_reportes | UC-017, UC-018, UC-019 | Reports |
| ve_dashboard | UC-025 | Reports |
| filtra_reportes | UC-020, UC-021 | Reports |
| exporta_csv | UC-022 | Reports |
| exporta_excel | UC-023 | Reports |
| exporta_pdf | UC-024 | Reports |
| ve_kpis | UC-025 | Reports |
| ve_graficos | UC-027, UC-028, UC-029 | Reports |
| ve_alertas | UC-039 | Alerts |
| configura_alertas | UC-036 | Alerts |
| configura_alertas_equipo | UC-040 | Alerts |
| pausa_alertas | UC-038 | Alerts |
| elimina_alertas | UC-038 | Alerts |
| ve_historial_alertas | UC-039 | Alerts |
| ve_auditoria | UC-061 | Audit |
| busca_auditoria | UC-061 | Audit |
| exporta_auditoria | UC-063 | Audit |
| genera_reporte_compliance | UC-062 | Audit |
| ve_logs_tecnicos | UC-070, UC-071 | Logs |
| exporta_logs | UC-072 | Logs |

---

<a name="11-migracion"></a>

## 11. MIGRACIÓN DESDE v5.1

### 11.1 Cambios Breaking

| Aspecto | v5.1 | v5.2 |
|---------|------|------|
| **Funciones** | 44 | 42 (-2) |
| **Segmentos** | ✅ Existen | ❌ Eliminados |
| **Nomenclatura** | Español | Inglés (Clean Code) |

### 11.2 Pasos de Migración

#### Paso 1: Backup

```bash
# Backup BD
mysqldump iact_db > backup_v5_1.sql
```

#### Paso 2: Eliminar Funciones Obsoletas

```sql
-- Eliminar asignaciones de funciones obsoletas
DELETE FROM user_function_assignments 
WHERE function_id IN ('USR-010', 'ACC-006');

-- Eliminar funciones obsoletas
DELETE FROM functions 
WHERE function_id IN ('USR-010', 'ACC-006');
```

#### Paso 3: Eliminar Segmentos

```sql
-- Eliminar asignaciones de segmentos
DROP TABLE IF EXISTS user_data_segment;

-- Eliminar segmentos
DROP TABLE IF EXISTS data_segments;
```

#### Paso 4: Renombrar Tablas (si aplicable)

```sql
-- Si usas las tablas v5.1 con nombres en español
ALTER TABLE funciones RENAME TO functions;
ALTER TABLE agrupadores RENAME TO function_groups;
ALTER TABLE usuario_funcion RENAME TO user_function_assignments;
ALTER TABLE usuario_agrupador RENAME TO user_function_group_assignments;
ALTER TABLE separacion_funciones RENAME TO function_separation_rules;
ALTER TABLE separacion_funciones_detalle RENAME TO function_separation_rule_details;
```

#### Paso 5: Aplicar Migraciones Django

```bash
python manage.py makemigrations
python manage.py migrate
```

#### Paso 6: Inicializar Datos

```bash
python manage.py initialize_permissions
```

#### Paso 7: Validar

```bash
# Verificar funciones
python manage.py shell
>>> from apps.access.models import Function
>>> Function.objects.count()
42  # ✅ Correcto

# Verificar grupos
>>> from apps.access.models import FunctionGroup
>>> FunctionGroup.objects.count()
10  # ✅ Correcto

# Verificar SoD
>>> from apps.access.models import FunctionSeparationRule
>>> FunctionSeparationRule.objects.count()
3  # ✅ Correcto
```

### 11.3 Checklist de Migración

```
□ Backup de BD realizado
□ Funciones USR-010 y ACC-006 eliminadas
□ Tablas de segmentos eliminadas
□ Tablas renombradas (si aplica)
□ Migraciones Django aplicadas
□ Datos inicializados (42 funciones, 10 grupos, 3 SoD)
□ Tests pasando
□ Validación manual completada
□ Documentación actualizada
□ Equipo notificado de cambios
```

---

## 12. RESUMEN

### 12.1 Métricas del Modelo v5.2

| Aspecto | Valor | Nota |
|---------|-------|------|
| **Filosofía** | Sin Pretensiones | Funciones describen QUÉ HACE |
| **Módulos IACT** | 8 | Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs |
| **Funciones atómicas** | 42 | Antes 44 (eliminadas USR-010, ACC-006) |
| **Grupos** | 10 | Mecanismo de asignación masiva |
| **Restricciones SoD** | 3 | Incompatibilidades obligatorias |
| **Segmentos de datos** | 0 | ❌ Eliminados desde v5.2 |
| **Restricciones CNST** | 8 | Restricciones arquitectónicas globales |
| **Nomenclatura** | Inglés | Clean Code v2.0.0 aplicado |

### 12.2 Cambios Destacados v5.2

1. **✅ Clean Code aplicado:**
   - `FunctionGroup` (NO "Grouper" ni "Agrupador")
   - `UserFunctionAssignment` (NO "UserFunction")
   - `UserFunctionGroupAssignment` (NO "UserGrouper")
   - `FunctionSeparationRule` (NO "SeparationOfDuties")

2. **✅ 42 funciones:**
   - ❌ Eliminada USR-010 (asignar segmento)
   - ❌ Eliminada ACC-006 (gestionar segmentos)

3. **✅ Sin segmentos de datos:**
   - ❌ No hay tabla `data_segments`
   - ❌ No hay tabla `user_data_segment`

4. **✅ Código inglés + comentarios español:**
   - Clases: Inglés
   - Docstrings: Español
   - `help_text`: Español

### 12.3 Lo que NO cambió

- ✅ 8 módulos funcionales
- ✅ 10 grupos de funciones
- ✅ 3 restricciones SoD
- ✅ Nombres de funciones (dominio español): `ve_reportes`, `exporta_csv`, etc.
- ✅ Filosofía "Sin Pretensiones"
- ✅ Flat RBAC (sin jerarquías)

---

**FIN DEL DOCUMENTO**

**Versión:** 5.2.0  
**Fecha:** 13 de enero de 2026  
**Estado:** Listo para Implementación  
**Changelog:** 
- v5.1 → v5.2: -2 funciones, -segmentos, +Clean Code
- Base: MODELO_RBAC_IACT_v5_1_1.md
- Actualización: Clean Code v2.0.0
