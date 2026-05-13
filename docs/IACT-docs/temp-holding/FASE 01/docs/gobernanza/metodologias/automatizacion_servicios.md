---
id: DOC-DEV-AGENTES
tipo: documentacion
categoria: desarrollo
version: 2.0.0
fecha_creacion: 2025-11-04
fecha_actualizacion: 2025-11-17
propietario: equipo-desarrollo
relacionados: ["DOC-GOB-ESTANDARES", "DOC-SCRIPTS-VALIDACION", "RUNBOOK-GIT-MERGE-CLEANUP"]
---
# Agentes de Automatizacion - Proyecto IACT

## Proposito

Este documento documenta la arquitectura completa de agentes de automatizacion implementados en el proyecto IACT. El sistema incluye mas de 100 agentes especializados que automatizan el ciclo completo de desarrollo de software (SDLC).

**IMPORTANTE**: Todas las rutas en este documento son correctas y verificadas. Los agentes estan implementados en `scripts/coding/ai/`.

## Tabla de Contenidos

1. [Agentes de Claude Code](#agentes-de-claude-code)
2. [Inventario Completo de Agentes Implementados](#inventario-completo-de-agentes-implementados)
3. [Arquitectura de CI/CD](#arquitectura-de-cicd)
4. [Casos de Uso Practicos](#casos-de-uso-practicos)
5. [Mejores Practicas](#mejores-practicas)

## Arquitectura de Agentes Especializados

El proyecto IACT implementa el patron de **N agentes especializados**, donde cada agente tiene una unica responsabilidad (Single Responsibility Principle).

**Referencia**: Para detalles sobre la arquitectura correcta de agentes especializados vs monoliticos, consulta:
- [Arquitectura de Agentes Especializados](./arquitectura_servicios_especializados.md)

Diferencias clave:
- 1 agente monolitico a N agentes especializados
- Mejor mantenibilidad, testeabilidad y reusabilidad
- Single Responsibility Principle aplicado
- Orchestrator coordina agentes independientes

---

## Agentes de Claude Code

### 1. Agente Explore

**Tipo**: `subagent_type="Explore"`

**Cuando usarlo**: Exploracion rapida de codebases, busqueda de archivos y contenido

**Como funciona**:
```python
Task(
    description="Explorar estructura de codigo",
    prompt="Revisa el codigo en api/ y valida contra restricciones...",
    subagent_type="Explore"
)
```

**Herramientas que usa internamente**:
- `Glob` - Buscar archivos por patrones
- `Grep` - Buscar contenido en archivos
- `Read` - Leer archivos especificos
- `Bash` - Comandos de shell

**Caracteristicas**:
- Rapido para busquedas especificas
- Puede seguir multiples pistas
- Retorna contexto completo

### 2. Agente General Purpose

**Tipo**: `subagent_type="general-purpose"`

**Cuando usarlo**: Tareas complejas que requieren planificacion, ejecucion y verificacion

**Arquitectura del agente**:

```
┌─────────────────────────────────────────────────────────────┐
│                    AGENTE GENERAL PURPOSE                    │
├─────────────────────────────────────────────────────────────┤
│  1. PLANNER (Planificador)                                  │
│     - Analiza la tarea                                       │
│     - Decide estrategia de ejecucion                         │
│     - Prioriza subtareas                                     │
│                                                              │
│  2. EXECUTOR (Ejecutor)                                      │
│     - Ejecuta plan con herramientas apropiadas               │
│     - Adapta estrategia segun resultados                     │
│                                                              │
│  3. VERIFIER (Verificador)                                   │
│     - Valida resultados                                      │
│     - Reintenta si es necesario                              │
│                                                              │
│  4. REPORTER (Reportero)                                     │
│     - Genera reporte final                                   │
│     - Documenta proceso y resultados                         │
└─────────────────────────────────────────────────────────────┘
```

---

## Inventario Completo de Agentes Implementados

**Ubicacion base**: `scripts/coding/ai/`

**Total de archivos Python**: 150+ agentes especializados

### Categoria 1: Agentes SDLC (7 agentes)

Pipeline completo de desarrollo de software.

| Agente | Ubicacion | LLM | Descripcion |
|--------|-----------|-----|-------------|
| SDLCPlannerAgent | scripts/coding/ai/sdlc/planner_agent.py | SI | Genera user stories desde feature requests |
| SDLCFeasibilityAgent | scripts/coding/ai/sdlc/feasibility_agent.py | NO | Analiza viabilidad tecnica y de negocio |
| SDLCDesignAgent | scripts/coding/ai/sdlc/design_agent.py | NO | Genera documentos de diseno tecnico |
| SDLCTestingAgent | scripts/coding/ai/sdlc/testing_agent.py | NO | Orquesta testing (unit, integration, E2E) |
| SDLCDeploymentAgent | scripts/coding/ai/sdlc/deployment_agent.py | NO | Gestiona proceso de deployment |
| SDLCOrchestratorAgent | scripts/coding/ai/sdlc/orchestrator.py | SI | Coordina pipeline SDLC completo |
| PlanValidationAgent | scripts/coding/ai/sdlc/plan_validation_agent.py | NO | Valida planes de implementacion |

**Soporte**:
- Base: `scripts/coding/ai/sdlc/base_agent.py`
- SDLC Base: `scripts/coding/ai/sdlc/sdlc_base.py`
- Integracion DORA: `scripts/coding/ai/sdlc/dora_integration.py`

### Categoria 2: Agentes TDD (1 agente)

Implementacion automatizada siguiendo Test-Driven Development.

| Agente | Ubicacion | LLM | Descripcion |
|--------|-----------|-----|-------------|
| TDDFeatureAgent | scripts/coding/ai/tdd/feature_agent.py | SI | Implementa features con ciclo RED-GREEN-REFACTOR |

**Soporte**:
- Constitucion: `scripts/coding/ai/tdd/constitution.py`
- Logger: `scripts/coding/ai/tdd/execution_logger.py`
- Dashboard: `scripts/coding/ai/tdd/metrics_dashboard.py`

### Categoria 3: Agentes Base y Tecnicas de Prompting (12 archivos)

Tecnicas fundamentales de prompting e inferencia.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| Agent Base | scripts/coding/ai/agents/base.py | Clase base para agentes |
| ChainOfVerificationAgent | scripts/coding/ai/agents/base/chain_of_verification.py | Tecnica CoVe (Meta AI 2023) |
| AutoCoTAgent | scripts/coding/ai/agents/base/auto_cot_agent.py | Auto-CoT (Zhang 2022) |
| SelfConsistencyAgent | scripts/coding/ai/agents/base/self_consistency.py | Self-Consistency (Wang 2022) |
| TreeOfThoughtsAgent | scripts/coding/ai/agents/base/tree_of_thoughts.py | ToT (Yao 2023) |
| Fundamental Techniques | scripts/coding/ai/agents/base/fundamental_techniques.py | Zero-shot, Few-shot, CoT |
| Knowledge Techniques | scripts/coding/ai/agents/base/knowledge_techniques.py | RAG, Knowledge graphs |
| Optimization Techniques | scripts/coding/ai/agents/base/optimization_techniques.py | Optimizacion de prompts |
| Search Optimization | scripts/coding/ai/agents/base/search_optimization_techniques.py | Beam search, Best-first |
| Specialized Techniques | scripts/coding/ai/agents/base/specialized_techniques.py | Tecnicas especializadas |
| Structuring Techniques | scripts/coding/ai/agents/base/structuring_techniques.py | Estructuracion de outputs |
| Prompt Templates | scripts/coding/ai/agents/base/prompt_templates.py | Plantillas de prompts |

### Categoria 4: Agentes Meta (7 agentes)

Analisis arquitectonico y patrones de diseno.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| ArchitectureAnalysisAgent | scripts/coding/ai/agents/meta/architecture_analysis_agent.py | Analiza arquitectura del sistema |
| DesignPatternsAgent | scripts/coding/ai/agents/meta/design_patterns_agent.py | Detecta y sugiere patrones de diseno |
| DRFArchitectureAgent | scripts/coding/ai/agents/meta/drf_architecture_agent.py | Analisis especifico de Django REST Framework |
| RefactoringOpportunitiesAgent | scripts/coding/ai/agents/meta/refactoring_opportunities_agent.py | Identifica oportunidades de refactoring |
| UMLGeneratorAgent | scripts/coding/ai/agents/meta/uml_generator_agent.py | Genera diagramas UML |
| UMLValidationAgent | scripts/coding/ai/agents/meta/uml_validation_agent.py | Valida diagramas UML |
| Meta Pipeline | scripts/coding/ai/agents/meta/pipeline.py | Pipeline de analisis meta |

### Categoria 5: Agentes de Documentacion (3 agentes)

Analisis, validacion y sincronizacion de documentacion.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| DocumentationAnalysisAgent | scripts/coding/ai/agents/documentation/documentation_analysis_agent.py | Analisis de calidad documental (estructura, completitud, enlaces) |
| DocsStructureGate | scripts/coding/ai/agents/documentation/docs_structure_gate.py | Validacion de estructura documental |
| ETACodexAgent | scripts/coding/ai/agents/documentation/eta_codex_agent.py | Agente especializado en CODEX |

**Soporte adicional**:
- DocumentSplitter: `scripts/coding/ai/documentation/document_splitter.py`
- SyncAgent: `scripts/coding/ai/documentation/sync_agent.py`

### Categoria 6: Agentes de Seguridad (3 agentes)

Auditoria de seguridad y deteccion de amenazas.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| SecurityAuditAgent | scripts/coding/ai/agents/security/audit.py | Auditoria de seguridad estatica |
| HITLAgent | scripts/coding/ai/agents/security/hitl.py | Human-in-the-Loop para decisiones criticas |
| ThreatDetector | scripts/coding/ai/agents/security/threat_detector.py | Deteccion de amenazas de seguridad |

### Categoria 7: Agentes de Calidad (2 agentes)

Analisis y remediacion de calidad de codigo.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| ShellAnalysisAgent | scripts/coding/ai/agents/quality/shell_analysis_agent.py | Analiza scripts shell |
| ShellRemediationAgent | scripts/coding/ai/agents/quality/shell_remediation_agent.py | Remedia problemas en scripts shell |

**Validadores adicionales** (ubicados en `scripts/coding/ai/quality/`):
- CodeQualityValidator: `code_quality_validator.py`
- CompletenessValidator: `completeness_validator.py`
- CoverageAnalyzer: `coverage_analyzer.py`
- CoverageValidator: `coverage_validator.py`
- SyntaxValidator: `syntax_validator.py`

### Categoria 8: Agentes de Validacion (2 agentes)

Gates de validacion para restricciones del proyecto.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| RestrictionsGate | scripts/coding/ai/agents/validation/restrictions_gate.py | Valida restricciones criticas del proyecto |
| EmojiLintGate | scripts/coding/ai/agents/validation/emoji_lint_gate.py | Valida ausencia de emojis |

### Categoria 9: Agentes de Requisitos (3 agentes)

Gestion de requisitos y trazabilidad.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| GenerateRequirementsIndex | scripts/coding/ai/agents/requirements/generate_requirements_index.py | Genera indices de requisitos |
| GenerarIndices | scripts/coding/ai/agents/requirements/generar_indices.py | Generacion de indices ISO 29148 |
| ValidarFrontmatter | scripts/coding/ai/agents/requirements/validar_frontmatter.py | Valida metadatos YAML en requisitos |

### Categoria 10: Agentes de Database (1 agente)

Validacion de configuracion de base de datos.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| DBRouterGate | scripts/coding/ai/agents/database/db_router_gate.py | Valida database router |

### Categoria 11: Agentes de Permisos (2 agentes)

Analisis de permisos y autorizacion.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| PermissionsBase | scripts/coding/ai/agents/permissions/base.py | Base para analisis de permisos |
| RouteLinter | scripts/coding/ai/agents/permissions/route_linter.py | Lint de rutas y permisos |

### Categoria 12: Agentes de UX (3 agentes)

Garantias de experiencia de usuario para agentes IA.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| ConsistencyAgent | scripts/coding/ai/agents/ux/consistency.py | Valida consistencia de interfaz |
| ControlAgent | scripts/coding/ai/agents/ux/control.py | Valida control del usuario |
| TransparencyAgent | scripts/coding/ai/agents/ux/transparency.py | Valida transparencia de operaciones |

### Categoria 13: Agentes de Placement (14 componentes)

Sistema de placement inteligente para documentos.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| PlacementAgent | scripts/coding/ai/agents/placement_agent.py | Agente principal de placement |
| Classifier | scripts/coding/ai/agents/placement/classifier.py | Clasificador de documentos |
| CLI | scripts/coding/ai/agents/placement/cli.py | Interfaz de linea de comandos |
| ConfigLoader | scripts/coding/ai/agents/placement/config_loader.py | Cargador de configuracion |
| ContentAnalyzer | scripts/coding/ai/agents/placement/content_analyzer.py | Analiza contenido de documentos |
| Contexto | scripts/coding/ai/agents/placement/contexto.py | Analisis de contexto |
| Detector | scripts/coding/ai/agents/placement/detector.py | Deteccion de tipo de documento |
| Ejemplos | scripts/coding/ai/agents/placement/ejemplos.py | Ejemplos de placement |
| Frontmatter | scripts/coding/ai/agents/placement/frontmatter.py | Procesamiento de frontmatter |
| Naming | scripts/coding/ai/agents/placement/naming.py | Estrategias de nombrado |
| Ownership | scripts/coding/ai/agents/placement/ownership.py | Gestion de ownership |
| StructureDiscovery | scripts/coding/ai/agents/placement/structure_discovery.py | Descubrimiento de estructura |
| Temporalidad | scripts/coding/ai/agents/placement/temporalidad.py | Analisis temporal |
| Ubicacion | scripts/coding/ai/agents/placement/ubicacion.py | Determinacion de ubicacion |
| Validacion | scripts/coding/ai/agents/placement/validacion.py | Validacion de placement |

### Categoria 14: Agentes de Planning (5 componentes)

Planificacion y descomposicion de tareas.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| Decomposer | scripts/coding/ai/agents/planning/decomposer.py | Descompone tareas complejas |
| Iterative | scripts/coding/ai/agents/planning/iterative.py | Planificacion iterativa |
| Models | scripts/coding/ai/agents/planning/models.py | Modelos de datos de planificacion |
| Parser | scripts/coding/ai/agents/planning/parser.py | Parser de planes |
| Validators | scripts/coding/ai/agents/planning/validators.py | Validadores de planes |

### Categoria 15: Agentes de Protocolos (3 agentes)

Protocolos de comunicacion entre agentes.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| A2AProtocol | scripts/coding/ai/agents/protocols/a2a.py | Agent-to-Agent communication |
| MCPProtocol | scripts/coding/ai/agents/protocols/mcp.py | Model Context Protocol |
| NLWebProtocol | scripts/coding/ai/agents/protocols/nlweb.py | Natural Language Web protocol |

### Categoria 16: Agentes de Automatizacion (9 agentes)

Automatizacion de validaciones y metricas.

| Agente | Ubicacion | Descripcion |
|--------|-----------|-------------|
| BusinessRulesValidator | scripts/coding/ai/automation/business_rules_validator_agent.py | Valida reglas de negocio |
| CIPipelineOrchestrator | scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py | Orquesta pipeline CI/CD |
| CoherenceAnalyzer | scripts/coding/ai/automation/coherence_analyzer_agent.py | Analiza coherencia de sistema |
| ComplianceValidator | scripts/coding/ai/automation/compliance_validator_agent.py | Valida compliance |
| ConstitutionValidator | scripts/coding/ai/automation/constitution_validator_agent.py | Valida constitucion de agentes |
| DevcontainerValidator | scripts/coding/ai/automation/devcontainer_validator_agent.py | Valida devcontainer |
| MetricsCollector | scripts/coding/ai/automation/metrics_collector_agent.py | Colecta metricas |
| PDCAAgent | scripts/coding/ai/automation/pdca_agent.py | Metricas DORA con ciclo PDCA |
| SchemaValidator | scripts/coding/ai/automation/schema_validator_agent.py | Valida esquemas |

### Categoria 17: Generadores (4 componentes)

Generacion de codigo, documentacion y artefactos.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| BaseGenerator | scripts/coding/ai/generators/base.py | Clase base para generadores |
| LLMGenerator | scripts/coding/ai/generators/llm_generator.py | Generador con LLM (Anthropic/OpenAI) |
| TemplateGenerator | scripts/coding/ai/generators/template_generator.py | Generador basado en plantillas |
| TraceabilityMatrixGenerator | scripts/coding/ai/generators/traceability_matrix_generator.py | Genera matrices de trazabilidad |

**LLMGenerator - Integracion LLM Central**:
```python
from scripts.coding.ai.generators.llm_generator import LLMGenerator

llm = LLMGenerator(config={
    "llm_provider": "anthropic",  # o "openai"
    "model": "claude-sonnet-4-5-20250929"
})

response = llm._call_llm(prompt)
```

**Proveedores soportados**:
- Anthropic Claude (requiere ANTHROPIC_API_KEY)
- OpenAI GPT (requiere OPENAI_API_KEY)

### Categoria 18: Analisis de Negocio (2 componentes)

Generacion de analisis de negocio.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| Generator | scripts/coding/ai/business_analysis/generator.py | Genera documentos de negocio |
| Pipeline | scripts/coding/ai/business_analysis/pipeline.py | Pipeline de analisis de negocio |

### Categoria 19: Orquestadores (1 componente)

Orquestacion de workflows multi-agente.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| CodexMCPWorkflow | scripts/coding/ai/orchestrators/codex_mcp_workflow.py | Workflow builder para MCP |

### Categoria 20: Utilidades Compartidas (7 componentes)

Utilidades comunes para todos los agentes.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| AgentBase | scripts/coding/ai/shared/agent_base.py | Clase base abstracta para agentes |
| ConstitutionLoader | scripts/coding/ai/shared/constitution_loader.py | Carga constitucion de agentes |
| ContextSessions | scripts/coding/ai/shared/context_sessions.py | Gestion de sesiones de contexto |
| EnvLoader | scripts/coding/ai/shared/env_loader.py | Carga variables de entorno |
| EnvironmentConfig | scripts/coding/ai/shared/environment_config.py | Configuracion de entorno |
| LLMCostOptimizer | scripts/coding/ai/shared/llm_cost_optimizer.py | Optimizacion de costos LLM |
| PRCreator | scripts/coding/ai/shared/pr_creator.py | Creacion de Pull Requests |

### Categoria 21: Machine Learning (1 componente)

Modelos de ML para soporte de decisiones.

| Componente | Ubicacion | Descripcion |
|------------|-----------|-------------|
| RetrainDeploymentRiskModel | scripts/coding/ai/ml/retrain_deployment_risk_model.py | Modelo de riesgo de deployment |

---

## Casos de Uso Practicos

### Caso 1: Generacion Automatica de User Stories

```bash
python scripts/coding/ai/sdlc/planner_agent.py \
    --feature-request "Implementar autenticacion 2FA con SMS" \
    --context "Sistema Django con usuarios existentes"
```

**Agente**: SDLCPlannerAgent (LLM integrado)

**Output**:
```json
{
  "title": "US-123: Implementar autenticacion 2FA con SMS",
  "description": "Como usuario registrado...",
  "acceptance_criteria": [
    "El usuario puede activar 2FA desde su perfil",
    "Se envia codigo SMS al numero registrado",
    "El codigo expira en 5 minutos"
  ],
  "story_points": 8,
  "priority": "P1",
  "technical_requirements": [
    "Integracion con proveedor SMS",
    "Modelo TwoFactorAuth en BD",
    "Middleware de verificacion 2FA"
  ]
}
```

### Caso 2: Implementacion TDD Automatica

```bash
python scripts/coding/ai/tdd/feature_agent.py \
    --user-story "US-123" \
    --module "authentication" \
    --target-coverage 90
```

**Agente**: TDDFeatureAgent (LLM integrado)

**Flujo**:
1. RED: Genera tests que fallan basados en acceptance criteria
2. GREEN: Implementa codigo para pasar tests
3. REFACTOR: Mejora codigo manteniendo tests verdes

**Output**:
- `api/authentication/two_factor.py` - Implementacion
- `api/tests/test_two_factor.py` - Suite de tests
- Coverage report: 92% (objetivo superado)

### Caso 3: Analisis de Arquitectura con Chain-of-Verification

```bash
python -c "
from scripts.coding.ai.agents.base.chain_of_verification import ChainOfVerificationAgent

agent = ChainOfVerificationAgent(
    llm_provider='anthropic',
    model='claude-sonnet-4-5-20250929'
)

result = agent.verify(
    question='El diseno de esta feature cumple con SOLID?',
    context={'design_doc': 'docs/design/US-123.md'}
)

print(f'Verified: {result.final_answer}')
print(f'Confidence: {result.confidence}')
"
```

**Agente**: ChainOfVerificationAgent (Meta AI 2023)

**Tecnica**: Chain-of-Verification - genera respuesta base, planifica preguntas de verificacion, ejecuta verificaciones independientes, genera respuesta refinada

### Caso 4: Toma de Decisiones con Self-Consistency

```bash
python -c "
from scripts.coding.ai.agents.base.self_consistency import SelfConsistencyAgent

agent = SelfConsistencyAgent(
    num_samples=10,
    temperature=0.7,
    llm_provider='anthropic'
)

result = agent.solve_with_consistency(
    prompt='Debemos usar Redis o Memcached para cache de sesiones?'
)

print(f'Decision: {result.final_answer}')
print(f'Confidence: {result.confidence_score:.2%}')
print(f'Vote distribution: {result.vote_distribution}')
"
```

**Agente**: SelfConsistencyAgent (Google Research 2022)

**Tecnica**: Genera multiples razonamientos independientes y aplica voting para obtener la respuesta mas consistente

### Caso 5: Exploracion de Soluciones con Tree-of-Thoughts

```bash
python -c "
from scripts.coding.ai.agents.base.tree_of_thoughts import TreeOfThoughtsAgent, SearchStrategy

agent = TreeOfThoughtsAgent(
    strategy=SearchStrategy.BEAM,
    max_thoughts_per_step=3,
    max_depth=5,
    llm_provider='anthropic'
)

solution, metadata = agent.solve(
    problem='Como optimizar consultas N+1 en Django ORM',
    context={'domain': 'database'}
)

print(f'Solution path: {[t.content for t in solution]}')
print(f'Total thoughts explored: {metadata["total_thoughts"]}')
"
```

**Agente**: TreeOfThoughtsAgent (Princeton/Google DeepMind 2023)

**Tecnica**: Explora sistematicamente multiples caminos de razonamiento con evaluacion y backtracking

### Caso 6: Analisis de Documentacion

```bash
python scripts/coding/ai/agents/documentation/documentation_analysis_agent.py \
    --path docs/gobernanza/ \
    --mode DEEP \
    --output-format json
```

**Agente**: DocumentationAnalysisAgent

**Analiza**:
1. Estructura (jerarquia, secciones)
2. Calidad (legibilidad, completitud)
3. Constitucion (sin emojis, seguridad)
4. Trazabilidad (enlaces a issues, ADRs)
5. Validacion de enlaces (internos, externos)

**Output**:
```json
{
  "overall_score": 85.5,
  "issues_by_severity": {
    "CRITICAL": 0,
    "HIGH": 2,
    "MEDIUM": 5,
    "LOW": 12
  },
  "recommendations": [
    "Agregar frontmatter YAML a 3 archivos",
    "Reparar 2 enlaces rotos a ADRs",
    "Mejorar legibilidad de 1 seccion (Flesch score < 60)"
  ]
}
```

---

## Arquitectura de CI/CD

### Integracion en GitHub Actions

```yaml
name: AI Agents Pipeline

on: [pull_request]

jobs:
  analyze-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install Dependencies
        run: |
          pip install pytest pytest-cov anthropic

      - name: Run Quality Agents
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          # Coverage Analyzer
          python scripts/coding/ai/quality/coverage_analyzer.py \
            --project-path api/ \
            --min-coverage 85

          # Syntax Validator
          python scripts/coding/ai/quality/syntax_validator.py \
            --path api/ \
            --fix-issues

          # Restrictions Gate
          python scripts/coding/ai/agents/validation/restrictions_gate.py \
            --validate-all

      - name: Create PR if Issues Found
        if: failure()
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          python scripts/coding/ai/shared/pr_creator.py \
            --issue-type "quality-improvements" \
            --auto-fix
```

### Diagrama de Flujo Completo

```
┌───────────────────────────────────────────────────────────────────┐
│                         COMMIT PUSH                                │
└───────────────┬───────────────────────────────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────────────────────────────┐
│                    PRE-COMMIT HOOKS (Local)                        │
├───────────────────────────────────────────────────────────────────┤
│  1. Agente de Formateo/Estilo (DETERMINISTA)                      │
│     - ruff --fix        (lint + auto-fix)                         │
│     - black             (format)                                   │
│     - isort             (imports)                                  │
│     - mypy              (type checking)                            │
│     - shellcheck        (bash scripts)                             │
│                                                                    │
│  2. Validaciones Custom                                            │
│     - check-no-emojis   (grep pattern)                            │
│                                                                    │
│  GUARDRAIL: Si falla alguno BLOQUEA COMMIT                        │
└───────────────┬───────────────────────────────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────────────────────────────┐
│                    GITHUB ACTIONS CI (Remoto)                      │
├───────────────────────────────────────────────────────────────────┤
│  JOB 1: LINT (Fast Feedback - 30 segundos)                        │
│  - ruff check .                                                    │
│  - black --check .                                                 │
│  - isort --check-only .                                            │
│  - mypy api --pretty                                               │
│  GUARDRAIL: Falla = PR bloqueado                                  │
│                                                                    │
│  JOB 2: SECURITY (Shift-Left - 1 minuto)                         │
│  - bandit -r api -q -lll           (SAST Python)                 │
│  - pip-audit -r requirements.txt    (CVE scan)                    │
│  - gitleaks                         (secrets scan)                │
│  - validate_critical_restrictions.sh (custom)                      │
│  GUARDRAIL: CVE High/Critical = BLOQUEA                           │
│                                                                    │
│  JOB 3: TESTS (Core - 2-5 minutos)                               │
│  - pytest -q --cov=api --cov-fail-under=85                        │
│  - pytest-django (integration)                                     │
│  - factory_boy (fixtures)                                          │
│  GUARDRAIL: Cobertura < 85% = BLOQUEA                             │
│                                                                    │
│  JOB 4: CONTRACTS (OpenAPI - 2 minutos)                          │
│  - schemathesis run /openapi.json --checks all                    │
│  GUARDRAIL: Contract violation = WARNING (no bloquea)             │
│                                                                    │
│  JOB 5: CUSTOM VALIDATION                                         │
│  - validate_security_config.sh                                     │
│  - validate_database_router.sh                                     │
└───────────────┬───────────────────────────────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────────────────────────────┐
│                    NIGHTLY JOBS (Profundos)                        │
├───────────────────────────────────────────────────────────────────┤
│  JOB 6: MUTATION TESTING (30-60 minutos)                         │
│  - mutmut run --paths-to-mutate api/                              │
│  - mutmut results mutation_report.txt                            │
│  METRICA: Mutation score > 75% (objetivo)                         │
│                                                                    │
│  JOB 7: FUZZING (1-2 horas)                                       │
│  - hypothesis + python-afl                                         │
│  Enfocado en parsers, importadores, ETL                          │
│                                                                    │
│  JOB 8: PERFORMANCE REGRESSION (10 minutos)                       │
│  - pytest-benchmark                                                │
│  - k6 load testing                                                 │
└───────────────────────────────────────────────────────────────────┘
```

---

## Patrones de Uso

### Patron 1: Agente Standalone

```python
from scripts.coding.ai.tdd.feature_agent import TDDFeatureAgent

agent = TDDFeatureAgent(config={
    "llm_provider": "anthropic",
    "model": "claude-sonnet-4-5-20250929",
    "project_root": "/path/to/project",
    "coverage_target": 90
})

result = agent.run({
    "user_story": "US-123",
    "module": "authentication"
})
```

### Patron 2: Composicion de Agentes

```python
from scripts.coding.ai.sdlc.planner_agent import SDLCPlannerAgent
from scripts.coding.ai.sdlc.feasibility_agent import SDLCFeasibilityAgent
from scripts.coding.ai.tdd.feature_agent import TDDFeatureAgent

# Pipeline: Planificacion Factibilidad Implementacion
planner = SDLCPlannerAgent(config={...})
feasibility = SDLCFeasibilityAgent(config={...})
tdd = TDDFeatureAgent(config={...})

# 1. Generar user story
user_story = planner.run({"feature_request": "..."})

# 2. Validar factibilidad
feasibility_result = feasibility.run({"user_story": user_story})

if feasibility_result["decision"] == "GO":
    # 3. Implementar con TDD
    implementation = tdd.run({"user_story": user_story})
```

### Patron 3: Agente con Verificacion

```python
from scripts.coding.ai.agents.base.chain_of_verification import ChainOfVerificationAgent

# Agente meta para validar outputs de otros agentes
verifier = ChainOfVerificationAgent(use_llm=True)

# Generar codigo con agente
code = tdd_operativo.run({...})

# Verificar con CoVe
verification = verifier.verify(
    question="Este codigo cumple con TDD y SOLID?",
    context={"code": code}
)

if verification.final_confidence < 0.7:
    # Regenerar con feedback
    code = tdd_operativo.run({..., "feedback": verification.issues})
```

### Patron 4: Orquestacion Multi-Agente

```python
from scripts.coding.ai.sdlc.orchestrator import SDLCOrchestratorAgent

orchestrator = SDLCOrchestratorAgent(config={
    "llm_provider": "anthropic",
    "model": "claude-sonnet-4-5-20250929"
})

result = orchestrator.run({
    "feature_request": "Implementar autenticacion 2FA",
    "project_context": "Sistema Django existente",
    "start_phase": "planning",
    "end_phase": "deployment"
})

# Result contiene outputs de todas las fases
print(result["phases"]["planning"]["user_story"])
print(result["phases"]["feasibility"]["decision"])
print(result["phases"]["implementation"]["coverage"])
```

---

## Mejores Practicas

### 1. Velocidad del Feedback Loop

**Objetivo**: Desarrollador debe saber si algo esta mal en < 30 segundos

**Implementacion**:
```
Pre-commit (local) 10-15 segundos
- ruff --fix (2s)
- black (1s)
- isort (1s)
- mypy (5s)
- custom checks (2s)

CI Lint Job 30 segundos
- ruff check
- black --check
- isort --check

CI Tests 2-5 minutos
- pytest con servicios
```

### 2. Guardrails No Negociables

| Guardrail | Accion | Justificacion |
|-----------|--------|---------------|
| Cobertura < 85% | BLOQUEA merge | Calidad minima |
| CVE High/Critical | BLOQUEA merge | Seguridad |
| Ruff/Black failing | BLOQUEA merge | Estandares |
| No emojis en .md | BLOQUEA commit | Regla del proyecto |
| Restricciones criticas | BLOQUEA merge | Requisitos de negocio |

### 3. Tests Progresivos

```
Commit Pre-commit hooks (10s)

Push CI Lint (30s)

PR CI Tests + Security (5min)

Merge Contracts + Property-Based (10min)

Nightly Mutation + Fuzzing (2h)
```

### 4. Agentes LLM: Asistentes, No Jueces

**Correcto**:
- LLM propone tests Verifier determinista valida
- LLM sugiere refactor Ruff/mypy/pytest validan
- LLM genera codigo Coverage check valida

**Incorrecto**:
- LLM decide si merge o no (debe ser determinista)
- LLM como unico validador de calidad
- LLM sin guardrails deterministas

### 5. Documentacion de Decisiones

Cada agente debe documentar:
- Que hizo
- Por que lo hizo
- Que valido
- Que encontro

Ejemplo:
```json
{
  "agent": "TDDFeatureAgent",
  "timestamp": "2025-11-17T10:00:00Z",
  "user_story": "US-123",
  "tests_generated": 15,
  "coverage_achieved": 92.5,
  "verification": {
    "all_tests_pass": true,
    "linting_pass": true,
    "type_checking_pass": true
  },
  "guardrails_passed": [
    "minimum_coverage_90",
    "no_hardcoded_secrets",
    "follows_aaa_pattern"
  ]
}
```

---

## Estado de Implementacion

### Metricas de Progreso

**Total de agentes implementados**: 100+

**Por categoria**:
- SDLC: 7 agentes
- TDD: 1 agente
- Base/Tecnicas: 12 componentes
- Meta: 7 agentes
- Documentacion: 3 agentes
- Seguridad: 3 agentes
- Calidad: 2 agentes + 5 validadores
- Validacion: 2 agentes
- Requisitos: 3 agentes
- Database: 1 agente
- Permisos: 2 agentes
- UX: 3 agentes
- Placement: 14 componentes
- Planning: 5 componentes
- Protocolos: 3 agentes
- Automatizacion: 9 agentes
- Generadores: 4 componentes
- Analisis Negocio: 2 componentes
- Orquestadores: 1 componente
- Utilidades: 7 componentes
- ML: 1 componente

**Integracion LLM**:
- Agentes con LLM: 6 (TDDFeature, SDLCPlanner, SDLCOrchestrator, ChainOfVerification, AutoCoT, SelfConsistency, TreeOfThoughts)
- Proveedores: Anthropic Claude, OpenAI GPT
- Componente central: LLMGenerator

### Referencias Adicionales

**Documentacion relacionada**:
- Arquitectura de agentes especializados: `docs/gobernanza/metodologias/arquitectura_servicios_especializados.md`
- README tecnico: `scripts/coding/ai/README.md`
- Configuracion API keys: `scripts/coding/ai/.env.example`
- Constitucion de agentes: Archivos constitution.py en cada categoria

**Scripts de ejecucion**:
- Pipeline SDLC completo: `scripts/run_sdlc_pipeline_for_tdd.py`
- Test generation orchestrator: `scripts/coding/ai/test_generation_orchestrator.py`
- Generacion de analisis de negocio: `scripts/coding/ai/examples/generate_business_analysis.py`

---

## Conclusion

El proyecto IACT implementa una arquitectura completa de agentes especializados que automatiza el ciclo completo de SDLC. Todos los agentes estan implementados en `scripts/coding/ai/` y siguen el patron de Single Responsibility Principle.

**Principios clave**:
1. Un agente = Una responsabilidad
2. Interfaces claras entre agentes
3. Idempotencia
4. Sin estado compartido
5. Logging estructurado
6. Guardrails deterministas
7. LLM como asistente, no juez

**Proximos pasos**:
1. Completar integracion LLM en agentes SDLC restantes
2. Implementar dashboard de metricas DORA
3. Agregar mas tecnicas de prompting avanzadas
4. Expandir cobertura de tests de agentes
5. Documentar mas casos de uso practicos

---

**Ultima actualizacion**: 2025-11-17
**Autor**: Equipo de Desarrollo
**Revisores**: Equipo QA, Equipo DevOps
**Changelog**:
- 2025-11-17: Actualizacion completa con inventario real de 100+ agentes, rutas corregidas (scripts/coding/ai), sin emojis - v2.0.0
- 2025-11-11: Agregada seccion "Sistema de 35 Agentes Especializados" con casos de uso practicos - v1.3.0
- 2025-11-06: Agregados ReleaseAgent, DependencyAgent, SecurityAgent - v1.2.0
- 2025-11-05: Agregado Agente GitOps con caso de uso real - v1.1.0
- 2025-11-04: Version inicial - v1.0.0
