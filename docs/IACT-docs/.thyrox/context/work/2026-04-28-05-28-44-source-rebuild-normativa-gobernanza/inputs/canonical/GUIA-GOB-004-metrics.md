---
id: GUIA-GOB-004
tipo: guia
categoria: gobernanza
subcategoria: metricas
version: 1.0.0
fecha_creacion: 2025-11-07
autor: equipo-qa
estado: activo
---

# Metricas de Adoption de Guias

Este documento rastrea las metricas de adoption, uso y efectividad de las guias operativas del proyecto IACT.

## Metricas Clave

### 1. Documentation Coverage

**Objetivo: 147 guias completas**

| Categoria | Objetivo | Actual | % Completado |
|-----------|----------|--------|--------------|
| P0 - Criticas (Onboarding) | 20 | 17 | 85% |
| P1 - Alta Prioridad | 40 | 0 | 0% |
| P2 - Media Prioridad | 50 | 0 | 0% |
| P3 - Baja Prioridad | 37 | 0 | 0% |
| **TOTAL** | **147** | **17** | **11.6%** |

**Estado actual: EN PROGRESO**

### 2. Guias por Categoria

| Categoria | Guias Actuales | Objetivo Final | % Completado |
|-----------|----------------|----------------|--------------|
| Onboarding | 7 | 10 | 70% |
| Workflows | 4 | 20 | 20% |
| Testing | 3 | 15 | 20% |
| Deployment | 2 | 10 | 20% |
| Troubleshooting | 1 | 10 | 10% |
| Scripts | 0 | 50 | 0% |
| Agentes SDLC | 1 | 10 | 10% |
| Fases SDLC | 0 | 7 | 0% |
| Transversales | 0 | 15 | 0% |

### 3. Tiempo de Onboarding

**Objetivo: <30 minutos para onboarding basico**

| Metrica | Objetivo | Actual | Estado |
|---------|----------|--------|--------|
| Tiempo onboarding basico | <30 min | ~55 min | En progreso |
| Tiempo primer commit | <2 horas | TBD | Pendiente medicion |
| Tiempo primer PR | <4 horas | TBD | Pendiente medicion |

**Notas:**
- Onboarding basico incluye: setup entorno + ejecutar proyecto + primer commit
- Tiempo actual (55 min) es estimado basado en suma de tiempos de guias
- Objetivo: reducir a <30 min mediante optimizacion de guias

### 4. Adoption por Equipo

**Objetivo: 80%+ de desarrolladores usan las guias**

| Equipo | Miembros | Usuarios Guias | % Adoption | Estado |
|--------|----------|----------------|------------|--------|
| Backend | TBD | TBD | TBD | Pendiente baseline |
| Frontend | TBD | TBD | TBD | Pendiente baseline |
| DevOps | TBD | TBD | TBD | Pendiente baseline |
| QA | TBD | TBD | TBD | Pendiente baseline |
| **TOTAL** | TBD | TBD | TBD | Pendiente baseline |

**Como medimos adoption:**
- Encuesta semanal al equipo
- Tracking de views en GitHub Pages (docs publicadas)
- Tracking de preguntas en Slack (#dev-help)
- Feedback directo en issues

### 5. Reduccion de Preguntas Repetitivas

**Objetivo: 50% reduccion en preguntas sobre temas cubiertos en guias**

| Metrica | Baseline | Actual | Objetivo | % Mejora |
|---------|----------|--------|----------|----------|
| Preguntas setup entorno/semana | TBD | TBD | -50% | TBD |
| Preguntas Git workflow/semana | TBD | TBD | -50% | TBD |
| Preguntas testing/semana | TBD | TBD | -50% | TBD |
| Preguntas deployment/semana | TBD | TBD | -50% | TBD |

**Establecer baseline:**
- Revisar historico de Slack #dev-help (ultimas 4 semanas)
- Categorizar preguntas por tema
- Contar preguntas que podrian responderse con guias existentes

### 6. Calidad de Guias

**Metricas de calidad individual por guia:**

| Metrica | Objetivo | Implementacion |
|---------|----------|----------------|
| Frontmatter completo | 100% | Automatizado en template |
| Comandos ejecutables | 100% | Manual review |
| Screenshots donde aplica | 80% | Pendiente |
| Links funcionando | 100% | CI workflow (validate-guides.yml) |
| Troubleshooting completo | 100% | Manual review |
| Actualizada (< 3 meses) | 100% | Tracking automatico |

## Dashboard de Metricas

### Resumen Ejecutivo

```
Fecha: 2025-11-07
Estado del Proyecto: INICIADO

[████████░░░░░░░░░░░░] 11.6% - Documentation Coverage (17/147)
[████████████████░░░░] 85.0% - Guias P0 Criticas (17/20)
[████████████████████] 100% - Calidad de Guias Generadas
[░░░░░░░░░░░░░░░░░░░░] 0% - Adoption por Equipo (TBD)
[░░░░░░░░░░░░░░░░░░░░] 0% - Reduccion Preguntas (TBD)
```

### Tendencias

**Semana 1 (Nov 7-14):**
- Guias generadas: 17
- Coverage: 11.6%
- Feedback recibido: 0 (esperando deployment)

**Proyeccion Semana 2-3 (Nov 15-28):**
- Guias esperadas: +40 (P1)
- Coverage esperado: 38.8%
- Adoption objetivo: Establecer baseline

**Proyeccion Mes 2 (Diciembre):**
- Guias esperadas: +50 (P2)
- Coverage esperado: 72.8%
- Adoption objetivo: 50%+

**Proyeccion Mes 3 (Enero):**
- Guias esperadas: +37 (P3)
- Coverage esperado: 100%
- Adoption objetivo: 80%+

## Metricas DORA Relacionadas

Las guias de documentacion impactan indirectamente en metricas DORA:

### Lead Time for Changes

**Hipotesis:** Guias reducen tiempo desde commit hasta production

| Metrica | Sin Guias | Con Guias (Proyectado) | Mejora Esperada |
|---------|-----------|------------------------|-----------------|
| Tiempo setup entorno | 2-4 horas | <30 min | 75-87% |
| Tiempo crear PR correcto | 1-2 horas | <30 min | 50-75% |
| Tiempo pasar CI primera vez | 2-3 intentos | 1 intento | 50-66% |

**Objetivo:** Reducir Lead Time en 30%+ con guias completas

### Change Failure Rate

**Hipotesis:** Guias de testing/validacion reducen failures

| Metrica | Sin Guias | Con Guias (Proyectado) | Mejora Esperada |
|---------|-----------|------------------------|-----------------|
| PRs rechazados por CI | 30-40% | <20% | 33-50% |
| Bugs en produccion | Baseline TBD | -25% | 25% |
| Rollbacks necesarios | Baseline TBD | -30% | 30% |

**Objetivo:** Reducir Change Failure Rate a <15% (Elite)

### Deployment Frequency

**Hipotesis:** Guias facilitan deployments mas frecuentes

| Metrica | Sin Guias | Con Guias (Proyectado) | Mejora Esperada |
|---------|-----------|------------------------|-----------------|
| Deployments/semana | Baseline TBD | +50% | 50% |
| Tiempo por deployment | Baseline TBD | -40% | 40% |

### MTTR (Mean Time to Recovery)

**Hipotesis:** Guias de troubleshooting reducen MTTR

| Metrica | Sin Guias | Con Guias (Proyectado) | Mejora Esperada |
|---------|-----------|------------------------|-----------------|
| Tiempo resolver incidente P0 | Baseline TBD | -50% | 50% |
| Tiempo resolver incidente P1 | Baseline TBD | -40% | 40% |

## Metodologia de Medicion

### Como medimos Documentation Coverage

```python
# Ver: scripts/generate_guides.py --report
total_guides_planned = 147
total_guides_actual = count_md_files("docs/guias/**/*.md")
coverage_percent = (total_guides_actual / total_guides_planned) * 100
```

### Como medimos Adoption

1. **Tracking de views (GitHub Pages)**
   ```javascript
   // Google Analytics en docs publicadas
   // Eventos: guide_view, guide_search, guide_feedback
   ```

2. **Encuesta mensual**
   ```
   Preguntas:
   - Has usado las guias este mes? (Si/No)
   - Cuantas guias usaste? (0, 1-3, 4-10, 10+)
   - Que tan utiles fueron? (1-5)
   - Que falta? (texto libre)
   ```

3. **Tracking de Slack**
   ```python
   # Script: scripts/metrics/slack_question_tracker.py
   # Cuenta preguntas en #dev-help que podrian responderse con guias
   ```

### Como medimos Tiempo de Onboarding

1. **Tracking directo**
   - Nuevos desarrolladores registran tiempo real
   - Formulario de feedback post-onboarding

2. **Estimacion basada en guias**
   ```python
   onboarding_time = sum(guide.tiempo_lectura for guide in onboarding_guides)
   ```

### Como medimos Reduccion de Preguntas

1. **Baseline (4 semanas antes de guias)**
   ```python
   baseline_questions = count_slack_questions(
       channel="#dev-help",
       weeks=4,
       categories=["setup", "git", "testing", "deployment"]
   )
   ```

2. **Medicion actual (4 semanas despues)**
   ```python
   current_questions = count_slack_questions(
       channel="#dev-help",
       weeks=4,
       categories=["setup", "git", "testing", "deployment"]
   )
   reduction_percent = ((baseline - current) / baseline) * 100
   ```

## Reportes Programados

### Semanal

**Todos los lunes a las 9 AM**

Email automatico a:
- @tech-lead
- @doc-lead
- @arquitecto-senior

Contenido:
- Guias generadas esta semana
- Guias mas vistas
- Feedback recibido
- Issues de documentacion abiertos

### Mensual

**Primer dia de cada mes**

Reporte completo a:
- Todo el equipo de desarrollo
- Management

Contenido:
- Dashboard completo de metricas
- Tendencias vs mes anterior
- Objetivos del proximo mes
- Llamado a accion (completar encuesta, etc)

## Objetivos y KPIs

### Semana 1 (Nov 7-14)

- [x] Generar 17/20 guias P0 (85% completado)
- [ ] Completar 20/20 guias P0 (100%)
- [ ] Deployment de guias a GitHub Pages
- [ ] Comunicacion al equipo
- [ ] Establecer baseline de preguntas Slack

### Mes 1 (Noviembre)

- [ ] Generar 60 guias totales (P0 + P1)
- [ ] Adoption >30% del equipo
- [ ] Tiempo onboarding <45 min
- [ ] Primera medicion de reduccion de preguntas

### Mes 2 (Diciembre)

- [ ] Generar 110 guias totales (P0 + P1 + P2)
- [ ] Adoption >50% del equipo
- [ ] Tiempo onboarding <30 min
- [ ] 30% reduccion de preguntas repetitivas

### Mes 3 (Enero)

- [ ] Generar 147 guias totales (100%)
- [ ] Adoption >80% del equipo
- [ ] Tiempo onboarding <30 min
- [ ] 50% reduccion de preguntas repetitivas
- [ ] Impacto medible en DORA metrics

## Como Contribuir a Metricas

### Desarrolladores

- Usa las guias cuando las necesites
- Reporta problemas/mejoras via issues
- Completa la encuesta mensual
- Recomienda guias a nuevos miembros

### Tech Leads

- Asigna guias a nuevos desarrolladores
- Registra tiempo de onboarding
- Revisa metricas semanales
- Aprueba nuevas guias

### Doc Lead

- Mantiene metricas actualizadas
- Genera reportes semanales/mensuales
- Coordina generacion de nuevas guias
- Analiza feedback

## Dashboards Externos

**GitHub Pages (Publico):**
- https://2-coatl.github.io/IACT---project/guias/

**Google Analytics (Privado):**
- Tracking de views, bounce rate, tiempo en pagina
- Dashboard: [Link TBD]

**Slack Analytics (Privado):**
- Tracking de preguntas en #dev-help
- Dashboard: [Link TBD]

## Referencias

- [README principal de guias](README.md)
- [Script generador de guias](../../scripts/generate_guides.py)
- [Script DORA metrics](../../scripts/dora_metrics.py)
- [Workflow validate-guides.yml](../../.github/workflows/validate-guides.yml)

---

**Mantenedores:** @doc-lead, @tech-lead
**Ultima actualizacion:** 2025-11-07
**Proxima actualizacion:** 2025-11-14 (semanal)
