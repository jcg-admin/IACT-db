---
name: pm-executing
description: "Use when managing the execution of a PMBOK project. pm:executing — direct and manage project work, conduct quality audits, manage team and stakeholder engagement, implement approved changes."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["project execution", "deliverables management", "direct and manage", "PMBOK executing", "resource coordination"]
updated_at: 2026-04-17 00:00:00
---

# /pm-executing — PMBOK: Executing

> *"Executing is where plans meet reality. The PM's job is not to protect the plan — it's to produce deliverables while managing the inevitable gap between what was planned and what is actually happening."*

Ejecuta el **Grupo de Proceso Executing** de PMBOK. Dirige y gestiona el trabajo del proyecto para producir los deliverables, conduce auditorías de calidad, gestiona el equipo y el engagement de stakeholders, e implementa los cambios aprobados.

**THYROX Stage:** Stage 10 IMPLEMENT.

**Outputs clave:** Deliverables · Work Performance Data · Change Requests · Issue Log updates.

---

## Pre-condición

Requiere: `{wp}/pm-planning.md` con:
- Project Management Plan aprobado (scope baseline, schedule baseline, cost baseline)
- Roles y responsabilidades definidos (RACI)
- Plan de calidad con estándares definidos

---

## Cuándo usar este paso

- Cuando el Project Management Plan ha sido aprobado y el equipo está listo para trabajar
- Para cada ciclo de trabajo dentro de la fase de ejecución
- Cuando hay cambios aprobados que requieren acción de ejecución

## Cuándo NO usar este paso

- Sin Project Management Plan aprobado — ejecutar sin plan es trabajo no gestionado
- Si el alcance no está definido — se producirán deliverables incorrectos sin poder medirlos

---

## Knowledge Areas activas en Executing

| Knowledge Area | Intensidad | Proceso PMBOK |
|---------------|-----------|---------------|
| Integration Management | **Alta** | Direct and Manage Project Work |
| Quality Management | **Alta** | Perform Quality Assurance |
| HR / Resource Management | **Alta** | Acquire Resources, Develop Team, Manage Team |
| Communications Management | **Alta** | Manage Communications |
| Stakeholder Management | **Alta** | Manage Stakeholder Engagement |
| Procurement Management | Media | Conduct Procurements (si aplica) |
| Risk Management | Media | Implement Risk Responses |
| Scope / Schedule / Cost | Baja | Solo monitoreo (Monitoring & Controlling) |

---

## Actividades

### 1. Direct and Manage Project Work

El PM dirige el trabajo del equipo para producir los deliverables del proyecto:

| Actividad | Descripción | Frecuencia |
|-----------|-------------|-----------|
| **Daily standups / status checks** | Estado de trabajo en progreso, impedimentos, próximos pasos | Diario o cada iteración |
| **Work assignments** | Asignar tasks del WBS a miembros del equipo según RACI | Al inicio de cada periodo |
| **Deliverable review** | Revisar deliverables completados antes de enviar a QA | Por cada deliverable |
| **Issue log management** | Registrar y escalar issues que no pueden resolverse a nivel operativo | Continuo |
| **Change request generation** | Crear change requests formales cuando el trabajo requiere modificar el plan aprobado | Cuando hay varianza |

**Issue Log:**

| Campo | Descripción |
|-------|-------------|
| **Issue ID** | I-001, I-002, ... |
| **Descripción** | Qué problema está bloqueando o impactando el trabajo |
| **Fecha identificado** | Cuándo se detectó el issue |
| **Asignado a** | Quién debe resolver el issue |
| **Prioridad** | Alta / Media / Baja |
| **Estado** | Abierto / En progreso / Escalado / Cerrado |
| **Resolución** | Cómo se resolvió (cuando está cerrado) |

> **Issue vs Risk:** Un issue es un riesgo que ya ocurrió. Los riesgos se gestionan en el Risk Register; los issues que materializan se trasladan al Issue Log y se activan los planes de respuesta.

### 2. Perform Quality Assurance

Quality Assurance (QA) verifica que los procesos del proyecto producen deliverables de calidad:

| Actividad | Descripción | Output |
|-----------|-------------|--------|
| **Quality Audits** | Revisión independiente de si el proyecto está siguiendo los procesos definidos | Audit report con findings y recommendations |
| **Process analysis** | Identificar ineficiencias en los procesos de trabajo — eliminar pasos que no agregan valor | Process improvement recommendations |
| **Standards compliance check** | Verificar que los deliverables cumplen los estándares definidos en el Quality Plan | Compliance checklist completado |

**Quality Audit checklist:**

| Área | Preguntas clave |
|------|----------------|
| **Scope compliance** | ¿El trabajo producido está dentro del scope aprobado? |
| **Quality standards** | ¿Los deliverables cumplen los criterios de aceptación definidos? |
| **Process adherence** | ¿El equipo está siguiendo los procesos definidos (code reviews, testing, etc.)? |
| **Documentation** | ¿Los artefactos del proyecto están actualizados y completos? |
| **Change control** | ¿Los cambios al scope/schedule/cost están pasando por el proceso de change control? |

> **Diferencia QA vs QC:** Quality Assurance = auditar el proceso para prevenir defectos. Quality Control = inspeccionar los deliverables para detectar defectos. QA en Executing, QC en Monitoring & Controlling.

### 3. Manage Team

El PM gestiona el equipo para maximizar el performance:

| Actividad | Descripción |
|-----------|-------------|
| **Team performance assessment** | Evaluar el desempeño del equipo y de miembros individuales |
| **Conflict resolution** | Resolver conflictos dentro del equipo usando técnicas de resolución |
| **Coaching y desarrollo** | Identificar gaps de skills y apoyar el desarrollo del equipo |
| **Recognition** | Reconocer y recompensar el buen desempeño para mantener la motivación |

**Técnicas de resolución de conflictos (en orden de preferencia PMBOK):**

| Técnica | Descripción | Cuándo usar |
|---------|-------------|-------------|
| **Collaborating / Problem Solving** | Buscar solución que satisface a ambas partes | Primera opción siempre |
| **Compromising** | Cada parte cede algo | Cuando el tiempo apremia y ambas posiciones son válidas |
| **Accommodating / Smoothing** | Una parte cede para preservar la relación | Cuando la relación importa más que el issue |
| **Forcing** | El PM impone la decisión | Solo cuando hay urgencia o seguridad involucrada |
| **Avoiding / Withdrawing** | Posponer la resolución | Cuando el issue puede resolverse solo |

> **Regla PMBOK:** Collaborating produce las soluciones más duraderas. Forcing produce las menos duraderas. Avoiding solo es válido cuando el tiempo resuelve el issue.

### 4. Manage Stakeholder Engagement

Mantener a los stakeholders engaged según su cuadrante del Power/Interest Grid:

| Estrategia | Acciones concretas |
|-----------|-------------------|
| **Manage Closely** (Poder Alto / Interés Alto) | Reuniones regulares, involucrar en decisiones, comunicar proactivamente los riesgos |
| **Keep Satisfied** (Poder Alto / Interés Bajo) | Reportes ejecutivos periódicos, consultar antes de decisiones que los afectan |
| **Keep Informed** (Poder Bajo / Interés Alto) | Updates regulares del proyecto, escuchar sus concerns y responder |
| **Monitor** (Poder Bajo / Interés Bajo) | Comunicación mínima, revisar si el cuadrante cambia |

**Señales de desengagement a observar:**

- Sponsor que no responde a issues escalados en > 3 días hábiles
- Key stakeholder que no asiste a reviews o demos
- Usuarios que no participan en UAT cuando se les convoca
- Resistencia pasiva (aprobación verbal pero sin acciones)

### 5. Manage Communications

Ejecutar el Communications Management Plan:

| Artefacto de comunicación | Frecuencia | Audiencia | Contenido |
|--------------------------|-----------|-----------|-----------|
| **Status Report** | Semanal o quincenal | Sponsor + equipo | Progreso vs plan, issues, riesgos activos, próximos hitos |
| **Executive Dashboard** | Mensual | Sponsor + steering committee | EVM summary, RAG status (Red/Amber/Green), key decisions needed |
| **Team Standup** | Diario o por sprint | Equipo del proyecto | Qué se hizo, qué se hará, qué bloquea |
| **Stakeholder Update** | Según plan de comms | Según stakeholder | Relevante para cada stakeholder según sus interests |

---

## Criterio de completitud — ¿cuándo Executing termina?

Executing no "termina" en una fecha — continúa hasta que todos los deliverables del proyecto están completos y verificados. El cierre de Executing ocurre cuando:

1. Todos los deliverables del WBS han sido completados
2. Los deliverables han pasado el Quality Control de Monitoring & Controlling
3. No hay issues críticos abiertos en el Issue Log
4. El sponsor ha revisado los deliverables (previa a la aceptación formal en Closing)

---

## Artefacto esperado

`{wp}/pm-executing.md`

usar template: [status-report-template.md](./assets/status-report-template.md)

---

## Red Flags — señales de Executing mal gestionado

- **Issues que no se escalan** — si los miembros del equipo resuelven issues por su cuenta sin documentarlos, el PM no tiene visibilidad del estado real del proyecto
- **Scope creep silencioso** — trabajo adicional que se hace sin change request porque "es pequeño" acumula varianza de schedule y costo que no aparece en los reportes hasta que es tarde
- **Quality Assurance omitida** — si la QA solo ocurre al final, los defectos de proceso se detectan cuando la corrección es más costosa
- **Equipo que no reporta impedimentos** — en un equipo saludable, los impedimentos se reportan inmediatamente; si nadie reporta impedimentos durante semanas, la comunicación está rota
- **Stakeholders que "no tienen tiempo para reuniones"** — un stakeholder clave que evita las reuniones de status puede estar comunicando desengagement o resistencia al cambio

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pm:executing
flow: pm
pm_process_group: executing
```

**Al COMPLETAR** (todos los deliverables completados):
```yaml
methodology_step: pm:executing  # completado → listo para pm:closing
flow: pm
pm_process_group: executing
```

## Siguiente paso

- Todos los deliverables completados → `pm:closing`
- En paralelo continuo → `pm:monitoring` (Monitoring & Controlling corre en paralelo con Executing)

---

## Limitaciones

- Executing y Monitoring & Controlling son paralelos, no secuenciales — en la práctica, el PM está ejecutando y monitoreando simultáneamente en cada periodo de trabajo
- La resolución de conflictos documentada aquí es para conflictos del equipo del proyecto; los conflictos con stakeholders externos siguen un proceso diferente dependiendo de si hay contrato
- En proyectos ágiles, los "sprints" o "iteraciones" son instancias de Executing + Monitoring que se repiten; PMBOK describe el contenido de estas actividades, no la cadencia específica

---

## Reference Files

### Assets
- [status-report-template.md](./assets/status-report-template.md) — Template de status report: RAG status, hitos, deliverables, issue log, QA results, team performance, stakeholder engagement, CRs

### References
- [team-management.md](./references/team-management.md) — 5 técnicas de resolución de conflictos PMBOK, selector por contexto, escalation path, issue log gestión, QA vs QC, scope creep control
