```yml
type: Contexto de Proyecto
category: Decisiones Arquitectónicas
project: IACT-docs
version: 1.0.0
purpose: Índice de decisiones del proyecto IACT-docs
created_at: 2026-04-23 09:05:00
updated_at: 2026-04-23 09:05:00
```

# Decisiones de Arquitectura — IACT-docs

Registro de decisiones arquitectónicas específicas del proyecto IACT-docs. Cada ADR documenta el razonamiento detrás de una decisión permanente.

---

## IACT-docs Specific ADRs

Decisiones propias del proyecto (a crear durante ejecución).

### Seguridad y Cumplimiento

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| **adr-sensitive-info-policy** (pendiente) | Política para información sensible (RBAC, restricciones) en repositorio | Pendiente | 2026-04-23 |

**Descripción:** Define qué información es sensible (RBAC models, CNST constraints, security details), dónde almacenarla (env vars, no-git, encrypted), y cómo prevenir futuros commits (pre-commit hooks).

**Trigger:** TD-002 — Crear durante Phase 3 DIAGNOSE o Phase 5 STRATEGY

### Configuración Sphinx

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| **adr-sphinx-configuration** (a crear) | Decisiones sobre extensiones, tema, estructura de build | Abierto | — |

**Descripción:** Documentar por qué elegimos las 16 extensiones, qué hace cada una, cómo validarlas (TD-005).

### Estructura de Documentación

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| **adr-documentation-structure** (a crear) | Organización de directorios en source/ y convenciones | Abierto | — |

**Descripción:** Estructura actual (arquitectura_tecnica/, base_cognitiva/, gestion/, normativa/, requisitos/) — por qué esta organización, dónde agregar nuevo contenido.

---

## Framework Base ADRs (heredadas)

Decisiones del framework THYROX que aplican universalmente y son heredadas por IACT-docs.

### Fundamentos del Framework

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| [adr-markdown-documentacion](../skills/thyrox/references/adr-markdown-documentacion.md) | Markdown como formato estándar | Aprobado | 2025-03-24 |
| [adr-conventional-commits](../skills/thyrox/references/adr-conventional-commits.md) | Conventional Commits para mensajes | Aprobado | 2025-03-24 |
| [adr-yaml-configuracion](../skills/thyrox/references/adr-yaml-configuracion.md) | YAML para archivos de configuración | Pendiente | 2025-03-24 |

**Aplicación a IACT-docs:** Todos los commits en feature/project-setup siguen conventional commits. Metadata usa YAML.

### Metodología THYROX

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| [adr-analyze-first](../skills/thyrox/references/adr-analyze-first.md) | Phase 1 es siempre DISCOVER | Aprobado | 2026-03-27 |
| [adr-claude-code-development-agent](../skills/thyrox/references/adr-claude-code-development-agent.md) | Claude Code como agente principal | Aprobado | 2025-03-24 |
| [adr-anatomia-oficial-skill](../skills/thyrox/references/adr-anatomia-oficial-skill.md) | Anatomía oficial del skill | Aprobado | 2026-03-27 |
| [adr-bound-detector-preToolUse](../skills/thyrox/references/adr-bound-detector-preToolUse.md) | PreToolUse hook para detectar bounds | Aprobado | 2026-04-14 |

**Aplicación a IACT-docs:** El WP config-review-iact-docs sigue la estructura THYROX con 7 fases (1, 3, 5, 6, 8, 10, 11). Phase 1 DISCOVER completada.

### Arquitectura de Skills y Framework

| Archivo | Decisión | Status | Fecha |
|---------|----------|--------|-------|
| [adr-arquitectura-orquestacion-thyrox](../skills/thyrox/references/adr-arquitectura-orquestacion-thyrox.md) | Arquitectura de 5 capas | Aprobado | 2026-04-07 |
| [adr-plugin-namespace-thyrox](../skills/thyrox/references/adr-plugin-namespace-thyrox.md) | Namespace /thyrox:* | Aprobado | 2026-04-10 |
| [adr-workflow-commands-a-skills](../skills/thyrox/references/adr-workflow-commands-a-skills.md) | Migración /workflow_* a skills | Aprobado | 2026-04-08 |

**Aplicación a IACT-docs:** Se heredan los scripts del framework (session-start.sh, validate-session-close.sh, etc.).

---

## Cómo Crear una Nueva ADR para IACT-docs

1. Identificar una decisión arquitectónica permanente del proyecto (no framework)
2. Crear archivo: `decisions/adr-{tema-descriptivo}.md`
3. Usar template si existe (ver referencias/ del framework)
4. Agregar fila en la tabla "IACT-docs Specific ADRs" arriba
5. Commit: `docs(adr): add adr-{tema} — [descripción breve]`

**Timing:** Crear ADRs en Phase 1-2 cuando la decisión se toma permanente.

---

## Resumen

| Categoría | Cantidad | Status |
|-----------|----------|--------|
| **IACT-docs Specific ADRs** | 1 | Pendiente (sensitive-info-policy) |
| **Framework Base ADRs (heredadas)** | 10 | Aprobadas |
| **Total** | 11 | 10 aprobadas, 1 pendiente |

---

**Ubicación:** `.thyrox/context/decisions.md`  
**Scope:** Decisiones de IACT-docs + framework heredado  
**Última actualización:** 2026-04-23 09:05:00
