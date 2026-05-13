---
id: TASK-REORG-INFRA-011
tipo: tarea_reorganizacion
categoria: consolidacion
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: ALTA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-004]
tags: [planificacion, consolidacion]
tecnica_prompting: Decomposed Prompting
---

# TASK-REORG-INFRA-011: Consolidar Planificación

## Objetivo
Consolidar todos los archivos de planificación dispersos en la codebase en una estructura unificada bajo `planificacion/` para mejorar discoverability, mantenibilidad y consistencia en la documentación de planes de implementación, roadmaps y estrategias.

## Problema Identificado

La codebase presenta una **dispersión crítica de archivos de planificación** en múltiples ubicaciones:

### Directorios Encontrados
```
docs/gobernanza/plans/               ← ANTIGUA
docs/gobernanza/planificacion/       ← NUEVA
docs/infraestructura/plan/           ← ANTIGUA
docs/infraestructura/plans/          ← ANTIGUA
docs/infraestructura/planificacion/  ← NUEVA
docs/ai/plans/                       ← ANTIGUA
docs/ai/planificacion_y_releases/    ← MIXTA
docs/frontend/plans/                 ← ANTIGUA
docs/frontend/planificacion_y_releases/ ← MIXTA
docs/devops/git/planificacion/       ← NUEVA
docs/devops/automatizacion/planificacion/ ← NUEVA
```

### Problemas Originados
- **Inconsistencia de nomenclatura**: plans vs plan vs planificacion
- **Dificultad de búsqueda**: Usuarios no saben dónde buscar planes
- **Duplicación**: Potencial de planes duplicados en múltiples ubicaciones
- **Mantenimiento**: Más superficie de error al actualizar documentación
- **Falta de centralización**: No hay una fuente única de verdad para planes

## Archivos a Consolidar

### Planes en Gobernanza (docs/gobernanza/)
```
plans/
├── REV_20251112_remediation_plan.md
└── [otros planes de remediación]

planificacion/
├── PLAN_REMEDIACION_DOCS_GOBERNANZA.md
└── [planes específicos de gobernanza]
```

### Planes en Infraestructura (docs/infraestructura/)
```
plan/
├── SPEC_INFRA_001_cpython_precompilado_plan.md
├── planificacion_y_releases/
└── [otros especificaciones de plan]

plans/
└── [planes de infraestructura]

planificacion/
└── [planes de planificación]
```

### Planes en IA (docs/ai/)
```
plans/
├── EXECPLAN_prompt_techniques_catalog.md
├── EXECPLAN_meta_agente_codex.md
├── EXECPLAN_context_memory_management.md
├── EXECPLAN_codex_mcp_multi_llm.md
└── EXECPLAN_agents_domain_alignment.md

PLAN_EJECUCION_COMPLETO.md
└── [plan de ejecución maestro]

planificacion_y_releases/
└── [planes de release]
```

### Planes en DevOps (docs/devops/)
```
git/planificacion/
├── TESTING_PLAN_GIT_DOCS.md
├── MAINTENANCE_PLAN_GIT_DOCS.md
└── DEPLOYMENT_PLAN_GIT_DOCS.md

automatizacion/planificacion/
├── MAINTENANCE_PLAN.md
├── TESTING_PLAN.md
└── DEPLOYMENT_PLAN.md
```

### Planes en Backend (docs/backend/)
```
deployment/
└── deployment_plan.md

planificacion_documentacion.md
└── [planes de documentación]
```

### Planes en Frontend (docs/frontend/)
```
plans/
└── [planes de frontend]

planificacion_y_releases/
└── [planes de release]
```

## Estructura Consolidada Propuesta

```
docs/
├── gobernanza/
│   └── planificacion/
│       ├── README.md (índice de planes gobernanza)
│       ├── planes_remediacion/
│       │   ├── PLAN_REMEDIACION_DOCS_GOBERNANZA.md
│       │   └── REV_20251112_remediation_plan.md
│       ├── planes_generales/
│       │   └── plan_general.md
│       └── roadmaps/
│           └── [roadmaps de gobernanza]
│
├── infraestructura/
│   └── planificacion/
│       ├── README.md (índice de planes infraestructura)
│       ├── especificaciones/
│       │   └── SPEC_INFRA_001_cpython_precompilado_plan.md
│       ├── release_management/
│       │   └── [planes de release]
│       └── deployment/
│           └── [deployment plans]
│
├── ai/
│   └── planificacion/
│       ├── README.md (índice de planes IA)
│       ├── ejecucion/
│       │   ├── PLAN_EJECUCION_COMPLETO.md
│       │   ├── EXECPLAN_prompt_techniques_catalog.md
│       │   ├── EXECPLAN_meta_agente_codex.md
│       │   ├── EXECPLAN_context_memory_management.md
│       │   ├── EXECPLAN_codex_mcp_multi_llm.md
│       │   └── EXECPLAN_agents_domain_alignment.md
│       ├── release_management/
│       │   └── [planes de release y versioning]
│       └── validation/
│           └── [planes de validación de agentes]
│
├── backend/
│   └── planificacion/
│       ├── README.md (índice de planes backend)
│       ├── deployment/
│       │   └── deployment_plan.md
│       ├── documentacion/
│       │   └── planificacion_documentacion.md
│       └── qa/
│           └── [planes de QA]
│
├── frontend/
│   └── planificacion/
│       ├── README.md (índice de planes frontend)
│       ├── release_management/
│       │   └── [planes de release]
│       └── ui_ux/
│           └── [planes de UI/UX]
│
└── devops/
    ├── git/
    │   └── planificacion/
    │       ├── README.md
    │       ├── TESTING_PLAN_GIT_DOCS.md
    │       ├── MAINTENANCE_PLAN_GIT_DOCS.md
    │       └── DEPLOYMENT_PLAN_GIT_DOCS.md
    │
    └── automatizacion/
        └── planificacion/
            ├── README.md
            ├── MAINTENANCE_PLAN.md
            ├── TESTING_PLAN.md
            └── DEPLOYMENT_PLAN.md
```

## Pasos de Ejecución

### Fase 1: Análisis e Inventario (Paso 1-2)
- [ ] Ejecutar script de análisis para mapear todos los archivos de planificación
- [ ] Crear inventario completo con rutas actuales y destinos propuestos
- [ ] Documentar dependencias entre planes

### Fase 2: Reorganización Estructural (Paso 3-5)
- [ ] Crear directorios `planificacion/` en cada módulo (gobernanza, infraestructura, ai, backend, frontend, devops)
- [ ] Crear subdirectorios temáticos (ejecucion, release_management, deployment, etc.)
- [ ] Crear archivos README.md en cada planificacion/ con índice de planes

### Fase 3: Migración de Archivos (Paso 6-7)
- [ ] Mover archivos desde `plan/`, `plans/`, `planificacion_y_releases/` al nuevo `planificacion/`
- [ ] Eliminar directorios antiguos (mantener .gitkeep temporalmente)
- [ ] Actualizar referencias y enlaces internos en documentos movidos

### Fase 4: Validación y Documentación (Paso 8-9)
- [ ] Verificar integridad: Todos los planes están en `planificacion/`
- [ ] Validar que no hay planes orfandos en ubicaciones antiguas
- [ ] Generar reporte de migración
- [ ] Documentar cambios en este archivo

### Fase 5: Integración de Mejoras (Paso 10)
- [ ] Crear índice maestro global de planes
- [ ] Actualizar links en documentación principal
- [ ] Crear guía de convención de nombres para planes

## Deliverables

1. **Estructura Consolidada**: Todos los planes en directorios `planificacion/` por módulo
2. **Índices README.md**: Un README en cada `planificacion/` listando todos los planes
3. **Reporte de Migración**: Documento detallando qué se movió, cuándo y por qué
4. **Validación Self-Consistency**: Verificación de que 100% de planes están consolidados
5. **Guía de Convenciones**: Documento sobre cómo nombrar y ubicar futuros planes
6. **Actualización de Referencias**: Links internos apuntan a nuevas ubicaciones

## Dependencias

**Bloqueado por**: TASK-REORG-INFRA-004 (Reorganización de estructura base)

## Métricas de Éxito

- [ ] 0 archivos `*plan*.md` dispersos fuera de `planificacion/`
- [ ] 100% de planes documentados en índices README
- [ ] 0 enlaces rotos a planes
- [ ] Self-consistency: Verificación de cobertura total
- [ ] Documentación actualizada reflejando nueva estructura

## Técnicas de Prompting Utilizadas

**Decomposed Prompting**: Dividir la consolidación en fases discretas:
1. Análisis y mapeo de archivos existentes
2. Diseño de estructura consolidada
3. Ejecución de migración
4. Validación y documentación

**Self-Consistency**: Múltiples pasadas de verificación para confirmar que:
- Todos los `*plan*.md` están en `planificacion/`
- No hay duplicados
- Todas las referencias están actualizadas
- La cobertura es 100%

## Notas Importantes

- Esta tarea requiere validación cuidadosa de referencias cruzadas
- Algunos planes pueden ser interdependientes - manejar con cuidado
- Mantener historial git limpio con commits descriptivos
- Considerar migración gradual si hay muchas dependencias activas
- Documentar cualquier plan especial o excepción encontrada

---

**Creado**: 2025-11-18
**Última actualización**: 2025-11-18
**Responsable**: IACT Infrastructure Team
**Estado**: Pendiente de Ejecución
