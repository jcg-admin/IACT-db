```yml
type: Reference
title: Modelo de Permisos — Gates de decision vs permisos de herramienta
category: Cross-phase
version: 1.0
created_at: 2026-04-09
work_package: 2026-04-09-10-25-55-write-gates
owner: thyrox (cross-phase)
purpose: Explicar los dos planos de aprobacion del sistema THYROX y la configuracion vigente de settings.json
```

# Modelo de Permisos — Gates de decision vs permisos de herramienta

El sistema THYROX opera en dos planos de aprobacion independientes. Cada uno tiene una funcion
distinta. Configurarlos juntos es lo que elimina la friccion innecesaria sin sacrificar seguridad.

---

## Los dos planos

### Plano A — Gates de decision del SKILL (metodologico)

Puntos donde el **humano decide si continuar**. Definidos en `workflow-*/SKILL.md` como `STOP`.

Son gates de **governance**: "¿los resultados de esta fase son correctos antes de comprometerse con la siguiente?"

| Gate | Momento | Proposito |
|------|---------|-----------|
| Phase 1 → 2 | Despues del analisis | Validar hallazgos antes de disenar |
| Phase 2 → 3 | Despues de la estrategia | Aprobar direccion antes de planificar |
| Phase 4 → 5 | Despues del spec | Aprobar spec antes de descomponer |
| Phase 5 → 6 | Antes de ejecutar | Autorizar inicio de ejecucion |
| Phase 6 → 7 | Antes de TRACK | Confirmar que la ejecucion fue correcta |
| GATE OPERACION | Operacion destructiva | Aprobar accion irreversible puntual |

**Estos gates no se eliminan.** Son la barrera correcta. El humano decide una vez por transicion de fase.

### Plano B — Permisos de herramienta de Claude Code (sistema)

Configurados en `.claude/settings.json`. Aplican por **llamada de herramienta**, no por fase.

Son mecanismos de **ejecucion**: que operaciones corren sin prompt dentro de una fase ya aprobada.

Sin configuracion: cada llamada a Bash (scripts, git) y Edit (archivos) genera un prompt individual,
incluso despues de que el humano ya dijo "SI" al gate de fase.

---

## Tres tipos de edicion

No toda edicion tiene el mismo peso. Antes de decidir si una operacion necesita gate:

| Tipo | Definicion | Ejemplos | Gate |
|------|-----------|---------|------|
| **Edicion decision** | Cambia comportamiento futuro del sistema o del proyecto | Instrucciones en SKILL.md, pasos de Phase, GATE OPERACION en workflow-execute, `description` en frontmatter | GATE OPERACION + `ask` rule |
| **Edicion consecuencia** | Metadata que refleja un cambio ya aprobado — nunca ocurre sola | `updated_at`, `version`, checkboxes en ROADMAP, entrada en CHANGELOG, lecciones aprendidas | Auto — es el resultado de una decision anterior |
| **Edicion correctiva** | Corrige sin cambiar semantica — typo, link roto, formato | Arreglar path en `references/*.md`, corregir nombre de archivo | Auto si no cambia instrucciones |

**Regla de gate:** Si la edicion SOLO actualiza `updated_at` u otros campos de metadata como consecuencia de otro cambio, NO requiere GATE OPERACION. El prompt del `ask` rule (si aplica) se aprueba sin deliberacion.

**Regla de comportamiento:** `updated_at` se actualiza **automaticamente** en el mismo Edit que modifica el contenido — sin que el usuario lo pida, sin paso separado. Ver `CLAUDE.md ## Reglas de edicion`.

---

## Tabla de comportamiento por categoria

| Categoria | Ejemplos | Comportamiento | Mecanismo |
|-----------|---------|---------------|-----------|
| Artefactos WP | `context/work/**/*.md` fuera de `.claude/` | Auto | `acceptEdits` |
| Estado de sesion | `now.md`, `focus.md` fuera de `.claude/` | Auto | `acceptEdits` |
| Artefactos WP dentro de `.claude/` | `.claude/context/work/**/*.md` | **Prompt siempre** | Safety invariant |
| Estado de sesion dentro de `.claude/` | `.claude/context/now.md`, `focus.md` | **Prompt siempre** | Safety invariant |
| Historial del proyecto | `CHANGELOG.md`, `ROADMAP.md` | Auto | `acceptEdits` |
| Scripts del sistema | `bash .claude/scripts/*` | Auto | `allow` |
| Scripts de validacion de fase | `bash .claude/skills/*/scripts/*` | Auto | `allow` |
| Git rutinario | `git add/commit/push/status/log/diff` | Auto | `allow` |
| Config del sistema — edicion decision | Cambiar instrucciones en `SKILL.md`, `CLAUDE.md` | Prompt | GATE OPERACION + `ask` |
| Config del sistema — edicion consecuencia | Actualizar `updated_at` en `SKILL.md`, `CLAUDE.md` | Prompt ligero (1 click) | `ask` rule — sin GATE OPERACION |
| Operaciones destructivas | `git push --force`, `git reset --hard`, `rm -rf` | Bloqueado | `deny` |

**Relacion entre planos:**
El gate Phase 6→7 (Plano A) es la aprobacion para TODO Phase 7. Las operaciones de cierre
(scripts de validacion, git add/commit/push) corren automaticamente despues de ese gate.
Son consecuencia de la decision, no nuevas decisiones.

---

## Configuracion vigente — settings.json

```json
{
  "env": { "CLAUDE_STREAM_IDLE_TIMEOUT_MS": "120000" },
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Edit(/ROADMAP.md)",
      "Write(/.claude/references/**)",
      "Bash(bash .claude/scripts/*)",
      "Bash(bash .claude/skills/*/scripts/*)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git commit -m *)",
      "Bash(git push *)",
      "Bash(git push -u *)",
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(git fetch *)",
      "Bash(git branch *)",
      "Bash(date *)",
      "Bash(mkdir *)",
      "Bash(ls *)",
      "Bash(echo *)"
    ],
    "ask": [
      "Edit(/.claude/scripts/*.sh)",
      "Edit(/.claude/settings.json)"
    ],
    "deny": [
      "Bash(git push --force *)",
      "Bash(git push --force-with-lease *)",
      "Bash(git reset --hard *)",
      "Bash(rm -rf *)"
    ]
  }
}
```

**Nota (FASE 35 — 2026-04-14):** Las reglas `Edit` y `Write` para `.claude/context/` fueron eliminadas porque son inefectivas. La safety invariant del binario protege `.claude/` completo (excepto `.claude/worktrees/`) independientemente de cualquier regla `allow` o del valor de `defaultMode`. La solución real es migrar los archivos de estado fuera de `.claude/` (ver WP `2026-04-14-09-13-51-context-migration`).

---

## Sintaxis de reglas

Referencia rapida de la sintaxis de `permissions`:

| Patron | Ejemplo | Efecto |
|--------|---------|--------|
| Tool sin especificador | `Bash` | Todos los comandos Bash |
| Comando exacto | `Bash(git status)` | Solo ese comando literal |
| Wildcard al final | `Bash(git add *)` | Cualquier `git add ...` |
| Wildcard al inicio | `Bash(* --version)` | Cualquier comando con `--version` |
| Path relativo al proyecto | `Edit(/src/**/*.ts)` | Archivos en `<project>/src/` |
| Path con wildcard de dir | `Edit(/.claude/skills/*/SKILL.md)` | SKILL.md de cualquier workflow-* |
| Domain fetch | `WebFetch(domain:example.com)` | Fetch solo a ese dominio |

**Precedencia:** deny → ask → allow (el primer match gana, deny siempre primero)

**Importante:** `Bash(safe-cmd *)` NO permite `safe-cmd && otro-comando` — Claude Code
reconoce operadores shell y los trata como comandos separados.

---

## Modos disponibles

| Modo | Valido en `permissions.defaultMode` | Valido en agent `permissionMode` | Descripcion | Usar cuando |
|------|--------------------------------------|----------------------------------|-------------|-------------|
| `default` | ✅ | ✅ | Prompt en primer uso de cada herramienta | Nunca — maxima friccion sin beneficio |
| `acceptEdits` | ✅ | ✅ | Auto-acepta Edit/Write + mkdir/touch/mv/cp | **Modo recomendado** para este proyecto |
| `plan` | ✅ | ✅ | Solo lectura y analisis, no puede modificar ni ejecutar | Revisiones de seguridad o auditorias |
| `dontAsk` | ❌ | ✅ | Auto-deniega herramientas no pre-aprobadas sin prompt | Agentes que deben ser estrictamente no-interactivos |
| `bypassPermissions` | ✅ | ✅ | Salta todos los prompts excepto dirs de la safety invariant | Solo en contenedores aislados |

**Nota sobre `bypassPermissions`:** Salta todos los prompts de herramientas.
La safety invariant del binario (v2.1.78+) protege ciertos subdirectorios de `.claude/`
independientemente del modo — pero el criterio exacto de qué paths están protegidos
no está documentado públicamente. Comportamiento observado empíricamente: `.claude/context/`
siempre prompts; `.claude/agents/` y `.claude/skills/` automáticos — sin respaldo documental
conocido. No usar en entornos de produccion.

---

## Como extender la configuracion

### Agregar una operacion confiable

```json
"allow": ["Bash(npm run *)"]
```

### Proteger un archivo critico del proyecto

```json
"ask": ["Edit(/constitution.md)"]
```

### Bloquear acceso a archivos sensibles

```json
"deny": ["Read(/.env)", "Read(/**/.env)"]
```

### Permitir fetch solo a dominios conocidos

```json
"allow": ["WebFetch(domain:api.github.com)"],
"deny": ["WebFetch"]
```

---

## Principios de diseno (L-106..L-109)

**L-106 — Edit y Write requieren aprobacion por defecto:**
Read-only (Read, Grep, Glob) es auto. Edit/Write genera prompt hasta fin de sesion.
Bash genera prompt permanente. `acceptEdits` cambia Edit/Write, no Bash.

**L-107 — Configurar los dos planos juntos:**
Al disenar un flujo con gates de fase, definir explicitamente que pasa en Plano B dentro de
cada fase. El gate de fase debe ser la unica friccion para operaciones rutinarias post-gate.

**L-108 — ask > deny para archivos de uso frecuente:**
`deny` bloquea incluso cuando el uso es legitimo (mantenimiento del sistema ocurre en ~80% FASEs).
`ask` fuerza un prompt sin bloquear — correcto para config del sistema.
`deny` es correcto solo para operaciones que nunca deben ocurrir en flujo normal (force push, rm -rf).

**L-109 — git push es consecuencia del gate, no una nueva decision:**
Despues de que el humano aprobo Phase 7, el push es el desenlace natural.
Solo las variantes destructivas (--force, --force-with-lease) van a `deny`.

---

## Ver tambien

- [claude-code-components](claude-code-components.md) — Referencia oficial completa de Skills, frontmatter y permisos
- [state-management](state-management.md) — Cuando actualizar now.md, focus.md, project-state.md
- `.claude/settings.json` — Configuracion vigente del proyecto
