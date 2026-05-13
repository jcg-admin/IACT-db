---
id: TASK-REORG-INFRA-006
tipo: tarea_reorganizacion
categoria: consolidacion
fase: FASE_2_REORGANIZACION_CRITICA
prioridad: ALTA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-003, TASK-REORG-INFRA-004]
tags: [diseno, arquitectura, consolidacion]
tecnica_prompting: Decomposed Prompting
---

# TASK-REORG-INFRA-006: Consolidar diseño/arquitectura/

## Objetivo
Centralizar y consolidar todos los archivos de arquitectura dispersos en el repositorio en una estructura coherente bajo `diseno/arquitectura/`, siguiendo el patrón de organización del proyecto IACT.

## Problema Identificado (AUTO-CoT Step 1)
Actualmente, los archivos de arquitectura están dispersos en múltiples ubicaciones:
- `/docs/agents/ARCHITECTURE.md`
- `/docs/ai/agent/arquitectura/` (múltiples archivos)
- `/docs/ai/arquitectura/README.md`
- `/docs/gobernanza/diseno/arquitectura/STORAGE_ARCHITECTURE.md`
- `/docs/infraestructura/ambientes_virtualizados.md`
- `/docs/infraestructura/storage_architecture.md`
- `/docs/infraestructura/cpython_precompilado/arquitectura.md`
- `/docs/backend/diseno/permisos/arquitectura_permisos_granular.md`
- `/docs/frontend/arquitectura/` (múltiples archivos)
- `/scripts/coding/ai/agents/ARCHITECTURE.md`
- `/scripts/coding/ai/agents/ARCHITECTURE_SDLC_AGENTS.md`

Esta dispersión dificulta:
- Localización de documentación de arquitectura
- Mantenimiento consistente de estándares
- Referencias cruzadas entre componentes
- Onboarding de nuevos miembros del equipo

## Archivos de Arquitectura Identificados (AUTO-CoT Step 2)

### Infraestructura & Ambientes
| Archivo | Ubicación Actual | Descripción |
|---------|------------------|-------------|
| ambientes_virtualizados.md | `/docs/infraestructura/` | Configuración de ambientes virtualizados |
| storage_architecture.md | `/docs/infraestructura/` | Arquitectura de almacenamiento |
| cpython_precompilado/arquitectura.md | `/docs/infraestructura/` | Arquitectura CPython precompilado |

### Gobernanza & Diseño
| Archivo | Ubicación Actual | Descripción |
|---------|------------------|-------------|
| STORAGE_ARCHITECTURE.md | `/docs/gobernanza/diseno/arquitectura/` | Especificación de arquitectura de almacenamiento |
| arquitectura_permisos_granular.md | `/docs/backend/diseno/permisos/` | Arquitectura de permisos granulares |

### Agentes & IA
| Archivo | Ubicación Actual | Descripción |
|---------|------------------|-------------|
| hld_shell_script_remediation_agent.md | `/docs/ai/agent/arquitectura/` | HLD agente remediación shell scripts |
| hld_adr_management_agent.md | `/docs/ai/agent/arquitectura/` | HLD agente gestión ADR |
| hld_documentation_analysis_agent.md | `/docs/ai/agent/arquitectura/` | HLD agente análisis documentación |
| hld_plan_validation_agent.md | `/docs/ai/agent/arquitectura/` | HLD agente validación planes |
| adrs_plan_validation_agent.md | `/docs/ai/agent/arquitectura/` | ADR agente validación planes |
| adrs_shell_script_remediation_agent.md | `/docs/ai/agent/arquitectura/` | ADR agente remediación shell scripts |
| hld_shell_script_analysis_agent.md | `/docs/ai/agent/arquitectura/` | HLD agente análisis shell scripts |
| adrs_shell_script_analysis_agent.md | `/docs/ai/agent/arquitectura/` | ADR agente análisis shell scripts |
| adrs_documentation_analysis_agent.md | `/docs/ai/agent/arquitectura/` | ADR agente análisis documentación |
| ARCHITECTURE.md | `/docs/agents/` | Especificación general de agentes |
| ARCHITECTURE.md | `/scripts/coding/ai/agents/` | Arquitectura de agentes SDLC |
| ARCHITECTURE_SDLC_AGENTS.md | `/scripts/coding/ai/agents/` | Arquitectura SDLC agentes |

### Frontend
| Archivo | Ubicación Actual | Descripción |
|---------|------------------|-------------|
| microfrontends_canvas.md | `/docs/frontend/arquitectura/` | Canvas arquitectura microfrontends |
| shared_webpack_configs.md | `/docs/frontend/arquitectura/` | Configuración compartida Webpack |
| estrategia_integracion_backend.md | `/docs/frontend/arquitectura/` | Estrategia integración backend |
| analisis_api_frontend.md | `/docs/frontend/arquitectura/` | Análisis API frontend |
| ejemplos_ui_design.md | `/docs/frontend/arquitectura/` | Ejemplos diseño UI |

### Devops & Automatización
| Archivo | Ubicación Actual | Descripción |
|---------|------------------|-------------|
| AUTOMATION_ARCHITECTURE.md | `/docs/devops/automatizacion/planificacion/` | Arquitectura de agentes automatización |

## Estructura Consolidada (AUTO-CoT Step 3)

```
diseno/
├── arquitectura/
│   ├── README.md                          (Este archivo)
│   │
│   ├── infraestructura/
│   │   ├── ambientes_virtualizados.md
│   │   ├── storage_architecture.md
│   │   └── cpython_precompilado_arquitectura.md
│   │
│   ├── gobernanza/
│   │   └── storage_architecture_gobernanza.md
│   │
│   ├── agentes/
│   │   ├── ARCHITECTURE_OVERVIEW.md       (Consolidado: agents + devops)
│   │   ├── AGENTS_SDLC_ARCHITECTURE.md
│   │   │
│   │   ├── hld/
│   │   │   ├── shell_script_remediation_agent.md
│   │   │   ├── adr_management_agent.md
│   │   │   ├── documentation_analysis_agent.md
│   │   │   └── plan_validation_agent.md
│   │   │
│   │   └── adrs/
│   │       ├── plan_validation_agent.md
│   │       ├── shell_script_remediation_agent.md
│   │       ├── shell_script_analysis_agent.md
│   │       ├── documentation_analysis_agent.md
│   │
│   ├── backend/
│   │   └── permisos_granular_arquitectura.md
│   │
│   └── frontend/
│       ├── microfrontends_canvas.md
│       ├── shared_webpack_configs.md
│       ├── estrategia_integracion_backend.md
│       ├── analisis_api_frontend.md
│       └── ejemplos_ui_design.md
```

## Tareas Específicas (AUTO-CoT Step 4)

### Phase 1: Preparación
- [ ] Crear directorio `/diseno/arquitectura/` con subdirectorios
- [ ] Validar que no existan conflictos entre archivos con mismo nombre
- [ ] Crear registro de mapeo origen -> destino

### Phase 2: Movimiento de Archivos
- [ ] Mover archivos de infraestructura
- [ ] Mover archivos de gobernanza
- [ ] Mover archivos de agentes (consolidando duplicados)
- [ ] Mover archivos de backend
- [ ] Mover archivos de frontend

### Phase 3: Actualización de Referencias
- [ ] Actualizar enlaces internos en README.md de cada subcategoría
- [ ] Actualizar referencias en documentación existente
- [ ] Validar que no hayan rutas rotas
- [ ] Actualizar índices y mapas de navegación

### Phase 4: Consolidación
- [ ] Crear README.md en `diseno/arquitectura/`
- [ ] Crear índice maestro de arquitecturas
- [ ] Incluir Canvas de DevContainer Host
- [ ] Incluir Canvas de Pipeline CI/CD
- [ ] Validar estructura con Self-Consistency

### Phase 5: Documentación & Validación
- [ ] Documentar cambios en evidencias/
- [ ] Crear MIGRATION_REPORT.md
- [ ] Validar Self-Consistency: todos los archivos en `diseno/arquitectura/`
- [ ] Prueba de referencias cruzadas

## Self-Consistency Checklist

Para validar que la consolidación es exitosa:

```bash
# Verificar que no quedan archivos de arquitectura fuera de diseno/arquitectura/
find /diseno/arquitectura -type f -name "*arquitectura*" -o -name "*ARCHITECTURE*" -o -name "*architecture*"

# Validar integridad de referencias
grep -r "docs/ai/agent/arquitectura\|docs/infraestructura/ambientes\|docs/infraestructura/storage" diseno/arquitectura/ || echo "No outdated references found"

# Contar archivos originales vs consolidados
echo "Original locations: $(find docs -type f \( -name "*arquitec*" -o -name "*ARCHITECTURE*" \) | wc -l)"
echo "Consolidated locations: $(find diseno/arquitectura -type f | wc -l)"
```

## Canvas Incluidos

### DevContainer Host Architecture
**Ubicación esperada**: `diseno/arquitectura/infraestructura/devcontainer_host_architecture.canvas`

Debe incluir:
- Componentes de host
- Interfaz con contenedores
- Monitoreo y logging
- Persistencia de datos

### Pipeline CI/CD Architecture
**Ubicación esperada**: `diseno/arquitectura/devops/cicd_pipeline_architecture.canvas`

Debe incluir:
- Etapas del pipeline
- Integración con agentes
- Validaciones automáticas
- Despliegue y rollback

## Beneficios Esperados

1. **Accesibilidad**: Un único punto de entrada para toda documentación de arquitectura
2. **Mantenibilidad**: Estructura uniforme facilita actualizaciones
3. **Descubrimiento**: Nuevos miembros encuentran documentación rápidamente
4. **Consistencia**: Estándares uniformes en toda la documentación
5. **Trazabilidad**: Fácil rastrear evolución de decisiones arquitectónicas

## Criterios de Aceptación

- [x] Estructura `diseno/arquitectura/` creada con subdirectorios
- [ ] Todos los archivos de arquitectura movidos a su nueva ubicación
- [ ] Todos los enlaces internos actualizados
- [ ] No hay referencias rotas detectadas
- [ ] Canvas de DevContainer Host incluido
- [ ] Canvas de Pipeline CI/CD incluido
- [ ] README.md maestro documenta estructura completa
- [ ] Self-Consistency validada: cero archivos de arquitectura fuera de `diseno/arquitectura/`

## Referencias

- TASK-REORG-INFRA-003: Creación estructura base
- TASK-REORG-INFRA-004: Migración primaria de documentación
- ADRs relacionados en `/docs/gobernanza/adr/`
- Metodología Decomposed Prompting para tareas complejas

## Notas de Implementación

- Respetar history de Git: usar `git mv` en lugar de copiar
- Crear commits atómicos por categoría (infraestructura, agentes, etc.)
- Mantener referencias de cambios en evidencias/MIGRATION_REPORT.md
- Validar con herramientas de linting de markdown

---

**Creado**: 2025-11-18
**Última actualización**: 2025-11-18
**Estado**: PENDIENTE
**Técnica de prompting**: Auto-CoT + Self-Consistency
