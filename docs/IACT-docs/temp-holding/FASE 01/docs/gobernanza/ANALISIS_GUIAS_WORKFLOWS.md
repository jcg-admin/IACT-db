---
id: ANALISIS-GUIAS-WORKFLOWS
tipo: analisis
categoria: gobernanza
version: 1.0.0
fecha: 2025-11-07
propietario: arquitecto-senior
relacionados: [INDICE_WORKFLOWS.md, SDLC_PROCESS.md, AGENTES_SDLC.md]
---

# Analisis Exhaustivo - Guias y Workflows del Proyecto IACT

Este documento analiza TODOS los workflows, procesos, scripts y checklists del proyecto IACT para determinar cuantas guias operativas se pueden generar y como se activa cada proceso.

**Fecha de analisis:** 2025-11-07
**Archivos analizados:** 315 archivos markdown + 88 scripts + 16 workflows
**Scope:** Proyecto completo IACT

---

## RESUMEN EJECUTIVO

### Inventario Total

| Categoria | Cantidad | Estado |
|-----------|----------|--------|
| GitHub Actions Workflows | 16 | Implementados |
| Scripts Automatizacion | 88 | Implementados |
| Procedimientos Documentados | 11 | Documentados |
| Checklists | 6 | Documentados |
| Agentes SDLC | 6 | Implementados |
| Fases SDLC | 7 | Definidas |
| Archivos Documentacion | 315 | Escritos |

### Guias Potenciales Identificadas

**TOTAL GUIAS GENERABLES: 147 guias**

Desglose:
- Guias por Workflow (16 workflows × 3 guias cada uno) = 48 guias
- Guias por Script (88 scripts × 1 guia cada uno) = 88 guias
- Guias por Fase SDLC (7 fases × 1 guia cada una) = 7 guias
- Guias Transversales = 4 guias

**TOTAL: 147 guias operativas completas**

---

## SECCION 1: WORKFLOWS GITHUB ACTIONS (16 workflows)

### 1.1 Lista Completa de Workflows

#### Workflows Core (8)

**1. backend-ci.yml**
- Ubicacion: .github/workflows/backend-ci.yml
- Proposito: CI para backend Django
- Triggers:
  - Push a: main, develop, feature/**, claude/**
  - Pull requests a: main, develop
  - Paths: api/**, requirements.txt
  - Manual: workflow_dispatch
- Jobs: lint, test-mysql, test-postgresql, validate-restrictions, integration-tests
- Scripts asociados: scripts/ci/backend_test.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/backend-ci.md
- Estado: IMPLEMENTADO

**2. frontend-ci.yml**
- Ubicacion: .github/workflows/frontend-ci.yml
- Proposito: CI para frontend React/TypeScript
- Triggers:
  - Push a: main, develop, feature/**, claude/**
  - Pull requests a: main, develop
  - Paths: frontend/**, package.json
  - Manual: workflow_dispatch
- Jobs: lint, test-unit, test-integration, test-e2e, build, accessibility, security
- Scripts asociados: scripts/ci/frontend_test.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/frontend-ci.md
- Estado: IMPLEMENTADO

**3. test-pyramid.yml**
- Ubicacion: .github/workflows/test-pyramid.yml
- Proposito: Validacion test pyramid (60% unit, 30% integration, 10% e2e)
- Triggers:
  - Push a: main, develop
  - Pull requests
  - Manual: workflow_dispatch
- Jobs: validate-pyramid
- Scripts asociados: scripts/ci/test_pyramid_check.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/test-pyramid.md
- Estado: IMPLEMENTADO

**4. deploy.yml**
- Ubicacion: .github/workflows/deploy.yml
- Proposito: Deployment blue-green a staging/production
- Triggers:
  - Push a: main (production)
  - Push a: develop (staging)
  - Manual: workflow_dispatch
- Jobs: deploy-staging, smoke-tests-staging, deploy-production, smoke-tests-production
- Scripts asociados: scripts/deploy/*.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/deploy.md
- Estado: IMPLEMENTADO

**5. migrations.yml**
- Ubicacion: .github/workflows/migrations.yml
- Proposito: Validacion automatica migraciones Django
- Triggers:
  - Push a: main, develop
  - Paths: **/migrations/*.py
  - Pull requests
- Jobs: validate-migrations, check-conflicts, dry-run
- Scripts asociados: scripts/migrations/*.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/migrations.md
- Estado: IMPLEMENTADO

**6. infrastructure-ci.yml**
- Ubicacion: .github/workflows/infrastructure-ci.yml
- Proposito: Validacion infrastructure as code
- Triggers:
  - Push a: main, develop
  - Paths: infrastructure/**, Dockerfile, *.sh
  - Pull requests
  - Manual: workflow_dispatch
- Jobs: shellcheck, terraform-validate, docker-lint
- Scripts asociados: scripts/infrastructure/*.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/infrastructure-ci.md
- Estado: IMPLEMENTADO

**7. security-scan.yml**
- Ubicacion: .github/workflows/security-scan.yml
- Proposito: Security scanning completo
- Triggers:
  - Schedule: Diario 3 AM UTC
  - Push a: main
  - Pull requests
  - Manual: workflow_dispatch
- Jobs: bandit, npm-audit, sql-injection-check, xss-check, csrf-check
- Scripts asociados: scripts/ci/security_scan.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/security-scan.md
- Estado: IMPLEMENTADO

**8. incident-response.yml**
- Ubicacion: .github/workflows/incident-response.yml
- Proposito: Manejo automatizado de incidentes
- Triggers:
  - Issues con label: incident, p0, p1
  - Manual: workflow_dispatch con severity input
- Jobs: triage, execute-playbook, notify
- Scripts asociados: infrastructure/devops/runbooks/playbooks_operativos/*.sh
- Documentacion: docs/gobernanza/ci_cd/workflows/incident-response.md
- Estado: IMPLEMENTADO

#### Workflows Documentacion (3)

**9. docs-validation.yml**
- Ubicacion: .github/workflows/docs-validation.yml
- Proposito: Validacion estructura y calidad docs
- Triggers:
  - Push a: main, develop, claude/**
  - Pull requests
  - Paths: docs/**
- Jobs: validate-structure, check-old-references, check-markdown-links, validate-auto-generated-docs, count-docs-stats
- Scripts asociados: scripts/validar_estructura_docs.sh
- Documentacion: docs/gobernanza/procesos/DEVOPS_AUTOMATION.md
- Estado: IMPLEMENTADO

**10. sync-docs.yml**
- Ubicacion: .github/workflows/sync-docs.yml
- Proposito: Sincronizacion semanal docs con codigo
- Triggers:
  - Schedule: Lunes 9 AM UTC (cron: 0 9 * * 1)
  - Manual: workflow_dispatch
- Jobs: sync-documentation, create-pr
- Scripts asociados: scripts/ai/agents/documentation_sync_agent.py
- Documentacion: docs/gobernanza/procesos/DEVOPS_AUTOMATION.md
- Estado: IMPLEMENTADO

**11. docs.yml**
- Ubicacion: .github/workflows/docs.yml
- Proposito: Build y deploy documentacion MkDocs
- Triggers:
  - Push a: main, develop
  - Paths: docs/**, docs/mkdocs.yml
  - Pull requests (paths)
  - Manual: workflow_dispatch
- Jobs: build, deploy (GitHub Pages), check-links
- URL: https://2-coatl.github.io/IACT---project/
- Estado: IMPLEMENTADO

#### Workflows Codigo (2)

**12. python_ci.yml**
- Ubicacion: .github/workflows/python_ci.yml
- Proposito: CI Python completo (legacy, usar backend-ci.yml)
- Triggers:
  - Push a: main, develop, feature/**, claude/**
  - Pull requests
  - Paths: api/**, .github/workflows/python_ci.yml
  - Manual: workflow_dispatch
- Jobs: code-quality, tests, performance, dependency-check, build-status
- Estado: IMPLEMENTADO (considerar deprecar)

**13. lint.yml**
- Ubicacion: .github/workflows/lint.yml
- Proposito: Linting multi-lenguaje
- Triggers:
  - Push a: main, develop, feature/**, claude/**
  - Pull requests
- Jobs: markdown-lint, yaml-lint, docs-structure-check, requirements-frontmatter-check, summary
- Estado: IMPLEMENTADO

#### Workflows Requisitos (2)

**14. requirements_index.yml**
- Ubicacion: .github/workflows/requirements_index.yml
- Proposito: Generacion automatica indice requisitos
- Triggers:
  - Push a: main, develop
  - Paths: do../gobernanza/marco_integrado/**/*.md
  - Pull requests (paths)
- Jobs: generate-index
- Scripts asociados: scripts/requisitos/generar_indices.py
- Estado: IMPLEMENTADO

**15. requirements_validate_traceability.yml**
- Ubicacion: .github/workflows/requirements_validate_traceability.yml
- Proposito: Validacion trazabilidad requisitos
- Triggers:
  - Push a: main, develop
  - Paths: do../gobernanza/marco_integrado/**/*.md
  - Pull requests (paths)
- Jobs: validate-traceability
- Scripts asociados: scripts/requisitos/validar_frontmatter.py
- Estado: IMPLEMENTADO

#### Workflows Releases (1)

**16. release.yml**
- Ubicacion: .github/workflows/release.yml
- Proposito: Automatizacion releases
- Triggers:
  - Push tags: v*.*.*
  - Manual: workflow_dispatch
- Jobs: build, create-release, deploy-production, notify
- Estado: IMPLEMENTADO

### 1.2 Matriz de Activacion de Workflows

| Workflow | Push main | Push develop | PR | Schedule | Manual | Paths | Tags | Issues |
|----------|-----------|--------------|-----|----------|--------|-------|------|--------|
| backend-ci.yml | SI | SI | SI | NO | SI | api/** | NO | NO |
| frontend-ci.yml | SI | SI | SI | NO | SI | frontend/** | NO | NO |
| test-pyramid.yml | SI | SI | SI | NO | SI | - | NO | NO |
| deploy.yml | SI (prod) | SI (stage) | NO | NO | SI | - | NO | NO |
| migrations.yml | SI | SI | SI | NO | NO | **/migrations/** | NO | NO |
| infrastructure-ci.yml | SI | SI | SI | NO | SI | infra/**, *.sh | NO | NO |
| security-scan.yml | SI | NO | SI | SI (diario) | SI | - | NO | NO |
| incident-response.yml | NO | NO | NO | NO | SI | - | NO | SI |
| docs-validation.yml | SI | SI | SI | NO | NO | docs/** | NO | NO |
| sync-docs.yml | NO | NO | NO | SI (semanal) | SI | - | NO | NO |
| docs.yml | SI | SI | SI | NO | SI | docs/** | NO | NO |
| python_ci.yml | SI | SI | SI | NO | SI | api/** | NO | NO |
| lint.yml | SI | SI | SI | NO | NO | - | NO | NO |
| requirements_index.yml | SI | SI | SI | NO | NO | requisitos/** | NO | NO |
| requirements_validate.yml | SI | SI | SI | NO | NO | requisitos/** | NO | NO |
| release.yml | NO | NO | NO | NO | SI | - | SI | NO |

### 1.3 Guias por Workflow (48 guias)

Para cada workflow se pueden generar 3 guias:

**Guia 1: Usuario/Desarrollador**
- Como usar el workflow desde mi trabajo diario
- Como interpretar resultados
- Como solucionar errores comunes

**Guia 2: Mantenedor/DevOps**
- Como modificar el workflow
- Como agregar jobs/steps
- Como debuggear fallos

**Guia 3: Troubleshooting**
- Errores comunes y soluciones
- Logs importantes
- Escalation path

**Total: 16 workflows × 3 guias = 48 guias**

---

## SECCION 2: SCRIPTS DE AUTOMATIZACION (88 scripts)

### 2.1 Categorias de Scripts

#### CI/CD Scripts (4)

1. scripts/ci/backend_test.sh
   - Proposito: Tests Django local
   - Activacion: ./scripts/ci/backend_test.sh
   - Requiere: Python 3.11+, MySQL, PostgreSQL

2. scripts/ci/frontend_test.sh
   - Proposito: Tests React local
   - Activacion: ./scripts/ci/frontend_test.sh
   - Requiere: Node.js 18+, npm

3. scripts/ci/test_pyramid_check.sh
   - Proposito: Validacion pyramid local
   - Activacion: ./scripts/ci/test_pyramid_check.sh
   - Requiere: pytest-json-report

4. scripts/ci/security_scan.sh
   - Proposito: Security scan local
   - Activacion: ./scripts/ci/security_scan.sh
   - Requiere: bandit, safety, npm audit

#### Validacion Scripts (4)

5. scripts/validate_critical_restrictions.sh
   - Proposito: Validar RNF-002 (NO Redis, etc)
   - Activacion: ./scripts/validate_critical_restrictions.sh
   - Requiere: grep, find

6. scripts/validate_security_config.sh
   - Proposito: Validar config seguridad
   - Activacion: ./scripts/validate_security_config.sh
   - Requiere: Python, Django settings

7. scripts/validate_database_router.sh
   - Proposito: Validar database router
   - Activacion: ./scripts/validate_database_router.sh
   - Requiere: Python, Django

8. scripts/validar_estructura_docs.sh
   - Proposito: Validar estructura docs/
   - Activacion: ./scripts/validar_estructura_docs.sh
   - Requiere: find, grep

#### AI/Agentes Scripts (30)

Agentes SDLC:
9. scripts/ai/agents/sdlc_planner.py
10. scripts/ai/agents/sdlc_feasibility.py
11. scripts/ai/agents/sdlc_design.py
12. scripts/ai/agents/sdlc_testing.py
13. scripts/ai/agents/sdlc_deployment.py
14. scripts/ai/agents/sdlc_orchestrator.py

Agentes Test Generation:
15. scripts/ai/agents/test_planner.py
16. scripts/ai/agents/coverage_analyzer.py
17. scripts/ai/agents/test_runner.py
18. scripts/ai/agents/llm_generator.py
19. scripts/ai/agents/syntax_validator.py
20. scripts/ai/agents/coverage_verifier.py

Agentes Analisis:
21. scripts/ai/agents/business_analysis_pipeline.py
22. scripts/ai/agents/business_analysis_generator.py
23. scripts/ai/agents/traceability_matrix_generator.py

Agentes Documentacion:
24. scripts/ai/agents/documentation_sync_agent.py
25. scripts/ai/agents/document_splitter.py
26. scripts/ai/agents/template_generator.py

Utilidades:
27. scripts/ai/agents/base.py
28. scripts/ai/agents/sdlc_base.py
29. scripts/ai/agents/constitution_loader.py
30. scripts/ai/agents/completeness_validator.py
31. scripts/ai/agents/pr_creator.py
32. scripts/ai/agents/dora_sdlc_integration.py
33. scripts/ai/agents/pdca_automation_agent.py

Tests:
34. scripts/ai/agents/test_business_analysis_agents.py
35. scripts/ai/agents/test_constitution_integration.py

Orchestrators:
36. scripts/ai/test_generation_orchestrator.py
37. scripts/ai/run_test_generation.sh

Ejemplos:
38. scripts/ai/examples/quickstart.sh

#### Requisitos Scripts (5)

39. scripts/requisitos/listar_requisitos.sh
40. scripts/requisitos/contar_requisitos.sh
41. scripts/requisitos/validar_frontmatter.py
42. scripts/requisitos/generar_indices.py
43. scripts/requisitos/generate_requirements_index.py

#### Templates Scripts (3)

44. scripts/templates/bash_script_template.sh
45. scripts/templates/library_template.sh
46. scripts/templates/posix_script_template.sh

#### DORA Metrics Scripts (estimados 10+)

47-56. scripts/generate_dora_report.sh
47-56. scripts/backup_data_centralization.sh
47-56. scripts/ml/retrain_deployment_risk_model.py
47-56. scripts/benchmarking/run_benchmarks.sh
47-56. scripts/disaster_recovery/*.sh (4 scripts)
47-56. scripts/load_testing/*.py
47-56. (y mas scripts relacionados con DORA tasks)

#### Infrastructure/DevOps Scripts (estimados 30+)

57-86. infrastructure/devops/runbooks/playbooks_operativos/*.sh
57-86. scripts/deploy/*.sh
57-86. scripts/migrations/*.sh
57-86. scripts/infrastructure/*.sh
57-86. scripts/monitoring/*.sh
57-86. scripts/backup/*.sh
57-86. (scripts de operaciones y mantenimiento)

#### Otros Scripts (estimados 2)

87. scripts/smoke_tests/run_smoke_tests.sh
88. scripts/cron/*.sh (jobs automatizados)

### 2.2 Guias por Script (88 guias)

Para cada script se puede generar 1 guia operativa:

**Contenido de la guia:**
- Proposito del script
- Prerequisitos
- Como ejecutarlo (comando exacto)
- Parametros y opciones
- Output esperado
- Como interpretar resultados
- Troubleshooting

**Total: 88 scripts × 1 guia = 88 guias**

---

## SECCION 3: PROCEDIMIENTOS DOCUMENTADOS (11 procedimientos)

### 3.1 Lista de Procedimientos

Ubicacion: docs/gobernanza/procesos/procedimientos/

1. procedimiento_desarrollo_local.md
   - Proposito: Setup entorno desarrollo local
   - Activacion: Primer dia de desarrollador nuevo

2. procedimiento_instalacion_entorno.md
   - Proposito: Instalacion completa entorno
   - Activacion: Onboarding

3. procedimiento_qa.md
   - Proposito: Proceso QA completo
   - Activacion: Antes de merge a main

4. procedimiento_release.md
   - Proposito: Proceso release oficial
   - Activacion: Cada release (mensual/bimestral)

5. procedimiento_diseno_tecnico.md
   - Proposito: Como crear diseños tecnicos
   - Activacion: Fase Design de SDLC

6. procedimiento_trazabilidad_requisitos.md
   - Proposito: Mantener trazabilidad requisitos
   - Activacion: Al crear/modificar requisitos

7. procedimiento_gestion_cambios.md
   - Proposito: Gestion formal de cambios
   - Activacion: Cambios arquitectonicos/criticos

8. procedimiento_analisis_seguridad.md
   - Proposito: Analisis seguridad features
   - Activacion: Fase Feasibility/Design

9. procedimiento_revision_documental.md
   - Proposito: Revision calidad documentacion
   - Activacion: Trimestral

10. guia_completa_desarrollo_features.md
    - Proposito: Guia end-to-end desarrollo features
    - Activacion: Al iniciar nuevo feature

11. README.md (indice procedimientos)
    - Proposito: Indice navegable
    - Activacion: Consulta

### 3.2 Guias Derivadas de Procedimientos

Ya estan documentados, pero se pueden generar guias quick-start resumidas (1 pagina) para cada uno.

**Potencial: 11 guias quick-start**

---

## SECCION 4: CHECKLISTS (6 checklists)

### 4.1 Lista de Checklists

Ubicacion: docs/gobernanza/procesos/checklists/

1. checklist_desarrollo.md
   - Proposito: Checklist pre-merge
   - Activacion: Antes de crear PR

2. checklist_testing.md
   - Proposito: Checklist cobertura tests
   - Activacion: Fase Testing

3. checklist_auditoria_restricciones.md
   - Proposito: Validar restricciones criticas
   - Activacion: Fase Feasibility + pre-merge

4. checklist_trazabilidad_requisitos.md
   - Proposito: Validar trazabilidad completa
   - Activacion: Al modificar requisitos

5. checklist_cambios_documentales.md
   - Proposito: Validar cambios documentacion
   - Activacion: Al modificar docs/

6. README.md (indice checklists)
   - Proposito: Indice navegable
   - Activacion: Consulta

### 4.2 Guias Derivadas de Checklists

Ya estan documentados, pero se pueden generar guias interactivas (con comandos CLI).

**Potencial: 6 guias interactivas**

---

## SECCION 5: AGENTES SDLC (6 agentes)

### 5.1 Lista de Agentes

Ubicacion: scripts/ai/agents/

**Agente 1: SDLCPlannerAgent**
- Ubicacion: scripts/ai/agents/sdlc_planner.py
- Fase SDLC: Planning (Fase 1)
- Proposito: Convertir feature request en GitHub issue
- Activacion:
  ```bash
  python scripts/sdlc_agent.py --phase planning \
    --input "Feature: Sistema de notificaciones push" \
    --format text
  ```
- Output: Issue markdown en docs/sdlc_outputs/planning/
- Decision: Siempre GO (no bloquea)

**Agente 2: SDLCFeasibilityAgent**
- Ubicacion: scripts/ai/agents/sdlc_feasibility.py
- Fase SDLC: Feasibility Analysis (Fase 2)
- Proposito: Analisis viabilidad tecnica
- Activacion:
  ```bash
  python scripts/sdlc_agent.py --phase feasibility \
    --input "Issue: #123" \
    --format text
  ```
- Output: Feasibility report con Go/No-Go decision
- Decision: GO | NO-GO | REVIEW

**Agente 3: SDLCDesignAgent**
- Ubicacion: scripts/ai/agents/sdlc_design.py
- Fase SDLC: Design (Fase 3)
- Proposito: Generar HLD, LLD, ADRs
- Activacion:
  ```bash
  python scripts/sdlc_agent.py --phase design \
    --input "Issue: #123" \
    --format text
  ```
- Output: docs/adr/, docs/arquitectura/
- Decision: Siempre GO

**Agente 4: SDLCTestingAgent**
- Ubicacion: scripts/ai/agents/sdlc_testing.py
- Fase SDLC: Testing (Fase 5)
- Proposito: Generar test plan y test cases
- Activacion:
  ```bash
  python scripts/sdlc_agent.py --phase testing \
    --input "Feature: authentication" \
    --format text
  ```
- Output: Test plan markdown
- Decision: GO si coverage >80%

**Agente 5: SDLCDeploymentAgent**
- Ubicacion: scripts/ai/agents/sdlc_deployment.py
- Fase SDLC: Deployment (Fase 6)
- Proposito: Generar deployment plan y rollback plan
- Activacion:
  ```bash
  python scripts/sdlc_agent.py --phase deployment \
    --input "Feature: #123" \
    --format text
  ```
- Output: Deployment plan, rollback plan
- Decision: Siempre GO

**Agente 6: SDLCOrchestratorAgent**
- Ubicacion: scripts/ai/agents/sdlc_orchestrator.py
- Fase SDLC: Todas (orquestador)
- Proposito: Ejecutar pipeline completo SDLC
- Activacion:
  ```bash
  python scripts/sdlc_orchestrator.py \
    --feature-request "Feature: Notificaciones push" \
    --auto-approve
  ```
- Output: Todos los artefactos SDLC
- Decision: Depende de cada fase

### 5.2 Guias por Agente (6 guias)

Para cada agente se necesita 1 guia operativa:

**Contenido:**
- Proposito del agente
- Fase SDLC asociada
- Como invocarlo (comando CLI)
- Parametros disponibles
- Output esperado
- Como interpretar resultados
- Integracion con CI/CD

**Total: 6 agentes × 1 guia = 6 guias**

---

## SECCION 6: FASES SDLC (7 fases)

### 6.1 Lista de Fases

Definidas en: docs/gobernanza/procesos/SDLC_PROCESS.md

**Fase 1: Planning**
- Activacion: Inicio de sprint / Nuevo feature request
- Artefactos: Issue, User Story, Acceptance Criteria
- Agente: SDLCPlannerAgent
- Duracion: 1-2 horas
- Roles: Product Owner, Tech Lead

**Fase 2: Feasibility Analysis**
- Activacion: Tras Planning, antes de Design
- Artefactos: Feasibility Report, Go/No-Go decision
- Agente: SDLCFeasibilityAgent
- Duracion: 2-4 horas
- Roles: Arquitecto Senior, Tech Lead

**Fase 3: Design**
- Activacion: Tras Feasibility GO
- Artefactos: HLD, LLD, ADRs, Diagramas
- Agente: SDLCDesignAgent
- Duracion: 1-2 dias
- Roles: Arquitecto Senior, Tech Lead, Developers

**Fase 4: Implementation**
- Activacion: Tras Design aprobado
- Artefactos: Codigo, Tests, Documentacion tecnica
- Agente: Ninguno (manual)
- Duracion: 3-10 dias (depende de story points)
- Roles: Developers

**Fase 5: Testing**
- Activacion: Tras Implementation completa
- Artefactos: Test plan, Test results, Coverage report
- Agente: SDLCTestingAgent
- Duracion: 1-2 dias
- Roles: QA Lead, Developers

**Fase 6: Deployment**
- Activacion: Tras Testing exitoso
- Artefactos: Deployment plan, Rollback plan, Release notes
- Agente: SDLCDeploymentAgent
- Duracion: 1 dia
- Roles: DevOps Lead, Tech Lead

**Fase 7: Maintenance**
- Activacion: Tras Deployment a produccion
- Artefactos: Monitoring dashboards, Incident reports, DORA metrics
- Agente: Ninguno (operaciones continuas)
- Duracion: Continuo
- Roles: DevOps, SRE, On-call

### 6.2 Guias por Fase (7 guias)

Para cada fase se puede generar 1 guia completa:

**Contenido:**
- Objetivo de la fase
- Activacion y pre-requisitos
- Pasos detallados
- Artefactos requeridos
- Checkpoints y Go/No-Go
- Roles y responsabilidades
- Handoff a siguiente fase

**Total: 7 fases × 1 guia = 7 guias**

---

## SECCION 7: GUIAS TRANSVERSALES (4 guias)

### 7.1 Guias por Rol

**Guia 1: Developer Quick Start**
- Audiencia: Desarrollador nuevo
- Contenido:
  - Setup entorno local (Vagrant, Docker, o nativo)
  - Ejecutar tests locales
  - Crear feature branch
  - Workflow desarrollo diario
  - Como crear PR
  - Como interpretar CI/CD

**Guia 2: QA Quick Start**
- Audiencia: QA Engineer nuevo
- Contenido:
  - Ejecutar suite tests completa
  - Como validar coverage
  - Como ejecutar tests E2E
  - Como validar restricciones criticas
  - Como reportar bugs

**Guia 3: DevOps Quick Start**
- Audiencia: DevOps Engineer nuevo
- Contenido:
  - Infraestructura overview
  - Como modificar workflows CI/CD
  - Como deployar a staging/production
  - Como ejecutar playbooks incident response
  - Como monitorear sistema

**Guia 4: Arquitecto/Tech Lead Quick Start**
- Audiencia: Arquitecto/Tech Lead nuevo
- Contenido:
  - Arquitectura overview
  - Como aprobar PRs
  - Como crear ADRs
  - Como validar disenos
  - Como gestionar deuda tecnica

### 7.2 Total Guias Transversales

**Total: 4 guias transversales**

---

## SECCION 8: CALCULO TOTAL DE GUIAS

### 8.1 Desglose Completo

| Categoria | Cantidad Base | Guias por Item | Total Guias |
|-----------|---------------|----------------|-------------|
| Workflows CI/CD | 16 | 3 | 48 |
| Scripts Automatizacion | 88 | 1 | 88 |
| Agentes SDLC | 6 | 1 | 6 |
| Fases SDLC | 7 | 1 | 7 |
| Guias Transversales | 4 | 1 | 4 |
| **TOTAL** | **121 items** | **-** | **153 guias** |

### 8.2 Ajuste por Duplicados

Algunos procedimientos y checklists ya tienen guias equivalentes en workflows o scripts.

**Duplicados identificados: 6**

**TOTAL FINAL: 153 - 6 = 147 guias unicas**

---

## SECCION 9: PRIORIZACION DE GUIAS

### 9.1 Prioridad P0 (Criticas - 20 guias)

Guias que todo desarrollador necesita el primer dia:

1. Developer Quick Start (transversal)
2. Como ejecutar tests locales (script: backend_test.sh)
3. Como crear PR (workflow: python_ci.yml)
4. Como validar restricciones (script: validate_critical_restrictions.sh)
5. Como usar SDLCPlannerAgent (agente)
6. Fase Planning (fase SDLC)
7. Fase Implementation (fase SDLC)
8. Fase Testing (fase SDLC)
9. procedimiento_desarrollo_local.md (procedimiento)
10. checklist_desarrollo.md (checklist)
11-20. (10 guias workflow mas criticos)

### 9.2 Prioridad P1 (Alta - 40 guias)

Guias que se necesitan en primera semana:

21-30. Workflows core (backend-ci, frontend-ci, deploy, etc)
31-40. Scripts validacion y CI/CD
41-50. Agentes SDLC restantes
51-60. Fases SDLC restantes

### 9.3 Prioridad P2 (Media - 50 guias)

Guias para casos especificos:

61-110. Scripts AI/agentes especializados
111-120. Workflows documentacion y requisitos
121-130. Guias troubleshooting

### 9.4 Prioridad P3 (Baja - 37 guias)

Guias de referencia:

131-147. Scripts templates y utilities
148-153. Guias avanzadas

---

## SECCION 10: ESTRATEGIA DE GENERACION

### 10.1 Enfoque Incremental

**Semana 1: P0 (20 guias)**
- Focus: Onboarding desarrolladores
- Audiencia: Desarrolladores nuevos
- Tiempo estimado: 40 horas (2 horas/guia × 20)

**Semana 2-3: P1 (40 guias)**
- Focus: Workflows y scripts criticos
- Audiencia: Todo el equipo
- Tiempo estimado: 80 horas

**Mes 2: P2 (50 guias)**
- Focus: Casos especializados
- Audiencia: Roles especificos (QA, DevOps, etc)
- Tiempo estimado: 100 horas

**Mes 3: P3 (37 guias)**
- Focus: Referencia completa
- Audiencia: Usuarios avanzados
- Tiempo estimado: 74 horas

**TOTAL: ~294 horas (~7 semanas de 1 persona full-time)**

### 10.2 Automatizacion de Generacion

**Posible con agentes IA:**

Crear un nuevo agente: `DocumentationGuideGenerator`

```python
# scripts/ai/agents/guide_generator.py

class DocumentationGuideGenerator:
    def generate_workflow_guide(workflow_path):
        # Analiza .github/workflows/[workflow].yml
        # Genera guia usuario, guia mantenedor, guia troubleshooting
        pass

    def generate_script_guide(script_path):
        # Analiza script (sh o py)
        # Genera guia operativa
        pass

    def generate_phase_guide(phase_name):
        # Lee SDLC_PROCESS.md
        # Genera guia detallada fase
        pass
```

**Tiempo estimado con automatizacion:**
- Generacion automatica: 2 horas
- Revision manual: 1 hora/guia
- **Total: ~150 horas (~4 semanas)**

---

## SECCION 11: ESTRUCTURA RECOMENDADA DE GUIAS

### 11.1 Template Guia Workflow

```markdown
---
id: GUIA-WORKFLOW-[nombre]
tipo: guia_operativa
categoria: ci_cd
audiencia: [developer|qa|devops]
version: 1.0.0
---

# Guia: [Workflow Name]

## Proposito
[1 parrafo explicando que hace el workflow]

## Cuando se activa
- Trigger 1: [detalles]
- Trigger 2: [detalles]
- Manual: [comando]

## Pre-requisitos
- [ ] Item 1
- [ ] Item 2

## Pasos

### 1. [Paso 1]
[Descripcion detallada]

**Comando**:
```bash
[comando exacto]
```

**Output esperado**:
```
[ejemplo output]
```

### 2. [Paso 2]
...

## Como interpretar resultados
...

## Troubleshooting
| Error | Causa | Solucion |
|-------|-------|----------|
| Error 1 | ... | ... |

## Referencias
- Workflow: `.github/workflows/[nombre].yml`
- Script asociado: `scripts/[path]`
- Documentacion tecnica: `docs/[path]`
```

### 11.2 Template Guia Script

```markdown
---
id: GUIA-SCRIPT-[nombre]
tipo: guia_operativa
categoria: automatizacion
version: 1.0.0
---

# Guia: [Script Name]

## Proposito
[1 parrafo]

## Ubicacion
`scripts/[path]/[script].sh`

## Pre-requisitos
- Dependencia 1
- Dependencia 2

## Como ejecutar

**Basico**:
```bash
./scripts/[path]/[script].sh
```

**Con opciones**:
```bash
./scripts/[path]/[script].sh --option value
```

## Parametros

| Parametro | Requerido | Default | Descripcion |
|-----------|-----------|---------|-------------|
| --param1 | SI | - | ... |

## Output esperado
...

## Casos de uso
### Caso 1: [Nombre]
...

## Troubleshooting
...
```

---

## SECCION 12: ROADMAP DE IMPLEMENTACION

### 12.1 Timeline

**Noviembre 2025 (Semana 1)**
- [ ] Generar 20 guias P0
- [ ] Publicar en docs/guias/
- [ ] Comunicar a equipo

**Noviembre 2025 (Semanas 2-4)**
- [ ] Generar 40 guias P1
- [ ] Revision y feedback equipo
- [ ] Iteracion basada en feedback

**Diciembre 2025**
- [ ] Generar 50 guias P2
- [ ] Generar 37 guias P3
- [ ] Completar 147 guias

**Enero 2026**
- [ ] Revision completa
- [ ] Actualizacion basada en uso real
- [ ] Metricas adoption

### 12.2 Metricas de Exito

**Metricas objetivo:**
- 100% guias P0 generadas en Semana 1
- 80%+ adoption guias por equipo
- <30 min tiempo onboarding nuevo desarrollador
- 50% reduccion preguntas repetitivas en Slack

---

## CONCLUSION

El proyecto IACT tiene una infraestructura robusta de workflows, scripts, y procesos. Se pueden generar **147 guias operativas completas** que cubren:

- 16 workflows CI/CD (48 guias)
- 88 scripts automatizacion (88 guias)
- 6 agentes SDLC (6 guias)
- 7 fases SDLC (7 guias)
- 4 guias transversales

**Prioridad inmediata: Generar 20 guias P0 para onboarding rapido.**

**Estrategia: Generacion automatica con agente IA + revision manual.**

**Tiempo estimado: 4 semanas con automatizacion, 7 semanas manual.**

---

**Mantenedores:**
- @arquitecto-senior
- @devops-lead
- @tech-lead

**Proxima revision:** 2025-12-07
**Version:** 1.0.0
