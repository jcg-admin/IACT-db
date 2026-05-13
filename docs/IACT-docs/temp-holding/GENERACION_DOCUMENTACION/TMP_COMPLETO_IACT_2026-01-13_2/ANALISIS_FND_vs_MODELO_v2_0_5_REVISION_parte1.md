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
