```yml
created_at: 2026-04-24 02:50:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Borrador
version: 1.0.0
```

# Análisis: PlantUML Timing Diagrams — Modelado de Restricciones de Timing en Sistemas

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 232-272+ (Secciones 10.0-10.29)

**Propósito:** Validar si timing diagrams son aplicables a IACT-docs para documentación de requisitos funcionales.

**Criticidad:** MUY BAJA — Especializado; enfocado en sistemas tiempo real e integrados, no en requisitos de negocio.

---

## 1. Qué son Timing Diagrams

### 1.1 Definición y Propósito

**Timing Diagram:** Diagrama de interacción UML que visualiza:
- Restricciones de timing en el sistema
- Orden cronológico de eventos (con precisión temporal)
- Cómo objetos interactúan a lo largo del tiempo
- Comportamiento de sistemas en tiempo real

**Dominio de aplicación:**
- Sistemas en tiempo real (real-time systems)
- Sistemas embebidos (embedded systems)
- Protocolos de comunicación (timing de señales)
- Comportamiento sincronizado de múltiples entidades

**Diferencias conceptuales:**
- **Sequence Diagram:** Interacciones basadas en lógica (orden temporal, no duración)
- **Timing Diagram:** Interacciones basadas en tiempo (duración, constraints, precisión temporal)
- **Activity Diagram:** Flujo de actividades (parallelismo, no timing)
- **State Diagram:** Estados y transiciones (comportamiento reactivo, no timing)

### 1.2 Elementos Principales

Los timing diagrams se definen usando **participantes** y **estados temporales**.

---

## 2. Sintaxis de Timing Diagrams (Secciones 10.1-10.29)

### 2.1 Tipos de Participantes (Section 10.1)

**Sintaxis:**
```plantuml
robust "Name" as ID      ← Línea compleja para transiciones de estado
concise "Name" as ID     ← Línea simplificada para movimiento de datos
binary "Name" as ID      ← Señal binaria (solo 2 estados)
clock "Name" as ID       ← Señal reloj (períodos regulares)
analog "Name" as ID      ← Señal analógica (valores continuos)
```

**Características:**
- `robust` — complejidad alta (transiciones suaves)
- `concise` — complejidad media (datos)
- `binary` — 2 estados (high/low, true/false)
- `clock` — oscilación periódica
- `analog` — continuidad (interpolación lineal)

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE — Ninguno de estos tipos es relevante para documentación de requisitos funcionales

### 2.2 Definición de Estados Temporales (Section 10.1)

**Sintaxis:**
```plantuml
@0
Signal is Idle

@100
Signal is Processing

@300
Signal is Waiting
```

**Características:**
- `@N` — timestamp absoluto
- `Signal is State` — cambio de estado a tiempo N
- Multi-línea permitida para cambios simultáneos

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE — No hay requisitos de timing preciso en IACT-docs

### 2.3 Mensajes Entre Participantes (Section 10.3)

**Sintaxis:**
```plantuml
@100
User -> System : URL
User is Waiting
System is Processing
```

**Características:**
- Mensajes con timestamp
- Notas contextuales
- Transiciones simultáneas

**Aplicabilidad a IACT:**
- ⚠️ MUY BAJA — Sequence diagrams ya cubren mensajes mejor

### 2.4 Tiempo Relativo (Section 10.4)

**Sintaxis:**
```plantuml
@0
Signal is State1

@+100
Signal is State2

@+200
Signal is State3
```

**Características:**
- `@+N` — relativo al anterior
- Más legible que absoluto para cálculos
- Muestra duraciones claramente

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.5 Anchor Points (Section 10.5)

**Sintaxis:**
```plantuml
@0 as :start
@100 as :mid
@200 as :end

@:mid-50
Signal is State
```

**Características:**
- Puntos nombrados para referencia
- Cálculo relativo a anchors
- Mejora legibilidad

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.6 Escalado (Section 10.7)

**Sintaxis:**
```plantuml
scale 100 as 50 pixels   ← 100 unidades = 50 píxeles
scale 31536000 as 40 pixels  ← Para rangos grandes (ej: años)
```

**Características:**
- Ajusta visualización
- Soporta dates/times
- Permite representar períodos largos

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.7 Estado Inicial (Section 10.8)

**Sintaxis:**
```plantuml
robust "Web Browser" as WB
WB is Initializing
```

**Características:**
- Define estado antes de @0
- Clarifica condición inicial

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.8 Estados Intrincados/Indefinidos (Section 10.9)

**Sintaxis:**
```plantuml
robust "Signal" as S
S has 0,1,2,hello

@100
S is {0,1}  ← Estado múltiple (ambiguo)

@200
S is hello
```

**Características:**
- Estados inciertos (el signal es "uno u otro")
- Útil para circuitos reales con incertidumbre

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.9 Estados Ocultos (Section 10.10)

**Sintaxis:**
```plantuml
@0
Signal is A

@100
Signal is {-}    ← Hidden state

@200
Signal is B
```

**Características:**
- `{-}` — ocultación temporal
- `{hidden}` — ocultación permanente
- Mejora visualización sin perder datos

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.10 Ocultar Eje de Tiempo (Section 10.11)

**Sintaxis:**
```plantuml
hide time-axis
```

**Características:**
- Elimina eje temporal
- Muestra solo transiciones
- Simplifica diagrama

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.11 Usando Fechas y Horas (Section 10.12)

**Sintaxis:**
```plantuml
@2019/07/02
Signal is Idle

@2019/07/04
Signal is Processing

use date format "YY-MM-dd"
```

**Características:**
- Soporta fechas: `@YYYY/MM/DD`
- Soporta horas: `@HH:MM:SS`
- Formato personalizable

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.12 Restricciones de Tiempo (Section 10.15)

**Sintaxis:**
```plantuml
@0
Signal is Start

@0 <-> @50 : {50 ms lag}

@200 <-> @+150 : {150 ms}
```

**Características:**
- Visualiza restricciones de timing
- Etiquetas para duraciones
- Flechas bidirecionales

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.13 Períodos Destacados (Section 10.16)

**Sintaxis:**
```plantuml
highlight 200 to 450 #Gold;line:DimGrey : Caption
highlight 600 to 700 : Another period
```

**Características:**
- Resalta períodos de tiempo
- Colores y estilos personalizables
- Notas descriptivas

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.14 Notas (Section 10.17)

**Sintaxis:**
```plantuml
note top of Signal : first note\non several\nlines
note bottom of Signal : second note
```

**Características:**
- Notas en participantes
- Multi-línea soportada
- Similar a otros diagramas

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO si se usan timing diagrams (pero no aplica globalmente)

### 2.15 Textos Adicionales (Section 10.18)

**Sintaxis:**
```plantuml
Title My Title
header: some header
footer: some footer
legend
Legend text
end legend
caption some caption
```

**Características:**
- Títulos, headers, footers
- Leyendas y captions
- Estándar en todos los diagramas

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO (estándar)

### 2.16 Estilos Globales (Section 10.22)

**Sintaxis:**
```plantuml
<style>
timingDiagram {
  document {
    BackGroundColor SandyBrown
  }
  constraintArrow {
    LineStyle 2-1
    LineThickness 3
    LineColor Blue
  }
}
</style>
```

**Características:**
- `<style>` block para personalización
- Elementos específicos: document, constraintArrow
- Colores, estilos, espesores

**Aplicabilidad a IACT:**
- ⚠️ MUY BAJA — Si timing diagrams se usaran, necesitaría centralización
- Pero timing diagrams no son aplicables

### 2.17 Estilos Estereotipados (Section 10.23)

**Sintaxis:**
```plantuml
<style>
timingDiagram {
  .red {
    LineColor red
  }
  .blue {
    LineColor blue
    LineThickness 5
  }
}
</style>

binary "Signal1" as S1 <<blue>>
binary "Signal2" as S2 <<red>>
```

**Características:**
- Clases de estilo nombradas
- Aplicables con `<<stereotype>>`
- Reutilización

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.18 Modo Compacto (Section 10.24)

**Sintaxis:**
```plantuml
mode compact
compact robust "Browser" as B
```

**Características:**
- Global o por elemento
- Reduce espacio vertical
- Mejora legibilidad

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.19 Señales Analógicas (Section 10.25-10.26)

**Sintaxis:**
```plantuml
analog "Voltage" as V
V between 350 and 450 as A

@0
A is 350

@100
A is 450

V ticks num on multiple 3
V is 200 pixels height
```

**Características:**
- Escala min-max
- Interpolación lineal
- Altura personalizable
- Ticks configurables

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE (sistemas embebidos solamente)

### 2.20 Orden de Estados Robustos (Section 10.27)

**Sintaxis:**
```plantuml
robust "Flow rate" as rate
rate has high,low,none
rate has "35 gpm" as high
rate has "15 gpm" as low
rate has "0 gpm" as none

@0
rate is high
```

**Características:**
- Define orden de estados válidos
- Etiquetado con unidades
- Validación de transiciones

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.21 Definición por Reloj/Señal/Tiempo (Section 10.28)

**Sintaxis:**
```plantuml
@clk*0          ← Por reloj
@clk*1
@clk*2

@Signal@50      ← Por participante
@Signal@150

@0              ← Por tiempo absoluto
@50
@100
```

**Características:**
- Múltiples formas de referencia
- Sincronización con reloj
- Sincronización con señal

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

### 2.22 Anotaciones de Comentarios (Section 10.29)

**Sintaxis:**
```plantuml
@-3
Signal is State : description

@0
Signal is NewState : 1 lsb

@8
Signal is Stop : end of sequence

@0 <-> @8 : Serial data bits
```

**Características:**
- Comentarios en transiciones
- Descripciones de estados
- Notas sobre períodos

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE

---

## 3. Evaluación de Aplicabilidad a IACT-docs

### 3.1 Cuándo PODRÍAN Usarse Timing Diagrams

**Teóricamente en:**
1. Integración con sistemas externo en tiempo real
2. Especificación de protocolos de comunicación
3. Documentación de constraints de timing en APIs
4. Comportamiento sincronizado multi-entidad

**Realidad IACT-docs:**
- ❌ **NO HAY requisitos de timing real-time identificados**
- ❌ **NO HAY protocolos de bajo nivel (electrical/digital)**
- ❌ **NO HAY sistemas embebidos involucrados**
- ❌ **NO HAY restricciones de microsegundos/milisegundos**

### 3.2 Cuándo DEFINITIVAMENTE NO Usar

**Timing diagrams son completamente innecesarios para:**
1. Documentación de requisitos funcionales (IACT-docs es esto)
2. Flujos de procesos de negocio
3. Interacciones de usuarios (Activity/Sequence diagrams mejor)
4. Especificación de lógica de decisiones
5. Cualquier documentación de alto nivel

### 3.3 Recomendación Final

**Aplicabilidad: NOT APPLICABLE (❌ COMPLETAMENTE FUERA DE SCOPE)**

**Conclusión:**
Timing diagrams son para sistemas en tiempo real, protocolos de comunicación de bajo nivel, y circuitos digitales. IACT-docs es una aplicación empresarial con requisitos funcionales de negocio. Timing diagrams **NO APLICAN** en ningún contexto para este proyecto.

---

## 4. Síntesis: Timing Diagrams en IACT-docs

### 4.1 Hallazgos Clave

1. **Propósito:** Modelado de restricciones de timing en sistemas en tiempo real/integrados
2. **Sintaxis:** Especializada (participantes temporales, timestamps, constraints)
3. **Claridad:** Excelente para timing, pero solo relevante para circuitos/real-time
4. **Personalización:** `<style>` blocks soportado (moderno)
5. **Complejidad:** Alta (muchas características especializadas)

### 4.2 Comparativa: Timing vs. Sequence vs. Activity Diagrams

| Aspecto | Timing Diagram | Sequence Diagram | Activity Diagram |
|---------|---|---|---|
| **Foco** | Restricciones de timing (microsegundos) | Interacciones lógicas | Flujo de actividades |
| **Cuándo usar** | Real-time, protocolos, circuitos | Comunicación entre entidades | Procesos/flujos |
| **Precisión temporal** | ALTA (nanosegundos) | MEDIA (lógica) | BAJA (flujo) |
| **Aplicabilidad IACT** | ❌ NO APLICABLE | ✓ IMPORTANTE | ✓ IMPORTANTE |

### 4.3 Recomendación Final

**Para IACT-docs:**
- ❌ **NO incluir** Timing Diagrams en Phase 1 Setup
- ❌ **NO incluir** soporte en plantuml-styles.puml
- ❌ **NO postergar** a fases futuras (nunca serán necesarios)
- ✓ **Reconocer** que PlantUML 1.2025.0 lo soporta, pero es out-of-scope

---

## 5. Conclusión

Timing diagrams en PlantUML 1.2025.0 ofrecen soporte robusto para modelado de sistemas en tiempo real. Sin embargo, para IACT-docs, su aplicabilidad es **COMPLETAMENTE FUERA DE SCOPE**.

**Recomendación:**
- ❌ **NOT RECOMMENDED** para IACT-docs
- ❌ **NOT APPLICABLE** a documentación de requisitos funcionales
- ✓ **Reconocido** como especialidad de PlantUML (pero irrelevante para este proyecto)

**Aplicabilidad Final: NOT APPLICABLE (Completamente fuera de scope)**

