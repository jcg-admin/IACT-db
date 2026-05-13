# Measurement Tools — PDCA:Check

Guías para validar la significancia estadística de los resultados del piloto: Run Chart, tamaños de muestra y selección de test estadístico.

---

## Run Chart — regla de las corridas

El Run Chart es la herramienta principal de PDCA para verificar si un cambio produjo una mejora real versus variación aleatoria.

### Construcción

1. Graficar cada punto de medición en el eje X (tiempo) contra el valor de la métrica en el eje Y
2. Calcular la mediana del período **pre-cambio** (no el promedio — la mediana es más robusta)
3. Trazar la línea de mediana pre-cambio como referencia horizontal
4. Marcar visualmente el punto de intervención (cuándo se hizo el cambio en Do)

```
Valor
  │     · ·                             [Mediana pre-cambio: 2.1s]
  2.1 ─────────────────────────────────── ← mediana pre-cambio
  │  · ·   ·                ↑ intervención
  │                    · · · · · · · ·   ← 8 puntos consecutivos debajo = señal real
  0.6 ─────────────────────────────────── ← mediana post-cambio
  │
  └─────────────────────────────────── tiempo
```

### Regla de las 8 corridas (Run Rule)

| Señal | Criterio | Interpretación |
|-------|----------|----------------|
| **Corrida de 8** | ≥ 8 puntos consecutivos todos por encima O todos por debajo de la mediana pre-cambio | Mejora estadísticamente significativa |
| **Tendencia de 6** | ≥ 6 puntos consecutivos todos en dirección ascendente O descendente | Proceso en tendencia — aún no conclusivo |
| **Sin señal** | Los puntos alternan aleatoriamente alrededor de la mediana | La diferencia está dentro del ruido normal del proceso |

**Probabilidad de falso positivo con la regla de 8:** p = (1/2)^8 = 0.4% — muy baja.

### Cuándo NO usar Run Chart

- Cuando no hay datos temporales secuenciales (solo medidas puntuales)
- Cuando n < 10 puntos post-cambio (el patrón no es visible)
- Cuando el proceso tiene ciclos estacionales fuertes (la mediana pre-cambio no es estable)

---

## Tamaño de muestra mínimo para concluir

| Tipo de proceso | N mínimo post-cambio | Duración mínima | Razón |
|-----------------|---------------------|-----------------|-------|
| **Proceso continuo** (eventos frecuentes: minutos/horas) | ≥ 30 observaciones | ≥ 1 día representativo | CLT: con n ≥ 30, el promedio se comporta normalmente |
| **Proceso intermitente** (eventos diarios) | ≥ 20 observaciones | ≥ 4 semanas | Capturar variación semanal |
| **Proceso de baja frecuencia** (eventos semanales) | ≥ 8 observaciones | ≥ 8 semanas | Mínimo para regla de corridas |
| **Proceso mensual** | ≥ 3 ciclos completos | ≥ 3 meses | Representatividad estacional |

**Caso borde — piloto corto:** Si el piloto fue más corto que el mínimo, el Check puede emitir un veredicto "preliminar" con la advertencia: *"n insuficiente para conclusión definitiva; extender el piloto o aceptar incertidumbre."*

---

## Tabla de comparación antes/después

Cuando no hay datos temporales secuenciales, usar la comparación directa de distribuciones:

| Estadístico | Período pre-cambio | Período post-cambio | Cambio |
|-------------|-------------------|---------------------|--------|
| Media / Mediana | [valor] | [valor] | [+/-X%] |
| Percentil 95 | [valor] | [valor] | [+/-X%] |
| Desviación estándar | [valor] | [valor] | [factor] |
| Min / Max | [min – max] | [min – max] | — |
| N observaciones | [n] | [n] | — |

**Uso:** Comparar la distribución completa, no solo el promedio. Una mejora en media con aumento de varianza no es necesariamente éxito.

---

## Selección de test estadístico

| Test | Cuándo usar | Requisitos | Criterio de significancia |
|------|------------|-----------|--------------------------|
| **Run Chart (recomendado)** | Datos temporales secuenciales, cualquier n | Solo datos en orden cronológico | ≥ 8 puntos consecutivos en el mismo lado de la mediana |
| **T-test de dos muestras** | Comparar medias de dos grupos independientes | n ≥ 30 en ambos grupos; distribución aproximadamente normal (o n grande por CLT) | p-value < 0.05 |
| **Mann-Whitney U** | Comparar medianas, datos no normales | n ≥ 20 en ambos grupos; datos ordinales o continuos no normales | p-value < 0.05 |
| **Rango histórico** | Siempre disponible como primera verificación | Solo el rango [min, max] del período pre-cambio | El resultado post-cambio cae fuera del rango histórico |
| **Juicio experto** | Cambios cualitativos o datos insuficientes | Documentar el razonamiento explícitamente | N/A — justificación narrativa |

### Árbol de selección rápida

```
¿Tienes datos en orden cronológico?
├── Sí → Run Chart primero (siempre)
│         ¿n ≥ 30 en ambos grupos?
│         ├── Sí → puedes complementar con T-test
│         └── No → Run Chart es suficiente si cumple regla de 8
└── No → Tabla de comparación antes/después
          ¿Distribución normal o n grande?
          ├── Sí → T-test de dos muestras
          └── No → Mann-Whitney U o Rango histórico
```

---

## Control Chart vs Run Chart — cuándo usar cada uno

| Aspecto | Run Chart | Control Chart (SPC) |
|---------|-----------|---------------------|
| **Propósito** | Detectar si hubo un cambio | Monitorear proceso en tiempo real |
| **Complejidad** | Baja — solo mediana de referencia | Media-alta — requiere UCL/LCL calculados con datos históricos |
| **Cuándo usar en PDCA** | En Check, para evaluar el resultado del piloto | En Act, para monitoreo continuo post-estandarización |
| **Señales de cambio** | Regla de 8 corridas | 8 Reglas Western Electric (ver dmaic-control) |
| **Requisito de datos** | ≥ 10 puntos post-cambio | ≥ 25-30 puntos históricos para calcular límites |

**Regla práctica PDCA:** Usar Run Chart en Check. Si el ciclo es exitoso y se estandariza, considerar implementar un Control Chart para el monitoreo continuo en Act.
