---
id: PROC-DEV-002
tipo: proceso
categoria: desarrollo
subcategoria: sdlc
estado: activo
version: 1.0.0
fecha_creacion: 2025-11-06
autor: arquitecto-senior
relacionados: ["PROC-001", "ADR-003"]
---

# Proceso SDLC del Proyecto IACT

## Introducci?n

Este documento define el **Software Development Life Cycle (SDLC)** oficial para el proyecto IACT. Todo desarrollo de software, cambios en infraestructura, y modificaciones significativas deben seguir este proceso.

## Modelo SDLC Adoptado

**Modelo**: **Agile + DevOps Hybrid**

**Justificaci?n**:
- Proyecto complejo con requisitos cambiantes -> Agile
- Necesidad de CI/CD y deployment continuo -> DevOps
- Compliance ISO 27001 requiere documentaci?n -> Documentaci?n formal
- Equipo distribuido -> Necesita sprints y ceremonias claras

---

## Las 7 Fases del SDLC en IACT

```
+---------------------------------------------------------+
|                   SDLC LIFECYCLE                         |
|                                                          |
|  +----------+   +----------+   +----------+           |
|  | Planning |-->|Feasibility|-->|  Design  |           |
|  +----------+   +----------+   +----------+           |
|       |              |               |                  |
|       ?              ?               ?                  |
|  +----------+   +----------+   +----------+           |
|  |Implement |<--|  Testing |<--| Deploy   |           |
|  +----------+   +----------+   +----------+           |
|       |                              |                  |
|       +--------------+---------------+                  |
|                      ?                                  |
|               +--------------+                          |
|               | Maintenance  |                          |
|               +--------------+                          |
+---------------------------------------------------------+
```

---

## Fase 1: Planning (Planificaci?n)

### Objetivo
Definir **QU?** se va a construir y **POR QU?**.

### Actividades

#### 1.1 Creaci?n de Issues/Tickets
Toda feature, bug fix, o mejora debe tener un issue/ticket.

**Herramienta**: GitHub Issues (para features t?cnicas) o Jira (para features de negocio)

**Template de Issue**:
```markdown
## User Story
Como [rol], quiero [funcionalidad] para [beneficio]

## Acceptance Criteria
- [ ] Criterio 1
- [ ] Criterio 2
- [ ] Criterio 3

## Technical Requirements
- Stack: [Django/React/Terraform]
- Dependencies: [otras issues]
- Affected components: [authentication, users, etc.]

## Estimation
Story Points: [1, 2, 3, 5, 8, 13]

## Priority
[P0-Critical, P1-High, P2-Medium, P3-Low]

## Labels
[feature, bug, enhancement, documentation, infrastructure]
```

#### 1.2 Sprint Planning
**Frecuencia**: Cada 2 semanas (Sprint de 10 d?as laborables)

**Participantes**:
- Product Owner
- Scrum Master / Tech Lead
- Development Team

**Actividades**:
1. Revisar backlog priorizado
2. Seleccionar issues para el sprint
3. Estimar story points (Planning Poker)
4. Definir Sprint Goal
5. Crear tareas t?cnicas si es necesario

**Output**:
- Sprint Backlog definido
- Sprint Goal claro
- Capacidad del equipo (velocity) considerada

#### 1.3 Documentaci?n de Requisitos
**Para features P0/P1**: Crear documento de requisitos formal.

**Template**: `docs/requisitos/funcionales/rfXXX_nombre_feature.md`

**Contenido**:
```markdown
---
id: RF-XXX
tipo: requisito_funcional
prioridad: HIGH
estado: aprobado
owner: product-owner
relacionados: [N-XXX, RN-XXX]
---

# RF-XXX: Nombre del Requisito

## Descripci?n
[Descripci?n detallada]

## Justificaci?n de Negocio
[Por qu? es necesario]

## Criterios de Aceptaci?n
1. [Criterio 1]
2. [Criterio 2]

## Casos de Uso
### UC-1: Flujo Principal
...

## Dependencias
- [Otros requisitos]

## Riesgos
- [Riesgos identificados]
```

### Artefactos Generados
-  Issues/tickets en sistema de gesti?n
-  Sprint Backlog
-  Documentos de requisitos (para features grandes)
-  Estimaciones de esfuerzo

### Responsable
- **Product Owner**: Priorizaci?n
- **Tech Lead**: Estimaci?n t?cnica
- **Scrum Master**: Facilitaci?n

---

## Fase 2: Feasibility Analysis (An?lisis de Viabilidad)

### Objetivo
Determinar si el proyecto es **VIABLE** t?cnica, econ?mica y operativamente.

### Actividades

#### 2.1 Technical Feasibility
**Preguntas clave**:
- ?Tenemos la tecnolog?a necesaria?
- ?El equipo tiene las skills requeridas?
- ?Es compatible con nuestra arquitectura actual?
- ?Existen limitaciones t?cnicas?

**Output**: Documento de viabilidad t?cnica

#### 2.2 Risk Assessment
Usar matriz de riesgos:

| Riesgo | Probabilidad | Impacto | Severidad | Mitigaci?n |
|--------|--------------|---------|-----------|------------|
| Falta de tests | Alta | Alto | **CR?TICO** | Sprint dedicado de testing |
| CI/CD falla | Media | Alto | ALTO | Testing en staging primero |
| Equipo no conoce tech | Baja | Medio | MEDIO | Training antes de implementar |

**Severidad**: Probabilidad x Impacto

#### 2.3 Cost-Benefit Analysis
**Costo**:
- Horas de desarrollo (story points x velocity)
- Infraestructura adicional
- Licencias/herramientas

**Beneficio**:
- Reducci?n de tiempo de desarrollo futuro
- Mejora de calidad
- Compliance/seguridad
- ROI estimado

#### 2.4 Go/No-Go Decision
**Decision Makers**: Tech Lead + Product Owner + Arquitecto

**Criterios**:
-  Viabilidad t?cnica confirmada
-  Riesgos mitigables
-  ROI positivo
-  Recursos disponibles

### Artefactos Generados
-  Documento de viabilidad t?cnica
-  Risk assessment matrix
-  Cost-benefit analysis
-  Go/No-Go decision documentada

### Responsable
- **Arquitecto Senior**: Viabilidad t?cnica
- **Tech Lead**: Risk assessment
- **Product Owner**: Cost-benefit

---

## Fase 3: System Design (Dise?o del Sistema)

### Objetivo
Definir **C?MO** se va a construir la soluci?n.

### Actividades

#### 3.1 High-Level Design (HLD)
**Contenido**:
- Arquitectura general del sistema
- Componentes principales
- Interacciones entre componentes
- Tecnolog?as a utilizar
- Decisiones de arquitectura (ADRs)

**Output**: Documento HLD en `docs/arquitectura/diseno/HLD_feature_name.md`

#### 3.2 Low-Level Design (LLD)
**Contenido**:
- Especificaciones detalladas de cada componente
- Modelos de datos (schemas, ER diagrams)
- APIs (endpoints, payloads, responses)
- Algoritmos cr?ticos
- Diagramas de flujo
- Diagramas de secuencia

**Output**: Documento LLD en `docs/arquitectura/diseno/LLD_feature_name.md`

#### 3.3 Architecture Decision Records (ADRs)
Para decisiones significativas, crear ADR:

**Template**: `docs/adr/ADR_XXX_decision_title.md`

```markdown
---
id: ADR-XXX
status: accepted
date: 2025-11-XX
---

# ADR-XXX: [Decision Title]

## Context
[Por qu? necesitamos tomar esta decisi?n]

## Decision
[Qu? decidimos hacer]

## Alternatives Considered
1. [Opci?n A] - Pros/Cons
2. [Opci?n B] - Pros/Cons

## Consequences
- Positive: ...
- Negative: ...
- Risks: ...
```

#### 3.4 Design Review
**Participantes**:
- Arquitecto Senior (obligatorio)
- Tech Lead
- Developers involucrados
- Security Engineer (para features sensibles)

**Checklist**:
- [ ] Dise?o alineado con requisitos
- [ ] Considera casos edge
- [ ] Escalabilidad evaluada
- [ ] Seguridad considerada
- [ ] Performance considerada
- [ ] Mantenibilidad considerada
- [ ] Documentaci?n clara y completa

### Artefactos Generados
-  HLD document
-  LLD document
-  ADRs (si aplica)
-  Diagramas (arquitectura, flujo, secuencia)
-  Design review approved

### Responsable
- **Arquitecto Senior**: Design review y aprobaci?n
- **Tech Lead**: HLD y coordinaci?n
- **Developers**: LLD de componentes asignados

---

## Fase 4: Implementation (Implementaci?n)

### Objetivo
Construir la soluci?n siguiendo el dise?o aprobado.

### Actividades

#### 4.1 Development Environment Setup
Antes de codear, asegurar:
-  Branch creada desde `develop` o `main`
-  Dependencias instaladas
-  Tests existentes pasan
-  Linters/formatters configurados

**Naming Convention**:
```bash
feature/ISSUE-123-short-description
bugfix/ISSUE-456-bug-description
hotfix/critical-security-fix
```

#### 4.2 Coding Standards
**Seguir**:
- PEP 8 para Python
- ESLint + Prettier para JavaScript/React
- Black + isort para Python
- Type hints en Python (mypy)
- PropTypes en React

**Documentaci?n de c?digo**:
```python
def function_name(param1: str, param2: int) -> bool:
    """
    Brief description.

    Args:
        param1: Description of param1
        param2: Description of param2

    Returns:
        Description of return value

    Raises:
        ValueError: When validation fails
    """
    pass
```

#### 4.3 Atomic Commits
**Regla**: 1 commit = 1 cambio l?gico

**Mensaje de commit** (Conventional Commits):
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: Nueva feature
- `fix`: Bug fix
- `docs`: Solo documentaci?n
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Refactoring sin cambio de funcionalidad
- `test`: Agregar tests
- `chore`: Mantenimiento, dependencies, etc.

**Ejemplo**:
```
feat(authentication): agregar bloqueo por intentos fallidos

Implementa RF-003: Bloqueo de cuenta despu?s de 5 intentos
fallidos en 15 minutos.

- LoginAttemptService.count_recent_failures()
- L?gica de bloqueo en AuthenticationService
- Tests unitarios para bloqueo

Closes #123
```

#### 4.4 Test-Driven Development (TDD)
**Proceso**:
1.  Escribir test que falla (RED)
2.  Escribir c?digo m?nimo para pasar test (GREEN)
3.  Refactorizar manteniendo tests verdes (REFACTOR)

**Coverage target**: 80% para c?digo nuevo

#### 4.5 Code Review Process
**Antes de crear PR**:
- [ ] C?digo sigue standards
- [ ] Tests escritos y pasan
- [ ] Documentaci?n actualizada
- [ ] No hay secretos/passwords hardcodeados
- [ ] Linters pasan
- [ ] Build local exitoso

**Pull Request Template**:
```markdown
## Description
[Descripci?n de los cambios]

## Related Issue
Closes #123

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## How Has This Been Tested?
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review performed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No new warnings generated
- [ ] Dependent changes merged

## Screenshots (if applicable)
[Screenshots]
```

**Code Review Checklist** (Reviewer):
- [ ] C?digo legible y mantenible
- [ ] L?gica correcta
- [ ] Tests adecuados
- [ ] Sin vulnerabilidades de seguridad
- [ ] Performance aceptable
- [ ] Documentaci?n suficiente
- [ ] Alineado con dise?o aprobado

**Approval Required**:
- 1 aprobaci?n m?nimo
- Para c?digo cr?tico (authentication, audit, payments): 2 aprobaciones + arquitecto

### Artefactos Generados
-  C?digo funcional
-  Tests (unit + integration)
-  Commits at?micos con mensajes claros
-  Pull Request con descripci?n completa
-  Code review aprobado

### Responsable
- **Developers**: Implementaci?n y tests
- **Tech Lead**: Code reviews
- **Arquitecto**: Review de cambios arquitect?nicos

---

## Fase 5: Testing (Pruebas)

### Objetivo
Verificar que el software funciona correctamente y cumple requisitos.

### Niveles de Testing

#### 5.1 Unit Testing
**Objetivo**: Testear componentes individuales aisladamente.

**Herramientas**: pytest (Python), Jest (JavaScript)

**Est?ndar**: Coverage >= 80%

**Ejecutar**:
```bash
pytest api/callcentersite/tests/ --cov --cov-report=html
```

#### 5.2 Integration Testing
**Objetivo**: Testear interacci?n entre componentes.

**Herramientas**: pytest con fixtures, Docker Compose

**Ejemplo**: Test de authentication + users + audit juntos

#### 5.3 End-to-End (E2E) Testing
**Objetivo**: Testear flujos completos de usuario.

**Herramientas**: Cypress, Playwright, Selenium

**Ejemplo**: Login -> Dashboard -> Create Campaign -> Logout

#### 5.4 Performance Testing
**Objetivo**: Verificar que cumple requisitos de performance.

**Herramientas**: Locust, JMeter, k6

**M?tricas**:
- Response time < 500ms (p95)
- Throughput >= 100 req/s
- Error rate < 1%

#### 5.5 Security Testing
**Objetivo**: Identificar vulnerabilidades.

**Actividades**:
- SAST (Static): Bandit, Safety, npm audit
- DAST (Dynamic): OWASP ZAP
- Dependency scanning: Dependabot, Snyk
- Secret scanning: GitGuardian, TruffleHog

#### 5.6 Acceptance Testing (UAT)
**Objetivo**: Validar que cumple criterios de aceptaci?n.

**Responsable**: Product Owner + Stakeholders

**Proceso**:
1. Deploy a staging
2. Stakeholders ejecutan test cases
3. Sign-off si cumple criterios
4. Reportar bugs si no cumple

### Test Automation
**CI/CD Pipeline ejecuta**:
```yaml
on: [push, pull_request]
jobs:
  test:
    - Linting
    - Unit tests
    - Integration tests
    - Security scans
    - Coverage report
```

### Artefactos Generados
-  Test suites (unit, integration, E2E)
-  Coverage reports (>=80%)
-  Performance test results
-  Security scan reports
-  UAT sign-off

### Responsable
- **Developers**: Unit + integration tests
- **QA Engineer**: E2E, performance, coordinar UAT
- **Security Engineer**: Security testing
- **Product Owner**: UAT approval

---

## Fase 6: Deployment (Despliegue)

### Objetivo
Llevar el software a producci?n de forma segura y controlada.

### Estrategias de Deployment

#### 6.1 Deployment a Staging
**Antes de producci?n, siempre staging.**

```bash
# Deploy a staging
git checkout main
git pull origin main
git merge --no-ff feature/ISSUE-123
./scripts/deploy_staging.sh
```

**Validaciones en staging**:
- [ ] Smoke tests pasan
- [ ] E2E tests pasan
- [ ] Performance aceptable
- [ ] No hay errores en logs
- [ ] UAT aprobado

#### 6.2 Deployment Strategies

**Opci?n A: Blue-Green Deployment**
- Deploy a "green" environment (idle)
- Validar green
- Switch traffic: blue -> green
- Rollback r?pido si falla: green -> blue

**Opci?n B: Canary Deployment**
- Deploy a 5% de tr?fico
- Monitor metrics
- Si OK, gradualmente 10% -> 25% -> 50% -> 100%
- Rollback si m?tricas empeoran

**Opci?n C: Rolling Deployment**
- Deploy a 1 nodo/pod
- Validar
- Deploy al siguiente
- Repetir hasta completar cluster

**Opci?n seleccionada para IACT**: **Canary** (para features grandes), **Rolling** (para bug fixes)

#### 6.3 Deployment Checklist
Pre-deployment:
- [ ] All tests passing en CI/CD
- [ ] Code review aprobado
- [ ] Staging validado
- [ ] UAT sign-off
- [ ] Rollback plan documentado
- [ ] Database migrations revisadas (si aplica)
- [ ] Feature flags configurados (si aplica)
- [ ] Monitoring/alerting configurado

Durante deployment:
- [ ] Ejecutar deployment script
- [ ] Monitor logs en tiempo real
- [ ] Verificar health checks
- [ ] Ejecutar smoke tests post-deploy

Post-deployment:
- [ ] Verificar m?tricas (error rate, latency)
- [ ] Verificar funcionalidad cr?tica
- [ ] Monitor por 24h
- [ ] Documentar deployment

#### 6.4 Rollback Plan
**Si algo falla**:
```bash
# Rollback inmediato
./scripts/rollback_to_previous_version.sh

# O via feature flag
curl -X POST /api/feature-flags/disable \
  -d '{"flag": "new_authentication"}'
```

**Triggers para rollback**:
- Error rate > 5%
- Latency p95 > 2x normal
- Critical bug descubierto
- Database corruption

### Artefactos Generados
-  Deployment plan
-  Rollback plan
-  Deployment logs
-  Post-deployment validation report

### Responsable
- **DevOps Engineer**: Ejecutar deployment
- **Tech Lead**: Aprobar deployment
- **SRE**: Monitoring durante deployment

---

## Fase 7: Maintenance (Mantenimiento)

### Objetivo
Mantener el software funcional, actualizado y seguro post-deployment.

### Actividades

#### 7.1 Monitoring y Alerting
**M?tricas clave**:
- **Golden Signals**: Latency, Traffic, Errors, Saturation
- **Business metrics**: Users activos, Conversi?n, Revenue
- **Infrastructure**: CPU, Memory, Disk, Network

**Herramientas**:
- Application: Sentry, New Relic, Datadog
- Infrastructure: Prometheus + Grafana
- Logs: ELK Stack, CloudWatch

**Alerting**:
```yaml
alerts:
  - name: HighErrorRate
    condition: error_rate > 5%
    severity: P1
    notification: [#incidents, on-call-engineer]

  - name: HighLatency
    condition: p95_latency > 1000ms
    severity: P2
    notification: [#performance]
```

#### 7.2 Incident Response
**Severidad**:
- **P0 (Critical)**: Sistema completamente ca?do -> Response: <15 min
- **P1 (High)**: Funcionalidad cr?tica afectada -> Response: <1 hour
- **P2 (Medium)**: Funcionalidad no cr?tica afectada -> Response: <4 hours
- **P3 (Low)**: Issue menor -> Response: <24 hours

**Proceso**:
1. Alerta recibida
2. On-call engineer investiga
3. Si P0/P1: Escalar a Tech Lead
4. Mitigar (rollback, feature flag, hotfix)
5. Post-mortem (para P0/P1)

#### 7.3 Bug Fixes
**Process**:
```
Bug report -> Triage -> Priority -> Sprint planning -> Fix -> Deploy
```

**Hotfix process** (para P0):
```bash
git checkout main
git checkout -b hotfix/critical-security-fix
# Fix bug
# Test
git push
# Fast-track PR review
# Deploy ASAP
```

#### 7.4 Updates y Patches
**Tipos**:
- Security patches: Deploy ASAP (< 24h para critical)
- Dependency updates: Monthly
- Feature enhancements: Normal sprint cycle

#### 7.5 Documentation Updates
Mantener docs actualizada:
- [ ] Arquitectura docs
- [ ] API docs
- [ ] Runbooks
- [ ] User guides

#### 7.6 Post-Mortem (para incidents P0/P1)
**Template**:
```markdown
# Post-Mortem: [Incident Title]

## Summary
[Brief description]

## Timeline
- 10:00 AM: Incident detected
- 10:05 AM: On-call paged
- 10:15 AM: Root cause identified
- 10:30 AM: Fix deployed
- 11:00 AM: Incident resolved

## Root Cause
[Technical explanation]

## Impact
- Duration: 1 hour
- Users affected: 1,200
- Revenue lost: $X

## What Went Well
- Fast detection
- Clear runbook followed

## What Went Wrong
- No monitoring alert
- Rollback took too long

## Action Items
- [ ] Add monitoring for X
- [ ] Improve rollback script
- [ ] Update runbook

## Lessons Learned
[Key takeaways]
```

### Artefactos Generados
-  Monitoring dashboards
-  Alert configurations
-  Incident reports
-  Post-mortems
-  Runbooks actualizados

### Responsable
- **SRE/DevOps**: Monitoring, incident response
- **On-call Engineer**: First responder
- **Tech Lead**: Escalation, post-mortems

---

## Integraciones con Herramientas

### GitHub
- Issues para planning
- Projects para sprint tracking
- Pull Requests para code review
- Actions para CI/CD

### Jira (opcional)
- Epics para features grandes
- Stories para user stories
- Sprints para planning

### CI/CD
- GitHub Actions (actual)
- GitLab CI (alternativa)
- Jenkins (legacy, deprecar)

### Monitoring
- Sentry para errors
- Prometheus + Grafana para metrics
- ELK para logs

---

## Roles y Responsabilidades

| Rol | Planning | Feasibility | Design | Implementation | Testing | Deployment | Maintenance |
|-----|----------|-------------|--------|----------------|---------|------------|-------------|
| **Product Owner** | Lead | Review | Review | - | UAT | Approval | Prioritize bugs |
| **Arquitecto** | Consult | Technical Lead | Lead | Review | Review | Approval | Escalation |
| **Tech Lead** | Estimate | Lead | Review | Review + Merge | Review | Lead | On-call rotation |
| **Developer** | Contribute | - | LLD | Lead | Lead | Support | Bug fixes |
| **QA Engineer** | Contribute | - | - | - | Lead | Validate | Test automation |
| **DevOps/SRE** | Infra planning | Infra assess | Infra design | - | Infra tests | Lead | Lead |
| **Security** | Security reqs | Security risk | Security review | Review | Security tests | Review | Vulnerability mgmt |

---

## M?tricas y KPIs

### Sprint Metrics
- **Velocity**: Story points completed per sprint
- **Burn-down chart**: Work remaining vs time
- **Sprint goal achievement**: % of sprint goals met

### Quality Metrics
- **Test coverage**: % of code covered by tests (target: >=80%)
- **Bug density**: Bugs per KLOC
- **Defect escape rate**: Bugs found in prod vs total bugs

### Deployment Metrics (DORA)
- **Deployment frequency**: How often we deploy (target: Daily)
- **Lead time for changes**: Commit to deploy time (target: <4 hours)
- **Mean time to recovery (MTTR)**: Time to recover from failure (target: <1 hour)
- **Change failure rate**: % of deployments causing incidents (target: <5%)

### Incident Metrics
- **Mean time to detect (MTTD)**: Time to detect incident (target: <5 min)
- **Mean time to resolve (MTTR)**: Time to resolve incident (target: P0 <1h, P1 <4h)

---

## Compliance y Auditor?a

### ISO 27001 Requirements
-  Todos los cambios documentados
-  Code reviews obligatorios
-  Tests obligatorios
-  Deployment aprobado
-  Audit trail completo (Git + AuditLog)

### SOC 2 Requirements
-  Change management process
-  Separation of duties (developer ? approver)
-  Security testing
-  Incident response

---

## Templates y Recursos

### Templates Disponibles
- `docs/plantillas/issue_template.md`
- `docs/plantillas/pr_template.md`
- `docs/plantillas/hld_template.md`
- `docs/plantillas/lld_template.md`
- `docs/plantillas/adr_template.md`
- `docs/plantillas/postmortem_template.md`

### Scripts de Automatizaci?n
- `scripts/create_issue.sh` - Crear issue desde CLI
- `scripts/start_sprint.sh` - Inicializar sprint
- `scripts/deploy_staging.sh` - Deploy a staging
- `scripts/deploy_production.sh` - Deploy a producci?n
- `scripts/rollback.sh` - Rollback a versi?n anterior

### Runbooks
- `docs/infraestructura/devops/runbooks/deployment.md`
- `docs/infraestructura/devops/runbooks/incident_response.md`
- `docs/infraestructura/devops/runbooks/rollback.md`

---

## Revisi?n y Mejora Continua

### Sprint Retrospectives
**Frecuencia**: Al final de cada sprint

**Formato**:
- What went well?
- What didn't go well?
- What can we improve?
- Action items

### Process Improvement
**Review de proceso SDLC**: Quarterly

**M?tricas a revisar**:
- Lead time
- Deployment frequency
- MTTR
- Developer satisfaction

**Ajustar proceso** bas?ndose en feedback y m?tricas.

---

## Excepciones y Escalaciones

### Hotfixes
**Pueden saltear algunas fases** para velocidad:
- Planning: Ticket creado pero no sprint
- Design: Dise?o r?pido, no formal
- Testing: Unit tests m?nimos, E2E post-deploy
- Deployment: Fast-track approval

**Pero NUNCA saltear**:
- Code review
- Security review (para security fixes)
- Rollback plan

### Escalaci?n
**Cuando proceso se bloquea**:
- Issue: Reportar a Tech Lead
- Tech Lead bloqueado: Escalar a Arquitecto
- Arquitecto bloqueado: Escalar a CTO

---

## Cambios a Este Documento

**Ownership**: Arquitecto Senior

**Cambios requieren**:
- Propuesta de cambio (PR)
- Review de Tech Leads
- Aprobaci?n de Arquitecto + CTO

**Historial de cambios**: Ver Git log de este archivo

---

**?ltima actualizaci?n**: 2025-11-06
**Versi?n**: 1.0
**Pr?xima revisi?n**: 2026-02-06 (Quarterly)
