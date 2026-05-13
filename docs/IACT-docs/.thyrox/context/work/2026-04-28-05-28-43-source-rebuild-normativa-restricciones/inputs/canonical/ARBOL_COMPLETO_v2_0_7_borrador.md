## ÁRBOL COMPLETO v2.0.7

```
IACT/
│
├── conf.py
├── index.rst
├── Makefile
├── requirements.txt
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 1: BASE COGNITIVA
│ Propósito: Conocimiento fundamental, semántica, metodología
│ ═══════════════════════════════════════════════════════════════════
│
├── base_cognitiva/
│   │
│   ├── index.rst
│   │
│   ├── _metadata/                               # [PRIVADO] Identidad proyecto
│   │   ├── index.rst
│   │   ├── META_01_Identidad_Proyecto.rst
│   │   ├── META_02_Clasificacion_Documental.rst
│   │   ├── META_03_Fases_SDLC.rst
│   │   ├── META_04_Contexto_IACT.rst            # Contexto, NO es BReq
│   │   └── META_05_Estructura_Documental.rst
│   │
│   ├── glosario/                                # [CONGELADO]
│   │   ├── index.rst
│   │   └── GLOS_001_Glosario_IACT.rst
│   │
│   ├── _fundamentos_conceptuales/               # [PRIVADO] Marco teórico
│   │   ├── index.rst
│   │   ├── FND_01_Concepto_Requisito.rst
│   │   ├── FND_02_Reglas_de_Negocio.rst
│   │   ├── FND_03_Casos_de_Uso.rst
│   │   ├── FND_04_Trazabilidad.rst
│   │   ├── FND_05_Jerarquia_4_Niveles.rst
│   │   ├── FND_06_Derivacion_vs_Transformacion.rst
│   │   └── FND_07_Requerimientos_Funcionales.rst
│   │
│   ├── _ontologia_sbvr/                         # [PRIVADO] Semántica formal
│   │   ├── index.rst
│   │   ├── SBVR_01_Conceptos_Nucleares.rst
│   │   ├── SBVR_02_Fact_Types.rst
│   │   ├── SBVR_03_Reglas_Estructurales.rst
│   │   ├── SBVR_04_Reglas_Operativas.rst
│   │   └── SBVR_05_Vocabulario_Controlado.rst
│   │
│   ├── normativa/                               # [DESCONGELADO]
│   │   ├── index.rst
│   │   ├── estandares/
│   │   │   ├── index.rst
│   │   │   ├── STD_001_Formato_Documentos.rst
│   │   │   ├── STD_002_Nomenclatura_IDs.rst
│   │   │   ├── STD_003_Niveles_Estado.rst
│   │   │   ├── STD_004_Clasificacion_Informacion.rst
│   │   │   ├── STD_005_Documentacion_Codigo.rst
│   │   │   └── STD_006_Versionado_Documentos.rst
│   │   │
│   │   └── procedimientos/
│   │       ├── index.rst
│   │       ├── PROC_001_Gestion_Cambios.rst
│   │       ├── PROC_002_Revision_Documentos.rst
│   │       ├── PROC_003_Trazabilidad_Updates.rst
│   │       └── PROC_004_Aprobacion_Entregables.rst
│   │
│   └── plantillas/                              # [CONGELADO] Templates RST
│       ├── index.rst
│       ├── TPL_001_Plantilla_BReq.rst
│       ├── TPL_002_Plantilla_UC.rst
│       ├── TPL_003_Plantilla_Funcional.rst
│       ├── TPL_004_Plantilla_ADR.rst
│       └── TPL_005_Plantilla_CNST.rst           # PENDIENTE CREAR
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 2: ESPECIFICACIÓN DE REQUISITOS
│ Propósito: Qué debe hacer el sistema (negocio + funcional)
│ ═══════════════════════════════════════════════════════════════════
│
├── especificacion_requisitos/
│   │
│   ├── index.rst
│   │
│   ├── negocio/                                 # [DESCONGELADO] BReq
│   │   ├── index.rst
│   │   ├── BReq_01_Contexto_Justificacion.rst
│   │   ├── BReq_02_Objetivos_Alcance.rst
│   │   ├── BReq_03_Stakeholders.rst
│   │   ├── BReq_04_Problemas_Necesidades.rst
│   │   ├── BReq_05_Descripcion_Negocio.rst
│   │   ├── BReq_06_Procesos_AS_IS.rst
│   │   ├── BReq_07_Procesos_TO_BE.rst
│   │   ├── BReq_08_Reglas_Negocio.rst
│   │   ├── BReq_09_Criterios_Exito.rst
│   │   └── BReq_10_Glosario_Negocio.rst
│   │
│   ├── casos_de_uso/                            # [CONGELADO] 72 UC
│   │   ├── index.rst
│   │   ├── UC_001_a_UC_018_MOD_Auth.rst
│   │   ├── UC_019_a_UC_030_MOD_Users.rst
│   │   ├── UC_031_a_UC_034_MOD_Access.rst
│   │   ├── UC_035_MOD_Pipeline.rst
│   │   ├── UC_036_a_UC_062_MOD_Reports.rst
│   │   ├── UC_063_a_UC_068_MOD_Alerts.rst
│   │   ├── UC_069_a_UC_070_MOD_Audit.rst
│   │   └── UC_071_a_UC_072_MOD_Logs.rst
│   │
│   └── funcionales/                             # [CONGELADO] FReq - SRS
│       ├── index.rst
│       ├── SRS_v2_0_MOD_Auth.rst
│       ├── SRS_v2_0_MOD_Users.rst
│       ├── SRS_v2_0_MOD_Access.rst
│       ├── SRS_v2_0_MOD_Pipeline.rst
│       ├── SRS_v2_0_MOD_Reports.rst
│       ├── SRS_v2_0_MOD_Alerts.rst
│       ├── SRS_v2_0_MOD_Audit.rst
│       └── SRS_v2_0_MOD_Logs.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 3: ARQUITECTURA TÉCNICA
│ Propósito: Cómo se construye el sistema (diseño + implementación)
│ ═══════════════════════════════════════════════════════════════════
│
├── arquitectura_tecnica/
│   │
│   ├── index.rst
│   │
│   ├── seguridad/                               # [DESCONGELADO] MOD_Access + SEC_RULES
│   │   ├── index.rst
│   │   ├── RBAC_IACT_v5_1_1.rst                 # RBAC v5.1.1 - 44 funciones atómicas
│   │   ├── SEC_RULES_Enforcement.rst
│   │   ├── SEC_AUTH_Autenticacion.rst
│   │   ├── SEC_PERMS_Permisos_Funciones.rst
│   │   ├── SEC_SoD_Separacion_Funciones.rst
│   │   ├── SEC_TEMP_Permisos_Temporales.rst
│   │   └── SEC_CLASSIF_Clasificacion_Datos.rst
│   │
│   ├── restricciones/                           # [DESCONGELADO] 10 CNST - v1.1.0 - 10,543 lineas
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
│   ├── disenio/                                 # [CONGELADO] UML
│   │   ├── index.rst
│   │   ├── componentes/
│   │   │   ├── index.rst
│   │   │   ├── UML_COMP_001_Arquitectura_Global.puml
│   │   │   └── UML_COMP_002_8_Modulos_IACT.puml
│   │   │
│   │   ├── clases/
│   │   │   ├── index.rst
│   │   │   ├── UML_CLASS_001_MOD_Auth.puml
│   │   │   ├── UML_CLASS_002_MOD_Users.puml
│   │   │   ├── UML_CLASS_003_MOD_Access.puml
│   │   │   ├── UML_CLASS_004_MOD_Pipeline.puml
│   │   │   ├── UML_CLASS_005_MOD_Reports.puml
│   │   │   ├── UML_CLASS_006_MOD_Alerts.puml
│   │   │   ├── UML_CLASS_007_MOD_Audit.puml
│   │   │   └── UML_CLASS_008_MOD_Logs.puml
│   │   │
│   │   └── secuencia/
│   │       ├── index.rst
│   │       ├── UML_SEQ_001_Login_Sesion_Unica.puml
│   │       ├── UML_SEQ_002_Validacion_Funciones.puml
│   │       └── UML_SEQ_003_Proceso_ETL.puml
│   │
│   └── base_datos/                              # [CONGELADO] Modelo de datos
│       ├── index.rst
│       ├── DDL_001_Analytics_Schema.sql
│       ├── DDL_002_Analytics_Indexes.sql
│       ├── DDL_003_Analytics_Constraints.sql
│       ├── DDL_004_IVR_ReadOnly_Views.sql
│       └── ERD_Analytics_PostgreSQL.puml
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 4: TRAZABILIDAD Y MATRICES
│ Propósito: Relaciones entre artefactos (BReq → UC → FReq → Code)
│ ═══════════════════════════════════════════════════════════════════
│
├── trazabilidad/
│   │
│   ├── index.rst
│   │
│   ├── matrices/                                # [DESCONGELADO] RTM
│   │   ├── index.rst
│   │   ├── RTM_001_BReq_to_UC.xlsx
│   │   ├── RTM_002_UC_to_FReq.xlsx
│   │   ├── RTM_003_FReq_to_Code.xlsx
│   │   ├── RTM_004_CNST_Impact.xlsx
│   │   └── RTM_005_Cobertura_Testing.xlsx
│   │
│   ├── diagramas/                               # [DESCONGELADO] Grafos de dependencias
│   │   ├── index.rst
│   │   ├── TRACE_001_BReq_Tree.puml
│   │   ├── TRACE_002_UC_Dependencies.puml
│   │   └── TRACE_003_Module_Relationships.puml
│   │
│   └── reportes/                                # [DESCONGELADO] Análisis de impacto
│       ├── index.rst
│       ├── IMPACT_001_Cambio_RBAC_v4_to_v5.md
│       └── IMPACT_002_Ampliacion_CNST.md
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 5: APÉNDICES Y MATERIAL DE SOPORTE
│ Propósito: Documentación auxiliar, referencias, material de consulta
│ ═══════════════════════════════════════════════════════════════════
│
└── apendices/
    │
    ├── index.rst
    │
    ├── referencias/                             # [CONGELADO] Material de referencia
    │   ├── index.rst
    │   ├── REF_001_Django_4_2_Docs.md
    │   ├── REF_002_DRF_3_14_Docs.md
    │   ├── REF_003_PostgreSQL_15_Docs.md
    │   └── REF_004_React_18_Docs.md
    │
    ├── ejemplos/                                # [DESCONGELADO] Código de ejemplo
    │   ├── index.rst
    │   ├── EX_001_JWT_Authentication.py
    │   ├── EX_002_RBAC_Validation.py
    │   ├── EX_003_ETL_Pipeline.py
    │   └── EX_004_Report_Generation.py
    │
    └── historico/                               # [PRIVADO] Versiones anteriores
        ├── index.rst
        ├── v1.0/
        │   └── RBAC_v4_0_Deprecated.md
        └── v2.0/
            └── SRS_v1_0_Legacy.md

```

## NOTAS DE VERSIÓN v2.0.7

**Fecha:** 2026-01-03  
**Cambios principales:**

1. Directorio restricciones/
   - Estado: CONGELADO → DESCONGELADO
   - Versión: v1.0.0 → v1.1.0
   - Líneas: 9,621 → 10,543 (+922 líneas)
   - CNST-005 ampliado: +345 líneas (Permisos Temporales)
   - CNST-006 ampliado: +577 líneas (Patrones Recomendados)
   - Integración con RBAC v5.1.1

2. Comentario actualizado en restricciones/:
   - [DESCONGELADO] 10 CNST - v1.1.0 - 10,543 líneas

**Versiones anteriores:**
- v2.0.6: Estado anterior (2025-12-17)
- v2.0.5: Integración RBAC v5.1.1
- v2.0.4: Casos de uso congelados

