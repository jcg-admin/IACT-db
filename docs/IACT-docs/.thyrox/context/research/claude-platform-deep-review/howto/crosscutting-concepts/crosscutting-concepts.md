---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: crosscutting-concepts
---

# Crosscutting Concepts — Claude Code How-To

## Patrones

### Patrón 1: Frontmatter YAML como lenguaje de configuración universal

YAML frontmatter aparece como mecanismo de configuración en todos los artefactos del repo:
- Skills: `name`, `description`, `allowed-tools`, `context`, `model`, `effort`
- Subagentes: `memory`, `background`, `isolation`, `initialPrompt`, `hooks`, `skills`
- Memoria path-specific: `include`, `exclude`, `priority`
- Plugins: `name`, `version`, `description`, `skills`, `mcpServers`, `hooks`
- Documentación del repo mismo: `type`, `created_at`, `source`

El frontmatter YAML es el mecanismo universal de configuración declarativa en todo el ecosistema.

Fuente: `03-skills/README.md`; `04-subagents/README.md`; `02-memory/README.md`; `07-plugins/README.md`.

### Patrón 2: `allowed-tools` como mecanismo de least-privilege transversal

El campo `allowed-tools` aparece en skills, subagentes y plugins para limitar el acceso a herramientas. Este patrón de least-privilege es consistente en todos los artefactos. Un agente de revisión solo tiene `Read, Grep`. Un agente de implementación tiene todos los tools. La seguridad se configura por artefacto, no globalmente.

Fuente: `04-subagents/secure-reviewer.md`; `04-subagents/implementation-agent.md`; `03-skills/README.md`.

### Patrón 3: Dynamic context injection con `!`command`` 

El mecanismo `!`command`` permite inyectar output de comandos bash como contexto dinámico en skills. Aparece en ejemplos de slash commands (`!`git status``, `!`git diff HEAD``) y en skills que necesitan estado del sistema en tiempo de ejecución. Es un mecanismo transversal que conecta el filesystem/git con el contexto del modelo.

Fuente: `01-slash-commands/commit.md`; `01-slash-commands/README.md`, sección Dynamic Context.

### Patrón 4: String substitutions como contexto de runtime

El sistema provee variables de sustitución disponibles en cualquier artefacto:
- `${CLAUDE_SESSION_ID}`: ID único de sesión
- `${CLAUDE_SKILL_DIR}`: directorio del skill activo
- `${CLAUDE_PLUGIN_DATA}`: directorio de estado del plugin
- `${CLAUDE_ENV_FILE}`: archivo de variables de entorno persistentes

Son variables de contexto que permiten que los artefactos conozcan su entorno sin hardcoding.

Fuente: `03-skills/README.md`; `06-hooks/README.md`; `07-plugins/README.md`.

### Patrón 5: `context: fork` como patrón de aislamiento de ejecución

El campo `context: fork` en el frontmatter de skills y agents crea un subagente aislado para la ejecución. Aparece en skills que no deben contaminar el contexto del agente padre. Es el patrón de aislamiento más básico — más ligero que `isolation: worktree` pero suficiente para operaciones que no modifican el filesystem.

Fuente: `03-skills/README.md`; `04-subagents/README.md`; `01-slash-commands/README.md`.

### Patrón 6: Conventional Commits como estándar de comunicación

El STYLE_GUIDE define Conventional Commits como estándar para el repo. La skill de commit (`01-slash-commands/commit.md`) genera commits convencionales automáticamente. El slash command `/commit` usa dynamic context de `git status` y `git diff` para generar el mensaje. El estándar de commits es transversal a documentación y automatización.

Fuente: `STYLE_GUIDE.md`, sección Commit Messages; `01-slash-commands/commit.md`.

### Patrón 7: Hooks como mecanismo de observabilidad y control transversal

Los hooks pueden interceptar cualquier evento del ciclo de vida de Claude Code. Patrones transversales que los hooks habilitan:
- Logging centralizado de todas las operaciones
- Validación antes de ejecutar herramientas destructivas
- Notificaciones a sistemas externos (Discord, Slack, webhooks)
- Context tracking y estadísticas de uso
- Security scanning antes de commits

Los hooks son el mecanismo de observabilidad del sistema.

Fuente: `06-hooks/README.md`, secciones Use Cases y 26 Events Table.

## Conceptos

- **Declarative configuration**: frontmatter YAML como forma universal de configurar comportamiento
- **Runtime context**: `!`command``, `${VAR}` como mecanismos de inyección de contexto dinámico
- **Execution isolation spectrum**: `context: fork` (ligero) → `isolation: worktree` (fuerte)
- **Observability hooks**: sistema de eventos para instrumentar cualquier operación de Claude
- **Cross-cutting security**: `allowed-tools` como least-privilege aplicado uniformemente

## Notas

El frontmatter YAML como lenguaje de configuración universal es quizás el patrón más importante del ecosistema. Una vez que se entiende, la configuración de cualquier artefacto nuevo se vuelve predecible. El repo documenta este patrón implícitamente — nunca lo nombra directamente como "frontmatter-as-config", pero lo usa consistentemente en todos los módulos.
