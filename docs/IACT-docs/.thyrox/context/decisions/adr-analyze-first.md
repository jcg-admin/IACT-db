```yml
id: ADR-010
Título: ANALYZE primero, siempre
created_at: 2026-03-27
status: Aprobado
```

# ADR-010: ANALYZE primero, siempre

## Contexto

THYROX tenía 3 órdenes de fases diferentes: SKILL.md decía ANALYZE primero, project-state.md decía PLAN primero, y la tabla de comandos tenía otro orden. Necesitábamos definir cuál es correcto.

## Decisión

Phase 1 es siempre ANALYZE. El orden canónico es:

```
ANALYZE → SOLUTION_STRATEGY → PLAN → STRUCTURE → DECOMPOSE → EXECUTE → TRACK
```

No se puede planificar lo que no se entiende. PLAN sin ANALYZE es "vibe-driven."

## Alternativas consideradas

- **PLAN primero:** Más intuitivo ("primero decides qué hacer"). Rechazado porque lleva a planes sin fundamento.
- **Flexible (cada proyecto decide):** Crea inconsistencia. Rechazado por romper covariancia.

## Consecuencias

- Todas las referencias en 9+ archivos deben usar el mismo orden
- Phase 1 siempre produce análisis antes de que se tome cualquier decisión
- Para proyectos pequeños (<2h) se pueden saltar fases 3-5, pero ANALYZE sigue siendo primero
