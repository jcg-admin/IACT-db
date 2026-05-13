---
id: L-002
titulo: Bulk-sed en docs de plataforma introdujo paths específicos del proyecto
categoria: Referencias
origen_wp: 2026-04-14-09-13-51-context-migration
origen_fase: FASE 35
fecha: 2026-04-14
---

## Contexto

Durante la migración `.claude/context/` → `.thyrox/context/`, se ejecutó
un `sed` en batch para actualizar todas las referencias al path antiguo.
El sed se aplicó correctamente a scripts y agentes, pero también afectó
`.claude/references/` — los docs de plataforma Claude Code.

## Qué Pasó

Docs de plataforma como `hook-authoring.md`, `tool-execution-model.md`,
`hooks.md` pasaron de tener paths abstractos/genéricos a tener paths
específicos de THYROX:

```
# Antes (correcto — abstracto)
Write(/context/work/**)

# Después del sed (incorrecto — THYROX-específico)
Write(/.thyrox/context/work/**)
```

El error fue detectado por el usuario: *"los /home/user/thyrox/.claude/references/
deben ser enfocados en cosas abstractas y no en implementaciones de nuestro proyecto"*.

## Causa Raíz

El bulk-sed tenía el scope incorrecto: se aplicó a **todos** los archivos
que contenían `.claude/context/`, sin distinguir entre:
- Archivos de configuración del proyecto (scripts, agentes) → deben actualizarse
- Docs de plataforma abstractos (references/) → deben mantenerse genéricos

## Solución Aplicada

Revertir los paths en 8 archivos de `.claude/references/`:
- `hook-authoring.md`, `tool-execution-model.md`, `hooks.md`, `tool-patterns.md`
- `component-decision.md`, `memory-patterns.md`, `skill-authoring.md`, `claude-code-components.md`

Regla establecida: los ejemplos THYROX en referencias deben tener label
`Ejemplo THYROX:` sin mencionar FASE, usando paths relativos.

## Clave del Aprendizaje

**Antes de cualquier bulk-sed, clasificar el scope por semántica del archivo,
no solo por contenido.** `.claude/references/` es documentación de plataforma
abstracta — siempre debe mantenerse independiente del proyecto.

## Aplicación Futura

Al hacer bulk-sed en futuros WPs:

```bash
# MAL: aplicar a todo el repo
sed -i 's|old|new|g' $(git ls-files)

# BIEN: aplicar solo a archivos de proyecto (scripts, agentes, SKILL.md)
for f in .claude/scripts/*.sh .claude/agents/*.md .claude/skills/**/*.md; do
  sed -i 's|old|new|g' "$f"
done
# .claude/references/ NO — son docs de plataforma abstracta
```

Antes de ejecutar, verificar con `grep -r "patron" .claude/references/` si hay falsos positivos.

## Referencias

- WP: `.thyrox/context/work/2026-04-14-09-13-51-context-migration/`
- Commits fix: `fix(references): revertir paths .thyrox → genéricos en docs de plataforma`
- Relacionado: L-001 (alcance incorrecto de operaciones batch)
