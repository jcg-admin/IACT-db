# BA Approach — Técnicas de Planificación del Análisis de Negocio

## Selección del enfoque: Planificado vs Adaptativo

| Dimensión | Enfoque Planificado | Enfoque Adaptativo |
|-----------|--------------------|--------------------|
| **Cuándo usar** | Dominio estable, requisitos claros desde el inicio, cambios costosos | Dominio nuevo, requisitos emergentes, alto nivel de incertidumbre |
| **Ciclo de vida** | Waterfall, RUP, cascada | Scrum, Kanban, SAFe |
| **Artefactos** | Especificaciones detalladas upfront; documentación formal | User stories, backlog; documentación just-in-time |
| **Stakeholder** | Disponibilidad limitada — alto impacto en planificado | Alta disponibilidad — requerida en adaptativo |
| **Riesgo del enfoque** | Cambios tardíos son costosos; puede quedar obsoleto | Scope creep si no hay governance; deuda de documentación |
| **Señal de mal ajuste** | BA documenta todo antes de que el negocio entienda el problema | BA construye sin documentar; trazabilidad imposible |

### Enfoque híbrido (cuando aplica)

| Componente | Enfoque |
|-----------|---------|
| Estrategia y contexto del negocio | Planificado (análisis upfront) |
| Especificación de features individuales | Adaptativo (just-in-time) |
| Gestión de cambios y trazabilidad | Planificado (RTM siempre) |
| Validación con stakeholders | Adaptativo (iterativa, frecuente) |

---

## Stakeholder Engagement Matrix

| Cuadrante | Influencia | Interés BA | Estrategia de engagement |
|-----------|:---------:|:----------:|--------------------------|
| **Gestionar de cerca** | Alta | Alta | Involucrar en decisiones; reuniones regulares; comunicar proactivamente riesgos de BA; solicitar sign-off formal |
| **Mantener satisfecho** | Alta | Baja | Actualizaciones ejecutivas periódicas; consultar antes de decisiones que los afectan; no saturar con detalles |
| **Mantener informado** | Baja | Alta | Updates regulares; responder sus preguntas; escuchar sus concerns; UAT con este grupo |
| **Monitorear** | Baja | Baja | Comunicación mínima; revisar si cambia su posición |

### Señales de desengagement de stakeholders en BA

| Señal | Interpretación | Acción del BA |
|-------|---------------|---------------|
| SME que no confirma resultados en > 5 días hábiles | Baja prioridad o desacuerdo no expresado | Reunión directa para entender el bloqueo |
| Usuario que no participa en validaciones | Desengagement o falta de tiempo | Hablar con su manager; ajustar timing |
| Sponsor que cambia prioridades sin CR | Desalineación con el BA Plan | Re-planificación formal con el sponsor |
| Aprobación verbal sin firma | Compromiso informal; riesgo de retractación | Requerir firma formal antes de proceder |

---

## Técnicas de planificación de actividades BA

### Descomposición de actividades por KA

| KA BABOK | Actividades típicas | Técnicas más usadas | Artefacto |
|---------|--------------------|--------------------|-----------|
| **Business Analysis Planning** | Planificar el trabajo de BA; definir governance | Stakeholder analysis, RACI | BA Plan + ba-progress.md |
| **Elicitation & Collaboration** | Entrevistar, facilitar talleres, observar | Entrevistas, JAD, Shadowing | Elicitation results |
| **Strategy Analysis** | Analizar estado actual/futuro, gap analysis | SWOT, VSM, gap table | Strategy analysis |
| **Requirements Analysis** | Modelar, especificar, verificar, priorizar | Use cases, user stories, MoSCoW | Requirements spec |
| **Requirements Life Cycle** | Trazar, gestionar cambios, mantener baseline | RTM, Change Control | Traceability Matrix |
| **Solution Evaluation** | Medir KPIs, evaluar valor, recomendar | Encuestas, analytics, ROI | Evaluation report |

### Estimación de esfuerzo de BA

| Tipo de proyecto | BA days típicos | Distribución recomendada |
|-----------------|----------------|--------------------------|
| Pequeño (< 3 meses) | 10-20 días | 20% Planning · 30% Elicitation · 30% Analysis · 20% Lifecycle |
| Mediano (3-9 meses) | 30-60 días | 15% Planning · 25% Elicitation · 35% Analysis · 25% Lifecycle |
| Grande (> 9 meses) | 80+ días | 10% Planning · 20% Elicitation · 35% Analysis · 25% Lifecycle · 10% Evaluation |

> **Regla de calibración:** El tiempo real de Elicitation suele duplicar la estimación original — los stakeholders tienen menos disponibilidad de la esperada y se necesitan múltiples rondas.

---

## Governance Approach — decisiones clave

### Matriz de decisión de governance

| Tipo de decisión | Quién decide | Proceso | Documentación |
|-----------------|-------------|---------|---------------|
| Técnica de elicitación | BA (autónomo) | Sin proceso formal | Nota en BA Plan |
| Prioridad de requisitos | Sponsor + BA | Revisión conjunta | Actualizar RTM |
| Cambio a requisito aprobado | CCB o sponsor | Change Request formal | CR + RTM actualizada |
| Diferir requisito | Sponsor | Sign-off formal | CR + RTM estado "Diferido" |
| Cancelar requisito | Sponsor | Sign-off formal | CR + RTM estado "Cancelado" |
| Cambio al BA Plan | Sponsor | Re-planificación | BA Plan v2 |

### Umbrales de impacto para escalación

| Impacto del cambio | Quién aprueba |
|-------------------|--------------|
| Cambio en < 1 requisito sin impacto en schedule | BA lead |
| Cambio en 1-5 requisitos o impacto en schedule < 1 semana | PM + BA lead |
| Cambio en > 5 requisitos o impacto en schedule > 1 semana | CCB / Sponsor |
| Cambio en alcance del proyecto | Sponsor + Steering Committee |

---

## RACI extendido para BA — patrones frecuentes

### Patrón: proyecto waterfall

| Actividad | BA | PM | Sponsor | SME | IT | QA |
|-----------|:--:|:--:|:-------:|:---:|:--:|:--:|
| Desarrollar BA Plan | R/A | C | C | I | I | I |
| Elicitar requisitos | R | I | C | C | I | I |
| Aprobar requisitos | R | I | A | C | C | I |
| Gestionar CRs | R/A | C | A | C | C | I |
| Validar con UAT | R | I | A | C | C | R |
| Evaluar solución | R/A | I | C | C | I | C |

### Patrón: proyecto ágil

| Actividad | BA / PO | Scrum Master | Dev Team | Stakeholders |
|-----------|:-------:|:------------:|:--------:|:------------:|
| Crear y priorizar backlog | R/A | C | C | C |
| Refinar user stories | R/A | F | C | C |
| Aceptar stories completadas | A | I | R | C |
| Gestionar cambios al backlog | R/A | I | C | C |

> F = Facilitator (rol Scrum Master en retrospectivas y refinement)
