---
id: DOC-GOB-WORKFLOW-AGENTES-DORA
tipo: proceso
categoria: gobernanza
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: arquitecto-senior
relacionados: ["AGENTES_SDLC.md", "FASES_IMPLEMENTACION_IA.md", "DORA_SDLC_INTEGRATION_GUIDE.md", "constitution.md"]
date: 2025-11-13
---

# Workflow de Agentes con Integracion DORA

Proceso completo para usar agentes SDLC con rastreo automatico de metricas DORA
y ciclos PDCA de mejora continua.

**Version:** 1.0.0
**Basado en:** FASES_IMPLEMENTACION_IA.md, constitution.md, DORA Report 2025

---

## Vision General

Este documento define el workflow completo para:
1. Ejecutar agentes SDLC con rastreo DORA automatico
2. Medir performance en tiempo real
3. Aplicar ciclos PDCA para mejora continua
4. Escalar practicas exitosas a toda la organizacion

**Principios:**
- Rastreo automatico (sin overhead manual)
- Feedback rapido (< 5 min)
- Mejora continua (ciclos PDCA semanales)
- Transparencia total (metricas publicas)

---

## Workflow Principal: Feature Development

### Diagrama de Flujo

```
[1] Feature Request
       |
       v
[2] SDLC Pipeline INICIA
       |
       +-> DORAMetrics.start_cycle(feature_id, 'planning')
       |
       v
[3] Planning Agent
       |
       +-> [T1] Analizar requirement
       +-> [T2] Generar plan tecnico
       +-> [T3] Estimar story points
       |
       +-> DORAMetrics.record_phase('planning', decision, duration)
       |
       v
[4] Design Agent
       |
       +-> [T1] Disenar arquitectura
       +-> [T2] Validar con constraints
       +-> [T3] Generar diagramas
       |
       +-> DORAMetrics.record_phase('design', decision, duration)
       |
       v
[5] Implementation (Developer)
       |
       +-> [T1] Implementar codigo
       +-> [T2] Escribir tests
       +-> [T3] Code review local
       |
       v
[6] Testing Agent
       |
       +-> [T1] Ejecutar test suite
       +-> [T2] Validar coverage (>80%)
       +-> [T3] Security scan
       |
       +-> DORAMetrics.record_phase('testing', decision, duration, {
       |       'tests_passed': 95,
       |       'tests_failed': 5,
       |       'coverage': 92.5
       |   })
       |
       v
[7] Deployment Agent
       |
       +-> [T1] Build & package
       +-> [T2] Deploy to staging
       +-> [T3] Smoke tests
       +-> [T4] Deploy to production
       |
       +-> DORAMetrics.record_phase('deployment', decision, duration)
       |   (Calcula: Lead Time, Deployment Frequency)
       |
       v
[8] Monitoring (Automatico)
       |
       +-> [T1] Health checks (5 min intervals)
       +-> [T2] Error detection
       +-> [T3] Performance metrics
       |
       v
[9] SDLC Pipeline COMPLETA
       |
       +-> summary = DORAMetrics.complete_cycle('success')
       |
       v
[10] PDCA Agent ANALIZA (semanal)
       |
       +-> [PLAN] Analizar metricas baseline
       +-> [DO] Ejecutar mejoras propuestas
       +-> [CHECK] Validar metricas post-cambio
       +-> [ACT] APPLY, REVERT, CONTINUE o ESCALATE
       |
       v
[11] Metricas PUBLICADAS
       |
       +-> Dashboard Django Admin
       +-> .dora_sdlc_metrics.json
       +-> GitHub API sync (opcional)
```

---

## Fase 1: Inicio de Feature (Planning)

### 1.1. Input

**Feature Request:**
```json
{
  "feature_id": "FEAT-001",
  "title": "Implementar autenticacion 2FA",
  "description": "Los usuarios deben poder activar 2FA via TOTP...",
  "priority": "high",
  "story_points": 13,
  "assigned_to": "@developer1"
}
```

### 1.2. Ejecucion Planning Agent

```python
from agents.dora_sdlc_integration import DORATrackedSDLCAgent, DORAMetrics
from agents.sdlc_planner import SDLCPlannerAgent

# Crear instancia compartida de metricas DORA
dora_metrics = DORAMetrics()

# Planning Agent con rastreo DORA
planning_agent = SDLCPlannerAgent(
    config={'project_root': '.'},
    dora_metrics=dora_metrics
)

# Ejecutar planning
result = planning_agent.execute({
    'feature_id': 'FEAT-001',
    'feature_request': feature_request,
    'project_context': 'Django + PostgreSQL + Celery',
    'backlog': []
})

# Metricas registradas automaticamente:
# - phase: 'planning'
# - decision: result.phase_result.decision ('go', 'no-go', 'review')
# - duration: tiempo de ejecucion en segundos
# - timestamp: ISO 8601
```

**Output:**
- Artefacto: `docs/sdlc_outputs/planning/FEAT-001_plan.md`
- Decision: `'go'` (confidence: 0.9)
- Duration: 5.2 minutos

**DORA Registered:**
- Lead Time START: `2025-11-06T14:30:00Z`
- Phase: `planning`
- Cycle ID: `cycle-20251106-143000`

### 1.3. Validaciones Automaticas

El Planning Agent aplica constitution guardrails:

1. [x] Sin placeholders (TODO, FIXME)
2. [x] Plan completo y accionable
3. [x] Story points <= 13 (small batches)
4. [x] Risks identificados
5. [x] Next steps claros

Si alguna validacion falla: decision = `'no-go'` o `'review'`

---

## Fase 2: Diseno (Design)

### 2.1. Ejecucion Design Agent

```python
from agents.sdlc_design import SDLCDesignAgent

design_agent = SDLCDesignAgent(
    config={'project_root': '.'},
    dora_metrics=dora_metrics  # Misma instancia
)

result = design_agent.execute({
    'feature_id': 'FEAT-001',
    'plan': planning_result,
    'constraints': ['RNF-002: NO Redis', 'PostgreSQL only']
})
```

**Output:**
- Artefacto: `docs/sdlc_outputs/design/FEAT-001_design.md`
- Decision: `'go'` (confidence: 0.85)
- Duration: 8.7 minutos

**DORA Registered:**
- Phase: `design`
- Checkpoint: Lead Time intermediate
- Timestamp: `2025-11-06T14:38:42Z`

---

## Fase 3: Testing (QA)

### 3.1. Ejecucion Testing Agent

```python
from agents.test_runner import TestRunner

testing_agent = TestRunner(
    config={'coverage_threshold': 0.80},
    dora_metrics=dora_metrics
)

result = testing_agent.execute({
    'feature_id': 'FEAT-001',
    'test_paths': ['tests/test_2fa.py'],
    'coverage_target': 0.90
})
```

**Output:**
- Tests passed: 95
- Tests failed: 5
- Coverage: 92.5%
- Duration: 2.3 minutos

**DORA Registered:**
- Phase: `testing`
- Decision: `'go'` (tests mayormente exitosos)
- **Change Failure Rate:** `(5 / 100) * 100 = 5.0%`
- Metadata: `{'tests_passed': 95, 'tests_failed': 5, 'coverage': 92.5}`

**Validacion:**
- Si CFR > 15%: decision = `'no-go'` (demasiados fallos)
- Si CFR <= 15%: decision = `'go'`

---

## Fase 4: Deployment (CD)

### 4.1. Ejecucion Deployment Agent

```python
from agents.deployment_agent import DeploymentAgent

deployment_agent = DeploymentAgent(
    config={'environment': 'production'},
    dora_metrics=dora_metrics
)

result = deployment_agent.execute({
    'feature_id': 'FEAT-001',
    'version': '1.2.3',
    'rollback_commit': 'abc123'
})
```

**Output:**
- Build: SUCCESS
- Deploy staging: SUCCESS
- Smoke tests: PASSED
- Deploy production: SUCCESS
- Duration: 4.5 minutos

**DORA Calculated:**

1. **Lead Time for Changes:**
   - Start: `2025-11-06T14:30:00Z` (planning)
   - End: `2025-11-06T15:45:00Z` (deployment)
   - **Lead Time: 1.25 horas**

2. **Deployment Frequency:**
   - Ultimos 30 dias: 15 deployments
   - **DF: 0.50 deployments/day**

**Classification:**
- Lead Time: 1.25h -> [ELITE] (<= 1 dia)
- Deployment Frequency: 0.50/day -> [HIGH] (>= 1/semana)

---

## Fase 5: Monitoreo y Mantenimiento

### 5.1. Health Checks Automaticos

```bash
# Cron job cada 5 minutos
*/5 * * * * /app/scripts/health_check.sh
```

**Detecta:**
- Errores 5xx
- Latencia > 500ms
- CPU > 80%
- Memory > 90%

**Si incidente detectado:**
- Crea issue con label `incident`
- Notifica equipo (Slack/PagerDuty)
- Activa Maintenance Agent

### 5.2. Maintenance Agent (Incident Response)

```python
from agents.maintenance_agent import MaintenanceAgent

maintenance_agent = MaintenanceAgent(
    config={'auto_rollback': True},
    dora_metrics=dora_metrics
)

result = maintenance_agent.execute({
    'feature_id': 'FEAT-001',
    'incident': incident_data,
    'action': 'rollback'  # o 'fix', 'escalate'
})
```

**Output:**
- Rollback executed: SUCCESS
- Incident resolved: `2025-11-06T16:15:00Z`
- Incident created: `2025-11-06T16:00:00Z`
- **MTTR: 15 minutos**

**DORA Registered:**
- Phase: `maintenance`
- Decision: `'resolved'`
- **Mean Time to Recovery: 0.25 horas**

---

## Fase 6: Cierre de Ciclo DORA

### 6.1. Complete Cycle

```python
# Al final del pipeline SDLC
summary = dora_metrics.complete_cycle('success')

print(f"Cycle: {summary['cycle_id']}")
print(f"Feature: {summary['feature_id']}")
print(f"Duration: {summary['duration_hours']}h")
print(f"Lead Time: {summary['metrics']['lead_time']}h")
print(f"CFR: {summary['metrics']['change_failure_rate']}%")
```

**Output:**
```
Cycle: cycle-20251106-143000
Feature: FEAT-001
Duration: 1.25h
Lead Time: 1.25h
CFR: 5.0%
DF: 0.50/day
MTTR: 0.25h (si hubo incidente)
```

### 6.2. Persistencia

Metricas guardadas en:
```json
// .dora_sdlc_metrics.json
{
  "cycles": [
    {
      "cycle_id": "cycle-20251106-143000",
      "feature_id": "FEAT-001",
      "start_time": "2025-11-06T14:30:00Z",
      "end_time": "2025-11-06T15:45:00Z",
      "phases": [
        {"phase": "planning", "duration": 312.0, "decision": "go"},
        {"phase": "design", "duration": 522.0, "decision": "go"},
        {"phase": "testing", "duration": 138.0, "decision": "go"},
        {"phase": "deployment", "duration": 270.0, "decision": "go"}
      ],
      "metrics": {
        "lead_time": 1.25,
        "deployment_frequency": 0.50,
        "change_failure_rate": 5.0,
        "mttr": 0.25
      },
      "status": "completed"
    }
  ]
}
```

---

## Fase 7: Ciclo PDCA (Semanal)

### 7.1. PLAN - Analizar Baseline

```bash
# Ejecutar PDCA automation agent (viernes, final sprint)
python scripts/ai/agents/pdca_automation_agent.py \
  --repo 2-Coatl/IACT---project \
  --baseline-days 14
```

**Output PLAN:**
```
[PLAN] Analizando metricas actuales...
  Deployment Frequency: 0.50 deploys/dia
  Lead Time: 1.25 horas
  Change Failure Rate: 5.00%
  MTTR: 0.25 horas

[PLAN] 2 mejoras identificadas:
  [HIGH] deployment_frequency: Incrementar automatizacion CI/CD
    - Target: 0.65 deploys/dia (+30%)
    - AI Assistance: Auto-merge PRs >90% coverage, AI code review

  [MEDIUM] lead_time: Reducir tiempo commit -> produccion
    - Target: 0.90 horas (-28%)
    - AI Assistance: AI test generation, Automated PR descriptions
```

### 7.2. DO - Ejecutar Cambios

**Acciones automaticas:**
```python
# Activar AI auto-merge
enable_feature_flag('ai_auto_merge')

# Configurar AI code review
update_config('.github/workflows/pr-review.yml', {
    'ai_review_enabled': True,
    'ai_review_threshold': 0.90
})

# Deploy a staging
deploy_incremental(environment='staging', features=['ai_auto_merge'])
```

**Rollback point guardado:** `commit-abc123`

### 7.3. CHECK - Validar Metricas

**Esperar 48h para estabilizacion, luego medir:**

```bash
# Obtener metricas post-cambio
python scripts/ai/agents/pdca_automation_agent.py --check-last-cycle
```

**Output CHECK:**
```
[CHECK] Validando metricas (baseline vs post-change)...
  [OK] deployment_frequency: 0.50 -> 0.64 (+28.0%)
  [OK] lead_time: 1.25h -> 0.95h (-24.0%)
  [OK] change_failure_rate: 5.0% -> 4.2% (-16.0%)
  [OK] mttr: 0.25h -> 0.22h (-12.0%)

[CHECK] Score ponderado: +22.5% (umbral: 5.0%)
[CHECK] RESULTADO: PASADO
```

### 7.4. ACT - Decision

**Decision Automatica:**
- Score >= 15%: **APPLY** (auto-aplicar)
- Score >= 5% y < 15%: **CONTINUE** (monitorear 48h mas)
- Score < 5%: **ESCALATE** (revision manual)
- Score < -5%: **REVERT** (rollback automatico)

**Caso actual: +22.5% -> APPLY**

```
[ACT] Decision: APPLY
[ACT] Razon: Mejora significativa (+22.5% >= 15.0%)

[ACCION] Merge cambios a main branch
[ACCION] Deploy a produccion
[ACCION] Actualizar baseline metrics
[ACCION] Notificar equipo: Mejora validada
```

---

## Workflow Avanzado: Feature Flags + A/B Testing

### Comparacion A/B con IA

```python
from agents.ab_testing_agent import ABTestingAgent

ab_agent = ABTestingAgent(
    config={
        'variant_a': 'without_ai',
        'variant_b': 'with_ai_auto_merge',
        'split': 0.50,
        'duration_days': 7
    }
)

result = ab_agent.execute({
    'feature_ids': ['FEAT-001', 'FEAT-002', 'FEAT-003'],
    'hypothesis': 'AI auto-merge reduce Lead Time en 30%',
    'metrics': ['lead_time', 'change_failure_rate']
})
```

**Output:**
```
A/B Test Results (7 dias):
  Variant A (sin AI):
    - Lead Time: 1.30h
    - CFR: 6.5%

  Variant B (con AI):
    - Lead Time: 0.92h (-29.2%)
    - CFR: 5.1% (-21.5%)

  Statistical Significance: p < 0.05
  Decision: WINNER -> Variant B
  Recommendation: Deploy AI auto-merge to 100%
```

---

## Integration con GitHub API

### Sincronizacion Bidireccional

```python
from agents.dora_sdlc_integration import integrate_dora_with_github

# Combinar metricas locales + GitHub
combined = integrate_dora_with_github(
    repo='2-Coatl/IACT---project',
    github_token=os.getenv('GITHUB_TOKEN'),
    days=30
)

# Output combinado
print(combined['local_sdlc_metrics'])    # De .dora_sdlc_metrics.json
print(combined['github_metrics'])        # De GitHub API
print(combined['overall_classification']) # Elite, High, Medium, Low
```

**Ventajas:**
- Metricas locales: Precision fase-a-fase
- Metricas GitHub: Cobertura completa (commits, PRs, issues)
- Combinadas: Visibilidad 360 grados

---

## Dashboards y Visualizacion

### CLI (Rapido)

```bash
# Ver metricas locales
python scripts/ai/agents/dora_sdlc_integration.py

# Ver metricas GitHub
python scripts/dora_metrics.py --days 30 --format markdown > report.md

# Ver historial PDCA
python scripts/ai/agents/pdca_automation_agent.py --show-history
```

### Django Admin (Production)

**Proxima implementacion (P2 - 5 SP):**
- Dashboard: `/admin/dora/metrics/`
- Graficos: Deployment Frequency, Lead Time, CFR, MTTR
- Tablas: Ultimos 30 ciclos
- Filtros: Por feature, por developer, por sprint

---

## Escalamiento Organizacional (Fase 6)

### Onboarding Automation

**Para nuevo equipo/proyecto:**

```bash
# Onboarding automation agent
python scripts/ai/agents/onboarding_agent.py \
  --team "Team Backend" \
  --project "Microservicio Pagos" \
  --template "django-microservice"
```

**Acciones automaticas:**
1. Crear repo desde template
2. Configurar CI/CD workflows
3. Setup DORA tracking (.dora_sdlc_metrics.json)
4. Configurar CODEOWNERS
5. Activar pre-commit hooks
6. Deploy sandbox environment
7. Generar docs/README.md
8. Crear primer issue "Setup validado"

**Tiempo:** < 15 minutos

---

## Mejores Practicas

### 1. Compartir DORAMetrics entre agentes

```python
# BIEN - instancia compartida
dora_metrics = DORAMetrics()
planning = PlanningAgent(dora_metrics=dora_metrics)
design = DesignAgent(dora_metrics=dora_metrics)
testing = TestingAgent(dora_metrics=dora_metrics)

# MAL - instancias separadas (no conectadas)
planning = PlanningAgent(dora_metrics=DORAMetrics())
design = DesignAgent(dora_metrics=DORAMetrics())
```

### 2. Feature ID en todos los inputs

```python
# BIEN - feature_id presente
input_data = {
    'feature_id': 'FEAT-001',
    'feature_request': '...'
}

# MAL - sin identificador
input_data = {'feature_request': '...'}
```

### 3. Metadata rica en Testing

```python
# BIEN - metadata completa
metadata = {
    'tests_passed': 95,
    'tests_failed': 5,
    'coverage': 92.5,
    'duration': 138.0,
    'test_suites': ['unit', 'integration', 'e2e']
}

# MAL - metadata minima
metadata = {'tests_passed': 95, 'tests_failed': 5}
```

### 4. Completar ciclo siempre

```python
try:
    # Ejecutar pipeline completo
    result = pipeline.execute(input_data)

    # Completar ciclo
    summary = dora_metrics.complete_cycle('success')

except Exception as e:
    # Completar ciclo incluso si falla
    summary = dora_metrics.complete_cycle('failed')
    raise
```

### 5. PDCA semanal (no diario)

```bash
# BIEN - viernes final de sprint
0 17 * * 5 python scripts/ai/agents/pdca_automation_agent.py

# MAL - diario (no hay tiempo para estabilizacion)
0 2 * * * python scripts/ai/agents/pdca_automation_agent.py
```

---

## Troubleshooting

### Error: "No hay ciclo activo"

**Causa:** `start_cycle()` no llamado antes de `record_phase()`

**Solucion:**
```python
# Asegurar que planning agent inicia ciclo
if not dora_metrics.current_cycle:
    dora_metrics.start_cycle(feature_id, 'planning')
```

### Metricas siempre en cero

**Causa:** Fases no registradas

**Solucion:** Verificar que cada agente llama `record_phase()` al completar

### PDCA siempre ESCALATE

**Causa:** Validation threshold muy alto

**Solucion:**
```python
# Reducir threshold de 10% a 5%
pdca = PDCAAutomationAgent(
    validation_threshold=0.05  # 5% minimo
)
```

---

## Referencias

**Codigo:**
- `scripts/ai/agents/dora_sdlc_integration.py`
- `scripts/ai/agents/pdca_automation_agent.py`
- `scripts/ai/agents/sdlc_base.py`
- `scripts/dora_metrics.py`

**Documentacion:**
- `docs/gobernanza/ai/FASES_IMPLEMENTACION_IA.md`
- `docs/gobernanza/ai/DORA_SDLC_INTEGRATION_GUIDE.md`
- `docs/gobernanza/ai/ESTRATEGIA_IA.md`
- `docs/gobernanza/procesos/agentes/constitution.md`
- `docs/gobernanza/procesos/AGENTES_SDLC.md`

**DORA Research:**
- [DORA Report 2025](https://dora.dev/)
- [DORA Metrics Guide](https://dora.dev/guides/)

---

**VERSION:** 1.0.0
**ULTIMA ACTUALIZACION:** 2025-11-06
**PROXIMA REVISION:** 2025-11-20 (post Sprint 1 validacion)
**ESTADO:** DOCUMENTACION COMPLETA, PROCESO OPERACIONAL
