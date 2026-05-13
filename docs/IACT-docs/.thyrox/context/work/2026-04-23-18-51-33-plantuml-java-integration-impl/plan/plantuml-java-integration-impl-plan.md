```yml
created_at: 2026-04-25 10:10:00
wp: plantuml-java-integration-impl
phase: Phase 6 — SCOPE
status: Aprobado — 2026-04-25 10:15:00
```

# Plan — PlantUML Integration Phase 1 Setup (Centralized Styling & Test Suite)

## Scope Statement

**Problema:** IACT-docs carece de un sistema centralizado para gestionar estilos PlantUML, causando inconsistencia visual en diagramas y alto esfuerzo de mantenimiento centralizado.

**Usuarios:**
- **Documentadores:** Necesitan crear diagramas con estilos corporativos automáticamente heredados
- **Arquitectos:** Necesitan cambiar estilos corporativos (colores, fuentes) de una sola vez para impactar 100+ diagramas
- **Desarrolladores:** Necesitan validar que !include + Sphinx integration funciona antes de escalar

**Criterios de éxito:**
- ✅ `source/_static/plantuml-styles.puml` existe con paleta corporativa completa (5-6 colores + T1-T4 variantes)
- ✅ 1-2 test diagramas (UC + Component) incluyen `!include` y heredan estilos centrales
- ✅ `make html` genera PNG/SVG correctamente con estilos aplicados
- ✅ `discover/GUIDELINES.md` documenta qué parámetros usar, qué evitar, ejemplos
- ✅ Sphinx build integration validado (working directory, path resolution, color output)
- ✅ Phase 1 Setup listo para expandir a 5 UC críticos en Phase 10 EXECUTE

---

## In-Scope

**Phase 1 Setup — Foundational Components:**

1. **Color System Design**
   - Definir 5-6 colores corporativos base
   - Crear variantes T1-T4 (lightest → darkest) para c/u
   - Validar contra guía corporativa IACT
   - Patrón: adoptado de TEAMMATES (PROVEN en producción)

2. **Central Style File: `source/_static/plantuml-styles.puml`**
   - Global skinparam (BackgroundColor, Shadowing, DefaultTextAlignment)
   - Context-specific skinparam (Class, Actor, Sequence, Activity, State)
   - Hide directives (footbox, members, circle)
   - Color macro definitions (!define)
   - ~150-200 líneas, self-documented

3. **Test Suite for Empirical Validation**
   - `discover/test-plantuml-styles.puml` — test style file (minimal version)
   - `discover/test-uc-diagram.md` — 1 Use Case test diagram
   - `discover/test-component-diagram.md` — 1 Component test diagram (coverage of both types)
   - All test diagramas: `!include ../../../_static/plantuml-styles.puml`
   - Test objective: validate !include path resolution + color output in Sphinx build

4. **Sphinx Build Validation**
   - `make html` compila test diagramas sin errores
   - PNG/SVG output contiene colores corporativos corrected
   - Working directory resolution funciona (Sphinx root = document root)
   - Build output log limpio (0 PlantUML errors)

5. **Documentation: `discover/GUIDELINES.md`**
   - Paleta corporativa documentada (colores + variantes)
   - Public parameters (recomendados) vs. private (evitar)
   - POSIX _prefix convention explicado
   - Ejemplos: cómo incluir style file, cómo usar colores, best practices
   - Anti-patrones: qué no hacer, por qué
   - TEAMMATES pattern reference (justificación)

6. **Decision Documentation**
   - ADR-plantuml-naming-conventions.md (creado Phase 5, linked)
   - solution-strategy.md (creado Phase 5, approved)
   - Risk-register.md (actualizar con Phase 1 Setup risks)
   - exit-conditions.md (actualizar Phase 10 criteria)

---

## Out-of-Scope

| Excluido | Razón |
|---|---|
| **Escalar a 100+ diagramas** | Phase 1 Setup solo valida patrón con 2 test diagramas. Escalado a Phase 10 EXECUTE (5 UC críticos → 100+ posterior) |
| **State Diagrams en Phase 1** | TEAMMATES proven state diagram, pero MODERATE applicability. Postergar a Phase 7 DESIGN (entity lifecycle diagrams) |
| **Component/Deployment/Timing Diagramas** | NOT APPLICABLE a requisitos funcionales (nivel técnico). Potential Phase 10+ si arquitectura lo requiere |
| **Sphinx Custom Plugin** | No necesario. sphinxcontrib-plantuml nativo maneja !include + rendering |
| **Automated Diagram Generation** | Out-of-scope. Documentadores crean diagramas manualmente, estilos heredan automáticamente |
| **CI/CD Diagram Validation** | Out-of-scope Phase 1. GitHub Actions setup (automated Sphinx build validation) → Phase 10 |
| **Complete GUIDELINES.md** | Phase 1 Setup documental: colores, POSIX convention, 5-10 ejemplos básicos. Ampliar en Phase 7+ |
| **Advanced skinparam Features** | Out-of-scope Phase 1 (mantener simple). Ejemplo: stereotypes, sequence numbering → Phase 7 |

---

## Estimación de Esfuerzo

| Componente | Tareas estimadas | Duración estimada |
|---|---|---|
| **1. Color System Design** | 2 | 30 min (definir paleta + validar corporativo) |
| **2. plantuml-styles.puml Implementation** | 3 | 1 hora (skinparam globals, context-specific, hide directives, colores) |
| **3. Test Suite Creation** | 4 | 1 hora (test-uc.md, test-component.md, test-styles.puml, validar estructura) |
| **4. Sphinx Build Validation** | 2 | 30 min (make html, verify output, fix path issues if any) |
| **5. GUIDELINES.md Documentation** | 2 | 45 min (paleta, POSIX convention, 5-10 ejemplos, best practices) |
| **6. Documentation & Review** | 2 | 30 min (ADR review, risk-register update, exit-conditions update) |
| **Total** | **15 tareas** | **~4 horas** |

**Clasificación:** Pequeño (scope claro, riesgos limitados, técnicas validadas via TEAMMATES)

**Fases activas:** Phase 1 Setup only (no Phase 5-9 overhead; empirical validation replaces full strategy)

---

## Recursos Necesarios

- **PlantUML 1.2025.0 reference** (Phase 1 DISCOVER complete ✅)
- **TEAMMATES reference** (externa, validation complete ✅)
- **Sphinx + sphinxcontrib-plantuml** (IACT-docs ya las usa)
- **Corporate branding guidelines** (colores, fonts, fonts IACT)

---

## Riesgos y Mitigación

| Riesgo | Severidad | Mitigación |
|--------|-----------|-----------|
| **!include path resolution fails** | ALTA | Phase 1 Setup: validar empirically with test diagram. TEAMMATES proof-of-concept. If fail → fallback: duplicar estilos en c/diagrama (plan B) |
| **Sphinx sphinxcontrib-plantuml incompatible with !include** | MEDIA | unlikely (TEAMMATES MarkBind works). Validar con make html. TEAMMATES architecture equivalent |
| **Working directory resolution wrong** | MEDIA | Test diagram de suite: path `../../../_static/...` if test lives in `discover/`. Validate output PNG contains colors |
| **Corporate color system wrong** | BAJA | Design phase 1: validar contra corporate guidelines. Easy to fix in plantuml-styles.puml |
| **Over-scope guidelines** | BAJA | Scope: básico Phase 1. Ampliar en Phase 7 (cuando haya State Diagrams) |

---

## Link ROADMAP

Ver tracking: [ROADMAP.md — Epic #2: plantuml-java-integration-impl](../../../../../ROADMAP.md#epic-2-plantuml-java-integration-impl)

---

## Critical Path

1. **Define color system** → 2. **Implement plantuml-styles.puml** → 3. **Create test suite** → 4. **Validate Sphinx build**

Success = `make html` generates PNG/SVG with corporate colors. No blockers.

---

## Próximas Fases (Preview)

- **Phase 7 DESIGN:** Especificar requisitos para 5 UC críticos (docentes, estudiantes, administradores)
- **Phase 10 EXECUTE:** Implementar 5 UC críticos + expandir a 100+ (Phase 1 Setup expandido)
- **Phase 11 TRACK:** Lessons learned, guidelines refinement
- **Phase 12 STANDARDIZE:** Patrón centralización disponible para otros proyectos IACT

---

## Estado de Aprobación

- [x] Scope aprobado por usuario — 2026-04-25

