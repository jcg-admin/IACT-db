```yml
type: Índice de Patrones
version: 1.1
created_at: 2026-04-14 20:34:23
updated_at: 2026-04-14 21:30:00
```

# Patrones — Índice Global

Soluciones que funcionaron y se repiten. Un patrón se formaliza cuando
ha sido aplicado ≥2 veces o cuando tiene impacto estratégico en el proyecto.

---

## Índice

### IACT-docs Specific Patterns (P-001 a P-003)

| ID | Archivo | Nombre | Problema que resuelve | Fecha |
|-----|---------|--------|----------|-------|
| P-001 | [validate-wire-test](validate-wire-test.md) | Validate-Wire-Test | Script creado sin conectar al sistema | 2026-04-14 |
| P-002 | [bound-explicito-agente](bound-explicito-agente.md) | Bound Explícito en Agentes | Instrucciones ilimitadas causan timeouts | 2026-04-14 |
| P-003 | [git-mv-migracion](git-mv-migracion.md) | git mv para Migraciones | Mover archivos sin perder historial | 2026-04-14 |

### Legacy Framework Patterns (P-004 a P-009) — Migrado desde .thyrox/discover/patterns/

| ID | Archivo | Nombre | Problema que resuelve | Categoría | Fecha |
|-----|---------|--------|----------|-----------|-------|
| P-004 | [adk-model-callback-contract](adk-model-callback-contract.md) | ADK Model Callback Contract | Retorno None en callbacks pierde mutaciones | ADK | 2026-04-23 |
| P-005 | [adk-tool-callback-contract](adk-tool-callback-contract.md) | ADK Tool Callback Context | Tipo incorrecto de contexto en tool callbacks | ADK | 2026-04-23 |
| P-006 | [hitl-blocking-loop](hitl-blocking-loop.md) | HITL Blocking Loop | HITL decorativo que no bloquea ejecución | HITL | 2026-04-23 |
| P-007 | [hitl-interrupt-resume](hitl-interrupt-resume.md) | HITL Interrupt/Resume | Interrupción sin mecanismo de reanudación | HITL | 2026-04-23 |
| P-008 | [langchain-imports-correct](langchain-imports-correct.md) | LangChain Imports Correctos | Importaciones desde módulos incorrectos | LangChain | 2026-04-23 |
| P-009 | [named-mechanism-vs-implementation](named-mechanism-vs-implementation.md) | Named Mechanism vs Implementation | Nombres prometen mecanismos que no existen | Arquitectura | 2026-04-23 |

---

## Cuándo Crear un Patrón

| Momento | Acción | Criterio |
|---------|--------|----------|
| Phase 6: EXECUTE | Detectar recurrencia | Si la misma solución se aplica por segunda vez en contextos distintos → documentar patrón |
| Phase 7: TRACK | Formalizar al cerrar WP | Si una solución fue clave para el WP y tiene potencial de reutilización |

## Cómo Crear un Patrón

Un patrón se crea cuando:
1. Una solución funcionó bien y podría aplicarse en futuros WPs
2. Se repitió ≥2 veces en distintos contextos (o tiene impacto estratégico)
3. Es lo suficientemente específico para ser accionable (no "escribir buen código")

Pasos:
1. Crear `{nombre-del-patron}.md` (kebab-case, sin números, auto-explicativo)
   usando el template: `.claude/skills/workflow-track/assets/pattern.md.template`
2. Agregar al índice de este README
3. Si hay lección origen, referenciarla en el patrón

**Naming:** El nombre del archivo describe la solución (no el problema).
Los `id: P-NNN` son referencias internas documentales, no nombres de archivo.
