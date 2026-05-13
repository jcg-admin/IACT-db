# pdca-do — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pdca:do
author: [nombre]
status: Borrador
```

---

## Diseño del piloto

| Dimensión | Decisión |
|-----------|---------|
| **Scope** | [qué subconjunto: 1 servidor / 1 región / 1 equipo] |
| **Duración** | [inicio: YYYY-MM-DD] → [fin: YYYY-MM-DD] |
| **Métricas** | [mismas que el baseline del Plan — listar] |
| **Rollback** | Condición: [cuándo revertir] · Procedimiento: [cómo revertir] |
| **Aislamiento** | [variables externas identificadas que podrían contaminar resultados] |

---

## Baseline del piloto

> Medición del estado actual en el ámbito del piloto, antes de cualquier cambio.

| Métrica | Valor baseline del piloto | Fecha de medición |
|---------|--------------------------|------------------|
| [Métrica principal del SMART goal] | [valor] | [YYYY-MM-DD] |
| [Métrica de control 1] | [valor] | [YYYY-MM-DD] |
| [Métrica de control 2] | [valor] | [YYYY-MM-DD] |

---

## Registro de implementación

| Timestamp | Acción ejecutada | Estado antes | Estado después | Observación |
|-----------|-----------------|--------------|----------------|-------------|
| [YYYY-MM-DD HH:MM] | [acción del plan] | [estado] | [estado] | [notas] |
| | | | | |

---

## Datos recopilados

| Período | [Métrica principal] | [Métrica control 1] | [Métrica control 2] |
|---------|--------------------|--------------------|---------------------|
| [fecha/hora] | [valor] | [valor] | [valor] |

---

## Desviaciones del plan

| Acción planificada | Lo que ocurrió | Causa de la desviación |
|-------------------|----------------|----------------------|
| [acción del plan] | [qué pasó en realidad] | [por qué hubo diferencia] |

*Si no hubo desviaciones: "Ninguna — el plan se ejecutó según lo planificado."*

---

## Observaciones generales

### Según lo esperado
[Comportamientos que confirmaron la hipótesis]

### Diferente a lo esperado
[Sorpresas positivas o negativas]

### Señales de riesgo detectadas
[Indicadores de impacto no deseado — o "Ninguna señal de riesgo detectada"]

### Estado del criterio de parada
[ ] Criterio de parada no alcanzado — piloto completo
[ ] Criterio de parada alcanzado — piloto detenido: [razón]
