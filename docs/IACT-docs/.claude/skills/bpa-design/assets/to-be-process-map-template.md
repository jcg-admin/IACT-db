# To-Be Process Map — Template

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: bpa:design
author: [nombre]
status: Borrador
```

---

## Información del proceso rediseñado

| Campo | Valor |
|-------|-------|
| **Nombre del proceso** | [nombre oficial] |
| **Process Owner** | [nombre + cargo] |
| **Versión del diseño** | 1.0 |
| **Fecha del diseño** | [YYYY-MM-DD] |
| **Diseñado por** | [nombre] |
| **Referencia As-Is** | bpa-map.md — versión [X] — [fecha] |
| **Tiempo de ciclo To-Be estimado** | [X días / X horas] |
| **Reducción estimada** | [X% vs. As-Is de Y días] |

---

## Swimlanes To-Be — actores del proceso rediseñado

| # | Actor / Swimlane | Cambio vs. As-Is |
|---|-----------------|-----------------|
| 1 | [Actor 1] | [Sin cambio / Rol ampliado / Rol eliminado] |
| 2 | [Actor 2] | [Sin cambio / Rol consolidado con Actor 3] |
| 3 | [Sistema / Herramienta nueva] | [Nuevo actor — automatiza steps X e Y] |

---

## Mapa To-Be — flujo rediseñado

| Step | Actor | Nombre de la actividad | Inputs | Outputs | Time | Decision | Change Type |
|------|-------|----------------------|--------|---------|------|----------|------------|
| 1 | [Actor 1] | [Verbo + objeto] | [inputs] | [outputs] | [X min/h] | — | Unchanged |
| 2 | [Sistema] | [Acción automática] | [inputs] | [outputs] | [X seg/min] | — | Automated |
| 3 | [Actor 2] | [Paso simplificado] | [inputs] | [outputs] | [X min/h] | ¿[decisión]? | Simplified |
| 3a | [Actor 2] | [Camino Sí] | — | — | — | — | Unchanged |
| 3b | [Actor 2] | [Camino No — manejado de forma diferente] | — | — | — | — | Simplified |
| 4 | [Actor 1+2 integrado] | [Paso integrado] | [inputs] | [outputs] | [X min/h] | — | Integrated |
| 5 | [Actor 2] | [Paso final] | [inputs] | [Output final] | [X min/h] | — | Unchanged |

**Leyenda — Change Type:**
| Tipo | Descripción |
|------|-------------|
| **Eliminated** | Actividad eliminada del proceso (era NVA) |
| **Simplified** | Actividad simplificada — menos pasos, menos campos, menos actores |
| **Integrated** | Actividades o actores consolidados en uno solo |
| **Automated** | Paso ejecutado por sistema sin intervención humana |
| **Unchanged** | Actividad preservada tal como estaba en el As-Is |

*Ver guía de criterios de aplicación: [redesign-principles.md](../references/redesign-principles.md)*

---

## Actividades eliminadas del As-Is

| Step As-Is | Actividad eliminada | Clasificación NVA | Razón de eliminación | Riesgo mitigado |
|-----------|--------------------|--------------------|---------------------|----------------|
| [Step N] | [Nombre de la actividad] | [Tipo NVA: Espera/Retrabajo/etc.] | [Por qué es seguro eliminarla] | [Qué control alternativo existe, si aplica] |

---

## Change Rationale — resumen de cambios

| # | Cambio | Tipo | Justificación | Impacto esperado |
|---|--------|------|---------------|-----------------|
| 1 | [Descripción del cambio principal] | Eliminate / Simplify / Integrate / Automate | [Por qué este cambio — basado en el análisis] | [Reducción de tiempo / error / fricción] |
| 2 | | | | |
| 3 | | | | |

---

## Comparación As-Is vs. To-Be

| Métrica | As-Is | To-Be | Mejora |
|---------|-------|-------|--------|
| N° de actividades total | [N] | [M] | [-K actividades] |
| N° de actividades NVA | [N] | [M] | [-K eliminadas] |
| Tiempo de ciclo total | [X días] | [Y días] | [-Z días = X%] |
| N° de handoffs | [N] | [M] | [-K] |
| N° de aprobaciones | [N] | [M] | [-K] |
| % tiempo VA | [X%] | [Y%] | [+Z%] |

---

## Requisitos para la implementación del To-Be

*Lo que debe estar disponible o completado antes de poder operar el nuevo proceso:*

| Requisito | Tipo | Responsable | Fecha necesaria |
|-----------|------|-------------|----------------|
| [Ej: configurar notificaciones automáticas en sistema X] | Técnico | [Equipo IT] | [YYYY-MM-DD] |
| [Ej: actualizar política de delegación de aprobación] | Proceso / Governance | [Management] | [YYYY-MM-DD] |
| [Ej: capacitar al equipo en el nuevo flujo] | Personas | [Process Owner] | [YYYY-MM-DD] |
| [Ej: SOP documentado y publicado] | Documentación | [Analista] | [YYYY-MM-DD] |

---

## Riesgos del rediseño

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|-----------|
| [Ej: el equipo no adopta el nuevo proceso] | Media | Alto | [Plan de training + comunicación del por qué] |
| [Ej: la automatización X falla en producción] | Baja | Medio | [Plan de rollback al proceso As-Is durante el piloto] |

---

## Validación del diseño To-Be

| Validador | Rol | Fecha | Estado | Comentarios |
|-----------|-----|-------|--------|-------------|
| [nombre] | Process Owner | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | Ejecutor principal | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
| [nombre] | IT / Sistemas | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas — viabilidad técnica] |
| [nombre] | Sponsor | [YYYY-MM-DD] | ✅ Aprobado / ❌ Pendiente | [notas] |
