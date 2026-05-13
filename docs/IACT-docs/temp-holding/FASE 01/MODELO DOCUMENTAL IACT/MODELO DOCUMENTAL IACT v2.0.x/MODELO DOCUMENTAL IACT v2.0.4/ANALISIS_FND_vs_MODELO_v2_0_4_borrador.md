# ANÁLISIS DE ALINEACIÓN: FND_01-07 vs MODELO_DOCUMENTAL_IACT_v2.0.4

**Fecha:** 2026-01-03  
**Objetivo:** Determinar si el MODELO_DOCUMENTAL necesita actualización a v2.1.4  
**Artefactos Analizados:** 7 FND + MODELO_DOCUMENTAL_IACT_v2.0.4

---

## RESUMEN EJECUTIVO

| Resultado | Decisión |
|-----------|----------|
| **SE REQUIERE ACTUALIZACIÓN** | v2.0.4 → **v2.0.5** |
| Severidad | 🟡 MEDIA (inconsistencias, no errores críticos) |
| FND con desalineación | 4 de 7 (57%) |
| FND alineados | 3 de 7 (43%) |

**Nota:** La actualización propuesta es v2.0.5 (no v2.1.4) porque los cambios son correcciones menores, no cambios estructurales que justifiquen incremento de minor version.

---

## 1. ANÁLISIS POR DOCUMENTO FND

### 1.1 FND_01: Concepto de Requisito

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO

| Aspecto | FND_01 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Tipos requisitos | FR y NFR | FR y NFR en requisitos/ | ✅ |
| Prefijos | BR, UC, FR, NFR | BR, UC, FR, NFR | ✅ |
| Ubicación FR | requisitos/funcionales/ | requisitos/funcionales/{modulo}/ | ✅ |
| Nomenclatura | FR-NNN.X | FR_UC[NNN]_xxx.rst | ✅ |

**Hallazgos:** Ninguno. Documento base conceptual alineado.

---

### 1.2 FND_02: Reglas de Negocio

**Versión FND:** 1.1.0 (2025-12-21)  
**Estado:** ⚠️ DESALINEACIÓN PARCIAL

| Aspecto | FND_02 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| 5 tipos BR | Fact, Constraint, Trigger, Inference, Calculation | Hecho, Restricción, Desencadenador, Inferencia, Cálculo | ✅ |
| Cantidad BR | ~15-20 típico | 20 BR identificadas | ✅ |
| Nomenclatura | BR_NNN_Nombre.rst | BR_NNN_Nombre.rst | ✅ |
| Campos obligatorios | Definición, Tipo, Modalidad, Fuente, Fecha Vigencia | **NO DOCUMENTADO** en modelo | ❌ |
| Campos adicionales | Prioridad, Estática/Dinámica, Justificación, Ejemplo | **NO DOCUMENTADO** en modelo | ❌ |

**Hallazgo H-001:** 🔴 DESALINEACIÓN
- FND_02 define template completo con 9 campos para cada BR
- MODELO v2.0.4 solo lista BR sin especificar campos requeridos
- **Impacto:** Al documentar las 20 BR, no hay guía de qué campos incluir

**Acción requerida:** Agregar sección "Template BR" en MODELO v2.0.5 o referenciar TPL_001_Plantilla_BR.rst

---

### 1.3 FND_03: Casos de Uso

**Versión FND:** 1.1.0 (2025-12-21)  
**Estado:** ⚠️ DESALINEACIÓN SIGNIFICATIVA

| Aspecto | FND_03 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Cantidad UC | 38 identificados | 49 identificados | ❌ |
| Actores RBAC | 18 roles (R001-R018) | 44 funciones atómicas | ❌ CONFLICTO |
| Categorías módulos | Usuarios, Reportes, Dashboards, Análisis, Alertas, Admin | Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs | ⚠️ PARCIAL |
| Técnicas derivación UC | 5 técnicas (22%/40%/22%/11%/5%) | No documentado | ❌ |
| UC por módulo | 7+8+6+5+5+7 = 38 | 5+4+9+4+12+5+4+3 = 46 visibles | ⚠️ |

**Hallazgo H-002:** 🔴 CONFLICTO CRÍTICO - Actores vs Funciones
- FND_03 define actores como 18 ROLES (R001-R018): USERS_FULL_MANAGER, DASHBOARD_VIEWER, etc.
- MODELO v2.0.4/RBAC v5.1.1 usa 44 FUNCIONES ATÓMICAS: crea_usuarios, ve_reportes, etc.
- **Filosofía "Sin Pretensiones" contradice nomenclatura FND_03**

**Hallazgo H-003:** 🟡 DISCREPANCIA - Cantidad UC
- FND_03: 38 UC identificados
- MODELO v2.0.4: 49 UC identificados
- Diferencia: +11 UC no documentados en FND_03

**Hallazgo H-004:** 🟡 MÓDULOS DIFERENTES
- FND_03 menciona: Dashboards (6 UC), Análisis (5 UC)
- MODELO v2.0.4 NO tiene módulo MOD_Dashboard ni MOD_Analysis
- UC-025 a UC-035 están en "reports/" pero FND_03 los separa

---

### 1.4 FND_04: Trazabilidad

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** 🔴 ERROR CRÍTICO - ARCHIVO CORRUPTO

**Hallazgo H-005:** 🔴 ARCHIVO DUPLICADO
```
FND_04_Trazabilidad.rst contiene el contenido de FND_03_Casos_de_Uso.rst
- Línea 3: :artefacto: FND_03 (debería ser FND_04)
- Línea 13: .. _fnd-03: (debería ser _fnd-04)
- Título: FND_03: Casos de Uso (debería ser FND_04: Trazabilidad)
```

**Impacto:** 
- FND_04 no existe realmente
- No hay documento de Trazabilidad en fundamentos conceptuales
- Referencias cruzadas en FND_05 y FND_06 apuntan a documento inexistente

**Acción CRÍTICA:** Crear FND_04_Trazabilidad.rst con contenido correcto
---

### 1.5 FND_05: Jerarquía de 4 Niveles

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ⚠️ DESALINEACIÓN PARCIAL

| Aspecto | FND_05 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Nivel 0 | BR (Business Rules) | BR en requisitos/reglas_negocio/ | ✅ |
| Nivel 1 | BReq (Business Requirements) | **NO EXISTE** subcarpeta objetivos/ | ❌ |
| Nivel 2 | UC (Use Cases) | UC en requisitos/casos_uso/ | ✅ |
| Nivel 3 | FR (Functional Requirements) | FR en requisitos/funcionales/ | ✅ |
| Prefijo BReq | BReq_NNN.rst | **NO DOCUMENTADO** | ❌ |
| Ubicación BReq | requisitos/objetivos/ | **NO EXISTE** en árbol | ❌ |

**Hallazgo H-006:** 🔴 NIVEL 1 (BReq) NO IMPLEMENTADO
- FND_05 define 4 niveles: BR → BReq → UC → FR
- MODELO v2.0.4 solo implementa 3 niveles: BR → UC → FR
- **BReq (Business Requirements) está ausente del modelo**

```
FND_05 líneas 500-510:
   requisitos/
       +--- reglas_negocio/      <- Nivel 0 (BR)
       +--- objetivos/           <- Nivel 1 (BReq) ❌ NO EXISTE EN v2.0.4
       +--- casos_uso/           <- Nivel 2 (UC)
       +--- funcionales/         <- Nivel 3 (FR)
```

**Hallazgo H-007:** 🟡 CANTIDADES DESALINEADAS
- FND_05 ejemplo típico: "5-20 BR → 3-10 BReq → 30-100 UC → 200-1000 FR"
- MODELO v2.0.4: 20 BR → 0 BReq → 49 UC → ~400 FR estimados
- BReq completamente ausente

**Decisión requerida:**
1. **Opción A:** Agregar requisitos/objetivos/ con BReq al modelo
2. **Opción B:** Actualizar FND_05 para reflejar modelo de 3 niveles
3. **Opción C:** Documentar que BReq está implícito en META_04_Contexto_IACT

---

### 1.6 FND_06: Derivación vs Transformación

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO

| Aspecto | FND_06 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Concepto derivación | Explicitar lo implícito | Cadena BR→UC→FR | ✅ |
| Dirección Greenfield | BR→UC→FR→Código | Orden ejecución: BR→UC→FR | ✅ |
| SRP por nivel | Cada nivel responsabilidad única | Niveles separados en subdominios | ✅ |
| Ejemplo SoD | BR_015 → UC_010 → FR-10.x | BR_007 → UC-043 → (pendiente FR) | ✅ |

**Hallazgos:** Ninguno significativo. El principio de derivación está correctamente aplicado.

**Nota menor:** El ejemplo en FND_06 usa BR_015 para SoD, pero MODELO v2.0.4 usa BR_007. Esto es solo diferencia de numeración, no de concepto.

---

### 1.7 FND_07: Requerimientos Funcionales

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO CON OBSERVACIONES

| Aspecto | FND_07 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Nomenclatura FR | FR-[UC].[SEQ] | FR_UC[NNN]_Nombre.rst | ✅ |
| Ubicación | requisitos/funcionales/ | requisitos/funcionales/{modulo}/ | ✅ |
| Template | 6 campos definidos | Referencia a TPL_003 | ✅ |
| SMART criteria | Documented | No explícito en modelo | ⚠️ |
| Ratio UC:FR | 1:8 típico | 1:8 documentado | ✅ |

**Hallazgo H-008:** 🟢 OBSERVACIÓN MENOR
- FND_07 documenta criterios SMART extensamente
- MODELO v2.0.4 no menciona SMART explícitamente
- No es error, pero podría referenciarse
---

## 2. MATRIZ DE HALLAZGOS CONSOLIDADA

| ID | Severidad | FND | Descripción | Impacto |
|----|-----------|-----|-------------|---------|
| H-001 | 🟡 MEDIA | FND_02 | Template BR no documentado en modelo | Inconsistencia al crear BR |
| H-002 | 🔴 ALTA | FND_03 | Conflicto Actores (18 Roles) vs Funciones (44 atómicas) | Confusión conceptual |
| H-003 | 🟡 MEDIA | FND_03 | Discrepancia cantidad UC (38 vs 49) | FND desactualizado |
| H-004 | 🟡 MEDIA | FND_03 | Módulos Dashboards/Análisis no existen en modelo | Estructura diferente |
| H-005 | 🔴 CRÍTICA | FND_04 | Archivo corrupto/duplicado de FND_03 | Documento inexistente |
| H-006 | 🔴 ALTA | FND_05 | Nivel 1 (BReq) no implementado en modelo | Gap estructural |
| H-007 | 🟡 MEDIA | FND_05 | Cantidades típicas no coinciden | Referencia incorrecta |
| H-008 | 🟢 BAJA | FND_07 | SMART no referenciado en modelo | Mejora opcional |

---

## 3. ANÁLISIS DE CONFLICTO CRÍTICO: ACTORES vs FUNCIONES

### 3.1 El Problema

**FND_03 (líneas 255-290)** define actores como ROLES con nomenclatura "pretenciosa":
```
R001: USERS_FULL_MANAGER
R008: DASHBOARD_VIEWER
R016: SYSTEM_ADMIN
R017: AUDIT_VIEWER
```

**MODELO v2.0.4 / RBAC v5.1.1** usa FUNCIONES con filosofía "Sin Pretensiones":
```
USR-001: crea_usuarios
RPT-001: ve_reportes
AUD-001: ve_auditoria
```

### 3.2 Análisis de Impacto

| Documento | Usa Roles (R00x) | Usa Funciones (XXX-00x) |
|-----------|-----------------|-------------------------|
| FND_03 | ✅ Exclusivo | ❌ No menciona |
| MODELO v2.0.4 | ❌ No menciona | ✅ Exclusivo |
| RBAC v5.1.1 | ❌ Eliminados | ✅ 44 funciones |
| UC documentados | R00x como actor | Debería usar funciones |

### 3.3 Decisión Requerida

**Opción A: Actualizar FND_03** (RECOMENDADA)
- Cambiar actores de R00x a funciones atómicas
- Alinear con filosofía "Sin Pretensiones"
- Actualizar lista de UC con nuevos 11 identificados

**Opción B: Mantener roles como concepto separado**
- Roles = Agrupadores (AGR-001 a AGR-010)
- Funciones = Permisos atómicos
- Requiere clarificación en ambos documentos

**Opción C: Híbrido**
- FND_03 documenta ACTORES como concepto abstracto
- MODELO implementa actores via AGRUPADORES
- Mapeo explícito: R001 = AGR-001, etc.

---

## 4. ANÁLISIS DEL ERROR FND_04

### 4.1 Evidencia del Error

```rst
Archivo: FND_04_Trazabilidad.rst
Línea 2-3:
   :artefacto: FND_03        ← ERROR (debería ser FND_04)
   :tipo: Fundamento Conceptual

Línea 13:
   .. _fnd-03:               ← ERROR (debería ser _fnd-04)

Línea 15-17:
   ==============================================================
   FND_03: Casos de Uso      ← ERROR (debería ser FND_04: Trazabilidad)
   ==============================================================
```

### 4.2 Contenido Esperado de FND_04

Basado en referencias en otros FND, FND_04 debería contener:

```
FND_04: Trazabilidad
1. Definición de trazabilidad
2. Tipos de enlaces (deriva, influye, genera, verifica)
3. Matriz RTM (Requirements Traceability Matrix)
4. Métricas de cobertura
5. Herramientas de trazabilidad
```

### 4.3 Impacto

- FND_05 línea 543 referencia `:ref:`fnd-04`` → apunta a documento corrupto
- FND_06 línea 488 referencia `:ref:`fnd-04`` → apunta a documento corrupto
- MODELO v2.0.4 sección 6 menciona métricas RTM sin FND de respaldo

---

## 5. ANÁLISIS DEL GAP: NIVEL BReq

### 5.1 El Gap

FND_05 define jerarquía de 4 niveles:
```
Nivel 0: BR (Business Rules)
Nivel 1: BReq (Business Requirements)  ← NO EXISTE EN MODELO
Nivel 2: UC (Use Cases)
Nivel 3: FR (Functional Requirements)
```

MODELO v2.0.4 implementa 3 niveles:
```
requisitos/
├── reglas_negocio/     ← Nivel 0 (BR) ✅
├── casos_uso/          ← Nivel 2 (UC) ✅
├── funcionales/        ← Nivel 3 (FR) ✅
└── no_funcionales/     ← NFR ✅
```

### 5.2 ¿Dónde está BReq?

**Posibilidad 1:** Implícito en META_04_Contexto_IACT.rst
- El contexto del proyecto contiene objetivos de negocio
- No está formalizado como BReq_NNN

**Posibilidad 2:** No se necesita para IACT
- Proyecto interno, no contractual
- BR directamente genera UC
- BReq es redundante

**Posibilidad 3:** Omisión accidental
- Debería existir requisitos/objetivos/
- Falta documentar BReq_001 a BReq_00N

### 5.3 Recomendación

**Opción elegida: Documentar como decisión explícita**

Agregar en MODELO v2.0.5:
```
NOTA: El Nivel 1 (BReq) definido en FND_05 está implícito en 
META_04_Contexto_IACT. Para IACT, la cadena de derivación es:
BR → UC → FR (3 niveles operativos)

Justificación: IACT es proyecto interno donde los objetivos de 
negocio están documentados en el contexto, no requieren 
formalización separada como BReq.
```
---

## 6. PLAN DE ACCIÓN

### 6.1 Acciones sobre FND (Fundamentos)

| Prioridad | Acción | Responsable | Esfuerzo |
|-----------|--------|-------------|----------|
| 🔴 CRÍTICA | Recrear FND_04_Trazabilidad.rst con contenido correcto | Documentador | 4h |
| 🔴 ALTA | Actualizar FND_03 actores: R00x → Funciones/Agrupadores | Documentador | 2h |
| 🟡 MEDIA | Actualizar FND_03 cantidad UC: 38 → 49 | Documentador | 1h |
| 🟡 MEDIA | Actualizar FND_03 módulos: agregar mapping a estructura real | Documentador | 1h |
| 🟢 BAJA | Revisar FND_05 para documentar decisión sobre BReq | Documentador | 30m |

### 6.2 Acciones sobre MODELO_DOCUMENTAL

| Prioridad | Acción | Sección Afectada | Esfuerzo |
|-----------|--------|------------------|----------|
| 🟡 MEDIA | Agregar referencia a template BR (FND_02/TPL_001) | Sección 4.2 | 30m |
| 🟡 MEDIA | Documentar decisión sobre BReq (Nivel 1) | Nueva sección | 30m |
| 🟡 MEDIA | Agregar mapeo Actores FND_03 ↔ Agrupadores RBAC | Sección 5.1 | 1h |
| 🟢 BAJA | Referenciar criterios SMART de FND_07 | Sección 3.3 | 15m |

### 6.3 Priorización de Versiones

**Fase 1: Corrección Crítica FND_04** (antes de cualquier otra cosa)
```
FND_04_Trazabilidad.rst → Crear documento correcto
Versión FND_04: 1.0.0
```

**Fase 2: MODELO_DOCUMENTAL v2.0.5** (cambios menores)
```
Cambios:
1. Nota sobre BReq implícito
2. Referencia a template BR
3. Mapeo actores ↔ agrupadores
4. Referencia SMART
```

**Fase 3: Actualización FND_03** (alineación con RBAC v5.1.1)
```
FND_03 v1.2.0:
1. Actores basados en Agrupadores, no Roles fijos
2. Lista actualizada de 49 UC
3. Módulos alineados con estructura real
```

---

## 7. PROPUESTA DE CONTENIDO FND_04_Trazabilidad

### 7.1 Estructura Propuesta

```rst
FND_04: Trazabilidad
====================

1. Definición de Trazabilidad
   - Qué es trazabilidad de requisitos
   - Por qué es importante
   - Trazabilidad bidireccional

2. Tipos de Enlaces
   - deriva (BR→UC, UC→FR)
   - influye (BR→UC sin generar)
   - genera (BReq→UC)
   - implementa (FR→CODE)
   - verifica (TEST→FR)

3. Matriz RTM (Requirements Traceability Matrix)
   - Estructura de la matriz
   - Herramientas (Sphinx cross-references)
   - Mantenimiento

4. Métricas de Cobertura
   - BR→UC: 100%
   - UC→FR: 100%
   - FR→CODE: 90%
   - FR→TEST: 80%

5. Trazabilidad en IACT
   - Ubicación: evidencia/trazabilidad/
   - RTM_Master_v1_0_0.rst
   - COV_001_Reporte_Cobertura.rst
```

### 7.2 Contenido Clave (extracto)

```rst
2. Tipos de Enlaces
-------------------

2.1 Enlace "deriva"
^^^^^^^^^^^^^^^^^^^

Relación donde un artefacto de nivel inferior se genera 
DIRECTAMENTE de un artefacto de nivel superior.

.. code-block:: text

   BR_002 (ETL Batch Nocturno)
       |
       | deriva (tipo Trigger genera UC)
       v
   UC_050 (Supervisar ETL)
       |
       | deriva (paso UC genera FR)
       v
   FR-050.1, FR-050.2, ...

Cardinalidad: 1 BR Trigger : 1 UC
              1 UC : N FR (típico N=8)
```

---

## 8. CONCLUSIÓN Y RECOMENDACIÓN

### 8.1 Estado Actual

| Documento | Estado | Acción |
|-----------|--------|--------|
| FND_01 | ✅ Alineado | Ninguna |
| FND_02 | ⚠️ Parcial | Referenciar en modelo |
| FND_03 | ❌ Desalineado | Actualizar FND |
| FND_04 | 🔴 Corrupto | RECREAR |
| FND_05 | ⚠️ Parcial | Documentar decisión BReq |
| FND_06 | ✅ Alineado | Ninguna |
| FND_07 | ✅ Alineado | Referencia SMART opcional |

### 8.2 Recomendación Final

```
┌─────────────────────────────────────────────────────────────┐
│  DECISIÓN: Actualizar a MODELO_DOCUMENTAL_IACT_v2.0.5      │
│                                                             │
│  Razón: Los cambios son correcciones menores y             │
│         clarificaciones, no cambios estructurales.          │
│                                                             │
│  v2.1.x se reservaría para:                                │
│  - Agregar nuevo dominio                                   │
│  - Cambiar estructura de árbol                             │
│  - Modificar jerarquía de derivación                       │
└─────────────────────────────────────────────────────────────┘
```

### 8.3 Orden de Ejecución

```
1. [CRÍTICO] Crear FND_04_Trazabilidad.rst correcto
2. [ALTO]    Crear MODELO_DOCUMENTAL_IACT_v2.0.5
3. [MEDIO]   Actualizar FND_03 a v1.2.0
4. [BAJO]    Revisar FND_05 para nota sobre BReq
```

---

## 9. CHANGELOG PROPUESTO v2.0.4 → v2.0.5

```markdown
| Versión | Cambio |
|---------|--------|
| v2.0.5 | Documentada decisión: BReq (Nivel 1) implícito en META_04 |
| v2.0.5 | Agregada referencia a template BR (TPL_001, FND_02) |
| v2.0.5 | Agregado mapeo Actores FND_03 ↔ Agrupadores RBAC v5.1.1 |
| v2.0.5 | Agregada referencia a criterios SMART (FND_07) |
| v2.0.5 | Corregida referencia a FND_04 (pendiente recreación) |
```

---

*Análisis FND vs MODELO_DOCUMENTAL_IACT v2.0.4*  
*Fecha: 2026-01-03*  
*Resultado: SE REQUIERE v2.0.5 + Corrección FND_04*
