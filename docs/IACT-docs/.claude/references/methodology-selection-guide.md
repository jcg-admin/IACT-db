```yml
type: Referencia — Selección de Metodología
category: Cross-phase
version: 1.0.0
purpose: Guía de decisión para seleccionar el coordinator correcto según el contexto
updated_at: 2026-04-17 20:00:00
owner: thyrox (cross-phase)
```

# Methodology Selection Guide

Cuándo usar cada coordinator y qué señales de contexto lo activan.

---

## Tabla de selección

| Metodología | Coordinator | Cuándo usar | Tipo de flujo | Señales de contexto | Output principal |
|-------------|-------------|-------------|---------------|---------------------|-----------------|
| **DMAIC** | `dmaic-coordinator` | Reducción de defectos medibles, variación de proceso, Six Sigma | Secuencial (5 fases) | "defecto", "variación", "DPMO", "sigma", "calidad proceso" | Project charter, fishbone, FMEA, control plan |
| **PDCA** | `pdca-coordinator` | Mejora continua iterativa, ciclos cortos, experimentación | Cíclico (4 etapas) | "mejorar continuamente", "ciclo", "iteración corta", "hipótesis" | Plan de mejora, registro de resultados, acción correctiva |
| **PMBOK** | `pm-coordinator` | Gestión formal de proyectos, PMO, entregables contractuales | Secuencial (5 grupos) | "proyecto formal", "PMO", "stakeholders", "presupuesto", "cronograma" | Acta de constitución, WBS, plan de proyecto, lecciones aprendidas |
| **BABOK v3** | `ba-coordinator` | Análisis de negocio, elicitación de requisitos, evaluación de soluciones | No-secuencial (6 áreas) | "análisis de negocio", "requisitos de negocio", "BA", "stakeholder needs" | Business case, requirements package, solution assessment |
| **RUP** | `rup-coordinator` | Software con arquitectura compleja, iteraciones formales, milestones | Iterativo (4 fases) | "arquitectura de software", "casos de uso", "iteraciones", "milestone" | Vision, SRS, SAD, milestones LCO/LCA/IOC/PD |
| **RM** | `rm-coordinator` | Ciclo de vida completo de requisitos, trazabilidad, gestión de cambios | State-machine | "requisitos", "trazabilidad", "change request", "validación requisitos" | Requirements spec, traceability matrix, change log |
| **Lean** | `lean-coordinator` | Eliminación de desperdicios, flujo de valor, manufactura | Secuencial (5 fases) | "desperdicio", "flujo de valor", "VSM", "muda", "kanban", "lead time" | VSM as-is/to-be, kaizen events, standard work |
| **BPA** | `bpa-coordinator` | Análisis y rediseño de procesos de negocio, BPMN | Secuencial (6 fases) | "proceso de negocio", "BPMN", "as-is", "to-be", "ESIA", "BVA/NVA" | Mapa BPMN, análisis VA, proceso to-be optimizado |
| **PPS** | `pps-coordinator` | Resolución estructurada de problemas, Toyota, go-and-see | State-machine | "problema recurrente", "5 whys", "A3", "gemba", "causa raíz Toyota" | A3 report, 5 whys, countermeasure plan |
| **SP** | `sp-coordinator` | Planificación estratégica, OKRs, BSC, revisiones periódicas | Cíclico | "estrategia", "PESTEL", "SWOT", "OKR", "balanced scorecard", "visión" | PESTEL/SWOT analysis, estrategia, BSC, OKRs |
| **CP** | `cp-coordinator` | Problemas complejos de negocio, consultoría, issue tree | Secuencial | "problema de negocio", "issue tree", "MECE", "hipótesis", "recomendación" | Issue tree, hypothesis tree, recommendation deck |

---

## Árbol de decisión rápido

```
¿Qué tipo de trabajo?
│
├── Problema de CALIDAD con datos medibles → DMAIC
├── Mejora ITERATIVA continua → PDCA
├── PROYECTO formal con presupuesto → PMBOK
├── ANÁLISIS DE NEGOCIO / requisitos → BABOK
├── DESARROLLO DE SOFTWARE complejo → RUP
├── REQUISITOS y trazabilidad → RM
├── DESPERDICIO / flujo de valor → Lean
├── PROCESO DE NEGOCIO (BPMN) → BPA
├── PROBLEMA RECURRENTE (Toyota) → PPS
├── PLANIFICACIÓN ESTRATÉGICA → SP
└── PROBLEMA COMPLEJO (consultoría) → CP
```

---

## Combinaciones frecuentes

| Escenario | Combinación |
|-----------|-------------|
| Mejora de proceso con datos | DMAIC + Lean (VSM primero, luego DMAIC para reducción de variación) |
| Proyecto de software con requisitos | PMBOK + RM (PMBOK para gestión, RM para trazabilidad de requisitos) |
| Transformación de negocio | SP + BPA (estrategia primero, luego rediseño de procesos) |
| Problema crítico recurrente | PPS + DMAIC (PPS para causa raíz, DMAIC para reducción sistemática) |

---

## Cuándo NO usar un coordinator

- WP técnico puro (feature de código, bug fix) → usar stages THYROX directamente sin coordinator
- Problema ya bien definido con solución clara → task plan T-NNN sin overhead de metodología
- Análisis exploratorio inicial → Stage 1 DISCOVER sin coordinator hasta tener clarity del problema
