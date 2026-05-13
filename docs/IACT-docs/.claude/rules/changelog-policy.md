```yml
type: Política de Proyecto
category: Changelog y Trazabilidad
version: 1.0.0
created_at: 2026-04-27 04:55:00
updated_at: 2026-04-27 04:55:00
applies_to: IACT-docs v1.0.0+
```

# Changelog Policy — Dos niveles de registro

> Cargado automáticamente. Aplica a TODO cambio en este repositorio.

## Regla principal

| Documento | Cuándo se actualiza | Quién |
|-----------|---------------------|-------|
| `track/{wp}-changelog.md` (dentro del WP) | **Siempre** que haya un cambio real durante el WP | Quien hace el cambio (Claude o humano) |
| `CHANGELOG.md` (raíz) | **Solo** en merge a `main` con bump de versión | Quien hace el merge |

**Nunca** editar `CHANGELOG.md` raíz mientras el trabajo esté en una rama
feature o en develop. **Siempre** registrar los cambios en el WP-changelog
correspondiente.

## Por qué dos niveles

`CHANGELOG.md` raíz es el contrato público del proyecto — describe lo que
existe en `main` (lo que un usuario verá si clona). Si se actualiza desde
una feature branch, miente sobre el estado actual de `main` mientras la
feature no se mergee, y queda inconsistente si la feature se aborta.

`track/{wp}-changelog.md` es el registro interno del WP — captura todo lo
que el WP hizo, con la granularidad que necesita el ejecutor. Es la fuente
para construir la entrada de CHANGELOG.md cuando llega el merge.

## Flujo

```
[trabajo en feature/foo]
      │
      ├── cambio 1 → registrar en track/foo-changelog.md
      ├── cambio 2 → registrar en track/foo-changelog.md
      ├── cambio N → registrar en track/foo-changelog.md
      │
      └── PR merge a main (con bump de versión)
            │
            └── promover entradas relevantes de
                track/foo-changelog.md → CHANGELOG.md raíz
                bajo [X.Y.Z] — YYYY-MM-DD
```

## Ubicación del WP-changelog

Por convención THYROX:

```
.thyrox/context/work/{wp}/track/{wp}-changelog.md
```

Si el WP aún no tiene cajón `track/`, crearlo apenas haya el primer cambio
que registrar (no esperar a Phase 11). El cajón existe para alojar el
changelog desde el inicio — su nombre coincide con el de la fase pero no
implica que el WP esté en Phase 11.

## Estructura del WP-changelog

Usar las secciones de [Keep a Changelog](https://keepachangelog.com/):

- `## Added` — nuevos archivos, features, capacidades.
- `## Changed` — modificaciones a comportamiento o configuración existente.
- `## Removed` — archivos, features, branches eliminados.
- `## Deprecated` — marcado como obsoleto, no removido aún.
- `## Fixed` — bug fixes.
- `## Security` — vulnerabilidades corregidas.

Adicionalmente, para WPs de THYROX:

- `## Aceptado / no fixeado` — decisiones de no actuar (con razón).
- `## Status de promoción a CHANGELOG.md raíz` — qué pasa al merge.

## Trazabilidad

Cada entrada DEBE referir al hallazgo, tarea o ADR que la motiva:

```
- pyproject.toml `readme` apunta a `readme.rst` — antes referenciaba
  `README.md` inexistente (F-02).
```

## Promoción al merge

Cuando un PR llega a `main`:

1. Verificar versión declarada en `pyproject.toml`. Si no se va a hacer
   bump, el PR no debe tocar `CHANGELOG.md`.
2. Si hay bump, abrir `CHANGELOG.md` raíz y crear sección
   `## [X.Y.Z] — YYYY-MM-DD`.
3. Copiar entradas relevantes de `track/{wp}-changelog.md` agrupadas por
   categoría, condensándolas si están demasiado granulares.
4. Mantener `track/{wp}-changelog.md` intacto en el WP (es histórico).

## Excepciones

- **Hot-fix en main:** un commit de hot-fix directo en `main` puede
  actualizar `CHANGELOG.md` en el mismo commit, sin pasar por WP. Es la
  única excepción y debe ser raro.
- **Documentación pura del CHANGELOG.md mismo** (typo, formato): puede
  cambiarse sin bump, mientras no cambie el contenido de releases.

## Anti-patrones prohibidos

```
# PROHIBIDO: editar CHANGELOG.md desde rama feature
git checkout feature/foo
echo "- new thing" >> CHANGELOG.md
git commit ...

# PROHIBIDO: registrar cambios solo en commit messages, sin WP-changelog
git commit -m "Add new thing" # ← perdido cuando el WP cierre

# CORRECTO: registrar primero en WP-changelog, luego commit
echo "- new thing (F-NN)" >> .thyrox/context/work/{wp}/track/{wp}-changelog.md
git add ...
git commit ... # body referencia el WP-changelog
```

## Relación con commits Tim Pope

El body del commit (Tim Pope style) explica QUÉ y POR QUÉ del cambio
puntual. El WP-changelog acumula esos cambios en formato Keep a Changelog
para consumo posterior. Son complementarios, no redundantes:

| Granularidad | Documento |
|--------------|-----------|
| 1 cambio individual | Commit message body |
| Conjunto de cambios del WP | WP-changelog |
| Release público | CHANGELOG.md raíz |
