# dmaic-analyze — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: dmaic:analyze
author: [nombre]
status: Borrador
```

---

## VSM / Análisis de flujo (si aplica)

**¿Se aplicó Value Stream Map?** [ ] Sí · [ ] No (proceso no tiene flujo secuencial)

| Tipo de waste (MUDA) identificado | Ubicación en el flujo | Impacto estimado |
|----------------------------------|----------------------|-----------------|
| [Espera / Sobreproducción / Reproceso / Transporte / Inventario] | [Paso del proceso] | [alto/medio/bajo] |

**Dónde enfocar el análisis estadístico según el VSM:** [pasos o etapas del flujo donde se concentra el problema]

---

## Hipótesis de causas — Diagrama de Ishikawa

| Categoría (6M) | Causas hipotéticas identificadas |
|----------------|--------------------------------|
| **Máquina / Equipo** | [lista de hipótesis] |
| **Método / Proceso** | [lista de hipótesis] |
| **Material** | [lista de hipótesis] |
| **Mano de obra** | [lista de hipótesis] |
| **Medio ambiente** | [lista de hipótesis] |
| **Medición** | [lista de hipótesis] |

*Ver guía de Ishikawa profundo y técnicas de VSM: [root-cause-tools.md](./references/root-cause-tools.md)*

---

## Análisis de Pareto — pocas causas vitales

| # | Categoría / Causa | Frecuencia | % del total | % acumulado | Vital / Trivial |
|---|------------------|-----------|-------------|-------------|----------------|
| 1 | [causa más frecuente] | [n] | [%] | [%] | VITAL |
| 2 | [segunda causa] | [n] | [%] | [%] | VITAL |
| 3 | [tercera causa] | [n] | [%] | [%] | VITAL |
| 4 | [resto] | [n] | [%] | [%] | Trivial |

**Umbral del 80%:** Las causas hasta este punto explican el 80% del problema → enfocar análisis estadístico en ellas.

---

## 5 Whys — profundización en causas vitales

### Causa vital 1: [nombre]

| Por qué | Respuesta |
|---------|-----------|
| ¿Por qué ocurre [la causa vital]? | [respuesta 1] |
| ¿Por qué [respuesta 1]? | [respuesta 2] |
| ¿Por qué [respuesta 2]? | [respuesta 3] |
| ¿Por qué [respuesta 3]? | [respuesta 4] |
| ¿Por qué [respuesta 4]? | **[causa raíz hipotética]** |

**Señal de parada:** [causa raíz alcanzada / siguiente "por qué" escapa del scope]

### Causa vital 2: [nombre]
[Repetir estructura de 5 Whys]

*Ver guía de 5-Why con verificación de cadena causal: [root-cause-tools.md](./references/root-cause-tools.md)*

---

## Validación estadística de causas

| Causa hipotética | H0 (hipótesis nula) | H1 (hipótesis alternativa) | Herramienta | Resultado | ¿Confirmada? |
|-----------------|--------------------|-----------------------------|------------|-----------|-------------|
| [causa 1] | No hay diferencia entre grupos X e Y | Existe diferencia significativa | [ANOVA/t-test/chi²] | p-value = [x] | ✅ / ❌ |
| [causa 2] | β = 0 (sin relación entre X y CTQ) | β ≠ 0 (relación significativa) | Regresión | p-value = [x], R² = [y] | ✅ / ❌ |

*Ver templates H0/H1 por tipo de test y árbol de selección: [hypothesis-testing.md](./references/hypothesis-testing.md)*

---

## Verificación de causalidad

Para cada causa confirmada estadísticamente:

| Causa raíz confirmada | Precedencia temporal | Mecanismo causal | Dosis-respuesta | Confusores descartados |
|----------------------|---------------------|-----------------|----------------|----------------------|
| [causa 1] | [X ocurre antes que Y: sí/no/evidencia] | [explicación física/lógica] | [a mayor X, mayor Y: sí/no] | [qué factores alternativos se descartaron] |

---

## Causas raíz confirmadas — priorizadas

| # | Causa raíz | % variación explicada | Esfuerzo de solución | Prioridad |
|---|-----------|----------------------|---------------------|-----------|
| 1 | [causa más impactante] | [%] | [bajo/medio/alto] | 1 |
| 2 | [segunda causa] | [%] | [bajo/medio/alto] | 2 |
| 3 | [tercera causa] | [%] | [bajo/medio/alto] | 3 |

**Causa(s) a atacar en Improve:** [lista de causas priorizadas con mayor impacto / esfuerzo favorable]
