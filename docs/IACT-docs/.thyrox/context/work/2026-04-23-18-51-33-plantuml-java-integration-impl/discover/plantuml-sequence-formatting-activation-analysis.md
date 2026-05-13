```yml
created_at: 2026-04-23 22:00:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: En revisión
version: 1.0.0
```

# Análisis: PlantUML Sequence Diagram — Formatting, Activation & Advanced Features

**Input:** Guía de Referencia del Lenguaje PlantUML 1.2025.0 — páginas 16-22 (Secciones 1.19-1.31)

**Objetivo:** Evaluar características avanzadas de diagramas de secuencia y su aplicabilidad a estrategia de centralización de estilos en IACT-docs.

---

## 1. Características de Formato: Creole & HTML (Sección 1.19)

### 1.1 Sintaxis Creole Soportada

PlantUML soporta sintaxis WikiCreole para textos en diagramas:

| Sintaxis | Resultado | Aplicable a Estilos Centralizados |
|----------|-----------|-----------|
| `**texto**` | **Bold** | ✅ Sí (para énfasis) |
| `//texto//` | *Italics* | ✅ Sí (para énfasis) |
| `""texto""` | Monospaced | ✅ Sí (para código/variables) |
| `--texto--` | ~~Stroked~~ | ⚠️ Limitado (cambios semánticos) |
| `__texto__` | <u>Underlined</u> | ✅ Sí (para énfasis) |
| `~~texto~~` | ~Waved~ | ⚠️ Limitado (decoración) |

### 1.2 Sintaxis HTML Soportada

PlantUML soporta tags HTML directos en textos:

```
<back:cadetblue><size:18>displayed</size></back>
<u:red>This</u> is <color #118888>displayed</color>
<color purple>left of</color>
<w:#FF33FF>This is hosted</w>
```

**Características HTML:**
- `<back:color>` → Fondo personalizado
- `<size:n>` → Tamaño de fuente
- `<color #HEX>` → Color de texto
- `<u:color>` → Subrayado coloreado
- `<w:color>` → Wavy line con color

### 1.3 Implicaciones para Estilización Centralizada

**Hallazgo crítico:** Creole & HTML permiten **colores inline** en textos.

**Problema:** Si permitimos HTML inline (`<color #red>`), se fragmenta la estrategia centralizada.

**Solución propuesta:**
1. Documentar en `plantuml-styles.puml`: "NO usar colores HTML inline"
2. Usar `skinparam` para colores globales de texto
3. Reemplazar `<color #red>` con `<color rgb(...)>` si es necesario, documentado en guidelines

---

## 2. Estructura y Divisiones de Diagramas

### 2.1 Divisor (== separador ==)

Separa diagramas en **secciones lógicas** sin afectar semántica:

```plantuml
== Initialization ==
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

== Repetition ==
Alice -> Bob: Another request
```

**Aplicabilidad:**
- ✅ Útil para UC largos (dividir en fases)
- ✅ No requiere estilización centralizada
- ✅ Mejora legibilidad de UC complejos

### 2.2 Referencia (ref over)

Marca secciones referenciales o comentarios:

```plantuml
ref over Alice, Bob : init
Alice -> Bob : hello
ref over Bob
  This can be on
  several lines
end ref
```

**Aplicabilidad:**
- ✅ Útil para notas sobre sub-procesos
- ✅ Compatible con estilos centralizados
- ✅ Permite documentación inline

---

## 3. Control de Tiempo y Retardos (Secciones 1.22, 1.31)

### 3.1 Retardo Simple (...) 

```plantuml
Alice -> Bob: Authentication Request
...
Bob --> Alice: Authentication Response
...5 minutes latter...
Bob --> Alice: Bye !
```

**Aplicabilidad:**
- ✅ Útil para UC con delays/timeouts
- ⚠️ Requiere documentación de qué significa "..." en el contexto IACT

### 3.2 Anclas y Duración con teoz

```plantuml
!pragma teoz true
{start} Alice -> Bob : start
{end} Bob -> Alice : finish
{start} <-> {end} : some time
```

**Aplicabilidad:**
- ⚠️ Requiere pragma: `!pragma teoz true`
- ⚠️ Requiere línea de comando: `java -jar plantuml.jar -Pteoz=true`
- ❌ Probablemente NO necesario para IACT-docs UC

---

## 4. Gestión de Líneas de Vida: Activación y Desactivación

### 4.1 Activación Explícita (activate/deactivate/destroy)

```plantuml
User -> A: DoWork
activate A
A -> B: << createRequest >>
activate B
B -> C: DoWork
activate C
C --> B: WorkDone
destroy C
B --> A: RequestCreated
deactivate B
A -> User: Done
deactivate A
```

**Conceptos:**
- `activate` → Marca el inicio de una línea de vida activa
- `deactivate` → Marca el fin de actividad
- `destroy` → Termina la línea de vida del participante

**Aplicabilidad a IACT-docs:**
- ✅ Modelar inicio/fin de procesos
- ✅ Mostrar estado activo de servicios
- ✅ Representar ciclo de vida de objetos

### 4.2 Color de Líneas de Vida (activate #COLOR)

```plantuml
activate A #FFBBBB
activate A #DarkSalmon
```

**Aplicabilidad:**
- ⚠️ Colores inline nuevamente fragmentan centralización
- **Recomendación:** Usar paleta corporativa via skinparam, NO inline

### 4.3 Sintaxis Abreviada (++, --, **, !!)

```plantuml
alice -> bob ++ : hello          [activar Bob]
bob -> bib ++ #005500 : hello    [activar Bib con color]
bob -> george ** : create         [crear George]
bob -> george !! : delete         [destruir George]
return done
```

**Ventajas:**
- ✅ Más compacta que `activate`/`deactivate`
- ✅ Combine en línea: `bob -> charlie --++`

---

## 5. Ajuste de Texto y Espaciado (Secciones 1.23-1.24)

### 5.1 Ajuste de Texto (skinparam maxMessageSize)

```plantuml
skinparam maxMessageSize 50
a -> b : this is a very long message on several words
```

**Aplicabilidad:**
- ✅ Control de layout automático
- ✅ Evita desbordamientos de texto
- **Recomendación:** Definir en `plantuml-styles.puml`

### 5.2 Espaciado Manual (|||)

```plantuml
Alice -> Bob: message 1
Bob --> Alice: ok
|||
Alice -> Bob: message 2
||45||
Alice -> Bob: message 3
```

**Aplicabilidad:**
- ✅ Control de vertical spacing
- ⚠️ Usado solo cuando diseño es crítico
- **Recomendación:** Documentar en guidelines para UC complejos

---

## 6. Creación de Participantes Dinámicos (Sección 1.27)

### 6.1 Palabra Reservada `create`

```plantuml
Alice -> Other : new
create Other
Alice -> Other : new

create control String
Alice -> String
note right : You can also put notes!
```

**Aplicabilidad:**
- ✅ Modelar creación de objetos/servicios
- ✅ Marcar claramente cuándo un participante entra en acción
- ✅ Compatible con estilos centralizados

---

## 7. Mensajes Entrantes y Salientes (Secciones 1.29-1.30)

### 7.1 Sintaxis [-> y ->]

```plantuml
[-> A: DoWork          [mensaje desde fuera del diagrama]
A ->] : << createRequest >>  [mensaje hacia fuera]
[<- A: Done            [respuesta desde fuera]
```

### 7.2 Variaciones Cortas

```plantuml
?-> Alice    : short to actor1
[-> Alice    : from start to actor1
Alice ->]    : to end
Alice ->?    : short from actor1
```

**Aplicabilidad:**
- ✅ Modelar interfaces externas
- ✅ Mostrar fronteras del sistema
- ✅ Representa mensajes del exterior o hacia exterior

---

## 8. Retorno de Mensajes (Sección 1.26)

### 8.1 Comando `return`

```plantuml
Bob -> Alice : hello
activate Alice
Alice -> Alice : some action
return bye
```

**Diferencia:**
- `return label` vs. `Alice --> Bob : bye`
- `return` es semánticamente explícito sobre retorno desde activación

**Aplicabilidad:**
- ✅ Claridad en flujos de retorno
- ✅ Marca punto de salida desde subproceso
- ✅ Compatible con estilos centralizados

---

## 9. Síntesis: Características por Categoría de Aplicabilidad

### 9.1 ✅ APLICABLES DIRECTAS (Sin impacto en centralización)

| Característica | Sección | Uso en IACT |
|---|---|---|
| Divisores (==) | 1.20 | Estructurar UC largos |
| Referencias (ref over) | 1.21 | Marcar sub-procesos |
| Retardos (...) | 1.22 | Indicar delays |
| Espaciado (\|\|\|) | 1.24 | Layout vertical |
| Activación/Desactivación | 1.25 | Estado de procesos |
| Creación de participantes | 1.27 | Objetos dinámicos |
| Mensajes entrantes/salientes | 1.29-1.30 | Interfaces externas |
| Retorno de mensajes | 1.26 | Flujos de retorno |

### 9.2 ⚠️ REQUIERE DOCUMENTACIÓN (Impacto en estilos)

| Característica | Sección | Restricción |
|---|---|---|
| Creole formatting (**bold**, //italics//) | 1.19 | Permitido; documentar uso |
| HTML formatting (<color>, <size>) | 1.19 | RESTRINGIR: NO colores inline |
| Colores de líneas de vida (#COLOR) | 1.25 | RESTRINGIR: usar skinparam |
| Ajuste maxMessageSize | 1.23 | Definir centralmente en .puml |
| Sintaxis abreviada (++, --, **) | 1.28 | Permitido; documentar estándar |

### 9.3 ❌ NO APLICABLES (Fuera de scope IACT)

| Característica | Sección | Razón |
|---|---|---|
| Anclas & teoz pragma | 1.31 | Timing diagrams, no UC |
| Wavy lines HTML | 1.19 | Decoración, no semántica |

---

## 10. Implicaciones para plantuml-styles.puml

### 10.1 Nuevos Parámetros a Definir

```plantuml
' Section 1.23 - Text wrapping
skinparam maxMessageSize 50

' Section 1.24 - Vertical spacing (no skinparam, documented in guidelines)

' Sections 1.19, 1.25 - Color management
' NOTE: Document that colors should use skinparam, NOT inline HTML
' Ensure corporate palette is applied via skinparam, not inline <color #RGB>

' Section 1.28 - Abbreviated syntax
' Document standard: use ++ for activate, -- for deactivate
```

### 10.2 Directiva !pragma (si necesario)

```plantuml
' Only if teoz/timing is needed (unlikely for IACT)
' !pragma teoz false  (or true if timing UC required)
```

---

## 11. Recomendaciones para Phase 1 DISCOVER → Phase 7 DESIGN

### 11.1 Cosas a Documentar en Guidelines

1. **Formatting permitido:**
   - ✅ `**bold**`, `//italics//`, `""monospaced""`, `__underlined__`
   - ❌ No usar `<color #...>` inline — usar skinparam

2. **Sintaxis abreviada (estándar):**
   - Usar `++ / --` en lugar de `activate / deactivate`
   - Usar `**` para `create`
   - Usar `!!` para `destroy`

3. **Espaciado & layout:**
   - `|||` permitido para UC complejos
   - `maxMessageSize` definido en estilos (no inline)

4. **Estructura:**
   - Usar `== Sección ==` para dividir UC largos
   - Usar `ref over` para comentarios de sub-procesos
   - Usar `[->` / `->]` para interfaces externas

---

## 12. Pendiente de Análisis Posterior

**Para Phase 7 DESIGN/SPECIFY:**
- [ ] Mapear UC reales IACT-docs contra patrones detectados
- [ ] Validar que UC existentes usan sintaxis compatible
- [ ] Definir template estándar para nuevos UC
- [ ] Crear ejemplos con estilos centralizados aplicados

---

**Análisis Completado:** 2026-04-23 22:00:00  
**Estado:** En revisión  
**Próximo paso:** Usuario indica si crear análisis adicional sobre secciones de guía, o avanzar a siguiente Phase
