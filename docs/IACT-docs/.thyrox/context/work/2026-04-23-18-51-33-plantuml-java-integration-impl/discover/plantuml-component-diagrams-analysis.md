```yml
created_at: 2026-04-24 02:10:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Borrador
version: 1.0.0
```

# Análisis: PlantUML Component Diagrams — Arquitectura de Componentes y Dependencias

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 145-164+ (Secciones 7.0-7.18)

**Propósito:** Validar si component diagrams son aplicables a IACT-docs para documentación de requisitos.

**Criticidad:** MEDIA — Especializado; más arquitectónico que funcional.

---

## 1. Qué son Component Diagrams

### 1.1 Definición y Propósito

**Component Diagram:** Diagrama estructural UML que visualiza:
- Organización de componentes del sistema
- Relaciones e interdependencias entre componentes
- Descomposición de sistemas complejos

**Diferencia con otros diagramas:**
- **Class Diagrams:** Clases y métodos (nivel detalle)
- **Component Diagrams:** Componentes y servicios (nivel macro)
- **Deployment Diagrams:** Distribución física de componentes

**Ejemplo conceptual:**
- Class Diagram: `public class UserService { void authenticate(...) }`
- Component Diagram: `[UserService Component] -- [Database Component]`

---

## 2. Sintaxis de Component Diagrams (Secciones 7.1-7.18)

### 2.1 Componentes (Section 7.1)

**Sintaxis:**
```plantuml
[Component Name]
component CompName
component CompName as Alias
[Multi\nline\nComponent] as MC
```

**Características:**
- `[Name]` — sintaxis corchetes para componentes
- `component Name` — palabra clave component
- `as Alias` — alias para referencias posteriores
- Multi-línea con `\n`

**Ejemplo:**
```plantuml
[First component]
[Another component] as Comp2
component Comp3
component [Last component] as Comp4
```

**Aplicabilidad a IACT:**
- ⚠️ BAJA — componentes son abstracciones técnicas, no funcionales

### 2.2 Interfaces (Section 7.2)

**Sintaxis:**
```plantuml
() "Interface Name"
() "Another" as Interf2
interface IName
interface "Multi\nline" as I4
```

**Características:**
- `()` — símbolo círculo para interfaces (luce como círculo)
- `interface Name` — palabra clave interface
- Multi-línea soportada
- Alias para referencias

**Aplicabilidad a IACT:**
- ⚠️ BAJA — interfaces son abstracciones técnicas

### 2.3 Relaciones Básicas (Section 7.3)

**Sintaxis de enlaces:**
```plantuml
[Component1] -- [Component2]      ← línea recta
[Component1] --> [Component2]     ← flecha derecha
[Component1] ..> Interface : use  ← punteada con etiqueta
```

**Características:**
- `--` — línea recta (asociación)
- `-->` — flecha (dependencia)
- `..>` — punteada (dependencia débil/uso)
- Etiquetas opcionales: `: label`

**Aplicabilidad a IACT:**
- ⚠️ BAJA — relaciones técnicas entre componentes

### 2.4 Notas (Section 7.4)

**Sintaxis:**
```plantuml
note left of [Component] : Inline note
note right of Interface
  Multi-line note
  with context
end note
```

**Características:**
- `note [left|right|top|bottom] of` — nota posicionada
- Inline con `: text`
- Multi-línea con `end note`

**Aplicabilidad a IACT:**
- ✅ MEDIA — documentar restricciones o contexto

### 2.5 Agrupación (Section 7.5)

**Sintaxis de contenedores:**
```plantuml
package "Group Name" {
  [Component1]
  [Component2]
}

node "Server Node" {
  [Component3]
}

cloud {
  [Cloud Component]
}

database "Database" {
  folder "Subfolder" {
    [Database Component]
  }
}

frame "Frame Group" {
  [Framed Component]
}
```

**Características:**
- `package` — agrupación simple
- `node` — nodo físico/lógico
- `folder` — estructura de carpetas
- `frame` — marco visual
- `cloud` — servicio en la nube
- `database` — almacenamiento de datos
- Anidamiento soportado

**Aplicabilidad a IACT:**
- ⚠️ MEDIA-BAJA — agrupar componentes lógicos (arquitectónico)

### 2.6 Dirección de Flechas (Section 7.6)

**Sintaxis:**
```plantuml
[Component] --> Interface      ← vertical (default)
[Component] -> Interface       ← horizontal
[Component] -left-> left
[Component] -right-> right
[Component] -up-> up
[Component] -down-> down
```

**Características:**
- `-->` — flecha vertical (default)
- `->` — flecha horizontal
- `-left->`, `-right->`, `-up->`, `-down->` — dirección explícita
- Abreviatura: `-l->`, `-r->`, `-u->`, `-d->`

**Aplicabilidad a IACT:**
- ✅ MEDIA — control de layout visual

### 2.7 Notaciones UML (Sections 7.7-7.9)

**Variantes de estilo:**

**UML2 (default):**
```plantuml
skinparam componentStyle uml2
[Component] ..> Interface : use
```
Icono de componente estándar

**UML1:**
```plantuml
skinparam componentStyle uml1
[Component] ..> Interface : use
```
Estilo antiguo UML1

**Rectangle (sin UML notation):**
```plantuml
skinparam componentStyle rectangle
[Component] ..> Interface : use
```
Rectángulo simple

**Aplicabilidad a IACT:**
- ⚠️ BAJA — opción de renderizado; UML2 (default) es recomendado

### 2.8 Long Description (Section 7.10)

**Sintaxis:**
```plantuml
component comp1 [
This component
has a long comment
on several lines
with details
]
```

**Características:**
- Multi-línea entre `[ ]`
- Descripción de componente sin sintaxis especial

**Aplicabilidad a IACT:**
- ✅ MEDIA — documentar propósito de componentes

### 2.9 Colores Individuales (Section 7.11)

**Sintaxis:**
```plantuml
component [Web Server] #Yellow
[Database] #Aqua
```

**Características:**
- `#ColorName` después de definición
- Colores por nombre o código
- Individual, no centralizado

**RESTRICCIÓN CRÍTICA:**
❌ **NO usar colores inline en IACT diagrams**
- Usar `skinparam component { BackgroundColor ... }` en su lugar

### 2.10 Sprites en Stereotypes (Section 7.12)

**Sintaxis:**
```plantuml
sprite $businessProcess [16x16/16] {
  FFFFFFFFFFFFFFFF
  FF00000000000FFF
  FF000000000000FF
  ...
}

rectangle "Process" <<$businessProcess>> {
  rectangle "inner1" <<$businessProcess>>
  rectangle "inner2" <<$businessProcess>>
}
```

**Características:**
- `sprite` — define icono custom
- `<<$spriteName>>` — aplica sprite como estereotipo
- Formato hexadecimal/ASCII art

**Aplicabilidad a IACT:**
- ❌ BAJA — casos muy especializados; evitar

### 2.11 Personalización con Skinparam (Section 7.13-7.14)

**Sintaxis:**
```plantuml
skinparam interface {
  backgroundColor RosyBrown
  borderColor orange
  fontColor blue
}

skinparam component {
  FontSize 13
  BackgroundColor<<Apache>> Pink
  BorderColor<<Apache>> #FF6655
  FontName Courier
  BorderColor black
  BackgroundColor gold
  ArrowFontName Impact
  ArrowColor #FF6655
}

skinparam componentStyle uml2

skinparam node {
  borderColor Green
  backgroundColor Yellow
  backgroundColor<<shared_node>> Magenta
}

skinparam databaseBackgroundColor Aqua
```

**Parámetros:**
- `interface { BackgroundColor, BorderColor, FontColor, FontSize }`
- `component { BackgroundColor, BorderColor, FontName, FontSize, ArrowColor }`
- `componentStyle { uml2 | uml1 | rectangle }`
- `node { BackgroundColor, BorderColor }`
- `database { BackgroundColor }`

**Con Stereotypes:**
- `BackgroundColor<<stereotype>>` — color específico por estereotipo
- `BorderColor<<stereotype>>` — borde específico

**Aplicabilidad a IACT:**
- ✅ CRÍTICA — centralizar colores vía skinparam
- ⚠️ RESTRICCIÓN: NO inline colors, usar skinparam

### 2.12 Hide/Remove Unlinked Components (Section 7.15)

**Sintaxis:**
```plantuml
component C1
component C2
component C3
C1 -- C2

hide @unlinked          ← oculta C3 (desconectado)
remove @unlinked        ← elimina C3 del diagrama
```

**Características:**
- `@unlinked` — pseudo-selector para componentes sin conexiones
- `hide @unlinked` — oculta visualmente
- `remove @unlinked` — elimina del diagrama
- Limpia diagrama de componentes "huérfanos"

**Aplicabilidad a IACT:**
- ⚠️ MEDIA — limpiar diagramas de componentes no usados

### 2.13 Hide/Remove/Restore Tagged Components (Section 7.16)

**Sintaxis:**
```plantuml
component C1 $tag13
component C2
component C3 $tag13
C1 -- C2

hide $tag13             ← oculta C1, C3
remove $tag13           ← elimina C1, C3
restore $tag1           ← restaura C1 (si tiene $tag1)
remove *
restore $tag13          ← remueve todo, restaura $tag13
```

**Características:**
- `$tagname` — etiqueta componentes
- `hide $tag` — ocultar por tag
- `remove $tag` — eliminar por tag
- `restore $tag` — restaurar específicos
- `remove *` — remover todo
- Filtrado fino de componentes

**Aplicabilidad a IACT:**
- ⚠️ BAJA — casos especializados; variantes complejas

### 2.14 JSON Display (Section 7.17)

**Sintaxis:**
```plantuml
allowmixing

component Component
() Interface

json JSON {
  "fruit":"Apple",
  "size":"Large",
  "color": ["Red", "Green"]
}
```

**Características:**
- `allowmixing` — permite mezclar JSON con componentes
- `json { ... }` — bloque JSON como antes
- Integración visual

**Aplicabilidad a IACT:**
- ❌ BAJA — JSON no aplicable a documentación de requisitos
- Ver análisis previo: JSON Display explícitamente prohibido

### 2.15 Ports (Section 7.18)

**Variantes de puertos:**

**Port (generic):**
```plantuml
component C {
  port p1
  port p2
  component c1
}
[external] --> p1
p1 --> c1
```

**PortIn (entrada):**
```plantuml
component C {
  portin p1
  portin p2
  component c1
}
[external] --> p1
p1 --> c1
```

**PortOut (salida):**
```plantuml
component C {
  portout p1
  portout p2
  component c1
}
c1 --> p1
p1 --> [external]
```

**Mixing PortIn & PortOut:**
```plantuml
component C {
  portin p_in1
  portin p_in2
  portout p_out1
  portout p_out2
  component c1
}
[input] --> p_in1
p_out1 --> [output]
```

**Características:**
- `port` — puerto genérico (bidireccional)
- `portin` — puerto de entrada (solo entrada)
- `portout` — puerto de salida (solo salida)
- Conexiones explícitas a puertos
- Documentar interfaces públicas

**Aplicabilidad a IACT:**
- ⚠️ MEDIA-BAJA — puertos útiles para componentes complejos con interfaces explícitas
- ⚠️ RESTRICCIÓN: Evitar si es posible (complejidad); usar para casos claros

---

## 3. Restricciones y Limitaciones

### 3.1 Restricciones Críticas

**Inline Colors — PROHIBIDO:**
```plantuml
[Component] #FF0000  ← PROHIBIDO
```

✅ **ALTERNATIVA:**
```plantuml
skinparam component {
  BackgroundColor #1976D2
  BorderColor #000000
}
```

### 3.2 Limitaciones de Aplicabilidad

| Aspecto | Score | Razón |
|---------|-------|-------|
| Necesidad en IACT | 2/5 | BAJA — documentación de requisitos no típicamente requiere componentes técnicos |
| Claridad | 4/5 | ALTA — diagrama es visualmente claro |
| Mantenibilidad | 3/5 | MEDIA — requiere actualización cuando arquitectura cambia |
| Valor para requisitos | 2/5 | BAJA — documentación funcional no necesita nivel técnico de componentes |
| UML Compliance | 5/5 | CRÍTICA — es diagrama UML estándar |

**Conclusión:** Component diagrams probablemente **NO necesarios** para IACT-docs (funcional).

---

## 4. Comparación: Aplicabilidad de Diagram Types en IACT-docs

| Tipo | Nivel | IACT Aplicación | Razón |
|------|-------|---|---|
| **Use Case** | Funcional | ✅ CRITICAL | Requisitos de negocio |
| **Sequence** | Interacción | ✅ IMPORTANT | Flujos multi-actor |
| **Activity** | Proceso | ✅ RECOMMENDED | Flujos de procesos |
| **Class** | Técnico (detalle) | ⚠️ OPTIONAL | Arquitectura de datos (rara) |
| **Component** | Técnico (macro) | ❌ NOT RECOMMENDED | Arquitectura de componentes (fuera de scope) |
| **Deployment** | Infraestructura | ❌ NOT APPLICABLE | Distribución física (DevOps, no requisitos) |

**Patrón observado:**
- Requisitos funcionales: UC, Sequence, Activity ✅
- Arquitectura técnica: Class, Component ⚠️
- Infraestructura: Deployment ❌

---

## 5. Síntesis: Component Diagrams para IACT-docs

### 5.1 Recomendación

**Component diagrams en IACT-docs:**
- ❌ **NO recomendado** — fuera de scope de requisitos funcionales
- ⚠️ **OPCIONAL** — solo si IACT documenta arquitectura técnica del sistema
- ❌ **EXPLÍCITAMENTE PROHIBIDO** — si se usa, NO colores inline

**Comparación con Class Diagrams:**
- Class Diagrams: Detalle de implementación (entidades, atributos, métodos)
- Component Diagrams: Macro arquitectónico (componentes, servicios, interfaces)
- IACT Decision: **Ambos son opcionales, pero Class es más probable que Component**

### 5.2 Si se Incluyen

**Restricciones estrictas:**
- ✅ Usar `skinparam component { ... }` centralizado
- ❌ NO colores inline
- ❌ NO sprites complejos
- ⚠️ Mantener simple (evitar ports si posible)
- ⚠️ Documentar en guidelines qué son componentes en IACT

---

## 6. Validación: Cobertura de Secciones 7.0-7.18

| Sección | Contenido | Status | Aplicabilidad |
|---------|----------|--------|---|
| 7.0 | Introducción | ✅ | MEDIA |
| 7.1 | Componentes | ✅ | BAJA |
| 7.2 | Interfaces | ✅ | BAJA |
| 7.3 | Ejemplo básico | ✅ | BAJA |
| 7.4 | Notas | ✅ | MEDIA |
| 7.5 | Agrupación | ✅ | MEDIA |
| 7.6 | Dirección flechas | ✅ | MEDIA |
| 7.7 | UML2 notation | ✅ | BAJA |
| 7.8 | UML1 notation | ✅ | BAJA |
| 7.9 | Rectangle notation | ✅ | BAJA |
| 7.10 | Long description | ✅ | MEDIA |
| 7.11 | Colores individuales | ✅ | CRÍTICA (PROHIBIDO) |
| 7.12 | Sprites | ✅ | BAJA |
| 7.13-7.14 | Skinparam | ✅ | CRÍTICA |
| 7.15 | Hide/Remove unlinked | ✅ | BAJA |
| 7.16 | Tags | ✅ | BAJA |
| 7.17 | JSON Display | ✅ | NULA (prohibido) |
| 7.18 | Ports | ✅ | MEDIA |

**Hallazgo:** Secciones 7.0-7.18 completamente cubiertas. Component diagram feature set es extenso.

---

## 7. Conclusión y Recomendación Final

### 7.1 Para IACT-docs

**Decisión propuesta:**

1. **Phase 5 STRATEGY:** Component diagrams son **explícitamente FUERA DE SCOPE**
   - IACT documenta requisitos funcionales, no arquitectura técnica de componentes
   - Component diagrams son para documentación de arquitectura (desarrollo)
   - Similar a Class Diagrams: OPCIONAL, no RECOMENDADO para fase actual

2. **Phase 7 DESIGN:** Incluir en guidelines
   - "Component diagrams NOT USED in IACT-docs"
   - Razón: Fuera de scope (requisitos, no arquitectura técnica)
   - Si necesario documentar: usar deployment diagrams para infraestructura (raro)

3. **Phase 10 EXECUTE:** No incluir component diagrams
   - No agregar `skinparam component { ... }` a plantuml-styles.puml
   - Mantener focus en UC, Sequence, Activity diagramas

---

**Análisis Completado:** 2026-04-24 02:10:00  
**Hallazgo clave:** Component diagrams NOT applicable to IACT-docs; explicitly out of scope.  
**Confianza:** 0.95 (claridad de no-aplicabilidad muy alta)  
**Recomendación:** Omitir completamente; enfoque en UC (functional) + Sequence (interaction) + Activity (flow) + Class (conditional technical architecture)
