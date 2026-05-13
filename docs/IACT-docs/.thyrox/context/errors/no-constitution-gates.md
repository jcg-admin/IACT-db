```yml
id: ERR-004
created_at: 2026-03-28
type: Gap en el framework
severity: Alta
status: Detectado
```

# ERR-004: Sin constitution ni gates de enforcement

## Qué falta

THYROX tiene principios arquitectónicos (solution-strategy.md) pero no hay mecanismo que los aplique. Se pueden violar sin consecuencia.

## Cómo lo resuelve spec-kit

spec-kit tiene:
- `memory/constitution.md` — principios inmutables del proyecto
- Phase -1 gates en plan-template.md que BLOQUEAN si hay violaciones
- "Complexity Tracking" que obliga a justificar excepciones

## Impacto en THYROX

Se puede agregar complejidad innecesaria, usar tecnologías no justificadas, o ignorar constraints sin que nadie lo detecte.

## Corrección propuesta

Crear `assets/constitution.md.template` y agregar gates a EXIT_CONDITIONS.md.template que verifiquen cumplimiento de principios antes de avanzar de fase.
