# Strategy Analysis — [Nombre del proyecto]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:strategy
author: [nombre]
status: Borrador
```

---

## Current State Analysis

### Procesos actuales

| Proceso | Descripción de pasos | Actores | Frecuencia | Tiempo ciclo |
|---------|---------------------|---------|:----------:|:------------:|
| [proceso 1] | [descripción paso a paso] | [roles] | [diaria/semanal] | [tiempo] |
| [proceso 2] | | | | |

**Mapa de proceso (descripción textual o diagrama adjunto):**
[Describir el flujo principal del proceso o referenciar el process map]

---

### Métricas actuales (baseline)

| KPI | Valor actual | Unidad | Fuente | Fecha medición |
|-----|:-----------:|--------|--------|:--------------:|
| [ej: Tiempo promedio de proceso] | [valor] | [días/horas] | [sistema/encuesta] | [fecha] |
| [ej: Tasa de error] | [valor] | [%] | [logs] | [fecha] |
| [ej: Satisfacción del usuario] | [valor] | [NPS/1-5] | [encuesta] | [fecha] |
| [ej: Costo por transacción] | [valor] | [$] | [contabilidad] | [fecha] |

---

### Pain points identificados

| Pain Point ID | Descripción | Stakeholder afectado | Frecuencia | Impacto cuantificado |
|:-------------:|-------------|---------------------|:----------:|:--------------------:|
| PP-001 | [descripción del problema] | [nombre/rol] | [diario/semanal] | [$/tiempo/% afectados] |
| PP-002 | | | | |

---

### SWOT del estado actual

| | Positivo | Negativo |
|--|---------|---------|
| **Interno** | **Fortalezas:** [lista de lo que funciona bien] | **Debilidades:** [lista de problemas internos] |
| **Externo** | **Oportunidades:** [factores externos que se pueden aprovechar] | **Amenazas:** [factores externos que representan riesgo] |

---

## Business Need

| Elemento | Detalle |
|----------|---------|
| **Problema** | [descripción factual del problema — sin proponer soluciones] |
| **Impacto cuantificado** | [$/tiempo/porcentaje de usuarios afectados — con fuente] |
| **Stakeholders afectados** | [lista de roles/grupos afectados] |
| **Métricas del problema** | [cómo se mide el problema hoy — vinculadas al baseline] |
| **Urgencia** | Alta / Media / Baja — [razón] |

---

## Future State Definition

### Objetivos del cambio

| Objetivo | Métrica de éxito | Target | Plazo |
|---------|:----------------:|:------:|:-----:|
| [ej: Reducir tiempo de aprobación] | [ej: Tiempo promedio proceso] | [ej: < 24h] | [ej: 90 días post-implementación] |
| [objetivo 2] | | | |

### Capacidades requeridas

| Capacidad | Descripción | ¿Existe hoy? | Prioridad |
|-----------|-------------|:------------:|:---------:|
| [ej: Notificaciones en tiempo real] | [descripción] | No | Alta |
| [capacidad 2] | | Parcialmente | Media |

### Restricciones del estado futuro (qué preservar)

- [ej: El proceso actual de auditoría manual para montos > $50K debe preservarse]
- [ej: Integración con sistema SAP existente no puede romperse]

### Asunciones

- [ej: La solución se desplegará en la nube corporativa (AWS)]
- [ej: Los usuarios tendrán acceso a smartphones corporativos]

---

## Gap Analysis

| Dimensión | Estado actual | Estado futuro (target) | Gap | Categoría | Prioridad |
|-----------|:------------:|:----------------------:|-----|:---------:|:---------:|
| [ej: Tiempo de aprobación] | 5.2 días | < 24h | Automatización del flujo de aprobación | Capability gap | Alta |
| [ej: Notificaciones] | Email manual | Push automático | Sistema de notificaciones | Capability gap | Media |
| [ej: Reportes] | Excel manual | Dashboard automático | Performance gap | Performance gap | Media |

**Categorías de gap:**
- **Capability gap:** Capacidad que no existe en el estado actual
- **Performance gap:** Capacidad que existe pero no al nivel requerido
- **Knowledge gap:** Información o habilidades faltantes
- **Process gap:** Proceso que debe crearse o rediseñarse

---

## Risk Assessment del cambio

| Riesgo | Descripción | P | I | Score P×I | Respuesta |
|--------|-------------|:-:|:-:|:---------:|-----------|
| R-001 — Adopción | Usuarios rechazan el nuevo proceso | Media | Alto | 6 | Plan de change management + training |
| R-002 — Técnico | Integración con sistema legacy compleja | Alta | Alto | 9 | PoC técnico antes del desarrollo |
| R-003 — Regulatorio | Cambios normativos durante el proyecto | Baja | Alto | 3 | Monitorear + revisión mensual |

> P: Baja=1 / Media=2 / Alta=3 · I: Bajo=1 / Medio=2 / Alto=3

---

## Recomendación de solución

### Opciones evaluadas

| Opción | Descripción | Pros | Contras | Costo estimado | Cierra los gaps |
|--------|-------------|------|---------|:--------------:|:--------------:|
| **Opción A** | [descripción de la solución completa] | [lista] | [lista] | $$$ | 100% |
| **Opción B** | [solución parcial o alternativa] | [lista] | [lista] | $$ | 75% |
| **Status quo** | Sin cambios | Sin costo | No resuelve los gaps | $ | 0% |

### Opción recomendada

**Opción seleccionada:** [A/B]

**Justificación:**
[Argumentar por qué esta opción es mejor dado el gap analysis, los riesgos y las restricciones identificadas]

**ROI estimado:**
- Costo estimado de implementación: [$]
- Beneficio esperado (anual): [$]
- Período de recuperación: [meses]

---

## Evaluación de completitud

- [ ] Gap analysis con métricas cuantitativas (estado actual vs target para cada gap)
- [ ] Business Need con impacto cuantificado ($, tiempo, o métrica de negocio)
- [ ] ≥ 2 opciones de solución evaluadas con pros, contras y costo
- [ ] ≥ 3 riesgos del cambio con probabilidad, impacto y respuesta
- [ ] Recomendación con justificación basada en el análisis

---

## Routing — próxima KA

| Situación | Próxima KA |
|-----------|-----------|
| Estrategia definida → especificar requisitos | `ba:requirements-analysis` |
| Falta información del estado actual | `ba:elicitation` |
| Cambios afectan requisitos existentes | `ba:requirements-lifecycle` |
| Solución implementada → verificar que cerró los gaps | `ba:solution-evaluation` |

**Decisión:** [KA seleccionada + razón]
