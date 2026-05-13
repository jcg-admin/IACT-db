```yml
project: IACT-docs
work_package: 2026-04-28-05-27-25-source-rebuild-base-cognitiva
parent_wp: 2026-04-28-01-58-08-source-rebuild-strategy
parent_relationship: child #1 of 16 (first in execution order)
created_at: 2026-04-28 05:27:25
current_phase: Phase 11 — TRACK (CERRADO v2)
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: CERRADO v2 — 2026-04-28 16:30 (W-1 + W-7 remediation aplicada, 22 fixes, 0 warnings)
opened_at: 2026-04-28 05:50:00
closed_at: 2026-04-28 06:05:00
reopened_at: 2026-04-28 16:00:00
closed_v2_at: 2026-04-28 16:30:00
```

# WP-hijo #1 — Source Rebuild: base_cognitiva

## Propósito

Reconstruir el dominio `source/base_cognitiva/` (33 archivos `.rst`)
aplicando la estrategia v2.0 del WP-padre. Es el **primer WP de
rebuild**: provee el vocabulario base (glosario, ontología,
fundamentos, taxonomías, metamodelos) que los demás dominios van
a usar.

## Capa en arquitectura v2.0

**Methodology / Governance** (capa 1 — primero en orden secuencial).

## Referencia al padre

- **WP-padre:** `2026-04-28-01-58-08-source-rebuild-strategy`
- **Plan padre aprobado:** `plan/source-rebuild-strategy-plan.md`
  (Aprobado 2026-04-28 05:15)
- **Strategy padre v2.0:** `strategy/source-rebuild-strategy-solution-strategy.md`
  (Aprobada 2026-04-28 04:48)

Decisiones del padre que aplican a este WP-hijo:

- Idea 1 (Backup-as-reference) — `temp-backup/` + `temp-holding/`
  son consultivos, no fuentes de copia mecánica.
- Idea 3 (Standards-first) — STD_007 + STD_006 desde día 1.
- Idea 4 (RST puro) — sin Markdown, sin myst-parser.
- Idea 5 (criterio editorial humano-en-loop) — Claude propone
  clasificación, ejecutor confirma.
- Idea 9 NO APLICA (este no es WP tech-skeleton).
- Idea 10 (source/ ↔ .thyrox/ separados) — relevante para
  `gestion/`, no acá.
- Decision 2 (`temp-backup/` se crea aquí, en este WP-hijo).
- Decision 3 (sin `-W` durante rebuild, recuperar al final) —
  aplicable.
- Decision 8 (cada WP-hijo con ciclo THYROX completo).
- Decision 14 (knowledge subsumido en base_cognitiva) — confirma
  el scope amplio de este dominio.

## Pre-tareas absorbidas (del plan del padre)

| Pre-tarea | Origen | Acción esperada en Phase 1 DISCOVER |
|-----------|--------|-------------------------------------|
| **Crear `temp-backup/source-2026-04-28/`** | Decision 2 + Decision 1 (D1) | Snapshot inmutable del estado verificado "0 warnings" del `source/` actual. Versionar en este feature branch. Eliminación al final del último WP-hijo (#15). |
| **Triage F-NEW-2** | Pre-tareas WP #1 + análisis del padre | Identificar cuál de los 5 backups anidados de `temp-holding/GENERACION_DOCUMENTACION/` es el más curado: `IACT_Backup_Completo_2026-01-11/`, `IACT_Backup_Completo_2026-01-11-old/`, `TMP_COMPLETO_2026-01-13/`, `TMP_COMPLETO_2026-01-13_OK/`, `TMP_COMPLETO_IACT_2026-01-13_2/`. Documentar elección con justificación. |
| **Inventario de `base_cognitiva/`** (F-OLD-3 del padre) | Discover del padre §8 | Para cada archivo del dominio: clasificar como incorporado / fusionado-con-X / reescrito / descartado-con-razón. |

## Inventario inicial del dominio (verificado en padre, repetido aquí)

```
source/base_cognitiva/                      33 .rst
├── _fundamentos_conceptuales/              FND_01..FND_07 + index
├── _metadata/                              META_01..META_05 + index
├── _ontologia_sbvr/                        SBVR_01..SBVR_05 + index
├── _taxonomias_y_metamodelos/              MTM_NN_*, TXM_NN_* + index
└── (raíz)                                  glossary, glosario_babok_pmbok_iso,
                                            IACT_Glossary_v1_0_0, index
```

Patrones detectados (de discover del padre):

- Underscores como prefijo de directorio (`_fundamentos_*`) — Sphinx
  los excluye del toctree público intencionalmente (STD_007 §5.2).
- Mezcla de patrones en raíz: `glossary.rst` (inglés),
  `glosario_babok_pmbok_iso.rst` (snake_case),
  `IACT_Glossary_v1_0_0.rst` (PascalCase + version → viola STD_006).
- `MOD_NN_Nombre.rst` (PascalCase con guion bajo) — verificar si
  existe y conformidad con STD_007 §4.1.

## Alcance propuesto (refinar en Phase 1 DISCOVER)

**In-scope:**

- Crear `temp-backup/source-2026-04-28/` con `cp -r source/`.
- Triage de los 5 backups anidados de `temp-holding/`.
- Inventario detallado de los 33 archivos actuales de
  `base_cognitiva/`.
- Inventario de archivos relevantes en `temp-holding/` y en el
  backup elegido.
- Clasificación editorial de cada archivo
  (incorporar / fusionar / reescribir / descartar).
- Reconstrucción del nuevo `source/base_cognitiva/` aplicando
  STD_007 (naming) + STD_006 (versión en metadata, no filename).
- Renombrado de `IACT_Glossary_v1_0_0.rst` → `IACT_Glossary.rst`
  con `:version: 1.0.0` en metadata.
- Reconciliación de los 3 glosarios duplicados (cuello v2.0 #12
  `Glossary duplicado`).
- Build verde sin warnings dentro del dominio (sin `-W` por
  Decision 3).

**Out-of-scope:**

- Modificar otros dominios (normativa, requisitos, etc.).
- Resolver conflictos cross-dominio (van en sus WPs respectivos).
- Decidir versionado de templates (eso es WP #2).
- Crear extensiones Sphinx custom.

## Pre-condiciones

- ✅ WP-padre `source-rebuild-strategy` aprobado en Phase 6.
- ✅ Task plan del padre aprobado (T-008 abre este WP).
- ⏳ Bootstrap del repo completo (tools/plantuml.jar, .venv) —
  verificable con `make check-bootstrap`.

Sin pre-condiciones de WPs hermanos (este es el primero).

## Salida esperada al cierre

- Nuevo `source/base_cognitiva/` reconstruido con criterio editorial.
- 100% archivos cumple STD_007 + STD_006.
- `index.rst` lista todo el contenido en toctree.
- Cero refs apuntando al backup.
- Todos los archivos del backup clasificados (incorporado /
  fusionado / reescrito / descartado-con-razón).
- Build verde dentro del dominio.
- `track/{wp}-changelog.md` cerrado.

## Estado

**Borrador (no iniciado).** Este WP fue spawneado por T-008 del
task plan del WP-padre. Esperando que el ejecutor lo abra
explícitamente (instrucción "abrir WP base-cognitiva" o similar)
para iniciar Phase 1 DISCOVER.
