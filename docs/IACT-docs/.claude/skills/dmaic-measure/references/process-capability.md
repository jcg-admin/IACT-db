# Process Capability — DMAIC:Measure

Fórmulas completas de capacidad de proceso, tabla DPMO→Sigma Level y convención 1.5σ.

---

## Capacidad de proceso — datos continuos

### Fórmulas fundamentales

| Índice | Fórmula | Qué mide |
|--------|---------|---------|
| **Cp** | (USL − LSL) / (6σ) | Capacidad potencial — ¿cabe el proceso en la especificación si estuviera centrado? |
| **Cpk** | min[(USL − μ)/3σ, (μ − LSL)/3σ] | Capacidad real — considera tanto variabilidad como descentramiento |
| **Pp** | (USL − LSL) / (6s) | Igual que Cp pero usando desviación muestral s (largo plazo) |
| **Ppk** | min[(USL − μ)/3s, (μ − LSL)/3s] | Igual que Cpk pero con desviación muestral s (largo plazo) |

**Notación:**
- μ = media del proceso
- σ = desviación estándar corto plazo (estimada desde rangos de subgrupos)
- s = desviación estándar largo plazo (calculada directamente de todos los datos)
- USL = Upper Specification Limit (límite de especificación superior)
- LSL = Lower Specification Limit (límite de especificación inferior)

### Diferencia Cp vs Cpk

```
Cp alto + Cpk bajo → proceso con poca variabilidad pero descentrado
Cp bajo → proceso con mucha variabilidad (no cabe en la especificación aunque estuviera centrado)
Cp = Cpk → proceso perfectamente centrado
```

### Diferencia Cp/Cpk vs Pp/Ppk

| Aspecto | Cp / Cpk (corto plazo) | Pp / Ppk (largo plazo) |
|---------|----------------------|----------------------|
| **Cuando usar** | Durante el proyecto, proceso en control estadístico | Evaluación histórica o proceso con variación de largo plazo |
| **Estimación de σ** | Desde rangos de subgrupos (solo variación within) | Desde todos los datos (incluye between-subgroup) |
| **Interpretación** | Capacidad intrínseca del proceso | Desempeño real observado |

### Tabla de interpretación Cpk

| Cpk | Sigma equivalent | % fuera de spec | Clasificación |
|-----|-----------------|-----------------|--------------|
| < 1.00 | < 3σ | > 0.27% | ❌ Proceso no capaz |
| 1.00 | 3σ | 0.27% | ⚠️ Proceso marginalmente capaz |
| 1.17 | 3.5σ | 0.046% | ⚠️ Mínimo aceptable en muchas industrias |
| 1.33 | 4σ | 0.0063% | ✅ Proceso capaz |
| 1.50 | 4.5σ | 0.00034% | ✅ Proceso bien capaz |
| 1.67 | 5σ | 0.0000057% | ✅✅ Proceso muy capaz |
| 2.00 | 6σ | ~ 0% (prácticamente) | ✅✅ World-class |

---

## Sigma Level — datos de atributo

### Fórmulas de DPMO y Sigma Level

```
DPU (Defectos por Unidad) = Defectos totales / Unidades totales

DPMO (Defectos por Millón de Oportunidades) = DPU / Oportunidades_por_unidad × 1,000,000

Sigma Level → usar tabla de conversión abajo
```

### Tabla DPMO → Sigma Level (convención Six Sigma estándar con shift 1.5σ)

| DPMO | Sigma Level | % Defectuoso | % Correcto |
|------|------------|-------------|-----------|
| 691,462 | 1.0σ | 69.1% | 30.9% |
| 308,538 | 2.0σ | 30.9% | 69.1% |
| 66,807 | 3.0σ | 6.7% | 93.3% |
| 22,750 | 3.5σ | 2.3% | 97.7% |
| 6,210 | 4.0σ | 0.62% | 99.38% |
| 1,350 | 4.5σ | 0.14% | 99.87% |
| 233 | 5.0σ | 0.023% | 99.977% |
| 32 | 5.5σ | 0.0032% | 99.997% |
| 3.4 | 6.0σ | 0.00034% | 99.9997% |

### La convención 1.5σ — por qué y cómo usarla

**Origen:** El Dr. Mikel Harry (Motorola, 1980s) observó que los procesos reales se desplazan ±1.5σ respecto al proceso controlado en el corto plazo, a lo largo del tiempo (por desgaste, cambios de turno, variación de materiales, etc.).

**Consecuencia:** El Sigma Level calculado desde DPMO ya incorpora este shift. Un proceso con DPMO = 3.4 se llama "6 Sigma" en el lenguaje Six Sigma, pero estadísticamente la distribución corto plazo tiene 4.5σ de separación entre la media y el spec más cercano.

**Cómo usarla correctamente:**

| Situación | Qué hacer |
|-----------|-----------|
| Calcular Sigma Level desde DPMO histórico | Usar la tabla directamente (ya incluye el shift) |
| Comparar Sigma Level con índices Cp/Cpk | Sigma Level (DMAIC) ≈ Cpk × 3 + 1.5 (corrección aproximada) |
| Comunicar a stakeholders | Siempre aclarar si se reporta el Sigma Level con o sin el shift 1.5σ |

**Trampa:** No mezclar el Sigma Level de Six Sigma con la estimación estadística directa de desviaciones estándar. Son convenciones distintas.

---

## Prerrequisitos para calcular Cp/Cpk

**1. El proceso debe estar en control estadístico:**
- Verificar con gráficas de control (X-bar R, I-MR)
- Si hay causas especiales activas, eliminarlas primero
- Cp/Cpk calculado con proceso fuera de control es un número sin sentido

**2. Los datos deben ser normales (aproximadamente):**
- Si la distribución es muy sesgada o bimodal, usar índices de capacidad no paramétricos
- Alternativa: transformar datos (Box-Cox) y calcular Cp/Cpk sobre los datos transformados

**3. Necesitar suficientes datos:**
- Mínimo recomendado: 30 observaciones para estimación confiable
- Preferible: 50-100 observaciones para Cpk estable

### Cálculo manual de Cpk — ejemplo

```
Datos: Tiempo de respuesta de API (segundos)
USL = 2.0s (especificación del cliente)
LSL = 0.0s (implícito — no puede ser negativo)
μ = 0.85s (media del proceso)
σ = 0.35s (desviación estándar corto plazo)

Cp = (USL - LSL) / (6σ) = (2.0 - 0) / (6 × 0.35) = 2.0 / 2.1 = 0.95
    → Cp < 1: el proceso no cabría en spec aunque estuviera centrado

Cpk = min[(USL - μ)/3σ, (μ - LSL)/3σ]
    = min[(2.0 - 0.85)/(3 × 0.35), (0.85 - 0)/(3 × 0.35)]
    = min[1.15/1.05, 0.85/1.05]
    = min[1.10, 0.81]
    = 0.81

Conclusión: Cpk = 0.81 < 1.0 → Proceso NO capaz
```
