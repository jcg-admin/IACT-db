---
id: INDICE-WORKFLOWS
tipo: indice_ci_cd
version: 1.0
fecha: 2025-11-06
owner: devops-lead
---

# Indice de Workflows CI/CD - Proyecto IACT

Estado actual de todos los workflows de GitHub Actions del proyecto.

## Total de Workflows: 8

## Estado de Documentacion

### WORKFLOWS EXISTENTES [8/8]

#### 1. docs-validation.yml [ACTIVO - DOCUMENTADO]
**Ubicacion**: `.github/workflows/docs-validation.yml`
**Proposito**: Validacion automatica de estructura de documentacion
**Triggers**:
- Pull requests que modifican `docs/**`
- Push a main, develop, claude/**

**Jobs**:
- validate-structure: Ejecuta `scripts/validar_estructura_docs.sh`
- check-old-references: Detecta referencias obsoletas a `implementacion/`
- check-markdown-links: Valida links rotos (markdown-link-check)
- validate-auto-generated-docs: Verifica metadata en docs auto-generados
- count-docs-stats: Genera estadisticas de documentacion

**Documentacion**:
- Template en: `docs/gobernanza/procesos/DEVOPS_AUTOMATION.md` (lineas 102-120)
- Implementado en sesion previa

**Estado**: FUNCIONAL

---

#### 2. sync-docs.yml [ACTIVO - DOCUMENTADO]
**Ubicacion**: `.github/workflows/sync-docs.yml`
**Proposito**: Sincronizacion semanal automatica de docs con codigo
**Triggers**:
- Schedule: Lunes 9 AM UTC (cron: '0 9 * * 1')
- Manual: workflow_dispatch

**Jobs**:
- sync-documentation: Ejecuta DocumentationSyncAgent
- Crea PR automatico si detecta cambios
- Notifica en caso de failure

**Documentacion**:
- Template en: `docs/gobernanza/procesos/DEVOPS_AUTOMATION.md` (lineas 121-135)
- Implementado en sesion previa

**Estado**: FUNCIONAL

---

#### 3. python_ci.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/python_ci.yml`
**Proposito**: CI para codigo Python (Django backend)
**Triggers**: Push, Pull requests

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

**Accion requerida**:
- Documentar en DEVOPS_AUTOMATION.md
- Verificar coverage de tests
- Validar que NO usa Redis (RNF-002)

---

#### 4. lint.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/lint.yml`
**Proposito**: Linting de codigo (Python, JS/TS)

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

**Accion requerida**:
- Documentar herramientas usadas (flake8, black, eslint)
- Integrar en DEVOPS_AUTOMATION.md

---

#### 5. requirements_validate_traceability.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/requirements_validate_traceability.yml`
**Proposito**: Validacion de trazabilidad de requisitos

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

**Accion requerida**:
- Documentar matriz de trazabilidad
- Verificar referencias upward/downward

---

#### 6. requirements_index.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/requirements_index.yml`
**Proposito**: Generacion automatica de indice de requisitos

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

---

#### 7. docs.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/docs.yml`
**Proposito**: Build y deploy de documentacion (MkDocs?)

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

---

#### 8. release.yml [ACTIVO - SIN DOCUMENTAR]
**Ubicacion**: `.github/workflows/release.yml`
**Proposito**: Automatizacion de releases

**Estado**: FUNCIONAL - NECESITA DOCUMENTACION

---

## WORKFLOWS DOCUMENTADOS EN DEVOPS_AUTOMATION.md [0/8]

**NOTA IMPORTANTE**: Los workflows documentados en `docs/gobernanza/procesos/DEVOPS_AUTOMATION.md`
son TEMPLATES/EJEMPLOS, NO son los workflows REALES del proyecto.

### Workflows Templates Documentados (NO implementados):
- backend-ci.yml (ejemplo - lineas ~50-90)
- frontend-ci.yml (ejemplo - lineas ~91-140)
- test-pyramid.yml (ejemplo)
- deploy.yml (ejemplo)
- infrastructure-ci.yml (ejemplo)
- migrations.yml (ejemplo)
- security-scan.yml (ejemplo)
- incident-response.yml (ejemplo)

**TODOS ESTOS SON EJEMPLOS TEORICOS**, no workflows reales del proyecto.

---

## WORKFLOWS FALTANTES SEGUN DEVOPS_AUTOMATION.md [8/8]

Los siguientes workflows estan documentados como templates en DEVOPS_AUTOMATION.md
pero NO estan implementados en `.github/workflows/`:

1. backend-ci.yml [NO IMPLEMENTADO]
   - Template: Django + PostgreSQL + MySQL testing
   - Status: Necesita implementacion

2. frontend-ci.yml [NO IMPLEMENTADO]
   - Template: React + TypeScript + Jest
   - Status: Necesita implementacion

3. test-pyramid.yml [NO IMPLEMENTADO]
   - Template: Unit -> Integration -> E2E
   - Status: Necesita implementacion

4. deploy.yml [NO IMPLEMENTADO]
   - Template: Blue-Green deployment
   - Status: Necesita implementacion

5. infrastructure-ci.yml [NO IMPLEMENTADO]
   - Template: Terraform validation
   - Status: Necesita implementacion

6. migrations.yml [NO IMPLEMENTADO]
   - Template: Database migrations automation
   - Status: Necesita implementacion

7. security-scan.yml [NO IMPLEMENTADO]
   - Template: Bandit + npm audit + Trivy
   - Status: Necesita implementacion

8. incident-response.yml [NO IMPLEMENTADO]
   - Template: Automated incident handling
   - Status: Necesita implementacion

---

## ANALISIS DE DOCUMENTACION REALIZADO

### Sesion 2025-11-06

**Que se hizo**:
1. Reorganizacion de estructura `docs/`
   - Eliminado nivel `implementacion/`
   - 128 archivos movidos
   - 1:1 mapping con codigo

2. Generacion automatica de documentacion:
   - `docs/backend/arquitectura/authentication.md` (354 lineas)
   - `docs/backend/arquitectura/users.md` (166 lineas)
   - `docs/backend/arquitectura/audit.md` (223 lineas)

3. Documentacion de procesos:
   - `docs/gobernanza/procesos/SDLC_PROCESS.md` (500+ lineas)
   - `docs/gobernanza/procesos/DEVOPS_AUTOMATION.md` (584 lineas)

4. Sistema de agentes SDLC:
   - `scripts/ai/agents/ARCHITECTURE_SDLC_AGENTS.md` (527 lineas)
   - `scripts/ai/agents/README_SDLC_AGENTS.md` (600+ lineas)
   - SDLCPlannerAgent implementado y funcional

5. Issues retrospectivos generados:
   - CODEOWNERS (2 story points)
   - CI/CD validation (2 story points)
   - Audit tests (3 story points)

**Archivos de docs analizados**: ~200+ archivos
**Archivos movidos**: 128 archivos
**Documentacion generada**: ~3,000 lineas
**Validaciones creadas**: 4 scripts shell

---

## ESTADO ACTUAL DEL PROYECTO

### Documentacion: [PARCIAL]
- Estructura reorganizada: SI
- Docs backend criticos: SI (authentication, users, audit)
- Proceso SDLC: SI
- Proceso DevOps: SI
- Workflows reales: NO (0/8 documentados)

### Workflows CI/CD: [FUNCIONALES PERO NO DOCUMENTADOS]
- Workflows activos: 8/8
- Workflows documentados: 2/8 (docs-validation, sync-docs)
- Workflows faltantes: 8 (templates en DEVOPS_AUTOMATION.md)

### Agentes SDLC: [INICIAL]
- SDLCPlannerAgent: IMPLEMENTADO
- SDLCFeasibilityAgent: PENDIENTE
- SDLCDesignAgent: PENDIENTE
- SDLCTestingAgent: PENDIENTE
- SDLCDeploymentAgent: PENDIENTE
- SDLCOrchestratorAgent: PENDIENTE

### Scripts Shell: [PARCIAL]
- Validaciones: 4/4 (validate_critical_restrictions.sh, etc)
- Testing: 0/1 (run_all_tests.sh - pendiente)
- Deployment: 0/1 (deploy.sh - pendiente)
- Monitoring: 0/2 (health_check.sh, cleanup_sessions.sh - pendientes)
- Analytics: 0/3 (analytics_portal_setup.sh, etc - pendientes)

---

## COMO EMPEZAR UNA NUEVA IMPLEMENTACION

### Opcion 1: Proceso SDLC Completo (RECOMENDADO)

#### Paso 1: Planning Phase
```bash
# Generar issue con SDLCPlannerAgent
python scripts/sdlc_agent.py --phase planning \
  --input "Feature: [Descripcion del feature]" \
  --format text

# Revisar issue generado
cat docs/sdlc_outputs/planning/ISSUE_*.md

# Crear issue en GitHub (opcional)
gh issue create --title "..." --body "..."
```

**Output**: Issue con user story, acceptance criteria, story points, prioridad

#### Paso 2: Feasibility Analysis
```bash
# TODO: Implementar SDLCFeasibilityAgent
# Por ahora: Analisis manual
```

**Preguntas clave**:
- Es tecnicamente viable?
- Viola alguna restriccion critica (NO Redis, NO Email)?
- Riesgos identificados?
- Go/No-Go decision?

#### Paso 3: Design Phase
```bash
# TODO: Implementar SDLCDesignAgent
# Por ahora: Diseno manual
```

**Artefactos requeridos**:
- HLD (High-Level Design)
- LLD (Low-Level Design) si es complejo
- ADR (Architecture Decision Record) si hay decisiones importantes
- Diagramas (Mermaid)

#### Paso 4: Implementation Phase

**4.1 Crear branch**:
```bash
git checkout -b feature/nombre-feature-issue-123
```

**4.2 Validar restricciones ANTES de codear**:
```bash
./scripts/validate_critical_restrictions.sh
./scripts/validate_security_config.sh
```

**4.3 Implementar**:
- Seguir coding standards
- NO usar Redis (RNF-002)
- NO usar Email (usar InternalMessage)
- Sesiones en MySQL obligatorio

**4.4 Tests PRIMERO** (TDD):
```bash
cd api/callcentersite
pytest tests/[area]/test_[feature].py -v
```

#### Paso 5: Testing Phase

**5.1 Ejecutar suite completa**:
```bash
# TODO: Implementar run_all_tests.sh
# Por ahora:
cd api/callcentersite
pytest --cov=callcentersite --cov-report=term --cov-fail-under=80
```

**5.2 Validar coverage**:
- Target: >80%
- Critico: 100% para security features

**5.3 Validar restricciones**:
```bash
./scripts/validate_critical_restrictions.sh
```

#### Paso 6: Deployment Phase

**6.1 Crear PR**:
```bash
git add .
git commit -m "feat(area): descripcion corta

Descripcion detallada del cambio.

**Cambios**:
- Item 1
- Item 2

**Tests**:
- Coverage: XX%
- Tests criticos: OK

**Referencias**:
- Issue: #123
- Requisitos: RF-XXX, RNF-XXX
"

git push -u origin feature/nombre-feature-issue-123

gh pr create --title "..." --body "..."
```

**6.2 Code Review**:
- CODEOWNERS asignara reviewers automaticamente
- Arquitecto senior revisa arquitectura
- DevOps revisa si hay cambios de infra
- QA revisa tests

**6.3 Deploy**:
```bash
# TODO: Implementar deploy.sh
# Por ahora: Manual
```

#### Paso 7: Maintenance Phase

**Monitoring**:
```bash
# TODO: Implementar health_check.sh
# Verificar que el feature funciona en produccion
```

**Metricas**:
```bash
# Despues de 30 dias
python scripts/dora_metrics.py --days 30
```

---

### Opcion 2: Proceso Rapido (Solo para cambios menores)

**SOLO usar para**:
- Typos en docs
- Cambios de formato
- Refactoring trivial (<5 lineas)

**Proceso**:
```bash
# 1. Validar restricciones
./scripts/validate_critical_restrictions.sh

# 2. Hacer cambio

# 3. Tests rapidos si aplica
pytest [archivo_afectado]

# 4. Commit atomico
git add [archivo]
git commit -m "fix(area): descripcion corta"

# 5. Push
git push
```

**NO usar proceso rapido para**:
- Nuevos features
- Cambios de arquitectura
- Cambios de seguridad
- Cambios de requisitos

---

## DECISION TREE: Que proceso usar?

```
Nuevo feature?
├─ SI → Proceso SDLC Completo
│   ├─ Planning: SDLCPlannerAgent
│   ├─ Feasibility: Analisis manual (por ahora)
│   ├─ Design: HLD/LLD/ADR
│   ├─ Implementation: TDD + Validaciones
│   ├─ Testing: Coverage >80%
│   ├─ Deployment: PR + Review
│   └─ Maintenance: Monitoring
│
└─ NO → Es cambio menor (<5 lineas, no critico)?
    ├─ SI → Proceso Rapido
    │   ├─ Validar restricciones
    │   ├─ Cambio
    │   ├─ Tests si aplica
    │   └─ Commit atomico
    │
    └─ NO → Proceso SDLC Completo
```

---

## TAREAS PENDIENTES CRITICAS

### Alta Prioridad (Esta semana)

1. **Documentar workflows reales existentes**:
   - [ ] python_ci.yml
   - [ ] lint.yml
   - [ ] requirements_validate_traceability.yml
   - [ ] requirements_index.yml
   - [ ] docs.yml
   - [ ] release.yml

   **Como**: Leer cada workflow, extraer proposito, documentar en este indice

2. **Implementar scripts shell documentados**:
   - [ ] scripts/run_all_tests.sh
   - [ ] scripts/deploy.sh
   - [ ] scripts/health_check.sh
   - [ ] scripts/cleanup_sessions.sh

3. **Implementar SDLCFeasibilityAgent**:
   - [ ] Risk assessment matrix
   - [ ] Go/No-Go recommendation
   - [ ] Integration con pipeline

### Media Prioridad (Este mes)

4. **Implementar workflows faltantes**:
   - [ ] .github/workflows/backend-ci.yml (real, no template)
   - [ ] .github/workflows/frontend-ci.yml
   - [ ] .github/workflows/security-scan.yml

5. **Completar sistema SDLC**:
   - [ ] SDLCDesignAgent
   - [ ] SDLCTestingAgent
   - [ ] SDLCDeploymentAgent

---

## REFERENCIAS

- **Workflows existentes**: `.github/workflows/`
- **Templates workflows**: `docs/gobernanza/procesos/DEVOPS_AUTOMATION.md`
- **Proceso SDLC**: `docs/gobernanza/procesos/SDLC_PROCESS.md`
- **Agentes SDLC**: `scripts/ai/agents/README_SDLC_AGENTS.md`
- **TODO Master**: `TODO.md`
- **Restricciones**: `docs/backend/requisitos/restricciones_y_lineamientos.md`

---

## ACTUALIZACION 2025-11-06 (Segunda Sesion)

### WORKFLOWS IMPLEMENTADOS [8/8]

Los 8 workflows que estaban documentados como templates en DEVOPS_AUTOMATION.md
han sido IMPLEMENTADOS y estan ahora funcionales en el proyecto:

#### 1. backend-ci.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/backend-ci.yml`
**Script**: `scripts/ci/backend_test.sh`
**Proposito**: Tests Django con MySQL y PostgreSQL
**Documentacion**: `docs/gobernanza/ci_cd/workflows/backend-ci.md`
**Jobs**:
- lint (flake8, black, isort)
- test-mysql
- test-postgresql
- validate-restrictions (RNF-002)
- integration-tests

#### 2. frontend-ci.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/frontend-ci.yml`
**Script**: `scripts/ci/frontend_test.sh`
**Proposito**: Tests React/TypeScript con Jest y Playwright
**Documentacion**: `docs/gobernanza/ci_cd/workflows/frontend-ci.md`
**Jobs**:
- lint (ESLint, Prettier, TypeScript)
- test-unit
- test-integration
- test-e2e
- build
- accessibility
- security

#### 3. test-pyramid.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/test-pyramid.yml`
**Script**: `scripts/ci/test_pyramid_check.sh`
**Proposito**: Validacion test pyramid 60/30/10
**Documentacion**: `docs/gobernanza/ci_cd/workflows/test-pyramid.md`

#### 4. deploy.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/deploy.yml`
**Proposito**: Blue-green deployment staging/production
**Documentacion**: `docs/gobernanza/ci_cd/workflows/deploy.md`

#### 5. migrations.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/migrations.yml`
**Proposito**: Validacion automatica migraciones Django
**Documentacion**: `docs/gobernanza/ci_cd/workflows/migrations.md`

#### 6. infrastructure-ci.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/infrastructure-ci.yml`
**Proposito**: Validacion shellcheck, Terraform, Docker
**Documentacion**: `docs/gobernanza/ci_cd/workflows/infrastructure-ci.md`

#### 7. security-scan.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/security-scan.yml`
**Script**: `scripts/ci/security_scan.sh`
**Proposito**: Security scan completo (Bandit, npm audit, SQL injection, XSS, CSRF)
**Documentacion**: `docs/gobernanza/ci_cd/workflows/security-scan.md`

#### 8. incident-response.yml [IMPLEMENTADO Y DOCUMENTADO]
**Ubicacion**: `.github/workflows/incident-response.yml`
**Proposito**: Manejo automatizado de incidentes con playbooks
**Documentacion**: `docs/gobernanza/ci_cd/workflows/incident-response.md`

### SCRIPTS SHELL LOCALES IMPLEMENTADOS [4/4]

Siguiendo principio "Scripts Primero, CI/CD Despues":

1. **scripts/ci/backend_test.sh** [IMPLEMENTADO]
   - Tests Django local (MySQL/PostgreSQL)
   - Validacion RNF-002
   - Documentacion: `docs/gobernanza/ci_cd/scripts/backend_test.md`

2. **scripts/ci/frontend_test.sh** [IMPLEMENTADO]
   - Tests React local (unit/integration/E2E)
   - Documentacion: `docs/gobernanza/ci_cd/scripts/frontend_test.md`

3. **scripts/ci/test_pyramid_check.sh** [IMPLEMENTADO]
   - Validacion pyramid 60/30/10 local
   - Documentacion: `docs/gobernanza/ci_cd/scripts/test_pyramid_check.md`

4. **scripts/ci/security_scan.sh** [IMPLEMENTADO]
   - Security scan completo local
   - Documentacion: `docs/gobernanza/ci_cd/scripts/security_scan.md`

### AGENTES SDLC IMPLEMENTADOS [5/5]

Sistema multi-agente SDLC completo:

1. **SDLCPlannerAgent** [IMPLEMENTADO]
2. **SDLCFeasibilityAgent** [IMPLEMENTADO]
3. **SDLCDesignAgent** [IMPLEMENTADO]
4. **SDLCTestingAgent** [IMPLEMENTADO]
5. **SDLCDeploymentAgent** [IMPLEMENTADO]
6. **SDLCOrchestratorAgent** [IMPLEMENTADO]

**Documentacion**: `docs/gobernanza/procesos/AGENTES_SDLC.md`

### DOCUMENTACION CI/CD COMPLETA

Nueva estructura de documentacion en `docs/gobernanza/ci_cd/`:

- README.md - Vista general
- INDICE.md - Indice completo
- GUIA_USO.md - Guias por rol (Developer/QA/DevOps/TechLead)
- TROUBLESHOOTING.md - Problemas comunes y soluciones
- EJEMPLOS.md - Flujos end-to-end completos
- workflows/ - Docs detallada de cada workflow (8)
- scripts/ - Docs detallada de cada script (4)

### RESTRICCIONES IACT VALIDADAS

Todos los workflows y scripts validan:
- RNF-002: NO Redis, sesiones en MySQL
- NO Email/SMTP (InternalMessage)
- NO Emojis/Iconos (ASCII puro)
- Scripts funcionan offline/local

---

**Ultima actualizacion**: 2025-11-06 (Segunda sesion)
**Version**: 2.0
**Mantenedor**: @devops-lead @arquitecto-senior
**Proxima revision**: 2025-11-13
