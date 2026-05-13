```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pm:initiating
author: [nombre]
status: Borrador
```

# PM Initiating — Artefacto

---

## Project Charter

### Project Purpose

| Campo | Contenido |
|-------|-----------|
| **Business Need** | [Necesidad de negocio que origina el proyecto] |
| **Opportunity** | [Oportunidad que se aprovechará, si aplica] |
| **Regulatory Requirement** | [Requisito regulatorio o de cumplimiento, si aplica] |
| **Strategic Alignment** | [Objetivo estratégico al que contribuye] |

### Measurable Objectives

| # | Objetivo | Métrica de éxito | Fecha límite |
|---|----------|-----------------|-------------|
| 1 | [Objetivo SMART] | [Métrica cuantificable] | [Fecha] |
| 2 | | | |

### High-Level Requirements

| Stakeholder | Necesidad | Prioridad |
|-------------|-----------|-----------|
| [nombre / rol] | [necesidad de alto nivel] | Alta / Media / Baja |

### High-Level Description

[Qué se va a construir — descripción de producto/servicio sin arquitectura técnica ni solución]

### Boundaries — In Scope / Out of Scope

| In Scope | Out of Scope |
|----------|-------------|
| [funcionalidad / componente incluido] | [exclusión explícita] |

### High-Level Risks

| Risk ID | Descripción | Categoría | Probabilidad | Impacto | Respuesta preliminar |
|---------|-------------|-----------|-------------|---------|---------------------|
| R-001 | | Técnico / Negocio / Externo | Alta / Media / Baja | Alto / Medio / Bajo | Mitigar / Aceptar / Evitar |

### Summary Milestone Schedule

| Milestone | Descripción | Fecha tentativa |
|-----------|-------------|----------------|
| M-01 | Project Charter aprobado | [fecha] |
| M-02 | Planning completado | [fecha] |
| M-03 | [Milestone principal] | [fecha] |
| M-04 | Producto final entregado | [fecha] |

### Summary Budget

| Concepto | Estimado (±50%) |
|----------|----------------|
| Recursos humanos | $ |
| Infraestructura / herramientas | $ |
| Contingency (15-25%) | $ |
| **Total** | **$** |

### Assumptions and Constraints

| Tipo | Descripción |
|------|-------------|
| **Assumption** | [supuesto que se asume como verdadero] |
| **Constraint** | [limitación que no puede cambiarse: tiempo, presupuesto, tecnología] |

### Sponsor Authorization

| Campo | Valor |
|-------|-------|
| **Sponsor** | [nombre, cargo] |
| **Fecha de autorización** | [fecha] |
| **Nivel de autoridad del PM** | [qué puede aprobar el PM sin consultar al sponsor] |
| **Firma / Confirmación** | [firma o confirmación escrita] |

### Project Manager Assigned

| Campo | Valor |
|-------|-------|
| **Project Manager** | [nombre] |
| **Nivel de autoridad** | [descripción de límites de decisión] |
| **Fecha de asignación** | [fecha] |

---

## Stakeholder Register

| Nombre | Rol | Organización / Área | Influence (H/M/L) | Interest (H/M/L) | Current Engagement | Desired Engagement |
|--------|-----|--------------------|--------------------|-------------------|-------------------|-------------------|
| | | | | | Unaware / Resistant / Neutral / Supportive / Leading | |

> **Niveles de engagement:**
> - Unaware: no conoce el proyecto ni su impacto
> - Resistant: conoce el proyecto y se opone
> - Neutral: conoce pero no apoya ni se opone
> - Supportive: conoce y apoya
> - Leading: activamente involucrado y promueve el proyecto

---

## Power/Interest Grid

| Cuadrante | Stakeholders | Estrategia |
|-----------|-------------|-----------|
| **Alto Poder / Alto Interés** — Manage closely | | Involucrar activamente, reuniones regulares |
| **Alto Poder / Bajo Interés** — Keep satisfied | | Informar periódicamente, no abrumar con detalle |
| **Bajo Poder / Alto Interés** — Keep informed | | Mantener informados, capturar conocimiento |
| **Bajo Poder / Bajo Interés** — Monitor | | Monitorear cambios en su engagement |

---

## High-Level Risk Log

| Risk ID | Descripción | Categoría | P | I | Score P×I | Respuesta preliminar | Owner |
|---------|-------------|-----------|---|---|-----------|---------------------|-------|
| R-001 | | Técnico | | | | | |

---

## Evaluación de completitud

- [ ] Project Charter firmado por el sponsor
- [ ] Stakeholders de Poder Alto (Poder H / Interés H) identificados y contactados
- [ ] PM asignado con nivel de autoridad explícito
- [ ] Top riesgos identificados (mínimo 5)
- [ ] Equipo core confirmado para Planning

---

## Decisión de flujo

- [ ] **Avanzar a pm:planning** — Charter firmado, stakeholders identificados, PM asignado
- [ ] **Permanecer en pm:initiating** — Motivo: [falta de firma / business need no validado / stakeholders incompletos]
