# Guía de Root Cause Analysis (RCA) — PS8

> Fuente base: Root cause analysis — /tmp/references/topics/topics/root-cause-analysis/index.md
> Ampliado con contexto TBP y métodos de confirmación para pps:analyze.

---

## ¿Qué es el Root Cause Analysis?

Root Cause Analysis (RCA) es una técnica de resolución de problemas que busca identificar las causas subyacentes de un evento, en lugar de solo tratar los síntomas. El objetivo es prevenir que problemas similares ocurran en el futuro eliminando las causas fundamentales, no suprimiendo sus efectos.

RCA se usa ampliamente en ingeniería, manufactura, salud, desarrollo de software y gestión de negocios. En el contexto de Toyota TBP, el RCA es el Step 4 del ciclo de 8 pasos y es el punto de inflexión del proyecto: sin causa raíz correctamente identificada, las contramedidas atacan síntomas y el problema regresa.

---

## Pasos del RCA en el contexto PS8

### 1. Identificar el problema

Usar el Problem Statement de pps:clarify: síntoma observable con datos, sin causas asumidas ni soluciones propuestas. El RCA comienza donde el Problem Statement termina.

### 2. Recopilar datos

Evidencia necesaria para el análisis:
- Observaciones directas del Gemba (de pps:clarify)
- Registros históricos del sistema (logs, reportes, dashboards)
- Entrevistas con quienes trabajan directamente en el proceso
- Datos cuantitativos: frecuencia, magnitud, variabilidad, tendencia

### 3. Analizar causas y efectos

Herramientas en pps:analyze:
- **Fishbone (Ishikawa)**: exploración amplia de causas potenciales por categorías (6M / 4P)
- **5 Whys**: drill-down secuencial desde síntoma hasta causa sistémica
- **Análisis de Pareto**: cuantificar frecuencia de causas para priorizar (el 20% de causas explica el 80% de efectos)

### 4. Identificar la causa raíz

La causa raíz es el factor subyacente que, si se elimina o modifica, evita que el problema ocurra en el futuro. Características:

- **Es un factor sistémico** — proceso, estándar, diseño, capacitación — no una persona
- **Es accionable** — el equipo puede intervenir sobre ella
- **Tiene evidencia que la confirma** — no es una suposición

### 5. Desarrollar y ejecutar el plan de acción

Una vez identificada la causa raíz confirmada → pps:countermeasures para desarrollar contramedidas, y pps:implement para ejecutarlas.

---

## Métodos de confirmación de causa raíz

La diferencia entre una hipótesis y una causa raíz confirmada es la evidencia:

| Método | Cuándo usar | Proceso |
|--------|-------------|---------|
| **Datos históricos correlacionados** | Hay registros temporales del problema | Mostrar que la causa hipotética ocurre cuando el problema ocurre y no cuando no ocurre |
| **Experimento controlado** | Se puede manipular la variable sospechada sin riesgo | Reproducir el problema introduciendo la causa; eliminarlo eliminando la causa |
| **Observación directa en Gemba** | El proceso es observable durante el problema | Ver directamente si la causa está presente cuando el problema aparece |
| **Análisis de Pareto** | Hay múltiples causas candidatas con datos | Cuantificar % de ocurrencia por causa; priorizar la de mayor peso |
| **Eliminación por exclusión** | Solo quedan pocas hipótesis | Descartar todas excepto la que explica todos los casos conocidos del problema |

---

## Análisis de Pareto — priorización basada en datos

El Principio de Pareto establece que el 80% de los efectos proviene del 20% de las causas. Aplicado al RCA:

1. Listar todas las causas identificadas en el Fishbone
2. Recopilar datos de frecuencia de cada causa (cuántas veces contribuyó al problema)
3. Ordenar de mayor a menor frecuencia
4. Calcular el % acumulado
5. Identificar las causas que explican el 80% de los casos — esas son las de mayor prioridad

| Causa | # de ocurrencias | % del total | % acumulado |
|-------|-----------------|-------------|-------------|
| [Causa A] | [n] | [%] | [%] |
| [Causa B] | [n] | [%] | [%] |
| [Causa C] | [n] | [%] | [%] |

---

## Causa raíz vs causa contributiva

| Tipo | Definición | Implicación |
|------|-----------|-------------|
| **Causa raíz** | El factor fundamental que, si se elimina, previene la recurrencia | Debe tener contramedida directa en pps:countermeasures |
| **Causa contributiva** | Factor que agrava o facilita el problema pero no lo genera por sí solo | Puede documentarse como mejora adicional pero no es el foco principal |
| **Causa sintomática** | La causa inmediata visible — un nivel antes de la causa real | No es suficiente como causa raíz; continuar el análisis más profundo |

Ejemplo:
```
Síntoma: el sistema cae bajo alta carga
Causa sintomática: el servidor se queda sin memoria
Causa contributiva: el equipo no monitorea el uso de memoria
Causa raíz: la arquitectura no tiene límites de recursos por proceso (falla de diseño sistémica)
```

---

## RCA para problemas recurrentes

Si el problema ya fue "resuelto" antes y regresó:

1. **Recuperar la solución anterior** — ¿qué se hizo la última vez?
2. **Evaluar si se llegó a la causa raíz** — ¿se trató el síntoma o la causa?
3. **Buscar la causa de la causa** — si se trató correctamente pero el problema volvió, hay una causa más profunda
4. **Aumentar el número de "porqués"** — en problemas recurrentes, la causa raíz suele estar más profunda de lo esperado

> Los problemas recurrentes son señal de que el RCA anterior no llegó a la causa raíz sistémica. TBP exige ir más profundo.
