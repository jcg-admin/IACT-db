---
name: rup-inception
description: "Use when starting a RUP project or iteration. rup:inception — establish project vision, identify critical risks, validate business case, reach LCO milestone to authorize Elaboration."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["RUP inception", "vision document", "LCO milestone", "business case RUP", "project kickoff RUP"]
updated_at: 2026-04-17 01:00:00
---

# /rup-inception — RUP: Inception

> *"The goal of Inception is not to define the system completely — it is to establish enough understanding to justify the investment in Elaboration."*

Ejecuta la fase **Inception** de RUP. Alinea a los stakeholders en la visión y alcance, identifica los riesgos críticos, valida el business case y obtiene el milestone **LCO (Lifecycle Objectives)** para autorizar el inicio de Elaboration.

**THYROX Stage:** Stage 1 DISCOVER / Stage 3 DIAGNOSE.

**Milestone:** LCO — Lifecycle Objectives.

---

## Pre-condición

- Work package activo con descripción inicial del sistema o producto a desarrollar.
- Sponsor identificado con autoridad para aprobar el business case.
- Para iteraciones subsiguientes de Inception: lección del LCO anterior documentando por qué no se alcanzó.

---

## Cuándo usar este paso

- Al inicio de un proyecto nuevo con RUP
- Cuando una iteración de Inception no alcanzó el LCO y se requiere una iteración adicional
- Cuando el scope o el business case cambia significativamente durante Elaboration

## Cuándo NO usar este paso

- Si el proyecto ya tiene LCO aprobado y el equipo está listo para Elaboration
- Para sistemas muy pequeños donde la visión es obvia y los riesgos son mínimos (PDCA o DMAIC puede ser más apropiado)

---

## Tabla de intensidad de disciplinas en Inception

Esta tabla orienta qué trabajo es central vs periférico en esta fase:

| Disciplina | Intensidad en Inception | Foco principal |
|-----------|------------------------|----------------|
| Business Modeling | **Alta** | Entender el dominio del negocio |
| Requirements | **Alta** | Vision Document, 10% Use Case Model |
| Analysis & Design | Media | Arquitectura de alto nivel conceptual |
| Implementation | Baja | Solo prototipos de concepto si es necesario |
| Test | Baja | Solo plan de test de alto nivel |
| Deployment | Nula | Demasiado temprano |
| Config & Change Mgmt | Baja | Setup del repositorio y herramientas |
| Project Management | **Alta** | Plan inicial, estimaciones rough |
| Environment | **Alta** | Setup del entorno de desarrollo |

> **Red Flag de BDUF:** Si Implementation está en "Alta" durante Inception, el equipo está haciendo Big Design Up Front — diseñando la solución antes de entender el problema.

---

## Actividades

### 1. Definir la visión del sistema

El Vision Document es el artefacto central de Inception. Define el "qué" sin comprometerse con el "cómo":

| Sección | Contenido | Criterio de calidad |
|---------|-----------|---------------------|
| **Problem Statement** | El problema que el sistema resuelve, para quién, con qué impacto | Sin mencionar la solución |
| **System Overview** | Descripción de alto nivel del sistema propuesto | No más de 1-2 párrafos; sin detalles de implementación |
| **Stakeholders** | Quiénes interactúan con el sistema (actores) + quiénes son afectados | Distinguir usuarios del sistema vs stakeholders del proyecto |
| **Scope** | Qué está dentro y fuera del sistema | Boundary del sistema explícita (IN/OUT) |
| **Key Features** | Capacidades de alto nivel (no casos de uso detallados) | 5-10 features; no spec completa |
| **Assumptions & Constraints** | Qué se asume como verdad; qué está fijo | Documentar; no ignorar |

**Técnicas para construir la visión:**
- Workshop de visión con stakeholders clave (2-4 horas máximo)
- Entrevistas individuales a usuarios representativos antes del workshop
- Análisis de documentos existentes (contratos, RFPs, especificaciones previas)
- Review de sistemas análogos en el dominio

### 2. Identificar casos de uso de alto nivel (~10%)

En Inception, no se especifican los Use Cases en detalle — se identifican los críticos:

| Tipo de Use Case | Criterio de inclusión en Inception |
|-----------------|-----------------------------------|
| **Arquitecturalmente significativos** | Involucra componentes técnicos de alto riesgo |
| **De alto riesgo** | Si falla, compromete el proyecto completo |
| **Críticos para el business case** | Su valor justifica la inversión |
| **De alcance incierto** | Necesita más análisis para confirmar factibilidad |

> Solo describir el nombre + actor + objetivo de los Use Cases en Inception — no el flujo completo. El flujo detallado es trabajo de Elaboration.

### 3. Identificar y clasificar riesgos críticos

RUP es risk-driven — los riesgos gobiernan la planificación de iteraciones:

| Categoría de riesgo | Preguntas clave | Herramienta |
|--------------------|----------------|-------------|
| **Técnico** | ¿Tecnología no probada? ¿Performance crítica? ¿Integración compleja? | Spike técnico / Architecture Prototype draft |
| **Negocio** | ¿Business case sólido? ¿Stakeholders alineados? ¿Regulación? | Workshop de validación |
| **Proyecto** | ¿Equipo con la experiencia necesaria? ¿Fechas realistas? | Estimación rough + team assessment |
| **Requisitos** | ¿Scope estable? ¿Stakeholders con prioridades claras? | Vision workshop |

**Risk List format:**

| Risk ID | Descripción | Probabilidad (A/M/B) | Impacto (A/M/B) | Plan de respuesta | Fase target para mitigar |
|---------|-------------|---------------------|----------------|------------------|--------------------------|
| R-001 | [descripción] | | | | |

### 4. Validar el Business Case

El Business Case debe convencer al sponsor de que la inversión en Elaboration vale la pena:

| Elemento | Contenido | Criterio de aprobación |
|----------|-----------|------------------------|
| **Problema de negocio** | Costo/impacto del problema sin resolver | Cuantificado ($/tiempo) |
| **Solución propuesta** | Descripción de alto nivel del sistema | Alineada con Vision |
| **ROI estimado** | Beneficio esperado / Inversión estimada | ROI > 1 o justificación estratégica |
| **Costo de no hacer nada** | ¿Qué pasa si no se construye el sistema? | Cuantificado |
| **Riesgos del proyecto** | Top-5 riesgos identificados + planes | Riesgos críticos con plan de respuesta |

### 5. Plan inicial de proyecto

En Inception, el plan es rough (±50% de accuracy es aceptable):

| Elemento | Nivel de detalle en Inception |
|----------|-------------------------------|
| **Fases y milestones** | Fechas target para LCA, IOC, PD |
| **Estimación de esfuerzo** | Order of magnitude (rough); mejorará en Elaboration |
| **Composición del equipo** | Roles necesarios, no necesariamente personas específicas |
| **Recursos clave** | Hardware, licencias, entornos |

---

## Criterio de milestone LCO — ¿avanzar o nueva iteración?

**Avanzar a Elaboration (todos los siguientes deben cumplirse):**
1. Stakeholders clave validaron y aprobaron el Vision Document
2. Business case aprobado por el sponsor
3. Riesgos críticos identificados con plan de respuesta inicial
4. ≥ 10% del Use Case Model existe (los UC más críticos nombrados y descritos brevemente)
5. El equipo tiene acceso a los recursos necesarios para Elaboration

**Nueva iteración de Inception (cualquiera de los siguientes):**
- Stakeholders clave no están alineados en la visión o el scope
- Business case cuestionado o rechazado por el sponsor
- Riesgos críticos identificados que podrían cancelar el proyecto — requieren más investigación antes de comprometer recursos en Elaboration
- Cambio significativo de scope que invalida la visión actual

> **Límite de Inception:** Inception no debe superar el 10% del esfuerzo total del proyecto. Si se necesitan más de 2 iteraciones, el problema suele ser falta de claridad en el negocio, no falta de análisis técnico.

---

## Artefacto esperado

`{wp}/rup-inception.md` — usar template: [rup-inception-template.md](./assets/rup-inception-template.md)

---

## Red Flags — señales de Inception mal ejecutada

- **Vision Document que describe la implementación** — *"el sistema usará microservicios con PostgreSQL"* en Inception es BDUF; la visión describe el problema y las capacidades, no la arquitectura
- **Risk List vacía o con solo 1-2 riesgos** — un proyecto de software con pocos riesgos identificados en Inception tiene una Risk List incompleta, no un proyecto de bajo riesgo
- **Inception > 10% del esfuerzo total** — señal de análisis paralítico; si no se puede alinear a los stakeholders en < 10%, el problema es político, no técnico
- **Business case sin números** — *"mejorará la eficiencia"* no es business case; debe tener costo del problema y beneficio esperado
- **LCO declarado sin checklist** — "ya tenemos la visión, pasemos a Elaboration" sin verificar los 5 criterios lleva a Elaboration sin fundamentos
- **Use Cases detallados en Inception** — describir flujos completos en Inception es trabajo prematuro; los UC críticos se nombran e identifican, no se especifican

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rup:inception
flow: rup
rup_phase: inception
rup_iteration: 1
```

**Al COMPLETAR** (LCO alcanzado):
```yaml
methodology_step: rup:inception  # completado → listo para rup:elaboration
flow: rup
rup_phase: inception
rup_iteration: [N]
```

## Siguiente paso

- LCO alcanzado → `rup:elaboration`
- LCO no alcanzado → nueva iteración de `rup:inception` con lecciones documentadas

---

## Limitaciones

- La calidad de Inception depende de la disponibilidad y compromiso de los stakeholders — sin acceso a los tomadores de decisión, Inception produce un Vision Document hipotético
- Las estimaciones en Inception tienen ±50% de accuracy — no comprometer fechas ni presupuestos basados en estas estimaciones; mejorarán en Elaboration
- RUP es un framework, no una metodología rígida — en proyectos pequeños, Inception puede completarse en días; en proyectos grandes, puede tomar semanas

---

## Reference Files

### Assets
- [rup-inception-template.md](./assets/rup-inception-template.md) — Template completo: Vision Document, Use Case Model 10%, Risk List, Business Case, Plan inicial, checklist LCO

### References
- [lco-criteria.md](./references/lco-criteria.md) — Criterios de evaluación LCO: 5 criterios con sub-criterios, checklist de concurrencia, decisiones típicas, límites de tiempo

### Scripts
- [check-lco-criteria.sh](./scripts/check-lco-criteria.sh) — Verifica readiness del milestone LCO inspeccionando el work package

```bash
# Verificar LCO readiness del WP activo
bash .claude/skills/rup-inception/scripts/check-lco-criteria.sh \
  .thyrox/context/work/YYYY-MM-DD-HH-MM-SS-nombre/
```

**Criterios verificados:** Vision Document con indicador de aprobación · Business Case con datos financieros · Risk List con ≥3 riesgos · Use Case Model con ≥1 UC · Plan con milestones LCA/IOC/PD. Sale con código 0 si todos pasan, 1 si hay criterios faltantes.
