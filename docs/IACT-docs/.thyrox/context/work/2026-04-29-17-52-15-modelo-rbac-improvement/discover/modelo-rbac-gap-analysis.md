```yml
created_at: 2026-04-29 18:20:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador (síntesis para revisión del ejecutor)
version: 1.0.0
```

# Gap Analysis — modelo-rbac-iact.rst (estado actual vs esperado)

## Calibración

- **OBSERVABLE:** 24 claims (todos verificados con find/grep + Read del documento).
- **INFERRED:** 8 claims (interpretación de spec aplicable).
- **SPECULATIVE:** 0.
- **Ratio (OBS+INF)/total:** 32/32 = 1.0 ≥ 0.75 ✓

## Hallazgos por categoría

### Categoría 1 — METADATA (frontmatter `.. meta::`)

| # | Hallazgo | Estado actual | Esperado (STD-007 v2.0.2 §6) | Severidad |
|---|----------|---------------|-------------------------------|-----------|
| M-01 | `:dominio:` con underscore | `arquitectura_tecnica` | `arquitectura-tecnica` (kebab) | MAJOR |
| M-02 | `:estado:` no canónico | `Vigente` | `Aprobado` (∈ {Borrador, En Revisión, Aprobado, Deprecado}) | MAJOR |
| M-03 | `:clasificacion:` no canónica | `Critico` | ∈ {Interno, Público, Confidencial} | MAJOR |
| M-04 | `:tipo:` no en lista canónica | `Modelo Arquitectonico` | clarificar (no documentado en §6.1; "Documento de Arquitectura"?) | MINOR |
| M-05 | `:version: 5.2.1` legítimo per SemVer pero alto sin razonar | 5.2.1 | OK per STD-006, pero valor anómalo (otros artefactos están en 1.x) | INFO |

### Categoría 2 — ESTRUCTURA Y SCOPE

| # | Hallazgo | Severidad |
|---|----------|-----------|
| E-01 | **39% del documento es código de implementación** (Django ~26% + SQL DDL ~13%). Mezcla "modelo" con "implementación". | MAJOR |
| E-02 | Sección "11. MIGRACIÓN DESDE v5.2.0" + "ESTÁNDAR DE NOMENCLATURA v5.2.1" en cabecera = **versionado interno duplicado** con metadata YAML. | MINOR |
| E-03 | El documento define **su propio "ESTÁNDAR DE NOMENCLATURA"** (líneas 112-140) — tensión con CNST-033 (Vocabulario Unificado RBAC) que es la fuente autoritativa. | MAJOR |
| E-04 | Sección "12. RESUMEN" + "12.1 Métricas del Modelo v5.2.1" + "12.2 Cambios Clave v5.2.1" = información que pertenece al **historial de versiones** (en metadata o en `:ultimo_cambio:`), no al cuerpo. | MINOR |
| E-05 | Falta sección explícita de **coexistencia ACC ↔ PERM** per ADR-GOB-008 — el modelo solo cubre la vista funcional MOD_Access. | MAJOR |
| E-06 | Falta cross-ref a CNSTs aplicables (CNST-029/030/031/032/033) en cada sección normativa. | MAJOR |

### Categoría 3 — CONTENIDO NORMATIVO

| # | Hallazgo | Severidad |
|---|----------|-----------|
| N-01 | Catálogo de 42 funciones, 10 grupos, 3 SoDs **completo y autoritativo** ✓ | OK |
| N-02 | Distinción system vs custom groups (per D-RBAC-4) **NO está documentada explícitamente** en el modelo. | MAJOR |
| N-03 | Falta documentación de **menú dinámico** (CNST-032 lo exige; el modelo no lo refleja). | MAJOR |
| N-04 | Falta sección sobre **Permisos Excepcionales** (CNST-031 los regula; modelo solo dice "Permisos Temporales" pero no menciona el mecanismo PERM). | MAJOR |
| N-05 | Vocabulario "Función" usado consistentemente ✓ (cumple CNST-033). | OK |
| N-06 | Tabla 10. MAPEO FUNCIONES → CASOS DE USO **solo cubre UC_ACC_***, no UC_PERM_* ni UC_AUD_*. Per ADR-GOB-008 deben coexistir las 3. | MAJOR |

### Categoría 4 — CÓDIGO EMBEBIDO (39% del archivo)

| # | Hallazgo | Severidad |
|---|----------|-----------|
| C-01 | DDL SQL completo (8.1-8.10, líneas 1203-1535) duplica lo que viven en los modelos Django. | MINOR |
| C-02 | Models Django (9.1, líneas 1541-1835) — **295 líneas de código Python**. ¿El doc es spec o source? | MAJOR |
| C-03 | Service / Decorator / Middleware (9.2-9.4, líneas 1836-2186) — código de **implementación** que cambia con cada feature/fix. Mantener sincronía manual entre código real y este doc es insostenible. | CRITICAL |
| C-04 | Datos iniciales SQL (8.8-8.10) duplican el catálogo declarativo de la sección 3-5. **Single source of truth violado.** | MAJOR |
| C-05 | Management Command (9.5) — código operativo, no parte de un modelo. | MINOR |

### Categoría 5 — REFS Y LINKING

| # | Hallazgo | Severidad |
|---|----------|-----------|
| R-01 | 707 menciones de identificadores del catálogo (MOD_*, AGR-*, SOD-*) en otros archivos. **Identificadores son inmutables** — cualquier rename rompe masivo. | INFO (constraint) |
| R-02 | Solo 6 `:doc:` directas + 0 `:ref:` al label `modelo-rbac-iact`. **Refs entrantes manejables** — no hay riesgo de cascading break al reorganizar secciones internas (anchors `:ref:` no se usan). | OK |
| R-03 | El modelo **NO referencia los CNSTs aplicables** (CNST-029/030/031/032/033). Los CNSTs sí lo referencian a él. Falta bidireccionalidad. | MAJOR |
| R-04 | Self-reference legacy en línea 21 (`:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact``) — autorefencia circular. | MINOR |

### Categoría 6 — CUMPLIMIENTO STD-007 v2.0.2

| # | Hallazgo | Severidad |
|---|----------|-----------|
| S-01 | Filename `modelo-rbac-iact.rst` cumple kebab-lowercase ✓. | OK |
| S-02 | NO usa prefijo canónico (`std-`, `arq-`, `mod-`). Es excepción documentada per STD-007 v2.0.2 §5.4 (guías/modelos sin prefijo en directorios temáticos). | OK |
| S-03 | `:tipo: Modelo Arquitectonico` no aparece en lista canónica de §6.1. Falta clarificar valor canónico para "modelos". | MINOR |

## Resumen ejecutivo: ¿qué hacer con el modelo?

### Hallazgos críticos / mayores que requieren intervención

**21 hallazgos identificados:**

- 2 CRITICAL (C-03)
- 10 MAJOR (M-01, M-02, M-03, E-01, E-03, E-05, E-06, N-02, N-03, N-04, N-06, C-02, C-04, R-03)
- 6 MINOR (M-04, E-02, E-04, C-01, C-05, R-04, S-03)
- 3 OK / INFO

### Tres opciones de mejora

| Opción | Scope | Costo | Beneficio |
|--------|-------|-------|-----------|
| **A — Refactor mínimo (lipstick)** | Solo metadata (M-01..M-04) + cross-refs CNSTs (R-03, E-06). Mantener todo el contenido. | Bajo (~30 min) | Bajo — el doc sigue siendo 39% código embebido y no refleja ADR-GOB-008. |
| **B — Refactor estructural (recomendado)** | A + E-05 (coexistencia ACC↔PERM) + N-02/N-03/N-04 (system/custom, menú dinámico, permisos excepcionales) + N-06 (mapeo UC_PERM/UC_AUD) + E-02/E-04 (limpieza de versionado interno) | Medio (4-6h) | Alto — modelo refleja realidad post ADR-GOB-008 + cumple CNSTs vigentes. |
| **C — Refactor radical (split)** | B + C-01..C-05 (extraer SQL/Django a artefactos separados). Modelo queda como **spec conceptual** ~1500 líneas; código viaja a `arq-mod-003-rbac-core.rst` o módulo de implementación dedicado. | Alto (1-2 sesiones) | Crítico — single source of truth, mantenibilidad, alineación con ADR-GOB-008 §"Implementación" punto 5 (WP #7 pendiente que es justamente esta migración). |

### Recomendación

**Opción B** como mínimo para esta iteración — cubre los hallazgos
MAJOR con costo razonable y deja el doc en estado coherente.

**Opción C** sería ideal pero amerita WP independiente con
deep-review por el costo de mover ~1000 líneas de código a otros
artefactos y verificar trazabilidad.

## Próximo paso

Decisión del ejecutor sobre el scope (A / B / C / mix) antes de
avanzar a Phase 5 STRATEGY y Phase 6 PLAN del WP.
