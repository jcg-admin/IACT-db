```yml
created_at: 2026-04-30 07:45:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Estrategia de eliminación de `.md` con verificaciones reales

> Tras Phase 3 ANALYZE (`md-refs-intent-analysis.md`), las
> verificaciones V1-V4 producen hechos del repo. Esta estrategia
> usa los hechos para decidir cada categoría.

## Hechos verificados (V1-V4 ejecutadas)

### V1 — `/docs/` legacy NO existe

```bash
$ ls /home/user/IACT-docs/docs/
No such file or directory
```

**Implicación:** todas las refs a paths `/docs/...md` (Cat D, ~150-200)
son referencias **legacy a estructura eliminada**. Los archivos
ya no existen en ninguna forma.

### V2 — Archivos en raíz del repo

```bash
$ ls README* LICENSE* CHANGELOG*
CHANGELOG.md         # SÍ existe, formato .md
README*              # NO existe (readme.rst per STD-007)
LICENSE*             # NO existe
```

**Implicación:**
- `CHANGELOG.md` es **archivo real**. Cualquier ref textual a
  CHANGELOG debe respetar este nombre.
- `README.md` referenciado **no existe** — ya migró a
  `readme.rst` o no aplica.
- `LICENSE.md` referenciado **no existe** tampoco.

### V3 — STD-007 declara formatos

STD-007 v2.0.2 § 5.1 declara:

```
- Todos los archivos .rst bajo source/.
- En raíz: LICENSE, CHANGELOG.md, ROADMAP.md, readme.rst
```

**Implicación oficial:**
- `.rst` es el único formato dentro de `source/`.
- En raíz, el proyecto **acepta `.md` excepcionalmente** para
  CHANGELOG.md y ROADMAP.md.
- README es `readme.rst`, NO README.md.

### V4 — temp-holding tiene 2347 archivos `.md`

**Implicación:** los archivos históricos referenciados con `.md`
muchas veces SÍ existen físicamente en `temp-holding/` aunque
no en `source/`.

## Estrategia por categoría (revisada con hechos)

### Cat A — Tree diagrams del repo (50-80 refs)

**Hecho:** README es `readme.rst` (no README.md).

**Decisión:** cambiar `README.md` → `readme.rst` en tree diagrams
que muestran estructura del repo. Excepto cuando el tree muestra
un subdirectorio cuyo README es realmente `.md` — verificar
caso por caso.

### Cat B — URLs externas a third-party (3 refs)

**Hecho:** son links a Angular, WASI. Esos proyectos usan `.md`
en sus repos.

**Decisión:**
- Angular CONTRIBUTING → `https://angular.dev/contribute` (web oficial)
- WASI docs.md → `https://wasi.dev/` (sitio web del proyecto)
- Repo example "/org/repo/.../ADR-BACK-006-...md" → claramente es
  ejemplo placeholder, cambiar a URL ejemplo abstracta sin .md

### Cat C — Refs a docs históricos no migrados (30-50 refs)

**Hecho:** algunos están en temp-holding/ (V4 = 2347 archivos).

**Decisión:** quitar extensión + agregar nota
"(documento histórico, ver temp-holding/ si requiere consulta)".

### Cat D — Refs a `/docs/` legacy (150-200 refs)

**Hecho clave:** `/docs/` NO existe (V1). Son **refs muertas**.

**Decisión:**
- Si la ref está en un **bloque de código** (find, grep, git add)
  como **EJEMPLO**: cambiar `*.md` → `*.rst` (refleja realidad
  actual del proyecto) — los comandos siguen siendo válidos
  pedagógicamente.
- Si la ref está en **texto narrativo** apuntando a un doc
  específico: mapear a su equivalente en `source/` si existe,
  o marcar como histórico no migrado.

### Cat E — Listados pedagógicos en proc-gob-001 (179 refs)

**Hecho:** son ejemplos del flujo SDLC aplicado a "dark-mode".
La saga real existe en `source/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/`.

**Decisión:**
1. Wrap toda la sección 5.1 "Flujo Completo (Dark Mode)" en
   `.. admonition:: Ejemplo pedagógico SDLC`.
2. Cambiar `.md` → `.rst` dentro del bloque (refleja realidad).
3. Plus la nota ya existente (commit `948ab32`) que linkea a
   la saga real.

### Cat F — Naming patterns documentando convención (50 refs)

**Hecho:** STD-007 dice que artefactos en `source/` son `.rst`.

**Decisión:** cambiar `.md` → `.rst` en patterns. Refleja la
realidad del proyecto.

### Cat G — Shell commands (30 refs)

**Hecho:** `/docs/` no existe. El proyecto migró a `source/`
con `.rst`.

**Decisión:**
- Comandos como `find docs/ -name "*.md"`: cambiar a
  `find source/ -name "*.rst"` (refleja proyecto actual).
- Si el comando es para `markdownlint` (solo .md):
  reemplazar por equivalente para `.rst` (e.g. `rstcheck`)
  o eliminar el comando.

### Cat H — Discusión del formato `.md` como concepto (10 refs)

**Hecho:** STD-007 acepta `.md` SOLO en raíz (CHANGELOG, ROADMAP).
En `source/` solo `.rst`.

**Decisión:** actualizar discusión de formatos para reflejar
política STD-007:
- "Documentación (.rst, .md)" → "Documentación (.rst en source,
  .md solo en raíz para CHANGELOG/ROADMAP)"
- "**En Markdown (.md):**" → eliminar la sección o explicar
  que aplica solo a CHANGELOG/ROADMAP de raíz

### Cat I — Comandos git tutorial (50 refs)

**Hecho:** `/docs/` no existe.

**Decisión:** los comandos git tutoriales que muestran
`git add docs/...md` son ejemplos pedagógicos. Cambiar a
`git add source/.../*.rst` (refleja proyecto actual).

### Cat especial — CHANGELOG.md (caso único)

**Hecho:** CHANGELOG.md SÍ existe en raíz (V2 + STD-007).

**Decisión:** cuando una ref apunta a CHANGELOG en raíz del
repo, mantener `CHANGELOG.md` (es archivo real). En source/,
sin embargo, no debería haber refs de hyperlink a CHANGELOG
porque está fuera del sitio Sphinx; usar URL absoluta GitHub
o texto descriptivo.

## Plan de transformación final

Aplicar en este orden (sin builds intermedios per instrucción):

### Pase 1 — Tree diagrams del repo (Cat A)

`README.md` → `readme.rst` en bloques `::` que muestran
estructura del repo.

### Pase 2 — URLs externas (Cat B)

3 reemplazos específicos:
- `https://github.com/angular/angular/blob/main/CONTRIBUTING.md`
  → `https://angular.dev/contribute`
- `https://github.com/WebAssembly/WASI/blob/main/phases/snapshot/docs.md`
  → `https://wasi.dev/`
- `https://github.com/org/repo/blob/main/docs/.../ADR-BACK-006-...md`
  → `https://github.com/{org}/{repo}` (placeholder ejemplo sin .md)

### Pase 3 — Históricos en backticks (Cat C)

`` ``ADR-015-frontend-modular-monolith.md`` (documento histórico) ``
→
`` ``ADR-015-frontend-modular-monolith`` (documento histórico, no migrado) ``

Pattern: dentro de backticks ``foo.md``, si va seguido de
"(documento histórico)" o similar, quitar extensión.

### Pase 4 — Listados pedagógicos (Cat E)

Wrap sección 5.1 de `proc-gob-001` en
`.. admonition:: Ejemplo pedagógico SDLC — Dark Mode`.
Cambiar `.md` → `.rst` dentro.

### Pase 5 — Naming patterns y refs migradas (Cat F + Cat D + Cat I)

Cambio bulk: `.md` → `.rst` para todas las refs en proyecto
actual (artefactos generados, paths /docs/ → source/, comandos
git tutoriales).

### Pase 6 — Shell commands (Cat G)

`find docs/ -name "*.md"` → `find source/ -name "*.rst"`
`markdownlint X.md` → eliminar o cambiar a equivalente .rst

### Pase 7 — Formato discutido (Cat H)

Actualizar STDs y guías para reflejar política real:
- Solo .rst en source/
- .md aceptado solo en CHANGELOG.md / ROADMAP.md de raíz

### Pase 8 — Casos especiales

- CHANGELOG.md en raíz → mantener literal
- `readme.rst` (no README.md) → corregir mapeo
- Comments en code-blocks que mencionan `.md` → cambiar a `.rst`

## Decisiones a aprobar antes de ejecutar

1. ¿Apruebas Pase 1 (`README.md` → `readme.rst` en tree diagrams)?
2. ¿Apruebas las 3 URLs externas reemplazadas (Angular, WASI, ejemplo)?
3. ¿Apruebas Pase 3 (históricos en backticks pierden extensión)?
4. ¿Apruebas Pase 4 (wrap proc-gob-001 §5.1 en `.. admonition:: Ejemplo`)?
5. ¿Apruebas Pase 5 (`.md` → `.rst` bulk en naming patterns y
   paths /docs/ → source/)?
6. ¿Apruebas Pase 6 (shell commands actualizados a proyecto actual)?
7. ¿Apruebas mantener CHANGELOG.md literal en su único contexto válido?

## Riesgos / consideraciones

- **Riesgo 1:** algunas refs Cat D pueden ser refs históricas
  legítimas (no ejemplos pedagógicos) — perderemos la nota
  "(legacy en /docs/)" si no se distingue.
  - Mitigación: revisar antes de transformar paths que estén
    fuera de bloques `::` (los bloques son pedagógicos; el
    texto narrativo puede ser histórico).
- **Riesgo 2:** Sphinx puede tener formato diferente para
  `:doc:` vs literal cuando el path es histórico. Verificar.
- **Riesgo 3:** algunos ADRs (adr-gob-007 línea 402) tienen
  comandos `find` que son spec del proceso documentado, no
  ejemplos pedagógicos. Cambiar a `.rst` puede romper la spec.
  - Mitigación: leer cada Cat G antes de transformar.

## Métricas de éxito

- ✓ 0 refs `.md` en source/ (excepto CHANGELOG.md cuando
  apunta a archivo real en raíz repo).
- ✓ Build `make html` sin warnings nuevos.
- ✓ Listados pedagógicos en proc-gob-001 marcados explícitamente
  como ejemplos via `.. admonition::`.
- ✓ Refs históricas mantienen trazabilidad sin extensión confusa.
- ✓ STDs y guías reflejan política real de formatos del proyecto.
