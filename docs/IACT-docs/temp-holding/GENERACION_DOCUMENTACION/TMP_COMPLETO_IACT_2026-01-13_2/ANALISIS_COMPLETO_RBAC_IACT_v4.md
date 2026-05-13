# ANALISIS COMPLETO: Modelo RBAC Sistema IACT v4.0

**Fecha:** 2026-01-03  
**Documentos Analizados:**
- Modelo_RBAC_Completo_-_Sistema_IACT_-_v_0_0_1.md (documento principal, 4378 lineas)
- ARTEFACTO_4_-_Modelo_RBAC_Completo_-_Sistema_IACT_-_v_0_0_1_-_4f25.md
- ARTEFACTO_4_-_PARTE_2_-_Modelo_RBAC_Completo_(Continuacion)_-_v_0_0_1_-_4f25.md
- ARTEFACTO_4_-_PARTE_3_FINAL_-_Modelo_RBAC_Completo_-_v_0_0_1_-_4f25.md
- BR_005 a BR_018 creadas previamente

**Proposito:** Determinar consistencia entre documentos RBAC oficiales y BR creadas, identificar discrepancias y definir acciones correctivas.

---

## 1. RESUMEN EJECUTIVO

### 1.1 Hallazgo Principal

**LAS BR CREADAS SON CONSISTENTES CON EL MODELO RBAC IACT v4.0**

El documento oficial IACT v4.0 utiliza un **modelo hibrido**:
- **18 Roles funcionales** (agrupadores de permisos)
- **Permisos granulares** dentro de cada rol (formato recurso.accion.scope)
- **Nomenclatura funcional** (REPORTS_VIEWER, no "Gerente")

Esto es **diferente** al modelo "Sin Pretensiones" v4.0 que propone funciones 100% atomicas.

### 1.2 Comparacion de Enfoques

| Aspecto | Modelo "Sin Pretensiones" | Modelo IACT v4.0 | BR Creadas |
|---------|---------------------------|------------------|------------|
| Unidad base | Funcion atomica | Rol funcional | Rol funcional |
| Cantidad | 75+ funciones | 18 roles | 18 roles |
| Permisos | Capacidades atomicas | Granulares por rol | Granulares por rol |
| Nomenclatura | verbo_sustantivo | CATEGORIA_ACCION | CATEGORIA_ACCION |
| Bundles | Obligatorios | No requeridos | No implementados |
| Namespace | Si (identity:, epm:) | No | No |

### 1.3 Conclusion

Las BR creadas (BR_006, BR_007, etc.) **SI estan alineadas** con el Modelo RBAC IACT v4.0 oficial. El documento "Sin Pretensiones" es un modelo de referencia externo, pero el proyecto IACT adopto un enfoque hibrido que las BR reflejan correctamente.

---

## 2. ARQUITECTURA DEL MODELO RBAC IACT v4.0

### 2.1 Estructura Oficial

```
┌─────────────────────────────────────────────────────┐
│                     USUARIOS                        │
│  (users table)                                      │
└─────────────────────────────────────────────────────┘
                        │
                        │ N:N
                        ▼
┌─────────────────────────────────────────────────────┐
│                      ROLES                          │
│  (roles table - 18 roles funcionales)               │
└─────────────────────────────────────────────────────┘
                        │
                        │ 1:N
                        ▼
┌─────────────────────────────────────────────────────┐
│                    PERMISOS                         │
│  (permissions table - granulares)                   │
└─────────────────────────────────────────────────────┘
```

### 2.2 Capas de Seguridad

1. **CAPA 1: AUTENTICACION**
   - Username + Password
   - Validacion de estado (ACTIVO)
   - Sesion unica por usuario

2. **CAPA 2: AUTORIZACION (RBAC)**
   - Validacion de roles del usuario
   - Verificacion de permisos
   - Precedencia: Directo > Rol > Segmento

3. **CAPA 3: SEGREGACION DE DATOS**
   - Segmento de datos del usuario
   - Filtros automaticos segun segmento

4. **CAPA 4: AUDITORIA**
   - Registro de todas las acciones
   - Logs inmutables

---

## 3. CATALOGO DE 18 ROLES FUNCIONALES

### 3.1 Categoria 1: Gestion de Usuarios (3 roles)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R001 | USERS_FULL_MANAGER | Administra usuarios, roles, permisos y segmentos | 2-3 |
| R002 | USERS_VIEWER | Ve informacion de usuarios sin modificar | 10-20 |
| R003 | USERS_TEAM_MANAGER | Administra usuarios del mismo segmento | 15-25 |

**Permisos R001 (ejemplo):**
```
users.create
users.read
users.update
users.delete (solo baja logica)
users.list
users.search
users.password.reset
users.block
users.unblock
roles.assign
roles.revoke
permissions.manage
permissions.direct.assign
segments.manage
internal_message.send.users
```

### 3.2 Categoria 2: Reportes (4 roles)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R004 | REPORTS_VIEWER | Consulta reportes basicos con filtros | 50-100 |
| R005 | REPORTS_EXPORTER | Exporta reportes CSV/Excel/PDF | 30-50 |
| R006 | REPORTS_ADVANCED_VIEWER | Accede a reportes avanzados cross-segment | 10-20 |
| R007 | REPORTS_CREATOR | Crea reportes personalizados con SQL | 5-10 |

**Permisos R004 (ejemplo):**
```
reports.view.basic
reports.view.quarterly
reports.view.transfers
reports.view.menu_errors
reports.filter.date
reports.filter.center
reports.filter.did
charts.view.basic
tables.view.basic
```

**Permisos R005 (adicionales a R004):**
```
reports.export.csv
reports.export.excel
reports.export.pdf
reports.export.download
files.generate
files.download
```

### 3.3 Categoria 3: Visualizacion (2 roles)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R008 | DASHBOARD_VIEWER | Ve dashboards estandar sin personalizacion | 50-100 |
| R009 | DASHBOARD_CUSTOMIZER | Personaliza dashboards y guarda vistas | 20-40 |

### 3.4 Categoria 4: Analisis Avanzado (1 rol)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R010 | DATA_ANALYST | Ejecuta analisis exploratorio y detecta patrones | 5-15 |

**Permisos R010:**
```
analysis.exploratory.execute
analysis.compare.periods
analysis.patterns.identify
analysis.anomalies.detect
queries.custom.create
queries.custom.execute
queries.custom.save
statistics.calculate
statistics.advanced
charts.generate.custom
```

### 3.5 Categoria 5: Alertas y Notificaciones (4 roles)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R011 | ALERTS_VIEWER | Recibe y visualiza alertas propias | 30-60 |
| R012 | ALERTS_CONFIGURATOR | Configura alertas personales y umbrales | 15-30 |
| R013 | ALERTS_TEAM_MANAGER | Configura alertas para equipos del segmento | 10-15 |
| R014 | ALERTS_GLOBAL_ADMIN | Administra alertas globales del sistema | 2-3 |

### 3.6 Categoria 6: Administracion y Seguridad (4 roles)

| Codigo | Nombre | Funcion | Usuarios Est. |
|--------|--------|---------|---------------|
| R015 | MODULES_ADMIN | Administra configuracion de modulos | 2-3 |
| R016 | SYSTEM_ADMIN | Administra sistema completo | 1-2 |
| R017 | AUDIT_VIEWER | Ve logs de auditoria (solo lectura) | 2-5 |
| R018 | SECURITY_ADMIN | Administra politicas de seguridad | 1-2 |

---

## 4. SEPARACION DE FUNCIONES (SoD)

### 4.1 Restricciones Definidas en IACT v4.0

| Rol A | Rol B | Razon |
|-------|-------|-------|
| R016 (SYSTEM_ADMIN) | R017 (AUDIT_VIEWER) | Quien opera NO debe auditar |
| R001 (USERS_FULL_MANAGER) | R017 (AUDIT_VIEWER) | Quien gestiona usuarios NO debe auditar |

### 4.2 Validacion SQL

```sql
-- Trigger que previene asignacion simultanea
IF EXISTS (
    SELECT 1 FROM user_roles 
    WHERE user_id = @user_id 
    AND role_id IN ('R001', 'R016')
) THEN
    IF @new_role_id = 'R017' THEN
        RAISE EXCEPTION 'SoD: R017 incompatible con R001/R016';
    END IF;
END IF;
```

### 4.3 Comparacion con BR_007

| Aspecto | IACT v4.0 | BR_007 | Estado |
|---------|-----------|--------|--------|
| Pares conflictivos | 2 | 3 | BR_007 mas completo |
| Validacion | SQL Trigger | SQL Trigger | CONSISTENTE |
| Razon documentada | Si | Si | CONSISTENTE |

---

## 5. PERMISOS DIRECTOS Y VENCIMIENTO

### 5.1 Definicion IACT v4.0

```sql
CREATE TABLE direct_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    permission VARCHAR(100) NOT NULL,
    granted_by INT NOT NULL,
    granted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    justification TEXT NOT NULL,
    status ENUM('ACTIVE', 'EXPIRED', 'REVOKED') NOT NULL DEFAULT 'ACTIVE',
    
    CHECK (expires_at <= DATE_ADD(granted_at, INTERVAL 6 MONTH))
);
```

### 5.2 Comparacion con BR_008

| Aspecto | IACT v4.0 | BR_008 | Estado |
|---------|-----------|--------|--------|
| Vencimiento obligatorio | Si | Si | CONSISTENTE |
| Maximo 6 meses | Si | Si | CONSISTENTE |
| Justificacion requerida | Si | Si | CONSISTENTE |
| Job expiracion | Event diario | Task diario | CONSISTENTE |

---

## 6. SEGMENTOS DE DATOS

### 6.1 Segmentos Definidos en IACT v4.0

| Codigo | Nombre | Descripcion |
|--------|--------|-------------|
| OP | DATOS_OPERATIVOS | Datos de operacion del IVR |
| FI | DATOS_FINANCIEROS | Datos para analisis de costos |
| TE | DATOS_TECNICOS | Datos tecnicos de infraestructura |
| SU | DATOS_SUPERVISION | Datos para supervision |
| CA | DATOS_CALIDAD | Datos de metricas de calidad |
| GE | DATOS_CONSOLIDADOS | Datos agregados para decisiones |

### 6.2 Comparacion con BR_012

| Aspecto | IACT v4.0 | BR_012 | Estado |
|---------|-----------|--------|--------|
| Usuario = 1 segmento | Si | Si | CONSISTENTE |
| Segmentos definidos | 6 | 5 | DIFERENCIA MENOR |
| Filtro automatico | Si | Si | CONSISTENTE |

---

## 7. ESTRUCTURA DE BASE DE DATOS

### 7.1 Tablas Principales IACT v4.0

```sql
-- Usuarios
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',
    segment_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    failed_login_attempts INT DEFAULT 0,
    locked_until DATETIME
);

-- Roles
CREATE TABLE roles (
    role_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE
);

-- Asignacion Usuario-Rol
CREATE TABLE user_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    role_id VARCHAR(10) NOT NULL,
    assigned_by INT NOT NULL,
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    justification TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE (user_id, role_id)
);

-- Permisos por Rol
CREATE TABLE role_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id VARCHAR(10) NOT NULL,
    permission VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Auditoria
CREATE TABLE audit_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_timestamp DATETIME NOT NULL,
    user_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45),
    action_type VARCHAR(100) NOT NULL,
    module VARCHAR(100),
    resource_type VARCHAR(100),
    resource_id VARCHAR(100),
    action_result ENUM('SUCCESS', 'FAILED', 'PARTIAL') NOT NULL,
    additional_data JSON
);
```

### 7.2 Triggers de Proteccion

```sql
-- Logs INMUTABLES
CREATE TRIGGER prevent_audit_modification
BEFORE UPDATE ON audit_logs
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Logs de auditoria son inmutables';
END;

CREATE TRIGGER prevent_audit_deletion
BEFORE DELETE ON audit_logs
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Logs de auditoria no se pueden eliminar';
END;
```

---

## 8. COMPARACION BR CREADAS vs IACT v4.0

### 8.1 Matriz de Consistencia

| BR | Concepto | IACT v4.0 | Estado |
|----|----------|-----------|--------|
| BR_005 | Sesion Unica | Capa 1 Autenticacion | CONSISTENTE |
| BR_006 | RBAC Flat NIST | 18 roles Flat RBAC | CONSISTENTE |
| BR_007 | SoD | 2 pares conflictivos | CONSISTENTE (BR mas completo) |
| BR_008 | Permisos Vencimiento | direct_permissions 6 meses | CONSISTENTE |
| BR_009 | Bajas Logicas | status ENUM, no DELETE | CONSISTENTE |
| BR_010 | Auditoria Inmutable | triggers prevent_* | CONSISTENTE |
| BR_011 | Limites Exportacion | Limites por perfil en R005 | CONSISTENTE |
| BR_012 | Segmento Unico | segment_id NOT NULL | CONSISTENTE |
| BR_013 | Username Unico | UNIQUE constraint | CONSISTENTE |
| BR_014 | Alertas Umbral | R012 ALERTS_CONFIGURATOR | CONSISTENTE |
| BR_015 | Bloqueo Intentos | failed_login_attempts + locked_until | CONSISTENTE |

### 8.2 Elementos IACT v4.0 No Cubiertos en BR

| Elemento | Descripcion | Prioridad | Accion |
|----------|-------------|-----------|--------|
| 6 Segmentos de Datos | Solo 5 en BR_012 | Baja | Actualizar BR_012 |
| Precedencia Permisos | Directo > Rol > Segmento | Media | Nueva BR o actualizar BR_006 |
| Limites por Perfil | BASICO vs ANALISTA | Baja | Documentar en BR_011 |
| Cross-segment access | R006 puede ver multi-segmento | Media | Nueva BR o FR |

### 8.3 Elementos BR No Presentes en IACT v4.0

| BR | Elemento | Evaluacion |
|----|----------|------------|
| BR_001 | Fuente MySQL Inmutable | Decisiones arquitectonicas, no RBAC |
| BR_002 | ETL Batch Nocturno | Pipeline, no RBAC |
| BR_003 | Usuario Inactivo 90d | Complementa, no contradice |
| BR_004 | Comunicaciones Internas | Presente en IACT como "buzon interno" |
| BR_016-018 | Metricas Calculo | Fuera de scope RBAC |

---

## 9. RECOMENDACIONES

### 9.1 Acciones Inmediatas (No requieren cambios)

Las BR creadas son **consistentes** con el Modelo RBAC IACT v4.0. No se requieren reescrituras.

### 9.2 Mejoras Sugeridas

| BR | Mejora | Prioridad |
|----|--------|-----------|
| BR_006 | Agregar catalogo completo de permisos por rol | Media |
| BR_007 | Mantener como esta (mas completo que IACT) | - |
| BR_011 | Detallar limites por perfil (BASICO, ANALISTA, etc) | Baja |
| BR_012 | Agregar 6to segmento (DATOS_CALIDAD) | Baja |

### 9.3 Nuevas BR Sugeridas

| BR | Nombre | Contenido | Prioridad |
|----|--------|-----------|-----------|
| BR_019 | Precedencia de Permisos | Directo > Rol > Segmento | Media |
| BR_020 | Acceso Cross-Segment | Reglas para R006 | Baja |

---

## 10. RELACION CON MODULOS IACT

### 10.1 Modulos Definidos y Roles Asociados

| Modulo | Roles Principales | UC Relacionados |
|--------|-------------------|-----------------|
| MOD_Auth | R016, R018 | UC-001 a UC-005 |
| MOD_Users | R001, R002, R003 | UC-006 a UC-011 |
| MOD_Reports | R004, R005, R006, R007 | UC-017 a UC-024 |
| MOD_Dashboard | R008, R009 | UC-025 a UC-030 |
| MOD_Analysis | R010 | UC-031 a UC-035 |
| MOD_Alerts | R011, R012, R013, R014 | UC-036 a UC-040 |
| MOD_Admin | R015, R016 | UC-043 a UC-048 |
| MOD_Audit | R017 | UC-060 a UC-063 |

### 10.2 Roles NO Cubiertos por Modulos Actuales

El documento menciona roles que interactuan con modulos aun no definidos:

- **R007 REPORTS_CREATOR**: Requiere modulo de creacion SQL personalizado
- **R013 ALERTS_TEAM_MANAGER**: Requiere modulo de alertas por equipo
- **R014 ALERTS_GLOBAL_ADMIN**: Requiere modulo de alertas globales
- **R015 MODULES_ADMIN**: Modulo de configuracion de modulos

Estos roles pueden implementarse en fases posteriores.

---

## 11. CONCLUSION FINAL

### 11.1 Estado de Consistencia

**ALTO** - Las BR creadas reflejan correctamente el Modelo RBAC IACT v4.0.

### 11.2 Aclaracion Importante

El documento "Modelo RBAC Sin Pretensiones v4.0" es un **modelo de referencia externo** que propone funciones 100% atomicas. El proyecto IACT adopto un **enfoque hibrido** con:

- 18 Roles funcionales (agrupadores)
- Permisos granulares dentro de cada rol
- Nomenclatura funcional (no puestos organizacionales)

Este enfoque hibrido es **valido** y las BR lo reflejan correctamente.

### 11.3 Proximos Pasos

1. Actualizar BR_012 con 6to segmento (DATOS_CALIDAD)
2. Considerar BR_019 para precedencia de permisos
3. Continuar con Fase 2 (Casos de Uso) alineados a los roles

---

## ANEXO A: CATALOGO COMPLETO DE PERMISOS POR ROL

### R001 - USERS_FULL_MANAGER (27 permisos)
```
users.create, users.read, users.update, users.delete, users.list,
users.search, users.password.reset, users.block, users.unblock,
users.reactivate, roles.assign, roles.revoke, roles.view, roles.list,
permissions.manage, permissions.view, permissions.direct.assign,
permissions.direct.revoke, segments.manage, segments.view,
segments.assign, internal_message.send, internal_message.send.users
```

### R004 - REPORTS_VIEWER (12 permisos)
```
reports.view.basic, reports.view.quarterly, reports.view.transfers,
reports.view.menu_errors, reports.view.daily_calls, reports.filter.date,
reports.filter.center, reports.filter.did, reports.filter.service,
charts.view.basic, tables.view.basic
```

### R010 - DATA_ANALYST (14 permisos)
```
analysis.exploratory.execute, analysis.compare.periods,
analysis.patterns.identify, analysis.patterns.detect,
analysis.navigation.check, analysis.wait_times.analyze,
analysis.anomalies.detect, analysis.results.export,
queries.custom.create, queries.custom.execute, queries.custom.save,
statistics.calculate, statistics.advanced, charts.generate.custom
```

### R017 - AUDIT_VIEWER (10 permisos)
```
audit.logs.view, audit.logs.search, audit.logs.filter,
audit.logs.export.read_only, audit.reports.view, audit.reports.generate,
audit.events.security.view, audit.patterns.analyze,
compliance.reports.view, compliance.reports.generate
```

---

*Analisis generado: 2026-01-03*
*Documentos analizados: 4 documentos RBAC IACT + 18 BR*
*Conclusion: BR CONSISTENTES con Modelo IACT v4.0*
