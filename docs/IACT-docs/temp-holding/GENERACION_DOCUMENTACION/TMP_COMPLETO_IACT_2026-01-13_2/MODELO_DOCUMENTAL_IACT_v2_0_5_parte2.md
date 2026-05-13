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
│   ├── restricciones/                           # [CONGELADO] ✅ 10 CNST COMPLETADOS
│   │   ├── index.rst
│   │   ├── CNST_001_Comunicaciones_Prohibidas.rst
│   │   ├── CNST_002_Gestion_Sesiones_BD.rst
│   │   ├── CNST_003_Base_Datos_Dual_Inmutable.rst
│   │   ├── CNST_004_Actualizacion_Datos_ETL.rst
│   │   ├── CNST_005_Seguridad_DRF_Checklist.rst
│   │   ├── CNST_006_Antipatrones_Arquitectura.rst   # ➖ No genera BR
│   │   ├── CNST_007_Limites_Performance_SLA.rst
│   │   ├── CNST_008_Infraestructura_Deployment.rst  # ➖ No genera BR
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
│   │   ├── STD_001_Suite_Calidad_Codigo.rst     # ← Absorbe CNST_006
│   │   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   │   ├── STD_003_Clean_Code_Naming.rst
│   │   ├── STD_004_Nomenclatura_Proyecto.rst
│   │   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   │   └── plantillas/
│   │       ├── TPL_001_Plantilla_BR.rst         # ← Template BR (ver FND_02)
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
│   │   └── PROC_004_Deployment.rst              # ← Absorbe CNST_008
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
        ├── RTM_Master_v1_0_0.rst                # Matriz de trazabilidad
        └── COV_001_Reporte_Cobertura.rst        # Métricas de cobertura
```

---

## 3. JERARQUÍA DE DERIVACIÓN (MTM_01 + MTM_02)

### 3.1 Cadena de Requisitos IACT (3 Niveles Operativos)

```
NIVEL 0                              NIVEL 2           NIVEL 3         NIVEL 4-5
┌─────────┐                         ┌─────────┐       ┌─────────┐     ┌─────────┐
│   BR    │────(genera si Trigger)──►│   UC    │──────►│   FR    │────►│  CODE   │
│ Regla   │                         │  Caso   │deriva │ Funcional│impl │         │
└────┬────┘                         └────┬────┘       └────┬────┘     └────┬────┘
     │                                   │                 │               │
     │ influye                           │ satisface       │               │ verifica
     │                                   ▼                 │               ▼
     │         ┌─────────┐              ┌─────────┐       │          ┌─────────┐
     └────────►│  META_04│─────────────►│   UC    │       └─────────►│  TEST   │
               │(BReq)   │   genera     │         │                  │         │
               └─────────┘              └─────────┘                  └─────────┘
               [Implícito]

NOTA v2.0.5: BReq está implícito en META_04_Contexto_IACT.rst
             Ver FND_05 para jerarquía teórica de 4 niveles.
```

### 3.2 Tipos de Enlaces (MTM_02)

| Enlace | Semántica | Cardinalidad |
|--------|-----------|--------------|
| BR --deriva--> UC | BR Trigger genera UC completo | 0..1 : 0..1 |
| BR --influye--> UC | BR afecta sin generar | 0..* : 0..* |
| META_04 --genera--> UC | Objetivos generan casos de uso | 1..* : 1..* |
| UC --deriva--> FR | Cada paso "Sistema" genera FR | 1 : 1..* |
| FR --implementa--> CODE | FR se codifica | 0..* : 0..* |
| TEST --verifica--> FR | Test valida FR | 1..* : 1..* |

### 3.3 Ratio de Derivación

```
Típico: 1 UC : 8 FR (ver FND_07 criterios SMART)

IACT esperado:
- BR: 20 (documentadas v2.0.4)
- UC: 49 (identificados)
- FR: ~400 (estimado: 49 × 8)
- TEST: ~320 (80% cobertura FR)
```
