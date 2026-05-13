```yml
created_at: 2026-04-30 04:11:28
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# WP — Auditoría de referencias `.md` en source/

## Objetivo

Inventariar y clasificar todas las referencias a archivos `.md` que
existen en `source/` (corpus Sphinx que se publica como sitio
documental). Identificar cuáles apuntan a archivos inexistentes,
cuáles son hyperlinks rotos (silenciosos para Sphinx), cuáles son
texto histórico aceptable y proponer remediación.

## Por qué este WP existe

Durante la implementación v5.4.0 (WP rbac-modelo-conceptual-cleanup)
se detectó que Sphinx **NO valida** referencias a archivos `.md`:

- `:doc:` cross-references **SÍ** son validados (warnings/errores).
- Hyperlinks RST tipo `` `Texto <path/file.md>`__ `` **NO** son
  validados — Sphinx los renderiza como `<a href>` externos sin
  comprobar existencia.
- Strings de texto plano (`"mencionado en archivo.md"`) son
  ignorados por completo.

**Riesgo:** los lectores del sitio publicado encuentran links rotos
silenciosos al hacer clic. La calidad documental se degrada sin
señal de error en CI/build.

## Métricas iniciales (línea base)

Comando: `grep -rEn "\.md\b" /home/user/IACT-docs/source/`

| Métrica | Valor |
|---------|-------|
| Total ocurrencias | 832 |
| Archivos `.rst` con referencias `.md` | 107 |
| Paths `.md` únicos referenciados | 511 |
| Referencias en formato hyperlink RST (TIPO A) | 150 |
| Referencias en formato literal/backticks (TIPO B) | 177 |
| Referencias en texto plano (TIPO C) | ~505 |
| Apuntan a `temp-holding/` | 4 |
| Apuntan a URLs absolutas externas | 3 |

## Distribución por dominio source/

| Dominio | Ocurrencias |
|---------|-------------|
| `normativa/` | 742 (89%) |
| `gestion/` | 54 |
| `backend/` | 9 |
| `devops/` | 8 |
| `risks-technical-debt/` | 5 |
| `requisitos/` | 4 |
| `frontend/` | 4 |
| `plantuml-guide/` | 2 |
| `_static/` | 2 |
| `arquitectura-tecnica/` | 1 |
| `conf.py` | 1 (comentario) |

**Concentración crítica:** 89% en `normativa/` — el dominio que
declara procesos, ADRs y procedimientos. Implica que documentación
de gobernanza es la más afectada por links rotos.

## Top archivos con más referencias `.md`

| Archivo | # refs |
|---------|--------|
| `proc-gob-001-mapeo-procesos-templates.rst` | 179 |
| `proc-gob-008-reorganizacion-estructura-documental.rst` | 43 |
| `proced-gob-005-analisis-impacto-cambios.rst` | 39 |
| `proc-gob-002-gobernanza-sdlc.rst` | 38 |
| `adr-gob-004-clasificacion-reglas-negocio.rst` | 30 |
| `proc-req-019-trazabilidad-requisitos.rst` | 26 |
| `adr-gob-003-jerarquia-requerimientos-5-niveles.rst` | 23 |
| `guia-completa-desarrollo-features.rst` | 20 |
| `proced-gob-004-crear-caso-uso.rst` | 19 |
| `adr-gob-005-especificacion-casos-uso.rst` | 19 |

## Categorización por tipo de referencia

### TIPO A — Hyperlinks RST (150 ocurrencias)

Sintaxis: `` `Texto descriptivo <path/al/archivo.md>`__ ``

Sphinx los renderiza como `<a href="path/al/archivo.md">` en el
HTML publicado. **Sphinx NO valida que el archivo exista.**

**Riesgo:** clic en el sitio publicado → 404.

**Ejemplos:**

```rst
`ADR-015-frontend-modular-monolith <./ADR-015-frontend-modular-monolith.md>`__
`PRIORIDAD_01 <../../backend/requisitos/prioridad_01_estructura_base_datos.md>`__
`README principal <../../../README.md>`__
```

### TIPO B — Literales en backticks (177 ocurrencias)

Sintaxis: `` ``path/al/archivo.md`` `` o `` `archivo.md` ``

Renderizados como código inline `<code>`. **No son links.**

**Riesgo:** menor — son menciones descriptivas, no links activos.
Pero si el nombre es incorrecto (typo, nombre obsoleto), confunde
al lector.

**Ejemplos:**

```rst
``docs/scripts/metrics_and_reporting.md``
``TODO.md``
``docs/backend/requisitos/INDICE_MAESTRO_PERMISOS_GRANULAR.md``
```

### TIPO C — Texto plano (~505 ocurrencias)

Sintaxis: mención casual sin formato RST especial.

**Ejemplos:**

```rst
"mencionado en frontend/analisis_api_frontend.md"
"backlog (TODO.md) con hitos"
"verificación de servicios (verificar_servicios.md)"
```

**Riesgo:** mínimo — son referencias narrativas. Pero si el lector
busca el archivo y no existe, frustra UX.

## Top paths `.md` únicos referenciados

| Path | Veces referenciado |
|------|---------------------|
| `CHANGELOG.md` | 18 |
| `README.md` | 15 |
| `RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | 10 |
| `verificar_servicios.md` | 10 |
| `plantilla_django_app.md` | 10 |
| `readme.md` | 9 |
| `procedimiento_qa.md` | 9 |
| `procedimiento_release.md` | 8 |
| `checklist_desarrollo.md` | 8 |
| `INDICE.md` | 8 |
| `plantilla_tdd.md` | 7 |
| `checklist_trazabilidad_requisitos.md` | 7 |

**Patrón observado:** muchas referencias son a artefactos de
templates (`plantilla_*.md`), procedimientos (`procedimiento_*.md`),
checklists (`checklist_*.md`) y archivos de documentación raíz
(README, CHANGELOG, INDICE).

## Hipótesis del origen

La concentración masiva en `normativa/procedimientos/` y
`normativa/gobernanza/` sugiere que estas referencias provienen
de:

1. **Migración incompleta:** los ADRs/procedimientos fueron
   originalmente escritos como `.md` y migrados a `.rst` pero
   las referencias internas no fueron actualizadas.
2. **Documentos compañeros vivos:** templates, checklists y
   procedimientos que conviven en el repo en formato `.md`
   (no en `source/` Sphinx) pero referenciados desde `source/`.
3. **Referencias a `temp-holding/`:** documentos históricos
   que no son parte del sitio publicado.
4. **Referencias a artefactos externos:** README, CHANGELOG del
   repo principal.

## Por qué Sphinx no detecta los links rotos `.md`

Sphinx valida exclusivamente:

| Construct | Sintaxis | ¿Valida destino? |
|-----------|----------|------------------|
| `:doc:` cross-reference | `` :doc:`/path/document` `` | ✓ SÍ |
| `:ref:` label-based | `` :ref:`label-name` `` | ✓ SÍ |
| `:numref:`, `:term:`, etc. | objetos del dominio Sphinx | ✓ SÍ |
| Hyperlink externo `<URL>` | `` `Text <URL>`__ `` | ❌ NO |
| Hyperlink interno `<file>` | `` `Text <file.md>`__ `` | ❌ NO (lo trata como URL) |
| Texto literal | `` ``str`` `` o texto | ❌ NO |
| Imagen | `.. image:: file.png` | ✓ SÍ (si está en `_static`) |

**Razón técnica:** Sphinx usa el módulo `docutils` que distingue
entre **internal references** (resueltas por Sphinx) y **external
references** (delegadas al renderer HTML/PDF). Cualquier path con
extensión que no sea `.rst`, `.md` (cuando MyST está habilitado)
o que tenga prefijo `http(s)://`, `mailto:`, `ftp://` cae en
"external" y NO se valida.

**Conclusión:** los warnings tipo `unknown document` solo aparecen
para `:doc:` references. Todo lo demás pasa silencioso.

## Plan de remediación propuesto (Phase 6 PLAN del WP)

### Fase 1 — Triaje por categoría de destino

Para cada uno de los 511 paths únicos, determinar:

1. **EXISTE** en el repo (en cualquier directorio) → preservar como
   hyperlink relativo correcto.
2. **EXISTE en `temp-holding/`** → mover a referencia citacional
   sin link clickeable (texto plano con nota de origen histórico).
3. **NO EXISTE en absoluto** → eliminar el link y reemplazar por
   texto descriptivo, o crear el documento si es necesario.
4. **EXTERNO al repo** (URL absoluta) → preservar.

### Fase 2 — Estrategia por TIPO

| TIPO | Cantidad | Acción propuesta |
|------|----------|------------------|
| A (hyperlinks) | 150 | Validar destino; los rotos → convertir a TIPO C (texto plano) o crear archivo |
| B (literales) | 177 | Bajo riesgo; revisar solo los con typos/nombres obsoletos |
| C (texto plano) | ~505 | Bajo riesgo; auditar solo los que prometan navegación al lector |

### Fase 3 — Prevención futura

- Configurar Sphinx con `nitpicky = True` y filtros para detectar
  hyperlinks a `.md` rotos (custom checker en CI).
- Política convención: documentos en `source/` SOLO referencian
  `.rst` en `source/` o URLs externas absolutas. Los `.md` viven
  fuera de `source/`.
- Verificación automática como parte de la CI pipeline.

## Hallazgo conexo: errores nuevos en modelo-rbac-iact

Durante la auditoría se detectaron también:

- `modelo-rbac-iact.rst:816, 1041, 1049`: ERROR `Unexpected indentation [docutils]`.
- `modelo-rbac-iact.rst:817, 1042`: WARNING `Block quote ends without a blank line`.

Estos son preexistentes pero deben atenderse en otro WP de
saneamiento de RST.

## Métricas de éxito del WP

- 0 hyperlinks RST a `.md` inexistentes en source.
- 0 referencias citacionales a archivos que no existen ni en
  source/ ni en temp-holding/ ni en URLs externas.
- Política de naming documentada en STD-007 o similar.
- Checker en CI que detecta hyperlinks rotos a `.md`.

## Próximos pasos

1. **Phase 2 MEASURE**: cuantificar cuántos de los 511 paths
   apuntan a archivos que SÍ existen vs no existen (script
   automatizable).
2. **Phase 3 ANALYZE**: clasificar por motivo del rote (typo,
   migración, eliminación, etc.).
3. **Phase 4 CONSTRAINTS**: declarar política de referencias.
4. **Phase 5 STRATEGY**: decidir crear archivos faltantes vs
   reemplazar links.
5. **Phase 6 PLAN**: task plan de remediación.
6. **Phase 8 EXECUTE**: aplicar fixes.

## Referencias

- WP rbac-modelo-conceptual-cleanup (origen del hallazgo)
- Sphinx documentation: https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html
