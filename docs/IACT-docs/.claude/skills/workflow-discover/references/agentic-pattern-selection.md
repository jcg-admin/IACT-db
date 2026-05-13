```yml
created_at: 2026-04-20 13:43:15
project: THYROX
author: NestorMonroy
status: Borrador
```

# Agentic Pattern Selection — Heurístico para Stage 1 DISCOVER y Stage 5 STRATEGY

## Árbol de decisión: selección de patrón agentic

### ¿El workflow de resolución se conoce de antemano?

```
¿El workflow se conoce de antemano?
│
├── SÍ — estructura fija
│   ├── ¿Los pasos son secuenciales sin bifurcación? → CHAINING
│   ├── ¿Hay bifurcaciones basadas en tipo de input? → ROUTING
│   └── ¿Los pasos pueden ejecutarse en paralelo sin dependencias? → PARALLELIZATION
│
└── NO — estructura emerge durante la ejecución
    ├── ¿Necesita integrar fuentes internas + búsqueda externa? → PLANNING + RAG (dos capas distintas)
    └── ¿Solo fuentes internas? → PLANNING puro

⚠ Señal de advertencia: si se usa Planning pero el workflow resultante siempre tiene
la misma estructura → probablemente es Chaining o Routing disfrazado de Planning
```

## Taxonomía HITL/HOTL/HIC para Stage 5 STRATEGY

| Modelo | Descripción | Requisito de implementación |
|--------|-------------|----------------------------|
| **HITL** | Workflow se bloquea hasta que el humano revisa | interrupt/resume pattern real (AP-16/17) |
| **HOTL** | Workflow ejecuta; humano monitorea y puede intervenir | No requiere blocking |
| **HIC** | Humano define reglas; agente las ejecuta autónomamente | Sin supervisión en tiempo real |

⚠ Señal de advertencia: si el diseño usa HITL conceptualmente pero no implementa interrupt/resume (AP-16/17), el sistema es realmente HOTL.

## Gate THYROX calibrado ≠ Consenso

- **Gate THYROX implementa:** Parallelization (evaluadores concurrentes) + Merger con grounding
- **Consenso requeriría:** rondas de discusión entre evaluadores con protocolo de terminación — THYROX NO implementa esto

Regla de diseño: un agente es "distinto" de otro cuando tiene al menos un tool que el otro no tiene. Distinción solo de system prompt NO es especialización real.

## Referencias

- Patrones de implementación: `discover/patterns/` (AP-01..AP-30)
- HITL/HOTL patterns: `discover/patterns/hitl-blocking-loop.md`, `discover/patterns/hitl-interrupt-resume.md`
- Contratos de herramientas: `discover/patterns/adk-tool-callback-contract.md`
