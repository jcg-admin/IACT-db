---
name: pm-planning
description: "Use when developing the project management plan in PMBOK. pm:planning — develop all subsidiary plans across 10 knowledge areas, create WBS, define schedule with CPM/PERT, estimate costs, plan quality/risks/communications/stakeholders."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["project management plan", "WBS", "schedule planning", "PMBOK planning", "cost estimation"]
updated_at: 2026-04-17 00:00:00
---

# /pm-planning — PMBOK: Planning

> *"Planning is the most undervalued process group in project management. Every hour spent in solid planning eliminates three to ten hours of rework during execution. The plan is not the goal — the plan is the tool that makes the goal achievable."*

Ejecuta el **Grupo de Proceso Planning** de PMBOK. Desarrolla todos los planes subsidiarios de las 10 Knowledge Areas, crea el WBS, define el cronograma con CPM/PERT, estima costos, planifica calidad, riesgos, comunicaciones y stakeholders. El output es el **Project Management Plan** aprobado.

**THYROX Stage:** Stage 5 STRATEGY / Stage 6 SCOPE / Stage 7 DESIGN/SPECIFY.

**Outputs clave:** Project Management Plan · WBS · Schedule Baseline · Cost Baseline · Risk Register.

---

## Pre-condición

Requiere: `{wp}/pm-initiating.md` con:
- Project Charter firmado por el sponsor
- Stakeholder Register inicial completo
- PM asignado con autoridad delegada

---

## Cuándo usar este paso

- Cuando el Project Charter está firmado y el equipo está listo para planificar
- Al iniciar la planificación de una nueva fase en proyectos multi-fase
- Cuando un cambio aprobado requiere re-planificación significativa de una o más KAs

## Cuándo NO usar este paso

- Sin Project Charter firmado — planificar sin autorización formal genera trabajo que puede ser rechazado
- Si hay aspectos del negocio aún no claros — regresar a Initiating para aclarar antes de planificar

---

## Knowledge Areas en Planning

| # | Knowledge Area | Plan subsidiario clave |
|---|---------------|----------------------|
| 1 | Integration Management | Project Management Plan (integra todos los demás) |
| 2 | Scope Management | Scope Management Plan · WBS · WBS Dictionary |
| 3 | Schedule Management | Schedule Management Plan · Network Diagram · Cronograma |
| 4 | Cost Management | Cost Management Plan · Cost Estimates · Cost Baseline |
| 5 | Quality Management | Quality Management Plan · Quality Metrics |
| 6 | Resource Management | Resource Management Plan · RACI · Staffing Plan |
| 7 | Communications Management | Communications Management Plan |
| 8 | Risk Management | Risk Management Plan · Risk Register |
| 9 | Procurement Management | Procurement Management Plan (si aplica) |
| 10 | Stakeholder Management | Stakeholder Engagement Plan |

---

## Actividades

Siete knowledge areas activas en Planning. Detalles de técnicas en [references/planning-techniques.md](references/planning-techniques.md).

| Actividad | Output | Técnicas clave |
|-----------|--------|----------------|
| **1. Scope Management** | WBS + WBS Dictionary | WBS (regla 8/80), Scope Statement |
| **2. Schedule Management** | Schedule baseline + Critical Path | CPM, PERT, Fast Tracking, Crashing |
| **3. Cost Management** | Cost Baseline | Analogous, Parametric, Bottom-up, Three-point |
| **4. Quality Management** | Quality Management Plan | QA auditorías, QC inspecciones, Definition of Done |
| **5. Risk Management** | Risk Register (top 10+) | Probability × Impact Matrix, 8 estrategias de respuesta |
| **6. Communications** | Communications Plan | Matriz de comunicaciones por audiencia/frecuencia/formato |
| **7. RACI Matrix** | Accountability matrix | R/A/C/I por actividad — exactamente 1 A por actividad |

---

## Criterio de completitud — ¿Project Management Plan aprobado?

**Plan aprobado (todos los siguientes):**
1. WBS completo con todos los deliverables del scope del Charter
2. Schedule con Critical Path identificado y fecha de completion aceptable para el sponsor
3. Cost Baseline dentro del budget del Charter (o re-negociado con sponsor)
4. Risk Register con top 10 riesgos con planes de respuesta
5. RACI completo — todo el equipo conoce sus responsabilidades
6. Plan de comunicaciones con todos los stakeholders de Poder Alto cubiertos
7. Project Management Plan aprobado formalmente por el sponsor

**Requiere más iteración de Planning:**
- Schedule o cost excede el Charter y no hay acuerdo con el sponsor
- Riesgos críticos identificados que pueden cancelar el proyecto — investigar antes de continuar
- Stakeholders de Poder Alto no alineados en scope o prioridades

---

## Artefacto esperado

`{wp}/pm-planning.md`

usar template: [project-plan-template.md](./assets/project-plan-template.md)

---

## Red Flags — señales de Planning mal ejecutado

- **WBS de 2 niveles** — un WBS con solo "Fases" y "Deliverables" no tiene suficiente granularidad para estimar costos ni asignar responsabilidades; el nivel de Work Package es fundamental
- **Cronograma sin Critical Path identificado** — un cronograma donde todas las actividades parecen igualmente importantes indica que el análisis de red no se realizó
- **Risk Register con solo 3-4 riesgos** — igual que en PDCA y RUP, un proyecto con muy pocos riesgos identificados tiene un Risk Register incompleto
- **RACI con muchos A por actividad** — si 3 personas son "Accountable" de la misma actividad, nadie es realmente accountable; hay que resolver antes de ejecutar
- **Plan aprobado solo por el PM** — el Project Management Plan debe ser aprobado por el sponsor; la aprobación del PM es insuficiente para autorizar el inicio de Executing
- **Costo estimado sin reservas de contingencia** — un budget sin reservas está optimizado para el caso ideal, no para la realidad de los proyectos

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pm:planning
flow: pm
pm_process_group: planning
```

**Al COMPLETAR** (Project Management Plan aprobado):
```yaml
methodology_step: pm:planning  # completado → listo para pm:executing
flow: pm
pm_process_group: planning
```

## Siguiente paso

- Project Management Plan aprobado → `pm:executing` (+ `pm:monitoring` en paralelo)
- Plan no aprobado → más iteración de `pm:planning` con gaps documentados

---

## Limitaciones

- El nivel de detalle del plan debe ser proporcional al tamaño y complejidad del proyecto — un proyecto pequeño no necesita 50 páginas de plan; un proyecto de $10M sí
- Las estimaciones de Planning tienen ±10-20% de accuracy (vs ±50% de Initiating) — son más precisas pero siguen siendo estimaciones; comprometer fechas y costos exactos en contratos basados en estimaciones de Planning es riesgoso
- El Project Management Plan es una baseline, no una camisa de fuerza — está diseñado para ser actualizado mediante el proceso de Change Control cuando la realidad difiere del plan

---

## Reference Files

### Assets
- [project-plan-template.md](./assets/project-plan-template.md) — Template del Project Management Plan: WBS, schedule baseline, cost baseline, RACI, risk register, communications plan

### References
- [planning-techniques.md](./references/planning-techniques.md) — WBS regla 8-80, CPM, PERT, Fast Tracking/Crashing, Three-point estimation, Probability×Impact Matrix, RACI regla 1-A
