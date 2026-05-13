---
title: Meta-framework Orchestration — 4-layer architecture
date: 2026-04-17
status: Accepted
deciders: NestorMonroy
context: ÉPICA 40 multi-methodology
---

# ADR: Meta-framework Orchestration Architecture

## Contexto

THYROX necesitaba un mecanismo para orquestar 11 coordinators de metodología distintos sin acoplamiento directo entre ellos. El problema: ¿cómo selecciona el usuario el coordinator correcto? ¿cómo saben los coordinators qué artefactos produjeron otros coordinators?

## Decisión

Arquitectura de 4 capas independientes y componibles:

**Capa 1 — Intake diagnóstico (`thyrox-coordinator`)**
5 preguntas cerradas (tipo de trabajo, foco, audiencia, horizonte, herramientas) que producen una recomendación determinística de coordinator. No requiere conocimiento previo del usuario sobre las metodologías.

**Capa 2 — Routing table (`routing-rules.yml`)**
Mapeo explícito problema→coordinator con `trigger_keywords` y `conflict_resolution`. Permite actualizar el routing sin modificar el coordinator genérico. Separación de "qué decide" (thyrox-coordinator) de "cómo se decide" (routing-rules.yml).

**Capa 3 — Artifact-ready signals (coordinators)**
Al cerrar, cada coordinator emite un bloque estructurado:
```
[{flow}-coordinator COMPLETED]
Artifacts produced: ...
Summary: ...
Ready for: Stage 11 TRACK/EVALUATE
```
Más: actualiza `now.md::coordinators.{name}.status = completed`.
Permite coordinación inter-coordinator sin acoplamiento directo.

**Capa 4 — Coordinator tracking (`now.md::coordinators`)**
Campo `coordinators: {}` en `now.md` para tracking multi-coordinator simultáneo. Formato documentado en HTML comment en el propio now.md.

## Consecuencias

**Positivas:**
- Añadir un nuevo coordinator (nueva metodología) solo requiere: YAML en registry + coordinator agent + entrada en routing-rules.yml. Sin modificar thyrox-coordinator.
- El routing es auditable y versionado (routing-rules.yml en git).
- Los artifact-ready signals son compatibles con el `artifact-registry.md.template` para coordinación multi-coordinator.

**Negativas / trade-offs:**
- 3 archivos distintos deben mantenerse consistentes al agregar un coordinator (YAML + agent + routing-rules).
- El campo `coordinators:` en now.md crece indefinidamente si no se limpia entre WPs. Mitigación: `close-wp.sh` resetea el campo a `{}`.

## Alternativas descartadas

- **Coordinator único monolítico**: no escala a 11 metodologías — el contexto del coordinator se satura.
- **Auto-detección por LLM**: probabilístico, no determinístico. El routing-rules.yml garantiza consistencia entre sesiones.
