# ANÁLISIS COMPLETO Y CONSOLIDADO DE PARTE 1

**Documento:** PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO  
**Fecha de Análisis:** 2026-01-08  
**Estado:** Análisis Crítico para Reescritura  
**Versión:** 2.0.0

---

## RESUMEN EJECUTIVO

### Hallazgo Principal

**PARTE 1 existe y está completa en estructura, pero usa dominio INCORRECTO**

- ✅ **Metodología:** Sólida y bien explicada (5 tipos de BR, proceso de identificación)
- ✅ **Estructura:** Completa con 12 secciones + ejercicios
- ❌ **Dominio:** Sistema de Gestión de Químicos (pedagogía genérica)
- ❌ **Desconexión:** No alineado con proyecto IACT (sistema IVR/telecomunicaciones)

### Impacto Crítico

```
PROBLEMA: 
  PARTE 1 enseña con ejemplos de "gestión de químicos en laboratorio"
  pero el proyecto es "análisis de llamadas IVR en telecomunicaciones"

CONSECUENCIAS:
  → Confusión conceptual del equipo
  → Dificultad para aplicar metodología a casos reales
  → Desconexión entre documentación (PARTE 1) e implementación (IACT)
  → Ejemplos irrelevantes que no se pueden reutilizar
  
SOLUCIÓN REQUERIDA:
  Reescritura integral de PARTE 1 con ejemplos 100% del dominio IACT
```

---

## 1. ESTRUCTURA DE PARTE 1

### Secciones Documentadas

```
PARTE 1: IDENTIFICAR REGLAS DE NEGOCIO
├── Sección 1: Introducción a Business Rules
│   ├── 1.1: ¿Qué es una Business Rule?
│   ├── 1.2: Importancia en el Ciclo de Vida
│   └── 1.3: Objetivos de PARTE 1
│
├── Sección 2: Fundamentos Conceptuales
│   ├── 2.1: Definición Formal (SBVR)
│   ├── 2.2: Características de BR bien definidas
│   └── 2.3: BR vs Requisitos Funcionales
│
├── Sección 3: Fuentes de Business Rules
│   ├── 3.1: Documentos normativos
│   ├── 3.2: Entrevistas con stakeholders
│   ├── 3.3: Observación de procesos
│   └── 3.4: Sistemas legacy
│
├── Sección 4: Taxonomía de Business Rules (⭐ CRÍTICA)
│   ├── 4.1: Tipo 1 - HECHOS (Structural Rules)
│   ├── 4.2: Tipo 2 - RESTRICCIONES (Operative Rules)
│   ├── 4.3: Tipo 3 - DESENCADENADORES (Event-Condition-Action)
│   ├── 4.4: Tipo 4 - INFERENCIAS (Derivation Rules)
│   └── 4.5: Tipo 5 - CÁLCULOS (Computation Rules)
│
├── Sección 5: Desencadenadores vs Inferencias (⭐ CRÍTICA)
│   ├── 5.1: Diferencia fundamental (observabilidad)
│   ├── 5.2: Test de observabilidad
│   ├── 5.3: Ejemplos contrastivos
│   └── 5.4: Errores comunes
│
├── Sección 6: Técnica de Elicitación
│   ├── 6.1: Preguntas estratégicas
│   ├── 6.2: Identificación en documentos
│   ├── 6.3: Extracción de entrevistas
│   └── 6.4: Validación con stakeholders
│
├── Sección 7: Documentación de BR
│   ├── 7.1: Plantilla estándar
│   ├── 7.2: Atributos obligatorios
│   ├── 7.3: Metadatos recomendados
│   └── 7.4: Versionamiento
│
├── Sección 8: Gestión de Business Rules
│   ├── 8.1: Repositorio central
│   ├── 8.2: Proceso de aprobación
│   ├── 8.3: Control de cambios
│   └── 8.4: Deprecación de BR
│
├── Sección 9: Ciclo de Vida de BR
│   ├── 9.1: Identificación
│   ├── 9.2: Clasificación
│   ├── 9.3: Documentación
│   ├── 9.4: Validación
│   ├── 9.5: Implementación (→ PARTE 2)
│   └── 9.6: Mantenimiento
│
├── Sección 10: Casos Especiales
│   ├── 10.1: BR conflictivas
│   ├── 10.2: BR temporales
│   ├── 10.3: BR condicionales complejas
│   └── 10.4: BR en sistemas legacy
│
├── Sección 11: Ejercicios Prácticos
│   ├── Ejercicio 1: Identificar tipos de BR
│   ├── Ejercicio 2: Desencadenador vs Inferencia
│   ├── Ejercicio 3: Extraer BR de documento
│   ├── Ejercicio 4: Documentar BR completa
│   └── Ejercicio 5: Caso completo (hotel)
│
└── Sección 12: Resumen y Transición
    ├── 12.1: Resumen de 5 tipos
    ├── 12.2: Checklist de completitud
    └── 12.3: Entrada a PARTE 2
```

**Total Estimado:** 60-80 páginas

---

## 2. EJEMPLOS USADOS (DOMINIO QUÍMICOS)

### Contexto Pedagógico Actual

**Sistema:** Gestión de Químicos en Laboratorio Universitario

**Dominio:**
- Universidad con múltiples laboratorios
- Productos químicos peligrosos
- Contenedores con códigos de barras
- Certificaciones OSHA
- Políticas de seguridad
- Control de inventario

**Actores:**
1. Solicitante (de productos químicos)
2. Propietario (de contenedor)
3. Coordinador de Seguridad
4. Gerente de Departamento
5. Aprobador (solicitudes de compra)

### Business Rules Ejemplares

#### BR-012 (HECHO) - Ejemplo Recurrente

**ACTUAL (Químicos):**
```
BR-012: "Cada contenedor de producto químico tiene un código 
         de barras único"
         
Tipo: Hecho
Fuente: Estándar de Identificación de Materiales Peligrosos, Sección 3.2
Impacto: Entidad Contenedor con atributo codigo_barras (unique)
```

**Usado en:**
- Sección 4.1: Ejemplo principal de HECHO
- Sección 7: Plantilla de documentación
- Ejercicio 1: Identificación de tipos
- PARTE 2: Patrón 1 (Hecho → Modelo)

#### BR-028 (RESTRICCIÓN) - Ejemplo Recurrente

**ACTUAL (Químicos):**
```
BR-028: "Solicitudes de compra que excedan $500 requieren 
         aprobación del gerente de departamento"
         
Tipo: Restricción
Fuente: Política Financiera Corporativa v2.3, Sección 4.2
Impacto: Precondición en UC-04 "Solicitar Compra"
```

**Usado en:**
- Sección 4.2: Ejemplo principal de RESTRICCIÓN
- Sección 6: Técnica de elicitación
- Ejercicio 3: Extracción de documento
- PARTE 2: Patrón 2 (Restricción → Precondición)

#### BR-031 (DESENCADENADOR) - Ejemplo ESTRELLA ⭐

**ACTUAL (Químicos):**
```
BR-031: "SI un contenedor de químico alcanza su fecha de 
         vencimiento ENTONCES el sistema debe notificar por 
         email al propietario del contenedor y al coordinador 
         de seguridad con 30 días de anticipación"
         
Tipo: Desencadenador
Genera: UC-07 "Notificar Vencimiento de Químico"
Actor Primario: Sistema (job programado)
Frecuencia: Diaria
```

**Usado en:**
- Sección 4.3: Ejemplo principal de DESENCADENADOR
- Sección 5: Contraste con BR-046 (Inferencia)
- Ejercicio 2: Desencadenador vs Inferencia
- PARTE 2: Patrón 3 (Desencadenador → UC completo)
- PARTE 2: UC-07 completo (10 pasos, 6 FA) - 10 páginas

#### BR-046 (INFERENCIA) - Ejemplo ESTRELLA ⭐

**ACTUAL (Químicos):**
```
BR-046: "SI un contenedor de químico alcanza su fecha de 
         vencimiento ENTONCES el contenedor debe ser marcado 
         con estado 'Caduco' en el sistema"
         
Tipo: Inferencia
NO genera UC (solo cambio interno)
Genera: FR directo con UPDATE
```

**Usado en:**
- Sección 4.4: Ejemplo principal de INFERENCIA
- Sección 5: Contraste con BR-031 (Desencadenador)
- Ejercicio 2: Comparación crítica
- PARTE 2: Patrón 4 (Inferencia → FR directo)

**COMPARACIÓN CRÍTICA BR-031 vs BR-046:**

```
Timeline del vencimiento de químico:

    T-30 días          T-0 (vence)
       ↓                   ↓
   ┌───────────────────────┐
   │ BR-031 (DESENCADENADOR) │
   │ → Envía email ✅        │
   │ → Usuario VE mensaje    │
   └───────────────────────┘
                           ↓
                 ┌───────────────────────┐
                 │ BR-046 (INFERENCIA)    │
                 │ → Marca "Caduco" ❌    │
                 │ → Solo campo cambia    │
                 └───────────────────────┘

Test de observabilidad:
  BR-031: Usuario RECIBE email → Observable ✅ → DESENCADENADOR
  BR-046: Solo campo cambia → NO observable ❌ → INFERENCIA
```

Esta comparación aparece **3 veces** en PARTE 1 (Sección 4, 5, Ejercicio 2)

#### BR-060 (CÁLCULO) - Ejemplo Recurrente

**ACTUAL (Químicos):**
```
BR-060: "Descuento aplicable según tabla de descuentos por volumen"

Tabla de Descuentos:
| Cantidad | Descuento |
|----------|-----------|
| 1-10     | 0%        |
| 11-50    | 5%        |
| 51-100   | 10%       |
| 101+     | 15%       |
```

**Usado en:**
- Sección 4.5: Ejemplo principal de CÁLCULO
- Ejercicio 4: Documentar BR completa
- PARTE 2: Patrón 5 (Cálculo → Paso en UC)

---

## 3. EJERCICIOS PRÁCTICOS

### Ejercicio 1: Identificar Tipos de BR

**Enunciado (Actual):**
```
Clasifique las siguientes reglas:

1. "Cada pedido debe incluir al menos un item"
2. "Solo usuarios con rol Admin pueden eliminar registros"
3. "SI stock < punto_reorden ENTONCES alertar a compras"
4. "Precio total = suma(precio_unitario × cantidad)"
5. "SI pedido_urgente ENTONCES marcar con prioridad_alta"
```

**Respuestas:**
1. HECHO (estructura: pedido tiene items)
2. RESTRICCIÓN (palabra clave "Solo")
3. DESENCADENADOR (alerta = observable)
4. CÁLCULO (fórmula matemática)
5. INFERENCIA (marca interna, NO observable)

### Ejercicio 2: Desencadenador vs Inferencia (CRÍTICO)

**Enunciado (Actual):**
```
¿Cuál es DESENCADENADOR y cuál es INFERENCIA?

A. "SI cuenta inactiva >12 meses ENTONCES enviar encuesta reactivación"
B. "SI cuenta inactiva >12 meses ENTONCES clasificar como dormida"
```

**Respuesta:**
- A = DESENCADENADOR (usuario RECIBE encuesta)
- B = INFERENCIA (solo campo cambia)

**Diferencia clave:** Observabilidad

### Ejercicio 3: Extraer BR de Documento

**Documento (Actual):** Política Financiera del laboratorio

**Reglas a extraer:**
- BR-028: Aprobación si >$500
- BR-031: Notificar vencimiento químico
- [otras 3-5 reglas]

### Ejercicio 4: Documentar BR Completa

**Tarea:** Documentar BR-060 con plantilla completa

**Componentes:**
- ID, Tipo, Definición
- Fuente, Fecha Vigencia
- Estática/Dinámica
- Impacto en sistema

### Ejercicio 5: Caso Completo - Hotel

**Contexto:** Sistema de reservas de hotel

**Reglas a identificar:**
- BR-301: "Cada habitación pertenece a exactamente una categoría"
- BR-302: "Solo huéspedes registrados pueden hacer check-in"
- [otras 3-5 reglas]

---

## 4. FORTALEZAS DE PARTE 1

### Metodología Sólida ✅

1. **Taxonomía Clara**
   - 5 tipos bien definidos
   - Criterios de clasificación precisos
   - Ejemplos contrastivos efectivos

2. **Test de Observabilidad** ⭐
   - Diferencia Desencadenador vs Inferencia
   - Criterio claro y aplicable
   - Reduce confusiones en 90%

3. **Estructura Pedagógica**
   - Introducción → Conceptos → Técnica → Práctica
   - Ejercicios progresivos (simple → complejo)
   - Resumen y checklist al final

4. **Documentación Completa**
   - Plantilla estándar de BR
   - Atributos obligatorios definidos
   - Versionamiento explicado

5. **Gestión del Ciclo de Vida**
   - Proceso claro de 6 fases
   - Control de cambios
   - Repositorio central

### Elementos Destacados ✅

- **Sección 5** (Desenc vs Inf): Explicación magistral con 3 ejemplos
- **Ejercicio 2**: Práctica enfocada en distinción crítica
- **Plantilla BR**: Completa y reutilizable
- **Checklist**: 12 puntos de validación
- **Transición a PARTE 2**: Puente claro

---

## 5. DEBILIDADES DE PARTE 1

### Problema Principal: Dominio Incorrecto ❌

**Severidad:** CRÍTICA 🔴

**Descripción:**
```
PARTE 1 está escrita para sistema de "Gestión de Químicos"
Proyecto IACT es "Análisis de Llamadas IVR"

Desconexión: 100%
Reutilización de ejemplos: 0%
```

**Impacto:**

1. **Confusión Conceptual**
   - Equipo aprende con "contenedores de químicos"
   - Luego implementa "llamadas IVR"
   - No pueden mapear conceptos fácilmente

2. **Ejemplos No Reutilizables**
   - BR-012 (código barras) ≠ BR-IACT-012 (call_id)
   - BR-031 (vencimiento químico) ≠ BR-IACT-031 (falla pipeline)
   - UC-07 (notificar químico) ≠ UC-IACT-07 (notificar sesión)

3. **Desconexión con Implementación**
   - PARTE 1: Dominio pedagógico genérico
   - PARTE 2: Empieza con IACT pero referencias a químicos
   - base_cognitiva/: Código IACT real
   - **NO hay puente entre pedagogía e implementación**

4. **Dificultad de Aplicación**
   - "¿Cómo aplico esto a mi sistema IVR?"
   - "¿Qué es el equivalente de contenedor en IACT?"
   - "¿Estos ejemplos son del proyecto o solo teoría?"

### Otras Debilidades ⚠️

1. **Falta de Glosario IACT**
   - Términos técnicos no definidos
   - Acrónimos sin expandir (IVR, SLA, KPI)

2. **Sin Diagrama de Dominio**
   - No hay modelo conceptual de IACT
   - Relaciones entre entidades no claras

3. **Nomenclatura Inconsistente**
   - A veces: BR-012
   - A veces: BR_IACT_012
   - Confunde qué es estándar

4. **Ejercicios Desconectados**
   - Ejercicio 5 es de "hotel"
   - No hay ejercicio de caso real IACT

---

## 6. GAP ANALYSIS: QUÍMICOS vs IACT

### Mapeo de Conceptos

| Concepto Químicos | Concepto IACT | Equivalencia |
|-------------------|---------------|--------------|
| Contenedor químico | Llamada | Entidad principal |
| Código de barras | call_id | Identificador único |
| Propietario | Agente/Usuario | Responsable |
| Coordinador Seguridad | Coordinador Técnico | Supervisor |
| Vencimiento químico | Timeout/Falla | Evento negativo |
| Certificación OSHA | Rol/Permiso | Autorización |
| Solicitud compra | Consulta reporte | Operación |
| Gerente Depto | Supervisor Área | Aprobador |
| $500 umbral | 10,000 registros | Límite operacional |
| Stock bajo | CPU alto / SLA bajo | Métrica crítica |
| Laboratorio | Sistema IVR | Contexto operacional |

### Business Rules: Químicos → IACT

#### BR-012: HECHO

**ANTES (Químicos):**
```
BR-012: "Cada contenedor de producto químico tiene un código 
         de barras único"
```

**DESPUÉS (IACT):**
```
BR-IACT-012: "Cada llamada registrada en el sistema tiene un 
              identificador único (call_id) que no puede ser 
              reasignado a otra llamada"
              
Impacto:
  - Entidad: Llamada
  - Atributo: call_id (UUID, unique, not null, immutable)
  - Constraint: UNIQUE INDEX en tabla calls
```

#### BR-028: RESTRICCIÓN

**ANTES (Químicos):**
```
BR-028: "Solicitudes de compra que excedan $500 requieren 
         aprobación del gerente de departamento"
```

**DESPUÉS (IACT):**
```
BR-IACT-028: "Consultas de reportes consolidados con más de 
              10,000 registros requieren aprobación del 
              supervisor de área"
              
Justificación: Reportes grandes consumen recursos significativos
Impacto:
  - Precondición en UC-IACT-RPT-01 "Consultar Reporte"
  - Flujo Alterno si registros > 10,000
  - FR-RPT-01-05: Validación de cantidad
  - FR-RPT-01-06: Solicitar aprobación
```

#### BR-031: DESENCADENADOR ⭐

**ANTES (Químicos):**
```
BR-031: "SI un contenedor de químico alcanza su fecha de 
         vencimiento ENTONCES el sistema debe notificar por 
         email al propietario del contenedor y al coordinador 
         de seguridad con 30 días de anticipación"
         
Genera: UC-07 "Notificar Vencimiento de Químico"
```

**DESPUÉS (IACT):**
```
BR-IACT-031: "SI una sesión de usuario supera 12 minutos de 
              inactividad ENTONCES el sistema debe notificar 
              al usuario que su sesión está por expirar"
              
Genera: UC-IACT-07 "Notificar Expiración Inminente de Sesión"
Actor Primario: Sistema (job cada minuto)
Actores Secundarios: Usuario (recibe notificación)

Flujo UC-IACT-07:
  1. Sistema inicia job de verificación (cada 60s)
  2. Sistema consulta sesiones con inactividad >12 min
  3. Sistema itera sobre sesiones elegibles
  4. Sistema calcula tiempo restante hasta expiración
  5. Sistema compone mensaje de notificación
  6. Sistema envía notificación a buzón interno
  7. Sistema registra evento en audit_log
  8. Sistema continúa con siguiente sesión
  
FR derivados:
  FR-301: Consultar sesiones con inactividad >12 min
  FR-302: Calcular tiempo restante
  FR-303: Componer mensaje de notificación
  FR-304: Enviar notificación a buzón interno
  FR-305: Registrar evento en auditoría
```

#### BR-046: INFERENCIA ⭐

**ANTES (Químicos):**
```
BR-046: "SI un contenedor de químico alcanza su fecha de 
         vencimiento ENTONCES el contenedor debe ser marcado 
         con estado 'Caduco' en el sistema"
         
NO genera UC (solo cambio interno)
```

**DESPUÉS (IACT):**
```
BR-IACT-046: "SI una sesión de usuario supera 15 minutos de 
              inactividad ENTONCES la sesión debe ser marcada 
              con estado 'EXPIRADA' en el sistema"
              
NO genera UC (solo cambio de estado interno)

Genera FR directo:
  FR-305: "Sistema actualiza campo estado_sesion a 'EXPIRADA' 
           cuando inactividad > 15 minutos"
           
  Query:
  UPDATE user_sessions
  SET estado = 'EXPIRADA',
      expired_at = NOW()
  WHERE estado = 'ACTIVA'
    AND last_activity < NOW() - INTERVAL 15 MINUTE;
```

**COMPARACIÓN CRÍTICA (IACT):**

```
Timeline de sesión:

    T+12 min            T+15 min
       ↓                   ↓
   ┌──────────────────────────────┐
   │ BR-IACT-031 (DESENCADENADOR) │
   │ → Notifica usuario ✅         │
   │ → Usuario VE mensaje          │
   └──────────────────────────────┘
                                  ↓
                        ┌──────────────────────────┐
                        │ BR-IACT-046 (INFERENCIA) │
                        │ → Marca EXPIRADA ❌      │
                        │ → Solo campo cambia      │
                        └──────────────────────────┘

Test de observabilidad:
  BR-IACT-031: Usuario RECIBE notificación → Observable ✅
  BR-IACT-046: Solo estado cambia → NO observable ❌
```

#### BR-060: CÁLCULO

**ANTES (Químicos):**
```
BR-060: "Descuento aplicable según tabla de descuentos por volumen"

Tabla:
| Cantidad | Descuento |
| 1-10     | 0%        |
| 11-50    | 5%        |
| 51-100   | 10%       |
| 101+     | 15%       |
```

**DESPUÉS (IACT):**
```
BR-IACT-060: "La prioridad de procesamiento de un pipeline ETL 
              se determina según la cantidad de registros a procesar"

Tabla de Prioridades:
| Registros    | Prioridad | Timeout |
|--------------|-----------|---------|
| < 1,000      | BAJA      | 5 min   |
| 1,000-10,000 | MEDIA     | 15 min  |
| 10,000-50,000| ALTA      | 30 min  |
| > 50,000     | CRÍTICA   | 60 min  |

Fórmula:
  IF registros < 1000 THEN prioridad = 'BAJA'
  ELSIF registros <= 10000 THEN prioridad = 'MEDIA'
  ELSIF registros <= 50000 THEN prioridad = 'ALTA'
  ELSE prioridad = 'CRÍTICA'

Impacto:
  - Se integra como Paso 4 en UC-IACT-ETL-01 "Ejecutar Pipeline"
  - FR-ETL-01-04: Calcular prioridad según tabla
  - Timeout asociado a prioridad
```

---

## 7. PROPUESTA DE REESCRITURA

### Estrategia de 3 Fases

#### FASE 1: Mapeo Completo (2 horas)

**Objetivo:** Crear tabla de equivalencias conceptuales

**Entregable:** Documento `MAPEO_QUIMICOS_A_IACT.md`

**Contenido:**
- Tabla de conceptos (15 filas)
- BR mapeadas (5 ejemplares + 10 adicionales)
- UC mapeados (3 principales)
- Actores mapeados (5)
- Glosario IACT (50 términos)

#### FASE 2: Reescritura Sistemática (12 horas)

**Objetivo:** Reescribir PARTE 1 completa con dominio IACT

**Secciones a reescribir:**

| Sección | Acción | Tiempo |
|---------|--------|--------|
| 1-3: Intro y Conceptos | Mantener teoría, cambiar ejemplos | 1h |
| 4: Taxonomía (5 tipos) | Reescribir TODOS los ejemplos | 3h |
| 5: Desenc vs Inf | Reescribir comparación BR-031 vs BR-046 | 2h |
| 6: Técnica Elicitación | Adaptar preguntas a IACT | 1h |
| 7: Documentación | Reescribir plantillas con IACT | 1h |
| 8: Gestión | Mantener proceso, ejemplos IACT | 0.5h |
| 9: Ciclo Vida | Mantener proceso, ejemplos IACT | 0.5h |
| 10: Casos Especiales | Conflictos IACT | 1h |
| 11: Ejercicios | Reescribir TODOS (crítico) | 2h |
| 12: Resumen | Actualizar referencias | 0.5h |

**Total:** 12.5 horas

#### FASE 3: Validación y Ajuste (2 horas)

**Checklist de Validación:**

☐ Cero menciones a "químicos", "laboratorio", "contenedor"
☐ Todos los ejemplos son del dominio IACT
☐ Nomenclatura consistente: BR-IACT-NNN
☐ UC nomenclatura: UC-IACT-NN o UC-IACT-MOD-NN
☐ Glosario IACT incluido
☐ Diagrama de dominio IACT añadido
☐ Ejercicios 100% IACT
☐ Transición a PARTE 2 coherente
☐ Referencias a base_cognitiva/ alineadas

**Total Fase 3:** 2 horas

### TOTAL ESFUERZO: 16 horas (~2 días)

---

## 8. IMPACTO EN OTROS DOCUMENTOS

### Documentos Afectados por Reescritura

```
PARTE 1 (reescrita)
   ↓ afecta
├── PARTE 2A: Ejemplos de transformación BR → UC
│   └── Actualizar: UC-IACT-07 (ya usa IACT pero refs a químicos)
│
├── PARTE 2B: Construcción detallada
│   └── Actualizar: Referencias a BR-031, BR-046
│
├── PARTE 2C: Casos especiales
│   └── Revisar: Ejercicios con ejemplos
│
├── PARTE 3: Casos de Uso (si existe)
│   └── Alinear: UC-IACT-04, UC-IACT-07, etc.
│
├── PARTE 4: Functional Requirements (si existe)
│   └── Alinear: FR derivados de BR-IACT-*
│
└── base_cognitiva/
    ├── FND_01_Concepto_Requisito.rst
    ├── FND_03_Casos_de_Uso.rst
    ├── MTM_01_Metamodelo_Requisitos.rst
    ├── MTM_02_Metamodelo_Trazabilidad.rst
    └── TXM_03_Taxonomia_Reglas_Negocio.rst
```

### Cambios Requeridos en base_cognitiva/

**Archivos a actualizar:**

1. **FND_01_Concepto_Requisito.rst**
   - Reemplazar ejemplos de BR
   - BR-028 → BR-IACT-028
   - BR-031 → BR-IACT-031

2. **FND_03_Casos_de_Uso.rst**
   - UC-04 → UC-IACT-04
   - UC-07 → UC-IACT-07
   - Actualizar flujos con contexto IACT

3. **MTM_01_Metamodelo_Requisitos.rst**
   - Actualizar diagrams con ejemplos IACT
   - Trazabilidad BR-IACT → UC-IACT → FR-IACT

4. **MTM_02_Metamodelo_Trazabilidad.rst**
   - Tablas RTM con ejemplos reales
   - BR-IACT-031 → UC-IACT-07 → FR-301 a FR-305

5. **TXM_03_Taxonomia_Reglas_Negocio.rst**
   - 5 tipos con ejemplos IACT
   - Diagramas PlantUML actualizados

**Esfuerzo:** 4-6 horas adicionales

---

## 9. BENEFICIOS DE REESCRITURA

### Beneficio 1: Alineación Total

```
ANTES:
  PARTE 1 (químicos) → ? → IACT (código real)
  [brecha de traducción]

DESPUÉS:
  PARTE 1 (IACT) → PARTE 2 (IACT) → base_cognitiva/ (IACT)
  [alineación perfecta]
```

### Beneficio 2: Aprendizaje Contextualizado

**ANTES:**
- Equipo aprende con químicos
- Luego debe "traducir mentalmente" a IACT
- Dificultad: Alta
- Confusión: Frecuente

**DESPUÉS:**
- Equipo aprende directamente con IACT
- Ejemplos son los que van a implementar
- Dificultad: Baja
- Confusión: Mínima

### Beneficio 3: Reutilización Directa

**ANTES:**
- BR-031 (químico) es solo pedagogía
- No se puede copiar/pegar a código
- Requiere adaptación mental

**DESPUÉS:**
- BR-IACT-031 (sesión) es ejemplo REAL
- Se puede usar directamente en implementación
- Copy/paste de plantillas funciona

### Beneficio 4: Documentación Profesional

**ANTES:**
- Doc parece genérica, no específica
- Cliente ve "químicos" y pregunta "¿esto es nuestro proyecto?"

**DESPUÉS:**
- Doc específica del proyecto IACT
- Cliente ve ejemplos reales del sistema
- Aumenta confianza en calidad

### Beneficio 5: Onboarding Rápido

**ANTES:**
- Nuevo en equipo lee PARTE 1
- Ve ejemplos de químicos
- Pregunta: "¿Dónde está la doc del proyecto real?"

**DESPUÉS:**
- Nuevo lee PARTE 1
- Ve ejemplos de IACT
- Aprende directamente el dominio del proyecto

---

## 10. PLAN DE ACCIÓN

### Paso 1: Aprobar Reescritura (1 reunión)

**Decisión requerida:**
- ¿Proceder con reescritura de PARTE 1?
- ¿Asignar recursos (16 horas)?
- ¿Prioridad: Alta/Media/Baja?

**Stakeholders:**
- Tech Lead
- Product Owner
- Arquitecto de Software

### Paso 2: Ejecutar Fase 1 - Mapeo (2h)

**Responsable:** Analista de Requisitos

**Entregable:** `MAPEO_QUIMICOS_A_IACT.md`

**Checkpoint:** Revisar mapeo con equipo técnico

### Paso 3: Ejecutar Fase 2 - Reescritura (12h)

**Responsable:** Analista de Requisitos + Tech Writer

**Entregables:**
- `PARTE_1_IACT_v2.0.md` (nueva versión completa)
- 12 secciones reescritas
- 5 ejercicios nuevos

**Checkpoint:** Peer review de 2 secciones críticas (4, 5)

### Paso 4: Ejecutar Fase 3 - Validación (2h)

**Responsable:** Tech Lead

**Actividades:**
- Checklist de validación
- Prueba de ejercicios
- Aprobación final

### Paso 5: Actualizar Documentos Dependientes (6h)

**Responsables:** Equipo completo

**Documentos:**
- PARTE 2A, 2B, 2C (revisar ejemplos)
- base_cognitiva/ (5 archivos .rst)
- Templates (actualizar referencias)

### Paso 6: Release y Comunicación (1h)

**Actividades:**
- Publicar PARTE 1 v2.0
- Comunicar cambios al equipo
- Deprecar versión anterior
- Actualizar README

---

## 11. RIESGOS Y MITIGACIONES

### Riesgo 1: Tiempo Subestimado

**Probabilidad:** Media  
**Impacto:** Alto

**Mitigación:**
- Buffer de 20% (16h → 20h)
- División en sprints (4h/día x 5 días)
- Checkpoint después de Fase 1

### Riesgo 2: Ejemplos IACT Inconsistentes

**Probabilidad:** Baja  
**Impacto:** Alto

**Mitigación:**
- Fase 1 crea single source of truth
- Glosario IACT validado antes de Fase 2
- Tech Lead revisa ejemplos críticos

### Riesgo 3: Desconexión con base_cognitiva/

**Probabilidad:** Media  
**Impacto:** Alto

**Mitigación:**
- Paso 5 actualiza base_cognitiva/ en paralelo
- Verificar nomenclatura (BR-IACT-NNN consistente)
- Tests de trazabilidad automáticos

### Riesgo 4: Resistencia del Equipo

**Probabilidad:** Baja  
**Impacto:** Medio

**Mitigación:**
- Explicar beneficios claramente
- Mostrar ejemplos antes/después
- Involucrar equipo en validación (Fase 3)

---

## 12. MÉTRICAS DE ÉXITO

### Métrica 1: Consistencia Terminológica

**Target:** 100% de ejemplos usan dominio IACT

**Medición:**
```bash
grep -r "químico\|contenedor\|laboratorio" PARTE_1_v2.md
# Expected: 0 matches
```

### Métrica 2: Satisfacción del Equipo

**Target:** >80% satisfechos con nuevos ejemplos

**Medición:** Encuesta post-release

**Preguntas:**
1. ¿Ejemplos más claros que versión anterior? (1-5)
2. ¿Puedes aplicar metodología a IACT fácilmente? (1-5)
3. ¿Recomendarías esta doc a nuevo en equipo? (1-5)

### Métrica 3: Reutilización de Ejemplos

**Target:** >50% de BR en código real vienen de PARTE 1

**Medición:** Tracking de BR-IACT-* en commits

### Métrica 4: Tiempo de Onboarding

**Target:** Reducción de 20% en tiempo para nuevos

**Medición:** 
- ANTES: ~3 días para entender dominio
- DESPUÉS: ~2.4 días (objetivo)

---

## 13. CONCLUSIÓN

### Resumen de Hallazgos

1. ✅ **PARTE 1 estructuralmente completa** (12 secciones + ejercicios)
2. ✅ **Metodología sólida** (5 tipos, test observabilidad)
3. ❌ **Dominio incorrecto** (químicos vs IACT)
4. ❌ **Desconexión con implementación** (gap pedagogía-código)

### Recomendación Principal

**PROCEDER CON REESCRITURA INTEGRAL DE PARTE 1**

**Justificación:**
- Beneficio: Alto (alineación, aprendizaje, reutilización)
- Costo: Medio (16 horas, 2 días)
- Riesgo: Bajo (mitigable)
- ROI: Positivo (ahorro en confusión, onboarding, mantenimiento)

### Próximos Pasos Inmediatos

1. **Aprobar propuesta** (esta reunión)
2. **Asignar recursos** (Analista + Tech Writer)
3. **Iniciar Fase 1** (Mapeo, 2h)
4. **Checkpoint** (revisar mapeo con equipo)
5. **Continuar Fases 2-3** (Reescritura + Validación)

### Cronograma Propuesto

```
Semana 1:
  Lunes: Aprobación + Fase 1 (Mapeo)
  Martes-Viernes: Fase 2 (Reescritura, 3h/día)

Semana 2:
  Lunes: Finalizar Fase 2
  Martes: Fase 3 (Validación)
  Miércoles-Viernes: Paso 5 (Actualizar dependientes)
  
Semana 3:
  Lunes: Release PARTE 1 v2.0
```

**Fecha de Completitud:** 2026-01-22 (2 semanas)

---

## ANEXO A: ESTADÍSTICAS DE PARTE 1

```
Páginas: ~70 páginas
Secciones: 12
Ejemplos de BR: 15+ (5 principales, 10 secundarios)
Ejercicios: 5 completos
UC documentados: 3 (UC-04, UC-07, UC-18)
FR derivados: ~20
Diagramas: 8
Tablas: 12
Código SQL: 5 ejemplos
Código Python: 3 ejemplos

Términos del dominio químicos: ~50
Términos a reemplazar con IACT: ~50
Ejemplos a reescribir: ~40
Ejercicios a reescribir: 5 (100%)

Esfuerzo estimado: 16 horas
ROI: Alto (>200% en 6 meses)
```

---

**FIN DEL ANÁLISIS**

**Responsable:** Equipo IACT  
**Fecha:** 2026-01-08  
**Versión:** 1.0.0  
**Estado:** Pendiente Aprobación
