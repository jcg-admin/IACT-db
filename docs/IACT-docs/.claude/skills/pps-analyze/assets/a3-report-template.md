# A3 Report — PS8 Toyota TBP

> El A3 Report es el artefacto central del ciclo PS8. Su nombre viene del tamaño de papel A3 (420×297mm) — la disciplina de mantenerlo en una sola página obliga a la síntesis y claridad.
> Completar a lo largo del ciclo: Secciones 1-4 en pps:analyze, Sección 5 en pps:countermeasures, Sección 6 en pps:implement, Sección 7 en pps:evaluate.

---

## Encabezado

| Campo | Valor |
|-------|-------|
| **Título del problema** | [descripción concisa del problema — máximo 10 palabras] |
| **Área / Proceso** | [dónde ocurre el problema] |
| **Dueño del A3** | [responsable del proyecto de mejora] |
| **Sponsor** | [quién autoriza y apoya] |
| **Fecha inicio** | [YYYY-MM-DD] |
| **Fecha objetivo** | [YYYY-MM-DD — deadline del target] |
| **Estado actual** | [En análisis / En implementación / Cerrado] |

---

## Sección 1 — Background (Contexto)

> Completar en: pps:analyze (al iniciar)
> Propósito: ¿Por qué este problema merece un proyecto TBP?

**Contexto del problema:**

[¿Quién reportó el problema? ¿Cuándo? ¿En qué contexto apareció?]

**Importancia para el negocio:**

[¿Por qué importa resolverlo? Conexión con objetivos estratégicos, SLAs, o impacto al cliente]

**Intentos anteriores de solución (si aplica):**

[¿Se intentó resolver antes? ¿Qué se hizo y por qué no funcionó de forma sostenible?]

---

## Sección 2 — Current Condition (Condición Actual)

> Completar en: pps:analyze (con datos del Gemba de pps:clarify)
> Propósito: Mostrar con datos y visualizaciones el estado actual del problema

**Problem Statement:**

[De pps:clarify — síntoma observable con datos, sin causas ni soluciones]

**Datos clave del Gemba:**

| Métrica | Valor actual | Período | Fuente |
|---------|-------------|---------|--------|
| [métrica principal] | [valor] | [período] | [fuente] |
| [métrica secundaria] | [valor] | [período] | [fuente] |

**Visualización del problema:**

[Gráfica de tendencia, diagrama de proceso marcando dónde falla, o tabla que muestre la magnitud]

```
[Insertar gráfica de tendencia o diagrama de proceso aquí]
Período: [fechas]
Eje Y: [métrica]
Tendencia: ↑ / ↓ / estable
```

**Descomposición del problema (de pps:clarify):**

[Sub-problema priorizado y por qué]

---

## Sección 3 — Goal / Target (Objetivo)

> Completar en: pps:analyze (referenciar Target Sheet de pps:target)
> Propósito: ¿Cómo se ve el éxito?

**Target:**

> [Copiar el target SMART de pps:target]

| Métrica | Baseline | Target | Deadline |
|---------|---------|--------|----------|
| [métrica principal] | [valor] | [meta] | [fecha] |

**Métricas secundarias (no degradar):**

| Métrica | Umbral mínimo |
|---------|--------------|
| [métrica 2] | ≥ [valor] |

---

## Sección 4 — Root Cause Analysis (Análisis de Causa Raíz)

> Completar en: pps:analyze
> Propósito: Mostrar la cadena causal confirmada con datos

**Diagrama Fishbone — resumen:**

```
                    [Manpower]          [Methods]
                        |                   |
[Materials] ────────────┼───────────────────┼──── PROBLEMA: [síntoma]
                        |                   |
                    [Machines]         [Measurements]
                                   [Mother Nature]
```

[Describir las causas identificadas por categoría]

**5 Whys — cadena causal principal:**

| Nivel | Pregunta | Respuesta | Evidencia |
|-------|----------|-----------|-----------|
| Síntoma | ¿Qué pasa? | [Problem Statement] | [datos] |
| Why 1 | ¿Por qué [síntoma]? | [causa 1] | [evidencia] |
| Why 2 | ¿Por qué [causa 1]? | [causa 2] | [evidencia] |
| Why 3 | ¿Por qué [causa 2]? | [causa 3] | [evidencia] |
| Why 4 | ¿Por qué [causa 3]? | [causa 4] | [evidencia] |
| Why 5 | ¿Por qué [causa 4]? | **[Causa raíz]** | [evidencia] |

**Causa raíz confirmada:**

[Descripción clara de la causa raíz + dato/experimento que la confirma]

---

## Sección 5 — Countermeasures (Contramedidas)

> Completar en: pps:countermeasures
> Propósito: ¿Qué se va a hacer y por qué se eligió esto?

**Contramedidas seleccionadas:**

| # | Causa Raíz atendida | Contramedida | Tipo | Responsable | Deadline |
|---|---------------------|-------------|------|-------------|----------|
| 1 | [causa raíz] | [descripción específica] | Preventiva/Correctiva | [nombre] | [fecha] |
| 2 | [causa raíz] | [descripción específica] | Preventiva/Correctiva | [nombre] | [fecha] |

**Justificación de la selección:**

[¿Por qué estas contramedidas sobre las alternativas? Referencia a la evaluación de factibilidad/impacto]

**Cobertura de causas raíz:**

[Confirmar que todas las causas raíz identificadas tienen al menos una contramedida]

---

## Sección 6 — Effect Confirmation (Confirmación de Efecto)

> Completar en: pps:implement (preliminar) y pps:evaluate (final)
> Propósito: ¿Funcionaron las contramedidas?

**Datos post-implementación:**

| Métrica | Baseline | Target | Resultado real | ¿Target alcanzado? |
|---------|---------|--------|----------------|-------------------|
| [métrica principal] | [valor] | [meta] | [valor real] | ✅ / ❌ / Parcial |
| [métrica 2] | [umbral] | ≥[umbral] | [valor real] | ✅ / ❌ |

**Tendencia de la métrica principal:**

```
[Gráfica de tendencia: antes / durante implementación / después]
Período de medición: [fechas]
Período de confirmación sostenida: [semanas]
```

**Análisis de resultado:**

- [ ] Target alcanzado completamente → estandarizar y cerrar
- [ ] Mejora parcial ([%] del target) → documentar brecha y evaluar nuevo ciclo
- [ ] Sin mejora → regresar a pps:analyze con nueva información
- [ ] Regresión → investigar efecto secundario urgente

**Efectos secundarios observados:**

[¿Algo mejoró o empeoró que no estaba previsto?]

---

## Sección 7 — Follow-up / Standardization (Seguimiento y Estandarización)

> Completar en: pps:evaluate
> Propósito: ¿Cómo se sostiene la mejora y qué se aprende para el futuro?

**Contramedidas estandarizadas:**

| Contramedida | Cómo se estandarizó | Mecanismo de control | Responsable de sostenimiento |
|-------------|---------------------|---------------------|------------------------------|
| [CM-1] | [SOP actualizado / automatización / poka-yoke] | [alerta / revisión periódica] | [nombre] |
| [CM-2] | [SOP actualizado / automatización / poka-yoke] | [alerta / revisión periódica] | [nombre] |

**Indicador de sostenibilidad:**

| Métrica | Umbral de alerta | Frecuencia de revisión | Quién revisa |
|---------|-----------------|----------------------|--------------|
| [métrica principal] | [valor que dispara revisión] | [semanal/mensual] | [nombre] |

**Aprendizajes clave:**

1. [Aprendizaje 1 — qué funcionó y por qué]
2. [Aprendizaje 2 — qué no funcionó y qué se aprendió]
3. [Aprendizaje 3 — qué harías diferente en el próximo ciclo]

**Aplicabilidad a otros procesos (Yokoten):**

[¿Hay procesos similares donde estas contramedidas podrían aplicarse? ¿Quién debería conocer estos aprendizajes?]

**Brecha residual (si aplica):**

[Si el target no se alcanzó completamente, describir la brecha y si se iniciará un nuevo ciclo PS8]

**Próximos pasos:**

- [ ] Comunicar resultados al sponsor
- [ ] Compartir A3 con equipos que pueden beneficiarse
- [ ] Programar revisión de sostenibilidad en [fecha]
- [ ] Iniciar nuevo ciclo PS8 para [brecha residual] (si aplica)

---

## Historial de versiones

| Versión | Fecha | Qué se completó | Autor |
|---------|-------|-----------------|-------|
| v0.1 | [fecha] | Secciones 1-4 (pps:analyze) | [nombre] |
| v0.2 | [fecha] | Sección 5 (pps:countermeasures) | [nombre] |
| v0.3 | [fecha] | Sección 6 preliminar (pps:implement) | [nombre] |
| v1.0 | [fecha] | Secciones 6-7 finales, cerrado (pps:evaluate) | [nombre] |
