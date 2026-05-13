```yml
id: ERR-005
created_at: 2026-03-28
type: Gap en el framework
severity: Media
status: Detectado
```

# ERR-005: Fases descritas pero no ejecutables

## Qué falta

SKILL.md tiene ~40 líneas por fase — suficiente para entender QUÉ es cada fase, pero no CÓMO ejecutarla paso a paso. Un usuario o Claude Code leyendo Phase 3: PLAN no sabe exactamente qué pasos seguir.

## Cómo lo resuelve spec-kit

spec-kit tiene un archivo de comando por fase (specify.md = 800+ líneas, plan.md = 600+, implement.md = 600+). Cada uno es una guía paso a paso con:
- Prerequisitos
- Pasos numerados
- Decision points
- Hooks pre/post
- Exit conditions

## Impacto en THYROX

Cada sesión de trabajo requiere que Claude Code "adivine" cómo ejecutar una fase. La calidad depende de la interpretación, no de instrucciones claras.

## Corrección propuesta

Crear command files por fase en references/ (como spec-kit's commands/):
- references/cmd-analyze.md
- references/cmd-plan.md
- references/cmd-execute.md
- etc.

SKILL.md enlaza a estos con 1 línea. Los command files tienen las instrucciones detalladas.
