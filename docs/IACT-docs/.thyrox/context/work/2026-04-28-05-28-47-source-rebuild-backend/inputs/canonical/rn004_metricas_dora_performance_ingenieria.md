---
id: RN-004
tipo: requisito_negocio
titulo: Sistema de métricas DORA para mejorar performance de ingeniería de software
dominio: backend
owner: equipo-ingenieria
prioridad: alta
estado: implementado
fecha_creacion: 2025-11-11
trazabilidad_upward:
 - N-004 # Metricas DORA para performance del ciclo de desarrollo
stakeholders:
 - cto
 - tech-lead
 - engineering-manager
 - devops-team
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "9.3"
date: 2025-11-13
---

# RN-004: Sistema de métricas DORA para mejorar performance de ingeniería de software

## 1. Declaración del Requisito

El sistema IACT DEBE proveer un sistema de métricas DORA (DevOps Research and Assessment) que permita al equipo de ingeniería medir, monitorear y mejorar el performance del ciclo de desarrollo de software mediante el tracking automático de:

1. **Deployment Frequency** (frecuencia de despliegues)
2. **Lead Time for Changes** (tiempo desde commit hasta producción)
3. **Change Failure Rate** (porcentaje de despliegues que fallan)
4. **Mean Time to Recovery** (tiempo promedio de recuperación tras fallo)

El sistema DEBE permitir:
- Clasificación de performance según benchmarks DORA (Elite, High, Medium, Low)
- Telemetría de decisiones de agentes IA con feedback loop
- Predicción de riesgos de deployment mediante ML
- Auto-remediación de problemas detectados

## 2. Justificación de Negocio

### 2.1 Problema de Negocio

Sin métricas objetivas de performance de ingeniería, la organización opera "a ciegas" sin poder:
- Medir efectividad del proceso de desarrollo
- Identificar cuellos de botella en el pipeline
- Comparar performance contra benchmarks de industria
- Tomar decisiones data-driven sobre mejoras

**Impacto actual:**
- Lead Time desconocido (industria Elite: <1 hora)
- CFR desconocido (industria Elite: 0-15%)
- MTTR desconocido (industria Elite: <1 hora)
- ROI de agentes IA no cuantificable

### 2.2 Valor de Negocio

**Beneficios cuantitativos:**
- Reducción 25% en Lead Time (validado en ADR_2025_003)
- Reducción 20% en Change Failure Rate
- Reducción 30% en MTTR mediante auto-remediation
- Aumento 50% en Deployment Frequency

**Beneficios cualitativos:**
- Cultura de mejora continua basada en datos
- Decisiones de inversión justificadas con métricas
- Benchmarking contra industria (DORA research)
- AI governance y accountability

### 2.3 Alineación Estratégica

- **Objetivo estratégico**: OE-2025-02 "Excelencia en ingeniería de software"
- **Iniciativa corporativa**: INIT-DEVOPS-2025 "DevOps transformation"
- **DORA Research**: Framework validado con 10+ años de investigación

## 3. Alcance

### 3.1 En Alcance

**Core DORA Metrics:**
- Registro de ciclos de desarrollo (planning, testing, deployment, maintenance)
- Cálculo automático de 4 métricas DORA
- Dashboard con visualización
- Clasificación de performance (Elite/High/Medium/Low)

**Data Governance:**
- Catálogo de métricas DORA
- Evaluación de calidad de datos
- Data lineage mapping
- Metadata registry

**Advanced Analytics:**
- Análisis de tendencias
- Detección de anomalías
- Forecasting de performance
- Reportes históricos

**AI Telemetry & Governance:**
- Registro de decisiones de agentes IA
- Confidence scores y human feedback
- Accuracy tracking
- Stats por agente

**ML Predictions:**
- Predicción de riesgo de deployment
- Feature importance analysis
- Modelo retrainable

**Auto-Remediation:**
- Detección de problemas comunes
- Propuesta de fixes
- Ejecución automática (con aprobación)
- Rollback capability

### 3.2 Fuera de Alcance

- Integración con CI/CD externo (GitLab CI, GitHub Actions)
- Métricas de código (coverage, complexity)
- Métricas de infraestructura (uptime, resources)
- Integración con Jira/Azure DevOps
- Métricas de negocio (revenue, satisfaction)

### 3.3 Restricciones

Según **ADR_2025_003**:

**Técnicas:**
1. NO Redis - Solo PostgreSQL, MySQL, filesystem (RNF-002)
2. NO emojis en código/docs (RNF-NO-EMOJIS)
3. ML con scikit-learn (no TensorFlow/PyTorch)
4. Auto-remediation requiere aprobación humana para cambios críticos
5. Telemetría IA sin PII

**Operacionales:**
6. Dashboard carga en <3 segundos
7. Predictions ML en <500ms
8. Overhead pipeline <1% (ADR_2025_003 target)

## 4. Stakeholders

| Stakeholder | Rol | Responsabilidades | Expectativas |
|-------------|-----|-------------------|--------------|
| CTO | Sponsor | Aprobar inversión, revisar métricas | Visibilidad performance ingeniería |
| Tech Lead | Usuario primario | Monitorear métricas equipo, proponer mejoras | Dashboard con métricas en tiempo real |
| Engineering Manager | Usuario frecuente | Reportar a management, gestionar recursos | Reportes ejecutivos, justificar inversiones |
| DevOps Team | Usuarios intensivos | Optimizar pipeline, reducir MTTR | Alertas proactivas, auto-remediation |
| QA Lead | Usuario ocasional | Validar calidad (CFR) | Métricas de QA effectiveness |

## 5. Criterios de Aceptación del Negocio

1. **Dashboard funcional:** 4 métricas DORA visualizadas en tiempo real con <3s load time
2. **Clasificación DORA:** Cálculo automático según benchmarks oficiales DORA
3. **AI Telemetry:** 100% de decisiones de agentes tracked con confidence scores
4. **Predictions:** Riesgo de deployment predicho con >70% accuracy
5. **Auto-Remediation:** >5 problemas comunes detectados y corregidos automáticamente
6. **Adopción:** 100% equipo ingeniería consulta dashboard semanalmente
7. **Overhead:** <1% overhead en duración de pipeline (según ADR_2025_003)

## 6. Dependencias

### 6.1 Dependencias Técnicas

- **MySQL**: Para almacenamiento de métricas (tabla `dora_metrics`)
- **Python 3.11+**: Para ML predictions con scikit-learn
- **Django Admin**: Para dashboards (opcional, fase 4 según ADR_2025_003)

### 6.2 Dependencias de Datos

- Ciclos de desarrollo registrados (manual o via API)
- Feedback humano sobre decisiones IA (para accuracy tracking)
- Datos históricos de últimos 6 meses (para ML training)

### 6.3 Dependencias Externas

- **GITHUB_TOKEN** (bloqueado actualmente): Para sync con GitHub API (fase 5 opcional)

## 7. Riesgos

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-06 | Equipos no registran ciclos consistentemente | Media | Alto | Training, automation, gamification |
| R-07 | ML predictions con baja accuracy (<70%) | Media | Medio | Feature engineering, más datos entrenamiento |
| R-08 | Auto-remediation causa problemas | Baja | Crítico | Aprobación humana, rollback, testing exhaustivo |
| R-09 | AI telemetry overhead de performance | Baja | Medio | Async logging, sampling, optimización |
| R-10 | Resistencia cultural a métricas | Media | Medio | Communication, transparency, no-blame culture |

## 8. Supuestos

1. Equipos proporcionan feedback sobre AI agents de forma regular
2. Datos históricos de últimos 6 meses están disponibles o se generarán
3. Modelo ML se re-entrena mensualmente con datos actualizados
4. Ciclos de desarrollo se registran via API o decorators (automatizado)
5. Infraestructura MySQL tiene capacidad para time-series data

## 9. Trazabilidad

### 9.1 Upward (Origen)

- **N-004**: Métricas DORA para mejorar performance del ciclo de desarrollo de software

### 9.2 Downward (Derivados)

**Requisitos Funcionales (30 requisitos):**
- RF-020 a RF-027: Core DORA Metrics (8 requisitos)
- RF-028 a RF-031: Data Catalog & Governance (4 requisitos)
- RF-032 a RF-036: Advanced Analytics (5 requisitos)
- RF-037 a RF-041: AI Telemetry (5 requisitos)
- RF-042 a RF-045: ML Predictions (4 requisitos)
- RF-046 a RF-049: Auto-Remediation (4 requisitos)

**Requisitos No Funcionales:**
- RNF-006: Performance dashboard (<3s)
- RNF-007: Performance predictions (<500ms)
- RNF-008: Aprobación humana auto-remediation crítica
- RNF-009: Telemetría IA sin PII
- RNF-010: Modelo ML retrainable mensualmente

**Implementación:**
- Módulo: `api/callcentersite/dora_metrics/`
- ADR: ADR_2025_003 (Integración DORA Metrics con SDLC Agents)

**Casos de Uso:**
- UC-DM-001 a UC-DM-010 (pendientes de documentar)

## 10. Referencias

### 10.1 Documentación Técnica

- **ADR_2025_003**: Integración DORA Metrics con SDLC Agents (docs/adr/)
- **Código implementado**: api/callcentersite/dora_metrics/
- **Backend analysis**: docs/backend_analisis/2025-11-11/
- **DORA SDLC Integration Guide**: docs/gobernanza/ai/DORA_SDLC_INTEGRATION_GUIDE.md
- **Workflow Agentes DORA**: docs/gobernanza/procesos/agentes/WORKFLOW_METRICAS_PROCESO.md

### 10.2 Research & Standards

- **DORA State of DevOps Report 2025**: https://dora.dev/
- **Accelerate** (Forsgren, Humble, Kim, 2018)
- **DORA Four Keys**: https://dora.dev/guides/dora-metrics-four-keys/
- **Google DORA Research**: https://cloud.google.com/blog/products/devops-sre/

### 10.3 Estándares

- **BABOK v3**: Knowledge Area - Business Analysis Planning and Monitoring
- **ISO/IEC/IEEE 29148:2018**: Clause 9.3 - Business Requirements Specification

## 11. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2025-11-11 | Requirements Analysis | Creación inicial - Documentación para código existente |

---

**Nota Importante:**

Este requisito de negocio documenta funcionalidad YA IMPLEMENTADA en el módulo `dora_metrics/` (~4,000 líneas de código). El propósito es:

1. **Establecer trazabilidad**: Requisito <-> Código <-> ADR
2. **Documentar QUÉ**: El negocio necesita métricas DORA
3. **Justificar implementación**: Por qué existe este módulo
4. **Criterios de validación**: Cómo validar que cumple necesidad
5. **Contexto para mantenimiento**: Por qué decisiones arquitecturales (ver ADR_2025_003)

**Estado actual**: Implementado según ADR_2025_003 con 6 fases:
- Fase 1: Core Integration (COMPLETADO)
- Fase 2-6: Refactor, MySQL, Dashboards, GitHub Sync, PDCA (EN ROADMAP)
