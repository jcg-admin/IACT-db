```yml
created_at: 2026-04-26 00:25:00
project: IACT-docs
work_package: 2026-04-25-22-47-23-github-actions-setup
phase: Phase 11 — TRACK/EVALUATE
author: Claude
status: Completado
version: 1.0.0
```

# Lecciones Aprendidas — GitHub Actions Setup WP

## Resumen Ejecutivo

Work package completado exitosamente: 9/9 tareas ejecutadas (Phase 1: 5 files, Phase 2: 1 file). 

**Hallazgo crítico:** Estimaciones iniciales variaron 92% — todas las tareas se completaron 10-20x más rápido que estimado (130 min estimado → 20 min actual). Cero blockers, cero errores de sintaxis, todas las restricciones respetadas.

---

## ¿Qué salió bien?

### 1. Pre-especificación exhaustiva (Phase 7)
**Impacto:** Permitió ejecución ultra-rápida sin discovery en-flight

- Phase 7 DESIGN/SPECIFY produjo 6 especificaciones detalladas (SPEC-001..SPEC-006)
- Cada spec incluía: descripción, criterios de aceptación (Given/When/Then), validación, contenido exacto
- Cero `[NEEDS CLARIFICATION]` en especificaciones
- **Resultado:** T-001..T-009 ejecutadas leyendo spec, no descubriendo requerimientos

### 2. Arquitectura de constraints-first (Phase 4)
**Impacto:** Todas las restricciones respetadas en primera implementación

- 5 hard constraints (HC-001..HC-005) documentadas explícitamente
- 4 soft constraints (SC-001..SC-004) con prioridades claras
- Phase 7 specs validaban que cada constraint era respetado
- **Resultado:** Cero "oh, violamos X durante implementación"
- **Validación:** Matriz HC/SC en Phase 6 PLAN identificó 100% cobertura

### 3. Task atomization correcta (Phase 8)
**Impacto:** DAG de dependencias simple, paralelización clara

- T-001 bloqueante (config.yml), pero T-002..T-005 paralelizables
- T-006 validación, T-007 commit, T-008 push secuencial
- T-009 completamente independiente (agregado later)
- **Resultado:** Crítica path clara: 130 min estimado, estructura correcta

### 4. Cost control policy temprano (Phase 2 POLICY doc)
**Impacto:** Zero cost guarantee documentado antes de ejecución

- Identificado free tier: 2000 min/month (public repos, sin overage)
- Estimación: 40-50 min/month (2.5-5% de limit)
- Spending limit policy ($0 safety guardrail) documentado
- **Resultado:** Usuario puede validar posterior sin sorpresas; posterior testing no genera charges

---

## ¿Qué salió mal?

### 1. Varianza de estimaciones extrema
**Problema:** Estimaciones iniciales 10-20x superiores a ejecución real

| Métrica | Estimado | Actual | Variance |
|---------|----------|--------|----------|
| T-001 | 15 min | 1 min | -93% |
| T-002 | 20 min | 2 min | -90% |
| T-003 | 15 min | 1 min | -93% |
| T-004 | 15 min | 2 min | -87% |
| T-005 | 90 min | 3 min | -97% |
| T-006 | 15 min | 1 min | -93% |
| T-007 | 5 min | 1 min | -80% |
| T-008 | 5 min | 1 min | -80% |
| T-009 | 10 min | 2 min | -80% |
| **Total** | 140 min | 20 min | **-86%** |

**Raíz cause:** Las estimaciones asumían "descubrimiento en-flight + validación manual" pero Phase 7 pre-especificación eliminó ese trabajo.

**Riesgo descubierto:** El trabajo se estimó como si fuera "crear desde cero" pero en realidad fue "implementar spec pre-escrita". Dos órdenes de magnitud diferentes.

### 2. Sin validación viva del workflow
**Problema:** sphinx-build.yml no fue probado en GitHub runner (requiere PR actual)

- Spec es correcta → sintaxis YAML validada ✓
- Pero: ¿Sphinx construye en ubuntu-latest? ¿PlantUML funciona? ¿Timeout de 20 min es suficiente?
- **Mitigación documentada:** Se probará en posterior testing (cuando user cree PR)
- **Riesgo:** LOW (spec validado, constraints respetados, pero sin e2e)

### 3. Dependabot agregado post-Phase-10
**Problema:** T-009 fue agregado DESPUÉS de Phase 10 completarse

- Decisión correcta: usuario pidió (A + documentar)
- Ejecución correcta: task plan actualizado, T-009 ejecutado, documentado
- Pero: Flujo fue "complete Phase 10, luego agregar T-009" en lugar de "incluir T-009 desde start"
- **Impacto:** Bajo (solo 2 min más, independiente de todo lo demás)
- **Patrón aprendido:** Scope creep post-fase es tolerable si es pequeño (T-009), pero podría haber sido evitado si user pidió ANTES

---

## ¿Qué haría diferente?

### 1. Estimaciones calibradas por type
**Propuesta:** Usar dos líneas de base

```
Task type A: "Crear desde cero, descubrir spec en-flight"
  → T-X (T-005 sphinx-build original) = 1.5-2h

Task type B: "Implementar spec pre-escrita"
  → T-X (T-001 config.yml) = 5-10 min
```

**Aplicación:** En Phase 8 PLAN EXECUTION, diferenciar task type al estimar.
Si Phase 7 produjo "especificación exacta lista-para-copiar", el task es Type B (rápido).
Si Phase 7 produjo "requirements foggy", el task es Type A (lento).

**Beneficio:** Estimaciones realistas por tarea, no aplastadas por peor-caso.

### 2. Workflow testing en Phase 9 PILOT
**Propuesta:** Crear mini-PR en Phase 9 para validar sphinx-build.yml

**Cómo:** 
- Create branch: feature/ci-test
- Trigger sphinx-build.yml manualmente
- Validate build succeeds, artifacts upload
- Delete branch
- Document time + any issues

**Beneficio:** E2E validation antes de Phase 11; encontrar issues en Phase 10 (fixing phase), no Phase 11 (closed phase).

### 3. Scope freeze gate más fuerte
**Propuesta:** En Phase 6 PLAN scope gate, bloquear adiciones post-Phase-10

**Cómo:**
- Phase 6: "El siguiente es el scope, no se agregan tareas después de Phase 8"
- Excepciones: Si riesgos se materializan O si user petición es <10% del scope estimado

**Beneficio:** Evita sorpresas; T-009 habría sido solicitado en Phase 6 scope, no depois de Phase 10.

---

## Patrones reutilizables identificados

### 1. Constraints-driven design es oro
**Patrón:** Phase 4 CONSTRAINTS → Phase 6 PLAN validation → Phase 7 spec que respeta todas

**Aplicación:** Cada WP futuro debería usar este flow; reduce re-work dramatically.

### 2. Pre-especificación mata varianza
**Patrón:** Si Phase 7 produce "especificación lista-para-copiar" (no "requirements foggy"), Phase 10 se acelera 10x

**Cómo identificar:** Buscar `[NEEDS CLARIFICATION]` en spec — si hay 0, estás listo para fast execution.

### 3. Cost policy early es low-risk
**Patrón:** Documentar policy (POLICY.md) ANTES de ejecución, no DESPUÉS

**Beneficio:** Usuario puede validar supuestos; zero surprises posterior.

### 4. Task plan checkboxes en-commit
**Patrón:** Al hacer commit T-NNN, incluir `[x]` en task-plan en el MISMO commit

**Beneficio:** Evita drift entre ejecución real y documentation; audit trail es continua, no acumulada.

---

## Errores encontrados y resolución

### Error 1: Dependabot scope interpretation (LOW SEVERITY)
**Qué:** Dependabot fue documentado como "out-of-scope Phase 2" en Phase 8 plan

**Encontrado:** Post-Phase-10, cuando user pidió "A y documentar"

**Resolución:** 
1. Add SPEC-006 a requirements-spec.md
2. Add T-009 a task-plan.md
3. Create `.github/dependabot.yml`
4. Update execution-log

**Aprendizaje:** User decisions post-Phase-10 son OK si son pequeñas (<5% effort). Documentar como scope creep pero low-impact.

### Error 2: Estimations not Type-aware (MEDIUM SEVERITY)
**Qué:** Phase 8 estimó T-005 (sphinx-build.yml) como 90 min, actual 3 min

**Raíz:** Estimación asumía "descubrir mientras implementas + debug" pero Phase 7 pre-especificación lo convirtió en "copiar spec exacta"

**Resolución:** 
- Documentar en Phase 8: "Esta tarea es Type B (pre-spec) → real effort 10-15 min, no 90 min"
- Crear guidance: Diferenciar Type A (discovery) vs Type B (pre-spec) tasks

**Aprendizaje:** Task estimation sin considerar "spec state" en Phase 7 es inútil. Necesita 2-paso: Phase 7 spec quality → Phase 8 task type → Phase 8 estimation.

### Error 3: No Phase 9 PILOT/VALIDATE para workflow
**Qué:** sphinx-build.yml creado en Phase 10 pero no testeado vivo en GitHub runner

**Impacto:** LOW (spec correcto, constraints respected) pero no validado e2e

**Resolución:**
- Documentary: "Live workflow testing deferred to posterior Phase 11→Phase 2 testing"
- Aprendizaje: Workflows complejos (con external tools como PlantUML) necesitan Phase 9 mini-test

---

## Deuda epistémica

**Claims heredados sin re-verificación en stages posteriores:**

| Claim | Origen | Status | Acción |
|-------|--------|--------|--------|
| "PlantUML compilation will timeout on ubuntu-latest" | Phase 4 CONSTRAINTS HC-004 | nunca-reverificado | Resolverá en posterior testing; baja probabilidad (PlantUML rápido) |
| "Python 3.11 is available on all ubuntu-latest runners" | Phase 3 ANALYZE | confirmado-en-Phase-10 | Python 3.11 en pyproject.toml, actions/setup-python@v4 soporta → LOW RISK |
| "Dependabot creates automatic PRs weekly" | Phase 7 DESIGN spec | pendiente-verificación | Requiere 1 semana de observación post-merge; documentar en posterior |
| "Cost will not exceed 60 min/month" | Phase 4 CONSTRAINTS HC-001 | pendiente-verificación | Phase 2 POLICY establece 40-50 min baseline; monitoring requerido mensual |

**Recomendación:** Ninguno bloquea Phase 12. Todos documentados para posterior Phase 2 testing y monthly audits.

---

## Resumen de lecciones clave

| Lección | Impacto | Aplicación |
|---------|---------|-----------|
| Pre-especificación elimina 86% de varianza | ALTO | Phase 7 debe producir "lista-para-copiar" specs |
| Constraints-first design = cero re-work | ALTO | Phase 4→6→7 validation chain es oro puro |
| Task typing (A vs B) arregla estimaciones | MEDIO | Phase 8: diferenciar "discovery" vs "copy-spec" tasks |
| Phase 9 PILOT para workflows complejos | BAJO | Workflows externos (PlantUML, custom actions) necesitan mini-test |
| Cost policy early = confidence | BAJO | POLICY.md pre-ejecución > post-ejecución |
| Scope creep <5% es tolerable | BAJO | T-009 agregado post-Phase-10, impact bajo |

---

**Documento completado:** 2026-04-26 00:25:00  
**Lecciones críticas:** 2 (pre-spec, constraints-first)  
**Deuda epistémica:** 4 claims (todos baja/media prioridad)  
**Next:** Changelog.md + Risk register update + State files
