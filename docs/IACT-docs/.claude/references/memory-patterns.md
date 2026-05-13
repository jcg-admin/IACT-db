```yml
type: Reference
title: Memory Patterns — Patrones de Uso del Sistema de Memoria
category: Claude Code Platform — Memoria y Estado
version: 1.0
created_at: 2026-04-13
owner: thyrox (cross-phase)
purpose: Estado de sesión, @imports, auto-memory y memory: en subagents
```

# Memory Patterns — Patrones de Uso del Sistema de Memoria

Guía de **cómo usar** el sistema de memoria de Claude Code en patrones concretos.
Para la arquitectura del sistema, ver [memory-hierarchy.md](memory-hierarchy.md).

---

## Los 8 niveles — resumen rápido

| Nivel | Tipo | Alcance | Cuándo usarlo |
|-------|------|---------|---------------|
| 1 | Managed Policy (enterprise) | Organización | Políticas corporativas inmutables |
| 2 | Managed Drop-ins | Organización modular | Reglas por equipo/dominio |
| 3 | Project Memory (`CLAUDE.md`) | Proyecto completo | Instrucciones universales del proyecto |
| 4 | Project Rules (`rules/*.md`) | Proyecto modular | Reglas por dominio (seguridad, estilo) |
| 5 | User Memory (`~/.claude/CLAUDE.md`) | Todos los proyectos | Preferencias personales globales |
| 6 | User Rules (`~/.claude/rules/*.md`) | Usuario modular | Reglas personales por dominio |
| 7 | Local Project Memory (`CLAUDE.local.md`) | Máquina local | Config local no commitable |
| 8 | Auto Memory | Auto-escrita | Aprendizaje automático entre sesiones |

Ver [memory-hierarchy.md](memory-hierarchy.md) para detalles de precedencia y carga automática.

---

## Patrón 1 — Estado de sesión (now.md / focus.md)

El patrón más usado en THYROX: archivos de estado efímero que persisten entre mensajes.

```
context/
├── now.md          ← Estado de la sesión actual (qué está pasando AHORA)
├── focus.md        ← Dirección del proyecto (objetivo de largo plazo)
└── project-state.md ← Metadata del proyecto (FASE actual, etc.)
```

**Regla:** `now.md` = memoria de sesión. `focus.md` = memoria de dirección. `project-state.md` = memoria permanente.

**Cuándo actualizar:**
- `now.md`: al inicio de cada sesión, al cambiar de tarea, al cerrar sesión
- `focus.md`: al cambiar el objetivo principal del proyecto
- `project-state.md`: al completar una FASE

**Diferencia con CLAUDE.md:**
- `CLAUDE.md`: instrucciones universales (cómo trabajar) — no cambia entre sesiones
- `now.md`: estado efímero (en qué estamos) — cambia en cada sesión

---

## Patrón 2 — @imports: referenciar sin copiar

Cuando CLAUDE.md necesita incorporar documentación externa sin duplicarla:

```markdown
# CLAUDE.md
@path/to/conventions.md
@path/to/architecture-overview.md

## Reglas de este proyecto
...
```

**Cuándo usar @imports:**
- Documentación grande que se mantiene por separado
- Specs que cambian frecuentemente (referenciar evita desincronización)
- Documentos compartidos entre múltiples proyectos

**Cuándo NO usar @imports:**
- Instrucciones críticas que deben estar siempre disponibles → incluirlas directamente
- Archivos que pueden no existir (error si el path no existe)
- Contenido muy grande (consume context budget al cargar)

**Sintaxis:**
```markdown
# Referencia relativa (desde la ubicación de CLAUDE.md)
@./references/conventions.md

# Referencia absoluta
@/home/user/shared-docs/style-guide.md
```

---

## Patrón 3 — Auto-memory

Claude Code puede escribir automáticamente a `~/.claude/projects/<project>/memory/` para recordar preferencias y convenciones entre sesiones.

**Variables de control:**
```bash
# Deshabilitar auto-memory completamente
CLAUDE_CODE_DISABLE_AUTO_MEMORY=true

# Deshabilitar en settings.json
{
  "env": {
    "CLAUDE_CODE_DISABLE_AUTO_MEMORY": "true"
  }
}
```

**Cuándo deshabilitar:**
- Proyectos en equipos donde la memoria personal interfiere
- Cuando se quiere control explícito de toda la memoria
- Proyectos con alta rotación de contexto (auto-memory puede quedar obsoleta)

**Cuándo mantener habilitado:**
- Trabajo personal de larga duración
- Proyectos donde Claude aprende convenciones gradualmente

---

## Patrón 4 — memory: en subagents (3 scopes)

Los subagentes tienen acceso a memoria configurable via el campo `memory:` en su frontmatter:

```yaml
---
name: mi-agente
tools: Read, Write, Bash
memory:
  - type: project   # Lee .claude/CLAUDE.md del proyecto
  - type: user      # Lee ~/.claude/CLAUDE.md del usuario
  - type: local     # Lee CLAUDE.local.md (gitignored)
---
```

**Scopes disponibles:**

| Scope | Qué carga | Cuándo usar |
|-------|-----------|-------------|
| `project` | `CLAUDE.md` del proyecto | Agentes que necesitan conocer las reglas del proyecto |
| `user` | `~/.claude/CLAUDE.md` | Agentes que deben respetar preferencias personales |
| `local` | `CLAUDE.local.md` | Agentes con config local específica de la máquina |

**Sin campo `memory:`:** El agente hereda la memoria del contexto en que fue invocado.

---

## Patrón 5 — Estado por WP (Work Package)

Para proyectos con múltiples WPs paralelos, cada agente tiene su propio archivo de estado:

```
context/
├── now.md                          ← Orquestador / estado compartido
├── now-task-executor.md            ← Agente nativo en ejecución
└── now-security-audit-wp-auth.md   ← Skill especializado + WP ID
```

**Regla de naming:**
- Orquestador → `now.md`
- Agente nativo → `now-{agent-name}.md`
- Skill especializado → `now-{skill-name}-{wp-id}.md`

---

## Patrón 6 — Context budget: cuándo usar /compact

El context budget se agota cuando hay mucho historial acumulado. `/compact` comprime el contexto.

**Cuándo usar /compact:**
- Antes de generar documentos largos (>200 líneas)
- Cuando la sesión supera los 30-40 intercambios
- Antes de una fase de síntesis intensiva

**Señales de que el context está saturado:**
- Timeouts frecuentes (TTFToken alto)
- Respuestas que ignoran instrucciones recientes
- `Stream idle timeout: partial response received`

**Ver:** [stream-resilience.md](stream-resilience.md) para el problema TTFToken/timeout.

---

## Anti-patrones

### ❌ CLAUDE.md como base de datos
```markdown
# MAL — CLAUDE.md con estado mutable
Estado actual: FASE 33, Phase 6, 14 archivos pendientes
Última sesión: 2026-04-13 19:18
Tarea actual: crear agent-authoring.md
```
**Correcto:** El estado va en `now.md`. CLAUDE.md solo tiene instrucciones permanentes.

---

### ❌ Estado ad-hoc fuera del WP
```
# MAL
/tmp/mi-estado.md
/home/user/notas-temporales.md
```
**Correcto:** Todo estado en `context/work/{wp}/` o `context/now.md`.

---

### ❌ CLAUDE.md gigante sin estructura
Un CLAUDE.md con 500+ líneas mezclando todo → carga completa en cada sesión → context budget consumido.

**Correcto:** Usar `@imports` para secciones separables + `rules/*.md` para reglas modulares.

---

### ❌ Múltiples `now.md` sin naming
Dos agentes paralelos escribiendo al mismo `now.md` → conflictos y pérdida de estado.

**Correcto:** `now-agente-a.md` + `now-agente-b.md` con naming por agente.
