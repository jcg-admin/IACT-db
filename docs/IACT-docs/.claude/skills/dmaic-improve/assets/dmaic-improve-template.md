# dmaic-improve — Template de artefacto

```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: dmaic:improve
author: [nombre]
status: Borrador
```

---

## Alternativas de solución evaluadas

| Causa raíz confirmada | Solución A | Solución B | Solución C |
|----------------------|-----------|-----------|-----------|
| [Causa 1 de Analyze] | [opción 1a] | [opción 1b] | [opción 1c] |
| [Causa 2 de Analyze] | [opción 2a] | [opción 2b] | — |

**Técnica de generación usada:** [Brainstorming / Benchmarking / Herramientas Lean / Poka-yoke / combinado]

---

## Cuadrante Impacto × Esfuerzo

| Solución | Impacto en CTQ | Esfuerzo | Cuadrante | Decisión |
|---------|---------------|---------|-----------|---------|
| [Solución A] | [alto/medio/bajo] | [alto/medio/bajo] | [Victoria Rápida / Proyecto Mayor / Relleno / Evitar] | [hacer ahora / planificar / descartada] |
| [Solución B] | | | | |

---

## Herramientas Lean aplicadas

> Si las causas raíz están relacionadas con waste de flujo o proceso, evaluar Lean antes de soluciones tecnológicas.

| Herramienta | Tipo de waste que resuelve | ¿Aplica? | Intervención planificada |
|-------------|--------------------------|---------|------------------------|
| 5S | Desorden, búsquedas, errores por entorno caótico | [ ] Sí / [ ] No | [descripción o N/A] |
| Kanban | Sobreproducción, WIP excesivo | [ ] Sí / [ ] No | [descripción o N/A] |
| SMED | Tiempos de setup largos | [ ] Sí / [ ] No | [descripción o N/A] |
| Eliminación de MUDA | Actividades NVA | [ ] Sí / [ ] No | [descripción o N/A] |
| Jidoka | Defectos desapercibidos | [ ] Sí / [ ] No | [descripción o N/A] |
| Heijunka | Demanda variable / cuellos de botella | [ ] Sí / [ ] No | [descripción o N/A] |

*Ver catálogo completo con aplicación paso a paso: [lean-tools-guide.md](./references/lean-tools-guide.md)*

---

## Solución seleccionada

**Solución elegida:** [nombre / descripción]
**Justificación:** [Por qué esta solución vs las alternativas — impacto, esfuerzo, sostenibilidad, reversibilidad]
**Ataca la causa raíz:** ✅ / ❌ — [explicación]

---

## FMEA — pre-piloto

> Aplicar si la solución puede impactar procesos críticos o si RPN de algún modo de falla > 100.

| Paso del proceso | Modo de falla potencial | Efecto del fallo | Severidad (1-10) | Ocurrencia (1-10) | Detección (1-10) | RPN (S×O×D) | Acción preventiva |
|-----------------|------------------------|-----------------|-----------------|------------------|-----------------|-------------|------------------|
| [paso] | [qué podría fallar] | [impacto en cliente/proceso] | [S] | [O] | [D] | [S×O×D] | [acción si RPN >100] |

*Escala: > 200 = Crítico (acción obligatoria) · 100-200 = Importante · < 100 = Monitorear. Ver tablas completas: [fmea-guide.md](./references/fmea-guide.md)*

**Modos de falla críticos (RPN > 200):** [lista o "Ninguno"]
**Acciones preventivas implementadas antes del piloto:** [lista o "No aplica — RPN < 200 en todos los modos"]

---

## Criterio piloto vs implementación completa

| Criterio | Evaluación | Valor |
|----------|-----------|-------|
| Reversibilidad | [fácil/difícil de revertir] | |
| Riesgo máximo RPN | [valor máximo del FMEA] | [> 100 → piloto recomendado] |
| Costo de error | [alto/bajo] | |
| Nivel de confianza en la causa raíz | [alto/medio] | |

**Decisión:** [ ] Piloto (subconjunto del proceso) · [ ] Implementación completa

**Scope del piloto:** [qué subconjunto, por qué es representativo]

---

## Diseño del piloto

| Elemento | Decisión |
|----------|----------|
| Scope | [subconjunto del proceso] |
| Duración | [inicio → fin] |
| Variables a medir | [exactamente las mismas que en Measure] |
| Variables controladas | [qué NO cambia durante el piloto para aislar el efecto] |
| Rollback | Condición: [cuándo revertir] · Procedimiento: [cómo revertir] |

---

## Datos post-implementación

| Métrica | Baseline (Measure) | Post-Improve | Delta | % Mejora |
|---------|-------------------|--------------|-------|---------|
| CTQ principal (DPMO o métrica continua) | [valor] | [valor] | [+/-] | [%] |
| Sigma Level | [valor] | [valor] | [+/-] | |
| CTQ control 1 (sin regresión) | [valor] | [valor] | [+/-] | |

---

## Validación estadística

| Comparación | Herramienta usada | Resultado | Significativo? |
|-------------|-------------------|---------|---------------|
| Media CTQ: antes vs después | [t-test / Mann-Whitney] | p-value = [x] | ✅ p < 0.05 / ❌ p ≥ 0.05 |
| Varianza: antes vs después | [F-test / Levene] | p-value = [x] | ✅ / ❌ |

**Conclusión de la validación:** [La mejora es estadísticamente significativa / No significativa — requiere ajuste]

---

## Nuevo Sigma Level

| Fase | Sigma Level | DPMO |
|------|------------|------|
| Baseline (Measure) | [valor] | [valor] |
| Post-Improve (piloto) | [valor] | [valor] |
| Delta | [+X.X σ] | [reducción] |
