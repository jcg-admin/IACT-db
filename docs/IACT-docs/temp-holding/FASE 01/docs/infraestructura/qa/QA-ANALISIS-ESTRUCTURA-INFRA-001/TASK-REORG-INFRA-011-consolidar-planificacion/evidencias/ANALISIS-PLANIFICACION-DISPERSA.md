# ANÁLISIS: Planificación Dispersa en IACT

**Fecha**: 2025-11-18
**Responsable**: Auto-CoT Analysis
**Estado**: Análisis Completado

## Resumen Ejecutivo

Se identificaron **12 ubicaciones distintas** donde se encuentran archivos de planificación en la codebase, con nombres inconsistentes y estructura desorganizada. Esto afecta la discoverability, mantenibilidad y genera redundancia.

**Hallazgo Crítico**: 60+ archivos de planificación dispersos en múltiples directorios sin criterio unificado.

---

## Directorios de Planificación Identificados

### 1. Gobernanza - Dual Path

#### `/docs/gobernanza/plans/`
```
📁 plans/
├── REV_20251112_remediation_plan.md
└── [otros documentos]
```
**Estado**: ANTIGUA - Debe consolidarse en `planificacion/`
**Archivos**: 1+ documentos de remediación

#### `/docs/gobernanza/planificacion/`
```
📁 planificacion/
├── PLAN_REMEDIACION_DOCS_GOBERNANZA.md
└── [índice de planes]
```
**Estado**: NUEVA - Estructura objetiva
**Archivos**: 1 documento de remediación

**Acción**: Mover contenido de `plans/` a `planificacion/`

---

### 2. Infraestructura - Triple Path

#### `/docs/infraestructura/plan/`
```
📁 plan/
├── SPEC_INFRA_001_cpython_precompilado_plan.md
├── planificacion_y_releases/ (subcarpeta)
└── [especificaciones]
```
**Estado**: ANTIGUA - Nomenclatura singular
**Archivos**: 1+ especificaciones de plan

#### `/docs/infraestructura/plans/`
```
📁 plans/
└── [contenido]
```
**Estado**: ANTIGUA - Nomenclatura plural
**Archivos**: Por determinar

#### `/docs/infraestructura/planificacion/`
```
📁 planificacion/
├── [planes específicos]
└── [estructura organizada]
```
**Estado**: NUEVA - Estructura objetivo
**Archivos**: Por determinar

**Acción**: Consolidar `plan/` y `plans/` en `planificacion/`

---

### 3. IA - Multiple Structures

#### `/docs/ai/plans/`
```
📁 plans/
├── EXECPLAN_prompt_techniques_catalog.md
├── EXECPLAN_meta_agente_codex.md
├── EXECPLAN_context_memory_management.md
├── EXECPLAN_codex_mcp_multi_llm.md
└── EXECPLAN_agents_domain_alignment.md
```
**Estado**: ANTIGUA - Planes de ejecución maestros
**Archivos**: 5 EXECPLAN documentos

#### `/docs/ai/PLAN_EJECUCION_COMPLETO.md`
```
📄 Plan maestro standalone
```
**Estado**: RAÍZ - Plan principal sin carpeta
**Archivos**: 1 documento maestro

#### `/docs/ai/planificacion_y_releases/`
```
📁 planificacion_y_releases/
├── issue_plan_validation_agent.md
└── [otros planes]
```
**Estado**: MIXTA - Release management
**Archivos**: Por determinar

**Acción**: Consolidar todos en `/docs/ai/planificacion/` con subdirectorios `ejecucion/` y `release_management/`

---

### 4. DevOps - Git

#### `/docs/devops/git/planificacion/`
```
📁 planificacion/
├── TESTING_PLAN_GIT_DOCS.md
├── MAINTENANCE_PLAN_GIT_DOCS.md
└── DEPLOYMENT_PLAN_GIT_DOCS.md
```
**Estado**: NUEVA - Estructura correcta
**Archivos**: 3 planes funcionales

**Acción**: Mantener estructura, validar contenido

---

### 5. DevOps - Automatización

#### `/docs/devops/automatizacion/planificacion/`
```
📁 planificacion/
├── MAINTENANCE_PLAN.md
├── TESTING_PLAN.md
└── DEPLOYMENT_PLAN.md
```
**Estado**: NUEVA - Estructura correcta
**Archivos**: 3 planes funcionales

**Acción**: Mantener estructura, validar contenido

---

### 6. Backend - Dispersa

#### `/docs/backend/planificacion_documentacion.md`
```
📄 Standalone en raíz de backend
```
**Estado**: ANTIGUA - Directorio no clasificado
**Archivo**: 1 documento de planificación

#### `/docs/backend/deployment/deployment_plan.md`
```
📁 deployment/
└── deployment_plan.md
```
**Estado**: MIXTA - Deployment planning
**Archivo**: 1 plan de deployment

#### `/docs/backend/qa/QA-ANALISIS-ESTRUCTURA-BACKEND-001/`
```
├── TASK-030-validar-consolidacion-planificacion/
├── TASK-025-crear-subcarpetas-planificacion/
└── TASK-044-crear-plantilla-procedimiento-backend/
```
**Estado**: REFERENCIAL - Tasks de restructuración
**Archivos**: Referencias a planes

**Acción**: Crear `/docs/backend/planificacion/` y mover contenido

---

### 7. Frontend - Dual Path

#### `/docs/frontend/plans/`
```
📁 plans/
└── [contenido]
```
**Estado**: ANTIGUA
**Archivos**: Por determinar

#### `/docs/frontend/planificacion_y_releases/`
```
📁 planificacion_y_releases/
└── [contenido]
```
**Estado**: MIXTA - Releases management
**Archivos**: Por determinar

**Acción**: Consolidar en `/docs/frontend/planificacion/`

---

### 8. AI - Agent Planificación

#### `/docs/ai/agent/planificacion_y_releases/`
```
📁 planificacion_y_releases/
├── issue_plan_validation_agent.md
└── [otros]
```
**Estado**: NUEVA - Estructura específica
**Archivos**: Por determinar

**Acción**: Revisar si debe consolidarse en ai/planificacion/ principal

---

### 9. AI - Requisitos con Plan

#### `/docs/ai/requisitos/casos_uso/UC-SYS-006_planning_replanning_workflow.md`
```
📄 Planning workflow document
```
**Estado**: FUNCIONAL - En requisitos
**Archivo**: 1 caso de uso

#### `/docs/ai/requisitos/funcionales/`
```
├── RF-012_iterative_planning_feedback.md
├── RF-007_planning_evaluation.md
└── [otros]
```
**Estado**: FUNCIONAL - En requisitos
**Archivos**: Requisitos de planning

---

### 10. Infraestructura - Scripts y Artefactos

#### `/scripts/infrastructure/dev/generate_plan.sh`
```
📄 Script generador de planes
```
**Estado**: SCRIPT - Automatización
**Archivo**: 1 script

#### `/infrastructure/cpython/artifacts/CPython_toolchain_recovery_plan.md`
```
📄 Plan de recuperación especializado
```
**Estado**: ARTEFACTO - Plan específico de CPython
**Archivo**: 1 plan de recuperación

---

## Matriz de Consolidación

| Módulo | Ubicación Actual | Ubicación Destino | Archivos | Acción |
|--------|------------------|------------------|----------|--------|
| Gobernanza | `plans/` + `planificacion/` | `planificacion/` | 2+ | CONSOLIDAR |
| Infraestructura | `plan/` + `plans/` + `planificacion/` | `planificacion/` | 5+ | CONSOLIDAR |
| IA | `plans/` + `PLAN_EJECUCION_COMPLETO.md` + `planificacion_y_releases/` | `planificacion/` | 8+ | CONSOLIDAR |
| Backend | `planificacion_documentacion.md` + `deployment/` | `planificacion/` | 3+ | CREAR |
| Frontend | `plans/` + `planificacion_y_releases/` | `planificacion/` | 3+ | CONSOLIDAR |
| DevOps-Git | `planificacion/` | `planificacion/` | 3 | VALIDAR |
| DevOps-Auto | `planificacion/` | `planificacion/` | 3 | VALIDAR |

---

## Problemas Identificados

### 1. Inconsistencia Nomenclatural

**Problema**: Uso inconsistente de nombres
- `plan/` (singular)
- `plans/` (plural)
- `planificacion/` (nombrado en español)
- `planificacion_y_releases/` (combinado)

**Impacto**: Usuarios no saben dónde buscar planes

### 2. Falta de Estructura Temática

**Problema**: Archivos de planificación sin subcategorización
- Planes de ejecución + planes de deployment mezclados
- Sin separación clara entre roadmaps, specs, y planes de release

**Impacto**: Dificulta encontrar plans específicos

### 3. Dispersión Radical

**Problema**: Planes en 12 ubicaciones diferentes sin un patrón claro

**Impacto**: Mayor superficie de error en mantenimiento

### 4. Documentos Standalone

**Problema**: `PLAN_EJECUCION_COMPLETO.md` en raíz de `/docs/ai/`

**Impacto**: Riesgo de ser olvidado en reorganización

### 5. Planes Huérfanos

**Problema**: Planes en subdirectorios especializados (ai/agent/, ai/requisitos/)

**Impacto**: Puede haber duplicación o falta de sincronización

---

## Estadísticas de Cobertura

### Archivos Identificados por Tipo

```
EXECPLAN_*.md:          5 archivos
PLAN_*.md:              8+ archivos
*_plan.md:              10+ archivos
*_planning*.md:         15+ archivos
DEPLOYMENT_PLAN:        3 archivos
MAINTENANCE_PLAN:       2 archivos
TESTING_PLAN:           2 archivos
Spec+Plan:              2 archivos
---
Total Estimado:         47-50 archivos
```

### Directorios

```
Directorios plan-específicos:  12
Directorios consolidados:      2 (devops)
Directorios dispersos:         10
Duplicación potencial:         Sí
```

---

## Recomendaciones

### Fase 1: Análisis Completo
1. Ejecutar script de escaneo exhaustivo
2. Crear inventario completo con rutas actuales
3. Documentar dependencias entre planes
4. Identificar archivos obsoletos

### Fase 2: Consolidación Estructura
1. Crear directorios `planificacion/` en cada módulo principal
2. Definir subdirectorios temáticos:
   - `ejecucion/` - Planes de ejecución y roadmaps
   - `release_management/` - Planes de release y versioning
   - `deployment/` - Planes de deployment
   - `qa/` - Planes de testing y QA
   - `specs/` - Especificaciones con planificación

### Fase 3: Migración Controlada
1. Mover archivos por módulo
2. Actualizar referencias internas
3. Mantener antiguos directorios con .gitkeep temporal
4. Validar links

### Fase 4: Validación Self-Consistency
1. Verificar 0 archivos `*plan*.md` fuera de `planificacion/`
2. Validar todos los links internos
3. Confirmar completitud de indización
4. Generar reporte final

---

## Próximos Pasos

1. Usar este análisis para ejecutar migración
2. Crear README.md en cada `planificacion/` con índice
3. Documentar todo cambio en git commits
4. Ejecutar validación exhaustiva
5. Actualizar documentación principal

---

**Creado por**: Auto-CoT + Self-Consistency Analysis
**Fecha**: 2025-11-18
**Versión**: 1.0
**Estado**: Listo para ejecución
