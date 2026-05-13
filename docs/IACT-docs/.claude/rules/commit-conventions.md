# Commit Conventions — Tim Pope Style

> Cargado automáticamente. Aplica a TODOS los commits en este repositorio.
> Reemplaza el estilo Conventional Commits (vigente hasta ÉPICA 4).

## Las 7 reglas

1. **Subject y body separados por línea en blanco.**
2. **Subject ≤ 50 caracteres** (máximo absoluto: 72).
3. **Subject capitalizado** (primera letra mayúscula).
4. **Sin punto final en el subject.**
5. **Modo imperativo en el subject** ("Add", "Fix", "Refactor" — no "Added", "Adding").
6. **Body envuelto a 72 caracteres** por línea.
7. **El body explica QUÉ y POR QUÉ — no CÓMO.** El diff ya muestra el cómo.

## Formato canónico

```
Subject corto en imperativo (≤50 ch)

Cuerpo opcional pero RECOMENDADO. Explica el contexto: por qué se hizo
este cambio, qué problema resuelve, qué alternativas se descartaron y
por qué. Wrap a 72 caracteres por línea.

Si hay varios puntos relevantes, usar bullets:

- Punto uno con su justificación
- Punto dos
- Referencia a hallazgos: F-11, T-001, ADR-019

Refs: F-11, ADR-019
```

## Cuándo el body es OBLIGATORIO

Salvo en commits triviales (typo, formato, rename de archivo sin cambios
de contenido), el body es **obligatorio**. Si no podés escribir 2-3 líneas
de contexto, probablemente el commit es muy chico y se puede combinar con
otro, o muy grande y debería partirse.

**Excepciones permitidas (subject solo):**
- Merge commits (formato auto-generado por git)
- Revert commits (formato auto-generado por git revert)
- Commits triviales: typo, format, rename sin lógica nueva

## Ejemplos correctos

### Cambio simple con contexto
```
Add THYROX plugin manifest

The /thyrox:* namespace was declared in ADR-019 but the manifest
was never created. Without it, the session-start hook recommended
a non-existent command.

Refs: F-11
```

### Cambio mediano con alternativas
```
Wire local plugin via directory marketplace

settings.json schema rejected inline plugins with relative paths
(error: "settings-sourced marketplace must use remote sources").

Considered three approaches:

- Inline source "settings": rejected (no relative paths allowed)
- Symlinks at repo root: rejected (Windows compatibility)
- Marketplace tipo "directory" pointing to local marketplace.json:
  chosen — paths relative to marketplace.json are allowed

Refs: F-11
```

### Trivial (solo subject)
```
Fix typo in README
```

## Anti-patrones prohibidos

```
WIP                          ← sin contexto, no commiteable
update                       ← inútil
fix stuff                    ← sin contexto
Added new feature.           ← pasado + punto final
add new feature              ← minúscula
feat(scope): add feature     ← convencional commits viejo, ya no se usa
```

## Trazabilidad a hallazgos / WPs

Cuando el commit responde a un hallazgo (F-NN), una tarea (T-NNN), o un
ADR, mencionarlos al final del body con `Refs:`:

```
Refs: F-01, F-11, ADR-019
```

## Migración desde Conventional Commits

El historial previo a ÉPICA 4 usa `type(scope): description`. NO se reescribe
— git history es inmutable. A partir del próximo commit en este branch,
aplica Tim Pope.

## Validación automática

`.githooks/commit-msg` valida:

- Subject ≤ 72 caracteres
- Subject empieza con mayúscula
- Subject NO termina en punto
- Subject en imperativo (heurística: no termina en `ed`, `ing`, `s`)

El hook NO valida el body (demasiado heurístico) — esa es responsabilidad
del autor.

Para activar el hook en un clone nuevo: `bash scripts/install-hooks.sh`.
