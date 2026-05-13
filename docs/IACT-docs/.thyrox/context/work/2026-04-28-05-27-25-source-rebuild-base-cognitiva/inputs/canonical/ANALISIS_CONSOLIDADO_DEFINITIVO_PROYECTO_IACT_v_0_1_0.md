# ANÁLISIS CONSOLIDADO DEFINITIVO DEL PROYECTO IACT

**Análisis Integral de Documentación y Plan de Actualización**

**Fecha de Análisis:** 2026-01-08  
**Versión del Análisis:** 1.0.0  
**Estado:** COMPLETO - Pendiente Aprobación  
**Alcance:** PARTES 0-2C + CNST + UC v4.0 + Normativas

---

## RESUMEN EJECUTIVO

### Situación Actual del Proyecto

El proyecto IACT cuenta con una **base documental extensa pero desactualizada** que requiere una actualización integral para alinearse con:

1. **Dominio real:** Sistema de Análisis de Llamadas IVR (telecomunicaciones)
2. **RBAC v5.1.1:** 44 funciones atómicas en lugar de 18 roles
3. **Nomenclatura v2.0.0:** Versionado semántico obligatorio
4. **Casos de Uso v4.0.0:** 49 UC con nueva estructura
5. **Estándares:** Sin emojis, formato RST estricto

### Problema Principal Identificado

**🔴 CRÍTICO: Desconexión Triple**

```
PROBLEMA 1: Dominio Incorrecto
  PARTES 0-2C usan "Sistema de Gestión de Químicos"
  Proyecto real: Sistema de Análisis de Llamadas IVR
  Impacto: 150+ ocurrencias en PARTE 0, 100+ en PARTE 1, 50+ en PARTE 2
  
PROBLEMA 2: RBAC Obsoleto  
  CNST v1.0.0 usa roles fijos (R001-R018)
  Sistema actual: RBAC v5.1.1 con 44 funciones atómicas
  Impacto: 10 documentos CNST, 10,543 líneas totales
  
PROBLEMA 3: Sin Versionado Semántico
  Documentos actuales sin _MAJOR_MINOR_PATCH
  NOM_001 v2.0.0 requiere versionado obligatorio
  Impacto: ~60-80 archivos base_cognitiva/
```

### Magnitud del Trabajo

| Componente | Documentos | Palabras | Horas Estimadas | Prioridad |
|------------|-----------|----------|-----------------|-----------|
| PARTE 0 | 1 | 18,000 | 23h | 🔴 CRÍTICA |
| PARTE 1 | 1 | 15,000 | 16h | 🟠 ALTA |
| PARTE 2 (A+B+C) | 3 | 95,000 | 15h (revisión) | 🟡 MEDIA |
| CNST v1.1.0 | 11 | ~25,000 | 4-5h | 🟠 ALTA |
| UC v4.0.0 | 49 | ~25,000 | 4-5h | 🟠 ALTA |
| base_cognitiva/ | ~24 | 60,000 | 70h | 🟡 MEDIA |
| **TOTAL** | **~90** | **~238,000** | **~130h** | |

---

## PARTE 1: INVENTARIO COMPLETO DE DOCUMENTACIÓN

### 1.1 Material Pedagógico (PARTES 0-2C)

#### PARTE 0: Contexto y Fundamentos

**Archivo:** PARTE_0_CONTEXTO_FUNDAMENTOS.md  
**Estado:** Documento puente pedagógico  
**Tamaño:** 18,000 palabras (~40-50 páginas)  
**Fecha:** 2025-12-08  
**Problema:** 150+ ocurrencias de dominio químicos

**Estructura (7 secciones):**

```
PARTE 0: CONTEXTO Y FUNDAMENTOS
├── 1. El Problema (2,500 palabras)
│   ├── 1.1 El Síntoma
│   ├── 1.2 La Causa Raíz
│   ├── 1.3 Las Consecuencias
│   └── 1.4 Caso Ilustrativo ⭐ (UC-04 químicos, 26 menciones)
│
├── 2. La Solución (4,000 palabras) ⭐
│   ├── 2.1 Jerarquía de 4 Niveles (BR → BReq → UC → FR)
│   ├── 2.2 Nivel 0: Business Rules (BR-028, BR-087)
│   ├── 2.3 Nivel 1: Business Requirements
│   ├── 2.4 Nivel 2: User Requirements ⭐ (UC-04 completo, 8 pasos)
│   ├── 2.5 Nivel 3: Functional Requirements (RF-205, RF-206, RF-207)
│   ├── 2.6 Flujo de Influencia (Bidireccional)
│   └── 2.7 Diagrama Maestro
│
├── 3. Transformaciones Clave (3,500 palabras) ⭐⭐
│   ├── 3.1 BR → UC (Transformación Principal)
│   ├── 3.2 Los 5 Tipos de BR
│   ├── 3.3 Desencadenadores vs Inferencias ⭐ (BR-031 vs BR-046)
│   ├── 3.4 Trazabilidad Bidireccional
│   └── 3.5 Propagación de Cambios
│
├── 4. Alcance del Material (1,500 palabras)
│   └── Las 6 Partes documentadas
│
├── 5. Roadmap Detallado (5,000 palabras) ⭐⭐⭐
│   ├── 5.1 Flujo General
│   ├── 5.2 PARTE 1: Identificar BR
│   ├── 5.3 PARTE 2: Transformar BR → UC
│   ├── 5.4 PARTE 3: Identificar UC Adicionales
│   ├── 5.5 PARTE 4: Diagramar UML
│   ├── 5.6 PARTE 5: Especificar RNF
│   ├── 5.7 PARTE 6: Validar Trazabilidad
│   └── 5.8 Resumen Entregables (~120)
│
├── 6. Convenciones (1,000 palabras)
│   └── Nomenclatura BR/UC/FR
│
└── 7. Próximos Pasos (500 palabras)
    └── Comenzar con PARTE 1
```

**Ejemplos más usados:**
- BR-028 (Restricción): 23 ocurrencias → "Solicitudes >$500 requieren aprobación"
- UC-04 (Solicitar Químico): 26 ocurrencias → Ejemplo maestro con 8 pasos
- BR-031 (Desencadenador): 7 ocurrencias → "Notificar vencimiento 30 días antes"
- BR-046 (Inferencia): 4 ocurrencias → "Marcar químico caduco"

**Reescritura requerida:** 23 horas (~3 días)

---

#### PARTE 1: Identificar Reglas de Negocio

**Archivo:** PARTE_1_IDENTIFICAR_BR.md (estimado)  
**Estado:** Presumiblemente existe  
**Tamaño:** ~15,000 palabras (~60-70 páginas)  
**Problema:** ~100 ocurrencias de dominio químicos

**Estructura esperada (12 secciones):**

```
PARTE 1: IDENTIFICAR REGLAS DE NEGOCIO
├── 1. Introducción a Business Rules
│   ├── 1.1 ¿Qué es una BR?
│   ├── 1.2 Importancia en el Ciclo de Vida
│   └── 1.3 Objetivos de PARTE 1
│
├── 2. Fundamentos Conceptuales
│   ├── 2.1 Definición Formal (SBVR)
│   ├── 2.2 Características de BR bien definidas
│   └── 2.3 BR vs Requisitos Funcionales
│
├── 3. Fuentes de Business Rules
│   ├── 3.1 Documentos normativos
│   ├── 3.2 Entrevistas con stakeholders
│   ├── 3.3 Observación de procesos
│   └── 3.4 Sistemas legacy
│
├── 4. Taxonomía de BR ⭐ (CRÍTICA)
│   ├── 4.1 Tipo 1: HECHOS (Structural)
│   ├── 4.2 Tipo 2: RESTRICCIONES (Operative)
│   ├── 4.3 Tipo 3: DESENCADENADORES (ECA) ⭐⭐
│   ├── 4.4 Tipo 4: INFERENCIAS (Derivation)
│   └── 4.5 Tipo 5: CÁLCULOS (Computation)
│
├── 5. Desencadenadores vs Inferencias ⭐ (CRÍTICA)
│   ├── 5.1 Diferencia fundamental (observabilidad)
│   ├── 5.2 Test de observabilidad
│   ├── 5.3 Ejemplos contrastivos (BR-031 vs BR-046)
│   └── 5.4 Errores comunes
│
├── 6. Técnica de Elicitación
│   ├── 6.1 Preguntas estratégicas (6 preguntas)
│   ├── 6.2 Identificación en documentos
│   ├── 6.3 Extracción de entrevistas
│   └── 6.4 Validación con stakeholders
│
├── 7. Documentación de BR
│   ├── 7.1 Plantilla estándar
│   ├── 7.2 Atributos obligatorios
│   ├── 7.3 Metadatos recomendados
│   └── 7.4 Versionamiento
│
├── 8. Gestión de Business Rules
│   ├── 8.1 Repositorio central
│   ├── 8.2 Proceso de aprobación
│   ├── 8.3 Control de cambios
│   └── 8.4 Deprecación de BR
│
├── 9. Ciclo de Vida de BR
│   ├── 9.1 Identificación
│   ├── 9.2 Clasificación
│   ├── 9.3 Documentación
│   ├── 9.4 Validación
│   ├── 9.5 Implementación (→ PARTE 2)
│   └── 9.6 Mantenimiento
│
├── 10. Casos Especiales
│   ├── 10.1 BR conflictivas
│   ├── 10.2 BR temporales
│   ├── 10.3 BR condicionales complejas
│   └── 10.4 BR en sistemas legacy
│
├── 11. Ejercicios Prácticos
│   ├── Ejercicio 1: Identificar tipos de BR
│   ├── Ejercicio 2: Desencadenador vs Inferencia ⭐
│   ├── Ejercicio 3: Extraer BR de documento
│   ├── Ejercicio 4: Documentar BR completa
│   └── Ejercicio 5: Caso completo (hotel)
│
└── 12. Resumen y Transición
    ├── 12.1 Resumen de 5 tipos
    ├── 12.2 Checklist de completitud
    └── 12.3 Entrada a PARTE 2
```

**Mapeo a base_cognitiva/:**

```
PARTE 1 se distribuye en:

_fundamentos_conceptuales/
├── FND_02_Reglas_de_Negocio_1_0_0.rst
│   → Definición y características

_taxonomias_y_metamodelos/taxonomias/
└── TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst ⭐
    → 5 tipos con ejemplos
    → Desencadenador vs Inferencia

_ontologia_sbvr/
├── SBVR_01_Conceptos_Nucleares_1_0_0.rst
├── SBVR_02_Fact_Types_1_0_0.rst (Hechos)
├── SBVR_03_Reglas_Estructurales_1_0_0.rst (Restricciones)
├── SBVR_04_Reglas_Operativas_1_0_0.rst (Desenc/Inf/Calc)
└── SBVR_05_Vocabulario_Controlado_1_0_0.rst
```

**Probabilidad de ejemplos químicos:** 95% (ALTA)

**Reescritura requerida:** 16 horas (~2 días)

---

#### PARTE 2A: Fundamentos de Transformación

**Archivo:** PARTE_2A_FUNDAMENTOS_IACT.md  
**Estado:** ✅ COMPLETO  
**Tamaño:** 142 KB (~75 páginas, ~37,000 palabras)  
**Fecha:** 2026-01-08  
**Problema:** Mezcla dominio químicos + IACT

**Contenido entregado (3 secciones):**

```
PARTE 2A: FUNDAMENTOS DE TRANSFORMACIÓN
├── Sección 1: Introducción (5,000 palabras)
│   ├── Entrada desde PARTE 1 (45 BR clasificadas)
│   ├── Objetivo central: ¿Cómo transformar BR en UC y FR?
│   ├── Entregables esperados
│   └── Decisión crítica: ¿Qué genera cada tipo de BR?
│
├── Sección 2: Fundamentos de Casos de Uso (12,000 palabras)
│   ├── Definición formal de UC (6 características)
│   ├── 12 componentes de un UC (7 obligatorios + 5 opcionales)
│   ├── UC-IACT-04 completo ⭐ (ejemplo recurrente, integra 5 BR)
│   ├── Taxonomía de actores (Primario, Secundario, Sistema, Tiempo)
│   ├── Plantilla de decisión para identificar actores
│   └── Flujo Normal vs 4 tipos de Flujos Alternos
│
└── Sección 3: Los 5 Patrones de Transformación ⭐⭐⭐ (20,000 palabras)
    ├── Patrón 1: HECHOS → Modelo de Dominio
    │   └── Ejemplo: BR-IACT-012 (code_slug único)
    │
    ├── Patrón 2: RESTRICCIONES → Precondiciones/Validaciones/FA
    │   ├── Ejemplo: BR-IACT-087 (nivel seguridad 3)
    │   └── Ejemplo: BR-IACT-028 (aprobación si >10 usuarios)
    │
    ├── Patrón 3: DESENCADENADORES → UC Completos ⭐⭐⭐
    │   ├── ÚNICO patrón que genera UC independientes
    │   ├── Ejemplo central: BR-IACT-031 → UC-IACT-07
    │   ├── UC completo con 10 pasos + 6 FA
    │   ├── Test de observabilidad
    │   └── 9 FR derivados (FR-301 a FR-309)
    │
    ├── Patrón 4: INFERENCIAS → FR Directo (Sin UC)
    │   ├── Ejemplo: BR-IACT-046 (marcar sesión EXPIRADA)
    │   ├── Cambio interno NO observable
    │   ├── FR-305 directo con UPDATE SQL
    │   └── Diferencia crítica con Desencadenadores
    │
    └── Patrón 5: CÁLCULOS → Integración en Pasos
        ├── Ejemplo: BR-IACT-060 (score de riesgo)
        ├── Se integra como paso 6 en UC-IACT-04
        ├── FR-601 con fórmula completa
        └── Problema detectado en fórmula + solución
```

**Estado:** Mezclado - Tiene ejemplos IACT pero referencias a químicos

**Acción:** Revisión (15% del contenido) - 5 horas

---

#### PARTE 2B: Construcción Detallada

**Archivo:** PARTE_2B_CONSTRUCCION_IACT.md  
**Estado:** ✅ COMPLETO  
**Tamaño:** 156 KB (~80 páginas, ~40,000 palabras)  
**Fecha:** 2026-01-08  

**Contenido entregado (Secciones 4-7):**

```
PARTE 2B: CONSTRUCCIÓN DETALLADA
├── Sección 4: Construcción de UC (15,000 palabras)
│   ├── 4.1 Proceso de 7 Pasos ⭐
│   │   ├── Paso 1: Identificar BR Desencadenador
│   │   ├── Paso 2: Identificar Actor Primario (3 preguntas)
│   │   ├── Paso 3: Definir Objetivo del UC
│   │   ├── Paso 4: Construir Precondiciones (4 categorías)
│   │   ├── Paso 5: Construir Flujo Normal (5 fases)
│   │   ├── Paso 6: Construir Flujos Alternos (5 patrones)
│   │   └── Paso 7: Definir Postcondiciones
│   │
│   ├── 4.2 Ejemplo Completo: UC-IACT-07 (10 páginas)
│   │   ├── 11 pasos flujo normal
│   │   ├── 6 flujos alternos
│   │   ├── 24 postcondiciones
│   │   └── Query SQL con índices
│   │
│   └── 4.3 Checklist de Calidad (8 puntos)
│
├── Sección 5: Integración Multi-BR (10,000 palabras)
│   ├── 5.1 Cuando múltiples BR afectan un UC
│   ├── 5.2 Priorización de BR
│   ├── 5.3 Resolución de conflictos
│   └── 5.4 Ejemplo: UC-IACT-04 con 5 BR
│       ├── BR-IACT-012 (code_slug)
│       ├── BR-IACT-028 (aprobación)
│       ├── BR-IACT-060 (score riesgo)
│       ├── BR-IACT-072 (usuario activo)
│       └── BR-IACT-087 (nivel seguridad)
│
├── Sección 6: Derivación de FR (10,000 palabras)
│   ├── 6.1 ¿Qué es un FR?
│   ├── 6.2 Granularidad de FR (3 niveles)
│   ├── 6.3 Proceso de Derivación (4 pasos)
│   ├── 6.4 Plantilla de FR (10 componentes) ⭐
│   └── 6.5 Ejemplos Completos
│       ├── FR-301 (Query sesiones)
│       ├── FR-401 (Validación nivel)
│       └── FR-601 (Cálculo score)
│
└── Sección 7: Trazabilidad (5,000 palabras)
    ├── 7.1 Trazabilidad Forward (BR → FR)
    ├── 7.2 Trazabilidad Backward (FR → BR)
    ├── 7.3 Requirements Traceability Matrix (RTM)
    ├── 7.4 Herramientas (PlantUML, Sphinx)
    └── 7.5 Ejemplo Completo: Cadena BR-031 → UC-07 → FR-305
```

**Estado:** Casi completo - Necesita revisión menor (10% del contenido) - 3 horas

---

#### PARTE 2C: Casos Especiales y Validación

**Archivo:** PARTE_2C_CASOS_ESPECIALES_IACT.md  
**Estado:** ✅ COMPLETO  
**Tamaño:** 114 KB (~60 páginas, ~30,000 palabras)  
**Fecha:** 2026-01-08  

**Contenido entregado (Secciones 8-11):**

```
PARTE 2C: CASOS ESPECIALES Y VALIDACIÓN
├── Sección 8: Casos Especiales (15,000 palabras)
│   ├── 8.1 CRUD UC
│   │   ├── Decisión: Documentar completo vs simplificado
│   │   └── Ejemplo: UC-IACT-15 (Register Function, 9 pasos, 5 FA)
│   │
│   ├── 8.2 System Constraints
│   │   ├── 6 CNST globales IACT (CNST-001 a CNST-009)
│   │   ├── CNST-001 (No emails) impacta todos UC notificación
│   │   └── Ejemplo: UC-IACT-09 modificado con buzón interno
│   │
│   ├── 8.3 Multiple Primary Actors
│   │   ├── Criterios: Un UC vs varios UC
│   │   └── Ejemplo: UC-IACT-18 (Query History) con 2 actores
│   │
│   ├── 8.4 UC Variants
│   │   ├── Criterios: Variante vs FA vs UC separado
│   │   └── Ejemplo: UC-IACT-04 con 3 variantes
│   │       ├── Variant A: Asignación individual (60%, 30s)
│   │       ├── Variant B: Asignación múltiple (30%, 1-2 min)
│   │       └── Variant C: Asignación masiva (10%, 3-10 min)
│   │
│   └── 8.5 Concurrency and Race Conditions
│       ├── 3 tipos: Dirty Read, Lost Update, Race Condition
│       ├── Ejemplo: UC-IACT-21 (Modify User) con optimistic locking
│       └── Prevention: Lock timeout, "who is editing"
│
├── Sección 9: Validación de UC (12,000 palabras)
│   ├── 9.1 Quality Checklist (26 puntos) ⭐
│   │   ├── 8 Completitud
│   │   ├── 6 Claridad
│   │   ├── 4 Trazabilidad
│   │   ├── 4 Técnica
│   │   └── 4 Negocio
│   │
│   ├── 9.2 Peer Review (5 fases)
│   │   ├── Self-review
│   │   ├── Technical review (30-45 min)
│   │   ├── Business review (20-30 min)
│   │   ├── Feedback consolidation
│   │   └── Approval
│   │
│   ├── 9.3 Stakeholder Validation
│   │   ├── Walkthrough session (60-90 min)
│   │   └── Script completo: UC-IACT-04 con Admin y Auditor
│   │
│   └── 9.4 Consistency Between UC
│       ├── 5 tipos de inconsistencia
│       └── Consistency matrix: MOD_Access, 3 UC, 4 aspectos
│
├── Sección 10: Metrics and Completeness (8,000 palabras)
│   ├── 10.1 Quality Metrics (7 métricas)
│   │   ├── M1: BR Coverage (>90%)
│   │   ├── M2: Documentation Depth (>8 steps, >3 FA)
│   │   ├── M3: Complete Traceability (100%)
│   │   ├── M4: Terminological Consistency (>95%)
│   │   ├── M5: Scenario Coverage (100%)
│   │   ├── M6: Clarity (Flesch 60-70)
│   │   └── M7: Update Recency (<90 days)
│   │
│   ├── 10.2 Completeness Dashboard
│   │   ├── Phase 1 BR: 45/45 (100%)
│   │   ├── Phase 2 UC: 22/24 (92%)
│   │   ├── Phase 3 FR: 156 total (54% implemented)
│   │   └── Projection: Completeness in 10 weeks
│   │
│   └── 10.3 Gap Analysis (5-step methodology)
│       └── Ejemplo: MOD_Audit (4 gaps, 6-week plan)
│
└── Sección 11: Practical Exercises (5,000 palabras)
    ├── Exercise 1: Build UC from BR (BR-070 → UC-25)
    ├── Exercise 2: Integrate Multiple BR (BR-099 + BR-105)
    ├── Exercise 3: Derive FR (UC-25 Step 2 → FR-2501)
    └── Exercise 4: Complete Traceability (code → FR → UC → BR)
```

**Estado:** Completo con ejemplos IACT - Necesita revisión mínima (5% del contenido) - 2 horas

---

### 1.2 Templates Generados

**Total:** 5 templates creados (de 17 planeados)

| Template | Archivo | Tamaño | Estado |
|----------|---------|--------|--------|
| T01 | Decision_Tipo_BR.md | 6 KB | ✅ COMPLETO |
| T02 | Construccion_UC_7_Pasos.md | 8 KB | ✅ COMPLETO |
| T03 | Identificacion_Actor_Primario.md | 7 KB | ✅ COMPLETO |
| T04 | Documentacion_FR_10_Componentes.md | 9 KB | ✅ COMPLETO |
| T09 | Checklist_Calidad_UC_26_Puntos.md | 10 KB | ✅ COMPLETO |

**Pendientes:** T05-T08, T10-T12 (12 templates)

---

### 1.3 Documentación Normativa Actualizada

#### STD_001: Estándares de Documentación (Sin Emojis)

**Archivo:** STD_001_Estandares_Documentacion_Sin_Emojis_1_1_0.rst  
**Versión:** 1.1.0  
**Fecha:** 2026-01-08  
**Estado:** ✅ APROBADO

**Contenido:**

```
STD_001: Sin Emojis ni Iconos Unicode
├── 1. Propósito
├── 2. Prohibiciones
│   ├── 2.1 Emojis (✅❌⚠️🚀📁💾 → PROHIBIDOS)
│   ├── 2.2 Iconos Unicode (▶●→★♦ → PROHIBIDOS)
│   └── 2.3 Box Drawing (╔═╗║ → PROHIBIDOS excepto en code-blocks)
│
├── 3. Alternativas Aprobadas
│   ├── 3.1 Sistema de Prefijos ([OK], [PENDING], [ERROR], [WARN])
│   ├── 3.2 Estados de Componentes ([VERIFIED], [OUTDATED], [READY])
│   ├── 3.3 Listas y Viñetas RST
│   ├── 3.4 Admoniciones RST (.. note::, .. warning::, .. danger::)
│   ├── 3.5 Tablas de Estado
│   └── 3.6 Secciones y Separadores (----)
│
├── 4. Casos Especiales
│   ├── 4.1 Diagramas de Árbol (permitido en code-blocks)
│   ├── 4.2 Diagramas PlantUML (permitido)
│   └── 4.3 Código Fuente Citado (permitido)
│
├── 5. Ejemplos de Conversión
│   ├── 5.1 Lista de Estado (antes/después)
│   ├── 5.2 Tabla de Progreso
│   ├── 5.3 Checklist
│   └── 5.4 Nomenclatura Actualizada (v1.1.0 NUEVO)
│
├── 6. Validación
│   ├── 6.1 Checklist de Revisión (8 puntos)
│   └── 6.2 Comando de Verificación (grep)
│
└── 7. Excepciones Documentadas
    ├── 7.1 Documentos Legacy
    └── 7.2 Documentos Externos Citados
```

**Impacto:** Todos los documentos nuevos deben seguir STD_001

---

#### NOM_001: Nomenclatura del Proyecto IACT

**Archivo:** NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst  
**Versión:** 2.0.0  
**Fecha:** 2026-01-08  
**Estado:** ✅ APROBADO

**Cambios principales v1.0 → v2.0:**

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| Dígitos secuenciales | 2 dígitos (01, 02) | **3 dígitos (001, 002)** |
| Versionado | Opcional | **OBLIGATORIO** (_MAJOR_MINOR_PATCH) |
| Templates | 6 ejemplos | **17 TPL completos** |
| Procedimientos | No versionados | **38 PROC versionados** |
| Prefijos totales | 17 | **27 prefijos** |
| Normativas | No existía | **NOM con versionado** |

**Formato general:**

```
[PREFIJO]_[SECUENCIAL]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

Donde:
  PREFIJO = UC, BR, FR, CNST, STD, PROC, TPL, etc.
  SECUENCIAL = 2 dígitos (UC con módulo) o 3 dígitos (global)
  Nombre = PascalCase en español
  Versionado = Semántico obligatorio
```

**Ejemplos:**

```
# Casos de Uso (2 dígitos + módulo):
UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
UC_ACC_09_Auditar_Cambios_Acceso_4_0_0.rst

# Artefactos globales (3 dígitos):
BR_001_Cliente_Debe_Autenticarse_1_0_0.rst
CNST_005_Seguridad_DRF_1_1_0.rst
NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst
STD_001_Suite_Calidad_Codigo_1_0_0.rst

# FR especial (punto):
FR_001.01_Validar_Username_1_0_0.rst
```

**Impacto:** Todos los archivos existentes necesitan renombramiento + versionado

---

### 1.4 CNST: Restricciones de Arquitectura

**Análisis:** ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md  
**Fecha:** 2026-01-03  
**Versión Origen:** 1.0.0 (CONGELADO, 2025-12-17)  
**Versión Destino:** 1.1.0 (VIGENTE, 2026-01-03)

**10 documentos CNST:**

| Documento | Líneas v1.0.0 | Líneas v1.1.0 | Cambio | Prioridad |
|-----------|---------------|---------------|--------|-----------|
| CNST_001 | 685 | 688 | +3 | MEDIA |
| CNST_002 | 840 | 841 | +1 | BAJA |
| CNST_003 | 901 | 902 | +1 | BAJA |
| CNST_004 | 920 | 921 | +1 | BAJA |
| **CNST_005** | **994** | **1,339** | **+345** | **🔴 CRÍTICA** |
| **CNST_006** | **1,126** | **1,703** | **+577** | **🔴 CRÍTICA** |
| CNST_007 | 1,061 | 1,062 | +1 | BAJA |
| CNST_008 | 1,019 | 1,020 | +1 | BAJA |
| CNST_009 | 1,077 | 1,078 | +1 | BAJA |
| CNST_010 | 998 | 1,002 | +4 | 🟠 ALTA |
| index.rst | 253 | 280 | +27 | 🟡 MEDIA |
| **TOTAL** | **9,621** | **10,543** | **+922** | |

**Cambio arquitectónico principal:**

```python
# ANTES (RBAC v4.0 - Basado en roles):
class HasRole(permissions.BasePermission):
    ALLOWED_ROLES = ['R004', 'R005', 'R007', 'R015']
    
    def has_permission(self, request, view):
        user_roles = get_user_roles(request.user)
        return any(role in user_roles for role in self.ALLOWED_ROLES)

# DESPUÉS (RBAC v5.1.1 - Basado en funciones atómicas):
class HasFunction(permissions.BasePermission):
    required_functions = ['ve_reportes']  # Catálogo de 44 funciones
    
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        
        from apps.access.models import UserFunctionAssignment
        user_functions = UserFunctionAssignment.get_user_functions(request.user)
        return any(func in user_functions for func in required_functions)
```

**Ampliaciones principales:**

1. **CNST_005:** +345 líneas → Permisos Temporales (expires_at, middleware, comando)
2. **CNST_006:** +577 líneas → Patrones de Diseño Recomendados (Service Layer, Custom Manager, Signals)

**Esfuerzo:** 4-5 horas (generación desde cero con `create_file`)

---

### 1.5 UC v4.0: Casos de Uso Regenerados

**Plan:** PLAN_MAESTRO_Regeneracion_Casos_Uso_v4_0.md  
**Fecha:** 2026-01-06  
**Versión:** 4.0.0  
**Estado:** APROBADO PARA EJECUCIÓN

**49 Casos de Uso distribuidos en 8 módulos:**

| Módulo | Código | UC | Ejemplos |
|--------|--------|-----|----------|
| MOD_Auth | AUTH | 5 | UC_AUTH_01_Iniciar_Sesion_4_0_0.rst |
| MOD_Users | USR | 4 | UC_USR_01_Crear_Usuario_4_0_0.rst |
| MOD_Access | ACC | 9 | UC_ACC_01_Asignar_Funciones_4_0_0.rst |
| MOD_Pipeline | PIP | 4 | UC_PIP_01_Supervisar_ETL_4_0_0.rst |
| MOD_Reports | RPT | 14 | UC_RPT_06_Exportar_CSV_4_0_0.rst |
| MOD_Alerts | ALR | 5 | UC_ALR_01_Configurar_Alerta_4_0_0.rst |
| MOD_Audit | AUD | 4 | UC_AUD_01_Consultar_Auditoria_4_0_0.rst |
| MOD_Logs | LOG | 4 | UC_LOG_01_Consultar_Logs_4_0_0.rst |
| **TOTAL** | | **49** | |

**Plantilla estándar (14 secciones):**

```rst
UC_[MOD]_[NN]_[Nombre_Descriptivo]_4_0_0.rst

1. Resumen (tabla con ID, Actor, Función RBAC, Prioridad)
2. Descripción (con CNST aplicables)
3. Diagrama de Caso de Uso (PlantUML)
4. Contexto de Ejecución (Precondiciones, Trigger, Postcondiciones)
5. Flujo Normal (tabla con Paso/Actor/Acción)
6. Diagrama de Secuencia (PlantUML con notas CNST)
7. Flujos Alternos
8. Excepciones
9. Diagrama de Actividad (PlantUML)
10. Reglas de Negocio
11. Restricciones de Arquitectura (tabla CNST)
12. Requisitos Funcionales Derivados
13. Trazabilidad (BReq, BR, CNST, FR, UC relacionados)
14. Historial de Cambios
```

**Características v4.0:**

- ✅ Actor = Agrupador RBAC (AGR-001 a AGR-010)
- ✅ Función RBAC explícita (de catálogo 44 funciones)
- ✅ CNST aplicables documentados en Sección 11
- ✅ Trazabilidad completa BR → UC → FR
- ✅ Versionado semántico (_4_0_0)
- ✅ Sin emojis (STD_001)

**Esfuerzo:** 4-5 horas (~5-6 min por UC, generación automatizada)

---

## PARTE 2: MAPEO Y TRAZABILIDAD

### 2.1 Mapeo: Químicos → IACT

**Tabla Maestra de Equivalencias (30 filas):**

| Concepto Químicos | Concepto IACT | Tipo | Justificación |
|-------------------|---------------|------|---------------|
| **Entidades** |
| Producto Químico | Llamada IVR | Entidad principal | Unidad básica de análisis |
| Contenedor químico | Sesión IVR | Contenedor | Agrupa múltiples llamadas |
| Solicitud de compra | Consulta de reporte | Operación | Acción que requiere aprobación |
| Fecha vencimiento | Timeout / Expiración | Evento temporal | Marca límite temporal |
| Laboratorio | Cola IVR | Contexto operacional | Lugar donde ocurren eventos |
| **Actores** |
| Solicitante | Analista de negocio | Usuario operativo | Quien solicita información |
| Coordinador Seguridad | Coordinador técnico | Supervisor | Responsable de calidad |
| Gerente Departamento | Gerente de área | Aprobador | Autoriza operaciones |
| Propietario | Agente / Usuario | Responsable | Dueño del recurso |
| **Atributos/Métricas** |
| Monto ($500) | Cantidad registros (10,000) | Umbral | Límite que dispara aprobación |
| Certificación OSHA | Rol / Permiso | Autorización | Requisito para acceso |
| Clase peligrosidad | Nivel de prioridad | Clasificación | Categorización de criticidad |
| **Reglas/Políticas** |
| Política Financiera | Política de Uso de Recursos | Normativa interna | Regla empresarial |
| Regulación OSHA | Política de Seguridad | Normativa externa | Regulación obligatoria |
| Vencimiento químico | Expiración de sesión | Evento temporal | Fin de vida útil |

---

### 2.2 Business Rules: Mapeo Detallado

#### BR-028: Restricción (MÁS USADO - 23 ocurrencias en PARTE 0)

**ANTES (Químicos):**
```
BR-028 (Restricción):
  "Solicitudes de compra que excedan $500 requieren 
   aprobación del gerente de departamento"
  
  Tipo: Restricción
  Fuente: Política Financiera Corporativa v2.3, Sección 4.2
  Impacto: Precondición en UC-04 "Solicitar Producto Químico"
```

**DESPUÉS (IACT):**
```
BR-IACT-028 (Restricción):
  "Consultas de reportes consolidados con más de 10,000 registros 
   requieren aprobación del supervisor de área"
  
  Tipo: Restricción
  Fuente: Política de Uso de Recursos Computacionales v1.2, Sección 3.4
  Fecha vigencia: 2024-01-01
  Prioridad: Media
  
  Impacto:
    - Precondición en UC-IACT-RPT-01 "Consultar Reporte Consolidado"
    - Flujo Alterno si registros > 10,000
    - FR-RPT-01-05: Validar cantidad de registros
    - FR-RPT-01-06: Solicitar aprobación supervisor
```

---

#### BR-031 vs BR-046: Comparación CRÍTICA

**BR-031 (Desencadenador) - 7 ocurrencias:**

```
ANTES (Químicos):
  "SI un contenedor de químico alcanza su fecha de vencimiento 
   ENTONCES el sistema debe notificar por email al propietario 
   del contenedor y al coordinador de seguridad con 30 días 
   de anticipación"

DESPUÉS (IACT):
  "SI una sesión de usuario supera 12 minutos de inactividad 
   ENTONCES el sistema debe notificar al usuario que su sesión 
   está por expirar"
  
  Genera: UC-IACT-07 "Notificar Expiración Inminente de Sesión"
  Actor Primario: Sistema (job cada minuto)
  
  Flujo UC-IACT-07:
    1. Sistema inicia job verificación (cada 60s)
    2. Sistema consulta sesiones con inactividad >12 min
    3. Sistema itera sobre sesiones elegibles
    4. Sistema calcula tiempo restante (15 min - 12 min = 3 min)
    5. Sistema compone mensaje de notificación
    6. Sistema envía notificación a buzón interno [CNST-001]
    7. Sistema registra evento en audit_log [CNST-009]
  
  FR derivados:
    FR-301: Consultar sesiones (query SQL + índice)
    FR-302: Calcular tiempo restante
    FR-303: Componer mensaje
    FR-304: Enviar a InternalMessage (no email)
    FR-305: Registrar en audit_log
```

**BR-046 (Inferencia) - 4 ocurrencias:**

```
ANTES (Químicos):
  "SI un contenedor de químico alcanza su fecha de vencimiento 
   ENTONCES el contenedor debe ser marcado con estado 'Caduco' 
   en el sistema"

DESPUÉS (IACT):
  "SI una sesión de usuario supera 15 minutos de inactividad 
   ENTONCES la sesión debe ser marcada con estado 'EXPIRADA' 
   en el sistema"
  
  NO genera UC (solo cambio interno)
  
  Genera FR-305 directo:
    
    UPDATE user_sessions
    SET estado = 'EXPIRADA',
        expired_at = NOW()
    WHERE estado = 'ACTIVA'
      AND last_activity < NOW() - INTERVAL 15 MINUTE;
```

**Timeline comparativo CRÍTICO:**

```
Sesión IACT:

    T+12 min            T+15 min
       ↓                   ↓
   ┌──────────────────────────────┐
   │ BR-IACT-031 (DESENCADENADOR) │
   │ → Notifica usuario ✅         │
   │ → Usuario VE mensaje          │
   │ → Genera UC-IACT-07           │
   └──────────────────────────────┘
                                  ↓
                        ┌──────────────────────────┐
                        │ BR-IACT-046 (INFERENCIA) │
                        │ → Marca EXPIRADA ❌      │
                        │ → Solo campo cambia      │
                        │ → Genera FR-305 directo  │
                        └──────────────────────────┘

Test de observabilidad:
  BR-IACT-031: Usuario RECIBE notificación → Observable ✅ → DESENCADENADOR
  BR-IACT-046: Solo estado DB cambia → NO observable ❌ → INFERENCIA
```

---

#### BR-087: Restricción (10 ocurrencias)

**ANTES (Químicos):**
```
BR-087 (Restricción):
  "Solo personal con certificación OSHA 29 CFR 1910.1200
   puede manipular químicos peligrosos clase 1-4"
```

**DESPUÉS (IACT):**
```
BR-IACT-087 (Restricción):
  "Solo usuarios con nivel de seguridad ≥3 pueden asignar
   funciones críticas del sistema"
  
  Fuente: Política de Segregación de Funciones v1.8, Artículo 12
  Fecha vigencia: 2024-06-01
  Prioridad: Alta
  
  Impacto:
    - Precondición en UC-IACT-04 "Asignar Funciones a Usuario"
    - Validación en Paso 4: Verificar nivel_seguridad >= 3
    - Flujo Alterno FA-3: Admin sin nivel suficiente
    - FR-401: Verificar nivel seguridad del admin
    - FR-402: Listar funciones críticas
    - FR-403: Validar nivel antes de asignar
```

---

### 2.3 Casos de Uso: Mapeo Detallado

#### UC-04: Ejemplo MAESTRO (26 ocurrencias en PARTE 0)

**ANTES (Químicos):**
```
UC-04: Solicitar Producto Químico

Actor Primario: Solicitante
Objetivo: Obtener autorización para adquirir un producto químico

Flujo Normal:
  1. Solicitante ingresa código del producto
  2. Sistema muestra información del producto
  3. Solicitante ingresa cantidad y justificación
  4. Sistema verifica capacitación del solicitante [BR-087]
  5. Sistema valida cantidad contra límites permitidos
  6. SI monto >$500 ENTONCES [BR-028]
       Sistema solicita aprobación de gerente
  7. Sistema registra la solicitud
  8. Sistema notifica al solicitante

Business Rules: BR-028, BR-087, BR-031
FR derivados: RF-205, RF-206, RF-207
```

**DESPUÉS (IACT):**
```
UC-IACT-RPT-01: Consultar Reporte Consolidado
Versión: 4.0.0

Actor Primario: Analista de negocio [AGR-003: agr_analista]
Función RBAC: RPT-001 (ve_reportes)
Objetivo: Obtener reporte consolidado de métricas IVR

Precondiciones:
  1. Usuario autenticado con sesión activa [CNST-002]
  2. Usuario tiene función RPT-001 (ve_reportes) [RBAC v5.1.1]
  3. Sistema IVR actualizado (ETL <6 horas) [CNST-003, CNST-004]

Flujo Normal:
  1. Analista selecciona "Consultar Reporte"
  2. Sistema muestra catálogo de reportes disponibles
  3. Analista selecciona tipo (ej: "Métricas por Cola")
  4. Sistema muestra formulario de parámetros
  5. Analista ingresa parámetros:
     - Rango de fechas (desde-hasta) [máx 2 años, CNST-006]
     - Colas IVR (selección múltiple)
     - Métricas (TMO, SLA, Abandono, etc.)
     - Nivel de agregación (horario/diario/semanal)
  6. Analista confirma "Generar Reporte"
  7. Sistema verifica permisos [BR-IACT-401]
  8. Sistema calcula cantidad de registros a procesar
  9. SI registros >10,000 ENTONCES [BR-IACT-028]
       Sistema solicita aprobación de supervisor
       Ir a FA-1: Requiere Aprobación
  10. Sistema ejecuta consulta SQL (solo lectura en BD IVR) [CNST-003]
  11. Sistema genera reporte en pantalla
  12. Analista puede exportar (CSV/Excel) [CNST-007]
  13. Sistema registra en audit_log [CNST-009]

Flujos Alternos:
  FA-1: Requiere Aprobación de Supervisor
    9a. Sistema detecta registros = 45,000 (>10,000)
    9b. Sistema identifica supervisor del área
    9c. Sistema genera solicitud de aprobación
    9d. Sistema notifica supervisor por buzón interno [CNST-001]
    9e. Sistema muestra mensaje a analista:
        "Su solicitud requiere aprobación.
         Supervisor: {nombre}
         Se notificará cuando sea aprobada."
    9f. UC termina en estado PENDIENTE
    
  FA-2: Sin Permisos para Reporte
    7a. Sistema detecta analista sin función RPT-001
    7b. Sistema muestra error:
        "No tiene permisos para este tipo de reporte.
         Contacte al administrador."
    7c. Sistema registra intento en audit_log [CNST-009]
    7d. UC termina sin generar reporte
  
  FA-3: Rango de Fechas Excede Límite
    5a. Sistema detecta rango > 2 años [CNST-006]
    5b. Sistema muestra error:
        "El rango de fechas no puede exceder 2 años.
         Seleccione un rango menor."
    5c. Sistema retorna a paso 5

Postcondiciones:
  Éxito:
    - Reporte generado y visualizado
    - Evento registrado en audit_log
    - Estadística de uso actualizada
  
  FA-1:
    - Solicitud pendiente de aprobación
    - Notificación enviada a supervisor
    - Estado: PENDIENTE

Business Rules aplicadas:
  - BR-IACT-028: Aprobación si >10,000 registros (Paso 9)
  - BR-IACT-401: Permisos de acceso (Paso 7)
  - CNST-001: Solo buzón interno (FA-1, paso 9d)
  - CNST-003: BD IVR solo lectura (Paso 10)
  - CNST-006: Rango máximo 2 años (Paso 5, FA-3)
  - CNST-007: Límites exportación (Paso 12)
  - CNST-009: Auditoría obligatoria (Paso 13)

FR derivados:
  FR-RPT-01-01: Consultar catálogo de reportes
  FR-RPT-01-02: Renderizar formulario de parámetros
  FR-RPT-01-03: Validar rango de fechas (máx 2 años)
  FR-RPT-01-04: Validar selección de colas
  FR-RPT-01-05: Calcular cantidad de registros
  FR-RPT-01-06: Verificar función RPT-001 del analista
  FR-RPT-01-07: Solicitar aprobación supervisor si >10k
  FR-RPT-01-08: Ejecutar query consolidado (solo lectura)
  FR-RPT-01-09: Formatear datos para visualización
  FR-RPT-01-10: Exportar a CSV/Excel con límites

Trazabilidad:
  BReq: BReq_RPT_Consultar_Metricas_1_0_0
  BR: BR-IACT-028, BR-IACT-401
  CNST: CNST-001, CNST-003, CNST-006, CNST-007, CNST-009
  Actor: AGR-003 (agr_analista)
  Función RBAC: RPT-001 (ve_reportes)
  UC relacionados: UC_RPT_06_Exportar_CSV, UC_RPT_07_Exportar_Excel
```

---

### 2.4 Trazabilidad Completa: Ejemplo de Cadena

**Cadena BR → UC → FR → Código:**

```
BR-IACT-031 (Desencadenador)
  "SI sesión >12 min inactividad ENTONCES notificar usuario"
  │
  │ TRANSFORMA EN
  ↓
UC-IACT-07 (Caso de Uso Completo)
  "Notificar Expiración Inminente de Sesión"
  Actor: Sistema (Scheduler)
  11 pasos + 6 FA
  │
  │ DERIVA EN
  ↓
FR-301 (Query Sesiones)
  "Consultar sesiones con inactividad >12 min"
  Query SQL:
    SELECT * FROM user_sessions
    WHERE estado = 'ACTIVA'
      AND last_activity < NOW() - INTERVAL 12 MINUTE
    ORDER BY last_activity ASC;
  │
  │ IMPLEMENTA EN
  ↓
session_monitor.py
  """
  Módulo: apps/auth/jobs/session_monitor.py
  Job: Monitoreo de sesiones inactivas
  
  Trazabilidad:
    BR: BR-IACT-031
    UC: UC-IACT-07 Paso 2
    FR: FR-301
  """
  
  def get_expiring_sessions():
      from apps.auth.models import UserSession
      from django.utils import timezone
      from datetime import timedelta
      
      # FR-301: Query sesiones >12 min inactividad
      threshold = timezone.now() - timedelta(minutes=12)
      
      sessions = UserSession.objects.filter(
          estado='ACTIVA',
          last_activity__lt=threshold
      ).select_related('user').order_by('last_activity')
      
      # BR-IACT-031: Condición temporal
      return sessions
  │
  │ VALIDA CON
  ↓
test_session_monitor.py
  def test_get_expiring_sessions():
      """
      Test Case: TST-301-01
      Verifica FR-301: Query sesiones >12 min
      Implementa: UC-IACT-07 Paso 2
      Valida: BR-IACT-031
      """
      # Arrange: Crear sesión inactiva 13 minutos
      session = UserSession.objects.create(
          user=user,
          estado='ACTIVA',
          last_activity=timezone.now() - timedelta(minutes=13)
      )
      
      # Act: Ejecutar query
      result = get_expiring_sessions()
      
      # Assert: Sesión debe aparecer
      assert session in result
```

**RTM (Requirements Traceability Matrix):**

| BR | UC | FR | Código | Test | Estado |
|----|----|----|--------|------|--------|
| BR-IACT-031 | UC-IACT-07 | FR-301 | session_monitor.py | TST-301-01 | ✅ COMPLETO |
| BR-IACT-031 | UC-IACT-07 | FR-302 | time_calculator.py | TST-302-01 | ✅ COMPLETO |
| BR-IACT-031 | UC-IACT-07 | FR-303 | message_composer.py | TST-303-01 | ✅ COMPLETO |
| BR-IACT-031 | UC-IACT-07 | FR-304 | internal_notifier.py | TST-304-01 | ✅ COMPLETO |
| BR-IACT-031 | UC-IACT-07 | FR-305 | audit_logger.py | TST-305-01 | ✅ COMPLETO |

---

## PARTE 3: PLAN DE ACTUALIZACIÓN INTEGRAL

### 3.1 Secuencia Óptima de Actualización

```
FASE 0: Preparación y Aprobación (3 horas)
  ├── Aprobar este análisis consolidado
  ├── Asignar recursos (analista + tech lead)
  └── Crear estructura /tmp para staging

FASE 1: PARTE 0 - Fundamento (23 horas) ⭐⭐⭐ PRIORITARIO
  ├── Mapeo Químicos → IACT (4h)
  ├── Reescritura secciones críticas (14h)
  │   ├── 1.4 Caso Ilustrativo (3h)
  │   ├── 2.4 Nivel 2 UC (2.5h)
  │   ├── 3.3 Desenc vs Inf (2h)
  │   └── Otras secciones (6.5h)
  ├── Validación (3h)
  └── Referencias (2h)

FASE 2: PARTE 1 - BR (16 horas) ⭐⭐ ALTA
  ├── Mapeo BR principales (2h)
  ├── Reescritura secciones críticas (10h)
  │   ├── 4. Taxonomía 5 tipos (3h)
  │   ├── 5. Desenc vs Inf (2h)
  │   └── Otras secciones (5h)
  ├── Ejercicios IACT (2h)
  └── Validación (2h)

FASE 3: base_cognitiva/ Grupo 1 (32 horas) ⭐ IMPORTANTE
  ├── TXM_03 Taxonomía BR (8h)
  ├── SBVR_03 Reglas Estructurales (8h)
  ├── SBVR_04 Reglas Operativas (8h)
  └── FND_02 Reglas de Negocio (8h)

FASE 4: PARTE 2 Revisión (10 horas) 🟡 MEDIA
  ├── PARTE 2A revisión (5h)
  ├── PARTE 2B revisión (3h)
  └── PARTE 2C revisión (2h)

FASE 5: CNST v1.1.0 (5 horas) ⭐⭐ ALTA
  ├── CNST_005 ampliación (2h)
  ├── CNST_006 ampliación (2h)
  └── Otros CNST actualizados (1h)

FASE 6: UC v4.0.0 (5 horas) ⭐⭐ ALTA
  ├── Preparación (Fase 0 del plan) (0.5h)
  ├── AUTH (5 UC) (0.5h)
  ├── USR (4 UC) (0.5h)
  ├── ACC (9 UC) (1h)
  ├── PIP (4 UC) (0.5h)
  ├── RPT (14 UC) (1.5h)
  ├── ALR (5 UC) (0.5h)
  ├── AUD (4 UC) (0.5h)
  └── LOG (4 UC) (0.5h)

FASE 7: Nomenclatura v2.0.0 (20 horas) 🟡 MEDIA
  ├── Renombrar archivos existentes (10h)
  ├── Agregar versionado _X_Y_Z (8h)
  └── Validación nomenclatura (2h)

FASE 8: base_cognitiva/ Grupo 2 (18 horas) 🟢 BAJA
  ├── FND_03 Casos de Uso (6h)
  ├── FND_05 Jerarquía 4 Niveles (6h)
  └── MTM_01/02 Metamodelos (6h)

FASE 9: Templates Pendientes (15 horas) 🟢 BAJA
  ├── T05-T08 (8h)
  └── T10-T12 (7h)

FASE 10: Validación Global (10 horas)
  ├── Build Sphinx sin warnings (2h)
  ├── Verificación STD_001 (sin emojis) (2h)
  ├── Verificación NOM_001 (nomenclatura) (2h)
  ├── Trazabilidad BR→UC→FR (2h)
  └── Pruebas de integración (2h)

──────────────────────────────────────────────────────
TOTAL: 157 horas (~20 días laborables, ~4 semanas)
```

---

### 3.2 Matriz de Prioridades

| Fase | Componente | Horas | Prioridad | Dependencias | Bloqueante |
|------|-----------|-------|-----------|--------------|------------|
| 1 | PARTE 0 | 23 | 🔴 CRÍTICA | Ninguna | SÍ (base todo) |
| 2 | PARTE 1 | 16 | 🟠 ALTA | PARTE 0 | SÍ (P1→BC) |
| 3 | base_cognitiva/ G1 | 32 | ⭐ IMPORTANTE | PARTE 1 | NO |
| 4 | PARTE 2 revisión | 10 | 🟡 MEDIA | PARTE 0, 1 | NO |
| 5 | CNST v1.1.0 | 5 | 🟠 ALTA | Ninguna | NO |
| 6 | UC v4.0.0 | 5 | 🟠 ALTA | CNST v1.1.0 | NO |
| 7 | Nomenclatura | 20 | 🟡 MEDIA | NOM_001 | NO |
| 8 | base_cognitiva/ G2 | 18 | 🟢 BAJA | Fase 3 | NO |
| 9 | Templates | 15 | 🟢 BAJA | Ninguna | NO |
| 10 | Validación | 10 | 🟢 BAJA | Todas | SÍ (final) |

---

### 3.3 Cronograma Tentativo (4 Semanas)

```
SEMANA 1: Fundamentos
├── Lunes-Miércoles: PARTE 0 (23h)
│   └── BLOQUEANTE: Todo depende de esto
└── Jueves-Viernes: PARTE 1 (16h)

SEMANA 2: Transformaciones
├── Lunes-Martes: base_cognitiva/ G1 (32h)
│   ├── TXM_03 (8h)
│   ├── SBVR_03/04 (16h)
│   └── FND_02 (8h)
└── Miércoles-Viernes: PARTE 2 revisión + CNST (15h)
    ├── PARTE 2 (10h)
    └── CNST v1.1.0 (5h)

SEMANA 3: Casos de Uso y Nomenclatura
├── Lunes: UC v4.0.0 (5h)
├── Martes-Jueves: Nomenclatura v2.0.0 (20h)
└── Viernes: base_cognitiva/ G2 inicio (8h)

SEMANA 4: Cierre
├── Lunes-Martes: base_cognitiva/ G2 (10h restantes)
├── Miércoles: Templates pendientes (15h)
└── Jueves-Viernes: Validación global (10h)
```

---

### 3.4 Riesgos y Mitigaciones

| # | Riesgo | Probabilidad | Impacto | Mitigación |
|---|--------|--------------|---------|------------|
| R1 | PARTE 0 toma más de 23h | Media | Alto | Buffer 20%, dividir en sprints 4h |
| R2 | Ejemplos IACT inconsistentes | Media | Alto | Validar con PO en Fase 1 |
| R3 | Desconexión base_cognitiva/ | Baja | Alto | Fase 4 actualiza en paralelo |
| R4 | Nomenclatura v2.0 causa conflictos | Media | Medio | Script de renombramiento automatizado |
| R5 | Build Sphinx con warnings | Alta | Medio | Validación incremental por fase |
| R6 | CNST_005/006 muy extensos | Baja | Bajo | Generar en /tmp, no copiar |
| R7 | Resistencia del equipo | Baja | Medio | Mostrar beneficios, involucrar en validación |
| R8 | Falta de recursos | Media | Alto | Priorizar Fases 1-2, resto gradual |

---

## PARTE 4: NORMATIVAS Y ESTÁNDARES APLICABLES

### 4.1 STD_001: Sin Emojis (v1.1.0)

**Reglas obligatorias:**

```rst
PROHIBIDO en documentación:
  ✅ ❌ ⚠️ 🚀 📁 💾 🔍 ⏳ ✨ 🎉 ⭐ 📊 📈 🎯 💡
  ▶ ● → ★ ♦ ■ ▸ » ☑ ☐
  ╔═╗ ║ ┌─┐ │ └ ├

USAR en su lugar:
  [OK] [ERROR] [WARN] [INFO] [SUCCESS] [PENDING]
  [VERIFIED] [OUTDATED] [READY] [CRITICAL]
  
  .. note::
  .. warning::
  .. danger::
```

**Validación:**
```bash
grep -rn "[✅❌⚠️🚀📁💾🔍⏳✨🎉⭐📊📈🎯💡]" source/*.rst
# Expected: 0 matches
```

**Impacto en actualización:**
- PARTE 0, 1, 2: Revisar y eliminar emojis
- CNST: Ya sin emojis
- UC v4.0: Sin emojis desde diseño

---

### 4.2 NOM_001: Nomenclatura (v2.0.0)

**Cambios críticos:**

| Aspecto | v1.0 | v2.0 |
|---------|------|------|
| Dígitos UC | 2 (01, 02) | **2 (mantiene)** |
| Dígitos globales | 2 (01, 02) | **3 (001, 002)** |
| Versionado | Opcional | **OBLIGATORIO** |
| Separador | Guión medio (-) | **Guión bajo (_)** |

**Formato obligatorio:**

```
[PREFIJO]_[SECUENCIAL]_[Nombre]_[MAJOR]_[MINOR]_[PATCH].rst

Ejemplos:
  UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
  BR_001_Cliente_Debe_Autenticarse_1_0_0.rst
  CNST_005_Seguridad_DRF_1_1_0.rst
  FR_001.01_Validar_Username_1_0_0.rst
```

**Script de migración automática:**

```python
# rename_to_v2.py
import os
import re
from pathlib import Path

def migrate_filename(old_name):
    """Migrar nombre v1.0 → v2.0"""
    
    # Patrón v1.0: BR-001-Nombre.rst
    # Patrón v2.0: BR_001_Nombre_1_0_0.rst
    
    match = re.match(r'([A-Z]+)-(\d+)-(.+)\.rst', old_name)
    if match:
        prefix, num, name = match.groups()
        
        # Convertir guiones a guiones bajos
        name = name.replace('-', '_')
        
        # Agregar versionado por defecto 1_0_0
        new_name = f"{prefix}_{num.zfill(3)}_{name}_1_0_0.rst"
        return new_name
    
    return old_name

# Ejemplo de uso:
# BR-001-Fuente-Inmutable.rst → BR_001_Fuente_Inmutable_1_0_0.rst
```

---

### 4.3 RBAC v5.1.1: 44 Funciones Atómicas

**Distribución por módulo:**

| Módulo | Código | Funciones | Ejemplos |
|--------|--------|-----------|----------|
| MOD_Auth | AUT | 4 | gestiona_sesiones, cierra_sesion_usuario |
| MOD_Users | USR | 10 | crea_usuarios, ve_usuarios, modifica_usuarios |
| MOD_Access | ACC | 6 | asigna_funciones, revoca_funciones, ve_asignaciones |
| MOD_Pipeline | PIP | 4 | supervisa_etl, ejecuta_etl, configura_etl |
| MOD_Reports | RPT | 8 | ve_reportes, genera_reporte, exporta_csv, exporta_excel |
| MOD_Alerts | ALR | 6 | crea_alertas, notifica_usuario, gestiona_alertas |
| MOD_Audit | AUD | 4 | consulta_auditoria, exporta_audit |
| MOD_Logs | LOG | 2 | consulta_logs, exporta_logs |
| **TOTAL** | | **44** | |

**Principio "Sin Pretensiones":**

```
❌ INCORRECTO (con pretensiones):
  USERS_FULL_MANAGER → Define QUÉ ES la persona
  SYSTEM_ADMIN → Cargo jerárquico
  REPORTS_VIEWER → Rol/título

✅ CORRECTO (sin pretensiones):
  crea_usuarios → Describe QUÉ PUEDE HACER
  ve_reportes → Acción concreta
  exporta_csv → Capacidad específica
```

**Integración en UC v4.0:**

```rst
.. meta::
   :uc_id: UC_RPT_06
   :actor: AGR-004 (agr_analista_senior)
   :funcion_rbac: RPT-004 (exporta_csv)

Precondiciones:
  1. Usuario autenticado
  2. Usuario tiene función RPT-004 (exporta_csv)
  3. Datos disponibles para exportar
```

---

## PARTE 5: MÉTRICAS Y VALIDACIÓN

### 5.1 Métricas de Éxito

#### M1: Consistencia Terminológica

**Target:** 100% ejemplos usan dominio IACT

**Medición:**
```bash
# En PARTE 0, 1, 2
grep -ri "químico\|contenedor\|laboratorio\|OSHA" source/
# Expected: 0 matches (excepto en secciones "antes/después")

# En CNST
grep -ri "R001\|R015\|ROLE" source/normativa/restricciones/
# Expected: 0 matches (excepto en adaptadores legacy)
```

**Resultado esperado:** 0 ocurrencias fuera de contexto

#### M2: Cobertura de Nomenclatura v2.0

**Target:** 100% archivos con versionado

**Medición:**
```bash
# Contar archivos sin versionado
find source/ -name "*.rst" | grep -v "_[0-9]_[0-9]_[0-9].rst" | wc -l
# Expected: 0

# Contar archivos con versionado correcto
find source/ -name "*_[0-9]_[0-9]_[0-9].rst" | wc -l
# Expected: ~90 archivos
```

#### M3: Sin Emojis (STD_001)

**Target:** 0 emojis en documentación

**Medición:**
```bash
grep -rn "[✅❌⚠️🚀📁💾🔍⏳✨🎉⭐📊📈🎯💡▶●→★♦■▸»☑☐╔═╗║┌─┐│└├]" source/*.rst
# Expected: 0 matches
```

#### M4: Build Sphinx sin Warnings

**Target:** Build limpio

**Medición:**
```bash
make clean
make html 2>&1 | grep -i "warning\|error" | wc -l
# Expected: 0 warnings
```

#### M5: Trazabilidad Completa

**Target:** 100% trazabilidad BR→UC→FR

**Medición:**
- Cada BR tiene UC que la implementa
- Cada UC tiene BR origen
- Cada FR tiene UC origen
- RTM completo y actualizado

**Resultado esperado:** 100% trazabilidad

#### M6: Satisfacción del Equipo

**Target:** >80% satisfechos

**Encuesta post-actualización:**
1. ¿Ejemplos más claros que antes? (1-5)
2. ¿Puedes aplicar metodología fácilmente? (1-5)
3. ¿Nomenclatura v2.0 es clara? (1-5)
4. ¿RBAC v5.1.1 es comprensible? (1-5)
5. ¿Recomendarías esta doc a nuevo? (1-5)

**Resultado esperado:** Promedio >4.0/5.0

#### M7: Reducción de Preguntas

**Target:** -50% preguntas sobre metodología

**Medición:**
- ANTES: ~10 preguntas/semana
- DESPUÉS: <5 preguntas/semana

---

### 5.2 Checklist de Validación Global

**Pre-Aprobación (este documento):**

- [x] Análisis completo de PARTES 0-2C
- [x] Análisis CNST v1.1.0 integrado
- [x] Plan UC v4.0 integrado
- [x] STD_001 considerado
- [x] NOM_001 v2.0.0 considerado
- [x] Mapeo Químicos → IACT completo
- [x] Cronograma definido (4 semanas)
- [x] Riesgos identificados
- [x] Métricas definidas

**Post-Fase 1 (PARTE 0):**

- [ ] 0 menciones a químicos (excepto contexto histórico)
- [ ] BR-IACT-028, 031, 046, 087 documentados
- [ ] UC-IACT-RPT-01 o UC-IACT-07 como ejemplo maestro
- [ ] Glosario IACT incluido
- [ ] Diagrama maestro actualizado
- [ ] Referencias a PARTES 1-6 coherentes
- [ ] Aprobado por Tech Lead y PO

**Post-Fase 2 (PARTE 1):**

- [ ] 5 tipos de BR con ejemplos IACT
- [ ] Diferencia Desencadenador vs Inferencia clara
- [ ] Ejercicios 100% IACT
- [ ] Mapeo a base_cognitiva/ actualizado
- [ ] Aprobado por Arquitecto

**Post-Fase 5 (CNST v1.1.0):**

- [ ] 10 CNST actualizados
- [ ] RBAC v5.1.1 (44 funciones) integrado
- [ ] CNST_005 con Permisos Temporales (+345 líneas)
- [ ] CNST_006 con Patrones Recomendados (+577 líneas)
- [ ] Código Python validado
- [ ] Build Sphinx sin warnings

**Post-Fase 6 (UC v4.0.0):**

- [ ] 49 UC generados
- [ ] Actores = Agrupadores RBAC (AGR-00x)
- [ ] Funciones RBAC explícitas (de catálogo 44)
- [ ] CNST aplicables documentados
- [ ] Versionado _4_0_0 correcto
- [ ] Sin emojis (STD_001)
- [ ] Diagramas PlantUML renderizados

**Post-Fase 7 (Nomenclatura):**

- [ ] 100% archivos renombrados
- [ ] Versionado _X_Y_Z agregado
- [ ] Separadores _ (no -)
- [ ] 3 dígitos para artefactos globales
- [ ] 2 dígitos para UC
- [ ] Script de migración ejecutado
- [ ] Índices actualizados

**Post-Fase 10 (Validación Final):**

- [ ] M1: Consistencia 100%
- [ ] M2: Nomenclatura 100%
- [ ] M3: Sin emojis
- [ ] M4: Build limpio
- [ ] M5: Trazabilidad 100%
- [ ] M6: Satisfacción >80%
- [ ] M7: Preguntas -50%
- [ ] Documentación publicada
- [ ] README actualizado
- [ ] CHANGELOG generado

---

## PARTE 6: RECURSOS Y HERRAMIENTAS

### 6.1 Equipo Requerido

| Rol | Responsabilidad | Fases | Horas |
|-----|----------------|-------|-------|
| **Analista de Requisitos** | Reescritura PARTES 0-2 | 1, 2, 4 | 49h |
| **Tech Writer** | Reescritura base_cognitiva/ | 3, 8 | 50h |
| **Arquitecto de Software** | CNST v1.1.0, validación técnica | 5, 10 | 15h |
| **Developer Senior** | UC v4.0.0, código Python | 6 | 5h |
| **Tech Lead** | Nomenclatura, coordinación | 7, 10 | 30h |
| **Product Owner** | Validación ejemplos IACT | 1, 2 | 8h |
| **TOTAL** | | | **157h** |

---

### 6.2 Herramientas

**Documentación:**
- Sphinx 7.2.x
- reStructuredText
- PlantUML
- VS Code + RST extension

**Versionamiento:**
- Git + GitLab/GitHub
- Semantic Versioning 2.0.0

**Validación:**
- STD_001 validator (grep scripts)
- NOM_001 validator (Python script)
- Sphinx linkcheck
- Pytest para código Python

**Colaboración:**
- Slack/Teams para comunicación
- GitLab Issues para tracking
- Confluence para documentación temporal

---

### 6.3 Estructura de Staging

```
/tmp/iact_update/
├── fase_1_parte_0/
│   ├── PARTE_0_IACT_v2.0.md
│   └── MAPEO_QUIMICOS_IACT.md
│
├── fase_2_parte_1/
│   ├── PARTE_1_IACT_v2.0.md
│   └── ejercicios_iact/
│
├── fase_3_base_cognitiva_g1/
│   ├── TXM_03_Taxonomia_Reglas_Negocio_2_0_0.rst
│   ├── SBVR_03_Reglas_Estructurales_2_0_0.rst
│   ├── SBVR_04_Reglas_Operativas_2_0_0.rst
│   └── FND_02_Reglas_de_Negocio_2_0_0.rst
│
├── fase_5_cnst/
│   ├── CNST_001_Comunicaciones_Prohibidas_1_1_0.rst
│   ├── CNST_005_Seguridad_DRF_1_1_0.rst
│   ├── CNST_006_Antipatrones_Arquitectura_1_1_0.rst
│   └── [resto CNST]
│
├── fase_6_uc_v4/
│   ├── auth/
│   │   ├── UC_AUTH_01_Iniciar_Sesion_4_0_0.rst
│   │   └── [4 UC más]
│   ├── users/
│   │   └── [4 UC]
│   ├── access/
│   │   └── [9 UC]
│   └── [resto módulos]
│
└── fase_7_nomenclatura/
    ├── rename_script.py
    ├── rename_log.txt
    └── rollback_script.py
```

---

## PARTE 7: CONCLUSIÓN Y RECOMENDACIONES

### 7.1 Resumen de Hallazgos

**1. Magnitud del Trabajo**

- ✅ Material pedagógico extenso: ~238,000 palabras
- ✅ Bien estructurado pero dominio incorrecto
- ✅ ~90 documentos requieren actualización
- ✅ ~157 horas de trabajo (~4 semanas)

**2. Problema Triple Identificado**

```
PROBLEMA 1: Dominio Químicos
  Impacto: PARTES 0, 1, 2A parcialmente
  Solución: Reescritura con ejemplos IACT
  
PROBLEMA 2: RBAC Obsoleto
  Impacto: CNST v1.0.0 (10 docs)
  Solución: Actualización a v5.1.1 (44 funciones)
  
PROBLEMA 3: Sin Versionado
  Impacto: ~60-80 archivos
  Solución: Aplicar NOM_001 v2.0.0
```

**3. Fortalezas del Material**

- ⭐ PARTE 2A, 2B, 2C: Contenido sólido con ejemplos IACT
- ⭐ Templates T01-T04, T09: Útiles y reutilizables
- ⭐ Metodología clara y bien explicada
- ⭐ Trazabilidad BR→UC→FR bien definida

**4. Dependencias Críticas**

```
PARTE 0 (23h) → BLOQUEANTE para PARTE 1
PARTE 1 (16h) → BLOQUEANTE para base_cognitiva/ G1
CNST v1.1.0 (5h) → INDEPENDIENTE, ejecutar en paralelo
UC v4.0.0 (5h) → Depende de CNST v1.1.0
```

---

### 7.2 Recomendación Principal

**PROCEDER CON ACTUALIZACIÓN INTEGRAL EN 4 SEMANAS**

**Justificación:**

1. **Necesidad Crítica**
   - Equipo necesita documentación alineada con proyecto real
   - Dominio químicos genera confusión y desconfianza
   - RBAC v4.0 obsoleto impide implementación correcta

2. **ROI Positivo**
   - Inversión: 157 horas (~$20,000-30,000)
   - Beneficio: Documentación profesional reutilizable
   - Ahorro: Onboarding 50% más rápido, menos errores
   - ROI: >300% en 12 meses

3. **Viabilidad**
   - Plan detallado con fases claras
   - Riesgos identificados y mitigables
   - Equipo disponible (4-5 personas)
   - Herramientas disponibles

4. **Urgencia**
   - Proyecto IACT en desarrollo activo
   - Nuevos desarrolladores necesitan onboarding
   - Cliente requiere documentación actualizada

---

### 7.3 Alternativas Consideradas

**Alternativa A: Mantener status quo**
- ❌ Rechazada: Perpetúa confusión, reduce calidad

**Alternativa B: Actualización parcial (solo PARTE 0 + CNST)**
- ⚠ Considerada: Ahorra tiempo (33h) pero deja inconsistencias
- ❌ Rechazada: Solución a medias, no resuelve problema raíz

**Alternativa C: Reescritura incremental (6 meses)**
- ⚠ Considerada: Menos presión, más tiempo
- ❌ Rechazada: Equipo necesita solución YA, no en 6 meses

**Alternativa D: Actualización integral en 4 semanas**
- ✅ **SELECCIONADA:** Balance óptimo entre calidad, tiempo y recursos

---

### 7.4 Próximos Pasos Inmediatos

**PASO 1: Reunión de Aprobación (esta semana)**

- Presentar este análisis al equipo
- Stakeholders: Tech Lead, PO, Arquitecto, CTO
- Decisión: GO / NO-GO / DIFERIR
- Duración: 2 horas

**PASO 2: Asignación de Recursos (si GO)**

- Confirmar disponibilidad del equipo
- Asignar roles y responsabilidades
- Reservar tiempo en calendarios (4 semanas)
- Duración: 1 día

**PASO 3: Kickoff (inicio Semana 1)**

- Crear estructura /tmp
- Setup herramientas
- Briefing del equipo
- Inicio FASE 1 (PARTE 0)
- Duración: Medio día

**PASO 4: Ejecución Fases 1-10 (4 semanas)**

- Seguir cronograma definido
- Checkpoints diarios (15 min)
- Reviews semanales (1 hora)
- Ajustes según necesidad

**PASO 5: Release y Comunicación (fin Semana 4)**

- Publicar documentación actualizada
- Comunicar cambios al equipo
- Training session (2 horas)
- Recoger feedback

---

## ANEXO A: TABLA RESUMEN CONSOLIDADA

### Documentos a Actualizar

| # | Componente | Archivos | Palabras | Horas | Prioridad | Fase |
|---|-----------|----------|----------|-------|-----------|------|
| 1 | PARTE 0 | 1 | 18,000 | 23 | 🔴 CRÍTICA | 1 |
| 2 | PARTE 1 | 1 | 15,000 | 16 | 🟠 ALTA | 2 |
| 3 | PARTE 2 (revisión) | 3 | 95,000 | 10 | 🟡 MEDIA | 4 |
| 4 | CNST v1.1.0 | 11 | 25,000 | 5 | 🟠 ALTA | 5 |
| 5 | UC v4.0.0 | 49 | 25,000 | 5 | 🟠 ALTA | 6 |
| 6 | base_cognitiva/ G1 | 4 | 20,000 | 32 | ⭐ IMPORTANTE | 3 |
| 7 | base_cognitiva/ G2 | 6 | 20,000 | 18 | 🟢 BAJA | 8 |
| 8 | Nomenclatura | ~80 | - | 20 | 🟡 MEDIA | 7 |
| 9 | Templates | 12 | 15,000 | 15 | 🟢 BAJA | 9 |
| 10 | Validación | - | - | 10 | 🟢 BAJA | 10 |
| **TOTAL** | **~167** | **~233,000** | **154h** | | |

---

## ANEXO B: GLOSARIO DE TÉRMINOS

| Término | Definición |
|---------|-----------|
| **IACT** | Sistema de Análisis de Llamadas IVR (IVR Analytics & Customer Tracking) |
| **RBAC v5.1.1** | Role-Based Access Control con 44 funciones atómicas |
| **Función atómica** | Capacidad específica asignable a usuario (ej: ve_reportes) |
| **Agrupador** | Conjunto de funciones RBAC (ej: AGR-003 agr_analista) |
| **CNST** | Constraint - Restricción de arquitectura |
| **BR** | Business Rule - Regla de negocio |
| **UC** | Use Case - Caso de uso |
| **FR** | Functional Requirement - Requisito funcional |
| **RTM** | Requirements Traceability Matrix |
| **Desencadenador** | BR que genera UC completo (observable) |
| **Inferencia** | BR que genera FR directo (no observable) |
| **STD_001** | Estándar sin emojis ni iconos Unicode |
| **NOM_001 v2.0** | Nomenclatura con versionado semántico obligatorio |
| **PlantUML** | Lenguaje para diagramas UML |
| **Sphinx** | Generador de documentación |
| **reStructuredText (RST)** | Formato de marcado para documentación |

---

## ANEXO C: CONTACTOS Y RESPONSABLES

| Rol | Nombre | Email | Responsabilidad |
|-----|--------|-------|----------------|
| Tech Lead | [Nombre] | [email] | Coordinación general, Fase 7 |
| Arquitecto | [Nombre] | [email] | CNST v1.1.0, validación técnica |
| Analista Requisitos | [Nombre] | [email] | PARTES 0, 1, 2 |
| Tech Writer | [Nombre] | [email] | base_cognitiva/ |
| Developer Senior | [Nombre] | [email] | UC v4.0, código Python |
| Product Owner | [Nombre] | [email] | Validación ejemplos IACT |
| CTO | [Nombre] | [email] | Aprobación final |

---

**FIN DEL ANÁLISIS CONSOLIDADO DEFINITIVO**

**Responsable:** Equipo IACT  
**Fecha:** 2026-01-08  
**Versión:** 1.0.0  
**Estado:** Completo - Pendiente Aprobación  
**Próxima Acción:** Reunión de aprobación

**Total Páginas:** ~70  
**Total Palabras:** ~18,000  
**Total Tablas:** 35  
**Total Diagramas:** 8
