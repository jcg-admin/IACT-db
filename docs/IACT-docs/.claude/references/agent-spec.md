```yml
type: Reference
title: Especificación de formato — Agentes nativos de Claude Code
work_package: 2026-04-07-03-08-03-agent-format-spec
created_at: 2026-04-07 05:22:12
status: Activo
covers: R-001, R-002, R-003, R-006
owner: thyrox (cross-phase)
```

# Especificación de formato — Agentes nativos de Claude Code

Este documento es el **gate de WP-1** (`parallel-agent-conventions`). Ninguna tarea que modifique agentes existentes debe iniciar hasta que esta spec esté aprobada.

> **Nota (2026-04-09):** Campos `model` y `tools` corregidos respecto a versión original.
> Ver [claude-code-components.md](claude-code-components.md) para referencia oficial completa.
> TD-024 resuelto.

---

## Tabla de campos

| Campo | Estado | Descripción |
|-------|--------|-------------|
| `name` | REQUERIDO | Kebab-case. Debe coincidir exactamente con el nombre del archivo sin extensión. |
| `description` | REQUERIDO | Campo de routing — Claude Code lo usa para seleccionar el agente automáticamente. Patrón obligatorio: `{qué hace}. Usar cuando {condición}.` Mínimo 20 caracteres. No puede ser bloque vacío `>`. |
| `tools` | Opcional | Lista YAML de herramientas. Si se omite: hereda todas las tools del parent. |
| `model` | Opcional | `sonnet \| opus \| haiku \| inherit`. Default: `inherit` (hereda del parent). |
| `state_file` | Opcional | Archivo de estado del agente. Convención: `context/now-{agent-name}.md`. Crear/actualizar al inicio de cada sesión con: tarea activa, paso en curso, próximo paso. Permite resumir sesiones interrumpidas. |
| `category` | PROHIBIDO | Metadata del registry. No tiene semántica en agentes nativos. |
| `skill_template` | PROHIBIDO | Metadata del generador. No debe propagarse al agente nativo generado. |
| `system_prompt` | PROHIBIDO | El system prompt va en el cuerpo markdown del archivo, no en el frontmatter. |

---

## Reglas de `description`

El campo `description` es el único vector de routing automático. Un agente con `description` vacío o malformado es invisible para Claude Code.

**Patrón recomendado:**

```
{qué hace}. Usar cuando {condición}.
```

**Reglas del linter:**

| Regla | Severidad | Condición |
|-------|-----------|-----------|
| Campo presente | ERROR | Falta `description` en el frontmatter |
| No vacío | ERROR | `description: >` sin contenido, o string vacío |
| Longitud mínima | ERROR | Menos de 20 caracteres |
| Patrón `{qué hace}. Usar cuando {condición}.` | WARN | Description válida pero sin el patrón recomendado |

**Ejemplos:**

```yaml
# Correcto — sigue el patrón
description: Ejecuta tareas atómicas de un task-plan.md. Usar cuando hay un task-plan con checkboxes T-NNN y el usuario quiere implementar la siguiente tarea pendiente.

# Correcto — longitud suficiente, sin patrón (genera WARN, no ERROR)
description: Especialista en Node.js para análisis de código, dependencias y arquitectura backend.

# Incorrecto — bloque vacío (genera ERROR)
description: >

# Incorrecto — demasiado corto (genera ERROR)
description: Node expert
```

---

## Convención de naming

Los nombres de archivo siguen kebab-case y el campo `name` debe coincidir con el nombre del archivo sin extensión.

| Patrón | Formato | Cuándo usar | Ejemplos |
|--------|---------|-------------|---------|
| Tech-expert | `{tech}-expert.md` | Agente de conocimiento de tecnología específica | `nodejs-expert.md`, `react-expert.md` |
| Workflow | `{tarea}-{rol}.md` | Paso del flujo thyrox | `task-executor.md`, `task-planner.md` |
| Utility | `{dominio}-{función}.md` | Utilidad de propósito específico | `tech-detector.md`, `skill-generator.md` |

---

## Ejemplo: agente bien formado vs mal formado

### Mal formado (antes)

```yaml
---
name: nodejs-expert
description: >
model: claude-sonnet-4-6
category: tech-expert
tools:
  - Read
  - Bash
---
```

Problemas:
- `description: >` — bloque vacío, agente invisible para routing
- `model` — campo prohibido en agentes nativos
- `category` — campo prohibido en agentes nativos

### Bien formado (después)

```yaml
---
name: nodejs-expert
description: Analiza código Node.js, dependencias npm y arquitectura backend. Usar cuando el proyecto usa Node.js y se necesita expertise en ecosistema, patrones o debugging de backend JavaScript.
tools:
  - Read
  - Bash
  - Glob
  - Grep
---
```

Cumple:
- `name` coincide con el nombre del archivo
- `description` sigue el patrón, supera 20 chars, no es bloque vacío
- `tools` tiene al menos un elemento
- Sin campos prohibidos

---

## Validación

El linter ejecutable que valida estas reglas vive en:

```
.claude/scripts/lint-agents.py
```

Uso:
```bash
# Validar todos los agentes
python3 .claude/scripts/lint-agents.py

# Validar un agente específico
python3 .claude/scripts/lint-agents.py .claude/agents/nodejs-expert.md
```
