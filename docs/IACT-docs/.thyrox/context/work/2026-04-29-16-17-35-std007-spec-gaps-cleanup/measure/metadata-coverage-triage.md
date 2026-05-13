```yml
created_at: 2026-04-29 16:45:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 2 — MEASURE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Metadata Coverage Triage — F-07/F-08/F-09 + F-13 (nuevo)

## Hallazgo crítico nuevo: F-13 — Schema split en metadata YAML

**Severity: MAJOR**

El corpus tiene **dos schemas distintos** de metadata YAML
coexistiendo, sin documentación canónica en STD alguno.

### Schema A — Canonical (usado por STDs, ADRs, BR, CNST, FND...)

```
.. meta::
 :artefacto: STD_007
 :tipo: Estándar
 :dominio: normativa
 :subdominio: estandares
 :estado: Aprobado
 :version: 2.0.1
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-29
 :autor: Equipo IACT
 :clasificacion: Interno
```

### Schema B — Legacy UC (usado por UCs y FRs)

```
.. meta::
 :project: IACT - Call Center Analytics
 :version: 4.0.0
 :date: 2026-01-06
 :status: Aprobado
 :module: MOD_Access
 :uc_id: UC_ACC_01
 :normativa: CNST_029, CNST_025
```

### Equivalencias entre schemas

| Schema A (Canonical) | Schema B (Legacy UC) | Notas |
|----------------------|----------------------|-------|
| `:artefacto:` | `:uc_id:` o `:project:` | A=ID, B=parcial |
| `:tipo:` | (implícito por `:uc_id:`) | A=explícito |
| `:dominio:`/`:subdominio:` | `:module:` | A=path semántico |
| `:estado:` | `:status:` | sinónimos |
| `:version:` | `:version:` | mismo |
| `:fecha_creacion:` | `:date:` | sinónimos |
| `:ultimo_cambio:` | (ausente) | A=track changes |
| `:autor:` | (ausente) | A=track ownership |
| `:clasificacion:` | (ausente) | A=track confidentiality |
| (ausente) | `:normativa:` | B=cross-ref CNSTs |

### Conteos verificados

| Schema | Cant archivos | Comando |
|--------|--------------:|---------|
| Canonical (`:artefacto:`) | 301 | `grep -rl ":artefacto:" source --include="*.rst" \| wc -l` |
| Legacy UC (`:uc_id:` o `:module:`) | 49 | `grep -rl -E "(:uc_id:\|:module:)" source --include="*.rst" \| wc -l` |
| Solo `:date:` (sin fecha_creacion) | 51 | `grep -rl "^[[:space:]]*:date:" source --include="*.rst" \| wc -l` |
| Sin **ninguna fecha** (ni `:date:` ni `:fecha_creacion:`) | 74 | scan |

## Findings reconciliados

### F-07 — Sin frontmatter `.. meta::` (29 archivos)

Conteo verificado con `head -15` (más preciso que `head -3`).

**Reproducible:**
```bash
for f in $(find source -type f -name "*.rst" ! -name "index.rst"); do
  head -15 "$f" | grep -q "^\.\. meta::" || echo "$f"
done | wc -l
```

### F-08 — Sin `:version:` (35 archivos)

F-08 ⊃ F-07: 6 archivos extra tienen `.. meta::` pero sin `:version:`.

### F-09 — Recalibrado: 74 archivos sin **ninguna fecha**

Conteo previo (133) era falsamente alto: solo medía `:fecha_creacion:`
literal, ignorando archivos con `:date:` (schema legacy UC).

**Distribución por path:**

| Path | F-09 cant | Mayoría schema |
|------|-----------|----------------|
| source/requisitos | ~22 | UC con `:date:` parcialmente migrados |
| source/normativa | 12 | ADRs sin frontmatter (F-07 también) |
| source/gestion | 10 | mix |
| source/arquitectura-tecnica | 8 | arq-mod-* todos |
| source/plantuml-guide | 7 | guides sin meta |
| source/(otros) | ~15 | mix |

### F-13 (NUEVO) — Schema split

Un schema canónico debe documentarse en STD_007 v2.0.2 (o STD nuevo).

**Decisión preliminar:**

- **Schema A (Canonical)** queda como ÚNICO schema válido.
- Los 49 archivos legacy UC migran a Schema A (mapping 1:1
  por equivalencias, preservando información):
  - `:uc_id:` → `:artefacto:`
  - `:module:` → `:subdominio:`
  - `:status:` → `:estado:`
  - `:date:` → `:fecha_creacion:`
  - `:project:` → eliminar (redundante con repo-level)
  - `:normativa:` → preservar como campo extra (válido en Schema A)
- Los 3 sin schema (plantilla-adr, git-workflow, guidelines) → caso por caso.

## Triaje: artefactos primarios vs guías

### Artefactos primarios (REQUIEREN metadata canónica) — 108 + 49 + 8 = ~165

- 108 con prefijo numerado canónico (uc-, br-, fr-, cnst-, adr-, proc-, std-, tpl-, etc.) que no tienen `:fecha_creacion:`
- 49 con schema legacy UC
- 8 arq-mod-* (sin meta — comment-style legacy)

### Guías/info (PUEDEN omitir metadata) — propuesta

| Path | Archivos | Decisión propuesta |
|------|----------|---------------------|
| `source/plantuml-guide/*.rst` (no en ejemplos/) | 3 (`color-palette`, `guidelines`, `metadata-standard`) | OPCIONAL — guías cortas, exigir solo `:version:` y `:autor:` |
| `source/plantuml-guide/ejemplos/*.rst` | 4 (`test-uc-diagram`, `test-component-diagram`, `etl-pipeline`, `sistema-completo`) | OPCIONAL — ejemplos didácticos |
| `source/gestion/git-workflow.rst` | 1 | REQUERIDA — guía operativa |
| `source/gestion/plantilla-adr.rst` | 1 | REQUERIDA — plantilla |
| `source/gestion/pm/checklists/*.rst` | 6 | REQUERIDA — checklists oficiales |
| `source/gestion/pm/deployment-plan.rst` | 1 | REQUERIDA — plan de despliegue |

## Plan revisado para Bloque E (F-07/F-08/F-09 + F-13)

| Sub-bloque | Acción | Cant aprox |
|------------|--------|-----------:|
| E.1 | Migrar Schema B → Schema A en 49 UCs/FRs (mapping 1:1) | 49 |
| E.2 | Agregar `.. meta::` completo a 29 archivos sin frontmatter | 29 |
| E.3 | Agregar `:version: 1.0.0` donde falta (post E.2) | ~6 |
| E.4 | Agregar `:fecha_creacion:` inferido de git log donde falta | ~74 |
| E.5 | Documentar excepción para 7 guías plantuml-guide (opcional) | 7 |
| E.6 | Build verify | — |

## Implicación para el plan global

- **F-09 magnitud real: 74 (no 133)** — bajo recalibración.
- **F-13 nuevo: 49 archivos** con schema legacy a migrar.
- Bloque E sigue siendo el más voluminoso pero ahora más
  manejable (~80 archivos a tocar, no 133+).
- F-13 debe documentarse en STD_007 v2.0.2 (Bloque B) ANTES
  de la migración E.1 (necesita ground truth).

**Recalibración del plan:** Bloque B también debe documentar el schema canónico.
