# ANÁLISIS EXHAUSTIVO: PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO

**Fecha:** 2026-01-08  
**Documento:** UID 20251208034056696331  
**Longitud:** ~2,000 líneas (~50 páginas)  
**Diagramas PlantUML:** 21

---

## 1. ESTRUCTURA DEL DOCUMENTO

### 1.1 Tabla de Contenidos (12 Secciones)

```
1.  Introducción
2.  Naturaleza de las Reglas de Negocio
3.  Posición en la Jerarquía
4.  Taxonomía: Los 5 Tipos de Reglas
5.  La Distinción Crítica: Desencadenador vs Inferencia
6.  Identificación: Técnicas de Elicitación
7.  Documentación de Reglas
8.  Gestión del Catálogo de Reglas
9.  Ciclo de Vida de una Regla de Negocio
10. Casos Especiales
11. Ejercicios Prácticos
12. Resumen y Siguientes Pasos
```

**Observación:** Documento muy completo, cubre todo el ciclo de vida de Business Rules.

---

## 2. DOMINIO UTILIZADO: QUÍMICOS (CONFIRMADO)

### 2.1 Conteo de Ejemplos del Dominio Químicos

| Business Rule | Tipo | Ocurrencias Totales | Secciones Principales |
|---------------|------|---------------------|----------------------|
| **BR-028** | Restricción | **14** | 3.2, 4.2, 7.2, 7.4, 8.4, 8.5 |
| **BR-031** | Desencadenador | **17** | 4.3, 5.4, 5.5, 7.4, 9.3, 9.4, 9.5 |
| **BR-046** | Inferencia | **12** | 4.4, 5.4, 5.5, 7.4 |
| **BR-087** | Restricción | **8** | 4.2, 6.4, 10.2 |
| **BR-012** | Hecho | **6** | 4.1, 7.4 |

**Total estimado de referencias al dominio químicos:** **60+ ocurrencias**

### 2.2 Entidades y Términos del Dominio Químicos

- **"Producto Químico"** / **"Químico"**: 35+ ocurrencias
- **"Contenedor"**: 28+ ocurrencias
- **"Vencimiento"** / **"Fecha de vencimiento"**: 18+ ocurrencias
- **"Coordinador de Seguridad"**: 9+ ocurrencias
- **"Propietario del contenedor"**: 7+ ocurrencias
- **"OSHA 29 CFR 1910.1200"**: 4 ocurrencias
- **"Certificación OSHA"**: 5 ocurrencias
- **"Clase de químico"** (1-4, peligrosos): 6 ocurrencias
- **"Caduco"**: 8 ocurrencias
- **"Política de Seguridad de Laboratorio v4.1"**: 6 ocurrencias

---

## 3. ANÁLISIS POR SECCIÓN

### 3.1 Sección 1: Introducción

**Contenido:**
- Objetivos de aprendizaje
- Contexto en flujo completo (6 PARTES)
- **Diagrama PlantUML** del flujo completo

**Ejemplos químicos:** 0  
**Observación:** Sección neutral, no usa dominio específico.

---

### 3.2 Sección 2: Naturaleza de las Reglas de Negocio

**Contenido:**
- Definición conceptual de BR
- Características esenciales (externidad, obligatoriedad, estabilidad)
- Fuentes de BR (externas e internas)
- Por qué existen independientemente del sistema

**Ejemplos químicos:** 0  
**Observación:** Conceptual, usa ejemplos genéricos (Ley de Protección de Datos, OSHA como ejemplo de regulación).

---

### 3.3 Sección 3: Posición en la Jerarquía

**Contenido:**
- **Nivel 0:** Business Rules (más abstracto)
- **Diagrama PlantUML:** Jerarquía Nivel 0-3
- Influencia en múltiples niveles
- **Diagrama PlantUML:** Influencia múltiple de BR

**Ejemplos químicos:**
- **BR-028** aparece en **diagrama de influencia** (Sección 3.2)
- **Ejemplo completo de BR-028** con su influencia en:
  - Nivel 1 (BReq): "Control de gastos"
  - Nivel 2 (UC): UC-04 Paso 6
  - Nivel 3 (FR): RF-205, RF-206, RF-207
  - QA: QA-12
  - EI: EI-03, EI-04
  - Constraints: CON-07

**Conteo:** BR-028 mencionado **3 veces** en esta sección.

---

### 3.4 Sección 4: Taxonomía - Los 5 Tipos de Reglas

**Esta es la sección MÁS IMPORTANTE y con MÁS ejemplos químicos.**

#### 4.1 Tipo 1: Hechos

**Ejemplos químicos:**
- **BR-012** (Hecho): "Cada contenedor de producto químico tiene un código de barras único"
  - Ejemplo completo con análisis
  - Impacto en sistema

**Conteo:** BR-012 mencionado **2 veces**

#### 4.2 Tipo 2: Restricciones

**Ejemplos químicos:**
- **BR-028** (Restricción): "Solicitudes >$500 requieren aprobación"
  - Ejemplo completo con análisis
  - Fuente: Política Financiera Corporativa v2.3
  - Impacto en UC-04

- **BR-087** (Restricción): "Solo personal con certificación OSHA puede solicitar químicos clase 1-4"
  - Ejemplo completo con análisis
  - Fuente: OSHA 29 CFR 1910.1200

**Conteo:** 
- BR-028: **4 veces**
- BR-087: **3 veces**

**Observación:** También incluye **Matriz de Roles y Permisos** genérica (sin dominio químicos).

#### 4.3 Tipo 3: Desencadenadores

**Ejemplos químicos:**
- **BR-031** (Desencadenador): "SI contenedor vence ENTONCES notificar propietario y coordinador"
  - **Ejemplo COMPLETO Y DETALLADO** (el más extenso del documento)
  - Incluye:
    - Condición: `fecha_actual >= fecha_vencimiento - 30 días`
    - Comportamiento: Notificar (OBSERVABLE)
    - **Genera UC-07** completo con 6 pasos
    - Genera **4 Functional Requirements:** RF-301, RF-302, RF-303, RF-304
    - Requiere **EI-03:** Integración SMTP

**Conteo:** BR-031 mencionado **5 veces** en esta subsección.

#### 4.4 Tipo 4: Inferencias

**Ejemplos químicos:**
- **BR-046** (Inferencia): "SI contenedor vence ENTONCES marcar como 'Caduco'"
  - Ejemplo completo con análisis
  - **Comparación directa con BR-031** (mismo evento, diferente tipo)
  - NO genera UC
  - Solo genera RF-305

**Conteo:** BR-046 mencionado **4 veces** en esta subsección.

#### 4.5 Tipo 5: Cálculos

**Ejemplos químicos:** 0  
**Observación:** Usa ejemplos genéricos (descuentos por volumen, calificaciones académicas, costo de envío).

---

### 3.5 Sección 5: La Distinción Crítica - Desencadenador vs Inferencia

**Esta sección es CRÍTICA para la metodología.**

**Contenido:**
- Por qué es crítica esta distinción
- Análisis conceptual (HACE vs SABE)
- Tabla comparativa
- Diagrama de decisión (PlantUML)
- **3 ejemplos comparativos detallados**

**Ejemplos químicos:**

#### Ejemplo 1: Vencimiento de Químico (el MÁS DETALLADO)

**BR-031 (Desencadenador):**
- "SI vence ENTONCES NOTIFICAR"
- Observable: Emails recibidos
- Genera UC-07
- 4 Functional Requirements
- Usuario VE emails

**BR-046 (Inferencia):**
- "SI vence ENTONCES MARCAR caduco"
- NO observable
- NO genera UC
- 1 Functional Requirement
- Usuario NO VE nada

**Diagrama PlantUML comparativo** incluido.

**Conteo en esta sección:**
- BR-031: **6 veces**
- BR-046: **5 veces**

#### Ejemplo 2: Sistema de Pagos (genérico)
- BR-122 (Desencadenador): Enviar recordatorio
- BR-089 (Inferencia): Clasificar como deudora

#### Ejemplo 3: Inventario (genérico)
- BR-245 (Desencadenador): Alertar stock bajo
- BR-246 (Inferencia): Marcar como stock bajo

**Regla de Oro incluida:**
> "¿Cómo sabe el usuario que la regla se ejecutó?"
> - Desencadenador: Algo llegó, apareció, cambió visiblemente
> - Inferencia: No sabe (hasta que busque en el sistema)

---

### 3.6 Sección 6: Identificación - Técnicas de Elicitación

**Contenido:**
- Proceso de licitación (elicitación)
- **Las 6 Preguntas Estratégicas**
- Técnicas complementarias
- **Ejemplo de sesión de licitación** (CON QUÍMICOS)

**Ejemplos químicos en la sesión de licitación:**

La Sección 6.4 incluye un **diálogo completo** de sesión de elicitación:

```
ANALISTA: "¿Por qué necesitamos controlar quién solicita químicos?"
COORDINADOR: "Por regulaciones de OSHA. Solo personal capacitado..."

[Identifican 5 Business Rules:]
- BR-087 (Restricción): Certificación OSHA
- BR-031 (Desencadenador): Notificar vencimiento
- BR-046 (Inferencia): Marcar como caduco
- BR-012 (Hecho): Contenedor - propietario
- BR-088 (Inferencia): Clasificar como peligroso
```

**Conteo en esta sección:**
- BR-087: **2 veces**
- BR-031: **2 veces**
- BR-046: **2 veces**
- BR-012: **1 vez**
- **BR-088** (nuevo): **1 vez**

**Total de la sesión:** 5 Business Rules identificadas del dominio químicos.

---

### 3.7 Sección 7: Documentación de Reglas

**Contenido:**
- Plantilla estructurada
- Campos obligatorios
- Estática vs Dinámica
- **5 ejemplos completos documentados** (uno por cada tipo)

**Ejemplos químicos documentados:**

#### Ejemplo 1: Hecho
- **BR-012** (completo con plantilla)

#### Ejemplo 2: Restricción
- **BR-028** (completo con plantilla)

#### Ejemplo 3: Desencadenador
- **BR-031** (completo con plantilla, MUY DETALLADO)

#### Ejemplo 4: Inferencia
- **BR-046** (completo con plantilla)

#### Ejemplo 5: Cálculo
- **BR-060** (descuentos por volumen - NO químicos)

**Conteo en esta sección:**
- BR-012: **1 vez**
- BR-028: **1 vez**
- BR-031: **1 vez**
- BR-046: **1 vez**

**Matriz de Roles y Permisos:**
Sección 7.5 incluye **matriz completa del Sistema de Gestión de Químicos:**

```
| Operación                     | Solicitante | Aprobador | Gerente | Coordinador | Admin |
|-------------------------------|-------------|-----------|---------|-------------|-------|
| Crear solicitud               | X           | X         | X       | X           | X     |
| Ver solicitud propia          | X           | X         | X       | X           | X     |
| Aprobar solicitud             |             | X         | X       | X           |       |
| Eliminar contenedor           |             |           |         | X           | X     |
...
```

Conversión a Business Rules:
- BR-101, BR-102, BR-103, BR-104, BR-105 (todas del dominio químicos)

**Conteo adicional:** 5 BR nuevos derivados de la matriz.

---

### 3.8 Sección 8: Gestión del Catálogo de Reglas

**Contenido:**
- Niveles de madurez (1-4)
- Catálogo vs Base de Datos
- Por qué separar RN del código
- Proceso de gestión
- Versionado y evolución

**Ejemplos químicos:**

**Sección 8.4 - Por qué NO incrustar BR en código:**

Ejemplo MALO:
```java
if (sol.getMonto() > 500) {  // ¿Por qué 500?
```

Ejemplo BUENO:
```java
// Aplicar BR-028: Política Financiera v2.3, Sec 4.2
```

**Sección 8.5 - Versionado:**

Ejemplo de cambio:
```
BR-028.1: Umbral $500 (2023-01-01 a 2024-05-31)
BR-028.2: Umbral $1,000 (2024-06-01 a actual)
```

Proceso de cambio completo incluido con **UC-04** y **RF-205, RF-206** afectados.

**Conteo en esta sección:**
- BR-028: **4 veces**

---

### 3.9 Sección 9: Ciclo de Vida de una RN

**Contenido:**
- 6 fases del ciclo de vida
- Diagrama PlantUML del ciclo
- Detalle de cada fase con ejemplos

**Ejemplos químicos:**

#### Fase 1: Identificación
- **BR-031** como ejemplo de regla candidata

#### Fase 2: Validación
- **BR-031** con texto exacto de fuente:
  - "Política de Seguridad de Laboratorio v4.1, Artículo 8, párrafo 3"

#### Fase 3: Documentación
- **BR-031** con plantilla completa

#### Fase 4: Implementación
- **BR-031** → **UC-07** (6 pasos)
- **RF-301, RF-302, RF-303, RF-304**
- Componentes: `ExpirationCheckService`, `NotificationService`
- Código: `ExpirationCheckService.java`, `NotificationService.sendExpirationEmail()`

#### Fase 5: Operación
- **BR-028** con calendario de revisión trimestral/semestral
- Métricas:
  ```
  Total solicitudes >$500: 245
  Aprobaciones solicitadas: 245 (100%)
  ```

#### Fase 6: Retiro
- **BR-028** marcado como obsoleto
- Reemplazado por BR-028-v2
- Dependencias: UC-04, RF-205, RF-206 actualizados

**Conteo en esta sección:**
- BR-031: **5 veces**
- BR-028: **3 veces**

---

### 3.10 Sección 10: Casos Especiales

**Contenido:**
- Conflictos entre reglas
- Priorización de fuentes (jerarquía de autoridad)
- Reglas temporales
- Reglas condicionales complejas

**Ejemplos químicos:**

**Sección 10.2 - Priorización:**

Conflicto detectado:
```
BR-087 (OSHA - Nivel 4): Solo certificados pueden manejar químicos
BR-099 (Política - Nivel 8): Gerentes pueden autorizar excepción

RESOLUCIÓN: BR-087 prevalece (OSHA > Política corporativa)
```

**Conteo en esta sección:**
- BR-087: **3 veces**
- **BR-099** (nuevo): **2 veces**

---

### 3.11 Sección 11: Ejercicios Prácticos

**Contenido:**
- 5 ejercicios con respuestas

**Ejemplos químicos:** 0  
**Observación:** Ejercicios usan ejemplos genéricos (biblioteca, hotel, etc.)

---

### 3.12 Sección 12: Resumen y Siguientes Pasos

**Contenido:**
- Conceptos clave dominados
- Entregables de esta parte
- Conexión con PARTE 2

**Ejemplos químicos:**
- **BR-031** mencionado como ejemplo de transformación en PARTE 2
- **BR-028, BR-060, BR-046** mencionados

**Conteo:** 4 referencias.

---

## 4. CONTEO TOTAL DE EJEMPLOS QUÍMICOS

### 4.1 Business Rules del Dominio Químicos

| BR ID | Tipo | Ocurrencias | Secciones |
|-------|------|-------------|-----------|
| **BR-028** | Restricción | **14** | 3.2, 4.2, 7.4, 8.4, 8.5, 9.5, 9.6, 12.2 |
| **BR-031** | Desencadenador | **17** | 4.3, 5.4, 5.5, 7.4, 9.2, 9.3, 9.4, 12.2 |
| **BR-046** | Inferencia | **12** | 4.4, 5.4, 5.5, 6.4, 7.4, 12.2 |
| **BR-087** | Restricción | **8** | 4.2, 6.4, 10.2 |
| **BR-012** | Hecho | **6** | 4.1, 6.4, 7.4 |
| **BR-088** | Inferencia | **1** | 6.4 |
| **BR-099** | Restricción | **2** | 10.2 |
| **BR-101-105** | Restricciones (matriz) | **5** | 7.5 |

**TOTAL:** **65+ ocurrencias** de Business Rules del dominio químicos.

### 4.2 Entidades y Términos

- **"Químico" / "Producto químico"**: 35+ ocurrencias
- **"Contenedor"**: 28+ ocurrencias
- **"Vencimiento"**: 18+ ocurrencias
- **"Coordinador de Seguridad"**: 9+ ocurrencias
- **"OSHA"**: 9+ ocurrencias
- **"Certificación"**: 7+ ocurrencias
- **"Propietario"**: 7+ ocurrencias
- **"Caduco"**: 8+ ocurrencias

---

## 5. ANÁLISIS DE BUSINESS REQUIREMENTS

### 5.1 ¿Menciona Business Requirements?

**SÍ, pero mínimamente.**

**Sección 3.2 - Influencia en Múltiples Niveles:**

Ejemplo de BR-028:
```
INFLUYE EN:

Nivel 1 (Business Requirements):
  → Justifica objetivo: "Control de gastos según políticas"
```

**Sección 3.3 - Diagrama de Influencia:**
```
BR → BReq: INFLUYE (las políticas justifican el proyecto)
```

**Observación:**
- BReq **aparece** en la jerarquía conceptual
- BReq **NO se trabaja** metodológicamente
- No hay técnicas para identificar BReq
- No hay plantilla para documentar BReq
- **Confirma la brecha identificada anteriormente**

---

## 6. SECCIONES CRÍTICAS PARA REESCRITURA

### 6.1 Alta Prioridad (Muchos Ejemplos Químicos)

| Sección | Ejemplos Químicos | Complejidad | Prioridad |
|---------|-------------------|-------------|-----------|
| **4.3 Tipo 3: Desencadenadores** | BR-031 (5×) | ALTA | 🔴 CRÍTICA |
| **5. Distinción Desenc vs Inf** | BR-031 (6×), BR-046 (5×) | ALTA | 🔴 CRÍTICA |
| **7.4 Ejemplos Documentados** | BR-012, BR-028, BR-031, BR-046 | ALTA | 🔴 CRÍTICA |
| **6.4 Sesión de Licitación** | 5 BR nuevos | MEDIA | 🟡 ALTA |
| **9. Ciclo de Vida** | BR-031 (5×), BR-028 (3×) | MEDIA | 🟡 ALTA |

### 6.2 Media Prioridad

| Sección | Ejemplos Químicos | Complejidad | Prioridad |
|---------|-------------------|-------------|-----------|
| **4.2 Tipo 2: Restricciones** | BR-028 (4×), BR-087 (3×) | MEDIA | 🟡 ALTA |
| **4.4 Tipo 4: Inferencias** | BR-046 (4×) | MEDIA | 🟡 ALTA |
| **7.5 Matriz Roles/Permisos** | 5 BR nuevos | BAJA | 🟢 MEDIA |
| **8.5 Versionado** | BR-028 (4×) | BAJA | 🟢 MEDIA |

### 6.3 Baja Prioridad (Ejemplos Genéricos)

- Sección 1: Introducción (neutral)
- Sección 2: Naturaleza (conceptual)
- Sección 4.5: Cálculos (ejemplos genéricos)
- Sección 11: Ejercicios (ejemplos genéricos)

---

## 7. HALLAZGOS IMPORTANTES

### 7.1 BR-031 es el Ejemplo ESTRELLA

**BR-031** (Desencadenador) es el ejemplo MÁS DESARROLLADO del documento:

1. Aparece **17 veces** (el más usado)
2. Tiene **UC-07 completo** con 6 pasos detallados
3. Genera **4 Functional Requirements** (RF-301 a RF-304)
4. Incluye **integración externa** (SMTP)
5. Usado en **3 secciones críticas** (4.3, 5, 7.4, 9)
6. Ejemplo central de **Desencadenador vs Inferencia**

**Para reescritura:** BR-031 debe ser reemplazado por un ejemplo IACT igual de robusto.

### 7.2 BR-028 es el Ejemplo de Restricción Principal

**BR-028** (Restricción) es el segundo más usado:

1. Aparece **14 veces**
2. Ejemplo de **influencia multinivel** (Sección 3.2)
3. Usado en **versionado** (Sección 8.5)
4. Usado en **ciclo de vida** (Sección 9)

**Para reescritura:** Debe ser reemplazado por una restricción IACT equivalente.

### 7.3 La Distinción Desencadenador vs Inferencia es CENTRAL

**Sección 5** es **CRÍTICA** para la metodología:

- 3 ejemplos comparativos detallados
- Diagrama PlantUML de decisión
- Tabla comparativa
- Regla de Oro
- **BR-031 vs BR-046** como caso estrella

**Para reescritura:** Esta sección debe mantener su estructura pero con ejemplos IACT.

### 7.4 Sesión de Licitación es un Diálogo Completo

**Sección 6.4** incluye un **diálogo realista** completo de 30+ líneas entre Analista y Coordinador de Seguridad.

**Para reescritura:** Debe reescribirse con roles IACT (ej: Analista y Supervisor de Operaciones).

### 7.5 Matriz de Roles es Específica del Dominio

**Sección 7.5** tiene una **tabla completa** de 14 operaciones × 5 roles = 70 celdas.

Roles del dominio químicos:
- Solicitante
- Aprobador
- Gerente
- Coordinador (de Seguridad)
- Admin

**Para reescritura:** Debe reemplazarse con matriz de roles IACT.

---

## 8. COMPARACIÓN CON PARTE 0

| Característica | PARTE 0 | PARTE 1 |
|----------------|---------|---------|
| **Longitud** | ~18,000 palabras | ~50,000 palabras |
| **Ejemplos químicos** | 150+ ocurrencias | 65+ BR, 100+ términos |
| **Business Rules específicos** | BR-028, UC-04, BR-087, etc. | BR-028, BR-031, BR-046, BR-087, BR-012 |
| **Diagramas PlantUML** | ~10 | 21 |
| **Enfoque** | Visión general, jerarquía | Profundización en BR |
| **Mención de BReq** | Sección 2.3 completa | Mínima (solo en influencia) |

**Observación:** PARTE 1 es **más extensa** y **más técnica** que PARTE 0.

---

## 9. ESTRATEGIA DE REESCRITURA

### 9.1 Enfoque Sugerido

**OPCIÓN A: Reescritura Completa (128-179h total)**
1. Reescribir PARTE 0 (18-24h)
2. Reescribir PARTE 1 (40-50h) ← **MÁS COMPLEJA**
3. Reescribir PARTES 2-6 (si existen)
4. Reescribir base_cognitiva/ (si usa químicos)

**OPCIÓN B: Reescritura Parcial (60-80h)**
1. Reescribir solo documentos PARTE (PARTE 0-6)
2. Asumir que base_cognitiva/ ya usa IACT

**OPCIÓN C: Reescritura Incremental**
1. Empezar con PARTE 0 (18-24h)
2. Validar con usuario
3. Continuar con PARTE 1 (40-50h)
4. Iterar

### 9.2 Orden de Prioridad para PARTE 1

Si se reescribe PARTE 1, atacar en este orden:

1. **Sección 4.3** (Desencadenadores con BR-031)
2. **Sección 5** (Distinción crítica)
3. **Sección 7.4** (Ejemplos documentados)
4. **Sección 6.4** (Sesión de licitación)
5. **Sección 9** (Ciclo de vida)
6. Resto de secciones

---

## 10. CONCLUSIONES

### 10.1 Confirmaciones

✅ **PARTE 1 usa dominio químicos** (65+ BR, 100+ términos)  
✅ **BR-031 es el ejemplo estrella** (17 ocurrencias)  
✅ **Sección 5 es crítica** (Desencadenador vs Inferencia)  
✅ **Business Requirements están ausentes** (solo mención mínima)  
✅ **Documento muy completo** (~50 páginas, 21 diagramas)

### 10.2 Alcance Real

**PARTE 1 es MÁS COMPLEJA que PARTE 0:**
- 2.5× más larga
- 2× más diagramas
- Ejemplos más detallados (UC-07 completo, RF-301 a RF-304)
- Sesión de licitación con diálogo realista

**Estimación de reescritura PARTE 1:** **40-50 horas**

### 10.3 Decisión Requerida

¿Qué quieres hacer?

**A)** Empezar a reescribir PARTE 0 (18-24h)  
**B)** Empezar a reescribir PARTE 1 (40-50h)  
**C)** Validar primero si existen PARTES 2-6  
**D)** Leer archivos críticos de base_cognitiva/ primero

---

**FIN DEL ANÁLISIS**
