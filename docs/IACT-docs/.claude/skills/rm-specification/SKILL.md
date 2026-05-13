---
name: rm-specification
description: "Use when formalizing analyzed requirements into a specification document. rm:specification — write requirements in a standard format (SRS/BRD/User Stories) with acceptance criteria and traceability."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
metadata:
  triggers: ["requirements specification RM", "SRS", "BRD", "RM specification", "acceptance criteria definition"]
updated_at: 2026-04-17 00:00:00
---

# /rm-specification — Requirements Management: Specification

> *"A requirement without an acceptance criterion is a wish. Specification is the act of turning wishes into verifiable commitments."*

Ejecuta el paso **Specification** del ciclo de Requirements Management. Formaliza los requisitos analizados en documentos estándar con acceptance criteria verificables y trazabilidad completa.

**THYROX Stage:** Stage 7 DESIGN/SPECIFY.

---

## Foco en el ciclo RM

| Paso | Intensidad relativa | Rol en el ciclo |
|------|-------------------|----------------|
| Elicitation | Baja | Provee las necesidades que este paso convierte en especificación formal |
| Analysis | Alta | Provee los requisitos priorizados y con calidad verificada como input directo |
| **Specification** | **Alta** (este paso) | Formalización — produce el documento que guía diseño, desarrollo y tests |
| Validation | Alta | Verifica y valida la especificación producida por este paso |
| Management | Media | Gestiona los cambios al baseline que este paso establece |

---

## Pre-condición

Requiere: `{wp}/rm-analysis.md` con:
- Requisitos priorizados con MoSCoW
- Checklist de calidad IEEE 830 pasado (≥ 80%)
- Conflictos resueltos o escalados
- Stakeholder owner identificado para cada Must Have

---

## Cuándo usar este paso

- Cuando el análisis está completo con requisitos priorizados y calidad verificada
- Para producir el documento formal que guiará el diseño, desarrollo y pruebas
- Para establecer el baseline de requisitos contra el que se gestionarán cambios futuros

## Cuándo NO usar este paso

- Sin análisis completado — especificar sin calidad verificada propaga defectos a todos los artefactos siguientes
- Si hay conflictos no resueltos — la especificación no puede tener dos versiones de la misma funcionalidad

---

## Actividades

### 1. Elegir el formato de especificación

| Formato | Cuándo usar | Audiencia principal | Pros | Contras |
|---------|-------------|---------------------|------|---------|
| **IEEE 830 SRS** | Sistemas de software, contratos formales, proyectos regulados | Desarrolladores + auditores técnicos | Estándar internacional; trazabilidad formal | Pesado; difícil de mantener ágil |
| **BRD** (Business Requirements Document) | Proyectos de negocio, ERP, transformación digital | Sponsor + business analysts + PMs | Orientado a valor de negocio | Menos técnico; requiere traducción a req técnicos |
| **User Stories + Given/When/Then** | Proyectos ágiles, equipos pequeños, software de producto | Equipo de desarrollo + PO | Liviano; testable desde el inicio; fácil de priorizar | Difícil de escalar en sistemas complejos |
| **Especificación híbrida** | Proyectos medianos con componentes técnicos y de negocio | Múltiples audiencias | Cubre ambas perspectivas | Más trabajo de mantenimiento |

**Criterios de decisión:**

| Contexto | Formato recomendado |
|----------|---------------------|
| Contrato formal / regulación legal | IEEE 830 SRS |
| Proyecto de negocio sin código propio | BRD |
| Equipo ágil / iteraciones cortas | User Stories |
| Sistema técnico complejo + equipo mixto | Híbrido SRS + User Stories |

### 2. Estructura IEEE 830 SRS (cuando aplica)

| Sección | Contenido |
|---------|-----------|
| **1. Introduction** | Purpose, scope, definitions/acronyms, references, overview |
| **2. Overall Description** | Product perspective, product functions, user characteristics, constraints, assumptions |
| **3. Specific Requirements** | External interfaces, functional requirements (por caso de uso/feature), non-functional requirements |
| **4. Appendices** | Data models, glossary, index |

> **Regla del SRS:** Cada requisito funcional debe tener: ID único, descripción, prioridad (MoSCoW), origen (stakeholder), acceptance criteria, y si aplica: condiciones de error.

### 3. User Stories con INVEST + Given/When/Then

**Criterios INVEST para validar calidad de cada User Story:**

| Criterio | Pregunta | Ejemplo de falla |
|----------|----------|-----------------|
| **I**ndependent | ¿Se puede implementar sin depender de otra story? | "Como usuario, puedo ver el dashboard *si* la autenticación funciona" |
| **N**egotiable | ¿Los detalles son negociables hasta el sprint? | Story tan detallada que no hay espacio para decisiones de implementación |
| **V**aluable | ¿Entrega valor al usuario o al negocio? | Story técnica sin valor de usuario directo |
| **E**stimable | ¿El equipo puede estimar el esfuerzo? | Story demasiado grande o demasiado vaga |
| **S**mall | ¿Se puede completar en un sprint? | Story que tarda 3+ sprints |
| **T**estable | ¿Tiene acceptance criteria verificables? | "Como usuario, quiero una buena experiencia" |

**Formato Given/When/Then (BDD):**

```
Given [precondición/contexto],
When [acción del usuario],
Then [resultado esperado].

Ejemplo:
Given que el usuario tiene rol "admin" y hay al menos 1 pedido pendiente,
When hace clic en "Ver pedidos pendientes",
Then el sistema muestra la lista de pedidos con estado "Pendiente" ordenados por fecha de creación descendente.
```

> Cada User Story debe tener al menos: 1 escenario nominal (happy path) + 1 escenario de error (qué pasa si la precondición no se cumple).

### 4. Especificación de requisitos no funcionales (NFR)

Los NFR definen las restricciones de calidad del sistema:

| Categoría NFR | Ejemplo de especificación | Cómo medir |
|---------------|--------------------------|------------|
| **Performance** | "El endpoint /orders responde en < 500ms para el p95 bajo carga de 100 req/s" | Load test con percentiles |
| **Security** | "La autenticación usa JWT con expiración de 1h; tokens inválidos devuelven HTTP 401" | Security audit + penetration test |
| **Scalability** | "El sistema mantiene el SLA de performance hasta 10× el volumen actual sin cambios de arquitectura" | Stress test |
| **Availability** | "Uptime ≥ 99.5% medido mensualmente, excluyendo mantenimiento programado" | Monitoring con SLA dashboard |
| **Usability** | "Un usuario nuevo completa el flujo de alta sin asistencia en < 5 minutos" | Usability test con usuarios reales |

### 5. Establecer el baseline de requisitos

Al completar la especificación, establecer el baseline:

| Acción | Descripción |
|--------|-------------|
| **Versionar el documento** | Versión 1.0 = baseline inicial |
| **Obtener sign-off** | Aprobación formal del sponsor / PO / cliente |
| **Establecer trazabilidad inicial** | Cada req ID → stakeholder origen + prioridad MoSCoW |
| **Comunicar el baseline** | Notificar a todos los stakeholders que el baseline está establecido y que cambios futuros pasan por CCB |

> El baseline es el artefacto que `rm:management` mantendrá. Sin baseline formal, no hay control de cambios posible.

---

## Artefacto esperado

`{wp}/rm-specification.md`

usar template: [requirements-spec-template.md](./assets/requirements-spec-template.md)

---

## Red Flags — señales de especificación mal ejecutada

- **Acceptance criteria ausentes** — un requisito sin criterio de aceptación no puede ser verificado ni aprobado en validación
- **User Stories sin escenario de error** — solo el happy path no es especificación completa
- **NFR sin métrica cuantitativa** — *"el sistema debe ser rápido"* no es especificable ni testeable
- **Baseline sin sign-off formal** — si el sponsor no aprobó el baseline, los cambios posteriores no tienen referencia formal
- **ID de requisitos no únicos** — sin IDs únicos, la trazabilidad y el control de cambios son imposibles
- **Requisitos funcionales mezclados con diseño** — *"el botón azul en la esquina superior derecha hace X"* es diseño UI, no requisito funcional
- **INVEST no verificado** — User Stories sin verificar INVEST producen stories que no pueden estimarse ni completarse en un sprint

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: rm:specification
flow: rm
```

**Al COMPLETAR** (especificación con baseline aprobado):
```yaml
methodology_step: rm:specification  # completado → listo para rm:validation
flow: rm
```

## Siguiente paso

Cuando la especificación tiene baseline con sign-off → `rm:validation`

---

## Limitaciones

- La especificación solo puede ser tan buena como la elicitación y el análisis que la preceden — garbage in, garbage out
- IEEE 830 SRS es costoso de mantener en proyectos con cambios frecuentes — en contextos ágiles, preferir User Stories con un nivel mínimo de SRS para los NFR
- El formato de la especificación debe alinearse con el proceso de desarrollo del equipo — una spec perfecta que nadie lee no tiene valor

---

## Reference Files

### Assets
- [requirements-spec-template.md](./assets/requirements-spec-template.md) — Template IEEE 830-style: requisitos funcionales, NFR, trazabilidad, baseline y sign-off

### References
- [specification-standards.md](./references/specification-standards.md) — IEEE 830 estructura, User Stories INVEST+splitting, Gherkin avanzado, AC patterns para NFR
