# Lean RCA Guide — Root Cause Analysis para Lean

Guía de técnicas de análisis de causa raíz aplicadas al contexto Lean: 5 Whys, Fishbone (6M), validación de causas y errores comunes.

---

## Por qué la causa raíz importa en Lean

Un Kaizen event sin análisis de causa raíz es un "arreglo rápido" que:
- No previene que el waste regrese
- Puede atacar el síntoma equivocado
- Desperdicia el tiempo del equipo en mejoras que no tienen impacto duradero

La regla Lean es: **definir la causa raíz antes de elegir la herramienta de mejora**.

| Sin análisis de causa raíz | Con análisis de causa raíz |
|---------------------------|---------------------------|
| "Hay esperas → ponemos Kanban" | "La espera es por falta de señal visual → el Kanban resuelve esa causa específica" |
| Mejora cosmética que no dura | Mejora duradera que ataca el sistema |
| El waste regresa en 4-8 semanas | El waste es eliminado estructuralmente |

---

## Técnica 1: 5 Whys

### Qué es y cuándo usarlo

El análisis 5 Whys es la técnica más directa de Lean para encontrar causas raíz. Se usa cuando:
- El waste está bien definido (del VSM As-Is)
- El equipo tiene conocimiento del proceso
- La causa raíz es probablemente singular o tiene pocas ramificaciones

**Cuándo NO usar 5 Whys:**
- Cuando el waste tiene múltiples causas posibles e interrelacionadas → usar Fishbone primero
- Si el equipo tiene opiniones muy divergentes sobre la causa → Fishbone primero para organizar las hipótesis

### Protocolo 5 Whys paso a paso

**Paso 1: Definir el waste con datos**
```
NO: "Hay esperas en el proceso"
SÍ: "El 68% del lead time (4.2 días de 6.1 días totales) son tiempos de espera entre el Paso 3 y Paso 4"
```

**Paso 2: Preguntar "¿Por qué?" con disciplina**
- Cada respuesta debe ser observable o verificable
- No aceptar "la gente no hace su trabajo" — las personas no son causas sistémicas
- Si hay dos respuestas posibles al mismo Why, explorar ambas (árbol de causas)

**Paso 3: Reconocer la causa raíz**

Una causa raíz tiene estas características:
1. Es sistémica — del diseño del proceso, no de un individuo
2. Está dentro del control del equipo para corregir
3. Su eliminación prevendría el waste (no solo lo mitigaría)
4. El equipo puede validarla con evidencia

**Paso 4: Verificar la cadena hacia arriba**

Leer la cadena de atrás hacia adelante:
```
"[Causa raíz] → [causa 4] → [causa 3] → [causa 2] → [causa 1] → [waste]"
```
Si la lógica fluye coherentemente, la cadena es válida.

### Errores comunes en 5 Whys Lean

| Error | Ejemplo | Corrección |
|-------|---------|-----------|
| Causa raíz demasiado amplia | "El proceso no está documentado" | ¿Qué aspecto específico del proceso no está documentado? |
| Causa raíz que es una persona | "El aprobador es lento" | "No hay señal visual de items pendientes" — la lentitud es síntoma, no causa |
| Detenerse en el síntoma | Why 1: "No hay comunicación" → Causa raíz declarada | ¿Por qué no hay comunicación? → Seguir hasta el diseño del proceso |
| Asumir la causa antes de preguntar | "Ya sabemos que es el sistema ERP" | Hacer el 5 Whys igualmente — la asunción puede estar equivocada |

---

## Técnica 2: Diagrama de Ishikawa (Fishbone / 6M)

### Qué es y cuándo usarlo

El Fishbone organiza las posibles causas en categorías (6M) antes de priorizar. Usar cuando:
- El waste puede tener múltiples causas interrelacionadas
- El equipo tiene perspectivas divergentes sobre la causa
- Se quiere asegurar que no se está pasando por alto una categoría completa de causas

### Las 6M adaptadas al contexto Lean

**Mano de obra (People)**
- ¿El equipo conoce el proceso estándar?
- ¿Hay carga de trabajo desbalanceada entre operadores?
- ¿La rotación de personal afecta el conocimiento del proceso?
- ¿El equipo fue entrenado en el proceso actual?

**Métodos (Process)**
- ¿El estándar documentado genera el waste?
- ¿Existe un estándar? ¿Se sigue?
- ¿El proceso tiene pasos innecesarios heredados de una versión anterior?
- ¿Las instrucciones son ambiguas o interpretables de múltiples maneras?

**Máquinas (Equipment/Systems)**
- ¿Los sistemas IT tienen alta tasa de falla o lentitud?
- ¿Los tiempos de setup son largos?
- ¿Hay mantenimiento preventivo ausente?
- ¿La herramienta no soporta el flujo que se necesita?

**Materiales (Inputs)**
- ¿Los inputs del proveedor upstream son de calidad inconsistente?
- ¿Las especificaciones de entrada son ambiguas?
- ¿Los datos de entrada están incompletos frecuentemente?

**Medición (Measurement)**
- ¿El proceso no tiene métricas de flujo visibles?
- ¿Las métricas actuales incentivan el waste? (ej: medir utilización en lugar de lead time)
- ¿El sistema de medición es inaccesible para el equipo operacional?

**Medio Ambiente (Environment)**
- ¿El layout físico o digital genera movimientos innecesarios?
- ¿El entorno es caótico sin organización 5S?
- ¿El ruido/interrupciones generan errores frecuentes?
- ¿El espacio de trabajo digital (herramientas, carpetas, wikis) está desorganizado?

### Cómo facilitar el Fishbone

1. Dibujar el esquema con el waste en la cabeza del pez
2. Dividir el equipo en grupos de 2-3 personas por categoría M
3. Cada grupo genera causas posibles para su categoría (5-10 min)
4. Presentar y organizar en el diagrama
5. Votar las causas más probables (3 votos por persona)
6. Las 2-3 causas con más votos son las candidatas para validar con 5 Whys

---

## Técnica 3: Análisis de datos históricos

Cuando el proceso tiene datos registrados (tickets, timestamps, registros de errores), el análisis de datos complementa los 5 Whys y Fishbone:

| Herramienta | Qué responde | Cuándo usar |
|-------------|-------------|-------------|
| **Pareto de wastes** | ¿Cuál es el waste más frecuente? | Cuando hay múltiples tipos de waste documentados |
| **Análisis de cycle time por paso** | ¿Dónde está el cuello de botella real? | Cuando el CT varía significativamente entre pasos |
| **Scatter plot: tiempo de espera vs día/hora** | ¿Cuándo ocurren las esperas más largas? | Para identificar causas relacionadas con picos de demanda |
| **Análisis de defectos por categoría** | ¿Qué tipo de error ocurre más? | Cuando el waste principal son defectos |

---

## Validación de causas raíz — métodos

| Método | Descripción | Cuándo usar |
|--------|-------------|-------------|
| **Observación directa** | Ir al proceso y observar si la causa ocurre realmente | Causa relacionada con comportamiento o proceso observable |
| **Análisis de registros** | Revisar timestamps, logs, tickets para confirmar patrón | Proceso con datos históricos |
| **Entrevista a operadores** | Preguntar a quienes operan el proceso si reconocen la causa | Causa relacionada con conocimiento o práctica del equipo |
| **Experimento controlado** | Eliminar temporalmente la causa y observar si el waste desaparece | Causa no directamente observable; alto riesgo de error de diagnóstico |
| **Verificación lógica** | Leer la cadena 5 Whys de atrás hacia adelante; ¿es coherente? | Siempre — es el mínimo de validación |

---

## Diferencia entre causa raíz Lean y causa raíz Six Sigma

| Aspecto | Causa raíz Lean | Causa raíz Six Sigma |
|---------|----------------|----------------------|
| Foco | Eliminar waste visible, diseño del proceso | Reducir variación estadística de defectos |
| Herramientas | 5 Whys, Fishbone, observación Gemba | Regresión, ANOVA, DOE, análisis de varianza |
| Validación | Evidencia directa, observación, lógica | Prueba estadística (p-value, R², intervalos de confianza) |
| Tipo de causa raíz | Diseño del proceso, ausencia de estándar, falta de señal | Parámetro de proceso fuera de control, variable oculta |

Si el análisis 5 Whys lleva a una causa que requiere validación estadística → considerar cambiar a ciclo DMAIC.
