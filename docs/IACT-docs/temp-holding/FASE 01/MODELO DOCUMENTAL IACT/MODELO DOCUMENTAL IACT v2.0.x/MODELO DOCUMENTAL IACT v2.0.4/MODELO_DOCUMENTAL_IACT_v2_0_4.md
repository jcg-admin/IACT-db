# MODELO DOCUMENTAL IACT v2.0.4
## Proyecto IACT Dashboard Analytics

**Versión:** 2.0.4  
**Fecha:** 2026-01-03  
**Base:** Análisis de TXM_01-03, MTM_01-03, MODELO_RBAC_v5.1.1, CNST_001-010

---

## CHANGELOG desde v2.0.0

| Versión | Cambio |
|---------|--------|
| v2.0.3 | Añadido subdominio modulos/ con 8 MOD_ |
| v2.0.3 | Nomenclatura Clean Code (MOD_Auth vs ARQ_MOD_001) |
| v2.0.3 | SEC_RULES integrado en MOD_Access |
| v2.0.3 | Añadido subdominio flujos_datos/ con 12 FD_ |
| v2.0.3-rev1 | Integración de taxonomías y metamodelos |
| v2.0.3-rev1 | Corrección ubicación: CNST en arquitectura_tecnica/ |
| v2.0.3-rev1 | Añadido base_cognitiva/_taxonomias_y_metamodelos/ |
| v2.0.3-rev1 | Añadido base_cognitiva/_ontologia_sbvr/ |
| v2.0.3-rev1 | Añadido base_cognitiva/_metodologias_analiticas/ |
| v2.0.3-rev1 | Definición formal de 5 tipos de BR |
| v2.0.3-rev1 | Métricas de cobertura RTM definidas |
| **v2.0.4** | **Actualización BR_006 y BR_007 alineadas con RBAC v5.1.1** |
| **v2.0.4** | **Nuevas BR_019 (Clasificación Datos) y BR_020 (Rango Temporal)** |
| **v2.0.4** | **Cobertura 100% de CNST aplicables** |
| **v2.0.4** | **Integración con 44 funciones atómicas RBAC** |
| **v2.0.4** | **Mapeo completo BR → Funciones RBAC → UC** |
| **v2.0.4** | **Identificación CNST que NO generan BR (CNST_006, CNST_008)** |

---

## 1. ESTRUCTURA COMPLETA DEL SISTEMA DOCUMENTAL

### 1.1 Fórmula del Modelo

```
5 DOMINIOS + 21 SUBDOMINIOS + 6 SUBCARPETAS ORGANIZATIVAS
```

### 1.2 Los 5 Dominios

| # | Dominio | Propósito | Prefijos |
|---|---------|-----------|----------|
| 1 | base_cognitiva/ | Conocimiento fundamental | META, GLOS, FND, SBVR, TXM, MTM, METH |
| 2 | requisitos/ | Especificación del sistema | BR, UC, FR, NFR |
| 3 | arquitectura_tecnica/ | Diseño e implementación | MOD, ADR, VIEW, API, CNST, FD |
| 4 | normativa/ | Estándares y políticas | STD, PROC, POL, TPL |
| 5 | evidencia/ | Verificación y trazabilidad | TST, RTM, COV |

---

## 2. ÁRBOL COMPLETO v2.0.4

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
│   │   ├── META_04_Contexto_IACT.rst
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
│   ├── _taxonomias_y_metamodelos/               # [PRIVADO] Clasificaciones
│   │   ├── index.rst
│   │   ├── taxonomias/
│   │   │   ├── TXM_01_Taxonomia_Requisitos.rst
│   │   │   ├── TXM_02_Taxonomia_Artefactos.rst
│   │   │   └── TXM_03_Taxonomia_Reglas_Negocio.rst
│   │   └── metamodelos/
│   │       ├── MTM_01_Metamodelo_Requisitos.rst
│   │       ├── MTM_02_Metamodelo_Trazabilidad.rst
│   │       └── MTM_03_Metamodelo_RBAC.rst
│   │
│   └── _metodologias_analiticas/                # [PRIVADO] Procedimientos
│       ├── index.rst
│       ├── METH_01_Derivacion_UC_desde_BR.rst
│       ├── METH_02_Derivacion_FR_desde_UC.rst
│       └── METH_03_Tecnicas_Larman.rst
│
│
│ ═══════════════════════════════════════════════════════════════════
│ DOMINIO 2: REQUISITOS
│ Propósito: Especificación del sistema (BR → UC → FR)
│ ═══════════════════════════════════════════════════════════════════
│
├── requisitos/
│   │
│   ├── index.rst
│   │
│   ├── reglas_negocio/                          # [DESCONGELADO] 20 BR ✅ v2.0.4
│   │   ├── index.rst
│   │   │
│   │   │   # TIPO: RESTRICCIÓN (Deóntica - DEBE/NO DEBE) [9 BR]
│   │   ├── BR_001_Fuente_Inmutable.rst
│   │   ├── BR_004_Comunicaciones_Internas.rst
│   │   ├── BR_005_Sesion_Unica.rst
│   │   ├── BR_007_Separacion_Funciones_SoD.rst      # ⚠️ ACTUALIZADA v2.0.4
│   │   ├── BR_008_Permisos_Vencimiento.rst
│   │   ├── BR_009_Bajas_Logicas.rst
│   │   ├── BR_010_Auditoria_Inmutable.rst
│   │   ├── BR_011_Limites_Exportacion.rst
│   │   ├── BR_020_Rango_Temporal_Reportes.rst       # 🆕 NUEVA v2.0.4
│   │   │
│   │   │   # TIPO: HECHO (Aléctica - ES/TIENE) [4 BR]
│   │   ├── BR_006_RBAC_Flat_NIST.rst                # ⚠️ ACTUALIZADA v2.0.4
│   │   ├── BR_012_Usuario_Segmento_Unico.rst
│   │   ├── BR_013_Username_Unico.rst
│   │   ├── BR_019_Clasificacion_Datos.rst           # 🆕 NUEVA v2.0.4
│   │   │
│   │   │   # TIPO: DESENCADENADOR (SI→ENTONCES visible) [3 BR]
│   │   ├── BR_002_ETL_Batch_Nocturno.rst
│   │   ├── BR_014_Alerta_Umbral.rst
│   │   ├── BR_015_Bloqueo_Intentos_Fallidos.rst
│   │   │
│   │   │   # TIPO: INFERENCIA (SI→ENTONCES interno) [1 BR]
│   │   ├── BR_003_Usuario_Inactivo_90d.rst
│   │   │
│   │   │   # TIPO: CÁLCULO (Fórmulas) [3 BR]
│   │   ├── BR_016_Tasa_Abandono.rst
│   │   ├── BR_017_Tiempo_Promedio_Espera.rst
│   │   └── BR_018_Indice_Eficiencia.rst
│   │
│   ├── casos_uso/                               # [DESCONGELADO] 49 UC
│   │   ├── index.rst
│   │   │
│   │   ├── auth/                                # MOD_Auth: UC-001 a UC-005
│   │   │   ├── UC_001_Inicio_Sesion.rst
│   │   │   ├── UC_002_Cierre_Sesion.rst
│   │   │   ├── UC_003_Recuperar_Password.rst
│   │   │   ├── UC_004_Cambiar_Password.rst
│   │   │   └── UC_005_Gestionar_Sesiones.rst
│   │   │
│   │   ├── users/                               # MOD_Users: UC-006 a UC-009
│   │   │   ├── UC_006_Crear_Usuario.rst
│   │   │   ├── UC_007_Modificar_Usuario.rst
│   │   │   ├── UC_008_Baja_Usuario.rst
│   │   │   └── UC_009_Listar_Usuarios.rst
│   │   │
│   │   ├── access/                              # MOD_Access: UC-010, UC-011, UC-041-047
│   │   │   ├── UC_010_Asignar_Roles.rst
│   │   │   ├── UC_011_Gestionar_Permisos_Rol.rst
│   │   │   ├── UC_041_Asignar_Segmento.rst
│   │   │   ├── UC_042_Asignar_Permiso_Directo.rst
│   │   │   ├── UC_043_Configurar_SoD.rst
│   │   │   ├── UC_044_Consultar_Permisos_Efectivos.rst
│   │   │   ├── UC_045_Gestionar_Catalogo_Roles.rst
│   │   │   ├── UC_046_Gestionar_Catalogo_Permisos.rst
│   │   │   └── UC_047_Auditar_Cambios_Permisos.rst
│   │   │
│   │   ├── pipeline/                            # MOD_Pipeline: UC-050 a UC-053
│   │   │   ├── UC_050_Supervisar_ETL.rst
│   │   │   ├── UC_051_Consultar_Errores_ETL.rst
│   │   │   ├── UC_052_Consultar_Disponibilidad.rst
│   │   │   └── UC_053_Solicitar_Reintento_ETL.rst
│   │   │
│   │   ├── reports/                             # MOD_Reports: UC-017 a UC-029
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
│   │   │
│   │   ├── alerts/                              # MOD_Alerts: UC-036 a UC-040
│   │   │   ├── UC_036_Crear_Alerta.rst
│   │   │   ├── UC_037_Recibir_Notificacion.rst
│   │   │   ├── UC_038_Pausar_Alerta.rst
│   │   │   ├── UC_039_Historial_Alertas.rst
│   │   │   └── UC_040_Gestionar_Destinatarios.rst
│   │   │
│   │   ├── audit/                               # MOD_Audit: UC-060 a UC-063
│   │   │   ├── UC_060_Registrar_Evento.rst
│   │   │   ├── UC_061_Consultar_Auditoria.rst
│   │   │   ├── UC_062_Generar_Reporte_Auditoria.rst
│   │   │   └── UC_063_Exportar_Auditoria.rst
│   │   │
│   │   └── logs/                                # MOD_Logs: UC-070 a UC-072
│   │       ├── UC_070_Consultar_Logs.rst
│   │       ├── UC_071_Filtrar_Logs.rst
│   │       └── UC_072_Exportar_Logs.rst
│   │
│   ├── funcionales/                             # [DESCONGELADO] ~300 FR
│   │   ├── index.rst
│   │   ├── auth/
│   │   │   └── FR_UC001_Inicio_Sesion.rst       # Contiene FR-001.1 a FR-001.N
│   │   ├── users/
│   │   ├── access/
│   │   ├── pipeline/
│   │   ├── reports/
│   │   ├── alerts/
│   │   ├── audit/
│   │   └── logs/
│   │
│   └── no_funcionales/                          # [CONGELADO] ~20 NFR
│       ├── index.rst
│       ├── NFR_001_Rendimiento.rst
│       ├── NFR_002_Seguridad.rst
│       ├── NFR_003_Usabilidad.rst
│       └── NFR_004_Confiabilidad.rst
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

### 3.1 Cadena de Requisitos

```
NIVEL 0                NIVEL 1            NIVEL 2           NIVEL 3         NIVEL 4-5
┌─────────┐                              ┌─────────┐       ┌─────────┐     ┌─────────┐
│   BR    │──────(genera si Trigger)────►│   UC    │──────►│   FR    │────►│  CODE   │
│ Regla   │                              │  Caso   │deriva │ Funcional│impl │         │
└────┬────┘                              └────┬────┘       └────┬────┘     └────┬────┘
     │                                        │                 │               │
     │ influye                                │ satisface       │               │ verifica
     │                                        ▼                 │               ▼
     │         ┌─────────┐    genera    ┌─────────┐            │          ┌─────────┐
     └────────►│  BReq   │─────────────►│   UC    │            └─────────►│  TEST   │
               │Objetivo │              │         │                       │         │
               └─────────┘              └─────────┘                       └─────────┘
```

### 3.2 Tipos de Enlaces (MTM_02)

| Enlace | Semántica | Cardinalidad |
|--------|-----------|--------------|
| BR --deriva--> UC | BR Trigger genera UC completo | 0..1 : 0..1 |
| BR --influye--> UC | BR afecta sin generar | 0..* : 0..* |
| BReq --genera--> UC | Objetivo genera casos de uso | 1..* : 1..* |
| UC --deriva--> FR | Cada paso "Sistema" genera FR | 1 : 1..* |
| FR --implementa--> CODE | FR se codifica | 0..* : 0..* |
| TEST --verifica--> FR | Test valida FR | 1..* : 1..* |

### 3.3 Ratio de Derivación

```
Típico: 1 UC : 8 FR

IACT esperado:
- BR: 20 (documentadas v2.0.4)
- UC: 49 (identificados)
- FR: ~400 (estimado: 49 × 8)
- TEST: ~320 (80% cobertura FR)
```

---

## 4. TIPOS DE BUSINESS RULES (TXM_03)

### 4.1 Los 5 Tipos

| Tipo | Modalidad | ¿Genera UC? | Patrón | Cantidad v2.0.4 |
|------|-----------|-------------|--------|-----------------|
| **Hecho** | Aléctica | NO | "[X] ES/TIENE [Y]" | 4 |
| **Restricción** | Deóntica | Parcial | "[X] DEBE/NO DEBE [Y]" | 9 |
| **Desencadenador** | Deóntica | **SÍ** | "SI [cond] ENTONCES [acción visible]" | 3 |
| **Inferencia** | Aléctica | NO | "SI [cond] ENTONCES [estado interno]" | 1 |
| **Cálculo** | Aléctica | NO | "[Resultado] = [fórmula]" | 3 |
| **TOTAL** | | | | **20** |

### 4.2 Catálogo Completo de BR v2.0.4

| BR | Nombre | Tipo | CNST | Funciones RBAC | Estado |
|----|--------|------|------|----------------|--------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 | PIP-001, RPT-001 | ✅ |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 | PIP-001 a PIP-004 | ✅ |
| BR_003 | Usuario Inactivo 90d | Inferencia | -- | USR-009 | ✅ |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 | AUT-003, ALR-002 | ✅ |
| BR_005 | Sesión Única | Restricción | CNST_002 | AUT-001, AUT-002, AUT-004 | ✅ |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 | ACC-001 a ACC-006 | ⚠️ **ACTUALIZADA** |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 | ACC-005 | ⚠️ **ACTUALIZADA** |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 | ACC-001 | ✅ |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 | USR-004 | ✅ |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 | AUD-001 a AUD-004 | ✅ |
| BR_011 | Límites Exportación | Restricción | CNST_007 | RPT-004, RPT-005, RPT-006 | ✅ |
| BR_012 | Usuario-Segmento Único | Hecho | -- | USR-010, ACC-006 | ✅ |
| BR_013 | Username Único | Hecho | -- | USR-001 | ✅ |
| BR_014 | Alerta por Umbral | Desencadenador | -- | ALR-002 | ✅ |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 | AUT-001 | ✅ |
| BR_016 | Tasa Abandono | Cálculo | -- | RPT-007 | ✅ |
| BR_017 | Tiempo Promedio Espera | Cálculo | -- | RPT-007 | ✅ |
| BR_018 | Índice Eficiencia | Cálculo | -- | RPT-007 | ✅ |
| **BR_019** | **Clasificación Datos** | **Hecho** | **CNST_010** | ACC-006 | 🆕 **NUEVA** |
| **BR_020** | **Rango Temporal Reportes** | **Restricción** | **CNST_007** | RPT-001, RPT-003 | 🆕 **NUEVA** |

### 4.3 Detalle de BR Actualizadas (v2.0.4)

#### BR_006: RBAC Flat NIST (ACTUALIZADA)

**Declaración:**
El sistema IACT implementa un modelo RBAC Flat con las siguientes características:

| Componente | Cantidad | Descripción |
|------------|----------|-------------|
| Funciones Atómicas | 44 | Distribuidas en 8 módulos IACT |
| Agrupadores | 10 | AGR-001 a AGR-010 |
| Segmentos | 5 | OP, FI, TE, SU, CA |
| Restricciones SoD | 3 | SOD-001, SOD-002, SOD-003 |

**Filosofía "Sin Pretensiones":**
Los nombres de funciones describen QUÉ HACE, NO QUIÉN ES:
- ✅ `crea_usuarios`, `ve_reportes`, `exporta_csv`
- ❌ `USERS_FULL_MANAGER`, `SYSTEM_ADMIN`

**Precedencia de Permisos:**
```
Permiso Directo > Función Asignada > Segmento
```

**Funciones por Módulo:**

| Módulo | Código | Cantidad |
|--------|--------|----------|
| MOD_Auth | AUT | 4 |
| MOD_Users | USR | 10 |
| MOD_Access | ACC | 6 |
| MOD_Pipeline | PIP | 4 |
| MOD_Reports | RPT | 8 |
| MOD_Alerts | ALR | 6 |
| MOD_Audit | AUD | 4 |
| MOD_Logs | LOG | 2 |

---

#### BR_007: Separación Funciones SoD (ACTUALIZADA)

**Declaración:**
Un usuario NO DEBE tener asignadas simultáneamente funciones que pertenezcan a grupos en conflicto según las restricciones SoD.

**Restricciones SoD Obligatorias:**

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| SOD-001 | sod_admin_auditoria | PIP-001, PIP-002, PIP-003, PIP-004 | AUD-001, AUD-002, AUD-003, AUD-004 | Quien opera pipeline NO audita |
| SOD-002 | sod_usuarios_auditoria | USR-001, USR-003, USR-004, USR-007 | AUD-001, AUD-002, AUD-003 | Quien gestiona usuarios NO audita |
| SOD-003 | sod_acceso_auditoria | ACC-001, ACC-002, ACC-005 | AUD-001, AUD-002 | Quien gestiona acceso NO audita |

**Enforcement:**
- Validación en tiempo de asignación (ACC-001)
- Validación en tiempo de ejecución (SEC_RULES)
- No aplican excepciones

---

#### BR_019: Clasificación de Datos (NUEVA)

**Declaración:**
Los datos del sistema IACT están clasificados en 4 niveles según su sensibilidad.

**Niveles:**

| Nivel | Nombre | Acceso |
|-------|--------|--------|
| C1 | PÚBLICO | Cualquier usuario autenticado |
| C2 | INTERNO | Usuarios con función específica |
| C3 | CONFIDENCIAL | Solo roles supervisión |
| C4 | RESTRINGIDO | Solo auditoría y compliance |

**Segmentos de Datos IACT:**
- **OP:** Datos operativos (llamadas, tiempos)
- **FI:** Datos financieros (costos por llamada)
- **TE:** Datos técnicos (errores, logs)
- **SU:** Datos de supervisión (rendimiento agentes)
- **CA:** Datos de calidad (encuestas, NPS)

**Tratamiento:**
- C3 y C4 requieren enmascaramiento en exportaciones
- PII nunca se exporta en texto plano
- Acceso a C4 genera registro de auditoría nivel CRITICAL

---

#### BR_020: Rango Temporal Reportes (NUEVA)

**Declaración:**
Los reportes y consultas del sistema NO DEBEN solicitar un rango de fechas mayor a 730 días (2 años).

**Parámetros:**
- Rango máximo: 730 días
- Validación: API (serializer) + ORM (queryset)
- Mensaje error: "El rango de fechas no puede exceder 2 años"

**Funciones Afectadas:**
- RPT-001 (ve_reportes)
- RPT-003 (filtra_reportes)
- RPT-004, RPT-005, RPT-006 (exportaciones)

---

### 4.4 Árbol de Decisión para Clasificar BR

```
¿La BR tiene formato SI...ENTONCES?
│
├─ NO → ¿Define una verdad estructural?
│       ├─ SÍ → HECHO
│       └─ NO → ¿Define una fórmula?
│               ├─ SÍ → CÁLCULO
│               └─ NO → RESTRICCIÓN
│
└─ SÍ → ¿El ENTONCES es visible externamente?
        ├─ SÍ → DESENCADENADOR (genera UC)
        └─ NO → INFERENCIA
```

---

## 5. LOS 8 MÓDULOS FUNCIONALES

### 5.1 Catálogo de Módulos

| Código | Nombre | App Django | UC Asociados | Funciones RBAC |
|--------|--------|------------|--------------|----------------|
| MOD_Auth | Auth | apps.auth | UC-001 a UC-005 | AUT-001 a AUT-004 |
| MOD_Users | Users | apps.users | UC-006 a UC-009 | USR-001 a USR-010 |
| MOD_Access | Access | apps.access | UC-010, UC-011, UC-041-047 | ACC-001 a ACC-006 |
| MOD_Pipeline | Pipeline | apps.pipeline | UC-050 a UC-053 | PIP-001 a PIP-004 |
| MOD_Reports | Reports | apps.reports | UC-017 a UC-029 | RPT-001 a RPT-008 |
| MOD_Alerts | Alerts | apps.alerts | UC-036 a UC-040 | ALR-001 a ALR-006 |
| MOD_Audit | Audit | apps.audit | UC-060 a UC-063 | AUD-001 a AUD-004 |
| MOD_Logs | Logs | apps.logs | UC-070 a UC-072 | LOG-001 a LOG-002 |

### 5.2 Estructura de cada MOD_xxx.rst

```rst
============================
MOD_xxx - Nombre del Módulo
============================

1. Propósito
2. Responsabilidades (PUEDE hacer)
3. Límites (NO PUEDE hacer)
4. Casos de Uso Asociados
5. Funciones RBAC del Módulo
6. Restricciones Aplicables (CNST)
7. Business Rules Aplicables (BR)
8. Dependencias con otros Módulos
9. Componentes Internos (si aplica)
10. Diagrama PlantUML
```

### 5.3 SEC_RULES (Integrado en MOD_Access)

SEC_RULES NO es módulo separado. Es subcapa interna de MOD_Access:

| Componente | Visibilidad | Descripción |
|------------|-------------|-------------|
| RBAC_CORE | Usuario ve UI | Administración roles/permisos |
| SEC_RULES | Automático | Enforcement middleware/decoradores |

---

## 6. MÉTRICAS DE COBERTURA RTM (MTM_02)

### 6.1 Umbrales Mínimos IACT

| Cobertura | Umbral | Fórmula |
|-----------|--------|---------|
| BR → UC | 100% | BR con impacto / Total BR |
| UC → FR | 100% | UC con FR derivados / Total UC |
| FR → CODE | 90% | FR implementados / Total FR |
| FR → TEST | 80% | FR con test / Total FR |

### 6.2 Estado Actual v2.0.4

| Métrica | Valor | Estado |
|---------|-------|--------|
| BR identificadas | 20 | ✅ Completo |
| UC identificados | 49 | ✅ Listo para documentar |
| FR derivados | 0 | ❌ Pendiente |
| Cobertura BR→UC | -- | ⏳ Pendiente RTM |
| Cobertura UC→FR | 0% | ❌ Pendiente derivar |
| Cobertura FR→TEST | 0% | ❌ Pendiente |
| Cobertura CNST→BR | 100% | ✅ Completo v2.0.4 |

---

## 7. MAPEO CNST → BR (ACTUALIZADO v2.0.4)

### 7.1 Matriz de Cobertura Completa

| CNST | Descripción | BR Derivada | Tipo BR | Estado |
|------|-------------|-------------|---------|--------|
| CNST_001 | Sin email | BR_004 | Restricción | ✅ |
| CNST_002 | Sesiones BD | BR_005 | Restricción | ✅ |
| CNST_003 | BD readonly | BR_001 | Restricción | ✅ |
| CNST_004 | ETL batch | BR_002 | Desencadenador | ✅ |
| CNST_005 | RBAC/Seguridad | BR_006, BR_007, BR_008, BR_009, BR_015 | Varios | ✅ |
| CNST_006 | Antipatrones | ➖ NO genera BR | N/A | ➖ Va a STD_001 |
| CNST_007 | Límites/Performance | BR_011, **BR_020** | Restricción | ✅ |
| CNST_008 | Infraestructura | ➖ NO genera BR | N/A | ➖ Va a PROC_004 |
| CNST_009 | Auditoría | BR_010 | Restricción | ✅ |
| CNST_010 | Clasificación datos | **BR_019** | Hecho | ✅ 🆕 |

### 7.2 CNST que NO Generan BR

| CNST | Razón | Destino Correcto |
|------|-------|------------------|
| CNST_006 | Es estándar de código, no regla de negocio | STD_001_Suite_Calidad_Codigo.rst |
| CNST_008 | Es restricción de infraestructura técnica | PROC_004_Deployment.rst |

### 7.3 Resumen de Cobertura

```
CNST Cubiertos por BR:     8/10 (80%)
CNST que no aplican a BR:  2/10 (20%) → Van a normativa/
Cobertura efectiva:        100%
```

---

## 8. MAPEO BR → FUNCIONES RBAC v5.1.1

| BR | Funciones RBAC Afectadas |
|----|--------------------------|
| BR_001 | PIP-001 (ve_estado_etl), RPT-001 (ve_reportes) |
| BR_002 | PIP-001, PIP-002, PIP-003, PIP-004 |
| BR_003 | USR-009 (reactiva_usuarios) |
| BR_004 | AUT-003 (resetea_password), ALR-002 (configura_alertas) |
| BR_005 | AUT-001 (gestiona_sesiones), AUT-002, AUT-004 |
| BR_006 | ACC-001 a ACC-006 (todas las de acceso) |
| BR_007 | ACC-005 (gestiona_sod) |
| BR_008 | ACC-001 (asigna_funciones) |
| BR_009 | USR-004 (elimina_usuarios) |
| BR_010 | AUD-001 a AUD-004 (todas las de auditoría) |
| BR_011 | RPT-004, RPT-005, RPT-006 (exportaciones) |
| BR_012 | USR-010 (asigna_segmento), ACC-006 (gestiona_segmentos) |
| BR_013 | USR-001 (crea_usuarios) |
| BR_014 | ALR-002 (configura_alertas) |
| BR_015 | AUT-001 (gestiona_sesiones) |
| BR_016-018 | RPT-007 (ve_kpis) |
| BR_019 | ACC-006 (gestiona_segmentos) |
| BR_020 | RPT-001 (ve_reportes), RPT-003 (filtra_reportes) |

---

## 9. CATÁLOGO DE PREFIJOS

### 9.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| requisitos | BR, UC, FR, NFR | ~470 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~45 |
| normativa | STD, PROC, POL, TPL | ~15 |
| evidencia | TST, RTM, COV | ~12 |
| **TOTAL** | -- | **~567** |

### 9.2 Nomenclatura de Archivos

```
[PREFIJO]_[NNN]_[Nombre_Descriptivo].rst

Ejemplos:
- BR_001_Fuente_Inmutable.rst
- UC_010_Asignar_Roles.rst
- MOD_Auth.rst (sin número, nombre único)
- CNST_001_Comunicaciones_Prohibidas.rst
```

### 9.3 Caso Especial: FR

```
FR_UC[NNN]_[Nombre_UC].rst

El archivo contiene todos los FR del UC.

Ejemplo:
- FR_UC010_Asignar_Roles.rst → contiene FR-010.1 a FR-010.N
```

---

## 10. CONTEO DE ARTEFACTOS

### 10.1 Por Estado

| Estado | Cantidad | % |
|--------|----------|---|
| ✅ COMPLETADOS | 23 | 4% |
| ⏳ IDENTIFICADOS | ~100 | 18% |
| ❌ PENDIENTES | ~444 | 78% |
| **TOTAL** | **~567** | 100% |

### 10.2 Completados

| Tipo | Cantidad | Ubicación |
|------|----------|-----------|
| CNST | 10 | arquitectura_tecnica/restricciones/ |
| FND | 7 | base_cognitiva/_fundamentos_conceptuales/ |
| TXM | 3 | base_cognitiva/_taxonomias_y_metamodelos/taxonomias/ |
| MTM | 3 | base_cognitiva/_taxonomias_y_metamodelos/metamodelos/ |
| **TOTAL** | **23** | -- |

### 10.3 Pendientes Prioritarios

| Tipo | Cantidad | Prioridad |
|------|----------|-----------|
| BR | 20 | 🔴 ALTA (identificadas, falta documentar) |
| UC | 49 | 🔴 ALTA |
| FR | ~400 | 🟡 MEDIA |
| MOD | 8 | 🟡 MEDIA |
| TST | ~320 | 🟢 BAJA |

---

## 11. ORDEN DE EJECUCIÓN

### Fase 1: Business Rules (BR)
```
Prioridad: 🔴 ALTA
Cantidad: 20 documentos
Ubicación: requisitos/reglas_negocio/

Orden:
1. BR_006, BR_007 (actualizadas - alineación RBAC v5.1.1)
2. BR_019, BR_020 (nuevas)
3. BR_001 a BR_018 restantes
4. index.rst con clasificación por tipo
```

### Fase 2: Casos de Uso (UC)
```
Prioridad: 🔴 ALTA
Cantidad: 49 documentos
Ubicación: requisitos/casos_uso/{modulo}/

Por módulo:
1. auth/ (5 UC)
2. users/ (4 UC)
3. access/ (9 UC)
4. pipeline/ (4 UC)
5. reports/ (12 UC)
6. alerts/ (5 UC)
7. audit/ (4 UC)
8. logs/ (3 UC)
```

### Fase 3: Módulos (MOD)
```
Prioridad: 🟡 MEDIA
Cantidad: 8 documentos
Ubicación: arquitectura_tecnica/modulos/

1. MOD_Auth.rst
2. MOD_Users.rst
3. MOD_Access.rst (con SEC_RULES)
4. MOD_Pipeline.rst
5. MOD_Reports.rst
6. MOD_Alerts.rst
7. MOD_Audit.rst
8. MOD_Logs.rst
```

### Fase 4: Functional Requirements (FR)
```
Prioridad: 🟡 MEDIA
Cantidad: ~400 documentos
Ubicación: requisitos/funcionales/{modulo}/

Derivar desde cada UC usando ratio 1:8
```

### Fase 5: Trazabilidad (RTM)
```
Prioridad: 🟡 MEDIA
Cantidad: 2 documentos
Ubicación: evidencia/trazabilidad/

1. RTM_Master_v1_0_0.rst
2. COV_001_Reporte_Cobertura.rst
```

### Fase 6: Tests (TST)
```
Prioridad: 🟢 BAJA
Cantidad: ~320 documentos
Ubicación: evidencia/pruebas/{modulo}/

Crear para cumplir 80% cobertura FR→TEST
```

---

## 12. ARCHIVOS DE REFERENCIA (NO DOCUMENTACIÓN)

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| REFERENCIA_GLOBAL_MODULOS_IACT.md | Fuente para MOD_.rst | /outputs/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo RBAC oficial | /outputs/ |
| ANALISIS_BR_REVISION_INTEGRAL_v1.md | Análisis BR vs RBAC | /outputs/ |
| MODELO_DOCUMENTAL_IACT_v2_0_4.md | Este documento | /outputs/ |

---

## 13. RESUMEN DE CAMBIOS v2.0.4

### 13.1 BR Actualizadas

| BR | Cambio Principal |
|----|------------------|
| BR_006 | Alineada con 44 funciones atómicas, 10 agrupadores, filosofía "Sin Pretensiones" |
| BR_007 | Documentadas 3 restricciones SoD específicas (SOD-001, SOD-002, SOD-003) |

### 13.2 BR Nuevas

| BR | Origen | Propósito |
|----|--------|-----------|
| BR_019 | CNST_010 | Clasificación de datos en 4 niveles (C1-C4) |
| BR_020 | CNST_007 | Rango máximo de reportes (730 días) |

### 13.3 Cobertura Lograda

| Métrica | v2.0.3 | v2.0.4 | Cambio |
|---------|--------|--------|--------|
| Total BR | 18 | 20 | +2 |
| Cobertura CNST→BR | 70% | 100% | +30% |
| BR alineadas RBAC v5.1.1 | 0 | 20 | +20 |

---

*Modelo Documental IACT v2.0.4*  
*Proyecto: IACT Dashboard Analytics*  
*Fecha: 2026-01-03*  
*Base: TXM_01-03 + MTM_01-03 + MODELO_RBAC_v5.1.1 + CNST_001-010*