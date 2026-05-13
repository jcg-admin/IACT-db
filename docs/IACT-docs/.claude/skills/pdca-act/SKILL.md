---
name: pdca-act
description: "Use when deciding whether to standardize or adjust a PDCA improvement. pdca:act — standardize and scale if successful, or adjust and plan next cycle if not. Document lessons learned."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 00:00:00
---

# /pdca-act — PDCA: Act

> *"Standardize what works, or you'll lose the gain. Every successful improvement that isn't standardized will regress."*

Ejecuta el paso **Act** del ciclo PDCA. Decide estandarizar y escalar, o ajustar y repetir. En ambos casos, documenta lo aprendido y comunica el resultado.

**THYROX Stage:** Stage 10 IMPLEMENT / Stage 12 STANDARDIZE (si estandarización completa).

---

## Pre-condición

Requiere: `{wp}/pdca-check.md` con:
- Veredicto claro (éxito / parcial / falla) respaldado por datos
- Análisis de causas del resultado
- Recomendación para Act

---

## Cuándo usar este paso

- Cuando Check ha producido un veredicto claro con datos
- Para cerrar el ciclo actual y determinar el siguiente paso
- Para que la mejora sobreviva más allá del piloto

## Cuándo NO usar este paso

- Sin Check completado — Act sin datos es una decisión ciega
- Si el Check identificó contaminación externa que invalida los datos → repetir Do primero

---

## Decisión basada en el Check

### Árbol de decisión

```
Check resultado
├── Objetivo alcanzado o superado
│   ├── Sin regresiones en métricas de control → ESTANDARIZAR + ESCALAR
│   └── Con regresión en métricas de control → AJUSTAR primero, luego estandarizar
├── Mejora parcial (mejoró pero no alcanzó meta)
│   ├── La hipótesis era correcta, implementación incompleta → NUEVO CICLO con plan ajustado
│   └── La hipótesis era parcialmente correcta → NUEVO CICLO con hipótesis refinada
└── Sin mejora o regresión
    ├── Regresión revertida durante Do → documentar causa, NUEVO CICLO con análisis de estabilidad
    ├── Hipótesis incorrecta → NUEVO CICLO con análisis de Plan
    └── Implementación incorrecta → NUEVO CICLO con Do mejorado
```

---

## Actividades — si ESTANDARIZAR

### 1. Actualizar SOPs / procedimientos

Los cambios implementados en el piloto deben quedar documentados como el nuevo estándar:

| Qué actualizar | Cómo |
|---------------|------|
| Runbooks / SOPs | Incorporar los pasos nuevos, eliminar los obsoletos |
| Documentación técnica | README, wikis, configuración de referencia |
| Checklist de operaciones | Si el proceso tiene pasos manuales |
| Configuración de sistema | Variables de entorno, parámetros, archivos de configuración |

### 2. Poka-yoke — error-proofing del nuevo estándar

Antes de escalar, preguntar: *¿Cómo evito que alguien revierta este cambio sin darse cuenta?*

| Técnica | Ejemplo |
|---------|---------|
| **Constraint de sistema** | Hacer imposible el comportamiento anterior (ej: constraint de BD, type check) |
| **Automatización** | El nuevo proceso corre automáticamente, no requiere acción manual |
| **Alerta de regresión** | Monitor que avisa si la métrica vuelve al estado anterior |
| **Documentación prominente** | Aviso en el código/config que explica por qué no revertir |

### 3. Yokoten — despliegue horizontal

Ver proceso completo de Yokoten, adaptación y transferencia: [standardization-patterns.md](./references/standardization-patterns.md)

Antes de escalar dentro del proceso, evaluar si la mejora es transferible a procesos análogos:

| Pregunta | Acción |
|----------|--------|
| ¿Hay otros equipos/servicios con el mismo problema? | Identificarlos y notificarles el aprendizaje |
| ¿La hipótesis aplica a procesos similares? | Proponer aplicar la misma solución, adaptada |
| ¿Se puede generalizar la técnica más allá del caso concreto? | Documentar el patrón en el repositorio de mejoras |

> Yokoten (横展開, despliegue horizontal) es el principio Lean de propagar aprendizajes entre procesos análogos. No es obligatorio, pero maximiza el valor de cada ciclo PDCA.

### 4. Escalar al ámbito completo

El piloto corrió en un subconjunto. Para escalar:

| Paso | Verificar |
|------|-----------|
| Rollout plan | ¿Cómo se despliega al resto? ¿Gradual o todo a la vez? |
| Comunicación | ¿Quién necesita saber del cambio? |
| Training | ¿Alguien necesita aprender el nuevo proceso? |
| Monitoreo post-rollout | ¿Qué métricas vigilar los primeros días? |

### 5. Comunicar el resultado a stakeholders

| Audiencia | Qué comunicar | Cuándo |
|-----------|---------------|--------|
| Sponsor / dueño del proceso | Resultado vs objetivo SMART, impacto en negocio | Al finalizar Act |
| Equipo operativo | El nuevo estándar, qué cambia en su trabajo | Antes del rollout |
| Áreas análogas (si aplica Yokoten) | El aprendizaje clave y cómo replicarlo | Después de estabilizar |

### 6. Establecer nuevo baseline

Después de escalar, el resultado del ciclo se convierte en el nuevo baseline. Documentar:
- Nueva métrica baseline (valor, fecha)
- Si se define un nuevo objetivo de mejora → iniciar nuevo `pdca:plan`

---

## Actividades — si NUEVO CICLO

### 1. Analizar qué ajustar

| Tipo de falla | Qué cambiar en el próximo Plan |
|---------------|-------------------------------|
| Hipótesis incorrecta | Revisar el análisis de causa raíz; ¿qué nos llevó a la hipótesis errónea? |
| Implementación incompleta | Identificar por qué Do no ejecutó el plan completo |
| Objetivo no realista | Ajustar la meta al alcance demostrado por los datos |
| Condiciones externas | Aislar mejor el piloto o esperar condiciones más estables |
| Regresión total revertida | Documentar la señal de parada, analizar qué variable causó la regresión antes de replantear la hipótesis |

### 2. Documentar el aprendizaje para el próximo ciclo

La lección del ciclo fallido es insumo para el próximo Plan. Documentar:
- *"La hipótesis era X pero los datos mostraron Y — la causa real parece ser Z"*
- *"La implementación se detuvo en el paso N por razón R — el próximo ciclo debe contemplar R"*

---

## Lecciones aprendidas — siempre, independiente del resultado

Documentar al final de cada ciclo:

| Dimensión | Pregunta |
|-----------|----------|
| **Proceso** | ¿Qué funcionó bien en el ciclo Plan-Do-Check? ¿Qué fue difícil? |
| **Técnica** | ¿Las herramientas y técnicas elegidas fueron las correctas? |
| **Hipótesis** | ¿La hipótesis fue buena? ¿Cómo mejorar el análisis inicial? |
| **Datos** | ¿Los datos recopilados en Do fueron suficientes para concluir en Check? |
| **Comunicación** | ¿Los stakeholders estuvieron informados y alineados? |

---

## A3 Report (opcional)

Para comunicar el ciclo PDCA completo en una sola página, usar el formato **A3 Report**:

| Sección | Contenido |
|---------|-----------|
| **Contexto** | Por qué el problema importa al negocio |
| **Situación actual** | Baseline + Problem Statement |
| **Objetivo** | SMART goal del Plan |
| **Análisis** | Causa raíz identificada en Plan |
| **Contramedidas** | Plan de acción y piloto Do |
| **Resultado** | Comparativa Check (antes/después) |
| **Próximos pasos** | Decisión Act: estandarizar / nuevo ciclo |

> El A3 Report es el artefacto de comunicación estándar en Kaizen y Toyota Production System. Útil cuando el ciclo PDCA involucra múltiples stakeholders o cuando el resultado debe presentarse formalmente.

---

## Artefacto esperado

`{wp}/pdca-act.md` — usar template: [pdca-act-template.md](./assets/pdca-act-template.md)

---

## Red Flags — señales de Act mal ejecutado

- **Estandarizar sin documentar** — si nadie escribe el nuevo estándar, en 3 meses el equipo habrá regresado al método anterior
- **Escalar sin poka-yoke** — sin mecanismo de protección, cualquier cambio posterior puede revertir la mejora accidentalmente
- **"Nuevo ciclo" sin lección** — repetir el ciclo sin entender por qué falló el anterior es solo más tiempo desperdiciado
- **Cerrar el WP con "parcialmente exitoso" sin definir qué sigue** — ambigüedad en Act produce entropía; siempre concluir con una acción clara
- **Ajustar el objetivo para que "parezca éxito"** — si no alcanzó la meta, decirlo directamente y explicar qué se aprendió
- **No comunicar el resultado a stakeholders** — el ciclo PDCA tiene valor de aprendizaje organizacional, no solo técnico
- **Ignorar Yokoten** — estandarizar solo en el proceso piloto cuando hay procesos análogos con el mismo problema desaprovecha el aprendizaje

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: pdca:act
flow: pdca
```

**Al COMPLETAR** (decisión tomada, documentada y comunicada):
```yaml
methodology_step: pdca:act  # completado → estandarizar o nuevo ciclo
flow: pdca
```

## Siguiente paso

Si ciclo exitoso + estandarizado → cerrar WP o iniciar nuevo objetivo (`pdca:plan`)
Si ciclo requiere ajuste → `pdca:plan` con hipótesis ajustada y lecciones incorporadas

---

## Limitaciones

- Act no puede compensar un Check sin datos; si los datos de Do son pobres, la decisión de Act será débil
- La estandarización es responsabilidad del equipo dueño del proceso — este skill guía qué documentar, pero el ownership de los cambios debe ser claro
- Para cambios que afectan múltiples equipos, el rollout requiere coordinación fuera del scope de este skill
- Yokoten requiere que haya áreas análogas con problemas similares — no siempre aplica

---

## Reference Files

- `assets/pdca-act-template.md` — Template del artefacto `{wp}/pdca-act.md` con árbol de decisión, sección estandarizar (SOPs, poka-yoke, Yokoten, rollout) y sección nuevo ciclo
- `references/standardization-patterns.md` — Yokoten (4 pasos: identificar/adaptar/transferir/verificar), A3 Report template, ciclo SDCA, estructura de SOP con antipatrones
