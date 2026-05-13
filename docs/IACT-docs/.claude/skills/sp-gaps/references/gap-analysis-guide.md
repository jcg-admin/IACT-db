# Gap Analysis Guide — Cuantificación de Brechas Estratégicas

## ¿Qué es un gap estratégico?

Un gap estratégico es la diferencia medible entre el estado actual de la organización y el estado futuro deseado en una dimensión estratégicamente relevante. A diferencia de los gaps operacionales (donde el proceso falla), los gaps estratégicos reflejan la distancia entre la posición competitiva actual y la posición que la organización necesita alcanzar.

**Tipos de gap estratégico:**

| Tipo | Definición | Ejemplo |
|------|-----------|---------|
| **Performance gap** | La organización sabe hacer X pero no alcanza el nivel requerido | Revenue actual $2M vs. target $8M |
| **Capability gap** | La organización no tiene la capacidad para hacer X | Sin equipo de data science; estrategia requiere analytics avanzado |
| **Market gap** | La organización no está en el mercado o segmento correcto | Sin presencia en LATAM; target incluye LATAM como fuente de 30% del revenue |
| **Resource gap** | Faltan recursos (capital, talento, tecnología) para ejecutar | Presupuesto de $500K vs. inversión requerida de $2M |

---

## Cómo cuantificar brechas estratégicas

### Paso 1: Definir la métrica correcta por dimensión

No todas las dimensiones tienen una métrica natural. Usar este mapeo como guía:

| Dimensión estratégica | Métrica recomendada | Cómo obtener el baseline |
|-----------------------|--------------------|--------------------------| 
| Participación de mercado | % market share | Datos de industria + revenue propio |
| Rentabilidad | EBITDA margin %, ROI | Estados financieros |
| Satisfacción de clientes | NPS, CSAT, CES | Encuestas periódicas |
| Eficiencia operacional | Costo por unidad, cycle time | Datos operacionales internos |
| Innovación | # nuevos productos/año, % revenue de productos <3 años | Portfolio de productos |
| Talento | % roles críticos cubiertos, eNPS | RRHH |
| Presencia digital | Tráfico orgánico, tasa de conversión | Analytics |
| Calidad | Tasa de defectos, % SLA cumplido | Datos de calidad / soporte |

### Paso 2: Validar el baseline antes de calcular la brecha

El baseline debe ser:
- **Reciente** — datos del último trimestre o año fiscal, no proyecciones
- **Verificable** — con fuente documentada (no "estimamos que...")
- **Acordado** — el equipo directivo debe alinear en el dato, no en el target

Si el baseline no existe: crear un plan de medición antes de continuar con el gap analysis.

### Paso 3: Establecer el target con rigor

Los targets estratégicos pueden provenir de:
1. **Benchmark sectorial** — ¿cuál es el percentil 75 del sector? ¿qué hace el líder?
2. **Modelo financiero** — ¿qué revenue/margen se necesita para financiar la estrategia?
3. **Aspiración directiva** — validar con análisis de factibilidad; un target 10× en 1 año sin recursos es irrealizable
4. **Compromisos externos** — board, inversores, reguladores

> Un target sin justificación es una ilusión. Un target con justificación es un norte.

### Paso 4: Calcular la brecha de forma consistente

```
Gap = Target - Baseline

Para métricas donde "más es mejor" (revenue, NPS, market share):
  Gap positivo = brecha de crecimiento
  
Para métricas donde "menos es mejor" (costo, tiempo, tasa de defectos):
  Gap = Baseline - Target (para que el gap positivo = mejoría necesaria)
```

**Brecha relativa** (útil para comparar brechas de distintas escalas):
```
Gap% = (Target - Baseline) / |Baseline| × 100%
```

---

## Análisis de causa raíz estratégico

A diferencia del análisis de causa raíz operacional (donde se busca la falla del proceso), el análisis estratégico es más complejo porque las causas son sistémicas, históricas y a menudo externas.

### Framework de 7 categorías de causa raíz estratégica

| Categoría | Preguntas diagnósticas | Señales de alerta |
|-----------|----------------------|------------------|
| **Capacidades** | ¿Sabe la organización hacerlo? ¿Lo ha hecho antes? | "Nunca hemos tenido ese expertise" |
| **Procesos** | ¿El proceso actual impide alcanzar el target? | Proceso diseñado para escala menor / distinta |
| **Tecnología** | ¿La tecnología actual es el cuello de botella? | Sistema legacy sin API / integración |
| **Talento** | ¿Falta el perfil correcto? ¿Retención? ¿Desarrollo? | Alta rotación en roles críticos |
| **Estructura** | ¿La organización está estructurada para ejecutar esto? | Silos que impiden coordinación necesaria |
| **Decisiones pasadas** | ¿Una decisión anterior creó la brecha? | Deuda técnica, contratos restrictivos |
| **Mercado/entorno** | ¿La brecha es externa — competencia, regulación? | No hay acción interna que la cierre sin adaptación externa |

### Técnica de los "5 ¿Por qué?" adaptada para estrategia

```
Gap: NPS = 42 (target: 70)
¿Por qué el NPS es bajo? → Clientes reportan soporte lento
¿Por qué el soporte es lento? → El equipo de soporte está subespecializado y subestaffed
¿Por qué está subespecializado? → El producto evolucionó pero el equipo no se entrenó
¿Por qué no se entrenó? → No hubo presupuesto de L&D en los últimos 2 años
¿Por qué no hubo presupuesto? → L&D fue recortado como primera línea en ajuste de costos

Causa raíz: Decisión estratégica de reducir L&D sin plan de compensación para el talento existente
Categoría: Decisiones pasadas + Talento
```

---

## Matriz de priorización — guía de puntuación

### Dimensión: Impacto estratégico (1-5)

| Score | Descripción |
|-------|------------|
| 5 | Crítico para la supervivencia o diferenciación core del negocio |
| 4 | Impacta directamente en el objetivo estratégico principal |
| 3 | Relevante para la estrategia pero no central |
| 2 | Mejora incremental sin relación directa con la estrategia |
| 1 | Marginal — impacto difícil de trazar a objetivos estratégicos |

### Dimensión: Urgencia (1-5)

| Score | Descripción |
|-------|------------|
| 5 | Si no se aborda en <6 meses, el daño se vuelve irreversible |
| 4 | Ventana de oportunidad se cierra en 6-12 meses |
| 3 | Relevante en el horizonte de 1-2 años |
| 2 | Puede esperar 2-3 años sin consecuencias graves |
| 1 | Sin urgencia — monitorear |

### Interpretación de la matriz

```
        Alta urgencia (4-5)    Baja urgencia (1-2)
Alto impacto   CRÍTICA (prioridad 1)   ALTA (prioridad 2)
Bajo impacto   MEDIA (prioridad 3)     BAJA (no actuar)
```

### Errores comunes en la priorización

1. **Calificar todo como urgencia 5** — confundir "importante" con "urgente"
2. **No validar el score con el equipo directivo** — la matriz refleja la percepción del que la llena, que puede no ser la del CEO
3. **Ignorar interdependencias** — si cerrar el gap A es requisito para cerrar el gap B, la prioridad de A sube automáticamente
4. **No revisar tras cambios del entorno** — una amenaza que se materializa cambia la urgencia de múltiples brechas

---

## Conexión con el ciclo SP

El gap analysis alimenta directamente sp:formulate:
- Los gaps de alta prioridad → Objetivos estratégicos en el BSC
- Las causas raíz → Perspectivas del BSC donde actuar (Learning & Growth, Internal Processes)
- La cuantificación de brechas → KPIs y targets del BSC y los OKRs
