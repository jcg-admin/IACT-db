```yml
created_at: 2026-04-28 01:58:08
project: IACT-docs
author: NestorMonroy
status: Aprobado
version: 2.0.0
```

# Phase 1 DISCOVER — Source Rebuild Strategy

## 1. Estado actual de `source/` (verificado)

```
source/                         379 .rst, 0 .md
├── _static/                      0 .rst
├── _templates/                   0 .rst
├── arquitectura_tecnica/        15 .rst
├── base_cognitiva/              33 .rst   ← punto de partida
├── gestion/                     15 .rst
├── normativa/                  149 .rst
├── plantuml-guide/               8 .rst
└── requisitos/                 158 .rst
```

Verificado con `find source -name "*.rst" | wc -l` → 379.

## 2. Hipótesis estratégica

Reconstruir `source/` desde cero, dominio por dominio, sobre un
snapshot inmutable (`temp-backup/`) que se versiona en git para
trazabilidad total.

**Por qué esto puede ser superior al cleanup incremental:**

- 34 patrones de naming distintos → cualquier renombre crea N
  refs rotas. Reconstruir aplicando STD_007 desde el principio
  evita el flicker continuo de "build se rompe / se arregla".
- 147 hyperlinks rotos no están distribuidos uniformemente —
  dominios con peor estado (procedimientos: 67 archivos) cargan
  el resto al hacer build con `-W`.
- El cleanup incremental requiere *holding pattern* (mantener
  todo funcional mientras se reescribe) — el rebuild permite
  trabajar en cada dominio aislado sin tocar los demás.

**Riesgo principal del rebuild:** perder contenido valioso al no
re-incorporarlo. Mitigación: `temp-backup/` versionado +
checklist de cobertura por dominio (cada artefacto del backup
debe estar marcado "incorporado", "descartado-con-razón" o
"pendiente").

## 3. Inventario de `base_cognitiva/` (dominio inicial)

33 archivos en 4 sub-dominios:

| Sub-dominio | Archivos | Patrón |
|-------------|----------|--------|
| `_fundamentos_conceptuales/` | FND_01..FND_07 + index | `FND_NN_Nombre.rst` |
| `_metadata/` | META_01..META_05 + index | `META_NN_Nombre.rst` |
| `_ontologia_sbvr/` | SBVR_01..SBVR_05 + index | `SBVR_NN_Nombre.rst` |
| `_taxonomias_y_metamodelos/` | metamodelos/ + taxonomias/ + index | `MTM_NN_*`, `TXM_NN_*` |
| (raíz) | glossary, glosario_babok_pmbok_iso, IACT_Glossary_v1_0_0, index | mixto |

Observaciones inmediatas:

- Underscores como prefijo de directorio (`_fundamentos_*`) — Sphinx
  los trata como ocultos en algunos contextos.
- Mezcla de patrones en raíz: `glossary.rst` (inglés), `glosario_babok_pmbok_iso.rst`
  (snake_case), `IACT_Glossary_v1_0_0.rst` (PascalCase + version).
- Convención `MOD_NN_Nombre.rst` (PascalCase con guion bajo) viola
  STD_007 (kebab-case recomendado), pero hay 33 archivos que
  comparten la convención — decisión: mantenerla con justificación
  o migrar.

## 4. Decisiones pendientes (a resolver en este WP)

### D1: ¿Versión final del backup?

- Opción A: `temp-backup/source-2026-04-28/` versionado en feature
  branch, gitignored en main.
- Opción B: rama dedicada `backup/source-pre-rebuild` con `source/`
  intacto, y feature branch limpio.
- **Decisión confirmada por ejecutor: A — temp-backup/ versionado.**

### D2: ¿Dominio inicial?

- **Decisión confirmada por ejecutor: `base_cognitiva/`.**
- Justificación: provee el vocabulario (glosario, ontología, fundamentos)
  del que dependen los demás dominios. Empezar aquí da el
  diccionario de términos que el resto va a usar.

### D3: ¿Build con `-W` durante rebuild?

- **Decisión confirmada por ejecutor: NO usar `-W` durante el
  rebuild.** Recuperar `-W` al final, cuando todos los dominios
  estén reconstruidos.

### D4: ¿Convención sobre prefijos numéricos en filenames?

**Resolución (2026-04-28):** No hay tensión real. La hipótesis
inicial era falsa. STD_007 **codifica IDs semánticos**, no los
prohíbe.

Verificación leyendo `source/normativa/estandares/STD_007_Convencion_Naming.rst`:

- Sección 4.1 define explícitamente patrones con ID semántico:
  `UC_<MOD>_<NN>_<Desc>.rst`, `BR_<NNN>_<Desc>.rst`,
  `STD_<NNN>_<Desc>.rst`, `FND_<NN>_<Desc>.rst`, etc.
- El propio archivo se llama `STD_007_*.rst` — si la regla
  prohibiera IDs numéricos, se estaría auto-violando.
- Sección 6 (Tabla de Decisión Rápida) lista 12 tipos de
  artefactos, casi todos con ID semántico obligatorio.

La regla "NO prefijos numéricos" que motivó la duda viene de
`.claude/rules/convention-naming.md` — pero esa regla aplica al
scope `.thyrox/context/` (artefactos del framework THYROX),
**no a `source/`**. Los dos scopes tienen reglas opuestas porque
el dominio es distinto: en `source/` los IDs son tracking
citables (UC-001, BR-001, STD-007); en `.thyrox/` no hay tracking
IDs en filenames.

**Decisión:** mantener los IDs semánticos de STD_007 tal cual.
No se renombran archivos por este motivo durante el rebuild.

### D5: ¿Strategy de re-incorporación de contenido?

**Resolución (2026-04-28): "Backup as reference" — material
consultivo, no fuente de copia.**

Tanto `temp-backup/` como `temp-holding/` son material **de
referencia consultiva**. Ningún archivo se copia mecánicamente
al nuevo `source/`.

| | Lift-and-shift descartado | Backup as reference (elegido) |
|---|---|---|
| Default por archivo | copiar y renombrar | **no copiar** |
| Decisión por archivo | renombrar + arreglar refs | leer referencia → decidir si el contenido sobrevive, se reescribe, se fusiona o se descarta |
| Pregunta guía | "¿cómo lo renombro?" | **"¿este contenido debe existir en el nuevo source/? Si sí, ¿cómo?"** |
| Resultado en `source/` | espejo normalizado del backup | nuevo `source/` escrito desde criterio editorial |

**Justificación:** el `source/` actual contiene problemas de
diseño y contenido (no solo de naming). Copiar mecánicamente el
backup propaga esos problemas al nuevo `source/`. Rebuild
editorial elimina problemas heredados desde el inicio.

**Criterio de aceptación cambia:** ya no es "todo archivo del
backup está en source/ con su nuevo nombre" sino **"todo archivo
del backup está clasificado como incorporado / fusionado-en-X /
reescrito / descartado-con-razón"**.

**Mitigación de pérdida de contenido:** ambos backups quedan en
git history y en directorios versionados — recuperables siempre
si se descubre que algo se descartó por error.

## 5. Orden de reconstrucción propuesto

Ordenado de menos a más dependencias salientes:

1. **`base_cognitiva/`** (33 archivos) — diccionario, sin
   dependencias hacia otros dominios.
2. **`normativa/estandares/`** (~10 archivos) — STDs y guías de
   estilo, depende del glosario.
3. **`normativa/procedimientos/`** (~67 archivos) — depende de
   estándares.
4. **`normativa/gobernanza/`** + **`normativa/restricciones/`** —
   dependen de procedimientos y estándares.
5. **`requisitos/`** (158 archivos) — depende del glosario y de
   las plantillas de estándares.
6. **`arquitectura_tecnica/`** (15 archivos) — depende de
   requisitos.
7. **`gestion/`** (15 archivos) — depende de todos los anteriores.
8. **`plantuml-guide/`** (8 archivos) — independiente, se puede
   hacer en cualquier momento o eliminar si no es esencial.

## 6. Criterios de aceptación por dominio

Cada WP de rebuild de dominio debe cumplir:

1. ✅ Build exit 0 con `sphinx-build -b html` (sin `-W`).
2. ✅ Todos los archivos del dominio en backup están marcados como
   incorporado / descartado-con-razón / pendiente.
3. ✅ Filenames y refs cumplen STD_007 (verificable por script).
4. ✅ Cero refs apuntando al backup (`temp-backup/`).
5. ✅ index.rst del dominio lista todo el contenido en toctree.

## 7. Bridge plan — mantener build verde durante rebuild

Durante el rebuild incremental:

- `source/index.rst` lista solo los dominios reconstruidos.
- Dominios pendientes viven en `temp-backup/` (no en toctree de
  source/). Sphinx no los conoce → no genera refs ni warnings.
- Refs entre dominios reconstruidos: usar `:ref:` con anchor explícito
  (no `:doc:` con path) para que un futuro renombre no rompa.
- Recuperar `-W` solo cuando los 7 dominios estén reconstruidos.

## 8. Resolución de hallazgos (2026-04-28)

| ID | Hallazgo | Resolución |
|----|----------|-----------|
| **F-04** | Destino de `plantuml-guide/` (8 archivos) | **Mover a `arquitectura_tecnica/plantuml-guide/`** durante el rebuild del dominio `arquitectura_tecnica/`. No es independiente; es soporte técnico de la arquitectura. |
| **F-05** | `_static/` y `_templates/` (infra Sphinx) | **Quedan en `source/`**. Son críticos para diseño y rendering del sitio publicado. Sin cambios estructurales. |
| **F-NEW-1** | Conflicto sin resolver en `.gitignore` | **RESUELTO** en commit anterior. Combinó tools/ excludes (HEAD) + temp-holding/**/transcripts y mnt (otra rama), descartó duplicado de `build/`. |
| **F-NEW-2** | `temp-holding/` contiene 5+ backups anidados | Triage al inicio del primer WP de rebuild para identificar el más curado. Backups detectados: `IACT_Backup_Completo_2026-01-11/`, `IACT_Backup_Completo_2026-01-11-old/`, `TMP_COMPLETO_2026-01-13/`, `TMP_COMPLETO_2026-01-13_OK/`, `TMP_COMPLETO_IACT_2026-01-13_2/`. |
| **F-NEW-3** | Premisa "source/ tiene 0 warnings/errores" | **VERIFICADO (2026-04-28 03:55).** Premisa correcta: `uv run sphinx-build -E -b html source/` → `build succeeded.` (0 warnings, 0 errors). Pre-condición: ejecutar `bash scripts/setup.sh` antes — instala plantuml.jar, libenchant, sincroniza venv y activa git hooks. Sin setup.sh, el build genera 183 warnings (todas plantuml-related, falsas alarmas). |
| **F-NEW-6** | `rm -rf` bloqueado por permission prompts de Claude Code | Usar `make clean` en su lugar — el Makefile ya define el target y al ser invocación indirecta no genera prompt. Patrón a aplicar consistentemente. |
| **F-NEW-7** | `setup.sh` no señalizado como pre-condición obligatoria | Cualquier `git clone` nuevo tropieza con build fallido. Acciones propuestas: (1) sección "First time setup" en `readme.rst`, (2) guard en Makefile target `html` que verifique plantuml.jar/enchant, (3) `CONTRIBUTING.md`, (4) CI job de bootstrap end-to-end. **Fuera de scope DISCOVER** — abordar en WP separado. |
| **F-NEW-4** | `pyproject.toml` con pins internamente contradictorios | **RESUELTO (2026-04-28 03:35).** `sphinx-tabs==3.5.0` + `sphinx-toolbox==4.1.2`, pero toolbox 4.1.2 requiere `sphinx-tabs<3.4.7`. Investigación: latest sphinx-toolbox en PyPI es 4.1.2 (opción B no viable). Verificado que `sphinx-toolbox` NO se usa en `source/` (0 ocurrencias) — **eliminado**. `sphinx-tabs` se mantiene (uso futuro intencional en nuevo source/). `uv sync` ahora completa sin conflictos. |
| **F-NEW-5** | Eliminación de Markdown del proyecto | El nuevo `source/` será 100% RST por decisión del ejecutor. Eliminado `myst-parser==4.0.1` y dependencias transitivas huérfanas (`markdown-it-py`, `mdit-py-plugins`, `mdurl`) de `pyproject.toml`. Eliminada extension `'myst_parser'` de `source/conf.py`. Añadida extension `'sphinx_tabs.tabs'` (será usada en el rebuild). El skill `sphinx` queda disponible como referencia para uso correcto de directivas (`.. tabs::`, `.. tab::`, etc.). |
| **F-OLD-3** | Inventariar contenido específico de `base_cognitiva/` | Diferido al primer WP de rebuild (`source-rebuild-base-cognitiva`). El inventario detallado va en su discover, no aquí. |

## 9. Estrategia de gestión de directorios temporales

**`temp-backup/` y `temp-holding/` cumplen roles complementarios:**

| Directorio | Origen | Rol | Cuándo se crea |
|-----------|--------|-----|----------------|
| `temp-backup/source-2026-04-28/` | Snapshot del `source/` actual al iniciar el rebuild | Baseline "estado actual conocido" — referencia limpia (asumiendo 0 warnings/errores; F-NEW-3) | Al inicio del primer WP de rebuild (`source-rebuild-base-cognitiva`) |
| `temp-holding/` | Material crudo histórico de FASE 01, FASE 02, GENERACION_DOCUMENTACION, etc. | Referencia de contenido extendido — versiones previas, alternativas, drafts. Probable contenedor de errores de diseño. | Ya existe (3472 archivos, 65 MB) |

**Cleanup final:** ambos directorios se eliminan cuando los 8 dominios
estén reconstruidos y validados (criterio: build con `-W` exit 0,
ningún `:doc:` o `:ref:` apunta a `temp-*`).

## 10. Resumen de decisiones consolidadas

| ID | Resolución |
|----|------------|
| **D1** | Mantener `temp-backup/` versionado en feature branch. Se crea al inicio del primer WP de rebuild. |
| **D2** | Empezar por `base_cognitiva/`. |
| **D3** | No usar `-W` durante rebuild; recuperar al final. |
| **D4** | Mantener IDs semánticos de STD_007 (no renombrar por motivo de prefijo numérico). |
| **D5** | "Backup as reference" — `temp-backup/` y `temp-holding/` son consultivos, no fuente de copia. Rebuild editorial. |
| **F-04** | `plantuml-guide/` → `arquitectura_tecnica/plantuml-guide/`. |
| **F-05** | `_static/` y `_templates/` se quedan en `source/`. |
| **F-NEW-1** | Conflicto `.gitignore` resuelto. |
| **F-NEW-2** | Triage de backups anidados de `temp-holding/` en primer WP de rebuild. |
| **F-NEW-3** | **VERIFICADO**: source/ build con 0 warnings tras ejecutar `bash scripts/setup.sh`. |
| **F-NEW-6** | `rm -rf` genera permission prompts; usar `make clean` en su lugar. |
| **F-NEW-7** | `setup.sh` debe señalizarse como pre-condición obligatoria — abordar en WP separado. |
| **F-NEW-4** | `pyproject.toml` con pins contradictorios resuelto eliminando `sphinx-toolbox` (dependencia muerta). `uv sync` funcional. |
| **F-NEW-5** | Markdown eliminado del proyecto: `myst-parser` + transitivas + extension `myst_parser` removidas. `sphinx-tabs` preservado para uso correcto en nuevo source/. Skill `sphinx` cargado como referencia. |
| **CLEANUP** | `temp-backup/` y `temp-holding/` se eliminan al final. |

## 11. Criterio editorial — quién decide

Para cada archivo de `temp-backup/` o `temp-holding/` consultado durante
el rebuild de un dominio, la clasificación inicial (incorporar / fusionar /
reescribir / descartar) la **propone Claude** y la **confirma o corrige
el ejecutor**. Esto vive en el discover de cada WP de rebuild de dominio.

## 12. Estado del WP

**Phase 1 DISCOVER: APROBADA.**

Salida atómica de este WP:

- `wp-state.md` (status: Aprobado).
- `discover/source-rebuild-strategy-analysis.md` (este documento, v2.0.0).

**Próximo paso:** abrir el primer WP de rebuild de dominio
(`source-rebuild-base-cognitiva`) — responsable de:

1. Crear `temp-backup/source-2026-04-28/` con snapshot del `source/` actual.
2. Triage de los 5 backups anidados en `temp-holding/` (F-NEW-2).
3. Inventario y clasificación editorial de `base_cognitiva/` (F-OLD-3).
4. Reconstrucción del dominio aplicando STD_007.
