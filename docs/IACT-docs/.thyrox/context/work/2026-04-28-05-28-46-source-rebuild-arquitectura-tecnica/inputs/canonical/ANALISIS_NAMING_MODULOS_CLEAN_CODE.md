# ANÁLISIS DE NAMING: Módulos del Sistema IACT

## Aplicando Clean Code Naming Principles de Robert Martin

---

## ANÁLISIS DE NOMBRES ACTUALES

### Nombres Actuales (Problema: Verbosidad Excesiva)

```
ARQ_MOD_001_AUTH
ARQ_MOD_002_USER_IDENTITY  
ARQ_MOD_003_RBAC_CORE
ARQ_MOD_004_ETL_MONITORING
ARQ_MOD_005_VIS_REPORTS
ARQ_MOD_006_ALERTS
ARQ_MOD_007_AUDIT
ARQ_MOD_008_SYS_LOGS
```

### Evaluación contra Clean Code:

| Principio | Evaluación | Problema |
|-----------|------------|----------|
| **Revela intención** | ✅ Sí | Pero con exceso |
| **Pronunciable** | ❌ No | "ARQ_MOD_001" es trabalenguas |
| **Buscable** | ✅ Sí | Pero imprácticamente largo |
| **Evita codificación** | ❌ No | "ARQ_MOD_001" es código interno |
| **Evita asignación mental** | ❌ No | Hay que traducir "001" mentalmente |
| **Longitud apropiada** | ❌ No | Demasiado largo para el scope |

---

## PROBLEMAS IDENTIFICADOS

### 1. Prefijo "ARQ_MOD_" es redundante
- Ya sabemos que son módulos de arquitectura por el contexto (carpeta, documento)
- Viola: "No añadir palabras que no aportan valor semántico"

### 2. Números secuenciales "001, 002..."
- Requieren traducción mental
- "001" no dice nada sobre AUTH
- Viola: "Evitar codificaciones" y "Evitar asignaciones mentales"

### 3. Nombres compuestos impronunciables
- "ARQ_MOD_004_ETL_MONITORING" - ¿cómo lo pronuncias en una reunión?
- Viola: "Usar nombres que se puedan pronunciar"

---

## PROPUESTA DE NOMBRES CLEAN CODE

### Opción A: Nombres Simples y Directos

| Actual | Propuesto | Justificación |
|--------|-----------|---------------|
| ARQ_MOD_001_AUTH | **Auth** | Revela intención, pronunciable, buscable |
| ARQ_MOD_002_USER_IDENTITY | **Users** | Simple, directo, todo el mundo entiende |
| ARQ_MOD_003_RBAC_CORE | **Access** | Describe qué hace (control de acceso) |
| ARQ_MOD_004_ETL_MONITORING | **DataPipeline** | Más claro que "ETL" para no-técnicos |
| ARQ_MOD_005_VIS_REPORTS | **Reports** | Directo, obvio |
| ARQ_MOD_006_ALERTS | **Alerts** | Perfecto como está |
| ARQ_MOD_007_AUDIT | **Audit** | Perfecto como está |
| ARQ_MOD_008_SYS_LOGS | **Logs** | Simple, todos entienden |

### Opción B: Nombres con Prefijo de Dominio (si necesitas agrupar)

| Actual | Propuesto | Dominio |
|--------|-----------|---------|
| ARQ_MOD_001_AUTH | **MOD_Auth** | Autenticación |
| ARQ_MOD_002_USER_IDENTITY | **MOD_Users** | Identidad |
| ARQ_MOD_003_RBAC_CORE | **MOD_Access** | Control de Acceso |
| ARQ_MOD_004_ETL_MONITORING | **MOD_Pipeline** | Datos |
| ARQ_MOD_005_VIS_REPORTS | **MOD_Reports** | Visualización |
| ARQ_MOD_006_ALERTS | **MOD_Alerts** | Notificaciones |
| ARQ_MOD_007_AUDIT | **MOD_Audit** | Auditoría |
| ARQ_MOD_008_SYS_LOGS | **MOD_Logs** | Técnico |

### Opción C: Nombres Descriptivos Cortos (Equilibrio)

| Actual | Propuesto | Pronunciación |
|--------|-----------|---------------|
| ARQ_MOD_001_AUTH | **AuthSessions** | "Auth Sessions" |
| ARQ_MOD_002_USER_IDENTITY | **UserAccounts** | "User Accounts" |
| ARQ_MOD_003_RBAC_CORE | **AccessControl** | "Access Control" |
| ARQ_MOD_004_ETL_MONITORING | **DataPipeline** | "Data Pipeline" |
| ARQ_MOD_005_VIS_REPORTS | **Dashboards** | "Dashboards" |
| ARQ_MOD_006_ALERTS | **Notifications** | "Notifications" |
| ARQ_MOD_007_AUDIT | **AuditTrail** | "Audit Trail" |
| ARQ_MOD_008_SYS_LOGS | **SystemLogs** | "System Logs" |

---

## RECOMENDACIÓN FINAL

### Para documentación técnica formal (RTM, SRS):

Usar **Opción B con números** si necesitas ordenamiento:

```
MOD-01 Auth
MOD-02 Users  
MOD-03 Access
MOD-04 Pipeline
MOD-05 Reports
MOD-06 Alerts
MOD-07 Audit
MOD-08 Logs
```

**Justificación:**
- "MOD-01" es más pronunciable que "ARQ_MOD_001"
- El guión mejora legibilidad vs underscore
- Nombres cortos pero descriptivos
- Fácil de referenciar en conversación: "el módulo de Auth" o "MOD-01"

### Para código y APIs:

Usar **Opción A** (nombres simples):

```python
# apps/auth/
# apps/users/
# apps/access/
# apps/pipeline/
# apps/reports/
# apps/alerts/
# apps/audit/
# apps/logs/
```

**Justificación:**
- Convención Django/Python de nombres cortos para apps
- Fácil de importar: `from apps.auth import ...`
- Pronunciable en code reviews

---

## TABLA COMPARATIVA FINAL

| # | Doc Formal | Código | Descripción Corta |
|---|------------|--------|-------------------|
| 1 | MOD-01 Auth | auth | Autenticación y Sesiones |
| 2 | MOD-02 Users | users | Gestión de Identidades |
| 3 | MOD-03 Access | access | Roles, Permisos, Segmentos |
| 4 | MOD-04 Pipeline | pipeline | Supervisión del ETL |
| 5 | MOD-05 Reports | reports | Dashboards y Reportes |
| 6 | MOD-06 Alerts | alerts | Alertas y Notificaciones |
| 7 | MOD-07 Audit | audit | Auditoría Funcional |
| 8 | MOD-08 Logs | logs | Bitácoras Técnicas |

---

## VALIDACIÓN CONTRA CLEAN CODE

| Principio | Antes | Después |
|-----------|-------|---------|
| Revela intención | ✅ Verboso | ✅ Conciso |
| Pronunciable | ❌ Trabalenguas | ✅ "Módulo de Auth" |
| Buscable | ✅ Único | ✅ Único |
| Sin codificación | ❌ "ARQ_MOD_001" | ✅ "MOD-01 Auth" |
| Sin traducción mental | ❌ "001 = ?" | ✅ "Auth = Autenticación" |
| Longitud apropiada | ❌ 20+ chars | ✅ 8-15 chars |
| Una palabra por concepto | ⚠️ Inconsistente | ✅ Consistente |

---

## APLICACIÓN AL PROYECTO IACT

Si decides usar esta nomenclatura, los documentos quedarían:

**Archivos de Arquitectura:**
```
MOD-01_Auth.rst
MOD-02_Users.rst
MOD-03_Access.rst
MOD-04_Pipeline.rst
MOD-05_Reports.rst
MOD-06_Alerts.rst
MOD-07_Audit.rst
MOD-08_Logs.rst
```

**En conversación:**
- "El módulo de Access tiene el SEC_RULES integrado"
- "MOD-05 Reports incluye dashboards y exportaciones"
- "¿Ya revisaste el MOD-07 Audit?"

**En código:**
```python
INSTALLED_APPS = [
    'apps.auth',
    'apps.users', 
    'apps.access',
    'apps.pipeline',
    'apps.reports',
    'apps.alerts',
    'apps.audit',
    'apps.logs',
]
```

---

*Análisis basado en Clean Code Naming Principles - Robert C. Martin*
