```yml
type: Índice de Lecciones Aprendidas
version: 1.1
created_at: 2026-04-14 20:34:23
updated_at: 2026-04-14 21:30:00
```

# Lecciones Aprendidas — Índice Global

Lecciones con impacto cross-WP promovidas desde `work/*/lessons-learned.md`.
Para lecciones locales de un WP específico, ver el WP directamente.

---

## Índice

| Archivo | Lección | Origen | Categoría | Fecha |
|---------|---------|--------|-----------|-------|
| [script-sin-registrar](script-sin-registrar.md) | Script creado sin registrar en settings.json | FASE 35 | Infraestructura | 2026-04-14 |
| [referencias-abstractas](referencias-abstractas.md) | Bulk-sed en docs de plataforma con paths del proyecto | FASE 35 | Referencias | 2026-04-14 |
| [env-var-sesion-activa](env-var-sesion-activa.md) | `settings.json` env vars no propagan a subagentes de sesión activa | FASE 35 | Configuración | 2026-04-14 |
| [bound-agente-timeout](bound-agente-timeout.md) | Instrucciones de agente sin scope bound causan timeouts | FASE 35 | Agentes | 2026-04-14 |

---

## Categorías

| Categoría | Descripción |
|-----------|-------------|
| Infraestructura | Hooks, scripts, settings, wiring |
| Referencias | Docs de plataforma, paths, arquitectura de referencias |
| Configuración | Variables de entorno, settings.json, timeouts |
| Agentes | Subagentes, prompts, scope, paralelismo |
| Git | Commits, migraciones, historial |
| Metodología | Fases, gates, SKILL, CLAUDE.md |

---

## Cuándo Promover una Lección

| Momento | Acción | Criterio |
|---------|--------|----------|
| Phase 7: TRACK | Revisar `{wp}-lessons-learned.md` | ¿Esta lección evitaría el mismo error en futuros WPs? Si sí → promover |
| Phase 6: EXECUTE | Detectar recurrencia cross-WP | Si la misma lección ya está documentada, reforzar en `patterns/` |

## Cómo Promover una Lección

1. La lección debe haber ocurrido en un WP (está en `work/.../lessons-learned.md`)
2. Debe tener impacto cross-WP: evitaría el mismo error en futuros WPs
3. Crear `{descripcion-corta}.md` (kebab-case, sin números, auto-explicativo)
   usando el template: `.claude/skills/workflow-track/assets/lesson.md.template`
4. Agregar al índice de este README
5. Si generó un patrón de solución, crear también en `patterns/`

**Naming:** El nombre del archivo = la lección en sí (sin prefijo L-NNN).
Los `id: L-NNN` son referencias internas documentales, no nombres de archivo.
