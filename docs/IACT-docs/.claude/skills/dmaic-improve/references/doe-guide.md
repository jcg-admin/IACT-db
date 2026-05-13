# DOE Guide — DMAIC:Improve

Guía de Design of Experiments: cuándo usar, factorial completo vs fraccionado, factores/niveles/corridas.

---

## Cuándo usar DOE en DMAIC:Improve

El DOE (Diseño de Experimentos) es la herramienta más poderosa de Improve para:
1. **Confirmar causas raíz** cuando la validación estadística de Analyze fue inconclusiva
2. **Optimizar parámetros** — encontrar la combinación óptima de múltiples factores
3. **Detectar interacciones** — si el efecto de A depende del nivel de B
4. **Cuantificar el efecto de cada factor** con una sola serie de experimentos eficiente

**DOE NO es necesario cuando:**
- Solo hay 1-2 factores con efecto confirmado en Analyze → experimentar secuencialmente
- Los factores no pueden ser controlados experimentalmente (DOE requiere control)
- El costo o tiempo de cada corrida es prohibitivo (considerar DOE fraccionado)

---

## Conceptos fundamentales

| Término | Definición | Ejemplo |
|---------|-----------|---------|
| **Factor** | Variable de proceso que se cree influye en el CTQ | Temperatura, velocidad, operador |
| **Nivel** | Valores que toma el factor en el experimento | Temperatura: [180°C, 200°C] → 2 niveles |
| **Corrida** | Una combinación específica de niveles de todos los factores | Temp=180°C + Velocidad=50rpm |
| **Réplica** | Repetir la misma corrida para estimar el error experimental | Correr la misma combinación 2-3 veces |
| **Respuesta** | El CTQ que se mide en cada corrida | DPMO, tiempo de ciclo, resistencia |
| **Efecto principal** | Cambio promedio en la respuesta al cambiar un factor | "Aumentar temperatura 20°C reduce DPMO en 1,500" |
| **Interacción** | El efecto de un factor depende del nivel de otro | "A alta temperatura, el efecto de la velocidad desaparece" |
| **Bloque** | Variable de control que se quiere separar del efecto de los factores | Diferentes días, diferentes operadores |

---

## Factorial completo 2ᵏ

### Descripción

Todas las combinaciones posibles de k factores con 2 niveles cada uno (bajo y alto).

| k factores | Corridas (sin réplicas) | Cuándo usar |
|------------|------------------------|-------------|
| 2 factores | 2² = 4 corridas | Siempre factible |
| 3 factores | 2³ = 8 corridas | Factible |
| 4 factores | 2⁴ = 16 corridas | Factible si costo por corrida es bajo |
| 5 factores | 2⁵ = 32 corridas | Considerar fraccionado |
| 6+ factores | 2⁶ = 64+ corridas | Usar fraccionado — el factorial completo no es práctico |

### Fórmula de corridas totales con réplicas

```
Corridas totales = 2ᵏ × réplicas

Ejemplo: 3 factores, 2 réplicas = 2³ × 2 = 16 corridas
```

### Tabla de diseño — ejemplo 2² (2 factores)

| Corrida | Factor A | Factor B | Respuesta Y |
|---------|---------|---------|-------------|
| 1 | − (bajo) | − (bajo) | [medir CTQ] |
| 2 | + (alto) | − (bajo) | [medir CTQ] |
| 3 | − (bajo) | + (alto) | [medir CTQ] |
| 4 | + (alto) | + (alto) | [medir CTQ] |

### Cálculo de efectos principales

```
Efecto A = [(Y₂ + Y₄)/2] − [(Y₁ + Y₃)/2]
         = promedio de corridas con A=+ menos promedio con A=−

Efecto B = [(Y₃ + Y₄)/2] − [(Y₁ + Y₂)/2]

Efecto interacción AB = [(Y₁ + Y₄)/2] − [(Y₂ + Y₃)/2]
```

---

## Factorial fraccionado 2ᵏ⁻ᵖ

### Cuándo usar

Cuando hay 5+ factores y el factorial completo requiere demasiadas corridas. Se sacrifica la capacidad de estimar algunas interacciones de orden alto (que rara vez son significativas) para reducir el número de corridas.

### Resolución del diseño — qué se puede estimar

| Resolución | Notación | Qué se puede estimar | Qué se sacrifica |
|------------|---------|---------------------|-----------------|
| **III** | 2ᵏ⁻ᵖ III | Efectos principales (confundidos con interacciones de 2 factores) | Interacciones de 2 factores no estimables limpiamente |
| **IV** | 2ᵏ⁻ᵖ IV | Efectos principales + interacciones de 2 factores (pero interacciones de 2 factores confundidas entre sí) | Solo interacciones de 3+ factores no estimables |
| **V** | 2ᵏ⁻ᵖ V | Efectos principales + todas las interacciones de 2 factores (limpias) | Solo interacciones de 3+ factores no estimables |

**Regla práctica:** 
- Si solo interesa confirmar efectos principales → Resolución III
- Si se sospecha interacciones entre pares de factores → Resolución IV o V

### Tabla de diseños fraccionados comunes

| Factores | Resolución | Corridas | Fracciones |
|----------|-----------|---------|-----------|
| 4 | IV | 8 | 2⁴⁻¹ = 1/2 del factorial completo |
| 5 | III | 8 | 2⁵⁻² = 1/4 del factorial completo |
| 5 | V | 16 | 2⁵⁻¹ = 1/2 del factorial completo |
| 6 | III | 8 | 2⁶⁻³ = 1/8 del factorial completo |
| 6 | IV | 16 | 2⁶⁻² = 1/4 del factorial completo |
| 7 | IV | 16 | 2⁷⁻³ = 1/8 del factorial completo |

---

## Proceso de planificación del DOE

### Paso 1: Definir factores y niveles

| Factor | Nivel bajo (−1) | Nivel alto (+1) | Unidades | ¿Puede controlarse? |
|--------|----------------|----------------|---------|---------------------|
| [Factor A] | [valor bajo] | [valor alto] | [unidad] | ✅ / ❌ |
| [Factor B] | [valor bajo] | [valor alto] | [unidad] | ✅ / ❌ |

**Regla:** Solo incluir factores que se pueden controlar con precisión en el experimento. Factores que no se pueden fijar a un nivel específico deben convertirse en bloques o covariables.

### Paso 2: Definir la respuesta

| Elemento | Decisión |
|----------|----------|
| CTQ principal a minimizar/maximizar | [CTQ del proyecto] |
| Unidad de medida | [unidad] |
| Cómo se mide en cada corrida | [método / instrumento] |
| Número de réplicas por corrida | [2-3 recomendado para estimar el error] |

### Paso 3: Seleccionar el diseño

```
¿Cuántos factores?
├── 2-3 → Factorial completo 2² o 2³ (4-8 corridas)
├── 4 → Factorial completo 2⁴ (16 corridas) o fraccionado Resolución IV (8 corridas)
├── 5 → Fraccionado 2⁵⁻¹ Resolución V (16 corridas) o 2⁵⁻² Resolución III (8 corridas)
└── 6+ → Fraccionado Resolución IV o Plackett-Burman para screening
```

### Paso 4: Aleatorizar el orden de las corridas

El orden de las corridas debe ser aleatorio (random) para evitar confundir efectos temporales con efectos de factores.

### Paso 5: Analizar los resultados

1. Calcular efectos principales e interacciones
2. Gráfica de efectos principales (main effects plot)
3. Gráfica de interacciones (interaction plot) — si hay interacciones significativas
4. Normal probability plot de los efectos — los efectos que caen fuera de la línea son significativos
5. Confirmar con ANOVA si los efectos son estadísticamente significativos

---

## DOE en el contexto de DMAIC:Improve

| Fase DMAIC | Uso de DOE |
|------------|-----------|
| **Analyze** | DOE exploratorio (screening) para identificar qué factores son significativos de muchos candidatos |
| **Improve** | DOE de optimización para encontrar la combinación óptima de los factores confirmados en Analyze |
| **Control** | No — en Control se monitorea el punto óptimo encontrado, no se experimenta |

**Cuándo DOE > experimento secuencial:**
- Hay 3+ factores que se sospechan interactúan entre sí
- El costo de experimentos secuenciales (uno por factor) excede el costo del DOE
- Se necesita cuantificar el efecto de cada factor con precisión estadística
