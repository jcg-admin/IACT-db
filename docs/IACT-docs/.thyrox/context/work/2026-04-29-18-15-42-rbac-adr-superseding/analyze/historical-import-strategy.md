```yml
created_at: 2026-04-29 20:25:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador (decisión pendiente del ejecutor)
version: 1.0.0
```

# Estrategia de importación de material histórico a source/

## Principio (confirmado por el ejecutor)

`source/` es el corpus **autocontenido publicable**:

- ✅ NO referencia `temp-holding/` (es workspace, no publicación).
- ✅ NO referencia `.thyrox/` (es proceso interno, no producto).
- ✅ Cualquier material que un ADR/CNST/UC necesite citar debe
     vivir bajo `source/`.

Si los ADRs nuevos `adr-gob-009` y `adr-back-005` necesitan citar
material histórico, ese material debe **importarse a source/**
adaptándolo a las convenciones (kebab-lowercase, RST puro, schema
STD-007 v2.0.2).

## Material candidato a importar

### Imprescindibles para ADR-GOB-009 (conceptual)

| Origen `temp-holding/` | Para qué se cita | Acción |
|------------------------|-------------------|--------|
| `RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md` (14 KB) | Documenta los 87+ errores que motivaron v5.2.1 → CNST-033 vocabulary canónico | **Importar como artefacto histórico** |
| `RBAC/Modelo RBAC Sin Pretensiones v4.0.txt` (99 KB) | "Lo que NO replicar" — 18 roles R001..R018 legacy | **NO importar completo** — resumir en narrativa breve dentro del ADR |
| `GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md` § PARTE 3 | Debate "8 vs 9 módulos" + decisión final | **Extractar solo PARTE 3** + adaptar |

### Imprescindibles para ADR-BACK-005 (técnico)

| Origen `temp-holding/` | Para qué se cita | Acción |
|------------------------|-------------------|--------|
| `Modules/*.py` (12 archivos Python) | Diseño de referencia heredado | **NO importar como código** — resumir el diseño en narrativa RST |

## Estructura propuesta para los archivos importados

### Decisión de ubicación

Hay 3 opciones razonables:

| Opción | Path | Pros | Contras |
|--------|------|------|---------|
| **A** | `source/arquitectura-tecnica/rbac/_historia/` | Local al subdominio RBAC; prefijo `_` excluye del toctree público (Sphinx) | Solo accesible vía path absoluto en `:doc:` |
| B | `source/base-cognitiva/_historico/` | Centraliza histórico del proyecto en un solo lugar | Disperso del subdominio que lo cita |
| C | `source/historico/` (nuevo top-level) | Visibilidad propia | Crea dir nuevo + más complejidad |

**Recomendada: Opción A.**

- Coincide con el subdominio (`rbac/`) que cita el material.
- Prefijo `_historia` excluye del navegador público (per STD-007
  v2.0.2 §5.2 — convención Sphinx para directorios internos).
- ADRs y modelo lo referencian fácilmente con
  `:doc:`/arquitectura-tecnica/rbac/_historia/<file>``.

### Archivos a crear (Opción A)

```
source/arquitectura-tecnica/rbac/_historia/
├── index.rst                                              # entry-point
├── analisis-errores-modelo-rbac-v5-2-0.rst                # historial
├── modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst       # extracto narrativo del v4.0
├── decisiones-modulos-8-vs-9-historico.rst                # PARTE 3 del análisis
└── diseno-referencia-implementacion-permisos-legacy.rst   # narrativa de Modules/*.py
```

5 archivos nuevos en source/. Todos con frontmatter Schema A
canonical:

```yml
:artefacto: HIST_RBAC_NNN
:tipo: Documento Historico
:dominio: arquitectura-tecnica
:subdominio: rbac/_historia
:estado: Aprobado
:version: 1.0.0
:fecha_creacion: 2026-04-29
:autor: Equipo IACT
:clasificacion: Interno
```

### Convenciones aplicadas en la adaptación

Cada archivo importado pasa por:

1. **Format conversion:** MD/TXT → RST
   - Headers `# H1` → `=== H1 ===` / `--- H2 ---` / `^^^ H3 ^^^`
   - Tables MD → `.. list-table::`
   - Links `[txt](url)` → `` `txt <url>`_ ``
   - Code blocks `~~~lang` → `.. code-block:: lang`
   - Emojis legacy → ASCII text

2. **Filename conversion:** STD-007 v2.0.2 kebab-lowercase
   - `MODELO_RBAC_IACT_v5_2_0` → `modelo-rbac-iact-v5-2-0`
   - `ANALISIS_ERRORES` → `analisis-errores`

3. **Metadata frontmatter:** Schema A canonical (§6 STD-007).

4. **Ranking:** marcar como `:tipo: Documento Historico` y agregar
   nota visible en cuerpo:

   ```rst
   .. note::

      **Documento histórico — referencia para trazabilidad.**

      Este artefacto preserva información histórica del proceso de
      decisión del modelo RBAC. NO es spec vigente. Para spec
      vigente ver :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
      + :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`.
   ```

5. **Cross-refs:** apuntar a artefactos vigentes donde aplique.

## Adaptación específica por archivo

### 1. `analisis-errores-modelo-rbac-v5-2-0.rst`

- **Origen:** `temp-holding/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md` (14 KB).
- **Adaptación:** conversión MD → RST + frontmatter; conservar
  la tabla de 87 errores y el análisis de causa raíz (vocabulario
  español → inglés).
- **Tamaño esperado:** ~200-300 líneas.
- **Cross-refs:** apunta a CNST-033 (que formaliza el vocabulario)
  + modelo-rbac-iact (v5.2.1 vigente).

### 2. `modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst`

- **Origen:** `temp-holding/RBAC/Modelo RBAC Sin Pretensiones v4.0.txt` (99 KB).
- **Adaptación:** **NO importar completo** (99 KB es excesivo
  para histórico). Crear documento RESUMEN narrativo que:
  - Enumere los 18 roles R001..R018 con descripción 1-línea.
  - Explique por qué fueron descartados (estructura jerárquica
    rígida).
  - Cite SBVR-01 que ya formaliza el rechazo.
- **Tamaño esperado:** ~100-150 líneas.

### 3. `decisiones-modulos-8-vs-9-historico.rst`

- **Origen:** `temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md` § PARTE 3.
- **Adaptación:** extraer sólo PARTE 3 (Identificación de
  Contradicciones); convertir a RST; enumerar la decisión final
  "8 módulos con SEC_RULES integrado".
- **Tamaño esperado:** ~80-120 líneas.

### 4. `diseno-referencia-implementacion-permisos-legacy.rst`

- **Origen:** `temp-holding/Modules/*.py` (12 archivos Python).
- **Adaptación:** **NO importar como código** (no es spec, es
  legacy). Crear narrativa RST que:
  - Liste los 12 archivos con su propósito 1-línea.
  - Resuma la estructura: 8 tablas BD, vistas SQL, funciones SQL.
  - Identifique los nombres legacy (`Capacidad`, `manage_sessions`)
    y mapee al vocabulario actual.
  - Cite ADR-BACK-005 nuevo como spec vigente.
- **Tamaño esperado:** ~150-200 líneas.

### 5. `index.rst`

- Entry-point del subdir `_historia/`.
- Toctree de los 4 anteriores.
- Nota visible: "Esta sección preserva contexto histórico del
  modelo RBAC IACT. Para spec vigente, consultar el modelo
  principal y los CNSTs."

## Implicación para Z.1 — scope expansion

### Z.1 original

- Crear 2 ADRs nuevos (`adr-gob-009`, `adr-back-005`).
- Marcar 3 ADR-BACK legacy como `:estado: Superseded`.
- Estimación: 1 sesión (~2-3h).

### Z.1 expandido (con import histórico)

- Crear 2 ADRs nuevos.
- Crear 5 archivos históricos en `source/arquitectura-tecnica/rbac/_historia/`.
- Marcar 3 ADR-BACK legacy como Superseded.
- Build verify.
- Estimación: ~4-6h.

**Aumento ~2x el tiempo, pero:**

- ✅ Los ADRs nuevos pueden citar material en source/ sin acoplar
  a temp-holding.
- ✅ Material histórico queda accesible permanentemente en el
  corpus publicable (con deprecation marker visible).
- ✅ Cumple el principio "source/ autocontenido".

## Alternativas si Z.1 no debe expandirse

| Alt | Impacto |
|-----|---------|
| **Alt-1:** ADRs nuevos NO citan material histórico (solo justifican con texto interno) | Pierde trazabilidad histórica de las decisiones |
| **Alt-2:** ADRs nuevos citan implícitamente ("ver análisis previo") sin link | Reader no encuentra el análisis fácilmente |
| **Alt-3:** Crear sub-WP Z.1.1 separado para el import histórico, ejecutar antes de Z.1 | Granularidad extra; bloquea redacción de los ADRs nuevos hasta cerrar Z.1.1 |
| **Alt-4:** Importar material en Z.1 expandido (esta propuesta) | Z.1 toma ~2x tiempo pero entrega coherente |
| **Alt-5:** Inlinar el contenido relevante directamente DENTRO del ADR nuevo (sin doc histórico separado) | ADRs muy grandes (~800-1000 líneas cada uno); no escala si más decisiones requieren contexto |

**Recomendada: Alt-4** (Z.1 expandido).

**Argumentación:** los 4 archivos históricos son la herramienta
correcta porque el ADR-GOB-009 no debe contener 14 KB de análisis
de errores literal — el ADR debe ser conciso ("decidimos X porque
Y, ver `/arquitectura-tecnica/rbac/_historia/analisis-errores-...`
para detalles").

Z.1.1 separado (Alt-3) es defensible si se quiere granularidad
extra, pero el material histórico solo tiene sentido en presencia
de los ADRs que lo citan. Acoplarlos en Z.1 mantiene el cierre
coherente.

## Pregunta para el ejecutor

1. **¿Apruebas el principio "source/ autocontenido + import histórico"?**
2. **¿Apruebas Opción A** (`source/arquitectura-tecnica/rbac/_historia/`)?
3. **¿Apruebas Z.1 expandido** (Alt-4) o prefieres Z.1.1 separado (Alt-3)?
4. **¿Hay material adicional en `temp-holding/`** que el ejecutor sepa
   que es relevante y no detecté en la auditoría?
