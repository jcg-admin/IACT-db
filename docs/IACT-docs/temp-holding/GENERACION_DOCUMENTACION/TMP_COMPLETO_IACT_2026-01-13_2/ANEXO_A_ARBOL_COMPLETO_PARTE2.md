```
│ ═══════════════════════════════════════════════════════════════════════════════
│ DOMINIO 3: ARQUITECTURA TÉCNICA
│ ═══════════════════════════════════════════════════════════════════════════════
│
├── arquitectura_tecnica/
│   ├── index.rst
│   │
│   ├── modulos/                                      # [CONGELADO] 8 MOD
│   │   ├── index.rst
│   │   ├── MOD_Auth.rst
│   │   ├── MOD_Users.rst
│   │   ├── MOD_Access.rst
│   │   ├── MOD_Pipeline.rst
│   │   ├── MOD_Reports.rst
│   │   ├── MOD_Alerts.rst
│   │   ├── MOD_Audit.rst
│   │   └── MOD_Logs.rst
│   │
│   ├── restricciones/                                # [CONGELADO] 10 CNST
│   │   ├── index.rst
│   │   ├── CNST_001_Comunicaciones_Prohibidas.rst
│   │   ├── CNST_002_Gestion_Sesiones_BD.rst
│   │   ├── CNST_003_BD_Dual_Inmutable.rst
│   │   ├── CNST_004_Actualizacion_ETL.rst
│   │   ├── CNST_005_Seguridad_DRF.rst
│   │   ├── CNST_006_Retencion_Datos.rst
│   │   ├── CNST_007_Limites_Exportacion.rst
│   │   ├── CNST_008_Infraestructura.rst
│   │   ├── CNST_009_Auditoria_Inmutable.rst
│   │   └── CNST_010_Clasificacion_Datos.rst
│   │
│   ├── decisiones/                                   # [DESCONGELADO] 5 ADR
│   │   ├── index.rst
│   │   ├── ADR_001_Stack_Python_Django.rst
│   │   ├── ADR_002_JWT_Autenticacion.rst
│   │   ├── ADR_003_RBAC_Flat.rst
│   │   ├── ADR_004_BD_Dual.rst
│   │   └── ADR_005_Sphinx_Documentacion.rst
│   │
│   ├── vistas/                                       # [DESCONGELADO] 5 VIEW
│   │   ├── index.rst
│   │   ├── VIEW_Logica_001_Componentes.rst
│   │   ├── VIEW_Proceso_001_Flujos.rst
│   │   ├── VIEW_Fisica_001_Deployment.rst
│   │   ├── VIEW_Desarrollo_001_Paquetes.rst
│   │   └── VIEW_Escenarios_001_UC.rst
│   │
│   ├── flujos_datos/                                 # [DESCONGELADO] 12 FD
│   │   ├── index.rst
│   │   ├── FD_001_User.rst
│   │   ├── FD_002_Role.rst
│   │   ├── FD_003_Permission.rst
│   │   ├── FD_004_Session.rst
│   │   ├── FD_005_AuditLog.rst
│   │   ├── FD_006_Alert.rst
│   │   ├── FD_007_Report.rst
│   │   ├── FD_008_Dashboard.rst
│   │   ├── FD_009_ETLJob.rst
│   │   ├── FD_010_Segment.rst
│   │   ├── FD_011_Function.rst
│   │   └── FD_012_Grouper.rst
│   │
│   ├── apis/                                         # [DESCONGELADO] 8 API
│   │   ├── index.rst
│   │   ├── API_Auth.rst
│   │   ├── API_Users.rst
│   │   ├── API_Roles.rst
│   │   ├── API_Permissions.rst
│   │   ├── API_Reports.rst
│   │   ├── API_Alerts.rst
│   │   ├── API_Audit.rst
│   │   └── API_Pipeline.rst
│   │
│   └── modelos_datos/                                # [DESCONGELADO] 3 MDL
│       ├── index.rst
│       ├── MDL_001_Core.rst
│       ├── MDL_002_RBAC.rst
│       └── MDL_003_Analytics.rst
│
│
│ ═══════════════════════════════════════════════════════════════════════════════
│ DOMINIO 4: NORMATIVA  🆕 EXPANDIDO v2.2.0
│ ═══════════════════════════════════════════════════════════════════════════════
│
├── normativa/
│   ├── index.rst
│   │
│   ├── estandares/                                   # [DESCONGELADO] 6 STD
│   │   ├── index.rst
│   │   ├── STD_001_Suite_Calidad_Codigo.rst
│   │   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   │   ├── STD_003_Clean_Code_Naming.rst
│   │   ├── STD_004_Nomenclatura_Proyecto.rst
│   │   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   │   ├── STD_006_Versionado_Semantico.rst
│   │   │
│   │   └── plantillas/                               # 🆕 [NUEVO] 17 TPL
│   │       ├── index.rst
│   │       │
│   │       │   # === TPL de Requisitos (5) ===
│   │       ├── TPL_BReq_Objetivos_Negocio_1_0_0.rst
│   │       ├── TPL_BR_Business_Rules_1_0_0.rst
│   │       ├── TPL_UC_Casos_de_Uso_2_0_0.rst
│   │       ├── TPL_FR_Requisitos_Funcionales_1_0_0.rst
│   │       ├── TPL_NFR_No_Funcionales_1_0_0.rst
│   │       │
│   │       │   # === TPL de Arquitectura (6) ===
│   │       ├── TPL_CNST_Restricciones_1_0_0.rst
│   │       ├── TPL_MOD_Modulos_1_0_0.rst
│   │       ├── TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
│   │       ├── TPL_FD_Fichas_Dominio_1_0_0.rst
│   │       ├── TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
│   │       ├── TPL_API_Documentacion_API_1_1_0.rst
│   │       │
│   │       │   # === TPL de Normativa (3) ===
│   │       ├── TPL_STD_Estandares_1_0_0.rst
│   │       ├── TPL_PROC_Procedimientos_1_0_0.rst
│   │       ├── TPL_POL_Politicas_1_0_0.rst
│   │       │
│   │       │   # === TPL de Evidencia (2) ===
│   │       ├── TPL_TST_Pruebas_1_0_0.rst
│   │       ├── TPL_RTM_Trazabilidad_1_0_0.rst
│   │       │
│   │       │   # === TPL Utilitario (1) ===
│   │       └── TPL_INDEX_Indices_1_0_0.rst
│   │
│   ├── procedimientos/                               # 🆕 [NUEVO] 38 PROC
│   │   ├── index.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 1: PREPARACIÓN Y APOYO (4 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
│   │   ├── PROC_Revision_TPL_Previo_Generacion_1_0_0.rst
│   │   ├── PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst
│   │   ├── PROC_Crear_Plan_Analisis_1_0_0.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 2: GENERACIÓN DE ARTEFACTOS (16 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Generacion_BReq_1_0_0.rst
│   │   ├── PROC_Generacion_BR_1_0_0.rst
│   │   ├── PROC_Generacion_UC_1_0_0.rst
│   │   ├── PROC_Generacion_FR_1_0_0.rst
│   │   ├── PROC_Generacion_NFR_1_0_0.rst
│   │   ├── PROC_Generacion_TST_1_0_0.rst
│   │   ├── PROC_Generacion_CNST_1_0_0.rst
│   │   ├── PROC_Generacion_MOD_1_0_0.rst
│   │   ├── PROC_Generacion_ADR_1_0_0.rst
│   │   ├── PROC_Generacion_STD_1_0_0.rst
│   │   ├── PROC_Generacion_POL_1_0_0.rst
│   │   ├── PROC_Generacion_FD_1_0_0.rst
│   │   ├── PROC_Generacion_VIEW_1_0_0.rst
│   │   ├── PROC_Generacion_API_1_0_0.rst
│   │   ├── PROC_Generacion_RTM_1_0_0.rst
│   │   ├── PROC_Generacion_Index_1_0_0.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 3: DERIVACIÓN (5 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Derivacion_BReq_BR_1_0_0.rst
│   │   ├── PROC_Derivacion_BR_UC_1_0_0.rst
│   │   ├── PROC_Derivacion_UC_FR_1_0_0.rst
│   │   ├── PROC_Derivacion_FR_TST_1_1_0.rst
│   │   ├── PROC_Derivacion_FR_CODE_1_0_0.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 4: GOBERNANZA DOCUMENTAL (7 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Versionado_Semantico_1_0_0.rst
│   │   ├── PROC_Congelamiento_Subdominio_1_0_0.rst
│   │   ├── PROC_Descongelamiento_Subdominio_1_0_0.rst
│   │   ├── PROC_Actualizacion_Modelo_Documental_1_0_0.rst
│   │   ├── PROC_Cambio_Requisitos_1_0_0.rst
│   │   ├── PROC_Revision_Artefactos_1_0_0.rst
│   │   ├── PROC_Aprobacion_Documentos_1_0_0.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 5: TRANSFERENCIA Y PUBLICACIÓN (3 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Copiar_Tmp_Outputs_1_0_0.rst
│   │   ├── PROC_Validacion_Sphinx_1_0_0.rst
│   │   ├── PROC_Publicacion_Documentacion_1_0_0.rst
│   │   │
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │   # CATEGORÍA 6: TRAZABILIDAD Y VERIFICACIÓN (3 PROC)
│   │   │   # ═══════════════════════════════════════════════════════════════
│   │   │
│   │   ├── PROC_Verificacion_Cobertura_1_0_0.rst
│   │   ├── PROC_Auditoria_Documental_1_0_0.rst
│   │   └── PROC_Identificar_Gaps_Huerfanos_1_0_0.rst
│   │
│   └── politicas/                                    # [CONGELADO] 2 POL
│       ├── index.rst
│       ├── POL_001_Seguridad_Informacion.rst
│       └── POL_002_Control_Acceso.rst
│
│
│ ═══════════════════════════════════════════════════════════════════════════════
│ DOMINIO 5: EVIDENCIA
│ ═══════════════════════════════════════════════════════════════════════════════
│
└── evidencia/
    ├── index.rst
    │
    ├── pruebas/                                      # [DESCONGELADO] TST (pendiente)
    │   ├── index.rst
    │   │
    │   ├── auth/                                     # TST para MOD_Auth
    │   │   └── (pendiente generación)
    │   │
    │   ├── users/                                    # TST para MOD_Users
    │   │   └── (pendiente generación)
    │   │
    │   ├── access/                                   # TST para MOD_Access
    │   │   └── (pendiente generación)
    │   │
    │   ├── pipeline/                                 # TST para MOD_Pipeline
    │   │   └── (pendiente generación)
    │   │
    │   ├── reports/                                  # TST para MOD_Reports
    │   │   └── (pendiente generación)
    │   │
    │   ├── alerts/                                   # TST para MOD_Alerts
    │   │   └── (pendiente generación)
    │   │
    │   ├── audit/                                    # TST para MOD_Audit
    │   │   └── (pendiente generación)
    │   │
    │   └── logs/                                     # TST para MOD_Logs
    │       └── (pendiente generación)
    │
    └── trazabilidad/                                 # [CONGELADO] RTM, COV
        ├── index.rst
        ├── RTM_Master_v1_0_0.rst
        ├── RTM_BReq_BR.rst
        ├── RTM_BR_UC.rst
        ├── RTM_UC_FR.rst
        ├── RTM_FR_TST.rst
        └── COV_001_Reporte_Cobertura.rst
```

---

## A.3 RESUMEN DE CONTEO

### A.3.1 Por Dominio

| Dominio | Subdominios | Artefactos |
|---------|-------------|------------|
| base_cognitiva | 6 | ~27 |
| requisitos | 5 | ~142 |
| arquitectura_tecnica | 7 | ~51 |
| normativa | 3 | **~63** (6 STD + 17 TPL + 38 PROC + 2 POL) |
| evidencia | 2 | ~10 |
| **TOTAL** | **23** | **~293** |

### A.3.2 Detalle de Normativa (v2.2.0)

| Tipo | Cantidad | Líneas Totales |
|------|----------|----------------|
| STD | 6 | ~1,150 |
| TPL | 17 | ~8,918 |
| PROC | 38 | ~11,873 |
| POL | 2 | ~400 |
| **Total** | **63** | **~22,341** |

### A.3.3 Templates por Categoría

| Categoría | Cantidad | TPL |
|-----------|----------|-----|
| Requisitos | 5 | BReq, BR, UC, FR, NFR |
| Arquitectura | 6 | CNST, MOD, ADR, FD, VIEW, API |
| Normativa | 3 | STD, PROC, POL |
| Evidencia | 2 | TST, RTM |
| Utilitario | 1 | INDEX |
| **Total** | **17** | |

### A.3.4 Procedimientos por Categoría

| Categoría | Cantidad | Descripción |
|-----------|----------|-------------|
| Preparación | 4 | Revisión previa, estructura |
| Generación | 16 | Crear artefactos |
| Derivación | 5 | BReq→BR→UC→FR→TST/CODE |
| Gobernanza | 7 | Versionado, congelamiento |
| Transferencia | 3 | Copiar, validar, publicar |
| Trazabilidad | 3 | Cobertura, auditoría, gaps |
| **Total** | **38** | |

---

## A.4 NOMENCLATURA APLICADA

### A.4.1 Templates (TPL)

```
TPL_[Tipo]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

Ejemplos:
- TPL_BR_Business_Rules_1_0_0.rst
- TPL_UC_Casos_de_Uso_2_0_0.rst
- TPL_API_Documentacion_API_1_1_0.rst
```

### A.4.2 Procedimientos (PROC)

```
PROC_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

Ejemplos:
- PROC_Generacion_FR_1_0_0.rst
- PROC_Derivacion_UC_FR_1_0_0.rst
- PROC_Derivacion_FR_TST_1_1_0.rst
```

---

*ANEXO_A v2.2.0 - Árbol Completo del Modelo Documental IACT*  
*Fecha: 2026-01-07*
