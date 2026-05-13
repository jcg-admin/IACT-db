---
title: DevOps Backend IACT
date: 2025-11-13
domain: backend
status: active
---

# DevOps Backend IACT

**Proposito**: Documentacion de operaciones y herramientas DevOps

## Contenido

- CLI y scripts operativos
- Workflows CI/CD
- Monitoring y observabilidad
- Incident response
- Runbooks

## Documentos Principales

- `CLI-SDLC-AUTOMATION.md`: CLI de agentes SDLC
- `ci-cd-workflows.md`: Workflows GitHub Actions
- `monitoring-setup.md`: Configuracion de monitoring
- `incident-response-playbook.md`: Playbook de incidentes
- `runbook-backend.md`: Runbook operacional

## Scripts Operativos

- `scripts/sdlc_agent.py`: CLI agentes SDLC
- `scripts/dora_metrics.py`: Metricas DORA
- `scripts/health_check.sh`: Health checks
- `scripts/deploy.sh`: Deployment
- `scripts/validate_*.sh`: Scripts de validacion

## Metrics DORA

- Deployment Frequency: Daily (target)
- Lead Time for Changes: <4 hours (target)
- MTTR: <1 hour (target)
- Change Failure Rate: <5% (target)

## Ownership

Maintainer: DevOps Team
Review: Tech Lead
