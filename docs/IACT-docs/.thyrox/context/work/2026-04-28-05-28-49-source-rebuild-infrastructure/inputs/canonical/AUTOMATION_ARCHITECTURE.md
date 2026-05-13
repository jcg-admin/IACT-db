---
title: Agents Architecture - Sistema Automatizacion
issue_number: IACT-AUTO-001
date: 2025-11-13
fase: implementation
subfase: agents_design
proyecto: IACT---project
parent_doc: DEPLOYMENT_PLAN.md
status: in_progress
version: 1.0
---

# Agents Architecture: Sistema Automatizacion Hibrido

**Issue**: IACT-AUTO-001
**Fecha**: 2025-11-13
**Approach**: TDD + Auto-CoT + Self-Consistency

---

## 1. Arquitectura Hibrida: Bash + Python

### 1.1 Rational (Self-Consistency Analysis)

**Pregunta**: Por que arquitectura hibrida Bash/Python?

**Analisis Multiple Perspectivas**:

**Perspectiva 1 - Performance**:
- Bash: Rapido para operaciones Git, filesystem
- Python: Mejor para logica compleja, validaciones inteligentes
- Conclusion: Bash entry points, Python business logic

**Perspectiva 2 - Integracion Git Hooks**:
- Git hooks esperan scripts ejecutables simples
- Bash ideal para entry points
- Python agentes como workers
- Conclusion: Bash wrappers necesarios

**Perspectiva 3 - Mantenibilidad**:
- Bash: Mas dificil debug, testing
- Python: Testeable, modular, type hints
- Conclusion: Minimo codigo Bash, maximo Python

**Perspectiva 4 - Proyecto Existente**:
- IACT tiene 40+ scripts Bash existentes
- Ya hay agentes Python en scripts/coding/ai/
- Conclusion: Hibrido mantiene consistencia

**Self-Consistency Verdict**: TODAS las perspectivas convergen en arquitectura hibrida

---

## 2. Componentes Sistema (Auto-CoT Decomposition)

### 2.1 Capa 1: Bash Entry Points (YA IMPLEMENTADOS)

**Ubicacion**: `/scripts/`

| Script | Lineas | Funcion | Estado |
|--------|--------|---------|--------|
| constitucion.sh | 656 | Valida 6 reglas constitucion | COMPLETO |
| ci-local.sh | 945 | Orquesta pipeline CI local | COMPLETO |
| check_ui_api_coherence.sh | 75 | Detecta incoherencia UI/API | COMPLETO |
| validate_constitution_schema.sh | 130 | Valida .constitucion.yaml | COMPLETO |
| validate_devcontainer_env.sh | 180 | Valida entorno DevContainer | COMPLETO |
| install_hooks.sh | 87 | Instala Git hooks | EXISTENTE |

**Total**: 2073 lineas Bash

**Responsabilidades**:
- Entry points Git hooks
- Parseo argumentos CLI
- Invocacion agentes Python
- Agregacion resultados
- Exit codes

---

### 2.2 Capa 2: Python Agents (A IMPLEMENTAR)

**Ubicacion**: `/scripts/coding/ai/automation/`

#### 2.2.1 Core Automation Agents (6 agentes NUEVOS)

**1. ConstitutionValidatorAgent**
```python
# Location: scripts/coding/ai/automation/constitution_validator_agent.py
# Responsibility: Validacion inteligente reglas constitucion R1-R6
# Invoked by: constitucion.sh
```

**Funcionalidad**:
- Validacion R1: Branch protection (main/master)
- Validacion R2: Emoji detection con regex Unicode
- Validacion R3: UI/API coherence analysis (AST parsing)
- Validacion R4: Database router validation (Django settings analysis)
- Validacion R5: Test execution orchestration
- Validacion R6: DevContainer environment validation

**Input**: Mode (pre-commit, pre-push, etc.), changed files
**Output**: Validation results JSON, violations log

---

**2. CIPipelineOrchestratorAgent**
```python
# Location: scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py
# Responsibility: Orquestacion inteligente pipeline CI local
# Invoked by: ci-local.sh
```

**Funcionalidad**:
- Smart detection (git diff analysis, pattern matching)
- Parallel job execution (asyncio, subprocess management)
- Dependency resolution (stage dependencies)
- Result aggregation (JSON reports)
- Timeout handling
- Fail-fast logic

**Input**: .ci-local.yaml config, git context
**Output**: Pipeline results JSON, stage/job status

---

**3. CoherenceAnalyzerAgent**
```python
# Location: scripts/coding/ai/automation/coherence_analyzer_agent.py
# Responsibility: Analisis coherencia UI/API avanzado
# Invoked by: check_ui_api_coherence.sh
```

**Funcionalidad**:
- AST parsing API (views.py, serializers.py, urls.py)
- Detection endpoint changes (REST endpoints, GraphQL)
- AST parsing UI (services, components, tests)
- Correlation analysis (API endpoint → UI service → UI test)
- Gap detection (missing tests, missing services)
- Confidence scoring (0-100%)

**Input**: Git diff, base branch
**Output**: Coherence report JSON, gaps detected

---

**4. DevContainerValidatorAgent**
```python
# Location: scripts/coding/ai/automation/devcontainer_validator_agent.py
# Responsibility: Validacion completa entorno DevContainer
# Invoked by: validate_devcontainer_env.sh
```

**Funcionalidad**:
- Service health checks (PostgreSQL, MariaDB, Redis future)
- Version validation (Python 3.12.x, Node 18.x)
- Dependency verification (yq, jq, git, npm, pip)
- Port availability (5432, 3306, 8000, 3000)
- Volume mounts validation
- Environment variables verification
- devcontainer.json schema validation

**Input**: devcontainer.json, running containers
**Output**: Environment report JSON, validation status

---

**5. SchemaValidatorAgent**
```python
# Location: scripts/coding/ai/automation/schema_validator_agent.py
# Responsibility: Validacion schemas YAML/JSON (constitucion, ci-local)
# Invoked by: validate_constitution_schema.sh
```

**Funcionalidad**:
- YAML/JSON syntax validation
- JSON Schema validation (.constitucion.yaml, .ci-local.yaml)
- Reference validation (principle_id exists, job dependencies valid)
- Type checking (severity: error|warning)
- Default values injection
- Schema evolution detection

**Input**: YAML/JSON file, schema definition
**Output**: Validation report JSON, errors list

---

**6. MetricsCollectorAgent**
```python
# Location: scripts/coding/ai/automation/metrics_collector_agent.py
# Responsibility: Recoleccion metricas sistema automatizacion
# Invoked by: constitucion.sh --mode=report, ci-local.sh
```

**Funcionalidad**:
- Violations tracking (logs/constitucion_violations.log)
- CI pipeline metrics (duration, success rate)
- Coverage trends (history tracking)
- Developer compliance metrics
- Trend analysis (violations subiendo/bajando)
- Dashboard data generation

**Input**: Logs, historical data
**Output**: Metrics JSON, trends report

---

#### 2.2.2 Supporting Agents (Reuso de Existentes)

**7. ShellAnalysisAgent** (YA EXISTE)
```python
# Location: scripts/coding/ai/agents/quality/shell_analysis_agent.py
# Responsibility: Analisis calidad scripts Bash
# Usage: Analizar scripts constitucion.sh, ci-local.sh
```

**8. ShellRemediationAgent** (YA EXISTE)
```python
# Location: scripts/coding/ai/agents/quality/shell_remediation_agent.py
# Responsibility: Remediacion scripts Bash (shellcheck, optimizaciones)
# Usage: Refactoring scripts Bash
```

**9. TestingAgent** (YA EXISTE)
```python
# Location: scripts/coding/ai/sdlc/testing_agent.py
# Responsibility: Generacion tests (usado para tests agentes)
# Usage: Generar tests Python para agentes automation
```

**10. PDCAAgent** (YA EXISTE)
```python
# Location: scripts/coding/ai/automation/pdca_agent.py
# Responsibility: PDCA cycle (Plan-Do-Check-Act) para mejora continua
# Usage: Mejora continua sistema automatizacion
```

---

### 2.3 Total Agents Architecture

**NUEVOS a implementar**: 6 agentes
**EXISTENTES a reusar**: 4 agentes
**TOTAL**: 10 agentes

---

## 3. TDD Workflow para Agentes

### 3.1 Estructura Tests

```
tests/
├── ai/
│   └── automation/
│       ├── test_constitution_validator_agent.py    (NUEVO)
│       ├── test_ci_pipeline_orchestrator_agent.py  (NUEVO)
│       ├── test_coherence_analyzer_agent.py        (NUEVO)
│       ├── test_devcontainer_validator_agent.py    (NUEVO)
│       ├── test_schema_validator_agent.py          (NUEVO)
│       ├── test_metrics_collector_agent.py         (NUEVO)
│       └── fixtures/
│           ├── sample_constitucion.yaml
│           ├── sample_ci_local.yaml
│           ├── sample_git_diff.txt
│           └── sample_devcontainer.json
```

### 3.2 Test Coverage Targets

| Agente | Unit Tests | Integration Tests | E2E Tests | Target Coverage |
|--------|-----------|------------------|-----------|-----------------|
| ConstitutionValidatorAgent | 25 | 6 | 2 | 90% |
| CIPipelineOrchestratorAgent | 30 | 8 | 3 | 90% |
| CoherenceAnalyzerAgent | 20 | 5 | 2 | 85% |
| DevContainerValidatorAgent | 15 | 4 | 1 | 85% |
| SchemaValidatorAgent | 12 | 3 | 1 | 90% |
| MetricsCollectorAgent | 10 | 2 | 1 | 80% |

**Total Tests**: 112 unit + 28 integration + 10 E2E = **150 tests**

---

## 4. Implementation Order (Auto-CoT Dependencies)

### Fase 1: Foundation (Sem 1)
1. **SchemaValidatorAgent** (sin dependencias)
2. **DevContainerValidatorAgent** (depende de SchemaValidator)
3. **MetricsCollectorAgent** (sin dependencias)

### Fase 2: Core Logic (Sem 2)
4. **CoherenceAnalyzerAgent** (depende de SchemaValidator)
5. **ConstitutionValidatorAgent** (depende de CoherenceAnalyzer, DevContainerValidator, SchemaValidator)

### Fase 3: Orchestration (Sem 3)
6. **CIPipelineOrchestratorAgent** (depende de ConstitutionValidator, MetricsCollector)

### Fase 4: Integration (Sem 4)
- Integration tests todos agentes
- E2E tests workflow completo
- Performance optimization

---

## 5. Agent Base Class

### 5.1 BaseAutomationAgent

**Ubicacion**: `scripts/coding/ai/automation/base_automation_agent.py`

**Responsabilidades**:
- Logging estandarizado
- Configuration loading
- JSON reporting
- Error handling
- Metrics tracking

**Ya existe**: `scripts/coding/ai/sdlc/base_agent.py` (REUSAR)

---

## 6. Communication Protocol

### 6.1 Bash → Python

**Invocacion**:
```bash
# En constitucion.sh
python3 scripts/coding/ai/automation/constitution_validator_agent.py \
    --mode pre-push \
    --config .constitucion.yaml \
    --changed-files "$changed_files" \
    --output /tmp/constitution_report.json
```

**Exit codes**:
- 0: Success
- 1: Validation failed (blocking)
- 2: Warnings (non-blocking)
- 3: Configuration error

### 6.2 Python → Bash

**Output JSON**:
```json
{
  "status": "success|failure|warning",
  "violations": [
    {
      "rule_id": "R2_no_emojis_anywhere",
      "severity": "error",
      "file": "docs/test.md",
      "line": 42,
      "message": "Emoji detected: ✓"
    }
  ],
  "summary": {
    "rules_evaluated": 6,
    "rules_passed": 5,
    "rules_failed": 1,
    "blocking": true
  }
}
```

**Bash parseo**:
```bash
status=$(jq -r '.status' /tmp/constitution_report.json)
if [ "$status" = "failure" ]; then
    exit 1
fi
```

---

## 7. ADR Requirements

Para cada agente NUEVO, crear ADR:

**Template ADR**:
```markdown
docs/adr/ADR-XXX-{agent-name}.md

# ADR-XXX: {Agent Name}

Date: 2025-11-13
Status: Implemented
Decision Makers: DevOps Team

## Context
{Problem agent solves}

## Decision
{Why this agent approach}

## Consequences
Positive:
- {Benefits}

Negative:
- {Trade-offs}

## Implementation
{Key implementation details}

## Testing Strategy
{How agent is tested}
```

---

## 8. Documentation Requirements

### 8.1 Agent README

**Ubicacion**: `scripts/coding/ai/automation/README.md`

**Contenido**:
- Overview 6 agentes
- Architecture diagram
- Usage examples
- Configuration
- Troubleshooting

### 8.2 Integration Guide

**Ubicacion**: `docs/devops/automatizacion/INTEGRATION_GUIDE.md`

**Contenido**:
- Como Bash scripts invocan agentes
- Configuracion .constitucion.yaml
- Configuracion .ci-local.yaml
- Git hooks setup
- DevContainer integration

---

## 9. Metrics & Observability

### 9.1 Agent Metrics

Cada agente debe trackear:
- Execution time (ms)
- Success/failure rate
- Violations detected (por tipo)
- Resource usage (memory, CPU)

### 9.2 Dashboard

**Ubicacion futura**: `scripts/coding/ai/automation/dashboard/`

**Metricas a visualizar**:
- Violations trend (semana, mes)
- CI pipeline duration trend
- Coverage trend
- Agent performance

---

## 10. Resumen Ejecutivo

### 10.1 Arquitectura Final

```
Git Hooks (Bash Entry Points)
    ↓
Bash Scripts (constitucion.sh, ci-local.sh)
    ↓
Python Agents (6 NUEVOS + 4 EXISTENTES)
    ↓
Validation Logic, Metrics, Reports
    ↓
JSON Output → Bash → Exit Codes
```

### 10.2 Deliverables

**Codigo**:
- 6 agentes Python NUEVOS (automation/)
- 150 tests (unit + integration + E2E)
- 1 base class (BaseAutomationAgent)

**Documentacion**:
- 6 ADRs (1 por agente)
- 1 README automation/
- 1 INTEGRATION_GUIDE.md
- 1 AUTOMATION_ARCHITECTURE.md (este documento)

**Configuracion**:
- .constitucion.yaml (reglas)
- .ci-local.yaml (pipeline)
- pytest.ini (tests config)

**Estimado**:
- Codigo: 3000+ lineas Python
- Tests: 2000+ lineas Python
- Documentacion: 2000+ lineas Markdown
- Tiempo: 4 semanas (1 semana por fase)

---

## 11. Next Steps Inmediatos

**Orden ejecucion** (NO PARAR):

1. Commit este documento (AUTOMATION_ARCHITECTURE.md)
2. Crear estructura tests/ai/automation/
3. TDD RED: Implementar tests SchemaValidatorAgent
4. TDD GREEN: Implementar SchemaValidatorAgent
5. ADR: Documentar SchemaValidatorAgent
6. Repeat steps 3-5 para cada agente (orden dependencias)
7. Integration tests
8. E2E tests
9. Documentation completa
10. Validation final

**Status**: ARQUITECTURA COMPLETA, LISTO PARA IMPLEMENTACION

**Fecha**: 2025-11-13
**Metodologia**: Auto-CoT + Self-Consistency + TDD
**Autor**: SDLC Agent / DevOps Team
