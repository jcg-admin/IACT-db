# ANEXO A: ÁRBOL COMPLETO DEL MODELO DOCUMENTAL IACT v2.2.0

**Versión:** 2.2.0  
**Fecha:** 2026-01-07  
**Propósito:** Árbol detallado con todos los artefactos del proyecto IACT

---

## A.1 VISIÓN GENERAL

| Dominio | Subdominios | Artefactos Principales |
|---------|-------------|------------------------|
| base_cognitiva | 6 | META, GLOS, FND, SBVR, TXM, MTM, METH |
| requisitos | 5 | BReq, BR, UC, FR, NFR |
| arquitectura_tecnica | 7 | MOD, CNST, ADR, VIEW, FD, API, MDL |
| normativa | 3 | STD, PROC (38), POL, TPL (17) |
| evidencia | 2 | TST, RTM, COV |

---

## A.2 ÁRBOL COMPLETO

```
IACT/
│
├── conf.py
├── index.rst
├── Makefile
├── requirements.txt
│
│ ═══════════════════════════════════════════════════════════════════════════════
│ DOMINIO 1: BASE COGNITIVA
│ ═══════════════════════════════════════════════════════════════════════════════
│
├── base_cognitiva/
│   ├── index.rst
│   │
│   ├── _metadata/                                    # [PRIVADO] 5 META
│   │   ├── META_01_Identidad_Proyecto.rst
│   │   ├── META_02_Clasificacion_Documental.rst
│   │   ├── META_03_Fases_SDLC.rst
│   │   ├── META_04_Contexto_IACT.rst
│   │   └── META_05_Estructura_Documental.rst
│   │
│   ├── glosario/                                     # [CONGELADO] 1 GLOS
│   │   └── GLOS_001_Glosario_IACT.rst
│   │
│   ├── _fundamentos_conceptuales/                    # [PRIVADO] 7 FND
│   │   ├── FND_01_Concepto_Requisito.rst
│   │   ├── FND_02_Reglas_de_Negocio.rst
│   │   ├── FND_03_Casos_de_Uso.rst
│   │   ├── FND_04_Trazabilidad.rst
│   │   ├── FND_05_Jerarquia_5_Niveles.rst
│   │   ├── FND_06_Derivacion_vs_Transformacion.rst
│   │   └── FND_07_Requerimientos_Funcionales.rst
│   │
│   ├── _ontologia_sbvr/                              # [PRIVADO] 5 SBVR
│   │   ├── SBVR_01_Conceptos_Nucleares.rst
│   │   ├── SBVR_02_Fact_Types.rst
│   │   ├── SBVR_03_Reglas_Estructurales.rst
│   │   ├── SBVR_04_Reglas_Operativas.rst
│   │   └── SBVR_05_Vocabulario_Controlado.rst
│   │
│   ├── _taxonomias_y_metamodelos/                    # [PRIVADO]
│   │   ├── taxonomias/                               # 3 TXM
│   │   │   ├── TXM_01_Taxonomia_Requisitos.rst
│   │   │   ├── TXM_02_Taxonomia_Artefactos.rst
│   │   │   └── TXM_03_Taxonomia_Reglas_Negocio.rst
│   │   └── metamodelos/                              # 3 MTM
│   │       ├── MTM_01_Metamodelo_Requisitos.rst
│   │       ├── MTM_02_Metamodelo_Trazabilidad.rst
│   │       └── MTM_03_Metamodelo_RBAC.rst
│   │
│   └── _metodologias_analiticas/                     # [PRIVADO] 3 METH
│       ├── METH_01_Derivacion_UC_desde_BR.rst
│       ├── METH_02_Derivacion_FR_desde_UC.rst
│       └── METH_03_Tecnicas_Larman.rst
│
│
│ ═══════════════════════════════════════════════════════════════════════════════
│ DOMINIO 2: REQUISITOS
│ ═══════════════════════════════════════════════════════════════════════════════
│
├── requisitos/
│   ├── index.rst
│   │
│   ├── objetivos_negocio/                            # [DESCONGELADO] 8 BReq
│   │   ├── index.rst
│   │   ├── BReq_AUTH_Autenticacion.rst
│   │   ├── BReq_USR_Gestion_Usuarios.rst
│   │   ├── BReq_ACC_Control_Acceso.rst
│   │   ├── BReq_PIP_Pipeline_Datos.rst
│   │   ├── BReq_RPT_Reporteria.rst
│   │   ├── BReq_ALR_Alertas.rst
│   │   ├── BReq_AUD_Auditoria.rst
│   │   └── BReq_LOG_Bitacoras.rst
│   │
│   ├── reglas_negocio/                               # [CONGELADO] 20 BR
│   │   ├── index.rst
│   │   ├── BR_001_Fuente_Operacional_Inmutable.rst
│   │   ├── BR_002_ETL_Batch_Nocturno.rst
│   │   ├── BR_003_Usuario_Inactivo_90_Dias.rst
│   │   ├── BR_004_Comunicaciones_Internas_Only.rst
│   │   ├── BR_005_Sesion_Unica_Por_Usuario.rst
│   │   ├── BR_006_RBAC_Flat_NIST.rst
│   │   ├── BR_007_Separacion_Funciones_SoD.rst
│   │   ├── BR_008_Auditoria_Accesos.rst
│   │   ├── BR_009_Bajas_Logicas.rst
│   │   ├── BR_010_Auditoria_Inmutable.rst
│   │   ├── BR_011_Limites_Exportacion.rst
│   │   ├── BR_012_Usuario_Segmento_Unico.rst
│   │   ├── BR_013_Username_Unico.rst
│   │   ├── BR_014_Alerta_Por_Umbral.rst
│   │   ├── BR_015_Bloqueo_Intentos_Fallidos.rst
│   │   ├── BR_016_Tasa_Abandono.rst
│   │   ├── BR_017_Tiempo_Promedio_Espera.rst
│   │   ├── BR_018_Indice_Eficiencia.rst
│   │   ├── BR_019_Retencion_2_Anios.rst
│   │   └── BR_020_Clasificacion_Datos.rst
│   │
│   ├── casos_uso/                                    # [DESCONGELADO] 49 UC v4.0
│   │   ├── index.rst
│   │   ├── _actores.rst
│   │   ├── _glosario_uc.rst
│   │   ├── _restricciones_aplicables.rst
│   │   ├── _plantilla_uc.rst
│   │   ├── _estilos_plantuml.iuml
│   │   │
│   │   ├── auth/                                     # MOD_Auth: 5 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_AUTH_01_Iniciar_Sesion.rst
│   │   │   ├── UC_AUTH_02_Cerrar_Sesion.rst
│   │   │   ├── UC_AUTH_03_Recuperar_Contrasena.rst
│   │   │   ├── UC_AUTH_04_Cambiar_Contrasena.rst
│   │   │   └── UC_AUTH_05_Gestionar_Sesiones.rst
│   │   │
│   │   ├── users/                                    # MOD_Users: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_USR_01_Crear_Usuario.rst
│   │   │   ├── UC_USR_02_Modificar_Usuario.rst
│   │   │   ├── UC_USR_03_Desactivar_Usuario.rst
│   │   │   └── UC_USR_04_Listar_Usuarios.rst
│   │   │
│   │   ├── access/                                   # MOD_Access: 9 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_ACC_01_Asignar_Rol.rst
│   │   │   ├── UC_ACC_02_Revocar_Rol.rst
│   │   │   ├── UC_ACC_03_Gestionar_Funciones.rst
│   │   │   ├── UC_ACC_04_Gestionar_Agrupadores.rst
│   │   │   ├── UC_ACC_05_Configurar_SoD.rst
│   │   │   ├── UC_ACC_06_Asignar_Segmento.rst
│   │   │   ├── UC_ACC_07_Consultar_Permisos_Efectivos.rst
│   │   │   ├── UC_ACC_08_Gestionar_Permisos_Temporales.rst
│   │   │   └── UC_ACC_09_Auditar_Cambios_Acceso.rst
│   │   │
│   │   ├── pipeline/                                 # MOD_Pipeline: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_PIP_01_Monitorear_ETL.rst
│   │   │   ├── UC_PIP_02_Consultar_Errores_ETL.rst
│   │   │   ├── UC_PIP_03_Consultar_Disponibilidad.rst
│   │   │   └── UC_PIP_04_Solicitar_Reproceso.rst
│   │   │
│   │   ├── reports/                                  # MOD_Reports: 14 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_RPT_01_Ver_Dashboard_Principal.rst
│   │   │   ├── UC_RPT_02_Filtrar_por_Fecha.rst
│   │   │   ├── UC_RPT_03_Filtrar_por_Centro.rst
│   │   │   ├── UC_RPT_04_Ver_Grafico_por_Hora.rst
│   │   │   ├── UC_RPT_05_Ver_Grafico_por_Dia.rst
│   │   │   ├── UC_RPT_06_Ver_Distribucion_por_Centro.rst
│   │   │   ├── UC_RPT_07_Generar_Reporte_Trimestral.rst
│   │   │   ├── UC_RPT_08_Generar_Reporte_Problemas_Menu.rst
│   │   │   ├── UC_RPT_09_Generar_Reporte_Transferencias.rst
│   │   │   ├── UC_RPT_10_Exportar_CSV.rst
│   │   │   ├── UC_RPT_11_Exportar_Excel.rst
│   │   │   ├── UC_RPT_12_Exportar_PDF.rst
│   │   │   ├── UC_RPT_13_Programar_Reporte.rst
│   │   │   └── UC_RPT_14_Compartir_Dashboard.rst
│   │   │
│   │   ├── alerts/                                   # MOD_Alerts: 5 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_ALR_01_Crear_Alerta.rst
│   │   │   ├── UC_ALR_02_Modificar_Alerta.rst
│   │   │   ├── UC_ALR_03_Eliminar_Alerta.rst
│   │   │   ├── UC_ALR_04_Consultar_Historial_Alertas.rst
│   │   │   └── UC_ALR_05_Gestionar_Destinatarios.rst
│   │   │
│   │   ├── audit/                                    # MOD_Audit: 4 UC
│   │   │   ├── index.rst
│   │   │   ├── UC_AUD_01_Consultar_Auditoria.rst
│   │   │   ├── UC_AUD_02_Buscar_Auditoria.rst
│   │   │   ├── UC_AUD_03_Exportar_Auditoria.rst
│   │   │   └── UC_AUD_04_Generar_Reporte_Compliance.rst
│   │   │
│   │   └── logs/                                     # MOD_Logs: 4 UC
│   │       ├── index.rst
│   │       ├── UC_LOG_01_Consultar_Logs.rst
│   │       ├── UC_LOG_02_Filtrar_Logs.rst
│   │       ├── UC_LOG_03_Exportar_Logs.rst
│   │       └── UC_LOG_04_Configurar_Retencion.rst
│   │
│   ├── funcionales/                                  # [EN PROGRESO] 55/~392 FR
│   │   ├── index.rst
│   │   │
│   │   ├── auth/                                     # 21 FR ✅
│   │   │   ├── index.rst
│   │   │   ├── UC_AUTH_01/
│   │   │   │   ├── FR_UC_AUTH_01_01_Validar_Username.rst
│   │   │   │   ├── FR_UC_AUTH_01_02_Validar_Password.rst
│   │   │   │   ├── FR_UC_AUTH_01_03_Verificar_Credenciales.rst
│   │   │   │   ├── FR_UC_AUTH_01_04_Generar_Token_JWT.rst
│   │   │   │   └── FR_UC_AUTH_01_05_Registrar_Evento_Login.rst
│   │   │   ├── UC_AUTH_02/
│   │   │   │   ├── FR_UCAUTH_02_01_Invalidar_Token.rst
│   │   │   │   ├── FR_UCAUTH_02_02_Registrar_Logout.rst
│   │   │   │   └── FR_UCAUTH_02_03_Limpiar_Sesion.rst
│   │   │   ├── UC_AUTH_03/
│   │   │   │   └── ... (5 FR)
│   │   │   ├── UC_AUTH_04/
│   │   │   │   └── ... (4 FR)
│   │   │   └── UC_AUTH_05/
│   │   │       └── ... (4 FR)
│   │   │
│   │   ├── users/                                    # 17 FR ✅
│   │   │   ├── index.rst
│   │   │   ├── UC_USR_01/
│   │   │   │   └── ... (5 FR)
│   │   │   ├── UC_USR_02/
│   │   │   │   └── ... (4 FR)
│   │   │   ├── UC_USR_03/
│   │   │   │   └── ... (4 FR)
│   │   │   └── UC_USR_04/
│   │   │       └── ... (4 FR)
│   │   │
│   │   ├── access/                                   # 17 FR 🔄 (parcial)
│   │   │   ├── index.rst
│   │   │   ├── UC_ACC_01/
│   │   │   │   └── ... (4 FR)
│   │   │   ├── UC_ACC_02/
│   │   │   │   └── ... (3 FR)
│   │   │   ├── UC_ACC_05/
│   │   │   │   └── ... (5 FR)
│   │   │   ├── UC_ACC_06/
│   │   │   │   └── ... (3 FR)
│   │   │   └── UC_ACC_09/
│   │   │       └── ... (2 FR)
│   │   │
│   │   ├── pipeline/                                 # 0 FR ⏳
│   │   │   └── index.rst
│   │   │
│   │   ├── reports/                                  # 0 FR ⏳
│   │   │   └── index.rst
│   │   │
│   │   ├── alerts/                                   # 0 FR ⏳
│   │   │   └── index.rst
│   │   │
│   │   ├── audit/                                    # 0 FR ⏳
│   │   │   └── index.rst
│   │   │
│   │   └── logs/                                     # 0 FR ⏳
│   │       └── index.rst
│   │
│   └── no_funcionales/                               # [CONGELADO] ~20 NFR
│       ├── index.rst
│       ├── NFR_PERF_001_Tiempo_Respuesta.rst
│       ├── NFR_PERF_002_Throughput.rst
│       ├── NFR_SEC_001_Cifrado_Datos.rst
│       └── ... (demás NFR)
```

---

*Continúa en Parte 2: Dominios 3-5*
