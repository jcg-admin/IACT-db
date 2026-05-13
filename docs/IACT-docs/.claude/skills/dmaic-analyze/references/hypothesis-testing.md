# Hypothesis Testing — DMAIC:Analyze

Templates H0/H1, tabla de decisión de p-value y matriz de selección de test estadístico.

---

## Marco conceptual

### H0 y H1 — definición explícita antes de cada test

Todo test estadístico en DMAIC comienza con hipótesis explícitas:

| Elemento | Descripción | Ejemplo |
|----------|-------------|---------|
| **H0 (hipótesis nula)** | El statu quo — asume que no hay diferencia o relación | "El tiempo de ciclo no difiere entre el turno A y el turno B" |
| **H1 (hipótesis alternativa)** | Lo que queremos probar — existe diferencia o relación | "El tiempo de ciclo del turno A es diferente al del turno B" |
| **p-value** | Probabilidad de observar el resultado (o más extremo) si H0 fuera verdadera | p = 0.03 → hay 3% de probabilidad de ver este resultado por azar |
| **α (nivel de significancia)** | Umbral para decidir — convención Six Sigma: α = 0.05 | Si p < α → rechazar H0 |

### Regla de decisión

```
p < 0.05 → Rechazar H0 → La diferencia es estadísticamente significativa → causa candidata confirmada
p ≥ 0.05 → No rechazar H0 → Sin evidencia estadística suficiente → hipótesis no confirmada
```

**Importante:** "No rechazar H0" ≠ "H0 es verdadera". Solo significa que los datos no proveen suficiente evidencia para rechazarla con α = 0.05.

---

## Templates H0/H1 por tipo de situación

### Comparación de grupos (causa categórica)

| Situación | H0 | H1 | Test recomendado |
|-----------|----|----|-----------------|
| 2 grupos, CTQ continuo, n ≥ 30 | μ₁ = μ₂ (las medias son iguales) | μ₁ ≠ μ₂ (las medias son diferentes) | t-test de dos muestras independientes |
| 2 grupos, CTQ continuo, n < 30 o no normal | La distribución de los grupos es igual | Las distribuciones difieren | Mann-Whitney U |
| 3+ grupos, CTQ continuo | μ₁ = μ₂ = ... = μₖ | Al menos un grupo es diferente | ANOVA de un factor |
| 3+ grupos, CTQ continuo, no normal | Las medianas son iguales en todos los grupos | Al menos una mediana difiere | Kruskal-Wallis |
| 2 variables categóricas | Las variables son independientes (sin asociación) | Existe asociación entre las variables | Chi-cuadrado de independencia |

### Relación entre variable continua y CTQ

| Situación | H0 | H1 | Test recomendado |
|-----------|----|----|-----------------|
| 1 predictor continuo vs CTQ continuo | β = 0 (la pendiente es cero — sin relación lineal) | β ≠ 0 (existe relación lineal significativa) | Regresión lineal simple |
| 2+ predictores vs CTQ | β₁ = β₂ = ... = 0 | Al menos un β ≠ 0 | Regresión lineal múltiple |
| 2 variables continuas, validar correlación | ρ = 0 (sin correlación) | ρ ≠ 0 | Pearson o Spearman |

### Varianza y estabilidad

| Situación | H0 | H1 | Test recomendado |
|-----------|----|----|-----------------|
| Comparar varianzas de 2 grupos | σ₁² = σ₂² | σ₁² ≠ σ₂² | F-test de Levene |
| Varianza de 3+ grupos | σ₁² = σ₂² = ... | Al menos una varianza difiere | Test de Bartlett (normal) o Levene (no normal) |
| Antes vs después en el mismo proceso | El proceso no cambió (sin cambio en media) | El proceso cambió (cambio en media) | t-test de muestras pareadas |

---

## Tabla de decisión p-value

| p-value | Interpretación | Acción en DMAIC |
|---------|---------------|-----------------|
| **p < 0.01** | Evidencia estadística muy fuerte | Causa confirmada con alta confianza; proceder a Improve |
| **0.01 ≤ p < 0.05** | Evidencia estadística suficiente | Causa confirmada; documentar el p-value |
| **0.05 ≤ p < 0.10** | Evidencia marginal | Causa candidata — recopilar más datos o aceptar incertidumbre documentada |
| **p ≥ 0.10** | Sin evidencia estadística | H0 no rechazada — hipótesis no confirmada con los datos disponibles |

---

## Matriz de selección de test estadístico

```
¿Cuántas variables predictoras?
├── 1 predictor
│   ├── ¿Tipo de predictor?
│   │   ├── Categórico (grupos)
│   │   │   ├── ¿Cuántos grupos?
│   │   │   │   ├── 2 grupos
│   │   │   │   │   ├── CTQ continuo + normal + n ≥ 30 → t-test dos muestras
│   │   │   │   │   ├── CTQ continuo + no normal o n < 30 → Mann-Whitney U
│   │   │   │   │   └── CTQ categórico → Chi-cuadrado
│   │   │   │   └── 3+ grupos
│   │   │   │       ├── CTQ continuo + normal → ANOVA
│   │   │   │       ├── CTQ continuo + no normal → Kruskal-Wallis
│   │   │   │       └── CTQ categórico → Chi-cuadrado
│   │   └── Continuo
│   │       └── CTQ continuo → Regresión lineal simple / Correlación Pearson
└── 2+ predictores
    ├── Todos continuos → Regresión múltiple / DOE
    ├── Mixto → ANCOVA / Regresión con variables dummy
    └── DOE → Regresión con interacciones
```

---

## Requisitos y verificaciones antes de aplicar el test

### Para t-test y ANOVA

| Requisito | Cómo verificar | Alternativa si no cumple |
|-----------|---------------|------------------------|
| Normalidad | Test de Shapiro-Wilk (n < 50) o Anderson-Darling (n ≥ 50); p > 0.05 → normal | Mann-Whitney U (2 grupos) o Kruskal-Wallis (3+ grupos) |
| Varianzas iguales (homoscedasticity) | Test de Levene; p > 0.05 → varianzas iguales | t-test de Welch (no asume igualdad de varianzas) |
| Independencia de observaciones | Verificar que no hay muestras repetidas del mismo sujeto | t-test pareado si hay medidas antes/después del mismo sujeto |
| Tamaño de muestra | n ≥ 30 por grupo para t-test confiable | Con n < 30, considerar no-paramétrico o aumentar muestra |

### Para Chi-cuadrado

| Requisito | Criterio | Alternativa si no cumple |
|-----------|----------|------------------------|
| Frecuencias esperadas | Todas las celdas deben tener frecuencia esperada ≥ 5 | Test exacto de Fisher (tablas 2×2 con frecuencias bajas) |
| Independencia de observaciones | Cada unidad clasificada solo una vez | — |
| Tamaño de muestra | n ≥ 20 total | Recopilar más datos |

### Para Regresión

| Requisito | Cómo verificar |
|-----------|---------------|
| Linealidad | Gráfica de dispersión X vs Y; debe verse tendencia lineal |
| Residuos normales | Q-Q plot o test de Shapiro-Wilk sobre los residuos |
| Homocedasticidad | Gráfica de residuos vs valores ajustados — sin patrón de embudo |
| Independencia de residuos | Test de Durbin-Watson (especialmente si datos son temporales) |

---

## Interpretación del R² en regresión

| R² | Interpretación práctica |
|----|------------------------|
| < 0.3 | Poca variación del CTQ explicada por X — X probablemente no es la causa principal |
| 0.3 – 0.6 | X explica parte significativa — causa candidata importante; buscar factores adicionales |
| 0.6 – 0.8 | X explica gran parte de la variación — causa principal probable |
| > 0.8 | X explica casi toda la variación — causa principal con alta probabilidad |

**Advertencia:** Un R² alto no prueba causalidad. Verificar siempre el mecanismo causal.
