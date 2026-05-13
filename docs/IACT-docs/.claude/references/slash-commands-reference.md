```yml
type: Reference
title: Slash Commands Reference — Catálogo Completo
category: Claude Code Platform — Commands
version: 1.0
created_at: 2026-04-15
owner: thyrox (cross-phase)
purpose: Catálogo de slash commands built-in, bundled skills y sintaxis de comandos custom
```

# Slash Commands Reference — Catálogo Completo

Catálogo de todos los slash commands disponibles en Claude Code: built-in, bundled skills,
plugin commands, y MCP prompts. Cubre sintaxis de argumentos y migración de legacy commands.

> **Relación con otros references:**
> - [command-execution-model](./command-execution-model.md) — flujo de ejecución runtime, frontmatter fields, patrones fat/thin
> - [skill-authoring](./skill-authoring.md) — cómo crear skills de alta calidad (principios, grados de libertad)
> - [plugins](./plugins.md) — estructura de plugins y distribución de plugin commands
> Este documento cubre: **qué comandos existen** y cómo invocarlos.

---

## 1. Tipos de Slash Commands

| Tipo | Ejemplo de invocación | Origen |
|------|----------------------|--------|
| **Built-in** | `/help`, `/clear`, `/model` | Incluido en el binario de Claude Code |
| **Skill** | `/optimize`, `/pr` | `.claude/skills/<name>/SKILL.md` |
| **Legacy command** | `/optimize` | `.claude/commands/<name>.md` (deprecated, aún funciona) |
| **Plugin command** | `/thyrox:analyze` | `plugin/commands/<name>.md` + `plugin.json::name` |
| **MCP prompt** | `/mcp__github__list_prs` | Expuesto por un MCP server activo en la sesión |

**Regla de precedencia cuando hay conflicto de nombre:**
Skill > Legacy command. Si `.claude/skills/review/SKILL.md` y `.claude/commands/review.md`
coexisten, el skill gana. Los plugin commands no compiten porque usan namespace (`:`) propio.

**Scope de instalación:**

| Scope | Path skills | Path commands legacy | Disponibilidad |
|-------|-------------|----------------------|----------------|
| Proyecto | `.claude/skills/<name>/` | `.claude/commands/<name>.md` | Solo este proyecto |
| Global | `~/.claude/skills/<name>/` | `~/.claude/commands/<name>.md` | Todos los proyectos del usuario |

Los commands de proyecto tienen prioridad sobre los globales cuando hay conflicto de nombre.

---

## 2. Built-in Commands — Catálogo Completo

Claude Code incluye 60+ comandos built-in. Accesibles desde cualquier sesión sin configuración.
Escribir `/` en Claude Code para ver la lista completa; `/` + letras para filtrar.

| Comando | Propósito |
|---------|-----------|
| `/add-dir <path>` | Agrega un working directory a la sesión |
| `/agents` | Gestiona configuraciones de agentes |
| `/branch [name]` | Bifurca la conversación en una nueva sesión (alias: `/fork`, renombrado en v2.1.77) |
| `/btw <question>` | Pregunta lateral sin agregar al historial de conversación |
| `/chrome` | Configura integración con Chrome browser |
| `/clear` | Limpia la conversación (aliases: `/reset`, `/new`) |
| `/color [color\|default]` | Define color de la barra de prompt |
| `/compact [instructions]` | Compacta la conversación con instrucciones de foco opcionales |
| `/config` | Abre Settings (alias: `/settings`) |
| `/context` | Visualiza uso de contexto como grilla de colores |
| `/copy [N]` | Copia respuesta del asistente al clipboard; `w` escribe a archivo |
| `/cost` | Muestra estadísticas de uso de tokens |
| `/desktop` | Continúa en la Desktop app (alias: `/app`) |
| `/diff` | Visor interactivo de diff para cambios sin commitear |
| `/doctor` | Diagnostica la salud de la instalación |
| `/effort [low\|medium\|high\|max\|auto]` | Define nivel de esfuerzo. `max` requiere Opus 4.6 |
| `/exit` | Sale del REPL (alias: `/quit`) |
| `/export [filename]` | Exporta la conversación actual a archivo o clipboard |
| `/extra-usage` | Configura extra usage para rate limits |
| `/fast [on\|off]` | Activa/desactiva fast mode |
| `/feedback` | Envía feedback (alias: `/bug`) |
| `/help` | Muestra ayuda |
| `/hooks` | Ver configuraciones de hooks |
| `/ide` | Gestiona integraciones con IDEs |
| `/init` | Inicializa `CLAUDE.md`. Usar `CLAUDE_CODE_NEW_INIT=1` para flujo interactivo |
| `/insights` | Genera reporte de análisis de sesión |
| `/install-github-app` | Configura la GitHub Actions app |
| `/install-slack-app` | Instala la Slack app |
| `/keybindings` | Abre configuración de keybindings |
| `/login` | Cambia cuentas de Anthropic |
| `/logout` | Cierra sesión de la cuenta Anthropic |
| `/mcp` | Gestiona MCP servers y OAuth |
| `/memory` | Edita `CLAUDE.md`, activa/desactiva auto-memory |
| `/mobile` | QR code para app móvil (aliases: `/ios`, `/android`) |
| `/model [model]` | Selecciona modelo; flechas izquierda/derecha para ajustar effort |
| `/passes` | Comparte una semana gratuita de Claude Code |
| `/permissions` | Ver/actualizar permisos (alias: `/allowed-tools`) |
| `/plan [description]` | Entra en plan mode |
| `/plugin` | Gestiona plugins |
| `/powerup` | Descubre features via lecciones interactivas con demos animadas |
| `/privacy-settings` | Configuración de privacidad (Pro/Max únicamente) |
| `/release-notes` | Ver changelog |
| `/reload-plugins` | Recarga plugins activos |
| `/remote-control` | Control remoto desde claude.ai (alias: `/rc`) |
| `/remote-env` | Configura entorno remoto por defecto |
| `/rename [name]` | Renombra la sesión |
| `/resume [session]` | Reanuda conversación (alias: `/continue`) |
| `/rewind` | Rebobina conversación y/o código (alias: `/checkpoint`) |
| `/sandbox` | Activa/desactiva sandbox mode |
| `/schedule [description]` | Crea/gestiona Cloud scheduled tasks |
| `/security-review` | Analiza el branch en busca de vulnerabilidades de seguridad |
| `/skills` | Lista skills disponibles |
| `/stats` | Visualiza uso diario, sesiones, rachas |
| `/stickers` | Pedir stickers de Claude Code |
| `/status` | Muestra versión, modelo, cuenta |
| `/statusline` | Configura la status line |
| `/tasks` | Lista/gestiona background tasks |
| `/terminal-setup` | Configura keybindings del terminal |
| `/theme` | Cambia el color theme |
| `/ultraplan <prompt>` | Redacta plan en sesión ultraplan, revisa en el browser |
| `/upgrade` | Abre la página de upgrade a un plan superior |
| `/usage` | Muestra límites del plan y estado de rate limits |
| `/voice` | Activa/desactiva dictado de voz push-to-talk |

### Comandos deprecated y removidos

| Comando | Estado |
|---------|--------|
| `/review` | Deprecated — reemplazado por el plugin `code-review` |
| `/output-style` | Deprecated desde v2.1.73 |
| `/fork` | Renombrado a `/branch`; alias `/fork` sigue funcionando (v2.1.77) |
| `/pr-comments` | Removido en v2.1.91 — pedir directamente a Claude que vea los comentarios del PR |
| `/vim` | Removido en v2.1.92 — usar `/config` → Editor mode |

---

## 3. Bundled Skills

Estos 5 skills vienen preinstalados con Claude Code y son accesibles como slash commands
desde cualquier proyecto sin configuración adicional.

| Skill | Sintaxis | Propósito |
|-------|----------|-----------|
| `/batch` | `/batch <instruction>` | Orquesta cambios a gran escala en paralelo usando worktrees |
| `/claude-api` | `/claude-api` | Carga la referencia de Claude API para el lenguaje del proyecto |
| `/debug` | `/debug [description]` | Habilita debug logging en la sesión |
| `/loop` | `/loop [interval] <prompt>` | Ejecuta un prompt repetidamente en intervalos definidos |
| `/simplify` | `/simplify [focus]` | Revisa archivos modificados para calidad de código |

---

## 4. Bundled Skills de Ejemplo (claude-howto)

Estos 8 skills de ejemplo ilustran patrones reales de commands. Pueden instalarse como
skills (`.claude/skills/<name>/SKILL.md`) o como legacy commands (`.claude/commands/<name>.md`).

### `/commit` — Git commit con contexto dinámico

**Frontmatter relevante:**
```yaml
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*)
argument-hint: [message]
description: Create a git commit with context
```

**Patrón:** Usa `!` backtick para inyectar contexto dinámico (status, diff, branch, log)
antes de generar el mensaje de commit. Acepta `$ARGUMENTS` como mensaje opcional.

**Uso:** `/commit` o `/commit "feat: add login page"`

---

### `/pr` — Preparación de Pull Request

**Frontmatter relevante:**
```yaml
description: Clean up code, stage changes, and prepare a pull request
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(npm test:*), Bash(npm run lint:*)
```

**Patrón:** Checklist secuencial — lint, test, diff review, commit convencional, resumen del PR.
Sin argumentos; el skill guía el flujo completo.

**Uso:** `/pr`

---

### `/push-all` — Stage, commit y push con safety checks

**Frontmatter relevante:**
```yaml
description: Stage all changes, create commit, and push to remote (use with caution)
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), ...
```

**Patrón fat command:** Contiene toda la lógica inline — safety checks, confirmación explícita
del usuario antes de ejecutar, manejo de errores, detección de secrets.

**Safety checks incluidos:**
- Secrets: `.env*`, `*.key`, `*.pem`, `credentials.json`, `id_rsa`
- API Keys reales (vs placeholders como `your-api-key`, `xxx`, `placeholder`)
- Archivos grandes `>10MB` sin Git LFS
- Build artifacts: `node_modules/`, `dist/`, `__pycache__/`

**Uso:** `/push-all` (pide confirmación explícita antes de ejecutar)

---

### `/optimize` — Optimización de código

**Frontmatter relevante:**
```yaml
description: Analyze code for performance issues and suggest optimizations
```

**Patrón:** Sin `allowed-tools` — solo análisis. El usuario pega el código en el prompt.
Output estructurado con severidad (Critical/High/Medium/Low), ubicación, explicación y fix.

**Uso:** `/optimize` seguido del código a analizar

---

### `/generate-api-docs` — Generador de documentación de API

**Frontmatter relevante:**
```yaml
description: Create comprehensive API documentation from source code
```

**Patrón:** Escanea `src/api/`, extrae firmas y JSDoc, genera markdown en `docs/api.md`
con ejemplos curl y tipos TypeScript.

**Uso:** `/generate-api-docs`

---

### `/doc-refactor` — Reestructuración de documentación

**Frontmatter relevante:**
```yaml
name: Documentation Refactor
description: Restructure project documentation for clarity and accessibility
tags: documentation, refactoring, organization
```

**Patrón:** Adapta la estructura al tipo de proyecto (library/API/web app/CLI/microservices).
Centraliza docs en `docs/`, genera Mermaid para diagramas.

**Uso:** `/doc-refactor`

---

### `/setup-ci-cd` — Pipeline CI/CD

**Frontmatter relevante:**
```yaml
name: Setup CI/CD Pipeline
description: Implement pre-commit hooks and GitHub Actions for quality assurance
tags: ci-cd, devops, automation
```

**Patrón:** Detecta el lenguaje y framework del proyecto, configura pre-commit hooks
y GitHub Actions workflows adaptados. Usa herramientas open-source.

**Uso:** `/setup-ci-cd`

---

### `/unit-test-expand` — Expansión de cobertura de tests

**Frontmatter relevante:**
```yaml
name: Expand Unit Tests
description: Increase test coverage by targeting untested branches and edge cases
tags: testing, coverage, unit-tests
```

**Patrón:** Ejecuta coverage report, identifica gaps, escribe tests para el framework
del proyecto (Jest/pytest/Go testing/Rust). Verifica mejora al final.

**Uso:** `/unit-test-expand`

---

## 5. Sintaxis de Argumentos en Skills Custom

### `$ARGUMENTS` — Todos los argumentos como string

```yaml
---
name: fix-issue
description: Fix a GitHub issue by number
---

Fix issue #$ARGUMENTS following our coding standards
```

Invocación: `/fix-issue 123` → `$ARGUMENTS` = `"123"`

---

### `$0`, `$1`, `$N` — Argumentos posicionales (base-0)

```yaml
---
name: review-pr
description: Review a PR with priority
---

Review PR #$0 with priority $1
```

Invocación: `/review-pr 456 high` → `$0` = `"456"`, `$1` = `"high"`

---

### `` !`comando` `` — Contexto dinámico via shell

Se ejecuta en shell antes de enviar el prompt al LLM. Claude ve el output, no el comando.

```yaml
---
name: commit
description: Create a git commit with context
allowed-tools: Bash(git *)
---

## Context

- Current git status: !`git status`
- Current git diff: !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`
```

---

### `@path/to/file` — Incluir contenido de archivo

Incluye el contenido del archivo como contexto estático en el prompt.

```markdown
Review the implementation in @src/utils/helpers.js
Compare @src/old-version.js with @src/new-version.js
```

---

### Variables de entorno del sistema

| Variable | Valor |
|----------|-------|
| `${CLAUDE_SESSION_ID}` | ID único de la sesión actual |
| `${CLAUDE_SKILL_DIR}` | Path absoluto al directorio del skill |

---

## 6. Plugin Commands y MCP Prompts

### Plugin commands — namespace con `:`

Los plugins proveen comandos con namespace propio para evitar colisiones:

```
/plugin-name:command-name
```

Ejemplos:
```bash
/thyrox:analyze
/frontend-design:frontend-design
/commit-commands:commit
```

El `:` es exclusivo de plugins. No existe "project namespace" para commands standalone.

### MCP Prompts — formato `mcp__server__prompt`

Los MCP servers exponen prompts como slash commands:

```
/mcp__<server-name>__<prompt-name> [arguments]
```

Ejemplos:
```bash
/mcp__github__list_prs
/mcp__github__pr_review 456
/mcp__jira__create_issue "Bug title" high
```

**Control de acceso en permisos MCP:**

| Sintaxis | Alcance |
|----------|---------|
| `mcp__github` | Acceso completo al server GitHub |
| `mcp__github__*` | Wildcard a todos los tools del server |
| `mcp__github__get_issue` | Acceso a un tool específico |

---

## 7. Migración: Legacy Commands → Skills

Los archivos en `.claude/commands/` siguen funcionando sin cambios. La migración es opcional
pero recomendada para acceder a las funcionalidades adicionales de skills.

| Aspecto | Legacy command | Skill |
|---------|---------------|-------|
| Ubicación | `.claude/commands/<name>.md` | `.claude/skills/<name>/SKILL.md` |
| Archivos adicionales | No (archivo único) | Sí (scripts, templates, references en el mismo directorio) |
| Auto-invocación por Claude | No | Sí (via `description`) |
| Control de invocación | No | `disable-model-invocation`, `user-invocable` |
| Context aislado | No | Sí, con `context: fork` |
| Precedencia si hay conflicto | Pierde | Gana |

**Migración de un archivo:**

Antes (legacy):
```
.claude/commands/optimize.md
```

Después (skill):
```
.claude/skills/optimize/SKILL.md
```

El contenido del archivo puede mantenerse idéntico. Solo cambia la ubicación y nombre del archivo.

**Instalación masiva como skills:**
```bash
mkdir -p .claude/skills
for cmd in optimize pr commit; do
  mkdir -p .claude/skills/$cmd
  cp .claude/commands/$cmd.md .claude/skills/$cmd/SKILL.md
done
```

---

## 8. Ventajas de Skills sobre Legacy Commands

Skills ofrecen funcionalidades adicionales que los legacy commands no tienen:

- **Estructura de directorio:** Agrupar scripts, templates y archivos de referencia junto al SKILL.md
- **Auto-invocación:** Claude puede disparar el skill automáticamente cuando detecta que es relevante
- **Control de invocación:** Elegir si el usuario, Claude, o ambos pueden invocar
- **Ejecución en subagente:** Aislar el context con `context: fork`
- **Disclosure progresiva:** Cargar archivos adicionales del directorio solo cuando se necesitan

Para la guía completa de cómo crear skills, ver [skill-authoring](./skill-authoring.md).
Para entender el flujo de ejecución runtime, ver [command-execution-model](./command-execution-model.md).

---

## Referencias

- [command-execution-model](./command-execution-model.md) — flujo runtime, frontmatter fields completos, fat vs thin
- [skill-authoring](./skill-authoring.md) — principios de authoring, grados de libertad, ejemplos
- [skill-vs-agent](./skill-vs-agent.md) — cuándo crear skill vs agente nativo
- [plugins](./plugins.md) — estructura de plugins, distribución, manifest
- [subagent-patterns](./subagent-patterns.md) — context isolation, worktrees, background agents
