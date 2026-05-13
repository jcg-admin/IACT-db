```yml
created_at: 2026-04-30 04:45:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis multi-perspectiva — Conversión de 832 referencias `.md` a Sphinx

> Análisis desde 10 perspectivas para decidir cómo convertir las 832
> referencias `.md` que actualmente viven en `source/` a un formato
> que Sphinx valide y permita navegación funcional. Considera que
> mucho del contenido referenciado vive en `temp-holding/` y que
> podemos reorganizar cualquier carpeta de `source/`.

## Línea base reconfirmada

| Métrica | Valor |
|---------|-------|
| Total ocurrencias `.md` en source/ | 832 |
| Paths únicos referenciados | 511 |
| Paths analizados (excluyendo wildcards/patterns) | 473 |
| **Existen en repo** (cualquier ubicación) | **168** (35.5%) |
| ↳ De los cuales en `temp-holding/` | **133** (79% de los que existen) |
| ↳ De los cuales en source/ u otro lugar | 35 |
| **NO existen en repo** | **305** (64.5%) |
| Tamaño total de `temp-holding/` | 65 MB |
| Archivos `.md` en `temp-holding/` | 2,347 |
| Archivos `.rst` en `temp-holding/` | 707 |

**Sphinx config actual:** NO tiene MyST habilitado (`myst_parser`
NO está en `extensions`). Solo procesa `.rst`. Cualquier `.md` en
source es inerte (no se construye ni se valida).

**Carpetas existentes en source/:**

```
_static, _templates, arquitectura-tecnica, backend, base-cognitiva,
databases, devops, frontend, gestion, normativa, onboarding,
plantuml-guide, quality, requisitos, risks-technical-debt
```

## Top 25 archivos `.md` más referenciados

| # refs | Archivo |
|--------|---------|
| 17 | `CHANGELOG.md` |
| 12 | `README.md` |
| 10 | `verificar_servicios.md` |
| 10 | `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` |
| 9 | `readme.md` |
| 9 | `procedimiento_qa.md` |
| 9 | `plantilla_django_app.md` |
| 8 | `procedimiento_release.md` |
| 8 | `UC-BACK-001-iniciar-sesion.md` (en docs/gobernanza/...) |
| 8 | `checklist_desarrollo.md` |
| 8 | `INDICE.md` |
| 7 | `plantilla_tdd.md` |
| 7 | `GUIA-BACK-003-authentication-guide.md` |
| 7 | `checklist_trazabilidad_requisitos.md` |
| 6 | `procedimiento_instalacion_entorno.md` |
| 6 | `procedimiento_gestion_cambios.md` |
| 6 | `procedimiento_desarrollo_local.md` |
| 6 | `checklist_testing.md` |
| 6 | `lineamientos_codigo.md` |
| 5 | `reprocesar_etl_fallido.md` |
| 5 | `procedimiento_diseno_tecnico.md` |
| 5 | `UC-BACK-003-cambiar-contrasena.md` |

## Patrón observado

El 80% de los referenced docs caen en estas familias:

- `RN_*.md` (Reglas de Negocio): 32 únicos
- `ADR_*.md`: 27 únicos
- `UC-*.md`: 23 únicos
- `RF_*.md` (Requisitos Funcionales): 12 únicos
- `CATALOGO_*.md`: 10 únicos
- `PROCEDimiento_*.md` y `PROC_*.md`: 17 únicos
- `RNF_*.md` (Requisitos No Funcionales): 8 únicos
- `PARTE_*.md` (capítulos pedagógicos): 8 únicos
- `MATRIZ_*.md`: 6 únicos
- `plantilla_*.md`: 4 únicos
- `TASK-*.md`: 6 únicos

---

# 10 Perspectivas de análisis

## 1. Perspectiva técnica — Mecanismos de conversión

### Opción 1A: Habilitar MyST Parser

```python
# source/conf.py
extensions = [
    ...
    'myst_parser',
]
source_suffix = ['.rst', '.md']
```

**Pros:**
- Sphinx procesa `.md` directamente.
- Cero conversión necesaria — solo importar archivos.
- Sintaxis Markdown tradicional + extensiones MyST para directivas.
- Permite mezclar `.md` y `.rst` en mismo proyecto.

**Contras:**
- 832 references siguen sin validación si los archivos no existen
  todavía en source/.
- El proyecto ya está estandarizado en RST — introduce
  heterogeneidad.
- MyST tiene limitaciones con algunos directives RST avanzados
  (cross-references complejos, sphinx-design tabs).

**Veredicto:** Útil como puente, NO como solución completa.

### Opción 1B: Conversión automatizada `.md` → `.rst`

Herramientas:

- `pandoc` (más robusto): `pandoc -f markdown -t rst archivo.md > archivo.rst`
- `m2r2` / `rst-tools`: específicos para Sphinx.
- Scripts custom para preservar metadata, frontmatter, links.

**Pros:**
- Mantiene estandar RST único.
- Valida links después de conversión vía Sphinx.

**Contras:**
- 2,347 archivos `.md` en temp-holding — conversión masiva
  manual o con script.
- Pandoc no preserva semántica de cross-references RST.
- Frontmatter YAML de los `.md` debe convertirse a `.. meta::` RST.
- Tablas markdown se mapean a list-tables RST con riesgo de
  formato incorrecto.

**Veredicto:** Necesario para los `.md` que vamos a importar
permanentemente al sitio.

### Opción 1C: Híbrido (recomendado)

- MyST habilitado para soportar `.md` que vienen de fuentes
  externas (e.g. README.md, CHANGELOG.md raíz).
- Conversión `.md` → `.rst` para los docs que se incorporan al
  sitio publicado bajo la convención del proyecto.
- Decisión por archivo: ¿es contenido publicable o referencia
  histórica?

---

## 2. Perspectiva de contenido — ¿Qué hay realmente en `temp-holding/`?

`temp-holding/` contiene **2,347 archivos `.md`** + 707 `.rst`,
65 MB. Es el repositorio histórico del proyecto IACT desde antes
de la consolidación a `source/`.

Estructura observada:

- `FASE 01/`: documentos pedagógicos, ingeniería de requerimientos,
  análisis consolidado v0.x, casos de uso, BR.
- `FASE 02/`: base cognitiva, fundamentos conceptuales, normativa,
  templates.
- `GENERACION_DOCUMENTACION/`: backups iterativos del sitio
  (4+ copias del mismo contenido en distintas etapas).
- `Modules/`: módulos arquitectónicos.
- `RBAC/`: modelos RBAC v4.0 / v5.0 / v5.1.x / v5.2.x.
- `project/`: documentación general del proyecto.

**Hallazgo clave:** muchos archivos están **duplicados** en
múltiples backups (e.g. `PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md`
aparece 6 veces en distintos paths con el mismo contenido). El
volumen real de contenido único es menor a los 2,347.

**Implicación para conversión:** primero deduplicar, luego
convertir. Si convertimos 2,347 archivos directos, importamos
contenido obsoleto/redundante a source/.

---

## 3. Perspectiva arquitectural — ¿Dónde colocar el contenido en source/?

Mapeo propuesto de familias `.md` → carpetas `source/`:

| Familia `.md` | Carpeta destino en `source/` |
|---------------|------------------------------|
| `UC-*.md` (casos de uso) | `requisitos/casos-uso/{módulo}/` |
| `RF_*.md` (req funcionales) | `requisitos/requisitos-funcionales/` |
| `RNF_*.md` (req no funcionales) | `requisitos/requisitos-no-funcionales/` |
| `RN_*.md` (reglas de negocio) | `requisitos/reglas-negocio/` |
| `ADR_*.md` (arquitectura) | `backend/`, `frontend/`, `devops/`, `databases/` o `normativa/gobernanza/` según scope |
| `CATALOGO_*.md` | `arquitectura-tecnica/catalogos/` (carpeta nueva) |
| `procedimiento_*.md` | `normativa/procedimientos/` |
| `checklist_*.md` | `quality/checklists/` (carpeta nueva o existente) |
| `plantilla_*.md` (templates) | `normativa/templates/` (carpeta nueva) |
| `MATRIZ_*.md` | `quality/matrices/` o `arquitectura-tecnica/` |
| `PARTE_*.md` (pedagógicos) | `base-cognitiva/_fundamentos-conceptuales/` (ya existe) |
| `TASK-*.md` (tasks históricas) | NO importar a source — son artefactos de WP, viven en `.thyrox/context/` o se descartan |
| `README.md`, `CHANGELOG.md` | NO mover — viven en raíz del repo y son externos al sitio |

**Regla de oro:** ¿este documento debe ser parte del **sitio
publicado** (consultable por usuarios)? Sí → convertir a `.rst`
y ubicar en source/. No → permanecer en raíz / temp-holding.

---

## 4. Perspectiva de proceso — Workflow de migración

Proceso propuesto en 4 etapas:

### Etapa 1: Triaje (1 sesión, automatizable)

Para cada uno de los 511 paths únicos referenciados, decidir:

- **A) Importar a source/** — el contenido es publicable, debe
  vivir en el sitio.
- **B) Mantener en raíz repo** — externo al sitio (README,
  CHANGELOG, scripts).
- **C) Eliminar referencia** — el archivo no aporta valor; el
  link debe convertirse a texto plano o eliminarse.
- **D) Quedar en temp-holding como histórico** — mencionado
  por trazabilidad, no como link clickeable.

### Etapa 2: Conversión por lotes (scripts + revisión)

Para los marcados (A):

1. Localizar archivo fuente en `temp-holding/` o el repo.
2. Si hay duplicados, escoger la versión más reciente/correcta.
3. Convertir con `pandoc -f markdown -t rst`.
4. Aplicar metadata canónica (`.. meta::` block).
5. Aplicar convenciones de nombres del proyecto (kebab-case,
   prefijos `uc-*`, `adr-*`, etc.).
6. Crear/actualizar `index.rst` del directorio destino.

### Etapa 3: Update de referencias

Para cada referencia `.md` en source:

- Si destino convertido (A): cambiar a `:doc:` cross-reference.
- Si externo (B): cambiar a hyperlink HTTP (cuando exista) o
  texto plano.
- Si eliminado (C): eliminar link, dejar texto descriptivo.
- Si histórico (D): convertir a texto plano con nota "(histórico,
  preservado en temp-holding)".

### Etapa 4: Validación

- Habilitar `nitpicky = True` en conf.py.
- Custom checker en CI: scan de hyperlinks RST a archivos `.md`.
- Política STD-007 actualizada.

---

## 5. Perspectiva de riesgo — ¿Qué puede romperse?

| Riesgo | Severidad | Mitigación |
|--------|-----------|------------|
| Convertir docs obsoletos al sitio (ruido) | Alta | Triaje estricto antes de convertir |
| Duplicación al importar de múltiples backups | Alta | Deduplicación previa de temp-holding |
| Perder formato en conversión pandoc | Media | Revisión manual post-conversión |
| Romper `:doc:` references de docs ya en source al renombrar | Alta | Mantener path del archivo igual o usar redirecciones |
| Sphinx falla por cross-references rotas tras importar | Media | Build incremental, fix iterativo |
| Tiempo de conversión 2,347 archivos | Alta | Scripts batch + priorización por # refs |
| Inconsistencia de metadata frontmatter | Media | Template estricto + validador |
| `temp-holding/` mismo contiene contradicciones internas | Alta | Adoptar versión más reciente cuando hay conflicto |

---

## 6. Perspectiva costo-beneficio — ¿Vale la pena convertir todo?

### Costo estimado de migración total

- **Triaje 511 paths**: ~6-8 horas (1 humano).
- **Localización + dedup + conversión 168 archivos existentes**:
  ~16-24 horas (con scripts + revisión).
- **Decisión sobre 305 paths sin archivo fuente**: ~4-6 horas.
- **Update de 832 referencias en 107 archivos source**: ~12-16
  horas (con scripts grep+sed para casos simples).
- **Setup de validación CI**: ~4 horas.

**Total estimado:** 42-58 horas para conversión total.

### Beneficio

- Sitio publicado sin links rotos silenciosos.
- Cumplimiento del principio "single source of truth": todo
  contenido publicable está en source/, no disperso.
- CI valida automáticamente referencias.
- Eliminación de deuda técnica documental.

### ¿Vale?

| Estrategia | Costo (h) | Beneficio | Recomendación |
|------------|-----------|-----------|---------------|
| Hacer nada | 0 | Sitio sigue con links rotos silenciosos | NO — deuda crece |
| Solo TIPO A (150 hyperlinks) | 8-12 | Resuelve riesgo más alto | **Sí — Priorizar** |
| TIPO A + TIPO B literales | 14-20 | Resuelve riesgo + claridad | Recomendado |
| Conversión total (todos los tipos + 305 inexistentes) | 42-58 | Sitio impecable | Solo si hay capacidad |

---

## 7. Perspectiva de categorización — Estrategia diferencial por tipo

### TIPO A: Hyperlinks RST (150 ocurrencias) — PRIORIDAD ALTA

Acción por subcategoría:

- **A.1 Archivo existe en source/** (raros): cambiar a `:doc:`.
- **A.2 Archivo existe en temp-holding/**: convertir + importar
  + cambiar a `:doc:`.
- **A.3 Archivo NO existe**: convertir hyperlink a texto plano
  ("ver documento histórico {nombre}") o eliminar.
- **A.4 Archivo externo al repo** (URL absoluta de README, etc.):
  reemplazar por URL absoluta o nota descriptiva.

### TIPO B: Literales en backticks (177 ocurrencias) — PRIORIDAD MEDIA

Estos son menciones descriptivas. Acción:

- **B.1 Path obsoleto** (ej. `INDICE_MAESTRO_PERMISOS_GRANULAR.md`
  refers to old structure): actualizar a path nuevo en source/
  o eliminar mención.
- **B.2 Path correcto** (referencia válida a un script externo):
  preservar.
- **B.3 Path inventado** (typo, archivo nunca existió): eliminar
  o reescribir.

### TIPO C: Texto plano (~505 ocurrencias) — PRIORIDAD BAJA

Auditar solo los que prometan navegación al lector. Mayoría son
narrativos y aceptables tal cual.

---

## 8. Perspectiva Sphinx-capabilities — ¿Qué nos da el ecosistema?

### Extensiones útiles

- **`myst_parser`**: parsear `.md` como fuente Sphinx.
- **`sphinxext-rediraffe`**: redirecciones cuando renombramos
  archivos (preserva URLs antiguas).
- **`sphinx_external_toc`**: gestiona TOC desde YAML, útil cuando
  hay muchos archivos nuevos.
- **`sphinx-needs`**: gestión de requirements como objetos
  estructurados (UC, RF, RN cross-referenciables).
- **`linkchecker` (builder de Sphinx)**: `make linkcheck` valida
  hyperlinks externos. NO valida links a archivos `.md` locales,
  pero ayuda con HTTP.
- **`sphinxcontrib-bibtex`**: bibliografía si hay muchas referencias.

### Configuración recomendada para validación

```python
# conf.py — añadir
nitpicky = True  # falla en referencias rotas
nitpick_ignore = []  # whitelist explícita

# Custom checker (post-build)
def check_md_hyperlinks(app, exception):
    """Detecta hyperlinks RST a .md en HTML output."""
    ...
app.connect('build-finished', check_md_hyperlinks)
```

---

## 9. Perspectiva de triaje — Priorización por valor/esfuerzo

Matriz Eisenhower aplicada:

| Cuadrante | Característica | Acción |
|-----------|----------------|--------|
| **Importante + Urgente** | TIPO A con destino existe en repo (133 paths) | Convertir + importar primero |
| **Importante + No urgente** | TIPO A sin destino + TIPO B obsoleto | Decidir crear vs eliminar |
| **No importante + Urgente** | Errores de typo en TIPO B | Fix masivo con sed |
| **No importante + No urgente** | TIPO C narrativo | Dejar tal cual o limpiar en futuro |

### Top 10 archivos por **frecuencia × riesgo**

Estos archivos son los que más impactarían si se convierten:

1. `CHANGELOG.md` (17 refs) — externo al repo. **Acción:** mantener referencia textual + URL HTTP cuando se publique.
2. `README.md` (12 refs) — externo. **Acción:** idem.
3. `verificar_servicios.md` (10 refs) — interno (devops), parece runbook. **Acción:** importar a `source/devops/runbooks/`.
4. `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` (10 refs) — fuente de muchas CNST. **Acción:** ya migrado a `source/normativa/restricciones/cnst-*.rst`. Cambiar referencias a docs específicos.
5. `procedimiento_qa.md` (9 refs) — proceso documentado. **Acción:** crear `source/normativa/procedimientos/proc-qa-*.rst`.
6. `plantilla_django_app.md` (9 refs) — template. **Acción:** mover a `source/normativa/templates/` o eliminar referencia.
7. `procedimiento_release.md` (8 refs). **Acción:** crear `source/normativa/procedimientos/proc-release.rst`.
8. `INDICE.md` (8 refs) — meta-doc. **Acción:** mapear a `source/index.rst` o eliminar referencia.
9. `UC-BACK-001-iniciar-sesion.md` (8 refs) — caso de uso. **Acción:** ya existe `source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst`. Cambiar referencia a `:doc:`.
10. `checklist_desarrollo.md` (8 refs). **Acción:** crear `source/quality/checklists/checklist-desarrollo.rst`.

**Insight:** muchos refs apuntan a docs que **ya existen en source/
con nombre canónico kebab-case**. La mayor parte del trabajo es
convertir hyperlinks `<file.md>` a `:doc:`/path/file``.

---

## 10. Perspectiva de tooling — Automatización viable

### Script 1: Validador de existencia (Phase 2 MEASURE)

```python
# .thyrox/context/work/.../scripts/validate_md_refs.py
#
# Para cada path único, busca el archivo en:
# 1. source/ (existencia → cambiar a :doc:)
# 2. temp-holding/ (candidato a importar)
# 3. Raíz repo (externo, mantener)
# 4. No existe → triaje manual

import subprocess, json
from pathlib import Path

def find_file(name):
    result = subprocess.run(
        ['find', '/home/user/IACT-docs', '-name', name,
         '-not', '-path', '*/build/*'],
        capture_output=True, text=True
    )
    return result.stdout.strip().split('\n')

paths = Path('/tmp/md-paths-unique.txt').read_text().splitlines()
report = []
for p in paths:
    fname = Path(p).name
    matches = find_file(fname)
    report.append({
        'path': p,
        'matches': [m for m in matches if m],
        'in_source': any('/source/' in m for m in matches),
        'in_temp': any('/temp-holding/' in m for m in matches),
    })

Path('md-refs-existence-report.json').write_text(json.dumps(report, indent=2))
```

### Script 2: Conversor masivo `.md` → `.rst`

```bash
#!/usr/bin/env bash
# Para cada archivo .md a importar:
# 1. Convierte con pandoc
# 2. Aplica frontmatter canónico
# 3. Renombra al esquema kebab-case del proyecto

for md in $(cat list-of-mds-to-convert.txt); do
    rst="${md%.md}.rst"
    pandoc -f markdown -t rst "$md" -o "$rst"
    # Post-process: añadir .. meta:: header, normalizar refs
    python3 normalize_rst.py "$rst"
done
```

### Script 3: Updater de referencias

```python
# Para cada hyperlink RST tipo `Texto <file.md>`__:
# - Si file existe en source/: cambiar a :doc:
# - Si external: dejar como hyperlink HTTP
# - Si broken: convertir a texto plano

import re
from pathlib import Path

PATTERN = re.compile(r'`([^`]+) <([^>]+\.md)>`__')

for rst_file in Path('source').rglob('*.rst'):
    text = rst_file.read_text()
    def replacer(m):
        text_label, md_path = m.group(1), m.group(2)
        # ... lógica de mapeo
        return new_form
    new = PATTERN.sub(replacer, text)
    if new != text:
        rst_file.write_text(new)
```

### Script 4: CI checker

```python
# .github/workflows/check-md-refs.py
# Falla el CI si encuentra hyperlinks a archivos .md
# que no existen en source/ ni en docs externos válidos.

import re, sys
from pathlib import Path

PATTERN = re.compile(r'`[^`]+ <([^>]+\.md)>`__')

errors = []
for rst in Path('source').rglob('*.rst'):
    for m in PATTERN.finditer(rst.read_text()):
        md_path = m.group(1)
        if md_path.startswith('http'):
            continue  # external
        target = (rst.parent / md_path).resolve()
        if not target.exists():
            errors.append(f"{rst}: broken .md hyperlink → {md_path}")

if errors:
    print("\n".join(errors))
    sys.exit(1)
```

---

# Estrategia recomendada (síntesis multi-perspectiva)

## Fase 1 — Triaje + decisión global (alto valor, bajo costo)

**Esfuerzo:** ~6 horas. **Valor:** decisivo.

1. Ejecutar Script 1 — generar reporte automatizado de
   existencia (cuántos archivos están en source/, temp-holding/,
   externos, inexistentes).
2. Decidir política STD: ¿qué `.md` PUEDEN existir en source/
   (Larman: solo si el sitio los publica)?
3. Categorizar los 511 paths en A/B/C/D (importar / externo /
   eliminar / histórico).

## Fase 2 — Quick wins (alto ROI)

**Esfuerzo:** ~10-12 horas. **Valor:** elimina 50-60% del riesgo.

1. Para los **35 paths que existen en source/ con nombre
   canónico**: convertir hyperlinks `<file.md>` → `:doc:`. Fix
   masivo automatizado.
2. Para los **17 refs a CHANGELOG/README**: reemplazar por URLs
   absolutas a GitHub o texto descriptivo "ver README del repo".
3. Para los **133 paths que existen en temp-holding**: triaje
   ¿son contenido vivo del sitio o histórico? Si vivo → convertir
   con pandoc; si histórico → texto plano con nota.

## Fase 3 — Conversión por lotes (medio ROI)

**Esfuerzo:** ~16-20 horas. **Valor:** completa el cleanup.

1. Habilitar MyST como puente para `.md` que vienen de fuera.
2. Convertir lotes priorizados por # refs descendente.
3. Crear archivos `index.rst` para nuevas carpetas.
4. Actualizar referencias.

## Fase 4 — Prevención (bajo costo, alto valor)

**Esfuerzo:** ~4 horas. **Valor:** evita regresión.

1. `nitpicky = True` en conf.py.
2. Script 4 (CI checker) en pre-commit y CI pipeline.
3. Política documentada en STD-007 v3.0.0.
4. Decisión: ¿MyST se queda como puente o se prohíbe?

## Estrategia "minimal viable"

Si solo hay capacidad para 12-15 horas:

- **Hacer:** Fases 1 + 2 + 4.
- **Saltar:** Fase 3 (conversión masiva).
- **Resultado:** TIPO A queda limpio (150 → 0); TIPO B/C
  tolerados como deuda controlada.

## Estrategia "completa"

Para corpus impecable y profesional:

- Fases 1 + 2 + 3 + 4.
- 42-58 horas total.
- Refleja madurez documental.

---

## Anexo: matriz de decisión por tipo de archivo

| Tipo `.md` | Existe en source ya? | Existe en temp-holding? | Acción |
|------------|----------------------|--------------------------|--------|
| `UC-*` | A veces (con prefijo `uc-*`) | Sí (con nombre histórico) | Mapear a doc existente; fix referencias |
| `ADR_*` | A veces (con prefijo `adr-*`) | Sí | Mapear o crear faltantes |
| `RN_*` | A veces (`br-*`) | Sí | Mapear |
| `RF_*` / `RNF_*` | Pocas | Sí | Crear faltantes en `requisitos/requisitos-funcionales/` |
| `procedimiento_*` | Algunas (`proc-*`) | Sí | Crear faltantes |
| `checklist_*` | NO | Sí | Crear carpeta `quality/checklists/` |
| `plantilla_*` | NO | Sí | Crear `normativa/templates/` o NO importar |
| `MATRIZ_*` | NO | Sí | Crear o NO importar (templates) |
| `CATALOGO_*` | NO | Sí | Crear `arquitectura-tecnica/catalogos/` |
| `TASK-*` | NO | Sí | NO importar (artefactos efímeros de WP) |
| `PARTE_*` | NO | Sí (duplicados) | Importar a `base-cognitiva/` o NO importar |
| `README` / `CHANGELOG` | NO (externos) | A veces | Externos al sitio, referencias HTTP |

## Decisión recomendada

**Estrategia "minimal viable" + selectiva en Fase 3.**

- Ejecutar Fases 1, 2, 4 completas.
- En Fase 3, priorizar conversión solo de los archivos del top
  25 (los más referenciados).
- Esto resuelve ~70% del riesgo en ~25 horas.
- Documentar el resto como deuda con razón explícita y fecha
  de revisión.

## Preguntas para el ejecutor

1. ¿Aprobamos estrategia **minimal viable + top 25** o **completa**?
2. ¿Habilitamos MyST como puente para `.md` externos (e.g. README)?
3. ¿Crear las 4 nuevas carpetas (`source/quality/checklists/`,
   `source/normativa/templates/`, `source/arquitectura-tecnica/catalogos/`,
   `source/devops/runbooks/`)?
4. ¿La conversión `temp-holding` → `source` también debe
   actualizar la metadata histórica (preservar autor original,
   fecha de creación)?
5. ¿Pre-commit hook o CI-only para el validador anti-`.md`?
