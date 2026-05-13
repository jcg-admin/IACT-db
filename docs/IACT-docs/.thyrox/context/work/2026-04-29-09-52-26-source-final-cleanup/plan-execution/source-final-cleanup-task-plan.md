```yml
created_at: 2026-04-29 09:52:26
project: IACT-docs
work_package: 2026-04-29-09-52-26-source-final-cleanup
phase: Phase 8 — PLAN EXECUTION
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Task Plan — Source Final Cleanup

## Scope

Solucionar TODOS los hallazgos de los 3 audits hasta que
`make clean && make html` -> `build succeeded` con 0 WARN /
0 ERR / 0 CRIT.

## Loop policy

- Ejecutor NO sale del loop hasta que todas las T-NNN esten `[x]`.
- Cada T-NNN sigue micro-ciclo de `mechanical-bulk-edits.md`:
  Diagnose -> Pilot -> Measure -> Apply -> Regression check.
- Build verde es el invariante despues de CADA T-NNN.
- Si una T-NNN introduce regresion, revertir y refinar antes
  de continuar.

## Tasks

### Bloque MD — Markdown Residual (22 archivos, 170 violaciones)

#### MD-HR (Horizontal rules `---` -> `----` transition)

- [ ] **T-001** `MODELO_RBAC_IACT.rst` (8 ocurrencias hr +
      otros patrones; ver T-008+)
- [ ] **T-002** `FND_00_Contexto_y_Jerarquia.rst` (22 ocurrencias hr)
- [ ] **T-003** `git-workflow.rst` (9 ocurrencias hr)
- [ ] **T-004** `UC_PERM_01_Asignar_Grupo_a_Usuario.rst` (1 hr)
- [ ] **T-005** `_metadata/index.rst` (1 hr)
- [ ] **T-006** `backend/conventions.rst` (1 hr — fix mio del WP backend)

#### MD-TABLE (markdown pipes `| a | b |` -> list-table)

- [ ] **T-007** `ADR-DEVOPS-003-wasi-style-virtualization-importante-db.rst` (16 pipes)
- [ ] **T-008** `procedimiento-analisis-seguridad.rst` (12 pipes)
- [ ] **T-009** `procedimiento-trazabilidad-requisitos.rst` (4 pipes)
- [ ] **T-010** `TPL_UC_Temporal_Schedulers.rst` (4 pipes)
- [ ] **T-011** `ADR-FRONT-010-typescript-adopcion-gradual.rst` (4 pipes)
- [ ] **T-012** `PROCED-GOB-003-documentar-regla-negocio.rst` (3 pipes)
- [ ] **T-013** `PROCED-GOB-005-analisis-impacto-cambios.rst` (3 pipes)
- [ ] **T-014** `procedimiento-diseno-tecnico.rst` (2 pipes)
- [ ] **T-015** `ADR-GOB-004-clasificacion-reglas-negocio.rst` (2 pipes)
- [ ] **T-016** `PROCED-QA-001-ejecutar_tests.rst` (1 pipe)

#### MD-OTHER (links, anchors, blockquotes, html, atx)

- [ ] **T-017** `MODELO_RBAC_IACT.rst` — links + anchors + blockquotes
      (caso de estudio del audit)
- [ ] **T-018** `PROCED-GOB-002-actualizar_documentacion.rst` — blockquote + link (4)
- [ ] **T-019** `PROCED-GOB-004-crear-caso-uso.rst` — html_br (15)
- [ ] **T-020** `ADR-GOB-005-especificacion-casos-uso.rst` — html_br (4)
- [ ] **T-021** `TPL_FR_Validacion_Reglas.rst` — blockquote (2)
- [ ] **T-022** `PROCED-DEV-002-code_review.rst` — atx heading (1)
- [ ] **T-023** `TPL_TST_Pruebas.rst` — md link (1)

### Bloque ET — Emojis & Tables

#### Emoji cleanup (script-driven, 78 archivos, ~1266 violaciones efectivas)

- [ ] **T-024** Crear `/tmp/fix_emojis.py` con tabla canonica de
      sustituciones (☐→[ ], ✓→OK, ❌→[NO], ⚠→[ALERTA], 🔴→[CRITICO],
      etc.). Script idempotente.
- [ ] **T-025** PILOT en `gestion/pm/checklists/checklists-pm.rst`
      (133 ocurrencias, archivo mas afectado). Verificar diff,
      build, render visual.
- [ ] **T-026** Apply global excluyendo `STD_001*.rst` (excepcion
      legitima por documentar prohibiciones).
- [ ] **T-027** Verify: emoji audit reporta solo ocurrencias en
      STD_001 (107) y whitelist (flechas, °).

#### Tables outliers (13 tablas grid/simple en 5 archivos)

- [ ] **T-028** Convertir grid tables en
      `FND_04_Trazabilidad.rst` (4 grids).
- [ ] **T-029** Convertir grid en
      `ADR-DEVOPS-003-wasi-style-virtualization-importante-db.rst`
      (2 grids — overlapped con T-007).
- [ ] **T-030** Convertir grid en `ARQ_MOD_002_USER_IDENTITY.rst`
      (1 grid).
- [ ] **T-031** Convertir grid en `TPL_UC_Actor_Secundario.rst`
      (1 grid).
- [ ] **T-032** Convertir simple tables en 4 ADRs FRONT/QA
      (1 cada uno).

### Bloque FN — Finalizacion

- [ ] **T-033** `make clean && make html` — verificar 0/0/0 en
      clean rebuild.
- [ ] **T-034** Re-correr scans (emoji, markdown, tables) para
      confirmar 0 violaciones efectivas.
- [ ] **T-035** Cerrar WP: changelog en `track/`, lessons learned,
      update ROADMAP.md.

## Dependencias / orden

- MD-HR (T-001..T-006) son independientes entre si.
- MD-TABLE (T-007..T-016) son independientes (pero T-007 incluye
  contenido del archivo de T-029, hacer T-007 primero).
- MD-OTHER (T-017..T-023) son independientes.
- E (T-024..T-027) requiere T-024 antes de T-025-T-027.
- T (T-028..T-032) son independientes.
- FN (T-033..T-035) requiere TODAS las anteriores.

**Orden recomendado del loop:**

```
T-024 -> T-001..T-023 (intercalando) -> T-025 -> T-026 -> T-027
-> T-028..T-032 -> T-033 -> T-034 -> T-035
```

Total: 35 tareas atomicas.

## Invariante del loop

Despues de CADA T-NNN:

1. Verificar build verde: `make html` -> 0 issues.
2. Si NO verde: revert el cambio, marcar T-NNN como `[!] BLOCKED`,
   investigar, re-intentar.
3. Si verde: commit con `Refs: T-NNN`, push, marcar T-NNN como `[x]`.
4. Avanzar a la siguiente T-NNN.

## Salida del loop

Solo cuando TODAS las T-NNN esten `[x]` Y `make clean && make html`
reporte `build succeeded` con 0 WARN / 0 ERR / 0 CRIT.

Si quedan tareas `[!]` BLOCKED tras 2 intentos, escalar a humano.
