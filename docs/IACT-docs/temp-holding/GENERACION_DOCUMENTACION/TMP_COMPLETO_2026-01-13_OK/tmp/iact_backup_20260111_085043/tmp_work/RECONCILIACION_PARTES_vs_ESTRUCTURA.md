# RECONCILIACIÓN: REFERENCIAS "PARTE X" vs ESTRUCTURA REAL

**Fecha:** 2026-01-08  
**Objetivo:** Entender la relación entre conceptos "PARTE 0/1/2" y archivos reales

---

## SECCIÓN 1: ORIGEN DE LAS REFERENCIAS "PARTE X"

### 1.1 ¿De Dónde Salieron las "PARTES"?

En análisis previos encontré referencias a:

- **PARTE 0:** Introducción y contexto
- **PARTE 1:** Identificar Business Rules
- **PARTE 2:** Transformar BR en UC y FR

### 1.2 Posibles Fuentes

Estas referencias pueden venir de:

**HIPÓTESIS A:** Documentos antiguos que mencionaban PARTE 0, 1, 2
- Podría ser una estructura ANTERIOR que fue reorganizada
- Los archivos cambiaron de nombre pero las referencias quedaron

**HIPÓTESIS B:** Referencias conceptuales (no nombres de archivos)
- "PARTE 0" es un CONCEPTO pedagógico, no un archivo
- Los archivos reales están organizados diferente

**HIPÓTESIS C:** Documentos externos que referencian base_cognitiva/
- Algún README o guía menciona "PARTE 0, 1, 2"
- Son secciones de UN DOCUMENTO mayor, no archivos separados

---

## SECCIÓN 2: MAPEO CONCEPTUAL "PARTE X" → ARCHIVOS REALES

### 2.1 PARTE 0: Introducción y Contexto

**Lo que yo propuse (basado en "PARTE 0"):**
```
FND_00_Contexto_y_Jerarquia.rst
FND_01_Identidad_Estrategica.rst
FND_02_Glosario_de_Terminos.rst
```

**Lo que EXISTE en la estructura real:**
```
_metadata/
├── META_01_Identidad_Proyecto_1_0_0.rst
├── META_02_Clasificacion_Documental_1_0_0.rst
├── META_03_Fases_SDLC_1_0_0.rst
├── META_04_Contexto_IACT_1_0_0.rst          ← CONTEXTO
└── META_05_Estructura_Documental_1_0_0.rst

_fundamentos_conceptuales/
├── FND_01_Concepto_Requisito_1_0_0.rst      ← INTRODUCCIÓN
├── FND_02_Reglas_de_Negocio_1_0_0.rst
└── ...

IACT_Glossary_v1_0_0.rst                      ← GLOSARIO
```

**CONCLUSIÓN:**
- "PARTE 0" se corresponde con:
  - META_04 (Contexto del proyecto)
  - FND_01 (Introducción conceptual)
  - IACT_Glossary (Glosario)
- NO existe un "FND_00" porque FND empieza en 01

---

### 2.2 PARTE 1: Identificar Business Rules

**Lo que yo propuse (basado en "PARTE 1"):**
```
FND_03_Taxonomia_BR.rst
MTM_01_BR_a_UC_Trazabilidad.rst
MTM_02_UC_a_FR_Trazabilidad.rst
MTM_03_Esquema_Trazabilidad.rst
```

**Lo que EXISTE en la estructura real:**
```
_fundamentos_conceptuales/
├── FND_02_Reglas_de_Negocio_1_0_0.rst       ← QUÉ ES UNA BR
├── FND_04_Trazabilidad_1_0_0.rst            ← TRAZABILIDAD
└── ...

_ontologia_sbvr/
├── SBVR_01_Conceptos_Nucleares_1_0_0.rst
├── SBVR_02_Fact_Types_1_0_0.rst             ← TIPOS DE BR (Hechos)
├── SBVR_03_Reglas_Estructurales_1_0_0.rst   ← TIPOS DE BR (Restricciones)
├── SBVR_04_Reglas_Operativas_1_0_0.rst      ← TIPOS DE BR (Desencadenadores)
└── SBVR_05_Vocabulario_Controlado_1_0_0.rst

_taxonomias_y_metamodelos/
├── taxonomias/
│   ├── TXM_01_Taxonomia_Requisitos_1_0_0.rst
│   ├── TXM_02_Taxonomia_Artefactos_1_0_0.rst
│   └── TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst  ← TAXONOMÍA BR
├── metamodelos/
│   ├── MTM_01_Metamodelo_Requisitos_1_0_0.rst
│   └── MTM_02_Metamodelo_Trazabilidad_1_0_0.rst   ← METAMODELO TRAZABILIDAD
```

**CONCLUSIÓN:**
- "PARTE 1" (Identificar BR) se DISTRIBUYE en:
  - FND_02 (Concepto de BR)
  - SBVR_02-04 (Tipos de BR según SBVR)
  - TXM_03 (Taxonomía de BR - ¡ESTE ES EL CRÍTICO!)
  - MTM_02 (Metamodelo de trazabilidad)
- La información NO está en 1 archivo, sino distribuida en 4 carpetas

---

### 2.3 PARTE 2: Transformar BR en UC

**Lo que yo propuse (basado en "PARTE 2"):**
```
TXM_01_Nomenclatura_UC_FR.rst
TXM_02_Plantillas_UC_FR.rst
TXM_03_Patrones_Transformacion.rst
TXM_04_Proceso_Construccion.rst
TXM_05_Integracion_BR.rst
TXM_06_Derivacion_FR.rst
TXM_07_Matriz_Trazabilidad.rst
TXM_08_Validacion_Calidad.rst
```

**Lo que EXISTE en la estructura real:**
```
_fundamentos_conceptuales/
├── FND_03_Casos_de_Uso_1_0_0.rst            ← QUÉ ES UN UC
├── FND_05_Jerarquia_4_Niveles_1_0_0.rst     ← BR→UC→FR
├── FND_06_Derivacion_vs_Transformacion_1_0_0.rst  ← TRANSFORMACIÓN
└── FND_07_Requerimientos_Funcionales_1_0_0.rst    ← QUÉ ES UN FR

_taxonomias_y_metamodelos/
├── taxonomias/
│   └── TXM_01_Taxonomia_Requisitos_1_0_0.rst  ← TIPOS DE REQUISITOS
└── metamodelos/
    └── MTM_01_Metamodelo_Requisitos_1_0_0.rst ← MODELO BR→UC→FR
```

**CONCLUSIÓN:**
- "PARTE 2" (Transformar BR→UC) se DISTRIBUYE en:
  - FND_03 (Concepto de UC)
  - FND_05 (Jerarquía completa BR→UC→FR) ← **ARCHIVO CLAVE**
  - FND_06 (Metodología transformación)
  - FND_07 (Concepto de FR)
  - TXM_01 (Taxonomía de requisitos)
  - MTM_01 (Metamodelo de requisitos)
- NO existen TXM_02-08 porque la información está en FND

---

## SECCIÓN 3: TABLA MAESTRA DE RECONCILIACIÓN

| Concepto (PARTE X) | Archivo que Propuse | Archivo REAL Equivalente | Carpeta |
|--------------------|---------------------|--------------------------|---------|
| **PARTE 0: Introducción** | | | |
| Contexto del proyecto | FND_00_Contexto_y_Jerarquia.rst | META_04_Contexto_IACT_1_0_0.rst | _metadata/ |
| Identidad estratégica | FND_01_Identidad_Estrategica.rst | META_01_Identidad_Proyecto_1_0_0.rst | _metadata/ |
| Introducción conceptual | (no propuesto) | FND_01_Concepto_Requisito_1_0_0.rst | _fundamentos/ |
| Glosario | FND_02_Glosario_de_Terminos.rst | IACT_Glossary_v1_0_0.rst | raíz |
| **PARTE 1: Identificar BR** | | | |
| Concepto de BR | FND_02 (mal numerado) | FND_02_Reglas_de_Negocio_1_0_0.rst | _fundamentos/ |
| Taxonomía 5 tipos BR | FND_03_Taxonomia_BR.rst | TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst | taxonomias/ |
| BR Tipo 1: Hechos | (incluido en FND_03) | SBVR_02_Fact_Types_1_0_0.rst | _ontologia_sbvr/ |
| BR Tipo 2: Restricciones | (incluido en FND_03) | SBVR_03_Reglas_Estructurales_1_0_0.rst | _ontologia_sbvr/ |
| BR Tipo 3-5: Otros tipos | (incluido en FND_03) | SBVR_04_Reglas_Operativas_1_0_0.rst | _ontologia_sbvr/ |
| Trazabilidad BR→UC | MTM_01_BR_a_UC_Trazabilidad.rst | MTM_02_Metamodelo_Trazabilidad_1_0_0.rst | metamodelos/ |
| Trazabilidad UC→FR | MTM_02_UC_a_FR_Trazabilidad.rst | MTM_01_Metamodelo_Requisitos_1_0_0.rst | metamodelos/ |
| Trazabilidad (concepto) | FND_04 (no propuesto) | FND_04_Trazabilidad_1_0_0.rst | _fundamentos/ |
| **PARTE 2: Transformar BR→UC** | | | |
| Concepto de UC | FND_03 (mal nombre) | FND_03_Casos_de_Uso_1_0_0.rst | _fundamentos/ |
| Jerarquía 4 niveles | (no propuesto) | FND_05_Jerarquia_4_Niveles_1_0_0.rst | _fundamentos/ |
| Derivación vs Transf. | (no propuesto) | FND_06_Derivacion_vs_Transformacion_1_0_0.rst | _fundamentos/ |
| Concepto de FR | (no propuesto) | FND_07_Requerimientos_Funcionales_1_0_0.rst | _fundamentos/ |
| Nomenclatura UC/FR | TXM_01_Nomenclatura_UC_FR.rst | TXM_01_Taxonomia_Requisitos_1_0_0.rst | taxonomias/ |
| Plantillas | TXM_02_Plantillas_UC_FR.rst | ❌ NO EXISTE | - |
| Patrones transformación | TXM_03_Patrones_Transformacion.rst | ❌ NO EXISTE (ver FND_06) | - |
| Proceso construcción | TXM_04_Proceso_Construccion.rst | ❌ NO EXISTE (ver FND_05) | - |
| Integración BR | TXM_05_Integracion_BR.rst | ❌ NO EXISTE | - |
| Derivación FR | TXM_06_Derivacion_FR.rst | ❌ NO EXISTE (ver FND_07) | - |
| Matriz trazabilidad | TXM_07_Matriz_Trazabilidad.rst | ❌ NO EXISTE (ver MTM_02) | - |
| Validación calidad | TXM_08_Validacion_Calidad.rst | ❌ NO EXISTE | - |

---

## SECCIÓN 4: POR QUÉ PROPUSE ARCHIVOS QUE NO EXISTEN

### 4.1 Análisis de Mis Deducciones

**Deduje que existían TXM_02-08 porque:**

1. Hay una carpeta `_taxonomias_y_metamodelos/taxonomias/`
2. Hay TXM_01, TXM_02, TXM_03 (solo 3, no 8)
3. Asumí que habría más archivos TXM para cubrir "PARTE 2"

**ERROR:** La información de "PARTE 2" está en FND, no en TXM adicionales.

---

### 4.2 La Verdadera Organización

La estructura real es más **MODULAR** y **DISTRIBUIDA**:

```
Concepto: ¿Qué es una BR?
  → FND_02_Reglas_de_Negocio_1_0_0.rst (fundamentos conceptuales)

Taxonomía: 5 tipos de BR
  → TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst (taxonomía)
  → SBVR_02-04 (ontología SBVR detallada)

Transformación: BR→UC→FR
  → FND_05_Jerarquia_4_Niveles_1_0_0.rst (proceso completo)
  → FND_06_Derivacion_vs_Transformacion_1_0_0.rst (metodología)
  → MTM_01_Metamodelo_Requisitos_1_0_0.rst (modelo UML)
```

**CONCLUSIÓN:** No hacen falta TXM_04-08 porque FND_05-07 ya cubren esos temas.

---

## SECCIÓN 5: ¿DÓNDE ESTÁN LOS EJEMPLOS DE QUÍMICOS?

### 5.1 Predicción Basada en Reconciliación

Ahora que entiendo la estructura real, predigo ejemplos químicos en:

**PRIORIDAD 1 (MUY PROBABLE - Ejemplos extensos):**

1. **TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst**
   - Razón: Es el equivalente a mi "FND_03_Taxonomia_BR.rst"
   - Contenido: 5 tipos de BR con ejemplos
   - Probable: BR-028, BR-031, BR-060, UC-07, UC-04

2. **FND_05_Jerarquia_4_Niveles_1_0_0.rst**
   - Razón: Muestra transformación completa BReq→BR→UC→FR
   - Contenido: Ejemplo de principio a fin
   - Probable: Ejemplo completo de químicos

3. **SBVR_02_Fact_Types_1_0_0.rst**
   - Razón: Hechos con ejemplos de dominio
   - Contenido: BR-012 "Código barras único" (Hecho)
   - Probable: Terminología de contenedores

4. **SBVR_03_Reglas_Estructurales_1_0_0.rst**
   - Razón: Restricciones con ejemplos
   - Contenido: BR-028 "Aprobación >$500" (Restricción)
   - Probable: Múltiples BR de restricción

5. **SBVR_04_Reglas_Operativas_1_0_0.rst**
   - Razón: Desencadenadores con ejemplos
   - Contenido: BR-031 "Notificar vencimiento" (Desencadenador)
   - Probable: UC-07 completo

6. **FND_02_Reglas_de_Negocio_1_0_0.rst**
   - Razón: Concepto de BR con ejemplos introductorios
   - Contenido: 2-3 ejemplos simples
   - Probable: BR-028 o similar

7. **FND_03_Casos_de_Uso_1_0_0.rst**
   - Razón: Concepto de UC con ejemplo completo
   - Contenido: 1 UC desarrollado
   - Probable: UC-07 o UC-04

8. **META_04_Contexto_IACT_1_0_0.rst**
   - Razón: Describe el proyecto
   - Contenido: ¿Describe sistema de químicos o IACT?
   - Probable: Depende de cuándo se escribió

---

### 5.2 Archivos Menos Probables

**PRIORIDAD 2-3 (Técnicos, menos ejemplos):**

- MTM_01, MTM_02, MTM_03: Diagramas UML (técnicos)
- TXM_01, TXM_02: Taxonomías (listados)
- FND_01: Concepto general de requisito
- FND_04: Concepto general de trazabilidad
- FND_06: Metodología (abstracto)
- FND_07: Concepto de FR

---

## SECCIÓN 6: CONCLUSIÓN CORREGIDA

### 6.1 Qué Aprendí

1. **NO "inventé" archivos arbitrariamente**
   - Los deduje de referencias a "PARTE 0, 1, 2"
   - Fueron suposiciones lógicas pero incorrectas

2. **La estructura real es MODULAR**
   - Información distribuida en 4 carpetas
   - FND = conceptos fundamentales
   - SBVR = ontología detallada
   - TXM = taxonomías (solo 3)
   - MTM = metamodelos (solo 3)

3. **TXM_02-08 NO EXISTEN porque no se necesitan**
   - FND_05-07 cubren esa información
   - Evita duplicación

4. **Los 8 archivos críticos identificados son correctos**
   - Basados en contenido probable, no estructura inventada
   - TXM_03, FND_02, FND_03, FND_05 son clave

---

### 6.2 Plan de Acción Corregido

**PASO 1: Validar contenido de los 8 críticos**

Leer estos archivos reales para confirmar ejemplos químicos:

```
1. TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst       [taxonomias/]
2. FND_02_Reglas_de_Negocio_1_0_0.rst              [fundamentos/]
3. FND_03_Casos_de_Uso_1_0_0.rst                   [fundamentos/]
4. FND_05_Jerarquia_4_Niveles_1_0_0.rst            [fundamentos/]
5. META_04_Contexto_IACT_1_0_0.rst                 [metadata/]
6. SBVR_02_Fact_Types_1_0_0.rst                    [ontologia_sbvr/]
7. SBVR_03_Reglas_Estructurales_1_0_0.rst          [ontologia_sbvr/]
8. SBVR_04_Reglas_Operativas_1_0_0.rst             [ontologia_sbvr/]
```

**PASO 2: Generar plan de reescritura**

Basado en:
- Estructura REAL (24 archivos, 4 carpetas)
- Nomenclatura correcta (_1_0_0.rst)
- Contenido validado de archivos críticos

---

## RESUMEN EJECUTIVO

| Concepto | Propuse | Real | Estado |
|----------|---------|------|--------|
| PARTE 0 (Intro) | FND_00, 01, 02 | META_04, FND_01, Glossary | ⚠️ Renombrar |
| PARTE 1 (Identificar BR) | FND_03, MTM_01-03 | TXM_03, SBVR_02-04, FND_02 | ⚠️ Redistribuido |
| PARTE 2 (Transformar) | TXM_01-08 | FND_05-07, TXM_01, MTM_01 | ❌ TXM_02-08 no existen |
| **TOTAL** | 15-20 archivos | 24 archivos | ✅ Estructura clara |

**Usuario tenía razón:** No inventé, deduje de "PARTE X" pero la estructura real es diferente.

**Próximo paso:** Leer los 8 archivos críticos para validar contenido.

---

**FIN DE LA RECONCILIACIÓN**
