```yml
created_at: 2026-04-30 05:30:00
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Recategorización de residuales — refs `.md` sin categoría obvia

> Análisis adicional sobre los ~76 archivos `.md` que en el plan
> previo (`missing-files-creation-plan.md`) quedaron como
> "Misceláneos / Otros". Investigación caso por caso del documento
> source que los referencia y POR QUÉ se hace la referencia.

## Hallazgo central

**La GRAN MAYORÍA de los residuales son ejemplos pedagógicos
dentro de docs de proceso.** No son archivos que falten — son
**referencias tutoriales** mostrando cómo se aplicarían los
templates en escenarios hipotéticos.

Esto cambia drásticamente la estimación del WP:

- **Plan original:** ~76 misceláneos a triaje individual (~10-15h).
- **Plan revisado:** ~50-60 son ejemplos pedagógicos (acción:
  convertir a texto/literal, NO crear archivos), ~15-20 requieren
  triaje real.

## Patrón A — Ejemplos pedagógicos en `proc-gob-001`

El documento
`source/normativa/procedimientos/proc-gob-001-mapeo-procesos-templates.rst`
es un **mapeo del proceso documental SDLC**. Concentra **179 refs
`.md` (36% del total)**. La mayoría siguen este patrón:

```rst
2. Cuando aparece "necesidad: dark mode":
    └─> Crear: BN-001-dark-mode.md (template_necesidad.md)
3. Cuando se transforma a regla de negocio:
    └─> Crear: RN-001-dark-mode.md (template_requisito_negocio.md)
4. Cuando se especifica como UC:
    └─> Crear: UC-001-activar-dark-mode.md (plantilla_caso_de_uso.md)
5. Cuando se diseña arquitectura:
    └─> Crear: HLD-dark-mode.md (plantilla_sad.md)
    └─> Crear: LLD-dark-mode.md (plantilla_srs.md)
    └─> Crear: DB-user-preferences.md (plantilla_database_design.md)
```

Esto es **contenido tutorial** mostrando el workflow del proceso
SDLC con un ejemplo concreto (la feature "dark mode"). Los
archivos referenciados NO existen porque NUNCA se crearon —
son hipotéticos.

### Inventario detectado (subcategoría A.1 — feature "dark-mode")

```
BN-001-dark-mode.md
RN-001-dark-mode.md
RF-001-dark-mode-toggle.md
RF-002-dark-mode-persistence.md
UC-001-activar-dark-mode.md
HLD-dark-mode.md
LLD-dark-mode.md
DB-user-preferences.md
test_plan_dark_mode.md
TC-001-toggle-dark-mode.md
release_plan_v1.5.0.md
deployment_guide_staging.md
api_reference_preferences.md
troubleshooting_mysql_crash.md
RNF-005-disk-monitoring.md
```

### Subcategoría A.2 — feature "stock"

`DISENO_TECNICO_STOCK.md` aparece en docs como ejemplo de nombre
de archivo del template `DISENO_TECNICO_{COMPONENTE}.md`. Mismo
patrón.

### Subcategoría A.3 — feature "autenticación"

`DISENO_TECNICO_AUTENTICACION.md` aparece en `proc-dev-004` línea
con texto:

```rst
- Nomenclatura: ``DISENO_TECNICO_{COMPONENTE}.md``
- Ejemplo: ``DISENO_TECNICO_AUTENTICACION.md``
```

Es claro: es **EJEMPLO** del template, NO un archivo a crear.

### Acción recomendada para Patrón A

1. **NO crear archivos.**
2. Convertir hyperlinks RST `` `Texto <archivo.md>`__ `` a
   literales backticks `` ``archivo.md`` `` cuando el contexto
   sea pedagógico.
3. Idealmente: agregar una nota `:caption: Ejemplo pedagógico`
   o similar al inicio del bloque tutorial para que el lector
   entienda el contexto.

**Esfuerzo:** 2-3h con script automatizado para
`proc-gob-001-mapeo-procesos-templates.rst` específicamente.

## Patrón B — Hyperlinks a docs externos del sitio

Algunos paths apuntan a documentación que vive **fuera del sitio
Sphinx publicado**, herencia de la estructura previa del repo:

| Archivo `.md` | Doc source que lo referencia | Naturaleza |
|---------------|-------------------------------|------------|
| `PLAN_MAESTRO_PRIORIDAD_02.md` | `backend/adr-back-002-configuracion-dinamica-sistema.rst` | Plan de implementación legacy del backend |
| `AGENTES_SDLC.md` | `proc-gob-001-mapeo-procesos-templates.rst` | Doc histórico no migrado |
| `INDICE.md` (raíz) | varios docs | Índice histórico no Sphinx |
| `../../.github/claude-code-conventions.md` | normativa | Convenciones del repo, externas al sitio |

### Acción recomendada para Patrón B

1. **NO crear en source/.**
2. Reemplazar por:
   - URL absoluta a GitHub si el archivo existe en la rama main.
   - Texto plano descriptivo si es histórico ("ver AGENTES_SDLC
     histórico en repo legacy").
   - Eliminar la referencia si no aporta valor.

**Esfuerzo:** ~30 min.

## Patrón C — Strings literales en bloques de código

Algunos paths aparecen dentro de **código mostrado como ejemplo**
del comportamiento del sistema, no como hyperlinks navegables:

```rst
Ejemplo:
    /tmp/MODELO_DOCUMENTAL_IACT_v2_1_2.md
```

```rst
Estructura del package:
    artifacts/
    ├── ARTIFACTS.md
    └── .gitkeep
```

Estos NO son links. Son **strings literales** dentro de bloques
de código. Sphinx ya los renderiza correctamente (sin link). El
grep `\.md\b` los detectó pero NO son referencias problemáticas.

### Inventario detectado

```
/tmp/MODELO_DOCUMENTAL_IACT_v2_1_2.md
/tmp/PLAN_FR_GENERACION_v1_0_0.md
ARTIFACTS.md (en bloque code-block: tree)
.md (genérico, en plantillas)
README.md (cuando aparece en árbol de directorios)
```

### Acción recomendada para Patrón C

**Ninguna.** Son falsos positivos del grep. Excluir de la cuenta
de "referencias rotas".

**Esfuerzo:** 0h (solo agregar a whitelist del CI checker).

## Patrón D — Notas de entrevista / artefactos efímeros

Templates como `tpl-uc-stakeholder-driven.rst` referencian
archivos que serían artefactos efímeros del proceso de
elicitación:

```rst
Inputs del UC stakeholder-driven:
- Notas: Notas_Entrevista_Maria_RPT.md
- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md
```

`Notas_Entrevista_Maria_RPT.md` es claramente **artefacto privado
de proceso** (notas de entrevista a un stakeholder), no documento
del sitio.

### Acción recomendada para Patrón D

1. **NO crear archivos** (son privados/efímeros).
2. Convertir a texto plano: "(notas de entrevista, archivo privado del proceso)".
3. SKILL guía aplicable: **`ba-elicitation`** documenta cómo
   gestionar artefactos de elicitación SIN publicarlos en el sitio.

**Esfuerzo:** ~1h.

## Patrón E — `PARTE_*.md` (capítulos pedagógicos)

```
PARTE_0_Elicitacion_Requisitos_1_0_0.md
PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md
PARTE_3A_CRUD_Patterns_IACT_1_0_0.md
PARTE_4_Functional_Requirements_IACT_1_0_0.md
PARTE_5_Trazabilidad_IACT_1_0_0.md
```

Estos SÍ son documentos pedagógicos reales que viven en
`temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/`
con CONTENIDO sustancial (4000-6000 líneas cada uno).

**Equivalentes ya migrados a source/:**

```
source/base-cognitiva/_fundamentos-conceptuales/fnd-00-contexto-y-jerarquia.rst
source/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles.rst
... (otros fnd-*.rst ya migrados)
```

### Acción recomendada para Patrón E

1. Verificar mapeo `PARTE_X` → `fnd-X` ya migrado.
2. Si existe equivalente: cambiar referencia a `:doc:`.
3. Si no existe: importar desde temp-holding con conversión
   pandoc + metadata canónica.

**SKILL guía:** dependiente de la PARTE:
- PARTE_0 Elicitación → `ba-elicitation`
- PARTE_2 UCs → `rm-specification`
- PARTE_3A CRUD → `bpa-design`
- PARTE_4 Func Req → `rm-specification`
- PARTE_5 Trazabilidad → `rm-validation`

**Esfuerzo:** 2-3h por PARTE faltante (~10-15h total).

## Patrón F — TASKs históricas

```
TASK-022-...
ANALISIS_CORREGIDO_PARTE2_CON_UC_REALES.md
REPORTE_EJECUCION_TASK_001_004.md
```

Son artefactos de WP históricos (resultados de tareas pasadas).

### Acción recomendada para Patrón F

**NO importar a source/.** Son artefactos efímeros que viven en
`.thyrox/context/work/<wp>/` o en `temp-holding/`.

**Acción:** convertir referencia a texto plano.

**Esfuerzo:** ~30 min.

## Resumen recategorizado de los ~76 misceláneos

| Patrón | Cantidad estimada | Acción | Esfuerzo (h) |
|--------|-------------------|--------|--------------|
| A — Ejemplos pedagógicos (proc-gob-001) | ~40 | Convertir a literales | 2-3 |
| B — Hyperlinks a docs externos | ~10 | Reemplazar por URL/texto | 0.5 |
| C — Strings literales en code-blocks | ~5 | Whitelist (ninguna acción) | 0 |
| D — Notas/artefactos efímeros | ~5 | Texto plano | 1 |
| E — `PARTE_*` pedagógicos | ~8 | Mapear o importar de temp-holding | 10-15 |
| F — TASKs históricas | ~5 | Texto plano | 0.5 |
| Triaje real (genuinos a crear) | ~3-5 | Crear con SKILL aplicable | 5-8 |
| **TOTAL** | **~76** | | **19-28** |

## Plan revisado neto del WP md-references-audit

Recalculando con la recategorización correcta del residual:

| Categoría | Crear nuevo | Mapear existente | Descartar | Esfuerzo |
|-----------|-------------|-------------------|-----------|----------|
| Placeholders/patterns | 0 | 0 | 75 | 1 |
| ADRs | 20-25 | 15-20 | 5 | 25-35 |
| Casos de Uso | 0-3 | 23-25 | 0-2 | 3-5 |
| Procedimientos | 12-15 | 12-15 | 3 | 20-30 |
| Templates plantillas | 0 | 0 (importar 10-15) | 17 | 4-6 |
| Catálogos | 6 | 0 | 0 | 12 |
| Guías técnicas | 4 | 0 | 0 | 8-12 |
| Runbooks | 4 | 0 | 0 | 8 |
| Requisitos Funcionales | 2-3 | 1-2 | 0 | 3-6 |
| Checklists | 3 | 0 | 0 | 5 |
| Matrices | 3 | 0 | 0 | 6-9 |
| Reglas de Negocio | 1-2 | 1-2 | 0 | 3-6 |
| README/INDICE/CHANGELOG | 0 | 0 | 7 | 1 |
| **Misceláneos recategorizados** | **3-5** | **~8 PARTE + 25 ejemplos** | **~40** | **19-28** |
| **TOTAL** | **58-83** | **~85-110** | **150-160** | **115-160** |

Cambio significativo respecto al plan original:

- **Crear:** ~58-83 (antes ~75-100). **Reducción ~17.**
- **Descartar:** ~150-160 (antes ~125). **Aumento ~25.**

**Razón del cambio:** los misceláneos pedagógicos no requieren
crear archivos — solo cambiar formato de hyperlink a literal.

## Atención especial: `proc-gob-001-mapeo-procesos-templates.rst`

Este archivo concentra **179 referencias `.md` (36% del total)**.

Solución dirigida:

1. **Auditar el documento completo.**
2. Identificar todos los bloques tutoriales (patrón "Cuando ...
   └─> Crear: ...").
3. Aplicar transformación masiva: hyperlinks → literales.
4. Posiblemente reformatear tutoriales como bloques `code-block`
   o `note::` para clarificar el contexto pedagógico.

Esta sola acción resuelve **~30% del problema total** del WP en
~3-4 horas.

**Recomendación:** PRIORIDAD MÁXIMA. Hacer este fix antes de
cualquier otro sprint.

## SKILL guía aplicable a la recategorización

Para cada patrón identificado, SKILL aplicable:

| Patrón | SKILL primario | Justificación |
|--------|----------------|---------------|
| A — Ejemplos pedagógicos | `bpa-design` | Templates son artefactos de diseño de proceso |
| B — Externos | N/A | No aplican procesos del proyecto |
| C — Code literals | N/A | Son ejemplos sintácticos |
| D — Notas elicitación | `ba-elicitation` | Gestión de artefactos de elicitación |
| E — PARTE_*  | varía según contenido | (sección 3 plan original) |
| F — TASKs históricas | `pm-closing` | Cierre de WP, artefactos de proyecto |

## Decisiones para el ejecutor

1. ¿Aprueba la recategorización? (Plan revisado: 58-83 crear,
   85-110 mapear, 150-160 descartar.)
2. ¿Hacer **prioritario** el fix de `proc-gob-001` (179 refs,
   3-4h, resuelve 30%)?
3. ¿Mantener carpeta nueva `source/gestion/runbooks/`
   (consolidar en gestion) vs `source/devops/runbooks/`?
4. ¿Convertir ejemplos pedagógicos del Patrón A a `code-block::`
   directives o solo a literales backticks?
5. ¿Importar `PARTE_*.md` de temp-holding a
   `source/base-cognitiva/` con qué SKILL guía o esperar otro WP?
