# BA Plan — [Nombre del proyecto]

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: ba:planning
author: [nombre]
status: Borrador
```

---

## BA Plan

### Approach

**Enfoque seleccionado:** [ ] Planificado (upfront) · [ ] Adaptativo (iterativo)

**Justificación:**

| Criterio | Evaluación para este proyecto |
|---------|------------------------------|
| Dominio del negocio | [bien conocido / nuevo / cambiante] |
| Requisitos | [estables / emergentes / evolutivos] |
| Disponibilidad de stakeholders | [alta / media / limitada] |
| Ciclo del proyecto | [waterfall / RUP / ágil] |
| Costo de cambios tardíos | [alto / bajo] |

**Conclusión:** [Justificación del enfoque elegido]

---

### BA Activities y técnicas planificadas

| Actividad | Técnica BABOK | KA | Timing | Stakeholders |
|-----------|---------------|----|--------|-------------|
| [ej: Elicitar necesidades] | [ej: Entrevistas] | ba:elicitation | [ej: Semana 1-2] | [ej: SME, Sponsor] |
| [ej: Analizar estado actual] | [ej: Process mapping] | ba:strategy | [ej: Semana 2] | [ej: SME] |
| [ej: Especificar requisitos] | [ej: Use cases] | ba:requirements-analysis | [ej: Semana 3-4] | [ej: SME, IT] |
| [ej: Gestionar cambios] | [ej: Change Control] | ba:requirements-lifecycle | [ej: Continuo] | [ej: CCB] |

---

### Deliverables de BA

| Deliverable | KA | Destinatario | Criterio de aceptación | Fecha estimada |
|-------------|----|--------------|-----------------------|---------------|
| BA Plan (este doc) | ba:planning | Sponsor | Firmado por el sponsor | [fecha] |
| ba-progress.md | ba:planning | BA (tracking) | 6 KAs con estado inicial | [fecha] |
| Elicitation results | ba:elicitation | Equipo proyecto | Confirmados por stakeholders | [fecha] |
| Requirements spec | ba:requirements-analysis | IT + Sponsor | Verificados + validados | [fecha] |
| Traceability Matrix | ba:requirements-lifecycle | QA + PM | Requisitos trazados 100% | [fecha] |

---

## Stakeholder Engagement Approach

| Stakeholder | Rol | Influencia | Interés BA | Necesidades del BA | Técnica | Frecuencia | Disponibilidad |
|-------------|-----|-----------|------------|-------------------|---------|-----------|---------------|
| [nombre] | Sponsor | Alta | Alta | Dirección estratégica, sign-off | Entrevista + revisión | Semanal | [horas/semana] |
| [nombre] | SME | Alta | Alta | Conocimiento del dominio, validación | Entrevistas + talleres | Bi-semanal | [horas/semana] |
| [nombre] | Usuario final | Media | Media | Necesidades operacionales, UAT | Focus group + observación | Por fase | [horas/sesión] |
| [nombre] | IT / Arquitecto | Media | Baja | Restricciones técnicas, viabilidad | Reunión técnica | Por deliverable | [horas/reunión] |

---

## RACI — Actividades de BA

| Actividad de BA | BA | Sponsor | SME | Usuario Final | IT |
|----------------|:--:|:-------:|:---:|:-------------:|:--:|
| Elicitar requisitos | R/A | C | C | C | I |
| Validar requisitos | R | A | C | C | C |
| Aprobar especificaciones | I | A | C | I | C |
| Gestionar cambios de requisitos | R/A | C | I | I | C |
| Evaluar la solución | R/A | C | I | C | C |

> R = Responsible · A = Accountable · C = Consulted · I = Informed

---

## Governance Approach

**Decisiones que el BA puede tomar autónomamente:**
- [ej: Selección de técnicas de elicitación]
- [ej: Formato de la documentación de requisitos]
- [ej: Priorización interna de actividades de BA]

**Decisiones que requieren aprobación del sponsor:**
- [ej: Cambios al scope del BA Plan]
- [ej: Cambios a requisitos Must Have aprobados]
- [ej: Diferimiento de actividades de BA por limitaciones de recursos]

**Change Request process:**
- Cualquier cambio a requisitos aprobados debe crear un CR documentado
- CRs con impacto ≤ [umbral] → aprobación del BA lead
- CRs con impacto > [umbral] → CCB o sponsor

**Priorización:** [Quién decide la prioridad relativa — ej: Sponsor con input del SME]

**Sign-off:** [Quién firma los deliverables — ej: Sponsor para BA Plan, SME para especificaciones]

---

## Evaluación de completitud

- [ ] Enfoque de BA definido (planificado vs adaptativo) con justificación
- [ ] BA Activities mapeadas a KAs de BABOK con timing
- [ ] Stakeholders de influencia alta cubiertos con técnica y frecuencia
- [ ] RACI completo para actividades de BA
- [ ] Governance con proceso de decisión y CR process claro
- [ ] ba-progress.md creado con estado inicial de las 6 KAs
- [ ] Acuerdo con sponsor sobre nivel de formalidad y deliverables

---

## Routing — próxima KA

Ver Routing Table en SKILL.md — seleccionar según contexto del proyecto:

| Situación | Próxima KA |
|-----------|-----------|
| Dominio poco conocido → entender el negocio | `ba:elicitation` |
| Problema de negocio claro que analizar | `ba:strategy` |
| Requisitos iniciales pero sin modelar | `ba:requirements-analysis` |
| Requisitos existentes que gestionar | `ba:requirements-lifecycle` |
| Solución entregada → evaluar valor | `ba:solution-evaluation` |

**Decisión para este proyecto:** [KA seleccionada + razón]
