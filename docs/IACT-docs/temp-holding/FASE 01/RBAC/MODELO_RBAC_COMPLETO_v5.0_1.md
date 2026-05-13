# MODELO RBAC COMPLETO - v5.0

## Sistema IACT - IVR Analytics & Customer Tracking

---

**Proyecto:** IACT-2025-001  
**Documento:** IACT-RBAC-001-v5.0  
**Título:** Modelo de Control de Acceso Basado en Funciones Atómicas  
**Versión:** 5.0 - ENFOQUE SIN PRETENSIONES  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación

---

## CONTROL DE CAMBIOS

| Versión | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0-3.0 | 17-18 Oct 2025 | Versiones preliminares | Equipo |
| 4.0 | 19 Oct 2025 | Modelo híbrido con 18 roles | Equipo |
| **5.0** | **03 Ene 2026** | **Enfoque Sin Pretensiones - Funciones atómicas** | **Equipo** |

### Cambios Principales v4.0 → v5.0

| Aspecto | v4.0 (Anterior) | v5.0 (Actual) |
|---------|-----------------|---------------|
| Unidad asignable | Rol (18 roles) | Función atómica (57 funciones) |
| Agrupación | No había | Agrupadores (12) |
| Nomenclatura | SCREAMING_CASE | snake_case |
| Filosofía | "Usuario ES rol" | "Usuario TIENE funciones" |
| Base de datos | JSON en columnas | Tablas normalizadas 3FN |

---

## TABLA DE CONTENIDO

1. Filosofía del Modelo
2. Arquitectura
3. Catálogo de Funciones Atómicas (57)
4. Catálogo de Agrupadores (12)
5. Separación de Funciones (SoD)
6. Segmentos de Datos
7. Permisos Temporales
8. Modelo de Datos
9. Implementación SQL
10. Funciones y Procedimientos
11. Ejemplos de Uso
12. Migración v4.0 → v5.0

---

## 1. FILOSOFÍA DEL MODELO

### 1.1 Principio Central

> **Los nombres de funciones describen QUÉ HACE la función, NO QUIÉN es la persona**

### 1.2 Enfoque Sin Pretensiones

**❌ INCORRECTO - Con Pretensiones (v4.0):**

```
Roles basados en títulos:
- USERS_FULL_MANAGER      → Define QUÉ ES la persona
- REPORTS_VIEWER          → Título organizacional
- SYSTEM_ADMIN            → Cargo jerárquico
```

**✅ CORRECTO - Sin Pretensiones (v5.0):**

```
Funciones basadas en acciones:
- crea_usuarios           → Describe QUÉ PUEDE HACER
- ve_reportes             → Acción concreta
- exporta_csv             → Capacidad específica
```

### 1.3 Ventajas del Enfoque

| Ventaja | Descripción |
|---------|-------------|
| Claridad | Nombre = Acción (sin ambigüedad) |
| Auditoría | "¿Puede exportar PDF?" → Buscar exporta_pdf → Sí/No |
| Flexibilidad | Combinaciones únicas por usuario |
| Mantenibilidad | Cambio de cargo ≠ cambio de funciones |
| Mínimo privilegio | Asignar solo lo necesario |

### 1.4 Agrupadores ≠ Roles

Los agrupadores son **mecanismos de asignación masiva**, NO son roles.

```
Agrupador "agr_supervisor":
  → Internamente asigna: ve_reportes, filtra_reportes, exporta_csv
  → El usuario NO "es" supervisor
  → El usuario TIENE las funciones individualmente
  → En BD: N registros en tabla usuarios_funciones
```

---

## 2. ARQUITECTURA

### 2.1 Diagrama de Componentes

```
┌─────────────────────────────────────────────────────┐
│                     USUARIO                          │
└─────────────────────────────────────────────────────┘
                        │
                        │ tiene asignadas (N:M)
                        ▼
┌─────────────────────────────────────────────────────┐
│              FUNCIONES ATÓMICAS (57)                 │
│  crea_usuarios │ ve_reportes │ exporta_csv │ ...    │
└─────────────────────────────────────────────────────┘
                        │
                        │ cada función = 1 capacidad
                        ▼
┌─────────────────────────────────────────────────────┐
│                   CAPACIDAD                          │
│  crea_usuarios → usuarios:crear                      │
│  exporta_csv   → reportes:exportar_csv               │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│              AGRUPADORES (12)                        │
│  agr_supervisor contiene:                            │
│    ve_reportes + filtra_reportes + exporta_csv      │
│  Al asignar: crea N registros individuales          │
└─────────────────────────────────────────────────────┘
```

### 2.2 Capas de Seguridad

```
CAPA 1: AUTENTICACIÓN
  - Username + Password
  - Sesión única por usuario
  - Bloqueo por intentos fallidos (3 intentos → 15 min)

CAPA 2: AUTORIZACIÓN (Funciones Atómicas)
  - ¿Usuario tiene función X? → Sí/No
  - Consulta directa a tabla usuarios_funciones

CAPA 3: SEGREGACIÓN DE DATOS
  - Usuario pertenece a 1 segmento
  - Filtro automático por segmento en consultas

CAPA 4: AUDITORÍA
  - Registro de toda acción
  - Logs inmutables con checksum SHA-256
```

---

## 3. CATÁLOGO DE FUNCIONES ATÓMICAS

### 3.1 Resumen por Dominio

| Dominio | Cantidad | Prefijo |
|---------|----------|---------|
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

### 3.2 DOMINIO: Usuarios (10 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| USR-001 | crea_usuarios | usuarios:crear | Crea nuevos usuarios |
| USR-002 | ve_usuarios | usuarios:leer | Consulta información de usuarios |
| USR-003 | modifica_usuarios | usuarios:modificar | Modifica datos de usuarios |
| USR-004 | elimina_usuarios | usuarios:eliminar | Baja lógica de usuarios |
| USR-005 | lista_usuarios | usuarios:listar | Lista usuarios con filtros |
| USR-006 | busca_usuarios | usuarios:buscar | Busca usuarios por criterios |
| USR-007 | resetea_passwords | usuarios:reset_password | Genera contraseña temporal |
| USR-008 | bloquea_usuarios | usuarios:bloquear | Bloquea acceso de usuario |
| USR-009 | desbloquea_usuarios | usuarios:desbloquear | Desbloquea usuario |
| USR-010 | reactiva_usuarios | usuarios:reactivar | Reactiva usuario inactivo |

### 3.3 DOMINIO: Funciones RBAC (6 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| FUN-001 | asigna_funciones | funciones:asignar | Asigna funciones a usuarios |
| FUN-002 | revoca_funciones | funciones:revocar | Revoca funciones de usuarios |
| FUN-003 | ve_funciones | funciones:leer | Consulta catálogo de funciones |
| FUN-004 | ve_asignaciones | asignaciones:leer | Ve asignaciones usuario-función |
| FUN-005 | asigna_agrupadores | agrupadores:asignar | Asigna agrupadores completos |
| FUN-006 | gestiona_sod | sod:gestionar | Configura restricciones SoD |

### 3.4 DOMINIO: Reportes (10 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| RPT-001 | ve_reportes | reportes:leer | Ve reportes básicos |
| RPT-002 | ve_reportes_avanzados | reportes:leer_avanzados | Ve reportes avanzados |
| RPT-003 | ve_reportes_consolidados | reportes:leer_consolidados | Ve reportes multi-segmento |
| RPT-004 | filtra_reportes | reportes:filtrar | Aplica filtros a reportes |
| RPT-005 | exporta_csv | reportes:exportar_csv | Exporta a CSV |
| RPT-006 | exporta_excel | reportes:exportar_excel | Exporta a Excel |
| RPT-007 | exporta_pdf | reportes:exportar_pdf | Exporta a PDF |
| RPT-008 | crea_reportes | reportes:crear | Crea reportes personalizados |
| RPT-009 | programa_reportes | reportes:programar | Programa generación automática |
| RPT-010 | comparte_reportes | reportes:compartir | Comparte reportes |

### 3.5 DOMINIO: Dashboard (5 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| DSH-001 | ve_dashboard | dashboard:leer | Ve dashboard estándar |
| DSH-002 | personaliza_dashboard | dashboard:personalizar | Personaliza disposición |
| DSH-003 | guarda_vistas | dashboard:guardar_vista | Guarda vistas personalizadas |
| DSH-004 | configura_widgets | dashboard:config_widgets | Configura widgets |
| DSH-005 | comparte_dashboard | dashboard:compartir | Comparte vistas |

### 3.6 DOMINIO: Alertas (8 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| ALR-001 | ve_alertas | alertas:leer | Ve alertas propias |
| ALR-002 | configura_alertas | alertas:configurar | Configura alertas personales |
| ALR-003 | configura_alertas_equipo | alertas:config_equipo | Alertas para equipo |
| ALR-004 | configura_alertas_globales | alertas:config_global | Alertas globales |
| ALR-005 | pausa_alertas | alertas:pausar | Pausa alertas |
| ALR-006 | elimina_alertas | alertas:eliminar | Elimina alertas propias |
| ALR-007 | ve_historial_alertas | alertas:historial | Ve historial |
| ALR-008 | gestiona_destinatarios | alertas:destinatarios | Gestiona destinatarios |

### 3.7 DOMINIO: Análisis (6 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| ANL-001 | analiza_exploratorio | analisis:exploratorio | Análisis exploratorio |
| ANL-002 | compara_periodos | analisis:comparar | Compara períodos |
| ANL-003 | identifica_patrones | analisis:patrones | Identifica patrones |
| ANL-004 | detecta_anomalias | analisis:anomalias | Detecta anomalías |
| ANL-005 | ejecuta_consultas | analisis:consultas | Ejecuta consultas personalizadas |
| ANL-006 | analiza_navegacion | analisis:navegacion | Analiza navegación IVR |

### 3.8 DOMINIO: Auditoría (4 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| AUD-001 | ve_auditoria | auditoria:leer | Ve logs de auditoría |
| AUD-002 | busca_auditoria | auditoria:buscar | Busca en logs |
| AUD-003 | exporta_auditoria | auditoria:exportar | Exporta logs |
| AUD-004 | genera_compliance | auditoria:compliance | Genera reportes compliance |

### 3.9 DOMINIO: Sistema (5 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| SYS-001 | administra_sistema | sistema:administrar | Administra configuración |
| SYS-002 | gestiona_sesiones | sistema:sesiones | Gestiona sesiones activas |
| SYS-003 | ejecuta_etl | sistema:etl | Ejecuta ETL manualmente |
| SYS-004 | configura_parametros | sistema:parametros | Configura parámetros |
| SYS-005 | ve_estado_sistema | sistema:estado | Ve estado del sistema |

### 3.10 DOMINIO: Seguridad (3 funciones)

| ID | Función | Capacidad | Descripción |
|----|---------|-----------|-------------|
| SEC-001 | configura_politicas | seguridad:politicas | Configura políticas |
| SEC-002 | ve_eventos_seguridad | seguridad:eventos | Ve eventos de seguridad |
| SEC-003 | gestiona_bloqueos | seguridad:bloqueos | Gestiona bloqueos |

---

## 4. CATÁLOGO DE AGRUPADORES

### 4.1 Lista de 12 Agrupadores

| ID | Nombre | Funciones | Descripción |
|----|--------|-----------|-------------|
| AGR-001 | agr_operador_basico | 5 | Consulta básica |
| AGR-002 | agr_operador_reportes | 7 | Acceso a reportes |
| AGR-003 | agr_supervisor | 12 | Supervisor de equipo |
| AGR-004 | agr_analista | 18 | Analista de datos |
| AGR-005 | agr_exportador | 4 | Exportación |
| AGR-006 | agr_gestor_alertas | 6 | Gestión de alertas |
| AGR-007 | agr_admin_usuarios | 12 | Admin de usuarios |
| AGR-008 | agr_admin_funciones | 6 | Admin RBAC |
| AGR-009 | agr_auditor | 4 | Auditoría |
| AGR-010 | agr_admin_sistema | 8 | Admin sistema |
| AGR-011 | agr_seguridad | 5 | Seguridad |
| AGR-012 | agr_completo | 45 | Acceso completo (excepto SoD) |

### 4.2 Detalle: AGR-001 agr_operador_basico

```
Funciones incluidas (5):
  - ve_reportes
  - filtra_reportes
  - ve_dashboard
  - ve_alertas
  - ve_historial_alertas

Usuarios estimados: 50-100
```

### 4.3 Detalle: AGR-003 agr_supervisor

```
Funciones incluidas (12):
  - ve_reportes
  - ve_reportes_avanzados
  - filtra_reportes
  - exporta_csv
  - exporta_excel
  - ve_dashboard
  - personaliza_dashboard
  - guarda_vistas
  - ve_alertas
  - configura_alertas
  - configura_alertas_equipo
  - ve_historial_alertas

Usuarios estimados: 20-40
```

### 4.4 Detalle: AGR-004 agr_analista

```
Funciones incluidas (18):
  - ve_reportes
  - ve_reportes_avanzados
  - ve_reportes_consolidados
  - filtra_reportes
  - exporta_csv
  - exporta_excel
  - exporta_pdf
  - crea_reportes
  - programa_reportes
  - ve_dashboard
  - personaliza_dashboard
  - guarda_vistas
  - configura_widgets
  - analiza_exploratorio
  - compara_periodos
  - identifica_patrones
  - detecta_anomalias
  - ejecuta_consultas

Usuarios estimados: 5-15
```

### 4.5 Detalle: AGR-007 agr_admin_usuarios

```
Funciones incluidas (12):
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
  - asigna_funciones
  - revoca_funciones

Usuarios estimados: 2-5

NOTA: SoD con AGR-009 (auditor)
```

### 4.6 Detalle: AGR-009 agr_auditor

```
Funciones incluidas (4):
  - ve_auditoria
  - busca_auditoria
  - exporta_auditoria
  - genera_compliance

Usuarios estimados: 2-5

SoD:
  - Incompatible con AGR-007 (admin_usuarios)
  - Incompatible con AGR-010 (admin_sistema)
```

---

## 5. SEPARACIÓN DE FUNCIONES (SoD)

### 5.1 Restricciones Definidas

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| SOD-001 | sod_admin_auditoria | SYS-001,SYS-002,SYS-003,SYS-004 | AUD-001,AUD-002,AUD-003,AUD-004 | Quien opera NO audita |
| SOD-002 | sod_usuarios_auditoria | USR-001,USR-003,USR-004,USR-008 | AUD-001,AUD-002,AUD-003 | Quien gestiona usuarios NO audita |
| SOD-003 | sod_crea_elimina | USR-001 | USR-004 | Control de 4 ojos |
| SOD-004 | sod_asigna_sod | FUN-001 | FUN-006 | Separación de poderes |
| SOD-005 | sod_politicas_auditoria | SEC-001 | AUD-001 | Independencia |

### 5.2 Lógica de Validación

```
Al asignar función F a usuario U:
  1. Obtener funciones actuales de U
  2. Para cada restricción SoD activa donde F participa:
     a. Determinar grupo de F (A o B)
     b. Verificar si U tiene funciones del grupo opuesto
     c. Si tiene → RECHAZAR asignación
  3. Si pasa todas las validaciones → PERMITIR
```

---

## 6. SEGMENTOS DE DATOS

### 6.1 Catálogo de Segmentos

| Código | Nombre | Descripción |
|--------|--------|-------------|
| OP | DATOS_OPERATIVOS | Operación del IVR: llamadas, menús |
| FI | DATOS_FINANCIEROS | Costos y facturación |
| TE | DATOS_TECNICOS | Infraestructura y rendimiento |
| SU | DATOS_SUPERVISION | Supervisión y control |
| CA | DATOS_CALIDAD | Métricas de calidad |
| GE | DATOS_CONSOLIDADOS | Datos agregados multi-segmento |

### 6.2 Reglas

1. Usuario pertenece a exactamente 1 segmento
2. Filtro automático por segmento en todas las consultas
3. Acceso multi-segmento requiere función ve_reportes_consolidados
4. Segmento GE (consolidados) ve datos agregados, no detalle

---

## 7. PERMISOS TEMPORALES

### 7.1 Concepto

Función otorgada temporalmente con fecha de vencimiento obligatoria.

### 7.2 Características

- Vencimiento máximo: 6 meses
- Justificación obligatoria (mínimo 20 caracteres)
- Mayor precedencia que asignación regular
- Revocación automática al vencer

### 7.3 Casos de Uso

```
Caso 1: Cobertura de vacaciones
  Usuario: maria.lopez
  Función: crea_usuarios
  Duración: 15 días
  Justificación: "Cobertura vacaciones admin principal 15-30 enero"

Caso 2: Proyecto especial
  Usuario: juan.perez
  Función: exporta_pdf
  Duración: 1 mes
  Justificación: "Proyecto auditoría externa Q1 2026"
```

---

## 8. MODELO DE DATOS

### 8.1 Diagrama Entidad-Relación

```
usuarios ─────────────┬──────────────── segmentos_datos
    │                 │
    │ N:M             │ 1:N
    ▼                 │
usuarios_funciones    │
    │                 │
    │ N:1             │
    ▼                 │
funciones ◄───────────┘
    │
    │ N:M
    ▼
agrupador_funciones
    │
    │ N:1
    ▼
agrupadores

separacion_funciones
    │
    │ 1:N
    ▼
separacion_funciones_detalle ───► funciones
```

---

## 9. IMPLEMENTACIÓN SQL

### 9.1 Tabla: segmentos_datos

```sql
CREATE TABLE segmentos_datos (
    segmento_id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_segmento_codigo UNIQUE (codigo),
    CONSTRAINT uk_segmento_nombre UNIQUE (nombre),
    INDEX idx_segmento_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO segmentos_datos (codigo, nombre, descripcion) VALUES
('OP', 'DATOS_OPERATIVOS', 'Datos de operación del IVR'),
('FI', 'DATOS_FINANCIEROS', 'Datos de costos y facturación'),
('TE', 'DATOS_TECNICOS', 'Datos técnicos de infraestructura'),
('SU', 'DATOS_SUPERVISION', 'Datos para supervisión'),
('CA', 'DATOS_CALIDAD', 'Datos de métricas de calidad'),
('GE', 'DATOS_CONSOLIDADOS', 'Datos agregados multi-segmento');
```

### 9.2 Tabla: usuarios

```sql
CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO', 'ELIMINADO') NOT NULL DEFAULT 'ACTIVO',
    segmento_id INT NOT NULL,
    intentos_fallidos TINYINT NOT NULL DEFAULT 0,
    bloqueado_hasta DATETIME NULL,
    debe_cambiar_password BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_ultimo_acceso DATETIME NULL,
    creado_por INT NULL,
    
    CONSTRAINT uk_usuario_username UNIQUE (username),
    CONSTRAINT uk_usuario_email UNIQUE (email),
    CONSTRAINT fk_usuario_segmento FOREIGN KEY (segmento_id) 
        REFERENCES segmentos_datos(segmento_id),
    CONSTRAINT fk_usuario_creador FOREIGN KEY (creado_por) 
        REFERENCES usuarios(usuario_id),
    
    INDEX idx_usuario_estado (estado),
    INDEX idx_usuario_segmento (segmento_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 9.3 Tabla: funciones

```sql
CREATE TABLE funciones (
    funcion_id VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dominio VARCHAR(50) NOT NULL,
    capacidad VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uk_funcion_nombre UNIQUE (nombre),
    INDEX idx_funcion_dominio (dominio),
    INDEX idx_funcion_activa (activa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
```

### 9.7 Tabla: separacion_funciones

```sql
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
```

### 9.8 Tabla: separacion_funciones_detalle

```sql
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
```

### 9.9 Tabla: permisos_temporales

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

### 9.10 Tabla: log_auditoria

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
    INDEX idx_log_modulo (modulo, fecha_evento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 10. FUNCIONES Y PROCEDIMIENTOS

### 10.1 Trigger: Checksum Auditoría

```sql
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
```

### 10.2 Trigger: Auditoría Inmutable

```sql
DELIMITER $$
CREATE TRIGGER trg_log_auditoria_no_update
BEFORE UPDATE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Los registros de auditoría son inmutables';
END$$
DELIMITER ;

CREATE TRIGGER trg_log_auditoria_no_delete
BEFORE DELETE ON log_auditoria
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Los registros de auditoría no se pueden eliminar';
END$$
DELIMITER ;
```

### 10.3 Función: usuario_tiene_funcion

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
    
    SELECT funcion_id INTO v_funcion_id
    FROM funciones
    WHERE nombre = p_nombre_funcion
      AND activa = TRUE;
    
    IF v_funcion_id IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Verificar permiso temporal activo
    SELECT TRUE INTO v_tiene
    FROM permisos_temporales
    WHERE usuario_id = p_usuario_id
      AND funcion_id = v_funcion_id
      AND estado = 'ACTIVO'
      AND fecha_vencimiento > NOW()
    LIMIT 1;
    
    IF v_tiene THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar asignación directa
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

### 10.4 Función: validar_sod

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

### 10.5 Procedimiento: asignar_funcion

```sql
DELIMITER $$
CREATE PROCEDURE asignar_funcion(
    IN p_usuario_id INT,
    IN p_funcion_id VARCHAR(20),
    IN p_asignado_por INT,
    IN p_justificacion VARCHAR(500)
)
BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_sod VARCHAR(200);
    DECLARE v_existe BOOLEAN DEFAULT FALSE;
    
    -- Validar usuario activo
    SELECT estado INTO v_estado
    FROM usuarios WHERE usuario_id = p_usuario_id;
    
    IF v_estado IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;
    
    IF v_estado != 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Usuario no está activo';
    END IF;
    
    -- Validar justificación
    IF LENGTH(TRIM(p_justificacion)) < 20 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Justificación debe tener al menos 20 caracteres';
    END IF;
    
    -- Verificar si ya tiene la función
    SELECT TRUE INTO v_existe
    FROM usuarios_funciones
    WHERE usuario_id = p_usuario_id
      AND funcion_id = p_funcion_id
      AND activo = TRUE
    LIMIT 1;
    
    IF v_existe THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Usuario ya tiene esta función asignada';
    END IF;
    
    -- Validar SoD
    SET v_sod = validar_sod(p_usuario_id, p_funcion_id);
    
    IF v_sod != 'OK' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = v_sod;
    END IF;
    
    -- Insertar asignación
    INSERT INTO usuarios_funciones 
        (usuario_id, funcion_id, asignado_por, justificacion)
    VALUES 
        (p_usuario_id, p_funcion_id, p_asignado_por, p_justificacion);
    
    SELECT 'Función asignada correctamente' AS resultado;
END$$
DELIMITER ;
```

### 10.6 Procedimiento: asignar_agrupador

```sql
DELIMITER $$
CREATE PROCEDURE asignar_agrupador(
    IN p_usuario_id INT,
    IN p_agrupador_id VARCHAR(20),
    IN p_asignado_por INT,
    IN p_justificacion VARCHAR(500)
)
BEGIN
    DECLARE v_funcion VARCHAR(20);
    DECLARE v_sod VARCHAR(200);
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_contador INT DEFAULT 0;
    
    DECLARE cur_funciones CURSOR FOR
        SELECT funcion_id 
        FROM agrupador_funciones
        WHERE agrupador_id = p_agrupador_id
        ORDER BY orden;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Validar agrupador existe
    IF NOT EXISTS (SELECT 1 FROM agrupadores WHERE agrupador_id = p_agrupador_id AND activo = TRUE) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Agrupador no existe o no está activo';
    END IF;
    
    -- Validar justificación
    IF LENGTH(TRIM(p_justificacion)) < 20 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Justificación debe tener al menos 20 caracteres';
    END IF;
    
    START TRANSACTION;
    
    OPEN cur_funciones;
    
    asignar_loop: LOOP
        FETCH cur_funciones INTO v_funcion;
        IF done THEN
            LEAVE asignar_loop;
        END IF;
        
        -- Validar SoD para cada función
        SET v_sod = validar_sod(p_usuario_id, v_funcion);
        IF v_sod != 'OK' THEN
            ROLLBACK;
            CLOSE cur_funciones;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_sod;
        END IF;
        
        -- Insertar si no existe
        INSERT IGNORE INTO usuarios_funciones 
            (usuario_id, funcion_id, asignado_por, justificacion, origen_agrupador)
        VALUES 
            (p_usuario_id, v_funcion, p_asignado_por, p_justificacion, p_agrupador_id);
        
        SET v_contador = v_contador + ROW_COUNT();
    END LOOP;
    
    CLOSE cur_funciones;
    COMMIT;
    
    SELECT CONCAT('Asignadas ', v_contador, ' funciones del agrupador') AS resultado;
END$$
DELIMITER ;
```

---

## 11. DATOS INICIALES

### 11.1 Insertar Funciones (57)

```sql
INSERT INTO funciones (funcion_id, nombre, dominio, capacidad, descripcion) VALUES
-- Usuarios (10)
('USR-001', 'crea_usuarios', 'usuarios', 'usuarios:crear', 'Crea nuevos usuarios'),
('USR-002', 've_usuarios', 'usuarios', 'usuarios:leer', 'Consulta información de usuarios'),
('USR-003', 'modifica_usuarios', 'usuarios', 'usuarios:modificar', 'Modifica datos de usuarios'),
('USR-004', 'elimina_usuarios', 'usuarios', 'usuarios:eliminar', 'Baja lógica de usuarios'),
('USR-005', 'lista_usuarios', 'usuarios', 'usuarios:listar', 'Lista usuarios con filtros'),
('USR-006', 'busca_usuarios', 'usuarios', 'usuarios:buscar', 'Busca usuarios por criterios'),
('USR-007', 'resetea_passwords', 'usuarios', 'usuarios:reset_password', 'Genera contraseña temporal'),
('USR-008', 'bloquea_usuarios', 'usuarios', 'usuarios:bloquear', 'Bloquea acceso de usuario'),
('USR-009', 'desbloquea_usuarios', 'usuarios', 'usuarios:desbloquear', 'Desbloquea usuario'),
('USR-010', 'reactiva_usuarios', 'usuarios', 'usuarios:reactivar', 'Reactiva usuario inactivo'),

-- Funciones RBAC (6)
('FUN-001', 'asigna_funciones', 'funciones', 'funciones:asignar', 'Asigna funciones a usuarios'),
('FUN-002', 'revoca_funciones', 'funciones', 'funciones:revocar', 'Revoca funciones de usuarios'),
('FUN-003', 've_funciones', 'funciones', 'funciones:leer', 'Consulta catálogo de funciones'),
('FUN-004', 've_asignaciones', 'funciones', 'asignaciones:leer', 'Ve asignaciones usuario-función'),
('FUN-005', 'asigna_agrupadores', 'funciones', 'agrupadores:asignar', 'Asigna agrupadores'),
('FUN-006', 'gestiona_sod', 'funciones', 'sod:gestionar', 'Configura restricciones SoD'),

-- Reportes (10)
('RPT-001', 've_reportes', 'reportes', 'reportes:leer', 'Ve reportes básicos'),
('RPT-002', 've_reportes_avanzados', 'reportes', 'reportes:leer_avanzados', 'Ve reportes avanzados'),
('RPT-003', 've_reportes_consolidados', 'reportes', 'reportes:leer_consolidados', 'Ve reportes multi-segmento'),
('RPT-004', 'filtra_reportes', 'reportes', 'reportes:filtrar', 'Aplica filtros a reportes'),
('RPT-005', 'exporta_csv', 'reportes', 'reportes:exportar_csv', 'Exporta a CSV'),
('RPT-006', 'exporta_excel', 'reportes', 'reportes:exportar_excel', 'Exporta a Excel'),
('RPT-007', 'exporta_pdf', 'reportes', 'reportes:exportar_pdf', 'Exporta a PDF'),
('RPT-008', 'crea_reportes', 'reportes', 'reportes:crear', 'Crea reportes personalizados'),
('RPT-009', 'programa_reportes', 'reportes', 'reportes:programar', 'Programa generación automática'),
('RPT-010', 'comparte_reportes', 'reportes', 'reportes:compartir', 'Comparte reportes'),

-- Dashboard (5)
('DSH-001', 've_dashboard', 'dashboard', 'dashboard:leer', 'Ve dashboard estándar'),
('DSH-002', 'personaliza_dashboard', 'dashboard', 'dashboard:personalizar', 'Personaliza disposición'),
('DSH-003', 'guarda_vistas', 'dashboard', 'dashboard:guardar_vista', 'Guarda vistas personalizadas'),
('DSH-004', 'configura_widgets', 'dashboard', 'dashboard:config_widgets', 'Configura widgets'),
('DSH-005', 'comparte_dashboard', 'dashboard', 'dashboard:compartir', 'Comparte vistas'),

-- Alertas (8)
('ALR-001', 've_alertas', 'alertas', 'alertas:leer', 'Ve alertas propias'),
('ALR-002', 'configura_alertas', 'alertas', 'alertas:configurar', 'Configura alertas personales'),
('ALR-003', 'configura_alertas_equipo', 'alertas', 'alertas:config_equipo', 'Alertas para equipo'),
('ALR-004', 'configura_alertas_globales', 'alertas', 'alertas:config_global', 'Alertas globales'),
('ALR-005', 'pausa_alertas', 'alertas', 'alertas:pausar', 'Pausa alertas'),
('ALR-006', 'elimina_alertas', 'alertas', 'alertas:eliminar', 'Elimina alertas propias'),
('ALR-007', 've_historial_alertas', 'alertas', 'alertas:historial', 'Ve historial'),
('ALR-008', 'gestiona_destinatarios', 'alertas', 'alertas:destinatarios', 'Gestiona destinatarios'),

-- Análisis (6)
('ANL-001', 'analiza_exploratorio', 'analisis', 'analisis:exploratorio', 'Análisis exploratorio'),
('ANL-002', 'compara_periodos', 'analisis', 'analisis:comparar', 'Compara períodos'),
('ANL-003', 'identifica_patrones', 'analisis', 'analisis:patrones', 'Identifica patrones'),
('ANL-004', 'detecta_anomalias', 'analisis', 'analisis:anomalias', 'Detecta anomalías'),
('ANL-005', 'ejecuta_consultas', 'analisis', 'analisis:consultas', 'Ejecuta consultas'),
('ANL-006', 'analiza_navegacion', 'analisis', 'analisis:navegacion', 'Analiza navegación IVR'),

-- Auditoría (4)
('AUD-001', 've_auditoria', 'auditoria', 'auditoria:leer', 'Ve logs de auditoría'),
('AUD-002', 'busca_auditoria', 'auditoria', 'auditoria:buscar', 'Busca en logs'),
('AUD-003', 'exporta_auditoria', 'auditoria', 'auditoria:exportar', 'Exporta logs'),
('AUD-004', 'genera_compliance', 'auditoria', 'auditoria:compliance', 'Genera reportes compliance'),

-- Sistema (5)
('SYS-001', 'administra_sistema', 'sistema', 'sistema:administrar', 'Administra configuración'),
('SYS-002', 'gestiona_sesiones', 'sistema', 'sistema:sesiones', 'Gestiona sesiones'),
('SYS-003', 'ejecuta_etl', 'sistema', 'sistema:etl', 'Ejecuta ETL manualmente'),
('SYS-004', 'configura_parametros', 'sistema', 'sistema:parametros', 'Configura parámetros'),
('SYS-005', 've_estado_sistema', 'sistema', 'sistema:estado', 'Ve estado del sistema'),

-- Seguridad (3)
('SEC-001', 'configura_politicas', 'seguridad', 'seguridad:politicas', 'Configura políticas'),
('SEC-002', 've_eventos_seguridad', 'seguridad', 'seguridad:eventos', 'Ve eventos de seguridad'),
('SEC-003', 'gestiona_bloqueos', 'seguridad', 'seguridad:bloqueos', 'Gestiona bloqueos');
```

### 11.2 Insertar Agrupadores (12)

```sql
INSERT INTO agrupadores (agrupador_id, nombre, descripcion) VALUES
('AGR-001', 'agr_operador_basico', 'Funciones mínimas para consulta'),
('AGR-002', 'agr_operador_reportes', 'Acceso a reportes'),
('AGR-003', 'agr_supervisor', 'Supervisor de equipo'),
('AGR-004', 'agr_analista', 'Analista de datos'),
('AGR-005', 'agr_exportador', 'Exportación de reportes'),
('AGR-006', 'agr_gestor_alertas', 'Gestión de alertas'),
('AGR-007', 'agr_admin_usuarios', 'Administración de usuarios'),
('AGR-008', 'agr_admin_funciones', 'Administración RBAC'),
('AGR-009', 'agr_auditor', 'Auditoría y compliance'),
('AGR-010', 'agr_admin_sistema', 'Administración del sistema'),
('AGR-011', 'agr_seguridad', 'Seguridad del sistema'),
('AGR-012', 'agr_completo', 'Acceso completo excepto SoD');
```

### 11.3 Insertar Detalle Agrupadores

```sql
-- AGR-001: agr_operador_basico (5)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-001', 'RPT-001', 1),
('AGR-001', 'RPT-004', 2),
('AGR-001', 'DSH-001', 3),
('AGR-001', 'ALR-001', 4),
('AGR-001', 'ALR-007', 5);

-- AGR-002: agr_operador_reportes (7)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-002', 'RPT-001', 1),
('AGR-002', 'RPT-002', 2),
('AGR-002', 'RPT-004', 3),
('AGR-002', 'DSH-001', 4),
('AGR-002', 'DSH-002', 5),
('AGR-002', 'ALR-001', 6),
('AGR-002', 'ALR-007', 7);

-- AGR-003: agr_supervisor (12)
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

-- AGR-004: agr_analista (18)
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

-- AGR-005: agr_exportador (4)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-005', 'RPT-005', 1),
('AGR-005', 'RPT-006', 2),
('AGR-005', 'RPT-007', 3),
('AGR-005', 'RPT-010', 4);

-- AGR-006: agr_gestor_alertas (6)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-006', 'ALR-001', 1),
('AGR-006', 'ALR-002', 2),
('AGR-006', 'ALR-003', 3),
('AGR-006', 'ALR-005', 4),
('AGR-006', 'ALR-006', 5),
('AGR-006', 'ALR-008', 6);

-- AGR-007: agr_admin_usuarios (12)
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

-- AGR-008: agr_admin_funciones (6)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-008', 'FUN-001', 1),
('AGR-008', 'FUN-002', 2),
('AGR-008', 'FUN-003', 3),
('AGR-008', 'FUN-004', 4),
('AGR-008', 'FUN-005', 5),
('AGR-008', 'FUN-006', 6);

-- AGR-009: agr_auditor (4)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-009', 'AUD-001', 1),
('AGR-009', 'AUD-002', 2),
('AGR-009', 'AUD-003', 3),
('AGR-009', 'AUD-004', 4);

-- AGR-010: agr_admin_sistema (8)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-010', 'SYS-001', 1),
('AGR-010', 'SYS-002', 2),
('AGR-010', 'SYS-003', 3),
('AGR-010', 'SYS-004', 4),
('AGR-010', 'SYS-005', 5),
('AGR-010', 'USR-002', 6),
('AGR-010', 'USR-005', 7),
('AGR-010', 'USR-006', 8);

-- AGR-011: agr_seguridad (5)
INSERT INTO agrupador_funciones (agrupador_id, funcion_id, orden) VALUES
('AGR-011', 'SEC-001', 1),
('AGR-011', 'SEC-002', 2),
('AGR-011', 'SEC-003', 3),
('AGR-011', 'AUD-001', 4),
('AGR-011', 'AUD-002', 5);
```

### 11.4 Insertar Restricciones SoD

```sql
-- Restricciones principales
INSERT INTO separacion_funciones (restriccion_id, nombre, descripcion, cardinalidad_maxima, razon) VALUES
('SOD-001', 'sod_admin_auditoria', 'Quien opera NO debe auditar', 1, 'Principio de independencia del auditor'),
('SOD-002', 'sod_usuarios_auditoria', 'Quien gestiona usuarios NO audita', 1, 'Prevenir ocultamiento de acciones'),
('SOD-003', 'sod_crea_elimina', 'Quien crea NO elimina', 1, 'Control de cuatro ojos'),
('SOD-004', 'sod_asigna_sod', 'Quien asigna NO gestiona SoD', 1, 'Separación de poderes'),
('SOD-005', 'sod_politicas_auditoria', 'Quien configura políticas NO audita', 1, 'Independencia');

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

---

## 12. EJEMPLOS DE USO

### 12.1 Verificar si usuario puede exportar PDF

```sql
SELECT usuario_tiene_funcion(123, 'exporta_pdf') AS puede_exportar;
-- Resultado: 1 (TRUE) o 0 (FALSE)
```

### 12.2 Asignar función individual

```sql
CALL asignar_funcion(
    123,                                      -- usuario_id
    'RPT-005',                               -- funcion_id (exporta_csv)
    1,                                       -- asignado_por
    'Requerimiento para proyecto Q1 2026'   -- justificación
);
```

### 12.3 Asignar agrupador completo

```sql
CALL asignar_agrupador(
    123,                                          -- usuario_id
    'AGR-003',                                   -- agrupador_id (supervisor)
    1,                                           -- asignado_por
    'Promoción a supervisor equipo Norte'        -- justificación
);
```

### 12.4 Ver funciones de un usuario

```sql
SELECT 
    f.nombre AS funcion,
    f.dominio,
    uf.fecha_asignacion,
    uf.origen_agrupador
FROM usuarios_funciones uf
INNER JOIN funciones f ON uf.funcion_id = f.funcion_id
WHERE uf.usuario_id = 123
  AND uf.activo = TRUE
ORDER BY f.dominio, f.nombre;
```

### 12.5 Verificar SoD antes de asignar

```sql
SELECT validar_sod(123, 'AUD-001') AS validacion;
-- Resultado: 'OK' o 'VIOLACION: sod_admin_auditoria'
```

---

## 13. MIGRACIÓN v4.0 → v5.0

### 13.1 Mapeo de Roles a Agrupadores

| Rol v4.0 | Agrupador v5.0 |
|----------|----------------|
| USERS_FULL_MANAGER | AGR-007 agr_admin_usuarios |
| USERS_VIEWER | ve_usuarios + lista_usuarios |
| REPORTS_VIEWER | AGR-001 agr_operador_basico |
| REPORTS_EXPORTER | AGR-001 + AGR-005 |
| SYSTEM_ADMIN | AGR-010 agr_admin_sistema |
| AUDIT_VIEWER | AGR-009 agr_auditor |

### 13.2 Pasos de Migración

1. Crear nuevas tablas v5.0
2. Insertar catálogo de funciones
3. Insertar agrupadores y detalle
4. Migrar asignaciones de roles a funciones
5. Verificar integridad
6. Desactivar tablas v4.0

---

## 14. CONCLUSIÓN

### Resumen del Modelo v5.0

| Aspecto | Valor |
|---------|-------|
| Filosofía | Sin Pretensiones |
| Funciones atómicas | 57 |
| Agrupadores | 12 |
| Dominios | 9 |
| Restricciones SoD | 5 |
| Segmentos de datos | 6 |

### Beneficios

1. Claridad: Nombre = Acción
2. Auditoría: Consulta directa
3. Flexibilidad: Combinaciones únicas
4. Mantenibilidad: Cambio de cargo ≠ cambio de funciones
5. Compliance: Mínimo privilegio

---

**FIN DEL DOCUMENTO**

**Versión:** 5.0 - Enfoque Sin Pretensiones  
**Fecha:** 03 de enero de 2026  
**Estado:** Listo para Implementación
