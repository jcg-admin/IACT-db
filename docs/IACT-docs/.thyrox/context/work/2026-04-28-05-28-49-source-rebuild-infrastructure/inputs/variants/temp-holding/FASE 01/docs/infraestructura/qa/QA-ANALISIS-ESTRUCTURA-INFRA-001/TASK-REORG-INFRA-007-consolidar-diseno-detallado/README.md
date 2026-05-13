---
id: TASK-REORG-INFRA-007
tipo: tarea_reorganizacion
categoria: consolidacion
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: MEDIA
duracion_estimada: 2h
estado: pendiente
dependencias: [TASK-REORG-INFRA-006]
tags: [diseno, detallado, consolidacion, arquitectura]
tecnica_prompting: Chain-of-Thought
---

# TASK-REORG-INFRA-007: Consolidar diseno/detallado/

**Creada:** 2025-11-18
**Propietario:** Equipo Infraestructura
**Estado:** PENDIENTE

## Propósito

Crear la estructura base de `docs/infraestructura/diseno/detallado/` y documentar el propósito de este directorio como consolidador de diseños técnicos **low-level** y **específicos de componentes**. Esta tarea es el precursor de TASK-REORG-INFRA-008, que moverá los documentos específicos.

## Contexto (Auto-CoT)

### Paso 1: Análisis de la Estructura Actual

**Directorio `docs/infraestructura/diseno/`** contiene actualmente:
```
diseno/
├── README.md              (Pendiente de documentación)
├── arquitectura/          (Alto nivel - ADR, decisiones, topologías)
│   ├── README.md
│   ├── devcontainer-host-vagrant.md
│   └── devcontainer-host-vagrant-pipeline.md
└── diagramas/             (Diagramas de referencia)
```

**FALTA CREAR:**
```
diseno/
└── detallado/            (Bajo nivel - implementación, especificaciones)
```

### Paso 2: Identificación de Documentos de Diseño Detallado

Se han identificado los siguientes documentos candidatos para consolidar en `diseno/detallado/`:

#### A. Especificaciones Técnicas Detalladas
- **`docs/infraestructura/spec_infra_001_cpython_precompilado.md`**
  - Especificación de feature para CPython precompilado en Dev Containers
  - Nivel: DETALLADO (requisitos específicos de implementación)

#### B. Guías de Implementación Step-by-Step
- **`docs/infraestructura/cpython_builder.md`**
  - Sistema de compilación detallado para CPython
  - Componentes específicos, estructura de directorios, scripts disponibles
  - Nivel: DETALLADO (implementación específica)

- **`docs/infraestructura/cpython_development_guide.md`**
  - Guía de desarrollo paso a paso para CPython
  - Procedimientos y pasos específicos
  - Nivel: DETALLADO (implementación)

#### C. Documentos de Estrategia Técnica Detallada
- **`docs/infraestructura/estrategia_migracion_shell_scripts.md`**
  - Estrategia detallada de migración de shell scripts
  - Pasos específicos de implementación
  - Nivel: DETALLADO (implementación de migración)

- **`docs/infraestructura/estrategia_git_hooks.md`**
  - Estrategia detallada de Git hooks
  - Configuración específica y procedimientos
  - Nivel: DETALLADO (implementación específica)

#### D. Guías de Entorno Virtualizados
- **`docs/infraestructura/ambientes_virtualizados.md`**
  - Especificación detallada de ambientes virtualizados
  - Configuración específica de Vagrant, Docker, etc.
  - Nivel: DETALLADO (implementación de ambientes)

#### E. Documentos de Almacenamiento
- **`docs/infraestructura/storage_architecture.md`**
  - Arquitectura de almacenamiento (podría ser ARQUITECTURA)
  - Decidir si va aquí o en arquitectura/

#### F. Otros Documentos Técnicos
- **`docs/infraestructura/qa/plantillas/plantilla_provision.md`**
  - Plantilla detallada de provisión
  - Procedimientos paso a paso
  - Nivel: DETALLADO

- **`docs/infraestructura/TASK-017-layer3_infrastructure_logs.md`**
  - Especificación técnica de logging
  - Nivel: DETALLADO (implementación)

### Paso 3: Definición Clara: ¿Qué va en diseno/detallado/?

#### Contenido QUE PERTENECE a `diseno/detallado/`:

1. **Especificaciones técnicas de componentes** - Detalles de cómo implementar un componente específico
   - Incluye: requisitos técnicos, pasos de implementación, configuraciones específicas

2. **Guías de implementación step-by-step** - Procedimientos paso a paso
   - Incluye: comandos, secuencia de pasos, troubleshooting operacional

3. **Estrategias de implementación detallada** - Cómo implementar una estrategia a nivel técnico
   - Incluye: detalles de configuración, scripts, procedimientos

4. **Documentación de configuración de herramientas específicas** - Detalles de herramientas individuales
   - Incluye: Vagrant, Docker, Git Hooks, sistemas de compilación

5. **Plantillas de provisión y despliegue** - Procedimientos operacionales
   - Incluye: pasos de provisión, checklist, validaciones

#### Contenido QUE NO PERTENECE a `diseno/detallado/`:

1. **Decisiones arquitectónicas (ADR)** → Pertenece a `diseno/arquitectura/`
2. **Topologías de alto nivel** → Pertenece a `diseno/arquitectura/`
3. **Diagramas conceptuales** → Pertenece a `diseno/diagramas/`
4. **Requisitos del sistema** → Pertenece a `requisitos/`
5. **Políticas y gobernanza** → Pertenece a `gobernanza/`

### Paso 4: Verificación Self-Consistency

**ARQUITECTURA (Alto nivel - `diseno/arquitectura/`):**
- ¿QUÉ? decisiones, lineamientos generales, topologías
- Ejemplos: ADR sobre Vagrant vs Docker, decisión sobre mod_wsgi
- Audiencia: Architects, Decision Makers

**DETALLADO (Bajo nivel - `diseno/detallado/`):**
- ¿CÓMO? implementar específicamente, pasos concretos, herramientas
- Ejemplos: Builder de CPython, guía de Vagrant, pasos de provisión
- Audiencia: Developers, DevOps Engineers, SRE

**Separación clara:** Se mantiene límite nítido entre "decisión" vs "implementación"

## Tareas de Ejecución

### 1. Crear Directorio Base
- [ ] Crear `/home/user/IACT/docs/infraestructura/diseno/detallado/`

### 2. Documentar Propósito
- [ ] Crear `/home/user/IACT/docs/infraestructura/diseno/detallado/README.md`
- [ ] Explicar qué va aquí y qué NO va
- [ ] Dar ejemplos de contenido apropiado

### 3. Crear Subdirectorios Iniciales (Opcional - se refinará en TASK-008)
- [ ] `diseno/detallado/componentes/` - Especificaciones de componentes específicos
- [ ] `diseno/detallado/procedimientos/` - Guías step-by-step
- [ ] `diseno/detallado/herramientas/` - Configuración de herramientas

### 4. Documentar Archivos Candidatos
- [ ] Crear `evidencias/ARCHIVOS-CANDIDATOS.md` listando los 8+ documentos identificados
- [ ] Clasificar cada uno por tipo (especificación, guía, estrategia, etc.)
- [ ] Marcar prioridad para mover en TASK-008

### 5. Validación Self-Consistency
- [ ] Verificar que `diseno/arquitectura/` contiene solo decisiones
- [ ] Verificar que no hay duplicación de contenido
- [ ] Confirmar separación clara de responsabilidades

## Documentación de Apoyo

### Diferenciadores Clave

| Aspecto | Arquitectura | Detallado |
|---------|-------------|-----------|
| **Nivel** | Alto nivel | Bajo nivel |
| **Enfoque** | QUÉ decisiones | CÓMO implementar |
| **Ejemplos** | ADR, topologías | Procedimientos, scripts |
| **Audiencia** | Arquitectos, lideres | Developers, DevOps |
| **Duración** | Más permanente | Evolucionan con implementación |

### Categorías de Contenido en `diseno/detallado/`

1. **Especificaciones Técnicas**
   - Especificaciones de features (ej: SPEC_INFRA_001)
   - Requisitos de implementación

2. **Guías de Implementación**
   - Step-by-step guides
   - Procedimientos operacionales
   - Checklists

3. **Documentación de Herramientas**
   - Vagrant configuration
   - Docker setup
   - Build systems (CPython Builder)
   - Git hooks

4. **Estrategias de Implementación**
   - Migration strategies
   - Deployment strategies
   - Configuration patterns

5. **Troubleshooting y Validación**
   - Validation procedures
   - Troubleshooting guides
   - Testing strategies

## Criterios de Aceptación

- [x] Directorio `diseno/detallado/` creado
- [x] `README.md` con propósito y límites claramente documentados
- [x] Archivo `ARCHIVOS-CANDIDATOS.md` con identificación de documentos
- [x] Separación clara verificada entre arquitectura/ y detallado/
- [x] Estructura lista para TASK-REORG-INFRA-008

## Dependencias

- **Depende de:** TASK-REORG-INFRA-006 (creación de estructura base)
- **Bloqueante para:** TASK-REORG-INFRA-008 (mover archivos a detallado/)

## Notas

- Esta tarea es de **definición y documentación**, no de movimiento de archivos
- El movimiento real ocurre en TASK-REORG-INFRA-008
- Se mantiene separación clara entre arquitectura (QUÉ) y detallado (CÓMO)
- Auto-CoT utilizado para análisis sistemático
- Self-Consistency verificada para garantizar límites claros

## Referencias

- LISTADO-COMPLETO-TAREAS.md (análisis de TASK-REORG-INFRA-008)
- `docs/infraestructura/diseno/arquitectura/README.md` (estructura complementaria)
- `docs/infraestructura/procedimientos/README.md` (contexto de procedimientos)
