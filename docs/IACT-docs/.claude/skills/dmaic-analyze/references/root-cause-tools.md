# Root Cause Tools — DMAIC:Analyze

Guías detalladas para herramientas de análisis de causa raíz: VSM, Ishikawa profundo, 5-Why con verificación causal, y Scatter plot.

---

## VSM — Value Stream Map en Analyze

El VSM en Analyze no solo mapea el flujo — identifica *dónde* aplicar el análisis estadístico para confirmar causas raíz.

### Símbolos esenciales del VSM

| Símbolo (descripción) | Representa | Dato a capturar |
|----------------------|-----------|----------------|
| **Caja de proceso** | Actividad que agrega o no agrega valor | Tiempo de ciclo (CT), % tiempo VA, operadores |
| **Triángulo de inventario** | WIP entre etapas | Cantidad de unidades en espera |
| **Flecha de empuje** (push) | El proceso anterior empuja sin esperar demanda | Genera sobreproducción |
| **Flecha de jalar** (pull) | El proceso siguiente pide cuando necesita | Reduce WIP |
| **Rayo** | Problema identificado (cuello de botella, defecto, espera) | Marcar para análisis |
| **Burbuja Kaizen** | Oportunidad de mejora | Candidato para Improve |

### Métricas VSM a calcular

| Métrica | Fórmula | Señal de problema |
|---------|---------|------------------|
| **Lead Time (LT)** | Suma de todos los tiempos (VA + NVA + espera) | LT >> Tiempo VA → mucho waste |
| **Process Time (PT)** | Suma de tiempos VA únicamente | — |
| **Flow Efficiency** | PT / LT × 100% | < 20% → waste significativo |
| **WIP total** | Suma de inventarios entre etapas | Alto WIP → cuello de botella |
| **Cycle Time (CT)** | Tiempo de una unidad a través de un paso | CT > Takt Time → cuello de botella |
| **Takt Time** | Tiempo disponible / Demanda del cliente | Referencia del ritmo requerido |

### Cómo usar el VSM para focalizar el análisis estadístico

1. Construir el VSM del estado actual (AS-IS)
2. Identificar los pasos con mayor tiempo NVA, WIP acumulado o mayor tasa de defectos
3. Para cada "rayo" o burbuja Kaizen → formular una hipótesis de causa raíz
4. Priorizar las 2-3 hipótesis con mayor impacto sobre el LT o el CTQ
5. Validar estadísticamente esas hipótesis con los datos de Measure

---

## Diagrama de Ishikawa — Fishbone profundo

### Estructura básica

```
                [Material]     [Método]     [Mano de obra]
                    │             │               │
                    └─────────────┴───────────────┘
                                  │
    ──────────────────────────────────────────────── → EFECTO (problema)
                                  │
                    ┌─────────────┬───────────────┐
                    │             │               │
               [Máquina]   [Medio ambiente]  [Medición]
```

### Categorías 6M con preguntas guía

| Categoría | Preguntas para identificar causas hipotéticas |
|-----------|---------------------------------------------|
| **Máquina / Equipo** | ¿Hay variación entre máquinas o equipos? ¿El mantenimiento está al día? ¿Hay calibración? ¿El equipo tiene especificaciones correctas para el proceso? |
| **Método / Proceso** | ¿El proceso está documentado? ¿Se sigue el procedimiento? ¿Hay variación entre operadores? ¿El proceso tiene pasos redundantes o innecesarios? |
| **Material** | ¿Hay variación entre lotes de material? ¿Diferentes proveedores producen diferente variabilidad? ¿Los materiales cumplen especificaciones de entrada? |
| **Mano de obra** | ¿Hay diferencias entre turnos, operadores o equipos? ¿El entrenamiento es consistente? ¿Hay fatiga o rotación de personal? |
| **Medio ambiente** | ¿Temperatura, humedad, ruido, vibración afectan? ¿El resultado cambia según la hora del día o el día de la semana? ¿Hay factores externos como estacionalidad? |
| **Medición** (6M) | ¿El sistema de medición introduce variación? (validado con MSA) ¿Los criterios de clasificación son ambiguos? ¿Hay variación entre evaluadores? |

### Técnicas para profundizar en cada rama

**Nivel 1 (primer por qué):** Identificar la causa directa inmediata del efecto
**Nivel 2 (segundo por qué):** ¿Por qué ocurre esa causa directa?
**Nivel 3 (tercer por qué):** Continuar hasta llegar a algo que se puede cambiar

**Ejemplo de rama profunda — Categoría Método:**
```
Problema: Pedidos entregados fuera de plazo
└── Método: Asignación de ruta manual
    └── ¿Por qué manual? No hay criterios documentados de asignación
        └── ¿Por qué no documentados? El proceso no fue estandarizado al crearse
            └── ¿Por qué no estandarizado? No existe proceso de onboarding para este rol ← CAUSA RAÍZ
```

### Señales de que el Ishikawa es superficial

| Señal | Problema | Corrección |
|-------|---------|------------|
| Todas las causas son del tipo "falta de X" | Las causas raíz no tienen suficiente profundidad | Aplicar 5-Why en cada causa de nivel 1 |
| Una sola categoría tiene causas | Análisis incompleto o sesgo del equipo | Forzar al equipo a generar ≥ 1 hipótesis por categoría |
| Las causas son soluciones en disfraz | *"Falta capacitación"* implica la solución antes de confirmar la causa | Reformular: *"Los operadores tienen conocimiento variable"* |
| Mismo nivel de profundidad en todo | Algunas ramas se detuvo demasiado pronto | Identificar cuáles causas son más prometedoras y profundizar más |

---

## 5-Why — con verificación de cadena causal

### Protocolo paso a paso

1. **Escribir el problema como síntoma observable** — sin asumir causa
2. **Preguntar "¿Por qué ocurre esto?"** — anotar la respuesta
3. **Verificar la relación causal** antes de avanzar: ¿si esta causa no existiera, el problema desaparecería?
4. **Repetir** con la respuesta anterior como nuevo "problema"
5. **Parar cuando** se llega a algo que se puede cambiar directamente y está dentro del scope

### Template de 5-Why con verificación

| # | Pregunta | Respuesta | Verificación |
|---|---------|-----------|-------------|
| 0 | **Síntoma:** [problema] | — | — |
| 1 | ¿Por qué ocurre [síntoma]? | [respuesta 1] | Si [respuesta 1] no existiera, ¿desaparecería el síntoma? [Sí/No/Parcialmente] |
| 2 | ¿Por qué ocurre [respuesta 1]? | [respuesta 2] | Si [respuesta 2] no existiera, ¿desaparecería [respuesta 1]? [Sí/No/Parcialmente] |
| 3 | ¿Por qué ocurre [respuesta 2]? | [respuesta 3] | Verificar... |
| 4 | ¿Por qué ocurre [respuesta 3]? | [respuesta 4] | Verificar... |
| 5 | ¿Por qué ocurre [respuesta 4]? | **[causa raíz]** | ¿Es esto algo que podemos cambiar? [Sí/No] |

### Señales de cadena causal inválida

| Señal | Ejemplo | Corrección |
|-------|---------|------------|
| La respuesta no causa el síntoma | *"¿Por qué llegan tarde los pedidos? → Porque hay mucho trabajo"* — "mucho trabajo" no causa retraso per se | Buscar el mecanismo específico |
| La cadena gira en círculo | *"Fallan los pedidos porque hay errores → hay errores porque los operadores se equivocan → se equivocan porque fallan los pedidos"* | Salir del ciclo buscando la causa externa que lo inicia |
| Salto de nivel (causa demasiado profunda sin evidencia) | *"¿Por qué falla? → Por la cultura organizacional"* — muy abstracto y no verificable | Solicitar evidencia de datos para ese nivel antes de aceptarlo |
| La "causa raíz" está fuera del scope | La causa requiere cambios que el equipo no puede hacer | Documentar, escalar y reformular el scope del proyecto |

---

## Scatter Plot — interpretación

El Scatter Plot visualiza la relación entre una variable de proceso (X) y el CTQ (Y).

### Patrones de interpretación

| Patrón visual | Interpretación | Acción en Analyze |
|---------------|---------------|-------------------|
| **Tendencia lineal positiva** | A mayor X, mayor Y — correlación positiva | Validar con regresión / Pearson |
| **Tendencia lineal negativa** | A mayor X, menor Y — correlación negativa | Validar con regresión / Pearson |
| **Nube dispersa (sin patrón)** | No hay relación lineal entre X e Y | X no explica la variación del CTQ — descartar hipótesis |
| **Patrón curvo** | Relación no lineal — puede haber óptimo | Considerar regresión polinómica o transformación |
| **Dos grupos separados** | Puede haber una variable confusora (turno, operador) | Estratificar el gráfico por el factor sospechoso |
| **Outliers** | Puntos muy separados del patrón | Investigar si son errores de datos o condiciones especiales |

### Cómo usar el Scatter Plot en DMAIC:Analyze

1. Eje X: la variable de proceso hipotética como causa (predictor)
2. Eje Y: el CTQ o la métrica del problema (respuesta)
3. Si hay subgrupos (turnos, operadores), usar colores diferentes por subgrupo
4. Agregar línea de regresión si hay tendencia visible
5. No concluir causalidad solo por correlación visual — siempre validar con test estadístico
