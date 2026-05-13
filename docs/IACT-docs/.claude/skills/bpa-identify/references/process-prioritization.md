# Process Prioritization — BPA:Identify

Guía para calcular Priority Score, normalizar datos, y validar la selección de procesos con stakeholders.

---

## Por qué priorizar antes de analizar

Sin priorización formal, el proceso que se analiza suele ser:
- El proceso que el stakeholder más senior mencionó en la última reunión
- El proceso que tuvo un incidente reciente (recency bias)
- El proceso más visible, no el más impactante

La priorización basada en datos protege contra estos sesgos y genera consenso entre stakeholders sobre por qué se analiza ese proceso y no otro.

---

## Fórmula Priority Score

```
Priority Score = (Frecuencia_norm × 0.2) + (Volumen_norm × 0.2) + (Pain Level × 0.3) + (Impacto Estratégico × 0.3)
```

Los pesos por defecto asignan mayor importancia a Pain Level e Impacto Estratégico (30% cada uno) porque estos factores determinan la tracción política y el valor de negocio de mejorar el proceso.

### Ajuste de pesos por contexto

| Contexto | Ajuste recomendado |
|----------|-------------------|
| Programa de transformación digital | Aumentar Impacto Estratégico a 0.4 |
| Reducción de costos operacionales | Aumentar Volumen a 0.35 |
| Mejora de experiencia del equipo | Aumentar Pain Level a 0.45 |
| Compliance / regulatorio | Agregar factor Riesgo Regulatorio con peso 0.3 |

---

## Normalización de variables

### Frecuencia

| Frecuencia real | Valor normalizado |
|----------------|-----------------|
| Varias veces al día | 5 |
| Diaria (1x/día) | 4 |
| Semanal | 3 |
| Quincenal | 2 |
| Mensual o menos | 1 |

### Volumen/día

Normalizar sobre el máximo del set:

```
Volumen_norm = (Volumen_proceso / Volumen_máximo_del_set) × 5
```

**Ejemplo:**
- Proceso A: 200 transacciones/día
- Proceso B: 50 transacciones/día
- Proceso C: 400 transacciones/día (máximo)

→ Proceso A: (200/400) × 5 = 2.5
→ Proceso B: (50/400) × 5 = 0.6
→ Proceso C: (400/400) × 5 = 5.0

### Pain Level (1-5) — escala con criterios

| Nivel | Descripción | Indicadores observables |
|-------|-------------|------------------------|
| **1 — Mínimo** | Proceso fluye bien | Pocas o ninguna queja, ejecutores satisfechos |
| **2 — Bajo** | Molestias menores | Workarounds ocasionales, retrasos esporádicos |
| **3 — Medio** | Problemas regulares | Escaladas frecuentes, errores recurrentes, quejas documentadas |
| **4 — Alto** | Impacto operacional | Retrabajos frecuentes, overtime para cubrir fallas, SLAs incumplidos |
| **5 — Crítico** | Crisis recurrentes | Escaladas a management, clientes afectados visiblemente, impacto financiero directo |

**Cómo asignar Pain Level con rigor:**
- No basarse solo en la percepción del manager — validar con ejecutores del proceso
- Usar datos cuando están disponibles: tickets de soporte, tasas de error, tiempo promedio de ciclo vs. objetivo
- Si hay discrepancia entre manager y ejecutores, documentar ambas perspectivas y usar el promedio

### Impacto Estratégico (1-5)

| Nivel | Descripción |
|-------|-------------|
| **5 — Crítico** | Afecta directamente un objetivo del plan anual o un KPI estratégico corporativo |
| **4 — Alto** | Afecta la satisfacción de clientes clave o la retención de talento |
| **3 — Medio** | Afecta eficiencia operacional de un área pero no objetivos estratégicos directos |
| **2 — Bajo** | Proceso de soporte con impacto interno limitado |
| **1 — Nulo** | Proceso administrativo de baja visibilidad y bajo impacto |

**Fuentes para determinar Impacto Estratégico:**
- Plan anual o OKRs de la organización
- Balanced Scorecard del área
- Entrevistas con management sobre prioridades del año

---

## Interpretación del Priority Score

| Score | Categoría | Decisión |
|-------|-----------|---------|
| 4.0 – 5.0 | **Alta prioridad** | Analizar en la presente iniciativa |
| 2.5 – 3.9 | **Media prioridad** | Planificar para el próximo ciclo BPA |
| 0.0 – 2.4 | **Baja prioridad** | Monitorear; no analizar ahora |

**Regla:** Si hay más de un proceso con score ≥ 4.0, seleccionar el de mayor score — o el que tenga owner con mandato para implementar cambios.

---

## Técnicas de validación con stakeholders

### Técnica 1: Dot Voting (priorización rápida en grupo)

Usar cuando: hay 5+ stakeholders en la sala y se quiere consenso rápido.

**Procedimiento:**
1. Listar procesos en pizarra o flipchart
2. Dar a cada stakeholder 3 "votos" (puntos, post-its o marcas)
3. Cada uno asigna sus votos a los procesos más dolorosos / importantes
4. Ordenar por número de votos
5. Usar como input de Pain Level (votos = percepción de pain del equipo)

### Técnica 2: Validation Matrix

Usar cuando: hay datos de sistemas y se quiere validar estimaciones del equipo.

| Proceso | Score equipo | Datos sistema | Score final |
|---------|-------------|--------------|-------------|
| [Proceso A] | [score basado en entrevistas] | [dato real: X errores/mes] | [score ajustado] |

### Técnica 3: Revisión con Process Owner

Antes de finalizar la selección:
1. Presentar top 3 procesos con scores
2. Preguntar: *"¿Hay algún factor que el score no captura?"*
3. Preguntar: *"¿Tiene usted el mandato para implementar cambios en estos procesos?"*
4. Si el owner no tiene mandato → escalarlo como riesgo antes de continuar

---

## Riesgos de priorización

| Riesgo | Mitigación |
|--------|-----------|
| Score alto pero owner sin mandato | Documentar riesgo; escalar antes de iniciar bpa:map |
| Datos de volumen no disponibles | Usar estimaciones rangadas ("30–50 transacciones/día") y documentar la incertidumbre |
| Stakeholders no llegan a consenso | Usar dot voting para evidenciar preferencias del grupo; el facilitador desempata en caso de empate |
| Proceso con score alto es inmanejable (scope gigante) | Definir límites estrictos en bpa:identify antes de avanzar; considerar analizar subproceso |

---

## Ejemplo ilustrativo de scoring

| Proceso | Frecuencia_norm | Volumen_norm | Pain Level | Impacto Est. | Priority Score |
|---------|----------------|-------------|-----------|-------------|---------------|
| Aprobación de crédito | 4 (diaria) | 2.5 | 4 | 5 | **4.05** ← Seleccionado |
| Onboarding empleado nuevo | 2 (quincenal) | 1.0 | 3 | 4 | **2.90** |
| Procesamiento de facturas | 5 (varias/día) | 5.0 | 2 | 3 | **3.10** |
| Reporte mensual de ventas | 1 (mensual) | 0.5 | 2 | 2 | **1.75** |

*En este ejemplo, "Aprobación de crédito" se selecciona por su combinación de alto impacto estratégico (5) y dolor operacional (4).*
