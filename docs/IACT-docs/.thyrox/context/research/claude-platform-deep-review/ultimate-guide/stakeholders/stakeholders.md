---
type: Deep-Review Domain Analysis
created_at: 2026-04-14 00:00:00
source: /tmp/reference/claude-code-ultimate-guide
domain: stakeholders
repo: claude-code-ultimate-guide
---

# Stakeholders: Hallazgos de claude-code-ultimate-guide

## Patrones identificados

### Patrón 1 — Roles diferenciados con rutas de aprendizaje específicas
**Descripción:** El repositorio define paths de lectura distintos: Tech Lead/EM (Ch.3.5 → Ch.9.17 → Ch.9.20 → Ch.11), CTO/Decision Maker (ROI, security posture, team adoption), CIO/CEO (Budget, risk, 3 min), PM/Designer (vibe coding), Developer (guía completa).
**Fuente:** README.md:56-64
**Relevancia:** Alta

### Patrón 2 — Nuevos roles de ingeniería emergentes
**Descripción:** El repositorio documenta 16 nuevos roles: Prompt Engineer, Context Engineer, AI Engineer, LLM Engineer, AI Agent Engineer, Founding AI Engineer, AI Architect, Platform Engineer (AI context), Harness Engineer, AI PM, AI Safety & Eval Engineer, ML Engineer, MLOps Engineer, AI Developer Advocate, AI Orchestration Engineer.
**Fuente:** guide/roles/ai-roles.md:1-60
**Relevancia:** Alta

### Patrón 3 — Context Engineer como rol emergente clave
**Descripción:** Context Engineer es identificado como "uno de los más rápidos en crecer en 2025". El rol diseña sistemas que dan a los modelos la información correcta en el momento correcto. Cita directa a Andrej Karpathy ("Context engineering is the art of filling the context window with the right information at the right time") y Philipp Schmid de Google.
**Fuente:** guide/roles/ai-roles.md:100-135
**Relevancia:** Alta

### Patrón 4 — Harness Engineer: rol de infraestructura de evaluación
**Descripción:** El repositorio introduce el término "Harness Engineer" para el rol que construye infraestructura de testing/evaluación para agentes AI. Distinto del AI Safety Engineer. Rol emergente en organizaciones con pipelines de agentes complejos.
**Fuente:** core/glossary.md:73 ("Eval harness")
**Relevancia:** Media

### Patrón 5 — Datos de adopción empresarial (Anthropic 2026)
**Descripción:** 5000+ organizaciones en el estudio. Fases de adopción: Pilot (1-2 meses, 60-70% éxito), Expansion (3-4 meses, 75-85%), Production (5-6 meses, 85-90%). Factores críticos: arquitectura modular, tests comprehensivos, descomposición clara de tareas.
**Fuente:** guide/workflows/agent-teams.md:87-97
**Relevancia:** Media

### Patrón 6 — Anthropic AI Fluency Index: el "Artifact Paradox"
**Descripción:** Investigación de Anthropic (2026): usuarios que producen artefactos AI son menos propensos a cuestionar el razonamiento detrás de ellos. Riesgo de "comprehension debt" y "verification paradox" en adopción masiva.
**Fuente:** core/glossary.md:34-35
**Relevancia:** Media

## Conceptos clave

- Cada rol tiene un path de lectura distinto en la guía
- Context Engineer como nueva disciplina de ingeniería (no solo "alguien que escribe prompts")
- Comprehension debt: brecha entre código AI producido y comprensión real del desarrollador
- La gobernanza empresarial requiere definir quién aprueba MCP servers, quién puede usar qué features

## Notas adicionales

El repositorio tiene documentos específicos para stakeholders no-técnicos: docs/for-cto.md, docs/for-cio-ceo.md, docs/for-tech-leads.md, docs/for-product-managers.md. Para escritores/ops hay una guía separada: claude-cowork-guide.

Salary benchmarks 2025-2026 disponibles en guide/roles/ai-roles.md:sección 18.
