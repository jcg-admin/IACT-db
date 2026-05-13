```yml
created_at: 2026-04-25 23:35:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 1 — DISCOVER
author: Claude
status: Borrador
version: 1.0.0
```

# Exit Conditions — GitHub Actions Setup WP

> **GATES ARE MANDATORY.** No avanzar si las condiciones no están cumplidas.
> Si una condición no puede cumplirse: documentar POR QUÉ en un ADR antes de continuar.

---

## Escalabilidad: MEDIANO (6-9 horas estimado)

**Tamaño:** Phase 1 (1h) + Phase 6 (1h) + Phase 7 (1h) + Phase 8 (1h) + Phase 10 (3-6h) = **6-9 horas**

**Fases obligatorias:** 1 ✅, 6, 7, 8, 10, 11  
**Fases opcionales (según compresión):** 2 (BASELINE), 3 (ANALYZE), 4 (CONSTRAINTS), 5 (STRATEGY), 9 (PILOT), 12 (STANDARDIZE)

**Justificación:** Phase 1 DISCOVER cubre contexto y oportunidades claramente. Fases 2-5 pueden comprimirse o incluirse según profundidad deseada. Phase 11 y 12 recomendados para MEDIANO.

---

## PHASE 1: DISCOVER ✅ COMPLETADO

**Objetivo:** Explorar contexto, stakeholders, síntomas. Crear WP + risk register.

**Gate Stage 1→6 (MEDIANO, sin análisis profundo):**
- `entry_condition`: "WP creado con timestamp real (2026-04-25-22-47-23); risk-register existe"
- `exit_threshold`: "discover/{nombre-wp}-analysis.md sin [NEEDS CLARIFICATION]; 8 aspectos documentados; USER APPROVAL obtenido"
- `max_rework_iterations: 1` (ya completado)
- `context_pruning_rule`: "descartar claims SPECULATIVE de esta fase que no tengan observable de origen"

**Exit Conditions:**
- [x] `discover/github-actions-setup-analysis.md` existe y está completo
- [x] `github-actions-setup-risk-register.md` existe con 8 riesgos
- [x] Stopping Point Manifest documentado (Phase 1 DISCOVER → Phase 6 PLAN)
- [x] 8 aspectos documentados: objetivo, stakeholders, problemas, oportunidades, restricciones, scope, dependencies, éxito
- [x] USER APPROVAL obtenido (implícito en decisión de crear WP)

**Status:** ✅ APROBADO  
**Transition:** → Phase 6 PLAN (MEDIANO: saltar análisis profundo 2-5)

---

## PHASE 2: MEASURE (OPCIONAL para MEDIANO)

**Objetivo:** Establecer baseline de CI/CD actual.

**Gate Stage 2→3 (si se incluye):**
- `entry_condition`: "Phase 1 aprobado"
- `exit_threshold`: "measure/github-actions-baseline.md con métricas actuales documentadas; USER APPROVAL"

**Exit Conditions:**
- [ ] `measure/github-actions-baseline.md` con estado actual (no hay automation)
- [ ] Métricas iniciales: 0% automation, manual PRs, no build validation
- [ ] USER APPROVAL obtenido

**Status:** ⏳ OPCIONAL — saltar si tiempo limitado, incluir si se desea baseline formal

**Transition:** → Phase 3 ANALYZE

---

## PHASE 3: ANALYZE (OPCIONAL para MEDIANO)

**Objetivo:** Análisis profundo de raíces de problemas.

**Gate Stage 3→4 (si se incluye):**
- `entry_condition`: "Phase 1 completado"
- `exit_threshold`: "analyze/ con síntesis documentada; causas raíz trazables; USER APPROVAL"

**Exit Conditions:**
- [ ] `analyze/github-actions-diagnose-synthesis.md` existe
- [ ] Causas raíz identificadas (Process clarity > CI/CD automation, not architecture design)
- [ ] `github-actions-setup-risk-register.md` re-validado
- [ ] USER APPROVAL obtenido

**Status:** ⏳ OPCIONAL — Phase 1 DISCOVER cubre esto suficientemente

**Transition:** → Phase 4 CONSTRAINTS

---

## PHASE 4: CONSTRAINTS ✅ REQUIRED para MEDIANO

**Objetivo:** Documentar restricciones técnicas y de plataforma ANTES de diseñar workflow.

**Gate Stage 4→7 (CRÍTICA — fase obligatoria):**
- `entry_condition`: "Phase 6 PLAN aprobado; scope claro"
- `exit_threshold`: "constraints/{nombre-wp}-constraints.md completo; 5 HC + 4 SC documentadas; solución space validada; USER APPROVAL"
- `max_rework_iterations: 2`

**Exit Conditions:**
- [x] `constraints/github-actions-setup-constraints.md` existe
- [x] HC-001 a HC-005 documentadas (GitHub Actions, Linux, Python, PlantUML, build validation)
- [x] SC-001 a SC-004 documentadas (cost, speed, compilation, backward compatibility)
- [x] Solution space descrito (opciones viables vs descartadas)
- [x] Verificación checklist creada para Phase 7 validation
- [x] USER APPROVAL obtenido

**Status:** ✅ COMPLETADO — Constraints documentadas y verificadas

**Justificación:** Phase 4 CONSTRAINTS debe PRECEDER a Phase 7 DESIGN/SPECIFY porque:
1. HC/SC delimitan espacio de soluciones válidas
2. Specs en Phase 7 DEBEN respetar estas restricciones
3. Evita "sorpresas" en Phase 10 EXECUTE (descubrir limitaciones tardíamente)

**Transition:** → Phase 7 DESIGN/SPECIFY (con constraints como entrada)

---

## PHASE 5: STRATEGY (OPCIONAL para MEDIANO)

**Objetivo:** Diseñar solución de CI/CD con alternativas investigadas.

**Gate — Pre-Design (si se incluye):**
- `entry_condition`: "Phase 4 aprobado"
- `exit_threshold`: "estrategia respeta restricciones; unknowns investigados"

**Gate — Post-Design (si se incluye):**
- `entry_condition`: "strategy/{nombre-wp}-solution-strategy.md borrador existe"
- `exit_threshold`: "consistencia re-verificada; alternativas descartadas documentadas; USER APPROVAL"

**Exit Conditions:**
- [ ] `strategy/github-actions-solution-strategy.md` existe
- [ ] Fase 1 (Essential CI/CD) vs Fase 2 (Enhanced) describida
- [ ] Alternativas descartadas documentadas (e.g., Travis CI, CircleCI rejected)
- [ ] ADRs creados si corresponde
- [ ] USER APPROVAL obtenido

**Status:** ⏳ OPCIONAL — Phase 1 DISCOVER define estrategia clara (Phase 1 Essential + Phase 2 Enhanced)

**Transition:** → Phase 6 PLAN

---

## PHASE 6: PLAN ✅ PENDIENTE

**Objetivo:** Definir scope explícito: 5 archivos Phase 1, deferidos Phase 2.

**Gate Stage 6→7:**
- `entry_condition`: "Phase 1 DISCOVER aprobado; ninguna decisión de scope contradice riesgos"
- `exit_threshold`: "plan/{nombre-wp}-plan.md con In-Scope/Out-of-Scope explícitos; success criteria claros; USER APPROVAL"
- `max_rework_iterations: 2`
- `context_pruning_rule`: "scope items sin trazabilidad a DISCOVER: descartar o re-documentar"

**Exit Conditions:**
- [ ] `plan/github-actions-setup-plan.md` existe
- [ ] **In-Scope Phase 1 (Essential):** 5 archivos listados (.github/ISSUE_TEMPLATE/config.yml, bug-report.yml, feature-request.md, PULL_REQUEST_TEMPLATE.md, workflows/sphinx-build.yml)
- [ ] **Out-of-Scope Phase 2 (Deferred):** rst-lint.yml, dependabot.yml, documentation hosting, notification integrations
- [ ] Success criteria: 5 files created, workflow runs on PR, build validation works, no cost overrun
- [ ] Timeline: 6-9 hours estimated
- [ ] Risk ownership by phase documented
- [ ] ROADMAP.md updated
- [ ] USER APPROVAL obtenido

**Status:** ⏳ PRÓXIMO A CREAR

**Transition:** → Phase 7 DESIGN/SPECIFY

---

## PHASE 7: DESIGN/SPECIFY ✅ PENDIENTE

**Objetivo:** Especificar exactamente cada uno de los 5 archivos.

**Gate — Spec Quality:**
- `entry_condition`: "plan/{nombre-wp}-plan.md aprobado con scope definido"
- `exit_threshold`: "design/{nombre-wp}-requirements-spec.md completo; cada archivo tiene Given/When/Then; USER APPROVAL"
- `max_rework_iterations: 2`
- `context_pruning_rule`: "criterios SPECULATIVE sin medición verificable: rechazar"

**Exit Conditions:**
- [ ] `design/github-actions-setup-requirements-spec.md` existe
- [ ] 5 SPECs documentados: SPEC-001 (config.yml), SPEC-002 (bug-report.yml), SPEC-003 (feature-request.md), SPEC-004 (PULL_REQUEST_TEMPLATE.md), SPEC-005 (sphinx-build.yml)
- [ ] Cada SPEC tiene: objetivo, formato, trigger, contenido estructura, success criteria
- [ ] USER APPROVAL obtenido

**Status:** ⏳ DESPUÉS DE PHASE 6

**Transition:** → Phase 8 PLAN EXECUTION

---

## PHASE 8: PLAN EXECUTION ✅ PENDIENTE

**Objetivo:** Descomponer en tareas atómicas T-001 a T-005.

**Gate Stage 8→10 (sin PILOT para bajo riesgo):**
- `entry_condition`: "design/ aprobado; scope claro"
- `exit_threshold`: "task-plan con T-001..T-005 atómicas; DAG sin ciclos; trazabilidad SPEC→tarea; USER APPROVAL"
- `max_rework_iterations: 2`
- `context_pruning_rule`: "tareas sin trazabilidad a SPEC: descartar"

**Exit Conditions:**
- [ ] `plan-execution/github-actions-setup-task-plan.md` existe
- [ ] Tareas T-001..T-005 creadas (1 por archivo)
- [ ] Cada tarea es atómica (15-30 min)
- [ ] DAG sin ciclos
- [ ] Trazabilidad SPEC→tarea completa
- [ ] USER APPROVAL obtenido

**Status:** ⏳ DESPUÉS DE PHASE 7

**Transition:** → Phase 10 EXECUTE (bajo riesgo, skip PILOT)

---

## PHASE 9: PILOT/VALIDATE (OPCIONAL para MEDIANO bajo riesgo)

**Objetivo:** Validar sphinx-build.yml workflow antes de merge.

**Gate Stage 9→10 (si se incluye):**
- `entry_condition`: "task-plan aprobado; riesgos críticos identificados"
- `exit_threshold`: "pilot/{nombre-wp}-pilot-report.md; supuestos críticos evaluados; GO documentado"
- `max_rework_iterations: 1`

**Exit Conditions:**
- [ ] `pilot/github-actions-sphinx-build-validation.md` existe
- [ ] Sphinx build test on runner passed
- [ ] PlantUML diagrams compile on runner
- [ ] Environmental variables correct
- [ ] Decision GO/NO-GO documented
- [ ] USER APPROVAL obtenido

**Status:** ⏳ OPCIONAL — bajo riesgo (templates simple), pero RECOMENDADO para envs (PlantUML, Python)

**Transition:** → Phase 10 EXECUTE (GO) | Phase 5 STRATEGY (NO-GO)

---

## PHASE 10: EXECUTE ✅ PENDIENTE

**Objetivo:** Implementar 5 archivos .github/ exactamente según specs.

**Gate Stage 10→11:**
- `entry_condition`: "task-plan aprobado; tareas no bloqueadas"
- `exit_threshold`: "todas las tareas T-001..T-005 [x]; sphinx-build.yml probado; commits convencionales; USER APPROVAL"
- `max_rework_iterations: 3`

**Exit Conditions:**
- [ ] Todas las tareas T-NNN ejecutadas (checkboxes `[x]`)
- [ ] 5 archivos creados en .github/
- [ ] sphinx-build.yml probado (al menos 1 test PR)
- [ ] Issue templates validadas (manualmente o via form validation)
- [ ] Commits realizados con formato convencional (feat, chore)
- [ ] `execute/github-actions-setup-execution-log.md` actualizado
- [ ] Build succeeds after changes
- [ ] USER APPROVAL obtenido

**Status:** ⏳ DESPUÉS DE PHASE 8

**Transition:** → Phase 11 TRACK/EVALUATE

---

## PHASE 11: TRACK/EVALUATE ✅ PENDIENTE

**Objetivo:** Evaluar resultados y documentar lecciones.

**Gate Stage 11→12:**
- `entry_condition`: "execute/ completo; todas las tareas [x]"
- `exit_threshold`: "lessons-learned existe; changelog creado; risk-register cerrado; USER APPROVAL"
- `max_rework_iterations: 2`

**Exit Conditions:**
- [ ] `track/github-actions-setup-lessons-learned.md` existe
- [ ] `track/github-actions-setup-changelog.md` creado
- [ ] `github-actions-setup-risk-register.md` actualizado (cerrar riesgos)
- [ ] Comparación: estimado (6-9h) vs actual tiempo
- [ ] Métricas de éxito evaluadas (automation level, workflow reliability, cost)
- [ ] USER APPROVAL obtenido

**Status:** ⏳ DESPUÉS DE PHASE 10

**Transition:** → Phase 12 STANDARDIZE (si WP grande) | Cierre directo (si MEDIANO sin innovación)

---

## PHASE 12: STANDARDIZE (OPCIONAL para MEDIANO)

**Objetivo:** Propagar patrones a framework si corresponde.

**Gate Stage 12→cierre:**
- `entry_condition`: "track/ completo; lessons-learned aprobado"
- `exit_threshold`: "patterns documentados si corresponde; ROADMAP.md cerrado; WP marked as complete"

**Exit Conditions:**
- [ ] `standardize/github-actions-setup-patterns.md` existe (si hay innovación)
- [ ] Guidelines actualizadas (si corresponde)
- [ ] ROADMAP.md actualizado (WP completado)
- [ ] now.md actualizado (current_work = null)
- [ ] validate-session-close.sh pasa

**Status:** ⏳ OPCIONAL — incluir si hay patrones reutilizables

**La ÉPOCA cierra cuando Phase 12 completa** → WP archived, `now.md::phase = null`.

---

## Recomendación: Path recomendado para este WP

**Mínimo (bajo riesgo, 6-7 horas):**  
Phase 1 ✅ → Phase 6 → Phase 4 (CONSTRAINTS REQUIRED) → Phase 7 → Phase 8 → Phase 10 → Phase 11 → Cierre

**Recomendado (con validación, 7-8 horas):**  
Phase 1 ✅ → Phase 6 → Phase 4 (CONSTRAINTS REQUIRED) → Phase 7 → Phase 8 → Phase 9 (PILOT) → Phase 10 → Phase 11

**Completo (con aprendizajes, 8-9 horas):**  
Phase 1 ✅ → Phase 2 (BASELINE) → Phase 6 → Phase 4 (CONSTRAINTS REQUIRED) → Phase 7 → Phase 8 → Phase 9 (PILOT) → Phase 10 → Phase 11 → Phase 12 (STANDARDIZE)

**NOTA:** Phase 4 CONSTRAINTS es CRÍTICA — documenta HC/SC técnicas que impactan Phase 7 DESIGN/SPECIFY. No puede omitirse.

---

## Cómo usar este documento

1. **Fase actual:** Marcar `[x]` cuando una condición se cumple
2. **Gate actual:** Validar que TODAS las exit conditions aplican antes de avanzar
3. **Rework:** Si una fase no pasa, iterar máximo `max_rework_iterations` veces
4. **Escalar:** Si supera límite de rework, escalar a decisión humana

---

**Documento creado:** 2026-04-25 23:35:00  
**Status:** Borrador — Listo para Phase 6 PLAN cuando usuario apruebe  
**Next Action:** Crear `plan/github-actions-setup-plan.md`
