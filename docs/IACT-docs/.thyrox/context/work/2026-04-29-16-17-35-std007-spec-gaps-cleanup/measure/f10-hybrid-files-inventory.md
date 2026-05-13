```yml
created_at: 2026-04-29 16:35:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 2 — MEASURE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# F-10 Hybrid MD/RST Files Inventory

## Resumen

Scan exhaustivo del corpus para identificar archivos parcialmente
convertidos de MD a RST. Detección por múltiples heurísticas.

## F-10 estricto (2 archivos)

Archivos cuyo **primer header** literal contiene `<NOMBRE>.md`:

```
source/requisitos/requisitos-no-funcionales/rnf-proc-001-proceso-sdlc.rst
source/requisitos/requisitos-no-funcionales/rnf-proc-002-metricas-proceso.rst
```

**Reproducible:**

```bash
for f in $(find source -type f -name "*.rst"); do
  head -3 "$f" | grep -E "^[A-Z][A-Z0-9_-]+\.md$" > /dev/null && echo "$f"
done
```

**Headers actuales (extracto):**

```
# rnf-proc-001-proceso-sdlc.rst
RNF-PROC-001_PROCESO_SDLC.md
============================

# rnf-proc-002-metricas-proceso.rst
RNF-PROC-002_METRICAS_PROCESO.md
================================
```

**Severity:** CRITICAL — el título es el filename MD original con
extensión `.md` literal. Sphinx lo renderiza como header H1 visible
para el lector, lo cual es semánticamente incorrecto y confuso.

## F-10 ampliado: patrones MD residuales (3 archivos adicionales)

Archivos con sintaxis MD residual `[linktext](url)` (RST usa
`` `text <url>`_ ``):

```
source/normativa/procedimientos/proced-gob-002-actualizar-documentacion.rst
source/normativa/procedimientos/proced-gob-005-analisis-impacto-cambios.rst
source/normativa/estandares/guia-estilo.rst
```

**Reproducible:** `grep -rl "\](http" source --include="*.rst"`

**Severity:** MAJOR — sintaxis MD que Sphinx muestra literal
(no renderiza como link). Deuda menor pero perceptible al lector.

## F-10 NO detectado en otros patrones

| Patrón scaneado | Resultado |
|-----------------|-----------|
| Headers `# H1` estilo MD | **0** archivos ✓ |
| Separadores `---` tipo MD | **0** archivos ✓ |
| Inline single-backtick code (\`x\`) | no checkeado (ambiguo: válido en ambos) |

## Total F-10

- **2 archivos estrictos** (CRITICAL — título literal con `.md`)
- **3 archivos ampliados** (MAJOR — sintaxis link MD residual)
- **5 archivos totales** requieren intervención

## Plan de remediación (preliminar)

### Para los 2 estrictos (rnf-proc-*)

1. Eliminar el primer header `<NAME>.md ===` por completo.
2. Mover el segundo header (descripción real) a posición de H1.
3. Agregar frontmatter `.. meta::` con campos del schema source/:
   - `:artefacto: RNF-PROC-001` / `RNF-PROC-002`
   - `:tipo: Requisito No Funcional`
   - `:dominio: requisitos`
   - `:subdominio: requisitos-no-funcionales`
   - `:estado: Aprobado`
   - `:version: 1.0.0`
   - `:fecha_creacion: 2026-04-28` (inferir de git log)
   - `:autor: Equipo IACT`
   - `:clasificacion: Interno`
4. Verificar `:ref:` labels (si los antiguos refs existen).

### Para los 3 con sintaxis MD link

1. Convertir `[linktext](url)` → `` `linktext <url>`_ `` (RST anonymous link).
2. Verificar que ningún link queda roto.
3. Build verify.

## Implicación para el orden del WP

F-10 es **menor en magnitud** de lo estimado inicialmente (≥2 →
total 5). Esto significa:

- Bloque D (F-10) será corto: 5 archivos, ~30min.
- Bloque E (F-07/F-08/F-09) procesará los 35 restantes sin meta
  + los 133 sin fecha — sigue siendo el bloque más voluminoso.

No cambia el orden A → B → C → D → E → F.
