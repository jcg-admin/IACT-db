---
id: DOC-PROYECTO-ROADMAP
tipo: roadmap
categoria: planificacion
version: 1.0.0
fecha_creacion: 2025-11-06
propietario: arquitecto-senior
relacionados: ["TAREAS_ACTIVAS.md", "CHANGELOG.md", "vision_y_alcance.md"]
---

# ROADMAP - Proyecto IACT

Vision estrategica y planificacion a largo plazo del proyecto IACT.

**Version:** 1.0.0
**Ultima actualizacion:** 2025-11-12
**Horizonte temporal:** Q4 2025 - Q2 2026

---

## Vision General

Transformar IACT en una plataforma robusta de gestion de call center con:
1. **Automatizacion SDLC completa** via agentes IA
2. **DevOps maduro** con CI/CD y observability
3. **Compliance total** con restricciones criticas (RNF-002, NO Redis)
4. **Documentacion living** integrada con workflows

---

## Q4 2025 (Octubre - Diciembre) - FUNDAMENTOS

### Objetivos Clave
- [x] Sistema SDLC con 7 agentes implementado
- [x] 8 workflows CI/CD operativos
- [x] Documentacion migrada y reorganizada (118 archivos)
- [x] Sistema de asociacion workflow-template
- [ ] Scripts shell core completados (4 pendientes)
- [x] Documentacion de tareas criticas TASK-001 a TASK-006 completada
- [ ] Coverage tests >= 80%
- [ ] Validacion completa de restricciones

### Entregables Q4
- [x] docs/ completamente migrado desde docs_legacy/
- [x] INDICE.md v1.3.0 con 118 archivos
- [x] .claude/workflow_template_mapping.json
- [x] scripts/generate_workflow_from_template.py
- [x] MAPEO_PROCESOS_TEMPLATES.md v1.1.0
- [ ] run_all_tests.sh
- [ ] deploy.sh
- [ ] health_check.sh
- [ ] cleanup_sessions.sh
- [x] Documentacion TASK-001 a TASK-006 (Sprint 1 critico)

### Metricas Q4
- **Documentacion:** 124 archivos (118 + 6 TASK), ~35,414 lineas
- **Agentes SDLC:** 7 implementados
- **Workflows CI/CD:** 8 operativos
- **Coverage objetivo:** >= 80%
- **DORA Metrics baseline:** Por establecer

---

## Q1 2026 (Enero - Marzo) - CONSOLIDACION

### Objetivos Clave
- [ ] Monitoring y observability (logs + metrics en MySQL)
- [ ] Analytics Service Management operativo
- [ ] Pre-commit hooks instalados y funcionando
- [ ] DORA metrics tracking mensual automatizado
- [ ] Todos los tests >= 80% coverage
- [ ] Incident response automatizado

### Entregables Q1
- [ ] Sistema de metrics interno (tabla MySQL)
- [ ] Custom dashboards en Django Admin
- [ ] Alert rules via scripts shell + InternalMessage
- [ ] Analytics portal interno (Django)
- [ ] Scripts de analytics automation
- [ ] Pre-commit hooks con validacion restricciones
- [ ] Cron jobs para maintenance

### Metricas Q1 (Objetivo)
- **Deployment Frequency:** >= 1/semana
- **Lead Time:** < 2 dias
- **Change Failure Rate:** < 15%
- **MTTR:** < 4 horas
- **Test Coverage:** >= 80%
- **Documentation coverage:** 100% de APIs publicas

---

## Q2 2026 (Abril - Junio) - OPTIMIZACION

### Objetivos Clave
- [ ] Self-healing infrastructure
- [ ] Predictive analytics para SDLC
- [ ] Automated capacity planning
- [ ] ML para call volume prediction
- [ ] Chaos engineering (GameDays)
- [ ] Portal web de auto-servicio analytics

### Entregables Q2
- [ ] Auto-recovery de services
- [ ] Auto-scaling inteligente
- [ ] Predictive bug detection
- [ ] Predictive delay warnings
- [ ] Resource forecasting automatico
- [ ] Cost optimization dashboard
- [ ] Analytics self-service portal

### Metricas Q2 (Objetivo)
- **Deployment Frequency:** >= 2/dia (Elite)
- **Lead Time:** < 1 dia (Elite)
- **Change Failure Rate:** < 5% (Elite)
- **MTTR:** < 1 hora (Elite)
- **Automation rate:** >= 90%
- **Manual toil:** < 10%

---

## Epicas Mayores

### EPICA-001: DevOps Maturity
**Duracion:** Q4 2025 - Q1 2026
**Story Points:** ~150 SP
**Estado:** 70% completado

**Componentes:**
- [x] CI/CD workflows (8/8)
- [x] Scripts shell core (5/9)
- [ ] Monitoring setup (0%)
- [ ] Incident response automation (0%)
- [ ] Capacity planning (0%)

**Criterios de exito:**
- DORA metrics nivel High o Elite
- 0 incidents por restricciones violadas
- <= 10% manual toil

---

### EPICA-002: SDLC Automation
**Duracion:** Q4 2025 (COMPLETADO)
**Story Points:** ~100 SP
**Estado:** 100% completado

**Componentes:**
- [x] 7 agentes SDLC implementados
- [x] Pipeline orchestration
- [x] Go/No-Go decisions automatizadas
- [x] Documentacion completa generada
- [x] CLI funcional

**Criterios de exito:**
- [x] Todos los agentes operativos
- [x] Documentacion >= 1000 lineas por agente
- [x] CLI con --help completo

---

### EPICA-003: Documentation Excellence
**Duracion:** Q4 2025 - Q1 2026
**Story Points:** ~80 SP
**Estado:** 90% completado

**Componentes:**
- [x] Migracion docs_legacy -> docs (118 archivos)
- [x] INDICE.md master v1.3.0
- [x] Integracion workflow-template
- [x] MAPEO_PROCESOS_TEMPLATES.md
- [x] Estructura BABOK v3 completa
- [ ] API documentation auto-generada
- [ ] Diagramas Mermaid en todos los procesos

**Criterios de exito:**
- [x] 100% documentos sin emojis
- [x] Estructura BABOK v3 completa
- [ ] 100% APIs documentadas
- [ ] 0 broken links

---

### EPICA-004: Analytics Service
**Duracion:** Q1 2026 - Q2 2026
**Story Points:** ~120 SP
**Estado:** 0% completado

**Componentes:**
- [ ] Portal interno de analytics
- [ ] Automation de requests
- [ ] Triage por SLA
- [ ] Templates de reports comunes
- [ ] ML para predictive analytics
- [ ] Self-service portal web

**Criterios de exito:**
- 80% requests automatizados
- SLA compliance >= 95%
- User satisfaction >= 4.5/5

---

### EPICA-005: Observability & Monitoring
**Duracion:** Q1 2026
**Story Points:** ~100 SP
**Estado:** 0% completado

**Componentes:**
- [ ] Sistema de metrics interno (MySQL)
- [ ] Logging estructurado (Python logging + archivos)
- [ ] Alert rules via scripts shell
- [ ] Incident response automation
- [ ] Dashboards Django Admin por rol (Dev, DevOps, PO)

**Criterios de exito:**
- MTTR < 4 horas
- 0 incidents sin alert
- 100% critical services monitored

---

### EPICA-006: AI Excellence (DORA 2025)
**Duracion:** Q4 2025 - Q2 2026
**Story Points:** ~60 SP
**Estado:** 70% completado

**Componentes:**
- [x] 7 Agentes SDLC implementados
- [x] Claude Code integration
- [x] Documentacion IA-accessible (118 archivos Markdown)
- [x] Sistema de asociacion workflow-template
- [x] Strong version control practices (Git + CODEOWNERS)
- [x] Metodologia small batches
- [x] ESTRATEGIA_IA.md (stance clara)
- [x] AI_CAPABILITIES.md (checklist diario)
- [ ] Sistema de metrics interno (AI-accessible data)
- [ ] Logging estructurado
- [ ] DORA metrics baseline establecida
- [ ] Platform API para agentes
- [ ] Risk calibration dashboard

**7 Practicas DORA AI Capabilities:**
- [x] 1. User-centric Focus (Templates, vision, trazabilidad)
- [x] 2. Strong Version Control (Git, CI/CD, CODEOWNERS)
- [ ] 3. AI-accessible Internal Data (Docs OK, faltan metrics)
- [x] 4. Working in Small Batches (Metodologia establecida)
- [x] 5. Clear + Communicated AI Stance (ESTRATEGIA_IA.md)
- [x] 6. Quality Internal Platform (Django + 8 workflows + 13 scripts)
- [ ] 7. Healthy Data Ecosystems (PostgreSQL+MySQL OK, faltan metrics)

**Criterios de exito:**
- [x] Score 7 practicas: >= 5/7 (actual: 5/7, 71%)
- [ ] Score 7 practicas: 7/7 (target Q1 2026)
- [ ] DORA Deployment Frequency: >= 1/dia (Q1 2026)
- [ ] Lead Time: < 2 dias (Q1 2026)
- [ ] Change Failure Rate: < 15% (Q1 2026)
- [ ] MTTR: < 4 horas (Q1 2026)

**Fuente:** [DORA Report 2025](https://dora.dev/dora-report-2025)

**Documentos de referencia:**
- [ESTRATEGIA_IA.md](../gobernanza/ai/ESTRATEGIA_IA.md) - Estrategia completa IA basada en DORA 2025
- [AI_CAPABILITIES.md](../gobernanza/ai/AI_CAPABILITIES.md) - Checklist diario 7 practicas DORA
- [FASES_IMPLEMENTACION_IA.md](../gobernanza/ai/FASES_IMPLEMENTACION_IA.md) - Metodologia 6 fases (144 SP, Q2 2026)
- [ANALISIS_GAPS_POST_DORA_2025.md](../gobernanza/ai/ANALISIS_GAPS_POST_DORA_2025.md) - Analisis detallado gaps (5/7 practicas, 29 SP para 100%)
- [GAPS_SUMMARY_QUICK_REF.md](../gobernanza/ai/GAPS_SUMMARY_QUICK_REF.md) - Quick reference gaps criticos (P0-P1, quick wins <3h)
- [DORA_SDLC_INTEGRATION_GUIDE.md](../gobernanza/ai/DORA_SDLC_INTEGRATION_GUIDE.md) - Guia integracion DORA + SDLC Agents
- [DORA_CASSANDRA_INTEGRATION.md](../gobernanza/ai/DORA_CASSANDRA_INTEGRATION.md) - Arquitectura 3 capas observabilidad

---

## Hitos Criticos

### Hito 1: DevOps Foundation Complete
**Fecha objetivo:** 2025-12-31
**Criterios:**
- [x] 8 workflows CI/CD operativos
- [ ] 9 scripts shell core completados
- [ ] Coverage >= 80%
- [ ] DORA metrics baseline establecida

**Dependencias:**
- Tests de auditoria (TEST-AUDIT-002)
- Validacion restricciones completa
- Session engine en MySQL validado

---

### Hito 2: Monitoring & Alerting Operational
**Fecha objetivo:** 2026-03-31
**Criterios:**
- [ ] Sistema de metrics interno operativo (MySQL)
- [ ] 10+ alert rules configuradas (scripts shell)
- [ ] Incident response automatizado
- [ ] DORA metrics tracking mensual

**Dependencias:**
- Hito 1 completado
- Infrastructure stable
- Incident response workflows definidos

---

### Hito 3: Analytics Service Live
**Fecha objetivo:** 2026-06-30
**Criterios:**
- [ ] Portal interno operativo
- [ ] 80% automation rate
- [ ] SLA compliance >= 95%
- [ ] User satisfaction >= 4.5/5

**Dependencias:**
- Hito 2 completado
- Templates de reports validados
- ML models trained

---

### Hito 4: AI Excellence DORA Compliant
**Fecha objetivo:** 2026-03-31
**Criterios:**
- [ ] 7/7 practicas DORA AI Capabilities implementadas
- [ ] DORA metrics baseline establecida
- [ ] Deployment Frequency >= 1/dia
- [ ] Lead Time < 2 dias
- [ ] AI stance comunicada al 100% del equipo
- [ ] Platform API para agentes operativa

**Dependencias:**
- Hito 1 completado (DevOps Foundation)
- Hito 2 en progreso (Monitoring)
- Sistema de metrics interno operativo

**Impacto:**
- Amplificar capacidades del equipo con IA
- Reducir lead time en 50%
- Aumentar deployment frequency 10x
- Mantener quality mientras se escala

---

## Restricciones y Riesgos

### Restricciones Criticas (INMUTABLES)

**RNF-002: NO Redis/Memcached**
- Sesiones en MySQL obligatorio
- Cache en database si es necesario
- Validacion automatica en CI/CD

**NO Email/SMTP**
- Notificaciones via InternalMessage
- Validacion en pre-commit hooks

**Scripts First**
- Scripts shell funcionan offline
- CI/CD workflows llaman scripts
- Validacion manual siempre posible

### Riesgos Identificados

**RIESGO-001: Session Table Growth**
- Probabilidad: ALTA
- Impacto: MEDIO
- Mitigacion: cleanup_sessions.sh cada 6 horas

**RIESGO-002: Test Coverage Drift**
- Probabilidad: MEDIA
- Impacto: ALTO
- Mitigacion: CI/CD bloquea merge si coverage < 80%

**RIESGO-003: Documentation Drift**
- Probabilidad: MEDIA
- Impacto: MEDIO
- Mitigacion: docs-validation.yml en cada PR

**RIESGO-004: Incident Response Gaps**
- Probabilidad: MEDIA
- Impacto: ALTO
- Mitigacion: Runbooks completos + incident-response.yml

---

## Metricas de Exito del Proyecto

### Metricas DORA (Objetivo Q2 2026)
- **Deployment Frequency:** >= 2/dia (Elite)
- **Lead Time:** < 1 dia (Elite)
- **Change Failure Rate:** < 5% (Elite)
- **MTTR:** < 1 hora (Elite)

### Metricas de Calidad
- **Test Coverage:** >= 80% (siempre)
- **Documentation Coverage:** 100% APIs publicas
- **Security Scan:** 0 critical vulnerabilities
- **Code Quality:** Complexity < 10 (Cyclomatic)

### Metricas Operacionales
- **Uptime:** >= 99.9%
- **P95 Latency:** < 500ms
- **Error Rate:** < 1%
- **Session Table:** < 100K rows

### Metricas de Proceso
- **Sprint Velocity:** 20-30 SP/sprint (2 devs)
- **Bug Escape Rate:** < 5%
- **Automation Rate:** >= 90%
- **Manual Toil:** < 10%

---

## Dependencias Externas

### Infraestructura
- Vagrant VMs estables
- PostgreSQL y MySQL operativos
- Network connectivity confiable

### Herramientas
- GitHub Actions (CI/CD)
- Claude Code CLI (SDLC agents)
- Python 3.11+ (scripts automation)
- Bash 4.0+ (scripts shell)

### Equipo
- 1 Arquitecto Senior
- 2 Backend Developers
- 1 Frontend Developer
- 1 DevOps Engineer
- 1 QA Engineer

---

## Referencias

### Documentacion Relacionada
- [Vision y Alcance](vision_y_alcance.md)
- [Tareas Activas](TAREAS_ACTIVAS.md)
- [Changelog](CHANGELOG.md)
- [INDICE General](../INDICE.md)
- [Agentes SDLC](../gobernanza/procesos/AGENTES_SDLC.md)
- [CI/CD Workflows](../gobernanza/ci_cd/INDICE.md)

### Standards
- BABOK v3
- PMBOK 7
- ISO/IEC/IEEE 29148:2018
- DORA Metrics Framework

---

## Proceso de Actualizacion

**Frecuencia:** Mensual (primer viernes de cada mes)

**Responsable:** @arquitecto-senior

**Proceso:**
1. Revisar progreso de epicas y hitos
2. Actualizar metricas DORA
3. Identificar nuevos riesgos
4. Ajustar fechas si es necesario
5. Comunicar cambios al equipo
6. Commit: `docs(roadmap): actualizar ROADMAP.md - [mes]`

**Proxima revision:** 2025-12-06

---

**Mantenedor:** @arquitecto-senior
**Ultima actualizacion:** 2025-11-12
**Version:** 1.0.0
