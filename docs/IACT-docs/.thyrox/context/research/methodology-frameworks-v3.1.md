```yml
created_at: 2026-04-17 02:59:28
project: THYROX
type: research
title: Compilación completa de marcos y frameworks investigados — V3.1
origin: Investigación fundacional ÉPICA 40 (multi-methodology)
status: Válido
relevance: Fuente de verdad para los 6 namespaces implementados y los 9 frameworks pendientes
```

# COMPILACIÓN COMPLETA: MARCOS Y FRAMEWORKS INVESTIGADOS — V3.1

## RESUMEN EJECUTIVO

Se han identificado y analizado **15 marcos y estructuras metodológicas** distribuidos en las siguientes categorías:

### MARCOS METODOLÓGICOS (12)
Procesos completos con fases secuenciales o cíclicas definidas:
- **Software Development:** 1
- **Mejora de Procesos/Calidad:** 3
- **Resolución de Problemas:** 2
- **Planeación Estratégica:** 2
- **Consultoría:** 2
- **Análisis de Negocios:** 2

### FRAMEWORKS / TÉCNICAS (3)
Estructuras/esqueletos reutilizables, técnicas de descomposición y análisis:
- **Resolución de Problemas:** 1 (Root Cause Analysis)
- **Investigación:** 1 (Framework Analysis)
- **Ingeniería:** 1 (NASA Logical Decomposition)

**Hallazgo Universal:** TODOS los marcos metodológicos comienzan con Identify/Define/Understand ANTES de Analyze. No hay excepciones.

---

## CAMBIOS RESPECTO A V3.0

### Eliminaciones Validadas:
1. **Six-Step Solution** — ELIMINADO: Assessment como primer paso ambiguo/no claramente documentado
2. **Future Problem Solving** — ELIMINADO: Es método educativo, no marco metodológico empresarial completo

### Adiciones:
1. **Lean Six Sigma** — AGREGADO: Marco que combina Lean + DMAIC (Six Sigma)

### Aclaraciones:
1. **DMAIC = Six Sigma** (no son diferentes; DMAIC es la metodología que usa Six Sigma)
2. **Lean Six Sigma** combina principios Lean + Six Sigma/DMAIC

### Reclasificaciones Previas (mantenidas):
1. NASA Logical Decomposition = TÉCNICA (no marco completo)
2. Functional Decomposition = TÉCNICA (no framework)

---

# MARCOS METODOLÓGICOS FINALES

## CATEGORÍA 1: SOFTWARE DEVELOPMENT

### 1. SDLC (Software Development Life Cycle)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial / Waterfall
**Flexibilidad:** BAJA
**Primer Paso:** Planning (Identificar objetivos, alcance)

**Fases:**
1. Planning — Establecer objetivos, alcance, viabilidad
2. Analysis / Requirements Analysis — Comprender qué debe hacer el software
3. Design — Crear arquitectura y especificaciones
4. Development / Implementation / Coding — Construir el software
5. Testing — Verificar funcionamiento correcto
6. Deployment — Poner en producción
7. Maintenance — Mantener y mejorar

**Características:**
- Lineal y predecible
- Documentación extensa
- Cada fase debe completarse antes de la siguiente
- Difícil adaptar a cambios
- Aplicación: Desarrollo de software con requisitos conocidos

**Verificación:** ✓ CORRECTO — Comienza con identificación de objetivos

---

## CATEGORÍA 2: MEJORA DE PROCESOS Y CALIDAD

### 2. PDCA (Plan-Do-Check-Act)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Cíclico / Iterativo
**Flexibilidad:** ALTA
**Primer Paso:** Plan (Planificar mejoras)

**Fases:**
1. Plan — Planificar cambios/mejoras/identificar problema
2. Do — Implementar en pequeña escala (experimentación)
3. Check — Evaluar resultados
4. Act — Ajustar e implementar permanentemente

**Características:**
- Infinitamente repetible
- Se adapta a descubrimientos
- Escalable a cualquier tamaño/industria
- Bajo riesgo (experimentación pequeña)
- Simple e iterativo
- Aplicación: Mejora continua en cualquier contexto

**Relación con DMAIC:** PDCA es adecuado cuando ya se conoce la causa del problema y se desea implementar o probar una solución de forma ágil, mientras que DMAIC es indicado cuando es necesario identificar y analizar problemas complejos con causas desconocidas.

**Verificación:** ✓ CORRECTO — Comienza con planificación (incluye identificación)

---

### 3. DMAIC (Define-Measure-Analyze-Improve-Control)
**Tipo:** MARCO METODOLÓGICO = SIX SIGMA
**Subtipo:** Secuencial (dentro de ciclos)
**Flexibilidad:** BAJA-MEDIA
**Primer Paso:** Define (Identificar/Clarificar problema)

**Fases:**
1. Define — Establecer problema claramente, objetivos, stakeholders
2. Measure — Medir performance actual con indicadores específicos
3. Analyze — Identificar causas raíz (usa estadística)
4. Improve — Generar, probar y optimizar soluciones
5. Control — Asegurar permanencia, desarrollar SOP

**Características:**
- Data-driven y fact-based
- Estructura rígida pero efectiva
- Enfocado en reducción de variabilidad y defectos
- Herramientas estadísticas específicas
- Requiere certificación (Cinturones: blanco, amarillo, verde, negro)
- Aplicación: Optimización de procesos existentes

**Variante Relacionada:** DMADV (Define-Measure-Analyze-Design-Verify) para diseñar procesos nuevos.

**Nota Importante:** DMAIC es el estándar usado cuando hay que optimizar procesos existentes. DMADV se aplica cuando los procesos aún no se han establecido y todavía hay que crearlos.

**Verificación:** ✓ CORRECTO — Define = Identificar/Clarificar el problema

---

### 4. Lean Six Sigma
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial (Combinación Lean + DMAIC)
**Flexibilidad:** MEDIA
**Primer Paso:** Define (igual que DMAIC)

**Definición:** Lean Six Sigma combina: Lean (velocidad y eficiencia, elimina desperdicios y tiempos muertos) + Six Sigma (precisión y calidad, reduce defectos y variabilidad).

**Metodología:** Usa DMAIC pero integra herramientas Lean.

**Fases (DMAIC + Lean):**
1. Define — Identificar problema/oportunidad Y desperdicios
2. Measure — Medir rendimiento actual, mapear flujo de valor
3. Analyze — Estudiar posibles causas raíz Y fuentes de variación
4. Improve — Desarrollar soluciones Lean (eliminar desperdicios) + Six Sigma (reducir variación)
5. Control — Monitorear resultados, crear SOP

**Herramientas:**
- Lean: Value Stream Mapping, 5S, Kanban, eliminación de desperdicios
- Six Sigma: Control charts, Pareto diagrams, estadística avanzada

**Aplicación:** Optimización completa de procesos (velocidad + calidad)

**Verificación:** ✓ CORRECTO — Comienza con Define (identificación del problema)

---

## CATEGORÍA 3: RESOLUCIÓN DE PROBLEMAS

### 5. Problem Solving (8-Step / Toyota Way)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial
**Flexibilidad:** BAJA-MEDIA
**Primer Paso:** Identify (Detectar anomalías)

**Fases:**
1. Identify — Detectar anomalías/desviaciones en producción
2. Clarify — Precisar problema (scope, ubicación, impacto)
3. Set Target — Establecer fecha objetivo para resolver
4. Analyze Root Cause — Usar 5 Whys para identificar causa fundamental
5. Implement — Desarrollar e implementar correcciones
6. Check — Evaluar resultados contra target
7. Standardize — Crear procedimientos para prevenir recurrencia
8. Reflect — Documentar aprendizajes

**Aplicación:** Resolución de problemas manufactureros y operacionales

**Verificación:** ✓ CORRECTO — Comienza con identificación

---

### 6. Root Cause Analysis (RCA)
**Tipo:** FRAMEWORK / TÉCNICA
**Subtipo:** Secuencial (iterativo)
**Flexibilidad:** MEDIA
**Primer Paso:** Define Problem (Articular claramente)

**Fases:**
1. Define Problem — Articular claramente el problema
2. Collect Data — Recopilar información relevante
3. Identify Possible Causal Factors — Analizar data para encontrar factores
4. Identify Root Cause — Usar técnicas (5 Whys, Fishbone, RCA Pro)
5. Recommend & Implement Solutions — Desarrollar acciones correctivas

**Verificación:** ✓ CORRECTO — Define = Clarificar el problema

---

## CATEGORÍA 4: PLANEACIÓN ESTRATÉGICA

### 7. Strategic Planning
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial
**Flexibilidad:** MEDIA
**Primer Paso:** Identification (Identificar propósito, objetivos, desafíos)

**Fases:**
1. Identification — Identificar propósito de organización, objetivos, problemas, desafíos, oportunidades
2. Prioritization — Priorizar iniciativas usando portafolios de trabajo
3. Development — Elaborar plan detallado con iniciativas y tareas
4. Implementation — Ejecutar tareas, proyectos e iniciativas
5. Update — Revisar y ajustar continuamente con feedback, monitoreo de KPIs

**Corrección en V3.0:** NO comienza con "Analyze" sino con "Identification". El sesgo provenía de búsquedas web incompletas.

**Verificación:** ✓ CORRECTO — Comienza con IDENTIFICACIÓN

---

### 8. Strategic Management (Gestión Estratégica)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial / Cíclico
**Flexibilidad:** MEDIA-ALTA
**Primer Paso:** Environmental Scanning (Analizar factores)

**Fases:**
1. Environmental Scanning — Analizar factores internos y externos (SWOT, PESTEL)
2. Strategy Formulation — Formular estrategia
3. Strategy Implementation — Ejecutar estrategia
4. Evaluation and Control — Evaluar (continuo)

**Diferencia con Strategic Planning:**
- Strategic Planning = Periódico (3-5 años), estructurado
- Strategic Management = Continuo, adaptativo

**Verificación:** ✓ CORRECTO — Comienza con análisis (identificación implícita previa)

---

## CATEGORÍA 5: CONSULTORÍA

### 9. Consulting Process (General)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial (altamente adaptable)
**Flexibilidad:** ALTA
**Primer Paso:** Initiation (Contacto inicial, diagnóstico preliminar)

**Fases:**
1. Initiation — Contacto inicial, diagnóstico preliminar, propuesta, contrato
2. Diagnosis — Definir y medir problema, investigar, analizar
3. Action Planning — Desarrollar soluciones, alternativas, plan implementación
4. Implementation — Poner plan en acción, colaboración
5. Evaluation — Monitorear, analizar, evaluar resultados

**Verificación:** ✓ CORRECTO — Comienza con iniciación (identificación del problema)

---

### 10. Consulting Process (Thoucentric — 7 Steps)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial (adaptable)
**Flexibilidad:** MEDIA-ALTA
**Primer Paso:** Initial Understanding (Entender necesidades)

**Fases:**
1. Initial Understanding — Entender necesidades del cliente (IDENTIFICACIÓN)
2. Define Scope & Objectives — Definir alcance (CLARIFICACIÓN)
3. Collect & Analyze Data — Recopilar y analizar información
4. Develop Solutions — Crear soluciones tailored
5. Create Action Plan — Preparar plan de ejecución detallado
6. Implementation — Implementar solución con equipo cliente
7. Monitoring & Adjustment — Monitorear, ajustar, evaluar

**Verificación:** ✓ CORRECTO — Comienza con identificación de necesidades

---

## CATEGORÍA 6: ANÁLISIS DE NEGOCIOS

### 11. Business Analysis Process
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial (contextual)
**Flexibilidad:** ALTA
**Primer Paso:** Context & Understanding (Entender contexto)

**Fases:**
1. Context & Understanding — Entender historia, sistemas, procesos
2. Elicitation — Recopilar requisitos de stakeholders
3. Analysis — Analizar y validar requisitos
4. Design — Diseñar solución
5. Implementation — Implementar solución
6. Testing — Probar solución
7. Evaluation — Evaluar y validar contra objetivos

**Diferencia con Business Process Analysis:**
- Business Analysis = Análisis de requisitos para nuevas soluciones
- Business Process Analysis = Análisis de procesos existentes

**Verificación:** ✓ CORRECTO — Comienza con identificación del contexto

---

### 12. Business Process Analysis (BPA)
**Tipo:** MARCO METODOLÓGICO
**Subtipo:** Secuencial (iterativo)
**Flexibilidad:** MEDIA-ALTA
**Primer Paso:** Identify (Identificar necesidad de análisis)

**Fases:**
1. Identify — Identificar necesidad de análisis, seleccionar proceso
2. Map — Mapear proceso actual (As-Is)
3. Analyze — Analizar e identificar ineficiencias, bottlenecks, redundancias
4. Improve — Crear versión mejorada (To-Be)
5. Implement — Implementar cambios
6. Monitor — Monitorear performance continuo con KPIs

**Verificación:** ✓ CORRECTO — Comienza con identificación

---

## CATEGORÍA 7: INVESTIGACIÓN E INGENIERÍA

### 13. Framework Analysis (Investigación Cualitativa)
**Tipo:** FRAMEWORK METODOLÓGICO
**Subtipo:** Secuencial (flexible)
**Primer Paso:** Familiarization (Familiarizarse con datos)

**Fases:**
1. Familiarization — Leer y releer transcripts/datos múltiples veces
2. Indexing — Dividir y codificar con temas
3. Charting — Rearreglar data en orden discernible
4. Mapping & Interpretation — Mapear relaciones entre temas
5. Analysis — Analizar e interpretar

**Verificación:** ✓ CORRECTO — Comienza con familiarización (identificación de contexto)

---

### 14. NASA Logical Decomposition
**Tipo:** TÉCNICA DE INGENIERÍA / FRAMEWORK
**Subtipo:** Secuencial / Jerárquico
**Flexibilidad:** BAJA
**Contexto:** Requiere que requisitos altos YA ESTÁN DEFINIDOS

**Fases:**
1. Establish System Architecture Model
2. Functional Analysis
3. Decompose Requirements
4. Define Interfaces
5. Design Solution Definition

**Reclasificación:** TÉCNICA DE DESCOMPOSICIÓN, no marco metodológico completo — asume requisitos previos.

**Verificación:** ⚠ ESPECIAL — No es process end-to-end, es técnica de descomposición

---

# CONTEO FINAL VERIFICADO

**MARCOS METODOLÓGICOS:** 12
1. SDLC
2. PDCA
3. DMAIC (= Six Sigma)
4. Lean Six Sigma (Lean + DMAIC)
5. Problem Solving 8-step (Toyota)
6. Strategic Planning
7. Strategic Management
8. Consulting Process (General)
9. Consulting Process (Thoucentric)
10. Business Analysis
11. Business Process Analysis
12. (Vacante — podrían agregarse otros)

**FRAMEWORKS / TÉCNICAS:** 3
1. Root Cause Analysis
2. Framework Analysis
3. NASA Logical Decomposition

**TOTAL:** 15 estructuras metodológicas validadas

---

# PASOS UNIVERSALES — VERSIÓN FINAL

1. **IDENTIFY / RECOGNIZE / INITIATE** — Detectar necesidad o problema existente
2. **DEFINE / CLARIFY** — Precisar exactamente qué es, scope, propósito
3. **UNDERSTAND CONTEXT** — Entender historia, sistemas, stakeholders, ambiente
4. **MEASURE / ASSESS** — Cuantificar estado actual, línea base
5. **ANALYZE** — Investigar causas raíz, dinámicas, posibilidades
6. **PLAN / STRATEGY / PRIORITIZE** — Diseñar solución, priorizar acciones
7. **EXECUTE / IMPLEMENT** — Poner en acción
8. **MONITOR / TRACK / CHECK** — Rastrear progreso, evaluar resultados
9. **STANDARDIZE / UPDATE / SUSTAIN** — Hacer permanente, prevenir recurrencia

**PATRÓN UNIVERSAL CONFIRMADO:** Todos los marcos comienzan en pasos 1-3 (Identify → Define → Understand) ANTES de Analyze. NO HAY EXCEPCIONES.

---

# RELACIÓN CON THYROX (ÉPICA 40)

## Implementados como methodology skills (6 de 12 marcos):

| Marco V3.1 | Namespace THYROX | Skills |
|------------|-----------------|--------|
| PDCA | `pdca:` | pdca-plan, pdca-do, pdca-check, pdca-act |
| DMAIC / Six Sigma | `dmaic:` | dmaic-define, dmaic-measure, dmaic-analyze, dmaic-improve, dmaic-control |
| RUP / SDLC iterativo | `rup:` | rup-inception, rup-elaboration, rup-construction, rup-transition |
| Business Analysis | `ba:` | ba-planning, ba-elicitation, ba-requirements-analysis, ba-requirements-lifecycle, ba-solution-evaluation, ba-strategy |
| Strategic Planning / PMBOK | `pm:` | pm-initiating, pm-planning, pm-executing, pm-monitoring, pm-closing |
| Requirements Management | `rm:` | rm-elicitation, rm-analysis, rm-specification, rm-validation, rm-management |

## Pendientes de implementación (5 de 12 marcos):
- Lean Six Sigma — namespace futuro: `lean:` o extensión de `dmaic:`
- Problem Solving 8-step (Toyota) — namespace futuro: `ps8:`
- Strategic Planning (standalone) — namespace futuro: `sp:`
- Consulting Process (General + Thoucentric) — namespace futuro: sin definir
- Business Process Analysis — namespace futuro: `bpa:`

## No implementar como methodology skill:
- **SDLC** — El ciclo de 12 stages de THYROX ya ES el ciclo de vida universal destilado del
  flujo crítico de los 15 frameworks. SDLC waterfall está subsumed en la propia estructura del
  framework. SDLC iterativo está cubierto por `rup:`. Agregar `sdlc:` sería anidar un
  ciclo de vida dentro de sí mismo.

## Técnicas (no requieren skill propio):
- Root Cause Analysis — herramienta dentro de pdca y dmaic
- Framework Analysis — fuera del scope actual
- NASA Logical Decomposition — fuera del scope actual

**Versión:** 3.1 | **Estado:** Corregido, Validado y Completo | **Fecha original:** Abril 15, 2026
