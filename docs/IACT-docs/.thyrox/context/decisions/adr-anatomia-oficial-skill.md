```yml
id: ADR-011
Título: Anatomía oficial de Anthropic para el skill
created_at: 2026-03-27
status: Aprobado
```

# ADR-011: Anatomía oficial de Anthropic para el skill

## Contexto

THYROX tenía templates/ para assets, tracking/ para AD_HOC_TASKS, utils/ para scripts y reportes, epics/ con ejemplos, y archivos sueltos en context/. No seguía ningún estándar.

## Decisión

Seguir la anatomía oficial de Anthropic:

```
pm-thyrox/
├── SKILL.md       ← Instrucciones (≤500 líneas)
├── scripts/       ← Código ejecutable (no se carga en contexto)
├── references/    ← Documentación cargada bajo demanda
└── assets/        ← Archivos usados en output (templates)
```

- **scripts/**: Token efficient, deterministic, ejecutable sin cargar en contexto
- **references/**: Documentación que Claude lee cuando la necesita
- **assets/**: Templates que se copian al output, no se cargan en contexto

## Alternativas consideradas

- **Estructura libre (como ADT):** 15 skills separados, cada uno con su estructura. Rechazado por fragmentación.
- **Estructura propia de THYROX:** templates/ + tracking/ + utils/. Rechazado por no ser estándar.

## Consecuencias

- templates/ renombrado a assets/
- tracking/ movido a assets/ como .template files
- utils/ eliminado, scripts movidos a pm-thyrox/scripts/
- Root scripts/ consolidado en pm-thyrox/scripts/
- Zero carpetas ad-hoc
