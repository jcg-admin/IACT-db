# MSA — Measurement System Analysis

Guía para validar el sistema de medición antes de confiar en los datos del proceso: Gauge R&R para datos continuos y Kappa de Cohen para datos de atributo.

---

## Por qué el MSA es obligatorio

Un sistema de medición deficiente convierte buenos datos en ruido. Si el instrumento varía más que el proceso, el análisis de Analyze producirá causas falsas.

```
Variación total observada = Variación real del proceso + Variación del sistema de medición

Si la variación del sistema de medición > 30% → los datos no distinguen entre proceso bueno y malo
```

---

## Gauge R&R — para datos continuos

### Componentes

| Componente | Descripción | Causa típica |
|------------|-------------|-------------|
| **Repetibilidad** | ¿El mismo operador midiendo la misma pieza obtiene el mismo resultado? | Variación del instrumento |
| **Reproducibilidad** | ¿Diferentes operadores midiendo la misma pieza obtienen el mismo resultado? | Variación entre personas (entrenamiento, interpretación) |
| **%GR&R total** | Repetibilidad + Reproducibilidad expresado como % de la tolerancia del proceso | |

### Tabla de decisión %GR&R

| %GR&R | Evaluación | Acción |
|-------|-----------|--------|
| **< 10%** | ✅ Sistema aceptable | Proceder con la recolección de datos |
| **10% – 30%** | ⚠️ Aceptable condicionalmente | Documentar la limitación; monitorear si los análisis de Analyze son sensibles a este rango |
| **≥ 30%** | ❌ Sistema no confiable | Corregir el sistema de medición antes de continuar — recalibrar, reentrenar, o cambiar el instrumento |

### Thresholds adicionales

| Criterio | Umbral | Significado |
|----------|--------|-------------|
| **% Contribution del GR&R** | < 9% de la varianza total | Sistema aceptable |
| **Number of Distinct Categories (ndc)** | ≥ 5 | El instrumento puede distinguir al menos 5 categorías de valores distintos |
| **P/T ratio** (Precision-to-Tolerance) | < 10% | La variación del sistema de medición es < 10% de la tolerancia del spec |

### Cómo ejecutar un Gauge R&R básico

**Diseño mínimo:**
- 2-3 operadores
- 10 piezas/muestras representativas del rango del proceso
- 2-3 réplicas por operador por pieza
- Las piezas se miden en orden aleatorio (el operador no sabe qué midió antes)

**Cálculo simplificado con Average and Range:**
1. Para cada celda operador × pieza: registrar todas las réplicas
2. Calcular rango dentro de réplicas para cada celda → promedio de rangos (R̄)
3. Calcular promedio por operador → rango entre operadores (X̄_diff)
4. Repeatability = R̄ / d2 × 5.15 (para 99% de la distribución)
5. Reproducibility = sqrt(max(0, (X̄_diff/d2)² − Repeatability²/n_piezas))
6. %GR&R = GRR / Tolerancia × 100

*Para análisis completo: usar Minitab (Gage R&R Study), R (SixSigma package), o Python (statsmodels).*

---

## Kappa de Cohen — para datos de atributo

Mide el grado de acuerdo entre evaluadores cuando los datos son categóricos (bueno/malo, categoría A/B/C, pasa/no pasa).

### Tabla de interpretación

| Kappa | Interpretación | Acción |
|-------|---------------|--------|
| **> 0.9** | Concordancia excelente | MSA aprobado — los evaluadores clasifican igual |
| **0.7 – 0.9** | Concordancia aceptable | Documentar; monitorear en producción |
| **0.5 – 0.7** | Concordancia moderada | Revisar criterios de clasificación; considerar reentrenamiento |
| **< 0.5** | Concordancia baja a pobre | ❌ Sistema de medición no confiable — redefinir criterios de clasificación antes de continuar |

### Cómo ejecutar el Kappa de Cohen

**Diseño mínimo:**
- 2+ evaluadores
- 20-50 muestras que incluyan una mezcla representativa de categorías (no todas "bueno")
- Cada evaluador clasifica cada muestra de forma independiente
- No revelar la respuesta "correcta" durante el ejercicio

**Cálculo:**
```
Kappa = (P_observed - P_expected) / (1 - P_expected)

P_observed = % de acuerdo observado = (acuerdos totales) / (total de comparaciones)
P_expected = % de acuerdo esperado por azar = Σ(P_eval1_categoría × P_eval2_categoría)
```

**Ejemplo numérico:**
- 50 muestras, 2 evaluadores, categorías: Bueno / Defecto
- Acuerdo: ambos dicen "Bueno" en 35 casos, ambos dicen "Defecto" en 10 casos = 45 acuerdos
- P_observed = 45/50 = 0.90
- P_expected (por azar) = (40/50 × 42/50) + (10/50 × 8/50) = 0.672 + 0.032 = 0.704
- Kappa = (0.90 - 0.704) / (1 - 0.704) = 0.196 / 0.296 = **0.66 → Concordancia moderada**

### Causas típicas de Kappa < 0.7

| Causa | Diagnóstico | Corrección |
|-------|-------------|-----------|
| Criterios de clasificación ambiguos | Los evaluadores interpretan diferente el límite entre categorías | Redefinir criterios con ejemplos visuales (fotos, samples) |
| Falta de entrenamiento | Evaluadores nuevos o sin calibración reciente | Sesión de calibración con casos de entrenamiento conocidos |
| Zona gris | Muchas muestras en el límite del criterio | Crear categoría "borderline" o redefine el criterio |
| Muestras no representativas | El set de muestras no tiene variedad suficiente | Incluir casos fáciles, difíciles y borderline |

---

## MSA para sistemas automatizados

Cuando el sistema de medición es un sensor, software o algoritmo:

| Aspecto a validar | Cómo verificar |
|------------------|----------------|
| **Exactitud** | Comparar con un estándar de referencia (gold standard) |
| **Precisión** | Medir la misma muestra múltiples veces en el mismo estado |
| **Sesgo** | ¿El sistema sobreestima o subestima sistemáticamente? |
| **Linealidad** | ¿La exactitud varía en diferentes rangos del proceso? |
| **Estabilidad** | ¿El sistema mide igual hoy vs hace 3 meses? |

*Para sistemas de clasificación automatizada (ML/IA): usar matriz de confusión + F1-score como proxy del Kappa.*

---

## Guía de decisión MSA → continuar

| Situación | Decisión |
|-----------|----------|
| Gauge R&R < 10% | ✅ Continuar con recolección de datos |
| Gauge R&R 10-30% | ⚠️ Continuar pero documentar; si los análisis de Analyze son sensibles a esta incertidumbre, mejorar el MSA |
| Gauge R&R ≥ 30% | ❌ Corregir MSA antes de continuar — los datos actuales no son confiables |
| Kappa > 0.9 | ✅ Continuar con recolección de datos |
| Kappa 0.7-0.9 | ⚠️ Continuar; revisar criterios para reducir zona gris |
| Kappa < 0.7 | ❌ Redefinir criterios de clasificación y re-ejecutar el MSA |
| Sin MSA (datos históricos) | ⚠️ Documentar la fuente y sus limitaciones conocidas; aceptar mayor incertidumbre en Analyze |
