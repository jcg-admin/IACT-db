```yml
created_at: 2026-04-20 13:45:00
project: THYROX
author: NestorMonroy
status: Borrador
```

# ARCHITECTURE.md — Inventario Canónico de Agentes THYROX

## Agentes instalados (28)

| Nombre | Función | Tipo | YML en registry | Origen | Solapamientos conocidos |
|--------|---------|------|-----------------|--------|------------------------|
| agentic-reasoning | DEPRECATED — absorbido en deep-dive como Capa 7 (calibración epistémica) | analysis | agentic-reasoning.yml | manual | deep-dive (Capa 7) |
| agentic-validator | Valida código Python agentic contra catálogo AP-01..AP-39 | analysis | agentic-validator.yml | bootstrap | — |
| ba-coordinator | Coordinator BABOK — Business Analysis Body of Knowledge (6 knowledge areas) | coordinator | ba-coordinator.yml | manual | — |
| bpa-coordinator | Coordinator BPA — Business Process Analysis (As-Is → To-Be, 6 fases) | coordinator | bpa-coordinator.yml | manual | — |
| cp-coordinator | Coordinator CP — Consulting Process McKinsey/BCG (Issue Tree, MECE, 7 fases) | coordinator | cp-coordinator.yml | manual | — |
| deep-dive | Análisis adversarial de artefactos: documentos, código, arquitecturas, decisiones. Capa 7: calibración THYROX automática para artefactos WP | analysis | deep-dive.yml | manual | agentic-reasoning (absorbido) |
| deep-review | Análisis de cobertura entre fases consecutivas del WP; análisis de repos/docs externos | analysis | deep-review.yml | manual | pattern-harvester (trigger distinto) |
| diagrama-ishikawa | Análisis de causa raíz con diagramas Ishikawa (espina de pescado) | analysis | diagrama-ishikawa.yml | manual | — |
| dmaic-coordinator | Coordinator DMAIC — Six Sigma (Define/Measure/Analyze/Improve/Control, 5 fases) | coordinator | dmaic-coordinator.yml | manual | lean-coordinator (misma estructura DMAIC) |
| lean-coordinator | Coordinator Lean Six Sigma — eliminación de desperdicios (5 fases, VSM) | coordinator | lean-coordinator.yml | manual | dmaic-coordinator (estructura similar) |
| mysql-expert | Especialista MySQL: schema, queries, migrations, indexes, optimización | expert | mysql-expert.yml | bootstrap | postgresql-expert (misma estructura) |
| nodejs-expert | Especialista Node.js/Express: APIs REST, middlewares, npm | expert | nodejs-expert.yml | bootstrap | — |
| pattern-harvester | Extrae patrones accionables de corpus de deep-dive y calibración; mapea a componentes THYROX | analysis | pattern-harvester.yml | manual | deep-review (input distinto) |
| pdca-coordinator | Coordinator PDCA — ciclo Plan/Do/Check/Act (4 etapas) | coordinator | pdca-coordinator.yml | manual | — |
| pm-coordinator | Coordinator PMBOK — PMI project management (5 grupos de proceso) | coordinator | pm-coordinator.yml | manual | — |
| postgresql-expert | Especialista PostgreSQL: schema, queries, migrations, transactions | expert | postgresql-expert.yml | bootstrap | mysql-expert (misma estructura) |
| pps-coordinator | Coordinator PPS — Practical Problem Solving Toyota TBP (A3 Report, 6 fases) | coordinator | pps-coordinator.yml | manual | — |
| react-expert | Especialista React: hooks, componentes, gestión de estado, bundlers | expert | react-expert.yml | bootstrap | webpack-expert (bundling) |
| rm-coordinator | Coordinator RM — Requirements Management (elicitation, análisis, spec, validación) | coordinator | rm-coordinator.yml | manual | ba-coordinator (overlap en análisis de reqs) |
| rup-coordinator | Coordinator RUP — Rational Unified Process (4 fases iterativas, milestones LCO/LCA/IOC/PD) | coordinator | rup-coordinator.yml | manual | — |
| skill-generator | Genera archivos de skill/agente desde templates del registry para una tecnología | infra | skill-generator.yml | bootstrap | tech-detector (precede a skill-generator) |
| sp-coordinator | Coordinator SP — Strategic Planning (PESTEL/SWOT, BSC, OKRs, 8 fases) | coordinator | sp-coordinator.yml | manual | — |
| task-executor | Ejecuta tareas atómicas de un task-plan.md (T-NNN checkboxes) | general | task-executor.yml | bootstrap | task-planner (roles disjuntos: ejecutar vs planificar) |
| task-planner | Descompone trabajo nuevo en tareas T-NNN; nunca ejecuta | general | task-planner.yml | bootstrap | task-synthesizer (input distinto: fresh vs corpus) |
| task-synthesizer | Consolida outputs de análisis existentes (deep-dive, pattern-harvester) en task-plan | general | task-synthesizer.yml | manual | task-planner (trigger distinto: corpus vs scratch) |
| tech-detector | Detecta stack tecnológico del proyecto analizando configs, deps y estructura | infra | tech-detector.yml | bootstrap | skill-generator (orquestación secuencial) |
| thyrox-coordinator | Coordinator genérico THYROX — lee YAML dinámicamente, resuelve cualquier metodología registrada | coordinator | thyrox-coordinator.yml | manual | Todos los coordinators específicos |
| webpack-expert | Especialista Webpack: entry/output, loaders, plugins, code splitting, optimización | expert | webpack-expert.yml | bootstrap | react-expert (frontend stack) |

## Tipos de agente

| Tipo | Descripción | Agentes |
|------|-------------|---------|
| coordinator | Orquesta un proceso metodológico con pasos y tollgates formales. Lee metodología desde registry YAML | ba, bpa, cp, dmaic, lean, pdca, pm, pps, rm, rup, sp, thyrox-coordinator (12) |
| expert | Especialista en tecnología específica. Usa tools MCP de ejecución | mysql-expert, nodejs-expert, postgresql-expert, react-expert, webpack-expert (5) |
| analysis | Produce análisis de artefactos, corpus o fase-a-fase. Salida: archivo markdown de hallazgos | agentic-reasoning, agentic-validator, deep-dive, deep-review, diagrama-ishikawa, pattern-harvester (6) |
| infra | Infraestructura del sistema: detecta stack, genera skills | skill-generator, tech-detector (2) |
| general | Propósito general de planning/execution del ciclo de trabajo THYROX | task-executor, task-planner, task-synthesizer (3) |

## Estado del registry (YMLs)

Todos los 28 agentes instalados tienen YML en `.thyrox/registry/agents/`. Esta paridad fue alcanzada en ÉPICA 42.

| Origen | Agentes |
|--------|---------|
| **bootstrap** (generados por bootstrap.py) | agentic-validator, mysql-expert, nodejs-expert, postgresql-expert, react-expert, skill-generator, task-executor, task-planner, tech-detector, webpack-expert (10) |
| **manual** (artefactos estáticos con `installation: manual`) | agentic-reasoning, ba-coordinator, bpa-coordinator, cp-coordinator, deep-dive, deep-review, diagrama-ishikawa, dmaic-coordinator, lean-coordinator, pattern-harvester, pdca-coordinator, pm-coordinator, pps-coordinator, rm-coordinator, rup-coordinator, sp-coordinator, task-synthesizer, thyrox-coordinator (18) |

Ver: `adr-coordinators-static-artifacts.md` — por qué coordinators son artefactos estáticos y no se generan desde bootstrap.py.

## Detección de agentes zombies

Un agente zombie es un `.md` instalado sin invocación documentada en los últimos 3 WPs y con descripción obsoleta. Revisar en cada ÉPICA de mantenimiento.

**Criterios de zombie:**
1. `.md` instalado en `.claude/agents/`
2. Sin invocación documentada en los últimos 3 WPs (revisar `now.md` histórico y `git log`)
3. Descripción obsoleta o solapada completamente con otro agente

**Zombies actuales:**
| Agente | Estado | Razón |
|--------|--------|-------|
| agentic-reasoning | DEPRECATED — candidate for removal | Funcionalidad absorbida en deep-dive (Capa 7). Mantener hasta ÉPICA 43 para verificar que deep-dive cubre todos los casos de uso. |

**Proceso de cleanup:**
1. Identificar agente zombie
2. Verificar en los últimos 3 WPs: ¿fue invocado explícitamente?
3. Si no hay invocación: marcar DEPRECATED en el `.md`
4. En la siguiente ÉPICA de mantenimiento: eliminar si sigue sin uso

## Solapamientos conocidos entre agentes de análisis

| Par | Overlap | Distinción |
|-----|---------|------------|
| deep-dive / agentic-reasoning | Calibración de artefactos THYROX | deep-dive absorbe ambos roles desde ÉPICA 42. agentic-reasoning DEPRECATED |
| deep-review / pattern-harvester | Leen corpus de archivos WP | deep-review: cobertura fase-a-fase. pattern-harvester: síntesis de hallazgos de análisis previos |
| task-planner / task-synthesizer | Producen task-plan.md | task-planner: planning desde cero. task-synthesizer: consolida outputs de agentes previos |
| mysql-expert / postgresql-expert | Especialistas SQL relacionales | Motores distintos — no hay overlap real |
| react-expert / webpack-expert | Frontend stack | react-expert: componentes/estado. webpack-expert: bundling |

## Relaciones de orquestación

```
tech-detector → skill-generator           (detectar stack → generar skills)
task-planner  → task-executor             (planificar → ejecutar)
deep-dive     → pattern-harvester         (analizar corpus → extraer patrones)
pattern-harvester → task-synthesizer      (patrones → task-plan consolidado)
thyrox-coordinator ←→ {coordinadores específicos}  (fallback genérico vs. especializado)
```

## Referencias

- `adr-coordinators-static-artifacts.md` — por qué coordinators no se generan desde bootstrap.py
- `adr-python-mcp-manual-skill.md` — guideline python-mcp como artefacto manual
- `.thyrox/registry/agents/README.md` — spec del pipeline de generación de agentes
- `.claude/references/agent-spec.md` — spec formal de frontmatter de agentes
