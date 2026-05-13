## ÁRBOL COMPLETO v2.0.6

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

