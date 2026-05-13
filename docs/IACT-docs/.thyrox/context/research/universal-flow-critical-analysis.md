```yml
created_at: 2026-04-17 02:59:28
project: THYROX
type: research
title: Análisis crítico y corrección del flujo universal — 14 pasos corregidos
origin: Investigación fundacional ÉPICA 40 (multi-methodology)
status: Válido
relevance: Fuente de verdad del mapeo 14 pasos → 12 stages THYROX (merges documentados aquí)
```

# ANÁLISIS CRÍTICO Y CORRECCIÓN DEL FLUJO UNIVERSAL

## Flujo Original Propuesto (9 pasos)

```
DISCOVER → MEASURE → ANALYZE → STRATEGY → PLAN → STRUCTURE → DECOMPOSE → EXECUTE → TRACK
```

---

## ANÁLISIS CRÍTICO POR PASO

### 1. DISCOVER — "¿Qué problema existe?"

**Problema:** Riesgo de identificar síntomas, no causa raíz. Sin validación de que es el problema REAL.

**Ejemplo:**
- "Nuestras ventas bajan" ← SÍNTOMA
- "No podemos vender porque el sitio cae" ← PROBLEMA REAL
- "El sitio cae porque servidor no escala" ← CAUSA RAÍZ

**Corrección:** DISCOVER debe validar que el problema identificado es el REAL, no un síntoma.

---

### 2. MEASURE — "¿Cuál es el estado actual medido?"

**Problema:** MEASURE requiere saber QUÉ medir. "DETERMINE METRICS" debe ocurrir ANTES de MEASURE.

**Corrección:** Agregar paso "DEFINE METRICS" entre DISCOVER y MEASURE.

---

### 3. ANALYZE — "¿Por qué existe el problema?"

**Correcto en posición.** Debe diferenciar entre causa raíz, síntomas e impactos.

---

### 4. STRATEGY — "¿Qué enfoque/arquitectura usamos?"

**Problema:** STRATEGY ignora restricciones (presupuesto, timeline, recursos).

**Ejemplo del problema:**
```
STRATEGY "cambiar a Kubernetes"
PERO: cuesta $50k (presupuesto es $10k), toma 6 meses (deadline es 2 semanas)
```

**Corrección:** Agregar "DEFINE CONSTRAINTS" ANTES de STRATEGY.

---

### 5. PLAN — "¿Qué entra en scope y qué no?"

**Distinción con STRATEGY:**
- STRATEGY = "Cómo resolver a nivel alto" (QUÉ)
- PLAN = "Qué hacemos concretamente" (CÓMO EXACTO)

---

### 6. STRUCTURE — "¿Cómo exactamente?"

**Problema:** Término muy vago. Puede significar arquitectura de software, especificaciones de requisitos, diseño de BD, wireframes.

**Corrección:** Cambiar a DESIGN/SPECIFY (más explícito).

---

### 7. DECOMPOSE — "¿En qué tareas atómicas se divide?"

**Problema:** ¿Es "descomposición" o "planificación de tareas"?

**Corrección:** Cambiar nombre a "PLAN EXECUTION" (¿qué?, ¿quién?, ¿cuándo?).

---

### 8. EXECUTE — "Hacer el trabajo"

**Problema:** Sin validación previa. Riesgo de catástrofe en producción.

**Corrección:** Insertar "PILOT/VALIDATE" ANTES de EXECUTE.

---

### 9. TRACK — "Cerrar, lecciones aprendidas"

**Problema:** No muestra bucles de iteración. Si TRACK descubre que el enfoque NO funcionó, ¿vuelve a dónde?

**Corrección:** Agregar bucles de retroalimentación.

---

## FLUJO CORREGIDO Y MEJORADO (14 pasos)

```
1.  DISCOVER         → Identificar problema real (validado)
2.  DEFINE METRICS   → ¿Qué medimos?
3.  MEASURE          → Estado actual
4.  ANALYZE          → Causas raíz + Impactos
5.  DEFINE CONSTRAINTS → Presupuesto, Timeline, Recursos
6.  STRATEGY         → Enfoque a nivel alto
7.  PLAN             → Scope, Prioridades, Riesgos
8.  DESIGN/SPECIFY   → Requisitos detallados, Arquitectura
9.  PLAN EXECUTION   → Tareas, Asignaciones, Calendario
10. PILOT/VALIDATE   → Prueba en ambiente controlado
    ↓ ¿Funciona?
    NO → Vuelve a paso 4 (ANALYZE)
    SÍ → Continúa
11. EXECUTE          → Implementación completa
12. MONITOR          → Observación continua
13. TRACK/EVALUATE   → Análisis post-ejecución
    ↓ ¿Alcanzó objetivos?
    NO → Vuelve a paso 4 (ANALYZE)
    SÍ → Continúa
14. STANDARDIZE      → Permanencia, Lecciones aprendidas
```

---

## TABLA DE PROBLEMAS DETECTADOS Y CORRECCIONES

| # | Paso original | Problema | Severidad | Corrección |
|---|--------------|----------|-----------|-----------|
| 1 | DISCOVER | No valida si problema es real o síntoma | ALTA | Agregar validación |
| 2 | MEASURE | No define QUÉ medir | ALTA | Agregar DEFINE METRICS |
| 3 | ANALYZE | No diferencia causa/síntoma/impacto | MEDIA | Ser explícito en análisis |
| 4 | STRATEGY | Ignora restricciones (presupuesto, timeline) | ALTA | Agregar DEFINE CONSTRAINTS |
| 5 | PLAN | Acoplado con STRATEGY (posible duplicación) | MEDIA | Clarificar diferencia |
| 6 | STRUCTURE | Término muy vago | MEDIA | Cambiar a DESIGN/SPECIFY |
| 7 | DECOMPOSE | Podría ser PLAN EXECUTION | BAJA | Renombrar |
| 8 | EXECUTE | Sin validación previa (PILOT) | ALTA | Agregar PILOT antes |
| 9 | TRACK | No muestra bucles de iteración | ALTA | Agregar feedback loops |

---

## MAPEO 14 PASOS → 12 STAGES THYROX

Los 14 pasos del flujo corregido se consolidaron en 12 stages THYROX mediante merges:

| Paso corregido | → | Stage THYROX |
|---------------|---|-------------|
| DISCOVER | → | Stage 1 DISCOVER |
| DEFINE METRICS | → | Stage 2 BASELINE (absorbido) |
| MEASURE | → | Stage 2 BASELINE |
| ANALYZE | → | Stage 3 DIAGNOSE |
| DEFINE CONSTRAINTS | → | Stage 4 CONSTRAINTS |
| STRATEGY | → | Stage 5 STRATEGY |
| PLAN | → | Stage 6 SCOPE |
| DESIGN/SPECIFY | → | Stage 7 DESIGN/SPECIFY |
| PLAN EXECUTION | → | Stage 8 PLAN EXECUTION |
| PILOT/VALIDATE | → | Stage 9 PILOT/VALIDATE |
| EXECUTE | → | Stage 10 IMPLEMENT |
| MONITOR | → | Stage 10 IMPLEMENT (paralelo) |
| TRACK/EVALUATE | → | Stage 11 TRACK/EVALUATE |
| STANDARDIZE | → | Stage 12 STANDARDIZE |

**Bucles de retroalimentación → Modelo de permisos (Plano A):**
- Si PILOT falla → vuelve a Stage 3 DIAGNOSE
- Si TRACK indica falla → vuelve a Stage 3 DIAGNOSE

Estos bucles están mapeados a los gates del modelo de permisos en `thyrox/SKILL.md`.

---

## GANANCIA DEL FLUJO CORREGIDO

**Flujo Original: 9 pasos**
**Flujo Corregido: 14 pasos (+5 pasos críticos, +2 bucles)**

- Menos riesgo de medir lo equivocado (DEFINE METRICS)
- Menos riesgo de ignorar restricciones (DEFINE CONSTRAINTS)
- Menos riesgo de ejecutar sin validación (PILOT/VALIDATE)
- Visibilidad clara de qué hacer si falla (feedback loops)
- Mejor claridad en cada paso (DESIGN/SPECIFY, PLAN EXECUTION)

---

## ADICIONES CRÍTICAS INCORPORADAS EN THYROX

| Adición del flujo crítico | Stage THYROX resultado |
|--------------------------|----------------------|
| DEFINE METRICS (nuevo) | Stage 2 BASELINE |
| DEFINE CONSTRAINTS (nuevo) | Stage 4 CONSTRAINTS |
| PILOT/VALIDATE (nuevo) | Stage 9 PILOT/VALIDATE |
| MONITOR separado de TRACK | Stage 10 IMPLEMENT (paralelo) |
| Feedback loops (nuevo) | Gates del modelo de permisos |
| DESIGN/SPECIFY (renombrado) | Stage 7 DESIGN/SPECIFY |
| PLAN EXECUTION (renombrado) | Stage 8 PLAN EXECUTION |

**Versión del análisis:** 1.0 | **Estado:** Validado y aplicado | **Fecha original:** Abril 15, 2026
