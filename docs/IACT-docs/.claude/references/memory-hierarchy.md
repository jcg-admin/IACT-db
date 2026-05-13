```yml
type: Reference
title: Memory Hierarchy — Sistema de Memoria en Claude Code
category: Claude Code Platform — Memoria y Estado
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Sistema de 8 niveles de memoria — CLAUDE.md, @imports, auto-memory, managed settings enterprise
```

# Memory Hierarchy — Sistema de Memoria en Claude Code

Referencia para el sistema de memoria de 8 niveles de Claude Code. Controla qué instrucciones se cargan automáticamente, en qué orden, y con qué precedencia.

## Los 8 niveles de memoria (prioridad descendente)

| Prioridad | Tipo | Ubicación | Alcance |
|-----------|------|-----------|---------|
| 1 (máxima) | **Managed Policy** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) · `/etc/claude-code/CLAUDE.md` (Linux/WSL) · `C:\Program Files\ClaudeCode\CLAUDE.md` (Windows) | Organización |
| 2 | **Managed Drop-ins** | `managed-settings.d/*.md` (v2.1.83+) | Organización (modular) |
| 3 | **Project Memory** | `./CLAUDE.md` o `./.claude/CLAUDE.md` | Proyecto (equipo) |
| 4 | **Project Rules** | `./.claude/rules/*.md` (glob patterns) | Proyecto (modular) |
| 5 | **User Memory** | `~/.claude/CLAUDE.md` | Usuario (todos los proyectos) |
| 6 | **User Rules** | `~/.claude/rules/*.md` | Usuario (modular) |
| 7 | **Local Project Memory** | `./CLAUDE.local.md` (git-ignored) | Máquina local |
| 8 (mínima) | **Auto Memory** | `~/.claude/projects/<project>/memory/` | Auto-escrita por Claude |

**Regla:** Los niveles superiores toman precedencia. Si Managed Policy dice X y Project Memory dice ¬X, gana X.

## Cargado automático vs on-demand

Los archivos CLAUDE.md se cargan automáticamente al inicio de sesión. Claude traversa hacia arriba desde el directorio de trabajo actual para descubrir CLAUDE.md — no solo el directorio raíz. Los archivos en subdirectorios se cargan cuando Claude accede a esos directorios (traversal contextual).

```
/project-root/
├── CLAUDE.md              ← cargado al inicio
├── .claude/
│   ├── CLAUDE.md          ← cargado al inicio (alternativa)
│   └── rules/
│       ├── security.md    ← cargado por glob pattern match
│       └── tests.md       ← cargado por glob pattern match
├── src/
│   └── CLAUDE.md          ← cargado cuando Claude accede a src/
└── CLAUDE.local.md        ← cargado al inicio, NO commiteado
```

## Import syntax — `@path/to/file`

Los archivos CLAUDE.md pueden importar otros archivos para modularidad:

```markdown
# Importar archivo relativo al proyecto
@.claude/team-standards.md

# Importar archivo del usuario
@~/.claude/personal-preferences.md
```

**Restricciones:**
- La sintaxis `@path` NO funciona dentro de bloques de código markdown
- Importaciones recursivas limitadas a **5 niveles** (previene loops)
- Primera vez que se importa desde ruta externa → diálogo de aprobación único

## Auto Memory — Claude escribe su propia memoria

Claude puede auto-actualizar su memoria persistente para recordar preferencias y contexto entre sesiones.

**Estructura oficial:**
```
~/.claude/projects/<hash-del-proyecto>/memory/
├── MEMORY.md              ← entrypoint principal (primeras 200 líneas / 25KB cargadas al inicio)
├── debugging.md           ← topic file (cargado on-demand)
├── api-conventions.md     ← topic file (cargado on-demand)
└── testing-patterns.md    ← topic file (cargado on-demand)
```

**Importante:** El archivo entrypoint se llama `MEMORY.md` (no `preferences.md` ni `patterns.md`). Los topic files adicionales son on-demand, no se cargan al inicio.

**Versión mínima requerida:** v2.1.59

**Control via env var:**
```bash
# Deshabilitar auto memory
CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude

# Forzar auto memory on explícitamente
CLAUDE_CODE_DISABLE_AUTO_MEMORY=0 claude
```

| Valor | Comportamiento |
|-------|---------------|
| `0` | Fuerza auto memory **on** |
| `1` | Fuerza auto memory **off** |
| *(sin definir)* | Comportamiento por defecto (activado) |

**Control via settings — `claudeMdAutoSave`:**

```jsonc
// En ~/.claude/settings.json o .claude/settings.local.json
{
  "claudeMdAutoSave": true    // Habilitar auto-save (default: true)
}
```

- Controla si Claude guarda aprendizajes automáticamente al final de la sesión y cada ~30 minutos
- Escribe en el entrypoint `MEMORY.md`; crea topic files on-demand (`api-conventions.md`, `debugging.md`, etc.)
- Equivalente persistente al env var `CLAUDE_CODE_DISABLE_AUTO_MEMORY`

**Directorio personalizado** (`autoMemoryDirectory`, disponible desde v2.1.74):

```jsonc
// Solo en ~/.claude/settings.json o .claude/settings.local.json
// NO en project settings ni managed policy
{
  "autoMemoryDirectory": "/path/to/custom/memory/directory"
}
```

**Worktrees:** Todos los worktrees y subdirectorios del mismo repositorio git comparten un único directorio de auto memory.

**Cuándo es útil:** Claude aprende convenciones del proyecto (naming, patterns preferidos) y las retiene entre sesiones sin que el usuario deba repetirlas.

## Managed Settings para Enterprise

Los administradores pueden hacer cumplir políticas a nivel de organización:

```
macOS:   /Library/Application Support/ClaudeCode/
Linux/WSL:  /etc/claude-code/
Windows: C:\Program Files\ClaudeCode\

Archivos disponibles:
├── CLAUDE.md               # Memoria de política org (nivel 1)
├── managed-settings.json   # Configuración org (permisos, herramientas)
├── managed-mcp.json        # Whitelist/blocklist de servidores MCP
└── managed-settings.d/     # Drop-ins modulares (v2.1.83+)
    ├── security.json
    ├── dev-tools.json
    └── integrations.json
```

**Jerarquía de settings (5 niveles):**

| Nivel | Ubicación | Scope |
|-------|-----------|-------|
| 1 (más alto) | Managed policy (system-level) | Organización — enforcement obligatorio |
| 2 | `managed-settings.d/` (v2.1.83+) | Org modular — merged alfabéticamente |
| 3 | `~/.claude/settings.json` | Usuario |
| 4 | `.claude/settings.json` | Proyecto (commiteado) |
| 5 (más bajo) | `.claude/settings.local.json` | Local (git-ignored) |

**Settings nativos de plataforma (v2.1.51+):** En macOS pueden usarse archivos plist; en Windows, el Registry. Se leen junto a los JSON y siguen las mismas reglas de precedencia.

`claudeMdExcludes` puede definirse en cualquier nivel de settings (no solo en managed policy):

```jsonc
{
  "claudeMdExcludes": [
    "packages/legacy-app/CLAUDE.md",
    "vendors/**/CLAUDE.md",
    "archived/**/CLAUDE.md",
    "{deprecated,examples}/**"
  ]
}
```

**Patrones soportados** (glob relativo a la raíz del proyecto):
- `packages/*/CLAUDE.md` — excluir todas las sub-packages
- `**/node_modules/**` — excluir dependencias vendoreadas
- `{deprecated,archived}/**` — múltiples raíces con brace expansion

**Cuándo usar:**
- Monorepos con sub-proyectos donde solo algunos son relevantes al trabajo actual
- Repos con CLAUDE.md de terceros o vendoreadas
- Reducir ruido en el context window excluyendo instrucciones obsoletas
- Equipos trabajando en servicios específicos de un polyrepo

## Sistema de rules modulares

Las rules en `.claude/rules/` admiten dos características organizativas:

- **Subdirectorios:** Las rules se descubren recursivamente. Se pueden organizar en carpetas por tema (`rules/api/`, `rules/testing/`, `rules/security/`)
- **Symlinks:** Soportados para compartir rules entre proyectos desde una ubicación central

Las rules de usuario en `~/.claude/rules/` se cargan antes que las de proyecto, permitiendo defaults personales que los proyectos pueden sobreescribir.

**Path-specific rules con YAML frontmatter:**

Las rules pueden limitarse a rutas específicas usando frontmatter:

```markdown
---
paths: src/api/**/*.ts
---

# API Development Rules

- All API endpoints must include input validation
- Use Zod for schema validation
```

Glob patterns soportados: `**/*.ts`, `src/**/*`, `src/**/*.{ts,tsx}`, `{src,lib}/**/*.ts`.

## Comandos de memoria en sesión

| Comando | Propósito | Cuándo usar |
|---------|-----------|-------------|
| `/init` | Inicializar CLAUDE.md del proyecto | Primera vez, proyecto nuevo |
| `/memory` | Editar archivos de memoria en editor | Actualizaciones extensas, revisión |
| `@path/to/file` | Importar contenido externo | Referenciar docs existentes en CLAUDE.md |

**`/init` con modo interactivo:**
```bash
CLAUDE_CODE_NEW_INIT=1 claude
/init
```
Activa un flujo multi-fase que guía el setup paso a paso.

**`#` prefix — discontinuado:** El shortcut `# texto` para agregar reglas en línea ya no funciona. Usar `/memory` o pedir conversacionalmente ("remember that we always use TypeScript strict mode").

**Agregar memoria conversacionalmente:**
```
Remember that we always use TypeScript strict mode in this project.
```
Claude preguntará en qué archivo de memoria guardar y actualizará el CLAUDE.md correspondiente.

## Carga desde directorios adicionales — `--add-dir`

El flag `--add-dir` permite cargar CLAUDE.md de directorios adicionales más allá del directorio de trabajo. Útil para monorepos o setups multi-proyecto.

```bash
# Activar el feature
export CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1

# Lanzar Claude con directorio adicional
claude --add-dir /path/to/other/project
```

Claude carga el CLAUDE.md del directorio adicional junto con los archivos de memoria del directorio de trabajo actual.

## Memoria de subagentes — scope por agente

Los subagentes tienen su propio directorio de memoria separado del contexto principal:

```yaml
---
name: researcher
memory: project    # user | project | local
---
```

| Scope | Directorio |
|-------|-----------|
| `user` | `~/.claude/agent-memory/<agent-name>/` |
| `project` | `.claude/agent-memory/<agent-name>/` |
| `local` | `.claude/agent-memory-local/<agent-name>/` |

**Cómo funciona:**
- Las primeras **200 líneas** (o 25KB) de `MEMORY.md` se inyectan automáticamente en el system prompt del subagente
- Archivos de temas adicionales se cargan on-demand
- El subagente tiene Read/Write/Edit habilitados para gestionar su propia memoria

## Memory tool (beta) — recuperación dinámica

Desde Claude Sonnet 4.5, existe un Memory tool en beta público. Es distinto de CLAUDE.md:

| Mecanismo | Carga | Naturaleza |
|-----------|-------|-----------|
| CLAUDE.md | Al inicio de sesión (siempre) | Contexto estático — configuración |
| Memory tool | On-demand, al consultar | Contexto dinámico — recuperación |

El Memory tool mantiene un knowledge store estructurado que Claude consulta cuando necesita contexto específico. Reduce la necesidad de codificar manualmente todo el conocimiento en archivos de configuración, especialmente en workflows de agentes.

## Niveles de memoria para diferentes audiencias

| Nivel | Quién lo usa | Ejemplo de contenido |
|-------|-------------|---------------------|
| Managed Policy (1) | Admin IT | Políticas de seguridad, herramientas prohibidas |
| Project Memory (3) | Equipo | Convenciones de código, arquitectura del proyecto |
| User Memory (5) | Desarrollador | Preferencias personales, estilo de respuesta |
| Local Project (7) | Máquina local | Rutas de entorno local, credenciales de dev |
| Auto Memory (8) | Claude mismo | Patrones aprendidos, preferencias inferidas |

## Contexto THYROX

En THYROX, la memoria sigue este patrón:
- **Nivel 3 (Project):** `.claude/CLAUDE.md` — reglas del sistema (Locked Decisions, estructura)
- **Nivel 4 (Rules):** Potencialmente `.claude/rules/` para modularizar reglas por capa
- **Nivel 7 (Local):** `CLAUDE.local.md` si existe — overrides locales no commiteados

El `context/now.md` y `context/focus.md` de THYROX NO son memoria de Claude Code — son archivos de estado que el skill lee explícitamente al inicio de sesión (via `session-start.sh` hook + instrucción en CLAUDE.md). Son diferentes mecanismos.

## Referencias

- `claude-howto/02-memory/README.md` — Documentación oficial de memoria (fuente externa)
- [claude-code-components](claude-code-components.md) — Frontmatter de skills y agentes
- [state-management](state-management.md) — Archivos de estado de sesión (now.md, focus.md)
- [subagent-patterns](subagent-patterns.md) — Memoria persistente de subagentes
