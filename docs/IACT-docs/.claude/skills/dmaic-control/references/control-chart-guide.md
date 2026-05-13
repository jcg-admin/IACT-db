# Control Chart Guide — DMAIC:Control

Guía completa de gráficas de control SPC: selección por tipo de dato, 8 Reglas Western Electric y Plan de Reacción por señal.

---

## Selección del tipo de gráfica SPC

| Tipo de dato | Tamaño de subgrupo | Gráfica recomendada | Qué monitorea |
|-------------|-------------------|-------------------|--------------|
| **Continuo** | n = 1 (medición individual) | **I-MR** (Individuales y Rango Móvil) | Media y variabilidad de observaciones individuales |
| **Continuo** | n = 2–9 (subgrupos pequeños) | **X-bar / R** | Media del subgrupo y rango dentro del subgrupo |
| **Continuo** | n ≥ 10 (subgrupos grandes) | **X-bar / S** | Media del subgrupo y desviación estándar del subgrupo |
| **Atributo — proporción defectuosa** | n variable entre subgrupos | **p-chart** | Proporción de unidades defectuosas por subgrupo |
| **Atributo — proporción defectuosa** | n constante entre subgrupos | **np-chart** | Número de unidades defectuosas por subgrupo |
| **Conteo — defectos por unidad** | n variable | **u-chart** | Defectos por unidad cuando n varía |
| **Conteo — defectos por unidad** | n constante | **c-chart** | Número total de defectos cuando n es fijo |

### Árbol de selección rápida

```
¿Qué tipo de dato tienes?
├── Continuo (tiempo, peso, temperatura, latencia)
│   └── ¿Cuántas mediciones por subgrupo?
│       ├── 1 sola medición por período → I-MR
│       ├── 2-9 mediciones por período → X-bar / R
│       └── ≥ 10 mediciones por período → X-bar / S
└── Atributo (defecto sí/no, pasa/no pasa)
    └── ¿Qué se cuenta?
        ├── Unidades defectuosas
        │   ├── n variable entre subgrupos → p-chart
        │   └── n fijo → np-chart
        └── Defectos por unidad
            ├── n variable → u-chart
            └── n fijo → c-chart
```

---

## Cálculo de límites de control (UCL / LCL)

**Principio:** Los límites se calculan a ±3σ de la distribución de la estadística monitoreada. Representan la variación normal del proceso.

### I-MR (Individuales y Rango Móvil)

```
Gráfica de Individuales (I):
  UCL = X̄ + 3 × (MR̄ / d₂)     donde d₂ = 1.128 para n=2
  LCL = X̄ - 3 × (MR̄ / d₂)

Gráfica de Rango Móvil (MR):
  UCL_MR = D₄ × MR̄               donde D₄ = 3.267 para n=2
  LCL_MR = D₃ × MR̄               donde D₃ = 0 para n≤6
```

### X-bar / R

```
Gráfica de X-bar:
  UCL = X̄̄ + A₂ × R̄
  LCL = X̄̄ - A₂ × R̄

Gráfica de R:
  UCL = D₄ × R̄
  LCL = D₃ × R̄

Constantes por tamaño de subgrupo n:
  n=2: A₂=1.88, D₃=0, D₄=3.27
  n=3: A₂=1.02, D₃=0, D₄=2.57
  n=4: A₂=0.73, D₃=0, D₄=2.28
  n=5: A₂=0.58, D₃=0, D₄=2.11
```

### p-chart

```
p̄ = total defectuosas / total unidades inspeccionadas

UCL_i = p̄ + 3 × sqrt(p̄(1-p̄)/nᵢ)    ← límite varía con nᵢ si n es variable
LCL_i = p̄ - 3 × sqrt(p̄(1-p̄)/nᵢ)    ← si LCL < 0, usar LCL = 0
```

**Importante:** Los límites de control se calculan a partir de los datos del proceso *mejorado* (post-Improve), no del baseline de Measure.

---

## Las 8 Reglas Western Electric

Las señales de causa especial indican que algo *no normal* está afectando el proceso.

| Regla | Señal | Descripción | Señal visual |
|-------|-------|-------------|-------------|
| **1** | **Punto extremo** | 1 punto fuera de los límites de control (±3σ) | Punto más allá de UCL o LCL |
| **2** | **Dos de tres** | 2 de 3 puntos consecutivos más allá de ±2σ, en el mismo lado de la línea central | Zona de 2σ a 3σ — mayoría en el mismo lado |
| **3** | **Cuatro de cinco** | 4 de 5 puntos consecutivos más allá de ±1σ, en el mismo lado | Zona de 1σ a 3σ — mayoría en el mismo lado |
| **4** | **Corrida de 8** | 8 puntos consecutivos todos en el mismo lado de la línea central | Ningún punto cruza la línea central durante 8 períodos |
| **5** | **Tendencia de 6** | 6 puntos consecutivos en tendencia continua ascendente O descendente | Línea continua de subida o bajada |
| **6** | **Estratificación** | 15 puntos consecutivos dentro de ±1σ (demasiado dentro de la zona central) | Los puntos parecen pegados a la línea central |
| **7** | **Ciclo alternante** | 14 puntos consecutivos alternando arriba-abajo de manera exagerada | Patrón de zigzag extremo |
| **8** | **Mezcla** | 8 puntos consecutivos a ambos lados de la media, ninguno dentro de ±1σ | Los puntos evitan la zona central |

### Interpretación de cada regla

| Regla | Causa típica | Diagnóstico |
|-------|-------------|-------------|
| **1** | Evento de causa especial puntual | Investigar qué ocurrió en ese punto exacto |
| **2** | Cambio pequeño pero sostenido en la media | Posible cambio en insumos o configuración |
| **3** | Cambio moderado en la media o el proceso | Revisar si hubo ajuste reciente en el proceso |
| **4** | Cambio sistemático en la media del proceso | Cambio en método, operador, material, turno |
| **5** | Desgaste gradual o tendencia esperada | Mantenimiento preventivo, cambio de insumo que se agota |
| **6** | Dos distribuciones superpuestas (stratification) | Datos mezclados de dos fuentes (turnos, máquinas) |
| **7** | Sobreajuste del proceso (over-control) | Operadores ajustando demasiado frecuente y activamente |
| **8** | Mezcla de dos grupos con medias distintas | Combinar datos de dos procesos diferentes en la misma gráfica |

### Qué reglas usar en práctica

| Contexto | Reglas recomendadas |
|----------|-------------------|
| **Mínimo obligatorio** | Regla 1 + Regla 4 | 
| **Control estándar** | Reglas 1, 2, 3, 4 |
| **Alta criticidad** | Las 8 reglas |
| **Nota:** Usar todas las 8 reglas simultáneamente aumenta la tasa de falsas alarmas al ~5% por punto | Calibrar según criticidad del proceso |

---

## Plan de Reacción por señal

> El Plan de Reacción define *exactamente* qué hacer cuando aparece una señal. Sin él, las gráficas son decoración.

### Template de Plan de Reacción

| Señal (Regla) | ¿Quién actúa primero? | Acción inmediata (< 30 min) | Investigación (< 24h) | ¿Cuándo escalar? | Escalar a |
|--------------|---------------------|--------------------------|---------------------|-----------------|----------|
| **Regla 1: punto fuera de UCL** | Operador / Técnico de turno | 1. Verificar si es error de medición (re-medir si posible) 2. Si es real: documentar condiciones del proceso en ese momento | Analizar qué cambió en el proceso antes de ese punto — insumos, configuración, condiciones | Si no se identifica causa en < 24h | Supervisor / Ing. de proceso |
| **Regla 1: punto fuera de LCL** (para métricas donde menor = mejor) | Operador | 1. Verificar medición 2. Si es real: documentar — puede ser señal de mejora espontánea | Investigar si hay nueva práctica no documentada que mejoró el proceso | Si no se identifica causa | Supervisor |
| **Regla 4: 8 puntos mismo lado** | Supervisor | Revisar si hubo cambio en el proceso en los últimos 8 períodos (insumos, turno, configuración) | Comparar características del proceso durante la corrida vs períodos normales | Inmediatamente si no hay causa obvia | Ing. de proceso / Dueño del proceso |
| **Regla 5: tendencia de 6 puntos** | Supervisor | Revisar desgaste de equipo, agotamiento de materiales, cambios ambientales | Análisis de causa raíz de la tendencia | Si continúa tras acción correctiva | Ing. de proceso |
| **Reglas 2, 3: señales de zona** | Supervisor | Revisar cambios recientes en el proceso | Análisis de estratificación por turno/operador/máquina | Si se confirma cambio sistémico | Ing. de proceso |
| **Regla 6: estratificación** | Ingeniero de proceso | Revisar si se están mezclando datos de fuentes distintas en la misma gráfica | Separar la gráfica por la variable sospechosa (turno, máquina, etc.) | Si la estratificación confirma dos procesos | Rediseñar el plan de control |
| **Regla 7: ciclo alternante** | Ingeniero de proceso | Verificar si operadores están sobreajustando el proceso | Revisar procedimiento de ajuste; puede requerir entrenamiento | Siempre que se confirme sobreajuste | Dueño del proceso |

---

## Control Chart vs Run Chart — cuándo usar cada uno

| Aspecto | Run Chart | Control Chart (SPC) |
|---------|-----------|---------------------|
| **Propósito** | Detectar si hubo un cambio puntual (Check de PDCA) | Monitorear el proceso en producción continua |
| **Límites** | Mediana pre-cambio como referencia | UCL/LCL calculados estadísticamente a ±3σ |
| **Señales** | Regla de 8 corridas | 8 Reglas Western Electric |
| **Cuándo usar** | Evaluación después de un cambio (piloto) | Monitoreo ongoing del proceso mejorado |
| **Complejidad** | Baja | Media-alta (requiere datos base para calcular límites) |
| **Cuándo hacer la transición** | — | Después de validar la mejora en Improve → implementar en Control |

---

## Datos necesarios para calcular límites de control

| Tipo de gráfica | Datos mínimos para límites estables |
|----------------|-------------------------------------|
| I-MR | ≥ 20-25 observaciones individuales del proceso mejorado |
| X-bar/R | ≥ 20-25 subgrupos del proceso mejorado |
| p-chart | ≥ 20-25 subgrupos; cada subgrupo con n ≥ 30 para estabilidad |
| u-chart | ≥ 20-25 subgrupos con n representativo |

**Importante:** Calcular siempre los límites a partir del proceso *mejorado* (datos de Improve post-piloto), nunca del baseline de Measure.
