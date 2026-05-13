│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 3: ARQUITECTURA TÉCNICA
│ Propósito: Diseño, restricciones, módulos, flujos
│ ═══════════════════════════════════════════════════════════════════
│
├── arquitectura_tecnica/
│   │
│   ├── index.rst
│   │
│   ├── modulos/                                 # [DESCONGELADO] 8 MOD_
│   │   ├── index.rst
│   │   ├── MOD_Auth.rst
│   │   ├── MOD_Users.rst
│   │   ├── MOD_Access.rst                       # Incluye SEC_RULES
│   │   ├── MOD_Pipeline.rst
│   │   ├── MOD_Reports.rst
│   │   ├── MOD_Alerts.rst
│   │   ├── MOD_Audit.rst
│   │   └── MOD_Logs.rst
│   │
│   ├── restricciones/                           # [CONGELADO] 10 CNST
│   │   ├── index.rst
│   │   ├── CNST_001_Comunicaciones_Prohibidas.rst
│   │   ├── CNST_002_Gestion_Sesiones_BD.rst
│   │   ├── CNST_003_Base_Datos_Dual_Inmutable.rst
│   │   ├── CNST_004_Actualizacion_Datos_ETL.rst
│   │   ├── CNST_005_Seguridad_DRF_Checklist.rst
│   │   ├── CNST_006_Antipatrones_Arquitectura.rst
│   │   ├── CNST_007_Limites_Performance_SLA.rst
│   │   ├── CNST_008_Infraestructura_Deployment.rst
│   │   ├── CNST_009_Logging_Auditoria_Inmutable.rst
│   │   └── CNST_010_Clasificacion_Proteccion_Datos.rst
│   │
│   ├── decisiones/                              # [DESCONGELADO] ADR
│   │   ├── index.rst
│   │   ├── ADR_001_Stack_Django_DRF.rst
│   │   ├── ADR_002_BD_Dual_MySQL_PG.rst
│   │   ├── ADR_003_RBAC_Flat_vs_Hierarchical.rst
│   │   ├── ADR_004_8_Modulos_SEC_RULES_Integrado.rst
│   │   └── ADR_005_UML_PlantUML.rst
│   │
│   ├── vistas/                                  # [DESCONGELADO] Diagramas UML
│   │   ├── index.rst
│   │   ├── VIEW_001_Componentes.rst
│   │   ├── VIEW_002_Deployment.rst
│   │   ├── VIEW_003_Secuencia_ETL.rst
│   │   ├── VIEW_004_Dependencias_Modulos.rst
│   │   └── VIEW_005_Modelo_RBAC.rst
│   │
│   ├── flujos_datos/                            # [DESCONGELADO] 12 FD_
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
│   │   ├── FD_11_Enforcement_SEC_RULES.rst
│   │   └── FD_12_Mensajeria_Interna.rst
│   │
│   ├── apis/                                    # [DESCONGELADO] Por módulo
│   │   ├── index.rst
│   │   ├── API_Auth.rst
│   │   ├── API_Users.rst
│   │   ├── API_Access.rst
│   │   ├── API_Pipeline.rst
│   │   ├── API_Reports.rst
│   │   ├── API_Alerts.rst
│   │   ├── API_Audit.rst
│   │   └── API_Logs.rst
│   │
│   └── modelos_datos/                           # [DESCONGELADO] Esquemas BD
│       ├── index.rst
│       ├── MDL_001_Conceptual.rst
│       ├── MDL_002_Logico.rst
│       └── MDL_003_Fisico.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 4: NORMATIVA
│ Propósito: Estándares, procedimientos, políticas
│ ═══════════════════════════════════════════════════════════════════
│
├── normativa/
│   │
│   ├── index.rst
│   │
│   ├── estandares/                              # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── STD_001_Suite_Calidad_Codigo.rst
│   │   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   │   ├── STD_003_Clean_Code_Naming.rst
│   │   ├── STD_004_Nomenclatura_Proyecto.rst
│   │   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   │   └── plantillas/
│   │       ├── TPL_001_Plantilla_BR.rst
│   │       ├── TPL_002_Plantilla_UC.rst
│   │       ├── TPL_003_Plantilla_FR.rst
│   │       ├── TPL_004_Plantilla_ADR.rst
│   │       ├── TPL_005_Plantilla_CNST.rst
│   │       └── TPL_006_Plantilla_MOD.rst
│   │
│   ├── procedimientos/                          # [CONGELADO]
│   │   ├── index.rst
│   │   ├── PROC_001_Cambio_Requisitos.rst
│   │   ├── PROC_002_Revision_Artefactos.rst
│   │   ├── PROC_003_Aprobacion_Documentos.rst
│   │   └── PROC_004_Deployment.rst
│   │
│   └── politicas/                               # [CONGELADO]
│       ├── index.rst
│       ├── POL_001_Seguridad_Informacion.rst
│       └── POL_002_Control_Acceso.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 5: EVIDENCIA
│ Propósito: Verificación, pruebas, trazabilidad
│ ═══════════════════════════════════════════════════════════════════
│
└── evidencia/
    │
    ├── index.rst
    │
    ├── pruebas/                                 # [DESCONGELADO] Por módulo
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
    └── trazabilidad/                            # [CONGELADO]
        ├── index.rst
        ├── RTM_Master_v1_0_0.rst
        └── COV_001_Reporte_Cobertura.rst
```

---

## 3. BUSINESS REQUIREMENTS - Nivel 1 (NUEVO v2.0.6)

### 3.1 Definición (según FND_05)

Los **Business Requirements (BReq)** expresan los objetivos de alto nivel que justifican la existencia del proyecto. Responden: "¿Por qué estamos construyendo este sistema?"

**Características:**
- **Estratégicos:** Visión de negocio, no técnica
- **Justificativos:** Explican el ROI del proyecto
- **Influenciados:** Por BR, pero no son reiteración de ellas
- **Alcance:** Definen límites del proyecto

### 3.2 BReq Identificados para IACT

| ID | Nombre | Descripción | Métrica de Éxito |
|----|--------|-------------|------------------|
| BReq-001 | Visibilidad Métricas IVR | Proporcionar visibilidad en tiempo real de las métricas de llamadas del IVR | Dashboard actualizado cada 5 min |
| BReq-002 | Reducción Tiempo Incidentes | Reducir el tiempo de resolución de incidentes operacionales | Reducción ≥ 40% vs línea base |
| BReq-003 | Decisiones Informadas | Permitir a supervisores identificar problemas y tomar decisiones basadas en datos | 100% decisiones con respaldo de datos |
| BReq-004 | Cumplimiento Seguridad | Garantizar control de acceso RBAC y auditoría completa | 0 accesos no autorizados |
| BReq-005 | Integridad Datos Operacionales | Proteger la base de datos operacional de escrituras no autorizadas | 0 escrituras desde IACT |

### 3.3 Trazabilidad BReq → UC

```
BReq-001 (Visibilidad)
    ├── UC-025 Dashboard Principal
    ├── UC-026 Tendencias Temporales
    ├── UC-027 Gráficos por Hora
    ├── UC-028 Gráficos por Día
    └── UC-029 Distribución por Centro

BReq-002 (Reducción Incidentes)
    ├── UC-036 Crear Alerta
    ├── UC-037 Recibir Notificación
    ├── UC-038 Pausar Alerta
    ├── UC-039 Historial Alertas
    └── UC-040 Gestionar Destinatarios

BReq-003 (Decisiones Informadas)
    ├── UC-017 Reporte Trimestral
    ├── UC-018 Reporte Problemas Menú
    ├── UC-019 Reporte Transferencias
    ├── UC-020 a UC-024 (Filtros y Exportaciones)
    └── UC-030 Personalizar Dashboard

BReq-004 (Cumplimiento Seguridad)
    ├── UC-010 Asignar Roles
    ├── UC-011 Gestionar Permisos
    ├── UC-043 Configurar SoD
    ├── UC-060 a UC-063 (Auditoría)
    └── UC-047 Auditar Cambios Permisos

BReq-005 (Integridad Datos)
    ├── UC-050 Supervisar ETL
    ├── UC-051 Consultar Errores ETL
    └── UC-052 Consultar Disponibilidad
```

### 3.4 Relación BR → BReq (Influencia)

Las Business Rules **influyen** en los Business Requirements:

| BR | Influye en BReq | Tipo de Influencia |
|----|-----------------|-------------------|
| BR_001 (Fuente Inmutable) | BReq-005 | Define restricción de solo lectura |
| BR_002 (ETL Nocturno) | BReq-001 | Define ventana de actualización |
| BR_006 (RBAC Flat) | BReq-004 | Define modelo de seguridad |
| BR_007 (SoD) | BReq-004 | Define segregación de funciones |
| BR_010 (Auditoría Inmutable) | BReq-004 | Define requisitos de auditoría |
| BR_014 (Alerta Umbral) | BReq-002 | Define mecanismo de alertas |

### 3.5 Ubicación y Nomenclatura

```
requisitos/
└── objetivos/
    ├── index.rst
    └── BReq_001_Objetivos_IACT.rst    # Documento consolidado
```

**Formato archivo:** `BReq_NNN_Nombre_Descriptivo.rst`
