# MODELO DOCUMENTAL IACT v2.0.9

**Versión:** 2.0.9  
**Fecha:** 2026-01-07  
**Estado:** EN DESARROLLO ACTIVO  
**Fase Actual:** Generación de Requisitos Funcionales (FR)

---

## RESUMEN EJECUTIVO

Este documento representa el estado actual completo del proyecto IACT (Call Center Analytics Dashboard), incluyendo todos los artefactos generados, su ubicación, y el progreso de cada dominio documental.

### Estadísticas Globales

| Métrica | Cantidad | Estado |
|---------|----------|--------|
| Casos de Uso (UC) | 49 | ✅ COMPLETO |
| Requisitos Funcionales (FR) | 55 generados / 158 totales | 🔄 EN PROGRESO (35%) |
| Reglas de Negocio (BR) | 15 | ✅ COMPLETO |
| Restricciones (CNST) | 10 | ✅ COMPLETO |
| Módulos Arquitectónicos | 8 | ✅ COMPLETO |
| Documentos Fundacionales | 7 | ✅ COMPLETO |
| Documentos Gobernanza | 10 | ✅ COMPLETO |
| Documentos META | 5 | ✅ COMPLETO |

---

## PARTE 1: ESTRUCTURA DOCUMENTAL

### 1.1 Dominios Documentales

```
MODELO DOCUMENTAL IACT
├── 📁 requisitos/
│   ├── 📁 casos_uso/          # 49 UC en 8 módulos
│   ├── 📁 funcionales/        # 55 FR generados (en progreso)
│   └── 📁 no_funcionales/     # NFR (pendiente)
├── 📁 arquitectura/
│   ├── 📁 modulos/            # 8 ARQ_MOD
│   └── 📁 decisiones/         # ADR (pendiente)
├── 📁 reglas/
│   ├── 📁 negocio/            # 15 BR
│   └── 📁 restricciones/      # 10 CNST
├── 📁 fundamentos/            # 7 FND
├── 📁 gobernanza/             # 10 GOB
├── 📁 metamodelo/             # 3 MTM
├── 📁 taxonomia/              # 3 TXM
└── 📁 meta/                   # 5 META
```

### 1.2 Jerarquía de 4 Niveles

```
NIVEL 1: ESTRATÉGICO
├── BReq (Business Requirements) ────────────────────── 4 documentos
│   ├── BReq-001: Visualizar Métricas
│   ├── BReq-002: Exportar Datos
│   ├── BReq-003: Gestionar Accesos
│   └── BReq-004: Cumplimiento Seguridad
│
NIVEL 2: TÁCTICO
├── UC (Casos de Uso) ───────────────────────────────── 49 documentos
│   └── Derivados de BReq + BR
│
NIVEL 3: OPERATIVO
├── FR (Requisitos Funcionales) ─────────────────────── 158 planificados
│   └── Derivados de UC (55 generados)
│
NIVEL 4: TÉCNICO
├── TEST (Casos de Prueba) ──────────────────────────── Pendiente
│   └── Derivados de FR
└── CODE (Implementación) ───────────────────────────── Pendiente
    └── Trazable a FR
```

---

## PARTE 2: INVENTARIO DE ARTEFACTOS

### 2.1 Documentos Fundacionales (FND)

| ID | Nombre | Versión | Estado |
|----|--------|---------|--------|
| FND_01 | Concepto de Requisito | 1.0.0 | ✅ Aprobado |
| FND_02 | Reglas de Negocio | 1.0.0 | ✅ Aprobado |
| FND_03 | Casos de Uso | 1.3.0 | ✅ Aprobado |
| FND_04 | Trazabilidad | 1.0.0 | ✅ Aprobado |
| FND_05 | Jerarquía 4 Niveles | 1.1.0 | ✅ Aprobado |
| FND_06 | Derivación vs Transformación | 1.0.0 | ✅ Aprobado |
| FND_07 | Requerimientos Funcionales | 1.0.0 | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/outputs/FND_*.rst`

### 2.2 Documentos de Gobernanza (GOB)

| ID | Nombre | Versión | Estado |
|----|--------|---------|--------|
| GOB_01 | Modelo de Gobernanza IACT | 1.0.0 | ✅ Aprobado |
| GOB_02 | Roles y RACI | 1.0.0 | ✅ Aprobado |
| GOB_03 | Control Calidad Documental | 1.0.0 | ✅ Aprobado |
| GOB_04 | Gestión Cambios Documentales | 1.0.0 | ✅ Aprobado |
| GOB_05 | Control de Versiones | 1.0.0 | ✅ Aprobado |
| GOB_06 | Trazabilidad SDLC | 1.0.0 | ✅ Aprobado |
| GOB_07 | Gestión de Dominios | 1.0.0 | ✅ Aprobado |
| GOB_08 | Estados Documentales | 1.0.0 | ✅ Aprobado |
| GOB_09 | Política de Clasificación | 1.0.0 | ✅ Aprobado |
| GOB_10 | Auditoría Documental | 1.0.0 | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/outputs/GOB_*.rst`

### 2.3 Documentos META

| ID | Nombre | Versión | Estado |
|----|--------|---------|--------|
| META_01 | Identidad del Proyecto | 1.0.0 | ✅ Aprobado |
| META_02 | Clasificación Documental | 1.0.0 | ✅ Aprobado |
| META_03 | Fases SDLC | 1.0.0 | ✅ Aprobado |
| META_04 | Contexto IACT | 1.0.0 | ✅ Aprobado |
| META_05 | Estructura Documental | 1.0.0 | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/outputs/META_*.rst`

### 2.4 Metamodelos (MTM)

| ID | Nombre | Versión | Estado |
|----|--------|---------|--------|
| MTM_01 | Metamodelo de Requisitos | 1.0.0 | ✅ Aprobado |
| MTM_02 | Metamodelo de Trazabilidad | 1.0.0 | ✅ Aprobado |
| MTM_03 | Metamodelo RBAC | 1.0.0 | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/uploads/MTM_*.rst`

### 2.5 Taxonomías (TXM)

| ID | Nombre | Versión | Estado |
|----|--------|---------|--------|
| TXM_01 | Taxonomía de Requisitos | 1.0.0 | ✅ Aprobado |
| TXM_02 | Taxonomía de Artefactos | 1.0.0 | ✅ Aprobado |
| TXM_03 | Taxonomía de Reglas de Negocio | 1.0.0 | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/uploads/TXM_*.rst`

---

## PARTE 3: REGLAS DE NEGOCIO (BR)

### 3.1 Catálogo de Reglas de Negocio

| ID | Nombre | Categoría | Estado |
|----|--------|-----------|--------|
| BR_001 | Inmutabilidad de Fuente | Datos | ✅ Aprobado |
| BR_002 | ETL Nocturno | Proceso | ✅ Aprobado |
| BR_003 | RBAC Flat | Seguridad | ✅ Aprobado |
| BR_004 | Comunicaciones Internas | Seguridad | ✅ Aprobado |
| BR_005 | Sesión Única | Seguridad | ✅ Aprobado |
| BR_006 | RBAC Flat NIST | Seguridad | ✅ Aprobado |
| BR_007 | Separación de Funciones (SoD) | Seguridad | ✅ Aprobado |
| BR_008 | Auditoría Obligatoria | Cumplimiento | ✅ Aprobado |
| BR_009 | Bajas Lógicas | Datos | ✅ Aprobado |
| BR_010 | Ventana de Datos | Datos | ✅ Aprobado |
| BR_011 | Formatos de Exportación | Proceso | ✅ Aprobado |
| BR_012 | Segmentación Usuario-Centro | Seguridad | ✅ Aprobado |
| BR_013 | Username Único | Datos | ✅ Aprobado |
| BR_014 | Complejidad de Password | Seguridad | ✅ Aprobado |
| BR_015 | Bloqueo por Intentos Fallidos | Seguridad | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/outputs/BR_*.rst` y `/mnt/user-data/outputs/reglas_negocio/`

---

## PARTE 4: RESTRICCIONES (CNST)

### 4.1 Catálogo de Restricciones

| ID | Nombre | Categoría | Estado |
|----|--------|-----------|--------|
| CNST-001 | Comunicaciones Prohibidas | Seguridad | ✅ Aprobado |
| CNST-002 | Gestión Sesiones en BD | Arquitectura | ✅ Aprobado |
| CNST-003 | Base de Datos Dual Inmutable | Arquitectura | ✅ Aprobado |
| CNST-004 | Actualización Datos vía ETL | Arquitectura | ✅ Aprobado |
| CNST-005 | Seguridad DRF Checklist | Seguridad | ✅ Aprobado |
| CNST-006 | Antipatrones Arquitectura | Arquitectura | ✅ Aprobado |
| CNST-007 | Límites Performance SLA | Performance | ✅ Aprobado |
| CNST-008 | Infraestructura Deployment | Infraestructura | ✅ Aprobado |
| CNST-009 | Logging Auditoría Inmutable | Cumplimiento | ✅ Aprobado |
| CNST-010 | Clasificación Protección Datos | Seguridad | ✅ Aprobado |

**Ubicación:** `/mnt/user-data/outputs/CNST_*.rst`

---

## PARTE 5: ARQUITECTURA MODULAR

### 5.1 Módulos del Sistema

| ID | Nombre | UC | Descripción |
|----|--------|-----|-------------|
| MOD_Auth | Autenticación | 5 | Login, logout, sesiones, passwords |
| MOD_Users | Gestión Usuarios | 4 | CRUD de usuarios |
| MOD_Access | Control de Acceso | 9 | RBAC, funciones, segmentos, SoD |
| MOD_Reports | Reportes y Visualización | 14 | Dashboards, KPIs, exportación |
| MOD_Alerts | Sistema de Alertas | 5 | Notificaciones y umbrales |
| MOD_Pipeline | Supervisión ETL | 4 | Monitoreo del ETL |
| MOD_Audit | Auditoría | 4 | Logs de auditoría |
| MOD_Logs | Logs del Sistema | 4 | Logs técnicos |

**Ubicación Módulos:** `/mnt/user-data/outputs/ARQ_MOD_*.rst`

### 5.2 Distribución de UC por Módulo

```
MOD_Auth (5 UC)
├── UC_001: Iniciar Sesión
├── UC_002: Cerrar Sesión
├── UC_003: Recuperar Password
├── UC_004: Cambiar Password
└── UC_005: Gestionar Sesiones

MOD_Users (4 UC)
├── UC_006: Crear Usuario
├── UC_007: Modificar Usuario
├── UC_008: Dar de Baja Usuario
└── UC_009: Listar Usuarios

MOD_Access (9 UC)
├── UC_010: Asignar Funciones
├── UC_011: Revocar Funciones
├── UC_041: Asignar Segmento
├── UC_042: Revocar Segmento
├── UC_043: Configurar SoD
├── UC_044: Consultar Permisos
├── UC_045: Gestionar Agrupadores
├── UC_046: Gestionar Funciones
└── UC_047: Auditar Permisos

MOD_Reports (14 UC)
├── UC_017: Generar Reporte
├── UC_018: Crear Reporte Personalizado
├── UC_019: Programar Reporte
├── UC_020: Filtrar Por Fecha
├── UC_021: Filtrar Por Centro
├── UC_022: Exportar CSV
├── UC_023: Exportar Excel
├── UC_024: Exportar PDF
├── UC_025: Visualizar Dashboard
├── UC_026: Ver KPIs
├── UC_027: Analizar Tendencias
├── UC_028: Comparar Períodos
├── UC_029: Filtrar Dashboard Centro
└── UC_030: Exportar Dashboard

MOD_Alerts (5 UC)
├── UC_036: Crear Alerta
├── UC_037: Recibir Notificación
├── UC_038: Consultar Historial
├── UC_039: Modificar Alerta
└── UC_040: Gestionar Destinatarios

MOD_Pipeline (4 UC)
├── UC_050: Supervisar ETL
├── UC_051: Consultar Errores ETL
├── UC_052: Consultar Disponibilidad
└── UC_053: Reiniciar ETL

MOD_Audit (4 UC)
├── UC_060: Registrar Evento
├── UC_061: Consultar Log
├── UC_062: Generar Reporte Auditoría
└── UC_063: Exportar Auditoría

MOD_Logs (4 UC)
├── UC_070: Consultar Logs Sistema
├── UC_071: Filtrar Logs
├── UC_072: Exportar Logs
└── UC_073: Configurar Retención
```

**Ubicación UC:** `/mnt/user-data/outputs/casos_uso/{modulo}/UC_*.rst`

---

## PARTE 6: REQUISITOS FUNCIONALES (FR) - EN PROGRESO

### 6.1 Plan de Generación de FR

| Fase | Módulo | UC | FR Plan | FR Gen | Estado |
|------|--------|-----|---------|--------|--------|
| FASE 1 | MOD_Auth | 5 | 21 | 21 | ✅ COMPLETA |
| FASE 2 | MOD_Users | 4 | 17 | 17 | ✅ COMPLETA |
| FASE 3A | MOD_Access (Funciones) | 2 | 7 | 7 | ✅ COMPLETA |
| FASE 3B | MOD_Access (Segmentos/SoD) | 3 | 10 | 10 | ✅ COMPLETA |
| FASE 3C | MOD_Access (Consultas) | 4 | 13 | 0 | 🔄 PENDIENTE |
| FASE 4 | MOD_Reports | 14 | 42 | 0 | ⏳ PENDIENTE |
| FASE 5 | MOD_Alerts | 5 | 16 | 0 | ⏳ PENDIENTE |
| FASE 6 | MOD_Pipeline | 4 | 14 | 0 | ⏳ PENDIENTE |
| FASE 7 | MOD_Audit | 4 | 10 | 0 | ⏳ PENDIENTE |
| FASE 8 | MOD_Logs | 4 | 8 | 0 | ⏳ PENDIENTE |
| **TOTAL** | — | **49** | **158** | **55** | **35%** |

### 6.2 FR Generados - Detalle

#### FASE 1: MOD_Auth (21 FR) ✅

**UC_001: Iniciar Sesión (5 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-001.01 | Validar formato username | Validación |
| FR-001.02 | Validar credenciales | Validación |
| FR-001.03 | Generar token JWT | Proceso |
| FR-001.04 | Invalidar sesiones previas | Proceso |
| FR-001.05 | Registrar evento auditoría | Auditoría |

**UC_002: Cerrar Sesión (3 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-002.01 | Invalidar token JWT | Proceso |
| FR-002.02 | Registrar evento logout | Auditoría |
| FR-002.03 | Limpiar datos sesión cliente | Interfaz |

**UC_003: Recuperar Password (5 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-003.01 | Validar username existe | Validación |
| FR-003.02 | Mostrar pregunta seguridad | Interfaz |
| FR-003.03 | Validar respuesta | Validación |
| FR-003.04 | Generar password temporal | Proceso |
| FR-003.05 | Forzar cambio siguiente login | Proceso |

**UC_004: Cambiar Password (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-004.01 | Validar password actual | Validación |
| FR-004.02 | Validar complejidad nuevo password | Validación |
| FR-004.03 | Actualizar hash BD | Datos |
| FR-004.04 | Invalidar sesiones | Proceso |

**UC_005: Gestionar Sesiones (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-005.01 | Listar sesiones activas | Proceso |
| FR-005.02 | Mostrar detalle sesión | Interfaz |
| FR-005.03 | Invalidar sesión individual | Proceso |
| FR-005.04 | Invalidar sesiones por usuario | Proceso |

**Ubicación:** `/mnt/user-data/outputs/funcionales/auth/`

#### FASE 2: MOD_Users (17 FR) ✅

**UC_006: Crear Usuario (5 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-006.01 | Validar campos obligatorios | Validación |
| FR-006.02 | Verificar unicidad username | Validación |
| FR-006.03 | Generar password temporal | Proceso |
| FR-006.04 | Crear registro usuario | Datos |
| FR-006.05 | Registrar auditoría | Auditoría |

**UC_007: Modificar Usuario (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-007.01 | Cargar datos usuario | Proceso |
| FR-007.02 | Validar campos modificados | Validación |
| FR-007.03 | Actualizar registro | Datos |
| FR-007.04 | Registrar cambios auditoría | Auditoría |

**UC_008: Dar de Baja Usuario (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-008.01 | Validar usuario activo | Validación |
| FR-008.02 | Cambiar estado a INACTIVO | Datos |
| FR-008.03 | Invalidar sesiones | Proceso |
| FR-008.04 | Preservar registro histórico | Auditoría |

**UC_009: Listar Usuarios (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-009.01 | Obtener lista paginada | Proceso |
| FR-009.02 | Aplicar filtros | Interfaz |
| FR-009.03 | Ordenar resultados | Interfaz |
| FR-009.04 | Mostrar indicador inactividad | Interfaz |

**Ubicación:** `/mnt/user-data/outputs/funcionales/users/`

#### FASE 3A: MOD_Access - Funciones (7 FR) ✅

**UC_010: Asignar Funciones (4 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-010.01 | Listar funciones disponibles | Proceso |
| FR-010.02 | Validar SoD antes de asignar | Validación |
| FR-010.03 | Crear asignación usuario-función | Datos |
| FR-010.04 | Calcular permisos efectivos | Proceso |

**UC_011: Revocar Funciones (3 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-011.01 | Listar funciones asignadas | Proceso |
| FR-011.02 | Eliminar asignación | Datos |
| FR-011.03 | Recalcular permisos efectivos | Proceso |

**Ubicación:** `/tmp/funcionales/access/UC_010_*/` y `/tmp/funcionales/access/UC_011_*/`

#### FASE 3B: MOD_Access - Segmentos y SoD (10 FR) ✅

**UC_041: Asignar Segmento (3 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-041.01 | Listar centros disponibles | Proceso |
| FR-041.02 | Asignar centro a usuario | Datos |
| FR-041.03 | Aplicar filtro en consultas | Proceso |

**UC_042: Revocar Segmento (2 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-042.01 | Validar mínimo un segmento | Validación |
| FR-042.02 | Eliminar asignación segmento | Datos |

**UC_043: Configurar SoD (5 FR)**
| ID | Nombre | Tipo |
|----|--------|------|
| FR-043.01 | Crear restricción SoD | Datos |
| FR-043.02 | Validar conflictos existentes | Validación |
| FR-043.03 | Listar restricciones vigentes | Proceso |
| FR-043.04 | Modificar restricción | Datos |
| FR-043.05 | Eliminar restricción | Datos |

**Ubicación:** `/tmp/funcionales/access/UC_04*_*/`

### 6.3 FR Pendientes por Generar

#### FASE 3C: MOD_Access - Consultas (13 FR) 🔄

**UC_044: Consultar Permisos (3 FR)**
- FR-044.01: Calcular permisos efectivos
- FR-044.02: Mostrar origen de permiso
- FR-044.03: Mostrar restricciones SoD

**UC_045: Gestionar Agrupadores (4 FR)**
- FR-045.01: Listar agrupadores
- FR-045.02: Crear agrupador
- FR-045.03: Modificar composición
- FR-045.04: Validar SoD interno

**UC_046: Gestionar Funciones (3 FR)**
- FR-046.01: Listar funciones por módulo
- FR-046.02: Mostrar detalle función
- FR-046.03: Actualizar descripción

**UC_047: Auditar Permisos (3 FR)**
- FR-047.01: Consultar historial permisos
- FR-047.02: Filtrar por criterios
- FR-047.03: Exportar reporte auditoría

#### FASES 4-8: Módulos Restantes (90 FR) ⏳

| Módulo | UC | FR Estimados |
|--------|-----|--------------|
| MOD_Reports | 14 | 42 |
| MOD_Alerts | 5 | 16 |
| MOD_Pipeline | 4 | 14 |
| MOD_Audit | 4 | 10 |
| MOD_Logs | 4 | 8 |

---

## PARTE 7: CATÁLOGO RBAC

### 7.1 Agrupadores (AGR)

| Código | Nombre | Funciones |
|--------|--------|-----------|
| AGR-001 | administrador_usuarios | USR-001 a USR-006 |
| AGR-002 | visor_usuarios | USR-005, USR-006 |
| AGR-003 | operador_reportes | REP-001 a REP-005 |
| AGR-004 | analista_dashboard | DSB-001 a DSB-005 |
| AGR-005 | gestor_alertas | ALR-001 a ALR-004 |
| AGR-006 | supervisor_etl | ETL-001 a ETL-004 |
| AGR-007 | auditor_sistema | AUD-001 a AUD-004 |
| AGR-008 | admin_seguridad | ACC-001 a ACC-007 |

### 7.2 Funciones por Módulo

**MOD_Auth (AUT-xxx)**
- AUT-001: iniciar_sesion
- AUT-002: cerrar_sesion
- AUT-003: cambiar_password_propio
- AUT-004: gestionar_sesiones

**MOD_Users (USR-xxx)**
- USR-001: crear_usuario
- USR-002: modificar_usuario
- USR-003: baja_usuario
- USR-004: reactivar_usuario
- USR-005: listar_usuarios
- USR-006: ver_detalle_usuario

**MOD_Access (ACC-xxx)**
- ACC-001: asignar_funciones
- ACC-002: revocar_funciones
- ACC-003: asignar_segmentos
- ACC-004: revocar_segmentos
- ACC-005: configurar_sod
- ACC-006: consultar_permisos
- ACC-007: auditar_permisos

**MOD_Reports (REP-xxx)**
- REP-001: generar_reporte
- REP-002: crear_reporte_personalizado
- REP-003: programar_reporte
- REP-004: exportar_reporte
- REP-005: ver_reportes

**MOD_Alerts (ALR-xxx)**
- ALR-001: crear_alerta
- ALR-002: modificar_alerta
- ALR-003: eliminar_alerta
- ALR-004: consultar_alertas

**Ubicación Catálogo:** `/mnt/user-data/outputs/CATALOGO_RBAC_IACT_v5_1_1.md`

---

## PARTE 8: UBICACIÓN DE ARCHIVOS

### 8.1 Estructura de Directorios

```
/mnt/user-data/outputs/
├── casos_uso/
│   ├── auth/           # UC_001 - UC_005
│   ├── users/          # UC_006 - UC_009
│   ├── access/         # UC_010-011, UC_041-047
│   ├── reports/        # UC_017 - UC_030
│   ├── alerts/         # UC_036 - UC_040
│   ├── pipeline/       # UC_050 - UC_053
│   ├── audit/          # UC_060 - UC_063
│   └── logs/           # UC_070 - UC_073
├── funcionales/
│   ├── auth/           # FR-001.xx - FR-005.xx (21 FR)
│   └── users/          # FR-006.xx - FR-009.xx (17 FR)
├── reglas_negocio/     # BR_001 - BR_015
├── ARQ_MOD_*.rst       # Módulos arquitectónicos
├── BR_*.rst            # Reglas de negocio
├── CNST_*.rst          # Restricciones
├── FND_*.rst           # Fundamentos
├── GOB_*.rst           # Gobernanza
└── META_*.rst          # Metadocumentos

/tmp/funcionales/       # FR en progreso (temporal)
├── users/              # FR-006.xx - FR-009.xx (17 FR)
└── access/             # FR-010.xx - FR-043.xx (17 FR)
    ├── UC_010_Asignar_Funciones/
    ├── UC_011_Revocar_Funciones/
    ├── UC_041_Asignar_Segmento/
    ├── UC_042_Revocar_Segmento/
    └── UC_043_Configurar_SoD/
```

### 8.2 Nomenclatura de Archivos

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| Caso de Uso | `UC_NNN_Nombre.rst` | UC_001_Iniciar_Sesion.rst |
| Requisito Funcional | `FR-NNN.NN_Nombre.rst` | FR-001.01_Validar_formato_username.rst |
| Regla de Negocio | `BR_NNN_Nombre.rst` | BR_001_Inmutabilidad_Fuente.rst |
| Restricción | `CNST_NNN_Nombre.rst` | CNST_001_Comunicaciones_Prohibidas.rst |
| Fundamento | `FND_NN_Nombre.rst` | FND_01_Concepto_Requisito.rst |
| Gobernanza | `GOB_NN_Nombre.rst` | GOB_01_Modelo_Gobernanza.rst |
| Módulo Arq. | `ARQ_MOD_NNN_Nombre.rst` | ARQ_MOD_001_AUTH.rst |

---

## PARTE 9: TRAZABILIDAD

### 9.1 Matriz de Trazabilidad BReq → UC

| BReq | UC Relacionados |
|------|-----------------|
| BReq-001 | UC_017-030 (Reports) |
| BReq-002 | UC_022-024, UC_030 (Exportación) |
| BReq-003 | UC_010-011, UC_041-047 (Access) |
| BReq-004 | UC_001-009, UC_060-063 (Auth, Users, Audit) |

### 9.2 Matriz de Trazabilidad UC → FR

| UC | FR Derivados |
|----|--------------|
| UC_001 | FR-001.01 a FR-001.05 |
| UC_002 | FR-002.01 a FR-002.03 |
| UC_003 | FR-003.01 a FR-003.05 |
| UC_004 | FR-004.01 a FR-004.04 |
| UC_005 | FR-005.01 a FR-005.04 |
| UC_006 | FR-006.01 a FR-006.05 |
| UC_007 | FR-007.01 a FR-007.04 |
| UC_008 | FR-008.01 a FR-008.04 |
| UC_009 | FR-009.01 a FR-009.04 |
| UC_010 | FR-010.01 a FR-010.04 |
| UC_011 | FR-011.01 a FR-011.03 |
| UC_041 | FR-041.01 a FR-041.03 |
| UC_042 | FR-042.01 a FR-042.02 |
| UC_043 | FR-043.01 a FR-043.05 |

### 9.3 Matriz BR → FR

| BR | FR que Implementan |
|----|-------------------|
| BR_004 | FR-003.04, FR-006.03 |
| BR_005 | FR-001.04 |
| BR_006 | FR-010.01, FR-010.03, FR-010.04 |
| BR_007 | FR-010.02, FR-043.01-05 |
| BR_008 | FR-001.05, FR-006.05, FR-007.04 |
| BR_009 | FR-008.02, FR-008.04 |
| BR_012 | FR-041.01-03, FR-042.01-02 |
| BR_013 | FR-006.02 |
| BR_014 | FR-004.02 |
| BR_015 | FR-001.02 |

---

## PARTE 10: PROGRESO Y PRÓXIMOS PASOS

### 10.1 Estado Actual

```
GENERACIÓN DE FR: ████████░░░░░░░░░░░░░░░░░░ 35% (55/158)

FASE 1 MOD_Auth:    ████████████████████ 100% (21/21) ✅
FASE 2 MOD_Users:   ████████████████████ 100% (17/17) ✅
FASE 3A MOD_Access: ████████████████████ 100% (7/7)   ✅
FASE 3B MOD_Access: ████████████████████ 100% (10/10) ✅
FASE 3C MOD_Access: ░░░░░░░░░░░░░░░░░░░░   0% (0/13)  🔄
FASE 4 MOD_Reports: ░░░░░░░░░░░░░░░░░░░░   0% (0/42)  ⏳
FASE 5 MOD_Alerts:  ░░░░░░░░░░░░░░░░░░░░   0% (0/16)  ⏳
FASE 6 MOD_Pipeline:░░░░░░░░░░░░░░░░░░░░   0% (0/14)  ⏳
FASE 7 MOD_Audit:   ░░░░░░░░░░░░░░░░░░░░   0% (0/10)  ⏳
FASE 8 MOD_Logs:    ░░░░░░░░░░░░░░░░░░░░   0% (0/8)   ⏳
```

### 10.2 Próximos Pasos

1. **INMEDIATO:** Completar FASE 3C (MOD_Access - UC_044-047)
2. **CORTO PLAZO:** Generar FASE 4 (MOD_Reports - 14 UC, 42 FR)
3. **MEDIANO PLAZO:** Completar FASES 5-8 (restantes 48 FR)
4. **POSTERIOR:** Iniciar generación de NFR y TEST

### 10.3 Estimación de Esfuerzo Restante

| Fase | FR Pendientes | Estimación |
|------|---------------|------------|
| FASE 3C | 13 | 1 sesión |
| FASE 4 | 42 | 2-3 sesiones |
| FASE 5-8 | 48 | 2-3 sesiones |
| **TOTAL** | **103** | **5-7 sesiones** |

---

## PARTE 11: HISTORIAL DE VERSIONES

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 2.0.0 | 2026-01-03 | Versión inicial del modelo |
| 2.0.1 | 2026-01-04 | Añadidos FND y GOB |
| 2.0.2 | 2026-01-05 | Completados BR y CNST |
| 2.0.3 | 2026-01-05 | Estructura modular definida |
| 2.0.4 | 2026-01-05 | Análisis FND vs Modelo |
| 2.0.5 | 2026-01-06 | Generación UC iniciada |
| 2.0.6 | 2026-01-06 | 49 UC completados |
| 2.0.7 | 2026-01-06 | Plan de FR establecido |
| 2.0.8 | 2026-01-07 | FASE 1 (MOD_Auth) completada - 21 FR |
| **2.0.9** | **2026-01-07** | **FASES 1-3B completadas - 55 FR** |

---

## ANEXO A: FORMATO ESTÁNDAR DE FR

Cada FR sigue esta estructura de 6 secciones:

```rst
1. Identificación
   - ID, Nombre, UC Origen, Paso UC, Módulo, Prioridad, Tipo

2. Especificación
   - Declaración DEBE/CUANDO
   - Descripción detallada con algoritmos/parámetros

3. Criterio de Aceptación
   - Escenarios DADO/CUANDO/ENTONCES (3-4 por FR)

4. Reglas y Restricciones
   - BR aplicables
   - CNST aplicables
   - Notas de seguridad/configuración

5. Trazabilidad
   - BReq, UC, Dependencias, CNST, TEST

6. Historial
   - Versión, Fecha, Cambios
```

---

## ANEXO B: GLOSARIO

| Término | Definición |
|---------|------------|
| BReq | Business Requirement - Requisito de negocio |
| UC | Use Case - Caso de uso |
| FR | Functional Requirement - Requisito funcional |
| NFR | Non-Functional Requirement - Requisito no funcional |
| BR | Business Rule - Regla de negocio |
| CNST | Constraint - Restricción |
| SoD | Separation of Duties - Separación de funciones |
| RBAC | Role-Based Access Control |
| AGR | Agrupador de funciones |
| ETL | Extract, Transform, Load |

---

**FIN DEL DOCUMENTO**

*MODELO DOCUMENTAL IACT v2.0.9 - Generado: 2026-01-07*
