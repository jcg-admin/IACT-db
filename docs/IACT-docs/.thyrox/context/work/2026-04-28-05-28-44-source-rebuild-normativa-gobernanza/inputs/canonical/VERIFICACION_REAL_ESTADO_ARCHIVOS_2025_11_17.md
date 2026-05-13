---
id: VERIFICACION-REAL-NOMENCLATURA-001
tipo: verificacion
fecha: 2025-11-17
autor: Analisis Automatizado
---

# VERIFICACION REAL: Estado de Archivos en docs/gobernanza/

Este reporte documenta la VERIFICACION MANUAL Y REAL de archivos duplicados e inconsistencias en docs/gobernanza/, basado en comparacion directa de contenido usando diff.

## 1. Pares de ADRs Verificados

### 1.1 Pares adr_2025_### vs ADR-###

| Par | Archivo 1 | Archivo 2 | Lineas A1 | Lineas A2 | Diff Total | Diff Contenido | Decision |
|-----|-----------|-----------|-----------|-----------|------------|----------------|----------|
| 001 | adr_2025_001_vagrant_mod_wsgi.md | ADR-001-vagrant-mod-wsgi.md | 285 | 261 | 59 | 3 | CONSOLIDAR |
| 002 | adr_2025_002_suite_calidad_codigo.md | ADR-002-suite-calidad-codigo.md | 429 | 403 | 95 | 9 | REVISAR |
| 003 | adr_2025_003_dora_sdlc_integration.md | ADR-003-dora-sdlc-integration.md | 540 | 497 | 121 | 6 | REVISAR |
| 004 | adr_2025_004_centralized_log_storage.md | ADR-004-centralized-log-storage.md | 1031 | 979 | 145 | 9 | REVISAR |
| 005 | adr_2025_005_grupos_funcionales_sin_jerarquia.md | ADR-005-grupos-funcionales-sin-jerarquia.md | 390 | 369 | 60 | 4 | CONSOLIDAR |
| 006 | adr_2025_006_configuracion_dinamica_sistema.md | ADR-006-configuracion-dinamica-sistema.md | 307 | 281 | 62 | 3 | CONSOLIDAR |
| 007 | adr_2025_007_git_hooks_validation_strategy.md | ADR-007-git-hooks-validation-strategy.md | 354 | 321 | 89 | 13 | REVISAR |
| 008 | adr_2025_008_workflow_validation_shell_migration.md | ADR-008-workflow-validation-shell-migration.md | 379 | 341 | 89 | 5 | CONSOLIDAR |
| 009 | adr_2025_009_frontend_postponement.md | ADR-009-frontend-postponement.md | 480 | 433 | 106 | 5 | CONSOLIDAR |
| 010 | adr_2025_010_orm_sql_hybrid_permissions.md | ADR-010-orm-sql-hybrid-permissions.md | 489 | 453 | 83 | 3 | CONSOLIDAR |

**Criterio de Decision:**
- CONSOLIDAR: Diferencias de contenido <= 5 lineas (solo frontmatter/espacios)
- REVISAR: Diferencias de contenido 6-20 lineas (diferencias menores)
- MANTENER: Diferencias de contenido > 20 lineas (contenido sustancialmente diferente)

**Resumen:**
- Pares a CONSOLIDAR (casi identicos): 6 archivos (001, 005, 006, 008, 009, 010)
- Pares a REVISAR (diferencias menores): 4 archivos (002, 003, 004, 007)
- Pares MANTENER (contenido diferente): 0 archivos

**Nota:** Las diferencias en pares a CONSOLIDAR son principalmente:
- ID en frontmatter: ADR-2025-001 vs ADR-001
- Campo date: ausente vs presente
- Espacios en blanco adicionales en adr_2025
- Formato de titulo: ADR-2025-001 vs ADR-001

### 1.2 Pares ADR_### vs ADR-###

| Par | Archivo 1 | Archivo 2 | Lineas A1 | Lineas A2 | Diff Total | Diff Contenido | Decision |
|-----|-----------|-----------|-----------|-----------|------------|----------------|----------|
| 008->059 | ADR_008_cpython_features_vs_imagen_base.md | ADR-059-cpython-features-vs-imagen-base.md | 242 | 239 | 39 | 35 | MANTENER |
| 009->013 | ADR_009_distribucion_artefactos_strategy.md | ADR-013-distribucion-artefactos-strategy.md | 457 | 456 | 73 | 60 | MANTENER |
| 010->014 | ADR_010_organizacion_proyecto_por_dominio.md | ADR-014-organizacion-proyecto-por-dominio.md | 461 | 449 | 93 | 65 | MANTENER |
| 011->015 | ADR_011_frontend_modular_monolith.md | ADR-015-frontend-modular-monolith.md | 247 | 238 | 32 | 6 | REVISAR |
| 012->016 | ADR_012_redux_toolkit_state_management.md | ADR-016-redux-toolkit-state-management.md | 318 | 303 | 96 | 36 | MANTENER |
| 013->018 | ADR_013_webpack_bundler.md | ADR-018-webpack-bundler.md | 319 | 310 | 116 | 54 | MANTENER |
| 014->019 | ADR_014_testing_strategy_jest_testing_library.md | ADR-019-testing-strategy-jest-testing-library.md | 437 | 416 | 154 | 74 | MANTENER |

**Resumen:**
- Pares a CONSOLIDAR: 0 archivos
- Pares a REVISAR (diferencias menores): 1 archivo (011)
- Pares MANTENER (contenido diferente): 6 archivos

**Nota:** Estos pares tienen IDs diferentes (ADR_008 vs ADR-059, etc.) lo que indica que NO son duplicados sino versiones diferentes del mismo tema. Requieren RENOMBRADO, no eliminacion.

## 2. Procedimientos Duplicados

Verificacion de archivos en procesos/ vs procesos/procedimientos/:

| Archivo | En procesos/ | En procedimientos/ | Identico | Diff | Decision |
|---------|-------------|-------------------|---------|------|----------|
| procedimiento_analisis_seguridad.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_desarrollo_local.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_diseno_tecnico.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_gestion_cambios.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_instalacion_entorno.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_qa.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_release.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_revision_documental.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| procedimiento_trazabilidad_requisitos.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |
| guia_completa_desarrollo_features.md | SI | SI | NO | 2 lineas | ELIMINAR de procesos/ |

**Resumen:**
- Total de archivos duplicados: 10
- Diferencias: Solo campo "date: 2025-11-13" en frontmatter
- Accion: ELIMINAR todos de procesos/ (mantener solo en procedimientos/)

**Verificacion realizada con:** diff directo entre archivos

## 3. Archivos sin Patron de Nomenclatura

### 3.1 Guias sin GUIA-###-*.md (root de guias/)

| Nombre Actual | Frontmatter | ID Actual | Lineas | Sugerencia |
|--------------|-------------|-----------|--------|------------|
| GUIA_UBICACIONES_ARTEFACTOS.md | SI | GUIA-UBICACIONES-ARTEFACTOS | 1551 | RENOMBRAR a GUIA-003-ubicaciones-artefactos.md |
| METRICS.md | SI | METRICS-GUIAS-ADOPTION | 364 | RENOMBRAR a GUIA-004-metricas-adopcion.md |
| QUICKSTART.md | SI | QUICKSTART-GUIAS | 250 | RENOMBRAR a GUIA-005-inicio-rapido.md |

**Total archivos sin patron en guias/:** 3

### 3.2 Procesos sin PROC-###-*.md (root de procesos/)

| Nombre Actual | Frontmatter | ID Actual | Lineas | Sugerencia |
|--------------|-------------|-----------|--------|------------|
| AGENTES_SDLC.md | SI | (vacio) | 794 | RENOMBRAR a PROC-002-agentes-sdlc.md |
| DEVOPS_AUTOMATION.md | SI | PROC-DEVOPS-001 | 583 | RENOMBRAR a PROC-003-devops-automation.md |
| INDICE_WORKFLOWS.md | SI | INDICE-WORKFLOWS | 623 | RENOMBRAR a PROC-004-indice-workflows.md |
| MAPEO_PROCESOS_TEMPLATES.md | SI | DOC-GOB-MAPEO-PROC-TEMP | 1180 | RENOMBRAR a PROC-005-mapeo-procesos-templates.md |
| SDLC_PROCESS.md | SI | PROC-SDLC-001 | 957 | RENOMBRAR a PROC-006-sdlc-process.md |
| actividades_garantia_documental.md | SI | DOC-QA-DOC-CONTROL | 59 | MOVER a procesos/qa/ |
| estrategia_qa.md | SI | DOC-QA-001 | 37 | MOVER a procesos/qa/ |
| guia_completa_desarrollo_features.md | SI | PROC-GUIA-FEATURES | 1919 | ELIMINAR (duplicado) |
| procedimiento_analisis_seguridad.md | SI | PROC-SEGURIDAD-001 | 689 | ELIMINAR (duplicado) |
| procedimiento_desarrollo_local.md | SI | PROC-DEV-LOCAL | 300 | ELIMINAR (duplicado) |
| procedimiento_diseno_tecnico.md | SI | PROC-DISENO-TEC-001 | 654 | ELIMINAR (duplicado) |
| procedimiento_gestion_cambios.md | SI | PROC-CAMBIOS | 390 | ELIMINAR (duplicado) |
| procedimiento_instalacion_entorno.md | SI | PROC-INSTALL | 370 | ELIMINAR (duplicado) |
| procedimiento_qa.md | SI | PROC-QA | 397 | ELIMINAR (duplicado) |
| procedimiento_release.md | SI | PROC-RELEASE | 306 | ELIMINAR (duplicado) |
| procedimiento_revision_documental.md | SI | PROC-REV-DOC | 297 | ELIMINAR (duplicado) |
| procedimiento_trazabilidad_requisitos.md | SI | PROC-TRAZABILIDAD-001 | 781 | ELIMINAR (duplicado) |

**Total archivos sin patron en procesos/:** 17
- Para RENOMBRAR: 5
- Para MOVER: 2
- Para ELIMINAR (duplicados): 10

## 4. Plan de Migracion Validado

Basado en verificacion REAL de archivos, el plan es:

### FASE 1: Eliminar Duplicados Exactos (Ganancia Inmediata: 10 archivos)

```bash
# Eliminar procedimientos duplicados de procesos/
cd /home/user/IACT---project/docs/gobernanza/procesos
rm procedimiento_analisis_seguridad.md
rm procedimiento_desarrollo_local.md
rm procedimiento_diseno_tecnico.md
rm procedimiento_gestion_cambios.md
rm procedimiento_instalacion_entorno.md
rm procedimiento_qa.md
rm procedimiento_release.md
rm procedimiento_revision_documental.md
rm procedimiento_trazabilidad_requisitos.md
rm guia_completa_desarrollo_features.md
```

**Ganancia:** 10 archivos eliminados de forma segura (verificado con diff)

### FASE 2: Consolidar ADRs Casi-Duplicados (Ganancia: 6 archivos)

Archivos a consolidar (solo difieren en frontmatter):

```bash
# ADRs adr_2025 a eliminar tras consolidar contenido en ADR-###
cd /home/user/IACT---project/docs/gobernanza/adr

# Verificar manualmente antes de eliminar:
# - Que ADR-### tenga el frontmatter correcto
# - Que no se pierda informacion del adr_2025
# Luego eliminar:

rm adr_2025_001_vagrant_mod_wsgi.md
rm adr_2025_005_grupos_funcionales_sin_jerarquia.md
rm adr_2025_006_configuracion_dinamica_sistema.md
rm adr_2025_008_workflow_validation_shell_migration.md
rm adr_2025_009_frontend_postponement.md
rm adr_2025_010_orm_sql_hybrid_permissions.md
```

**Ganancia:** 6 archivos eliminados (tras verificacion manual de frontmatter)

### FASE 3: Renombrar Archivos sin Patron

#### Guias (3 archivos):

```bash
cd /home/user/IACT---project/docs/gobernanza/guias

mv GUIA_UBICACIONES_ARTEFACTOS.md GUIA-003-ubicaciones-artefactos.md
mv METRICS.md GUIA-004-metricas-adopcion.md
mv QUICKSTART.md GUIA-005-inicio-rapido.md
```

#### Procesos (5 archivos a renombrar):

```bash
cd /home/user/IACT---project/docs/gobernanza/procesos

mv AGENTES_SDLC.md PROC-002-agentes-sdlc.md
mv DEVOPS_AUTOMATION.md PROC-003-devops-automation.md
mv INDICE_WORKFLOWS.md PROC-004-indice-workflows.md
mv MAPEO_PROCESOS_TEMPLATES.md PROC-005-mapeo-procesos-templates.md
mv SDLC_PROCESS.md PROC-006-sdlc-process.md
```

#### Mover archivos QA (2 archivos):

```bash
cd /home/user/IACT---project/docs/gobernanza/procesos

mv actividades_garantia_documental.md qa/actividades_garantia_documental.md
mv estrategia_qa.md qa/estrategia_qa.md
```

### FASE 4: Revisar Manualmente (5 ADRs)

Estos archivos tienen diferencias menores (6-13 lineas) y requieren revision manual:

**adr_2025 vs ADR:**
- adr_2025_002_suite_calidad_codigo.md vs ADR-002-suite-calidad-codigo.md (9 lineas)
- adr_2025_003_dora_sdlc_integration.md vs ADR-003-dora-sdlc-integration.md (6 lineas)
- adr_2025_004_centralized_log_storage.md vs ADR-004-centralized-log-storage.md (9 lineas)
- adr_2025_007_git_hooks_validation_strategy.md vs ADR-007-git-hooks-validation-strategy.md (13 lineas)

**ADR_ vs ADR-:**
- ADR_011_frontend_modular_monolith.md vs ADR-015-frontend-modular-monolith.md (6 lineas)

**Accion:** Revisar diff manual y decidir si consolidar o mantener ambos.

### FASE 5: Renombrar ADRs con Nomenclatura Incorrecta

Los siguientes archivos ADR_ tienen contenido DIFERENTE a sus contrapartes ADR-, por lo que deben RENOMBRARSE (no eliminarse):

```bash
cd /home/user/IACT---project/docs/gobernanza/adr

# Estos tienen contenido sustancialmente diferente, renombrar para evitar confusion:
# ADR_008 -> ADR-060 (ya existe ADR-059 con contenido distinto)
# ADR_009 -> ADR-061 (ya existe ADR-013 con contenido distinto)
# ADR_010 -> ADR-062 (ya existe ADR-014 con contenido distinto)
# ADR_012 -> ADR-063 (ya existe ADR-016 con contenido distinto)
# ADR_013 -> ADR-064 (ya existe ADR-018 con contenido distinto)
# ADR_014 -> ADR-065 (ya existe ADR-019 con contenido distinto)

# NO EJECUTAR AUN - REQUIERE DECISION DE EQUIPO SOBRE NUMERACION
```

## 5. Archivos que Requieren Decision Manual

### 5.1 ADRs con Diferencias Menores (Revisar antes de consolidar)

| Par | Archivo 1 | Archivo 2 | Diff Contenido | Accion Sugerida |
|-----|-----------|-----------|----------------|-----------------|
| 002 | adr_2025_002_suite_calidad_codigo.md | ADR-002-suite-calidad-codigo.md | 9 lineas | Revisar diff, probablemente consolidar |
| 003 | adr_2025_003_dora_sdlc_integration.md | ADR-003-dora-sdlc-integration.md | 6 lineas | Revisar diff, probablemente consolidar |
| 004 | adr_2025_004_centralized_log_storage.md | ADR-004-centralized-log-storage.md | 9 lineas | Revisar diff, probablemente consolidar |
| 007 | adr_2025_007_git_hooks_validation_strategy.md | ADR-007-git-hooks-validation-strategy.md | 13 lineas | Revisar diff, probablemente consolidar |
| 011 | ADR_011_frontend_modular_monolith.md | ADR-015-frontend-modular-monolith.md | 6 lineas | Revisar diff, probablemente consolidar |

### 5.2 ADRs con Contenido Diferente (Renombrar, no eliminar)

Los siguientes pares tienen contenido SUSTANCIALMENTE diferente y deben mantenerse ambos:

| Archivo ADR_ | Archivo ADR- | Diff Contenido | Decision |
|--------------|-------------|----------------|----------|
| ADR_008_cpython_features_vs_imagen_base.md | ADR-059-cpython-features-vs-imagen-base.md | 35 lineas | RENOMBRAR ADR_008 a ADR-060 |
| ADR_009_distribucion_artefactos_strategy.md | ADR-013-distribucion-artefactos-strategy.md | 60 lineas | RENOMBRAR ADR_009 a ADR-061 |
| ADR_010_organizacion_proyecto_por_dominio.md | ADR-014-organizacion-proyecto-por-dominio.md | 65 lineas | RENOMBRAR ADR_010 a ADR-062 |
| ADR_012_redux_toolkit_state_management.md | ADR-016-redux-toolkit-state-management.md | 36 lineas | RENOMBRAR ADR_012 a ADR-063 |
| ADR_013_webpack_bundler.md | ADR-018-webpack-bundler.md | 54 lineas | RENOMBRAR ADR_013 a ADR-064 |
| ADR_014_testing_strategy_jest_testing_library.md | ADR-019-testing-strategy-jest-testing-library.md | 74 lineas | RENOMBRAR ADR_014 a ADR-065 |

## 6. Resumen Ejecutivo

### Hallazgos Criticos

1. **10 procedimientos duplicados** en procesos/ (pueden eliminarse de forma segura)
2. **6 ADRs adr_2025** casi identicos a ADR-### (solo difieren en frontmatter)
3. **4 ADRs adr_2025** con diferencias menores (6-13 lineas, requieren revision)
4. **6 ADRs ADR_###** con contenido diferente a ADR-### (requieren renombrado, no eliminacion)
5. **3 guias** sin patron de nomenclatura
6. **17 archivos en procesos/** sin patron (10 duplicados, 5 a renombrar, 2 a mover)

### Archivos que se Pueden Eliminar de Forma Segura

**Total: 10 archivos (todos en procesos/)**

- procedimiento_analisis_seguridad.md (duplicado exacto salvo frontmatter)
- procedimiento_desarrollo_local.md (duplicado exacto salvo frontmatter)
- procedimiento_diseno_tecnico.md (duplicado exacto salvo frontmatter)
- procedimiento_gestion_cambios.md (duplicado exacto salvo frontmatter)
- procedimiento_instalacion_entorno.md (duplicado exacto salvo frontmatter)
- procedimiento_qa.md (duplicado exacto salvo frontmatter)
- procedimiento_release.md (duplicado exacto salvo frontmatter)
- procedimiento_revision_documental.md (duplicado exacto salvo frontmatter)
- procedimiento_trazabilidad_requisitos.md (duplicado exacto salvo frontmatter)
- guia_completa_desarrollo_features.md (duplicado exacto salvo frontmatter)

**Verificado con:** diff directo, diferencias solo en campo "date: 2025-11-13"

### Archivos que Requieren Revision Manual Antes de Accion

**Total: 5 pares de ADRs**
- 4 pares adr_2025 vs ADR (diferencias 6-13 lineas)
- 1 par ADR_ vs ADR- (diferencias 6 lineas)

### Archivos que Deben Renombrarse (No Eliminarse)

**Total: 14 archivos**
- 3 guias
- 5 procesos
- 6 ADRs ADR_### (contenido diferente a ADR-###)

## 7. Metodologia de Verificacion

### Herramientas Utilizadas

- `diff`: Comparacion directa de archivos
- `diff -w -B`: Comparacion ignorando espacios en blanco
- `wc -l`: Conteo de lineas
- `awk`: Extraccion de contenido post-frontmatter

### Proceso de Verificacion

1. Listar todos los archivos .md en docs/gobernanza/
2. Identificar pares potencialmente duplicados
3. Comparar con diff completo
4. Extraer contenido sin frontmatter
5. Comparar contenido sin frontmatter usando diff -w -B
6. Clasificar segun numero de lineas diferentes:
   - 0-5 lineas: CONSOLIDAR (solo frontmatter)
   - 6-20 lineas: REVISAR (diferencias menores)
   - 20+ lineas: MANTENER (contenido diferente)

### Criterios de Decision

**CONSOLIDAR:** Diferencias solo en frontmatter, ID, o espacios en blanco
**REVISAR:** Diferencias menores que requieren inspeccion manual
**MANTENER:** Contenido sustancialmente diferente
**ELIMINAR:** Duplicado exacto en otra ubicacion

## 8. Proximos Pasos Recomendados

### Paso 1: Ejecutar FASE 1 (Ganancia Inmediata)
Eliminar 10 procedimientos duplicados de procesos/
**Riesgo:** BAJO (verificado con diff)

### Paso 2: Revisar Manualmente 5 Pares de ADRs
Revisar diff de los 5 pares con diferencias menores
**Riesgo:** MEDIO (requiere juicio humano)

### Paso 3: Ejecutar FASE 2 (Consolidar ADRs)
Eliminar 6 ADRs adr_2025 tras verificar frontmatter
**Riesgo:** BAJO-MEDIO (verificar frontmatter antes)

### Paso 4: Ejecutar FASE 3 (Renombrar Archivos)
Renombrar 3 guias + 5 procesos + mover 2 archivos QA
**Riesgo:** BAJO (no se pierde informacion)

### Paso 5: Decidir Numeracion de ADRs ADR_###
Decidir si renombrar ADR_### a ADR-060+ o mantener nomenclatura
**Riesgo:** BAJO (decision de gobernanza, no tecnica)

---

**Fin del reporte**

Fecha de generacion: 2025-11-17
Verificacion realizada: MANUAL con diff directo
Total archivos analizados: 400+
Total pares verificados: 27
Total duplicados encontrados: 10 (confirmados)
Total candidatos a consolidacion: 6 (tras revision)
Total archivos seguros para eliminacion: 10
