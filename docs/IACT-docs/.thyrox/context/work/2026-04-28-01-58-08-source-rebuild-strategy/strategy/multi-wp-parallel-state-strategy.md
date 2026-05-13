```yml
created_at: 2026-04-28 05:05:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 6 — PLAN (artefacto de soporte — gap metodológico)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Estrategia de state files con WPs/agentes en paralelo

## Problema observado (2026-04-28 05:01)

Al crear `ARCHIVED.md` en el WP `github-actions-phase2-testing`,
`now.md::current_work` se cambió automáticamente a ese WP — pero
el WP activo real seguía siendo `source-rebuild-strategy`.

**Causa raíz:** el hook `.claude/scripts/sync-wp-state.sh`
(PostToolUse Write) actualiza `current_work` cada vez que se
escribe cualquier archivo en `.thyrox/context/work/*/`, sin
distinguir entre:

- Trabajo activo en un WP (debería actualizar)
- Archivado de un WP histórico (NO debería actualizar)
- Cross-referencias / linking entre WPs (NO debería actualizar)
- Spawning de WPs hijos (depende del workflow)

## Escenarios donde el modelo actual falla

### S1 — Archivado retroactivo (caso reproducido hoy)

Trabajando en WP-A, se crea `ARCHIVED.md` para WP-B.
Resultado actual: `current_work` apunta a WP-B incorrectamente.
Resultado deseado: `current_work` sigue en WP-A.

### S2 — Spawning de WPs hijos

WP-padre `source-rebuild-strategy` planea spawnear 16 WPs-hijos.
La creación inicial del `wp-state.md` de cada hijo (scaffolding)
no implica que el orquestador "se mueve" a ese hijo.
Resultado actual: cada `wp-state.md` creado mueve `current_work`.
Resultado deseado: `current_work` sigue en padre hasta decisión
explícita.

### S3 — Agentes en paralelo escribiendo a distintos WPs

5 agentes lanzados en paralelo (deep-review, gate-evaluators,
task-executors) escriben a `now-{agent}.md` o a artefactos de
WPs distintos. Cada Write dispara el hook → race condition,
último gana, valor final no determinístico.
Resultado deseado: agentes no afectan `current_work` del
orquestador.

### S4 — Múltiples branches activas en paralelo

Dev tiene 3 worktrees: `feature/wp-A`, `feature/wp-B`,
`feature/wp-C`. Cada branch tiene su propio `now.md` committeado
en ese branch. Conceptualmente esto YA funciona (git resuelve
naturalmente). El gap está en si los hooks asumen 1 single
session.

## Convención existente parcial

`.claude/references/parallel-agent-state-files.md` ya define:

- Orquestador / estado compartido → `now.md`
- Agente nativo en ejecución → `now-{agent-name}.md`
- Skill especializado → `now-{skill-name}-{wp-id}.md`
- Gate evaluador → `gate-{stage}-eval-{n}.json`
- Gate Merger output → `gate-{stage}-merged.json`

Pero el hook `sync-wp-state.sh` **viola esta convención** al
actualizar `now.md` desde escrituras que no son del orquestador.

## Propuesta de convención (v1)

### Principio rector

**`now.md::current_work` se actualiza SOLO cuando el orquestador
declara explícitamente foco en un WP**, no como side-effect de
escrituras.

### Fuentes de verdad por nivel

| Nivel | Fuente de verdad | Quién la actualiza |
|-------|------------------|---------------------|
| **Branch activo** | `git rev-parse --abbrev-ref HEAD` | git |
| **WP activo del branch** | `now.md::current_work` (committeado en el branch) | Orquestador con intención explícita |
| **Estado por agente** | `now-{agent-name}.md` | Cada agente |
| **Estado por skill** | `now-{skill-name}-{wp-id}.md` | Cada skill |
| **Coordinación de gates** | `gate-{stage}-*.json` | Evaluadores + Merger |

### Reglas de actualización del hook `sync-wp-state.sh`

Reemplazar el comportamiento actual ("update on any write") por:

1. **Scope por filename**: actualizar `current_work` SOLO si el
   archivo escrito es `wp-state.md` Y NO es un archivo de cierre
   (`ARCHIVED.md`, `CLOSURE-NOTICE.md`).
2. **Scope por agente**: si el caller es un sub-agente (no el
   orquestador principal), no tocar `now.md`. Cada agente usa
   su `now-{agent}.md`.
3. **Verificación de intención**: opcionalmente, exigir un
   marker en el archivo escrito (ej: `wp-state.md` con campo
   `current_phase != "Archivado"`).

### Multi-branch / multi-worktree

**No requiere tooling adicional.** Cada branch tiene su propio
`now.md` committeado:

- Switch de branch → git checkout → now.md cambia automáticamente
  al estado del branch.
- Worktree paralelo (`git worktree add`) → cada worktree tiene
  su propio working directory con su `now.md`.
- Conflicto al merge → resolverlo es decisión consciente del dev.

### Multi-WP en mismo branch (caso raro)

Si en una sesión el orquestador trabaja en WP-A pero necesita
crear/modificar artefactos en WP-B (ej: handoff cross-WP, archivado
retroactivo, scaffolding de hijo), `current_work` permanece en
WP-A. El hook debe permitir esto.

Para el caso de querer "mover el foco" a WP-B explícitamente,
usar `bash .claude/scripts/update-state.sh <wp-path>` (script
existente) o editar `now.md` directamente.

### Multi-agentes en paralelo

Cada agente:
- Escribe en `now-{agent-name}.md` (NO en now.md)
- No requiere coordinación cross-agent vía now.md
- El orquestador consume los outputs vía agent return values o
  archivos de gate (`gate-*.json`)

El hook actual viola esto si el agente escribe en un WP — la
solución es excluir agentes del trigger del hook (ver "Reglas
de actualización del hook").

## Acciones recomendadas

### A1 — Inmediato (este WP)

- [x] Corregir `now.md::current_work` manualmente al WP activo
  (`source-rebuild-strategy`).
- [x] Documentar la propuesta (este documento).

### A2 — Spinoff a `bootstrap-hardening` (WP existente)

Ese WP ya cubre mejoras al pipeline del repo. Agregar como
F-NEW-9:

- Modificar `.claude/scripts/sync-wp-state.sh` para implementar
  las "Reglas de actualización del hook":
  - Excluir `ARCHIVED.md`, `CLOSURE-NOTICE.md`, `WP-STATE-FUTURE.md`
  - Solo actualizar si el archivo escrito es `wp-state.md` con
    `current_phase` distinto de archivado
  - Detectar invocaciones desde sub-agentes (si hay forma) y
    abortar
- Test de regresión: reproducir S1 (escribir ARCHIVED.md de WP-B
  desde WP-A) y verificar que `current_work` no cambia.

### A3 — Mejora de SKILL (futuro)

Formalizar la convención propuesta en
`.claude/references/parallel-agent-state-files.md`:

- Agregar sección "Reglas de actualización de `now.md`".
- Agregar sección "Multi-branch / multi-worktree".
- Agregar sección "Multi-WP en mismo branch".

## Resumen de la respuesta al ejecutor

> "¿qué estrategia se va a usar si se puede trabajar con {1...x}
> ramas, y si existen muchos WPs lanzados en paralelo como agentes?"

| Situación | Estrategia |
|-----------|------------|
| 1 branch + 1 WP activo (caso normal) | `now.md::current_work` apunta al WP. Hook actualiza solo en cambios a `wp-state.md`. |
| N branches en paralelo (worktrees) | Cada branch tiene su propio `now.md` committeado. Git resuelve. Sin tooling extra. |
| 1 branch + N WPs tocados (cross-ref, archive) | `current_work` permanece en el WP de foco. Tocar otros no lo cambia. |
| N agentes en paralelo | Cada agente escribe en `now-{agent}.md`. `now.md` del orquestador no se toca. |
| Spawning de WPs hijos | `current_work` permanece en padre hasta decisión explícita de mover foco. |

**Bug actual del hook** rompe los casos 3, 4 y 5 — corregir en
`bootstrap-hardening` WP como F-NEW-9.
