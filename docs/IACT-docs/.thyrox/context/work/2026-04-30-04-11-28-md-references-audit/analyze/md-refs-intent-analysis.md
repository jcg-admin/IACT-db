```yml
created_at: 2026-04-30 07:30:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis profundo: las 803 refs `.md` y su intención original

> Aplicación de metodología THYROX (analizar antes de transformar)
> sobre las 803 refs `.md` remanentes. Cada archivo source se
> analiza por la **intención** del autor original, NO por
> reemplazo mecánico. Las decisiones se justifican en `.thyrox`
> per la skill metodológica.

## Lección aprendida (del intento mecánico fallido)

Mi transformación previa `.md → .rst` fue mecánica. Resultados
problemáticos detectados por el ejecutor:

1. URL de Angular CONTRIBUTING quedó rota (.md era la realidad —
   Angular usa markdown, no .rst).
2. README.md en tree diagrams del repo quedó como `README` sin
   indicación de que es archivo (parece directorio).
3. Refs a docs históricos no migrados (`ADR-015-frontend-modular-monolith.md`)
   quedaron como `.rst` cuando NO existen como `.rst` tampoco.
4. Refs a archivos en directorios fuera del Sphinx site
   (`/docs/`, `/scripts/`) quedaron transformados sin saber si
   existen como `.rst` allá.

**Lección:** la regla universal `.md → .rst` falla porque las
refs tienen orígenes heterogéneos.

## Distribución de las 803 refs por archivo source

| Archivo | # refs | % |
|---------|--------|---|
| `proc-gob-001-mapeo-procesos-templates.rst` | 179 | 22% |
| `proc-gob-008-reorganizacion-estructura-documental.rst` | 44 | 5.5% |
| `proced-gob-005-analisis-impacto-cambios.rst` | 39 | 4.9% |
| `proc-gob-002-gobernanza-sdlc.rst` | 38 | 4.7% |
| `adr-gob-004-clasificacion-reglas-negocio.rst` | 30 | 3.7% |
| `proc-req-019-trazabilidad-requisitos.rst` | 26 | 3.2% |
| `adr-gob-003-jerarquia-requerimientos-5-niveles.rst` | 23 | 2.9% |
| `proced-gob-004-crear-caso-uso.rst` | 19 | 2.4% |
| `adr-gob-005-especificacion-casos-uso.rst` | 19 | 2.4% |
| `proced-gob-009-refactorizaciones-codigo-tdd.rst` | 18 | 2.2% |
| Top 10 | 435 | **54%** |
| Resto (89 archivos) | 368 | 46% |

**Hallazgo:** atacar los **top 10 archivos** resuelve más de la
mitad del corpus. Estos archivos son procedures y ADRs de
gobernanza con contenido pedagógico/normativo histórico.

## Categorización refinada por intención original

### Cat A — Tree diagrams del repo (estructura real)

**Ejemplo:**
```
iact-cpython-builder/
├── cpython-system-builder/
│   └── README.md          ← archivo real del repo
└── README.md              ← archivo real del repo
```

**Intención original:** documentar estructura física del repo.
Los archivos README.md SON archivos reales fuera de source/.

**Estimado:** ~50-80 refs.

**Decisión correcta:**
- Si el repo SÍ tiene README.md (no .rst) → mantener `.md`
  porque es la realidad física.
- Si el repo migró a README.rst → cambiar a `.rst`.

**Verificación necesaria:** correr `find` en repo raíz para
confirmar formato real de READMEs.

### Cat B — URLs externas a proyectos third-party

**Ejemplo:**
```
- Angular Convention: https://github.com/angular/angular/blob/main/CONTRIBUTING.md
```

**Intención original:** referencia a doc oficial de proyecto
third-party (Angular, WASI). Esos proyectos usan `.md` en sus
repos.

**Estimado:** 3 refs.

**Decisión correcta:**
- Cambiar URL al **HTML rendered** del proyecto (si tiene sitio).
- Si no tiene HTML rendered, cambiar URL `/blob/main/CONTRIBUTING.md`
  → `/tree/main` (vista del repo) y mencionar archivo en texto.
- Última opción: descripción textual sin URL.

### Cat C — Refs a docs históricos NO migrados

**Ejemplo:**
```
``ADR-015-frontend-modular-monolith.md`` (documento histórico)
```

**Intención original:** mantener trazabilidad a doc histórico
que no se migró. La nota "(documento histórico)" lo marca
explícitamente.

**Estimado:** ~30-50 refs.

**Decisión correcta:** quitar `.md` (queda como nombre sin
extensión) y mantener nota "(documento histórico, no migrado)".

### Cat D — Refs a docs en `/docs/` (legacy, fuera de Sphinx)

**Ejemplo:**
```
docs/guias/GUIA-BACK-003-authentication-guide.md
docs/gobernanza/requisitos/reglas_negocio/restricciones/RN-BACK-001-...md
```

**Intención original:** referencias en bloques de código mostrando
paths del repo legacy `/docs/` antes de migrar a `/source/`.

**Estimado:** ~150-200 refs.

**Verificación necesaria:** confirmar si `/docs/` aún existe en
el repo o ya fue eliminado tras migración.

**Decisión correcta:**
- Si `/docs/` ya no existe: convertir refs a paths en `source/`
  con `.rst`.
- Si aún existe (legacy): mantener `.md` como referencia al
  archivo legacy real.

### Cat E — Listados pedagógicos en proc-gob-001

**Ejemplo:**
```
2. Derivar requisito de negocio
   └─> Crear: RN-001-dark-mode.md (template_requisito_negocio.md)
```

**Intención original:** ejemplo paso-a-paso del proceso SDLC
aplicado a feature dark-mode.

**Estimado:** ~150 refs en proc-gob-001.

**Decisión correcta:**
- Wrap en `.. admonition:: Ejemplo SDLC — feature Dark Mode`.
- Cambiar `.md` → `.rst` (refleja realidad migrada).
- Plus: link a saga real
  (`/base-cognitiva/_ejemplos-pedagogicos/ejemplo-dark-mode/`).

### Cat F — Naming patterns documentando convención

**Ejemplo:**
```
Artefactos generados:
- ``BN-001-nombre-business-need.md``
- ``RF-001-nombre-requisito-funcional.md``
```

**Intención original:** mostrar el pattern de naming para
artefactos generados.

**Estimado:** ~50 refs.

**Decisión correcta:**
- Si los artefactos se generan como `.rst` ahora → cambiar
  a `.rst`.
- Si se generan como `.md` (convención del proceso) → mantener `.md`.
- Verificar política STD-007 sobre formato de artefactos
  generados.

### Cat G — Shell commands y herramientas

**Ejemplo:**
```bash
find docs/ -name "*.md" -mtime +180
grep -r "RN-BACK-001" --include="*.md" .
markdownlint docs/guias/GUIA-BACK-003-authentication-guide.md
```

**Intención original:** comandos reales para operar sobre
archivos `.md` históricos.

**Estimado:** ~30 refs.

**Decisión correcta:**
- Si los comandos siguen siendo aplicables al repo legacy:
  mantener.
- Si el repo ya se migró a `.rst`: cambiar comandos a `.rst`.
- Comandos como `markdownlint` solo aplican a `.md`; si el
  proyecto no tiene archivos `.md` ya, eliminar el comando.

### Cat H — Discusión del formato `.md` como concepto

**Ejemplo:**
```
**En Markdown (.md):**
Documentación técnica (.rst, .md)
```

**Intención original:** documentar formatos soportados o
discutir markdown como tecnología.

**Estimado:** ~10 refs.

**Decisión correcta:**
- Si el proyecto SÍ acepta `.md` → mantener.
- Si solo acepta `.rst` → quitar mención de `.md`.

### Cat I — Tutorial/ejemplos de comandos git

**Ejemplo:**
```
git add docs/requisitos/*.md
git add docs/guias/GUIA-BACK-003-authentication-guide.md
```

**Intención original:** ejemplo de comando git en tutorial.

**Estimado:** ~50 refs.

**Decisión correcta:** dependiente de Cat D (si /docs/ existe o no).

## Distribución estimada

| Cat | Cantidad estimada | Acción dominante |
|-----|-------------------|-------------------|
| A — Tree diagrams del repo | 50-80 | Verificar formato real |
| B — URLs externas | 3 | Cambiar a HTML rendered |
| C — Históricos no migrados | 30-50 | Quitar extensión + nota |
| D — Refs a /docs/ legacy | 150-200 | Verificar si /docs/ existe |
| E — Listados pedagógicos | 150 | Wrap admonition + .rst |
| F — Naming patterns | 50 | Confirmar política output |
| G — Shell commands | 30 | Cambiar a .rst si proyecto migrado |
| H — Discusión del formato | 10 | Solo si .md aceptado |
| I — Comandos git tutorial | 50 | Verificar /docs/ |
| **TOTAL** | **~550-650** | (resto aún sin clasificar) |

## Verificaciones requeridas antes de transformar

### V1 — ¿Existe `/docs/` aún en el repo?

```bash
ls /home/user/IACT-docs/docs/ 2>&1 | head
```

Si NO existe → Cat D y Cat I se transforman a paths en `source/`.
Si SÍ existe → Cat D y Cat I se mantienen literales (refs reales).

### V2 — ¿Formato real del README del repo?

```bash
ls /home/user/IACT-docs/README* 2>&1
ls /home/user/IACT-docs/CHANGELOG* 2>&1
ls /home/user/IACT-docs/LICENSE* 2>&1
```

Determina si Cat A mantiene `.md` o cambia a `.rst`.

### V3 — ¿Política STD-007 sobre formato de artefactos generados?

Leer STD-007 actual: ¿los artefactos generados son `.rst` o `.md`?
Determina Cat F.

### V4 — ¿Hay `.md` en `temp-holding/`?

```bash
find /home/user/IACT-docs/temp-holding -name "*.md" | wc -l
```

Determina si refs históricas (Cat C) tienen archivos reales
en temp-holding o son nombres conceptuales.

## Decisiones por aprobar (Phase 5 STRATEGY)

Antes de ejecutar transformaciones, aprobar caso por caso:

1. **Tree diagrams del repo (Cat A):** ¿mantener `.md` (realidad
   física) o cambiar a `.rst` (asumiendo proyecto migrado)?
2. **URLs externas (Cat B):** ¿cambiar a HTML rendered, vista
   de repo (sin .md), o descripción textual?
3. **Refs históricas (Cat C):** ¿quitar extensión + nota
   "no migrado", o mantener `.md` con nota?
4. **Refs `/docs/` legacy (Cat D):** verificar si `/docs/` existe.
   Si no, cambiar a `source/.rst`. Si sí, mantener.
5. **Listados pedagógicos (Cat E):** ¿wrap en `.. admonition::
   Ejemplo` con `.rst` adentro, o link a saga dark-mode real?
6. **Naming patterns (Cat F):** ¿qué formato salen los
   artefactos generados — `.rst` o `.md`? Confirmar STD-007.
7. **Shell commands (Cat G):** ¿proyecto produce solo `.rst`
   o también `.md`? Determina si commands cambian.
8. **Discusión del formato (Cat H):** ¿proyecto acepta `.md`
   en algún lugar?
9. **Tutoriales git (Cat I):** dependiente de V1 (Cat D).

## Próximo paso (Phase 4 CONSTRAINTS + Phase 5 STRATEGY)

Ejecutar las verificaciones V1-V4, llenar las cantidades con
datos reales, y obtener aprobación del ejecutor para cada
categoría antes de transformar.

**NO transformar mecánicamente** — cada categoría tiene
contexto distinto y la transformación correcta depende de
hechos verificables del repo.
