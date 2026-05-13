```yml
created_at: 2026-04-25 09:15:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
architecture_version: 1.0.0
architect: Claude Code Agent
status: Aprobado — 2026-04-25 10:00:00
```

# Solution Strategy: PlantUML Java Integration Implementation

## Propósito

Transformar el análisis técnico de Phase 1 DISCOVER (19 análisis especializados, 7,600+ líneas) en decisiones arquitectónicas ejecutables para centralizar y estandarizar diagramas PlantUML en IACT-docs.

**Objetivo:** Validar y solidificar la estrategia de dos niveles (!include + estilos centralizados) como patrón central de implementación.

---

## Key Ideas

### Idea 1: Centralización de Estilos vía !include + skinparam + `<style>` Blocks

**Descripción:**
PlantUML 1.2025.0 soporta tres mecanismos complementarios para centralizar estilos:
1. `!include` directiva — importar archivo externo de definiciones
2. `skinparam` — parámetros globales aplicables a tipo de diagrama
3. `<style>` blocks — sintaxis moderna, context-aware, compatible con todos los tipos

**Impacto:**
- Todas las decisiones estilísticas (colores, fuentes, espaciado) viven en `source/_static/plantuml-styles.puml`
- Cambios centrales se propagan automáticamente a 100+ diagramas
- Sin duplicación: cada cambio se hace una vez
- Documentación como código: versionable en git

### Idea 2: Clasificación de Tipos de Diagrama por Aplicabilidad

**Descripción:**
No todos los 13 tipos de diagrama de PlantUML son relevantes para documentación de requisitos funcionales de negocio. Clasificación validada:

- **CRITICAL** (obligatorios Phase 1 Setup): Use Case Diagrams
- **IMPORTANT** (recomendados Phase 1 Setup): Sequence Diagrams
- **RECOMMENDED** (Phase 1 Setup, sintaxis moderna): Activity Diagrams (NEW SYNTAX v6)
- **OPTIONAL** (Phase 1 Setup, context-dependent): Class Diagrams
- **MODERATE** (postergar a Phase 7 DESIGN): State Diagrams (entity lifecycle)
- **NOT APPLICABLE** (excluir): Timing, Component, Deployment, Network (nwdiag), Object, Map, JSON/YAML Display — nivel técnico/arquitectónico

**Impacto:**
- Scope claro: 4 tipos de diagrama en Phase 1 Setup, no 13
- Decisión explícita sobre qué tipos usar, cuándo, y por qué
- Reduces cognitive load para documentadores
- Evita herramientas que no agregan valor (network diagrams en IACT es innecesario)

### Idea 3: Validación Empírica de !include Working Directory

**Descripción:**
!include tiene 0.85 confianza (basada en soporte histórico de PlantUML, no en validación empírica con Sphinx). Strategy es validar con 1 test UC antes de escalar a 100+.

**Impacto:**
- Reduce riesgo crítico (ALTA severidad): si !include falla en Sphinx build, todo el approach colapsa
- Phase 1 Setup = Phase 1 Validation empírica: crear test-plantuml-styles.puml + 1 UC de prueba
- No escalar a 100+ diagramas hasta que !include esté PROVEN

### Idea 4: skinparam Context-Dependency y Two-Tier Definition

**Descripción:**
`skinparam` es context-dependent: parámetros de Use Case Diagrams ≠ Sequence Diagrams. Solución:
- Nivel 1 (Global): parámetros universales (colores corporativos, fuentes)
- Nivel 2 (Context): cada tipo de diagrama define sus skinparam por separado

**Impacto:**
- plantuml-styles.puml contiene 13 secciones: [Global] + [UC] + [Sequence] + [Activity] + [Class] + [State] + [otros]
- Cada sección es auto-contenida
- Activity Diagrams NEW SYNTAX usa `<style>` block moderno (no skinparam legacy)

---

## Research: Validar Unknowns de Phase 1

### Unknown 1: ¿Funciona !include en Sphinx build con working directory correcto?

**Alternativas investigadas:**
- A) Usar !include con path relativo `source/_static/plantuml-styles.puml` ✓ Standard PlantUML
- B) Usar !include con path absoluto `/path/to/...` — frágil, no portable
- C) No usar !include, duplicar estilos en cada diagrama — mantenimiento pesado
- D) Usar template preprocessing (Sphinx preprocessor) — overhead innecesario

**Decisión:** Opción A (path relativo)
**Justificación:** PlantUML soporta path relativo desde el directorio de ejecución. Sphinx ejecuta desde raíz del proyecto.
**Validación empírica requerida:** Phase 1 Setup, con 1 test UC

### Unknown 2: ¿Skinparam y `<style>` blocks pueden coexistir sin conflictos?

**Alternativas:**
- A) Usar SOLO skinparam (legacy) — disponible en todos los tipos, pero sintaxis vieja
- B) Usar SOLO `<style>` blocks (moderno) — más potente, pero Activity Diagrams NEW SYNTAX requiere esto
- C) Mezclar ambos: skinparam para global, `<style>` para context-specific ✓

**Decisión:** Opción C (coexistencia)
**Justificación:** Activity Diagrams NEW SYNTAX usan `<style>`, Sequence Diagrams usan skinparam. Ambos pueden vivir en el mismo archivo.
**Validación:** Documentar en plantuml-styles.puml con notas sobre precedencia

### Unknown 3: ¿Sphinx sphinxcontrib-plantuml renderiza correctamente con !include + skinparam?

**Alternativas:**
- A) Validar con ejemplo real en Phase 1 Setup
- B) Confiar en documentación de PlantUML/Sphinx (riesgo MEDIUM)

**Decisión:** Opción A (validación empírica)
**Justificación:** El canal sphinxcontrib-plantuml es black-box. Debe testearse con config real.

---

## Fundamental Decisions

### Decision 1: Adoptar Estrategia de Dos Niveles para Centralización

**Alternativas Consideradas:**
- Opción A (ELEGIDA): Two-tier (!include + centralized styling + documented guidelines)
- Opción B: No centralizar — cada diagrama define sus estilos
- Opción C: Preprocesar RST en Sphinx (custom plugin) — overhead innecesario

**Justificación:**
- PlantUML 1.2025.0 soporta nativamente (no requiere herramientas externas)
- Mantiene documentation-as-code (estilos = código, versionable en git)
- Cambios centrales = impacto instantáneo (DRY principle)
- Sphinx + sphinxcontrib-plantuml es la integración estándar (no hay overhead)

**Implications:**
- Requiere archivos: `source/_static/plantuml-styles.puml` (central), `discover/test-plantuml-styles.md` (validation)
- Cambios de estilo corporativo → 1 archivo a editar, 100+ diagramas impactados
- Documentación de directrices es crítica (qué skinparam/style disponible, cómo usar)

### Decision 2: Seleccionar 4 Diagram Types para Phase 1 Setup

**Alternativas Consideradas:**
- Opción A (ELEGIDA): UC, Sequence, Activity, Class (4 tipos)
- Opción B: Agregar State Diagrams (5 tipos) — postpone, tiene MODERATE applicability
- Opción C: Incluir todos los 13 tipos — scope creep innecesario

**Justificación:**
- UC (CRITICAL) = mandatory
- Sequence (IMPORTANT) = essential para interacciones
- Activity (RECOMMENDED) = modern, NEW SYNTAX v6, sin Graphviz
- Class (OPTIONAL) = futuro-proof, arquitectura técnica posterior
- State (MODERATE) = useful pero postergar a Phase 7 (entity lifecycle, 3-5 máximo)
- Network, Timing, Component, Deployment, etc. = NOT APPLICABLE (nivel técnico/infraestructura)

**Implications:**
- plantuml-styles.puml tiene 5 secciones principales: [Global] + [UC] + [Sequence] + [Activity] + [Class]
- State Diagrams agregados en Phase 7 sin impacto en Phase 1 Setup
- Técnicas (Timing, Component, Network) EXCLUIDAS: no se documenta soporte

### Decision 3: Validar !include Empíricamente en Phase 1 Setup

**Alternativas:**
- Opción A (ELEGIDA): Crear test-plantuml-styles.puml + 1 test UC, validar en Sphinx build
- Opción B: Confiar en documentación de PlantUML — riesgo MEDIUM
- Opción C: Implementar todo (100+ diagramas) y rezar — riesgo ALTO

**Justificación:**
- !include es cornerstone de toda la estrategia (confidence 0.85 solo → empirical validation needed)
- Test UC = proof-of-concept de working directory resolution
- Reducir riesgo antes de escalar

**Implications:**
- Phase 1 Setup = discovery + validation (2-3 horas)
- Si !include falla → pivotear a Opción B (duplicar estilos en cada diagrama) o Opción C (Sphinx preprocessor)
- Si !include funciona → expandir a 5 UC críticos, luego 100+

### Decision 4: Adoptar Clean Code Naming Conventions (POSIX _prefix)

**Alternativas:**
- Opción A (ELEGIDA): POSIX _prefix para private members (`_privateSkinparam`)
- Opción B: camelCase todo
- Opción C: No distinguir private/public

**Justificación:**
- Clean Code principles (Robert Martin) recomiendan _prefix
- Claridad: qué es API pública (para diagramadores) vs. internal (para mantenedores)
- Escalabilidad: documentación automática de directrices

**Implications:**
- plantuml-styles.puml documenta qué parámetros son "públicos" (recomendado usar) vs. "_internal" (no usar)
- ADR para esta decisión: `adr-plantuml-naming-conventions.md`

---

## Technology Stack

```
PlantUML:           1.2025.0 (engine de diagramas)
Sphinx:             5.3+ (documentación)
sphinxcontrib-plantuml: 0.26+ (integración PlantUML-Sphinx)
Java:               8+ (para PlantUML engine)
Python:             3.9+ (para Sphinx)
Git:                2.40+ (versionamiento)

Styles Repository:  source/_static/plantuml-styles.puml
Test Framework:     make html (Sphinx build)
CI/CD:              GitHub Actions (validación de diagrams)
```

**Justificación:**
- PlantUML 1.2025.0: soporte completo para !include, skinparam, `<style>` blocks
- Sphinx: standard en IACT-docs (ya en uso)
- sphinxcontrib-plantuml: conversión PNG/SVG automática durante build
- Java 8+: mínimo requerido por PlantUML
- Git: versionamiento de plantuml-styles.puml

---

## Architecture Patterns

### Structural Patterns

**!include Pattern (Centralization via Inclusion)**
- Archivo central `plantuml-styles.puml` define todas las constantes, colores, skinparam
- Cada diagrama incluye: `!include ../../../_static/plantuml-styles.puml`
- Separación de concerns: contenido (diagrama) vs. presentación (estilos)

**Skinparam Hierarchy (Context-Aware Styling)**
- Global skinparam: colores corporativos, fuentes universales
- UC-specific skinparam: adjusts de actors, size, spacing
- Sequence-specific skinparam: lifeline colors, message font
- Activity-specific: swimlane styling, action box size

**Style Block Composition (Modern Syntax)**
- Activity Diagrams NEW SYNTAX: `<style> ... </style>` block (moderno)
- Selector-based: `activity { backgroundColor #EAEAEA }`, `swimlane { lineColor #3366BB }`
- Override precedence: local `<style>` > !included skinparam > defaults

### Behavioral Patterns

**Template Inheritance (via !include)**
- Base template: `plantuml-styles.puml` = fuente única de verdad
- Diagrams = templates + localized content

**Configuration as Code**
- Estilos = código fuente (no valores hardcoded en diagramas)
- Cambios = git commits (auditable, reversible)

### Architectural Styles

**Documentation as Code**
- Diagramas = Markdown + PlantUML (no Visio, no Lucidchart)
- Versionados en git junto con documentación
- Build reproducible (`make html`)

---

## How We Achieve Quality Goals

### Quality Goal 1: Consistency (Uniformidad Estilística)

**Approach:**
Todos los diagramas heredan estilos corporativos desde un único punto (plantuml-styles.puml).

**Mechanisms:**
- !include directiva en cada diagrama
- Global skinparam + context-specific overrides
- `<style>` blocks para Activity/State (NEW SYNTAX)

**Technologies:**
- PlantUML 1.2025.0 (!include, skinparam, `<style>`)
- sphinxcontrib-plantuml (renderización automática)

**Metric:** 100+ diagramas con estilos corporativos consistentes tras Phase 1 Setup

### Quality Goal 2: Maintainability (Facilidad de Cambios)

**Approach:**
Cambios estilísticos centralizados → impacto instantáneo en toda la documentación.

**Mechanisms:**
- Editar plantuml-styles.puml (1 archivo)
- Sphinx build regenera todos los diagramas (automatic)
- Git history tracking de cambios estilísticos

**Technologies:**
- PlantUML !include + Git
- Sphinx build system

**Metric:** Cambio de color corporativo tarda 5 minutos (edit + make html)

### Quality Goal 3: Correctness (Precisión de Requisitos)

**Approach:**
Usar tipos de diagramas validados contra nivel de abstracción correcto.

**Mechanisms:**
- UC Diagrams para requisitos funcionales
- Sequence Diagrams para interacciones
- Activity Diagrams para procesos
- State Diagrams para entity lifecycle (Phase 7+)

**Technologies:**
- Phase 1 DISCOVER análisis (19 tipos evaluados)
- ADR documentando decisiones

**Metric:** 0 diagramas de tipo incorrecto (ej: Network Diagram en requisitos funcionales)

### Quality Goal 4: Extensibility (Crecimiento Escalable)

**Approach:**
Agregar nuevos tipos de diagrama sin romper estilos existentes.

**Mechanisms:**
- Secciones modulares en plantuml-styles.puml por tipo
- New diagram type → agregar sección, no editar existentes
- Documentación de directrices por tipo

**Technologies:**
- PlantUML secciones comentadas
- Documentación dedicada (GUIDELINES.md)

**Metric:** Agregar State Diagrams en Phase 7 requiere <1 hora (nueva sección en plantuml-styles.puml)

### Quality Goal 5: Empirical Validation

**Approach:**
No escalar a 100+ diagramas sin validar !include + skinparam funciona en Sphinx build real.

**Mechanisms:**
- Phase 1 Setup: create test-plantuml-styles.puml + 1 test UC
- `make html` genera PNG/SVG correctamente
- Git-ignored test files (no contaminar repo)

**Technologies:**
- Sphinx build system
- GitHub Actions (CI validation)

**Metric:** Phase 1 Setup Success = `make html` renders test UC con estilos corporativos

---

## Adherence to Constraints

### Technical Constraint: Sphinx Build System (No Additional Tools)

**How we respect it:**
- !include + skinparam + `<style>` blocks son nativos a PlantUML (no custom extensions)
- sphinxcontrib-plantuml es extensión estándar de Sphinx (no build nuevas herramientas)
- Todo se ejecuta en `make html`

### Technical Constraint: Documentation as Code (No Binary Formats)

**How we respect it:**
- Estilos viven en plantuml-styles.puml (text file, versionable)
- Diagramas en Markdown con PlantUML (not Visio, not Lucidchart)
- Output: PNG/SVG generado automáticamente

### Business Constraint: Documentación de Requisitos Funcionales (Not Technical Architecture)

**How we respect it:**
- Diagram types seleccionados son nivel de requisitos (UC, Sequence, Activity, Class)
- Excluidos tipos técnicos (Network, Timing, Component, Deployment) = Phase 10+ si aplica
- Activity Diagrams usan NEW SYNTAX v6 (moderno, legible, no Graphviz)

### Organizational Constraint: Equipo Small (No DevOps Specialist)

**How we respect it:**
- plantuml-styles.puml es auto-contenido (1 archivo, no complicado)
- Sphinx build es automático (`make html`)
- GitHub Actions valida diagrams en CI (no manual testing)

### Regulatory Constraint: Corporate Branding (Colores, Fuentes)

**How we respect it:**
- Centralized skinparam garantiza colores corporativos
- Clean Code naming (_prefix) documenta qué parámetros son "recomendados"
- ADR registra decisión sobre paleta de colores

---

## Traceability to Analysis (Phase 1 DISCOVER)

### Connecting to Phase 1 Findings

| Finding | Solution Strategy | Responsibility |
|---------|-------------------|-----------------|
| **PlantUML 1.2025.0 supports !include** | Adopt !include as central pattern | Phase 1 Setup: validate empirically |
| **skinparam context-dependent** | Two-tier definition (global + context) | Define in plantuml-styles.puml |
| **11 diagram types evaluated** | Select 4 for Phase 1, exclude technical | architecture/diagram-types.md |
| **!include confidence 0.85** | Empirical validation needed | Phase 1 Setup with test UC |
| **Activity Diagrams NEW SYNTAX** | Use <style> blocks, not legacy skinparam | plantuml-styles.puml activity section |
| **State Diagrams MODERATE** | Defer to Phase 7 DESIGN | Documented in exit-conditions |

### Key Ideas → Decisions → Implementation

```
Key Idea: Two-tier centralization (!include + skinparam + <style>)
  ↓
Decision 1: Adopt two-tier strategy
Decision 2: Select 4 diagram types
Decision 3: Validate !include empirically
Decision 4: Clean Code naming conventions
  ↓
Implementation (Phase 1 Setup):
  - Create source/_static/plantuml-styles.puml
  - Create discover/test-plantuml-styles.md (test UC)
  - Validate Sphinx build
  - Create GUIDELINES.md (directrices para diagramadores)
  ↓
Expansion (Phase 10 onward):
  - Scale to 5 UC críticos
  - Scale to 100+ diagramas
  - Add State Diagrams in Phase 7
  - Document learnings in Phase 11 TRACK
```

---

## Evidencia de Respaldo

| Claim | Tipo | Fuente | Confianza | Origen |
|-------|------|--------|-----------|--------|
| PlantUML 1.2025.0 soporta !include, skinparam, `<style>` blocks | PROVEN | 19 análisis especializados (Phase 1 DISCOVER) | Alta | Nuevo (WP Phase 1) |
| skinparam es context-dependent (UC ≠ Sequence ≠ Activity) | PROVEN | plantuml-reference-language-analysis.md + plantuml-sequence-formatting-activation-analysis.md | Alta | Nuevo (WP Phase 1) |
| !include tiene confidence 0.85 (soporte histórico, no validado empíricamente) | INFERRED | Phase 1 DISCOVER: "!include as critical cornerstone (confidence 0.85; must validate working directory in Phase 1 Setup)" | Media | Heredado (Phase 1 synthesis) |
| UC Diagrams son CRITICAL para requisitos funcionales | PROVEN | plantuml-use-case-diagrams-analysis.md + discover synthesis | Alta | Nuevo (WP Phase 1) |
| Sequence Diagrams son IMPORTANT | PROVEN | plantuml-sequence-formatting-activation-analysis.md + plantuml-advanced-sequence-features-analysis.md | Alta | Nuevo (WP Phase 1) |
| Activity Diagrams NEW SYNTAX v6 es RECOMMENDED | PROVEN | plantuml-activity-diagrams-new-syntax-analysis.md (830+ líneas) | Alta | Nuevo (WP Phase 1) |
| Network, Timing, Component Diagrams son NOT APPLICABLE | PROVEN | plantuml-network-diagrams-analysis.md + plantuml-timing-diagrams-analysis.md + plantuml-component-diagrams-analysis.md | Alta | Nuevo (WP Phase 1) |
| Two-tier strategy es viable sin herramientas externas | INFERRED | PlantUML documentation + Phase 1 findings (no constraints técnicas encontradas) | Alta | Nuevo (Phase 5 Strategy) |
| Sphinx sphinxcontrib-plantuml renderiza correctamente | INFERRED | IACT-docs ya usa Sphinx + sphinxcontrib-plantuml (evidencia histórica) | Media | Externo (IACT-docs config) |

**Todos los claims son PROVEN o INFERRED. Ninguno SPECULATIVE. Gate Phase 5→6 puede aprobarse sin blockers.**

---

## Validation Checklist

- [x] Key ideas clearly articulated (4 ideas: centralization, classification, validation, naming)
- [x] Fundamental decisions documented (4 decisiones con alternativas y justificaciones)
- [x] Alternatives considered for each decision (A, B, C opciones evaluadas)
- [x] Clear justifications (références a Phase 1 analysis)
- [x] Technology stack complete (PlantUML, Sphinx, Java, Python, Git)
- [x] Architecture patterns explained (!include, skinparam hierarchy, `<style>` blocks)
- [x] Quality goals addressed (5 quality goals con mechanisms y metrics)
- [x] Constraints respected (5 constraints con respuestas)
- [x] Traceable to Phase 1 DISCOVER (7+ findings mapeados a decisiones)
- [x] Clear guidance for Phase 6 PLAN (fase de planificación next)
- [x] Evidence section con ≥3 claims clasificados (8 claims total, 6 PROVEN + 2 INFERRED)

---

## Siguiente Paso

Una vez aprobada PHASE 5: SOLUTION_STRATEGY → Pasar a PHASE 6: PLAN (definir scope explícito de Phase 1 Setup)

