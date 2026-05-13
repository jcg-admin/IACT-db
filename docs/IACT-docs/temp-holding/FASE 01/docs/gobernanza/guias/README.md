---
id: INDICE-GUIAS-OPERATIVAS
tipo: indice
categoria: guias
version: 1.0.0
fecha: 2025-11-07
---

# Guias Operativas del Proyecto IACT

Bienvenido al centro de guias operativas del proyecto IACT. Este directorio contiene guias practicas, paso a paso, para todas las operaciones comunes del proyecto.

## Estado Actual

**Guias completadas: 23 de 147 (15.6%)**

- P0 (Criticas - Onboarding): 18/20 guias (90%)
- P1 (Alta): 5/40 guias (12.5%)
- P2 (Media): 0/50 guias (0%)
- P3 (Baja): 0/37 guias (0%)

## Guia Rapida por Rol

### Soy Desarrollador Nuevo

Empieza aqui para tu primer dia:

1. [Configurar Entorno de Desarrollo Local](onboarding/onboarding_001.md) - 15 min
2. [Ejecutar Proyecto Localmente](onboarding/onboarding_002.md) - 10 min
3. [Estructura del Proyecto IACT](onboarding/onboarding_003.md) - 8 min
4. [Configurar Variables de Entorno](onboarding/onboarding_004.md) - 7 min
5. [Problemas Comunes de Setup](troubleshooting/troubleshooting_001.md) - 15 min

**Tiempo total onboarding: ~55 minutos**

### Soy Desarrollador Experimentado

Para tu primer commit:

1. [Crear Feature Branch](workflows/workflows_001.md) - 5 min
2. [Hacer Commits Convencionales](workflows/workflows_002.md) - 7 min
3. [Ejecutar Tests Backend Localmente](testing/testing_001.md) - 8 min
4. [Ejecutar Tests Frontend Localmente](testing/testing_002.md) - 8 min
5. [Crear Pull Request](workflows/workflows_003.md) - 10 min

### Soy QA Engineer

Para testing y validacion:

1. [Ejecutar Tests Backend Localmente](testing/testing_001.md) - 8 min
2. [Ejecutar Tests Frontend Localmente](testing/testing_002.md) - 8 min
3. [Validar Test Pyramid](testing/testing_003.md) - 6 min
4. [Validar Restricciones Criticas](deployment/deployment_002.md) - 5 min

### Soy DevOps Engineer

Para deployment y operaciones:

1. [Workflow de Deployment](deployment/deployment_001.md) - 10 min
2. [Interpretar Resultados de CI/CD](workflows/workflows_004.md) - 8 min
3. [Validar Restricciones Criticas](deployment/deployment_002.md) - 5 min

## Tabla de Contenidos Completa

### Onboarding (7 guias)

| ID | Titulo | Audiencia | Tiempo | Estado |
|----|--------|-----------|--------|--------|
| [GUIA-ONBOARDING-001](onboarding/onboarding_001.md) | Configurar Entorno de Desarrollo Local | Desarrollador Nuevo | 15 min | Completa |
| [GUIA-ONBOARDING-002](onboarding/onboarding_002.md) | Ejecutar Proyecto Localmente | Desarrollador Nuevo | 10 min | Completa |
| [GUIA-ONBOARDING-003](onboarding/onboarding_003.md) | Estructura del Proyecto IACT | Desarrollador Nuevo | 8 min | Completa |
| [GUIA-ONBOARDING-004](onboarding/onboarding_004.md) | Configurar Variables de Entorno | Desarrollador Nuevo | 7 min | Completa |
| [GUIA-ONBOARDING-005](onboarding/onboarding_005.md) | Usar Agentes SDLC - Planning | Desarrollador | 10 min | Completa |
| [GUIA-ONBOARDING-006](onboarding/onboarding_006.md) | Validar Documentacion | Desarrollador | 6 min | Completa |
| [GUIA-ONBOARDING-007](onboarding/onboarding_007.md) | Generar Indices de Requisitos | Desarrollador | 5 min | Completa |

### Workflows (4 guias)

| ID | Titulo | Audiencia | Tiempo | Estado |
|----|--------|-----------|--------|--------|
| [GUIA-WORKFLOWS-001](workflows/workflows_001.md) | Crear Feature Branch | Desarrollador | 5 min | Completa |
| [GUIA-WORKFLOWS-002](workflows/workflows_002.md) | Hacer Commits Convencionales | Desarrollador | 7 min | Completa |
| [GUIA-WORKFLOWS-003](workflows/workflows_003.md) | Crear Pull Request | Desarrollador | 10 min | Completa |
| [GUIA-WORKFLOWS-004](workflows/workflows_004.md) | Interpretar Resultados de CI/CD | Desarrollador | 8 min | Completa |

### Testing (3 guias)

| ID | Titulo | Audiencia | Tiempo | Estado |
|----|--------|-----------|--------|--------|
| [GUIA-TESTING-001](testing/testing_001.md) | Ejecutar Tests Backend Localmente | Desarrollador | 8 min | Completa |
| [GUIA-TESTING-002](testing/testing_002.md) | Ejecutar Tests Frontend Localmente | Desarrollador | 8 min | Completa |
| [GUIA-TESTING-003](testing/testing_003.md) | Validar Test Pyramid | Desarrollador | 6 min | Completa |

### Deployment (4 guias)

| ID | Titulo | Audiencia | Tiempo | Estado |
|----|--------|-----------|--------|--------|
| [GUIA-DEPLOYMENT-001](deployment/deployment_001.md) | Workflow de Deployment | Desarrollador | 10 min | Completa |
| [GUIA-DEPLOYMENT-002](deployment/deployment_002.md) | Validar Restricciones Criticas | Desarrollador | 5 min | Completa |
| [GUIA-DEPLOYMENT-004](deployment/deployment_004_tdd_backend_permisos_granular.md) | Implementacion TDD Backend Permisos Granular | Desarrollador Backend | 30 min | Completa |
| [GUIA-DEPLOYMENT-005](deployment/deployment_005_tdd_frontend_permisos_granular.md) | Implementacion TDD Frontend Permisos Granular | Desarrollador Frontend | 25 min | Completa |

### Troubleshooting (1 guia)

| ID | Titulo | Audiencia | Tiempo | Estado |
|----|--------|-----------|--------|--------|
| [GUIA-TROUBLESHOOTING-001](troubleshooting/troubleshooting_001.md) | Problemas Comunes de Setup | Desarrollador Nuevo | 15 min | Completa |

## Guias Planificadas

### P1 - Alta Prioridad (40 guias)

Proximas guias a generar:

**Workflows CI/CD (10 guias)**
- Como usar backend-ci.yml
- Como usar frontend-ci.yml
- Como usar deploy.yml
- Como usar security-scan.yml
- Como usar test-pyramid.yml
- Como usar migrations.yml
- Como usar infrastructure-ci.yml
- Como usar incident-response.yml
- Como debuggear workflows
- Como modificar workflows

**Scripts de Validacion (10 guias)**
- Como usar validate_critical_restrictions.sh
- Como usar validate_security_config.sh
- Como usar validate_database_router.sh
- Como usar validar_estructura_docs.sh
- Como usar backend_test.sh
- Como usar frontend_test.sh
- Como usar test_pyramid_check.sh
- Como usar security_scan.sh
- Troubleshooting scripts CI
- Scripts de smoke tests

**Agentes SDLC (6 guias)**
- Como usar SDLCFeasibilityAgent
- Como usar SDLCDesignAgent
- Como usar SDLCTestingAgent
- Como usar SDLCDeploymentAgent
- Como usar SDLCOrchestratorAgent
- Troubleshooting agentes

**Fases SDLC (7 guias)**
- Fase 2: Feasibility Analysis
- Fase 3: Design
- Fase 4: Implementation
- Fase 5: Testing
- Fase 6: Deployment
- Fase 7: Maintenance
- Transicion entre fases

**Otras (7 guias)**
- Crear ADRs
- Gestion de requisitos
- Code review best practices
- Como hacer rollback
- Incident response
- Monitoreo y observabilidad
- Performance optimization

### P2 - Media Prioridad (50 guias)

Scripts AI/Agentes especializados, workflows de documentacion, guias de troubleshooting especificas.

### P3 - Baja Prioridad (37 guias)

Scripts templates, utilities, guias avanzadas de referencia.

## Como Contribuir

### Reportar Problemas con Guias

Si encuentras un error o tienes sugerencias:

1. Crea un issue en GitHub con label `documentation`
2. Incluye:
   - Nombre de la guia
   - Seccion con problema
   - Error encontrado o mejora sugerida

### Proponer Nueva Guia

Para proponer una nueva guia:

1. Verifica que no este ya en la lista de planificadas
2. Crea un issue con:
   - Titulo propuesto
   - Audiencia objetivo
   - Por que es necesaria
   - Prioridad sugerida (P1/P2/P3)

### Actualizar Guia Existente

Para actualizar una guia:

1. Lee la guia actual
2. Crea un PR con cambios
3. Sigue el template de la guia (docs/plantillas/guia-template.md)
4. Actualiza fecha en frontmatter

## Generar Nuevas Guias

Usamos un generador automatico de guias:

```bash
# Generar todas las guias P0
python scripts/generate_guides.py --priority P0

# Generar guias de categoria especifica
python scripts/generate_guides.py --category onboarding

# Dry-run (no escribe archivos)
python scripts/generate_guides.py --priority P1 --dry-run

# Ver reporte de coverage
python scripts/generate_guides.py --report
```

## Metricas de Adoption

Ver metricas detalladas en: [METRICS.md](METRICS.md)

**Objetivos:**
- 100% guias P0 generadas en Semana 1: 85% (17/20)
- 80%+ adoption guias por equipo: TBD
- <30 min tiempo onboarding nuevo desarrollador: ~55 min (objetivo: reducir a <30)
- 50% reduccion preguntas repetitivas: TBD (baseline pendiente)

## Estructura de Directorio

```
docs/guias/
├── README.md                  # Este archivo (indice)
├── METRICS.md                 # Metricas de adoption
├── onboarding/                # Guias de onboarding (7)
├── workflows/                 # Guias de workflows Git/CI (4)
├── testing/                   # Guias de testing (3)
├── deployment/                # Guias de deployment (2)
└── troubleshooting/           # Guias de troubleshooting (1)
```

## Convenciones

Todas las guias siguen estas convenciones:

1. **Frontmatter YAML**: Metadata estructurada
2. **Seccion Proposito**: 1-2 parrafos explicando que hace
3. **Seccion Pre-requisitos**: Checklist de requerimientos
4. **Seccion Pasos**: Instrucciones paso a paso con comandos
5. **Seccion Validacion**: Como verificar que funciono
6. **Seccion Troubleshooting**: Errores comunes y soluciones
7. **Seccion Proximos pasos**: Guias relacionadas
8. **Seccion Referencias**: Links a docs tecnica

## Plantillas

Plantilla oficial: [docs/plantillas/guia-template.md](../plantillas/guia-template.md)

## Mantenedores

- @doc-lead - Documentacion y guias
- @arquitecto-senior - Guias tecnicas y arquitectura
- @devops-lead - Guias de deployment y operaciones
- @qa-lead - Guias de testing
- @tech-lead - Coordinacion general

## Proximas Actualizaciones

**Semana 1 (Nov 7-14):**
- [x] Generar 17/20 guias P0
- [ ] Completar 3 guias P0 restantes
- [ ] Primera revision con equipo
- [ ] Incorporar feedback inicial

**Semanas 2-3 (Nov 15-28):**
- [ ] Generar 40 guias P1
- [ ] Establecer baseline de metricas
- [ ] Primera medicion de adoption

**Mes 2 (Diciembre):**
- [ ] Generar 50 guias P2
- [ ] Iterar basado en feedback
- [ ] Alcanzar 80% adoption

**Mes 3 (Enero):**
- [ ] Generar 37 guias P3
- [ ] Completar 147 guias
- [ ] Alcanzar objetivos de metricas

---

**Version**: 1.0.0
**Ultima actualizacion**: 2025-11-07
**Proxima revision**: 2025-11-14
