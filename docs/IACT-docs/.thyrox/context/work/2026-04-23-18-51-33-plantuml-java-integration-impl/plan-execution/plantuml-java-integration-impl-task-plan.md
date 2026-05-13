```yml
created_at: 2026-04-25 10:50:00
project: IACT-docs
feature: plantuml-java-integration-impl
breakdown_version: 1.0
tasks_creator: NestorMonroy
total_tasks: 15
critical_dependencies: 5 (SPEC-001→002→003→004, SPEC-005 parallel)
planned_start: 2026-04-25 11:00:00
planned_end: 2026-04-25 15:00:00
implementation_owner: NestorMonroy
```

# Tasks: PlantUML Centralized Styling Phase 1 Setup

## Propósito

Documentar CÓMO técnicamente implementar Phase 1 Setup basado en 5 SPECs de DESIGN/SPECIFY. Desglose en 15 tareas atómicas con dependencias claras, criterios de éxito objetivos, y validación por checkpoint.

**Basado en:** design/plantuml-java-integration-impl-requirements-spec.md

---

## Resumen Ejecutivo

**Total de tareas:** 15  
**Estimación total:** 4 horas  
**Fecha inicio estimada:** 2026-04-25 11:00:00  
**Fecha fin estimada:** 2026-04-25 15:00:00

**Fases:**
1. **SPEC-001: Color System** (2 tareas, 0.5h)
2. **SPEC-002: Style File** (4 tareas, 1h)
3. **SPEC-003: Test Suite** (3 tareas, 1h)
4. **SPEC-004: Sphinx Validation** (3 tareas, 0.5h)
5. **SPEC-005: Guidelines** (2 tareas, 0.75h)
6. **Validación y Cierre** (1 tarea, 0.25h)

---

## Estados de Tarea

| Estado | Formato | Significado |
|--------|---------|-------------|
| `[ ]` | `- [ ] [T-NNN] desc` | Pendiente — lista para ejecutar |
| `[~]` | `- [~] [T-NNN] desc @agent-id` | En progreso — reclamada |
| `[x]` | `- [x] [T-NNN] desc @agent-id (done)` | Completada |

---

## FASE 1: Color System Design (Estimación: 0.5h)

### TASK-001: Definir y validar paleta corporativa

**Descripción:** Diseñar paleta de 5-6 colores corporativos base y generar variantes T1-T4 (lightest→darkest) para cada uno, validando contra WCAG 2.1 AA accessibility.

**Satisface:** SPEC-001 (Color System Design)

**Archivos afectados:**
- `discover/color-palette.md` (NUEVO)

**Criterios de éxito:**
- [ ] Paleta definida: 5-6 colores base con nombres descriptivos
- [ ] Valores HEX + RGB documentados para cada color
- [ ] Variantes T1-T4 generadas matemáticamente (escala linear RGB)
- [ ] AA contrast ratio validado (4.5:1 texto, 3:1 gráficos)
- [ ] Mappeo semántico documentado (qué color = qué significa)
- [ ] Validado contra TEAMMATES color pattern (referencia externa)
- [ ] discover/color-palette.md creado con tabla de referencia

**Dependencias:** Ninguna (inicio de critical path)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

### TASK-002: Documentar paleta en discover/color-palette.md

**Descripción:** Crear archivo de referencia con paleta corporativa, variantes T1-T4, y guía de uso semántico.

**Satisface:** SPEC-001 (continuación)

**Archivos a crear:**
```markdown
# Color Palette — PlantUML Corporate System

Base Colors (5-6 selections):
| Name | HEX | RGB | Semantic |
| Core Blue | #0066CC | (0, 102, 204) | Actors, primary elements |
| Core Green | #00CC66 | (0, 204, 102) | Data, storage |
...

Variants (T1-T4 for each):
| Color | T1 (Lightest) | T2 | T3 | T4 (Darkest) |
| Blue | #E6F0FF | #99CCFF | #3399FF | #003399 |
...
```

**Criterios de éxito:**
- [ ] Tabla con 5-6 colores base + HEX, RGB, semántica
- [ ] Variantes T1-T4 completadas para c/u (20-24 valores totales)
- [ ] Documento validado contra WCAG guidelines
- [ ] Formato markdown claro y copy-paste ready

**Dependencias:** T-001 (color definitions)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

## FASE 2: Central Style File Implementation (Estimación: 1h)

### TASK-003: Crear estructura plantuml-styles.puml — Secciones globales

**Descripción:** Crear archivo `source/_static/plantuml-styles.puml` con estructura base, global skinparam, y secciones de comentarios para cada tipo de diagrama.

**Satisface:** SPEC-002 (parte A: estructura + global)

**Archivos a crear:**
- `source/_static/plantuml-styles.puml` (inicio, ~80 líneas)

**Contenido esperado:**
```puml
' PlantUML Corporate Style File
' Phase 1 Setup — Centralized Styling
' Created: 2026-04-25
' Usage: !include ../../../_static/plantuml-styles.puml

' ============================================
' GLOBAL SKINPARAM
' ============================================
skinparam backgroundColor white
skinparam shadowing false
skinparam defaultTextAlignment left
skinparam padding 10

' ============================================
' COLOR DEFINITIONS (!define macros)
' ============================================
!define _coreCorporateBlue #0066CC
!define _coreCorporateGreen #00CC66
... (20+ define statements)
' Public parameters:
!define backgroundColor _coreCorporateBlue
...

' ============================================
' DIAGRAM TYPE: USE CASE
' ============================================
' [Will be filled by T-004]

' ============================================
' DIAGRAM TYPE: SEQUENCE
' ============================================
' [Will be filled by T-004]

' ============================================
' DIAGRAM TYPE: ACTIVITY
' ============================================
' [Will be filled by T-004]

' ============================================
' HIDE DIRECTIVES
' ============================================
' [Will be filled by T-004]
```

**Criterios de éxito:**
- [ ] Archivo creado en `source/_static/plantuml-styles.puml`
- [ ] Header comentado (descripción, fecha, uso)
- [ ] Global skinparam section completa (BackgroundColor, Shadowing, TextAlignment, Padding)
- [ ] Color definitions section iniciada con 20+ !define statements
- [ ] Diagrams type sections esqueletizados (comentarios placeholder)
- [ ] Archivo compilable (0 PlantUML syntax errors)
- [ ] Líneas totales: ~80 (expandirá a 150-200 con T-004)

**Dependencias:** T-002 (color palette ready)

**Estimación:** 0.5 horas

**Estado:** [ ] Pendiente

---

### TASK-004: Completar plantuml-styles.puml — Context-specific skinparam + hide directives

**Descripción:** Agregar context-specific skinparam para Use Case, Sequence, Activity, Component y hide directives.

**Satisface:** SPEC-002 (parte B: context-specific + Component)

**Archivos a modificar:**
- `source/_static/plantuml-styles.puml` (APPEND sections)

**Contenido a agregar:**
```puml
' ============================================
' DIAGRAM TYPE: USE CASE (Actor/Interaction)
' ============================================
skinparam actor {
  backgroundColor _coreCorporateBlue
  fontColor white
  borderColor #003366
}
skinparam usecase {
  backgroundColor _lightBlueT1
  fontColor #003366
  borderColor #003366
}

' ============================================
' DIAGRAM TYPE: CLASS (Structure)
' ============================================
skinparam class {
  backgroundColor _coreCorporateGreen
  borderColor #006633
  attributeFontColor #003333
}

' ============================================
' DIAGRAM TYPE: SEQUENCE (Interaction)
' ============================================
skinparam sequenceActor {
  backgroundColor _coreCorporateBlue
}
skinparam participant {
  backgroundColor _lightBlueT2
  borderColor _coreCorporateBlue
}

' ============================================
' DIAGRAM TYPE: ACTIVITY (Flow)
' ============================================
skinparam activity {
  backgroundColor _coreCorporateGreen
  borderColor #006633
}

' ============================================
' DIAGRAM TYPE: COMPONENT (Architecture)
' ============================================
skinparam component {
  backgroundColor _lightGreenT2
  borderColor _coreCorporateGreen
  fontColor #003333
}
skinparam interface {
  backgroundColor _lightGreenT1
  borderColor _coreCorporateGreen
  fontColor #003333
}

' ============================================
' HIDE DIRECTIVES (Clean output)
' ============================================
hide footbox
hide members
hide circle
```

**Criterios de éxito:**
- [ ] Class, Actor, Sequence, Activity sections agregadas
- [ ] Cada sección contiene skinparam relevantes (backgroundColor, fontColor, borderColor)
- [ ] POSIX _prefix convention aplicada (_coreColor = private, color = public)
- [ ] Hide directives completos (footbox, members, circle)
- [ ] Total líneas: 150-200 (target range)
- [ ] Archivo compila sin errores PlantUML CLI

**Dependencias:** T-003

**Estimación:** 0.5 horas

**Estado:** [ ] Pendiente

---

## FASE 3: Test Suite Creation (Estimación: 1h)

### TASK-005: Crear test-plantuml-styles.puml (versión simplificada)

**Descripción:** Crear archivo de test simplificado con versión minimal de plantuml-styles.puml para validar !include y color rendering.

**Satisface:** SPEC-003 (parte A: test style file)

**Archivos a crear:**
- `discover/test-plantuml-styles.puml` (10-15 líneas)

**Contenido esperado:**
```puml
' Test PlantUML Styles — Simplified Version
' Validates: color definitions, skinparam syntax, include directives

!define _testBlue #0066CC
!define _testGreen #00CC66
!define _testOrange #FF9900

skinparam backgroundColor white
skinparam shadowing false

skinparam actor {
  backgroundColor _testBlue
}
skinparam usecase {
  backgroundColor _testGreen
}
```

**Criterios de éxito:**
- [ ] Archivo creado en `discover/test-plantuml-styles.puml`
- [ ] Contiene 3-5 !define macros de color para testing
- [ ] Contiene minimal skinparam (global + 2 diagram types)
- [ ] Compilable sin errores en PlantUML CLI
- [ ] Líneas totales: 10-15 (minimal for testing)

**Dependencias:** T-004 (styles.puml reference)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

### TASK-006: Crear test-uc-diagram.md (Use Case test with !include)

**Descripción:** Crear diagrama de Use Case que valida !include path resolution y color application.

**Satisface:** SPEC-003 (parte B: UC test diagram)

**Archivos a crear:**
- `discover/test-uc-diagram.md` (markdown con PlantUML block)

**Contenido esperado:**
```markdown
# Test: Use Case Diagram with Centralized Styling

Validates:
- !include path resolution from discover/ to _static/
- Actor and UseCase color application
- Sphinx sphinxcontrib-plantuml integration

```puml
@startuml
!include ../../../_static/plantuml-styles.puml

actor "Student" as student
actor "Instructor" as instructor
usecase "Submit Assignment" as submit
usecase "Grade Assignment" as grade

student --> submit
instructor --> grade
@enduml
```
```

**Criterios de éxito:**
- [ ] Archivo creado en `discover/test-uc-diagram.md`
- [ ] PlantUML block contiene !include con path correcto: `!include ../../../_static/plantuml-styles.puml`
- [ ] Diagrama contiene 3-5 actores y 2-3 casos de uso
- [ ] Diagrama compila en PlantUML CLI sin errores
- [ ] Markdown está bien formado (Sphinx parseable)

**Dependencias:** T-004 (styles.puml exists)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

### TASK-007: Crear test-component-diagram.md (Component test with !include)

**Descripción:** Crear diagrama de Componentes que valida !include y estilo aplicado (segunda cobertura de tipos).

**Satisface:** SPEC-003 (parte C: Component test diagram)

**Archivos a crear:**
- `discover/test-component-diagram.md` (markdown con PlantUML block)

**Contenido esperado:**
```markdown
# Test: Component Diagram with Centralized Styling

Validates:
- !include path resolution (second diagram type)
- Style inheritance across diagram types
- Component and interface coloring

```puml
@startuml
!include ../../../_static/plantuml-styles.puml

package "API" {
  component [UserService]
  component [AuthService]
}

package "Database" {
  component [MongoDB]
}

UserService --> MongoDB
AuthService --> MongoDB
@enduml
```
```

**Criterios de éxito:**
- [ ] Archivo creado en `discover/test-component-diagram.md`
- [ ] !include path correcta: `!include ../../../_static/plantuml-styles.puml`
- [ ] Diagrama contiene 3-5 componentes y 2+ interfaces/relaciones
- [ ] Diagrama compila en PlantUML CLI sin errores
- [ ] Markdown bien formado

**Dependencias:** T-004 (styles.puml exists)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

## FASE 4: Sphinx Build Validation (Estimación: 0.5h)

### TASK-008: Ejecutar make html y validar build

**Descripción:** Compilar proyecto Sphinx incluyendo test diagramas para validar sphinxcontrib-plantuml integration y path resolution.

**Satisface:** SPEC-004 (parte A: build execution)

**Comandos a ejecutar:**
```bash
cd /home/user/IACT-docs
make clean  # Limpiar build anterior
make html   # Compilar Sphinx + test diagramas

# Verificar no hay PlantUML errores
grep -i "plantuml error" _build/html/*.log || echo "✓ No PlantUML errors"

# Verificar PNG/SVG generados
ls -la _build/html/discover/test-*-diagram.* 2>/dev/null || echo "✗ Missing diagrams"
```

**Criterios de éxito:**
- [ ] `make html` completa con exit code 0
- [ ] Build log tiene 0 líneas con "PlantUML Error"
- [ ] PNG/SVG generados en `_build/html/discover/`
- [ ] Sphinx warnings mínimas (0 si es posible)
- [ ] Build tiempo razonable (<30 segundos)

**Dependencias:** T-006, T-007 (test diagramas existen)

**Estimación:** 0.15 horas

**Estado:** [ ] Pendiente

---

### TASK-009: Validar colores en PNG/SVG output y path resolution

**Descripción:** Inspeccionar PNG/SVG generados para confirmar: (1) colores corporativos aplicados, (2) path resolution correcta, (3) imágenes legibles.

**Satisface:** SPEC-004 (parte B: output validation)

**Comandos a ejecutar:**
```bash
# Verificar archivos existen y tienen tamaño razonable (>1KB)
file _build/html/discover/test-uc-diagram.svg
file _build/html/discover/test-component-diagram.svg

# Inspeccionar SVG para colores (grep para valores hex)
grep "#0066CC\|#00CC66" _build/html/discover/test-uc-diagram.svg && echo "✓ Corporate colors detected"

# Verificar SVG structure (basic validity)
grep -q "<svg" _build/html/discover/test-uc-diagram.svg && echo "✓ Valid SVG structure"
```

**Criterios de éxito:**
- [ ] SVG/PNG archivos existen en _build/html/discover/
- [ ] Archivos tienen tamaño ≥1KB (no corrupted)
- [ ] SVG contiene valores de color corporativos (visual inspection)
- [ ] SVG bien formado (valid XML/SVG)
- [ ] Imágenes son legibles (actors, usecases, componentes visibles)
- [ ] Path resolution correcta (no "file not found" errors in log)

**Dependencias:** T-008

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

## FASE 5: Guidelines Documentation (Estimación: 0.75h)

### TASK-010: Crear discover/GUIDELINES.md — Secciones completas

**Descripción:** Documentar comprehensive guía de uso para documentadores incluyendo paleta, convención POSIX, ejemplos, best practices, anti-patrones.

**Satisface:** SPEC-005 (Guidelines documentation)

**Archivos a crear:**
- `discover/GUIDELINES.md` (40-50 líneas)

**Secciones requeridas:**
```markdown
# PlantUML Centralized Styling — GUIDELINES

## Introduction
[Qué es el sistema, por qué existe, para quién es]

## Color Palette
[Tabla colores corporativos + T1-T4 variantes]

## POSIX _prefix Convention
[Explicación privado vs público con ejemplos]
- Parámetros privados: _prefix (no usar en diagramas)
- Parámetros públicos: sin _ (OK usar en diagramas)

## Cómo Incluir Estilos
[Instrucción exacta de !include]
```puml
!include ../../../_static/plantuml-styles.puml
```

## Ejemplos
[3-5 ejemplos mínimos]
- UC diagram mínimo
- Sequence diagram con estilos
- Multi-diagram con colores

## Best Practices
[Order of execution, cuando usar qué color, etc.]

## Anti-patrones
[Qué NO hacer y por qué]
- NO duplicar estilos per-diagram
- NO modificar plantuml-styles.puml directamente
- NO hardcode colores en diagramas
```

**Criterios de éxito:**
- [ ] Archivo creado en `discover/GUIDELINES.md`
- [ ] Sección Paleta: todos 5-6 colores + variantes documentados
- [ ] Sección POSIX: claro público vs privado, con ejemplos código
- [ ] Sección Ejemplos: mínimo 3 ejemplos COMPILABLES en PlantUML (copy-paste ready, sin placeholder)
- [ ] Sección Best Practices: mínimo 3 prácticas
- [ ] Sección Anti-patrones: mínimo 3 qué-no-hacer
- [ ] Total líneas: 40-50 (conciso)
- [ ] Markdown bien formado, todos ejemplos son PlantUML sintaxis correcta

**Dependencias:** T-002 (color palette doc), T-004 (styles.puml complete), T-009 (validation complete)

**Estimación:** 0.5 horas

**Estado:** [ ] Pendiente

---

### TASK-011: Code review — Validar GUIDELINES y completar ADR references

**Descripción:** Revisar GUIDELINES.md por claridad y completitud, validar referencias a ADR-plantuml-naming-conventions.md, asegurar ejemplos sean copy-paste ready.

**Satisface:** SPEC-005 (review + finalization)

**Checklist de review:**
- [ ] Paleta de colores clara (no ambigüedad sobre qué usar cuándo)
- [ ] POSIX _prefix convention está bien explicado para documentadores no-técnicos
- [ ] Ejemplos compilan y funcionan (PlantUML syntax correcto)
- [ ] Referencias a ADR-plantuml-naming-conventions.md incluidas y validadas en POSIX section
- [ ] ADR-plantuml-naming-conventions.md enlazado y contexto claro (privado vs público)
- [ ] Terminología consistente con rest del proyecto
- [ ] Sin [NEEDS CLARIFICATION] markers pendientes
- [ ] Lenguaje es accesible (documentadores van a leerlo)

**Criterios de éxito:**
- [ ] Checklist completamente validado (todas las cajas checked)
- [ ] Revisión documentada (comentarios si hay issues)
- [ ] GUIDELINES.md final con todas correcciones aplicadas
- [ ] ADR references validadas

**Dependencias:** T-010

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

## FASE 6: Validación y Cierre (Estimación: 0.25h)

### TASK-012: Validación final y git commits

**Descripción:** Ejecutar validación completa (make html, style file compile, all files exist), crear commits finales, actualizar now.md con cierre de Phase 8.

**Satisface:** Cierre PLAN EXECUTION

**Validaciones:**
```bash
# Archivos requeridos existen
[ -f source/_static/plantuml-styles.puml ] && echo "✓ Style file exists"
[ -f discover/GUIDELINES.md ] && echo "✓ Guidelines exist"
[ -f discover/test-uc-diagram.md ] && echo "✓ UC test exists"
[ -f discover/test-component-diagram.md ] && echo "✓ Component test exists"

# Compilación final
make clean && make html

# Verificar diagrama SVG final
[ -f _build/html/discover/test-uc-diagram.svg ] && echo "✓ UC diagram rendered"
```

**Criterios de éxito:**
- [ ] Todos los archivos existen (12 archivos creados/modificados)
- [ ] `make html` pasa sin errores
- [ ] Build log limpio (0 PlantUML errors, minimal warnings)
- [ ] PNG/SVG output contiene colores corporativos
- [ ] Git working tree ready para commit
- [ ] now.md actualizado con Phase 8 completion
- [ ] **CHECKPOINT: Phase 1 Setup readiness verified** (color system + styles + tests + Sphinx validation completados, listo para Phase 10 escalado a 5 UC críticos)
- [ ] risk-register.md actualizado: Phase 1 Setup risks documentados y mitigaciones asignadas
- [ ] exit-conditions.md actualizado: Gate criteria para Phase 10 EXECUTE definidos explícitamente

**Dependencias:** T-011 (todo Phase 5 complete)

**Estimación:** 0.25 horas

**Estado:** [ ] Pendiente

---

## Orden de Ejecución (DAG)

```
Fase 1: SPEC-001 (Color System)
  T-001 → T-002
    ↓
Fase 2: SPEC-002 (Style File)
  T-003 → T-004
    ↓
Fase 3: SPEC-003 (Test Suite)
  T-005
  T-006 (depende T-004)
  T-007 (depende T-004)
  T-006, T-007 pueden ejecutarse en paralelo
    ↓
Fase 4: SPEC-004 (Validation)
  T-008 (depende T-006, T-007)
  T-009 (depende T-008)
    ↓
Fase 5: SPEC-005 (Guidelines) — PARALLELIZABLE con T-006,T-007
  T-010 (depende T-002, T-004, T-009)
  T-011 (depende T-010)
    ↓
Fase 6: Cierre
  T-012 (depende T-011)
```

**Secuencia recomendada:**
1. T-001, T-002 (color design, 0.5h)
2. T-003, T-004 (style file, 1h) — bloqueador para todo lo demás
3. T-005 (test style minimal, 0.25h)
4. T-006, T-007 EN PARALELO (UC + Component test, 0.5h)
5. T-008, T-009 (Sphinx validation, 0.4h)
6. T-010, T-011 EN PARALELO O SECUENCIAL (Guidelines, 0.75h)
7. T-012 (Final validation + commits, 0.25h)

**Timeline:** ~4 horas lineal, ~3 horas si se ejecutan paralelos

---

## Checkpoints

**CHECKPOINT-1: Después de T-004**
- plantuml-styles.puml completado y compilable
- `PlantUML -jar plantuml.jar source/_static/plantuml-styles.puml -o test_output`
- Resultado: 0 errores, archivo syntax válido

**CHECKPOINT-2: Después de T-009**
- Test diagramas compilan
- Sphinx build completa sin PlantUML errors
- PNG/SVG contienen colores corporativos
- Resultado esperado: 2 SVG archivos en _build/html/discover/ con colores visibles

**CHECKPOINT-3: Después de T-011**
- GUIDELINES.md documentado y revisado
- Todos los archivos creados
- Validación final pasada
- Resultado: proyecto listo para Phase 10 EXECUTE (escalado a 5 UC críticos)

---

## Rollback Points

**Si falla T-003 o T-004 (style file):**
- Revertir commits del estilo
- Eliminar source/_static/plantuml-styles.puml
- Volver a T-003 con análisis de error (syntax, color values, etc.)
- Plan B: simplificar si es necesario

**Si falla T-008 (make html):**
- Diagnosticar error específico en build log
- Likely causes: (1) path resolution (T-006/007 paths), (2) style syntax (T-004), (3) Sphinx config
- Verificar Sphinx conf.py tiene `extensions = ['sphinxcontrib.plantuml']`
- Fix y re-ejecutar T-008

**Si falla T-009 (colors no visible):**
- Verificar plantuml-styles.puml tiene !define colores (T-004)
- Verificar test diagramas usan estilos (!include + skinparam references)
- Verificar SVG válido (no corrupted en build)
- Plan B: inspeccionar SVG source vs PNG output

---

## Estimación de Tiempo

| Fase | Tareas | Estimación |
|------|--------|------------|
| 1: Color System | T-001, T-002 | 0.5h |
| 2: Style File | T-003, T-004 | 1.0h |
| 3: Test Suite | T-005, T-006, T-007 | 1.0h |
| 4: Sphinx Validation | T-008, T-009 | 0.4h |
| 5: Guidelines | T-010, T-011 | 0.75h |
| 6: Cierre | T-012 | 0.25h |
| **TOTAL** | 12 tareas core | **4.0h** |

Buffer recomendado: +15% = 4.6h total (cubre debugging, review iterations)

---

## Aprobación

- [ ] Tasks revisadas por arquitecto
- [ ] Estimaciones validadas
- [ ] Orden de ejecución verificado
- [ ] Dependencias mapeadas (DAG correcto)
- [ ] Checkpoints identificados
- [ ] Plan aprobado para ejecución

**Status:** Aprobado por usuario 2026-04-25 10:50:00  
**Ready for Phase 10:** Después de completar todos los checkpoints

---

## Próximas Fases (Preview)

- **Phase 9 PILOT/VALIDATE (opcional):** PoC con 1 diagrama UC real (no test)
- **Phase 10 EXECUTE:** Escalar a 5 UC críticos + 100+ diagrama posterior
- **Phase 11 TRACK:** Lessons learned, refinement de guidelines
- **Phase 12 STANDARDIZE:** Propagar patrón a otros proyectos IACT

---

**Versión:** 1.0.0  
**Creación:** 2026-04-25 10:50:00  
**Estado:** Listo para ejecución (awaiting Phase 10 start signal)
