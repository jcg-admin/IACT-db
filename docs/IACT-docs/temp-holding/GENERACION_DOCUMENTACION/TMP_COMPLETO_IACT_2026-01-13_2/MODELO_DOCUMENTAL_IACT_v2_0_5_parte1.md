# MODELO DOCUMENTAL IACT v2.0.5
## Proyecto IACT Dashboard Analytics

**Versión:** 2.0.5  
**Fecha:** 2026-01-03  
**Base:** Análisis de TXM_01-03, MTM_01-03, MODELO_RBAC_v5.1.1, CNST_001-010, FND_01-07

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
| v2.0.4 | Identificación CNST que NO generan BR (CNST_006, CNST_008) |
| **v2.0.5** | **Documentada decisión: BReq (Nivel 1) implícito en META_04** |
| **v2.0.5** | **Agregada referencia a template BR (TPL_001, FND_02)** |
| **v2.0.5** | **Agregado mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1** |
| **v2.0.5** | **Agregada referencia a criterios SMART (FND_07)** |
| **v2.0.5** | **Nota: FND_04 pendiente de recreación (archivo corrupto)** |

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

### 1.3 Decisión Arquitectónica: Jerarquía de 3 Niveles Operativos

> **NOTA IMPORTANTE (v2.0.5):**
> 
> FND_05 define una jerarquía de 4 niveles: BR → BReq → UC → FR
> 
> Para IACT, implementamos **3 niveles operativos**: BR → UC → FR
> 
> **Justificación:** El Nivel 1 (BReq - Business Requirements) está implícito
> en META_04_Contexto_IACT.rst. IACT es un proyecto interno donde los objetivos
> de negocio están documentados en el contexto del proyecto, no requieren
> formalización separada como artefactos BReq_NNN.
> 
> Ver: FND_05_Jerarquia_4_Niveles.rst para la teoría completa.

---

## 2. ÁRBOL COMPLETO v2.0.5

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
│   │   ├── META_04_Contexto_IACT.rst            # ← Contiene BReq implícitos
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
│ Propósito: Especificación del sistema (BR → UC → FR)
│ Nota: BReq (Nivel 1) está implícito en META_04_Contexto_IACT
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
│   ├── funcionales/                             # [DESCONGELADO] ~400 FR
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
