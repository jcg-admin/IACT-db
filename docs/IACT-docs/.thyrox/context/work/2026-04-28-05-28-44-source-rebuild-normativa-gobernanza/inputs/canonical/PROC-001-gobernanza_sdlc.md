---
id: PROC-AI-001
tipo: proceso
categoria: desarrollo
subcategoria: agentes-sdlc
estado: activo
version: 1.0.0
fecha_creacion: 2025-11-13
autor: equipo-ai
relacionados: ["PROC-001", "PROC-002"]
---

# Agentes SDLC - Documentacion Completa

Sistema multi-agente para automatizar el proceso SDLC completo.

## Indice

1. [Arquitectura de Agentes](#arquitectura-de-agentes)
2. [Agentes Implementados](#agentes-implementados)
3. [Uso y Ejemplos](#uso-y-ejemplos)
4. [Pipeline Completo](#pipeline-completo)
5. [Restricciones IACT](#restricciones-iact)

---

## Arquitectura de Agentes

### Ubicacion

```
scripts/ai/agents/
  sdlc_base.py           - Clases base (SDLCAgent, SDLCPhaseResult, SDLCPipeline)
  sdlc_planner.py        - Phase 1: Planning
  sdlc_feasibility.py    - Phase 2: Feasibility Analysis
  sdlc_design.py         - Phase 3: System Design
  sdlc_testing.py        - Phase 5: Testing
  sdlc_deployment.py     - Phase 6: Deployment
  sdlc_orchestrator.py   - Pipeline orchestrator
```

### Patron de Diseno

**Pipeline Pattern con Go/No-Go Decisions**

```
Planning → Feasibility → Design → Implementation → Testing → Deployment
           ↓ NO-GO
           STOP
```

Cada fase puede retornar:
- **GO**: Continuar a siguiente fase
- **NO-GO**: Detener pipeline, resolver blockers
- **REVIEW**: Requiere revision manual

### Flujo de Datos

```
Input: Feature Request (str)
  ↓
Planning Agent → Issue (dict)
  ↓
Feasibility Agent → Feasibility Report (dict)
  ↓ (if GO)
Design Agent → HLD, LLD, ADRs (dict)
  ↓
[Manual Implementation]
  ↓
Testing Agent → Test Plan, Test Cases (dict)
  ↓
Deployment Agent → Deployment Plan, Rollback Plan (dict)
```

---

## Agentes Implementados

### 1. SDLCPlannerAgent

**Fase**: Planning (Fase 1)

**Responsabilidad**: Convertir feature request en GitHub issue estructurado

**Input**:
```python
{
    "feature_request": str,          # Descripcion del feature
    "project_context": str,          # Contexto del proyecto (opcional)
    "backlog": list                  # Backlog existente (opcional)
}
```

**Output**:
```python
{
    "issue": {
        "issue_title": str,          # Titulo del issue
        "issue_body": str,           # Cuerpo completo (markdown)
        "user_story": str,           # User story formato: As/Want/So
        "acceptance_criteria": list, # Criteria verificables
        "technical_requirements": list,
        "story_points": int,         # Fibonacci: 1,2,3,5,8,13
        "priority": str,             # P0, P1, P2, P3
        "labels": list,              # ['feature', 'backend', etc]
        "assignees": list
    },
    "issue_path": str,               # Path del archivo generado
    "phase_result": SDLCPhaseResult  # decision="go"
}
```

**Artefactos Generados**:
- `docs/sdlc_outputs/planning/ISSUE_YYYYMMDD_HHMMSS.md`

**Ejemplo Uso**:
```bash
python scripts/sdlc_agent.py \
    --phase planning \
    --input "Implementar dark mode toggle en settings"
```

**Caracteristicas**:
- Estimacion automatica (story points Fibonacci)
- Priorizacion automatica (P0-P3)
- Analisis de backlog para evitar duplicados
- Formato GitHub issue completo

---

### 2. SDLCFeasibilityAgent

**Fase**: Feasibility Analysis (Fase 2)

**Responsabilidad**: Analizar viabilidad tecnica y Go/No-Go decision

**Input**:
```python
{
    "issue": dict,                      # Output de SDLCPlannerAgent
    "project_context": str,
    "technical_constraints": {
        "no_redis": True,                # RNF-002
        "no_email": True,
        "budget": float,
        "deadline": str
    }
}
```

**Output**:
```python
{
    "feasibility_report": str,          # Reporte completo (markdown)
    "decision": str,                    # "go", "no-go", "review"
    "confidence": float,                # 0.0 - 1.0
    "risks": [
        {
            "description": str,
            "severity": str,             # "low", "medium", "high", "critical"
            "probability": str,          # "low", "medium", "high"
            "impact": str,
            "mitigation": str
        }
    ],
    "technical_feasibility": dict,
    "effort_analysis": {
        "story_points": int,
        "estimated_hours": int,
        "estimated_days": int
    },
    "report_path": str,
    "phase_result": SDLCPhaseResult
}
```

**Artefactos Generados**:
- `docs/sdlc_outputs/feasibility/FEASIBILITY_REPORT_YYYYMMDD_HHMMSS.md`

**Go/No-Go Criteria**:
- **NO-GO** si:
  - Viola RNF-002 (Redis, Email)
  - Blockers criticos sin mitigacion
  - Esfuerzo > 3x estimado
- **REVIEW** si:
  - Riesgos HIGH no mitigados
  - Dependencias externas complejas
- **GO** si:
  - Tecnicamente viable
  - Riesgos mitigables
  - Dentro de budget/timeline

**Ejemplo Uso**:
```bash
python scripts/sdlc_agent.py \
    --phase feasibility \
    --input-file docs/sdlc_outputs/planning/ISSUE_20251106_150610.md
```

**Caracteristicas**:
- Risk assessment matrix (Severity x Probability)
- Validacion restricciones IACT automatica
- Conversion story points → horas/dias
- Analisis de dependencias

---

### 3. SDLCDesignAgent

**Fase**: System Design (Fase 3)

**Responsabilidad**: Generar HLD, LLD, ADRs, diagramas

**Input**:
```python
{
    "issue": dict,                   # Output de SDLCPlannerAgent
    "feasibility_result": dict,      # Output de SDLCFeasibilityAgent
    "project_context": str
}
```

**Output**:
```python
{
    "hld": str,                      # High-Level Design (markdown)
    "hld_path": str,
    "lld": str,                      # Low-Level Design (markdown)
    "lld_path": str,
    "adrs": [str],                   # Architecture Decision Records
    "diagrams": {
        "architecture": str,         # Mermaid diagram
        "sequence": str,
        "components": str,
        "database": str              # ER diagram
    },
    "diagrams_path": str,
    "review_checklist": str,
    "review_path": str,
    "artifacts": list,
    "phase_result": SDLCPhaseResult
}
```

**Artefactos Generados**:
- `HLD_YYYYMMDD_HHMMSS.md` - High-Level Design
- `LLD_YYYYMMDD_HHMMSS.md` - Low-Level Design
- `ADR_YYYYMMDD_HHMMSS_001.md` - ADRs individuales
- `DIAGRAMS_YYYYMMDD_HHMMSS.md` - Todos los diagramas Mermaid
- `DESIGN_REVIEW_CHECKLIST_YYYYMMDD_HHMMSS.md`

**HLD Incluye**:
- Executive Summary
- System Context
- High-Level Architecture
- Technology Stack
- Critical Constraints (IACT)
- Non-Functional Requirements
- Risk Mitigation
- Design Decisions
- Success Metrics

**LLD Incluye**:
- Module Breakdown
- Database Schema (SQL)
- API Endpoints (RESTful)
- Data Models (Python code)
- Business Logic (Python code)
- Frontend Components
- State Management
- Validation Rules
- Error Handling
- Testing Strategy
- Deployment Notes

**ADRs**:
- Decisiones arquitectonicas significativas
- Formato: Context, Decision, Rationale, Consequences
- Ejemplo: "Usar MySQL para sesiones (RNF-002)"

**Diagramas Mermaid**:
- Architecture (system overview)
- Sequence (user flows)
- Components (module relationships)
- Database ER (entity-relationship)

**Ejemplo Uso**:
```bash
python scripts/sdlc_agent.py \
    --phase design \
    --input-file docs/sdlc_outputs/feasibility/FEASIBILITY_REPORT_20251106_151030.md
```

**Caracteristicas**:
- Genera codigo de ejemplo (models, views, services)
- Diagramas Mermaid auto-generados
- ADRs para decisiones criticas
- Design review checklist completo

---

### 4. SDLCTestingAgent

**Fase**: Testing (Fase 5)

**Responsabilidad**: Generar test plan, test cases, test pyramid strategy

**Input**:
```python
{
    "issue": dict,
    "design_result": dict,           # Output de SDLCDesignAgent
    "implementation_status": str     # "pending", "in_progress", "completed"
}
```

**Output**:
```python
{
    "test_plan": str,                # Test plan completo (markdown)
    "test_plan_path": str,
    "test_cases": [
        {
            "id": str,                # "UT-001", "IT-001", "E2E-001"
            "type": str,              # "unit", "integration", "e2e"
            "name": str,
            "description": str,
            "preconditions": str,
            "steps": list,
            "expected_result": str,
            "priority": str           # "high", "medium", "low"
        }
    ],
    "test_cases_path": str,
    "test_pyramid": {
        "total_tests": int,
        "unit_tests": {
            "count": int,
            "percentage": float,
            "target": 60,
            "status": str             # "on_target", "needs_more"
        },
        "integration_tests": {...},
        "e2e_tests": {...}
    },
    "test_pyramid_path": str,
    "coverage_requirements": {
        "overall_target": 80,         # Porcentaje
        "critical_paths": 100,
        "models": 90,
        "services": 85,
        "views": 80
    },
    "testing_checklist": str,
    "checklist_path": str,
    "artifacts": list,
    "phase_result": SDLCPhaseResult
}
```

**Artefactos Generados**:
- `TEST_PLAN_YYYYMMDD_HHMMSS.md`
- `TEST_CASES_YYYYMMDD_HHMMSS.md`
- `TEST_PYRAMID_YYYYMMDD_HHMMSS.md`
- `TEST_CHECKLIST_YYYYMMDD_HHMMSS.md`

**Test Plan Incluye**:
- Testing Goals & Success Criteria
- Scope (In/Out)
- Test Strategy (Test Pyramid)
- Test Environment
- Entry/Exit Criteria
- Test Data
- Risks and Mitigation
- Schedule
- Deliverables

**Test Cases**:
- Unit tests (60%): Models, services, utilities
- Integration tests (30%): API endpoints, database
- E2E tests (10%): Critical user flows

**Test Pyramid Validation**:
- Unit >= 50% (target 60%)
- Integration 20-40% (target 30%)
- E2E <= 20% (target 10%)

**Ejemplo Uso**:
```bash
python scripts/sdlc_agent.py \
    --phase testing \
    --input-file docs/sdlc_outputs/design/HLD_20251106_151530.md
```

**Caracteristicas**:
- Genera test cases concretos con steps
- Validacion test pyramid automatica
- Coverage requirements por componente
- Testing checklist ejecutable

---

### 5. SDLCDeploymentAgent

**Fase**: Deployment (Fase 6)

**Responsabilidad**: Generar deployment plan, rollback plan, monitoring

**Input**:
```python
{
    "issue": dict,
    "design_result": dict,
    "testing_result": dict,          # Output de SDLCTestingAgent
    "environment": str               # "staging", "production"
}
```

**Output**:
```python
{
    "deployment_plan": str,          # Deployment plan completo
    "deployment_path": str,
    "rollback_plan": str,
    "rollback_path": str,
    "pre_deployment_checklist": str,
    "pre_checklist_path": str,
    "post_deployment_checklist": str,
    "post_checklist_path": str,
    "monitoring_plan": str,
    "monitoring_path": str,
    "environment": str,
    "artifacts": list,
    "phase_result": SDLCPhaseResult
}
```

**Artefactos Generados**:
- `DEPLOYMENT_PLAN_{env}_YYYYMMDD_HHMMSS.md`
- `ROLLBACK_PLAN_{env}_YYYYMMDD_HHMMSS.md`
- `PRE_DEPLOYMENT_CHECKLIST_YYYYMMDD_HHMMSS.md`
- `POST_DEPLOYMENT_CHECKLIST_YYYYMMDD_HHMMSS.md`
- `MONITORING_PLAN_YYYYMMDD_HHMMSS.md`

**Deployment Plan Incluye**:
- Executive Summary (objective, window, stakeholders)
- Prerequisites (code ready, infrastructure ready, team ready)
- Database Changes (migrations, data migration)
- Deployment Steps (6 steps con comandos)
- Verification Steps
- Rollback Criteria
- Communication Plan
- Monitoring
- Success Criteria
- Post-deployment Tasks
- Contacts & Escalation Path

**Deployment Steps**:
1. Pre-deployment Validation
2. Create Backup (database + code tag)
3. Deploy Code
4. Run Migrations
5. Restart Services
6. Health Check
7. Smoke Tests

**Rollback Plan Incluye**:
- Rollback Decision (when, who)
- Rollback Steps (5 steps)
- Database Rollback Considerations
- Rollback Verification
- Post-rollback Actions
- Rollback Time Estimate
- Communication
- Prevention for Next Deployment

**Monitoring Plan**:
- Key Metrics (response time, error rate, CPU/memory)
- Monitoring Duration (2h intensive, 24h regular, 1 week follow-up)
- Monitoring Commands
- Alerting Thresholds
- Incident Response

**Ejemplo Uso**:
```bash
# Staging
python scripts/sdlc_agent.py \
    --phase deployment \
    --environment staging \
    --input-file docs/sdlc_outputs/testing/TEST_PLAN_20251106_152030.md

# Production
python scripts/sdlc_agent.py \
    --phase deployment \
    --environment production \
    --input-file docs/sdlc_outputs/testing/TEST_PLAN_20251106_152030.md
```

**Caracteristicas**:
- Blue-green deployment strategy
- Database backup automatico
- Health checks en cada paso
- Rollback plan ejecutable
- Post-deployment monitoring (5 min, 24h, 1 week)

---

### 6. SDLCOrchestratorAgent

**Responsabilidad**: Orquestar pipeline completo con Go/No-Go decisions

**Input**:
```python
{
    "feature_request": str,
    "project_context": str,
    "technical_constraints": dict,
    "start_phase": str,              # "planning", "feasibility", etc.
    "end_phase": str,                # "deployment"
    "skip_phases": list,             # ["implementation"]
    "environment": str               # "staging", "production"
}
```

**Output**:
```python
{
    "status": str,                   # "completed", "early_stop"
    "feature_request": str,
    "phase_results": {
        "planning": dict,
        "feasibility": dict,
        "design": dict,
        "testing": dict,
        "deployment": dict
    },
    "execution_log": [
        {
            "phase": str,
            "status": str,           # "completed", "manual", "failed"
            "decision": str          # "go", "no-go", "n/a"
        }
    ],
    "all_artifacts": list,           # Paths de todos los artefactos
    "final_report": str,
    "report_path": str
}
```

**Artefactos Generados**:
- `SDLC_PIPELINE_REPORT_YYYYMMDD_HHMMSS.md` - Reporte consolidado
- Todos los artefactos de cada fase

**Ejemplo Uso**:
```bash
# Pipeline completo
python scripts/sdlc_agent.py \
    --phase orchestration \
    --input "Implementar dark mode toggle en settings"

# Ejecutar solo design → testing
python scripts/sdlc_agent.py \
    --phase orchestration \
    --start-phase design \
    --end-phase testing \
    --input "Feature request"

# Skip implementation (manual)
python scripts/sdlc_agent.py \
    --phase orchestration \
    --skip-phases implementation \
    --input "Feature request"
```

**Caracteristicas**:
- Go/No-Go decisions entre fases
- Early stop si fase falla
- Reporte consolidado final
- Lessons learned automaticas
- Ejecucion parcial (start/end phase)

---

## Uso y Ejemplos

### CLI: scripts/sdlc_agent.py

```bash
# Ver ayuda
python scripts/sdlc_agent.py --help

# Ejecutar fase individual
python scripts/sdlc_agent.py \
    --phase planning \
    --input "Feature request description"

# Ejecutar con archivo
python scripts/sdlc_agent.py \
    --phase feasibility \
    --input-file docs/sdlc_outputs/planning/ISSUE_20251106_150610.md

# Output en JSON
python scripts/sdlc_agent.py \
    --phase design \
    --input-file ... \
    --format json

# Dry-run (no guarda archivos)
python scripts/sdlc_agent.py \
    --phase testing \
    --input-file ... \
    --dry-run

# Pipeline completo
python scripts/sdlc_agent.py \
    --phase orchestration \
    --input "Implementar export a Excel en reportes" \
    --environment staging
```

### Ejemplo Completo: Dark Mode Feature

#### Step 1: Planning

```bash
python scripts/sdlc_agent.py \
    --phase planning \
    --input "Implementar dark mode toggle en settings para mejorar UX"
```

Output:
- Issue: `docs/sdlc_outputs/planning/ISSUE_20251106_150610.md`
- Story points: 5
- Priority: P2

#### Step 2: Feasibility

```bash
python scripts/sdlc_agent.py \
    --phase feasibility \
    --input-file docs/sdlc_outputs/planning/ISSUE_20251106_150610.md
```

Output:
- Feasibility Report: `docs/sdlc_outputs/feasibility/FEASIBILITY_REPORT_20251106_151030.md`
- Decision: GO
- Confidence: 0.85
- Risks: 2 (LOW severity)

#### Step 3: Design

```bash
python scripts/sdlc_agent.py \
    --phase design \
    --input-file docs/sdlc_outputs/feasibility/FEASIBILITY_REPORT_20251106_151030.md
```

Output:
- HLD: `docs/sdlc_outputs/design/HLD_20251106_151530.md`
- LLD: `docs/sdlc_outputs/design/LLD_20251106_151530.md`
- Diagrams: `docs/sdlc_outputs/design/DIAGRAMS_20251106_151530.md`
- ADRs: 1 (Store theme preference in user settings)

#### Step 4: Implementation

Manual - Developer implements following LLD

#### Step 5: Testing

```bash
python scripts/sdlc_agent.py \
    --phase testing \
    --input-file docs/sdlc_outputs/design/HLD_20251106_151530.md
```

Output:
- Test Plan: `docs/sdlc_outputs/testing/TEST_PLAN_20251106_152030.md`
- Test Cases: 15 total (9 unit, 4 integration, 2 E2E)
- Coverage requirement: 80%

#### Step 6: Deployment

```bash
python scripts/sdlc_agent.py \
    --phase deployment \
    --environment staging \
    --input-file docs/sdlc_outputs/testing/TEST_PLAN_20251106_152030.md
```

Output:
- Deployment Plan: `docs/sdlc_outputs/deployment/DEPLOYMENT_PLAN_staging_20251106_152530.md`
- Rollback Plan: `docs/sdlc_outputs/deployment/ROLLBACK_PLAN_staging_20251106_152530.md`

---

## Pipeline Completo

### Pipeline Automatico

```bash
python scripts/sdlc_agent.py \
    --phase orchestration \
    --input "Feature request" \
    --environment staging
```

Output:
- SDLC_PIPELINE_REPORT_YYYYMMDD_HHMMSS.md
- Todos los artefactos de todas las fases

### Early Stop Example

Si Feasibility retorna NO-GO:

```
Planning → Feasibility (NO-GO: Redis required) → STOP

Pipeline stopped at feasibility phase.
Reason: Feature requires Redis (prohibited by RNF-002)

Recommendations:
1. Review feasibility report for blockers
2. Redesign to use MySQL only
3. Re-run pipeline after fixes
```

---

## Restricciones IACT

Todos los agentes validan restricciones IACT automaticamente:

### RNF-002: NO Redis

**Validacion en SDLCFeasibilityAgent**:

```python
def _analyze_technical_feasibility(self, issue, constraints):
    requirements = " ".join(issue.get("technical_requirements", [])).lower()

    if constraints.get("no_redis") and "redis" in requirements:
        feasibility["blockers"].append("BLOCKER: Redis prohibited (RNF-002)")
        feasibility["is_feasible"] = False

    return feasibility
```

**Result**: Decision = NO-GO si detecta Redis

### Sesiones en MySQL

**ADR Automatico en SDLCDesignAgent**:

```python
if self._has_session_requirement(technical_requirements):
    adr = self._create_adr(
        title="Almacenamiento de Sesiones en MySQL",
        decision="Usar django.contrib.sessions.backends.db",
        rationale=[
            "RNF-002: Redis prohibido",
            "MySQL ya disponible",
            "Cumple performance requirements"
        ]
    )
    adrs.append(adr)
```

### NO Email

**Validacion en todos los agentes**:
- Detecta send_mail, EmailMessage en requirements
- Recomienda InternalMessage alternativa
- Genera codigo usando InternalMessage

### NO Emojis

**Output format**:
- [OK] = Success
- [FAIL] = Error
- [WARNING] = Warning
- [INFO] = Info

Todos los artefactos generados son texto ASCII puro.

---

## Referencias

- SDLC Process: docs/gobernanza/procesos/SDLC_PROCESS.md
- DevOps Automation: docs/gobernanza/procesos/DEVOPS_AUTOMATION.md
- Base Classes: scripts/ai/agents/sdlc_base.py
- CLI: scripts/sdlc_agent.py
- RNF-002: docs/backend/requisitos/restricciones_y_lineamientos.md

---

**Version**: 1.0
**Fecha**: 2025-11-06
**Autor**: SDLCOrchestratorAgent
