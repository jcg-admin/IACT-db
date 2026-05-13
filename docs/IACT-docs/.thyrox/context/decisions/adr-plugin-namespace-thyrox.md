```yml
type: ADR
id: ADR-019
title: Namespace /thyrox:* mediante Claude Code Plugin (Opción D)
status: Accepted
accepted_at: 2026-04-11
created_at: 2026-04-11
work_package: 2026-04-11-10-52-25-thyrox-commands-namespace
depends_on: ADR-016
```

# ADR-019: Namespace /thyrox:* mediante Claude Code Plugin (Opción D)

## Contexto

THYROX expone sus 7 fases SDLC más el comando de inicialización a través de 8 comandos slash. Hasta FASE 31, el namespace de invocación es `/workflow-analyze`, `/workflow-strategy`, … — un prefijo `workflow-` que:

1. Colisiona potencialmente con cualquier proyecto que tenga comandos propios con ese prefijo.
2. No está agrupado bajo un namespace único identificable en el menú `/` de Claude Code.
3. Dificulta la distribución del framework: instalar THYROX en otro proyecto requiere copiar y adaptar 8 comandos sueltos sin un mecanismo de empaquetado.

Claude Code soporta un mecanismo de Plugin: un repositorio con `.claude-plugin/plugin.json` y un directorio `commands/` puede exponer comandos bajo el namespace `/plugin-name:command`. El separador `:` es exclusivo de este mecanismo — no existe otra forma de lograr ese formato en comandos slash.

El constraint arquitectónico de Locked Decision #5 ("Single skill") ya tiene un addendum (ADR-016) que permite los 7 `workflow-*` skills como excepción intencional de herramientas por fase. La presente decisión no modifica la implementación existente — agrega una capa de interfaz sobre ella.

## Decisión

Implementar un **Claude Code Plugin** en el repositorio THYROX para exponer el namespace `/thyrox:*`.

**Estructura nueva (mínima, aditiva):**

```
.claude-plugin/
└── plugin.json          ← manifest del plugin
commands/
├── analyze.md           ← invoca workflow-analyze
├── strategy.md          ← invoca workflow-strategy
├── plan.md              ← invoca workflow-plan
├── structure.md         ← invoca workflow-structure
├── decompose.md         ← invoca workflow-decompose
├── execute.md           ← invoca workflow-execute
├── track.md             ← invoca workflow-track
└── init.md              ← invoca workflow_init
```

**Lo que NO cambia:**

- `.claude/skills/workflow-*/SKILL.md` — sin modificaciones. Son la implementación; el plugin es la interfaz.
- `.claude/scripts/session-start.sh` — actualización de strings `/workflow-analyze` → `/thyrox:analyze` únicamente (no cambio funcional).
- Cualquier archivo de proyecto bootstrapped con THYROX — sin impacto.

**Alternativas descartadas:**

| Opción | Motivo de descarte |
|--------|-------------------|
| A: Renombrar skills a `thyrox-*/SKILL.md` | Namespace `:` no se obtiene — resultado sería `/thyrox-analyze`, sin separador |
| B: Comandos alias en `.claude/commands/` | Cuando skill y comando comparten nombre, el skill gana. Arquitectónicamente inviable. |
| C: Renombrar directorios `workflow-*` → `thyrox-*` | Rompe proyectos bootstrapped con THYROX. R-06 (cerrado). |
| D: Plugin | Única vía para obtener `/thyrox:*`. Aditiva, no destructiva. Elegida. |

## Consecuencias

### Positivas

1. **Namespace propio y limpio**: `/thyrox:analyze`, `/thyrox:strategy`, … aparecen agrupados en el menú `/` bajo el prefijo `thyrox`.
2. **Distribución como plugin**: El repositorio THYROX puede instalarse en otros proyectos como plugin de Claude Code, sin copiar archivos manualmente.
3. **Cero regresión**: Los `workflow-*` skills internos no se tocan; proyectos existentes no se afectan.
4. **Implementación mínima**: 9 archivos nuevos (1 JSON + 8 Markdown) y 1 script actualizado.

### Negativas / trade-offs

1. **Doble interfaz transitoria**: Durante FASE 31, ambas interfaces coexisten (`/workflow-analyze` sigue disponible internamente). Se documenta como estado transitorio aceptado.
2. **Autodescubrimiento no verificado**: No se ha confirmado si Claude Code auto-detecta `.claude-plugin/plugin.json` en el proyecto actual o requiere invocación explícita. La estructura se implementa de forma agnóstica — funciona con o sin autodescubrimiento una vez que el mecanismo esté disponible.
3. **ADR-016 requiere amendment**: La Locked Decision #5 documenta los `workflow-*` como excepción. El addendum de este ADR debe reflejar que `/thyrox:*` es la interfaz pública y `workflow-*` es la implementación interna.

## Amendment a ADR-016

ADR-016 aprobó los 7 `workflow-*` como excepción a "Single skill" para herramientas de ejecución por fase. Este ADR agrega el siguiente addendum:

> **Addendum FASE 31 (ADR-019):** La interfaz pública del framework es `/thyrox:*` (plugin namespace). Los skills `workflow-*` son implementación interna — no se exponen directamente al usuario final en contextos de distribución. Esta separación interfaz/implementación no contradice ADR-016; lo complementa definiendo la capa de presentación.
