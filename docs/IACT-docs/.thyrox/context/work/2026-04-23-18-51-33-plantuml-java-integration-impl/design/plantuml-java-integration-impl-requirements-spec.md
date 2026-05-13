```yml
created_at: 2026-04-25 10:30:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 7 — DESIGN/SPECIFY
author: NestorMonroy
status: En Revisión
version: 1.0.0
```

# Especificación de Requisitos Técnicos — PlantUML Centralized Styling Phase 1 Setup

## Resumen Ejecutivo

Phase 1 Setup implementa un sistema centralizado para la gestión de estilos PlantUML en IACT-docs, resolviendo inconsistencia visual y alto esfuerzo de mantenimiento. El trabajo se estructura alrededor de 5 componentes interconectados: (1) diseño de un sistema de colores corporativo con variantes T1-T4, (2) implementación de un archivo central `plantuml-styles.puml` con skinparam globales y específicos por tipo de diagrama, (3) validación empírica mediante suite de pruebas, (4) integración con Sphinx y validación de path resolution, (5) documentación de directrices de uso.

**Objetivo:** Establecer fundación técnica para escalar de 2 diagramas de prueba a 100+ diagramas funcionales con estilos corporativos automáticamente heredados, usando patrón TEAMS validado en producción (15+ diagramas, 4+ años sin fricción).

---

## Mapeo PLAN → Especificación

| Componente PLAN | ID Spec | Descripción Técnica |
|-----------------|---------|-------------------|
| Color System Design | SPEC-001 | Definir paleta corporativa (5-6 colores base + T1-T4 variantes) |
| Central Style File | SPEC-002 | Implementar `source/_static/plantuml-styles.puml` (150-200 líneas) |
| Test Suite Creation | SPEC-003 | Crear test-plantuml-styles.puml, test-uc-diagram.md, test-component-diagram.md |
| Sphinx Build Validation | SPEC-004 | Validar `make html` genera PNG/SVG con estilos y path resolution correcto |
| GUIDELINES.md Documentation | SPEC-005 | Documentar paleta, POSIX _prefix convention, ejemplos, anti-patrones |

---

## SPEC-001: Color System Design

**ID:** SPEC-001  
**Requisito Origen:** Plan §1 "Color System Design"  
**Prioridad:** Critical  
**Estado:** Pendiente

### Descripción

Diseño de un sistema cromático corporativo para PlantUML que cubra variabilidad de contextos (diagramas Use Case, Sequence, Activity, Class) mediante paleta base de 5-6 colores principales con 4 variantes de intensidad (T1=lightest, T4=darkest) cada uno.

### Criterios de Aceptación

```
Given: Se requiere paleta corporativa para PlantUML
When: Analizar guía corporativa IACT (colores, brand guidelines)
Then: Definir 5-6 colores base (ej: blue, green, orange, red, purple)
  AND crear variantes T1-T4 para c/u (lightest → darkest)
  AND validar contraste con accessibility guidelines WCAG 2.1 AA

Given: Colores base han sido seleccionados
When: Documentar mapeo semántico (blue=actors, green=data, etc.)
Then: Crear tabla de referencia con valores HEX y RGB
  AND validar que variantes T1-T4 forman escala visual coherente
  AND confirmar que T4 (darkest) mantiene legibilidad en diagrama

Given: Paleta está definida
When: Comparar contra TEAMMATES color pattern
Then: Verificar compatibilidad con UI_COLOR, LOGIC_COLOR, MODEL_COLOR, STORAGE_COLOR
  AND documentar diferencias semánticas si las hay
```

### Consideraciones Técnicas

- PlantUML interpola colores en RGB — definir valores con precisión hex/decimal
- Variantes T1-T4 deben escalarse uniformemente (no perceptualmente — usar matemática linear en RGB)
- Colores must work en diagrama background blanco y gris corporativo
- Accessibility: AA contrast ratio (4.5:1) para text, 3:1 para gráficos decorativos
- TEAMMATES usa derivación matemática (T1=lightest, T4=darkest) — replicar enfoque

### Implementación

**Componentes Afectados:**
- `discover/GUIDELINES.md` (sección "Color Palette")
- `source/_static/plantuml-styles.puml` (sección "Color Definitions")

**Archivos a Crear:**
- `discover/color-palette.md` (documento de referencia de la paleta)

**Esfuerzo Estimado:** 0.5 horas  
**Complejidad:** Baja

### Validación

- [ ] Paleta definida en discover/color-palette.md con HEX + RGB
- [ ] Variantes T1-T4 generadas para c/color (20 valores totales)
- [ ] Valores validados contra accessibility checker (WCAG 2.1 AA)
- [ ] Mappeo semántico documentado (qué color = qué significa)
- [ ] TEAMMATES pattern review: colores compatibles con referencia externa

**Notas:** Color system blocks Phase 2 (SPEC-002) — NO comenzar hasta que SPEC-001 esté aprobado.

---

## SPEC-002: Central Style File Implementation

**ID:** SPEC-002  
**Requisito Origen:** Plan §2 "Central Style File: plantuml-styles.puml"  
**Prioridad:** Critical  
**Estado:** Pendiente

### Descripción

Implementación de `source/_static/plantuml-styles.puml`, archivo centralizado de 150-200 líneas que contiene: (1) global skinparam (BackgroundColor, Shadowing, DefaultTextAlignment), (2) context-specific skinparam por tipo de diagrama (Class, Actor, Sequence, Activity), (3) hide directives (footbox, members, circle), (4) color macro definitions usando `!define` con convención POSIX _prefix para parámetros privados.

### Criterios de Aceptación

```
Given: Color palette está aprobada (SPEC-001)
When: Crear archivo plantuml-styles.puml en source/_static/
Then: Archivo contiene estructura de secciones (Global, Class, Actor, Sequence, Activity)
  AND cada sección tiene comentarios explicativos
  AND archivo compila en PlantUML sin errores (0 syntax errors)

Given: Secciones globales están definidas
When: Configurar global skinparam
Then: BackgroundColor = corporativo white/light gray
  AND Shadowing = false (limpio, no sombreado)
  AND DefaultTextAlignment = left

Given: Color macros están definidos
When: Implementar !define macros con POSIX _prefix
Then: Parámetros privados ej: _coreCorporateBlue = #0066CC
  AND parámetros públicos ej: backgroundColor = _coreCorporateBlue
  AND documentación marca cuáles son private (prefijo _) vs public

Given: Context-specific skinparam están definidos
When: Configurar actor, class, sequence, activity, component sections
Then: Class { BackgroundColor, FontColor, BorderColor }
  AND Actor { BackgroundColor, FontColor }
  AND Sequence { ActorBackgroundColor, ParticipantBackgroundColor }
  AND Activity { BackgroundColor, BorderColor }
  AND Component { BackgroundColor, BorderColor, InterfaceBackgroundColor }

Given: Hide directives están definidos
When: Aplicar hide directives
Then: hide footbox (ocultar footer en sequence)
  AND hide members (ocultar miembros en class detail)
  AND hide circle (ocultar círculos de actores si aplica)
```

### Consideraciones Técnicas

- POSIX _prefix convention: privado (_var), público (var) — enforced vía ADR-plantuml-naming-conventions.md
- Skinparam heredable: valores globales aplican a todos los diagramas; context-specific overwrite
- Hide directives NO son estilísticos — son instrucciones de renderización PlantUML
- Sphinx sphinxcontrib-plantuml working directory = document root (source/) — paths relativos de test diagramas deben resolverse desde allí
- Archivo debe ser KISS (simple): 150-200 líneas max, sin macros complejas ni condicionales

### Implementación

**Componentes Afectados:**
- `source/_static/` (nuevo directorio si no existe)
- Sphinx build system (sphinxcontrib-plantuml)

**Archivos a Crear:**
- `source/_static/plantuml-styles.puml` (150-200 líneas)

**Estructura esperada:**
```
source/_static/plantuml-styles.puml
  ├── Comentario de cabecera (descripción, fecha)
  ├── Global skinparam section (10-15 líneas)
  ├── Color definitions (!define) section (20-30 líneas)
  ├── Use Case diagram skinparam (Class & Actor, 15-20 líneas)
  ├── Sequence diagram skinparam (15-20 líneas)
  ├── Activity diagram skinparam (15-20 líneas)
  ├── Component diagram skinparam (12-18 líneas)
  └── Hide directives (5-10 líneas)
```

**Esfuerzo Estimado:** 1 hora  
**Complejidad:** Media

### Validación

- [ ] Archivo compila en PlantUML CLI sin errores
- [ ] Cada sección comentada claramente
- [ ] POSIX _prefix convention aplicada (review ADR)
- [ ] Skinparam por tipo de diagrama completado (UC, Sequence, Activity, Component)
- [ ] Hide directives documentados
- [ ] Línea total ≤ 200
- [ ] Code review por arquitecto (checklist en ADR-plantuml-naming-conventions.md)

**Notas:** Bloqueador para SPEC-003 (test suite) — debe existir para !include.

---

## SPEC-003: Test Suite Creation

**ID:** SPEC-003  
**Requisito Origen:** Plan §3 "Test Suite for Empirical Validation"  
**Prioridad:** High  
**Estado:** Pendiente

### Descripción

Creación de suite de pruebas empírica para validar !include path resolution y correcta aplicación de estilos. Comprende 3 artefactos: (1) `discover/test-plantuml-styles.puml` versión simplificada del central para testing, (2) `discover/test-uc-diagram.md` diagrama de caso de uso que incluye el archivo central, (3) `discover/test-component-diagram.md` diagrama de componentes que incluye el archivo central.

### Criterios de Aceptación

```
Given: plantuml-styles.puml ha sido creado (SPEC-002)
When: Crear test-plantuml-styles.puml en discover/
Then: Archivo es versión simplificada del central (solo lo esencial)
  AND contiene 3-5 macros de color para testing
  AND compila sin errores en PlantUML CLI

Given: Test style file está creado
When: Crear test-uc-diagram.md en discover/
Then: Diagrama contiene 3-5 actores y 2-3 casos de uso
  AND primera línea del bloque PlantUML: !include ../../../_static/plantuml-styles.puml
  AND diagrama compila y genera PNG/SVG

Given: Test UC está creado
When: Crear test-component-diagram.md en discover/
Then: Diagrama contiene 3-5 componentes y relaciones
  AND usa !include ../../../_static/plantuml-styles.puml
  AND diagrama compila y genera PNG/SVG

Given: Ambos test diagramas existen
When: Validar path resolution
Then: Sphinx build resuelve path relativos correctamente
  AND PNG/SVG output contenga colores corporativos
  AND build log muestra 0 PlantUML errors
```

### Consideraciones Técnicas

- Path resolution: test diagramas en `discover/` incluyen desde `../../../_static/plantuml-styles.puml`
- Sphinx working directory = document root (source/) durante build
- !include ejecutado por sphinxcontrib-plantuml antes de PNG generation
- Archivos test deben ser minimal — no documentación, solo diagramas + !include
- Test UC y Component coverage ambos tipos de diagrama (requisito: 2 tipos para validation)

### Implementación

**Componentes Afectados:**
- `discover/` (nuevo contenido de test)
- Sphinx build system

**Archivos a Crear:**
- `discover/test-plantuml-styles.puml` (minimal style version, 10-15 líneas)
- `discover/test-uc-diagram.md` (3-5 actores, 2-3 UC)
- `discover/test-component-diagram.md` (3-5 componentes)

**Esfuerzo Estimado:** 1 hora  
**Complejidad:** Media

### Validación

- [ ] test-plantuml-styles.puml existe y compila
- [ ] test-uc-diagram.md contiene !include correcta
- [ ] test-component-diagram.md contiene !include correcta
- [ ] Ambos archivos compilan en PlantUML sin errores
- [ ] Paths relativos son correctos (tested via Sphinx build)

**Notas:** SPEC-003 depende de SPEC-002. Bloqueador para SPEC-004 (Sphinx validation).

---

## SPEC-004: Sphinx Build Validation

**ID:** SPEC-004  
**Requisito Origen:** Plan §4 "Sphinx Build Validation"  
**Prioridad:** Critical  
**Estado:** Pendiente

### Descripción

Validación de que el sistema Sphinx + sphinxcontrib-plantuml compile los diagramas test de SPEC-003 correctamente, resolviendo paths, generando PNG/SVG, y aplicando estilos corporativos. Criterios: `make html` sin errores PlantUML, PNG/SVG output contiene colores corporativos, build log limpio.

### Criterios de Aceptación

```
Given: Test suite ha sido creado (SPEC-003)
When: Ejecutar make html en raíz del proyecto
Then: Build completa sin errores PlantUML
  AND build log NO contiene líneas como "PlantUML Error" o "Error: invalid command"
  AND PNG/SVG generados en _build/html/discover/

Given: Build completó sin errores
When: Inspeccionar PNG/SVG output de test diagramas
Then: Imágenes contienen colores corporativos (verificar con color picker)
  AND estilos de actor/clase/componente aplicados (shapes, colores, texto)
  AND imagen legible y bien formada

Given: Sphinx build valida path resolution
When: Verificar que !include paths se resolvieron correctamente
Then: No hay errores de "file not found" en sphinxcontrib-plantuml
  AND PlantUML internals no reportan include failures
```

### Consideraciones Técnicas

- Sphinx working directory durante build = document root (IACT-docs/source/)
- Sphinxcontrib-plantuml ejecuta PlantUML como subprocess — stderr captura errores
- PNG/SVG output location: `_build/html/discover/` con mismo nombre base que .md source
- Path resolution depende de cómo sphinxcontrib-plantuml configura PlantUML working directory
- Si falla: verificar Sphinx conf.py tiene `extensions = ['sphinxcontrib.plantuml', ...]`

### Implementación

**Componentes Afectados:**
- Sphinx build system
- sphinxcontrib-plantuml configuration (conf.py)

**Archivos a Verificar:**
- `source/conf.py` (extensions list)
- `_build/html/discover/test-uc-diagram.svg`
- `_build/html/discover/test-component-diagram.svg`

**Esfuerzo Estimado:** 0.5 horas  
**Complejidad:** Baja (if SPEC-002 and SPEC-003 correct), Alta (if debugging needed)

### Validación

- [ ] `make html` ejecuta sin PlantUML errors
- [ ] Build log limpio (0 PlantUML error lines)
- [ ] PNG/SVG archivos existen en _build/html/discover/
- [ ] Imágenes contienen colores corporativos (visual inspection)
- [ ] Path resolution correcto (no "file not found" errors)

**Notas:** Si falla, root cause puede estar en: (1) path resolution (SPEC-003 paths incorrectos), (2) plantuml-styles.puml syntax (SPEC-002 error), (3) Sphinx config (extensions list).

---

## SPEC-005: GUIDELINES.md Documentation

**ID:** SPEC-005  
**Requisito Origen:** Plan §5 "Documentation: discover/GUIDELINES.md"  
**Prioridad:** High  
**Estado:** Pendiente

### Descripción

Documentación comprensiva de directrices de uso para diagrama (5 secciones): (1) Paleta corporativa con colores + variantes, (2) Convención POSIX _prefix explicada (privado vs public), (3) Ejemplos de inclusión y uso, (4) Best practices, (5) Anti-patrones. Objetivo: guía clara para que documentadores creen nuevos diagramas sin fricción.

### Criterios de Aceptación

```
Given: Color system está aprobado (SPEC-001)
When: Documentar paleta en GUIDELINES.md
Then: Sección "Color Palette" lista 5-6 colores con nombres, HEX, RGB
  AND lista variantes T1-T4 para c/u
  AND documenta cuándo usar cada variante (T1=highlight, T4=dark)

Given: POSIX _prefix convention está definida (ADR-plantuml-naming-conventions.md)
When: Explicar convención en GUIDELINES.md
Then: Sección clara: _prefix = privado (no usar en diagramas), sin _ = público
  AND ejemplos: _coreCorporateBlue (private), backgroundColor (public)
  AND regla: documentadores solo tocan parámetros sin _

Given: plantuml-styles.puml existe
When: Proporcionar ejemplos en GUIDELINES.md
Then: Ejemplo 1: cómo incluir el archivo (!include ../../../_static/plantuml-styles.puml)
  AND Ejemplo 2: cómo usar colores en diagrama (backgroundColor, etc.)
  AND Ejemplo 3: diagrama UC mínimo que cumpla con estilos

Given: Anti-patrones están identificados
When: Documentar qué NO hacer
Then: Anti-patrón 1: modificar plantuml-styles.puml per-diagram
  AND Anti-patrón 2: duplicar color definitions en cada diagrama
  AND Anti-patrón 3: usar valores hardcoded en lugar de macros
```

### Consideraciones Técnicas

- GUIDELINES.md es para documentadores — usar lenguaje claro, no técnico pesado
- Ejemplos deben ser copy-paste ready (código funcional)
- Referencia a TEAMMATES pattern: explicar que patrón está probado en producción
- Sección best practices: orden de ejecución (color → !include → diagrama)
- Ubicación: `discover/GUIDELINES.md` (mismo nivel que test diagramas)

### Implementación

**Componentes Afectados:**
- `discover/` (documentación para usuarios)

**Archivos a Crear:**
- `discover/GUIDELINES.md` (40-50 líneas)

**Estructura esperada:**
```
discover/GUIDELINES.md
  ├── Introducción (qué es el sistema, por qué)
  ├── Paleta Corporativa (tabla colores, HEX, RGB, variantes)
  ├── POSIX _prefix Convention (explicación + ejemplos)
  ├── Cómo Incluir (ejemplo: !include line)
  ├── Ejemplos (3-5 ejemplos mínimos)
  ├── Best Practices (order of execution, etc.)
  └── Anti-patrones (qué NO hacer)
```

**Esfuerzo Estimado:** 0.75 horas  
**Complejidad:** Baja

### Validación

- [ ] Sección Paleta documenta todos 5-6 colores + variantes
- [ ] Sección POSIX _prefix clara y con ejemplos
- [ ] Sección Ejemplos contiene 3-5 casos (UC, Sequence, etc.)
- [ ] Anti-patrones documentados (mínimo 3)
- [ ] Línea total 40-50 (conciso)
- [ ] Review por documentador (¿es comprensible?)

**Notas:** SPEC-005 bloquea Phase 10 EXECUTE (scalado a 5 UC críticos) — documentadores necesitan guía clara.

---

## Arquitectura Técnica

```
IACT-docs (Project Root)
│
├── source/                          ← Sphinx document root
│   ├── _static/                     ← Assets (NEW)
│   │   └── plantuml-styles.puml     ← Central style file (SPEC-002)
│   │
│   └── discover/                    ← Phase 1 DISCOVER docs + tests
│       ├── GUIDELINES.md            ← Usage guide (SPEC-005)
│       ├── color-palette.md         ← Color reference (SPEC-001)
│       ├── test-plantuml-styles.puml  ← Minimal style test (SPEC-003)
│       ├── test-uc-diagram.md       ← UC test with !include (SPEC-003)
│       └── test-component-diagram.md  ← Component test with !include (SPEC-003)
│
├── _build/
│   └── html/discover/               ← Build output (SPEC-004)
│       ├── test-uc-diagram.svg      ← Rendered with styles
│       └── test-component-diagram.svg  ← Rendered with styles
│
└── .thyrox/context/work/.../
    └── design/
        └── plantuml-java-integration-impl-requirements-spec.md ← This file
```

**Flujo de datos:**

```
SPEC-001 (Color Palette)
    ↓
SPEC-002 (plantuml-styles.puml)
    ↓
SPEC-003 (Test Suite with !include)
    ↓
SPEC-004 (Sphinx Build + Path Resolution)
    ↓
SPEC-005 (GUIDELINES.md Documentation)
```

---

## Dependencias Entre Requisitos

```
SPEC-001 (Color System) ─→ SPEC-002 (Style File)
SPEC-002 (Style File) ──→ SPEC-003 (Test Suite)
SPEC-003 (Test Suite) ──→ SPEC-004 (Sphinx Validation)
SPEC-001, SPEC-002, SPEC-003 ─→ SPEC-005 (GUIDELINES)
```

**Ruta crítica:** SPEC-001 → SPEC-002 → SPEC-003 → SPEC-004. SPEC-005 parallelizable.

---

## Plan de Implementación

### Fase 1: Foundation (Colores + Estilos)
- **SPEC-001:** Color System Design (0.5 horas)
- **SPEC-002:** Central Style File Implementation (1 hora)
- **Gate 1 Checkpoint:** Ambos archivos existentes, validados contra TEAMMATES pattern

### Fase 2: Validation (Testing + Build)
- **SPEC-003:** Test Suite Creation (1 hora)
- **SPEC-004:** Sphinx Build Validation (0.5 horas)
- **Gate 2 Checkpoint:** `make html` ejecuta sin errores, PNG/SVG contienen estilos

### Fase 3: Documentation (Guías de Uso)
- **SPEC-005:** GUIDELINES.md Documentation (0.75 horas)
- **Final Gate:** Documentadores pueden crear diagramas sin fricción

**Timeline total:** 4 horas (15 tareas atómicas en Phase 8 PLAN EXECUTION)

---

## Riesgos y Mitigaciones

| Riesgo | Impacto | Probabilidad | Mitigación |
|--------|---------|-------------|-----------|
| **!include path resolution fails** | ALTA | Media | Empirical test en SPEC-003 + SPEC-004. TEAMMATES proof-of-concept válida. Plan B: copiar estilos per-diagram |
| **sphinxcontrib-plantuml incompatible** | MEDIA | Baja | TEAMMATES usa MarkBind (diferente builder) con mismo patrón. Unlikely. Test en SPEC-004 |
| **Working directory resolution wrong** | MEDIA | Media | SPEC-003 test paths claros. SPEC-004 valida. Detectable en Phase 10 |
| **Color palette wrong** | BAJA | Baja | SPEC-001 valida contra corporate guidelines. Easy fix en plantuml-styles.puml |

---

## Glosario Técnico

- **Skinparam:** Parámetro PlantUML que controla apariencia (colores, fuentes, sombras)
- **!include:** Directiva PlantUML que carga archivo externo (ej: plantuml-styles.puml)
- **!define:** Macro PlantUML que define constante reutilizable (ej: _coreCorporateBlue)
- **POSIX _prefix:** Convención: _ = privado, sin _ = público (ADR-plantuml-naming-conventions.md)
- **T1-T4:** Variantes de intensidad de color (T1=lightest, T4=darkest)
- **Working directory:** Directorio desde el cual sphinxcontrib-plantuml resuelve paths relativos (= source/)
- **sphinxcontrib-plantuml:** Extensión Sphinx que renderiza diagramas PlantUML a PNG/SVG

---

## Aprobaciones

| Rol | Estado |
|-----|--------|
| **Arquitecto** | ⏳ Pendiente aprobación |
| **Tech Lead** | ⏳ Pendiente aprobación |
| **Product/Stakeholder** | ⏳ Pendiente aprobación |

---

**Versión:** 1.0.0  
**Creación:** 2026-04-25 10:30:00  
**Siguiente Revisión:** Después de Phase 7 approval gate
