# Methodology Selection Guide
# Árboles de decisión para seleccionar la metodología correcta entre candidatos similares.

## Cuándo usar este guide

Cuando la situación de negocio podría encajar en más de una metodología del catálogo THYROX.
Este guide ayuda a decidir cuál es más adecuada basándose en las características del problema.

---

## Árbol 1: Problemas de mejora de procesos

```
¿El problema tiene un proceso de negocio concreto que mejorar?
│
├─ NO → Ver Árbol 2 (Resolución de problemas)
│
└─ SÍ → ¿El foco principal es...?
         │
         ├─ Eliminar desperdicios y tiempos muertos (TIMWOOD)
         │   └─ → LEAN (lean-coordinator)
         │       Señales: VSM, 5S, Kaizen, Kanban, Poka-Yoke
         │
         ├─ Reducir defectos y variación con datos estadísticos
         │   └─ → DMAIC (dmaic-coordinator)
         │       Señales: Sigma Level, DPMO, MSA, DOE, SPC
         │
         ├─ Documentar, mapear y rediseñar el proceso (As-Is → To-Be)
         │   └─ → BPA (bpa-coordinator)
         │       Señales: BPMN, swim lanes, VA/NVA/BVA, ESIA
         │
         └─ Iteraciones rápidas de mejora sin necesidad estadística
             └─ → PDCA (pdca-coordinator)
                 Señales: ciclos cortos, piloto, aprendizaje iterativo
```

**Regla de desempate Lean vs DMAIC:**
- ¿Tienes datos cuantitativos de variación (sigma level, DPU, Cpk)? → DMAIC
- ¿El problema es principalmente de desperdicio visible (tiempo, movimiento, inventario)? → Lean
- ¿Ambos? → Lean Six Sigma: empezar con Lean para eliminar desperdicios obvios, luego DMAIC para variación residual

**Regla de desempate BPA vs Lean:**
- ¿Necesitas documentar el proceso formalmente antes de mejorar? → BPA
- ¿Ya conoces el proceso y quieres atacar desperdicios directamente? → Lean

---

## Árbol 2: Resolución de problemas

```
¿El problema está claramente definido y ocurre en un proceso concreto?
│
├─ SÍ y es de escala operacional (turno, línea, área)
│   └─ → PPS / Toyota TBP (pps-coordinator)
│       Señales: problema recurrente, causa raíz desconocida, evidencia en Gemba, A3 Report
│
├─ SÍ y es de escala estratégica/organizacional (múltiples áreas, alta dirección)
│   └─ → CP / Consulting Process (cp-coordinator)
│       Señales: issue tree, MECE, múltiples hipótesis, deck ejecutivo, ROI del cambio
│
└─ NO / El problema no está bien definido
    └─ Primero: clarificar con THYROX Stage 1 DISCOVER
       Luego: regresar a este árbol
```

**Regla de desempate PPS vs DMAIC:**
- ¿Necesitas datos estadísticos para encontrar la causa raíz? → DMAIC
- ¿La causa raíz se puede encontrar con observación directa (Go-and-See) y 5 Whys? → PPS
- ¿Es un problema de calidad con variación medible? → DMAIC
- ¿Es un problema de productividad o eficiencia observable? → PPS

**Regla de desempate PPS vs CP:**
- ¿Es un problema operacional de primera línea? → PPS
- ¿Requiere análisis estructurado de múltiples hipótesis con datos de múltiples fuentes? → CP
- ¿La audiencia de la solución es operativa? → PPS
- ¿La audiencia es ejecutiva y necesita un deck de recomendaciones? → CP

---

## Árbol 3: Planificación y estrategia

```
¿El trabajo requiere dirección organizacional de alto nivel?
│
├─ SÍ y es planificación del futuro de la organización (3-5 años)
│   └─ → SP / Strategic Planning (sp-coordinator)
│       Señales: PESTEL, SWOT, Balanced Scorecard, OKRs, Strategy Map
│
├─ SÍ y es un engagement de consultoría con un cliente/sponsor
│   └─ → CP / Consulting Process (cp-coordinator)
│       Señales: issue tree, hipótesis, Pyramid Principle, recomendación ejecutiva
│
└─ NO → Ver Árbol 4 (Gestión de proyectos)
```

**Regla de desempate SP vs CP:**
- ¿El output principal es un plan estratégico de largo plazo (BSC, OKRs, roadmap)? → SP
- ¿El output principal es una recomendación ejecutiva para resolver un problema específico? → CP
- ¿El horizonte es +1 año con revisiones periódicas? → SP
- ¿Es un proyecto de consultoría con entregable puntual? → CP

---

## Árbol 4: Gestión de proyectos y requisitos

```
¿El trabajo es un proyecto con entregables, equipo y presupuesto?
│
├─ SÍ y es desarrollo de software con arquitectura compleja e iteraciones
│   └─ → RUP (rup-coordinator)
│       Señales: milestones LCO/LCA/IOC, iteraciones por fase, arquitectura base
│
├─ SÍ y es un proyecto genérico (no necesariamente software)
│   └─ → PMBOK (pm-coordinator)
│       Señales: Project Charter, WBS, triple restricción, PMI, RACI
│
├─ El foco es gestionar requisitos (no el proyecto completo)
│   └─ → RM (rm-coordinator)
│       Señales: elicitación, SRS, trazabilidad, change control de requisitos
│
└─ El foco es análisis de negocio (qué necesita la organización, no cómo construirlo)
    └─ → BABOK (ba-coordinator)
        Señales: business case, necesidad de negocio, value delivery, solution evaluation
```

**Regla de desempate PMBOK vs RUP:**
- ¿Es desarrollo de software con incertidumbre arquitectónica alta? → RUP
- ¿Es cualquier tipo de proyecto (construcción, marketing, IT, etc.)? → PMBOK
- ¿Necesitas milestones de arquitectura específicos (LCO, LCA)? → RUP

**Regla de desempate RM vs BABOK:**
- ¿El foco es el ciclo de vida de los requisitos (elicitar → especificar → validar → cambiar)? → RM
- ¿El foco es el análisis de negocio integral (estrategia → análisis → solución → evaluación)? → BABOK

---

## Tabla de resumen rápido

| Si tu situación es... | Metodología recomendada | Coordinator |
|----------------------|------------------------|-------------|
| Eliminar desperdicios en un proceso | Lean Six Sigma | lean-coordinator |
| Reducir defectos con datos estadísticos | DMAIC | dmaic-coordinator |
| Documentar y rediseñar proceso (BPMN) | BPA | bpa-coordinator |
| Mejora iterativa rápida (ciclos cortos) | PDCA | pdca-coordinator |
| Resolver problema operacional con causa raíz | PPS / Toyota TBP | pps-coordinator |
| Resolver problema complejo con hipótesis | Consulting Process | cp-coordinator |
| Planificar estrategia de largo plazo | Strategic Planning | sp-coordinator |
| Gestionar proyecto PMI | PMBOK | pm-coordinator |
| Desarrollar software iterativamente | RUP | rup-coordinator |
| Gestionar ciclo de vida de requisitos | RM | rm-coordinator |
| Análisis de negocio integral | BABOK | ba-coordinator |

---

## Árbol 5: Sistemas Agentic AI

```
¿El WP construye o diseña un sistema donde un agente toma decisiones autónomas?
│
├─ NO → este árbol no aplica
│
└─ SÍ → ¿Cuál es el tipo de problema?
         │
         ├─ Orquestación multi-agente (coordinación de agentes especializados con scope acotado)
         │   └─ → RUP (rup-coordinator) — iteraciones claras por fase
         │       Referencias de implementación: discover/patterns/ (AP-01..AP-30)
         │       Señales: orquestadores/subagentes, boundary contracts, scope acotado por rol
         │
         ├─ Diseño HITL/HOTL/HIC (Human-in-the-Loop / on-the-Loop / in-Command)
         │   └─ → rup: o rm: según si hay ciclo de vida de requisitos activo
         │       Ver HITL patterns en discover/patterns/hitl-* (AP-07, AP-08)
         │       Señales: puntos de aprobación humana, escalation, override manual
         │
         ├─ Tool use contracts (especificar contratos de herramientas para el agente)
         │   └─ → workflow Stage 7 DESIGN/SPECIFY con AP-31/32
         │       Señales: inputs/outputs tipados, schemas de herramientas, invariantes de callback
         │
         └─ Observabilidad agentic (métricas, drift, latency, quality)
             └─ → AP-13..15 en agentic-python.instructions.md
                 Señales: ausencia de logs estructurados, sin métricas de drift, latency desconocida
```

**Regla de desempate para WPs agentic:**

| Situación | Flow recomendado |
|-----------|-----------------|
| Incertidumbre alta en cómo el agente resolverá el problema | `sp:` — exploración estratégica primero |
| Ciclo de vida software iterativo con fases claras (LCO, LCA, IOC) | `rup:` |
| WP es el framework mismo (meta-nivel — ej: mejorar THYROX) | Ciclo THYROX nativo sin flow adicional |
| Gestión de requisitos del sistema agentic (elicitación, trazabilidad) | `rm:` |

**Regla de desempate sp: vs rup: para WPs agentic:**
- ¿El problema de decisión del agente todavía no está definido (explorar qué mecanismo usar)? → `sp:`
- ¿Ya se sabe qué construir y el reto es ejecutar iterativamente? → `rup:`
- ¿El WP modifica o extiende THYROX mismo? → ciclo THYROX nativo (sin flow adicional)

**Referencias de implementación — patrones consultables:**

Los patrones AP-01..AP-30 en `discover/patterns/` del WP activo documentan implementaciones
verificadas de los siguientes dominios:

| Rango | Dominio | Archivo de referencia |
|-------|---------|----------------------|
| AP-01..AP-02 | Callback contracts (sin side effects) | adk-model-callback-contract.md |
| AP-03..AP-06 | Type contracts en tool inputs/outputs | — (ver agentic-python.instructions.md) |
| AP-07..AP-08 | HITL patterns (aprobación, escalation) | discover/patterns/hitl-* |
| AP-09..AP-12 | Error handling (no silenciar excepciones) | — |
| AP-13..AP-15 | Observabilidad: drift, latency, quality | agentic-python.instructions.md |
| AP-16..AP-30 | Patrones multiagente, memoria, RAG, MCP | discover/patterns/ |

---

## Cuándo NO usar una sola metodología

Algunos WPs grandes requieren combinar metodologías en secuencia:

| Combinación | Flujo | Cuándo |
|-------------|-------|--------|
| BPA → Lean | Mapear proceso → eliminar desperdicios | Cuando primero hay que entender el proceso antes de atacar los desperdicios |
| DMAIC → Lean | Medir variación → eliminar desperdicios | Lean Six Sigma completo |
| SP → CP | Estrategia → implementación via consultoría | Cuando la estrategia requiere un engagement de consultoría para implementarse |
| RM → RUP | Requisitos → desarrollo iterativo | Proyecto de software con gestión formal de requisitos |
| BA → PMBOK | Análisis de negocio → gestión del proyecto | Cuando el BA define el qué y el PM gestiona el cómo |

Para combinaciones: activar los coordinators en secuencia, pasando los artefactos de uno al otro.
