---
name: pdca-check
description: "Use when reviewing results of a PDCA pilot. pdca:check — compare actual results against Plan objectives, identify gaps, and analyze causes of success or failure."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 00:00:00
---

# /pdca-check — PDCA: Check

> *"Data kills opinions. Check is the moment of truth — what the numbers say, not what we hoped."*

Ejecuta el paso **Check** del ciclo PDCA. Compara los resultados del piloto contra el objetivo SMART del Plan. Produce un veredicto basado en datos.

**THYROX Stage:** Stage 10 IMPLEMENT / Stage 11 TRACK/EVALUATE.

---

## Pre-condición

Requiere: `{wp}/pdca-do.md` con:
- Baseline del piloto documentado (medido antes del cambio)
- Datos recopilados durante el piloto (mismas métricas que el baseline del Plan)
- Registro de desviaciones del plan original

---

## Cuándo usar este paso

- Cuando el piloto de Do está completo y los datos están recopilados
- Para determinar si la hipótesis de mejora fue confirmada o refutada

## Cuándo NO usar este paso

- Si los datos del Do son insuficientes (muestra muy pequeña o duración muy corta) → extender el piloto primero
- Si las condiciones del piloto fueron radicalmente distintas a las del baseline → los datos no son comparables; documentar y reiniciar Do
- Sin baseline definido en Plan → sin referencia, el Check no puede concluir nada

---

## Actividades

### 1. Comparar resultados con el objetivo SMART

| Métrica | Baseline (Plan) | Objetivo SMART (Plan) | Resultado Do | Delta vs Baseline | ¿Objetivo alcanzado? |
|---------|-----------------|----------------------|--------------|-------------------|---------------------|
| [Principal] | [valor] | [meta] | [valor real] | [+/-X%] | ✅ / ❌ |
| [Control 1] | [valor] | sin regresión | [valor real] | [+/-X%] | ✅ / ❌ |

### 2. Tamaño mínimo de muestra para conclusión válida

Antes de concluir, verificar que los datos son suficientes:

| Tipo de proceso | Mínimo recomendado | Razón |
|-----------------|-------------------|-------|
| Proceso continuo (eventos frecuentes) | ≥ 30 observaciones post-cambio | Aproximación normal por CLT |
| Proceso intermitente (eventos semanales) | ≥ 4-6 semanas post-cambio | Capturar ciclo completo |
| Proceso de baja frecuencia (mensual) | ≥ 3 ciclos completos | Representatividad |

> Si la muestra no cumple el mínimo, el Check no puede concluir con confianza. Opciones: extender el Do, o documentar el Check como "preliminar" y planificar una revisión.

### 3. Evaluar magnitud de la mejora

| Nivel | Criterio | Acción en Act |
|-------|----------|---------------|
| **Objetivo superado** | Resultado > meta con margen | Estandarizar y buscar nuevo objetivo |
| **Objetivo alcanzado** | Resultado = meta ± margen aceptable | Estandarizar |
| **Mejora parcial** | Resultado mejoró pero no alcanzó la meta | Act: ajustar plan, nuevo ciclo |
| **Sin cambio** | Resultado = baseline | Act: revisar hipótesis |
| **Regresión** | Resultado peor que baseline | Act: revertir cambio, reinvestigar |

### 4. Evaluar significancia estadística

Para evitar concluir que "mejoró" cuando la diferencia es ruido:

| Herramienta | Usar cuando... | Criterio de significancia |
|-------------|---------------|--------------------------|
| **Run Chart** (recomendado para PDCA) | Datos temporales secuenciales | ≥ 8 puntos consecutivos por encima/debajo de la mediana pre-cambio indica señal real |
| **Rango de variación histórica** | Siempre disponible con el baseline | ¿El resultado está fuera del rango normal del proceso antes del cambio? |
| **T-test de dos muestras** | n ≥ 30 en ambos grupos; distribución aproximadamente normal | p-value < 0.05 (asumir normalidad o n suficientemente grande por CLT) |
| **Juicio experto** | Cambios cualitativos o contexto con mucha variación externa | Documentar el razonamiento explícitamente |

> **Run Chart para PDCA:** Graficar cada punto de medición en el tiempo, marcar la mediana del período pre-cambio como línea de referencia. Si ≥ 8 puntos consecutivos caen por debajo (para métricas donde menor = mejor), la mejora es estadísticamente significativa por la regla de corridas.

Ver construcción detallada, árbol de selección de test y tabla de tamaños de muestra: [measurement-tools.md](./references/measurement-tools.md)

### 5. Analizar causas del resultado

**Si fue exitoso:**
- ¿La hipótesis se confirmó como esperado?
- ¿Hubo factores adicionales que contribuyeron?
- ¿El resultado es transferible al ámbito completo?

**Si fue parcial o fallido:**
- ¿Falló la hipótesis (causa raíz incorrecta)?
- ¿Falló la implementación (hipótesis correcta pero mal ejecutada)?
- ¿Cambiaron las condiciones externas durante el piloto?

### 6. Formular la conclusión del piloto

La conclusión debe ser una afirmación directa:

- ✅ *"La hipótesis fue confirmada. El índice compuesto redujo p95 de 2.1s a 0.6s (71% de mejora), superando el objetivo de 800ms."*
- ❌ *"La hipótesis fue refutada. El índice no mejoró la latencia; la causa raíz está en otro lugar."*
- ⚠️ *"Resultado mixto: la latencia mejoró (0.9s) pero no alcanzó el objetivo (0.8s). Se requiere ajuste."*

---

## Artefacto esperado

`{wp}/pdca-check.md` — usar template: [pdca-check-template.md](./assets/pdca-check-template.md)

---

## Red Flags

- **"Mejoró" sin número** — toda conclusión del Check debe tener datos
- **Comparar contra el objetivo sin el baseline** — el baseline es lo que importa
- **Ignorar regresiones en métricas de control** — si la mejora principal se logró pero algo más empeoró, no es éxito completo
- **Cambiar el objetivo después de ver los resultados** — el objetivo se define en Plan, no se ajusta en Check para que "parezca éxito"
- **Concluir con datos insuficientes** — si el piloto duró 2 horas en un proceso semanal, los datos no son representativos
- **Aplicar T-test sin verificar normalidad o tamaño de muestra** — con n < 30, el T-test puede dar resultados poco confiables; usar Run Chart en su lugar
- **Atribuir el resultado a la intervención sin descartar factores externos** — ¿cambió algo más en el entorno durante el piloto?

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pdca:check
flow: pdca
```

**Al COMPLETAR** (análisis de resultados con conclusión directa):
```yaml
methodology_step: pdca:check  # completado → listo para pdca:act
flow: pdca
```

## Siguiente paso

Cuando el análisis de resultados está completo con conclusión directa → `pdca:act`

---

## Limitaciones

- Para procesos con alta variabilidad natural, la significancia estadística requiere mayor rigor que la comparación simple de promedios
- Si el piloto fue contaminado por eventos externos (incidentes, cambios de infraestructura, estacionalidad), documentar la contaminación y considerar repetir el Do
- El Check no puede ser más confiable que la calidad de los datos recopilados en Do

---

## Reference Files

- `assets/pdca-check-template.md` — Template del artefacto `{wp}/pdca-check.md` con comparativa antes/después, validación de suficiencia, significancia y conclusión
- `references/measurement-tools.md` — Run Chart (regla de 8 corridas, construcción), tamaños de muestra por tipo de proceso, tabla antes/después, árbol de selección de test estadístico
