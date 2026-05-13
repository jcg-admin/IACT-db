```yml
id: ERR-027
created_at: 2026-03-28
type: Gap en documentación
severity: Alta
status: Detectado
```

# ERR-027: No hay mapeo de cuándo se usa cada template

## Qué pasó

Tenemos 32 archivos en assets/ (templates) pero no hay documentación de:

1. CUÁNDO se usa cada template (qué fase, qué trigger)
2. QUIÉN lo invoca (el humano lo copia, Claude lo lee, un script lo procesa)
3. CÓMO se usa (copiar y llenar, copiar y renombrar, referenciar)
4. Si todos se usan realmente o algunos son legacy

Los templates incluyen:
- 8 templates de Phase 1 (introduction, requirements-analysis, etc.)
- 7 templates de commits (bugfix, feature, refactor, etc.)
- 5 templates de proceso (EXIT_CONDITIONS, constitution, epic, etc.)
- 4 templates de corrección incremental (analysis-phase, categorization-plan, etc.)
- 3 templates de Phase 4 (design, tasks, requirements-specification)
- 2 templates de tracking (AD_HOC_TASKS, REFACTORS)
- 2 templates generales (document, adr)
- 1 template de proyecto (project.json)

## Impacto

Sin este mapeo, Claude no sabe cuándo sugerir un template. El SKILL.md menciona algunos (spec-quality-checklist, EXIT_CONDITIONS) pero no todos.

## Qué hacer

Crear un mapeo template → fase → trigger → cómo se usa.
