# ANÁLISIS PROFUNDO: MODELO RBAC v5.1.1 + MÓDULOS IACT

**Fecha de Análisis:** 2026-01-11  
**Documentos Analizados:**
- MODELO_RBAC_IACT_v5_1_1.md (1,655 líneas, 58KB)
- REFERENCIA_GLOBAL_MODULOS_IACT_v1.md (664 líneas, 22KB)

**Alcance:** Análisis exhaustivo de arquitectura RBAC y módulos funcionales del Sistema IACT

---

## 📋 TABLA DE CONTENIDO

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Arquitectura del Sistema IACT](#arquitectura-sistema)
3. [Modelo RBAC v5.1.1 Detallado](#modelo-rbac)
4. [Módulos Funcionales](#modulos-funcionales)
5. [Restricciones Globales (CNST)](#restricciones-cnst)
6. [Separación de Funciones (SoD)](#sod)
7. [Segmentos de Datos](#segmentos)
8. [Contraste con Documentación Actual](#contraste-documentacion)
9. [Impacto en Fases Pendientes](#impacto-fases)
10. [Recomendaciones y Próximos Pasos](#recomendaciones)

---

<a name="resumen-ejecutivo"></a>
## 1. RESUMEN EJECUTIVO

### 1.1 Hallazgos Principales

```
╔══════════════════════════════════════════════════════════════════╗
║              SISTEMA IACT - ARQUITECTURA RBAC v5.1.1             ║
╚══════════════════════════════════════════════════════════════════╝

FILOSOFÍA: "Sin Pretensiones" - Funciones atómicas sobre roles abstractos

COMPONENTES CLAVE:
├── 8 Módulos Funcionales
├── 44 Funciones Atómicas
├── 10 Agrupadores (bundles de funciones)
├── 3 Restricciones SoD (Separation of Duties)
├── 5 Segmentos de Datos
├── 8 Restricciones Globales (CNST)
└── Permisos Temporales con justificación obligatoria

CAMBIO FUNDAMENTAL:
  ANTES (v4.0): HasRole(['R004', 'R005'])
  AHORA (v5.1): HasFunction('ve_reportes')
```

### 1.2 Métricas del Modelo

| Aspecto | Valor | Nota |
|---------|-------|------|
| **Módulos IACT** | 8 | Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs |
| **Funciones atómicas** | 44 | Distribuidas por módulo |
| **Agrupadores** | 10 | Mecanismo de asignación masiva |
| **Restricciones SoD** | 3 | Incompatibilidades obligatorias |
| **Segmentos de datos** | 5 | Particionamiento automático |
| **Restricciones CNST** | 8 | Restricciones arquitectónicas globales |
| **Casos de Uso** | ~70 | Mapeados a funciones RBAC |

### 1.3 Impacto en Documentación Actual

**CRÍTICO:** Este modelo RBAC v5.1.1 es **FUNDAMENTAL** para:
- ✅ Actualización documentos CNST v1.0.0 → v1.1.0
- ✅ Regeneración de 49 UCs con funciones RBAC correctas
- ✅ Templates de documentación (referencias a permisos)
- ✅ Material pedagógico (ejemplos de control de acceso)

---

<a name="arquitectura-sistema"></a>
## 2. ARQUITECTURA DEL SISTEMA IACT

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
│  │ 4 funciones│ 10 funciones │ 6 funciones    │             │
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

### 2.2 Distribución de Funciones por Módulo

| Módulo | Código | Funciones | Porcentaje | Propósito |
|--------|--------|-----------|------------|-----------|
| MOD_Auth | AUT | 4 | 9.1% | Sesiones y autenticación |
| MOD_Users | USR | 10 | 22.7% | Gestión de identidades |
| MOD_Access | ACC | 6 | 13.6% | RBAC core + SEC_RULES |
| MOD_Pipeline | PIP | 4 | 9.1% | Supervisión ETL |
| **MOD_Reports** | **RPT** | **8** | **18.2%** | **Reportes/Dashboards** |
| MOD_Alerts | ALR | 6 | 13.6% | Alertas internas |
| MOD_Audit | AUD | 4 | 9.1% | Auditoría funcional |
| MOD_Logs | LOG | 2 | 4.5% | Logs técnicos |
| **TOTAL** | - | **44** | **100%** | - |

**Observación clave:** MOD_Reports + MOD_Alerts (31.8% de funciones) es el núcleo operativo del sistema.

---

<a name="modelo-rbac"></a>
## 3. MODELO RBAC v5.1.1 DETALLADO

### 3.1 Filosofía del Modelo

> **Principio Central:**
> "Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona"

```yaml
ANTES (v4.0 - Roles abstractos):
  rol: SYSTEM_ADMIN
  problema: ¿Qué puede hacer un SYSTEM_ADMIN?

AHORA (v5.1 - Funciones descriptivas):
  función: solicita_reintento_etl
  claridad: "Puede solicitar reintento del ETL"
```

### 3.2 Las 44 Funciones Atómicas

#### Grupo A: MOD_Auth (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUT-001 | `gestiona_sesiones` | auth:sesiones | UC-005 | Gestiona sesiones activas |
| AUT-002 | `cierra_sesion_usuario` | auth:cerrar_sesion | UC-005 | Cierra sesión de otro usuario |
| AUT-003 | `resetea_password` | auth:reset_password | UC-003 | Genera contraseña temporal |
| AUT-004 | `ve_sesiones_activas` | auth:ver_sesiones | UC-005 | Ve sesiones activas |

**CNST aplicables:** CNST_001 (NO email), CNST_002 (sesión única, 15 min timeout)

#### Grupo B: MOD_Users (10 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| USR-001 | `crea_usuarios` | users:crear | UC-006 | Crea nuevos usuarios |
| USR-002 | `ve_usuarios` | users:leer | UC-009 | Consulta información |
| USR-003 | `modifica_usuarios` | users:modificar | UC-007 | Modifica datos |
| USR-004 | `elimina_usuarios` | users:eliminar | UC-008 | Baja lógica |
| USR-005 | `lista_usuarios` | users:listar | UC-009 | Lista con filtros |
| USR-006 | `busca_usuarios` | users:buscar | UC-009 | Busca por criterios |
| USR-007 | `bloquea_usuarios` | users:bloquear | UC-007 | Bloquea acceso |
| USR-008 | `desbloquea_usuarios` | users:desbloquear | UC-007 | Desbloquea |
| USR-009 | `reactiva_usuarios` | users:reactivar | UC-007 | Reactiva inactivo |
| USR-010 | `asigna_segmento` | users:asignar_segmento | UC-041 | Asigna segmento |

**CNST aplicables:** CNST_001 (NO email), CNST_005 (bajas lógicas)

#### Grupo C: MOD_Access (6 funciones) - CORE RBAC

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ACC-001 | `asigna_funciones` | access:asignar | UC-010, UC-042 | Asigna funciones |
| ACC-002 | `revoca_funciones` | access:revocar | UC-010 | Revoca funciones |
| ACC-003 | `ve_asignaciones` | access:ver | UC-011, UC-044 | Ve asignaciones |
| ACC-004 | `asigna_agrupadores` | access:asignar_agrupador | UC-010 | Asigna bundles |
| ACC-005 | `gestiona_sod` | access:sod | UC-043 | Configura SoD |
| ACC-006 | `gestiona_segmentos` | access:segmentos | UC-045, UC-046 | Gestiona segmentos |

**Componente SEC_RULES:** Middleware automático de enforcement (no visible al usuario)

#### Grupo D: MOD_Pipeline (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| PIP-001 | `ve_estado_etl` | pipeline:ver_estado | UC-050 | Ve estado ETL |
| PIP-002 | `ve_errores_etl` | pipeline:ver_errores | UC-051 | Consulta errores |
| PIP-003 | `ve_disponibilidad_datos` | pipeline:disponibilidad | UC-052 | Disponibilidad datos |
| PIP-004 | `solicita_reintento_etl` | pipeline:reintento | UC-053 | Solicita reintento |

**CNST aplicables:** CNST_003 (BD IVR readonly, ETL 6-12h, NO real-time)

#### Grupo E: MOD_Reports (8 funciones) ⭐ CORE NEGOCIO

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| RPT-001 | `ve_reportes` | reports:ver | UC-017,018,019 | Ve reportes tabulares |
| RPT-002 | `ve_dashboard` | reports:dashboard | UC-025 | Ve dashboard principal |
| RPT-003 | `filtra_reportes` | reports:filtrar | UC-020, UC-021 | Aplica filtros |
| RPT-004 | `exporta_csv` | reports:exportar_csv | UC-022 | Exporta CSV (límite: 100K) |
| RPT-005 | `exporta_excel` | reports:exportar_excel | UC-023 | Exporta Excel (límite: 50K) |
| RPT-006 | `exporta_pdf` | reports:exportar_pdf | UC-024 | Exporta PDF (límite: 10K) |
| RPT-007 | `ve_kpis` | reports:kpis | UC-025 | Ve KPIs estáticos |
| RPT-008 | `ve_graficos` | reports:graficos | UC-027,028,029 | Ve gráficos |

**CNST aplicables:** 
- CNST_003 (datos desfasados, NO real-time)
- CNST_006 (rango máx 2 años)
- CNST_007 (límites exportación, throttling)

**Límites de exportación:**

| Formato | Max Registros | Límite Diario | Timeout |
|---------|---------------|---------------|---------|
| CSV | 100,000 | 10 | 60s |
| Excel | 50,000 | 5 | 90s |
| PDF | 10,000 | 3 | 120s |

#### Grupo F: MOD_Alerts (6 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| ALR-001 | `ve_alertas` | alerts:ver | UC-039 | Ve alertas propias |
| ALR-002 | `configura_alertas` | alerts:configurar | UC-036 | Configura personales |
| ALR-003 | `configura_alertas_equipo` | alerts:config_equipo | UC-040 | Alertas para equipo |
| ALR-004 | `pausa_alertas` | alerts:pausar | UC-038 | Pausa alertas (snooze) |
| ALR-005 | `elimina_alertas` | alerts:eliminar | UC-036 | Elimina propias |
| ALR-006 | `ve_historial_alertas` | alerts:historial | UC-039 | Ve historial |

**CNST aplicables:** CNST_001 (NO email), CNST_004 (máx 50 destinatarios, buzón interno)

#### Grupo G: MOD_Audit (4 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| AUD-001 | `ve_auditoria` | audit:ver | UC-061 | Ve logs auditoría |
| AUD-002 | `busca_auditoria` | audit:buscar | UC-061 | Busca con filtros |
| AUD-003 | `exporta_auditoria` | audit:exportar | UC-063 | Exporta logs |
| AUD-004 | `genera_reporte_compliance` | audit:compliance | UC-062 | Reportes compliance |

**CNST aplicables:** CNST_008 (inmutable, retención 2+ años, NO PII)

#### Grupo H: MOD_Logs (2 funciones)

| ID | Función | Capacidad | UC | Descripción |
|----|---------|-----------|-----|-------------|
| LOG-001 | `ve_logs_tecnicos` | logs:ver | UC-070, UC-071 | Ve logs técnicos |
| LOG-002 | `exporta_logs` | logs:exportar | UC-072 | Exporta logs |

**CNST aplicables:** CNST_008 (PII enmascarada, retención 30-90 días)

### 3.3 Los 10 Agrupadores

> **Agrupador = Bundle de funciones** (NO es un rol, crea N asignaciones individuales)

| ID | Agrupador | Funciones | Usuarios Est. | Descripción |
|----|-----------|-----------|---------------|-------------|
| AGR-001 | `agr_operador_basico` | 5 | 50-100 | Consulta básica |
| AGR-002 | `agr_operador_reportes` | 8 | 30-50 | Acceso completo reportes |
| AGR-003 | `agr_supervisor` | 12 | 20-40 | Supervisor + alertas equipo |
| AGR-004 | `agr_exportador` | 3 | 30-50 | Exportación reportes |
| AGR-005 | `agr_gestor_alertas` | 6 | 15-30 | Gestión alertas |
| AGR-006 | `agr_admin_usuarios` | 12 | 5-10 | Admin usuarios |
| AGR-007 | `agr_admin_acceso` | 6 | 2-5 | Admin RBAC |
| AGR-008 | `agr_auditor` | 4 | 3-5 | Auditoría/compliance |
| AGR-009 | `agr_admin_pipeline` | 4 | 2-3 | Supervisión ETL |
| AGR-010 | `agr_admin_logs` | 2 | 2-3 | Logs técnicos |

**Matriz Agrupador → Módulos:**

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

<a name="modulos-funcionales"></a>
## 4. MÓDULOS FUNCIONALES

### 4.1 Matriz de Capacidades

| Módulo | PUEDE hacer | NO PUEDE hacer |
|--------|-------------|----------------|
| **MOD_Auth** | Login/logout, JWT, sesiones BD, timeout 15min, throttling, recuperación password | Roles/permisos, gestión usuarios, envío emails, alertas |
| **MOD_Users** | Alta/baja lógica, modificar, listar, estados, preguntas seguridad, password temporal | Asignar roles, segmentos, permisos, SoD, envío emails |
| **MOD_Access** | Admin roles, asignar funciones, SoD, segmentos, permisos directos, calcular efectivos, SEC_RULES | UI negocio, crear usuarios, autenticar, lógica negocio |
| **MOD_Pipeline** | Histórico ETL, errores, disponibilidad datos, períodos cargados, desfasajes, solicitar reintento | Ejecutar ETL, modificar config, reportes negocio, consultar IVR directo, logs crudos |
| **MOD_Reports** | Dashboards predefinidos, reportes SQL, filtros, gráficos, KPIs, exportar (CSV/Excel/PDF), segmentos | Ejecutar ETL, consultar IVR, real-time, personalizar dashboards, query builder, OLAP, emails |
| **MOD_Alerts** | Crear/config alertas, umbrales, destinatarios, evaluar periódicamente, buzón interno, snooze, historial | Envío emails, consultar IVR, real-time extremo, reportes, permisos |
| **MOD_Audit** | Registrar eventos (append-only), capturar quién/qué/cuándo, antes/después, consultar con filtros, compliance | Modificar registros, eliminar, logs técnicos, reglas acceso |
| **MOD_Logs** | Logs JSON estructurados, niveles (DEBUG-CRIT), stack traces, métricas, rotar 30-90 días, integrar ELK/Loki | Eventos negocio, exponer PII, retención indefinida, reglas seguridad |

### 4.2 Dependencias Entre Módulos

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUJO DE DEPENDENCIAS                     │
└─────────────────────────────────────────────────────────────┘

MOD_Auth ──────► MOD_Users (consulta identidad)
    │
    └─────────► MOD_Access (consulta permisos)
    │
    └─────────► MOD_Audit (envía eventos)

MOD_Users ─────► MOD_Access (solicita asignación)
    │
    └─────────► MOD_Audit (envía eventos)
    │
    └─────────► MOD_Alerts (buzón interno)

MOD_Access ────► MOD_Audit (envía eventos)
    │
    └─────────► TODOS (provee permisos via SEC_RULES)

MOD_Pipeline ──► MOD_Logs (logs técnicos)
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

MOD_Audit ─────► MOD_Access (consulta permisos)

MOD_Logs ──────► (solo recibe de todos)
```

### 4.3 Diferenciación AUDIT vs LOGS

| Aspecto | MOD_Audit | MOD_Logs |
|---------|-----------|----------|
| **Pregunta** | ¿Quién hizo qué? | ¿Qué pasó técnicamente? |
| **Vista** | Negocio/Cumplimiento | Técnico/Operación |
| **Audiencia** | Auditores, seguridad, compliance | Devs, SRE, soporte |
| **Mutabilidad** | Inmutable (append-only) | Rotable |
| **Retención** | 2+ años | 30-90 días |
| **Ejemplo** | "Usuario X exportó reporte Y a las 14:32" | "Query tardó 5200ms (SLA: 5000ms)" |
| **Formato** | Eventos estructurados con antes/después | Logs JSON con stack traces |

---

<a name="restricciones-cnst"></a>
## 5. RESTRICCIONES GLOBALES (CNST)

### 5.1 Las 8 Restricciones Arquitectónicas

| CNST | Descripción | Módulos Afectados | Funciones Afectadas |
|------|-------------|-------------------|---------------------|
| **CNST_001** | NO email bajo ninguna circunstancia | TODOS | resetea_password, configura_alertas, crea_usuarios |
| **CNST_002** | Sesión única, BD (no Redis), timeout 15 min | MOD_Auth | gestiona_sesiones |
| **CNST_003** | BD IVR readonly, ETL 6-12h, NO real-time | Pipeline, Reports | ve_estado_etl, ve_reportes, TODOS Reports |
| **CNST_004** | Alertas buzón interno, máx 50 destinatarios | MOD_Alerts | configura_alertas, configura_alertas_equipo |
| **CNST_005** | Flat RBAC, SoD, permisos con vencimiento | MOD_Access | TODO el modelo RBAC |
| **CNST_006** | Reportes: rango máx 2 años, timeouts | MOD_Reports | filtra_reportes, TODOS Reports |
| **CNST_007** | Límites exportación, throttling | Reports, Access | exporta_csv, exporta_excel, exporta_pdf |
| **CNST_008** | Audit inmutable, logs sin PII, retención | Audit, Logs | ve_auditoria, busca_auditoria, ve_logs_tecnicos |

### 5.2 CNST_005 en Detalle (CORE RBAC)

```yaml
CNST_005: Modelo RBAC Flat (NIST)
────────────────────────────────────

Características:
  - Flat RBAC (sin jerarquías de roles)
  - Funciones atómicas sobre roles abstractos
  - Precedencia: Permiso Directo > Función Asignada > Segmento
  - SoD (Separation of Duties) obligatorio
  - Permisos directos SIEMPRE con justificación (mín. 20 chars)
  - Permisos directos SIEMPRE con vencimiento (máx. 6 meses)
  - Bajas SIEMPRE lógicas, nunca físicas
  - Username autogenerado
  - Estado inicial PENDIENTE_CONFIGURACION

Restricciones SoD definidas:
  1. SYSTEM_ADMIN ⚔️ AUDIT_VIEWER
  2. REPORT_ADMIN ⚔️ REPORT_EXPORTER  
  3. USER_ADMIN ⚔️ PERMISSION_ADMIN

En v5.1-IACT:
  1. admin_pipeline ⚔️ auditor
  2. admin_usuarios ⚔️ auditor
  3. admin_acceso ⚔️ auditor
```

---

<a name="sod"></a>
## 6. SEPARACIÓN DE FUNCIONES (SoD)

### 6.1 Las 3 Restricciones SoD

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| **SOD-001** | sod_admin_auditoria | Pipeline (4 func) | Auditoría (4 func) | Quien opera NO audita |
| **SOD-002** | sod_usuarios_auditoria | Gestión Users (4 func) | Auditoría (3 func) | Quien gestiona users NO audita |
| **SOD-003** | sod_acceso_auditoria | Gestión Access (3 func) | Auditoría (2 func) | Quien gestiona acceso NO audita |

### 6.2 Detalle SOD-001: sod_admin_auditoria

```yaml
Restricción: sod_admin_auditoria
Base: CNST_005 (SYSTEM_ADMIN ⚔️ AUDIT_VIEWER)
Principio: "Quien opera el sistema NO debe auditarlo"

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
  
Enforcement:
  - SEC_RULES valida en tiempo real
  - Bloquea asignación si viola SoD
  - Registra intento en MOD_Audit
```

### 6.3 Detalle SOD-002: sod_usuarios_auditoria

```yaml
Restricción: sod_usuarios_auditoria
Base: CNST_005 (USER_ADMIN ⚔️ PERMISSION_ADMIN)
Principio: "Quien gestiona usuarios NO debe auditar sus propias acciones"

Grupo A (Gestión Usuarios - críticas):
  - crea_usuarios (USR-001)
  - modifica_usuarios (USR-003)
  - elimina_usuarios (USR-004)
  - bloquea_usuarios (USR-007)

Grupo B (Auditoría - parcial):
  - ve_auditoria (AUD-001)
  - busca_auditoria (AUD-002)
  - exporta_auditoria (AUD-003)
  
Agrupadores afectados:
  - agr_admin_usuarios ⚔️ agr_auditor

Nota: Usuario puede tener ve_usuarios, lista_usuarios 
      (lecturas) sin violar SoD
```

### 6.4 Detalle SOD-003: sod_acceso_auditoria

```yaml
Restricción: sod_acceso_auditoria
Principio: "Quien gestiona acceso NO debe auditar cambios de permisos"

Grupo A (Gestión Acceso):
  - asigna_funciones (ACC-001)
  - revoca_funciones (ACC-002)
  - gestiona_sod (ACC-005)

Grupo B (Auditoría):
  - ve_auditoria (AUD-001)
  - busca_auditoria (AUD-002)
  
Agrupadores afectados:
  - agr_admin_acceso ⚔️ agr_auditor
```

---

<a name="segmentos"></a>
## 7. SEGMENTOS DE DATOS

### 7.1 Catálogo de Segmentos IACT

| Código | Nombre | Descripción |
|--------|--------|-------------|
| **OP** | DATOS_OPERATIVOS | Datos operación IVR: llamadas, menús, navegación |
| **FI** | DATOS_FINANCIEROS | Costos, facturación, presupuestos |
| **TE** | DATOS_TECNICOS | Infraestructura, rendimiento, disponibilidad |
| **SU** | DATOS_SUPERVISION | Supervisión, control, gestión operativa |
| **CA** | DATOS_CALIDAD | Métricas de calidad, satisfacción, NPS |

### 7.2 Reglas de Segmentación

```yaml
Regla 1: Usuario = 1 Segmento
  - Cada usuario pertenece a EXACTAMENTE un segmento
  - Campo segmento_id es NOT NULL
  - Asignado en creación de usuario (USR-001 + USR-010)

Regla 2: Filtro Automático (SEC_RULES)
  - MOD_Access/SEC_RULES aplica WHERE segmento_id = @usuario_segmento
  - Usuario solo ve datos de su segmento
  - Automático, transparente, no requiere código en módulos
  - Implementado en middleware Django

Regla 3: Cross-Segment (Excepcional)
  - Solo con función especial (por definir)
  - Auditado en MOD_Audit
  - Justificación obligatoria

Regla 4: Restricciones CNST
  - CNST_003: Datos según último ETL
  - CNST_006: Rango máximo 2 años
```

### 7.3 Ejemplo de Aplicación

```python
# Código en MOD_Reports
def ver_reporte_trimestral(request):
    # SEC_RULES automáticamente aplica:
    # WHERE segmento_id = request.user.segmento_id
    
    queryset = LlamadasIVR.objects.filter(
        fecha__gte=fecha_inicio,
        fecha__lte=fecha_fin
    )
    # El filtro de segmento se aplica automáticamente
    # Usuario con segmento_id=OP solo ve datos OP
    # Usuario con segmento_id=FI solo ve datos FI
```

---

<a name="contraste-documentacion"></a>
## 8. CONTRASTE CON DOCUMENTACIÓN ACTUAL

### 8.1 Estado Actual de la Base Cognitiva

**Documentación generada hasta FASE 13 v1.3.0:**

```
base_cognitiva/
├── fundacionales/          (2 archivos - NOM_001 v2.0.0, STD_001 v1.1.0)
├── pedagogico/            (12 archivos - PARTES 0-6)
├── templates/             (12 templates válidos)
├── originales/            (16 archivos - ARCHIVADOS)
│   ├── META_* (7)
│   ├── FND_* (6)
│   ├── MTM_* (2)
│   └── MODELO_* (3)
└── indices/               (VACÍO - FASE 14 pendiente)
```

### 8.2 Documentos CNST en /originales/

**CRÍTICO:** Los documentos CNST están en `/originales/` con información **DESACTUALIZADA**:

| Documento | Estado | Versión | Problema |
|-----------|--------|---------|----------|
| CNST_001 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_002 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_003 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_004 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_005 | Archivado | Desconocida | **CORE RBAC** - Debe actualizarse |
| CNST_006 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_007 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |
| CNST_008 | Archivado | Desconocida | Puede no reflejar RBAC v5.1.1 |

**Estimación del análisis previo:** 10 documentos CNST, 9,621 → 10,543 líneas, ~5 horas

### 8.3 Referencias a RBAC en Documentación Actual

**Material Pedagógico (12 archivos):**
- ✅ Algunos usan ejemplos genéricos de permisos
- ⚠️ NO alineados a las 44 funciones específicas de v5.1.1
- ⚠️ NO mencionan los 10 agrupadores
- ⚠️ NO documentan las 3 restricciones SoD específicas
- ⚠️ NO documentan los 5 segmentos de datos

**Templates (12 archivos):**
- ✅ Algunos tienen secciones de permisos/roles
- ⚠️ Probablemente usan roles genéricos (R001-R018) de v4.0
- ⚠️ NO alineados a funciones atómicas v5.1.1

**Ejemplo de desalineación encontrada:**

```rst
# En template actual (probablemente):
:Requiere_Rol: R004, R005

# Debería ser (v5.1.1):
:Requiere_Funcion: ve_reportes (RPT-001)
```

### 8.4 Casos de Uso (UCs)

**Estimación del análisis previo:** 49 UCs, ~5 horas de regeneración

**Mapeo UC → Funciones RBAC identificado:**

| Módulo | UCs Identificados | Funciones RBAC |
|--------|-------------------|----------------|
| MOD_Auth | UC-001 a UC-005 | 4 funciones |
| MOD_Users | UC-006 a UC-009, UC-041 | 10 funciones |
| MOD_Access | UC-010, UC-011, UC-042 a UC-047 | 6 funciones |
| MOD_Pipeline | UC-050 a UC-053 | 4 funciones |
| MOD_Reports | UC-017 a UC-029 | 8 funciones |
| MOD_Alerts | UC-036 a UC-040 | 6 funciones |
| MOD_Audit | UC-060 a UC-063 | 4 funciones |
| MOD_Logs | UC-070 a UC-072 | 2 funciones |
| **TOTAL** | **~70 UCs** | **44 funciones** |

**Problema:** Si los 49 UCs estimados no están regenerados con:
- Referencias a funciones RBAC v5.1.1
- Agrupadores aplicables
- Restricciones SoD
- Segmentos de datos
- CNST aplicables

→ Entonces están **DESACTUALIZADOS**

---

<a name="impacto-fases"></a>
## 9. IMPACTO EN FASES PENDIENTES

### 9.1 FASE 14: Índices y Catálogos (Planificada)

**Impacto:** MEDIO-ALTO

**Nuevos índices necesarios:**

1. **CATALOGO_FUNCIONES_RBAC_IACT_1_0_0.rst**
   - Catálogo de las 44 funciones atómicas
   - Agrupadas por módulo
   - Con capacidades, UCs, CNST aplicables
   - ~500-800 líneas estimadas

2. **CATALOGO_AGRUPADORES_IACT_1_0_0.rst**
   - Catálogo de los 10 agrupadores
   - Composición de funciones
   - Usuarios estimados
   - ~300-500 líneas estimadas

3. **MATRIZ_SOD_IACT_1_0_0.rst**
   - Documentación de las 3 restricciones SoD
   - Funciones incompatibles
   - Justificaciones
   - ~200-300 líneas estimadas

4. **CATALOGO_SEGMENTOS_DATOS_IACT_1_0_0.rst**
   - Los 5 segmentos de datos
   - Reglas de asignación
   - Filtrado automático
   - ~200-300 líneas estimadas

**Estimación adicional:** +4 documentos, ~1,200-1,900 líneas, +3-5 horas

### 9.2 FASE 15: CNST v1.0.0 → v1.1.0 (Pendiente del Análisis)

**Impacto:** CRÍTICO - ALTA PRIORIDAD

**Documentos a actualizar:**

| CNST | Título | Impacto RBAC v5.1.1 | Líneas Est. | Esfuerzo |
|------|--------|---------------------|-------------|----------|
| CNST_001 | NO Email | Funciones: resetea_password, configura_alertas | ~500 | 30 min |
| CNST_002 | Sesiones | Función: gestiona_sesiones | ~600 | 45 min |
| CNST_003 | BD IVR Readonly | Todas funciones Pipeline + Reports | ~800 | 1h |
| CNST_004 | Alertas Buzón | Todas funciones Alerts | ~700 | 45 min |
| **CNST_005** | **RBAC Flat + SoD** | **TODO el modelo v5.1.1** | **2,000** | **2h** |
| CNST_006 | Límites Reportes | Funciones Reports | ~600 | 45 min |
| CNST_007 | Throttling Export | exporta_csv, exporta_excel, exporta_pdf | ~700 | 45 min |
| CNST_008 | Audit Inmutable | Todas funciones Audit + Logs | ~900 | 1h |

**Total estimado:** 8 documentos, ~7,800 líneas, ~8-10 horas

**CRÍTICO: CNST_005** es el documento **CORE** que define todo el modelo RBAC v5.1.1:
- 44 funciones atómicas
- 10 agrupadores
- 3 restricciones SoD
- Permisos temporales
- Precedencias
- Modelo de datos
- SQL de implementación

**Recomendación:** CNST_005 debería ser el **PRIMER** documento a generar en FASE 15.

### 9.3 FASE 16: UC v4.0.0 (Pendiente del Análisis)

**Impacto:** ALTO

**UCs a regenerar con RBAC v5.1.1:**

**Plantilla completa de UC (14 secciones)** debe incluir:

```rst
UC-NNN: Nombre del Caso de Uso
================================

:Función_RBAC_Requerida: nombre_funcion (CODIGO-NNN)
:Agrupador_Aplicable: agr_nombre_agrupador (AGR-NNN)
:CNST_Aplicables: CNST_NNN, CNST_NNN
:Restricción_SoD: SOD-NNN (si aplica)
:Segmento_Datos: Filtrado automático por segmento_id
:Módulo: MOD_Nombre

[... resto de secciones estándar UC ...]

Permisos Detallados
-------------------

Función RBAC:
  - Nombre: nombre_funcion
  - Código: CODIGO-NNN
  - Capacidad: modulo:accion
  - Módulo: MOD_Nombre

Agrupadores que incluyen esta función:
  - AGR-NNN: agr_nombre
  - AGR-NNN: agr_nombre

Restricciones SoD:
  [si aplica]
```

**Regeneración estimada:**

| Módulo | UCs | Esfuerzo por UC | Total |
|--------|-----|-----------------|-------|
| MOD_Auth | 5 | 5 min | 25 min |
| MOD_Users | 5 | 5 min | 25 min |
| MOD_Access | 8 | 7 min | 56 min |
| MOD_Pipeline | 4 | 5 min | 20 min |
| MOD_Reports | 13 | 5 min | 65 min |
| MOD_Alerts | 5 | 5 min | 25 min |
| MOD_Audit | 4 | 5 min | 20 min |
| MOD_Logs | 3 | 5 min | 15 min |
| **TOTAL** | **~47** | - | **~4h** |

**Nota:** Algunos UCs pueden estar fuera de este alcance (UCs no directamente mapeados a funciones RBAC).

### 9.4 FASE 17: Validación Completa (Pendiente del Análisis)

**Impacto:** MEDIO

**Validaciones necesarias:**

1. **Cross-references UC ↔ Funciones RBAC**
   - Verificar que cada UC tiene función(es) RBAC correcta(s)
   - ~2 horas

2. **Trazabilidad BR → UC → FR → Funciones RBAC**
   - Validar cadena completa de trazabilidad
   - ~3 horas

3. **Consistencia CNST ↔ Funciones**
   - Verificar que cada CNST lista las funciones afectadas correctamente
   - ~2 horas

4. **Consistencia SoD**
   - Verificar que agrupadores no violan SoD
   - ~1 hora

5. **Consistencia Segmentos**
   - Verificar documentación de filtrado automático
   - ~1 hora

6. **Nomenclatura NOM_001 v2.0.0**
   - Validar que nuevos documentos cumplen nomenclatura
   - ~1 hora

**Total estimado:** ~10 horas

---

<a name="recomendaciones"></a>
## 10. RECOMENDACIONES Y PRÓXIMOS PASOS

### 10.1 Estrategia Recomendada

```
ESTRATEGIA: "Core-First" - Empezar por los fundamentos del RBAC

FASE 14: Índices (Planificada) → POSPONER temporalmente
FASE 15: CNST v1.1.0 → PRIORIZAR (especialmente CNST_005)
FASE 16: UC v4.0.0 → Después de CNST_005
FASE 17: Validación → Al final

Razón: CNST_005 define TODO el modelo RBAC v5.1.1
       Sin CNST_005 actualizado, los UCs no pueden tener
       referencias RBAC correctas.
```

### 10.2 Secuencia Propuesta (MODIFICADA)

**PASO 1: CNST_005 - CORE RBAC (PRIORIDAD MÁXIMA)**

```yaml
Documento: CNST_005_RBAC_Flat_SoD_Permisos_1_1_0.rst
Contenido:
  1. Filosofía "Sin Pretensiones"
  2. 44 Funciones atómicas (8 módulos)
  3. 10 Agrupadores
  4. 3 Restricciones SoD
  5. 5 Segmentos de datos
  6. Permisos temporales (justificación + vencimiento)
  7. Precedencias (Directo > Función > Segmento)
  8. Modelo de datos (ER + SQL)
  9. Implementación Django (decoradores, middleware)
  10. Migración v4.0 → v5.1

Fuente: MODELO_RBAC_IACT_v5_1_1.md
Líneas: ~2,000-2,500
Esfuerzo: 2-3 horas
Prioridad: 🔴 CRÍTICA
```

**PASO 2: Resto de CNST (CNST_001 a CNST_008 excepto 005)**

```yaml
Documentos: 7 archivos CNST
Contenido: Cada CNST documenta funciones RBAC afectadas
Fuente: MODELO_RBAC_IACT_v5_1_1.md + REFERENCIA_GLOBAL_MODULOS_IACT_v1.md
Líneas: ~5,800 total
Esfuerzo: ~6 horas
Prioridad: 🟠 ALTA
```

**PASO 3: UCs con RBAC v5.1.1**

```yaml
Documentos: ~47 UCs
Contenido: Plantilla 14 secciones + secciones RBAC
Fuente: MODELO_RBAC_IACT_v5_1_1.md (mapeo UC → Funciones)
Esfuerzo: ~4 horas
Prioridad: 🟡 MEDIA
```

**PASO 4: Índices RBAC**

```yaml
Documentos: 4 archivos
  - CATALOGO_FUNCIONES_RBAC_IACT_1_0_0.rst
  - CATALOGO_AGRUPADORES_IACT_1_0_0.rst
  - MATRIZ_SOD_IACT_1_0_0.rst
  - CATALOGO_SEGMENTOS_DATOS_IACT_1_0_0.rst
Esfuerzo: ~4 horas
Prioridad: 🟢 MEDIA-BAJA
```

**PASO 5: Índices Generales (FASE 14 original)**

```yaml
Documentos: 3 archivos planificados originalmente
  - INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
  - MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md
  - CATALOGO_TEMPLATES_IACT_1_3_0.rst (ya parcialmente cubierto)
Esfuerzo: ~3-4 horas
Prioridad: 🟢 BAJA
```

**PASO 6: Validación Completa**

```yaml
Tareas: 6 validaciones
Esfuerzo: ~10 horas
Prioridad: 🟢 BAJA (al final)
```

### 10.3 Estimación Total Revisada

| Fase | Documentos | Esfuerzo | Prioridad | Orden |
|------|------------|----------|-----------|-------|
| **CNST_005** | 1 | 2-3h | 🔴 CRÍTICA | 1 |
| **CNST resto** | 7 | 6h | 🟠 ALTA | 2 |
| **UCs RBAC** | 47 | 4h | 🟡 MEDIA | 3 |
| **Índices RBAC** | 4 | 4h | 🟢 MEDIA-BAJA | 4 |
| **Índices Gen.** | 3 | 3-4h | 🟢 BAJA | 5 |
| **Validación** | - | 10h | 🟢 BAJA | 6 |
| **TOTAL** | **62** | **~29-31h** | - | - |

**Comparación con análisis previo:**
- Análisis previo estimaba: ~22h pendiente
- Análisis actual estima: ~29-31h
- Diferencia: +7-9h (por índices RBAC adicionales)

### 10.4 Recomendaciones Específicas

#### 🔴 CRÍTICAS (Hacer YA)

1. **Generar CNST_005_RBAC_Flat_SoD_Permisos_1_1_0.rst**
   - Es el documento FUNDACIONAL del modelo RBAC v5.1.1
   - Sin él, no se pueden documentar correctamente los UCs
   - Base para todos los demás CNST
   - Estimación: 2-3 horas

2. **Crear directorio `/mnt/user-data/outputs/source/base_cognitiva/cnst/`**
   - Mover documentos CNST de `/originales/` a `/cnst/`
   - Versionarlos según NOM_001 v2.0.0

#### 🟠 ALTAS (Hacer pronto)

3. **Actualizar resto de CNST (001-004, 006-008)**
   - Agregar secciones de funciones RBAC afectadas
   - Ejemplos de enforcement
   - Estimación: ~6 horas total

4. **Plantilla UC con RBAC**
   - Crear plantilla estándar que incluya secciones RBAC
   - Usar como base para regenerar UCs
   - Estimación: 30 minutos

#### 🟡 MEDIAS (Hacer después)

5. **Regenerar UCs críticos primero**
   - Priorizar UCs de MOD_Reports (core negocio)
   - Luego MOD_Access, MOD_Users
   - Finalmente resto
   - Estimación: ~4 horas total

6. **Generar índices RBAC**
   - Catálogos de funciones, agrupadores, SoD, segmentos
   - Facilita consulta rápida
   - Estimación: ~4 horas

#### 🟢 BAJAS (Hacer al final)

7. **Índices generales FASE 14**
   - Índice maestro, mapa referencias cruzadas
   - Catálogo templates (ya parcialmente hecho)
   - Estimación: ~3-4 horas

8. **Validación exhaustiva**
   - Cross-references, trazabilidad, consistencia
   - Nomenclatura, SoD, segmentos
   - Estimación: ~10 horas

### 10.5 Plantilla Sugerida CNST_005

```rst
.. _CNST_005:

============================================================
CNST_005 - Modelo RBAC Flat + SoD + Permisos Temporales
============================================================

:Restricción: CNST_005
:Versión: 1.1.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: CRÍTICA
:Ámbito: Sistema completo IACT
:Módulo_Principal: MOD_Access
:Base: NIST RBAC (Flat, no jerárquico)

.. contents:: Tabla de Contenido
   :depth: 3
   :local:

Resumen Ejecutivo
=================

Definición del modelo de control de acceso basado en funciones atómicas
(RBAC v5.1.1) para el Sistema IACT.

Cambio fundamental respecto a v4.0:
  - ANTES: HasRole(['R004', 'R005'])
  - AHORA: HasFunction('ve_reportes')

Filosofía
=========

"Sin Pretensiones" - Los nombres de funciones describen QUÉ HACE
la función, NO QUIÉN es la persona.

[... continuar con todas las secciones del MODELO_RBAC_IACT_v5_1_1.md ...]

1. Las 44 Funciones Atómicas
============================

1.1 MOD_Auth (4 funciones)
---------------------------

[... tabla de funciones ...]

[... continuar para todos los módulos ...]

2. Los 10 Agrupadores
=====================

[... documentar agrupadores ...]

3. Restricciones SoD
====================

[... documentar las 3 restricciones ...]

4. Segmentos de Datos
=====================

[... documentar los 5 segmentos ...]

5. Permisos Temporales
======================

[... documentar justificación + vencimiento ...]

6. Modelo de Datos
==================

[... ER + tablas SQL ...]

7. Implementación
=================

[... decoradores Django, middleware SEC_RULES ...]

8. Migración v4.0 → v5.1
========================

[... guía de migración ...]

Referencias
===========

:Documento_Base: MODELO_RBAC_IACT_v5_1_1.md
:Alineación: REFERENCIA_GLOBAL_MODULOS_IACT_v1.md
:Casos_Uso: UC-001 a UC-072 (ver mapeo)

Historial de Cambios
====================

v1.1.0 (2026-01-11)
  - Migración completa a modelo v5.1.1
  - 44 funciones atómicas sobre 8 módulos
  - 10 agrupadores
  - 3 restricciones SoD
  - 5 segmentos de datos

v1.0.0 (2025-XX-XX)
  - Versión inicial con roles R001-R018 (OBSOLETA)
```

---

## 11. CONCLUSIONES

### 11.1 Hallazgos Críticos

1. **Modelo RBAC v5.1.1 es FUNDAMENTAL**
   - Define TODO el sistema de permisos
   - 44 funciones atómicas bien documentadas
   - Listo para implementación (SQL completo incluido)

2. **Documentación actual DESALINEADA**
   - CNST en `/originales/` probablemente obsoletos
   - UCs sin referencias RBAC v5.1.1
   - Templates con roles v4.0 genéricos

3. **CNST_005 es el DOCUMENTO CORE**
   - Sin CNST_005 actualizado, el resto de documentación no puede ser correcta
   - Debe generarse PRIMERO

4. **Impacto en FASES pendientes es ALTO**
   - FASE 15 (CNST): ~8-9 horas
   - FASE 16 (UCs): ~4 horas
   - FASE 14 (Índices): +4 horas de índices RBAC adicionales
   - FASE 17 (Validación): ~10 horas

### 11.2 Trabajo Total Pendiente

**TOTAL ESTIMADO: ~29-31 horas**

Desglose:
- CNST_005: 2-3h 🔴
- CNST resto: 6h 🟠
- UCs: 4h 🟡
- Índices RBAC: 4h 🟢
- Índices generales: 3-4h 🟢
- Validación: 10h 🟢

### 11.3 Siguiente Paso Inmediato

**ACCIÓN RECOMENDADA:**

```
GENERAR CNST_005_RBAC_Flat_SoD_Permisos_1_1_0.rst

Fuente: MODELO_RBAC_IACT_v5_1_1.md
Estructura: Plantilla sugerida en sección 10.5
Esfuerzo: 2-3 horas
Prioridad: 🔴 CRÍTICA

Este documento es la PIEDRA ANGULAR del sistema RBAC v5.1.1.
Sin él, no se puede continuar con UCs ni resto de CNST.
```

---

**FIN DEL ANÁLISIS PROFUNDO**

**Versión:** 1.0.0  
**Fecha:** 2026-01-11  
**Autor:** Claude (Análisis automatizado)  
**Estado:** Completo - Listo para decisión

