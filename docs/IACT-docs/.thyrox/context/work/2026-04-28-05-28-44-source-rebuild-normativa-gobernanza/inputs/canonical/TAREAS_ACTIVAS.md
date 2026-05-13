---
id: DOC-PROYECTO-tareas-ACTIVAS
tipo: task_tracking
categoria: planificacion
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: arquitecto-senior
relacionados: ["ROADMAP.md", "CHANGELOG.md"]
---

# TAREAS ACTIVAS - Proyecto IACT

Tareas de corto plazo (< 2 semanas) con seguimiento activo.

**Version:** 1.0.0
**Ultima actualizacion:** 2025-11-12
**Sprint actual:** Sprint 1 (2025-11-06 a 2025-11-19)

---

## Leyenda

**Prioridad:**
- `P0` - CRITICA (bloquea deploy)
- `P1` - ALTA (sprint actual)
- `P2` - MEDIA (próximo sprint)
- `P3` - BAJA (backlog)

**Estado:**
- `[ ]` - Pendiente
- `[>]` - En progreso
- `[x]` - Completado
- `[!]` - Bloqueado

**Story Points:** Fibonacci (1, 2, 3, 5, 8, 13, 21)

---

## P0 - CRITICO (Sprint Actual)

### Validacion y Testing

- [ ] **Ejecutar suite completa de tests** `P0` `2SP`
  - Comando: `./scripts/run_all_tests.sh`
  - Objetivo: Coverage >= 80%
  - Asignado: @backend-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-07

- [ ] **Validar restricciones criticas** `P0` `1SP`
  - Comando: `./scripts/validate_critical_restrictions.sh`
  - Verificar: RNF-002 (NO Redis), NO Email
  - Asignado: @backend-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-07

- [ ] **Verificar SESSION_ENGINE en settings** `P0` `1SP`
  - Grep: `grep SESSION_ENGINE api/callcentersite/*/settings*.py`
  - Debe ser: `django.contrib.sessions.backends.db`
  - Asignado: @backend-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-07

### Frontend - Continuidad operativa

- [x] **Fallback de configuración AppConfigService** `P0` `2SP`
  - `ui/src/services/config/AppConfigService.js`
  - Tests: `AppConfigService.test.js`, cobertura ≥80 %
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

- [x] **Menú dinámico con PermissionsService** `P0` `3SP`
  - `ui/src/components/MainLayout.jsx` consume permisos normalizados
  - Tests: `MainLayout.test.jsx`, `PermissionsService.test.js`
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

- [x] **CallsService resiliente + métricas en dashboard** `P0` `5SP`
  - Hook `useCallsSummary` integra fallback de llamadas
  - Tests: `CallsService.test.js`, `useCallsSummary.test.js`, `HomeModule.test.jsx`
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

- [x] **Indicadores visuales de datos simulados** `P0` `3SP`
  - Banner `MockDataNotice` y avisos en widgets
  - Tests: `App.test.jsx`
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

### Testing Especifico

- [ ] **Tests de auditoria inmutable (TEST-AUDIT-002)** `P0` `2SP`
  - Archivo: `api/callcentersite/tests/audit/test_audit_log.py`
  - Comando: `pytest tests/audit/test_audit_log.py -v`
  - Validar: ISO 27001 compliance
  - Asignado: @backend-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-08


### Documentacion de Tareas

- [x] **Documentar TASK-001 a TASK-006** `P1` `3SP`
  - Archivos creados: 6 TASK-*.md con frontmatter YAML
  - Ubicaciones: docs/qa/, docs/arquitectura/, docs/proyecto/
  - Status: COMPLETADO 2025-11-12
  - Asignado: @copilot
  - Coverage: 82.9% de tareas del PLAN documentadas



---

## P1 - ALTA PRIORIDAD (Sprint Actual)

### Scripts Shell

- [x] **Implementar run_all_tests.sh** `P1` `3SP`
  - Suite completa: backend + frontend + security + coverage
  - Script: `scripts/run_all_tests.sh`
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

- [x] **Implementar health_check.sh** `P1` `2SP`
  - Validar: API, PostgreSQL, MySQL, SESSION_ENGINE
  - Script: `scripts/health_check.sh`
  - Output: JSON y texto
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

- [x] **Implementar cleanup_sessions.sh** `P1` `2SP`
  - Limpieza django_session en MySQL
  - Script: `scripts/cleanup_sessions.sh`
  - Features: dry-run, stats, alert si > 100K
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

- [x] **Implementar deploy.sh** `P1` `5SP`
  - Deploy automatizado con backup y rollback
  - Script: `scripts/deploy.sh`
  - Environments: dev, staging, production
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

### Documentacion

- [ ] **Validar estructura de docs/** `P1` `1SP`
  - Comando: `./scripts/validar_estructura_docs.sh`
  - Verificar: No broken links, no referencias obsoletas
  - Asignado: @tech-writer
  - Bloqueadores: Ninguno
  - ETA: 2025-11-09

- [x] **Migrar contenido de docs_legacy/** `P1` `13SP`
  - Total: 118 archivos migrados
  - INDICE.md: v1.3.0
  - Estructura: BABOK v3 completa
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

### Frontend - Arquitectura

- [x] **Factoría resiliente y telemetría de mocks** `P1` `5SP`
  - `createResilientService`, `mockUsageTracker` y pruebas dedicadas
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

- [x] **Gestión centralizada de mocks + script de snapshots** `P1` `3SP`
  - `src/mocks/{registry,schemas,metadata}.js` + `npm run mocks:refresh`
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

- [x] **Flags `UI_BACKEND_*` y build aware** `P1` `2SP`
  - `backendIntegrity.js`, `webpack.config.cjs` y pruebas de toggles
  - Status: COMPLETADO 2025-11-09
  - Asignado: @equipo-frontend

### DORA Metrics

- [ ] **Ejecutar primer DORA metrics report** `P1` `1SP`
  - Comando: `python scripts/dora_metrics.py --repo 2-Coatl/IACT---project --days 30 --format markdown`
  - Output: `DORA_REPORT_20251106.md`
  - Establecer baseline
  - Asignado: @devops-lead
  - Bloqueadores: Necesita GITHUB_TOKEN
  - ETA: 2025-11-08

- [ ] **Configurar cron job para DORA metrics mensuales** `P1` `1SP`
  - Cron: `0 0 1 * * python scripts/dora_metrics.py --days 30 > /var/log/iact/dora_$(date +%Y%m).md`
  - Asignado: @devops-lead
  - Bloqueadores: DORA report inicial
  - ETA: 2025-11-09

### AI Excellence (DORA 2025)

- [x] **Estrategia de IA completa (DORA Report 2025)** `P1` `5SP`
  - docs/gobernanza/ai/ESTRATEGIA_IA.md
  - 7 practicas DORA AI Capabilities implementadas
  - Stance de IA del proyecto definida
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

- [x] **Checklist AI Capabilities** `P1` `2SP`
  - docs/gobernanza/ai/AI_CAPABILITIES.md
  - Checklist diario para developers, tech leads, arquitectos, QA
  - Metricas rapidas (adoption, productivity, quality)
  - Status: COMPLETADO 2025-11-06
  - Asignado: @arquitecto-senior

- [ ] **Comunicar AI stance al equipo** `P1` `1SP`
  - Presentacion de ESTRATEGIA_IA.md
  - Guidelines de cuando usar/no usar IA
  - Q&A session
  - Asignado: @arquitecto-senior
  - Bloqueadores: Ninguno
  - ETA: 2025-11-08

- [ ] **Agregar AI guidelines a onboarding** `P2` `2SP`
  - Actualizar onboarding guide con ESTRATEGIA_IA
  - Checklist AI_CAPABILITIES en proceso onboarding
  - Asignado: @tech-lead
  - Bloqueadores: Comunicacion al equipo
  - ETA: 2025-11-15

---

## P2 - MEDIA PRIORIDAD (Próximo Sprint)

### Pre-commit Hooks

- [ ] **Configurar pre-commit hooks** `P2` `2SP`
  - Comando: `./scripts/install_hooks.sh`
  - Validaciones: NO Redis, NO email, lint, format
  - Asignado: @devops-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-15

### Monitoring

- [ ] **Implementar sistema de metrics interno (MySQL)** `P2` `8SP`
  - Tabla metrics en MySQL
  - Django models para metrics
  - Scripts de collection
  - Asignado: @backend-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-20

- [ ] **Custom dashboards en Django Admin** `P2` `5SP`
  - Dashboard para Dev, DevOps, PO
  - Visualizacion de metrics
  - Alerts via InternalMessage
  - Asignado: @backend-lead
  - Bloqueadores: Sistema de metrics
  - ETA: 2025-11-25

### CI/CD

- [ ] **Mejorar backend-ci.yml con coverage report** `P2` `2SP`
  - Upload coverage a artifact
  - Comment en PR con coverage
  - Asignado: @devops-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-18

- [ ] **Implementar security-scan en PR checks** `P2` `2SP`
  - Ejecutar en cada PR
  - Bloquear merge si critical vulnerabilities
  - Asignado: @devops-lead
  - Bloqueadores: Ninguno
  - ETA: 2025-11-18

### Database Maintenance

- [ ] **Configurar cron jobs para maintenance** `P2` `1SP`
  - Cleanup sessions cada 6 horas
  - Health check cada 5 minutos
  - Cron entries en sistema
  - Asignado: @devops-lead
  - Bloqueadores: Scripts completados
  - ETA: 2025-11-12

---

## P3 - BAJA PRIORIDAD (Backlog)

### Analytics Service

- [ ] **Implementar analytics_portal_setup.sh** `P3` `3SP`
  - Portal interno de analytics
  - Templates de solicitudes comunes
  - Asignado: Pendiente
  - ETA: TBD

- [ ] **Implementar process_analytics_request.sh** `P3` `5SP`
  - Automatizar processing de requests
  - Notificacion via InternalMessage
  - Asignado: Pendiente
  - ETA: TBD

### Agentes SDLC Mejoras

- [ ] **Mejorar SDLCPlannerAgent con LLM real** `P3` `8SP`
  - Integracion Anthropic/OpenAI
  - Mejores user stories
  - Mejor estimacion de story points
  - Asignado: Pendiente
  - ETA: TBD

- [ ] **Dashboard web para agentes SDLC** `P3` `21SP`
  - Visualizacion de pipeline
  - Metricas en tiempo real
  - Asignado: Pendiente
  - ETA: TBD

---

## Bloqueados

*No hay tareas bloqueadas actualmente*

---

## Completados Recientemente (Ultimos 7 dias)

### 2025-11-06

- [x] **Sistema SDLC con 7 agentes implementado** `13SP`
  - sdlc_planner, feasibility, design, testing, deployment, orchestrator
  - Documentacion: docs/gobernanza/procesos/AGENTES_SDLC.md

- [x] **8 Workflows CI/CD operativos** `13SP`
  - backend-ci, frontend-ci, test-pyramid, deploy, migrations, security-scan, incident-response, infrastructure-ci
  - Documentacion: docs/gobernanza/ci_cd/INDICE.md

- [x] **Sistema de asociacion workflow-template** `8SP`
  - .claude/workflow_template_mapping.json
  - scripts/generate_workflow_from_template.py
  - docs/gobernanza/procesos/MAPEO_PROCESOS_TEMPLATES.md v1.1.0

- [x] **Migracion completa docs_legacy -> docs** `13SP`
  - 118 archivos migrados
  - INDICE.md v1.3.0
  - Estructura BABOK v3

- [x] **4 Scripts shell core** `12SP`
  - run_all_tests.sh
  - health_check.sh
  - cleanup_sessions.sh
  - deploy.sh

- [x] **Estructura moderna de tracking** `5SP`
  - docs/proyecto/ROADMAP.md
  - docs/proyecto/TAREAS_ACTIVAS.md
  - docs/proyecto/CHANGELOG.md

**Total Story Points completados:** 64 SP

---

## Metricas del Sprint Actual

**Sprint 1 (2025-11-06 a 2025-11-19)**

- **Velocity estimada:** 20-30 SP (2 devs)
- **Story Points comprometidos:** 15 SP (P0 + P1)
- **Story Points completados:** 64 SP (sprint anterior)
- **Story Points pendientes:** 15 SP

**Burndown:**
```
Day 1 (2025-11-06): 64 SP completados
Day 2 (2025-11-07): 15 SP pendientes (objetivo)
...
```

---

## Notas del Sprint

### Decisiones Tomadas
1. Eliminar Prometheus/Grafana de roadmap (violan RNF-002)
2. Usar MySQL para metrics internos
3. Dashboards en Django Admin en lugar de herramientas externas
4. Alert rules via scripts shell + InternalMessage

### Riesgos Identificados
1. **Session table growth:** Mitigation via cleanup_sessions.sh cada 6 horas
2. **Coverage drift:** Mitigation via CI/CD bloquea merge si < 80%
3. **GITHUB_TOKEN faltante:** Bloqueador para DORA metrics - obtener token

### Aprendizajes
1. Migracion exitosa de 118 archivos sin perder contenido
2. Sistema de asociacion workflow-template muy util
3. Scripts shell core completos facilitan automation

---

## Proximos Pasos (Semana 2025-11-11)

1. Completar todas las tareas P0 (4 tareas, 6 SP)
2. Ejecutar primer DORA metrics report
3. Configurar cron jobs para maintenance
4. Iniciar trabajo en monitoring interno (MySQL metrics)

---

## Referencias

### Documentacion
- [ROADMAP](ROADMAP.md) - Vision a largo plazo
- [CHANGELOG](CHANGELOG.md) - Historial completo
- [INDICE General](../INDICE.md)

### Scripts
- `scripts/run_all_tests.sh` - Suite completa de tests
- `scripts/health_check.sh` - Health check del sistema
- `scripts/cleanup_sessions.sh` - Limpieza de sesiones
- `scripts/deploy.sh` - Deploy automatizado

### Workflows
- `.github/workflows/backend-ci.yml`
- `.github/workflows/test-pyramid.yml`
- `.github/workflows/security-scan.yml`

---

## Actualizacion

**Frecuencia:** Diaria (standup)

**Responsable:** @arquitecto-senior o Scrum Master

**Proceso:**
1. Mover tareas completadas a seccion "Completados"
2. Actualizar estado de tareas en progreso
3. Identificar bloqueadores
4. Actualizar ETAs si necesario
5. Commit: `docs(tareas): actualizar TAREAS_ACTIVAS.md - [fecha]`

**Proxima actualizacion:** 2025-11-07

---

**Mantenedor:** @arquitecto-senior
**Ultima actualizacion:** 2025-11-06
**Version:** 1.0.0
