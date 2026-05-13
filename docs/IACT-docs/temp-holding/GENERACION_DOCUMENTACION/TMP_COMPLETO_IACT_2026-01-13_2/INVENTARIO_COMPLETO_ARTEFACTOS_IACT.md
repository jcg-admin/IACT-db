# INVENTARIO COMPLETO DE ARTEFACTOS IACT
## Análisis de /mnt/user-data/outputs/ vs /tmp/

**Fecha:** 2026-01-13  
**Versión:** 1.0.0  
**Propósito:** Documentar TODOS los artefactos generados y sus diferencias

---

## 1. RESUMEN EJECUTIVO

### 1.1 Totales por Ubicación

| Ubicación | Tipo | Cantidad | Líneas Est. |
|-----------|------|----------|-------------|
| **/mnt/user-data/outputs/** | | | |
| | PROC (.rst) | 39 | ~12,043 |
| | TPL (.rst) | 24 | ~11,474 |
| | Otros .rst (raíz) | 78 | ~47,000+ |
| | Archivos .md | 56 | ~31,000+ |
| | UC en casos_uso_v4/ | 62 | ~23,401 |
| | FR en funcionales/ | 46 | ~9,200+ |
| | BR en reglas_negocio/ | 21 | ~6,300+ |
| **/tmp/** | | | |
| | Archivos .md | 67 | ~35,000+ |
| | PROC en /tmp/procedimientos/ | 7 | ~1,214 |

### 1.2 Hallazgos Clave

| Hallazgo | Impacto |
|----------|---------|
| 🔴 TPL duplicados (nomenclatura antigua + nueva) | 7 archivos redundantes |
| 🔴 PROC con nomenclatura antigua | 1 archivo (PROC_05) |
| 🟡 Archivos en /tmp no copiados a outputs | 7 PROC FASE 5, documentos v2.2.0 |
| 🟡 MODELO_DOCUMENTAL v2.2.0 en partes | No consolidado |
| 🟢 38 PROC nueva nomenclatura | Completo |
| 🟢 17 TPL nueva nomenclatura | Completo |

---

## 2. INVENTARIO DETALLADO: /mnt/user-data/outputs/

### 2.1 PROCEDIMIENTOS (PROC) - 39 archivos

#### Nueva Nomenclatura (38 archivos) ✅

| # | Archivo | Líneas | Categoría |
|---|---------|--------|-----------|
| 1 | PROC_Actualizacion_Modelo_Documental_1_0_0.rst | 389 | Gobernanza |
| 2 | PROC_Aprobacion_Documentos_1_0_0.rst | 402 | Gobernanza |
| 3 | PROC_Auditoria_Documental_1_0_0.rst | 183 | Trazabilidad |
| 4 | PROC_Cambio_Requisitos_1_0_0.rst | 351 | Gobernanza |
| 5 | PROC_Congelamiento_Subdominio_1_0_0.rst | 388 | Gobernanza |
| 6 | PROC_Copiar_Tmp_Outputs_1_0_0.rst | 389 | Transferencia |
| 7 | PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst | 393 | Preparación |
| 8 | PROC_Crear_Plan_Analisis_1_0_0.rst | 150 | Preparación |
| 9 | PROC_Derivacion_BR_UC_1_0_0.rst | 187 | Derivación |
| 10 | PROC_Derivacion_BReq_BR_1_0_0.rst | 177 | Derivación |
| 11 | PROC_Derivacion_FR_CODE_1_0_0.rst | 184 | Derivación |
| 12 | PROC_Derivacion_FR_TST_1_1_0.rst | 440 | Derivación |
| 13 | PROC_Derivacion_UC_FR_1_0_0.rst | 485 | Derivación |
| 14 | PROC_Descongelamiento_Subdominio_1_0_0.rst | 386 | Gobernanza |
| 15 | PROC_Generacion_ADR_1_0_0.rst | 180 | Generación |
| 16 | PROC_Generacion_API_1_0_0.rst | 463 | Generación |
| 17 | PROC_Generacion_BR_1_0_0.rst | 393 | Generación |
| 18 | PROC_Generacion_BReq_1_0_0.rst | 162 | Generación |
| 19 | PROC_Generacion_CNST_1_0_0.rst | 175 | Generación |
| 20 | PROC_Generacion_FD_1_0_0.rst | 164 | Generación |
| 21 | PROC_Generacion_FR_1_0_0.rst | 459 | Generación |
| 22 | PROC_Generacion_Index_1_0_0.rst | 398 | Generación |
| 23 | PROC_Generacion_MOD_1_0_0.rst | 190 | Generación |
| 24 | PROC_Generacion_NFR_1_0_0.rst | 402 | Generación |
| 25 | PROC_Generacion_POL_1_0_0.rst | 165 | Generación |
| 26 | PROC_Generacion_RTM_1_0_0.rst | 446 | Generación |
| 27 | PROC_Generacion_STD_1_0_0.rst | 411 | Generación |
| 28 | PROC_Generacion_TST_1_0_0.rst | 509 | Generación |
| 29 | PROC_Generacion_UC_1_0_0.rst | 441 | Generación |
| 30 | PROC_Generacion_VIEW_1_0_0.rst | 178 | Generación |
| 31 | PROC_Identificar_Gaps_Huerfanos_1_0_0.rst | 184 | Trazabilidad |
| 32 | PROC_Publicacion_Documentacion_1_0_0.rst | 179 | Transferencia |
| 33 | PROC_Revision_Artefactos_1_0_0.rst | 403 | Gobernanza |
| 34 | PROC_Revision_TPL_Previo_Generacion_1_0_0.rst | 355 | Preparación |
| 35 | PROC_Revision_UC_Previo_Derivacion_1_0_0.rst | 375 | Preparación |
| 36 | PROC_Validacion_Sphinx_1_0_0.rst | 175 | Transferencia |
| 37 | PROC_Verificacion_Cobertura_1_0_0.rst | 190 | Trazabilidad |
| 38 | PROC_Versionado_Semantico_1_0_0.rst | 372 | Gobernanza |

**Subtotal nueva nomenclatura: 12,043 líneas**

#### Nomenclatura Antigua (1 archivo) ⚠️

| # | Archivo | Líneas | Acción Requerida |
|---|---------|--------|------------------|
| 1 | PROC_05_Elaboracion_Completa_Requisitos.rst | 1,170 | Revisar si mantener |

**Total PROC: 39 archivos, ~13,213 líneas**

---

### 2.2 TEMPLATES (TPL) - 24 archivos

#### Nueva Nomenclatura (17 archivos) ✅

| # | Archivo | Líneas |
|---|---------|--------|
| 1 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | 512 |
| 2 | TPL_API_Documentacion_API_1_1_0.rst | 893 |
| 3 | TPL_BR_Business_Rules_1_0_0.rst | 531 |
| 4 | TPL_BReq_Objetivos_Negocio_1_0_0.rst | 539 |
| 5 | TPL_CNST_Restricciones_1_0_0.rst | 522 |
| 6 | TPL_FD_Flujos_Datos_1_0_0.rst | 562 |
| 7 | TPL_FR_Requisitos_Funcionales_1_0_0.rst | 428 |
| 8 | TPL_INDEX_Indices_1_0_0.rst | 554 |
| 9 | TPL_MOD_Modulos_1_0_0.rst | 570 |
| 10 | TPL_NFR_No_Funcionales_1_0_0.rst | 577 |
| 11 | TPL_POL_Politicas_1_0_0.rst | 553 |
| 12 | TPL_PROC_Procedimientos_1_0_0.rst | 577 |
| 13 | TPL_RTM_Trazabilidad_1_0_0.rst | 573 |
| 14 | TPL_STD_Estandares_1_0_0.rst | 499 |
| 15 | TPL_TST_Pruebas_1_0_0.rst | 587 |
| 16 | TPL_UC_Casos_de_Uso_2_0_0.rst | 493 |
| 17 | TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst | 528 |

**Subtotal nueva nomenclatura: 9,498 líneas**

#### Nomenclatura Antigua (7 archivos) ⚠️ REDUNDANTES

| # | Archivo | Líneas | Equivalente Nuevo |
|---|---------|--------|-------------------|
| 1 | TPL_001_Plantilla_BR.rst | 328 | TPL_BR_Business_Rules_1_0_0.rst |
| 2 | TPL_002_Plantilla_UC.rst | 436 | TPL_UC_Casos_de_Uso_2_0_0.rst |
| 3 | TPL_002_Plantilla_UC_v2.rst | 493 | TPL_UC_Casos_de_Uso_2_0_0.rst |
| 4 | TPL_003_Plantilla_ADR.rst | 318 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst |
| 5 | TPL_004_Plantilla_CNST.rst | 326 | TPL_CNST_Restricciones_1_0_0.rst |
| 6 | TPL_005_Plantilla_ARQ_MOD.rst | 351 | TPL_MOD_Modulos_1_0_0.rst |
| 7 | TPL_006_Plantilla_FR.rst | 324 | TPL_FR_Requisitos_Funcionales_1_0_0.rst |

**Subtotal nomenclatura antigua: 2,576 líneas (REDUNDANTES)**

**Total TPL: 24 archivos, ~12,074 líneas (7 redundantes)**

---

### 2.3 OTROS ARTEFACTOS RST (78 archivos)

#### Base Cognitiva (27 archivos)

| Tipo | Archivos | Líneas Aprox. |
|------|----------|---------------|
| META_ | 5 | 1,522 |
| FND_ | 9 | 5,626 |
| SBVR_ | 8 | 4,889 |
| TXM_ | 3 | 1,972 |
| MTM_ | 3 | 1,975 |

#### Requisitos (17 archivos en raíz)

| Tipo | Archivos | Líneas Aprox. |
|------|----------|---------------|
| BReq_ | 3 | 1,125 |
| BR_ | 14 | 4,041 |

#### Arquitectura (18 archivos)

| Tipo | Archivos | Líneas Aprox. |
|------|----------|---------------|
| ARQ_MOD_ | 8 | 3,315 |
| CNST_ | 10 | 9,621 |

#### Normativa (11 archivos)

| Tipo | Archivos | Líneas Aprox. |
|------|----------|---------------|
| GOB_ | 10 | 7,794 |
| STD_ | 1 | 340 |

#### Índices y otros (5 archivos)

| Archivo | Líneas |
|---------|--------|
| index.rst | 344 |
| index_plantillas.rst | 304 |
| _fundamentos_conceptuales_index.rst | 203 |
| SBVR_index.rst | 341 |

---

### 2.4 ARCHIVOS MARKDOWN (.md) - 56 archivos

#### MODELO_DOCUMENTAL (11 versiones)

| Archivo | Líneas | Estado |
|---------|--------|--------|
| MODELO_DOCUMENTAL_IACT_v2_0_3.md | 555 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_3_ACTUALIZADO.md | 733 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_4.md | 922 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_5.md | 1,039 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_6.md | 1,189 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_7.md | 1,193 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_8.md | 821 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_0_9.md | 723 | Histórico |
| MODELO_DOCUMENTAL_IACT_v2_1_0.md | 1,068 | Histórico |
| **MODELO_DOCUMENTAL_IACT_v2_1_1.md** | **794** | **ACTUAL** |

#### MODELO_RBAC (3 versiones)

| Archivo | Líneas |
|---------|--------|
| MODELO_RBAC_COMPLETO_v5.0.md | 1,417 |
| MODELO_RBAC_COMPLETO_v5.1.md | 2,522 |
| **MODELO_RBAC_IACT_v5.1.md** | **1,650** |

#### ANÁLISIS (23 archivos)

| Archivo | Líneas |
|---------|--------|
| ANALISIS_BR_REVISION_INTEGRAL_v1.md | 616 |
| ANALISIS_COHERENCIA_FUENTES_OFICIALES.md | 591 |
| ANALISIS_COMPARATIVO_RBAC_v4_vs_BR_IACT.md | 664 |
| ANALISIS_COMPLETO_INCONSISTENCIAS_IACT.md | 281 |
| ANALISIS_COMPLETO_MODELO_OFICIAL.md | 443 |
| ANALISIS_COMPLETO_RBAC_IACT_v4.md | 531 |
| ANALISIS_CORREGIDO_ESTRUCTURA_v2.md | 447 |
| ANALISIS_CRITICO_DESVIACION_Y_DUPLICACION.md | 490 |
| ANALISIS_CRITICO_DISCREPANCIA_FND.md | 282 |
| ANALISIS_DESCOMPOSICION_RBAC_v1_0_0.md | 535 |
| ANALISIS_FND_vs_MODELO_REVISION_v2.md | 532 |
| ANALISIS_FND_vs_MODELO_v2_0_4.md | 516 |
| ANALISIS_NOMENCLATURA_TPL.md | 237 |
| ANALISIS_PROCEDIMIENTOS_PENDIENTES_v2.md | 293 |
| ANALISIS_PROC_COMPLETO_v2.md | 415 |
| ANALISIS_PROFUNDO_ESTADO_ARCHIVOS_IACT.md | 470 |
| ANALISIS_PROFUNDO_METODOLOGIA_UC.md | 695 |
| ANALISIS_PROFUNDO_PROC_05.md | 568 |
| ANALISIS_QUE_SIGUE_SEGUN_METODOLOGIA.md | 262 |
| ANALISIS_REGLAS_NEGOCIO_DESCONGELADO_v2.md | 458 |
| ANALISIS_SUBDOMINIO_ESTANDARES.md | 877 |
| ANALISIS_SUBDOMINIO_GOBERNANZA.md | 627 |
| ANALISIS_SUBDOMINIO_GOBERNANZA_FINAL_v2.md | 620 |

#### PLANES (9 archivos)

| Archivo | Líneas |
|---------|--------|
| PLAN_FR_ANALISIS_REAL_v1_0_0.md | 812 |
| PLAN_FR_v2_PLANTUML_GRANULAR_v1_0_0.md | 410 |
| PLAN_FR_v2_PLANTUML_v1_0_0.md | 456 |
| PLAN_GENERACION_TPL.md | 295 |
| PLAN_MAESTRO_FR_NFR_v1_0_0.md | 800 |
| PLAN_NIVEL_3_FR_v1_0_0.md | 520 |
| PLAN_UC_v2_PLANTUML.md | 531 |
| PLAN_UC_v2_PLANTUML_COMPLETADO.md | 160 |
| PLAN_UC_v2_PLANTUML_v1_1_0.md | 972 |

#### Otros (10 archivos)

| Archivo | Líneas |
|---------|--------|
| CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md | 510 |
| CONSOLIDACION_METODOLOGICA_IACT_v1_0_0.md | 634 |
| DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md | 288 |
| ESTRUCTURA_COMPLETA_FR_ANEXO.md | 602 |
| ESTRUCTURA_COMPLETA_MODELO_DOCUMENTAL_IACT_v2_0_1.md | 638 |
| ESTRUCTURA_COMPLETA_MODELO_DOCUMENTAL_IACT_v2_0_2.md | 810 |
| FASE1_RESUMEN.md | 63 |
| FASE2_RESUMEN.md | 65 |
| PROCESO_MIGRACION_CASOS_DE_USO.md | 389 |
| REFERENCIA_GLOBAL_MODULOS_IACT.md | 663 |
| REPORTE_CORRECCIONES_APLICADAS_IACT.md | 131 |

---

### 2.5 SUBCARPETAS EN /mnt/user-data/outputs/

| Carpeta | Contenido | Archivos |
|---------|-----------|----------|
| casos_uso_v4/ | UC versión 4.0 (actuales) | 62 .rst |
| funcionales/ | FR generados | 46 .rst |
| reglas_negocio/ | BR con index | 21 .rst |
| casos_uso/ | UC versión antigua | Histórico |
| casos_uso_v2/ | UC versión 2 | Histórico |
| objetivos/ | BReq antiguos | Histórico |
| no_funcionales/ | NFR | Pendiente |
| archivos_actualizados_v1.1.0/ | Backup | Histórico |

---

## 3. INVENTARIO DETALLADO: /tmp/

### 3.1 Archivos .md (67 archivos)

#### Documentos v2.2.0 (Pendientes de consolidar) ⚠️

| Archivo | Líneas | Estado |
|---------|--------|--------|
| ANALISIS_ACTUALIZACION_MODELO_v2_2_0.md | 398 | **NUEVO - no en outputs** |
| MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md | 428 | **NUEVO - no en outputs** |
| MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md | 337 | **NUEVO - no en outputs** |
| ANEXO_A_ARBOL_COMPLETO_PARTE1.md | 273 | **NUEVO - no en outputs** |
| ANEXO_A_ARBOL_COMPLETO_PARTE2.md | 326 | **NUEVO - no en outputs** |
| ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1.md | 253 | **NUEVO - no en outputs** |

#### Versiones históricas en partes

Múltiples archivos `*_parte1.md`, `*_parte2.md`, etc. que fueron consolidados en versiones completas.

### 3.2 Carpeta /tmp/procedimientos/ (7 archivos)

| Archivo | Líneas | Estado |
|---------|--------|--------|
| PROC_Generacion_ADR_1_0_0.rst | 180 | Ya en outputs |
| PROC_Generacion_BReq_1_0_0.rst | 162 | Ya en outputs |
| PROC_Generacion_CNST_1_0_0.rst | 175 | Ya en outputs |
| PROC_Generacion_FD_1_0_0.rst | 164 | Ya en outputs |
| PROC_Generacion_MOD_1_0_0.rst | 190 | Ya en outputs |
| PROC_Generacion_POL_1_0_0.rst | 165 | Ya en outputs |
| PROC_Generacion_VIEW_1_0_0.rst | 178 | Ya en outputs |

**Nota:** Estos 7 PROC de FASE 5 están duplicados (ya copiados a outputs).

---

## 4. DIFERENCIAS IDENTIFICADAS

### 4.1 Archivos en /tmp/ que NO están en /outputs/ ❌

| Archivo | Líneas | Acción Requerida |
|---------|--------|------------------|
| ANALISIS_ACTUALIZACION_MODELO_v2_2_0.md | 398 | Copiar a outputs |
| MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md | 428 | Consolidar y copiar |
| MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md | 337 | Consolidar y copiar |
| ANEXO_A_ARBOL_COMPLETO_PARTE1.md | 273 | Consolidar y copiar |
| ANEXO_A_ARBOL_COMPLETO_PARTE2.md | 326 | Consolidar y copiar |
| ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1.md | 253 | Consolidar y copiar |
| INFORME_ESTADO_COMPLETO_IACT_2025-12-22.md | 801 | Copiar si relevante |

### 4.2 Archivos REDUNDANTES en /outputs/ ⚠️

| Archivo Antiguo | Archivo Nuevo | Acción |
|-----------------|---------------|--------|
| TPL_001_Plantilla_BR.rst | TPL_BR_Business_Rules_1_0_0.rst | Eliminar antiguo |
| TPL_002_Plantilla_UC.rst | TPL_UC_Casos_de_Uso_2_0_0.rst | Eliminar antiguo |
| TPL_002_Plantilla_UC_v2.rst | TPL_UC_Casos_de_Uso_2_0_0.rst | Eliminar antiguo |
| TPL_003_Plantilla_ADR.rst | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | Eliminar antiguo |
| TPL_004_Plantilla_CNST.rst | TPL_CNST_Restricciones_1_0_0.rst | Eliminar antiguo |
| TPL_005_Plantilla_ARQ_MOD.rst | TPL_MOD_Modulos_1_0_0.rst | Eliminar antiguo |
| TPL_006_Plantilla_FR.rst | TPL_FR_Requisitos_Funcionales_1_0_0.rst | Eliminar antiguo |

### 4.3 Archivos que requieren decisión

| Archivo | Decisión Pendiente |
|---------|-------------------|
| PROC_05_Elaboracion_Completa_Requisitos.rst | ¿Mantener como referencia histórica o eliminar? |

---

## 5. MÉTRICAS FINALES

### 5.1 Conteo Total por Tipo

| Tipo | Cantidad | Líneas Estimadas |
|------|----------|------------------|
| **PROC (nueva nomenclatura)** | 38 | 12,043 |
| **TPL (nueva nomenclatura)** | 17 | 9,498 |
| **UC (casos_uso_v4)** | 62 | 23,401 |
| **FR (funcionales)** | 46 | 9,200+ |
| **BR (reglas_negocio)** | 21 | 6,300+ |
| **CNST** | 10 | 9,621 |
| **ARQ_MOD** | 8 | 3,315 |
| **FND** | 9 | 5,626 |
| **GOB** | 10 | 7,794 |
| **SBVR** | 8 | 4,889 |
| **META** | 5 | 1,522 |
| **MTM** | 3 | 1,975 |
| **TXM** | 3 | 1,972 |
| **STD** | 1 | 340 |
| **Documentos .md** | 56 | 31,000+ |
| **TOTAL** | **~297** | **~128,000+** |

### 5.2 Progreso del Proyecto

```
PROC:  ████████████████████ 100% (38/38)
TPL:   ████████████████████ 100% (17/17)
UC:    ████████████████████ 100% (49/49) + 13 aux = 62
FR:    ██░░░░░░░░░░░░░░░░░░  14% (55/~392)
BR:    ████████████████████ 100% (20/20)
```

---

## 6. RECOMENDACIONES

### 6.1 Acciones Inmediatas

1. **Consolidar MODELO_DOCUMENTAL v2.2.0**
   - Unir PARTE1 + PARTE2
   - Copiar a /outputs/

2. **Consolidar ANEXO_A v2.2.0**
   - Unir las 3 partes existentes
   - Copiar a /outputs/

3. **Copiar análisis v2.2.0**
   - ANALISIS_ACTUALIZACION_MODELO_v2_2_0.md → /outputs/

### 6.2 Limpieza Recomendada

1. **Eliminar TPL con nomenclatura antigua** (7 archivos)
2. **Evaluar PROC_05** - decidir si mantener o eliminar
3. **Archivar versiones históricas** de MODELO_DOCUMENTAL (v2.0.3 a v2.1.0)

### 6.3 Verificación de Consistencia

- [ ] Verificar que 17 TPL nuevos cubren todos los tipos de artefactos
- [ ] Verificar que 38 PROC nuevos cubren todo el ciclo de vida
- [ ] Actualizar índices para reflejar nueva nomenclatura

---

## 7. ESTRUCTURA FINAL RECOMENDADA

```
/mnt/user-data/outputs/
├── MODELO_DOCUMENTAL_IACT_v2_2_0.md          # ACTUAL
├── ANEXO_A_ARBOL_COMPLETO_v2_2_0.md          # ACTUAL
├── MODELO_RBAC_IACT_v5.1.md                  # ACTUAL
│
├── PROC_*.rst (38 archivos)                  # Nueva nomenclatura
├── TPL_*.rst (17 archivos)                   # Nueva nomenclatura
│
├── casos_uso_v4/                             # 62 UC actuales
├── funcionales/                              # 46 FR generados
├── reglas_negocio/                           # 21 BR
│
├── (otros .rst organizados por tipo)
└── (análisis y planes .md)
```

---

*Inventario generado: 2026-01-13*  
*Total artefactos analizados: ~297 archivos*  
*Total líneas estimadas: ~128,000+*
