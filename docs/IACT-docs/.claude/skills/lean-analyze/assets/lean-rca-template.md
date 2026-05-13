# lean-rca — Template de análisis de causa raíz

```yml
created_at: [timestamp]
project: [nombre del proyecto]
work_package: [wp-id]
phase: lean:analyze
author: [nombre]
status: Borrador
```

---

## Contexto del análisis

| Campo | Valor |
|-------|-------|
| **Proceso analizado** | [Nombre del proceso — ej: "Proceso de aprobación de facturas"] |
| **Wastes dominantes identificados en lean:measure** | [Top 2-3 de TIMWOOD, con datos del VSM] |
| **Lead Time As-Is** | [X días/horas] |
| **Process Efficiency As-Is** | [X%] |
| **Fecha del análisis** | [YYYY-MM-DD] |
| **Equipo de análisis** | [Nombres] |

---

## TIMWOOD Diagnostic Checklist

### T — Transportation

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Los materiales/documentos se mueven más de 2 veces entre pasos? | | | |
| ¿Hay handoffs entre áreas sin criterio de calidad en la entrega? | | | |
| ¿Existe doble registro del mismo dato en diferentes sistemas? | | | |
| ¿Algún paso recibe inputs de más de 3 fuentes diferentes? | | | |

**Diagnóstico Transportation:** [Presente con alta/media/baja intensidad / No presente]

### I — Inventory

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Hay colas con más de 10 items esperando procesamiento? | | | |
| ¿El WIP actual es mayor de 3× el takt time × capacidad? | | | |
| ¿Los tiempos de espera en el VSM superan el 30% del lead time? | | | |
| ¿Existe stock de seguridad cuya justificación nadie recuerda? | | | |

**Diagnóstico Inventory:** [Presente / No presente]

### M — Motion

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Los operadores buscan herramientas/datos más de 2 veces por hora? | | | |
| ¿El layout del área requiere desplazamientos para completar una tarea? | | | |
| ¿Hay información en múltiples sistemas que requiere navegar para completar un paso? | | | |

**Diagnóstico Motion:** [Presente / No presente]

### W — Waiting

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Los tiempos de aprobación/revisión superan 24 horas frecuentemente? | | | |
| ¿Hay dependencias entre equipos que generan esperas recurrentes? | | | |
| ¿Los operadores están idle esperando inputs más del 15% del tiempo? | | | |
| ¿El cuello de botella del VSM tiene CT > Takt Time? | | | |

**Diagnóstico Waiting:** [Presente / No presente]

### O — Overproduction

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Se producen reportes/documentos que nadie lee? | | | |
| ¿El sistema es push (forecast) en lugar de pull (demanda real)? | | | |
| ¿Lotes de producción más grandes de lo que el siguiente paso puede procesar? | | | |

**Diagnóstico Overproduction:** [Presente / No presente]

### O — Overprocessing

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Hay pasos de revisión/aprobación redundantes? | | | |
| ¿Existen formularios con campos que nunca se usan? | | | |
| ¿Hay actividades que se hacen "siempre así" sin razón documentada? | | | |

**Diagnóstico Overprocessing:** [Presente / No presente]

### D — Defects

| Pregunta diagnóstica | Sí/No | Evidencia | Impacto |
|---------------------|-------|-----------|---------|
| ¿Hay pasos explícitos de inspección en el VSM? | | | |
| ¿El % de reproceso es > 5%? | | | |
| ¿El cliente devuelve items o reporta errores frecuentemente? | | | |

**Diagnóstico Defects:** [Presente / No presente]

---

## Priorización de wastes

| Waste | Impacto en LT (1-5) | Impacto en Costo (1-5) | Esfuerzo de eliminar (1-5) | Score prioridad | Prioridad |
|-------|--------------------|-----------------------|--------------------------|----------------|-----------|
| [Waste 1] | | | | | Alta/Media/Baja |
| [Waste 2] | | | | | |
| [Waste 3] | | | | | |

**Score prioridad** = (Impacto LT × 0.4) + (Impacto Costo × 0.3) + ((6 - Esfuerzo) × 0.3)

**Wastes seleccionados para análisis de causa raíz:** [Top 2-3]

---

## Análisis 5 Whys — Waste 1

**Waste analizado:** [Nombre y descripción con datos del VSM]

| # | Por qué | Respuesta |
|---|---------|-----------|
| Why 1 | ¿Por qué [ocurre el waste]? | |
| Why 2 | ¿Por qué [respuesta 1]? | |
| Why 3 | ¿Por qué [respuesta 2]? | |
| Why 4 | ¿Por qué [respuesta 3]? | |
| Why 5 | ¿Por qué [respuesta 4]? | |

**Causa raíz identificada:** [Descripción sistémica de la causa raíz]

**Validación:** [Cómo se confirma que esta es la causa raíz — observación, datos, experimento]

---

## Análisis 5 Whys — Waste 2

**Waste analizado:** [Nombre y descripción con datos del VSM]

| # | Por qué | Respuesta |
|---|---------|-----------|
| Why 1 | ¿Por qué [ocurre el waste]? | |
| Why 2 | ¿Por qué [respuesta 1]? | |
| Why 3 | ¿Por qué [respuesta 2]? | |
| Why 4 | ¿Por qué [respuesta 3]? | |
| Why 5 | ¿Por qué [respuesta 4]? | |

**Causa raíz identificada:** [Descripción sistémica de la causa raíz]

**Validación:** [Cómo se confirma que esta es la causa raíz]

---

## Diagrama de Ishikawa (Fishbone) — [Waste principal]

**Problema en la cabeza del pez:** [Waste con datos — ej: "68% del LT en espera"]

```
Mano de obra ─────────┐
  [causa]              │
  [causa]              │
                       │
Métodos ──────────────┤
  [causa]              │
  [causa]              ├────────→ [WASTE/PROBLEMA]
                       │
Máquinas ─────────────┤
  [causa]              │
  [causa]              │
                       │
Materiales ───────────┤
  [causa]              │
                       │
Medición ─────────────┤
  [causa]              │
                       │
Medio Ambiente ────────┘
  [causa]
```

**Causas priorizadas del Fishbone:** [Top 2-3 con mayor probabilidad de ser la causa raíz]

---

## Validación de causas raíz

| Causa raíz identificada | Método de validación | Evidencia recopilada | Resultado |
|------------------------|---------------------|---------------------|-----------|
| [Causa 1 — Waste 1] | [Observación / Entrevista / Datos / Experimento] | [Qué se encontró] | Confirmada / Refutada |
| [Causa 2 — Waste 2] | | | |

---

## Síntesis — causas raíz validadas

| Waste | Causa raíz confirmada | Herramienta Lean recomendada |
|-------|----------------------|------------------------------|
| [Waste 1] | [Causa sistémica validada] | [5S / Kanban / SMED / Jidoka / Eliminación NVA] |
| [Waste 2] | [Causa sistémica validada] | [Herramienta] |
| [Waste 3] | [Causa sistémica validada] | [Herramienta] |

> Esta síntesis es el input directo para lean:improve — la herramienta seleccionada debe atacar la causa raíz, no solo el síntoma.
