# Kaizen Event Charter — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: lean:improve
author: [nombre]
status: Borrador
```

---

## Identificación del evento

| Campo | Valor |
|-------|-------|
| **Nombre del evento Kaizen** | [Nombre descriptivo — ej: "Kaizen Reducción Esperas Aprobación Facturas"] |
| **Proceso objetivo** | [Proceso específico donde se ejecuta el evento] |
| **Waste dominante a eliminar** | [TIMWOOD type + descripción — ej: "W — Waiting: 68% del lead time en esperas"] |
| **Causa raíz a eliminar** | [Causa validada en lean:analyze que este evento ataca] |
| **Herramienta Lean principal** | [5S / Kanban / SMED / Jidoka / Eliminación NVA / Rediseño de flujo] |
| **Fecha del evento** | [YYYY-MM-DD al YYYY-MM-DD] |
| **Duración** | [2 / 3 / 5 días] |
| **Área / Proceso objetivo** | [Nombre del área, departamento o proceso] |

---

## Equipo del evento

| Rol | Nombre | Disponibilidad |
|-----|--------|---------------|
| Lean Champion / Facilitador | [nombre] | 100% durante el evento |
| Process Owner | [nombre] | 100% Días 1-2; disponible Días 3-5 |
| Kaizen Team — miembro 1 | [nombre — operador del proceso] | 100% durante el evento |
| Kaizen Team — miembro 2 | [nombre] | 100% durante el evento |
| Kaizen Team — miembro 3 | [nombre] | 100% durante el evento |
| Kaizen Team — miembro 4 | [nombre] | 100% durante el evento |
| Sponsor | [nombre] | Día 1 (kick-off) + Día 5 (presentación) |
| Soporte IT / Técnico (si aplica) | [nombre] | [disponibilidad] |

> El Kaizen Team debe incluir mínimo 50% de operadores reales del proceso — ellos tienen el conocimiento de por qué el proceso funciona como funciona.

---

## Objetivo y métricas del evento

### Objetivo SMART

**Reducir [métrica] en [proceso] de [baseline] a [meta] en [N días del evento].**

[Ejemplo: "Reducir el tiempo de espera de aprobación de facturas de 4.2 días a menos de 1 día durante el Kaizen event del 2026-05-05 al 2026-05-09"]

### Métricas de éxito

| Métrica | Baseline (As-Is) | Meta del evento | Método de medición |
|---------|-----------------|----------------|-------------------|
| [Métrica 1 — LT, CT, WIP, etc.] | [valor actual] | [valor objetivo] | [cómo se mide] |
| [Métrica 2] | | | |
| [Métrica 3] | | | |

---

## Scope del evento

| In Scope | Out of Scope |
|----------|-------------|
| [Pasos del proceso incluidos en el evento] | [Pasos que NO se tocarán en este evento] |
| [Área física o digital incluida] | [Sistemas/áreas adyacentes fuera del evento] |

---

## Plan de 5 días

### Día 1 — Preparar y alinear

**Objetivo del día:** Alinear al equipo sobre el problema, el objetivo y el plan.

| Tiempo | Actividad | Facilitador |
|--------|-----------|------------|
| 09:00-09:30 | Bienvenida del Sponsor — por qué este Kaizen importa | Sponsor |
| 09:30-10:30 | Revisión del VSM As-Is y causas raíz (lean:analyze) | Lean Champion |
| 10:30-11:00 | Objetivo del evento y métricas de éxito | Lean Champion |
| 11:00-12:00 | Gemba walk inicial — ver el proceso con el equipo completo | Lean Champion |
| 12:00-13:00 | Almuerzo |  |
| 13:00-14:00 | Confirmar mediciones actuales (CT, WIP, esperas) | Kaizen Team |
| 14:00-15:30 | Revisar datos y confirmar causa raíz a eliminar | Kaizen Team |
| 15:30-16:00 | Plan detallado de días 2-5 | Lean Champion |

**Output del Día 1:** Equipo alineado, datos confirmados, plan aprobado.

### Día 2 — Observar y medir

**Objetivo del día:** Cuantificar el estado actual del área específica del evento.

| Tiempo | Actividad | Facilitador |
|--------|-----------|------------|
| 09:00-10:00 | Cronometrar el proceso con el equipo — medir CT de cada paso | Kaizen Team |
| 10:00-11:00 | Contar WIP actual entre pasos; documentar tiempos de espera | Kaizen Team |
| 11:00-12:00 | Identificar actividades VA vs NVA en detalle | Kaizen Team |
| 12:00-13:00 | Almuerzo | |
| 13:00-15:00 | Brainstorm de mejoras posibles (sin filtrar ideas) | Kaizen Team |
| 15:00-16:00 | Priorizar ideas: impacto vs esfuerzo | Kaizen Team |

**Output del Día 2:** Datos actuales confirmados + lista priorizada de mejoras.

### Día 3 — Idear e implementar (primera ronda)

**Objetivo del día:** Implementar las mejoras de mayor impacto.

| Tiempo | Actividad | Facilitador |
|--------|-----------|------------|
| 09:00-09:30 | Revisión de prioridades del Día 2 | Lean Champion |
| 09:30-12:00 | Implementar mejoras seleccionadas (5S, Kanban, rediseño de flujo) | Kaizen Team |
| 12:00-13:00 | Almuerzo | |
| 13:00-15:00 | Continuar implementación | Kaizen Team |
| 15:00-16:00 | Probar el proceso modificado — primera prueba | Kaizen Team |

**Output del Día 3:** Primeras mejoras implementadas y probadas.

### Día 4 — Probar, medir y ajustar

**Objetivo del día:** Validar que las mejoras funcionan con métricas reales.

| Tiempo | Actividad | Facilitador |
|--------|-----------|------------|
| 09:00-10:00 | Medir CT, WIP y esperas con las mejoras implementadas | Kaizen Team |
| 10:00-11:00 | Comparar métricas Día 1 vs Día 4 | Lean Champion |
| 11:00-12:00 | Identificar ajustes necesarios; implementar correcciones | Kaizen Team |
| 12:00-13:00 | Almuerzo | |
| 13:00-14:00 | Segunda prueba del proceso mejorado | Kaizen Team |
| 14:00-15:00 | Documentar el proceso mejorado (Standard Work borrador) | Kaizen Team |
| 15:00-16:00 | Preparar presentación de resultados para el Día 5 | Lean Champion |

**Output del Día 4:** Métricas post-mejora + Standard Work borrador + ajustes completados.

### Día 5 — Estandarizar y presentar

**Objetivo del día:** Documentar el nuevo estándar y presentar resultados al sponsor.

| Tiempo | Actividad | Facilitador |
|--------|-----------|------------|
| 09:00-11:00 | Finalizar Standard Work: secuencia, CT, WIP estándar, puntos de calidad | Kaizen Team |
| 11:00-12:00 | Crear plan de sostenibilidad y frecuencia de auditorías 5S | Lean Champion |
| 12:00-13:00 | Almuerzo | |
| 13:00-14:00 | Preparar A3 de resultados del evento | Lean Champion |
| 14:00-15:30 | Presentación al Sponsor: baseline vs resultados, standard work, plan de control | Lean Champion + Kaizen Team |
| 15:30-16:00 | Celebración + lecciones aprendidas | Todos |

**Output del Día 5:** Standard Work aprobado + Plan de control + Resultados presentados y aceptados.

---

## Resultados del evento (completar al finalizar)

| Métrica | Baseline (As-Is) | Resultado post-evento | Delta | % mejora |
|---------|-----------------|----------------------|-------|---------|
| [Métrica 1] | | | | |
| [Métrica 2] | | | | |
| [Métrica 3] | | | | |

**¿Se alcanzó el objetivo del evento?** Sí / No / Parcialmente

**Acciones pendientes post-evento:**

| Acción | Responsable | Fecha límite |
|--------|-------------|-------------|
| [Acción que no se completó en el evento] | [nombre] | [fecha] |

---

## Aprobación del evento

| Campo | Valor |
|-------|-------|
| **Sponsor** | [Nombre] |
| **Fecha de aprobación** | [YYYY-MM-DD] |
| **Standard Work aprobado** | Sí / No — pendiente revisión |
| **Próximo Kaizen event** | [Si hay otro waste a atacar — fecha tentativa] |
