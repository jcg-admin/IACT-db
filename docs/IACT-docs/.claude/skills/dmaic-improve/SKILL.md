---
name: dmaic-improve
description: "Use when implementing solutions in a DMAIC project. dmaic:improve — generate improvement alternatives, select optimal solution, implement pilot, validate improvement vs baseline."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 00:00:00
---

# /dmaic-improve — DMAIC: Improve

> *"Solve the root cause, not the symptom. A solution that doesn't address the validated root cause is just moving the problem."*

Ejecuta la fase **Improve** de DMAIC. Diseña, selecciona e implementa soluciones que eliminan las causas raíz identificadas en Analyze. Valida la mejora con datos.

**THYROX Stage:** Stage 10 IMPLEMENT.

**Tollgate:** Mejora validada con datos post-implementación vs baseline de Measure.

---

## Pre-condición

Requiere: `{wp}/dmaic-analyze.md` con:
- Causas raíz confirmadas estadísticamente
- Lista priorizada por impacto y esfuerzo
- Mecanismo causal documentado para cada causa raíz

---

## Cuándo usar este paso

- Cuando Analyze ha producido causas raíz confirmadas con datos
- Para diseñar e implementar soluciones dirigidas a esas causas raíz
- Para validar que las soluciones realmente mejoraron el CTQ

## Cuándo NO usar este paso

- Sin causas raíz validadas de Analyze — implementar soluciones sin causas confirmadas es apostar, no mejorar
- Si la solución ya está decidida sin análisis — eso no es DMAIC Improve, es implementación directa
- Si el alcance de la solución excede el scope del proyecto — escalar o redefinir el charter primero

---

## Actividades

### 1. Generar alternativas de solución

Para cada causa raíz confirmada, generar múltiples opciones:

| Causa raíz confirmada | Solución A | Solución B | Solución C |
|----------------------|-----------|-----------|-----------|
| [Causa 1] | [Opción 1a] | [Opción 1b] | [Opción 1c] |
| [Causa 2] | [Opción 2a] | [Opción 2b] | — |

**Técnicas para generar alternativas:**
- Brainstorming estructurado (equipo multifuncional)
- Benchmarking (¿cómo lo resuelven otros?)
- Herramientas Lean (ver sección siguiente)
- Poka-yoke: ¿cómo hacer imposible que la causa vuelva a ocurrir?

### 2. Herramientas Lean — catálogo de soluciones para waste

Para causas raíz relacionadas con waste de flujo o proceso, aplicar herramientas Lean antes de recurrir a soluciones tecnológicas complejas:

| Herramienta Lean | Tipo de waste que resuelve | Cómo aplicar |
|-----------------|---------------------------|-------------|
| **5S** (Clasificar, Ordenar, Limpiar, Estandarizar, Sostener) | Desorden, búsquedas, errores por entorno caótico | Implementar en el área de trabajo; toma 1-2 semanas en un área |
| **Kanban** | Sobreproducción, WIP excesivo | Limitar WIP con tarjetas/columnas; visualizar el flujo de trabajo |
| **SMED** (Single-Minute Exchange of Die) | Tiempos de setup largos | Separar actividades internas (máquina parada) de externas (máquina corriendo); convertir internas a externas |
| **Eliminación de MUDA** (7 desperdicios) | Cualquier actividad que no agrega valor | Mapear actividades VA vs NVA; eliminar NVA pura; minimizar NVA necesaria |
| **Jidoka** (autonomación) | Defectos que pasan desapercibidos | Mecanismos que paran el proceso automáticamente ante defectos |
| **Heijunka** (nivelación) | Demanda variable que genera cuellos de botella | Distribuir volumen de trabajo uniformemente en el tiempo |

> Las herramientas Lean son frecuentemente la solución más rápida y de menor costo para problemas de flujo y proceso. Evaluar antes de diseñar soluciones tecnológicas.

Ver catálogo completo con aplicación paso a paso: [lean-tools-guide.md](./references/lean-tools-guide.md)

### 3. Evaluar y seleccionar solución — Cuadrante Impacto × Esfuerzo

Clasificar cada alternativa en el cuadrante de decisión:

```
                    IMPACTO ALTO
                         │
          PROYECTOS    │  VICTORIAS
          MAYORES      │  RÁPIDAS
    (planificar bien)   │  (hacer ahora)
                         │
ESFUERZO ─────────────────────────── ESFUERZO
ALTO                     │                    BAJO
                         │
         EVITAR /       │  RELLENO
         DESCARTAR      │  (hacer si hay tiempo)
    (poco impacto,      │  (bajo impacto,
     mucho esfuerzo)     │   bajo esfuerzo)
                         │
                    IMPACTO BAJO
```

| Cuadrante | Descripción | Acción |
|-----------|-------------|--------|
| **Victorias Rápidas** | Alto impacto, bajo esfuerzo | Implementar primero — máximo ROI |
| **Proyectos Mayores** | Alto impacto, alto esfuerzo | Planificar cuidadosamente; justificar con business case |
| **Relleno** | Bajo impacto, bajo esfuerzo | Implementar solo si hay capacidad libre |
| **Evitar** | Bajo impacto, alto esfuerzo | No implementar — desproporción de recursos |

**Criterios adicionales de selección:**

| Criterio | Pregunta |
|----------|----------|
| **Ataca la causa raíz** | ¿La solución elimina la causa o solo mitiga el síntoma? |
| **Sostenibilidad** | ¿La solución puede mantenerse sin esfuerzo continuo? |
| **Reversibilidad** | ¿Se puede deshacer si no funciona? |
| **Efectos colaterales** | ¿Podría crear nuevos problemas? |
| **Poka-yoke level** | ¿Hace imposible la recurrencia, o solo más difícil? |

### 4. FMEA — Failure Mode and Effects Analysis (antes del piloto)

Para la solución seleccionada, evaluar los modos de falla antes de implementar:

| Paso del proceso | Modo de falla potencial | Efecto | Severidad (1-10) | Ocurrencia (1-10) | Detección (1-10) | RPN (S×O×D) | Acción preventiva |
|-----------------|------------------------|--------|------------------|-------------------|------------------|-------------|------------------|

**Escala RPN:**

| RPN | Clasificación | Acción requerida |
|-----|--------------|-----------------|
| > 200 | **Crítico** | Acción preventiva obligatoria antes del piloto |
| 100 – 200 | **Importante** | Acción preventiva fuertemente recomendada |
| < 100 | **Monitorear** | Incluir en plan de monitoreo del piloto |

> El FMEA es opcional para soluciones de bajo riesgo, pero obligatorio si la implementación puede afectar procesos críticos o clientes.

### 5. Criterio piloto vs implementación completa

Decidir el alcance antes de implementar:

| Criterio | Piloto (subconjunto) | Implementación completa |
|----------|---------------------|------------------------|
| **Reversibilidad** | Solución nueva o no probada | Solución validada en contexto similar |
| **Riesgo** | RPN > 100 o impacto en producción | RPN < 100, proceso no crítico |
| **Costo de error** | Alto (impacta clientes o procesos críticos) | Bajo (impacto contenible) |
| **Incertidumbre** | Causa raíz probable pero no 100% confirmada | Causa raíz confirmada con alta confianza |

> Por defecto, implementar en piloto primero. La excepción es cuando el contexto es idéntico a uno donde ya se validó la solución.

### 6. Diseñar y ejecutar el piloto

| Elemento | Decisión |
|----------|----------|
| **Scope** | Subconjunto representativo del proceso |
| **Duración** | Suficiente para capturar variabilidad normal |
| **Variables a medir** | Exactamente las mismas que en Measure (baseline) |
| **Control de variables** | Solo cambiar lo definido en la solución; nada más |
| **Rollback** | Condición y procedimiento para revertir |

### 7. Validar mejora — comparación estadística rigurosa

| Métrica | Baseline (Measure) | Post-Improve | Delta | Significancia |
|---------|-------------------|--------------|-------|--------------|
| CTQ principal (DPMO/Sigma) | | | | p-value < 0.05? |
| CTQs de control | | | | Sin regresión? |

**Herramientas de validación:**

| Comparación | Herramienta | Criterio |
|-------------|-------------|---------|
| Proporciones (antes/después) | Chi-cuadrado / test de proporciones | p < 0.05 |
| Medias continuas (antes/después) | t-test de dos muestras | p < 0.05 |
| Varianzas (antes/después) | F-test / Levene | p < 0.05 |
| Distribuciones completas | Mann-Whitney (no paramétrico) | p < 0.05 |

**Calcular el nuevo Sigma Level y comparar con baseline de Measure.**

---

## Artefacto esperado

`{wp}/dmaic-improve.md` — usar template: [dmaic-improve-template.md](./assets/dmaic-improve-template.md)

---

## Red Flags — señales de Improve mal ejecutado

- **Solución que no ataca la causa raíz confirmada** — la solución favorita del equipo vs la causa real no siempre coinciden
- **Omitir herramientas Lean** — para problemas de flujo y proceso, la solución tecnológica compleja suele ser la segunda mejor opción
- **Piloto sin control de variables** — si cambiaron otras cosas durante el piloto, no se puede atribuir la mejora a la solución
- **Validación solo con promedio** — verificar también si cambió la variabilidad (desviación estándar)
- **Sin comparación estadística** — *"claramente mejoró"* sin p-value no es validación en DMAIC
- **RPN > 200 ignorado en FMEA** — implementar sin mitigar modos de falla críticos es riesgo innecesario
- **Implementar al 100% sin piloto cuando RPN > 100** — el piloto existe para limitar el blast radius si algo sale mal
- **Comparar contra objetivo del charter, no contra baseline de Measure** — el tollgate de Improve es mejorar vs baseline

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: dmaic:improve
flow: dmaic
```

**Al COMPLETAR** (mejora validada estadísticamente, nuevo Sigma Level documentado):
```yaml
methodology_step: dmaic:improve  # completado → listo para dmaic:control
flow: dmaic
```

## Siguiente paso

Cuando la mejora está validada estadísticamente → `dmaic:control`

---

## Limitaciones

- DOE completo y análisis multivariante avanzado requieren herramientas especializadas (Minitab, R, Python)
- FMEA detallado para procesos críticos de seguridad requiere conocimiento profundo del dominio
- La validación estadística asume independencia de las observaciones — si los datos tienen autocorrelación temporal, usar Series de Tiempo en lugar de t-test
- Las herramientas Lean requieren cambio cultural además de técnico — la implementación técnica es solo la mitad del trabajo

---

## Reference Files

### Assets
- [dmaic-improve-template.md](./assets/dmaic-improve-template.md) — Template del artefacto Improve: alternativas, cuadrante I×E, FMEA, diseño del piloto, validación estadística, nuevo Sigma Level

### References
- [lean-tools-guide.md](./references/lean-tools-guide.md) — 7 MUDA, 5S paso a paso, Kanban (WIP limits), SMED, Jidoka, Heijunka, eliminación VA/NVA
- [fmea-guide.md](./references/fmea-guide.md) — Escala S/O/D (1-10), RPN thresholds (>200 crítico), ejemplo completo, cuándo FMEA es obligatorio
- [doe-guide.md](./references/doe-guide.md) — Factorial 2ᵏ, fraccional 2ᵏ⁻ᵖ (resolución III/IV/V), planificación DOE, DOE vs experimento secuencial
