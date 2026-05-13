# Evaluation Techniques — Técnicas de Evaluación de Soluciones

## Marco de evaluación BABOK

La Solution Evaluation responde a tres preguntas:
1. **¿Funcionó?** — La solución fue construida correctamente (QA/testing — no es responsabilidad del BA)
2. **¿Entregó valor?** — La solución resolvió el Business Need original (sí es responsabilidad del BA)
3. **¿Qué sigue?** — Basado en los resultados, qué hacer a continuación

---

## KPI Measurement Framework

### Clasificación de KPIs por tipo

| Tipo | Descripción | Ejemplos | Cuándo medir |
|------|-------------|---------|-------------|
| **Leading indicators** | Predicen el resultado futuro | Adopción, training completado | Semana 1-4 post-go-live |
| **Lagging indicators** | Miden el resultado ya ocurrido | ROI, reducción de costo | 3-6 meses post-go-live |
| **Process metrics** | Miden la eficiencia del proceso | Tiempo de ciclo, tasa de error | Continuo |
| **Outcome metrics** | Miden el impacto de negocio | Satisfacción, revenue | 30-90 días post-go-live |

### Período de medición recomendado

| Tipo de proyecto | Período mínimo para evaluación | Período óptimo |
|-----------------|:------------------------------:|:--------------:|
| Proyectos de proceso / eficiencia | 4 semanas de datos reales | 8-12 semanas |
| Proyectos de experiencia de usuario | 6 semanas (curva de aprendizaje) | 12 semanas |
| Proyectos de transformación de negocio | 12 semanas | 6 meses |
| Proyectos de reducción de costos | 8 semanas | 6 meses (ciclo contable) |

> **Por qué no evaluar antes:** Los usuarios necesitan tiempo para adaptarse. Una evaluación a los 3 días refleja la confusión del cambio, no el valor de la solución.

### Cálculo de % de mejora

```
% mejora = (Actual - Baseline) / |Baseline| × 100

Si mejora es reducción (tiempo, costo, error):
% mejora = (Baseline - Actual) / Baseline × 100

Ejemplo: Tiempo promedio 5.2 días → 1.8 días
% mejora = (5.2 - 1.8) / 5.2 × 100 = 65.4% de mejora
```

### Umbrales de evaluación

| Estado | Criterio | Acción |
|--------|---------|--------|
| ✅ Logrado | ≥ 90% del target | Documentar como éxito; continuar |
| ⚠️ Parcial | 60-89% del target | Identificar causa de brecha; plan de mejora |
| ❌ No logrado | < 60% del target | Análisis de causa raíz; acción correctiva |

---

## NPS y métricas de satisfacción

### Net Promoter Score (NPS)

**Pregunta:** "¿Qué tan probable es que recomiende esta solución a un colega? (0-10)"

**Clasificación:**
- **Promotores (9-10):** Usuarios muy satisfechos; embajadores del cambio
- **Pasivos (7-8):** Satisfechos pero sin entusiasmo; vulnerables a insatisfacción
- **Detractores (0-6):** Insatisfechos; pueden resistir el cambio y crear rumores negativos

**Cálculo:** NPS = % Promotores - % Detractores

| NPS | Interpretación |
|-----|---------------|
| > 50 | Excelente — alta satisfacción |
| 30-50 | Bueno — satisfacción aceptable |
| 0-29 | Regular — hay trabajo por hacer |
| < 0 | Problemático — más detractores que promotores |

**Cuándo usar NPS:** Proyectos con usuarios finales claros; cuando hay suficiente masa (> 50 usuarios) para que el % sea estadísticamente significativo.

### CSAT (Customer Satisfaction Score)

**Pregunta:** "¿Qué tan satisfecho está con [la solución / feature específica]? (1-5)"

**Cálculo:** CSAT = # respuestas 4-5 / Total respuestas × 100

**Benchmark:** > 80% es bueno; < 60% requiere atención.

**Cuándo usar CSAT:** Evaluación puntual de una interacción o feature específica; más granular que NPS.

### CES (Customer Effort Score)

**Pregunta:** "¿Qué tan fácil fue [hacer X con la solución]? (1-7, donde 1=muy difícil, 7=muy fácil)"

**Cuándo usar CES:** Proyectos donde la facilidad de uso es el KPI crítico; especialmente cuando la adopción es baja y se sospecha que la UX es el problema.

---

## Análisis de adopción

### Métricas de adopción por tipo de solución

| Tipo de solución | Métrica principal | Umbral de adopción saludable |
|-----------------|-----------------|:----------------------------:|
| Sistema de gestión interna | Usuarios activos / semana | > 80% de los habilitados |
| Herramienta de colaboración | Sesiones / usuario / semana | > 3 sesiones/usuario/semana |
| Proceso rediseñado | % transacciones por el nuevo proceso | > 90% en semana 8 |
| Dashboard / reportes | Consultas / semana | > 2 consultas/usuario/semana |

### Workarounds — señales de adopción problemática

Los workarounds son la señal más clara de que la solución no está cumpliendo su propósito:

| Tipo de workaround | Señal | Causa probable |
|-------------------|-------|---------------|
| Usuario usa Excel en paralelo | Sistema no ofrece la funcionalidad que necesita | Gap funcional no identificado |
| Usuario imprime y escribe a mano | UX compleja o sistema lento | Problema de usabilidad o performance |
| Usuario llama por teléfono en vez de usar el sistema | No confía en el sistema o no sabe usarlo | Falta de training o confianza |
| Usuario usa sistema antiguo para casos "especiales" | Sistema nuevo no maneja excepciones | Flujos de excepción no especificados |

### Técnica: Observación de uso post-implementación (Shadowing 2.0)

Aplicar la técnica de Shadowing (de `ba:elicitation`) en el contexto post-implementación para detectar workarounds y comportamientos no anticipados.

**Protocolo:**
1. Observar al usuario usando la nueva solución (sin el BA sugiriendo nada)
2. Registrar cada momento donde el usuario duda, busca ayuda o usa un workaround
3. Preguntar al final: "¿Hay situaciones donde prefiere hacer X como antes?"
4. Documentar en el template de evaluación como limitaciones o gaps

---

## Análisis financiero — ROI y cost savings

### Cálculo del ROI

```
ROI = (Beneficio realizado - Costo de la inversión) / Costo de la inversión × 100

Beneficio realizado = suma de beneficios cuantificados en el período de evaluación
```

**Tipos de beneficios cuantificables:**

| Tipo de beneficio | Cómo calcular |
|------------------|--------------|
| **Reducción de costo de proceso** | (Costo por transacción anterior - Costo actual) × # transacciones/año |
| **Ahorro de tiempo de FTE** | Horas ahorradas/semana × # personas × costo hora × 52 semanas |
| **Reducción de errores** | (Tasa de error anterior - Tasa actual) × costo promedio de error × volumen |
| **Aumento de revenue** | (Tasa de conversión nueva - anterior) × volumen × valor promedio |
| **Reducción de abandono** | (% abandono anterior - % actual) × volumen × valor promedio |

**Ejemplo:**
- Costo de proceso anterior: $12 por transacción
- Costo de proceso actual: $3.50 por transacción
- Reducción: $8.50 × 50,000 transacciones/año = $425,000/año
- Costo del proyecto: $180,000
- ROI = ($425,000 - $180,000) / $180,000 × 100 = 136% en el primer año

### Payback period

```
Payback = Costo de inversión / Beneficio anual

Ejemplo: $180,000 / $425,000 = 0.42 años = 5.1 meses
```

---

## Entrevistas post-implementación — protocolo

### Objetivo

Las entrevistas post-implementación capturan el "por qué" detrás de los números:
- NPS bajo: ¿qué está causando la insatisfacción?
- Adopción baja: ¿por qué no están usando la solución?
- KPI no logrado: ¿qué impide alcanzar el target?

### Preguntas guía

| Tema | Pregunta |
|------|---------|
| **Uso general** | "Describe cómo usas [la solución] en tu trabajo diario" |
| **Valor percibido** | "¿En qué te ha ayudado la solución? ¿Qué sería diferente sin ella?" |
| **Frustraciones** | "¿Hay situaciones donde la solución no te ayuda como esperabas?" |
| **Workarounds** | "¿Hay algo que prefieras hacer como antes?" |
| **Mejoras** | "Si pudieras cambiar una cosa de la solución, ¿qué sería?" |

### Muestra recomendada

| Grupo | # Entrevistas | Selección |
|-------|:------------:|----------|
| Usuarios frecuentes (uso alto) | 3-5 | Aleatorio entre los top 20% por uso |
| Usuarios infrecuentes (uso bajo) | 3-5 | Aleatorio entre los que menos usan |
| Usuarios que abandonaron | 2-3 | Identificados por analytics; acceso difícil |
| Stakeholders de negocio | 2-3 | Sponsor y SMEs que validaron los requisitos |

---

## Post-Implementation Review (PIR)

La PIR es una revisión formal con el sponsor a los 30-90 días:

| Agenda | Duración |
|--------|----------|
| KPI Dashboard — revisión de resultados vs targets | 15 min |
| Value Realization — veredicto sobre el Business Need | 10 min |
| Limitaciones identificadas — priorización | 15 min |
| Lecciones aprendidas del BA — compartir con el equipo | 10 min |
| Recomendaciones — decisión sobre próximos pasos | 10 min |

**Output de la PIR:** Decisión documentada sobre si se continúa (nueva iniciativa / mejora / cierre) con nombres y fechas.
