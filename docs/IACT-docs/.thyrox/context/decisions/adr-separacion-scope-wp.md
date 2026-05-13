```yml
type: ADR
id: ADR-014
title: Separación de scope y dependencia entre WP agent-format-spec y WP parallel-agent-conventions
status: Aprobado
created_at: 2026-04-07 03:08:03
work_package: coordinación entre 2026-04-07-03-08-03-agent-format-spec y 2026-04-07-03-08-03-parallel-agent-conventions
```

# ADR-014: Separación de Scope y Dependencia entre WP agent-format-spec y WP parallel-agent-conventions

## Contexto

Los dos WPs fueron creados en el mismo segundo (`2026-04-07-03-08-03`) y ejecutados en paralelo como experimento de dogfooding. Durante Phase 1 ANALYZE, el agente de `agent-format-spec` detectó un scope collision: WP-1 (`parallel-agent-conventions`) planea modificar `.claude/agents/task-executor.md` y `.claude/agents/task-planner.md` para agregar protocolo de claim, mientras WP-2 (`agent-format-spec`) es el dueño de la especificación formal de formato de todos los archivos en `.claude/agents/`.

Este ADR documenta la resolución de ese collision y establece la dependencia explícita entre ambos WPs.

## Decisión

### Límites de scope (no modificar sin aprobación)

#### WP-2: agent-format-spec — SCOPE EXCLUSIVO

| Artefacto | Tipo de cambio |
|-----------|----------------|
| Spec formal de campos (`references/agent-spec.md`) | CREAR |
| Linter script (`scripts/lint-agents.py`) | CREAR |
| Reference SKILL vs Agente (`references/skill-vs-agent.md`) | CREAR |
| Corrección `nodejs-expert.md` y `react-expert.md` | MODIFICAR |
| Actualización del generador `skill-generator.md` (quitar `model`) | MODIFICAR |
| Convención de naming de agentes | DOCUMENTAR |

#### WP-1: parallel-agent-conventions — SCOPE EXCLUSIVO

| Artefacto | Tipo de cambio |
|-----------|----------------|
| Patrón `now-{agent-id}.md` | DOCUMENTAR + convención |
| Estado `[~]` (in-progress) en task-plan | DOCUMENTAR + template |
| Protocolo de escritura en `ROADMAP.md` con múltiples agentes | DOCUMENTAR |
| Namespacing de ADRs por capa | DOCUMENTAR |
| Protocolo de handoff de sesión | DOCUMENTAR |
| Unicidad de IDs de WP (colisión de timestamps) | DOCUMENTAR |

#### Zona de intersección — requiere secuenciación

| Artefacto | Quién modifica | Condición |
|-----------|----------------|-----------|
| `.claude/agents/task-executor.md` (claim protocol) | WP-1 | **DESPUÉS** de que WP-2 apruebe la spec formal |
| `.claude/agents/task-planner.md` (awareness de claims) | WP-1 | **DESPUÉS** de que WP-2 apruebe la spec formal |
| `SKILL.md` | Ambos, en secciones distintas | WP-2 agrega Phase 1-2 (agent guidance); WP-1 agrega Phase 5-6 (parallel conventions) |
| `references/conventions.md` | Ambos, en secciones distintas | WP-2 agrega "Agent Format"; WP-1 agrega "Parallel Execution" |
| `assets/tasks.md.template` | WP-1 únicamente | Agrega estado `[~]`, no modifica campos de agentes |

### Dependencia explícita

```
WP-2 (agent-format-spec)
  └── Phase 2-6: Spec formal + linter
        └── Aprobación de spec por usuario
              └── WP-1 puede modificar archivos en .claude/agents/
```

**WP-1 puede ejecutar fases 1-5 (ANALYZE → DECOMPOSE) en paralelo con WP-2 sin restricciones.**
**WP-1 NO puede ejecutar tareas que modifiquen `.claude/agents/*.md` hasta que WP-2 complete su spec.**

### Regla de coordinación para SKILL.md y conventions.md

Cada WP anota su sección en el documento con un comentario de ownership:

```markdown
<!-- SECTION OWNER: agent-format-spec -->
...contenido...
<!-- END SECTION: agent-format-spec -->
```

Esto permite que ambos WPs editen el mismo archivo sin pisarse, y el agente coordinador (o el usuario) puede fusionar las secciones al final.

## Consecuencias

**Positivas:**
- Elimina el riesgo de specs divergentes sobre formato de agentes
- Permite que WP-1 avance en paralelo hasta el punto de dependencia
- El collision observado en dogfooding queda documentado como evidencia para WP-1 (GAP sobre coordinación inter-WP)

**Negativas:**
- WP-1 tiene un gate de espera sobre WP-2 para las tareas de modificación de agentes
- Introduce el concepto de "section ownership" en documentos compartidos — convención nueva que no existía

## Evidencia del collision

Detectado en Phase 1 ANALYZE por el agente de `agent-format-spec` (Fricción 3):

> "El WP `parallel-agent-conventions` tiene un nombre que sugiere que también trata sobre convenciones de agentes — posible overlap directo con este WP. Sin coordinación previa, ambos agentes pueden producir specs distintas para el mismo problema."

Y documentado independientemente por el agente de `parallel-agent-conventions` como ausencia de mecanismo de descubrimiento de pares (Observación 4):

> "Este agente no tiene forma de saber si el agente ejecutando `agent-format-spec` está activo, en qué fase está, o si ya terminó."
