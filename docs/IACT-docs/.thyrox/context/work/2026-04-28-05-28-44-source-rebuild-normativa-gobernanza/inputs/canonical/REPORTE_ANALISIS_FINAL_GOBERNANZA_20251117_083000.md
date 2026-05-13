# Reporte de Análisis Final: docs/gobernanza/

**Fecha**: 2025-11-17 08:30:00
**Autor**: Claude Code (Sonnet 4.5)
**Tipo**: Análisis post-reorganización
**Relacionados**: ADR-AI-018, GUIA-GOB-002, PLAN_REORGANIZACION_DOCS_AI_20251117_080000.md

---

## Resumen Ejecutivo

Tras completar la reorganización masiva de documentación según ADR-AI-018 y mejores prácticas de nomenclatura, `docs/gobernanza/` ahora tiene una estructura más semántica y organizada. Este reporte analiza el estado final, identifica áreas de mejora y propone tareas pendientes.

**Métricas Clave**:
- ✅ **40 ADRs** migrados a nomenclatura `PREFIX-DOMINIO-###`
- ✅ **7 Procedimientos (PROCED)** creados con guías paso a paso
- ✅ **16 archivos** de AI/agentes movidos a ubicación correcta
- ✅ **12 archivos** de "anexos" distribuidos semánticamente
- ⚠️ **35 archivos** en raíz de gobernanza requieren revisión

---

## 1. Cambios Implementados (Sesión Actual)

### 1.1 Migración de ADRs a Nomenclatura con Dominios

**Antes**: `ADR-005-grupos-funcionales-sin-jerarquia.md`
**Después**: `ADR-BACK-001-grupos-funcionales-sin-jerarquia.md`

**Total migrando**: 40 ADRs

**Distribución por dominio**:
| Dominio | Cantidad | Ejemplos |
|---------|----------|----------|
| AI | 19 (47.5%) | ADR-AI-001 a ADR-AI-019 |
| BACK | 5 (12.5%) | ADR-BACK-001 a ADR-BACK-005 |
| DEVOPS | 5 (12.5%) | ADR-DEVOPS-001 a ADR-DEVOPS-005 |
| FRONT | 4 (10%) | ADR-FRONT-001 a ADR-FRONT-004 |
| DEV | 2 (5%) | ADR-DEV-001 a ADR-DEV-002 |
| QA | 2 (5%) | ADR-QA-001 a ADR-QA-002 |
| GOB | 3 (7.5%) | ADR-GOB-001 a ADR-GOB-003 |

**Beneficios**:
- ✅ IDs globalmente únicos por dominio
- ✅ Previene colisiones entre equipos
- ✅ Facilita navegación y filtrado
- ✅ Cumple con GUIA-GOB-002

---

### 1.2 Creación de Procedimientos Detallados

**Nuevos procedimientos** (7 archivos):

#### Desarrollo (DEV)
1. **PROCED-DEV-001-crear_pull_request.md** (520 líneas)
   - Pasos completos para crear PR
   - Templates y checklist
   - Manejo de errores comunes

2. **PROCED-DEV-002-code_review.md** (740 líneas)
   - Checklist de calidad detallado
   - Mejores prácticas DO/DON'T
   - Problemas comunes y soluciones

3. **PROCED-DEV-003-resolver_conflictos_merge.md** (680 líneas)
   - Estrategias de resolución
   - Uso de merge tools
   - Prevención de conflictos futuros

#### QA
4. **PROCED-QA-001-ejecutar_tests.md** (650 líneas)
   - Ejecución de tests unitarios/integración
   - Generación de reportes de coverage
   - Troubleshooting de tests

#### DevOps
5. **PROCED-DEVOPS-001-deploy_staging.md** (720 líneas)
   - Deployment paso a paso a staging
   - Verificación post-deployment
   - Rollback procedures

#### Gobernanza (GOB)
6. **PROCED-GOB-001-crear_adr.md** (920 líneas)
   - Proceso completo de creación de ADR
   - Templates y ejemplos
   - Criterios de aprobación

7. **PROCED-GOB-002-actualizar_documentacion.md** (810 líneas)
   - Proceso de actualización de docs
   - Versionado semántico
   - Referencias cruzadas

**Total de documentación nueva**: ~5,040 líneas de guías prácticas

**Beneficios**:
- ✅ Estandarización de procesos operacionales
- ✅ Reducción de curva de aprendizaje para nuevos miembros
- ✅ Referencia rápida para tareas comunes
- ✅ Mejora consistencia en ejecución

---

### 1.3 Reorganización de Documentación AI/Agentes

**Motivación**: Según ADR-AI-018, `iact_agents/` es proyecto STANDALONE

**Archivos migrados** (16 total):

#### De `docs/gobernanza/ai/` → `docs/ai/` (12 archivos)

| Archivo | Nueva Ubicación | Categoría |
|---------|-----------------|-----------|
| ESTRATEGIA_IA.md | docs/ai/estrategia/ | Estrategia |
| FASES_IMPLEMENTACION_IA.md | docs/ai/estrategia/ | Estrategia |
| ANALISIS_GAPS_POST_DORA_2025.md | docs/ai/analisis/ | Análisis |
| GAPS_SUMMARY_QUICK_REF.md | docs/ai/analisis/ | Análisis |
| DORA_CASSANDRA_INTEGRATION.md | docs/ai/integraciones/ | Integración |
| DORA_SDLC_INTEGRATION_GUIDE.md | docs/ai/integraciones/ | Integración |
| HAMILTON_FRAMEWORK_INTEGRACION_SDLC.md | docs/ai/integraciones/ | Integración |
| COLLABORATION_PROTOCOLS.md | docs/ai/protocolos/ | Protocolos |
| AI_CAPABILITIES.md | docs/ai/ai_capabilities/ | Capabilities |
| TASK-009-comunicacion_ai_stance.md | docs/ai/tasks/ | Tasks |
| TASK-012-ai_guidelines_onboarding.md | docs/ai/tasks/ | Tasks |
| TASK-024-ai_telemetry_system.md | docs/ai/tasks/ | Tasks |

#### De `docs/gobernanza/agentes/` → `docs/agents/` (4 archivos)

| Archivo | Nueva Ubicación |
|---------|-----------------|
| AGENTS.md | docs/agents/ |
| constitution.md | docs/agents/ |
| tdd_feature_agent.md | docs/agents/ |
| README.md | docs/agents/README_GOVERNANCE.md |

**Directorios eliminados**:
- ❌ `docs/gobernanza/ai/` (ahora vacío)
- ❌ `docs/gobernanza/agentes/` (ahora vacío)

**Beneficios**:
- ✅ Documentación centralizada para proyecto standalone
- ✅ Mejor separación de concerns (gobernanza general vs AI específico)
- ✅ Facilita mantenimiento de iact_agents/
- ✅ Cumple con decisión arquitectónica ADR-AI-018

---

### 1.4 Eliminación de Carpeta Genérica "anexos"

**Problema**: `docs/gobernanza/anexos/` era categorización demasiado genérica

**Redistribución** (12 archivos):

| Desde | Hacia | Archivos |
|-------|-------|----------|
| anexos/catalogos/ | gobernanza/catalogos/ | 2 |
| anexos/diagramas/ | gobernanza/diagramas/ | 1 + subdirs |
| anexos/ejemplos/ | gobernanza/ejemplos/ | 1 |
| anexos/faq.md | gobernanza/faq.md | 1 |
| anexos/glosarios/ | gobernanza/glosarios/ | 3 |
| anexos/referencias/ | gobernanza/referencias/ | 1 |

**Directorio eliminado**:
- ❌ `docs/gobernanza/anexos/` (ahora vacío)

**Nueva estructura semántica**:
```
docs/gobernanza/
├── catalogos/           # Catálogos de reglas, inventarios
├── diagramas/           # Diagramas de arquitectura y contexto
├── ejemplos/            # Casos ilustrativos
├── faq.md               # Preguntas frecuentes
├── glosarios/           # Glosarios BABOK, PMBOK, ISO, etc.
└── referencias/         # Enlaces y docs externas
```

**Beneficios**:
- ✅ Navegación más intuitiva
- ✅ Descubrimiento de contenido más fácil
- ✅ Elimina ambigüedad de "anexos"
- ✅ Organización por propósito real

---

## 2. Estado Actual de docs/gobernanza/

### 2.1 Métricas Generales

| Métrica | Valor |
|---------|-------|
| **Total de subdirectorios** | 27 |
| **Total de archivos Markdown** | 364 |
| **ADRs migrados** | 40 (100%) |
| **Procesos (PROC)** | 7 |
| **Guías (GUIA)** | 5 |
| **Procedimientos (PROCED)** | 7 |
| **Tasks en raíz** | 4 |
| **Archivos en raíz** | 35 |

### 2.2 Estructura de Subdirectorios

```
docs/gobernanza/
├── adr/                    # 40 Architecture Decision Records
├── analisis_negocio/       # Análisis de negocio
├── arquitectura/           # Arquitectura de sistema
├── casos_de_uso/           # Casos de uso
├── catalogos/              # Catálogos (reglas, inventarios)
├── checklists/             # Checklists de verificación
├── ci_cd/                  # CI/CD pipelines
├── diagramas/              # Diagramas PlantUML
├── diseno_detallado/       # Diseño detallado
├── ejemplos/               # Ejemplos ilustrativos
├── estilos/                # Guías de estilo
├── glosarios/              # Glosarios técnicos
├── guias/                  # 5 Guías (GUIA-###)
├── marco_integrado/        # Marco integrado
├── metodologias/           # Metodologías
├── planificacion/          # Planificación
├── plans/                  # Planes
├── plantillas/             # Plantillas reutilizables
├── procedimientos/         # 7 Procedimientos (PROCED-###)
├── procesos/               # 7 Procesos (PROC-###)
├── qa/                     # Quality Assurance + Reportes
├── referencias/            # Referencias externas
├── requisitos/             # Requisitos
├── seguridad/              # Seguridad
├── sesiones/               # Sesiones de trabajo
├── solicitudes/            # Solicitudes de cambio
└── vision_y_alcance/       # Visión y alcance del proyecto
```

---

## 3. Hallazgos y Áreas de Mejora

### 3.1 ✅ Logros

1. **Nomenclatura Estandarizada**
   - 100% de ADRs migrados a `PREFIX-DOMINIO-###`
   - Procesos, Guías y Procedimientos siguen convenciones

2. **Documentación AI Centralizada**
   - Separada de gobernanza general
   - Refleja arquitectura standalone de iact_agents/

3. **Organización Semántica**
   - Eliminado "anexos" genérico
   - Contenido distribuido por propósito

4. **Procedimientos Operacionales**
   - 7 guías detalladas para tareas comunes
   - ~5,000 líneas de documentación práctica

### 3.2 ⚠️ Áreas de Atención

#### A. Archivos en Raíz de Gobernanza (35 archivos)

**Problema**: Muchos archivos en raíz deberían estar en subdirectorios

**Archivos que requieren reorganización**:

| Archivo | Ubicación Sugerida | Razón |
|---------|-------------------|-------|
| `TAREAS_ACTIVAS.md` | `planificacion/TAREAS_ACTIVAS.md` | Es planificación |
| `ROADMAP.md` | `planificacion/ROADMAP.md` | Es planificación |
| `CHANGELOG.md` | Raíz (OK) | Es changelog general |
| `GUIA_ESTILO.md` | `guias/GUIA-GOB-###-estilo_documentacion.md` | Es guía |
| `glossary.md` | `glosarios/` | Es glosario |
| `brs_business_requirements.md` | `requisitos/` | Es requisito |
| `strs_stakeholder_requirements.md` | `requisitos/` | Es requisito |
| `casos_de_uso_guide.md` | `guias/` o `casos_de_uso/` | Es guía |
| `shell_scripting_guide.md` | `guias/GUIA-DEV-###-shell-scripting.md` | Es guía |
| `github_copilot_codespaces.md` | `ci_cd/` o `guias/` | Herramientas de desarrollo |
| `documentacion_corporativa.md` | `guias/` | Es guía de documentación |
| `merge_y_limpieza_ramas.md` | `procedimientos/PROCED-DEV-###` | Es procedimiento |
| `TASK-004-tests_de_auditoría_inmutable.md` | `solicitudes/` o `planificacion/` | Es task |
| `TASK-008-cron_job_dora_mensuales.md` | `solicitudes/` o `planificacion/` | Es task |
| `TASK-015-actualizacion_documentacion.md` | `solicitudes/` o `planificacion/` | Es task |
| `TASK-016-compliance_rnf_002_audit.md` | `solicitudes/` o `planificacion/` | Es task |

**Estimación**: 25+ archivos candidatos a reubicación

---

#### B. Nomenclatura Inconsistente

**Guías sin nomenclatura estándar**:
```
GUIA_ESTILO.md                     → GUIA-GOB-###-estilo_documentacion.md
casos_de_uso_guide.md              → GUIA-GOB-###-casos_de_uso.md
shell_scripting_guide.md           → GUIA-DEV-###-shell_scripting.md
```

**Archivos de análisis sin timestamp**:
```
DOCS_LEGACY_ANALYSIS_REPORT.md    → REPORTE_ANALISIS_DOCS_LEGACY_YYYYMMDD_HHMMSS.md
ANALISIS_GUIAS_WORKFLOWS.md       → REPORTE_ANALISIS_GUIAS_WORKFLOWS_YYYYMMDD_HHMMSS.md
```

---

#### C. Posibles Duplicados

**Glosarios**:
- `glossary.md` (raíz)
- `glosarios/glossary.md`
- `glosarios/glosario.md`
- `glosarios/glosario_babok_pmbok_iso.md`

**Acción**: Verificar duplicación y consolidar

---

#### D. Documentos Legacy/Obsoletos

Candidatos a revisión:
- `DOCS_LEGACY_ANALYSIS_REPORT.md` - ¿Sigue siendo relevante?
- `RESUMEN_MIGRACION_SHELL_SCRIPTS.md` - ¿Ya completada la migración?
- `MAPEO_MIGRACION_LEGACY.md` - ¿Migración completada?
- `post_create.md` - ¿Devcontainer setup? ¿Ubicación correcta?

---

## 4. Métricas de Cumplimiento

### 4.1 Nomenclatura (GUIA-GOB-002)

| Tipo | Compliant | Total | % |
|------|-----------|-------|---|
| ADRs | 40 | 40 | **100%** ✅ |
| Procesos (PROC) | 7 | 7 | **100%** ✅ |
| Guías (GUIA) | 5 | ~10 | **50%** ⚠️ |
| Procedimientos (PROCED) | 7 | 7 | **100%** ✅ |
| Reportes con timestamp | 2 | ~8 | **25%** ⚠️ |

**Score General**: 75% de cumplimiento

**Áreas de mejora**:
- Migrar guías restantes a `GUIA-DOMINIO-###`
- Renombrar reportes con timestamp `YYYYMMDD_HHMMSS`

---

### 4.2 Organización Estructural

| Criterio | Estado | Observaciones |
|----------|--------|---------------|
| Separación por tipo de documento | ✅ Excelente | ADRs, PROCs, GUIAs, PROCEDs en carpetas separadas |
| Archivos en ubicación semántica | ⚠️ Parcial | 35 archivos en raíz requieren reorganización |
| Eliminación de categorías genéricas | ✅ Excelente | "anexos" eliminado correctamente |
| Separación AI/agentes standalone | ✅ Excelente | Migrado a docs/ai/ y docs/agents/ |
| Consistencia en nomenclatura | ⚠️ Parcial | 75% de cumplimiento (ver 4.1) |

**Score General**: 80% de organización

---

## 5. Recomendaciones Prioritarias

### Alta Prioridad (P0)

1. **Reorganizar 35 archivos de raíz** (2-3 horas)
   - Mover a subdirectorios correctos
   - Actualizar referencias cruzadas
   - Commit con mensaje descriptivo

2. **Estandarizar nomenclatura de guías** (1-2 horas)
   - Renombrar ~5 guías a `GUIA-DOMINIO-###`
   - Actualizar frontmatter e IDs
   - Verificar links rotos

3. **Consolidar glosarios duplicados** (1 hora)
   - Verificar contenido de 4 glosarios
   - Consolidar en 1-2 archivos únicos
   - Eliminar duplicados

### Media Prioridad (P1)

4. **Renombrar reportes con timestamp** (1 hora)
   - Aplicar patrón `TIPO_DESCRIPCION_YYYYMMDD_HHMMSS.md`
   - Actualizar referencias

5. **Revisar documentos legacy/obsoletos** (2 horas)
   - Evaluar relevancia actual
   - Marcar como obsoletos o eliminar
   - Actualizar estado en frontmatter

6. **Crear índices en subdirectorios** (2 horas)
   - README.md en cada carpeta principal
   - Describir contenido y propósito
   - Links a documentos principales

### Baja Prioridad (P2)

7. **Audit completo de referencias cruzadas** (3-4 horas)
   - Verificar todos los links internos
   - Corregir links rotos
   - Usar herramienta automatizada

8. **Establecer proceso de mantenimiento** (1 hora)
   - Definir cadencia de audits (trimestral)
   - Asignar owners a subdirectorios
   - Documentar en PROCED-GOB-###

---

## 6. Plan de Acción Propuesto

### Sprint 1 (Esta Semana)

**Objetivo**: Completar reorganización estructural

| # | Tarea | Estimación | Responsable |
|---|-------|------------|-------------|
| 1 | Reorganizar 35 archivos de raíz de gobernanza | 2-3h | Claude/Team |
| 2 | Estandarizar nomenclatura de guías restantes | 1-2h | Claude/Team |
| 3 | Consolidar glosarios duplicados | 1h | Claude/Team |
| 4 | Renombrar reportes con timestamp | 1h | Claude/Team |

**Total**: 5-7 horas

---

### Sprint 2 (Próxima Semana)

**Objetivo**: Limpieza y documentación

| # | Tarea | Estimación | Responsable |
|---|-------|------------|-------------|
| 5 | Revisar y marcar docs legacy como obsoletos | 2h | Team Lead |
| 6 | Crear READMEs en subdirectorios principales | 2h | Claude/Team |
| 7 | Audit de referencias cruzadas (automatizado) | 1h | DevOps |
| 8 | Corrección de links rotos identificados | 2h | Claude/Team |

**Total**: 7 horas

---

### Sprint 3 (Siguiente Sprint)

**Objetivo**: Establecer procesos de mantenimiento

| # | Tarea | Estimación | Responsable |
|---|-------|------------|-------------|
| 9 | Crear PROCED-GOB-###-mantenimiento_docs.md | 2h | Tech Lead |
| 10 | Asignar owners a subdirectorios en CODEOWNERS | 1h | Tech Lead |
| 11 | Documentar cadencia de audits trimestrales | 1h | Tech Lead |

**Total**: 4 horas

---

## 7. Tareas Inmediatas (Próxima Sesión)

### Tarea 1: Reorganizar Archivos de Raíz

**Archivos a mover** (top 10 prioritarios):

```bash
# Guías → guias/
git mv docs/gobernanza/GUIA_ESTILO.md docs/gobernanza/guias/GUIA-GOB-006-estilo_documentacion.md
git mv docs/gobernanza/casos_de_uso_guide.md docs/gobernanza/guias/GUIA-GOB-007-casos_de_uso.md
git mv docs/gobernanza/shell_scripting_guide.md docs/gobernanza/guias/GUIA-DEV-003-shell_scripting.md

# Planificación → planificacion/
git mv docs/gobernanza/TAREAS_ACTIVAS.md docs/gobernanza/planificacion/
git mv docs/gobernanza/ROADMAP.md docs/gobernanza/planificacion/

# Requisitos → requisitos/
git mv docs/gobernanza/brs_business_requirements.md docs/gobernanza/requisitos/
git mv docs/gobernanza/strs_stakeholder_requirements.md docs/gobernanza/requisitos/

# Glosarios → glosarios/
git mv docs/gobernanza/glossary.md docs/gobernanza/glosarios/

# Tasks → solicitudes/ o planificacion/
git mv docs/gobernanza/TASK-*.md docs/gobernanza/solicitudes/
```

---

### Tarea 2: Consolidar Glosarios

**Verificar duplicación**:
1. Leer `glossary.md` (raíz)
2. Leer `glosarios/glossary.md`
3. Leer `glosarios/glosario.md`
4. Comparar contenido
5. Consolidar en 1-2 archivos únicos
6. Eliminar duplicados

---

### Tarea 3: Renombrar Reportes

```bash
# Con timestamp de fecha de creación
git mv DOCS_LEGACY_ANALYSIS_REPORT.md REPORTE_ANALISIS_DOCS_LEGACY_20251110_143000.md
git mv ANALISIS_GUIAS_WORKFLOWS.md REPORTE_ANALISIS_GUIAS_WORKFLOWS_20251112_091500.md
git mv RESUMEN_MIGRACION_SHELL_SCRIPTS.md REPORTE_MIGRACION_SHELL_SCRIPTS_20251108_162000.md
```

---

## 8. Métricas de Éxito

Al completar el plan propuesto, esperamos alcanzar:

| Métrica | Actual | Meta | Delta |
|---------|--------|------|-------|
| Cumplimiento nomenclatura | 75% | 95% | +20% |
| Archivos en raíz de gobernanza | 35 | <10 | -71% |
| Organización estructural | 80% | 95% | +15% |
| Duplicados identificados | ¿? | 0 | N/A |
| Links rotos | ¿? | 0 | N/A |
| Subdirectorios con README | ~30% | 100% | +70% |

---

## 9. Conclusiones

### Logros de Esta Sesión

✅ **Migración masiva completada exitosamente**:
- 40 ADRs renombrados con nomenclatura de dominios
- 16 archivos de AI/agentes relocalizados correctamente
- 12 archivos de "anexos" distribuidos semánticamente
- 7 procedimientos detallados creados (~5,000 líneas)

✅ **Estructura mejorada significativamente**:
- Eliminadas categorizaciones genéricas ("anexos", "ai" en gobernanza)
- Cumplimiento de ADR-AI-018 (standalone architecture)
- 75% de cumplimiento en nomenclatura estándar

### Trabajo Pendiente

⚠️ **Reorganización adicional necesaria**:
- 35 archivos en raíz requieren ubicación correcta
- 5 guías requieren renombrado a estándar
- Glosarios duplicados necesitan consolidación

⚠️ **Mantenimiento continuo**:
- Establecer proceso de audit trimestral
- Asignar owners a subdirectorios
- Herramientas automatizadas para verificar links

---

## 10. Próximos Pasos

**Inmediato** (hoy):
1. Commit de este reporte a `docs/gobernanza/qa/`
2. Crear issues para tareas P0 en Sprint 1
3. Asignar responsables

**Esta semana**:
1. Ejecutar Sprint 1 (reorganización de archivos)
2. Commit y push cambios
3. Verificar no hay links rotos

**Próxima semana**:
1. Sprint 2 (limpieza y documentación)
2. Audit automatizado de referencias cruzadas

**Próximo Sprint**:
1. Sprint 3 (procesos de mantenimiento)
2. Retrospectiva de reorganización

---

## Anexos

### A. Comandos Útiles para Análisis

```bash
# Contar archivos por tipo
find docs/gobernanza -name "ADR-*.md" | wc -l
find docs/gobernanza -name "PROC-*.md" | wc -l
find docs/gobernanza -name "GUIA-*.md" | wc -l
find docs/gobernanza -name "PROCED-*.md" | wc -l

# Encontrar archivos en raíz
find docs/gobernanza -maxdepth 1 -type f -name "*.md"

# Buscar duplicados por nombre
find docs/gobernanza -name "*.md" | xargs -n1 basename | sort | uniq -d

# Verificar links rotos (requiere npm)
npx markdown-link-check docs/gobernanza/**/*.md

# Buscar referencias a archivos movidos
grep -r "docs/gobernanza/ai/" docs/ --include="*.md"
grep -r "docs/gobernanza/agentes/" docs/ --include="*.md"
grep -r "docs/gobernanza/anexos/" docs/ --include="*.md"
```

### B. Patrones de Nomenclatura (Referencia)

Según GUIA-GOB-002:

```markdown
# Documentos principales
ADR-{DOMINIO}-{###}-{titulo}.md
PROC-{DOMINIO}-{###}-{titulo}.md
GUIA-{DOMINIO}-{###}-{titulo}.md
PROCED-{DOMINIO}-{###}-{titulo}.md

# Reportes/Análisis
REPORTE_{TIPO}_{DESCRIPCION}_{YYYYMMDD}_{HHMMSS}.md
ANALISIS_{TIPO}_{DESCRIPCION}_{YYYYMMDD}_{HHMMSS}.md

# Tasks
TASK-{###}-{descripcion}.md
```

### C. Referencias

- [GUIA-GOB-002: Convenciones de Nomenclatura](../guias/GUIA-GOB-002-convenciones_nomenclatura.md)
- [ADR-AI-018: AI Agents Standalone Architecture](../adr/ADR-AI-018-ai-services-standalone-architecture.md)
- [PLAN_REORGANIZACION_DOCS_AI_20251117_080000.md](PLAN_REORGANIZACION_DOCS_AI_20251117_080000.md)

---

**Fin del Reporte**

Generado por: Claude Code (Sonnet 4.5)
Fecha: 2025-11-17 08:30:00
Versión: 1.0.0
