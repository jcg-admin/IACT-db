# Guía de Convenciones: Planes y Planificación en IACT

**Propósito**: Establecer estándares consistentes para ubicación, nomenclatura y estructura de documentos de planificación

**Versión**: 1.0
**Fecha**: 2025-11-18
**Aplicabilidad**: Todos los módulos (gobernanza, infraestructura, ai, backend, frontend, devops)

---

## 1. UBICACIÓN ESTÁNDAR

### Regla Principal
Todos los documentos de planificación DEBEN estar en el directorio `planificacion/` del módulo correspondiente.

### Estructura Obligatoria

```
/docs/
├── gobernanza/
│   └── planificacion/        ← ÚNICA ubicación para plans de gobernanza
│       ├── README.md
│       ├── planes_remediacion/
│       ├── planes_generales/
│       └── roadmaps/
│
├── infraestructura/
│   └── planificacion/        ← ÚNICA ubicación para plans de infraestructura
│       ├── README.md
│       ├── especificaciones/
│       ├── release_management/
│       └── deployment/
│
├── ai/
│   └── planificacion/        ← ÚNICA ubicación para plans de IA
│       ├── README.md
│       ├── ejecucion/
│       ├── release_management/
│       └── validation/
│
├── backend/
│   └── planificacion/        ← ÚNICA ubicación para plans de backend
│       ├── README.md
│       ├── deployment/
│       ├── documentacion/
│       └── qa/
│
├── frontend/
│   └── planificacion/        ← ÚNICA ubicación para plans de frontend
│       ├── README.md
│       ├── release_management/
│       └── ui_ux/
│
└── devops/
    ├── git/
    │   └── planificacion/    ← ÚNICA ubicación para plans de git
    │       ├── README.md
    │       ├── TESTING_PLAN_GIT_DOCS.md
    │       ├── MAINTENANCE_PLAN_GIT_DOCS.md
    │       └── DEPLOYMENT_PLAN_GIT_DOCS.md
    │
    └── automatizacion/
        └── planificacion/    ← ÚNICA ubicación para plans de automatización
            ├── README.md
            ├── MAINTENANCE_PLAN.md
            ├── TESTING_PLAN.md
            └── DEPLOYMENT_PLAN.md
```

### Subcategorías Estándar por Módulo

**Gobernanza**:
- `planes_remediacion/` - Planes de remediación de issues
- `planes_generales/` - Planes estratégicos generales
- `roadmaps/` - Roadmaps y visiones futuras

**Infraestructura**:
- `especificaciones/` - Especificaciones con componente de planificación
- `release_management/` - Planes de release y versioning
- `deployment/` - Planes de despliegue

**IA**:
- `ejecucion/` - Planes de ejecución de agentes y features
- `release_management/` - Planes de release y versioning
- `validation/` - Planes de validación de agentes

**Backend**:
- `deployment/` - Planes de despliegue
- `documentacion/` - Planes de documentación
- `qa/` - Planes de testing y QA

**Frontend**:
- `release_management/` - Planes de release
- `ui_ux/` - Planes de UI/UX y diseño

**DevOps**:
- (Archivos directamente en `planificacion/`)

---

## 2. NOMENCLATURA DE ARCHIVOS

### Patrones Permitidos

#### Pattern 1: Descriptivo Simple
```
[TIPO]_[COMPONENTE]_[DESCRIPCION].md
```

Ejemplos:
- `PLAN_MIGRACION_GITPYTHON.md`
- `PLAN_CONSOLIDACION_DOCS.md`
- `PLAN_RELEASE_v2025.01.md`

#### Pattern 2: Executive/Plan
```
EXEC[PLAN]_[COMPONENTE]_[DESCRIPCION].md
```

Ejemplos (IA):
- `EXECPLAN_prompt_techniques_catalog.md`
- `EXECPLAN_meta_agente_codex.md`
- `EXECPLAN_context_memory_management.md`

#### Pattern 3: Tipo Específico + Nombre
```
[TIPO]_[DESCRIPCION].md
```

Ejemplos:
- `TESTING_PLAN_GIT_DOCS.md`
- `MAINTENANCE_PLAN.md`
- `DEPLOYMENT_PLAN.md`

#### Pattern 4: Especificación + Plan
```
SPEC_[COMPONENTE]_[DESCRIPCION]_plan.md
```

Ejemplos:
- `SPEC_INFRA_001_cpython_precompilado_plan.md`

### Reglas de Nomenclatura

✓ **DEBE**:
- Usar CamelCase o UPPER_CASE_WITH_UNDERSCORES
- Incluir palabra clave clara: PLAN, EXECPLAN, SPEC, TESTING, MAINTENANCE, DEPLOYMENT
- Ser descriptivo del contenido
- Usar idioma consistente (preferentemente inglés o español, no mezclar)
- Numeración si hay series: PLAN_001, PLAN_002, etc.

✗ **NO DEBE**:
- Usar caracteres especiales excepto `_` y `-`
- Mezclar estilos (CamelCase + UPPER_CASE)
- Abreviaturas crípticas sin contexto
- Nombres vagos: plan.md, planning.md, doc.md
- Caracteres acentuados excepto en metadata/contenido

### Ejemplos Correctos vs Incorrectos

| Incorrecto | Correcto | Categoría |
|-----------|----------|-----------|
| `planning_doc.md` | `PLAN_RELEASE_v2025.md` | Release Planning |
| `spec.md` | `SPEC_INFRA_CPYTHON_PLAN.md` | Infrastructure Spec |
| `roadmap.pdf` | `ROADMAP_2025_GOBERNANZA.md` | Strategic Roadmap |
| `plan 01.md` | `PLAN_MIGRACION_001.md` | Migration Plan |
| `implementação.md` | `PLAN_IMPLEMENTACION_FEATURE.md` | Implementation Plan |

---

## 3. ESTRUCTURA INTERNA DE DOCUMENTOS

### Frontmatter Obligatorio

```yaml
---
id: [PLAN_ID]
tipo: plan
categoria: [Categoría]
modulo: [Módulo]
version: 1.0
fecha_creacion: YYYY-MM-DD
fecha_ultima_actualizacion: YYYY-MM-DD
responsable: [Nombre/Equipo]
estado: [borrador|pendiente|en_progreso|completado]
duracion_estimada: [Nh o Nd]
tags: [tag1, tag2, tag3]
Referencias_Relacionadas: [PLAN_ID_2, PLAN_ID_3]
---
```

### Estructura de Contenido Recomendada

```markdown
# Título del Plan

## Objetivo
[1-2 párrafos claros del propósito]

## Contexto
[Contexto y problema que se resuelve]

## Scope
[Qué se incluye y qué se excluye]

## Fases / Etapas
### Fase 1: [Nombre]
- Duración: [tiempo]
- Responsable: [rol/persona]
- Entregables:
  - Deliverable 1
  - Deliverable 2

### Fase 2: [Nombre]
[...]

## Timeline
[Tabla o diagrama de Gantt]

## Recursos Requeridos
- Personal: [rol, cantidad]
- Infraestructura: [recursos técnicos]
- Budget: [si aplica]

## Riesgos y Mitigación
| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|-----------|

## Validación/Criterios de Éxito
- [ ] Criterio 1
- [ ] Criterio 2

## Dependencias
- PLAN_OTRO_001
- TASK-XXX-YYY

## Contacto
- **Responsable Principal**: [nombre]
- **Revisores**: [nombres]
- **Stakeholders**: [equipos]

---
**Última Actualización**: [YYYY-MM-DD]
**Versión**: [1.0]
```

### Nivel de Detalle por Tipo

#### Plans Estratégicos (Roadmaps, Visiones)
- Más abstracción
- Menos detalles técnicos
- Focus en objetivos a largo plazo

#### Plans Tácticos (Release, Deployment)
- Balance de abstracción y detalles
- Timeline claro
- Responsabilidades definidas

#### Plans de Ejecución (Técnicos)
- Detalle alto
- Pasos específicos
- Consideraciones técnicas profundas

---

## 4. ACTUALIZACIÓN Y MANTENIMIENTO

### Versionado

```
version: 1.0    ← Major.Minor (1.0, 1.1, 2.0, etc.)
fecha_ultima_actualizacion: 2025-11-18
```

- **Minor updates** (1.0 → 1.1): Cambios pequeños, clarificaciones, actualizaciones de timeline
- **Major updates** (1.0 → 2.0): Cambios fundamentales de scope, objetivo, o dirección

### Ciclo de Vida de un Plan

1. **Borrador**: Creación inicial, en revisión
   - `estado: borrador`
   - Sin publicación oficial

2. **Pendiente**: Aprobado, aún no iniciado
   - `estado: pendiente`
   - Público en documentación

3. **En Progreso**: Ejecución activa
   - `estado: en_progreso`
   - Actualizaciones regulares (bi-weekly)

4. **Completado**: Ejecución finalizada
   - `estado: completado`
   - Documento de cierre
   - Lecciones aprendidas

### Cadencia de Actualización

- **Plans en progreso**: Mínimo semanal
- **Plans completados**: Archivo, sin cambios (excepto lecciones aprendidas)
- **Roadmaps/Estratégicos**: Trimestral o cuando hay cambios significativos

### Archivo y Retención

Planes completados se mantienen en estructura original pero marcados como `completado`. Opcionalmente pueden moverse a:
```
planificacion/
└── archivos/
    └── [planes completados 2024-2025]/
```

---

## 5. REFERENCIAS Y ENLACES

### Estructura de Referencias

Dentro de plans, usar rutas relativas:

```markdown
[Ver Plan de Release](./release_management/PLAN_RELEASE_v2.0.md)
[Especificación](../infraestructura/planificacion/especificaciones/SPEC_INFRA_001.md)
[Ver ADR-XXX](/docs/gobernanza/adr/ADR-XXX.md)
```

### Links Internos de Documentación

```markdown
### Documentación Relacionada
- [Plan de Infraestructura](/docs/infraestructura/planificacion/README.md)
- [Especificación CPython](/docs/infraestructura/planificacion/especificaciones/SPEC_INFRA_001.md)
- [Roadmap 2025](/docs/gobernanza/planificacion/roadmaps/ROADMAP_2025.md)
```

### Referencias Cruzadas

Cuando un plan depende de otro:
```yaml
dependencias:
  - /docs/infraestructura/planificacion/especificaciones/SPEC_INFRA_001.md
  - PLAN_ID_2
```

---

## 6. ÍNDICES Y DESCUBRIMIENTO

### README.md Obligatorio en Cada planificacion/

```markdown
# Planes y Planificación - [MÓDULO]

**Última Actualización**: [fecha]

## Índice por Categoría

### Planes de Ejecución
- [PLAN_EJECUCION_COMPLETO](./ejecucion/PLAN_EJECUCION_COMPLETO.md) - v1.0 - Estado: En Progreso

### Planes de Release
- [PLAN_RELEASE_v2025.01](./release_management/PLAN_RELEASE_v2025.01.md) - v1.0 - Estado: Pendiente

### Planes de Deployment
- [DEPLOYMENT_PLAN_BACKEND](./deployment/DEPLOYMENT_PLAN_BACKEND.md) - v1.0 - Estado: Completado

## Resumen de Estados

| Estado | Cantidad |
|--------|----------|
| Borrador | X |
| Pendiente | X |
| En Progreso | X |
| Completado | X |

## Cómo Contribuir

1. Crear nuevo plan en subcarpeta apropiada
2. Usar nomenclatura estándar
3. Incluir frontmatter completo
4. Actualizar este README.md
5. Crear Pull Request

## Contacto y Responsables

- **Responsable Gobernanza**: [nombre]
- **Responsable Infraestructura**: [nombre]
- **Responsable IA**: [nombre]
- **Responsable Backend**: [nombre]
- **Responsable Frontend**: [nombre]
- **Responsable DevOps**: [nombre]
```

---

## 7. VALIDACIÓN Y AUDITORÍA

### Pre-Commit Checklist

Antes de comitear un nuevo plan:
- [ ] Está en `planificacion/[subcarpeta]/`
- [ ] Nombre sigue convención
- [ ] Frontmatter completo y correcto
- [ ] Estructura clara y completa
- [ ] Tabla de contenidos (si aplica)
- [ ] Todos los links son válidos
- [ ] Responsable y contacto definido
- [ ] README.md del módulo actualizado

### Auditoría Periódica

**Trimestral**: Ejecutar script de validación
```bash
# Verificar estructura
find /docs/*/planificacion -type f -name "*.md" | wc -l

# Buscar archivos sin frontmatter
grep -L "^---" /docs/*/planificacion/**/*.md

# Verificar links rotos
[script de validación de links]
```

---

## 8. HERRAMIENTAS Y AUTOMATIZACIÓN

### Script de Creación de Plan Template

```bash
#!/bin/bash
# create_plan.sh

MODULE=$1  # gobernanza, infraestructura, ai, backend, frontend
CATEGORY=$2  # ejecucion, release_management, deployment, etc.
NAME=$3

TEMPLATE="---
id: PLAN_\$(date +%Y%m%d_\$(openssl rand -hex 4 | tr -d '\n'))
tipo: plan
categoria: $CATEGORY
modulo: $MODULE
version: 1.0
fecha_creacion: \$(date -u +%Y-%m-%d)
fecha_ultima_actualizacion: \$(date -u +%Y-%m-%d)
responsable: [Por Definir]
estado: borrador
duracion_estimada: [Por Definir]
tags: [$CATEGORY]
---

# $NAME

## Objetivo
[Por escribir]

## Contexto
[Por escribir]
"

echo "$TEMPLATE" > "/docs/$MODULE/planificacion/$CATEGORY/$NAME.md"
echo "Plan creado: /docs/$MODULE/planificacion/$CATEGORY/$NAME.md"
```

---

## 9. EJEMPLOS COMPLETOS

### Ejemplo 1: Plan de Release
```markdown
---
id: PLAN_RELEASE_v2025.01
tipo: plan
categoria: release_management
modulo: infraestructura
version: 1.0
fecha_creacion: 2025-11-15
fecha_ultima_actualizacion: 2025-11-18
responsable: Infrastructure Team
estado: pendiente
duracion_estimada: 4w
tags: [release, versioning, 2025]
---

# Plan de Release v2025.01

## Objetivo
Establecer timeline y criterios para release v2025.01 de IACT

## Timeline
- Semana 1: Feature freeze y QA
- Semana 2: Testing y bug fixes
- Semana 3: Release Candidate
- Semana 4: Production Release

## Criterios de Éxito
- [ ] Todos los features completos
- [ ] 0 bugs críticos
- [ ] Documentación actualizada
```

### Ejemplo 2: Plan de Ejecución
```markdown
---
id: EXECPLAN_AGENT_CODEX_20251118
tipo: plan
categoria: ejecucion
modulo: ai
version: 1.0
fecha_creacion: 2025-11-18
responsable: AI Engineering Team
estado: en_progreso
duracion_estimada: 8w
tags: [agente, codex, ejecucion]
---

# EXECPLAN: Meta Agente Codex

## Objetivo
Ejecutar implementación de agente Codex con capacidades de análisis multi-modelo

## Fases
...
```

---

## 10. MIGRACIÓN DE PLANES EXISTENTES

Para planes que NO cumplen convenciones:

1. **No renombrar files automáticamente** - Riesgo de romper referencias
2. **Mantener nombre original, mejorar contenido**
3. **Actualizar frontmatter** a formato estándar
4. **Documentar cambios** en notas de actualización

Ejemplo:
```markdown
---
nota_actualizacion: "Migrado a estructura estándar TASK-REORG-INFRA-011. Nombre archivo mantiene compatibilidad histórica."
---
```

---

## 11. PREGUNTAS FRECUENTES

**P: Dónde pongo un plan que abarca múltiples módulos?**
R: Ubicar en el módulo principal/más relevante. Usar sección de "Documentación Relacionada" para ligar con otros módulos.

**P: Puedo mantener un plan en su directorio temático actual + en planificacion/?**
R: No. Una sola copia en `planificacion/`. Si otro directorio temático necesita acceso directo, usar symlink o referencia relativa.

**P: Qué hago con planes completados/archivados?**
R: Mantener en lugar actual, marcar estado como `completado`. Opcionalmente mover a subcarpeta `archivos/`.

**P: Cómo manejo planes con frecuencia de actualización muy alta?**
R: Mantener versionado más granular (1.0, 1.1, 1.2) y notas de cambios en log al pie del documento.

**P: Puedo usar Jira links o referencias a otros sistemas?**
R: Sí, pero mantener también referencias internas. Usar sección "Integración Externa".

---

## 12. GOBERNANZA DE CAMBIOS

Cualquier cambio a esta guía requiere:
1. Discusión en equipo de infraestructura
2. Documentación de cambio
3. Comunicación a todos los módulos
4. Actualización de templates

**Dueño de esta Guía**: IACT Infrastructure Team
**Última Revisión**: 2025-11-18
**Próxima Revisión**: 2026-02-18

---

**Versión**: 1.0
**Efectiva desde**: 2025-11-18
**Estado**: ACTIVA

