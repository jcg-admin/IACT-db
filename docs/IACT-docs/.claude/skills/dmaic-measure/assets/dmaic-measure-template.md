# dmaic-measure — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: dmaic:measure
author: [nombre]
status: Borrador
```

---

## Process Map / VSM

**Tipo de mapa utilizado:** [Process Map detallado / Value Stream Map / Swim Lane]

**Hallazgos clave del mapa:**

| Indicador | Valor | Observación |
|-----------|-------|-------------|
| Número de pasos del proceso | [n] | |
| Tiempo de ciclo total (LT) | [valor] | |
| Tiempo de valor agregado (VA) | [valor] | |
| Eficiencia del flujo (VA/LT) | [%] | |
| WIP promedio | [valor] | |
| Puntos de medición del CTQ identificados | [lista] | |

---

## Plan de medición

| ¿Qué medir? | ¿Cómo? | ¿Con qué frecuencia? | ¿Quién? | ¿Fuente / sistema? |
|-------------|--------|---------------------|---------|-------------------|
| [CTQ principal] | [instrumento/método] | [continuo/diario/semanal] | [nombre/rol] | [BD/sistema/manual] |
| [CTQ secundario 1] | | | | |
| [Variable de proceso a monitorear] | | | | |

---

## Tipo de dato

- **Tipo:** [Continuo / Discreto-Atributo / Conteo]
- **Justificación:** [Por qué este tipo de dato es el apropiado para el CTQ]
- **Métricas apropiadas:** [Media/desviación + Cp/Cpk para continuo | DPU/DPMO/Sigma para atributo]

---

## Resultados del MSA — Validación del sistema de medición

### Para datos continuos — Gauge R&R

| Componente | % Contribución | Evaluación |
|------------|---------------|-----------|
| Repetibilidad (variación del instrumento) | [%] | |
| Reproducibilidad (variación entre evaluadores) | [%] | |
| **%GR&R total** | **[%]** | [< 10% Aceptable / 10-30% Condicional / ≥ 30% Rechazado] |

*Ver tabla de decisión y criterios de Gauge R&R: [msa-gage-rr.md](./references/msa-gage-rr.md)*

### Para datos de atributo — Kappa de Cohen

| Evaluadores | Kappa | Interpretación |
|-------------|-------|---------------|
| [Eval A vs B] | [valor] | [> 0.9 Excelente / 0.7-0.9 Aceptable / < 0.7 Insuficiente] |

**Decisión MSA:** [ ] Aceptado — datos confiables · [ ] Condicional — documentado · [ ] Rechazado — corregir antes de continuar

---

## Datos recopilados

| Campo | Valor |
|-------|-------|
| Período de recolección | [inicio YYYY-MM-DD → fin YYYY-MM-DD] |
| Tamaño de muestra (n) | [n observaciones] |
| Estratificación aplicada | [por turno / máquina / operador / región / —] |
| Fuente de datos | [sistema / medición manual / combinada] |

### Resumen estadístico

| Estadístico | Valor |
|-------------|-------|
| Media (μ) | [valor] |
| Desviación estándar (σ) | [valor] |
| Mínimo | [valor] |
| Máximo | [valor] |
| Percentil 5 / 95 | [valor] / [valor] |

---

## Baseline del proceso

### Para datos de atributo

| Métrica | Valor | Cálculo |
|---------|-------|---------|
| DPU (Defectos por unidad) | [valor] | defectos totales / unidades totales |
| Oportunidades por unidad | [n] | |
| DPMO | [valor] | (DPU / oportunidades) × 1,000,000 |
| Sigma Level | [valor] | ver tabla DPMO→Sigma |
| Período de medición del baseline | [fechas] | |

*Ver tabla DPMO→Sigma Level y convención 1.5σ: [process-capability.md](./references/process-capability.md)*

### Para datos continuos

| Métrica | Valor | Interpretación |
|---------|-------|---------------|
| LSL (Lower Spec Limit) | [valor] | Definido por CTQ / cliente |
| USL (Upper Spec Limit) | [valor] | Definido por CTQ / cliente |
| Cp (capacidad potencial) | [valor] | [< 1.0 No capaz / 1.0-1.33 Marginal / > 1.33 Capaz] |
| Cpk (capacidad real, considera centrado) | [valor] | |
| % fuera de especificación | [%] | |

*Ver fórmulas completas Cp/Cpk/Pp/Ppk: [process-capability.md](./references/process-capability.md)*

---

## Análisis de capacidad del proceso

**¿El proceso está en control estadístico?** [ ] Sí — sin causas especiales · [ ] No — causas especiales identificadas: [descripción]

**Histograma:** [Describir forma de la distribución: normal / sesgada / bimodal / con outliers]

**Conclusión de capacidad:** [El proceso es capaz / no capaz / marginalmente capaz de cumplir las especificaciones del CTQ]
