```yml
created_at: 2026-04-29 14:56:40
project: IACT-docs
work_package: 2026-04-29-14-56-40-std007-rename-cleanup
phase: Phase 8 — PLAN EXECUTION
author: NestorMonroy
status: Listo para ejecucion
version: 1.0.0
```

# STD_007 Rename — Task Plan

## Strategy

1. **PILOT en 1 archivo** (lección aprendida `mechanical-bulk-edits.md`).
2. **`git mv` puro** (sin tocar contenido) para preservar
   `git log --follow`.
3. **Build verify** después de cada batch.
4. **Update toctrees + refs** en mismo commit que el rename
   para mantener build verde.
5. **Categoría 1 (STDs sin número) requiere decisión humana**
   antes de ejecutar.

## Bloque DEC — Decisión sobre STD ambiguos

- [ ] **T-001** Inspeccionar contenido de
      `STD_Naming_Identificadores.rst` y verificar overlap
      con `STD_002_Nomenclatura_Proyecto.rst` y
      `STD_007_Convencion_Naming.rst`. Decidir: ¿consolidar
      en STD_007 + remove? ¿asignar STD_008?
- [ ] **T-002** Inspeccionar `STD_Profesional_Documentacion.rst`
      para confirmar standalone. Asignar `STD_009_*`.

## Bloque PILOT — 1 archivo (validación protocolo)

- [ ] **T-003** PILOT: renombrar
      `PROCED-DEV-002-code_review.rst` →
      `PROCED-DEV-002-code-review.rst` con `git mv`.
      Buscar refs en todo el corpus, actualizar.
      Build verify 0/0/0.

## Bloque CAT2 — PROCED/PROC/RNF (14 archivos restantes tras PILOT)

- [ ] **T-004** Renombrar 2 RNF (RNF-PROC-001, RNF-PROC-002)
      con descripción a kebab+lowercase.
- [ ] **T-005** Renombrar 5 PROC-* (DEV, DEVOPS, GOB, QA × 2,
      excluyendo el ya pilot).
- [ ] **T-006** Renombrar 7 PROCED-* (DEV × 2, DEVOPS, GOB × 2,
      QA, excluyendo el ya pilot).
- [ ] **T-007** Build verify 0/0/0 + grep refs orphan.

## Bloque CAT3 — Guías snake → kebab (6 archivos)

- [ ] **T-008** Renombrar `plantilla_adr.rst` →
      `plantilla-adr.rst` + actualizar refs.
- [ ] **T-009** Renombrar `deployment_plan.rst` →
      `deployment-plan.rst` + actualizar refs.
- [ ] **T-010** Renombrar 4 checklists con `_` → `-`:
      `checklist_trazabilidad_requisitos.rst`,
      `checklist_desarrollo.rst`,
      `checklist_testing.rst`,
      `checklist_cambios_documentales.rst`.
      Actualizar `gestion/pm/checklists/index.rst`.
- [ ] **T-011** Build verify.

## Bloque CAT1 — STDs (decisión-driven)

- [ ] **T-012** Aplicar decisión T-001 (consolidar o renombrar
      STD_Naming).
- [ ] **T-013** Aplicar decisión T-002 (asignar STD_009 o
      similar a STD_Profesional).

## Bloque FN — Cierre

- [ ] **T-014** `make clean-fast && make html` con
      `SPHINX_NITPICKY=1` → 0/0/0.
- [ ] **T-015** Re-run audit STD_007 → 0 irregulares.
- [ ] **T-016** Changelog del WP en `track/`.
- [ ] **T-017** Commit Tim Pope + push.
- [ ] **T-018** Update `now.md` + `focus.md` + ROADMAP.md.

## Total

18 tasks atómicas. Ganancia esperada: corpus 100% conforme a
STD_007 §4.x patterns por categoría.

## Loop policy

- Build verde 0/0/0 invariante después de cada T-NNN.
- Ejecutor aprueba antes de empezar (cambios estructurales).
- T-001 + T-002 (decisiones STD) requieren input humano si
  el contenido sugiere consolidación.
