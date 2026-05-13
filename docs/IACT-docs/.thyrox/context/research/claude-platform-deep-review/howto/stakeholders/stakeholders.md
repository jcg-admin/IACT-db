---
type: deep-review-domain
created_at: 2026-04-14
source: /tmp/reference/claude-howto/
topic: stakeholders
---

# Stakeholders — Claude Code How-To

## Patrones

### Patrón 1: Tres perfiles de usuario explícitamente definidos

La Learning Roadmap define tres niveles con self-assessment quiz: Beginner (configuración básica, primeros comandos), Intermediate (skills avanzadas, subagentes, MCP), Advanced (plugins, agent teams, worktrees). Cada nivel tiene prerequisitos, milestones, ejercicios hands-on y criterios de éxito. El repo clasifica explícitamente a sus usuarios.

Fuente: `LEARNING-ROADMAP.md`, secciones Beginner/Intermediate/Advanced.

### Patrón 2: Individual developer como usuario primario

Los templates de memoria (`personal-CLAUDE.md`) y el flujo de onboarding asumen un desarrollador individual trabajando en sus propios proyectos. El personal CLAUDE.md template incluye preferencias de estilo personal, tecnologías favoritas, convenciones de naming propias. El uso individual está documentado más profundamente que el uso en equipo.

Fuente: `02-memory/personal-CLAUDE.md`; `02-memory/project-CLAUDE.md`.

### Patrón 3: Equipos como stakeholder secundario con paths propios

El `project-CLAUDE.md` template es explícitamente para equipos: arquitectura compartida, estándares de código del equipo, convenciones git del equipo, requisitos de testing. El subagent `code-reviewer` tiene el patrón `use PROACTIVELY` para flujos colaborativos. Los hooks pueden usarse para gate checks de equipo.

Fuente: `02-memory/project-CLAUDE.md`; `04-subagents/code-reviewer.md`; `06-hooks/README.md`.

### Patrón 4: Contribuidores al repo como stakeholder documentado

El `STYLE_GUIDE.md` y `CONTRIBUTING.md` son documentos para contribuidores. El checklist de autores (17 items) y las convenciones de commit (Conventional Commits) definen explícitamente qué se espera de quien contribuye al repo mismo. Es un stakeholder inusual en documentación técnica.

Fuente: `STYLE_GUIDE.md`, sección Checklist for Authors y Commit Messages.

### Patrón 5: Enterprise / administradores como stakeholder implícito

La documentación de MCP menciona "managed MCP enterprise config" para configuración centralizada. El sistema de plugins tiene `strictKnownMarketplaces` para controlar qué plugins pueden instalarse. El hook `PermissionDenied` sugiere flujos de auditoria. El stakeholder enterprise existe pero no tiene documentación dedicada — está disperso en varios módulos.

Fuente: `05-mcp/README.md`, sección Enterprise; `07-plugins/README.md`, sección strictKnownMarketplaces.

## Conceptos

- **Progressive disclosure by skill level**: el repo adapta la profundidad al nivel del lector
- **Team shared memory**: `project-CLAUDE.md` como single source of truth para equipos
- **Self-assessment quiz**: herramienta para que el lector auto-clasifique su nivel antes de empezar
- **Contributor persona**: stakeholder adicional que mantiene el repo mismo

## Notas

El repo trata implícitamente al "contributor" como un stakeholder de primer orden al tener un STYLE_GUIDE detallado. Esto distingue claude-howto de documentación técnica típica donde los contribuidores son ciudadanos de segunda clase.
