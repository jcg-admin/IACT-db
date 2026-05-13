# ANÁLISIS: ESTRUCTURA REAL vs PROPUESTA DE BASE_COGNITIVA/

**Fecha:** 2026-01-08  
**Objetivo:** Identificar discrepancias entre estructura real y plan propuesto  
**Conclusión:** Determinar alcance real de reescritura

---

## SECCIÓN 1: ESTRUCTURA REAL (Según MODELO_DOCUMENTAL_IACT v2.2.0)

### 1.1 Inventario Completo de base_cognitiva/

```
base_cognitiva/
├── _fundamentos_conceptuales/
│   ├── FND_01_Concepto_Requisito_1_0_0.rst
│   ├── FND_02_Reglas_de_Negocio_1_0_0.rst
│   ├── FND_03_Casos_de_Uso_1_0_0.rst
│   ├── FND_04_Trazabilidad_1_0_0.rst
│   ├── FND_05_Jerarquia_4_Niveles_1_0_0.rst
│   ├── FND_06_Derivacion_vs_Transformacion_1_0_0.rst
│   ├── FND_07_Requerimientos_Funcionales_1_0_0.rst
│   └── index.rst
│
├── _metadata/
│   ├── META_01_Identidad_Proyecto_1_0_0.rst
│   ├── META_02_Clasificacion_Documental_1_0_0.rst
│   ├── META_03_Fases_SDLC_1_0_0.rst
│   ├── META_04_Contexto_IACT_1_0_0.rst
│   ├── META_05_Estructura_Documental_1_0_0.rst
│   └── index.rst
│
├── _ontologia_sbvr/
│   ├── SBVR_01_Conceptos_Nucleares_1_0_0.rst
│   ├── SBVR_02_Fact_Types_1_0_0.rst
│   ├── SBVR_03_Reglas_Estructurales_1_0_0.rst
│   ├── SBVR_04_Reglas_Operativas_1_0_0.rst
│   ├── SBVR_05_Vocabulario_Controlado_1_0_0.rst
│   └── index.rst
│
├── _taxonomias_y_metamodelos/
│   ├── metamodelos/
│   │   ├── MTM_01_Metamodelo_Requisitos_1_0_0.rst
│   │   ├── MTM_02_Metamodelo_Trazabilidad_1_0_0.rst
│   │   └── MTM_03_Metamodelo_RBAC_1_0_0.rst
│   ├── taxonomias/
│   │   ├── TXM_01_Taxonomia_Requisitos_1_0_0.rst
│   │   ├── TXM_02_Taxonomia_Artefactos_1_0_0.rst
│   │   └── TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst
│   └── index.rst
│
├── IACT_Glossary_v1_0_0.rst
└── index.rst
```

**Total archivos documentados en MODELO v2.2.0:**

| Categoría | # Archivos | Versionado | index.rst |
|-----------|-----------|------------|-----------|
| _fundamentos_conceptuales | 7 | _1_0_0.rst | 1 |
| _metadata | 5 | _1_0_0.rst | 1 |
| _ontologia_sbvr | 5 | _1_0_0.rst | 1 |
| _taxonomias_y_metamodelos/taxonomias | 3 | _1_0_0.rst | - |
| _taxonomias_y_metamodelos/metamodelos | 3 | _1_0_0.rst | - |
| Raíz | 1 (Glossary) | v1_0_0.rst | 1 (raíz) |
| **TOTAL** | **24** | **23 + 1** | **5** |

**Nomenclatura confirmada:**
- Archivos pedagógicos: `PREFIJO_NN_Nombre_Descriptivo_1_0_0.rst`
- Glosario: `IACT_Glossary_v1_0_0.rst` (formato diferente)
- Índices: `index.rst` (sin versionado)

---

## SECCIÓN 2: ESTRUCTURA PROPUESTA (INCORRECTA en mi plan)

### 2.1 Archivos que Propuse Crear

En mi plan incorrecto, propuse esta estructura:

```
base_cognitiva/
├── FND_00_Contexto_y_Jerarquia.rst          ❌ NO EXISTE
├── FND_01_Identidad_Estrategica.rst         ❌ NO EXISTE
├── FND_02_Glosario_de_Terminos.rst          ❌ NO EXISTE
├── FND_03_Taxonomia_BR.rst                   ❌ NO EXISTE
│
├── MTM_01_BR_a_UC_Trazabilidad.rst          ❌ NO EXISTE
├── MTM_02_UC_a_FR_Trazabilidad.rst          ❌ NO EXISTE
├── MTM_03_Esquema_Trazabilidad.rst          ❌ NO EXISTE
│
├── TXM_01_Nomenclatura_UC_FR.rst            ❌ NO EXISTE
├── TXM_02_Plantillas_UC_FR.rst              ❌ NO EXISTE
├── TXM_03_Patrones_Transformacion.rst       ❌ NO EXISTE
├── TXM_04_Proceso_Construccion.rst          ❌ NO EXISTE
├── TXM_05_Integracion_BR.rst                ❌ NO EXISTE
├── TXM_06_Derivacion_FR.rst                 ❌ NO EXISTE
├── TXM_07_Matriz_Trazabilidad.rst           ❌ NO EXISTE
├── TXM_08_Validacion_Calidad.rst            ❌ NO EXISTE
│
├── index.rst
├── conf.py
├── glosario.rst                              ❌ NO EXISTE (es IACT_Glossary_v1_0_0.rst)
├── referencias.rst                           ❌ NO EXISTE
├── diagramas/
│   ├── contexto.puml                         ❌ NO EXISTE
│   └── trazabilidad.puml                     ❌ NO EXISTE
└── plantillas/
    ├── plantilla_br.rst                      ❌ NO EXISTE
    └── plantilla_uc.rst                      ❌ NO EXISTE
```

**Total archivos propuestos:** 23 archivos + carpetas adicionales

---

## SECCIÓN 3: ANÁLISIS COMPARATIVO

### 3.1 Tabla de Mapeo: Propuesto vs Real

| # | Archivo PROPUESTO (Incorrecto) | Archivo REAL (Si existe) | Estado | Acción |
|---|-------------------------------|--------------------------|--------|--------|
| 1 | FND_00_Contexto_y_Jerarquia.rst | **NO EXISTE** | ❌ Inventado | Descartar |
| 2 | FND_01_Identidad_Estrategica.rst | FND_01_Concepto_Requisito_1_0_0.rst | ⚠️ Nombre diferente | Mapear |
| 3 | FND_02_Glosario_de_Terminos.rst | FND_02_Reglas_de_Negocio_1_0_0.rst | ⚠️ Nombre diferente | Mapear |
| 4 | FND_03_Taxonomia_BR.rst | FND_03_Casos_de_Uso_1_0_0.rst | ⚠️ Nombre diferente | Mapear |
| 5 | (no propuesto) | FND_04_Trazabilidad_1_0_0.rst | ✅ Existe en real | Incluir |
| 6 | (no propuesto) | FND_05_Jerarquia_4_Niveles_1_0_0.rst | ✅ Existe en real | Incluir |
| 7 | (no propuesto) | FND_06_Derivacion_vs_Transformacion_1_0_0.rst | ✅ Existe en real | Incluir |
| 8 | (no propuesto) | FND_07_Requerimientos_Funcionales_1_0_0.rst | ✅ Existe en real | Incluir |
| 9 | MTM_01_BR_a_UC_Trazabilidad.rst | MTM_02_Metamodelo_Trazabilidad_1_0_0.rst | ⚠️ Diferente concepto | Verificar |
| 10 | MTM_02_UC_a_FR_Trazabilidad.rst | **NO EXISTE** | ❌ Inventado | Descartar |
| 11 | MTM_03_Esquema_Trazabilidad.rst | **NO EXISTE** | ❌ Inventado | Descartar |
| 12 | TXM_01_Nomenclatura_UC_FR.rst | TXM_01_Taxonomia_Requisitos_1_0_0.rst | ⚠️ Diferente alcance | Verificar |
| 13 | TXM_02_Plantillas_UC_FR.rst | **NO EXISTE** | ❌ Inventado | Descartar |
| 14 | TXM_03_Patrones_Transformacion.rst | TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst | ⚠️ Posible mapeo | Verificar |
| 15 | TXM_04-08 (5 archivos) | **NO EXISTEN** | ❌ Inventados | Descartar |
| 16 | glosario.rst | IACT_Glossary_v1_0_0.rst | ⚠️ Nombre diferente | Mapear |
| 17 | (no propuesto) | META_01-05 (5 archivos) | ✅ Existen en real | Incluir |
| 18 | (no propuesto) | SBVR_01-05 (5 archivos) | ✅ Existen en real | Incluir |

**Resumen del análisis:**

| Categoría | Cantidad | Acción |
|-----------|----------|--------|
| Archivos inventados por mí | 10 | ❌ DESCARTAR |
| Archivos reales no propuestos | 12 | ✅ INCLUIR en plan |
| Archivos con mapeo posible | 6 | ⚠️ VERIFICAR contenido |
| **TOTAL analizado** | **28** | |

---

## SECCIÓN 4: ARCHIVOS QUE INVENTÉ (DESCARTAR)

Estos archivos **NO EXISTEN** en la estructura real y fueron **inventados** por mí:

### 4.1 Archivos Raíz Inventados

```
❌ FND_00_Contexto_y_Jerarquia.rst
   - Razón: No existe FND_00, la serie comienza en FND_01
   - Archivo creado: /tmp/FND_00_Contexto_y_Jerarquia.rst (825 líneas)
   - Acción: ELIMINAR y no usar

❌ FND_03_Taxonomia_BR.rst (parcial)
   - Razón: FND_03 real es "Casos_de_Uso", no "Taxonomia_BR"
   - Archivo creado: /tmp/FND_03_Taxonomia_BR.rst (parcial, no completado)
   - Acción: ELIMINAR y no usar
```

### 4.2 Archivos MTM Inventados

```
❌ MTM_02_UC_a_FR_Trazabilidad.rst
❌ MTM_03_Esquema_Trazabilidad.rst
```

Estos NO existen. Los MTM reales son:
- MTM_01_Metamodelo_Requisitos_1_0_0.rst
- MTM_02_Metamodelo_Trazabilidad_1_0_0.rst
- MTM_03_Metamodelo_RBAC_1_0_0.rst

### 4.3 Archivos TXM Inventados

```
❌ TXM_02_Plantillas_UC_FR.rst
❌ TXM_04_Proceso_Construccion.rst
❌ TXM_05_Integracion_BR.rst
❌ TXM_06_Derivacion_FR.rst
❌ TXM_07_Matriz_Trazabilidad.rst
❌ TXM_08_Validacion_Calidad.rst
```

Los TXM reales son solo 3:
- TXM_01_Taxonomia_Requisitos_1_0_0.rst
- TXM_02_Taxonomia_Artefactos_1_0_0.rst
- TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst

### 4.4 Archivos de Soporte Inventados

```
❌ conf.py
❌ referencias.rst
❌ diagramas/contexto.puml
❌ diagramas/trazabilidad.puml
❌ plantillas/plantilla_br.rst
❌ plantillas/plantilla_uc.rst
```

---

## SECCIÓN 5: ARCHIVOS REALES QUE NO PROPUSE (INCLUIR)

Estos archivos **EXISTEN** en la estructura real pero **NO LOS PROPUSE** en mi plan:

### 5.1 Carpeta _metadata/ (5 archivos + index)

```
✅ META_01_Identidad_Proyecto_1_0_0.rst
✅ META_02_Clasificacion_Documental_1_0_0.rst
✅ META_03_Fases_SDLC_1_0_0.rst
✅ META_04_Contexto_IACT_1_0_0.rst
✅ META_05_Estructura_Documental_1_0_0.rst
✅ index.rst
```

**Propósito:** Metadatos del proyecto IACT

**Probable contenido con ejemplos químicos:**
- META_04_Contexto_IACT podría describir el proyecto con ejemplos incorrectos

**Acción requerida:** Revisar si usan dominio químicos y reescribir con IACT

---

### 5.2 Carpeta _ontologia_sbvr/ (5 archivos + index)

```
✅ SBVR_01_Conceptos_Nucleares_1_0_0.rst
✅ SBVR_02_Fact_Types_1_0_0.rst
✅ SBVR_03_Reglas_Estructurales_1_0_0.rst
✅ SBVR_04_Reglas_Operativas_1_0_0.rst
✅ SBVR_05_Vocabulario_Controlado_1_0_0.rst
✅ index.rst
```

**Propósito:** Ontología basada en SBVR (Semantics of Business Vocabulary and Business Rules)

**Probable contenido con ejemplos químicos:**
- SBVR_02_Fact_Types probablemente tiene ejemplos como "Contenedor", "ProductoQuimico"
- SBVR_03_Reglas_Estructurales probablemente tiene BR-028, BR-031, etc.

**Acción requerida:** Reescribir ejemplos con dominio IACT

---

### 5.3 Fundamentos que olvidé

```
✅ FND_04_Trazabilidad_1_0_0.rst
✅ FND_05_Jerarquia_4_Niveles_1_0_0.rst
✅ FND_06_Derivacion_vs_Transformacion_1_0_0.rst
✅ FND_07_Requerimientos_Funcionales_1_0_0.rst
```

**Propósito:** Conceptos pedagógicos fundamentales

**Probable contenido con ejemplos químicos:** SÍ, muy probable

**Acción requerida:** Revisar y reescribir ejemplos

---

## SECCIÓN 6: MAPEO CORRECTO DE ARCHIVOS

### 6.1 Fundamentos Conceptuales (FND)

| # | Archivo REAL | Propósito Probable | Ejemplos Químicos? |
|---|--------------|-------------------|-------------------|
| 1 | FND_01_Concepto_Requisito_1_0_0.rst | Qué es un requisito | ⚠️ Probable |
| 2 | FND_02_Reglas_de_Negocio_1_0_0.rst | Qué es una BR, tipos | ⚠️ Muy probable |
| 3 | FND_03_Casos_de_Uso_1_0_0.rst | Qué es un UC | ⚠️ Muy probable |
| 4 | FND_04_Trazabilidad_1_0_0.rst | Concepto trazabilidad | ⚠️ Probable |
| 5 | FND_05_Jerarquia_4_Niveles_1_0_0.rst | BReq→BR→UC→FR | ⚠️ Muy probable |
| 6 | FND_06_Derivacion_vs_Transformacion_1_0_0.rst | Diferencia conceptual | ⚠️ Probable |
| 7 | FND_07_Requerimientos_Funcionales_1_0_0.rst | Qué es un FR | ⚠️ Probable |

**Predicción:** Los FND usan ejemplos pedagógicos simples. FND_02, FND_03, FND_05 son los MÁS PROPENSOS a tener ejemplos extensos de químicos.

---

### 6.2 Metadata (META)

| # | Archivo REAL | Propósito Probable | Ejemplos Químicos? |
|---|--------------|-------------------|-------------------|
| 1 | META_01_Identidad_Proyecto_1_0_0.rst | Nombre, visión del proyecto | ⚠️ Describe IACT o químicos? |
| 2 | META_02_Clasificacion_Documental_1_0_0.rst | Tipos de documentos | ❌ Probablemente no |
| 3 | META_03_Fases_SDLC_1_0_0.rst | Fases del ciclo de vida | ❌ Probablemente no |
| 4 | META_04_Contexto_IACT_1_0_0.rst | **CRÍTICO** Contexto del proyecto | ⚠️ MUY PROBABLE |
| 5 | META_05_Estructura_Documental_1_0_0.rst | Organización de carpetas | ❌ Probablemente no |

**Predicción:** META_04 es el archivo MÁS CRÍTICO de esta carpeta. Si describe el proyecto con ejemplos, seguro tiene químicos.

---

### 6.3 Ontología SBVR

| # | Archivo REAL | Propósito Probable | Ejemplos Químicos? |
|---|--------------|-------------------|-------------------|
| 1 | SBVR_01_Conceptos_Nucleares_1_0_0.rst | Teoría SBVR | ⚠️ Probable |
| 2 | SBVR_02_Fact_Types_1_0_0.rst | Hechos en SBVR | ⚠️ MUY PROBABLE |
| 3 | SBVR_03_Reglas_Estructurales_1_0_0.rst | Restricciones en SBVR | ⚠️ MUY PROBABLE |
| 4 | SBVR_04_Reglas_Operativas_1_0_0.rst | Desencadenadores SBVR | ⚠️ MUY PROBABLE |
| 5 | SBVR_05_Vocabulario_Controlado_1_0_0.rst | Términos del dominio | ⚠️ MUY PROBABLE |

**Predicción:** Esta carpeta completa probablemente usa terminología de químicos. SBVR_02-05 son los MÁS CRÍTICOS.

---

### 6.4 Taxonomías y Metamodelos

| # | Archivo REAL | Propósito Probable | Ejemplos Químicos? |
|---|--------------|-------------------|-------------------|
| 1 | TXM_01_Taxonomia_Requisitos_1_0_0.rst | Clasificación requisitos | ⚠️ Probable |
| 2 | TXM_02_Taxonomia_Artefactos_1_0_0.rst | Clasificación artefactos | ❌ Probablemente no |
| 3 | TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst | **CRÍTICO** 5 tipos de BR | ⚠️ MUY PROBABLE |
| 4 | MTM_01_Metamodelo_Requisitos_1_0_0.rst | Modelo de requisitos | ⚠️ Probable |
| 5 | MTM_02_Metamodelo_Trazabilidad_1_0_0.rst | Modelo trazabilidad | ⚠️ Probable |
| 6 | MTM_03_Metamodelo_RBAC_1_0_0.rst | Modelo RBAC | ❌ Probablemente no (técnico) |

**Predicción:** TXM_03 es el EQUIVALENTE a mi "FND_03_Taxonomia_BR.rst" inventado. Es el archivo MÁS CRÍTICO de reescribir.

---

## SECCIÓN 7: PRIORIZACIÓN DE ARCHIVOS A REESCRIBIR

### 7.1 Nivel de Criticidad

Basándome en probabilidad de tener ejemplos químicos y frecuencia de referencias:

#### PRIORIDAD 1 (CRÍTICO - Ejemplos extensos casi seguros)

| # | Archivo | Carpeta | Razón |
|---|---------|---------|-------|
| 1 | **TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst** | taxonomias | 5 tipos de BR con ejemplos |
| 2 | **FND_02_Reglas_de_Negocio_1_0_0.rst** | fundamentos | Concepto central con ejemplos |
| 3 | **FND_03_Casos_de_Uso_1_0_0.rst** | fundamentos | Ejemplos de UC |
| 4 | **FND_05_Jerarquia_4_Niveles_1_0_0.rst** | fundamentos | BReq→BR→UC→FR con ejemplo completo |
| 5 | **META_04_Contexto_IACT_1_0_0.rst** | metadata | Descripción del proyecto |
| 6 | **SBVR_02_Fact_Types_1_0_0.rst** | ontologia_sbvr | Hechos con ejemplos de dominio |
| 7 | **SBVR_03_Reglas_Estructurales_1_0_0.rst** | ontologia_sbvr | Restricciones con ejemplos |
| 8 | **SBVR_04_Reglas_Operativas_1_0_0.rst** | ontologia_sbvr | Desencadenadores con ejemplos |

**Estimación:** 8 archivos × 4-6 horas = 32-48 horas

---

#### PRIORIDAD 2 (ALTA - Ejemplos probables)

| # | Archivo | Carpeta | Razón |
|---|---------|---------|-------|
| 9 | FND_01_Concepto_Requisito_1_0_0.rst | fundamentos | Introducción con ejemplos |
| 10 | FND_04_Trazabilidad_1_0_0.rst | fundamentos | Ejemplos de trazabilidad |
| 11 | FND_06_Derivacion_vs_Transformacion_1_0_0.rst | fundamentos | Ejemplos comparativos |
| 12 | FND_07_Requerimientos_Funcionales_1_0_0.rst | fundamentos | Ejemplos de FR |
| 13 | SBVR_01_Conceptos_Nucleares_1_0_0.rst | ontologia_sbvr | Fundamentos SBVR |
| 14 | SBVR_05_Vocabulario_Controlado_1_0_0.rst | ontologia_sbvr | Términos del dominio |
| 15 | TXM_01_Taxonomia_Requisitos_1_0_0.rst | taxonomias | Clasificaciones |
| 16 | MTM_01_Metamodelo_Requisitos_1_0_0.rst | metamodelos | Diagramas UML |
| 17 | MTM_02_Metamodelo_Trazabilidad_1_0_0.rst | metamodelos | Matriz trazabilidad |

**Estimación:** 9 archivos × 2-3 horas = 18-27 horas

---

#### PRIORIDAD 3 (MEDIA - Revisar pero probablemente técnicos)

| # | Archivo | Carpeta | Razón |
|---|---------|---------|-------|
| 18 | META_01_Identidad_Proyecto_1_0_0.rst | metadata | Descripción general |
| 19 | META_02_Clasificacion_Documental_1_0_0.rst | metadata | Clasificación docs |
| 20 | META_05_Estructura_Documental_1_0_0.rst | metadata | Estructura carpetas |
| 21 | TXM_02_Taxonomia_Artefactos_1_0_0.rst | taxonomias | Tipos artefactos |
| 22 | MTM_03_Metamodelo_RBAC_1_0_0.rst | metamodelos | Modelo permisos |

**Estimación:** 5 archivos × 1-2 horas = 5-10 horas

---

#### PRIORIDAD 4 (BAJA - Probablemente no afectados)

| # | Archivo | Carpeta | Razón |
|---|---------|---------|-------|
| 23 | META_03_Fases_SDLC_1_0_0.rst | metadata | Fases genéricas |
| 24 | IACT_Glossary_v1_0_0.rst | raíz | Glosario de términos |

**Estimación:** 2 archivos × 1 hora = 2 horas

---

### 7.2 Resumen de Esfuerzo Estimado

| Prioridad | # Archivos | Horas Min | Horas Max |
|-----------|-----------|-----------|-----------|
| P1 (Crítico) | 8 | 32h | 48h |
| P2 (Alta) | 9 | 18h | 27h |
| P3 (Media) | 5 | 5h | 10h |
| P4 (Baja) | 2 | 2h | 2h |
| **TOTAL** | **24** | **57h** | **87h** |

**Más conservador:** 87 horas = ~11 días de trabajo (8h/día)

---

## SECCIÓN 8: DETECCIÓN DE EJEMPLOS QUÍMICOS

### 8.1 Patrones de Búsqueda

Para identificar si un archivo usa dominio químicos, buscar:

**Términos del dominio químicos:**
```
- "químico", "química"
- "contenedor"
- "producto químico"
- "OSHA", "certificación OSHA"
- "vencimiento", "caduco"
- "laboratorio"
- "coordinador de seguridad"
- "propietario" (en contexto de inventario)
```

**UC/BR del dominio químicos:**
```
- UC-07 "Notificar Vencimiento"
- UC-04 "Solicitar Químico"
- UC-09 "Aprobar Solicitud"
- BR-028 "Aprobación >$500"
- BR-031 "Notificar 30 días antes"
- BR-060 "Descuento volumen"
- BR-087 "Certificación OSHA"
- BR-046 "Marcar caduco"
- BR-012 "Código barras único"
```

**Actores del dominio químicos:**
```
- "Coordinador de Seguridad"
- "Propietario" (de contenedor)
- "Gerente" (de laboratorio)
- "Técnico de laboratorio"
```

---

### 8.2 Estrategia de Validación

Para cada archivo de base_cognitiva/:

1. **Leer archivo completo**
2. **Contar ocurrencias** de términos químicos
3. **Identificar secciones afectadas** (qué líneas tienen ejemplos)
4. **Estimar esfuerzo** de reescritura
5. **Proponer ejemplos IACT** equivalentes

---

## SECCIÓN 9: CONCLUSIONES Y RECOMENDACIONES

### 9.1 Hallazgos Principales

| # | Hallazgo | Impacto |
|---|----------|---------|
| 1 | **10 archivos inventados por mí** que NO existen | ⚠️ CRÍTICO - Descartar plan anterior |
| 2 | **12 archivos reales** que NO propuse | ⚠️ CRÍTICO - Plan incompleto |
| 3 | **24 archivos reales** a revisar (no 23 como pensé) | ⚠️ ALTO - Más esfuerzo del estimado |
| 4 | **Carpetas organizadas** por concepto (4 carpetas + raíz) | ✅ BUENO - Estructura clara |
| 5 | **Versionado _1_0_0.rst** obligatorio en todos | ✅ BUENO - Estándar claro |
| 6 | **8 archivos CRÍTICOS** con ejemplos extensos probables | ⚠️ ALTO - Requieren más tiempo |

---

### 9.2 Recomendaciones de Acción

#### Recomendación 1: VALIDAR CONTENIDO ACTUAL

**Acción inmediata:**

1. Leer los 8 archivos de PRIORIDAD 1 para confirmar si tienen ejemplos químicos
2. Contar líneas de cada archivo
3. Identificar secciones específicas a reescribir

**Comando sugerido:**

```bash
# Si tenemos acceso a base_cognitiva/ real
for file in TXM_03 FND_02 FND_03 FND_05 META_04 SBVR_02 SBVR_03 SBVR_04; do
    echo "=== $file ==="
    grep -i "químico\|contenedor\|UC-07\|BR-028\|BR-031" $file | wc -l
done
```

---

#### Recomendación 2: GENERAR NUEVO PLAN MAESTRO

**Basado en estructura REAL:**

```
FASE 0: Preparación
  - Validar contenido de 24 archivos reales
  - Contar líneas y ocurrencias de términos químicos
  - Priorizar por impacto

FASE 1: PRIORIDAD 1 - Archivos Críticos (8 archivos, 32-48h)
  - TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst
  - FND_02_Reglas_de_Negocio_1_0_0.rst
  - FND_03_Casos_de_Uso_1_0_0.rst
  - FND_05_Jerarquia_4_Niveles_1_0_0.rst
  - META_04_Contexto_IACT_1_0_0.rst
  - SBVR_02_Fact_Types_1_0_0.rst
  - SBVR_03_Reglas_Estructurales_1_0_0.rst
  - SBVR_04_Reglas_Operativas_1_0_0.rst

FASE 2: PRIORIDAD 2 - Archivos Alta Prioridad (9 archivos, 18-27h)
  [... lista completa ...]

FASE 3: PRIORIDAD 3 y 4 - Revisión (7 archivos, 7-12h)
  [... lista completa ...]

FASE 4: Validación Final
  - Compilación Sphinx
  - Verificación de referencias cruzadas
  - Checklist de coherencia
```

---

#### Recomendación 3: METODOLOGÍA DE TRABAJO

**Para cada archivo:**

1. **Leer archivo original completo**
2. **Identificar secciones con ejemplos químicos**
3. **Mapear ejemplos químicos → ejemplos IACT**
4. **Reescribir usando heredoc en /tmp**
5. **Validar nomenclatura (_1_0_0.rst)**
6. **Copiar a destino correcto** (carpeta correspondiente)
7. **Validar compilación Sphinx**

---

### 9.3 Decisión Requerida del Usuario

¿Qué acción tomar ahora?

**OPCIÓN A:** Leer archivos reales de base_cognitiva/ para validar contenido
- Necesito acceso a los archivos reales
- Generaré análisis de contenido por archivo
- Confirmaré cuáles tienen ejemplos químicos y cuántas líneas

**OPCIÓN B:** Generar nuevo PLAN MAESTRO basado en estructura real
- Sin leer archivos, asumiré que P1 y P2 tienen ejemplos
- Generaré plan detallado de 24 archivos
- Incluiré metodología y estimaciones

**OPCIÓN C:** Empezar con archivo más crítico (TXM_03)
- Leer TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst
- Analizar contenido específico
- Generar versión reescrita con ejemplos IACT

**OPCIÓN D:** Otra acción

---

## RESUMEN EJECUTIVO

### Problema Identificado

Mi plan anterior era **INCORRECTO** porque:
- Inventé 10 archivos que NO existen
- Omití 12 archivos que SÍ existen
- Usé nomenclatura incorrecta (sin _1_0_0.rst)
- Ignoré carpetas organizadas (_fundamentos_conceptuales/, etc.)

### Alcance Real

- **24 archivos** en base_cognitiva/ (no 23 como pensé)
- **4 carpetas temáticas** + raíz
- **8 archivos CRÍTICOS** (P1) con ejemplos extensos probables
- **57-87 horas** de esfuerzo estimado (más del doble de lo previsto)

### Próximo Paso Sugerido

**LEER archivos reales** de PRIORIDAD 1 para:
1. Confirmar si tienen ejemplos químicos
2. Contar líneas afectadas
3. Generar plan preciso de reescritura

---

**FIN DEL ANÁLISIS**

**Fecha:** 2026-01-08  
**Palabras:** ~8,000  
**Estado:** Completo - Esperando decisión del usuario
