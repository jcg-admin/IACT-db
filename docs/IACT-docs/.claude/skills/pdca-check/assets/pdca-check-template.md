# pdca-check — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: pdca:check
author: [nombre]
status: Borrador
```

---

## Comparativa objetivo vs resultado

| Métrica | Baseline (Plan) | Objetivo SMART | Resultado Do | Delta vs baseline | ¿Objetivo alcanzado? |
|---------|-----------------|----------------|--------------|------------------|---------------------|
| [Métrica principal] | [valor] | [meta] | [valor real] | [+/-X%] | ✅ / ❌ |
| [Métrica control 1] | [valor] | sin regresión | [valor real] | [+/-X%] | ✅ / ❌ |
| [Métrica control 2] | [valor] | sin regresión | [valor real] | [+/-X%] | ✅ / ❌ |

---

## Validación de suficiencia de datos

| Criterio | Valor del piloto | ¿Suficiente? |
|----------|-----------------|-------------|
| N° observaciones post-cambio | [n] | ✅ / ❌ (mín. recomendado: [X]) |
| Duración del piloto | [X días/semanas] | ✅ / ❌ (mín. para ciclo completo: [Y]) |

**Conclusión de suficiencia:** [Los datos son suficientes para concluir / Se recomienda extender el piloto porque ...]

*Ver guía de tamaños de muestra y tipos de proceso: [measurement-tools.md](./references/measurement-tools.md)*

---

## Evaluación de significancia

**Método utilizado:** [Run Chart / Rango histórico / T-test / Juicio experto]

[Descripción del análisis:]
- Run Chart: [¿hay ≥ 8 puntos consecutivos por encima/debajo de la mediana pre-cambio?]
- O: [rango del proceso antes del cambio: min-max; ¿el resultado cae fuera de ese rango?]
- O: [t-test: n_antes=[X], n_después=[X], p-value=[X] → ¿< 0.05?]

**Conclusión:** [La diferencia supera la variabilidad natural del proceso / La diferencia está dentro del ruido normal]

*Ver guías de Run Chart y selección de test estadístico: [measurement-tools.md](./references/measurement-tools.md)*

---

## Análisis de causas del resultado

**¿La hipótesis fue confirmada?** [Sí / No / Parcialmente]

[Explicación:
- Si sí: qué mecanismo causal actuó como se esperaba
- Si no: qué falló — hipótesis incorrecta / implementación deficiente / condiciones externas
- Si parcial: qué parte de la hipótesis fue correcta y qué parte no]

---

## Factores no anticipados

[Qué salió diferente a lo esperado durante el piloto — eventos externos, condiciones cambiantes, comportamientos inesperados del sistema]

*Si no hubo factores no anticipados: "Ninguno — las condiciones del piloto fueron estables."*

---

## Conclusión del piloto

**Veredicto:** [✅ Hipótesis confirmada / ❌ Hipótesis refutada / ⚠️ Resultado mixto]

[Afirmación directa con datos:]
*Ejemplo: "La hipótesis fue confirmada. El índice redujo p95 de 2.1s a 0.6s (71% de mejora), superando el objetivo de 800ms."*

---

## Recomendación para Act

- [ ] **Estandarizar** — objetivo alcanzado sin regresiones
- [ ] **Nuevo ciclo con ajuste** — mejoró pero no alcanzó la meta: [qué ajustar]
- [ ] **Nuevo ciclo con hipótesis diferente** — hipótesis refutada: [nueva hipótesis]
- [ ] **Revertir cambio** — regresión o daño colateral: [qué revertir]
