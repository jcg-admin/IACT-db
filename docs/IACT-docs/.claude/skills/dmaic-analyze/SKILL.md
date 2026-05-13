---
name: dmaic-analyze
description: "Use when identifying root causes in a DMAIC project. dmaic:analyze — perform root cause analysis using statistical tools (Pareto, Ishikawa, regression), validate causes with data."
allowed-tools: Read Glob Grep Bash Write Edit
effort: medium
disable-model-invocation: true
updated_at: 2026-04-17 00:00:00
---

# /dmaic-analyze — DMAIC: Analyze

> *"The most important thing is not to stop questioning. A root cause is only valid when data confirms it — not when the team believes it."*

Ejecuta la fase **Analyze** de DMAIC. Identifica y valida causas raíz con evidencia estadística.

**THYROX Stage:** Stage 3 DIAGNOSE.

**Tollgate:** Causas raíz validadas con datos (no solo con opiniones o brainstorming).

---

## Pre-condición

Requiere: `{wp}/dmaic-measure.md` con:
- Baseline cuantitativo del proceso (DPU/DPMO/Sigma o Cp/Cpk)
- MSA realizado y aceptado
- Datos estratificados por subgrupos (turno, máquina, operador, etc.)

---

## Cuándo usar este paso

- Cuando el baseline de Measure está establecido y el MSA validado
- Para identificar qué variables del proceso explican la variación observada en el CTQ
- Antes de definir soluciones — nunca diseñar mejoras sin causas raíz confirmadas

## Cuándo NO usar este paso

- Sin baseline de Measure — Analyze necesita datos del proceso para analizar
- Si la causa raíz ya está confirmada con datos previos — documentarla y avanzar a Improve
- Si el equipo quiere *confirmar* una causa ya decidida sin análisis real — eso es racionalización post-hoc

---

## Actividades

### 1. VSM — Value Stream Mapping (para procesos con flujo)

Para procesos operacionales o de información con flujo secuencial, el VSM complementa el análisis estadístico identificando waste en el flujo:

| Tipo de waste (MUDA) | Señal en VSM | Pregunta para Analyze |
|---------------------|-------------|----------------------|
| **Espera** | Tiempo de cola entre etapas | ¿Por qué hay cola aquí? ¿Cuello de botella aguas arriba? |
| **Sobreproducción** | WIP acumulado antes de una etapa | ¿Qué genera este exceso de WIP? |
| **Reproceso** | Bucles de corrección en el flujo | ¿Qué inputs defectuosos entran a esta etapa? |
| **Transporte** | Handoffs entre departamentos/sistemas | ¿Qué se pierde en cada handoff? |
| **Inventario** | WIP > 1 entre etapas consecutivas | ¿Hay desbalance de capacidades? |

> El VSM no reemplaza el análisis estadístico — lo complementa. Identifica *dónde* buscar causas en el flujo antes de aplicar herramientas estadísticas para confirmarlas.

### 2. Generar hipótesis de causas — lluvia de ideas estructurada

**Diagrama de Ishikawa (5M / 6M):**

| Categoría | Preguntas guía |
|-----------|---------------|
| **Máquina / Equipo** | ¿Hay variación entre máquinas? ¿Mantenimiento? ¿Calibración? |
| **Método / Proceso** | ¿El proceso está documentado? ¿Se sigue? ¿Hay variación entre operadores? |
| **Material** | ¿Hay variación en los insumos? ¿Diferentes proveedores? |
| **Mano de obra** | ¿Hay diferencias entre turnos, operadores, equipos? |
| **Medio ambiente** | ¿Temperatura, humedad, ruido, hora del día afectan? |
| **Medición** (6M) | ¿El sistema de medición introduce variación? (ya validado en MSA) |

El Ishikawa genera hipótesis, no las confirma. Cada rama es una hipótesis a validar con datos.

### 3. Seleccionar herramienta de análisis según el problema

| Herramienta | Cuándo usar | Qué responde |
|-------------|-------------|-------------|
| **Análisis de Pareto** | Múltiples categorías de defectos | ¿Cuáles pocas causas generan la mayoría del problema? |
| **5 Whys** | Causa aparentemente simple; buen punto de partida | ¿Cuál es la causa raíz profunda? |
| **VSM** | Proceso con flujo secuencial | ¿Dónde está el waste en el flujo? |
| **Análisis de estratificación** | Datos recopilados por subgrupos | ¿La causa está en el turno X, la máquina Y, el operador Z? |
| **Diagrama de dispersión** | Dos variables continuas | ¿Existe correlación entre variable X y el CTQ? |
| **Regresión lineal** | Una o más variables continuas predictoras | ¿Cuánto explica X la variación en CTQ? |
| **ANOVA** | Variable categórica con múltiples grupos | ¿La media del CTQ difiere significativamente entre grupos? |
| **Chi-cuadrado** | Dos variables categóricas | ¿Hay asociación estadística entre categoría A y defecto B? |
| **DOE exploratorio** | Múltiples factores con posibles interacciones | ¿Qué combinación de factores explica la variación? |

### 4. Análisis de Pareto — identificar las pocas causas vitales

1. Listar todas las categorías de defectos/causas con frecuencia
2. Ordenar de mayor a menor
3. Calcular % acumulado
4. Identificar el punto donde se llega al 80%

```
Las pocas vitales (20% de causas → 80% del problema) son las que merece la pena investigar primero.
Las muchas triviales (80% de causas → 20% del problema) no justifican esfuerzo de mejora.
```

### 5. 5 Whys — profundizar en causas raíz

Para cada causa "vital", preguntar "¿Por qué?" repetidamente:

```
Problema: 18% de pedidos llegan tarde
¿Por qué? → La ruta de despacho se asigna manualmente y hay errores
¿Por qué? → No hay criterios claros de asignación de ruta
¿Por qué? → El proceso de asignación nunca fue documentado
¿Por qué? → El responsable original no hizo transfer de conocimiento
¿Por qué? → No existe proceso de onboarding para este rol  ← causa raíz
```

**Cuándo parar:** llegaste a algo que puedes cambiar directamente, o el siguiente "¿por qué?" escapa del scope del proyecto.

### 6. Validar causas con datos — el paso crítico

Una causa hipotética se convierte en causa raíz confirmada cuando los datos la respaldan.

**Hipótesis estadística (H0 / H1):**

Antes de cada prueba estadística, declarar explícitamente:
- **H0 (hipótesis nula):** "No hay diferencia entre grupos / No hay relación entre X e Y"
- **H1 (hipótesis alternativa):** "Existe diferencia entre grupos / Existe relación entre X e Y"

Si p-value < 0.05 → rechazar H0 → la diferencia es estadísticamente significativa → causa candidata confirmada.

Ver templates H0/H1 por tipo de test y árbol de selección estadístico: [hypothesis-testing.md](./references/hypothesis-testing.md)

| Tipo de causa | Herramienta de validación | H0 | Criterio |
|---------------|--------------------------|-----|----------|
| Categórica (turno A vs B) | ANOVA / t-test | No hay diferencia entre grupos | p-value < 0.05 |
| Continua (temperatura vs defectos) | Regresión / dispersión | β = 0 (sin pendiente) | R² significativo, p-value < 0.05 |
| Temporal (antes/después de evento) | Control chart / t-test | No hay cambio en media/varianza | Cambio estadísticamente significativo |
| Dos variables categóricas | Chi-cuadrado | Variables independientes | p-value < 0.05 |

### 7. Causalidad — más allá de la correlación

**Correlación ≠ Causalidad.** Para establecer que X *causa* el CTQ, verificar:

| Criterio de causalidad | Pregunta | Cómo verificar |
|----------------------|----------|----------------|
| **Precedencia temporal** | ¿X ocurre antes que Y? | Timeline del proceso; correlación lagged |
| **Mecanismo causal** | ¿Hay una explicación física/lógica de por qué X causa Y? | Conocimiento del dominio; literatura |
| **Dosis-respuesta** | ¿A mayor X, mayor efecto en Y? | Gráfica X vs Y; análisis de regresión |
| **Descarte de confusores** | ¿Hay una variable Z que cause tanto X como Y? | ANOVA con covariables; diseño experimental |
| **Reversibilidad** | Si se reduce X, ¿se reduce Y? | Prueba piloto controlada |

> Si solo existe correlación sin mecanismo causal verificable, documentar como "causa candidata" y diseñar un experimento en Improve para confirmar.

### 8. Priorizar causas raíz confirmadas

| Causa raíz | Impacto estimado | Esfuerzo de solución | Prioridad |
|------------|-----------------|---------------------|-----------|
| [Causa 1] | [% de variación explicada] | [bajo / medio / alto] | [1 / 2 / 3] |

---

## Artefacto esperado

`{wp}/dmaic-analyze.md` — usar template: [dmaic-analyze-template.md](./assets/dmaic-analyze-template.md)

---

## Red Flags — señales de Analyze mal ejecutado

- **"Ya sabemos la causa"** — si el equipo decide la causa antes de analizar datos, el análisis es teatro
- **Ishikawa sin datos** — el diagrama solo genera hipótesis; sin validación estadística, no hay causa raíz
- **5 Whys que se detiene en el síntoma** — *"¿Por qué? Porque falla"* no es profundización
- **Confundir correlación con causalidad** — dos variables que se mueven juntas no implican que una cause la otra; buscar el mecanismo
- **Sin declarar H0/H1** — hacer pruebas estadísticas sin hipótesis explícita hace difícil interpretar los resultados
- **Validar solo las causas favoritas** — sesgo de confirmación; analizar *todas* las hipótesis del Ishikawa
- **Causas raíz fuera del scope** — si la causa raíz es *"la estrategia de la empresa"*, redefinir scope o escalar
- **Ignorar el VSM** — para procesos con flujo, el análisis estadístico sin mapa de flujo puede perder waste sistémico

---

## Estado en now.md

**Al INICIAR este step:**
```yaml
methodology_step: dmaic:analyze
flow: dmaic
```

**Al COMPLETAR** (causas raíz validadas con datos y priorizadas):
```yaml
methodology_step: dmaic:analyze  # completado → listo para dmaic:improve
flow: dmaic
```

## Siguiente paso

Cuando las causas raíz están validadas con datos y priorizadas → `dmaic:improve`

---

## Limitaciones

- Para análisis estadísticos avanzados (DOE completo, regresión múltiple, SEM), se requieren herramientas especializadas (Minitab, R, Python statsmodels)
- El número de "Whys" en 5 Whys no es literal — puede requerir más o menos de 5 iteraciones
- Si los datos de Measure no tienen suficiente estratificación, Analyze no podrá identificar las fuentes de variación
- La verificación de causalidad requiere conocimiento del dominio que este skill no puede proveer — el equipo debe tener expertos del proceso

---

## Reference Files

### Assets
- [dmaic-analyze-template.md](./assets/dmaic-analyze-template.md) — Template del artefacto Analyze: VSM, Ishikawa 6M, Pareto, 5-Whys, validación estadística H0/H1, causas priorizadas

### References
- [hypothesis-testing.md](./references/hypothesis-testing.md) — Templates H0/H1 por situación, tabla de decisión p-value, árbol de selección estadístico, prerequisitos por prueba
- [root-cause-tools.md](./references/root-cause-tools.md) — VSM (símbolos + métricas + flujo), Ishikawa 6M con preguntas detalladas, 5-Why protocolo, patrones de diagrama de dispersión
