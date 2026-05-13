---
id: N-004
tipo: necesidad
titulo: Metricas DORA para mejorar performance del ciclo de desarrollo de software
dominio: backend
owner: equipo-ingenieria
prioridad: alta
estado: identificado
fecha_creacion: 2025-11-11
sponsor: cto
stakeholders:
 - cto
 - tech-lead
 - engineering-manager
 - devops-team
 - qa-lead
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "6.2"
valor_negocio: alto
urgencia: alta
date: 2025-11-13
---

# N-004: Métricas DORA para mejorar performance del ciclo de desarrollo de software

## 1. Descripción de la Necesidad

### 1.1 Problema u Oportunidad

El equipo de ingeniería del proyecto IACT necesita visibilidad sobre la efectividad y performance del ciclo de desarrollo de software. Actualmente no se miden métricas clave de ingeniería como:

- **Deployment Frequency**: Frecuencia de despliegues a producción
- **Lead Time for Changes**: Tiempo desde commit hasta producción
- **Change Failure Rate (CFR)**: Porcentaje de deployments que fallan
- **Mean Time to Recovery (MTTR)**: Tiempo promedio de recuperación tras un fallo

Sin estas métricas, el equipo opera "a ciegas" sin datos objetivos para:
- Medir efectividad del proceso de desarrollo
- Identificar cuellos de botella en el pipeline
- Comparar performance contra benchmarks de la industria
- Tomar decisiones data-driven sobre mejoras de proceso

**Problemas actuales identificados:**

- **Sin métricas objetivas**: No se puede medir si el proceso mejora o empeora
- **Benchmarking imposible**: No se puede comparar contra DORA research (Elite, High, Medium, Low performers)
- **Problemas no detectados**: Issues en el pipeline se descubren tarde
- **Decisiones no basadas en datos**: Mejoras de proceso sin validación objetiva
- **AI agents sin telemetría**: Agentes IA operan sin tracking de performance

**Impacto en el negocio:**

Cuantitativo:
- Tiempo promedio lead time desconocido (industria Elite: <1 hora)
- CFR desconocido (industria Elite: 0-15%)
- MTTR desconocido (industria Elite: <1 hora)
- Performance de AI agents no medida

Cualitativo:
- Incapacidad de validar si DevOps mejora o no
- No se puede justificar inversiones en automatización
- Problemas en el pipeline se detectan reactivamente
- Cultura de mejora continua sin métricas objetivas

### 1.2 Situación Actual (As-Is)

**Proceso actual de medición:**

1. **Sin medición**: No se registran tiempos de ciclo de desarrollo
2. **Manual y esporádico**: Si se mide algo, es manual en retrospectivas
3. **Sin dashboard**: No hay visualización de métricas
4. **Sin alertas**: Problemas se detectan cuando usuarios reportan
5. **Sin AI telemetry**: Agentes IA operan sin tracking

**Características de la situación actual:**

- Frecuencia de medición: Ninguna o esporádica
- Visibilidad: Nula
- Benchmarking: Imposible
- Mejora de proceso: Sin validación objetiva
- AI governance: Inexistente

### 1.3 Situación Deseada (To-Be)

**Proceso objetivo:**

1. **Tracking automático**: Cada ciclo de desarrollo registrado (planning → testing → deployment → maintenance)
2. **Cálculo automático**: Métricas DORA calculadas en tiempo real
3. **Dashboard**: Visualización de métricas con tendencias
4. **Clasificación DORA**: Comparación contra benchmarks de la industria
5. **Alertas**: Notificaciones cuando métricas degradan
6. **AI Telemetry**: Tracking de decisiones y accuracy de agentes IA
7. **Predictive Analytics**: ML para predecir riesgos de deployment
8. **Auto-Remediation**: Detección y corrección automática de problemas

**Beneficios esperados:**

Cuantitativos:
- Visibilidad 100% de métricas DORA en tiempo real
- Clasificación DORA objetivo: "High" o "Elite" (actualmente desconocido)
- Reducción 30% en MTTR mediante auto-remediation
- Aumento 50% en deployment frequency mediante mejoras data-driven

Cualitativos:
- Cultura de mejora continua basada en datos
- Benchmarking contra industria (DORA research)
- AI agents con governance y accountability
- Decisiones de inversión justificadas con datos

**Criterios de éxito:**

- Dashboard DORA con 4 métricas principales funcionando
- Clasificación DORA calculada automáticamente
- AI telemetry tracking 100% de decisiones
- Auto-remediation detecta y corrige problemas comunes
- Deployment risk prediction con >70% accuracy

---

## 2. Justificación de Negocio

### 2.1 Impacto en el Negocio

| Dimensión | Impacto Actual | Impacto Esperado |
|-----------|----------------|-------------------|
| **Técnico** | Sin métricas, proceso opaco | Métricas DORA en tiempo real |
| **Calidad** | CFR desconocido, problemas no detectados | CFR <15%, detección proactiva |
| **Velocidad** | Lead time desconocido, posibles cuellos de botella | Lead time optimizado, cuellos de botella eliminados |
| **Cultura** | Mejora sin validación | Cultura data-driven con benchmarking |

### 2.2 Alineación con DORA Research

**DORA (DevOps Research and Assessment)** ha identificado 4 métricas clave que correlacionan con performance organizacional:

| Métrica | Elite | High | Medium | Low |
|---------|-------|------|--------|-----|
| **Deployment Frequency** | On-demand (múltiples por día) | Entre 1 vez/semana y 1 vez/mes | Entre 1 vez/mes y 1 vez/6 meses | Menos de 1 vez/6 meses |
| **Lead Time for Changes** | <1 hora | 1 día - 1 semana | 1 semana - 1 mes | 1 mes - 6 meses |
| **Change Failure Rate** | 0-15% | 16-30% | 31-45% | 46-60% |
| **Mean Time to Recovery** | <1 hora | <1 día | 1 día - 1 semana | 1 semana - 1 mes |

**Objetivo:** Alcanzar "High" o "Elite" en los próximos 12 meses

---

## 3. Alcance

### 3.1 En Alcance

**Core DORA Metrics:**
- Registro de ciclos de desarrollo (planning, testing, deployment, maintenance)
- Cálculo automático de 4 métricas DORA
- Dashboard con visualización de métricas
- Clasificación DORA (Elite, High, Medium, Low)
- Exportación de reportes

**Data Catalog & Governance:**
- Catálogo de métricas DORA
- Evaluación de calidad de datos
- Data lineage mapping
- Governance status dashboard

**Advanced Analytics:**
- Análisis de tendencias
- Detección de anomalías
- Forecasting de performance
- Comparación período sobre período

**AI Telemetry:**
- Registro de decisiones de agentes IA
- Tracking de confidence scores
- Human feedback loop
- Accuracy calculation

**ML Predictions:**
- Predicción de riesgo de deployment
- Feature importance analysis
- Modelo retrainable

**Auto-Remediation:**
- Detección de problemas comunes
- Propuesta de fixes
- Ejecución automática de remediación
- Rollback capability

### 3.2 Fuera de Alcance

- Integración con herramientas de CI/CD externas (GitLab CI, GitHub Actions)
- Métricas de código (code coverage, complexity)
- Métricas de infraestructura (uptime, resource usage)
- Integración con Jira/Azure DevOps
- Métricas de negocio (revenue, customer satisfaction)

### 3.3 Supuestos

1. Ciclos de desarrollo se registran manualmente o via API
2. Equipos proporcionan feedback sobre AI agents
3. Datos históricos de últimos 6 meses disponibles
4. ML model se re-entrena mensualmente

### 3.4 Restricciones

**Técnicas:**
1. Datos almacenados en PostgreSQL (no data warehouse separado)
2. ML con scikit-learn (no TensorFlow/PyTorch)
3. Auto-remediation limitada a problemas conocidos
4. Telemetría IA sin PII (Personally Identifiable Information)

**Operacionales:**
5. Dashboard carga en <3 segundos
6. Predictions en <500ms
7. Auto-remediation requiere aprobación humana para cambios críticos

---

## 4. Stakeholders Afectados

| Stakeholder | Rol | Interés | Impacto | Influencia |
|-------------|-----|---------|---------|------------|
| CTO | Sponsor | Alto - Visibilidad performance ingeniería | Positivo - Decisiones data-driven | Alta |
| Tech Lead | Usuario primario | Alto - Métricas de equipo | Positivo - Identificar mejoras | Alta |
| Engineering Manager | Usuario frecuente | Alto - Reportes a management | Positivo - Justificar inversiones | Alta |
| DevOps Team | Usuarios intensivos | Alto - Optimizar pipeline | Positivo - Reducir MTTR | Media |
| QA Lead | Usuario ocasional | Medio - Métricas de calidad (CFR) | Positivo - Validar QA effectiveness | Media |
| Product Owner | Interesado | Medio - Velocity del equipo | Positivo - Predictability | Baja |

---

## 5. Criterios de Éxito

### 5.1 Métricas de Éxito (KPIs)

| KPI | Baseline Actual | Target | Método de Medición |
|-----|-----------------|--------|--------------------|
| Clasificación DORA | Desconocido | High o Elite | Cálculo automático según benchmarks |
| Deployment Frequency | Desconocido | >1/semana | Contador de deployments |
| Lead Time | Desconocido | <1 semana | Timestamp commit → prod |
| Change Failure Rate | Desconocido | <15% | (Deployments fallidos / Total) |
| MTTR | Desconocido | <1 día | Timestamp inicio → resolución |
| AI Telemetry Coverage | 0% | 100% | (Decisiones tracked / Total) |
| Prediction Accuracy | N/A | >70% | Comparación predicción vs real |

### 5.2 Criterios de Aceptación del Negocio

1. **Dashboard funcional**: 4 métricas DORA visualizadas en tiempo real
2. **Clasificación DORA**: Cálculo automático según benchmarks
3. **AI Telemetry**: 100% de decisiones de agentes tracked
4. **Predictions**: Riesgo de deployment predicho con >70% accuracy
5. **Auto-Remediation**: >5 problemas comunes detectados y corregidos automáticamente
6. **Adopción**: 100% del equipo de ingeniería consulta dashboard semanalmente

---

## 6. Análisis de Alternativas

### 6.1 Opciones Evaluadas

#### Opción 1: Sistema DORA Custom (Recomendada - IMPLEMENTADA)
- **Descripción**: Sistema Django custom con métricas DORA, AI telemetry, ML predictions
- **Pros**:
 - Control total sobre funcionalidad
 - Integración nativa con backend IACT
 - AI telemetry específico para agentes IACT
 - Auto-remediation customizado
- **Contras**:
 - Desarrollo custom (ya realizado)
 - Mantenimiento interno
- **Estado**: IMPLEMENTADO (código existente en dora_metrics/)

#### Opción 2: Herramienta DORA Comercial (Datadog, New Relic)
- **Descripción**: SaaS de monitoreo con métricas DORA
- **Pros**:
 - Producto maduro
 - Menos desarrollo
- **Contras**:
 - Costo perpetuo (~$100-200/usuario/mes)
 - No incluye AI telemetry
 - No incluye auto-remediation
 - Menor control
- **Decisión**: NO seleccionada

#### Opción 3: Herramienta Open Source (Backstage, Sleuth)
- **Descripción**: Plataforma open source para developer portal con DORA
- **Pros**:
 - Gratuito
 - Comunidad activa
- **Contras**:
 - Requiere hosting
 - No incluye AI telemetry
 - No incluye auto-remediation customizado
 - Menor flexibilidad
- **Decisión**: NO seleccionada

### 6.2 Recomendación

**Opción seleccionada**: Opción 1 - Sistema DORA Custom

**Justificación**:
1. **Ya implementado**: Código existente en `dora_metrics/` módulo
2. **Funcionalidad completa**: Incluye AI telemetry, ML, auto-remediation
3. **Sin costo recurrente**: No licencias SaaS
4. **Customizado para IACT**: Específico para necesidades del proyecto

**Necesidad actual:** DOCUMENTAR los requisitos para el código ya existente

---

## 7. Derivación a Requisitos

Esta necesidad se descompone en los siguientes requisitos:

### 7.1 Requisitos de Negocio

- **RN-004**: Sistema de métricas DORA para performance de ingeniería de software

### 7.2 Requisitos Funcionales

**Core DORA Metrics (RF-020 a RF-027):**
- RF-020: Registrar ciclos de desarrollo con fases
- RF-021: Calcular Deployment Frequency
- RF-022: Calcular Lead Time for Changes
- RF-023: Calcular Change Failure Rate
- RF-024: Calcular Mean Time to Recovery
- RF-025: Clasificar performance DORA (Elite/High/Medium/Low)
- RF-026: Dashboard con 4 métricas DORA
- RF-027: Exportar reportes DORA

**Data Catalog (RF-028 a RF-031):**
- RF-028: Catálogo de métricas DORA
- RF-029: Evaluación de calidad de datos
- RF-030: Data lineage mapping
- RF-031: Governance status dashboard

**Advanced Analytics (RF-032 a RF-036):**
- RF-032: Análisis de tendencias
- RF-033: Detección de anomalías
- RF-034: Forecasting de performance
- RF-035: Comparación período sobre período
- RF-036: Reporte mensual histórico

**AI Telemetry (RF-037 a RF-041):**
- RF-037: Registrar decisiones de agentes IA
- RF-038: Feedback humano sobre decisiones IA
- RF-039: Calcular accuracy de agentes IA
- RF-040: Dashboard de telemetría IA
- RF-041: Stats por agente IA

**ML Predictions (RF-042 a RF-045):**
- RF-042: Predecir riesgo de deployment
- RF-043: Stats del modelo ML
- RF-044: Re-entrenar modelo ML
- RF-045: Feature importance analysis

**Auto-Remediation (RF-046 a RF-049):**
- RF-046: Detectar problemas comunes
- RF-047: Proponer fixes para problemas
- RF-048: Ejecutar remediación automática
- RF-049: Rollback de remediación

### 7.3 Requisitos No Funcionales

- **RNF-006**: Dashboard DORA carga en <3 segundos
- **RNF-007**: Predictions ML en <500ms
- **RNF-008**: Auto-remediation con aprobación humana para cambios críticos
- **RNF-009**: Telemetría IA sin PII
- **RNF-010**: Modelo ML re-entrenable mensualmente

---

## 8. Trazabilidad

### 8.1 Trazabilidad Upward (Origen)

Esta necesidad está alineada con:

- **Objetivo estratégico**: OE-2025-02 "Excelencia en ingeniería de software"
- **Iniciativa corporativa**: INIT-DEVOPS-2025 "DevOps transformation"
- **Pain point**: Falta de visibilidad sobre performance de desarrollo

### 8.2 Trazabilidad Downward (Derivados)

Esta necesidad genera:

- **Requisitos de negocio**: RN-004
- **Requisitos funcionales**: RF-020 a RF-049 (30 requisitos)
- **Requisitos no funcionales**: RNF-006 a RNF-010 (5 requisitos)
- **Módulo implementado**: `api/callcentersite/dora_metrics/`
- **Casos de uso**: UC-DM-001 a UC-DM-010 (pendientes)

---

## 9. Riesgos Identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-06 | Equipos no registran ciclos consistentemente | Media | Alto | Training, automation, gamification |
| R-07 | ML predictions con baja accuracy (<70%) | Media | Medio | Feature engineering, más datos de entrenamiento |
| R-08 | Auto-remediation causa problemas | Baja | Crítico | Aprobación humana, rollback capability, testing exhaustivo |
| R-09 | AI telemetry con overhead de performance | Baja | Medio | Async logging, sampling, optimización |

---

## 10. Referencias

### 10.1 Documentos Relacionados

- **DORA State of DevOps Report**: https://dora.dev/
- **Accelerate book** (Forsgren, Humble, Kim, 2018)
- **ADR_2025_003**: Integración DORA Metrics con SDLC Agents (`docs/adr/ADR_2025_003-dora-sdlc-integration.md`)
- Código implementado: `api/callcentersite/dora_metrics/`
- Backend analysis: `docs/backend_analisis/2025-11-11/`
- DORA SDLC Integration Guide: `docs/gobernanza/ai/DORA_SDLC_INTEGRATION_GUIDE.md`
- Workflow Agentes DORA: `docs/gobernanza/procesos/agentes/WORKFLOW_METRICAS_PROCESO.md`

### 10.2 Estándares Aplicados

- **DORA Research**: 4 key metrics (Deployment Frequency, Lead Time, CFR, MTTR)
- **BABOK v3**: Knowledge Area - Business Analysis Planning and Monitoring
- **ISO/IEC/IEEE 29148:2018**: Clause 6.2 - Business Analysis Process

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | 2025-11-11 | Requirements Analysis | Creación inicial - Documentación de necesidad para código existente |

---

**Nota importante:**

Esta necesidad documenta requisitos para un módulo YA IMPLEMENTADO (`dora_metrics/` con ~4,000 líneas de código). El propósito es:
1. Documentar el "QUÉ" (requisitos) para código existente
2. Establecer trazabilidad requisitos <-> código
3. Proveer criterios de aceptación para validación
4. Facilitar mantenimiento y evolución futura

El módulo contiene funcionalidad avanzada (AI telemetry, ML predictions, auto-remediation) que va más allá de las métricas DORA básicas.
