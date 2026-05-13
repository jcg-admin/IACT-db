# Agents Registry

Definiciones de agentes spawnables para THYROX. Cada archivo YML define un agente que `bootstrap.py` convierte en un agente nativo Claude Code (`.claude/agents/*.md`).

---

## Qué es un agente en este contexto

Un agente es un **subproceso Claude** con:
- Un conjunto limitado de herramientas (`tools`)
- Conocimiento técnico embebido (`system_prompt`)
- Un propósito específico (`description` — campo de routing)

El campo `description` es el más crítico: Claude lo usa para decidir qué agente lanzar con `Agent tool → subagent_type`. Si la descripción no describe claramente el propósito, el agente no se invocará correctamente.

---

## Campos del YML

| Campo | Estado | Descripción |
|-------|--------|-------------|
| `name` | **Obligatorio** | Identificador kebab-case. Debe coincidir con el nombre del archivo. |
| `description` | **Obligatorio** | ≥20 chars. Campo de routing — describe cuándo usar este agente. |
| `tools` | **Obligatorio** | Lista de herramientas permitidas. Mínimo necesario. |
| `system_prompt` | Opcional | Conocimiento técnico embebido. Instrucciones de comportamiento. |
| `model` | **PROHIBIDO** | No incluir en el YML. bootstrap.py no lo propaga a agentes nativos. |
| `category` | Metadata | Opcional. No lo usa bootstrap.py para la generación. |
| `skill_template` | Metadata | Path al template de skill asociado. No lo usa bootstrap.py. |

### Ejemplo mínimo válido

```yaml
name: mi-agente
description: >
  Agente especializado en X. Usar cuando el usuario necesite Y o Z.
  Conoce A, B, C y tiene acceso a exec_cmd para operaciones de sistema.
tools:
  - Read
  - Grep
  - Glob
```

### Ejemplo con system_prompt

```yaml
name: nodejs-expert
description: >
  Tech-expert para Node.js. Conoce Express/Fastify, async/await, testing con Jest,
  estructura de módulos y patrones de API REST.
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - mcp__thyrox_executor__exec_cmd
system_prompt: |
  Eres nodejs-expert, el especialista en Node.js de THYROX.
  ## Convenciones Node.js
  ...
```

---

## Agentes disponibles

Los agentes se dividen en dos grupos: **core** (siempre presentes, no dependen del stack) y **tech-experts** (generados según el stack del proyecto).

### Core agents — siempre activos

| Agente | Phase SDLC | Propósito | Tools clave |
|--------|-----------|-----------|-------------|
| `tech-detector` | Phase 1 — ANALYZE | Detecta stack tecnológico desde archivos de config | Glob, Read |
| `task-planner` | Phase 5 — DECOMPOSE | Descompone trabajo en tareas atómicas T-NNN | Read, Write, Glob, Grep |
| `task-executor` | Phase 6 — EXECUTE | Ejecuta una tarea T-NNN del task-plan | Read, Write, Edit, Bash, exec_cmd |
| `skill-generator` | Bootstrap / Phase 7 | Genera SKILL.md + agente desde un YML del registry | Read, Write, Glob |

### Tech-expert agents — generados por stack

| Agente | Phase SDLC | Propósito | Stack |
|--------|-----------|-----------|-------|
| `nodejs-expert` | Phase 6 — EXECUTE | Implementa features Node.js, Express, testing Jest | `--stack nodejs` |
| `react-expert` | Phase 6 — EXECUTE | Implementa componentes React, hooks, Vitest | `--stack react` |
| `webpack-expert` | Phase 6 — EXECUTE | Configura bundling, loaders, plugins, optimización | `--stack webpack` |
| `postgresql-expert` | Phase 6 — EXECUTE | Escribe SQL, migrations, índices PostgreSQL | `--stack postgresql` |
| `mysql-expert` | Phase 6 — EXECUTE | Escribe SQL, migrations, índices MySQL | `--stack mysql` |

> Los tech-experts se generan al ejecutar `bootstrap.py --stack {techs}`. Solo están disponibles si el stack fue declarado. `tech-detector` es el agente que detecta qué stack requiere bootstrap.

---

## Cómo agregar un agente nuevo

1. Crear `agents/{nombre}.yml` con los campos obligatorios
2. Escribir una `description` clara (≥20 chars, orientada al routing)
3. Listar solo las herramientas necesarias en `tools`
4. NO incluir `model`
5. Testear: `python .claude/registry/bootstrap.py --stack {nombre} --force`
6. Verificar con el linter: `python .claude/scripts/lint-agents.py`
7. Commit: `feat(registry): add {nombre} agent`

---

## Generación

```bash
# Generar todos los agentes del registry
python .claude/registry/bootstrap.py

# Generar agentes para un stack específico
python .claude/registry/bootstrap.py --stack nodejs,react

# Forzar regeneración (sobreescribir .claude/agents/*.md)
python .claude/registry/bootstrap.py --force
```

El script lee los YMLs de este directorio y genera `.claude/agents/{nombre}.md`. Los agentes generados son idempotentes: ejecutar dos veces produce el mismo resultado.

---

## Spec completa de agentes nativos

Ver [agent-spec.md](../../references/agent-spec.md) para la especificación formal de todos los campos, restricciones y convenciones de los agentes nativos Claude Code.
