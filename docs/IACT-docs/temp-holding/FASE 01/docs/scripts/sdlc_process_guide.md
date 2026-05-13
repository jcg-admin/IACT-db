---
title: Guia Completa: sdlc_agent.py
date: 2025-11-13
domain: general
status: active
---

# Guia Completa: sdlc_agent.py

Documentacion detallada del CLI principal para ejecutar agentes SDLC del proyecto IACT.

## Tabla de Contenidos

- [Introduccion](#introduccion)
- [Arquitectura](#arquitectura)
- [Instalacion y Configuracion](#instalacion-y-configuracion)
- [Uso Basico](#uso-basico)
- [Fases SDLC Disponibles](#fases-sdlc-disponibles)
- [Agentes Disponibles](#agentes-disponibles)
- [Pipeline Completo](#pipeline-completo)
- [Parametros y Opciones](#parametros-y-opciones)
- [Integracion con Constitution](#integracion-con-constitution)
- [Integracion con DORA Metrics](#integracion-con-dora-metrics)
- [Ejemplos de Uso Real](#ejemplos-de-uso-real)
- [Troubleshooting](#troubleshooting)
- [Mejores Practicas](#mejores-practicas)
- [Flujo de Trabajo Completo](#flujo-de-trabajo-completo)

## Introduccion

`sdlc_agent.py` es el CLI (Command Line Interface) principal del sistema de agentes SDLC del proyecto IACT. Permite ejecutar fases individuales del ciclo de vida de desarrollo de software (SDLC) o el pipeline completo de forma automatizada.

**Path:** `/home/user/IACT---project/scripts/sdlc_agent.py`

**Proposito:**
- Automatizar la generacion de artefactos SDLC (issues, diseños, planes de testing, etc.)
- Mantener consistencia y calidad en todas las fases del desarrollo
- Integrar Constitution del proyecto en cada decision
- Reducir trabajo manual repetitivo
- Generar documentacion completa automaticamente

**Beneficios:**
- Ahorra tiempo (hasta 80% en generacion de documentacion)
- Mejora calidad y consistencia
- Asegura compliance con requisitos del proyecto
- Facilita onboarding de nuevos desarrolladores
- Genera traceability automatica

## Arquitectura

### Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                     sdlc_agent.py (CLI)                     │
│                                                             │
│  - Parsing de argumentos                                    │
│  - Validacion de inputs                                     │
│  - Ejecucion de agentes                                     │
│  - Formato de outputs                                       │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   │ Delega ejecucion
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                  SDLCPipeline / SDLCAgent                   │
│                    (scripts/ai/agents/)                     │
│                                                             │
│  - SDLCPlannerAgent      → Genera issues                    │
│  - SDLCFeasibilityAgent  → Analiza viabilidad              │
│  - SDLCDesignAgent       → Genera HLD/LLD/ADRs             │
│  - SDLCTestingAgent      → Genera test strategy            │
│  - SDLCDeploymentAgent   → Genera deployment plan          │
│  - SDLCOrchestratorAgent → Orquesta todo el pipeline       │
└──────────────────┬──────────────────────────────────────────┘
                   │
                   │ Consulta reglas
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                   Constitution Loader                       │
│                                                             │
│  - Carga docs/gobernanza/CONSTITUTION.md                   │
│  - Valida compliance con reglas del proyecto                │
│  - Asegura restricciones criticas (RNF-002)                │
└─────────────────────────────────────────────────────────────┘
                   │
                   │ Genera artefactos
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                     Output Directory                        │
│                  (docs/sdlc_outputs/)                       │
│                                                             │
│  planning/      → Issues generados                          │
│  feasibility/   → Analisis de viabilidad                    │
│  design/        → HLD, LLD, ADRs, diagramas                │
│  testing/       → Test strategy, test cases                 │
│  deployment/    → Deployment plans, checklists             │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de Ejecucion

```
Usuario ejecuta CLI
      │
      ▼
Parseo de argumentos
      │
      ├──> --phase planning ──> SDLCPlannerAgent ──> Issue .md
      │
      ├──> --phase feasibility ──> SDLCFeasibilityAgent ──> Feasibility Report
      │
      ├──> --phase design ──> SDLCDesignAgent ──> HLD + LLD + ADRs
      │
      ├──> --phase testing ──> SDLCTestingAgent ──> Test Strategy
      │
      ├──> --phase deployment ──> SDLCDeploymentAgent ──> Deployment Plan
      │
      └──> --pipeline ──> SDLCOrchestratorAgent ──> Todo lo anterior
```

## Instalacion y Configuracion

### Prerequisitos

```bash
# Python 3.11 o superior
python --version
# Python 3.11.0

# Dependencias instaladas
pip install -r requirements.txt
```

### Variables de Entorno

```bash
# Opcional: Para integracion con GitHub
export GITHUB_TOKEN="ghp_..."

# Opcional: Modelo LLM a usar
export SDLC_LLM_MODEL="claude-3-5-sonnet-20241022"
```

### Archivo de Configuracion (Opcional)

Puedes crear un archivo JSON de configuracion:

```json
{
  "project_root": "/home/user/IACT---project",
  "output_dir": "docs/sdlc_outputs",
  "llm_provider": "anthropic",
  "model": "claude-3-5-sonnet-20241022",
  "temperature": 0.1,
  "max_tokens": 4096
}
```

Guardar como `sdlc_config.json` y usar con:

```bash
python scripts/sdlc_agent.py --config sdlc_config.json --phase planning --input "..."
```

## Uso Basico

### Sintaxis General

```bash
python scripts/sdlc_agent.py [OPTIONS]
```

### Opciones Principales

| Opcion | Descripcion | Requerido |
|--------|-------------|-----------|
| `--phase` | Fase SDLC a ejecutar (planning, feasibility, design, testing, deployment) | Si (o --pipeline) |
| `--pipeline` | Ejecutar pipeline completo | Si (o --phase) |
| `--input` | Feature request (texto directo) | Si (o --input-file) |
| `--input-file` | Archivo con feature request | Si (o --input) |
| `--config` | Archivo de configuracion JSON | No |
| `--project-context` | Contexto adicional del proyecto | No |
| `--auto-proceed` | Auto-proceder sin confirmacion (solo pipeline) | No |
| `--dry-run` | No guardar artefactos (modo prueba) | No |
| `--format` | Formato de output (text, json) | No |
| `--verbose` | Logging detallado | No |

### Ejemplo Minimo

```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Implementar autenticacion OAuth2"
```

## Fases SDLC Disponibles

### 1. Planning

**Proposito:** Convertir un feature request en un issue de GitHub estructurado.

**Agente:** SDLCPlannerAgent

**Input:** Descripcion del feature

**Output:**
- Issue title
- User story
- Acceptance criteria
- Story points
- Priority
- Labels
- Technical requirements

**Uso:**
```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Sistema de notificaciones push para usuarios"
```

**Output esperado:**
```
RESULTADO DE EJECUCION
================================================================================

Estado: SUCCESS

Issue generado:
  Titulo: Implementar sistema de notificaciones push
  Story Points: 8
  Prioridad: P1
  Artefacto: docs/sdlc_outputs/planning/issue-001.md

Acceptance Criteria (5):
  1. Usuario puede suscribirse a notificaciones push
  2. Sistema envia notificaciones en tiempo real
  3. Usuario puede configurar preferencias de notificaciones
  4. Sistema respeta opt-out del usuario
  5. Notificaciones funcionan en mobile y web

Requisitos Tecnicos (3):
  - Implementar WebPush API
  - Backend debe generar tokens de suscripcion
  - Frontend debe solicitar permisos de notificacion
```

### 2. Feasibility

**Proposito:** Analizar viabilidad tecnica del feature.

**Agente:** SDLCFeasibilityAgent

**Input:** Issue generado en Planning

**Output:**
- Decision: GO / NO-GO / REQUIRES_APPROVAL
- Confidence score
- Risks identified
- Blockers
- Recommendations
- Estimated complexity

**Uso:**
```bash
python scripts/sdlc_agent.py \
  --phase feasibility \
  --input "Feature: Implementar cache distribuido con Redis"
```

**Output esperado:**
```
Decision: NO-GO
Confianza: 95%

Razones:
  - Viola restriccion critica RNF-002 (NO Redis)
  - Alternativas disponibles: Memcached, Django cache

Recomendaciones:
  - Usar Memcached en lugar de Redis
  - Revisar ADR sobre caching strategies
```

### 3. Design

**Proposito:** Generar diseño tecnico (HLD, LLD, ADRs, diagramas).

**Agente:** SDLCDesignAgent

**Input:** Issue + Feasibility result

**Output:**
- High-Level Design (HLD)
- Low-Level Design (LLD)
- Architecture Decision Records (ADRs)
- Diagramas (C4, sequence, ER)
- API contracts
- Data models

**Uso:**
```bash
python scripts/sdlc_agent.py \
  --phase design \
  --input "Feature: Sistema de autenticacion OAuth2"
```

**Artefactos generados:**
```
docs/sdlc_outputs/design/
├── HLD_oauth2_authentication.md
├── LLD_oauth2_authentication.md
├── ADR_001_oauth2_provider_selection.md
├── diagrams/
│   ├── c4_context_oauth2.puml
│   ├── sequence_oauth2_flow.puml
│   └── er_oauth2_tables.puml
└── api_contracts/
    └── oauth2_api.yaml
```

### 4. Testing

**Proposito:** Generar estrategia de testing y test cases.

**Agente:** SDLCTestingAgent

**Input:** Issue + Design result

**Output:**
- Test strategy
- Test pyramid breakdown
- Unit test cases
- Integration test cases
- E2E test cases
- Coverage targets
- Test data requirements

**Uso:**
```bash
python scripts/sdlc_agent.py \
  --phase testing \
  --input "Feature: Sistema de pagos"
```

**Output esperado:**
```
Test Strategy generada

Total Test Cases: 45
  - Unit Tests: 27 (60%)
  - Integration Tests: 13 (29%)
  - E2E Tests: 5 (11%)

Coverage Target: 85%

Artefacto: docs/sdlc_outputs/testing/test_strategy_payments.md
```

### 5. Deployment

**Proposito:** Generar plan de deployment y rollback.

**Agente:** SDLCDeploymentAgent

**Input:** Issue + Design + Testing results

**Output:**
- Deployment plan
- Rollback plan
- Pre-deployment checklist
- Post-deployment checklist
- Smoke tests
- Monitoring plan

**Uso:**
```bash
python scripts/sdlc_agent.py \
  --phase deployment \
  --input "Feature: Nueva API de reportes"
```

**Artefactos generados:**
```
docs/sdlc_outputs/deployment/
├── deployment_plan_reports_api.md
├── rollback_plan_reports_api.md
├── pre_deployment_checklist.md
├── post_deployment_checklist.md
└── smoke_tests.md
```

## Agentes Disponibles

Ver [sdlc-agents-reference.md](./sdlc-agents-reference.md) para documentacion completa de cada agente.

### Resumen de Agentes

| Agente | Fase | Proposito |
|--------|------|-----------|
| SDLCPlannerAgent | Planning | Genera issues estructurados |
| SDLCFeasibilityAgent | Feasibility | Analiza viabilidad y riesgos |
| SDLCDesignAgent | Design | Genera HLD, LLD, ADRs |
| SDLCTestingAgent | Testing | Genera estrategia de testing |
| SDLCDeploymentAgent | Deployment | Genera planes de deployment |
| SDLCOrchestratorAgent | All | Orquesta pipeline completo |

## Pipeline Completo

### Ejecutar Pipeline SDLC Completo

El pipeline ejecuta todas las fases en secuencia:

```bash
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: Sistema de notificaciones en tiempo real"
```

### Flujo del Pipeline

```
1. Planning Phase
   └─> Genera Issue
        │
        ▼
2. Feasibility Phase
   └─> Analiza viabilidad
        │
        ├─> Decision: GO ──> Continua
        │
        └─> Decision: NO-GO ──> STOP
             │
             └─> Genera reporte early-stop
        │
        ▼
3. Design Phase
   └─> Genera HLD, LLD, ADRs
        │
        ▼
4. Implementation Phase (MANUAL - no ejecutado por agent)
   └─> Desarrollador implementa segun diseño
        │
        ▼
5. Testing Phase
   └─> Genera test strategy y test cases
        │
        ▼
6. Deployment Phase
   └─> Genera deployment plan
        │
        ▼
Final Report generado
```

### Modo Auto-Proceed

Por defecto, el pipeline pide confirmacion humana entre fases. Para ejecutar sin pausas:

```bash
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: Dashboard de metricas" \
  --auto-proceed
```

**ADVERTENCIA:** Solo usar `--auto-proceed` en entornos de prueba o CI/CD. Siempre revisar outputs en produccion.

## Parametros y Opciones

### --phase

Ejecuta una fase especifica del SDLC.

**Valores validos:**
- `planning`
- `feasibility`
- `design`
- `testing`
- `deployment`
- `maintenance` (no implementado aun)

**Ejemplo:**
```bash
python scripts/sdlc_agent.py --phase planning --input "Feature: ..."
```

### --pipeline

Ejecuta el pipeline completo (todas las fases en secuencia).

**Ejemplo:**
```bash
python scripts/sdlc_agent.py --pipeline --input "Feature: ..."
```

### --input

Feature request como texto directo.

**Ejemplo:**
```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Implementar autenticacion de dos factores (2FA) usando TOTP"
```

### --input-file

Lee el feature request desde un archivo.

**Ejemplo:**
```bash
# Crear archivo con feature request
cat > feature_request.txt << EOF
Feature: Sistema de Reportes Personalizados

Como usuario administrador
Quiero crear reportes personalizados
Para analizar metricas especificas del negocio

Detalles:
- Soporte para filtros dinamicos
- Exportacion a PDF y Excel
- Visualizaciones interactivas
- Scheduled reports
EOF

# Ejecutar con archivo
python scripts/sdlc_agent.py \
  --phase planning \
  --input-file feature_request.txt
```

### --project-context

Contexto adicional del proyecto (opcional).

**Ejemplo:**
```bash
python scripts/sdlc_agent.py \
  --phase design \
  --input "Feature: Cache layer" \
  --project-context "Proyecto usa Django + React. Database: MySQL + Cassandra. NO usar Redis (RNF-002)."
```

### --dry-run

No guarda artefactos (modo prueba).

**Ejemplo:**
```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Test" \
  --dry-run
```

Output:
```
[DRY-RUN] Guardaria artefacto en: docs/sdlc_outputs/planning/issue-001.md
```

### --format

Formato de output (text o json).

**Text (default):**
```bash
python scripts/sdlc_agent.py --phase planning --input "Feature: ..." --format text
```

**JSON:**
```bash
python scripts/sdlc_agent.py --phase planning --input "Feature: ..." --format json
```

Output JSON:
```json
{
  "status": "success",
  "data": {
    "issue_title": "Implementar sistema de notificaciones",
    "story_points": 8,
    "priority": "P1",
    "acceptance_criteria": [...],
    "technical_requirements": [...]
  }
}
```

### --verbose

Logging detallado (DEBUG level).

**Ejemplo:**
```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: ..." \
  --verbose
```

Output:
```
[10:30:15] sdlc_agent - DEBUG - Iniciando CLI
[10:30:15] SDLCPlannerAgent - DEBUG - Validando inputs
[10:30:16] SDLCPlannerAgent - DEBUG - Cargando Constitution
[10:30:17] SDLCPlannerAgent - DEBUG - Generando issue
...
```

## Integracion con Constitution

Todos los agentes SDLC integran automaticamente la Constitution del proyecto (`docs/gobernanza/CONSTITUTION.md`).

### Como Funciona

```python
# Dentro de cada agente
constitution_loader = ConstitutionLoader()
constitution = constitution_loader.load()

# El agente considera:
# - Restricciones criticas (RNF-002)
# - Valores del proyecto
# - Reglas de gobernanza
# - Estandares de calidad
```

### Ejemplo: Validacion de Restricciones

Si intentas usar una tecnologia prohibida:

```bash
python scripts/sdlc_agent.py \
  --phase feasibility \
  --input "Feature: Implementar queue con RabbitMQ"
```

Output:
```
Decision: NO-GO
Confianza: 100%

Razones:
  - VIOLACION RNF-002: RabbitMQ esta prohibido
  - Alternativas permitidas: Celery con Database broker, SQS

Recomendaciones:
  - Revisar ADR-XXX sobre message queuing
  - Usar alternativa compatible con restricciones
```

### Validacion Manual

Tambien puedes validar manualmente:

```bash
./scripts/validate_critical_restrictions.sh
```

## Integracion con DORA Metrics

Los artefactos generados por sdlc_agent.py alimentan las DORA metrics:

### Lead Time for Changes

Cada issue generado incluye timestamp:

```markdown
---
generated_at: 2025-11-07T10:30:00Z
phase: planning
---
```

Esto permite calcular lead time desde planning hasta deployment.

### Deployment Frequency

Los deployment plans generados se trackean para medir frecuencia.

### Ver Metricas

```bash
python scripts/dora_metrics.py --repo 2-Coatl/IACT---project
```

Output:
```
DORA METRICS REPORT
================================================================================

Deployment Frequency: 2.5 deployments/day [ELITE]
Lead Time for Changes: 4.2 hours [ELITE]
Change Failure Rate: 8% [ELITE]
MTTR: 0.8 hours [ELITE]

Overall Classification: ELITE
```

## Ejemplos de Uso Real

### Ejemplo 1: Feature Completo (Planning + Design)

```bash
# 1. Planning
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Sistema de notificaciones push multi-plataforma (web, iOS, Android)"

# Output: docs/sdlc_outputs/planning/issue-042.md

# 2. Feasibility
python scripts/sdlc_agent.py \
  --phase feasibility \
  --input "Feature: Sistema de notificaciones push multi-plataforma"

# Output: Decision: GO (confidence: 85%)

# 3. Design
python scripts/sdlc_agent.py \
  --phase design \
  --input "Feature: Sistema de notificaciones push multi-plataforma"

# Output:
# - docs/sdlc_outputs/design/HLD_push_notifications.md
# - docs/sdlc_outputs/design/LLD_push_notifications.md
# - docs/sdlc_outputs/design/ADR_001_push_provider_selection.md
```

### Ejemplo 2: Pipeline Completo con Auto-Proceed

```bash
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: Dashboard de metricas DORA con visualizaciones interactivas" \
  --auto-proceed \
  --format json > output.json

# Procesa output JSON
cat output.json | jq '.phase_results.planning.issue_title'
# "Dashboard de metricas DORA interactivo"
```

### Ejemplo 3: Dry-Run para Testing

```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Test dry-run" \
  --dry-run \
  --verbose
```

### Ejemplo 4: Uso en CI/CD

```yaml
# .github/workflows/sdlc-planning.yml
name: SDLC Planning

on:
  issues:
    types: [labeled]

jobs:
  generate-sdlc-artifacts:
    if: github.event.label.name == 'auto-sdlc'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run SDLC Planning
        run: |
          python scripts/sdlc_agent.py \
            --phase planning \
            --input "${{ github.event.issue.title }}" \
            --format json > planning_output.json

      - name: Comment on issue
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const output = JSON.parse(fs.readFileSync('planning_output.json'));
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `SDLC Planning completado:\n\nStory Points: ${output.data.story_points}\nPrioridad: ${output.data.priority}`
            });
```

## Troubleshooting

### Error: "ModuleNotFoundError: No module named 'agents'"

**Causa:** Python no encuentra el modulo agents.

**Solucion:**
```bash
# Ejecutar desde raiz del proyecto
cd /home/user/IACT---project
python scripts/sdlc_agent.py --phase planning --input "..."

# O agregar a PYTHONPATH
export PYTHONPATH=$PYTHONPATH:/home/user/IACT---project/scripts/ai
```

### Error: "GITHUB_TOKEN required"

**Causa:** Algunas integraciones requieren GitHub token.

**Solucion:**
```bash
# Crear personal access token en GitHub
# Settings -> Developer settings -> Personal access tokens
export GITHUB_TOKEN="ghp_..."

# O agregarlo al .env
echo "GITHUB_TOKEN=ghp_..." >> .env
```

### Error: "Invalid phase: xyz"

**Causa:** Fase no reconocida.

**Solucion:**
```bash
# Fases validas: planning, feasibility, design, testing, deployment
python scripts/sdlc_agent.py --phase planning --input "..."
```

### Warning: "Phase 'maintenance' not implemented yet"

**Causa:** Fase maintenance no esta implementada aun.

**Solucion:**
Usa las fases implementadas (planning, feasibility, design, testing, deployment).

### Output vacio o incompleto

**Causa:** Feature request muy vago o incompleto.

**Solucion:**
Proporciona feature request mas detallado:

```bash
# Malo
python scripts/sdlc_agent.py --phase planning --input "Feature: API"

# Bueno
python scripts/sdlc_agent.py --phase planning --input "Feature: REST API para gestion de usuarios con autenticacion JWT, CRUD completo, paginacion y filtros"
```

### Performance lento

**Causa:** Modelo LLM puede ser lento en requests grandes.

**Solucion:**
```bash
# Usar modelo mas rapido (si disponible)
export SDLC_LLM_MODEL="claude-3-haiku-20240307"

# O reducir complejidad del feature request
```

## Mejores Practicas

### 1. Feature Requests Claros

**Bueno:**
```
Feature: Sistema de autenticacion OAuth2

Como usuario
Quiero poder iniciar sesion usando Google o GitHub
Para no tener que crear otra cuenta

Detalles tecnicos:
- Soporte Google OAuth2
- Soporte GitHub OAuth2
- Callback URL configurable
- Almacenar token de refresh
- Auto-registro de usuarios nuevos
```

**Malo:**
```
Feature: Login con OAuth
```

### 2. Usar Dry-Run para Probar

Siempre prueba primero con `--dry-run`:

```bash
python scripts/sdlc_agent.py --phase planning --input "..." --dry-run
```

### 3. Guardar Outputs Importantes

```bash
# Guardar output JSON
python scripts/sdlc_agent.py \
  --phase planning \
  --input "..." \
  --format json > planning_output_$(date +%Y%m%d_%H%M%S).json
```

### 4. Usar Project Context

Proporciona contexto del proyecto para mejores resultados:

```bash
python scripts/sdlc_agent.py \
  --phase design \
  --input "Feature: Cache" \
  --project-context "Proyecto: Django + React + MySQL + Cassandra. Restricciones: NO Redis, NO MongoDB (RNF-002)"
```

### 5. Revisar Artefactos Generados

Siempre revisa y edita los artefactos generados antes de usarlos:

```bash
# Despues de ejecutar planning
cat docs/sdlc_outputs/planning/issue-001.md

# Editar si es necesario
vi docs/sdlc_outputs/planning/issue-001.md
```

### 6. Versionado de Artefactos

Commitea los artefactos generados:

```bash
git add docs/sdlc_outputs/
git commit -m "docs(sdlc): agregar artefactos planning para feature X"
```

### 7. Pipeline en Etapas

No uses `--pipeline` para features complejos. Ejecuta fase por fase y revisa:

```bash
# 1. Planning
python scripts/sdlc_agent.py --phase planning --input "..."
# Revisar output

# 2. Feasibility
python scripts/sdlc_agent.py --phase feasibility --input "..."
# Revisar output

# 3. Design
python scripts/sdlc_agent.py --phase design --input "..."
# Revisar output
```

## Flujo de Trabajo Completo

### Workflow Recomendado

```
1. Recibir feature request (GitHub issue, Jira ticket, etc)
   │
   ▼
2. Ejecutar Planning phase
   │
   ├─> python scripts/sdlc_agent.py --phase planning --input "..."
   │
   ├─> Revisar issue generado
   │
   └─> Commitear: git add docs/sdlc_outputs/planning/
   │
   ▼
3. Ejecutar Feasibility phase
   │
   ├─> python scripts/sdlc_agent.py --phase feasibility --input "..."
   │
   ├─> Decision GO? ──> Continuar
   │                └─> Decision NO-GO? ──> Resolver blockers primero
   │
   ▼
4. Ejecutar Design phase
   │
   ├─> python scripts/sdlc_agent.py --phase design --input "..."
   │
   ├─> Revisar HLD, LLD, ADRs
   │
   ├─> Aprobar diseño con equipo
   │
   └─> Commitear: git add docs/sdlc_outputs/design/
   │
   ▼
5. Implementacion (MANUAL)
   │
   ├─> Seguir diseño generado
   │
   ├─> TDD approach
   │
   └─> Code review
   │
   ▼
6. Ejecutar Testing phase
   │
   ├─> python scripts/sdlc_agent.py --phase testing --input "..."
   │
   ├─> Implementar tests segun strategy
   │
   └─> Validar coverage >= 80%
   │
   ▼
7. Ejecutar Deployment phase
   │
   ├─> python scripts/sdlc_agent.py --phase deployment --input "..."
   │
   ├─> Revisar deployment plan
   │
   ├─> Ejecutar pre-deployment checklist
   │
   └─> Deploy to staging
   │
   ▼
8. Monitoreo post-deployment
   │
   ├─> Ejecutar smoke tests
   │
   ├─> Monitorear metricas
   │
   └─> Deploy to production (si staging exitoso)
```

### Diagrama ASCII del Workflow

```
Feature Request
      │
      ▼
[Planning Phase]
      │
      ▼
   Issue.md ──────────┐
      │               │
      ▼               │
[Feasibility Phase]   │
      │               │
      ├─> GO          │
      │               │
      ▼               │
   Feasibility        │
   Report.md          │
      │               │
      ▼               │
[Design Phase]        │
      │               │
      ▼               │
   HLD.md             │
   LLD.md             │
   ADRs/              │
   Diagrams/          │
      │               │
      ▼               │
[Implementation] <────┘
   (Manual)
      │
      ▼
[Testing Phase]
      │
      ▼
   Test Strategy
   Test Cases
      │
      ▼
[Deployment Phase]
      │
      ▼
   Deployment Plan
   Rollback Plan
   Checklists
      │
      ▼
   Production
```

## Proximos Pasos

1. **Explorar agentes especificos:** Ver [sdlc-agents-reference.md](./sdlc-agents-reference.md)
2. **Ver ejemplos de CI/CD:** Ver [ci-cd-scripts.md](./ci-cd-scripts.md)
3. **Entender DORA metrics:** Ver [metrics-and-reporting.md](./metrics-and-reporting.md)
4. **Crear scripts personalizados:** Ver [script-development-guide.md](./script-development-guide.md)

## Referencias

- **Codigo fuente:** `/home/user/IACT---project/scripts/sdlc_agent.py`
- **Agentes SDLC:** `/home/user/IACT---project/scripts/ai/agents/`
- **Constitution:** `/home/user/IACT---project/docs/gobernanza/CONSTITUTION.md`
- **SDLC Process:** `/home/user/IACT---project/docs/gobernanza/procesos/SDLC_PROCESS.md`
- **DORA Metrics:** `/home/user/IACT---project/scripts/dora_metrics.py`

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0
**Mantenedores:** @tech-lead, @arquitecto-senior
