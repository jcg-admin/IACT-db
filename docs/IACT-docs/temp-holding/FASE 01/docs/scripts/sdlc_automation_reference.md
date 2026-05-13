---
title: Referencia Completa de Agentes SDLC
date: 2025-11-13
domain: general
status: active
---

# Referencia Completa de Agentes SDLC

Documentacion de todos los agentes AI del sistema SDLC del proyecto IACT.

## Tabla de Contenidos

- [Introduccion](#introduccion)
- [Agentes Core SDLC](#agentes-core-sdlc)
- [Agentes de Business Analysis](#agentes-de-business-analysis)
- [Agentes de Documentacion](#agentes-de-documentacion)
- [Agentes de Validacion](#agentes-de-validacion)
- [Agentes de Testing](#agentes-de-testing)
- [Agentes Utilitarios](#agentes-utilitarios)
- [Integracion Entre Agentes](#integracion-entre-agentes)

## Introduccion

El proyecto IACT incluye 20+ agentes AI especializados que automatizan diferentes fases del ciclo SDLC.

**Ubicacion:** `/home/user/IACT---project/scripts/ai/agents/`

**Arquitectura Base:** Todos los agentes heredan de `SDLCAgent` (definido en `sdlc_base.py`)

## Agentes Core SDLC

### SDLCOrchestratorAgent

**Archivo:** `sdlc_orchestrator.py`

**Proposito:** Orquestar todo el pipeline SDLC de punta a punta.

**Inputs:**
- `feature_request`: Descripcion del feature
- `project_context`: Contexto del proyecto
- `start_phase`: Fase inicial (default: "planning")
- `end_phase`: Fase final (default: "deployment")

**Outputs:**
- Reporte de ejecucion completo
- Artefactos de todas las fases
- Recomendacion final Go/No-Go
- Lessons learned

**Uso:**
```python
from agents.sdlc_orchestrator import SDLCOrchestratorAgent

orchestrator = SDLCOrchestratorAgent(config)
result = orchestrator.execute({
    "feature_request": "Implementar sistema de notificaciones",
    "start_phase": "planning",
    "end_phase": "deployment"
})
```

**Dependencias:**
- SDLCPlannerAgent
- TDDFeatureAgent (implementation)
- SDLCFeasibilityAgent
- SDLCDesignAgent
- SDLCTestingAgent
- SDLCDeploymentAgent

---

### SDLCPlannerAgent

**Archivo:** `sdlc_planner.py`

**Proposito:** Convertir feature requests en issues estructurados.

**Inputs:**
- `feature_request`: Descripcion del feature
- `project_context`: Contexto del proyecto (opcional)
- `backlog`: Backlog actual (opcional)

**Outputs:**
- Issue title
- User story completa
- Acceptance criteria
- Story points estimation
- Priority recommendation
- Technical requirements

**Uso:**
```bash
python scripts/sdlc_agent.py --phase planning --input "Feature: OAuth2 authentication"
```

**Artefactos generados:**
```
docs/sdlc_outputs/planning/
└── issue-XXX.md
```

**Ejemplo de output:**
```markdown
# Feature: Implementar autenticacion OAuth2

## User Story
Como usuario registrado
Quiero poder iniciar sesion usando mi cuenta de Google
Para no tener que recordar otra contrasena

## Acceptance Criteria
- [ ] Usuario puede iniciar sesion con Google OAuth2
- [ ] Usuario puede iniciar sesion con GitHub OAuth2
- [ ] Sistema maneja tokens de refresh correctamente
- [ ] Usuario puede desconectar cuentas OAuth
- [ ] Sistema registra automaticamente nuevos usuarios

## Story Points: 8
## Priority: P1
## Labels: feature, auth, oauth
```

---

### TDDFeatureAgent

**Archivo:** `tdd_feature_agent.py`

**Propósito:** Implementar features siguiendo metodología TDD (Test-Driven Development) con garantías de calidad y compliance.

**Inputs:**
- `issue_title`: Título del feature
- `acceptance_criteria`: Lista de criterios de aceptación
- `technical_requirements`: Requerimientos técnicos
- `target_module`: Módulo donde implementar

**Outputs:**
- Archivos de tests (unit, integration)
- Archivos de código fuente
- Execution log (JSON)
- Markdown report
- Dashboard visual con badges
- Constitution compliance result

**Proceso TDD:**
1. **RED Phase**: Genera tests unitarios que deben fallar
2. **GREEN Phase**: Implementa código para pasar tests
3. **REFACTOR Phase**: Optimiza código manteniendo tests verdes
4. **VALIDATION**: Valida constitution compliance
5. **REPORTING**: Genera reportes y dashboards

**Constitution Checks:**
- ✓ `RED_BEFORE_GREEN` (CRITICAL): Tests antes del código
- ✓ `TESTS_MUST_FAIL_FIRST` (CRITICAL): Tests fallan en RED
- ✓ `ALL_TESTS_MUST_PASS` (CRITICAL): Tests pasan en GREEN
- ✓ `TESTS_STAY_GREEN_AFTER_REFACTOR` (CRITICAL): Tests siguen pasando
- ✓ `MINIMUM_COVERAGE` (HIGH): Cobertura ≥ 90%
- ✓ `NO_SECURITY_ISSUES` (HIGH): Sin vulnerabilidades
- ✓ `CODE_QUALITY_PASSING` (MEDIUM): Linting y types
- ✓ `DOCUMENTATION_REQUIRED` (MEDIUM): Docstrings

**Uso:**
```bash
# Preparar issue data
cat > issue_data.json << EOF
{
  "issue_title": "Implement user authentication",
  "acceptance_criteria": [
    "Users can register with email",
    "Users can login with credentials"
  ],
  "technical_requirements": [
    "Use Django authentication",
    "Minimum 90% test coverage"
  ],
  "target_module": "apps.users"
}
EOF

# Ejecutar TDD agent
python scripts/sdlc_agent.py \
  --phase implementation \
  --issue-file issue_data.json \
  --verbose
```

**Artefactos generados:**
```
docs/sdlc_outputs/tdd_logs/
├── tdd_execution_<feature>_<timestamp>.json
├── tdd_execution_<feature>_<timestamp>.md
└── dashboard_<feature>.md
```

**Compliance Score:**
- 100: Perfect compliance
- 90-99: Excellent (COMPLIANT)
- 75-89: Good (COMPLIANT con warnings)
- <75: NOT COMPLIANT (agente falla)

**Herramientas QA Integradas:**
- `pytest + coverage`: Test execution y cobertura
- `ruff`: Code linting
- `mypy`: Type checking
- `bandit`: Security scanning
- AST parser: Docstring validation

**Ver también:**
- [TDD Feature Agent - Guía Técnica](../gobernanza/agentes/tdd-feature-agent.md) - Documentación técnica completa
- [Workflow - Implement Feature with TDD](../guias/workflows/workflow-implement-feature-with-tdd-agent.md) - Guía de uso paso a paso

---

### SDLCFeasibilityAgent

**Archivo:** `sdlc_feasibility.py`

**Proposito:** Analizar viabilidad tecnica y de negocio.

**Inputs:**
- `issue`: Issue generado por SDLCPlannerAgent
- `project_context`: Contexto del proyecto
- `technical_constraints`: Restricciones tecnicas (RNF-002, etc)

**Outputs:**
- Feasibility report completo
- Risk assessment matrix
- Go/No-Go recommendation
- Alternative approaches

**Uso:**
```python
from agents.sdlc_feasibility import SDLCFeasibilityAgent

agent = SDLCFeasibilityAgent(config)
result = agent.execute({
    "issue": planning_result["issue"],
    "technical_constraints": {"no_redis": True, "no_email": True}
})
```

**Decision Types:**
- `GO`: Feature es viable, proceder
- `NO-GO`: Feature no es viable, hay blockers criticos
- `REQUIRES_APPROVAL`: Feature tiene riesgos, requiere aprobacion

---

### SDLCDesignAgent

**Archivo:** `sdlc_design.py`

**Proposito:** Generar diseño tecnico completo (HLD, LLD, ADRs, diagramas).

**Inputs:**
- `issue`: Issue del planning
- `feasibility_result`: Resultado de feasibility
- `project_context`: Contexto del proyecto

**Outputs:**
- High-Level Design (HLD)
- Low-Level Design (LLD)
- Architecture Decision Records (ADRs)
- Diagramas (C4, sequence, ER)
- API contracts
- Data models

**Uso:**
```bash
python scripts/sdlc_agent.py --phase design --input "Feature: API de reportes"
```

**Artefactos generados:**
```
docs/sdlc_outputs/design/
├── HLD_feature_name.md
├── LLD_feature_name.md
├── ADR_001_decision_title.md
├── diagrams/
│   ├── c4_context.puml
│   ├── sequence_flow.puml
│   └── er_database.puml
└── api_contracts/
    └── api_spec.yaml
```

---

### SDLCTestingAgent

**Archivo:** `sdlc_testing.py`

**Proposito:** Generar estrategia de testing y test cases.

**Inputs:**
- `issue`: Issue del planning
- `design_result`: Resultado del design
- `implementation_status`: Estado de implementacion

**Outputs:**
- Test strategy
- Test pyramid breakdown (60% unit, 30% integration, 10% E2E)
- Unit test cases
- Integration test cases
- E2E test cases
- Coverage targets

**Uso:**
```bash
python scripts/sdlc_agent.py --phase testing --input "Feature: Payment processing"
```

**Ejemplo de output:**
```markdown
# Test Strategy: Payment Processing

## Test Pyramid
- Unit Tests: 27 cases (60%)
- Integration Tests: 13 cases (29%)
- E2E Tests: 5 cases (11%)
Total: 45 tests

## Coverage Target: 85%

## Unit Tests
- test_calculate_payment_amount()
- test_validate_card_number()
- test_process_refund()
...

## Integration Tests
- test_payment_gateway_integration()
- test_database_transaction_rollback()
...

## E2E Tests
- test_complete_payment_flow_success()
- test_payment_failure_handling()
...
```

---

### SDLCDeploymentAgent

**Archivo:** `sdlc_deployment.py`

**Proposito:** Generar plan de deployment y rollback.

**Inputs:**
- `issue`: Issue del planning
- `design_result`: Resultado del design
- `testing_result`: Resultado del testing
- `environment`: staging o production

**Outputs:**
- Deployment plan
- Rollback plan
- Pre-deployment checklist
- Post-deployment checklist
- Smoke tests

**Uso:**
```bash
python scripts/sdlc_agent.py --phase deployment --input "Feature: New API endpoint"
```

**Artefactos generados:**
```
docs/sdlc_outputs/deployment/
├── deployment_plan.md
├── rollback_plan.md
├── pre_deployment_checklist.md
├── post_deployment_checklist.md
└── smoke_tests.md
```

---

## Agentes de Business Analysis

### BusinessAnalysisGenerator

**Archivo:** `business_analysis_generator.py`

**Proposito:** Generar analisis de negocio completo.

**Inputs:**
- `business_requirement`: Requisito de negocio
- `stakeholders`: Lista de stakeholders
- `success_metrics`: Metricas de exito

**Outputs:**
- Business case
- ROI analysis
- Stakeholder analysis
- Success metrics

**Uso:**
```bash
python scripts/generate_business_analysis.py --input "Requirement: Loyalty program"
```

---

### BusinessAnalysisPipeline

**Archivo:** `business_analysis_pipeline.py`

**Proposito:** Pipeline completo de analisis de negocio.

**Flujo:**
1. Analisis de stakeholders
2. Analisis de requisitos
3. Business case
4. ROI calculation
5. Risk assessment

---

## Agentes de Documentacion

### DocumentationSyncAgent

**Archivo:** `documentation_sync_agent.py`

**Proposito:** Sincronizar documentacion entre diferentes ubicaciones.

**Uso:**
```bash
python scripts/sync_documentation.py
```

**Funcionalidades:**
- Detecta duplicados
- Sincroniza contenido
- Valida links
- Genera indices

---

### TraceabilityMatrixGenerator

**Archivo:** `traceability_matrix_generator.py`

**Proposito:** Generar matriz de trazabilidad de requisitos.

**Outputs:**
- Matriz requisitos → features
- Matriz features → tests
- Matriz tests → deployment

**Uso:**
```python
from agents.traceability_matrix_generator import TraceabilityMatrixGenerator

generator = TraceabilityMatrixGenerator()
matrix = generator.generate()
```

---

### TemplateGenerator

**Archivo:** `template_generator.py`

**Proposito:** Generar templates de documentacion.

**Templates disponibles:**
- Issue template
- ADR template
- Test case template
- Deployment plan template

---

## Agentes de Validacion

### CompletenessValidator

**Archivo:** `completeness_validator.py`

**Proposito:** Validar completitud de documentacion.

**Validaciones:**
- Frontmatter presente
- Secciones requeridas presentes
- Links validos
- Formato correcto

---

### SyntaxValidator

**Archivo:** `syntax_validator.py`

**Proposito:** Validar sintaxis de documentos (Markdown, YAML).

**Uso:**
```python
from agents.syntax_validator import SyntaxValidator

validator = SyntaxValidator()
errors = validator.validate_file("docs/requisitos/rf-001.md")
```

---

### CoverageAnalyzer

**Archivo:** `coverage_analyzer.py`

**Proposito:** Analizar cobertura de tests.

**Metricas:**
- Coverage percentage
- Coverage por modulo
- Uncovered lines
- Branch coverage

---

### CoverageVerifier

**Archivo:** `coverage_verifier.py`

**Proposito:** Verificar que coverage cumple targets.

**Uso:**
```bash
python scripts/ai/agents/coverage_verifier.py --target 80
```

---

## Agentes de Testing

### TestRunner

**Archivo:** `test_runner.py`

**Proposito:** Ejecutar tests automaticamente.

**Funcionalidades:**
- Ejecuta pytest
- Genera reportes
- Valida test pyramid
- Calcula coverage

---

### TestGenerationOrchestrator

**Archivo:** `test_generation_orchestrator.py` (en scripts/ai/)

**Proposito:** Orquestar generacion automatica de tests.

**Uso:**
```bash
./scripts/ai/run_test_generation.sh
```

---

## Agentes Utilitarios

### ConstitutionLoader

**Archivo:** `constitution_loader.py`

**Proposito:** Cargar y parsear Constitution del proyecto.

**Uso:**
```python
from agents.constitution_loader import ConstitutionLoader

loader = ConstitutionLoader()
constitution = loader.load()
```

**Valida:**
- Restricciones criticas (RNF-002)
- Valores del proyecto
- Reglas de gobernanza

---

### DocumentSplitter

**Archivo:** `document_splitter.py`

**Proposito:** Dividir documentos grandes en chunks para LLMs.

**Uso:**
```python
from agents.document_splitter import DocumentSplitter

splitter = DocumentSplitter(max_tokens=4000)
chunks = splitter.split(large_document)
```

---

### LLMGenerator

**Archivo:** `llm_generator.py`

**Proposito:** Wrapper para llamadas a LLMs (Claude, GPT).

**Providers soportados:**
- Anthropic Claude
- OpenAI GPT

**Uso:**
```python
from agents.llm_generator import LLMGenerator

generator = LLMGenerator(provider="anthropic")
response = generator.generate(prompt, model="claude-3-5-sonnet-20241022")
```

---

### PRCreator

**Archivo:** `pr_creator.py`

**Proposito:** Crear Pull Requests automaticamente.

**Uso:**
```python
from agents.pr_creator import PRCreator

creator = PRCreator()
pr_url = creator.create_pr(
    title="Feature: New API endpoint",
    body="...",
    branch="feature/api-endpoint"
)
```

---

### PDCAAutomationAgent

**Archivo:** `pdca_automation_agent.py`

**Proposito:** Automatizar ciclo PDCA (Plan-Do-Check-Act).

**Fases:**
1. Plan: Planificar mejora
2. Do: Implementar
3. Check: Verificar resultados
4. Act: Actuar sobre resultados

**Uso:**
```bash
python scripts/ai/agents/pdca_automation_agent.py --phase plan
```

---

### DORASDLCIntegration

**Archivo:** `dora_sdlc_integration.py`

**Proposito:** Integrar DORA metrics con SDLC pipeline.

**Metricas trackeadas:**
- Lead time (Planning → Deployment)
- Deployment frequency
- Change failure rate
- MTTR

**Uso:**
```bash
python scripts/ai/agents/dora_sdlc_integration.py --feature-id 123
```

---

## Integracion Entre Agentes

### Pipeline Completo

```
Feature Request
      ↓
SDLCPlannerAgent → Issue
      ↓
SDLCFeasibilityAgent → Feasibility Report
      ↓
SDLCDesignAgent → HLD + LLD + ADRs
      ↓
[Manual Implementation]
      ↓
SDLCTestingAgent → Test Strategy
      ↓
SDLCDeploymentAgent → Deployment Plan
      ↓
DORASDLCIntegration → Metrics
```

### Flujo de Datos

```python
# 1. Planning
planner = SDLCPlannerAgent(config)
planning_result = planner.execute({"feature_request": "..."})

# 2. Feasibility
feasibility = SDLCFeasibilityAgent(config)
feasibility_result = feasibility.execute({
    "issue": planning_result.data["issue"],
    "technical_constraints": {"no_redis": True}
})

# 3. Design
design = SDLCDesignAgent(config)
design_result = design.execute({
    "issue": planning_result.data["issue"],
    "feasibility_result": feasibility_result.data
})

# 4. Testing
testing = SDLCTestingAgent(config)
testing_result = testing.execute({
    "issue": planning_result.data["issue"],
    "design_result": design_result.data
})

# 5. Deployment
deployment = SDLCDeploymentAgent(config)
deployment_result = deployment.execute({
    "issue": planning_result.data["issue"],
    "testing_result": testing_result.data,
    "environment": "staging"
})
```

### Orquestacion Automatica

```python
# O usar orchestrator para todo automaticamente
orchestrator = SDLCOrchestratorAgent(config)
result = orchestrator.execute({
    "feature_request": "Implementar sistema de notificaciones",
    "start_phase": "planning",
    "end_phase": "deployment"
})
```

## Mejores Practicas

1. **Usar el orchestrator para pipelines completos:**
   - Para features complejos, ejecutar fase por fase
   - Revisar outputs antes de continuar

2. **Validar inputs:**
   - Todos los agentes validan inputs automaticamente
   - Revisar errores de validacion antes de ejecutar

3. **Guardar artefactos:**
   - Todos los agentes guardan en `docs/sdlc_outputs/`
   - Commitear artefactos generados

4. **Usar Constitution:**
   - Todos los agentes cargan Constitution automaticamente
   - Asegura compliance con restricciones criticas

5. **Integrar con CI/CD:**
   - Ejecutar agentes en GitHub Actions
   - Automatizar generacion de artefactos

## Testing de Agentes

### Test Suites Disponibles

```bash
# Test Planning Agent
python scripts/ai/agents/test_planner.py

# Test Business Analysis
python scripts/ai/agents/test_business_analysis_agents.py

# Test Constitution Integration
python scripts/ai/agents/test_constitution_integration.py
```

## Referencias

- **Arquitectura:** `scripts/ai/agents/ARCHITECTURE_SDLC_AGENTS.md`
- **README SDLC:** `scripts/ai/agents/README_SDLC_AGENTS.md`
- **README Business Analysis:** `scripts/ai/agents/README_BUSINESS_ANALYSIS.md`
- **README Doc Sync:** `scripts/ai/agents/README_DOCUMENTATION_SYNC.md`

---

**Ultima actualizacion:** 2025-11-07
**Version:** 1.0
**Mantenedores:** @tech-lead, @ai-lead
