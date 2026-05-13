```yml
created_at: 2026-04-24 02:35:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Borrador
version: 1.0.0
```

# Análisis: PlantUML State Diagrams — Modelado de Comportamiento Dinámico de Sistemas

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 210-230+ (Secciones 9.0-9.25)

**Propósito:** Validar si state diagrams son aplicables a IACT-docs para documentación de requisitos funcionales.

**Criticidad:** BAJA-MEDIA — Especializado; modelado de comportamiento a nivel de entidad/objeto, no de procesos de negocio.

---

## 1. Qué son State Diagrams

### 1.1 Definición y Propósito

**State Diagram:** Diagrama estructural UML que visualiza:
- Distintos estados en los que puede encontrarse un sistema u objeto
- Transiciones entre esos estados
- Eventos que disparan cambios de estado
- Ciclo de vida dinámico del sistema

**Diferencias conceptuales:**
- **Activity Diagram:** Flujo de actividades, procesos (NOD: swimlanes para actores)
- **State Diagram:** Estados y transiciones (foco: comportamiento reactivo a eventos)
- **Sequence Diagram:** Interacciones entre entidades (foco: comunicación temporal)
- **Class/Component Diagram:** Estructura estática (foco: relaciones arquitectónicas)

**Dominio de aplicación:**
- Modelado de máquinas de estado (state machines)
- Ciclo de vida de objetos (transitions triggered by events)
- Comportamiento reactivo ante eventos externos
- Control de flujo basado en estados

---

## 2. Sintaxis de State Diagrams (Secciones 9.1-9.25)

### 2.1 Estados Simples (Section 9.1)

**Sintaxis básica:**
```plantuml
[*] --> State1
State1 --> State2
State2 --> [*]
State1 : description line 1
State1 : description line 2
```

**Características:**
- `[*]` — punto de inicio/finalización
- `-->` — transición entre estados (flechas)
- `State : description` — agregar descripciones a estados
- Estados nombrados (State1, State2, etc.)

**Aplicabilidad a IACT:**
- ⚠️ BAJA — Estados simples suficientes si se usan state diagrams
- Claridad: estados bien definidos esenciales para UC documentation

### 2.2 Representación Visual Simplificada (Section 9.2)

**Comando:**
```plantuml
hide empty description
```

**Efecto:** Muestra estados como cajas simples sin decoraciones adicionales (aspecto limpio).

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO si se usan state diagrams — mejora legibilidad

### 2.3 Estados Compuestos (Section 9.3)

**Sintaxis:**
```plantuml
state Parent {
  state Child1
  state Child2
  [*] --> Child1
  Child1 --> Child2
}
```

**Características:**
- Subestados anidados (composición jerárquica)
- Estados internos con sus propias transiciones
- Subestado a subestado (transiciones entre subestados de diferentes padres)

**Aplicabilidad a IACT:**
- ✓ MODERADA — Composición jerárquica útil para:
  - Estados complejos con substates (ej: "Authenticated" → "ViewingDocs", "EditingDocs")
  - Documentación de control de flujo complicado
  - Pero probablemente innecesario para UC funcionales simples

### 2.4 Nombres Largos (Section 9.4)

**Sintaxis:**
```plantuml
state "Long Description Here" as shortAlias
shortAlias : description
```

**Características:**
- Alias para estados con nombres descriptivos largos
- Multi-línea con `\n`

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — Nombres largos + alias mejoran claridad

### 2.5 Histórico (Section 9.5)

**Sintaxis:**
```plantuml
[H]   — shallow history (último subestado)
[H*]  — deep history (recuérdalo recursivamente)
```

**Aplicabilidad a IACT:**
- ⚠️ BAJA — Característica avanzada; probablemente no necesaria para UC documentation

### 2.6 Bifurcación y Unión (Section 9.6)

**Sintaxis:**
```plantuml
state fork_state <<fork>>
state join_state <<join>>

[*] --> fork_state
fork_state --> State1
fork_state --> State2
State1 --> join_state
State2 --> join_state
```

**Características:**
- `<<fork>>` — dividir flujo en paralelo
- `<<join>>` — reconverger flujos paralelos
- Similar a forks en Activity diagrams pero en contexto de estados

**Aplicabilidad a IACT:**
- ⚠️ MUY BAJA — Parallelismo de estado raramente necesario en UC documentation

### 2.7 Estados Concurrentes (Section 9.7)

**Sintaxis:**
```plantuml
state Active {
  [*] -> State1
  State1 --> State2
  --           ← separador horizontal
  [*] -> State3
  State3 --> State4
}
```

**Características:**
- `--` — separador horizontal (concurrencia)
- `||` — separador vertical (concurrencia)
- Múltiples substates independientes activos simultáneamente

**Aplicabilidad a IACT:**
- ⚠️ BAJA — Estados concurrentes requieren coordinación compleja
- Probablemente fuera de scope para UC funcionales

### 2.8 Condicionales (Section 9.8)

**Sintaxis:**
```plantuml
state choice1 <<choice>>
State1 --> choice1
choice1 --> State2 : [condition1]
choice1 --> State3 : [condition2]
```

**Características:**
- `<<choice>>` — punto de decisión (como el rombo en Activity diagrams)
- Transiciones condicionales basadas en predicados
- Divergencia sin sincronización

**Aplicabilidad a IACT:**
- ✓ MODERADA — Lógica condicional útil para:
  - Decisiones basadas en estado (ej: "Si usuario autenticado → acceso_concedido, sino → acceso_denegado")
  - Pero Activity diagrams con decisiones ya cubren esto mejor

### 2.9 Estereotipos Complejos (Section 9.9)

**Sintaxis:**
```plantuml
state start1 <<start>>
state choice1 <<choice>>
state fork1 <<fork>>
state join2 <<join>>
state end3 <<end>>
```

**Características:**
- `<<start>>` — estado inicial explícito (equivalente a [*])
- `<<end>>` — estado final explícito
- Combinables con fork, join, choice para máquinas de estado complejas

**Aplicabilidad a IACT:**
- ⚠️ BAJA — Probablemente redundante con [*] y lógica simple

### 2.10-2.12 Puntos, Pines y Expansiones (Sections 9.10-9.12)

**Sintaxis:**
```plantuml
state entry1 <<entryPoint>>    ← entrada explícita
state entry1 <<inputPin>>      ← pin de entrada
state entry1 <<expansionInput>> ← entrada de expansión
```

**Características:**
- `<<entryPoint>>` / `<<exitPoint>>` — puntos de entrada/salida nombrados
- `<<inputPin>>` / `<<outputPin>>` — pines para conexión (UML 2.x)
- `<<expansionInput>>` / `<<expansionOutput>>` — entradas/salidas de regiones expandidas

**Aplicabilidad a IACT:**
- ❌ NO APLICABLE — Características muy avanzadas de UML 2.x
- No hay casos de uso conocidos en documentación de requisitos funcionales

### 2.13 Dirección de Flechas (Section 9.13)

**Sintaxis:**
```plantuml
State1 -down-> State2
State1 -right-> State2  (default)
State1 -left-> State2
State1 -up-> State2
```

**Características:**
- Fuerza dirección explícita de transiciones
- `-d-`, `-r-`, `-l-`, `-u-` como abreviaturas
- Graphviz usualmente calcula automáticamente sin ajustes

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — Si state diagrams se usan, dirección explícita mejora legibilidad
- Pero confía en Graphviz automático primero

### 2.14 Color y Estilo de Línea (Section 9.14)

**Sintaxis:**
```plantuml
S1 -[#DD00AA]-> S2           ← color personalizado
S1 -left[#yellow]-> S3       ← color + dirección
S1 -up[#red,dashed]-> S4     ← color + estilo (dashed/dotted/bold)
```

**Características:**
- `#color` — color de línea
- `dashed`, `dotted`, `bold` — estilos de línea
- Combinables

**Aplicabilidad a IACT:**
- ⚠️ BAJA — Principalmente cosmético
- Recomendación: usar centralización via `<style>` blocks (sección 9.20)

### 2.15-2.17 Notas (Sections 9.15-9.17)

**Sintaxis:**
```plantuml
note left of State1 : short note
note right of State1
  multi-line note
end note
note on link
  transition note
end note
```

**Características:**
- Notas en estados, compuestos o transiciones
- Multi-línea soportada
- Flotantes o ancladas

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — Notas esenciales para documentación de requisitos
- Explicar lógica de transiciones: "Why does this transition happen?"

### 2.18-2.19 Color Entre-Línea y Personalización (Sections 9.18-9.19)

**Sintaxis:**
```plantuml
state CurrentSite #pink {
    state HardwareSetup #lightblue
}

skinparam backgroundColor LightYellow
skinparam state {
  StartColor MediumBlue
  EndColor Red
  BackgroundColor Peru
  BorderColor Gray
  FontName Impact
}
```

**Características:**
- Color inline: `#color` en definición de estado
- `skinparam state { ... }` para personalización global
- Colores específicos para estereotipos

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — Pero usar centralización via `<style>` blocks
- Prohibir colores inline; usar centralizados

### 2.20-2.21 Estilos y Color Inline (Sections 9.20-9.21)

**Sintaxis (moderna):**
```plantuml
<style>
stateDiagram {
  BackgroundColor Peru
  FontName Impact
  FontColor Red
  arrow {
    FontSize 13
    LineColor Blue
  }
}
</style>

state FooGradient #red-green ##[dashed]blue
state FooDashed #red|green ##[dashed]blue
state FooBold ##[bold]
```

**Características:**
- `<style>` block para personalización jerárquica (MODERNA)
- Inline: `#color ##[style]color` — background + line style
- Gradientes: `#color1-color2`
- Patrones: `#color1|color2` (stripe)

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — `<style>` block moderna es mejor que skinparam
- Alineado con Activity diagrams NEW SYNTAX v6
- Centralizable via !include

### 2.22 Alias (Section 9.22)

**Sintaxis:**
```plantuml
state "long name" as alias
alias : description
```

**Características:**
- Alias para estados con nombres largos
- Mejora legibilidad en referencias

**Aplicabilidad a IACT:**
- ✓ RECOMENDADO — Nombres claros sin verbosidad

### 2.23-2.25 JSON Display, Descripción y Estilos Anidados (Sections 9.23-9.25)

**Características:**
- Mostrar datos JSON dentro de state diagrams (sección 9.23)
- Descripciones multi-línea de estados (sección 9.24)
- Estilos para subestados (sección 9.25)

**Aplicabilidad a IACT:**
- JSON: ⚠️ BAJA — Probablemente innecesario en UC documentation
- Descripciones: ✓ RECOMENDADO
- Estilos anidados: ✓ MODERADO — Útil si se usan estados compuestos

---

## 3. Evaluación de Aplicabilidad a IACT-docs

### 3.1 Cuándo Usar State Diagrams en Documentación de Requisitos

**RECOMENDADO para:**
1. **Modelado de ciclo de vida de entidades principales:**
   - Usuarios: Estados de usuario (Inactivo, Activo, Suspendido, Bloqueado)
   - Accesos: Estados de solicitud (Pendiente, Aprobado, Denegado, Revocado)
   - Reportes: Estados de generación (Queued, Processing, Ready, Archived)
   - Alertas: Estados de alerta (Triggered, Acknowledged, Resolved)

2. **Transiciones basadas en eventos:**
   - Clarificar CUÁNDO y POR QUÉ ocurren transiciones
   - Documentar precondiciones (qué estado debe existir antes)
   - Documentar postcondiciones (qué estado resulta después)

3. **Control de flujo complicado:**
   - Estados con condiciones de entrada/salida
   - Decisiones basadas en estado (choice stereotypes)
   - Pero: Activity diagrams ya cubren esto mejor

### 3.2 Cuándo NO Usar State Diagrams

**NO RECOMENDADO para:**
1. **Procesos de negocio simples:**
   - Activity diagrams o Sequence diagrams ya lo hacen mejor
   - State diagrams mejor para comportamiento reactivo (event-driven)

2. **Flujos con múltiples actores:**
   - Sequence diagrams muestran interacciones mejor
   - Activity diagrams con swimlanes muestran responsabilidades mejor

3. **Arquitectura técnica:**
   - Component/Deployment diagrams para componentes
   - Class diagrams para estructura de código

### 3.3 Recomendación Final para IACT-docs

**Aplicabilidad: MODERADA-BAJA**

**Recomendación:**
- ✓ Usar state diagrams para documentar ciclo de vida de **entidades principales** (Usuario, Acceso, Reporte, Alerta)
- ✓ Documentar transiciones con **notas explicativas** (qué evento dispara, qué condiciones requiere)
- ⚠️ **Limitar a 3-5 state diagrams máximo** (no para cada entidad)
- ✓ Usar `<style>` blocks centralizado (consistent con Activity diagrams NEW SYNTAX)
- ❌ **Evitar:** Estados anidados complejos, historiales, bifurcaciones, estereotipos avanzados (entryPoint, inputPin, expansionInput)
- ❌ **Evitar:** Colores inline; usar centralización

---

## 4. Síntesis: State Diagrams en IACT-docs

### 4.1 Hallazgos Clave

1. **Propósito:** Modelado de máquinas de estado (comportamiento reactivo a eventos)
2. **Sintaxis:** Simple (estados, transiciones, eventos) a compleja (anidamiento, estereotipos)
3. **Claridad:** Notas son ESENCIALES para documentar transiciones
4. **Personalización:** `<style>` blocks RECOMENDADO (no inline colors)
5. **Estereotipos avanzados:** Raramente necesarios en UC documentation

### 4.2 Comparativa: State vs. Activity vs. Sequence Diagrams

| Aspecto | State Diagram | Activity Diagram | Sequence Diagram |
|---------|---|---|---|
| **Foco** | Estados y transiciones reactivas | Flujo de actividades (procesos) | Interacciones entre entidades |
| **Cuándo usar** | Ciclo de vida de objetos | Procesos/flujos con decisiones | Comunicación temporal |
| **Complejidad** | Media | Media-Alta | Alta |
| **Notas** | Essencial para transiciones | Recomendado para claridad | Esencial para interacciones |
| **Aplicabilidad IACT** | MODERADA-BAJA | IMPORTANTE | IMPORTANTE |

### 4.3 Estado de Recomendación

**Para Phase 1 Setup:**
- ✓ Incluir soporte para state diagrams en plantuml-styles.puml
- ✓ Definir `<style> stateDiagram { ... }` similar a Activity diagrams
- ⚠️ **Baja prioridad:** Implementar para "entidades principales" primero (Usuarios, Accesos)
- ❌ **No prioridad:** Estereotipos avanzados, historia, bifurcación

**Para Phase 7 Design:**
- Evaluar qué entidades realmente necesitan state diagrams
- Crear 3-5 ejemplos máximo (Usuario, Acceso, Reporte, Alerta si aplica)
- Documentar transiciones con notas explicativas

---

## 5. Recomendaciones de Configuración

### 5.1 Plantilla Centralizada (plantuml-styles.puml)

```plantuml
' === STATE DIAGRAM STYLING ===
' Usar <style> block en lugar de skinparam (modern syntax)

<style>
stateDiagram {
  BackgroundColor #F5F5F5
  FontColor #333333
  FontName Segoe UI
  FontSize 11
  BorderColor #BDBDBD
  
  ' Estados especiales
  StartColor #4CAF50      ← [*] (inicio)
  EndColor #F44336        ← [*] (fin)
  
  ' Transiciones
  arrow {
    FontSize 10
    LineColor #757575
    LineThickness 2
  }
}

' Alternativa: skinparam (legacy, pero compatible)
skinparam state {
  BackgroundColor #F5F5F5
  BorderColor #BDBDBD
  FontColor #333333
}
</style>
```

### 5.2 Plantilla de State Diagram (ejemplo)

```plantuml
!include _static/plantuml-styles.puml

state "Usuario" as User {
  state "Inactivo" as Inactive
  state "Activo" as Active
  state "Suspendido" as Suspended
  
  [*] --> Inactive
  Inactive --> Active : registro_completado
  Active --> Inactive : cierre_sesión
  Active --> Suspended : admin_acción
  Suspended --> Active : admin_reactivación
  Inactive --> [*]
  Active --> [*]
  Suspended --> [*]
  
  note right of Active : Usuario puede acceder a recursos
  note right of Suspended : Acceso bloqueado temporalmente
}
```

---

## 6. Conclusión

State diagrams en PlantUML 1.2025.0 ofrecen soporte robusto para modelado de máquinas de estado. Sin embargo, para IACT-docs, su aplicabilidad es **MODERADA-BAJA** comparado con Use Case, Activity, y Sequence diagrams.

**Recomendación:**
- ✓ Soporte técnico: Incluir en plantuml-styles.puml centralizado
- ✓ Uso limitado: Entidades principales únicamente (3-5 máximo)
- ⚠️ Baja prioridad: Implementar en Phase 7 DESIGN, no en Phase 1 Setup
- ❌ Evitar: Complejidades innecesarias (estereotipos avanzados, anidamiento profundo)

**Aplicabilidad Final: NOT RECOMMENDED (para Phase 1 Setup) — Postergar a Phase 7**

