# ANÁLISIS REVISADO: FND_01-07 vs MODELO_DOCUMENTAL_IACT v2.0.5

**Fecha:** 2026-01-03  
**Revisión:** Enfoque en alineación base_cognitiva/_metadata/ con FND  
**Artefactos:** 7 FND + MODELO_DOCUMENTAL_IACT_v2.0.5

---

## RESUMEN EJECUTIVO REVISADO

| Resultado | Decisión |
|-----------|----------|
| **SE REQUIERE ACTUALIZACIÓN** | v2.0.5 → **v2.0.6** |
| Severidad | 🔴 ALTA (estructura _metadata/ desalineada) |
| Problema Principal | _metadata/ no refleja lo que FND define |

**Hallazgo Crítico:**
Los FND definen una estructura conceptual específica, pero `_metadata/` en el modelo
tiene artefactos que NO corresponden a lo que los FND establecen.

---

## 1. ANÁLISIS DE ESTRUCTURA _metadata/

### 1.1 Lo que dice el MODELO v2.0.5

```
base_cognitiva/
├── _metadata/
│   ├── META_01_Identidad_Proyecto.rst
│   ├── META_02_Clasificacion_Documental.rst
│   ├── META_03_Fases_SDLC.rst
│   ├── META_04_Contexto_IACT.rst          ← "Contiene BReq implícitos"
│   └── META_05_Estructura_Documental.rst
```

### 1.2 Lo que los FND Establecen

Revisando los 7 FND, encontramos que definen conceptos que **deberían estar en _metadata/** o ser referenciados correctamente:

| FND | Define | ¿Dónde debería estar? | ¿Está en _metadata/? |
|-----|--------|----------------------|---------------------|
| FND_01 | Concepto de Requisito | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |
| FND_02 | Reglas de Negocio | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |
| FND_03 | Casos de Uso | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |
| FND_04 | Trazabilidad | Ya está en _fundamentos_conceptuales/ | ⚠️ CORRUPTO |
| FND_05 | Jerarquía 4 Niveles | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |
| FND_06 | Derivación vs Transformación | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |
| FND_07 | Requerimientos Funcionales | Ya está en _fundamentos_conceptuales/ | ✅ Correcto |

### 1.3 Problema Identificado: META_04 como BReq

El modelo v2.0.5 dice:
> "META_04_Contexto_IACT.rst ← Contiene BReq implícitos"

**Pero según FND_05 (Jerarquía 4 Niveles), líneas 154-210:**

```
Nivel 1: Business Requirements (BReq)
- Expresan objetivos de alto nivel
- Responden: "¿Por qué estamos construyendo este sistema?"
- Prefijo: BReq_NNN.rst
- Ubicación esperada: requisitos/objetivos/
```

**Conflicto:**
- FND_05 dice que BReq va en `requisitos/objetivos/`
- MODELO dice que BReq está implícito en `base_cognitiva/_metadata/META_04`
- Estas son ubicaciones y conceptos diferentes

---

## 2. REVISIÓN DE CONTENIDO DE FND vs META

### 2.1 Qué Debería Contener _metadata/

Según la naturaleza de los artefactos META (metadatos del proyecto):

| Artefacto META | Propósito Real | Relación con FND |
|----------------|----------------|------------------|
| META_01_Identidad_Proyecto | Nombre, versión, fechas | Ninguna directa |
| META_02_Clasificacion_Documental | Cómo se organizan docs | FND_05 (jerarquía) |
| META_03_Fases_SDLC | Ciclo de vida | Ninguna directa |
| META_04_Contexto_IACT | Contexto del proyecto | **NO es BReq** |
| META_05_Estructura_Documental | Árbol de carpetas | Este MODELO |

### 2.2 El Problema con META_04 = BReq

**FND_05 define BReq así (líneas 157-165):**
```
Business Requirements expresan los objetivos de alto nivel que
justifican la existencia del proyecto. Responden: "Por que estamos
construyendo este sistema?"

Caracteristicas:
- Estrategicos: Vision de negocio, no tecnica
- Justificativos: Explican el ROI del proyecto
- Influenciados: Por BR, pero no son reiteracion de ellas
- Alcance: Definen limites del proyecto
```

**Ejemplo de BReq correcto (FND_05 línea 199):**
```
Business Requirement (IACT):
"El Sistema IACT Dashboard Analytics debe proporcionar
 visibilidad en tiempo real de las metricas de llamadas
 del IVR, permitiendo a los supervisores identificar
 problemas operacionales y tomar decisiones informadas,
 reduciendo el tiempo de resolucion de incidentes en 40%."
```

**Conclusión:**
- META_04 es "contexto" (descripción del ambiente)
- BReq son "objetivos de negocio medibles"
- **NO son lo mismo**

---

## 3. OPCIONES DE RESOLUCIÓN

### Opción A: Crear requisitos/objetivos/ con BReq formales

```
requisitos/
├── objetivos/                    # NUEVO
│   ├── index.rst
│   ├── BReq_001_Visibilidad_Metricas.rst
│   ├── BReq_002_Reduccion_Tiempo_Incidentes.rst
│   └── BReq_003_Toma_Decisiones_Informada.rst
├── reglas_negocio/
├── casos_uso/
├── funcionales/
└── no_funcionales/
```

**Pros:** Alineación perfecta con FND_05
**Contras:** Más documentos que mantener

### Opción B: Documentar que IACT usa 3 niveles (sin BReq formal)

```
NOTA ARQUITECTÓNICA:
IACT implementa jerarquía de 3 niveles operativos: BR → UC → FR

Justificación: Los Business Requirements están expresados como:
1. Objetivos en META_04_Contexto_IACT (contexto)
2. BR tipo "Desencadenador" que generan UC
3. NFR que definen métricas de éxito

Esta decisión reduce overhead documental sin perder trazabilidad.
```

**Pros:** Pragmático, menos documentos
**Contras:** Desviación de FND_05

### Opción C: Renombrar/Reestructurar META_04

```
base_cognitiva/
├── _metadata/
│   ├── META_01_Identidad_Proyecto.rst
│   ├── META_02_Clasificacion_Documental.rst
│   ├── META_03_Fases_SDLC.rst
│   ├── META_04_Objetivos_Negocio.rst    # Renombrado, incluye BReq
│   └── META_05_Estructura_Documental.rst
```

**Pros:** Menor cambio estructural
**Contras:** META debería ser metadatos, no requisitos
---

## 4. ANÁLISIS DETALLADO: FND_03 vs MODELO (Actores/UC)

### 4.1 Discrepancia de Cantidad de UC

| Fuente | Cantidad UC | Detalle |
|--------|-------------|---------|
| FND_03 sección 8 | 38 UC | Lista explícita en documento |
| MODELO v2.0.5 | 49 UC | Distribuidos en 8 módulos |
| **Diferencia** | **+11 UC** | MODELO tiene más |

### 4.2 UC en FND_03 vs UC en MODELO

**FND_03 lista (líneas 708-783):**
```
Gestión Usuarios: 7 UC (UC-005 a UC-011)
Reportes: 8 UC (UC-017 a UC-024)
Dashboards: 6 UC (UC-025 a UC-030)
Análisis: 5 UC (UC-031 a UC-035)
Alertas: 5 UC (UC-036 a UC-040)
Administración: 7 UC (UC-012 a UC-016, UC-041, UC-042)
TOTAL: 38 UC
```

**MODELO v2.0.5 lista:**
```
auth/: 5 UC (UC-001 a UC-005)
users/: 4 UC (UC-006 a UC-009)
access/: 9 UC (UC-010, UC-011, UC-041 a UC-047)
pipeline/: 4 UC (UC-050 a UC-053)
reports/: 12 UC (UC-017 a UC-029)
alerts/: 5 UC (UC-036 a UC-040)
audit/: 4 UC (UC-060 a UC-063)
logs/: 3 UC (UC-070 a UC-072)
TOTAL: 46 UC visibles + 3 implícitos = 49 UC
```

### 4.3 UC que están en MODELO pero NO en FND_03

| UC | Módulo | Descripción | ¿Por qué falta en FND_03? |
|----|--------|-------------|---------------------------|
| UC-001 a UC-004 | auth/ | Login, logout, password | FND_03 empieza en UC-005 |
| UC-043 a UC-047 | access/ | Gestión avanzada RBAC | Añadidos por RBAC v5.1.1 |
| UC-050 a UC-053 | pipeline/ | Supervisión ETL | No existía módulo pipeline |
| UC-060 a UC-063 | audit/ | Auditoría | No existía módulo audit |
| UC-070 a UC-072 | logs/ | Bitácoras | No existía módulo logs |

### 4.4 Conclusión FND_03

**FND_03 está DESACTUALIZADO respecto al MODELO**
- Falta actualizar lista de UC
- Falta módulos: pipeline, audit, logs
- Actores R00x deben mapearse a AGR-00x

---

## 5. ANÁLISIS DETALLADO: FND_05 vs MODELO (Jerarquía)

### 5.1 Jerarquía según FND_05

```
Nivel 0: BR (Business Rules)      → requisitos/reglas_negocio/
Nivel 1: BReq (Business Req.)     → requisitos/objetivos/
Nivel 2: UC (Use Cases)           → requisitos/casos_uso/
Nivel 3: FR (Functional Req.)     → requisitos/funcionales/
```

### 5.2 Jerarquía según MODELO v2.0.5

```
Nivel 0: BR                       → requisitos/reglas_negocio/ ✅
Nivel 1: BReq                     → [NO EXISTE carpeta] ❌
         (dice: "implícito en META_04")
Nivel 2: UC                       → requisitos/casos_uso/ ✅
Nivel 3: FR                       → requisitos/funcionales/ ✅
```

### 5.3 Resolución Propuesta

**Opción Recomendada: Crear estructura BReq mínima**

Agregar en `requisitos/`:
```
requisitos/
├── objetivos/                    # NUEVO - Nivel 1 BReq
│   ├── index.rst
│   └── BReq_001_Objetivos_IACT.rst   # Documento consolidado
├── reglas_negocio/               # Nivel 0 BR
├── casos_uso/                    # Nivel 2 UC
├── funcionales/                  # Nivel 3 FR
└── no_funcionales/               # NFR
```

**Contenido de BReq_001_Objetivos_IACT.rst:**
```rst
BReq_001: Objetivos de Negocio IACT
===================================

1. BReq-001.1: Visibilidad de Métricas
   "El sistema DEBE proporcionar visibilidad en tiempo real
    de las métricas de llamadas del IVR"

2. BReq-001.2: Reducción Tiempo Incidentes
   "El sistema DEBE reducir el tiempo de resolución de
    incidentes en 40%"

3. BReq-001.3: Toma de Decisiones
   "El sistema DEBE permitir a supervisores identificar
    problemas operacionales y tomar decisiones informadas"

Trazabilidad:
- BReq-001.1 → UC-025 (Dashboard Principal)
- BReq-001.2 → UC-036 a UC-040 (Alertas)
- BReq-001.3 → UC-017 a UC-024 (Reportes)
```

---

## 6. ANÁLISIS FND_04: DOCUMENTO CORRUPTO

### 6.1 Evidencia del Error

```
Archivo: FND_04_Trazabilidad.rst
Contenido real: Copia exacta de FND_03_Casos_de_Uso.rst
```

**Líneas problemáticas:**
- Línea 2: `:artefacto: FND_03` (debería ser FND_04)
- Línea 13: `.. _fnd-03:` (debería ser _fnd-04)
- Línea 16: `FND_03: Casos de Uso` (debería ser FND_04: Trazabilidad)

### 6.2 Contenido Esperado de FND_04

Basado en referencias en otros FND (FND_05 línea 543, FND_06 línea 488):

```rst
FND_04: Trazabilidad
====================

1. Definición de Trazabilidad
   - Capacidad de seguir un requisito desde origen hasta implementación
   - Trazabilidad hacia adelante (forward) y hacia atrás (backward)

2. Tipos de Enlaces
   - deriva: BR→UC, UC→FR
   - influye: BR→UC (sin generar)
   - genera: BReq→UC
   - implementa: FR→CODE
   - verifica: TEST→FR

3. Matriz RTM (Requirements Traceability Matrix)
   - Estructura: filas=requisitos, columnas=artefactos
   - Ubicación: evidencia/trazabilidad/RTM_Master_v1_0_0.rst

4. Métricas de Cobertura
   - BR→UC: 100%
   - UC→FR: 100%
   - FR→CODE: 90%
   - FR→TEST: 80%

5. Herramientas en IACT
   - Sphinx cross-references (:ref:)
   - Tags de trazabilidad en metadata
```

### 6.3 Acción Requerida

**CRÍTICO:** Recrear FND_04_Trazabilidad.rst con contenido correcto antes de cualquier otra actualización.
---

## 7. MATRIZ DE HALLAZGOS CONSOLIDADA (REVISADA)

| ID | Severidad | Ubicación | Descripción | Acción |
|----|-----------|-----------|-------------|--------|
| H-001 | 🔴 CRÍTICA | FND_04 | Archivo corrupto (copia de FND_03) | RECREAR documento |
| H-002 | 🔴 ALTA | MODELO/requisitos/ | Falta carpeta objetivos/ para BReq | CREAR estructura |
| H-003 | 🔴 ALTA | MODELO §1.3 | META_04 NO ES BReq (error conceptual) | CORREGIR texto |
| H-004 | 🟡 MEDIA | FND_03 | Lista UC desactualizada (38 vs 49) | ACTUALIZAR FND_03 |
| H-005 | 🟡 MEDIA | FND_03 | Faltan módulos pipeline/audit/logs | ACTUALIZAR FND_03 |
| H-006 | 🟡 MEDIA | FND_03 | Actores R00x vs Agrupadores AGR-00x | CREAR mapeo |
| H-007 | 🟢 BAJA | MODELO §4.2 | Template BR referencia incompleta | COMPLETAR |
| H-008 | 🟢 BAJA | MODELO §6 | SMART no referenciado explícitamente | AGREGAR ref |

---

## 8. PLAN DE ACCIÓN REVISADO

### 8.1 Fase 0: Corrección Crítica (Antes de todo)

| Acción | Documento | Esfuerzo |
|--------|-----------|----------|
| Recrear FND_04_Trazabilidad.rst | FND_04 | 2h |

### 8.2 Fase 1: Actualización MODELO a v2.0.6

| Cambio | Sección | Descripción |
|--------|---------|-------------|
| AGREGAR | requisitos/objetivos/ | Nueva carpeta con BReq_001 |
| CORREGIR | §1.3 | Eliminar "BReq implícito en META_04" |
| AGREGAR | §2 árbol | Incluir requisitos/objetivos/ |
| ACTUALIZAR | §3.1 diagrama | Mostrar 4 niveles completos |
| AGREGAR | §3.x | Nueva sección explicando BReq |

### 8.3 Fase 2: Actualización FND_03 a v1.2.0

| Cambio | Sección | Descripción |
|--------|---------|-------------|
| ACTUALIZAR | §8 | Lista de 49 UC (no 38) |
| AGREGAR | §3.4 | Módulos pipeline, audit, logs |
| AGREGAR | §3.4 | Mapeo Actores → Agrupadores |

### 8.4 Orden de Ejecución

```
1. [DÍA 1] Recrear FND_04_Trazabilidad.rst
2. [DÍA 1] Crear MODELO_DOCUMENTAL_IACT_v2.0.6
3. [DÍA 2] Actualizar FND_03 a v1.2.0
4. [DÍA 2] Validar consistencia cruzada
```

---

## 9. PROPUESTA: MODELO_DOCUMENTAL_IACT v2.0.6

### 9.1 Cambios Estructurales

**ANTES (v2.0.5):**
```
requisitos/
├── reglas_negocio/      # Nivel 0
├── casos_uso/           # Nivel 2
├── funcionales/         # Nivel 3
└── no_funcionales/
```

**DESPUÉS (v2.0.6):**
```
requisitos/
├── objetivos/           # Nivel 1 - NUEVO
│   ├── index.rst
│   └── BReq_001_Objetivos_IACT.rst
├── reglas_negocio/      # Nivel 0
├── casos_uso/           # Nivel 2
├── funcionales/         # Nivel 3
└── no_funcionales/
```

### 9.2 Cambios en Sección 1.3

**ANTES:**
```
> NOTA IMPORTANTE (v2.0.5):
> Para IACT, implementamos 3 niveles operativos: BR → UC → FR
> El Nivel 1 (BReq) está implícito en META_04_Contexto_IACT.rst.
```

**DESPUÉS:**
```
> NOTA (v2.0.6):
> IACT implementa los 4 niveles definidos en FND_05:
> - Nivel 0: BR (Business Rules) → requisitos/reglas_negocio/
> - Nivel 1: BReq (Business Requirements) → requisitos/objetivos/
> - Nivel 2: UC (Use Cases) → requisitos/casos_uso/
> - Nivel 3: FR (Functional Requirements) → requisitos/funcionales/
>
> Ver FND_05_Jerarquia_4_Niveles.rst para teoría completa.
```

### 9.3 Nueva Sección: Business Requirements

```markdown
## X. BUSINESS REQUIREMENTS (Nivel 1)

### X.1 Definición (FND_05)

Los Business Requirements expresan los objetivos de alto nivel que
justifican la existencia del proyecto IACT.

### X.2 BReq Identificados

| ID | Nombre | Descripción | UC Relacionados |
|----|--------|-------------|-----------------|
| BReq-001 | Visibilidad Métricas | Proporcionar visibilidad en tiempo real de métricas IVR | UC-025, UC-027, UC-028 |
| BReq-002 | Reducción Incidentes | Reducir tiempo resolución incidentes en 40% | UC-036 a UC-040 |
| BReq-003 | Decisiones Informadas | Permitir identificar problemas y tomar decisiones | UC-017 a UC-024 |
| BReq-004 | Cumplimiento Seguridad | Garantizar RBAC y auditoría según CNST_005 | UC-010, UC-060-063 |

### X.3 Ubicación

```
requisitos/objetivos/
├── index.rst
└── BReq_001_Objetivos_IACT.rst
```

### X.4 Relación con BR

Las BR influyen en los BReq pero no los generan directamente:

```
BR_001 (Fuente Inmutable) ──influye──> BReq-001 (Visibilidad)
BR_002 (ETL Nocturno) ──influye──> BReq-001 (Visibilidad)
CNST_005 (Seguridad) ──influye──> BReq-004 (Cumplimiento)
```
```

---

## 10. CHANGELOG PROPUESTO v2.0.5 → v2.0.6

```markdown
| Versión | Cambio |
|---------|--------|
| **v2.0.6** | **CORREGIDO: Agregada carpeta requisitos/objetivos/ para BReq** |
| **v2.0.6** | **CORREGIDO: Eliminado "BReq implícito en META_04" (error conceptual)** |
| **v2.0.6** | **AGREGADO: Sección completa de Business Requirements** |
| **v2.0.6** | **ACTUALIZADO: Diagrama jerarquía muestra 4 niveles completos** |
| **v2.0.6** | **ACTUALIZADO: Árbol incluye requisitos/objetivos/** |
| **v2.0.6** | **NOTA: FND_04 pendiente recreación (archivo corrupto identificado)** |
```

---

## 11. CONCLUSIÓN REVISADA

### 11.1 Estado Real

| Componente | Estado Actual | Estado Requerido |
|------------|---------------|------------------|
| FND_04 | 🔴 CORRUPTO | Recrear |
| FND_03 | 🟡 DESACTUALIZADO | Actualizar a v1.2.0 |
| MODELO v2.0.5 | 🟡 ERROR CONCEPTUAL | Actualizar a v2.0.6 |
| _metadata/ | ✅ CORRECTO | Sin cambios |
| _fundamentos_conceptuales/ | ✅ CORRECTO | (excepto FND_04) |

### 11.2 Resumen de Errores Corregidos

1. **META_04 ≠ BReq:** META_04 es contexto, BReq son objetivos medibles
2. **Falta requisitos/objetivos/:** Debe existir para cumplir FND_05
3. **FND_04 corrupto:** Contiene copia de FND_03
4. **FND_03 desactualizado:** 38 UC vs 49 UC reales

### 11.3 Próximos Pasos

```
┌─────────────────────────────────────────────────────────────┐
│  DECISIÓN: Actualizar a MODELO_DOCUMENTAL_IACT_v2.0.6      │
│                                                             │
│  Cambios principales:                                       │
│  1. Agregar requisitos/objetivos/ con BReq                 │
│  2. Corregir error "BReq en META_04"                       │
│  3. Actualizar diagrama a 4 niveles                        │
│  4. Marcar FND_04 para recreación                          │
└─────────────────────────────────────────────────────────────┘
```

---

*Análisis Revisado FND vs MODELO_DOCUMENTAL_IACT*  
*Fecha: 2026-01-03*  
*Resultado: SE REQUIERE v2.0.6 + Recrear FND_04 + Actualizar FND_03*
