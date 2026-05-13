```yml
id: ERR-029
created_at: 2026-03-28
phase: Phase 2 (SOLUTION_STRATEGY)
severity: media
recurrence: primera
```

# ERR-029: Phase 2 ejecutada sin seguir la estructura de solution-strategy.md

## Qué pasó

Al hacer la Phase 2 para las 5 correcciones del SKILL (grokputer analysis), escribí un spec.md con solo "Alternativas" y "Decisión" por corrección — como una tabla rápida. Omití:

1. **Key Ideas** — No definí los conceptos centrales
2. **Research Step** — No listé unknowns ni investigué alternativas con pros/cons formales
3. **Fundamental Decisions** — No usé el formato Alternatives/Justification/Implications
4. **Tech Stack** — No documenté qué herramientas se usan
5. **Patterns** — No identifiqué patrones arquitectónicos
6. **Quality Goals mapping** — No mapeé cómo las decisiones logran los quality goals
7. **Pre-design check** — No verifiqué principios antes de decidir
8. **Post-design re-check** — No re-verifiqué después de decidir

## Por qué

Prioridad en velocidad sobre rigor. Traté Phase 2 como "tomar decisiones rápidas" en vez de "investigar antes de decidir" que es lo que el SKILL define. Esto es exactamente el anti-pattern que Phase 2 existe para prevenir: **decisiones sin evidencia documentada.**

Irónicamente, la reference `solution-strategy.md` tiene una estructura clara de 5 secciones + research step que yo mismo ayudé a diseñar, y no la seguí.

## Prevención

Antes de escribir un spec.md de Phase 2, **leer** `references/solution-strategy.md` y verificar que el documento tiene las 5 secciones: Key Ideas, Fundamental Decisions, Tech Stack, Patterns, Quality Goals. Además el Research Step con unknowns y los pre/post design checks.

**Posible enforcement:** Agregar check en `validate-phase-readiness.sh` para Phase 2: verificar que spec.md contiene headers "Key Ideas", "Fundamental Decisions", "Research Step".

## Insight

Cuando diseñas un framework de fases, el riesgo más grande es que TÚ MISMO no sigas tus propias fases. Si el creador del SKILL se salta la estructura de Phase 2, los usuarios del template también lo harán. La solución no es más documentación — es que el SKILL referencie explícitamente la structure de solution-strategy.md en Phase 2.
