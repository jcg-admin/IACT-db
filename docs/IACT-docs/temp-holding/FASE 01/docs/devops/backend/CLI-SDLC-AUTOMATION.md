---
title: CLI de Agentes SDLC - Documentación Completa
date: 2025-11-13
domain: backend
status: active
---

# CLI de Agentes SDLC - Documentación Completa

**Archivo**: `scripts/sdlc_agent.py`
**Versión**: 1.0.0
**Última actualización**: 2025-11-07
**Propósito**: CLI para ejecutar agentes SDLC (Software Development Life Cycle) que automatizan fases del desarrollo

---

## Descripción General

El CLI de agentes SDLC permite automatizar las fases del ciclo de vida de desarrollo de software mediante agentes basados en LLM (Claude 3.5 Sonnet). Cada agente es responsable de una fase específica del SDLC y genera artefactos documentados.

### Capacidades

- **Ejecución por fases**: Ejecutar agentes SDLC individuales (planning, feasibility, design, testing, deployment)
- **Pipeline completo**: Orquestar múltiples agentes en secuencia
- **Dry-run mode**: Probar agentes sin guardar artefactos
- **Múltiples formatos**: Output en texto legible o JSON
- **Configuración flexible**: JSON config file o defaults sensibles

### Estado de Implementación

| Fase | Agente | Estado | Comando |
|------|--------|--------|---------|
| Planning | SDLCPlannerAgent | IMPLEMENTADO | `--phase planning` |
| Feasibility | SDLCFeasibilityAgent | PENDIENTE | `--phase feasibility` |
| Design | SDLCDesignAgent | PENDIENTE | `--phase design` |
| Testing | SDLCTestingAgent | PENDIENTE | `--phase testing` |
| Deployment | SDLCDeploymentAgent | PENDIENTE | `--phase deployment` |
| Maintenance | SDLCMaintenanceAgent | PENDIENTE | `--phase maintenance` |
| Pipeline | SDLCPipeline | PARCIAL | `--pipeline` |

---

## Instalación y Requisitos

### Requisitos

```bash
Python >= 3.11
anthropic >= 0.40.0
```

### Configuración de API Key

El CLI requiere acceso a la API de Anthropic (Claude). Configure la API key:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

O en archivo `.env`:

```
ANTHROPIC_API_KEY=sk-ant-...
```

### Verificación

```bash
# Verificar que el CLI funciona
python scripts/sdlc_agent.py --help
```

---

## Sintaxis Completa

```bash
python scripts/sdlc_agent.py [OPTIONS]
```

### Opciones Requeridas (una de las siguientes)

```
--phase {planning|feasibility|design|testing|deployment|maintenance}
    Ejecutar una fase SDLC específica

--pipeline
    Ejecutar pipeline SDLC completo (todas las fases en secuencia)
```

### Opciones de Input (una requerida)

```
--input TEXT
    Feature request como texto directo
    Ejemplo: --input "Feature: Implementar autenticación 2FA"

--input-file PATH
    Leer feature request desde archivo
    Ejemplo: --input-file feature_request.txt
```

### Opciones de Configuración

```
--config PATH
    Archivo de configuración JSON (opcional)
    Default: configuración interna con valores sensibles

--project-context TEXT
    Contexto adicional del proyecto (opcional)
    Ejemplo: --project-context "Aplicación Django REST API"

--auto-proceed
    Auto-proceder sin confirmación humana (solo pipeline)
    Útil para CI/CD automation

--dry-run
    Modo prueba: no guardar artefactos
    Los outputs van a /tmp/sdlc_outputs

--format {text|json}
    Formato de output (default: text)

--verbose
    Logging detallado (nivel DEBUG)
```

---

## Ejemplos de Uso

### Ejemplo 1: Planning Phase (Básico)

```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Sistema de notificaciones push"
```

**Output esperado**:
```
================================================================================
RESULTADO DE EJECUCIÓN
================================================================================

Estado: SUCCESS

Issue generado:
  Título: Implementar Sistema de Notificaciones Push
  Story Points: 13
  Prioridad: P1
  Artefacto: docs/sdlc_outputs/planning/issue_20251107_143022.md

Acceptance Criteria (7):
  1. Usuario puede recibir notificaciones push en dispositivos registrados
  2. Sistema soporta notificaciones programadas y en tiempo real
  3. Dashboard de administración para gestionar notificaciones
  4. API RESTful para enviar notificaciones desde backend
  5. Registro y des-registro de dispositivos
  ... y 2 más

Requisitos Técnicos (5):
  - Integrar Firebase Cloud Messaging (FCM) para Android/iOS
  - Implementar API endpoint POST /api/v1/notifications/send
  - Crear modelo NotificationQueue en Django
  - Implementar background task con Celery para envíos programados
  - Agregar tests de integración E2E para notificaciones

Decisión de fase: GO
Confianza: 95.0%

Recomendaciones:
  - Considerar rate limiting (max 1000 notificaciones/minuto)
  - Implementar retry logic para fallos de red
  - Agregar analytics para tracking de deliverability

================================================================================
```

**Artefactos generados**:
- `docs/sdlc_outputs/planning/issue_20251107_143022.md`: Issue completo formateado para GitHub

### Ejemplo 2: Planning con Archivo de Input

```bash
# Crear archivo de feature request
cat > feature_request.txt <<EOF
Feature: Dashboard de Métricas DORA

Requerimientos:
- Visualizar 4 métricas DORA (deployment frequency, lead time, MTTR, change failure rate)
- Gráficos históricos (últimos 30/90 días)
- Comparación con benchmarks de industria
- Exportar datos a CSV/JSON
- Filtros por equipo, proyecto, ambiente
EOF

# Ejecutar agente
python scripts/sdlc_agent.py \
  --phase planning \
  --input-file feature_request.txt \
  --project-context "Aplicación Django + PostgreSQL + React"
```

### Ejemplo 3: Dry-Run (No Guardar Artefactos)

```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Implementar rate limiting en API" \
  --dry-run \
  --verbose
```

**Comportamiento**:
- No guarda artefactos en `docs/sdlc_outputs/`
- Outputs temporales en `/tmp/sdlc_outputs/`
- Logging detallado con `--verbose`

### Ejemplo 4: Output en JSON (Para CI/CD)

```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Cache de consultas frecuentes" \
  --format json > planning_result.json
```

**Output JSON**:
```json
{
  "status": "success",
  "data": {
    "issue_title": "Implementar Cache de Consultas Frecuentes",
    "story_points": 8,
    "priority": "P1",
    "issue_path": "docs/sdlc_outputs/planning/issue_20251107_143500.md",
    "acceptance_criteria": [
      "Cache implementado con Redis para consultas de usuario",
      "TTL configurable por tipo de consulta",
      "Cache warming automático para datos críticos"
    ],
    "technical_requirements": [
      "Integrar django-redis para caching",
      "Implementar cache invalidation strategy",
      "Agregar monitoring de hit rate"
    ],
    "phase_result": {
      "decision": "go",
      "confidence": 0.92,
      "recommendations": [
        "Definir política de cache invalidation clara",
        "Implementar circuit breaker para fallos de Redis"
      ]
    }
  }
}
```

### Ejemplo 5: Pipeline Completo (Cuando esté implementado)

```bash
python scripts/sdlc_agent.py \
  --pipeline \
  --input "Feature: Sistema de autenticación OAuth2" \
  --auto-proceed
```

**Comportamiento esperado**:
1. **Planning**: Genera issue + user stories
2. **Feasibility**: Análisis de viabilidad técnica/económica
3. **Design**: HLD + LLD + ADRs
4. **Implementation**: Guía de implementación (humano ejecuta código)
5. **Testing**: Test cases + execution
6. **Deployment**: Deployment plan + rollback plan

**Estado actual**: Solo Planning implementado. Pipeline ejecuta solo esa fase.

### Ejemplo 6: Configuración Personalizada

```bash
# Crear config file
cat > sdlc_config.json <<EOF
{
  "project_root": "/home/user/IACT---project",
  "output_dir": "docs/sdlc_outputs",
  "llm_provider": "anthropic",
  "model": "claude-3-5-sonnet-20241022",
  "temperature": 0.7,
  "max_tokens": 4096
}
EOF

# Usar config personalizada
python scripts/sdlc_agent.py \
  --phase planning \
  --input "Feature: Búsqueda full-text con Elasticsearch" \
  --config sdlc_config.json
```

---

## Códigos de Salida

El CLI retorna códigos de salida para integración con CI/CD:

| Código | Significado | Descripción |
|--------|-------------|-------------|
| 0 | SUCCESS | Ejecución exitosa o requiere aprobación humana |
| 1 | FAILED | Error de ejecución o fallo de agente |
| 2 | BLOCKED | Agente bloqueado (no-go decision o errores críticos) |

**Ejemplo en script Bash**:
```bash
#!/bin/bash

if python scripts/sdlc_agent.py --phase planning --input "..."; then
    echo "Planning exitoso, continuar con implementación"
else
    exit_code=$?
    if [ $exit_code -eq 2 ]; then
        echo "ERROR: Agente bloqueado, revisar razones"
    else
        echo "ERROR: Fallo de ejecución"
    fi
    exit $exit_code
fi
```

---

## Configuración Avanzada

### Archivo de Configuración JSON

**Ubicación sugerida**: `config/sdlc_agents.json`

```json
{
  "project_root": "/home/user/IACT---project",
  "output_dir": "docs/sdlc_outputs",
  "llm_provider": "anthropic",
  "model": "claude-3-5-sonnet-20241022",
  "temperature": 0.7,
  "max_tokens": 4096,
  "planning": {
    "default_priority": "P2",
    "story_points_scale": "fibonacci",
    "max_acceptance_criteria": 10
  },
  "feasibility": {
    "risk_threshold": 0.7,
    "auto_approve_low_risk": true
  },
  "design": {
    "generate_diagrams": true,
    "diagram_format": "mermaid"
  }
}
```

### Variables de Entorno

```bash
# API Keys
export ANTHROPIC_API_KEY="sk-ant-..."

# Configuración
export SDLC_OUTPUT_DIR="docs/sdlc_outputs"
export SDLC_LOG_LEVEL="INFO"
export SDLC_AUTO_PROCEED="false"
```

---

## Artefactos Generados

### Estructura de Directorios

```
docs/sdlc_outputs/
├── planning/
│   ├── issue_20251107_143022.md          # Issue GitHub-ready
│   ├── user_stories_20251107_143022.md    # User stories detalladas
│   └── estimation_20251107_143022.json    # Estimaciones JSON
├── feasibility/
│   ├── feasibility_report_*.md
│   └── risk_assessment_*.md
├── design/
│   ├── hld_*.md                           # High-Level Design
│   ├── lld_*.md                           # Low-Level Design
│   ├── adrs/                              # Architecture Decision Records
│   └── diagrams/                          # Mermaid diagrams
├── testing/
│   ├── test_plan_*.md
│   ├── test_cases_*.md
│   └── test_execution_report_*.md
└── deployment/
    ├── deployment_plan_*.md
    ├── rollback_plan_*.md
    └── post_deployment_checklist_*.md
```

### Formato de Issues Generados

**Ejemplo**: `docs/sdlc_outputs/planning/issue_20251107_143022.md`

```markdown
# Feature: Sistema de Notificaciones Push

**Story Points**: 13
**Prioridad**: P1
**Tipo**: Feature
**Generado**: 2025-11-07 14:30:22 UTC

## User Story

Como usuario de la aplicación,
Quiero recibir notificaciones push en mi dispositivo,
Para estar informado de eventos importantes en tiempo real.

## Acceptance Criteria

- [ ] Usuario puede recibir notificaciones push en dispositivos registrados
- [ ] Sistema soporta notificaciones programadas y en tiempo real
- [ ] Dashboard de administración para gestionar notificaciones
- [ ] API RESTful para enviar notificaciones desde backend
- [ ] Registro y des-registro de dispositivos
- [ ] Rate limiting de 1000 notificaciones/minuto
- [ ] Analytics de deliverability

## Technical Requirements

### Backend
- Integrar Firebase Cloud Messaging (FCM) para Android/iOS
- Implementar API endpoint POST /api/v1/notifications/send
- Crear modelo NotificationQueue en Django
- Implementar background task con Celery para envíos programados

### Frontend
- Integrar Firebase SDK en React
- Solicitar permisos de notificaciones al usuario
- Manejar notificaciones en foreground y background

### Testing
- Tests unitarios para lógica de envío
- Tests de integración con FCM
- Tests E2E de flujo completo

## Estimación

- **Story Points**: 13 (Fibonacci)
- **Esfuerzo estimado**: 2-3 sprints (4-6 semanas)
- **Confianza**: 95%

## Dependencies

- Ninguna dependencia crítica identificada
- Nice-to-have: Sistema de plantillas de notificaciones (puede implementarse después)

## Risks

- **Rate limiting de FCM**: Google tiene límites de 500 requests/segundo
  - Mitigación: Implementar queue local con rate limiting propio

- **Compatibilidad de navegadores**: Web Push API no soportado en todos los navegadores
  - Mitigación: Graceful degradation, mostrar banner en navegadores no soportados

## Next Steps

1. Crear issue en GitHub con este contenido
2. Asignar al sprint backlog
3. Ejecutar fase de Feasibility Analysis si es P0/P1
4. Definir tasks técnicos específicos
5. Asignar a developers

## Generated by

SDLC Planner Agent v1.0.0
Model: claude-3-5-sonnet-20241022
```

---

## Integración con CI/CD

### GitHub Actions Example

```yaml
name: SDLC Agent Planning

on:
  issues:
    types: [labeled]

jobs:
  run-planning-agent:
    if: github.event.label.name == 'needs-planning'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install anthropic

      - name: Run Planning Agent
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          python scripts/sdlc_agent.py \
            --phase planning \
            --input "${{ github.event.issue.body }}" \
            --format json > planning_result.json

      - name: Parse Result
        id: parse
        run: |
          status=$(jq -r '.status' planning_result.json)
          echo "status=$status" >> $GITHUB_OUTPUT

      - name: Comment on Issue
        if: steps.parse.outputs.status == 'success'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const result = JSON.parse(fs.readFileSync('planning_result.json', 'utf8'));
            const comment = `
            ## Planning Agent Results

            - Story Points: ${result.data.story_points}
            - Priority: ${result.data.priority}
            - Confidence: ${(result.data.phase_result.confidence * 100).toFixed(1)}%

            Full issue generated at: ${result.data.issue_path}
            `;
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: comment
            });
```

---

## Troubleshooting

### Error: "API key not found"

**Causa**: `ANTHROPIC_API_KEY` no configurada

**Solución**:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### Error: "Fase 'feasibility' no implementada aún"

**Causa**: Agente no implementado todavía

**Solución**: Usar solo `--phase planning` por ahora

### Error: "No module named 'agents.sdlc_base'"

**Causa**: Estructura de directorios incorrecta o falta módulo

**Solución**:
```bash
# Verificar estructura
ls scripts/ai/agents/

# Debe contener:
# - sdlc_base.py
# - sdlc_planner.py
```

### Output Vacío o Incorrecto

**Debug con verbose**:
```bash
python scripts/sdlc_agent.py \
  --phase planning \
  --input "..." \
  --verbose
```

**Revisar logs**:
```
[14:30:22] sdlc_agent - INFO - Cargando configuración
[14:30:23] sdlc_planner - INFO - Ejecutando planning phase
[14:30:25] sdlc_planner - DEBUG - Llamando a Claude API
[14:30:30] sdlc_planner - INFO - Issue generado exitosamente
```

---

## Roadmap de Implementación

### v1.0 (ACTUAL) - Planning Only
- [x] SDLCPlannerAgent implementado
- [x] CLI básico funcional
- [x] Dry-run mode
- [x] Output en JSON y text

### v1.1 (PRÓXIMO) - Feasibility + Design
- [ ] SDLCFeasibilityAgent
- [ ] SDLCDesignAgent
- [ ] Pipeline con 3 fases

### v1.2 - Testing + Deployment
- [ ] SDLCTestingAgent
- [ ] SDLCDeploymentAgent
- [ ] Pipeline con 5 fases

### v2.0 - Maintenance + Orchestration
- [ ] SDLCMaintenanceAgent
- [ ] Orchestrator inteligente con decisiones autónomas
- [ ] Integración completa CI/CD

---

## Referencias

- **Código fuente**: `scripts/sdlc_agent.py`
- **Agentes**: `scripts/ai/agents/`
- **Outputs**: `docs/sdlc_outputs/`
- **Proceso SDLC**: `docs/gobernanza/procesos/SDLC_PROCESS.md`
- **Templates**: `docs/plantillas/`

---

## Ownership

**Maintainer**: DevOps Team
**Code Review**: Tech Lead required
**CI/CD Integration**: DevOps Engineer

Ver `.github/CODEOWNERS` para ownership detallado.
