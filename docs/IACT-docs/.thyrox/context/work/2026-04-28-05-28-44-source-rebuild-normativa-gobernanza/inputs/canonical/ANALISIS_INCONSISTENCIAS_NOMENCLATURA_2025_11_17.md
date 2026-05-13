---
id: ANALISIS-INCONSISTENCIAS-NOMENCLATURA-001
tipo: analisis
categoria: qa
subcategoria: nomenclatura
version: 1.0.0
fecha_analisis: 2025-11-17
autor: Claude Code (Sonnet 4.5)
estado: completo
---

# ANALISIS: Inconsistencias de Nomenclatura en docs/gobernanza/

## Resumen Ejecutivo

- **Total archivos analizados:** 396
- **Archivos con patrón correcto:** 279 (70.5%)
- **Archivos con inconsistencias:** 117 (29.5%)
- **Archivos duplicados:** 17 pares (34 archivos)
- **Archivos sin frontmatter YAML:** 32
- **Porcentaje de cumplimiento nomenclatura:** 70.5%

### Hallazgos Críticos

1. **17 pares de ADRs duplicados** (34 archivos totales): 10 con formato `adr_2025_###` y 7 con formato `ADR_###`
2. **3 archivos en guias/** sin patrón `GUIA-###-*`
3. **17 archivos en procesos/** sin patrón `PROC-###-*`
4. **32 archivos documentales** en root de `docs/gobernanza/` sin prefijo establecido
5. **32 archivos sin frontmatter YAML** o con frontmatter incompleto

---

## 1. ADRs con Nomenclatura Incorrecta

### 1.1 Formato adr_2025_###_titulo.md (snake_case con año) - DUPLICADOS

**Problema:** Estos 10 archivos usan formato obsoleto con año 2025 y están DUPLICADOS con versiones correctas.

| Archivo Incorrecto | Archivo Correcto Existente | Estado |
|-------------------|---------------------------|---------|
| `adr_2025_001_vagrant_mod_wsgi.md` | `ADR-001-vagrant-mod-wsgi.md` | DUPLICADO |
| `adr_2025_002_suite_calidad_codigo.md` | `ADR-002-suite-calidad-codigo.md` | DUPLICADO |
| `adr_2025_003_dora_sdlc_integration.md` | `ADR-003-dora-sdlc-integration.md` | DUPLICADO |
| `adr_2025_004_centralized_log_storage.md` | `ADR-004-centralized-log-storage.md` | DUPLICADO |
| `adr_2025_005_grupos_funcionales_sin_jerarquia.md` | `ADR-005-grupos-funcionales-sin-jerarquia.md` | DUPLICADO |
| `adr_2025_006_configuracion_dinamica_sistema.md` | `ADR-006-configuracion-dinamica-sistema.md` | DUPLICADO |
| `adr_2025_007_git_hooks_validation_strategy.md` | `ADR-007-git-hooks-validation-strategy.md` | DUPLICADO |
| `adr_2025_008_workflow_validation_shell_migration.md` | `ADR-008-workflow-validation-shell-migration.md` | DUPLICADO |
| `adr_2025_009_frontend_postponement.md` | `ADR-009-frontend-postponement.md` | DUPLICADO |
| `adr_2025_010_orm_sql_hybrid_permissions.md` | `ADR-010-orm-sql-hybrid-permissions.md` | DUPLICADO |

**Total:** 10 archivos duplicados

**Frontmatter inconsistente:** Los archivos `adr_2025_###` tienen `id: ADR-2025-###` en lugar de `id: ADR-###`

### 1.2 Formato ADR_###_titulo.md (underscores) - DUPLICADOS

**Problema:** Estos 7 archivos usan underscores en lugar de guiones y están DUPLICADOS con versiones correctas.

| Archivo Incorrecto | Archivo Correcto Existente | Estado |
|-------------------|---------------------------|---------|
| `ADR_008_cpython_features_vs_imagen_base.md` | `ADR-059-cpython-features-vs-imagen-base.md` | DUPLICADO |
| `ADR_009_distribucion_artefactos_strategy.md` | `ADR-013-distribucion-artefactos-strategy.md` | DUPLICADO |
| `ADR_010_organizacion_proyecto_por_dominio.md` | `ADR-014-organizacion-proyecto-por-dominio.md` | DUPLICADO |
| `ADR_011_frontend_modular_monolith.md` | `ADR-015-frontend-modular-monolith.md` | DUPLICADO |
| `ADR_012_redux_toolkit_state_management.md` | `ADR-016-redux-toolkit-state-management.md` | DUPLICADO |
| `ADR_013_webpack_bundler.md` | `ADR-018-webpack-bundler.md` | DUPLICADO |
| `ADR_014_testing_strategy_jest_testing_library.md` | `ADR-019-testing-strategy-jest-testing-library.md` | DUPLICADO |

**Total:** 7 archivos duplicados

**Problema adicional:** Algunos NO tienen frontmatter YAML (ej: `ADR_008`)

### 1.3 Resumen ADRs

- **Total ADRs en docs/gobernanza/adr/:** 60 archivos
- **ADRs con formato correcto (ADR-###-*):** 41 archivos
- **ADRs con formato incorrecto:** 17 archivos
- **Plantillas/README:** 2 archivos (`plantilla_adr.md`, `README.md`)

**Acción requerida:** ELIMINAR los 17 archivos duplicados con formato incorrecto.

---

## 2. GUIAs sin Patrón GUIA-###

### 2.1 Archivos en docs/gobernanza/guias/ (nivel raíz)

**Patrón establecido:** `GUIA-###-snake_case_title.md`

| Archivo Actual | Formato Correcto Sugerido | ID Frontmatter Actual | Problema |
|---------------|--------------------------|----------------------|----------|
| `GUIA-001-procesos_vs_procedimientos.md` | (correcto) | `GUIA-001` | FORMATO CORRECTO |
| `GUIA_UBICACIONES_ARTEFACTOS.md` | `GUIA-002-ubicaciones_artefactos.md` | `GUIA-UBICACIONES-ARTEFACTOS` | Sin número, underscores |
| `METRICS.md` | `GUIA-003-metrics.md` | (sin frontmatter) | Sin prefijo, sin número |
| `QUICKSTART.md` | `GUIA-004-quickstart.md` | (sin frontmatter) | Sin prefijo, sin número |

**Total archivos incorrectos:** 3

### 2.2 Subdirectorios en guias/

Los siguientes subdirectorios contienen archivos con nomenclatura genérica (sin prefijo GUIA):

- `guias/deployment/` - 5 archivos: `deployment_001.md` a `deployment_005_*.md`
- `guias/onboarding/` - 8 archivos: `onboarding_001.md` a `onboarding_008_*.md`
- `guias/testing/` - 3 archivos: `testing_001.md` a `testing_003.md`
- `guias/troubleshooting/` - 1 archivo: `troubleshooting_001.md`
- `guias/workflows/` - 7 archivos: `workflow_*.md`
- `guias/scripts/` - 3 archivos: `*.md`

**Total:** 27 archivos en subdirectorios con nomenclatura específica (ACEPTABLE según contexto organizacional)

**Nota:** Estos subdirectorios usan nomenclatura propia coherente internamente. Se podría considerar aceptable O renombrar a `GUIA-###-deployment_*`, etc.

---

## 3. PROCs sin Patrón PROC-###

### 3.1 Archivos en docs/gobernanza/procesos/ (nivel raíz)

**Patrón establecido:** `PROC-###-snake_case_title.md`

| Archivo Actual | Formato Correcto Sugerido | ID Frontmatter | Problema |
|---------------|--------------------------|---------------|----------|
| `PROC-001-pipeline_trabajo_iact.md` | (correcto) | `PROC-001` | FORMATO CORRECTO |
| `SDLC_PROCESS.md` | `PROC-002-sdlc_process.md` | `PROC-SDLC-001` | Sin prefijo PROC, underscores |
| `DEVOPS_AUTOMATION.md` | `PROC-003-devops_automation.md` | (verificar) | Sin prefijo PROC |
| `AGENTES_SDLC.md` | `PROC-004-agentes_sdlc.md` | (verificar) | Sin prefijo PROC |
| `INDICE_WORKFLOWS.md` | (índice - aceptable) | (verificar) | Archivo índice |
| `MAPEO_PROCESOS_TEMPLATES.md` | `PROC-005-mapeo_procesos_templates.md` | (verificar) | Sin prefijo PROC |
| `actividades_garantia_documental.md` | `PROC-006-actividades_garantia_documental.md` | (verificar) | Sin prefijo PROC |
| `estrategia_qa.md` | `PROC-007-estrategia_qa.md` | (verificar) | Sin prefijo PROC |
| `guia_completa_desarrollo_features.md` | (reubicar a guias/) | (verificar) | Mal ubicado (es guía) |
| `procedimiento_*.md` (9 archivos) | `PROCED-###-*.md` | (verificar) | Son procedimientos, no procesos |

**Total archivos incorrectos:** 8 procesos + 9 procedimientos = 17 archivos

### 3.2 Procedimientos vs Procesos

**Problema conceptual:** Existe confusión entre PROCESOS y PROCEDIMIENTOS.

Según `GUIA-001-procesos_vs_procedimientos.md`:
- **PROCESO:** Flujo de trabajo de alto nivel (ej: SDLC, DevOps Pipeline)
- **PROCEDIMIENTO:** Pasos específicos detallados (ej: Cómo hacer deployment, cómo configurar entorno)

**Archivos mal categorizados:**

En `procesos/` hay 9 archivos `procedimiento_*.md` que deberían:
1. Renombrarse con prefijo `PROCED-###-*`
2. O moverse a `procesos/procedimientos/` (ya existe este subdirectorio)

| Archivo | Ubicación Correcta Sugerida |
|---------|----------------------------|
| `procedimiento_analisis_seguridad.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_desarrollo_local.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_diseno_tecnico.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_gestion_cambios.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_instalacion_entorno.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_qa.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_release.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_revision_documental.md` | `procesos/procedimientos/` (ya existe copia) |
| `procedimiento_trazabilidad_requisitos.md` | `procesos/procedimientos/` (ya existe copia) |

**HALLAZGO CRÍTICO:** Los 9 archivos `procedimiento_*.md` están DUPLICADOS. Existen en `procesos/` y en `procesos/procedimientos/`.

**Acción:** ELIMINAR duplicados de `procesos/` (raíz), mantener solo en `procesos/procedimientos/`.

---

## 4. Archivos en Root de docs/gobernanza/

### 4.1 Archivos sin Prefijo Establecido

**Problema:** Hay 32 archivos en root de `docs/gobernanza/` sin seguir ningún patrón de nomenclatura establecido.

| Archivo | Tipo Probable | Sugerencia |
|---------|--------------|------------|
| `GUIA_ESTILO.md` | Guía | Mover a `guias/` como `GUIA-005-estilo.md` O renombrar a `GUIA-005-estilo.md` en root |
| `INDICE_ADRs.md` | Índice | ACEPTABLE (archivo índice) |
| `TAREAS_ACTIVAS.md` | Gestión | ACEPTABLE (archivo de gestión activa) |
| `ROADMAP.md` | Planificación | ACEPTABLE (estándar GitHub) |
| `CHANGELOG.md` | Cambios | ACEPTABLE (estándar GitHub) |
| `README.md` | Documentación | ACEPTABLE (estándar GitHub) |
| `TASK-004-*.md` (4 archivos) | Tareas | Mover a subdirectorio `tareas/` |
| `brs_business_requirements.md` | Requisitos | Mover a `requisitos/` (ya existe copia) |
| `strs_stakeholder_requirements.md` | Requisitos | Mover a `requisitos/` (ya existe copia) |
| `casos_de_uso_guide.md` | Guía | Renombrar a `GUIA-006-casos_de_uso.md` |
| `claude_code.md` | Guía | Renombrar a `GUIA-007-claude_code.md` |
| `documentacion_corporativa.md` | Guía | Renombrar a `GUIA-008-documentacion_corporativa.md` |
| `estandares_codigo.md` | Guía | Mover a `estilos/` (ya existe copia) |
| `glossary.md` | Glosario | Mover a `anexos/glosarios/` (ya existe) |
| `lineamientos_gobernanza.md` | Guía | Renombrar a `GUIA-009-lineamientos_gobernanza.md` |
| `merge_y_limpieza_ramas.md` | Procedimiento | Renombrar a `PROCED-001-merge_limpieza_ramas.md` |
| `plan_general.md` | Planificación | Mover a `planificacion/` |
| `plantilla_adr.md` | Plantilla | Mover a `plantillas/` (ya existe `adr/plantilla_adr.md`) |
| `plantilla_espacio_documental.md` | Plantilla | Mover a `plantillas/` (ya existe copia) |
| `post_create.md` | Script | Verificar ubicación |
| `registro_decisiones.md` | Gestión | Renombrar a `GUIA-010-registro_decisiones.md` |
| `reprocesar_etl_fallido.md` | Runbook | Mover a subdirectorio `runbooks/` |
| `shell_scripting_guide.md` | Guía | Mover a `estilos/` (ya existe copia) |
| `verificar_servicios.md` | Runbook | Mover a subdirectorio `runbooks/` |
| `vision_y_alcance.md` | Requisitos | Mover a subdirectorio `vision_y_alcance/` (ya existe) |
| `github_copilot_codespaces.md` | Guía | Renombrar a `GUIA-011-github_copilot.md` |
| `ANALISIS_GUIAS_WORKFLOWS.md` | Análisis | Mover a `qa/` |
| `DOCS_LEGACY_ANALYSIS_REPORT.md` | Reporte | Mover a `qa/` o `sesiones/analisis_nov_2025/` |
| `MAPEO_MIGRACION_LEGACY.md` | Análisis | Mover a `planificacion/` |
| `RESUMEN_MIGRACION_SHELL_SCRIPTS.md` | Reporte | Mover a `qa/` o `planificacion/` |

**Total:** 32 archivos sin estructura clara en root

**Problema:** Mezcla de guías, plantillas, procedimientos, requisitos y reportes en el mismo nivel.

---

## 5. Archivos Duplicados

### 5.1 Duplicados Confirmados

| Archivo Original | Archivo Duplicado | Ubicación 1 | Ubicación 2 |
|-----------------|-------------------|------------|------------|
| `ADR-001` a `ADR-010` | `adr_2025_001` a `010` | `adr/` | `adr/` |
| `ADR-013, 014, 015, 016, 018, 019` | `ADR_009` a `014` | `adr/` | `adr/` |
| `ADR-059` | `ADR_008` | `adr/` | `adr/` |
| `procedimiento_*.md` (9 archivos) | (mismos) | `procesos/` | `procesos/procedimientos/` |
| `brs_business_requirements.md` | (mismo) | root | `requisitos/` |
| `strs_stakeholder_requirements.md` | (mismo) | root | `requisitos/` |
| `estandares_codigo.md` | (mismo) | root | `estilos/` |
| `shell_scripting_guide.md` | (mismo) | root | `estilos/` |
| `glossary.md` | (mismo) | root | `anexos/glosarios/` |
| `plantilla_adr.md` | (mismo) | root | `adr/` |
| `plantilla_espacio_documental.md` | (mismo) | root | `plantillas/` |
| `actividades_garantia_documental.md` | (mismo) | `procesos/` | `procesos/qa/` |
| `estrategia_qa.md` | (mismo) | `procesos/` | `procesos/qa/` |
| `checklist_auditoria_restricciones.md` | (mismo) | `qa/` | `procesos/qa/` |

**Total pares duplicados:** 17 pares = 34 archivos

**Acción:** ELIMINAR versiones duplicadas, mantener solo la copia en la ubicación correcta.

---

## 6. Frontmatter Inconsistente

### 6.1 Archivos sin Frontmatter YAML

**Total:** 32 archivos sin frontmatter YAML o con frontmatter incompleto.

**Ejemplos críticos:**
- `ADR_008_cpython_features_vs_imagen_base.md` - Sin frontmatter
- `METRICS.md` - Sin frontmatter
- `QUICKSTART.md` - Sin frontmatter
- Varios archivos en `sesiones/`, `qa/`, `ci_cd/`

### 6.2 Archivos con ID Inconsistente

**Problema:** El ID en frontmatter no coincide con el nombre de archivo.

| Archivo | ID Frontmatter | ID Correcto Esperado |
|---------|---------------|---------------------|
| `adr_2025_001_vagrant_mod_wsgi.md` | `ADR-2025-001` | `ADR-001` |
| `adr_2025_002_suite_calidad_codigo.md` | `ADR-2025-002` | `ADR-002` |
| (idem para 003-010) | `ADR-2025-###` | `ADR-###` |
| `GUIA_UBICACIONES_ARTEFACTOS.md` | `GUIA-UBICACIONES-ARTEFACTOS` | `GUIA-002` |
| `SDLC_PROCESS.md` | `PROC-SDLC-001` | `PROC-002` |

**Total:** Aproximadamente 15-20 archivos con IDs inconsistentes.

---

## 7. Plan de Remediación

### Prioridad 1: ELIMINAR Duplicados (CRÍTICO)

**Impacto:** Alto - Confusión, referencias rotas, inconsistencia
**Esfuerzo:** Bajo - Simple eliminación de archivos

#### Acciones Inmediatas:

1. **ELIMINAR 10 archivos adr_2025_###** en `docs/gobernanza/adr/`:
   - [ ] `adr_2025_001_vagrant_mod_wsgi.md`
   - [ ] `adr_2025_002_suite_calidad_codigo.md`
   - [ ] `adr_2025_003_dora_sdlc_integration.md`
   - [ ] `adr_2025_004_centralized_log_storage.md`
   - [ ] `adr_2025_005_grupos_funcionales_sin_jerarquia.md`
   - [ ] `adr_2025_006_configuracion_dinamica_sistema.md`
   - [ ] `adr_2025_007_git_hooks_validation_strategy.md`
   - [ ] `adr_2025_008_workflow_validation_shell_migration.md`
   - [ ] `adr_2025_009_frontend_postponement.md`
   - [ ] `adr_2025_010_orm_sql_hybrid_permissions.md`

2. **ELIMINAR 7 archivos ADR_###** en `docs/gobernanza/adr/`:
   - [ ] `ADR_008_cpython_features_vs_imagen_base.md`
   - [ ] `ADR_009_distribucion_artefactos_strategy.md`
   - [ ] `ADR_010_organizacion_proyecto_por_dominio.md`
   - [ ] `ADR_011_frontend_modular_monolith.md`
   - [ ] `ADR_012_redux_toolkit_state_management.md`
   - [ ] `ADR_013_webpack_bundler.md`
   - [ ] `ADR_014_testing_strategy_jest_testing_library.md`

3. **ELIMINAR 9 procedimientos duplicados** en `docs/gobernanza/procesos/`:
   - [ ] `procedimiento_analisis_seguridad.md`
   - [ ] `procedimiento_desarrollo_local.md`
   - [ ] `procedimiento_diseno_tecnico.md`
   - [ ] `procedimiento_gestion_cambios.md`
   - [ ] `procedimiento_instalacion_entorno.md`
   - [ ] `procedimiento_qa.md`
   - [ ] `procedimiento_release.md`
   - [ ] `procedimiento_revision_documental.md`
   - [ ] `procedimiento_trazabilidad_requisitos.md`

4. **ELIMINAR otros duplicados en root:**
   - [ ] `brs_business_requirements.md` (mantener en `requisitos/`)
   - [ ] `strs_stakeholder_requirements.md` (mantener en `requisitos/`)
   - [ ] `estandares_codigo.md` (mantener en `estilos/`)
   - [ ] `shell_scripting_guide.md` (mantener en `estilos/`)
   - [ ] `glossary.md` (mantener en `anexos/glosarios/`)
   - [ ] `plantilla_adr.md` (mantener en `adr/`)
   - [ ] `plantilla_espacio_documental.md` (mantener en `plantillas/`)

**Total archivos a eliminar:** 34 archivos

---

### Prioridad 2: Renombrar Archivos en guias/ y procesos/ (ALTO)

**Impacto:** Medio - Mejora consistencia y navegabilidad
**Esfuerzo:** Medio - Requiere actualizar referencias

#### Acciones:

1. **Renombrar archivos en guias/**:
   - [ ] `GUIA_UBICACIONES_ARTEFACTOS.md` -> `GUIA-002-ubicaciones_artefactos.md`
   - [ ] `METRICS.md` -> `GUIA-003-metrics.md`
   - [ ] `QUICKSTART.md` -> `GUIA-004-quickstart.md`

2. **Renombrar archivos en procesos/**:
   - [ ] `SDLC_PROCESS.md` -> `PROC-002-sdlc_process.md`
   - [ ] `DEVOPS_AUTOMATION.md` -> `PROC-003-devops_automation.md`
   - [ ] `AGENTES_SDLC.md` -> `PROC-004-agentes_sdlc.md`
   - [ ] `MAPEO_PROCESOS_TEMPLATES.md` -> `PROC-005-mapeo_procesos_templates.md`
   - [ ] `actividades_garantia_documental.md` -> `PROC-006-actividades_garantia_documental.md`
   - [ ] `estrategia_qa.md` -> `PROC-007-estrategia_qa.md`

3. **Reubicar archivos mal categorizados**:
   - [ ] `procesos/guia_completa_desarrollo_features.md` -> `guias/GUIA-005-desarrollo_features.md`

**Total archivos a renombrar:** 10 archivos

---

### Prioridad 3: Reorganizar Root de docs/gobernanza/ (MEDIO)

**Impacto:** Medio - Mejora organización general
**Esfuerzo:** Alto - Requiere decisiones de arquitectura documental

#### Acciones:

1. **Crear subdirectorios faltantes** (si no existen):
   - [ ] `docs/gobernanza/tareas/`
   - [ ] `docs/gobernanza/runbooks/`

2. **Mover archivos a ubicaciones correctas**:
   - [ ] `TASK-*.md` (4 archivos) -> `tareas/`
   - [ ] `GUIA_ESTILO.md` -> `guias/GUIA-005-estilo.md` (renombrar también)
   - [ ] `casos_de_uso_guide.md` -> `guias/GUIA-006-casos_de_uso.md`
   - [ ] `claude_code.md` -> `guias/GUIA-007-claude_code.md`
   - [ ] `documentacion_corporativa.md` -> `guias/GUIA-008-documentacion_corporativa.md`
   - [ ] `lineamientos_gobernanza.md` -> `guias/GUIA-009-lineamientos_gobernanza.md`
   - [ ] `github_copilot_codespaces.md` -> `guias/GUIA-011-github_copilot.md`
   - [ ] `registro_decisiones.md` -> `guias/GUIA-010-registro_decisiones.md`
   - [ ] `merge_y_limpieza_ramas.md` -> `procesos/procedimientos/PROCED-010-merge_limpieza_ramas.md`
   - [ ] `reprocesar_etl_fallido.md` -> `runbooks/`
   - [ ] `verificar_servicios.md` -> `runbooks/`
   - [ ] `plan_general.md` -> `planificacion/`
   - [ ] `ANALISIS_GUIAS_WORKFLOWS.md` -> `qa/`
   - [ ] `DOCS_LEGACY_ANALYSIS_REPORT.md` -> `qa/`
   - [ ] `MAPEO_MIGRACION_LEGACY.md` -> `planificacion/`
   - [ ] `RESUMEN_MIGRACION_SHELL_SCRIPTS.md` -> `planificacion/`

**Total archivos a mover/renombrar:** 18 archivos

---

### Prioridad 4: Agregar/Corregir Frontmatter (MEDIO)

**Impacto:** Bajo - Mejora metadatos y automatización
**Esfuerzo:** Medio - Requiere análisis manual de cada archivo

#### Acciones:

1. **Agregar frontmatter YAML** a 32 archivos sin frontmatter
2. **Corregir IDs inconsistentes** en frontmatter (15-20 archivos)
3. **Estandarizar campos** de frontmatter según plantilla

**Plantilla frontmatter estándar:**

```yaml
---
id: PREFIX-###
tipo: [guia|proceso|procedimiento|adr|task]
categoria: [gobernanza|desarrollo|arquitectura|qa]
subcategoria: [específica]
version: 1.0.0
fecha_creacion: YYYY-MM-DD
autor: [nombre]
estado: [activo|borrador|deprecado]
relacionados: ["ID-001", "ID-002"]
---
```

**Total archivos a actualizar:** ~50 archivos

---

### Prioridad 5: Subdirectorios en guias/ (BAJO - OPCIONAL)

**Impacto:** Bajo - Mejora consistencia pero requiere decisión arquitectónica
**Esfuerzo:** Alto - Afecta muchos archivos (27 archivos)

#### Decisión Pendiente:

**Opción A:** Mantener estructura actual con subdirectorios temáticos:
- `guias/deployment/deployment_###.md`
- `guias/onboarding/onboarding_###.md`
- `guias/testing/testing_###.md`
- etc.

**Opción B:** Renombrar todo a patrón GUIA-###:
- `guias/GUIA-020-deployment_001.md`
- `guias/GUIA-030-onboarding_001.md`
- etc.

**Recomendación:** MANTENER estructura actual (Opción A). Los subdirectorios proporcionan organización lógica y los nombres actuales son coherentes internamente.

---

## 8. Estadísticas Finales

### Resumen de Archivos a Modificar

| Acción | Cantidad | Prioridad |
|--------|----------|-----------|
| Eliminar duplicados | 34 | CRÍTICO |
| Renombrar con patrón correcto | 10 | ALTO |
| Mover a ubicación correcta | 18 | MEDIO |
| Agregar/corregir frontmatter | 50 | MEDIO |
| **TOTAL** | **112** | - |

### Impacto Estimado

- **Archivos totales:** 396
- **Archivos a modificar:** 112 (28.3%)
- **Archivos que quedarán con nomenclatura correcta:** 362 (91.4%)
- **Mejora de cumplimiento:** 70.5% -> 91.4% (+20.9%)

### Tiempo Estimado de Remediación

| Prioridad | Esfuerzo Estimado | Riesgo |
|-----------|------------------|--------|
| P1: Eliminar duplicados | 1-2 horas | Bajo (simple eliminación) |
| P2: Renombrar archivos | 2-3 horas | Medio (actualizar referencias) |
| P3: Reorganizar root | 4-6 horas | Alto (decisiones de arquitectura) |
| P4: Frontmatter | 3-4 horas | Medio (análisis manual) |
| **TOTAL** | **10-15 horas** | - |

---

## 9. Recomendaciones Finales

### Recomendaciones Inmediatas

1. **Ejecutar Prioridad 1** (eliminar duplicados) INMEDIATAMENTE para evitar confusión
2. **Crear script de validación** para prevenir futuros duplicados
3. **Actualizar GUIA_ESTILO.md** con reglas de nomenclatura claras
4. **Documentar decisiones** sobre estructura de subdirectorios en guias/

### Recomendaciones a Largo Plazo

1. **Implementar pre-commit hooks** para validar nomenclatura de archivos nuevos
2. **Crear índices automatizados** que detecten inconsistencias
3. **Establecer proceso de revisión** para nuevos documentos
4. **Capacitar al equipo** sobre estándares de nomenclatura

### Herramientas Sugeridas

1. Script de validación de nomenclatura (`scripts/validate_naming.sh`)
2. Script de detección de duplicados (`scripts/find_duplicates.sh`)
3. Script de migración automática (`scripts/migrate_naming.sh`)
4. Pre-commit hook para validación (`scripts/pre_commit_naming_check.sh`)

---

## 10. Anexos

### Anexo A: Patrones de Nomenclatura Establecidos

**ADR (Architecture Decision Records):**
```
Patrón: ADR-###-snake_case_title.md
Ejemplo: ADR-001-vagrant-mod-wsgi.md
Frontmatter: id: ADR-###
```

**GUIA (Guías):**
```
Patrón: GUIA-###-snake_case_title.md
Ejemplo: GUIA-001-procesos_vs_procedimientos.md
Frontmatter: id: GUIA-###
```

**PROC (Procesos):**
```
Patrón: PROC-###-snake_case_title.md
Ejemplo: PROC-001-pipeline_trabajo_iact.md
Frontmatter: id: PROC-###
```

**PROCED (Procedimientos):**
```
Patrón: PROCED-###-snake_case_title.md
Ejemplo: PROCED-001-merge_limpieza_ramas.md
Frontmatter: id: PROCED-###
```

**TASK (Tareas):**
```
Patrón: TASK-###-snake_case_title.md
Ejemplo: TASK-004-tests_de_auditoria_inmutable.md
Frontmatter: id: TASK-###
```

### Anexo B: Archivos Aceptables sin Patrón

- `README.md` (estándar GitHub en cualquier directorio)
- `CHANGELOG.md` (estándar GitHub en root)
- `INDEX.md` (archivos índice)
- `INDICE_*.md` (archivos índice en español)
- `plantilla_*.md` (plantillas en directorio plantillas/)
- Archivos temporales en qa/ con fecha: `*_2025_11_17.md`

### Anexo C: Referencias

- `GUIA-001-procesos_vs_procedimientos.md` - Define diferencia entre proceso y procedimiento
- `GUIA_ESTILO.md` - Estándares de documentación (necesita actualización)
- `adr/plantilla_adr.md` - Plantilla oficial para ADRs

---

## Fin del Reporte

**Generado:** 2025-11-17
**Autor:** Claude Code (Sonnet 4.5)
**Versión:** 1.0.0
**Estado:** Completo

---

**Próximos pasos:** Revisar Plan de Remediación (Sección 7) y ejecutar acciones según prioridad.
