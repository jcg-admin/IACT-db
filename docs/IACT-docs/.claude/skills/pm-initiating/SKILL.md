---
name: pm-initiating
description: "Use when starting a PMBOK project or phase. pm:initiating — develop Project Charter, identify stakeholders, define high-level scope and risks, obtain formal authorization to proceed."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["project charter", "project authorization", "stakeholder identification", "PMBOK initiating", "project kickoff"]
updated_at: 2026-04-17 00:00:00
---

# /pm-initiating — PMBOK: Initiating

> *"Without a Project Charter, there is no project — only work. The Charter is the formal authorization that transforms effort into a managed initiative with accountability and scope."*

Ejecuta el **Grupo de Proceso Initiating** de PMBOK. Desarrolla el Project Charter, identifica los stakeholders clave, define el alcance de alto nivel y los riesgos iniciales, y obtiene la autorización formal para iniciar el proyecto.

**THYROX Stage:** Stage 1 DISCOVER / Stage 3 DIAGNOSE.

**Outputs clave:** Project Charter · Stakeholder Register.

---

## Pre-condición

- Work package activo con descripción inicial del proyecto o producto.
- Sponsor identificado con autoridad para firmar el Project Charter.
- Business need o problem statement definido (aunque sea preliminar).

---

## Cuándo usar este paso

- Al inicio de un proyecto nuevo con PMBOK
- Cuando se inicia una nueva fase de un proyecto existente (re-initiating)
- Cuando el alcance o el sponsor cambia significativamente durante la ejecución

## Cuándo NO usar este paso

- Si el Project Charter ya existe y fue aprobado — continuar en Planning
- Para cambios menores de alcance ya cubiertos por el proceso de Integrated Change Control

---

## Knowledge Areas activas en Initiating

| Knowledge Area | Intensidad | Entregable clave |
|---------------|-----------|-----------------|
| Integration Management | **Alta** | Project Charter |
| Stakeholder Management | **Alta** | Stakeholder Register |
| Scope Management | Media | Descripción preliminar de alcance |
| Risk Management | Media | Log de riesgos de alto nivel |
| Communications Management | Baja | Plan de comunicación preliminar |
| Cost / Schedule / Quality / HR / Procurement | Baja | Solo constraints de alto nivel |

---

## Actividades

### 1. Desarrollar el Project Charter

El Project Charter es el artefacto más importante de Initiating. Es la autorización formal del proyecto:

| Sección | Contenido | Criterio de calidad |
|---------|-----------|---------------------|
| **Project Purpose** | Por qué se hace el proyecto — business need, opportunity o regulatory requirement | Vinculado a un objetivo estratégico del negocio |
| **Measurable Objectives** | Qué debe lograr el proyecto — SMART goals | Cada objetivo tiene criterio de éxito verificable |
| **High-Level Requirements** | Qué necesitan los stakeholders — sin diseño técnico | Distingue entre necesidades del negocio y del producto |
| **High-Level Description** | Qué se va a construir/entregar — sin arquitectura | Suficiente para delimitar el scope |
| **High-Level Risks** | Top 5-7 riesgos identificados en este punto | Al menos un riesgo técnico, uno de negocio, uno de proyecto |
| **Summary Milestone Schedule** | Hitos clave — fechas tentativas | No más de 5-7 milestones; precisión ±50% |
| **Summary Budget** | Estimación de orden de magnitud | Rango, no cifra puntual |
| **Sponsor Authorization** | Firma del sponsor que autoriza el proyecto | Firma física o digital del sponsor |
| **Project Manager Assigned** | PM designado con nivel de autoridad | PM nombrado antes de Planning |

**Fuentes para construir el Charter:**

| Fuente | Información que aporta |
|--------|----------------------|
| Contrato o SOW (si hay cliente externo) | Deliverables contractuales, fechas, penalidades |
| Business case | ROI, costo del problema, alternativas evaluadas |
| Enterprise Environmental Factors | Regulaciones, cultura, sistemas existentes |
| Organizational Process Assets | Plantillas, lecciones aprendidas de proyectos anteriores |

### 2. Identificar Stakeholders

El Stakeholder Register captura quién tiene interés o influencia sobre el proyecto:

| Campo | Descripción |
|-------|-------------|
| **Nombre** | Persona o grupo |
| **Rol en el proyecto** | Sponsor / User / SME / Regulator / Supplier / etc. |
| **Organización / Departamento** | Unidad funcional |
| **Información de contacto** | Email / teléfono |
| **Requirements** | Qué necesita este stakeholder del proyecto |
| **Expectations** | Qué espera en términos de comunicación y participación |
| **Influence** | Grado de poder para afectar el proyecto (Alto/Medio/Bajo) |
| **Interest** | Grado de interés en el proyecto (Alto/Medio/Bajo) |
| **Current Engagement** | Unaware / Resistant / Neutral / Supportive / Leading |
| **Desired Engagement** | Estado de engagement al que queremos mover al stakeholder |

#### Power/Interest Grid

Clasificar stakeholders en la matriz para planificar el engagement:

| Poder | Interés | Estrategia |
|-------|---------|-----------|
| **Alto** | **Alto** | Manage Closely — comunicación frecuente, involucrar en decisiones |
| **Alto** | **Bajo** | Keep Satisfied — informar de avances, consultar en decisiones que los afectan |
| **Bajo** | **Alto** | Keep Informed — updates regulares, escuchar sus concerns |
| **Bajo** | **Bajo** | Monitor — comunicación mínima, revisar periódicamente si el cuadrante cambia |

**Técnicas para identificar stakeholders:**

| Técnica | Cuándo usar |
|---------|-------------|
| **Entrevistas al sponsor** | Siempre — el sponsor conoce el mapa político |
| **Análisis organizacional (org chart)** | Para proyectos internos con múltiples áreas funcionales |
| **Revisión de proyectos similares anteriores** | Si existen stakeholders recurrentes en el dominio |
| **Brainstorming con el equipo del proyecto** | Para capturar stakeholders técnicos y operativos |
| **Stakeholder onion diagram** | Para proyectos complejos con muchos grupos de interés |

> **Regla crítica:** Los stakeholders se identifican en Initiating pero se gestionan durante TODA la vida del proyecto. El Stakeholder Register es un documento vivo.

### 3. Definir riesgos de alto nivel

En Initiating, el análisis de riesgos es preliminar:

| Campo | Descripción |
|-------|-------------|
| **Risk ID** | R-001, R-002, ... |
| **Descripción** | Causa → Evento → Efecto (ej: "Si el proveedor X no entrega la API → el módulo Y no puede completarse → impacto en la fecha de entrega") |
| **Categoría** | Técnico / Negocio / Externo / Organizacional |
| **Probabilidad** | Alta / Media / Baja |
| **Impacto** | Alto / Medio / Bajo |
| **Respuesta preliminar** | Avoid / Transfer / Mitigate / Accept |

> **Nota:** El Risk Register se elabora en detalle en Planning. En Initiating solo se identifican los riesgos que podrían cancelar el proyecto o impactar el Charter.

---

## Criterio de completitud — ¿avanzar a Planning?

**Avanzar a Planning (todos los siguientes deben cumplirse):**
1. Project Charter desarrollado, revisado y firmado por el sponsor
2. Stakeholder Register con al menos los stakeholders de Poder Alto identificados
3. PM asignado con autoridad delegada documentada en el Charter
4. Top riesgos identificados — al menos un riesgo de cada categoría principal
5. Equipo del proyecto confirmado (aunque sea parcialmente) para Planning

**Permanecer en Initiating (cualquiera de los siguientes):**
- Sponsor no disponible para firmar el Charter
- Business need no está claro ni validado
- Conflicto de objetivos entre stakeholders clave que bloquea la definición de scope
- Recursos no confirmados para iniciar Planning

---

## Artefacto esperado

`{wp}/pm-initiating.md`

usar template: [pm-initiating-template.md](./assets/pm-initiating-template.md)

---

## Red Flags — señales de Initiating mal ejecutado

- **Project Charter sin firma del sponsor** — un Charter sin firma es un documento de deseos, no una autorización formal. Sin firma, el PM no tiene autoridad para comprometer recursos
- **Stakeholder Register con solo 2-3 personas** — un proyecto de software con pocos stakeholders identificados tiene una lista incompleta, no un proyecto simple
- **Objetivos sin criterio de éxito verificable** — "mejorar la eficiencia" no es un objetivo PMBOK; "reducir el tiempo de procesamiento de pedidos de 48h a 24h" sí lo es
- **Charter que especifica la solución técnica** — el Charter define el QUÉ (business need), no el CÓMO (arquitectura). Si hay stack tecnológico en el Charter, es Planning prematuro
- **Riesgos omitidos por optimismo** — "este proyecto es simple, no hay riesgos grandes" es una señal de análisis incompleto, no de proyecto sin riesgos
- **PM asignado después de Planning** — sin PM desde el inicio, Planning carece de ownership y accountability

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pm:initiating
flow: pm
pm_process_group: initiating
```

**Al COMPLETAR** (Charter firmado):
```yaml
methodology_step: pm:initiating  # completado → listo para pm:planning
flow: pm
pm_process_group: initiating
```

## Siguiente paso

- Charter firmado → `pm:planning`
- Charter no firmado / business need no claro → permanecer en `pm:initiating`

---

## Limitaciones

- El Project Charter establece el baseline pero no detalla el plan — el plan detallado de scope, tiempo, costo y calidad se desarrolla en Planning
- Los stakeholders identificados en Initiating pueden cambiar durante el proyecto — revisar y actualizar el Stakeholder Register en cada proceso group
- Las estimaciones de costo y tiempo en el Charter tienen ±50% de accuracy — no comprometer fechas ni presupuestos fijos basados en estas estimaciones

---

## Reference Files

### Assets
- [pm-initiating-template.md](./assets/pm-initiating-template.md) — Template completo: Project Charter, Stakeholder Register, Power/Interest Grid, High-Level Risk Log, evaluación de completitud

### References
- [project-charter-guide.md](./references/project-charter-guide.md) — Técnicas de identificación de stakeholders, Power/Interest Grid 4 cuadrantes, objetivos SMART, ROM estimating, señales de Charter incompleto
