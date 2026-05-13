# MODELO DOCUMENTAL IACT v2.0.3
## Proyecto IACT Dashboard Analytics

**Versión:** 2.0.3  
**Fecha:** 2026-01-03  
**Cambios desde v2.0.0:**
- Añadido subdominio `modulos/` con 8 módulos funcionales (MOD_)
- Nomenclatura Clean Code aplicada (sin ARQ_MOD_001, ahora MOD_Auth)
- SEC_RULES integrado en MOD_Access (no es módulo separado)
- Casos de Uso reorganizados por módulo

---

## 1. CAMBIOS EN v2.0.3

### 1.1 Nuevo Subdominio: modulos/

Se añade el subdominio `arquitectura_tecnica/modulos/` que contiene la documentación de los 8 módulos funcionales del sistema.

**Justificación:**
- Los módulos son artefactos de DISEÑO arquitectónico del SISTEMA
- Definen responsabilidades, límites y dependencias
- Son la base para la organización del código (Django apps)
- Conectan UC → FR → Implementación

### 1.2 Nomenclatura Clean Code

| Antes (v2.0.0) | Después (v2.0.3) | Razón |
|----------------|------------------|-------|
| ARQ_MOD_001_AUTH | MOD_Auth | Pronunciable, sin codificación |
| ARQ_MOD_002_USER_IDENTITY | MOD_Users | Simple, directo |
| ARQ_MOD_003_RBAC_CORE | MOD_Access | Describe función |
| N/A | MOD_Pipeline | Nuevo nombre para ETL |

### 1.3 SEC_RULES Integrado

SEC_RULES no es un módulo separado. Es una subcapa interna de MOD_Access:
- No tiene UI
- No tiene UC propios
- Es enforcement automático (middleware, decoradores)

---

## 2. ÁRBOL COMPLETO v2.0.3

```
IACT/
│
├── base_cognitiva/                          # DOMINIO 1: Conocimiento Fundamental
│   │
│   ├── index.rst
│   │
│   ├── glosario/                            # [CONGELADO]
│   │   ├── index.rst
│   │   └── GLO_001_Glosario_IACT.rst
│   │
│   ├── taxonomias_y_metamodelos/            # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── taxonomias/
│   │   │   └── TAX_001_Taxonomia_Roles.rst
│   │   └── metamodelos/
│   │       └── META_001_Metamodelo_RBAC.rst
│   │
│   └── _metadata/                           # [PRIVADO]
│       ├── index.rst
│       ├── 00_indice.rst
│       ├── 01_sbvr_fundamentos.rst
│       ├── 02_larman_metodologia.rst
│       ├── 03_derivacion_br_uc.rst
│       ├── 04_derivacion_uc_fr.rst
│       └── 05_trazabilidad_rtm.rst
│
├── requisitos/                              # DOMINIO 2: Requerimientos
│   │
│   ├── index.rst
│   │
│   ├── reglas_negocio/                      # [CONGELADO]
│   │   ├── index.rst
│   │   ├── BR_001_Inmutabilidad_Fuente.rst
│   │   ├── BR_002_ETL_Batch.rst
│   │   ├── BR_003_RBAC_Flat.rst
│   │   ├── BR_004_No_Email.rst
│   │   └── BR_005_Sesion_Unica.rst
│   │
│   ├── casos_uso/                           # [DESCONGELADO] - Por módulo
│   │   ├── index.rst
│   │   ├── auth/                            # UC del módulo Auth
│   │   │   ├── UC_001_Inicio_Sesion.rst
│   │   │   ├── UC_002_Cierre_Sesion.rst
│   │   │   ├── UC_003_Recuperar_Password.rst
│   │   │   ├── UC_004_Cambiar_Password.rst
│   │   │   └── UC_005_Gestionar_Sesiones.rst
│   │   ├── users/                           # UC del módulo Users
│   │   │   ├── UC_006_Crear_Usuario.rst
│   │   │   ├── UC_007_Modificar_Usuario.rst
│   │   │   ├── UC_008_Baja_Usuario.rst
│   │   │   └── UC_009_Listar_Usuarios.rst
│   │   ├── access/                          # UC del módulo Access
│   │   │   ├── UC_010_Asignar_Roles.rst
│   │   │   ├── UC_011_Gestionar_Permisos_Rol.rst
│   │   │   ├── UC_041_Asignar_Segmento.rst
│   │   │   ├── UC_042_Asignar_Permiso_Directo.rst
│   │   │   └── UC_043_Configurar_SoD.rst
│   │   ├── pipeline/                        # UC del módulo Pipeline
│   │   │   ├── UC_050_Supervisar_ETL.rst
│   │   │   ├── UC_051_Consultar_Errores_ETL.rst
│   │   │   └── UC_052_Consultar_Disponibilidad.rst
│   │   ├── reports/                         # UC del módulo Reports
│   │   │   ├── UC_017_Reporte_Trimestral.rst
│   │   │   ├── UC_018_Reporte_Problemas_Menu.rst
│   │   │   ├── UC_019_Reporte_Transferencias.rst
│   │   │   ├── UC_020_Filtro_Fecha.rst
│   │   │   ├── UC_021_Filtro_Centro.rst
│   │   │   ├── UC_022_Exportar_CSV.rst
│   │   │   ├── UC_023_Exportar_Excel.rst
│   │   │   ├── UC_024_Exportar_PDF.rst
│   │   │   ├── UC_025_Dashboard_Principal.rst
│   │   │   ├── UC_027_Graficos_Hora.rst
│   │   │   ├── UC_028_Graficos_Dia.rst
│   │   │   └── UC_029_Distribucion_Centro.rst
│   │   ├── alerts/                          # UC del módulo Alerts
│   │   │   ├── UC_036_Crear_Alerta.rst
│   │   │   ├── UC_037_Recibir_Notificacion.rst
│   │   │   ├── UC_038_Pausar_Alerta.rst
│   │   │   ├── UC_039_Historial_Alertas.rst
│   │   │   └── UC_040_Gestionar_Destinatarios.rst
│   │   ├── audit/                           # UC del módulo Audit
│   │   │   ├── UC_060_Registrar_Evento.rst
│   │   │   ├── UC_061_Consultar_Auditoria.rst
│   │   │   └── UC_062_Exportar_Auditoria.rst
│   │   └── logs/                            # UC del módulo Logs
│   │       ├── UC_070_Consultar_Logs.rst
│   │       └── UC_071_Filtrar_Logs.rst
│   │
│   └── requisitos_funcionales/              # [DESCONGELADO] - Por módulo
│       ├── index.rst
│       ├── auth/
│       ├── users/
│       ├── access/
│       ├── pipeline/
│       ├── reports/
│       ├── alerts/
│       ├── audit/
│       └── logs/
│
├── arquitectura_tecnica/                    # DOMINIO 3: Arquitectura
│   │
│   ├── index.rst
│   │
│   ├── modulos/                             # [NUEVO v2.0.3] ★★★
│   │   ├── index.rst
│   │   ├── MOD_Auth.rst                     # Autenticación y Sesiones
│   │   ├── MOD_Users.rst                    # Gestión de Identidades
│   │   ├── MOD_Access.rst                   # Roles, Permisos + SEC_RULES
│   │   ├── MOD_Pipeline.rst                 # Supervisión ETL
│   │   ├── MOD_Reports.rst                  # Dashboards y Reportes
│   │   ├── MOD_Alerts.rst                   # Alertas y Notificaciones
│   │   ├── MOD_Audit.rst                    # Auditoría Funcional
│   │   └── MOD_Logs.rst                     # Bitácoras Técnicas
│   │
│   ├── decisiones/                          # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── ADR_001_Stack_Django_React.rst
│   │   ├── ADR_002_BD_Dual_MySQL_PG.rst
│   │   ├── ADR_003_UML_No_C4.rst
│   │   └── ADR_004_8_Modulos_SEC_RULES_Integrado.rst  # [NUEVO]
│   │
│   ├── vistas/                              # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── ARQ_VIS_001_Componentes.rst
│   │   ├── ARQ_VIS_002_Deployment.rst
│   │   ├── ARQ_VIS_003_Secuencia_ETL.rst
│   │   └── ARQ_VIS_004_Dependencias_Modulos.rst  # [NUEVO]
│   │
│   ├── diseno_detallado/                    # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── apis/
│   │   │   ├── API_Auth.rst
│   │   │   ├── API_Users.rst
│   │   │   ├── API_Access.rst
│   │   │   ├── API_Pipeline.rst
│   │   │   ├── API_Reports.rst
│   │   │   ├── API_Alerts.rst
│   │   │   ├── API_Audit.rst
│   │   │   └── API_Logs.rst
│   │   ├── modelos/
│   │   │   ├── DSC_MOD_User.rst
│   │   │   ├── DSC_MOD_Role.rst
│   │   │   ├── DSC_MOD_Permission.rst
│   │   │   ├── DSC_MOD_ETLExecution.rst
│   │   │   ├── DSC_MOD_Report.rst
│   │   │   ├── DSC_MOD_Alert.rst
│   │   │   ├── DSC_MOD_AuditLog.rst
│   │   │   └── DSC_MOD_SystemLog.rst
│   │   └── esquemas/
│   │       ├── ESQ_Request_Auth.rst
│   │       └── ESQ_Response_Dashboard.rst
│   │
│   ├── flujos_datos/                        # [NUEVO v2.0.3] ★★★
│   │   ├── index.rst
│   │   ├── FD_01_Autenticacion.rst
│   │   ├── FD_02_Resolucion_Permisos.rst
│   │   ├── FD_03_Gestion_Identidades.rst
│   │   ├── FD_04_Ejecucion_ETL.rst
│   │   ├── FD_05_Supervision_ETL.rst
│   │   ├── FD_06_Visualizacion.rst
│   │   ├── FD_07_Exportacion.rst
│   │   ├── FD_08_Alertas.rst
│   │   ├── FD_09_Auditoria.rst
│   │   ├── FD_10_Bitacoras.rst
│   │   ├── FD_11_Enforcement.rst
│   │   └── FD_12_Mensajeria.rst
│   │
│   └── restricciones/                       # [CONGELADO] ✅ COMPLETADO
│       ├── index.rst
│       ├── CNST_001_Comunicaciones_Prohibidas.rst
│       ├── CNST_002_Gestion_Sesiones_BD.rst
│       ├── CNST_003_Base_Datos_Dual_Inmutable.rst
│       ├── CNST_004_Actualizacion_Datos_ETL.rst
│       ├── CNST_005_Seguridad_DRF_Checklist.rst
│       ├── CNST_006_Antipatrones_Arquitectura.rst
│       ├── CNST_007_Limites_Performance_SLA.rst
│       ├── CNST_008_Infraestructura_Deployment.rst
│       ├── CNST_009_Logging_Auditoria_Inmutable.rst
│       └── CNST_010_Clasificacion_Proteccion_Datos.rst
│
├── normativa/                               # DOMINIO 4: Estándares y Políticas
│   │
│   ├── index.rst
│   │
│   ├── estandares/                          # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── STD_001_Suite_Calidad_Codigo.rst
│   │   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   │   ├── STD_003_Clean_Code_Naming.rst
│   │   ├── STD_004_Nomenclatura_Proyecto.rst
│   │   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   │   └── plantillas/
│   │       ├── TPL_001_Plantilla_BR.rst
│   │       ├── TPL_002_Plantilla_UC.rst
│   │       ├── TPL_003_Plantilla_ADR.rst
│   │       ├── TPL_004_Plantilla_CNST.rst
│   │       └── TPL_005_Plantilla_MOD.rst    # [NUEVO]
│   │
│   └── politicas/                           # [CONGELADO]
│       ├── index.rst
│       ├── POL_001_Seguridad_Informacion.rst
│       └── POL_002_Control_Acceso.rst
│
└── evidencia/                               # DOMINIO 5: Verificación
    │
    ├── index.rst
    │
    ├── pruebas/                             # [DESCONGELADO] - Por módulo
    │   ├── index.rst
    │   ├── auth/
    │   │   └── TST_Auth_Plan.rst
    │   ├── users/
    │   │   └── TST_Users_Plan.rst
    │   ├── access/
    │   │   └── TST_Access_Plan.rst
    │   ├── pipeline/
    │   │   └── TST_Pipeline_Plan.rst
    │   ├── reports/
    │   │   └── TST_Reports_Plan.rst
    │   ├── alerts/
    │   │   └── TST_Alerts_Plan.rst
    │   ├── audit/
    │   │   └── TST_Audit_Plan.rst
    │   └── logs/
    │       └── TST_Logs_Plan.rst
    │
    └── trazabilidad/                        # [CONGELADO]
        ├── index.rst
        └── RTM_Master_v1_0_0.rst
```

---

## 3. LOS 8 MÓDULOS FUNCIONALES

### 3.1 Tabla Resumen

| Código | Nombre | App Django | UC Range | Descripción |
|--------|--------|------------|----------|-------------|
| MOD_Auth | Auth | apps.auth | UC-001 a UC-005 | Autenticación y Sesiones |
| MOD_Users | Users | apps.users | UC-006 a UC-009 | Gestión de Identidades |
| MOD_Access | Access | apps.access | UC-010, UC-041-047 | Roles, Permisos + SEC_RULES |
| MOD_Pipeline | Pipeline | apps.pipeline | UC-050 a UC-053 | Supervisión del ETL |
| MOD_Reports | Reports | apps.reports | UC-017 a UC-029 | Dashboards y Reportes |
| MOD_Alerts | Alerts | apps.alerts | UC-036 a UC-040 | Alertas y Notificaciones |
| MOD_Audit | Audit | apps.audit | UC-060 a UC-063 | Auditoría Funcional |
| MOD_Logs | Logs | apps.logs | UC-070 a UC-072 | Bitácoras Técnicas |

### 3.2 Estructura de cada MOD_xxx.rst

```rst
=====================================
MOD_Auth - Autenticación y Sesiones
=====================================

1. Propósito
------------
[Descripción del propósito del módulo]

2. Responsabilidades (PUEDE hacer)
----------------------------------
- Item 1
- Item 2
- ...

3. Límites (NO PUEDE hacer)
---------------------------
- Item 1
- Item 2
- ...

4. Casos de Uso
---------------
.. list-table::
   :header-rows: 1
   
   * - UC
     - Nombre
     - Prioridad
   * - UC-001
     - Inicio de sesión
     - Must

5. Restricciones Aplicables
---------------------------
.. list-table::
   :header-rows: 1
   
   * - CNST
     - Descripción
   * - CNST_001
     - NO email

6. Dependencias
---------------
.. uml::
   
   @startuml
   [MOD_Auth] --> [MOD_Users] : consulta identidad
   [MOD_Auth] --> [MOD_Access] : consulta permisos
   [MOD_Auth] --> [MOD_Audit] : envía eventos
   @enduml

7. Componentes Internos
-----------------------
[Si aplica, como SEC_RULES en MOD_Access]
```

---

## 4. MAPEO MÓDULO → UC → CNST

### MOD_Auth
| UC | Nombre | CNST |
|----|--------|------|
| UC-001 | Inicio de sesión | CNST_002, CNST_005 |
| UC-002 | Cierre de sesión | CNST_002 |
| UC-003 | Recuperar contraseña | CNST_001, CNST_002 |
| UC-004 | Cambiar contraseña | CNST_002, CNST_005 |
| UC-005 | Gestionar sesiones | CNST_002 |

### MOD_Users
| UC | Nombre | CNST |
|----|--------|------|
| UC-006 | Crear usuario | CNST_001, CNST_005 |
| UC-007 | Modificar usuario | CNST_005 |
| UC-008 | Baja lógica usuario | CNST_005 |
| UC-009 | Listar usuarios | CNST_005 |

### MOD_Access
| UC | Nombre | CNST |
|----|--------|------|
| UC-010 | Asignar roles | CNST_005 |
| UC-011 | Gestionar permisos por rol | CNST_005 |
| UC-041 | Asignar segmento de datos | CNST_005 |
| UC-042 | Asignar permiso directo | CNST_005 |
| UC-043 | Configurar SoD | CNST_005 |

### MOD_Pipeline
| UC | Nombre | CNST |
|----|--------|------|
| UC-050 | Supervisar ejecuciones ETL | CNST_003, CNST_004 |
| UC-051 | Consultar errores ETL | CNST_003, CNST_004 |
| UC-052 | Consultar disponibilidad | CNST_003, CNST_004 |

### MOD_Reports
| UC | Nombre | CNST |
|----|--------|------|
| UC-017 | Reporte trimestral | CNST_003, CNST_006, CNST_007 |
| UC-022 | Exportar CSV | CNST_001, CNST_007 |
| UC-023 | Exportar Excel | CNST_001, CNST_007 |
| UC-024 | Exportar PDF | CNST_001, CNST_007 |
| UC-025 | Dashboard principal | CNST_003, CNST_004 |

### MOD_Alerts
| UC | Nombre | CNST |
|----|--------|------|
| UC-036 | Crear alerta | CNST_001 |
| UC-037 | Recibir notificación | CNST_001 |
| UC-038 | Pausar alerta | CNST_001 |
| UC-039 | Historial alertas | CNST_001 |
| UC-040 | Gestionar destinatarios | CNST_001 |

### MOD_Audit
| UC | Nombre | CNST |
|----|--------|------|
| UC-060 | Registrar evento | CNST_009 |
| UC-061 | Consultar auditoría | CNST_009, CNST_005 |
| UC-062 | Exportar auditoría | CNST_009, CNST_007 |

### MOD_Logs
| UC | Nombre | CNST |
|----|--------|------|
| UC-070 | Consultar logs | CNST_009 |
| UC-071 | Filtrar logs | CNST_009 |

---

## 5. DIAGRAMA DE DEPENDENCIAS

```
┌─────────────────────────────────────────────────────────────────┐
│                        SISTEMA IACT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────┐     ┌──────────┐     ┌──────────┐                │
│   │MOD_Auth  │────►│MOD_Users │────►│MOD_Access│                │
│   └────┬─────┘     └────┬─────┘     └────┬─────┘                │
│        │                │                │                       │
│        │                │      ┌─────────┴─────────┐             │
│        │                │      │   SEC_RULES       │             │
│        │                │      │   (integrado)     │             │
│        │                │      └───────────────────┘             │
│        │                │                │                       │
│        ▼                ▼                ▼                       │
│   ┌──────────────────────────────────────────────────────┐      │
│   │              MÓDULOS FUNCIONALES                      │      │
│   ├──────────┬───────────┬───────────┬───────────────────┤      │
│   │MOD_      │MOD_       │MOD_       │MOD_               │      │
│   │Pipeline  │Reports    │Alerts     │                   │      │
│   └────┬─────┴─────┬─────┴─────┬─────┘                   │      │
│        │           │           │                          │      │
│        ▼           ▼           ▼                          │      │
│   ┌──────────────────────────────────────────────────────┐      │
│   │              MÓDULOS TRANSVERSALES                    │      │
│   ├────────────────────────┬─────────────────────────────┤      │
│   │      MOD_Audit         │        MOD_Logs             │      │
│   │   (eventos negocio)    │    (eventos técnicos)       │      │
│   └────────────────────────┴─────────────────────────────┘      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. RESUMEN DE CAMBIOS v2.0.0 → v2.0.3

| Aspecto | v2.0.0 | v2.0.3 |
|---------|--------|--------|
| Módulos | No definidos | 8 módulos funcionales |
| Nomenclatura | ARQ_MOD_001 | MOD_Auth |
| SEC_RULES | Potencial módulo 9 | Integrado en MOD_Access |
| UC organización | Por tipo | Por módulo |
| Flujos datos | No formalizados | FD_01 a FD_12 |
| Subdominios nuevos | 0 | 2 (modulos/, flujos_datos/) |

### Nuevos Artefactos en v2.0.3

| Tipo | Cantidad | Ubicación |
|------|----------|-----------|
| MOD_ | 8 | arquitectura_tecnica/modulos/ |
| FD_ | 12 | arquitectura_tecnica/flujos_datos/ |
| ADR_004 | 1 | arquitectura_tecnica/decisiones/ |
| ARQ_VIS_004 | 1 | arquitectura_tecnica/vistas/ |
| TPL_005 | 1 | normativa/estandares/plantillas/ |

---

## 7. CONTEO ACTUALIZADO

### Por Tipo de Documento

| Prefijo | v2.0.0 | v2.0.3 | Delta |
|---------|--------|--------|-------|
| CNST | 10 | 10 | 0 |
| MOD | 0 | 8 | +8 |
| FD | 0 | 12 | +12 |
| ADR | 3 | 4 | +1 |
| ARQ_VIS | 3 | 4 | +1 |
| TPL | 4 | 5 | +1 |
| **TOTAL** | ~62 | ~85 | +23 |

### Estado de Completitud

| Dominio | Completados | Pendientes |
|---------|-------------|------------|
| base_cognitiva | 6 | 3 |
| requisitos | 0 | ~49 |
| arquitectura_tecnica | 10 | ~35 |
| normativa | 0 | 12 |
| evidencia | 0 | 9 |
| **TOTAL** | 16 | ~108 |

---

## 8. PRÓXIMOS PASOS

### Fase Inmediata: Módulos (MOD_)
```
1. MOD_Auth.rst
2. MOD_Users.rst
3. MOD_Access.rst (incluye SEC_RULES)
4. MOD_Pipeline.rst
5. MOD_Reports.rst
6. MOD_Alerts.rst
7. MOD_Audit.rst
8. MOD_Logs.rst
```

### Fase Siguiente: Flujos de Datos (FD_)
```
1. FD_04_Ejecucion_ETL.rst (ya tiene contenido base)
2. FD_01_Autenticacion.rst
3. FD_06_Visualizacion.rst
... etc
```

### Fase Posterior: UC por Módulo
```
Reorganizar UC existentes en subcarpetas por módulo
```

---

## 9. ARCHIVOS DE REFERENCIA (NO DOCUMENTACIÓN)

Los siguientes archivos son de TRABAJO, no forman parte de la documentación formal:

| Archivo | Propósito |
|---------|-----------|
| REFERENCIA_GLOBAL_MODULOS_IACT.md | Fuente para generar MOD_.rst |
| ANALISIS_PROFUNDO_DECISIONES.md | Justificación de 8 módulos |
| ANALISIS_NAMING_CLEAN_CODE.md | Justificación nomenclatura |

---

*Modelo Documental IACT v2.0.3*
*Proyecto: IACT Dashboard Analytics*
*Fecha: 2026-01-03*
