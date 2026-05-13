# ANÁLISIS: ¿SE EXPLICAN BUSINESS REQUIREMENTS EN EL DOCUMENTO?

**Fecha:** 2026-01-08  
**Documento analizado:** "Identificación y Modelado Avanzado de Casos de Uso"  
**Pregunta:** ¿El documento explica Business Requirements (BReq)?

---

## HALLAZGOS: MENCIONES A BUSINESS REQUIREMENTS

### 1. Mención Explícita en Sección de Atributos de Calidad

**Cita textual del documento:**

> "tenemos nuestro **diagrama**. Tenemos en esta parte lo que son los **_Atributos de Calidad_**... 
> Ya vimos **Reglas de Negocio**, **Requerimientos de Negocio**, **Requerimientos de Usuario** 
> a través de los **_Casos de Uso_**, lo que viene siendo el **Documento de Visión y Alcance**."

**Análisis:**
- SÍ menciona "Requerimientos de Negocio" (Business Requirements)
- Los menciona como algo que "ya vimos"
- Los coloca en la secuencia: BR → BReq → UR (a través de UC)
- Menciona "Documento de Visión y Alcance" (Vision and Scope Document)

---

### 2. Mención en Contexto de Jerarquía

**Cita textual del documento:**

> "**Requerimientos de Usuario:** Describen los **comportamientos del sistema vistos desde 
> una perspectiva de los usuarios**. Es cómo el sistema se debe de **comportar**. 
> Los **Requerimientos de Usuario** son generalmente descritos en **_Casos de Uso_**"

**Análisis:**
- Define User Requirements (UR)
- Implica que BReq está en un nivel superior
- NO define explícitamente qué son los Business Requirements

---

### 3. Mención en RUP

**Cita textual del documento:**

> "**RUP** tiene **disciplinas** o **flujos de trabajo** que se realizan en **todas las fases**:
> - **Modelado de Negocio** (Business Modeling)
> - **Requerimientos** (Requirements)"

**Análisis:**
- RUP tiene "Business Modeling" como disciplina
- Pero NO explica cómo se documenta BReq
- NO relaciona "Business Modeling" con "Business Requirements"

---

## LO QUE EL DOCUMENTO NO CONTIENE

### ❌ NO HAY:

1. **Definición formal de Business Requirements**
   - No explica qué son los BReq
   - No explica cómo se diferencian de BR
   - No explica su propósito

2. **Metodología para trabajar con BReq**
   - No hay PARTE dedicada a BReq
   - No hay técnicas de licitación para BReq
   - No hay plantillas para documentar BReq

3. **Transformación BR → BReq → UC**
   - El documento salta de BR directo a UC
   - No explica el paso intermedio (BReq)

4. **Ejemplos de Business Requirements**
   - No hay ejemplos concretos de BReq
   - No hay comparación BReq vs BR vs UR

---

## LAS 6 PARTES PEDAGÓGICAS (CONFIRMACIÓN)

Según el documento, las PARTES son:

```
PARTE 1: Identificar Reglas de Negocio (BR)
         └─ Métodos: Actor-Goal, Escenarios, CRUD, Eventos
         └─ Clasificación: 5 tipos de BR
         
PARTE 2: Transformar BR → UC  ← SALTA DIRECTO DE BR A UC
         └─ Patrones de transformación
         └─ Include/Extend
         
PARTE 3: Identificar CU adicionales
         └─ Análisis CRUD
         └─ Técnicas de Larman
         
PARTE 4: Diagramar UML
         └─ Relaciones: Include, Extend, Generalización
         
PARTE 5: Especificar RNF (Atributos de Calidad)
         └─ Técnica SMART
         └─ Priorización
         
PARTE 6: Validar Trazabilidad
         └─ Forward/Backward tracing
```

**CONCLUSIÓN:** NO hay PARTE para Business Requirements

---

## EVIDENCIA DE LA BRECHA METODOLÓGICA

### Jerarquía Teórica Mencionada:

El documento menciona esta jerarquía (implícitamente):

```
Nivel 0: Business Rules (BR)
         ↓
Nivel 1: Business Requirements (BReq)  ← Mencionado pero NO trabajado
         ↓
Nivel 2: User Requirements (UC)
         ↓
Nivel 3: Functional Requirements (FR)
```

### Flujo Real en las 6 PARTES:

```
PARTE 1: Business Rules (BR)
         ↓ (SALTA)
PARTE 2: User Requirements (UC)  ← Sin pasar por BReq
         ↓
Functional Requirements (FR)
```

---

## COMPARACIÓN CON PARTE 0

### En PARTE 0 (el documento anterior):

**SÍ había una sección dedicada a BReq:**

> "Sección 2.3: Nivel 1: Business Requirements
> 
> Los Business Requirements expresan los objetivos de alto nivel que justifican 
> la existencia del proyecto. Responden la pregunta: '¿Por qué estamos 
> construyendo este sistema?'
> 
> Ejemplo:
> 'El Sistema de Seguimiento de Químicos debe permitir el cumplimiento de todas 
> las regulaciones federales y estatales relacionadas con el uso, almacenamiento 
> y disposición de productos químicos peligrosos...'"

### En este documento (Identificación y Modelado):

**NO hay sección dedicada a BReq**

Solo menciona que "ya vimos" Business Requirements, pero:
- No los define
- No los trabaja
- No muestra cómo documentarlos

---

## CONCLUSIONES

### ✅ EL USUARIO TIENE RAZÓN

1. **El documento SÍ menciona que existen Business Requirements**
   - Los lista en la jerarquía conceptual
   - Los nombra como "Requerimientos de Negocio"
   - Los relaciona con "Documento de Visión y Alcance"

2. **Pero NO los explica ni trabaja con ellos**
   - No hay definición formal
   - No hay PARTE pedagógica dedicada
   - No hay metodología para documentarlos

3. **Las 6 PARTES omiten BReq**
   - Van directo de BR (PARTE 1) a UC (PARTE 2)
   - Saltan el nivel intermedio (BReq)
   - No hay transformación BR → BReq

4. **Existe una brecha metodológica**
   - La jerarquía teórica incluye BReq (4 niveles)
   - Las PARTES prácticas omiten BReq (solo 3 niveles trabajados)
   - La metodología es incompleta

---

## POSIBLE EXPLICACIÓN

**Hipótesis 1: BReq se considera "contexto" no "metodología"**

El documento menciona "Documento de Visión y Alcance" junto con BReq:

> "Ya vimos... **Requerimientos de Negocio**, **Requerimientos de Usuario**... 
> lo que viene siendo el **Documento de Visión y Alcance**"

Esto sugiere que los BReq se documentan en el "Vision and Scope Document" 
(mencionado en PARTE 0, Sección 2.3), pero NO se trabajan como parte 
de la metodología de transformación BR → UC → FR.

**Hipótesis 2: Enfoque simplificado**

La metodología presentada es un enfoque simplificado que asume que:
- Los BReq ya están definidos (en el Vision and Scope Document)
- El trabajo práctico empieza con BR (PARTE 1)
- La transformación va directo BR → UC

**Hipótesis 3: BReq = Contexto del proyecto**

Los Business Requirements podrían estar documentados en:
- META_04_Contexto_IACT_1_0_0.rst (de base_cognitiva/)
- Vision and Scope Document (mencionado en PARTE 0)
- Como "entrada" preexistente a la metodología

---

## RECOMENDACIÓN

**Para completar la metodología, se necesitaría:**

1. **Agregar PARTE 0.5 o PARTE 1.5:**
   - Definir Business Requirements
   - Técnicas para identificar BReq
   - Plantilla para documentar BReq
   - Transformación BR → BReq

2. **O explicitar que BReq está fuera del alcance:**
   - Aclarar que BReq se asume como "entrada"
   - Documentar dónde encontrar los BReq (Vision and Scope)
   - Explicar por qué no se trabaja con ellos en las 6 PARTES

---

**FIN DEL ANÁLISIS**

**Respuesta a la pregunta:** NO, el documento NO explica Business Requirements 
de manera completa. Los menciona, pero no los trabaja metodológicamente.
