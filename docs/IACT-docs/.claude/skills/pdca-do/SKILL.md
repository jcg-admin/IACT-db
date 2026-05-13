---
name: pdca-do
description: "Use when executing a PDCA improvement plan. pdca:do — implement the plan at small scale (pilot), collect data during execution, and document observations and deviations."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 00:00:00
---

# /pdca-do — PDCA: Do

> *"Small, reversible steps. Verify each change before the next. Never change multiple variables simultaneously."*

Ejecuta el paso **Do** del ciclo PDCA. Implementa el plan a escala controlada (piloto) y recopila datos con disciplina.

**THYROX Stage:** Stage 10 IMPLEMENT.

---

## Pre-condición

Requiere: `{wp}/pdca-plan.md` con:
- Baseline numérico documentado (sin baseline, el Check no puede comparar)
- Objetivo SMART definido
- Hipótesis de mejora formulada
- Plan de acción con acciones, responsables y fechas

---

## Cuándo usar este paso

- Cuando el Plan está completo con baseline, objetivo SMART e hipótesis formulada
- Para ejecutar la intervención planificada en ámbito limitado

## Cuándo NO usar este paso

- Sin Plan aprobado con baseline — Do sin baseline invalida el Check
- Sin rollback plan definido — si la intervención puede dañar producción, definir primero cómo revertir
- Sin criterio de parada — si los resultados empeoran significativamente, ¿cuándo detener el piloto?

---

## Actividades

### 1. Diseñar el piloto

Un buen piloto es pequeño, controlado y representativo:

| Dimensión | Decisión necesaria |
|-----------|-------------------|
| **Scope** | ¿En qué subconjunto del proceso/sistema? (1 servidor, 1 región, 1 equipo) |
| **Duración** | ¿Cuánto tiempo para que los datos sean representativos? |
| **Métricas** | Exactamente las mismas que el baseline — ni más ni menos |
| **Rollback** | ¿Qué condición dispara revertir? ¿Cómo se revierte? |
| **Aislamiento** | ¿Hay variables externas que podrían contaminar los resultados? |

**Regla de aislamiento:** Cambiar una sola variable a la vez. Si el Plan tiene múltiples acciones, implementarlas secuencialmente y medir después de cada una.

> **Nota para procesos operacionales:** En mejoras de proceso no-técnico, el Do puede incluir un **Gemba Walk** — ir al lugar donde ocurre el proceso para observar la implementación directamente. No confundir con solo revisar reportes o dashboards.

### 2. Capturar el baseline del piloto

Antes de hacer cualquier cambio, recopilar las métricas en el estado actual del ámbito del piloto. Este sub-baseline permite comparar directamente en Check.

### 3. Implementar el plan

Seguir el plan de acción definido en `pdca:plan`. Durante la implementación:

- Documentar cada acción con timestamp
- Registrar el estado antes → después de cada cambio
- Capturar cualquier desviación del plan y su causa

**Principio de incrementalidad:**
```
Primera iteración → hacer que funcione (implementar la mejora básica)
Segunda iteración → hacer que sea claro (documentar y comunicar)
Tercera iteración → hacer que sea eficiente (optimizar si los datos lo justifican)
No intentar los tres a la vez.
```

### 4. Recopilar datos durante la ejecución

El plan de recolección debe estar definido *antes* de ejecutar:

| ¿Qué medir? | ¿Cómo? | ¿Con qué frecuencia? | ¿Quién? |
|-------------|--------|---------------------|---------|
| Métrica principal (del objetivo SMART) | Herramienta/fuente | Continuo / por hora / diario | Nombre |
| Métricas secundarias de control | | | |
| Efectos colaterales no deseados | | | |

> Medir los mismos indicadores que en el baseline. Si se miden cosas distintas, el Check no puede comparar.

### 5. Documentar observaciones y desviaciones

| Categoría | Qué registrar |
|-----------|---------------|
| **Según lo esperado** | Comportamientos que confirmaron la hipótesis |
| **Diferente a lo esperado** | Sorpresas positivas o negativas |
| **Desviaciones del plan** | Qué no se pudo hacer como estaba planificado y por qué |
| **Señales de riesgo** | Indicadores de que la mejora podría estar causando daño |

---

## Criterios de parada del piloto

Definir antes de empezar:

- Degradación > X% en métrica principal → detener y revertir
- Error crítico imprevisto en producción → detener y revertir
- Duración máxima sin señal positiva → detener y documentar

---

## Artefacto esperado

`{wp}/pdca-do.md` — usar template: [pdca-do-template.md](./assets/pdca-do-template.md)

---

## Red Flags

- **Múltiples cambios simultáneos** — si mejora (o empeora), no sabrás cuál fue la causa
- **Sin baseline del piloto** — el Check tendrá que comparar contra el baseline global, que puede no ser comparable si cambiaron las condiciones del entorno
- **Medir diferente en Do que en Plan** — invalida la comparación en Check
- **Piloto en 100% del sistema** — ya no es piloto; si falla, el impacto es máximo
- **Sin rollback plan** — implementar sin saber cómo revertir es imprudente en sistemas críticos
- **Comprimir el tiempo del piloto por presión de deadline** — los datos apresurados dan señales falsas
- **Cambios no planificados agregados durante el piloto por presión de negocio** — "ya que estamos" invalida el aislamiento de variables; cualquier cambio adicional debe esperar al siguiente ciclo o planificarse como acción separada

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pdca:do
flow: pdca
```

**Al COMPLETAR** (piloto terminado y datos recopilados):
```yaml
methodology_step: pdca:do  # completado → listo para pdca:check
flow: pdca
```

## Siguiente paso

Cuando el piloto está completo y los datos están recopilados → `pdca:check`

---

## Limitaciones

- El juicio de cuándo un piloto es "suficientemente representativo" requiere conocimiento del dominio
- Para procesos con alta variabilidad estacional, la duración del piloto debe cubrir al menos un ciclo completo del patrón
- Si el piloto no puede aislarse del proceso productivo, documentar cuidadosamente las condiciones externas que podrían contaminar los datos

---

## Reference Files

- `assets/pdca-do-template.md` — Template del artefacto `{wp}/pdca-do.md` con secciones: diseño del piloto, baseline, registro de implementación, datos recopilados, desviaciones y observaciones
