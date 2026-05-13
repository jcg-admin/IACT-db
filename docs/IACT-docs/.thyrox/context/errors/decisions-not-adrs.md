```yml
id: ERR-020
created_at: 2026-03-28
type: Violación de proceso
severity: Alta
status: Detectado
```

# ERR-020: 9 decisiones arquitectónicas sin ADRs

## Qué pasó

Durante esta sesión se tomaron al menos 9 decisiones arquitectónicas significativas, documentadas dentro de solution-strategy files pero NO como ADRs formales en `context/decisions/`.

## Decisiones sin ADR

1. templates/ → assets/ (anatomía oficial)
2. ANALYZE primero (no PLAN)
3. Single skill con progressive disclosure
4. Git como única persistencia
5. Detect/convert/validate pattern
6. Fuente canónica + referencia (covariancia)
7. Adoptar conceptos de spec-kit, no copiar implementación
8. [NEEDS CLARIFICATION] en checklist (no script)
9. Double constitution check

## Impacto

No se puede buscar "¿por qué usamos assets/?" directamente. La decisión está enterrada en un archivo de strategy de 100+ líneas.

## Corrección propuesta

Crear ADRs para al menos las top 3 decisiones. Agregar gate en EXIT_CONDITIONS Phase 2: "ADRs creados para decisiones tomadas."
