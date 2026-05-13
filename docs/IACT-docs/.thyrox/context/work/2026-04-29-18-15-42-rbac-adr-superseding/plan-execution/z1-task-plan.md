```yml
created_at: 2026-04-29 23:10:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 8 — PLAN EXECUTION
author: NestorMonroy
status: Listo para ejecucion
version: 1.0.0
```

# Z.1 — Task Plan

## Strategy

1. **PILOT en T-001** (1 archivo histórico) antes del bulk (T-002..T-008).
2. **Build verify** después de cada bloque.
3. **Bloque C depende de Bloque A** (los ADRs nuevos referencian
   los históricos importados).
4. **Bloque D depende de Bloque C** (Superseded markers necesitan
   los ADRs nuevos como targets).
5. Commits Tim Pope granulares por sub-tarea.

## Bloque A — Historical imports (PILOT + bulk)

- [ ] **T-001** PILOT: convertir
      `temp-holding/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md`
      (14 KB) → `source/gestion/evidencia/rbac-historia/analisis-errores-modelo-rbac-v5-2-0.rst`
      con frontmatter Schema A + nota histórica + cross-refs a
      CNST-033 + modelo vigente. Verify build.

- [ ] **T-002** Importar `Modelo RBAC Sin Pretensiones v4.0.txt`
      (99 KB) como **resumen narrativo** (~150 líneas) →
      `modelo-rbac-v4-0-roles-jerarquicos-deprecado.rst`.
      Enumera 18 roles R001..R018 + razón de deprecación.

- [ ] **T-003** Importar `ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md`
      § PARTE 3 (extracto) → `decisiones-modulos-8-vs-9-historico.rst`.
      Foco: debate y resolución 8 módulos.

- [ ] **T-004** Importar `GAP_ANALYSIS_SISTEMA_PERMISOS.md` →
      `gap-analysis-sistema-permisos-nov-2025.rst`. Conserva el
      "75% completado" y la enumeración de gaps.

- [ ] **T-005** Importar `DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md`
      → `discrepancia-rbac-correccion-ene-2026.rst`. Documenta
      cuándo se detectó el problema de roles tradicionales en BR.

- [ ] **T-006** Importar `CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md`
      → `capacidades-vs-permisos-comparativo.rst`. **Origen
      conceptual de D-RBAC-1.**

- [ ] **T-007** Importar `ANALISIS_COMPARATIVO_RBAC_v4_vs_BR_IACT.md`
      → `analisis-comparativo-rbac-v4-vs-br-iact.rst`. Genealogía
      v4 → v5.

- [ ] **T-008** Crear narrativa RST sobre `temp-holding/Modules/*.py`
      (12 archivos Python) → `diseno-referencia-implementacion-permisos-legacy.rst`.
      Lista archivos + estructura + mapping vocabulario legacy
      (`Capacidad`) → vigente (`Función`).

- [ ] **T-009** Crear `source/gestion/evidencia/rbac-historia/index.rst`
      con toctree de los 8 archivos + nota visible "documentos
      históricos / referencia para trazabilidad".

- [ ] **T-010** Update `source/gestion/evidencia/index.rst` para
      incluir `rbac-historia/index` en su toctree.

- [ ] **T-011** Build verify (`SPHINX_NITPICKY=1 make html`).
      Esperado 0/0/0.

- [ ] **T-012** Commit Tim Pope del Bloque A + push.

## Bloque B — ADR-BACK-005 middleware legacy import

- [ ] **T-013** Convertir `temp-holding/FASE 01/docs/backend/gobernanza/adr/ADR-BACK-005-middleware-decoradores-permisos.md`
      → `source/backend/adr-back-005-middleware-decoradores-permisos.rst`
      con frontmatter Schema A. `:estado: Vigente (legacy preservado)`.
      Nota visible: "ADR aceptado en 2025-11-18, importado al corpus
      en 2026-04-29 como referencia técnica preservada. Aplica a
      la implementación de middleware/decoradores cuando se
      materialice."

- [ ] **T-014** Update `source/backend/index.rst` toctree para
      incluir adr-back-005.

- [ ] **T-015** Build verify + commit Tim Pope del Bloque B + push.

## Bloque C — ADRs nuevos (gob-009 + back-006)

- [ ] **T-016** Crear `source/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual.rst`:
      - Supersede ADR-BACK-001 + ADR-BACK-004.
      - Cifras canónicas: 42 funciones / 10 grupos AGR / 3 SoD.
      - Vocabulario "Función" (CNST-033).
      - Cross-refs: modelo, CNST-029..033, ADR-GOB-008, 8 históricos.
      - Sección "Diferido: DEBT-RBAC-RACI" referenciando deuda técnica.

- [ ] **T-017** Crear `source/backend/adr-back-006-rbac-estrategia-implementacion.rst`:
      - Supersede ADR-BACK-003.
      - Estrategia híbrida ORM+SQL preservada.
      - Sección "Single source of truth for enforcement"
        (resuelve nota in-text de BACK-003).
      - Vocabulario `usuario_tiene_funcion()` (alineado CNST-033).
      - Cross-refs: adr-gob-009, CNST-032, modelo,
        diseno-referencia-implementacion-permisos-legacy.

- [ ] **T-018** Update `source/normativa/gobernanza/index.rst`
      toctree para incluir adr-gob-009.

- [ ] **T-019** Update `source/backend/index.rst` toctree para
      incluir adr-back-006.

- [ ] **T-020** Build verify + commit Tim Pope del Bloque C + push.

## Bloque D — Mark BACK-001/003/004 as Superseded

- [ ] **T-021** Editar `source/backend/adr-back-001-grupos-funcionales-sin-jerarquia.rst`:
      - `:estado: Superseded`
      - Agregar sección final "Superseded by" → `:doc:` apuntando
        a `adr-gob-009-rbac-modelo-conceptual`.
      - Preservar contenido legacy intacto.

- [ ] **T-022** Editar `source/backend/adr-back-003-orm-sql-hybrid-permissions.rst`:
      - `:estado: Superseded`
      - Sección "Superseded by" → `adr-back-006`.

- [ ] **T-023** Editar `source/backend/adr-back-004-sistema-permisos-sin-roles-jerarquicos.rst`:
      - `:estado: Superseded`
      - Sección "Superseded by" → `adr-gob-009`.

- [ ] **T-024** Build verify + commit Tim Pope del Bloque D + push.

## Bloque E — DEBT + cross-refs + verify + changelog

- [ ] **T-025** Agregar `DEBT-RBAC-RACI` a
      `source/risks-technical-debt/deuda-tecnica-rebuild.rst`:
      "Matriz RACI sobre las 42 funciones del catálogo RBAC.
      Origen: nota in-text de ADR-BACK-004 (legacy). Útil para
      gobernanza/auditoría/onboarding. Out-of-scope de Z.1; abrir
      WP propio cuando se priorice."

- [ ] **T-026** Auditar cross-refs bidireccionales:
      - modelo-rbac-iact.rst → ¿referencia a los 8 históricos? Add
        seealso si no.
      - CNST-033 → ¿referencia a `capacidades-vs-permisos-comparativo`?
      - ADR-GOB-008 → mantener su ref existente, agregar refs a
        adr-gob-009 (que lo alinea).

- [ ] **T-027** Cold rebuild final con SPHINX_NITPICKY=1. 0/0/0.

- [ ] **T-028** Re-audit adversarial Z.1: verificar que las 3
      inconsistencias originales (Inc-01/02/03) están resueltas.

- [ ] **T-029** Escribir `track/z1-changelog.md` con métricas,
      lessons learned, commits.

- [ ] **T-030** Update `wp-state.md` Z.1 → status Cerrado.

- [ ] **T-031** Update `now.md` con cierre Z.1, próximo Z.2.

- [ ] **T-032** Commit final Z.1 + push. Validar
      `bash .claude/scripts/validate-phase-completion.sh`.

## Total

32 tareas atómicas en 5 bloques.

## Loop policy

- Build verde 0/0/0 invariante al cierre de cada bloque (T-011,
  T-015, T-020, T-024, T-027).
- Commits Tim Pope granulares (1 commit por bloque al final, o
  más finos si conviene).
- Si T-001 PILOT detecta problemas con conversión MD→RST,
  detenerse y reportar; no proceder con T-002..T-008.

## Trazabilidad SPEC → tarea

| Decisión spec | Tarea(s) que la materializan |
|---------------|------------------------------|
| D-01 Principio source/ autocontenido | T-001 a T-014 (todo el import histórico) |
| D-02 Opción D — gestion/evidencia/rbac-historia | T-001..T-010 |
| D-03 8 archivos históricos | T-001..T-009 |
| D-04 adr-back-005 → adr-back-006 | T-017 |
| D-05 ADR-BACK-005 import | T-013, T-014 |
| D-06 A.3 (ADRs en su dominio) | (cubierto en Z.1.A — corpus ya reorganizado) |
| Note 1 (BACK-003) "validar estrategia" | T-017 (sección Single source of truth) |
| Note 2 (BACK-004) "matriz RACI" | T-016 (diferido) + T-025 (DEBT entry) |

## Estimación final

~6-8h distribuidas en 5 bloques. 32 tareas T-NNN.
