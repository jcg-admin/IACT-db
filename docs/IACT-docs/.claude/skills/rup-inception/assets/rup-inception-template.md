```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rup:inception
rup_iteration: 1
author: [nombre]
status: Borrador
```

# RUP Inception — Artefacto

---

## Vision Document

### Problem Statement

> Describir el problema SIN mencionar la solución. ¿Qué problema de negocio resuelve el sistema? ¿Para quién? ¿Cuál es el impacto si no se resuelve?

**El problema de:** [descripción del problema]
**Afecta a:** [stakeholders / usuarios afectados]
**Cuyo impacto es:** [consecuencias cuantificadas: costo, tiempo perdido, riesgo]
**Una solución exitosa:** [descripción del resultado esperado sin prescribir implementación]

### System Overview

> 1-2 párrafos. Sin detalles de implementación.

[Descripción del sistema propuesto a alto nivel]

### Stakeholders y actores

| Stakeholder / Actor | Tipo | Rol en el sistema | Intereses clave |
|---------------------|------|------------------|----------------|
| [nombre] | Usuario directo / Afectado / Proveedor | [qué hace con el sistema] | [qué le importa del sistema] |

### Scope (IN / OUT)

| IN — El sistema incluirá | OUT — El sistema NO incluirá |
|--------------------------|------------------------------|
| [funcionalidad incluida] | [funcionalidad excluida explícitamente] |

### Key Features (5-10)

> Capacidades de alto nivel — NO casos de uso detallados, NO implementación.

1. [Feature 1]
2. [Feature 2]
3. [Feature 3]
4. [Feature 4]
5. [Feature 5]

### Assumptions & Constraints

| Tipo | Descripción |
|------|-------------|
| **Asunción** | [algo que se asume como verdad sin confirmar] |
| **Constraint técnico** | [tecnología mandatada, plataforma fija, etc.] |
| **Constraint de negocio** | [fecha, presupuesto, regulación] |

---

## Use Case Model (10%)

> Solo identificar los UC críticos — nombre, actor y objetivo. Sin flujos detallados.

| Use Case | Actor principal | Objetivo | Por qué es crítico en Inception |
|----------|----------------|----------|--------------------------------|
| UC-001: [Nombre] | [Actor] | [Qué logra] | Arquitecturalmente significativo / Alto riesgo / Crítico para BC |
| UC-002: [Nombre] | [Actor] | [Qué logra] | |

---

## Risk List

> Ver criterios de evaluación: [lco-criteria.md](../references/lco-criteria.md)

| Risk ID | Descripción | Probabilidad (A/M/B) | Impacto (A/M/B) | Plan de respuesta | Fase target para mitigar |
|---------|-------------|---------------------|----------------|------------------|--------------------------|
| R-001 | [descripción del riesgo] | A / M / B | A / M / B | [acción de respuesta] | Inception / Elaboration / Construction |
| R-002 | | | | | |

---

## Business Case

### Problema de negocio
[Descripción cuantificada del problema: costo actual, frecuencia, impacto]

### Solución propuesta
[Descripción de alto nivel del sistema — alineada con el Vision Document]

### ROI estimado

| Elemento | Valor |
|----------|-------|
| Inversión estimada (proyecto) | $[monto] o [semanas-persona] |
| Beneficio esperado anual | $[monto] o [descripción cuantificada] |
| ROI estimado | [beneficio / inversión] |
| Período de recuperación | [meses] |

### Costo de no hacer nada
[Consecuencias cuantificadas si el sistema no se construye]

### Top-5 riesgos del proyecto

| # | Riesgo | Impacto en BC |
|---|--------|--------------|
| 1 | [riesgo] | [impacto] |
| 2 | | |

---

## Plan inicial de proyecto

| Fase RUP | Fecha target | Milestone | Notas |
|----------|-------------|-----------|-------|
| Inception | [fecha] | LCO | Iteración [N] |
| Elaboration | [fecha] | LCA | [N] iteraciones estimadas |
| Construction | [fecha] | IOC | [N] iteraciones estimadas |
| Transition | [fecha] | PD | [N] iteraciones estimadas |

**Estimación de esfuerzo total:** [semanas-persona] *(±50% accuracy en Inception — mejorará en Elaboration)*

**Roles necesarios:**

| Rol | % dedicación | Perfil requerido |
|-----|-------------|-----------------|
| Arquitecto / Tech Lead | [%] | [experiencia requerida] |
| Desarrolladores | [N × %] | [tecnologías] |
| QA | [%] | [tipo de testing] |
| Project Manager | [%] | [experiencia RUP] |

---

## Evaluación milestone LCO

> Todos los criterios deben cumplirse para avanzar a Elaboration.
> Criterios detallados: [lco-criteria.md](../references/lco-criteria.md)

- [ ] Vision Document validado y aprobado por stakeholders clave
- [ ] Business case aprobado por el sponsor
- [ ] Top riesgos críticos identificados con plan de respuesta inicial
- [ ] ≥ 10% del Use Case Model (UC más críticos nombrados y descritos brevemente)
- [ ] El equipo tiene acceso a los recursos necesarios para Elaboration

**Resultado de la evaluación:**

| Criterio | Estado | Observación |
|----------|--------|-------------|
| Vision aprobada | ✅ / ⚠️ / ❌ | |
| Business case aprobado | ✅ / ⚠️ / ❌ | |
| Riesgos con plan de respuesta | ✅ / ⚠️ / ❌ | |
| ≥ 10% Use Case Model | ✅ / ⚠️ / ❌ | |
| Recursos disponibles | ✅ / ⚠️ / ❌ | |

---

## Decisión

- [ ] **Avanzar a rup:elaboration** — LCO alcanzado (todos los criterios ✅)
- [ ] **Nueva iteración de Inception** — Motivo: [stakeholders no alineados / business case rechazado / riesgos críticos abiertos / scope cambió]

---

## Retrospectiva de iteración

| Dimensión | Observación |
|-----------|-------------|
| **Qué funcionó bien** | [workshops, entrevistas, análisis] |
| **Qué fue difícil** | [disponibilidad stakeholders, claridad del problema] |
| **Qué cambiar en la próxima iteración** | [si aplica iteración adicional] |
| **Lecciones para futuros proyectos** | [patrones a repetir o evitar] |
