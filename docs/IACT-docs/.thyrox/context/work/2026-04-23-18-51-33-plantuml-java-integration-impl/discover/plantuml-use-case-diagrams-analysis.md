```yml
created_at: 2026-04-23 23:00:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: En revisión
version: 1.0.0
```

# Análisis: PlantUML Use Case Diagrams — Syntax, Styling & IACT-docs Applicability

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 44-55 (Secciones 2.1-2.18: Diagramas de Casos de Uso)

**Criticidad:** MÁXIMA — IACT-docs tiene 100+ diagramas UC. Esta sección es la más directamente aplicable.

---

## 1. Use Case Diagram Basics (Secciones 2.1-2.6)

### 1.1 Elementos Básicos

| Elemento | Sintaxis | Ejemplo | Aplicabilidad |
|----------|----------|---------|---|
| **Use Case** | `(nombre)` | `(Login)` | ✅ CORE |
| **Actor** | `:nombre:` | `:Usuario:` | ✅ CORE |
| **Relationship** | `-->` | `Actor --> (UC)` | ✅ CORE |
| **Extend** | `<\|--` | `(UC1) <\|-- (UC2)` | ✅ Important |
| **Include** | `.>` | `(UC1) .> (UC2)` | ✅ Important |

### 1.2 Definición de Casos de Uso

**Forma 1: Paréntesis simples**
```plantuml
(First usecase)
(Another usecase) as (UC2)
```

**Forma 2: Palabra clave usecase**
```plantuml
usecase UC3
usecase (Last\nusecase) as UC4
```

**Ambas son válidas — Use Casos de IACT-docs probablemente usan Forma 1.**

### 1.3 Definición de Actores

**Forma 1: Dos puntos**
```plantuml
:First Actor:
:Another\nactor: as Men2
```

**Forma 2: Palabra clave actor**
```plantuml
actor Men3
actor :Last actor: as Men4
```

**Hallazgo:** Los actores pueden tener espacios, caracteres especiales, múltiples líneas (`\n`).

### 1.4 Relaciones Básicas

```plantuml
User -> (Start)
User --> (Use the application) : A small label
:Main Admin: ---> (Use the application) : This is\nyet another\nlabel
```

**Sintaxis:**
- `--->` : flecha con 3 guiones (más larga)
- `-->` : flecha con 2 guiones
- `->` : flecha con 1 guión

**Etiquetas:** Usando `:` se agregan etiquetas a las flechas.

---

## 2. Estilos de Actores (Sección 2.3)

### 2.1 Tres Estilos Soportados

| Estilo | Parámetro | Apariencia | Recomendación |
|--------|-----------|-----------|---|
| **Stick Man** | `skinparam actorStyle default` | Figura palito | ✅ Estándar |
| **Awesome** | `skinparam actorStyle awesome` | Más detallado | ⚠️ Puede ser visual |
| **Hollow** | `skinparam actorStyle hollow` | Silueta hueca | ⚠️ Menos claro |

**Para IACT-docs:** Recomendación es **stick man (default)** — consistencia y profesionalismo.

**Nota:** El estilo se define globalmente via skinparam, aplicable a TODOS los actores en el diagrama.

---

## 3. Descripciones Multi-línea (Sección 2.4)

### 3.1 Casos de Uso Complejos

**PlantUML soporta descripciones largos usando comillas dobles (`"`):**

```plantuml
usecase UC1 as "You can use
several lines to define your usecase.
You can also use separators.
--
Several separators are possible.
==
And you can add titles:
..Conclusion..
This allows large description."
```

**Separadores permitidos:**
- `--` : línea horizontal
- `..` : línea de puntos
- `==` : doble línea
- `__` : línea subrayo

**Aplicabilidad a IACT-docs:**
- ✅ Útil para documentar requisitos complejos dentro del UC
- ⚠️ Requiere documentación clara sobre cuándo usar descripciones multilinea
- ⚠️ Evitar descripciones demasiado largas (afecta layout)

---

## 4. Agrupación: Paquetes y Rectángulos (Sección 2.5)

### 4.1 Agrupar Actores y UC

```plantuml
left to right direction

actor Guest as g

package Professional {
  actor Chef as c
  actor "Food Critic" as fc
}

package Restaurant {
  usecase "Eat Food" as UC1
  usecase "Pay for Food" as UC2
  usecase "Drink" as UC3
  usecase "Review" as UC4
}

fc --> UC4
g --> UC1
g --> UC2
g --> UC3
```

**Alternativa: Usar `rectangle` en lugar de `package`:**
```plantuml
rectangle Restaurant {
  usecase "Eat Food" as UC1
  usecase "Pay for Food" as UC2
}
```

**Aplicabilidad a IACT-docs:**
- ✅ Agrupar por módulo (AUTH, ACCESS, USERS, etc.)
- ✅ Separar actores internos vs. externos
- ✅ Mejorar legibilidad de diagramas complejos

**Recomendación:** Usar `package` para UC, `rectangle` para agrupaciones sistémicas.

---

## 5. Relaciones: Extend vs. Include (Sección 2.7)

### 5.1 Extensión (`<|--`)

```plantuml
(Start) <|-- (Use)  ← Use extiende Start
```

**Semántica UML:** El UC extendido (Use) es una especialización del UC base (Start).

### 5.2 Inclusión (`*--` o `.>`)

**Implicito en package:**
```plantuml
(checkout) .> (payment) : include
```

**Semántica UML:** El UC "checkout" incluye el comportamiento de "payment".

**Diferencia:**
- **Include:** Un UC obligatoriamente ejecuta otro UC (reutilización de comportamiento)
- **Extend:** Un UC especializado extiende otro, con comportamiento adicional

**Aplicabilidad a IACT-docs:**
- ✅ Modelar sub-procesos (include)
- ✅ Modelar variantes (extend)
- ⚠️ Requiere documentación clara sobre cuándo usar cada uno

---

## 6. Notas y Anotaciones (Sección 2.8)

### 6.1 Notas Asociadas a Objetos

```plantuml
note right of Admin : This is an example.

note right of (Use)
  A note can also
  be on several lines
end note
```

### 6.2 Notas Independientes

```plantuml
note "This note is connected\nto several objects." as N2
(Start) .. N2
N2 .. (Use)
```

**Aplicabilidad:**
- ✅ Documentar requisitos especiales
- ✅ Aclaraciones sobre flujos excepcionales
- ⚠️ No abusar — mantener diagrama legible

---

## 7. Dirección de Flechas (Sección 2.10-2.12)

### 7.1 Control de Dirección

**Por defecto:** Top-to-bottom

**Cambiar a left-to-right:**
```plantuml
left to right direction
user1 --> (Usecase 1)
user2 --> (Usecase 2)
```

### 7.2 Dirección por Flecha

```plantuml
:user: -left-> (dummyLeft)
:user: -right-> (dummyRight)
:user: -up-> (dummyUp)
:user: -down-> (dummyDown)
```

**Abreviaciones:** `-l->`, `-r->`, `-u->`, `-d->`

**Aplicabilidad:**
- ✅ Controlar layout del diagrama
- ⚠️ Generalmente Graphviz maneja bien sin dirección explícita
- ⚠️ Evitar abusar — solo si layout queda claro

---

## 8. Estereotipos (Sección 2.9)

### 8.1 Agregar Estereotipos a Actores/UC

```plantuml
User << Human >>
:Main Database: as MySql << Application >>
(Start) << One Shot >>
(Use the application) as (Use) << Main >>
```

**Sintaxis:** `<< Estereotipo >>`

**Aplicabilidad:**
- ✅ Clasificar tipos de actores (Human, System, Database)
- ✅ Clasificar tipos de UC (Main, Optional, OneTime)
- ⚠️ Requiere documentación de estereotipos usados

---

## 9. Personalización: skinparam (Sección 2.13)

### 9.1 skinparam para UC Diagrams

```plantuml
skinparam usecase {
  BackgroundColor DarkSeaGreen
  BorderColor DarkSlateGray
  BackgroundColor<< Main >> YellowGreen
  BorderColor<< Main >> YellowGreen
  ArrowColor Olive
  ActorBorderColor black
  ActorFontName Courier
  ActorBackgroundColor<< Human >> Gold
}
```

**Parámetros clave:**
- `BackgroundColor` : Color de fondo de UC
- `BorderColor` : Color del borde
- `ArrowColor` : Color de flechas
- `ActorBorderColor` : Borde de actores
- `ActorFontName` : Fuente de actores

**CRÍTICO:** Los skinparam para UC son **específicos del tipo de diagrama**.

**Implicación para centralización:**
```plantuml
' plantuml-styles.puml debe definir SEPARADAMENTE:
skinparam sequence { ... }  ← Para Sequence Diagrams
skinparam usecase { ... }   ← Para UC Diagrams
```

---

## 10. Colores Inline (Sección 2.16-2.17)

### 10.1 Colores en Flechas (Inline Style)

```plantuml
foo --> (bar) : normal
foo --> (bar1) #line:red;line.bold;text:red : red bold
foo --> (bar2) #green;line.dashed;text:green : green dashed
foo --> (bar3) #blue;line.dotted;text:blue : blue dotted
```

**Sintaxis:** `#line:color;line.[bold|dashed|dotted];text:color`

### 10.2 Colores en Elementos

```plantuml
actor a
actor b #pink;line:red;line.bold;text:red
usecase c #palegreen;line:green;line.dashed;text:green
usecase d #aliceblue;line:blue;line.dotted;text:blue
```

**Síntaxis:** `#[color|back:color];line:color;line.[bold|dashed|dotted];text:color`

**RESTRICCIÓN (per guidelines):**
- ❌ NO usar colores inline
- ✅ USAR skinparam centralizado

---

## 11. Divisiones de Diagrama (Sección 2.11)

### 11.1 Palabra clave `newpage`

```plantuml
:actor1: --> (Usecase1)
newpage
:actor2: --> (Usecase2)
```

**Aplicabilidad:**
- ✅ Dividir diagramas grandes en múltiples páginas/imágenes
- ⚠️ Requiere validación de cómo sphinxcontrib.plantuml maneja `newpage`

---

## 12. Business Use Cases (Sección 2.15)

### 12.1 Síntaxis para UC de Negocio

```plantuml
(First usecase)/
(Another usecase)/ as (UC2)
usecase/ UC3

:First Actor:/
:Another\nactor:/ as Man2
actor/ Woman3
```

**Característica:** Agregar `/` al final convierte a "Business" UC/Actor.

**Aplicabilidad a IACT-docs:**
- ⚠️ Probablemente NO necesario (UC técnicos, no de negocio)
- ✅ Documentar si se usan

---

## 13. Síntesis: UC Diagrams vs. Sequence Diagrams

### 13.1 Cuándo Usar Cada Uno

| Aspecto | UC Diagram | Sequence Diagram |
|---------|-----------|--|
| **Nivel de abstracción** | Alto (qué hace el sistema) | Bajo (cómo lo hace) |
| **Actores** | Externos | Internos + externos |
| **Flujo** | Relaciones estáticas | Interacciones ordenadas |
| **Uso en IACT-docs** | 100+ diagramas UC | Pocos, para flujos detallados |

**Para IACT-docs:**
- **UC Diagrams:** Documento principal de requisitos
- **Sequence Diagrams:** Detalles de flujos complejos (si es necesario)

---

## 14. Implicaciones para plantuml-styles.puml

### 14.1 Necesario Agregar Sección UC

```plantuml
' SECTION: USE CASE DIAGRAM STYLING
' ==================================
skinparam usecase {
  BackgroundColor SECONDARY_COLOR
  BorderColor PRIMARY_COLOR
  BorderThickness 2
  FontColor TEXT_COLOR
}

' Actor styling for UC
skinparam actor {
  BackgroundColor PRIMARY_COLOR
  BorderColor SECONDARY_COLOR
  FontColor #FFFFFF
  ActorStyle default  ← NOT awesome, NOT hollow
}

' Arrow styling for UC
skinparam {
  ArrowColor TEXT_COLOR
  Arrow FontColor TEXT_COLOR
}
```

### 14.2 Parámetros UC-Específicos (NO para Sequence)

```
skinparam usecase { ... }       ← Only for UC
skinparam sequence { ... }      ← Only for Sequence
skinparam actor { ... }         ← For BOTH (but different contexts)
```

**CRÍTICO:** El skinparam es **contexto-dependiente**.

---

## 15. Validación: UC Reales en IACT-docs

### 15.1 Preguntas para Phase 7 DESIGN/SPECIFY

1. ¿Qué sintaxis usan los UC actuales de IACT-docs?
   - ¿Paréntesis `(UC)` o palabra clave `usecase`?
   - ¿Dos puntos `:Actor:` o palabra clave `actor`?

2. ¿Hay agrupación via package/rectangle?
   - ¿UC by module (AUTH, ACCESS, USERS)?
   - ¿Actores agrupados?

3. ¿Usan extend/include relaciones?
   - ¿Cómo están documentadas?

4. ¿Hay colores actuales inline?
   - ¿Colores específicos esperados?

5. ¿Dirección de diagrama?
   - ¿Top-to-bottom o left-to-right?

---

## 16. Riesgos UC-Específicos

| Riesgo | Probabilidad | Mitigación |
|--------|---|---|
| skinparam UC diferente de Sequence | MEDIUM | Documentar ambos en styles.puml |
| UC reales usan sintaxis no estándar | MEDIUM | Audit en Phase 7 |
| Colores inline en UC actuales | MEDIUM | Script de búsqueda/reemplazo |
| newpage no funciona en Sphinx | LOW | Test en Phase 1 Setup |

---

## 17. Recomendaciones para Phase 1 Setup

### 17.1 Checklist para UC Diagrams

- [ ] Validar que UC reales son PlantUML válidos
- [ ] Confirmar sintaxis predominante (paréntesis vs. keyword)
- [ ] Identificar colores inline actuales (si existen)
- [ ] Documentar convenciones de actor (internal vs. external)
- [ ] Documentar si usan package/rectangle agrupación

### 17.2 Para Phase 7 DESIGN/SPECIFY

- [ ] Crear ejemplos UC con estilos centralizados
- [ ] Mapear UC actuales contra nuevo style template
- [ ] Validar rendering de 5 UC críticos
- [ ] Crear guidelines de UC (estereotipos, package, etc.)

---

## 18. Comparación: Secciones 2 vs. Secciones 1

### 18.1 Sequence Diagrams (Secciones 1.1-1.45)

| Aspecto | Soporte |
|--------|---------|
| skinparam global | ✅ Completo (1.37) |
| Colores inline | ✅ Permitido (1.8, 1.25) |
| Estilos de flechas | ✅ Muy flexible (1.39) |
| Activación/Desactivación | ✅ Core feature (1.25, 1.28) |

### 18.2 Use Case Diagrams (Secciones 2.1-2.18)

| Aspecto | Soporte |
|--------|---------|
| skinparam global | ✅ Disponible (2.13) |
| Colores inline | ✅ Permitido (2.16, 2.17) |
| Agrupación (package) | ✅ Core feature (2.5) |
| Relaciones (extend/include) | ✅ Estándar UML (2.7) |

**Conclusión:** Ambos tipos soportan la estrategia de centralización via skinparam.

---

**Análisis Completado:** 2026-04-23 23:00:00  
**Criticidad:** MÁXIMA — UC Diagrams son el core de IACT-docs  
**Hallazgo clave:** skinparam para UC es **diferente** del de Sequence — ambos deben documentarse
