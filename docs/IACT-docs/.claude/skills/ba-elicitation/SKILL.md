---
name: ba-elicitation
description: "Use when collecting information from stakeholders in BABOK. ba:elicitation — plan and execute elicitation activities, confirm results with stakeholders, communicate findings."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["elicitation", "requirements gathering", "stakeholder interviews", "BABOK elicitation", "information collection"]
updated_at: 2026-04-17 00:00:00
---

# /ba-elicitation — BABOK: Elicitation & Collaboration

> *"Elicitation is not just asking questions — it is the art of helping stakeholders articulate needs they may not fully understand themselves. The most important requirements are often the ones stakeholders cannot express without facilitation."*

Ejecuta la Knowledge Area **Elicitation & Collaboration** de BABOK v3. Planifica y ejecuta actividades de elicitación para recopilar información de stakeholders, confirma los resultados con ellos, y comunica los hallazgos al equipo del proyecto.

**THYROX Stage:** Stage 1 DISCOVER / Stage 2 BASELINE.

**Outputs clave:** Elicitation Results (confirmados) · Stakeholder Needs articulados.

---

## Pre-condición

Requiere: `{wp}/ba-planning.md` con:
- Stakeholder Engagement Approach definido
- Técnicas de elicitación seleccionadas
- Governance Approach con proceso de confirmación

---

## Cuándo usar este paso

- Cuando se necesita entender el dominio del negocio, los problemas o las necesidades de los stakeholders
- Al inicio de cualquier trabajo de BA para capturar el conocimiento de los stakeholders
- Cuando cambia el contexto y se necesita re-elicitar para entender el impacto

## Cuándo NO usar este paso

- Si los requisitos ya están bien documentados y confirmados → ir a `ba:requirements-analysis`
- Si el trabajo es evaluar si una solución funcionó → ir a `ba:solution-evaluation`

---

## Técnicas de elicitación

| Técnica | Cuándo usar | Ventajas | Limitaciones |
|---------|-------------|---------|-------------|
| **Entrevistas** | Explorar en profundidad con un stakeholder | Permite profundizar; flexible | No escala para muchos stakeholders; depende de las preguntas |
| **Talleres / JAD** | Alinear múltiples stakeholders simultáneamente | Resuelve conflictos en tiempo real; genera consenso | Requiere facilitation experta; difícil coordinar |
| **Observación (Shadowing)** | Entender procesos tal como son en la práctica | Captura lo que los usuarios hacen, no lo que dicen que hacen | Requiere tiempo; puede alterar el comportamiento observado |
| **Análisis de documentos** | Entender el estado actual cuando hay documentación | No requiere tiempo de stakeholders | Documentos desactualizados; sin contexto de "por qué" |
| **Encuestas / Cuestionarios** | Recopilar datos de muchos stakeholders | Escala bien; cuantificable | No permite profundizar; baja tasa de respuesta |
| **Focus Groups** | Explorar percepciones y actitudes con grupos | Genera debate y perspectivas diversas | Riesgo de groupthink; requiere moderación neutral |
| **Brainstorming** | Generar ideas o identificar opciones en grupo | Alta participación; genera muchas ideas | Ideas sin filtrar; requiere priorización posterior |

### Técnicas para entrevistas efectivas

**Preguntas que sí usar:**

| Tipo | Ejemplo | Propósito |
|------|---------|-----------|
| **Apertura** | "¿Puede describir cómo funciona este proceso hoy?" | Obtener el panorama general sin sesgo |
| **Profundización** | "¿Qué pasa cuando ese paso falla?" | Explorar flujos de excepción |
| **Contexto** | "¿Con qué frecuencia ocurre esto? ¿Quién más está involucrado?" | Cuantificar y ampliar el contexto |
| **Impacto** | "¿Qué impacto tiene en su trabajo cuando esto no funciona?" | Priorizar por dolor real |
| **Futuro** | "¿Cómo le gustaría que funcionara esto en el futuro ideal?" | Capturar needs, no soluciones |

**Preguntas que evitar:**

| Tipo | Problema | Alternativa |
|------|---------|-------------|
| **Sugestivas** | "¿No cree que sería mejor usar un sistema automatizado?" | "¿Cómo preferiría gestionar este proceso?" |
| **Técnicas prematuras** | "¿Prefiere un dashboard o reportes?" | "¿Cómo usa hoy la información de X?" |
| **Sí/No cerradas** | "¿El proceso funciona bien?" | "Descríbame el proceso desde el inicio" |

### Protocolo de talleres JAD

| Fase del taller | Actividades |
|----------------|-------------|
| **Preparación** | Definir agenda; invitar al facilitador; preparar materials; enviar pre-reading a participantes |
| **Apertura** | Establecer reglas del taller; confirmar objetivo y agenda |
| **Trabajo** | Facilitar discusiones, técnicas visuales (mapas de procesos, diagramas de afinidad) |
| **Resolución de conflictos** | Anotar puntos de acuerdo y desacuerdo; resolver o escalar |
| **Cierre** | Confirmar resultados; definir seguimientos; asignar responsables |
| **Post-taller** | Enviar minuta con acuerdos a todos los participantes en < 48h |

### Protocolo de observación (Shadowing)

| Paso | Descripción |
|------|-------------|
| **Solicitar permiso** | Explicar el propósito; obtener consentimiento del usuario y su supervisor |
| **Observar sin interrumpir** | No sugerir mejoras durante la observación; solo tomar notas |
| **Registrar lo que se hace, no lo que se dice** | Los usuarios a menudo verbalizan un proceso idealizado, no el real |
| **Preguntar al final** | "¿Hay algo que no hizo hoy que normalmente haría?" |
| **Confirmar observaciones** | Enviar resumen de lo observado al usuario para validación |

---

## Confirmación de resultados

La confirmación es un paso obligatorio que cierra cada actividad de elicitación:

| Actividad de elicitación | Método de confirmación | Plazo |
|--------------------------|----------------------|-------|
| Entrevista | Email con resumen + "¿Capturé correctamente su necesidad?" | 48h |
| Taller | Minuta con acuerdos enviada a todos los participantes | 24h |
| Observación | Resumen de lo observado con el usuario observado | 24-48h |
| Encuesta | Resultados agregados compartidos con los respondientes | Por ciclo |
| Análisis de documentos | Notas de análisis compartidas con el dueño del documento | 48h |

> **Por qué confirmar:** El BA interpreta lo que escucha. La confirmación asegura que la interpretación es correcta antes de que los malentendidos se propaguen a los requisitos.

---

## Routing Table

| Situación | Próxima KA recomendada |
|-----------|----------------------|
| La elicitación reveló que hay un problema estratégico sin análisis | `ba:strategy` |
| Hay suficiente información para modelar y especificar requisitos | `ba:requirements-analysis` |
| Los requisitos elicitados necesitan trazabilidad y gestión de cambios | `ba:requirements-lifecycle` |
| La elicitación fue insuficiente (gaps, stakeholders faltantes) | Nueva ronda de `ba:elicitation` |
| La solución ya existe y se necesita evaluar si cumplió las necesidades | `ba:solution-evaluation` |

---

## Criterio de completitud

**Elicitación completa para esta iteración:**
1. Todas las técnicas planificadas en el BA Plan ejecutadas
2. Resultados confirmados por los stakeholders relevantes
3. Hallazgos documentados con suficiente detalle para alimentar la siguiente KA
4. Gaps identificados y plan para resolverlos (nueva ronda si necesario)

---

## Artefacto esperado

`{wp}/ba-elicitation.md`

usar template: [elicitation-notes-template.md](./assets/elicitation-notes-template.md)

---

## Red Flags — señales de Elicitation mal ejecutada

- **Solo una técnica usada** — si el BA solo hace entrevistas o solo hace documentación, está perdiendo perspectivas que otras técnicas capturarían
- **Resultados no confirmados** — si el BA documenta lo que escuchó sin confirmar con los stakeholders, los errores de interpretación se propagan
- **Preguntas sugestivas que sesgaron las respuestas** — "¿Le gustaría tener un dashboard en tiempo real?" genera respuestas sesgadas; el BA debe detectar si sus preguntas están guiando las respuestas
- **Stakeholders de alto impacto no elicitados** — si los usuarios finales no participaron en la elicitación, los requisitos reflejan la perspectiva del sponsor, no la del usuario
- **Elicitación que termina cuando "ya sabemos todo"** — la elicitación termina cuando los resultados están confirmados y los gaps identificados tienen plan, no cuando el BA se siente cómodo

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: ba:elicitation
flow: ba
ba_ka: elicitation_collaboration
```

**Al COMPLETAR:**
```yaml
methodology_step: ba:elicitation  # completado — resultados confirmados
flow: ba
ba_ka: elicitation_collaboration
```

## Siguiente paso

Usar la **Routing Table** — la siguiente KA depende de lo que se encontró en la elicitación.

---

## Reference Files

### Assets
- [elicitation-notes-template.md](./assets/elicitation-notes-template.md) — Template de notas de elicitación: actividades por técnica, hallazgos confirmados, necesidades articuladas (sin solución), gaps identificados con plan, routing

### References
- [elicitation-techniques.md](./references/elicitation-techniques.md) — 7 técnicas BABOK con protocolos detallados: entrevistas (preguntas efectivas vs evitar), JAD (fases del taller, técnicas visuales), shadowing (protocolo paso a paso), encuestas, focus groups, brainstorming, análisis de documentos
