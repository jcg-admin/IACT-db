# MODELO DOCUMENTAL IACT v2.0.6
## Proyecto IACT Dashboard Analytics

**Versión:** 2.0.6  
**Fecha:** 2026-01-03  
**Base:** TXM_01-03, MTM_01-03, MODELO_RBAC_v5.1.1, CNST_001-010, FND_01-07

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
| v2.0.4 | Actualización BR_006 y BR_007 alineadas con RBAC v5.1.1 |
| v2.0.4 | Nuevas BR_019 (Clasificación Datos) y BR_020 (Rango Temporal) |
| v2.0.4 | Cobertura 100% de CNST aplicables |
| v2.0.4 | Integración con 44 funciones atómicas RBAC |
| v2.0.4 | Mapeo completo BR → Funciones RBAC → UC |
| v2.0.5 | Agregada referencia a template BR (TPL_001, FND_02) |
| v2.0.5 | Agregado mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1 |
| v2.0.5 | Agregada referencia a criterios SMART (FND_07) |
| **v2.0.6** | **CORREGIDO: Agregada carpeta requisitos/objetivos/ para BReq (Nivel 1)** |
| **v2.0.6** | **CORREGIDO: Eliminado error "BReq implícito en META_04"** |
| **v2.0.6** | **AGREGADO: Sección completa de Business Requirements (BReq)** |
| **v2.0.6** | **ACTUALIZADO: Jerarquía completa 4 niveles según FND_05** |
| **v2.0.6** | **NOTA: FND_04 pendiente recreación (archivo corrupto)** |

---

## 1. ESTRUCTURA COMPLETA DEL SISTEMA DOCUMENTAL

### 1.1 Fórmula del Modelo

```
5 DOMINIOS + 22 SUBDOMINIOS + 6 SUBCARPETAS ORGANIZATIVAS
```

### 1.2 Los 5 Dominios

| # | Dominio | Propósito | Prefijos |
|---|---------|-----------|----------|
| 1 | base_cognitiva/ | Conocimiento fundamental | META, GLOS, FND, SBVR, TXM, MTM, METH |
| 2 | requisitos/ | Especificación del sistema | BReq, BR, UC, FR, NFR |
| 3 | arquitectura_tecnica/ | Diseño e implementación | MOD, ADR, VIEW, API, CNST, FD |
| 4 | normativa/ | Estándares y políticas | STD, PROC, POL, TPL |
| 5 | evidencia/ | Verificación y trazabilidad | TST, RTM, COV |

### 1.3 Jerarquía de 4 Niveles (Alineación FND_05)

> **IMPORTANTE (v2.0.6):**
> 
> IACT implementa la jerarquía completa de 4 niveles definida en FND_05:
> 
> | Nivel | Tipo | Ubicación | Pregunta que responde |
> |-------|------|-----------|----------------------|
> | 0 | BR (Business Rules) | requisitos/reglas_negocio/ | ¿Por qué esta restricción? |
> | 1 | BReq (Business Requirements) | requisitos/objetivos/ | ¿Por qué este proyecto? |
> | 2 | UC (Use Cases) | requisitos/casos_uso/ | ¿Qué hace el usuario? |
> | 3 | FR (Functional Requirements) | requisitos/funcionales/ | ¿Cómo lo hace el sistema? |
> 
> Ver: FND_05_Jerarquia_4_Niveles.rst para teoría completa.

### 1.4 Clarificación: _metadata/ vs BReq

| Artefacto | Propósito | NO ES |
|-----------|-----------|-------|
| META_04_Contexto_IACT | Describe el ambiente y contexto del proyecto | BReq |
| BReq_001_Objetivos_IACT | Define objetivos de negocio medibles | Contexto |

**META_04** = Descripción del ambiente (quién usa, dónde opera, qué existe)
**BReq** = Objetivos medibles (reducir X en Y%, lograr Z)

---

## 2. ÁRBOL COMPLETO v2.0.6

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
│   │   ├── FND_04_Trazabilidad.rst              # ⚠️ PENDIENTE RECREAR
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
│ Propósito: Especificación del sistema (4 niveles: BR → BReq → UC → FR)
│ ═══════════════════════════════════════════════════════════════════
│
├── requisitos/
│   │
│   ├── index.rst
│   │
│   ├── objetivos/                               # 🆕 NUEVO v2.0.6 - Nivel 1 BReq
│   │   ├── index.rst
│   │   └── BReq_001_Objetivos_IACT.rst
│   │
│   ├── reglas_negocio/                          # [DESCONGELADO] Nivel 0 - 20 BR
│   │   ├── index.rst
│   │   │
│   │   │   # TIPO: RESTRICCIÓN (Deóntica - DEBE/NO DEBE) [9 BR]
│   │   ├── BR_001_Fuente_Inmutable.rst
│   │   ├── BR_004_Comunicaciones_Internas.rst
│   │   ├── BR_005_Sesion_Unica.rst
│   │   ├── BR_007_Separacion_Funciones_SoD.rst
│   │   ├── BR_008_Permisos_Vencimiento.rst
│   │   ├── BR_009_Bajas_Logicas.rst
│   │   ├── BR_010_Auditoria_Inmutable.rst
│   │   ├── BR_011_Limites_Exportacion.rst
│   │   ├── BR_020_Rango_Temporal_Reportes.rst
│   │   │
│   │   │   # TIPO: HECHO (Aléctica - ES/TIENE) [4 BR]
│   │   ├── BR_006_RBAC_Flat_NIST.rst
│   │   ├── BR_012_Usuario_Segmento_Unico.rst
│   │   ├── BR_013_Username_Unico.rst
│   │   ├── BR_019_Clasificacion_Datos.rst
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
│   ├── casos_uso/                               # [DESCONGELADO] Nivel 2 - 49 UC
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
│   │   ├── reports/                             # MOD_Reports: UC-017 a UC-030
│   │   │   ├── UC_017_Reporte_Trimestral.rst
│   │   │   ├── UC_018_Reporte_Problemas_Menu.rst
│   │   │   ├── UC_019_Reporte_Transferencias.rst
│   │   │   ├── UC_020_Filtro_Fecha.rst
│   │   │   ├── UC_021_Filtro_Centro.rst
│   │   │   ├── UC_022_Exportar_CSV.rst
│   │   │   ├── UC_023_Exportar_Excel.rst
│   │   │   ├── UC_024_Exportar_PDF.rst
│   │   │   ├── UC_025_Dashboard_Principal.rst
│   │   │   ├── UC_026_Tendencias_Temporales.rst
│   │   │   ├── UC_027_Graficos_Hora.rst
│   │   │   ├── UC_028_Graficos_Dia.rst
│   │   │   ├── UC_029_Distribucion_Centro.rst
│   │   │   └── UC_030_Personalizar_Dashboard.rst
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
│   ├── funcionales/                             # [DESCONGELADO] Nivel 3 - ~400 FR
│   │   ├── index.rst
│   │   ├── auth/
│   │   │   └── FR_UC001_Inicio_Sesion.rst
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
ENDOFPART2
echo "Parte 2 creada: $(wc -l < /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte2.md) líneas"
Output

Parte 2 creada: 238 líneas

cat > /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte3.md << 'ENDOFPART3'
---

## 4. JERARQUÍA DE DERIVACIÓN (4 Niveles Completos)

### 4.1 Diagrama de Jerarquía (FND_05 + MTM_01)

```
NIVEL 0              NIVEL 1              NIVEL 2           NIVEL 3
┌─────────┐         ┌─────────┐          ┌─────────┐       ┌─────────┐
│   BR    │─influye─►│  BReq   │──genera──►│   UC    │──────►│   FR    │
│ Regla   │         │Objetivo │          │  Caso   │deriva │ Funcional│
│ Negocio │         │ Negocio │          │   Uso   │       │          │
└────┬────┘         └─────────┘          └────┬────┘       └────┬────┘
     │                                        │                 │
     │                                        │                 │
     │ genera (si Trigger)                    │ satisface       │ implementa
     │                                        ▼                 ▼
     │                                   ┌─────────┐       ┌─────────┐
     └───────────────────────────────────►│   UC    │       │  CODE   │
                                         └─────────┘       └────┬────┘
                                                                │
                                                                │ verifica
                                                                ▼
                                                           ┌─────────┐
                                                           │  TEST   │
                                                           └─────────┘
```

### 4.2 Tipos de Enlaces (MTM_02)

| Enlace | Origen | Destino | Semántica | Cardinalidad |
|--------|--------|---------|-----------|--------------|
| influye | BR | BReq | BR afecta objetivo sin generar | 0..* : 0..* |
| genera | BReq | UC | Objetivo genera casos de uso | 1 : 1..* |
| genera | BR (Trigger) | UC | BR Desencadenador genera UC | 0..1 : 0..1 |
| deriva | UC | FR | Cada paso "Sistema" genera FR | 1 : 1..* |
| implementa | FR | CODE | FR se codifica | 1 : 0..* |
| verifica | TEST | FR | Test valida FR | 1..* : 1 |

### 4.3 Preguntas por Nivel (FND_05)

| Nivel | Tipo | Pregunta Clave | Responsable |
|-------|------|----------------|-------------|
| 0 | BR | ¿Por qué esta restricción? | Stakeholders, Legal |
| 1 | BReq | ¿Por qué este proyecto? | Product Owner |
| 2 | UC | ¿Qué hace el usuario? | Business Analyst |
| 3 | FR | ¿Cómo lo hace el sistema? | BA + Arquitecto |

### 4.4 Ratio de Derivación Esperado

```
Típico según FND_05:
  5-20 BR → 3-10 BReq → 30-100 UC → 200-1000 FR

IACT v2.0.6:
  20 BR → 5 BReq → 49 UC → ~400 FR (estimado)
  
Ratios:
  BR : BReq = 4:1 (20/5)
  BReq : UC = 1:10 (5/49)
  UC : FR = 1:8 (49/~400)
```

---

## 5. TIPOS DE BUSINESS RULES (TXM_03)

### 5.1 Los 5 Tipos

| Tipo | Modalidad | ¿Genera UC? | Patrón | Cantidad |
|------|-----------|-------------|--------|----------|
| **Hecho** | Aléctica | NO | "[X] ES/TIENE [Y]" | 4 |
| **Restricción** | Deóntica | Parcial | "[X] DEBE/NO DEBE [Y]" | 9 |
| **Desencadenador** | Deóntica | **SÍ** | "SI [cond] ENTONCES [acción visible]" | 3 |
| **Inferencia** | Aléctica | NO | "SI [cond] ENTONCES [estado interno]" | 1 |
| **Cálculo** | Aléctica | NO | "[Resultado] = [fórmula]" | 3 |
| **TOTAL** | | | | **20** |

### 5.2 Template BR (Referencias: FND_02, TPL_001)

**Campos Obligatorios:**

| Campo | Descripción |
|-------|-------------|
| ID | BR_NNN formato |
| Nombre | Título descriptivo |
| Definición | Texto completo en lenguaje natural |
| Tipo | Fact, Constraint, Trigger, Inference, Calculation |
| Modalidad | Aléctica o Deóntica |
| Fuente | Documento origen (CNST, política, etc.) |
| Fecha Vigencia | YYYY-MM-DD |

**Campos Adicionales:**

| Campo | Descripción |
|-------|-------------|
| Prioridad | Alta / Media / Baja |
| Estática/Dinámica | Ley (estática) vs Política (dinámica) |
| Justificación | Razón de negocio |
| Ejemplo | Caso concreto de aplicación |

### 5.3 Catálogo Completo de BR v2.0.6

| BR | Nombre | Tipo | CNST | Funciones RBAC |
|----|--------|------|------|----------------|
| BR_001 | Fuente Inmutable | Restricción | CNST_003 | PIP-001, RPT-001 |
| BR_002 | ETL Batch Nocturno | Desencadenador | CNST_004 | PIP-001 a PIP-004 |
| BR_003 | Usuario Inactivo 90d | Inferencia | -- | USR-009 |
| BR_004 | Comunicaciones Internas | Restricción | CNST_001 | AUT-003, ALR-002 |
| BR_005 | Sesión Única | Restricción | CNST_002 | AUT-001, AUT-002, AUT-004 |
| BR_006 | RBAC Flat NIST | Hecho | CNST_005 | ACC-001 a ACC-006 |
| BR_007 | Separación Funciones SoD | Restricción | CNST_005 | ACC-005 |
| BR_008 | Permisos con Vencimiento | Restricción | CNST_005 | ACC-001 |
| BR_009 | Bajas Lógicas | Restricción | CNST_005 | USR-004 |
| BR_010 | Auditoría Inmutable | Restricción | CNST_009 | AUD-001 a AUD-004 |
| BR_011 | Límites Exportación | Restricción | CNST_007 | RPT-004, RPT-005, RPT-006 |
| BR_012 | Usuario-Segmento Único | Hecho | -- | USR-010, ACC-006 |
| BR_013 | Username Único | Hecho | -- | USR-001 |
| BR_014 | Alerta por Umbral | Desencadenador | -- | ALR-002 |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | CNST_005 | AUT-001 |
| BR_016 | Tasa Abandono | Cálculo | -- | RPT-007 |
| BR_017 | Tiempo Promedio Espera | Cálculo | -- | RPT-007 |
| BR_018 | Índice Eficiencia | Cálculo | -- | RPT-007 |
| BR_019 | Clasificación Datos | Hecho | CNST_010 | ACC-006 |
| BR_020 | Rango Temporal Reportes | Restricción | CNST_007 | RPT-001, RPT-003 |

### 5.4 Detalle de BR Clave

#### BR_006: RBAC Flat NIST

**Declaración:** El sistema IACT implementa un modelo RBAC Flat basado en NIST.

| Componente | Cantidad | Descripción |
|------------|----------|-------------|
| Funciones Atómicas | 44 | Distribuidas en 8 módulos |
| Agrupadores | 10 | AGR-001 a AGR-010 |
| Segmentos | 5 | OP, FI, TE, SU, CA |
| Restricciones SoD | 3 | SOD-001, SOD-002, SOD-003 |

**Filosofía "Sin Pretensiones":**
- ✅ `crea_usuarios`, `ve_reportes`, `exporta_csv`
- ❌ `USERS_FULL_MANAGER`, `SYSTEM_ADMIN`

#### BR_007: Separación Funciones SoD

**Restricciones SoD Obligatorias:**

| ID | Grupo A | Grupo B | Razón |
|----|---------|---------|-------|
| SOD-001 | PIP-001 a PIP-004 | AUD-001 a AUD-004 | Quien opera NO audita |
| SOD-002 | USR-001, USR-003, USR-004, USR-007 | AUD-001 a AUD-003 | Quien gestiona usuarios NO audita |
| SOD-003 | ACC-001, ACC-002, ACC-005 | AUD-001, AUD-002 | Quien gestiona acceso NO audita |

### 5.5 Árbol de Decisión para Clasificar BR

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
ENDOFPART3
echo "Parte 3 creada: $(wc -l < /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte3.md) líneas"
Output

Parte 3 creada: 168 líneas


bash

cat > /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte4.md << 'ENDOFPART4'
---

## 6. LOS 8 MÓDULOS FUNCIONALES

### 6.1 Catálogo de Módulos

| Código | Nombre | App Django | UC Asociados | Funciones RBAC |
|--------|--------|------------|--------------|----------------|
| MOD_Auth | Auth | apps.auth | UC-001 a UC-005 | AUT-001 a AUT-004 |
| MOD_Users | Users | apps.users | UC-006 a UC-009 | USR-001 a USR-010 |
| MOD_Access | Access | apps.access | UC-010, UC-011, UC-041-047 | ACC-001 a ACC-006 |
| MOD_Pipeline | Pipeline | apps.pipeline | UC-050 a UC-053 | PIP-001 a PIP-004 |
| MOD_Reports | Reports | apps.reports | UC-017 a UC-030 | RPT-001 a RPT-008 |
| MOD_Alerts | Alerts | apps.alerts | UC-036 a UC-040 | ALR-001 a ALR-006 |
| MOD_Audit | Audit | apps.audit | UC-060 a UC-063 | AUD-001 a AUD-004 |
| MOD_Logs | Logs | apps.logs | UC-070 a UC-072 | LOG-001 a LOG-002 |

### 6.2 Mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1

> **NOTA:** FND_03 define actores como Roles (R001-R018). 
> RBAC v5.1.1 usa Agrupadores (AGR-001 a AGR-010) con filosofía "Sin Pretensiones".

| Actor FND_03 | Rol Legacy | Agrupador RBAC | Funciones |
|--------------|------------|----------------|-----------|
| Gestión Usuarios | R001 | AGR-001 administrador_usuarios | USR-001 a USR-010 |
| Visor Usuarios | R002 | AGR-002 visor_usuarios | USR-005, USR-006 |
| Reportes | R004-R007 | AGR-003 analista_reportes | RPT-001 a RPT-008 |
| Dashboard | R008-R009 | AGR-004 visor_dashboard | RPT-001, RPT-007, RPT-008 |
| Alertas | R011-R014 | AGR-005 gestor_alertas | ALR-001 a ALR-006 |
| Supervisor | R003 | AGR-006 supervisor_equipo | USR-005/06, RPT-001/07 |
| Auditor | R017 | AGR-007 auditor | AUD-001 a AUD-004 |
| Admin Seguridad | R018 | AGR-008 admin_seguridad | ACC-001 a ACC-006 |
| Admin Sistema | R016 | AGR-009 admin_sistema | PIP-*, LOG-*, config |
| Operador ETL | (nuevo) | AGR-010 operador_etl | PIP-001 a PIP-004 |

**Uso en UC:** Actor Primario = Agrupador (ej: `AGR-001 administrador_usuarios`)

### 6.3 SEC_RULES (Integrado en MOD_Access)

SEC_RULES NO es módulo separado. Es subcapa interna de MOD_Access:

| Componente | Visibilidad | Descripción |
|------------|-------------|-------------|
| RBAC_CORE | Usuario ve UI | Administración roles/permisos |
| SEC_RULES | Automático | Enforcement middleware/decoradores |

---

## 7. MÉTRICAS DE COBERTURA RTM

### 7.1 Umbrales Mínimos IACT

| Cobertura | Umbral | Fórmula |
|-----------|--------|---------|
| BReq → UC | 100% | BReq con UC derivados / Total BReq |
| BR → UC | 100% | BR con impacto / Total BR |
| UC → FR | 100% | UC con FR derivados / Total UC |
| FR → CODE | 90% | FR implementados / Total FR |
| FR → TEST | 80% | FR con test / Total FR |

> **REFERENCIA:** Ver FND_07 para criterios SMART que cada FR debe cumplir.

### 7.2 Estado Actual v2.0.6

| Métrica | Valor | Estado |
|---------|-------|--------|
| BReq identificados | 5 | ✅ Completo |
| BR identificadas | 20 | ✅ Completo |
| UC identificados | 49 | ✅ Completo |
| FR derivados | 0 | ❌ Pendiente |
| Cobertura BReq→UC | 100% | ✅ Verificado |
| Cobertura BR→UC | Pendiente | ⏳ RTM |
| Cobertura CNST→BR | 100% | ✅ Completo |

---

## 8. MAPEO CNST → BR

### 8.1 Matriz de Cobertura Completa

| CNST | Descripción | BR Derivada | Tipo BR |
|------|-------------|-------------|---------|
| CNST_001 | Sin email | BR_004 | Restricción |
| CNST_002 | Sesiones BD | BR_005 | Restricción |
| CNST_003 | BD readonly | BR_001 | Restricción |
| CNST_004 | ETL batch | BR_002 | Desencadenador |
| CNST_005 | RBAC/Seguridad | BR_006, BR_007, BR_008, BR_009, BR_015 | Varios |
| CNST_006 | Antipatrones | ➖ NO genera BR | → STD_001 |
| CNST_007 | Límites/Performance | BR_011, BR_020 | Restricción |
| CNST_008 | Infraestructura | ➖ NO genera BR | → PROC_004 |
| CNST_009 | Auditoría | BR_010 | Restricción |
| CNST_010 | Clasificación datos | BR_019 | Hecho |

### 8.2 Resumen

```
CNST que generan BR:     8/10 (80%)
CNST que no aplican:     2/10 (20%) → normativa/
Cobertura efectiva:      100%
```

---

## 9. MAPEO BR → FUNCIONES RBAC v5.1.1

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
ENDOFPART4
echo "Parte 4 creada: $(wc -l < /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte4.md) líneas"
Output

Parte 4 creada: 125 líneas

bash

cat > /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte5.md << 'ENDOFPART5'
---

## 10. CATÁLOGO DE PREFIJOS

### 10.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| requisitos | BReq, BR, UC, FR, NFR | ~475 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~45 |
| normativa | STD, PROC, POL, TPL | ~15 |
| evidencia | TST, RTM, COV | ~12 |
| **TOTAL** | -- | **~572** |

### 10.2 Nomenclatura de Archivos

```
[PREFIJO]_[NNN]_[Nombre_Descriptivo].rst

Ejemplos:
- BReq_001_Objetivos_IACT.rst
- BR_001_Fuente_Inmutable.rst
- UC_010_Asignar_Roles.rst
- MOD_Auth.rst (sin número, nombre único)
```

### 10.3 Caso Especial: FR

```
FR_UC[NNN]_[Nombre_UC].rst

El archivo contiene todos los FR del UC.
Ejemplo: FR_UC010_Asignar_Roles.rst → contiene FR-010.1 a FR-010.N
```

---

## 11. CONTEO DE ARTEFACTOS

### 11.1 Por Estado

| Estado | Cantidad | % |
|--------|----------|---|
| ✅ COMPLETADOS | 24 | 4% |
| ⏳ IDENTIFICADOS | ~105 | 18% |
| ❌ PENDIENTES | ~443 | 78% |
| **TOTAL** | **~572** | 100% |

### 11.2 Completados

| Tipo | Cantidad | Ubicación |
|------|----------|-----------|
| CNST | 10 | arquitectura_tecnica/restricciones/ |
| FND | 7 | base_cognitiva/_fundamentos_conceptuales/ |
| TXM | 3 | base_cognitiva/_taxonomias_y_metamodelos/taxonomias/ |
| MTM | 3 | base_cognitiva/_taxonomias_y_metamodelos/metamodelos/ |
| BReq | 1 | requisitos/objetivos/ |
| **TOTAL** | **24** | -- |

### 11.3 Pendientes Prioritarios

| Tipo | Cantidad | Prioridad |
|------|----------|-----------|
| BReq | 1 (documentar completo) | 🔴 ALTA |
| BR | 20 (documentar) | 🔴 ALTA |
| UC | 49 | 🔴 ALTA |
| FR | ~400 | 🟡 MEDIA |
| MOD | 8 | 🟡 MEDIA |
| TST | ~320 | 🟢 BAJA |

---

## 12. ORDEN DE EJECUCIÓN

### Fase 0: Corrección FND_04 (CRÍTICO)
```
Prioridad: 🔴 CRÍTICA
Archivo: FND_04_Trazabilidad.rst
Estado actual: CORRUPTO (contiene copia de FND_03)
Acción: RECREAR con contenido correcto
```

### Fase 1: Business Requirements (BReq)
```
Prioridad: 🔴 ALTA
Cantidad: 1 documento (5 BReq consolidados)
Ubicación: requisitos/objetivos/
Archivo: BReq_001_Objetivos_IACT.rst
```

### Fase 2: Business Rules (BR)
```
Prioridad: 🔴 ALTA
Cantidad: 20 documentos
Ubicación: requisitos/reglas_negocio/
Template: TPL_001_Plantilla_BR.rst (ver FND_02)
```

### Fase 3: Casos de Uso (UC)
```
Prioridad: 🔴 ALTA
Cantidad: 49 documentos
Ubicación: requisitos/casos_uso/{modulo}/
Template: TPL_002_Plantilla_UC.rst
Actor: Usar Agrupadores (AGR-00x)

Por módulo:
1. auth/ (5 UC)
2. users/ (4 UC)
3. access/ (9 UC)
4. pipeline/ (4 UC)
5. reports/ (14 UC)
6. alerts/ (5 UC)
7. audit/ (4 UC)
8. logs/ (3 UC)
```

### Fase 4: Módulos (MOD)
```
Prioridad: 🟡 MEDIA
Cantidad: 8 documentos
Ubicación: arquitectura_tecnica/modulos/
Template: TPL_006_Plantilla_MOD.rst
```

### Fase 5: Functional Requirements (FR)
```
Prioridad: 🟡 MEDIA
Cantidad: ~400 documentos
Ubicación: requisitos/funcionales/{modulo}/
Template: TPL_003_Plantilla_FR.rst
Criterios: SMART (ver FND_07)
Ratio: 1 UC : 8 FR
```

### Fase 6: Trazabilidad (RTM)
```
Prioridad: 🟡 MEDIA
Cantidad: 2 documentos
Ubicación: evidencia/trazabilidad/
Referencia: FND_04_Trazabilidad.rst (después de recrear)
```

### Fase 7: Tests (TST)
```
Prioridad: 🟢 BAJA
Cantidad: ~320 documentos
Ubicación: evidencia/pruebas/{modulo}/
Meta: 80% cobertura FR→TEST
```

---

## 13. REFERENCIAS A FND

### 13.1 Documentos de Fundamentos Conceptuales

| FND | Título | Uso en Modelo |
|-----|--------|---------------|
| FND_01 | Concepto de Requisito | Base conceptual FR/NFR |
| FND_02 | Reglas de Negocio | Template BR, 5 tipos, campos |
| FND_03 | Casos de Uso | Estructura UC, actores → AGR |
| FND_04 | Trazabilidad | ⚠️ PENDIENTE RECREAR |
| FND_05 | Jerarquía 4 Niveles | BR→BReq→UC→FR |
| FND_06 | Derivación vs Transformación | Proceso derivar UC→FR |
| FND_07 | Requerimientos Funcionales | Criterios SMART, template FR |

### 13.2 Estado de FND

| FND | Versión | Estado | Notas |
|-----|---------|--------|-------|
| FND_01 | 1.0.0 | ✅ OK | -- |
| FND_02 | 1.1.0 | ✅ OK | Referenciado para template BR |
| FND_03 | 1.1.0 | ⚠️ Desalineado | UC: 38 vs 49, Actores: R00x vs AGR |
| FND_04 | -- | 🔴 CORRUPTO | Contiene copia de FND_03 |
| FND_05 | 1.0.0 | ✅ OK | Jerarquía 4 niveles aplicada |
| FND_06 | 1.0.0 | ✅ OK | -- |
| FND_07 | 1.0.0 | ✅ OK | Referenciado para SMART |

---

## 14. ARCHIVOS DE REFERENCIA

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| REFERENCIA_GLOBAL_MODULOS_IACT.md | Fuente para MOD_.rst | /outputs/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo RBAC oficial | /outputs/ |
| ANALISIS_BR_REVISION_INTEGRAL_v1.md | Análisis BR vs RBAC | /outputs/ |
| ANALISIS_FND_vs_MODELO_REVISION_v2.md | Análisis alineación FND | /outputs/ |
| MODELO_DOCUMENTAL_IACT_v2_0_6.md | Este documento | /outputs/ |
ENDOFPART5
echo "Parte 5 creada: $(wc -l < /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte5.md) líneas"
Output

Parte 5 creada: 191 líneas


bash

cat > /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte6.md << 'ENDOFPART6'
---

## 15. RESUMEN DE CAMBIOS v2.0.5 → v2.0.6

### 15.1 Cambios Estructurales

| Cambio | Descripción |
|--------|-------------|
| **AGREGADO** | Nueva carpeta `requisitos/objetivos/` para BReq (Nivel 1) |
| **AGREGADO** | Archivo BReq_001_Objetivos_IACT.rst con 5 BReq |
| **CORREGIDO** | Eliminado error "BReq implícito en META_04" |
| **CORREGIDO** | Clarificación META_04 ≠ BReq |
| **ACTUALIZADO** | Jerarquía muestra 4 niveles completos |
| **ACTUALIZADO** | Diagrama de derivación incluye Nivel 1 |
| **AGREGADO** | Sección 3 completa de Business Requirements |
| **ACTUALIZADO** | Conteo de subdominios: 21 → 22 |
| **ACTUALIZADO** | Prefijos incluyen BReq |

### 15.2 Correcciones Conceptuales

| Error en v2.0.5 | Corrección en v2.0.6 |
|-----------------|---------------------|
| "BReq implícito en META_04" | BReq son objetivos medibles, META_04 es contexto |
| Jerarquía 3 niveles | Jerarquía 4 niveles según FND_05 |
| Sin carpeta objetivos/ | Agregada requisitos/objetivos/ |
| BReq no documentados | 5 BReq identificados y trazados a UC |

### 15.3 Nuevos Artefactos Identificados

| Tipo | Cantidad Nueva | Total |
|------|----------------|-------|
| BReq | +5 | 5 |
| UC (reports) | +2 (UC-026, UC-030) | 49 |
| Subdominios | +1 (objetivos/) | 22 |

### 15.4 Alineación con FND

| FND | Estado v2.0.5 | Estado v2.0.6 |
|-----|---------------|---------------|
| FND_01 | ✅ | ✅ |
| FND_02 | ✅ | ✅ |
| FND_03 | ⚠️ Desalineado | ⚠️ Pendiente actualizar FND |
| FND_04 | 🔴 Corrupto | 🔴 Pendiente recrear |
| FND_05 | ❌ Violado (3 niveles) | ✅ Alineado (4 niveles) |
| FND_06 | ✅ | ✅ |
| FND_07 | ✅ | ✅ |

---

## 16. PRÓXIMOS PASOS

### 16.1 Acciones Inmediatas

```
┌─────────────────────────────────────────────────────────────────┐
│ PRIORIDAD CRÍTICA                                               │
├─────────────────────────────────────────────────────────────────┤
│ 1. Recrear FND_04_Trazabilidad.rst (archivo corrupto)          │
│ 2. Documentar BReq_001_Objetivos_IACT.rst completo             │
│ 3. Actualizar FND_03 a v1.2.0 (49 UC, AGR-00x)                 │
└─────────────────────────────────────────────────────────────────┘
```

### 16.2 Acciones de Seguimiento

```
┌─────────────────────────────────────────────────────────────────┐
│ PRIORIDAD ALTA                                                  │
├─────────────────────────────────────────────────────────────────┤
│ 4. Documentar las 20 BR con template FND_02                    │
│ 5. Documentar los 49 UC por módulo                             │
│ 6. Crear RTM_Master inicial                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 16.3 Validación de Consistencia

Después de completar acciones:

- [ ] FND_04 existe y contiene trazabilidad
- [ ] FND_03 v1.2.0 lista 49 UC
- [ ] FND_03 v1.2.0 usa AGR-00x como actores
- [ ] BReq_001 documenta 5 objetivos
- [ ] Todos BReq tienen trazabilidad a UC
- [ ] Todas BR tienen template FND_02

---

## APÉNDICE A: Contenido Esperado de BReq_001

```rst
====================================
BReq_001: Objetivos de Negocio IACT
====================================

.. meta::
   :artefacto: BReq_001
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0

1. BReq-001: Visibilidad de Métricas IVR
----------------------------------------

**Declaración:**
El Sistema IACT Dashboard Analytics DEBE proporcionar visibilidad 
en tiempo real de las métricas de llamadas del IVR.

**Métrica de Éxito:** Dashboard actualizado cada 5 minutos

**UC Relacionados:** UC-025, UC-026, UC-027, UC-028, UC-029, UC-030

**BR que Influyen:** BR_001, BR_002

---

2. BReq-002: Reducción de Tiempo de Incidentes
----------------------------------------------

**Declaración:**
El Sistema DEBE reducir el tiempo de resolución de incidentes 
operacionales en al menos 40% respecto a la línea base.

**Métrica de Éxito:** Tiempo promedio resolución ≤ 60% del actual

**UC Relacionados:** UC-036, UC-037, UC-038, UC-039, UC-040

**BR que Influyen:** BR_014

---

3. BReq-003: Decisiones Informadas
----------------------------------

**Declaración:**
El Sistema DEBE permitir a los supervisores identificar problemas 
operacionales y tomar decisiones basadas en datos verificables.

**Métrica de Éxito:** 100% decisiones con respaldo de datos

**UC Relacionados:** UC-017 a UC-024

**BR que Influyen:** BR_016, BR_017, BR_018

---

4. BReq-004: Cumplimiento de Seguridad
--------------------------------------

**Declaración:**
El Sistema DEBE garantizar control de acceso basado en roles (RBAC) 
y auditoría completa de todas las operaciones críticas.

**Métrica de Éxito:** 0 accesos no autorizados detectados

**UC Relacionados:** UC-010, UC-011, UC-043-047, UC-060-063

**BR que Influyen:** BR_006, BR_007, BR_010

---

5. BReq-005: Integridad de Datos Operacionales
----------------------------------------------

**Declaración:**
El Sistema DEBE proteger la base de datos operacional (MySQL) 
de cualquier operación de escritura no autorizada.

**Métrica de Éxito:** 0 escrituras desde IACT a MySQL operacional

**UC Relacionados:** UC-050, UC-051, UC-052

**BR que Influyen:** BR_001
```

---

*Modelo Documental IACT v2.0.6*  
*Proyecto: IACT Dashboard Analytics*  
*Fecha: 2026-01-03*  
*Base: TXM_01-03 + MTM_01-03 + MODELO_RBAC_v5.1.1 + CNST_001-010 + FND_01-07*
ENDOFPART6
echo "Parte 6 creada: $(wc -l < /tmp/MODELO_DOCUMENTAL_IACT_v2_0_6_parte6.md) líneas"
Output

Parte 6 creada: 183 líneas





