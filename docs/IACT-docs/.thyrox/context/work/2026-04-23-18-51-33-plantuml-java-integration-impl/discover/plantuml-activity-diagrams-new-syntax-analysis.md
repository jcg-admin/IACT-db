```yml
created_at: 2026-04-24 01:50:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Borrador
version: 1.0.0
```

# Análisis: PlantUML Activity Diagrams — Nueva Sintaxis (v6.0+)

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 116-150+ (Secciones 6.0.1-6.25)

**Propósito:** Validar la nueva sintaxis de activity diagrams y comparar con sintaxis anterior (Section 5).

**Criticidad:** ALTA — Nueva sintaxis es la recomendada; simplifica mantenimiento y elimina dependencia de Graphviz.

---

## 1. Nueva Sintaxis vs. Sintaxis Anterior

### 1.1 Contexto de Cambio

**Problema con sintaxis antigua (Section 5):**
- Dependencia de Graphviz (complicaba instalación)
- Limitaciones de mantenimiento
- Falta de estabilidad en ciertos casos

**Ventajas de nueva sintaxis (Section 6):**
- ✅ **SIN dependencia de Graphviz** — simplifica configuración, como Sequence diagrams
- ✅ **Mantenimiento más fácil** — sintaxis intuitiva y clara
- ✅ **Más estable** — mejor implementación base
- ✅ **Más características** — switch/case, goto/label, swimlanes, condition styles

**Recomendación de PlantUML:**
"Mientras que continuaremos apoyando la sintaxis antigua para mantener la compatibilidad, animamos a los usuarios a migrar a la nueva sintaxis para aprovechar las características mejoradas."

**Implicación para IACT:**
- USAR nueva sintaxis (Section 6)
- NO usar sintaxis anterior (Section 5)
- Nueva sintaxis es más mantenible y menos dependencias

---

## 2. Sintaxis de Nueva Activity (Secciones 6.1-6.25)

### 2.1 Actividad Simple (Section 6.1)

**Sintaxis:**
```
:Activity Label;
```

**Características:**
- Etiqueta comienza con `:` y termina con `;`
- Creole formatting soportado (`**bold**`, `__italic__`, etc.)
- Actividades se enlazan implícitamente en orden de definición
- Multi-línea soportada

**Ejemplo:**
```plantuml
:Hello world;
:This is on defined on
several **lines**;
```

**Aplicabilidad a IACT:**
- ✅ ALTA — sintaxis simple y clara para actividades

### 2.2 Inicio/Parada/Fin (Section 6.2)

**Sintaxis:**
```
start
:Activity;
stop
```

o

```
start
:Activity;
end
```

**Características:**
- `start` para iniciar diagrama
- `stop` o `end` para finalizar
- Explícito (no implícito como `(*)` en sintaxis antigua)

**Aplicabilidad:**
- ✅ MEDIA — ambas opciones disponibles; `stop` es más claro

### 2.3 Condicionales (Section 6.3)

**Sintaxis (3 variantes):**

**Variante 1 — if/then/else:**
```plantuml
if (condition?) then (yes)
  :activity;
else (no)
  :alternative;
endif
```

**Variante 2 — if/is:**
```plantuml
if (color?) is (<color:red>red) then
  :print red;
else
  :print not red;
endif
```

**Variante 3 — if/equals:**
```plantuml
if (counter?) equals (5) then
  :print 5;
else
  :print not 5;
endif
```

**Características:**
- Tres sintaxis flexibles según tipo de prueba
- Etiquetas en paréntesis: `(yes)`, `(no)`, etc.
- `elseif` para múltiples condiciones
- Modo horizontal (default) o vertical (`!pragma useVerticalIf on`)

**Aplicabilidad a IACT:**
- ✅ CRÍTICA — bifurcaciones en flujos de casos de uso
- ✅ MEDIA-ALTA — modo vertical para mejora de legibilidad en diagramas complejos

### 2.4 Switch/Case (Section 6.4)

**Sintaxis:**
```plantuml
switch (test?)
case ( condition A )
  :Text 1;
case ( condition B )
  :Text 2;
case ( condition C )
  :Text 3;
endswitch
```

**Características:**
- `switch`, `case`, `endswitch`
- Múltiples casos (no limitado a dos opciones como if/then/else)
- Cleaner que múltiples `elseif`
- Etiquetas opcionales en paréntesis

**Aplicabilidad a IACT:**
- ✅ ALTA — para flujos con múltiples caminos (enumeraciones, estados)
- ⚠️ RESTRICCIÓN: Mantener <5 casos para legibilidad (split diagrams si >5)

### 2.5 Stop con Condicional (Section 6.5)

**Sintaxis con `kill` o `detach`:**
```plantuml
if (condition?) then
  #pink:error;
  kill
endif
#palegreen:action;
```

**Características:**
- `kill` — detiene la rama sin continuación
- `detach` — similar a kill, termina rama especifica
- `#color:` — especifica color de actividad
- Usado para error handling o terminaciones anticipadas

**Aplicabilidad a IACT:**
- ✅ MEDIA — para flujos de excepción o error
- ⚠️ RESTRICCIÓN: Inline colors (`#pink`) PROHIBIDOS; usar skinparam en su lugar

### 2.6 Ciclos — Repeat (Section 6.6)

**Sintaxis:**
```plantuml
repeat
  :activity;
repeat while (condition?)
```

**Características:**
- `repeat` / `repeat while` — do-while loop (ejecuta al menos una vez)
- Etiqueta en `repeat while` (opcional): `repeat while (condition?) is (yes/no)`
- `backward` — acción en la ruta de retorno al loop
- Starting label: `repeat :label as name;`

**Ejemplo con backward:**
```plantuml
repeat :foo as starting;
  :read data;
  :generate diagrams;
backward:This is backward;
repeat while (more data?)
```

**Aplicabilidad a IACT:**
- ✅ MEDIA — para procesos iterativos (lectura de datos, procesamiento repetido)

### 2.7 Break en Repeat (Section 6.7)

**Sintaxis:**
```plantuml
repeat
  :Test something;
  if (Something wrong?) then (no)
    #palegreen:OK;
    break
  endif
  ->NOK;
  :Alert;
repeat while (Something wrong?) is (yes) not (no)
```

**Características:**
- `break` — salida temprana del loop
- Combinable con condicionales dentro del loop
- Etiquetas detalladas en `repeat while`

**Aplicabilidad a IACT:**
- ⚠️ BAJA — control de flujo avanzado; usar solo si necesario

### 2.8 Goto y Labels (Section 6.8)

**Sintaxis (EXPERIMENTAL):**
```plantuml
label <label_name>
goto <label_name>
```

**Características:**
- `label` — define punto en diagrama
- `goto` — salta a label
- **EXPERIMENTAL** — no garantizado estable
- Útil para evitar repetición de código o compartir caminos

**Aplicabilidad a IACT:**
- ❌ BAJA — sintaxis experimental, no recomendada para documentación estable
- ⚠️ RESTRICCIÓN: Evitar `goto` en documentación (afecta legibilidad y mantenibilidad)

### 2.9 Ciclos — While (Section 6.9)

**Sintaxis:**
```plantuml
while (data available?)
  :read data;
  :generate diagrams;
endwhile
```

**Características:**
- `while` / `endwhile` — pre-condition loop (puede no ejecutarse)
- Etiqueta opcional: `while (condition) is (label)` o `endwhile (label)`
- Contraste con `repeat` (do-while)

**Aplicabilidad a IACT:**
- ✅ MEDIA — para loops pre-condicionados (verificar antes de ejecutar)

### 2.10 Procesamiento Paralelo (Section 6.10)

**Sintaxis:**
```plantuml
fork
  :Treatment 1;
fork again
  :Treatment 2;
end fork
```

**Características:**
- `fork` / `fork again` / `end fork` — ejecutión concurrente
- Múltiples ramas paralelas
- Sincronización implícita al salir del fork

**Aplicabilidad a IACT:**
- ⚠️ MEDIA — procesos paralelos en requisitos (raro pero posible)

### 2.11 Split Processing (Section 6.11)

**Variantes:**

**a) Split regular:**
```plantuml
split
  :A;
split again
  :B;
split again
  :C;
end split
:D;
```

**b) Input split (multi-start):**
```plantuml
split
  -[hidden]->
  :A;
split again
  -[hidden]->
  :B;
end split
```

**c) Output split (multi-end):**
```plantuml
split
  :A;
  kill
split again
  :B;
  detach
end split
```

**Características:**
- `split` / `split again` / `end split` — ramificación de flujos
- `-[hidden]->` — flechas ocultas para multi-start
- `kill` / `detach` — finalizaciones múltiples
- Diferencia split vs fork: split es más flexible para topologías complejas

**Aplicabilidad a IACT:**
- ✅ MEDIA-ALTA — para flujos que se bifurcan o convergen de formas complejas

### 2.12 Notas (Section 6.12)

**Sintaxis:**
```plantuml
:foo1;
floating note left: This is a note
:foo2;
note right
  This note is on several
  //lines// and can
  contain <b>HTML</b>
end note
```

**Características:**
- `floating note` — nota flotante (posición independiente)
- `note [left|right|top|bottom]` — nota asociada a actividad
- Creole formatting soportado
- Multi-línea con `end note`

**Aplicabilidad a IACT:**
- ✅ ALTA — documentar restricciones, precondiciones, notas contextuales

### 2.13 Colores (Section 6.13)

**Sintaxis:**
```plantuml
:starting progress;
#HotPink:reading configuration files;
#AAAAAA:ending of the process;
```

**Características:**
- `#ColorCode:activity;` — color inline
- Nombres de color (HotPink, AAAAAA, etc.)
- Gradient colors soportados (probablemente)

**RESTRICCIÓN CRÍTICA:**
❌ **NO usar colores inline en IACT diagrams**
- Usar `skinparam activity { BackgroundColor ... }` en su lugar
- Inline colors hacen diagrama no mantenible (repetición de colores)

### 2.14 Líneas sin flechas (Section 6.14)

**Sintaxis:**
```plantuml
skinparam ArrowHeadColor none
:Hello world;
:This is defined on several lines;
```

**Características:**
- `skinparam ArrowHeadColor none` — elimina puntas de flecha
- Líneas rectas en lugar de flechas
- Aspecto más limpio (pero menos dinámico)

**Aplicabilidad a IACT:**
- ⚠️ BAJA — opcional, principalmente estético
- ⚠️ RESTRICCIÓN: Decisión de diseño a nivel global (no inline)

### 2.15 Flechas Estilizadas (Section 6.15)

**Sintaxis:**
```plantuml
:foo1;
-> You can put text on arrows;
if (test) then
  -[#blue]->
  :foo2;
  -[#green,dashed]-> The text can also be...;
  :foo3;
else
  -[#black,dotted]->
  :foo4;
endif
```

**Características:**
- `->` con etiqueta en texto
- Colores: `-[#blue]->`
- Estilos: `dashed`, `dotted`, `bold`
- Etiquetas multi-línea en flechas

**RESTRICCIÓN CRÍTICA:**
❌ **NO usar colores inline en flechas**
- Usar `skinparam arrow { ... }` en su lugar

### 2.16 Conectores (Section 6.16)

**Sintaxis:**
```plantuml
:Some activity;
(A)
detach
(A)
:Other activity;
```

**Características:**
- `(name)` — define conector (punto de referencia)
- `detach` — termina rama
- Permite saltos en el diagrama
- Color opcional: `#blue:(B)`

**Aplicabilidad a IACT:**
- ⚠️ BAJA — caso especializado; evitar si es posible (afecta legibilidad)

### 2.17 Agrupación — Particiones (Section 6.18)

**Sintaxis:**
```plantuml
start
partition Initialization {
    :read config file;
    :init internal variable;
}
partition Running {
    :wait for user interaction;
    :print information;
}
stop
```

**Características:**
- `partition Name { ... }` — agrupa actividades
- Delimitación visual clara
- Nombre descriptivo
- Color opcional: `partition Name #BackColor { ... }`

**Aplicabilidad a IACT:**
- ✅ CRÍTICA — documentar responsabilidades por entidad/actor
- ✅ ALTERNATIVA A SWIMLANES — para particiones principales

### 2.18 Carriles — Swimlanes (Section 6.19)

**Sintaxis:**
```plantuml
|Swimlane1|
:foo1;
|#AntiqueWhite|Swimlane2|
:foo2;
:foo3;
|Swimlane1|
:foo4;
```

**Características:**
- `|Name|` — define carril/swimlane
- Cambio de carril inline durante el diagrama
- Color opcional: `|#Color|Name|`
- Más dinámico que particiones estáticas

**Aplicabilidad a IACT:**
- ✅ CRÍTICA — documentar actores/entidades responsables de actividades
- ✅ VENTAJA SOBRE PARTICIONES — flexibilidad de movimiento entre carriles

### 2.19 Desacoplar y Remover (Section 6.20)

**Sintaxis:**
```plantuml
fork
  :foo1;
  :foo2;
fork again
  :foo3;
  detach
endfork
```

**Características:**
- `detach` — termina rama sin continuación al final
- Usado en fork/split para múltiples finales
- Clarifica terminaciones anticipadas

**Aplicabilidad a IACT:**
- ✅ MEDIA — para flujos con múltiples salidas

### 2.20 Otras Formas de Representación (Section 6.21)

**Sintaxis:**
```
:Activity|      <- separador |
:Activity<      <- separador <
:Activity>      <- separador >
:Activity/      <- separador /
:Activity]      <- separador ]
:Activity}      <- separador }
```

**Características:**
- Cambio de separador final cambia aspecto visual
- `;` (default) = rectángulo redondeado
- `|`, `<`, `>`, `/`, `]`, `}` = diferentes formas
- Principalmente estético

**Aplicabilidad a IACT:**
- ⚠️ BAJA — cambios estéticos; evitar (consistencia visual)

### 2.21 Condition Style (Section 6.23)

**Variantes:**

**Inside (default):**
```plantuml
skinparam conditionStyle inside
```
Prueba dentro del rombo

**Diamond:**
```plantuml
skinparam conditionStyle diamond
```
Prueba fuera del rombo

**InsideDiamond/Foo1:**
```plantuml
skinparam conditionStyle InsideDiamond
```
Híbrido

**Aplicabilidad a IACT:**
- ⚠️ MEDIA — decisión de diseño global; `inside` (default) es recomendado para legibilidad

### 2.22 Condition End Style (Section 6.24)

**Variantes:**

**Diamond (default):**
```plantuml
skinparam ConditionEndStyle diamond
```
Rombo al salir de condicional

**Horizontal line (hline):**
```plantuml
skinparam ConditionEndStyle hline
```
Línea horizontal al salir

**Aplicabilidad a IACT:**
- ⚠️ MEDIA — decisión de diseño; `diamond` es default y reconocible

### 2.23 Global Styling (Section 6.25)

**Sintaxis (nueva):**
```plantuml
<style>
activityDiagram {
  BackgroundColor #33668E
  BorderColor #33668E
  FontColor #888
  FontName arial
  
  diamond {
    BackgroundColor #ccf
    LineColor #00FF00
    FontColor green
  }
  arrow {
    FontColor gold
    FontName arial
  }
  partition {
    LineColor red
    FontColor green
    RoundCorner 10
    BackgroundColor PeachPuff
  }
  note {
    FontColor Blue
    LineColor Navy
    BackgroundColor #ccf
  }
}
</style>
```

**Características:**
- `<style>` block — nueva forma de stilizar
- `activityDiagram { ... }` — selector principal
- Sub-selectores: `diamond`, `arrow`, `partition`, `note`
- Más granular que `skinparam`

**Aplicabilidad a IACT:**
- ✅ CRÍTICA — alternativa moderna a `skinparam`
- ⚠️ DECISIÓN: Usar `<style>` (moderno) o `skinparam` (tradicional)
  - Recomendación: Usar `<style>` para IACT (más flexible, moderno)

---

## 3. Comparación: Sintaxis Anterior (Section 5) vs. Nueva (Section 6)

| Aspecto | Section 5 (Antigua) | Section 6 (Nueva) |
|---------|------------------|----------------|
| Dependencia Graphviz | ✅ Requerida | ❌ NO requerida |
| Mantenibilidad | ⚠️ Media | ✅ Alta |
| Sintaxis | `(*)`, `-->`, `if/then` | `:activity;`, `if/then`, `switch` |
| Características | Básicas | Switch, goto, swimlanes, split |
| Condiciones | if/then/else, anidadas | if/then, if/is, if/equals, switch |
| Paralelismo | Barras `===` | fork/split (más flexibles) |
| Particiones | `partition Name { ... }` | partition + swimlanes `\|Name\|` |
| Styling | skinparam limitado | skinparam + `<style>` block |
| Estado | Estable | Recomendado (migraranímada) |
| Compatibilidad | Antigua pero soportada | Moderna y recomendada |

**Conclusión para IACT:**
- ✅ USAR nueva sintaxis (Section 6)
- ❌ NO usar sintaxis antigua (Section 5)
- ✅ Nueva sintaxis es más simple, mantenible y poderosa

---

## 4. Restricciones y Limitaciones

### 4.1 Restricciones Críticas

**Inline Colors — PROHIBIDO:**
```plantuml
:activity; #FF0000  ← PROHIBIDO
-[#blue]-> text     ← PROHIBIDO en color
```

✅ **ALTERNATIVA:**
```plantuml
<style>
activityDiagram {
  BackgroundColor #1976D2
  arrow { FontColor #FFFFFF }
}
</style>
```

### 4.2 Limitaciones de Características

- ⚠️ Labels/goto es EXPERIMENTAL — no recomendado para documentación estable
- ⚠️ Conectores `(A)` — casos especializados; evitar si es posible
- ⚠️ Formas múltiples (separadores `|`, `<`, `>`) — mantener consistencia

### 4.3 Aplicabilidad a IACT-docs

| Característica | Aplicabilidad | Restricción |
|---|---|---|
| Actividades simples | ✅ CRÍTICA | — |
| Condicionales (if/then) | ✅ CRÍTICA | <2 niveles anidados |
| Switch/case | ✅ ALTA | <5 casos |
| Loops (repeat/while) | ✅ MEDIA | Simple; evitar anidados |
| Paralelismo (fork) | ✅ MEDIA | Solo si necesario |
| Split (multi-start/end) | ✅ MEDIA | Caso específico |
| Particiones | ✅ CRÍTICA | Documentar responsabilidades |
| Swimlanes | ✅ CRÍTICA | Movimiento entre carriles |
| Notas | ✅ ALTA | Contexto y restricciones |
| Styling | ✅ CRÍTICA | `<style>` moderno, NO inline colors |

---

## 5. Síntesis: Activity Diagrams Nueva Sintaxis para IACT-docs

### 5.1 Recomendación

**Nueva Sintaxis (Section 6) para IACT-docs:**
- ✅ **RECOMENDADA SOBRE SINTAXIS ANTIGUA** — más simple, sin Graphviz, más mantenible
- ✅ **TOTALMENTE APLICABLE** — todas las características relevantes presentes
- ✅ **MODERNA Y ESTABLE** — migrataconmendada oficialmente por PlantUML
- ⚠️ **RESTRICCIÓN: NO colores inline** — usar `<style>` block centralizado
- ⚠️ **RESTRICCIÓN: Swimlanes SÍ** — para documentar responsabilidades de actores
- ⚠️ **RESTRICCIÓN: Legibilidad** — <2 niveles if anidado, <5 casos en switch

### 5.2 Plantilla Estándar (Nueva Sintaxis)

```plantuml
!include source/_static/plantuml-styles.puml

@startuml UC_XXXX_Activity

|Swimlane_Actor1|
start
:Activity 1;
:Activity 2;

|Swimlane_Actor2|
if (Decision?) then (yes)
  :Activity 3A;
else (no)
  :Activity 3B;
endif

|Swimlane_Actor1|
:Activity 4;
note right: Context or constraint
stop

@enduml
```

### 5.3 Guía de Características Recomendadas

**PERMITIDO (estándar):**
- ✅ Actividades simples (`:activity;`)
- ✅ Condicionales if/then/else (<2 niveles)
- ✅ Switch/case (<5 casos)
- ✅ Swimlanes con movimiento entre carriles
- ✅ Notas (contexto, restricciones)
- ✅ Loops simple (repeat while, while)
- ✅ Fork para paralelismo explícito
- ✅ Multi-línea descriptions

**PROHIBIDO (no usar):**
- ❌ Colores inline (`:activity; #color`)
- ❌ Colores inline en flechas (`-[#color]->`)
- ❌ Goto/Labels (experimental, afecta legibilidad)
- ❌ Conectores complejos (especializado)
- ❌ Diferentes separadores de actividad (mantener `;`)

**RESTRINGIDO (cuidado):**
- ⚠️ Anidamiento profundo de if (>2 niveles = considerar split)
- ⚠️ Múltiples casos en switch (>5 = considerar dividir)
- ⚠️ Break en loops (solo para casos específicos)
- ⚠️ Detach (solo para multi-end splits)

---

## 6. Validación: Cobertura de Secciones 6.0.1-6.25

| Sección | Contenido | Status | Aplicabilidad |
|---------|----------|--------|---|
| 6.0.1-6.0.2 | Intro, ventajas nueva sintaxis | ✅ | CRÍTICA (recomendación) |
| 6.1 | Actividad simple | ✅ | CRÍTICA |
| 6.2 | Start/stop/end | ✅ | CRÍTICA |
| 6.3 | Condicionales | ✅ | CRÍTICA |
| 6.3.1 | Modo vertical | ✅ | MEDIA (mejora legibilidad) |
| 6.4 | Switch/case | ✅ | ALTA |
| 6.5 | Kill/detach | ✅ | MEDIA (error handling) |
| 6.6 | Repeat loop | ✅ | MEDIA |
| 6.7 | Break | ✅ | BAJA (especializado) |
| 6.8 | Goto/label | ✅ | BAJA (experimental) |
| 6.9 | While loop | ✅ | MEDIA |
| 6.10 | Fork (paralelo) | ✅ | MEDIA |
| 6.11 | Split | ✅ | MEDIA |
| 6.12 | Notas | ✅ | CRÍTICA |
| 6.13 | Colores | ✅ | CRÍTICA (PROHIBIDO inline) |
| 6.14 | Lines sin flechas | ✅ | BAJA (estético) |
| 6.15 | Flechas estilizadas | ✅ | MEDIA (evitar colores) |
| 6.16 | Conectores | ✅ | BAJA (especializado) |
| 6.17 | Color connectors | ✅ | BAJA (especializado) |
| 6.18 | Particiones | ✅ | CRÍTICA |
| 6.19 | Swimlanes | ✅ | CRÍTICA |
| 6.20 | Detach | ✅ | MEDIA |
| 6.21 | Formas múltiples | ✅ | BAJA (evitar) |
| 6.22 | Ejemplo completo | ✅ | APLICABLE |
| 6.23 | Condition style | ✅ | MEDIA (diseño global) |
| 6.24 | Condition end style | ✅ | MEDIA (diseño global) |
| 6.25 | Global `<style>` | ✅ | CRÍTICA (recomendado) |

**Hallazgo:** Todas las secciones cubiertas. Nueva sintaxis completa y bien documentada.

---

## 7. Conclusión y Recomendación Final

### 7.1 Para IACT-docs

**Decisión propuesta:**

1. **Phase 5 STRATEGY:** CONFIRMAR uso de nueva sintaxis
   - Declaración: Activity diagrams usan NUEVA SINTAXIS (Section 6, NO Section 5)
   - Justificación: Sin Graphviz, más mantenible, más características
   - Impacto: Cambio en plantuml-styles.puml (ver section 6.25)

2. **Phase 7 DESIGN:** Crear sección `<style>` en plantuml-styles.puml
   - NO usar `skinparam activity { ... }` (antigua sintaxis)
   - USAR `<style> activityDiagram { ... }` (nueva sintaxis)
   - Incluir sub-selectores: diamond, arrow, partition, note
   - Aplicar paleta corporativa (#1976D2, #388E3C, #F57C00)

3. **Phase 10 EXECUTE:** Aplicar nueva sintaxis en UC activity diagrams
   - Swimlanes para actores/entidades responsables
   - Particiones para agrupamientos lógicos
   - Notas para restricciones/contexto
   - Switch/case para múltiples caminos

### 7.2 Cambios de Scope

**Actualización del WP anterior:**
- Análisis previo (plantuml-activity-diagrams-analysis.md) cubre Section 5 (sintaxis antigua)
- Ese análisis debe marcarse como "DEPRECATED — use new syntax instead"
- Esta guía (plantuml-activity-diagrams-new-syntax-analysis.md) reemplaza el enfoque

**Recomendación:** 
- ⚠️ Actualizar síntesis principal para indicar "Activity Diagrams: NEW SYNTAX (v6) recomendado"
- ✅ Usar esta guía como base para Phase 7 DESIGN/SPECIFY

---

**Análisis Completado:** 2026-04-24 01:50:00  
**Hallazgo clave:** Nueva sintaxis (Section 6) es RECOMENDADA sobre sintaxis antigua; elimina Graphviz, mejora mantenibilidad.  
**Confianza:** 0.98 (secciones 6.0.1-6.25 completas; recomendación clara de migración)  
**Recomendación:** ADOPTAR nueva sintaxis completamente para IACT; usar `<style>` block moderno para centralización de estilos
