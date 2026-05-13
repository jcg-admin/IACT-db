```yml
created_at: 2026-04-28 05:50:00
project: IACT-docs
work_package: 2026-04-28-05-27-25-source-rebuild-base-cognitiva
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 1 DISCOVER — Source Rebuild: base_cognitiva

## 1. Propósito del WP-hijo

Reconstruir el dominio ``source/base_cognitiva/`` aplicando la
estrategia v2.0 del WP-padre. Es el primer dominio del rebuild
secuencial; provee el **vocabulario base** (glosario, ontología,
fundamentos, taxonomías, metamodelos) que los demás 15 dominios
van a consumir como input.

## 2. Inventario verificado

### 2.1 Backup canónico (`temp-backup/source-2026-04-28/base_cognitiva/`)

**33 archivos RST** distribuidos en 4 sub-dominios + raíz:

| Sub-dominio | Archivos | Naming | Estado vs STD_007 |
|-------------|----------|--------|-------------------|
| (raíz) | `index.rst`, `IACT_Glossary_v1_0_0.rst`, `glosario_babok_pmbok_iso.rst`, `glossary.rst` | mixto | Parcial — `_v1_0_0` viola STD_006 (sección 3.4) |
| `_fundamentos_conceptuales/` | `index.rst` + `FND_01..FND_07_*.rst` | `FND_NN_PascalCase` | OK STD_007 §4.1 |
| `_metadata/` | `index.rst` + `META_01..META_05_*.rst` | `META_NN_PascalCase` | OK STD_007 §4.1 |
| `_ontologia_sbvr/` | `index.rst` + `SBVR_01..SBVR_05_*.rst` | `SBVR_NN_PascalCase` | OK STD_007 §4.1 |
| `_taxonomias_y_metamodelos/` | `index.rst` + `metamodelos/` (4) + `taxonomias/` (4) | `MTM_NN_*`, `TXM_NN_*` | OK STD_007 §4.1 |

**Tamaño:** 480 KB, ~15,236 líneas de contenido.

### 2.2 Material complementario (`temp-holding/`)

**15+ archivos relacionados** a base_cognitiva, distribuidos en:

- `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/`:
  10 archivos `PARTE_*.md` que parecen ser drafts iniciales
  (markdown) de los FND_01..FND_07. Versión v1_0_0.
- `temp-holding/FASE 02/base_cognitiva/utilidades/`:
  - `STD_001_Estandares_Documentacion_1_1_0.rst` — pertenece a
    `normativa/estandares/`, no a base_cognitiva.
  - `MAPA_RBAC_COMPLETO_v1_0_0.md` — referencia conceptual de
    RBAC; relacionado con `MTM_03_Metamodelo_RBAC.rst`.
  - `NOM_001_Nomenclatura_Proyecto_2_0_0.rst` — pertenece a
    `normativa/estandares/` (es un STD).
- Glosarios en otros lugares:
  - `temp-holding/FASE 01/docs/backend/GLOSARIO-BACKEND.md` —
    glosario específico de tier (no necesariamente para
    base_cognitiva universal).
  - `temp-holding/FASE 01/docs/gobernanza/glossary.md` — glosario
    en gobernanza (decidir si se fusiona acá o queda en su
    dominio).

### 2.3 source/ actual (post-clean)

`source/base_cognitiva/` **NO existe** (se removió en el reset
del WP-padre). El rebuild crea desde cero.

## 3. Hallazgos

### F-BC-1: Versiones en filenames violan STD_006

Archivo `IACT_Glossary_v1_0_0.rst` lleva versión en filename.
Per STD_006 + STD_007 §3.4, la versión va en metadata YAML.
Renombrado obligatorio:

- `IACT_Glossary_v1_0_0.rst` → `IACT_Glossary.rst` (con
  ``:version: 1.0.0`` en metadata).

### F-BC-2: 3 glosarios coexisten — riesgo de duplicación

- `glossary.rst` (probablemente inglés)
- `glosario_babok_pmbok_iso.rst` (snake_case + idioma mixto)
- `IACT_Glossary_v1_0_0.rst` (PascalCase)

Decisión necesaria (D-BC-1): consolidar a uno solo o mantener
los 3 con propósito diferenciado documentado.

### F-BC-3: Underscores como prefijo de sub-dominio

Sub-dominios `_fundamentos_conceptuales/`, `_metadata/`,
`_ontologia_sbvr/`, `_taxonomias_y_metamodelos/` siguen STD_007
§5.2 (prefijo ``_`` para directorios internos no en navegación
pública). Sphinx por defecto los excluye del toctree público
salvo inclusión explícita.

**Decisión necesaria (D-BC-2):** ¿Se mantiene este patrón? El
patrón es válido y útil pero los 5 archivos en raíz (índice +
glosarios) actúan como "público" mientras todos los demás son
"internos". Confirmar intención.

### F-BC-4: PARTE_*.md son drafts paralelos

Los 10 archivos `PARTE_*.md` en temp-holding parecen ser drafts
markdown anteriores que se consolidaron en los FND_01..FND_07
RST. **Decisión:** descartar (su contenido ya está en los FND
canónicos) salvo que la inspección muestre contenido nuevo.

### F-BC-5: Naming "metamodelos/" vs "taxonomias/" — sub-dirs sin underscore

Dentro de `_taxonomias_y_metamodelos/`, los sub-directorios
`metamodelos/` y `taxonomias/` NO llevan underscore. Inconsistencia
con el patrón del padre. Per STD_007 §5.1 (snake_case para
directorios), está OK como están — pero el patrón de "interno
vs público" no se aplica aquí porque están dentro de un padre
con underscore.

## 4. Clasificación editorial por archivo

Decisión por archivo según D5 del WP-padre (backup-as-reference):
**incorporar / fusionar / reescribir / descartar**.

### 4.1 Raíz (4 archivos)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| `index.rst` | **reescribir** | Será el toctree raíz del nuevo dominio — debe reflejar la nueva estructura (con renombres aplicados). |
| `IACT_Glossary_v1_0_0.rst` | **incorporar (renombrado)** | Contenido del glosario IACT canónico. Renombre: `IACT_Glossary.rst`. Versión a metadata. |
| `glossary.rst` | **fusionar con IACT_Glossary** o **descartar** | Inspección revela si contenido único justifica preservarlo. Si es duplicado parcial, fusionar. |
| `glosario_babok_pmbok_iso.rst` | **incorporar** | Glosario cross-framework (BABOK + PMBOK + ISO) — propósito distinto del IACT_Glossary. Mantener si tiene contenido único. |

### 4.2 _fundamentos_conceptuales/ (8 archivos)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| `index.rst` | **reescribir** | Toctree del sub-dominio. |
| `FND_01_Concepto_Requisito.rst` | **incorporar** | Contenido conceptual base, ~460 líneas. Validar contenido + aplicar STD_007 sobre refs internas. |
| `FND_02_Reglas_de_Negocio.rst` | **incorporar** | idem. |
| `FND_03_Casos_de_Uso.rst` | **incorporar** | idem. |
| `FND_04_Trazabilidad.rst` | **incorporar** | idem. |
| `FND_05_Jerarquia_4_Niveles.rst` | **incorporar** | idem. |
| `FND_06_Derivacion_vs_Transformacion.rst` | **incorporar** | idem. |
| `FND_07_Requerimientos_Funcionales.rst` | **incorporar** | idem. |

### 4.3 _metadata/ (6 archivos)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| `index.rst` | **reescribir** | Toctree. |
| `META_01_Identidad_Proyecto.rst` | **incorporar** | Identidad del producto IACT. Validar que stack tech coincide con el real (DRF+React+Webpack+MySQL+PostgreSQL+Ubuntu+Apache). |
| `META_02_Clasificacion_Documental.rst` | **incorporar** | Clasificación documental. |
| `META_03_Fases_SDLC.rst` | **incorporar (con revisión)** | Fases SDLC del proyecto IACT — validar coherencia con la metodología THYROX usada. |
| `META_04_Contexto_IACT.rst` | **incorporar** | Contexto del producto. |
| `META_05_Estructura_Documental.rst` | **reescribir** | Esta es la sección que describe la estructura del repo de docs. Debe reflejar la **nueva arquitectura v2.0 de 3 capas**, no la anterior. Crítica. |

### 4.4 _ontologia_sbvr/ (6 archivos)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| `index.rst` | **reescribir** | Toctree. |
| `SBVR_01_Conceptos_Nucleares.rst` | **incorporar** | Ontología SBVR — base conceptual estable. |
| `SBVR_02_Fact_Types.rst` | **incorporar** | idem. |
| `SBVR_03_Reglas_Estructurales.rst` | **incorporar** | idem. |
| `SBVR_04_Reglas_Operativas.rst` | **incorporar** | idem. |
| `SBVR_05_Vocabulario_Controlado.rst` | **incorporar** | idem. |

### 4.5 _taxonomias_y_metamodelos/ (10 archivos)

| Archivo | Decisión | Razón |
|---------|----------|-------|
| `index.rst` (padre) | **reescribir** | Toctree. |
| `metamodelos/index.rst` | **reescribir** | Toctree. |
| `metamodelos/MTM_01_Metamodelo_Requisitos.rst` | **incorporar** | Metamodelo. |
| `metamodelos/MTM_02_Metamodelo_Trazabilidad.rst` | **incorporar** | idem. |
| `metamodelos/MTM_03_Metamodelo_RBAC.rst` | **incorporar (consultar MAPA_RBAC_COMPLETO de temp-holding)** | Si el mapa de temp-holding aporta detalle, fusionar. |
| `taxonomias/index.rst` | **reescribir** | Toctree. |
| `taxonomias/TXM_01_Taxonomia_Requisitos.rst` | **incorporar** | Taxonomía de requisitos. |
| `taxonomias/TXM_02_Taxonomia_Artefactos.rst` | **incorporar** | Taxonomía de artefactos — validar coherencia con la nueva arquitectura v2.0. |
| `taxonomias/TXM_03_Taxonomia_Reglas_Negocio.rst` | **incorporar** | Taxonomía de BRs. |

### 4.6 Material temp-holding (PARTE_*.md, glosarios extra)

| Material | Decisión | Razón |
|----------|----------|-------|
| `PARTE_0..6_*.md` (10 archivos) | **descartar** | Son drafts markdown anteriores a los FND RST canónicos. Su contenido ya está consolidado. |
| `MAPA_RBAC_COMPLETO_v1_0_0.md` | **consultar al re-autorear MTM_03** | Material de soporte. Si aporta detalle, incorporar como anexo de MTM_03. |
| `STD_001_Estandares_Documentacion_1_1_0.rst` | **fuera de scope** | Pertenece a `normativa/estandares/` (WP #2). |
| `NOM_001_Nomenclatura_Proyecto_2_0_0.rst` | **fuera de scope** | Pertenece a `normativa/estandares/` (WP #2). |
| `glossary.md` (gobernanza) | **fuera de scope** | Pertenece a `normativa/gobernanza/` (WP #5) si tiene valor; revisar entonces. |
| `GLOSARIO-BACKEND.md` | **fuera de scope** | Glosario tier-específico (backend); evaluar para `backend/` (WP #8). |

## 5. Decisiones a tomar

### D-BC-1: ¿Cómo manejar los 3 glosarios?

- **A)** Mantener los 3 (IACT_Glossary, glossary, glosario_babok_pmbok_iso) con propósitos diferenciados:
  - IACT_Glossary: términos del producto IACT.
  - glossary: glosario general (¿inglés?).
  - glosario_babok_pmbok_iso: glosario cross-framework de metodología.
- **B)** Fusionar todo en un solo glossary maestro con secciones.
- **C)** Mantener IACT_Glossary y glosario_babok_pmbok_iso, descartar glossary (si es redundante).

**Resolución del agente (auto-didacta):** **C** condicional —
inspeccionar `glossary.rst` antes de decidir descartar. Si tiene
contenido único de valor, mantener (opción A).

### D-BC-2: ¿Mantener prefijo `_` en sub-dominios?

- **A)** Mantener `_fundamentos_conceptuales/`, `_metadata/`,
  `_ontologia_sbvr/`, `_taxonomias_y_metamodelos/` (status quo).
- **B)** Renombrar a sin prefijo (sub-dominios públicos).

**Resolución del agente:** **A**. STD_007 §5.2 lo justifica
explícitamente — el contenido de estos sub-dominios es de
referencia interna; el público entra por el `index.rst` y los
3 glosarios en raíz. Sphinx puede listarlos en toctree con
nombre igualmente.

### D-BC-3: META_03_Fases_SDLC y META_05_Estructura_Documental

Ambos son metadata que describen el proyecto. La nueva arquitectura
v2.0 (3 capas) **NO** se refleja en META_05 porque ese archivo se
escribió cuando la estructura era distinta.

**Resolución del agente:** ambos archivos se **reescriben** para
reflejar la nueva arquitectura. Esto es el único caso de re-autoría
real (el resto se incorpora con cambios mínimos).

## 6. Pre-tareas absorbidas (del WP-padre)

| Pre-tarea | Estado |
|-----------|--------|
| Crear `temp-backup/source-2026-04-28/` | ✅ Hecho en commit `13b4faa` |
| Triage F-NEW-2 de los 5 backups anidados de `temp-holding/` | Pendiente — ver §7 |
| Inventario detallado de base_cognitiva | ✅ Este documento |

## 7. Triage F-NEW-2 — 5 backups anidados de temp-holding

Backups detectados en discover del padre:

```
temp-holding/GENERACION_DOCUMENTACION/
├── IACT_Backup_Completo_2026-01-11/
├── IACT_Backup_Completo_2026-01-11-old/
├── TMP_COMPLETO_2026-01-13/
├── TMP_COMPLETO_2026-01-13_OK/
└── TMP_COMPLETO_IACT_2026-01-13_2/
```

**Decisión rápida del agente:** para el alcance de
**base_cognitiva** específicamente, la fuente canónica es
`temp-backup/source-2026-04-28/base_cognitiva/` (snapshot directo
del source/ verificado a 0 warnings). Los 5 backups anidados son
de fechas previas y probablemente representan estados intermedios.

**No es necesario inspeccionar los 5 backups anidados para
base_cognitiva** porque el contenido más reciente y curado está
en el backup directo (el source/ del 2026-04-28 al momento del
rebuild). Los backups anidados se consultarán solo si la
re-autoría descubre vacíos específicos.

**F-NEW-2 cerrado para este WP** con justificación. El triage
formal de los 5 backups anidados se difiere — solo se invoca
on-demand por dominio si surge necesidad.

## 8. Riesgos

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| Re-autoría de 33 archivos en una sesión arruina calidad | Alto | Limitar re-autoría editorial real a los 5 archivos identificados (META_03, META_05, los 4 index.rst). Para los 24 restantes: aplicar normalización STD_007/STD_006 + validación visual del contenido. Esto NO es lift-and-shift mecánico — cada archivo se LEE antes de incorporar. |
| META_03_Fases_SDLC inconsistente con metodología real (THYROX) | Medio | Re-escribir reflejando ÉPICAs + 12 stages THYROX en vez de SDLC clásico. |
| META_05_Estructura_Documental obsoleto vs arquitectura v2.0 | Alto | Re-escribir completo con las 3 capas (methodology + spec/tech + lifecycle). |

## 9. Salida esperada del WP-hijo

- `source/base_cognitiva/` reconstruido con 33 archivos.
- 100% cumple STD_007 + STD_006.
- META_03 + META_05 reescritos.
- 3 glosarios revisados — con justificación de cuáles se mantienen.
- Build verde dentro del dominio (sin `-W` durante rebuild;
  recuperar `-W` final es responsabilidad del WP #15).
- toctree del root `source/index.rst` referencia
  `base_cognitiva/index.rst` como primer dominio publicado.
- Track changelog cerrado.

## 10. Próximo paso (en este WP-hijo)

Phase 5 STRATEGY — confirmar la estrategia de incorporación con
las 3 decisiones D-BC-1..3 resueltas, luego Phase 6 PLAN, luego
Phase 8 PLAN EXECUTION (decompose a T-NNN), luego Phase 10 EXECUTE.
