---
title: Reorganización: scripts/ → scripts/ai
date: 2025-11-13
domain: backend
status: active
---

# Reorganización: scripts/ → scripts/ai

**Fecha:** 2025-11-11
**Propósito:** Identificar scripts que deberían moverse a `scripts/ai` y proponer nuevos agentes

---

## Estructura Actual

```
scripts/
 ai/ # [OK] Ya organizado
 agents/ # Agentes AI
 permissions/ # Route Linter (22/22 tests)
 tdd/ # TDD Agent v1.1
 config/ # Configuración
 examples/ # Ejemplos
 ci/ # [OK] CI/CD shell scripts
 infrastructure/
 security/
 testing/
 ml/ # [MOVER] Machine Learning
 requisitos/ # [MOVER] Requirements management
 cassandra/ # [OK] DB específico
 disaster_recovery/ # [OK] DR específico
 load_testing/ # [OK] Performance específico
 logging/ # [OK] Logging específico
 [scripts raíz] # [REVISAR] Muchos candidatos para AI
```

---

## Análisis: ¿Qué mover a scripts/ai?

### Categoría 1: DEFINITIVAMENTE AI (mover YA)

#### 1.1 Machine Learning
```
[ACTUAL] scripts/ml/retrain_deployment_risk_model.py
[DESTINO] scripts/ai/ml/deployment_risk_model.py
[RAZÓN] Es ML, pertenece a AI
```

#### 1.2 Generación de Contenido (Content Generation)
```
[ACTUAL] scripts/generate_business_analysis.py
[DESTINO] scripts/ai/agents/documentation/business_analyzer.py
[TIPO] Chain Agent (multi-step analysis)
[RAZÓN] Genera análisis automático → AI task

[ACTUAL] scripts/generate_guides.py
[DESTINO] scripts/ai/agents/documentation/guide_generator.py
[TIPO] Template Agent (genera docs desde templates)
[RAZÓN] Generación automática de guías → AI task

[ACTUAL] scripts/sync_documentation.py
[DESTINO] scripts/ai/agents/documentation/doc_synchronizer.py
[TIPO] Chain Agent (analiza + sincroniza + valida)
[RAZÓN] Requiere análisis inteligente de contenido → AI task

[ACTUAL] scripts/generate_workflow_from_template.py
[DESTINO] scripts/ai/agents/workflow/workflow_generator.py
[TIPO] Template Agent
[RAZÓN] Generación desde templates con lógica → AI task
```

#### 1.3 Análisis de Métricas (Metrics Analysis)
```
[ACTUAL] scripts/dora_metrics.py
[DESTINO] scripts/ai/agents/metrics/dora_analyzer.py
[TIPO] Analytics Agent (recopila + analiza + reporta)
[RAZÓN] Análisis de patrones en métricas → AI task

[ACTUAL] scripts/sdlc_agent.py
[DESTINO] scripts/ai/agents/sdlc/sdlc_orchestrator.py
[RAZÓN] Ya es un agente, mover a estructura correcta
```

#### 1.4 Requirements Management
```
[ACTUAL] scripts/requisitos/validar_frontmatter.py
[DESTINO] scripts/ai/agents/requirements/frontmatter_validator.py
[TIPO] Gate (valida estructura de requisitos)
[RAZÓN] Validación estructurada → Gate pattern

[ACTUAL] scripts/requisitos/generar_indices.py
[DESTINO] scripts/ai/agents/requirements/index_generator.py
[TIPO] Template Agent
[RAZÓN] Generación automática de índices → AI task

[ACTUAL] scripts/requisitos/generate_requirements_index.py
[DESTINO] scripts/ai/agents/requirements/requirements_indexer.py
[TIPO] Chain Agent (escanea + analiza + genera índice)
[RAZÓN] Requiere análisis de relaciones entre requisitos → AI task

[ACTUAL] scripts/requisitos/listar_requisitos.sh
[DESTINO] scripts/ai/agents/requirements/requirements_lister.sh
[TIPO] Utility (wrapper para agente)
[RAZÓN] Debería usar el agente indexer
```

---

### Categoría 2: VALIDADORES (convertir a Gates)

#### 2.1 Documentation Validation
```
[ACTUAL] scripts/validar_estructura_docs.sh
[DESTINO] scripts/ai/agents/documentation/docs_structure_gate.py
[TIPO] Gate (valida estructura de documentación)
[RAZÓN] Validación sistemática → Gate pattern
[SHELL] scripts/ci/gate-docs-structure.sh (wrapper)
```

#### 2.2 Database Validation
```
[ACTUAL] scripts/validate_database_router.sh
[DESTINO] scripts/ai/agents/database/db_router_gate.py
[TIPO] Gate (valida que DB router no escribe en IVR)
[RAZÓN] Validación crítica de restricciones → Gate pattern
[SHELL] scripts/ci/gate-db-router.sh (wrapper)
```

#### 2.3 Restrictions Validation
```
[ACTUAL] scripts/validate_critical_restrictions.sh
[DESTINO] scripts/ai/agents/validation/restrictions_gate.py
[TIPO] Gate (valida restricciones del proyecto)
[RAZÓN] Validación de reglas de negocio → Gate pattern
[SHELL] scripts/ci/gate-restrictions.sh (wrapper)
```

#### 2.4 Emoji Check
```
[ACTUAL] scripts/check_no_emojis.py
[DESTINO] scripts/ai/agents/validation/emoji_lint_gate.py
[TIPO] Gate (valida ausencia de emojis)
[RAZÓN] Ya existe como restricción, crear gate formal
[SHELL] scripts/ci/gate-no-emojis.sh (wrapper)
```

---

### Categoría 3: MANTENIMIENTO AUTOMATIZADO (AI Automation)

#### 3.1 Content Cleanup
```
[ACTUAL] scripts/clean_emojis.sh
[DESTINO] scripts/ai/agents/maintenance/emoji_cleaner.py
[TIPO] Automation Agent (detecta + limpia + reporta)
[RAZÓN] Requiere análisis de contexto para limpiar → AI task
```

#### 3.2 Documentation Reorganization
```
[ACTUAL] scripts/reorganizar_docs_por_dominio.sh
[DESTINO] scripts/ai/agents/documentation/docs_organizer.py
[TIPO] Chain Agent (analiza dominio + mueve + actualiza refs)
[RAZÓN] Requiere análisis semántico de contenido → AI task
```

---

### Categoría 4: NO MOVER (mantener en scripts/ci o scripts/)

#### 4.1 Infrastructure/DevOps (scripts/ci o raíz)
```
[MANTENER] scripts/deploy.sh → Deployment puro
[MANTENER] scripts/health_check.sh → Ya existe en ci/infrastructure/
[MANTENER] scripts/install_hooks.sh → Git hooks (infraestructura)
[MANTENER] scripts/complete_sync.sh → Sync (infraestructura)
[MANTENER] scripts/cleanup_sessions.sh → Maintenance (NO AI)
[MANTENER] scripts/cleanup_branches.sh → Git maintenance (NO AI)
[MANTENER] scripts/backup_data_centralization.sh → Backup (NO AI)
```

#### 4.2 Testing (scripts/ci/testing/)
```
[MANTENER] scripts/run_all_tests.sh → Ya existe en ci/
[MANTENER] scripts/run_integration_tests.sh → Ya existe en ci/
```

#### 4.3 Security (scripts/ci/security/)
```
[MANTENER] scripts/validate_security_config.sh → Ya existe en ci/security/
```

---

## Nuevos Agentes Propuestos

### 1. Code Review Agent
```
[PATH] scripts/ai/agents/review/code_reviewer.py
[TIPO] Chain Agent
[FUNCIÓN] - Analiza PRs/commits
 - Detecta anti-patterns
 - Verifica convenciones
 - Genera reporte con sugerencias
[PROMPT] docs/backend/permisos/promptops/chains/code-review.md
[SHELL] scripts/ci/gate-code-review.sh
```

### 2. Migration Validator Agent
```
[PATH] scripts/ai/agents/database/migration_validator.py
[TIPO] Gate
[FUNCIÓN] - Valida migraciones Django
 - Detecta migraciones riesgosas (DROP, ALTER)
 - Verifica orden de migraciones
 - Valida backward compatibility
[PROMPT] docs/backend/permisos/promptops/gates/migration-validator.md
[SHELL] scripts/ci/gate-migration.sh
```

### 3. Performance Profiler Agent
```
[PATH] scripts/ai/agents/performance/profiler.py
[TIPO] Analytics Agent
[FUNCIÓN] - Analiza puntos calientes (hot spots)
 - Detecta N+1 queries
 - Identifica imports circulares
 - Genera reporte con recomendaciones
[PROMPT] docs/backend/permisos/promptops/analytics/performance-profiler.md
[SHELL] scripts/ci/analyze-performance.sh
```

### 4. Dependency Updater Agent
```
[PATH] scripts/ai/agents/dependencies/dependency_updater.py
[TIPO] Chain Agent
[FUNCIÓN] - Analiza dependencias obsoletas
 - Verifica compatibilidad (semver)
 - Ejecuta tests después de update
 - Genera PR con cambios
[PROMPT] docs/backend/permisos/promptops/chains/dependency-updater.md
[SHELL] scripts/ai/update-dependencies.sh
```

### 5. Test Coverage Analyzer
```
[PATH] scripts/ai/agents/testing/coverage_analyzer.py
[TIPO] Analytics Agent
[FUNCIÓN] - Analiza cobertura de código
 - Identifica módulos sin tests
 - Detecta código muerto
 - Genera reporte con prioridades
[PROMPT] docs/backend/permisos/promptops/analytics/coverage-analyzer.md
[SHELL] scripts/ci/analyze-coverage.sh
```

### 6. API Contract Validator
```
[PATH] scripts/ai/agents/api/contract_validator.py
[TIPO] Gate
[FUNCIÓN] - Valida contratos OpenAPI/Swagger
 - Detecta breaking changes en API
 - Verifica versionado correcto
 - Valida response schemas
[PROMPT] docs/backend/permisos/promptops/gates/api-contract.md
[SHELL] scripts/ci/gate-api-contract.sh
```

---

## Plan de Migración

### Fase 1: Quick Wins (1-2 días)
1. Mover `scripts/ml/` → `scripts/ai/ml/`
2. Mover `scripts/requisitos/` → `scripts/ai/agents/requirements/`
3. Crear gates faltantes:
 - `gate-docs-structure.sh`
 - `gate-db-router.sh`
 - `gate-restrictions.sh`
 - `gate-no-emojis.sh`

### Fase 2: Content Generation Agents (3-5 días)
4. Migrar generadores:
 - `business_analyzer.py`
 - `guide_generator.py`
 - `doc_synchronizer.py`
 - `workflow_generator.py`

### Fase 3: Nuevos Agentes Críticos (1 semana)
5. Implementar agentes prioritarios:
 - Migration Validator (CRÍTICO para seguridad BD)
 - Code Review Agent (mejora calidad código)
 - API Contract Validator (previene breaking changes)

### Fase 4: Analytics & Optimization (2 semanas)
6. Implementar agentes de análisis:
 - Performance Profiler
 - Test Coverage Analyzer
 - Dependency Updater

---

## Estructura Objetivo Final

```
scripts/
 ai/
 agents/
 api/ # API validation
 contract_validator.py
 database/ # Database agents
 db_router_gate.py
 migration_validator.py
 dependencies/ # Dependency management
 dependency_updater.py
 documentation/ # Docs agents
 business_analyzer.py
 docs_organizer.py
 docs_structure_gate.py
 doc_synchronizer.py
 guide_generator.py
 maintenance/ # Automation
 emoji_cleaner.py
 metrics/ # Analytics
 dora_analyzer.py
 performance/ # Performance
 profiler.py
 permissions/ # [EXISTENTE]
 route_linter.py
 requirements/ # Requirements mgmt
 frontmatter_validator.py
 index_generator.py
 requirements_indexer.py
 review/ # Code review
 code_reviewer.py
 sdlc/ # SDLC orchestration
 sdlc_orchestrator.py
 tdd/ # [EXISTENTE]
 tdd_operativo.py
 test_generator.py
 testing/ # Test analysis
 coverage_analyzer.py
 validation/ # General validation
 emoji_lint_gate.py
 restrictions_gate.py
 workflow/ # Workflow generation
 workflow_generator.py
 ml/ # Machine Learning
 deployment_risk_model.py
 config/ # [EXISTENTE]
 examples/ # [EXISTENTE]
 ci/ # [EXISTENTE]
 infrastructure/
 security/
 testing/
 gate-api-contract.sh
 gate-code-review.sh
 gate-db-router.sh
 gate-docs-structure.sh
 gate-migration.sh
 gate-no-emojis.sh
 gate-restrictions.sh
 gate-route-lint.sh # [EXISTENTE]
 run-all-gates.sh # [EXISTENTE]
 cassandra/ # [MANTENER]
 disaster_recovery/ # [MANTENER]
 load_testing/ # [MANTENER]
 logging/ # [MANTENER]
 [scripts de infraestructura] # [MANTENER]
```

---

## Beneficios de la Reorganización

### 1. Claridad Arquitectural
- [OK] Separación clara: AI vs Infraestructura vs CI/CD
- [OK] Fácil encontrar agentes por categoría
- [OK] Estructura escalable

### 2. Mantenibilidad
- [OK] Código relacionado agrupado
- [OK] Más fácil agregar nuevos agentes
- [OK] Menos conflictos en PRs

### 3. Reusabilidad
- [OK] Agentes pueden importarse fácilmente
- [OK] Shared utilities en `ai/config/`
- [OK] Templates reutilizables

### 4. Testing
- [OK] Tests organizados por agente
- [OK] Más fácil ejecutar tests por categoría
- [OK] TDD Agent puede generar tests automáticamente

---

## Próximos Pasos

1. **Aprobar propuesta** de reorganización
2. **Fase 1** (Quick Wins): Mover ML y requisitos
3. **Crear gates faltantes** (docs, db-router, restrictions, emojis)
4. **Migrar generadores** de contenido
5. **Implementar nuevos agentes** prioritarios

---

**Documento generado por:** Script Analysis Initiative
**Fecha:** 2025-11-11
**Versión:** 1.0
