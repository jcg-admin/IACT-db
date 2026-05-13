```yml
created_at: 2026-04-23 23:15:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: En revisión
version: 1.0.0
```

# Análisis: PlantUML Advanced Sequence Features — Stereotypes, Styling, Edge Cases

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 25-41 (Secciones 1.32-1.45)

**Propósito:** Validar capacidades avanzadas de Sequence Diagrams y cómo se integran con estrategia de centralización.

---

## 1. Estereotipos y Marcas (Secciones 1.32-1.33)

### 1.1 Sintaxis de Estereotipos

```plantuml
participant "Famous Bob" as Bob << Generated >>
participant Alice << (C,#ADD1B2) Testable >>
```

**Componentes:**
- `<< Stereotype >>` : Estereotipo textual
- `<< (X,#COLOR) Label >>` : Marca coloreada (X = carácter)

### 1.2 Control de Visualización

**Por defecto:** Guillemets ("") alrededor de estereotipos

**Desactivar:**
```plantuml
skinparam guillemet false
participant "Famous Bob" as Bob << Generated >>
```

**Posición:**
```plantuml
skinparam stereotypePosition top      ← Por defecto
skinparam stereotypePosition bottom   ← Alternativa
```

### 1.3 Aplicabilidad a IACT-docs

- ⚠️ Probablemente NO se usan estereotipos en UC
- ⚠️ Si se usan, requiere documentación clara
- ✅ Opción para clasificar participantes si es necesario

---

## 2. Títulos Enriquecidos (Sección 1.34)

### 2.1 Creole en Títulos

```plantuml
title __Simple__ **communication** example
```

### 2.2 Títulos Multi-línea

```plantuml
title __Simple__ communication example\non several lines
```

### 2.3 Títulos Complejos (Creole + HTML)

```plantuml
title
 <u>Simple</u> communication example
 on <i>several</i> lines and using <font color=red>html</font>
 This is hosted by <img:sourceforge.jpg>
end title
```

### 2.4 Aplicabilidad

- ✅ Títulos descriptivos
- ⚠️ HTML inline (potencial fragmentación de estilos)
- ✅ Multi-línea para diagramas complejos

**Recomendación:** Documentar restricción sobre colores HTML inline en títulos.

---

## 3. Entorno de Participante (Sección 1.35)

### 3.1 Palabra clave `box`

```plantuml
box "Internal Service" #LightBlue
  participant Bob
  participant Alice
end box
participant Other
```

**Aplicabilidad:**
- ✅ Agrupar participantes por subsistema/servicio
- ⚠️ Color inline — requiere restricción
- ✅ Mejora legibilidad de diagramas complejos

---

## 4. Personalizaciones Globales (Secciones 1.37-1.40)

### 4.1 skinparam Global para Sequence

```plantuml
skinparam sequenceArrowThickness 2
skinparam roundcorner 20
skinparam maxmessagesize 60
skinparam sequenceParticipant underline
```

### 4.2 skinparam por Tipo

```plantuml
skinparam sequence {
  ArrowColor DeepSkyBlue
  ActorBorderColor DeepSkyBlue
  LifeLineBorderColor blue
  LifeLineBackgroundColor #A9DCDF
  ParticipantBorderColor DeepSkyBlue
  ParticipantBackgroundColor DodgerBlue
  ParticipantFontName Impact
  ParticipantFontSize 17
  ParticipantFontColor #A9DCDF
  ActorBackgroundColor aqua
  ActorFontColor DeepSkyBlue
  ActorFontSize 17
  ActorFontName Aapex
}
```

**HALLAZGO CRÍTICO:** Hay **dos formas** de definir skinparam:

| Forma | Sintaxis | Aplicabilidad |
|-------|----------|---|
| **Global** | `skinparam key value` | Para valores simples |
| **Grouped** | `skinparam type { key value }` | Para parámetros complejos |

**Implicación:** plantuml-styles.puml debe soportar **ambas formas**.

### 4.3 Parámetros LifelineStrategy

```plantuml
skinparam lifelineStrategy nosolid   ← Por defecto (línea punteada)
skinparam lifelineStrategy solid     ← Línea continua
```

### 4.4 Style strictuml (UML Compliance)

```plantuml
skinparam style strictuml
```

**Efecto:** Flechas con triángulos (estándar UML) en lugar de punta afilada.

**Aplicabilidad:**
- ✅ REQUERIDO para UML 2.x compliance
- ✅ Debe estar en plantuml-styles.puml

---

## 5. Control de Espaciado y Layout (Sección 1.38)

### 5.1 Padding (Espaciado interno)

```plantuml
skinparam ParticipantPadding 20   ← Espaciado de participantes
skinparam BoxPadding 10            ← Espaciado de boxes
```

**Aplicabilidad:**
- ✅ Centralizable via skinparam
- ✅ Mejora legibilidad sin cambiar sintaxis

---

## 6. Tipos de Flechas (Sección 1.39 — Appendix)

### 6.1 Variantes de Flechas

**Normales:**
```
->   ->>   -\   -\\   -/   -//   ->x   x->   o->   ->o   <->
```

**Self (a sí mismo):**
```
->   ->>   -\   -\\   -/   -//   ->x   x->   o->   ->o   <->
```

**Entrada ([->):**
```
[->   [->>   [-\   [-\\   [-/   [-//   [->x   [x->   [o->   [->o   [<->
```

**Salida (->]):**
```
->]   ->>]   -\]   -\\]   -/]   -//]   ->x]   x->]   o->]   ->o]   <->]
```

**Corta (? - para long labels):**
```
?->   ?->>   ?-\   ?-\\   ?-/   ?-//   ?->x   ?x->   ?o->   ?->o   ?<->
```

**HALLAZGO:** Aproximadamente **20+ variantes** de flechas.

**Aplicabilidad a IACT-docs:**
- ⚠️ Probablemente usando solo `->` y `-->`
- ✅ Variantes disponibles si se necesita especificidad
- ⚠️ Documentar en guidelines cuáles se permiten

---

## 7. Mensajes Ocultos y Condicionales (Secciones 1.41-1.42)

### 7.1 Hide Unlinked

```plantuml
hide unlinked
participant Alice
participant Bob
participant Carol
Alice -> Bob : hello
```

**Efecto:** Oculta Carol (no tiene mensajes).

**Aplicabilidad:**
- ✅ Limpiar diagramas de actores no usados
- ⚠️ Requiere validación de que no oculta actores importantes

### 7.2 Colorear Grupo de Mensajes

```plantuml
alt#Gold #LightBlue Successful case
  Bob -> Alice: Authentication Accepted
else #Pink Failure
  Bob -> Alice: Authentication Rejected
end
```

**Aplicabilidad:**
- ✅ Diferenciar flujos alternos
- ⚠️ Colores inline — requiere documentación de restricción

---

## 8. Features Especiales (Secciones 1.43-1.45)

### 8.1 Mainframe

```plantuml
mainframe This is a **mainframe**
Alice->Bob : Hello
```

**Aplicabilidad:**
- ⚠️ Probablemente NO se usa en IACT
- ✅ Disponible si se necesita envolver diagramas

### 8.2 Slanted/Odd Arrows (v1.2022.6+)

```plantuml
A ->(10) B: text 10
B ->(10) A: text 10
```

**Sintaxis:** Número en paréntesis controla desplazamiento.

**Aplicabilidad:**
- ⚠️ Raramente usado
- ✅ Disponible para diagramas con mensajes paralelos confusos

### 8.3 Parallel Messages (teoz pragma)

```plantuml
!pragma teoz true
Alice -> Bob : hello
& Bob -> Charlie : hi
```

**Sintaxis:** `&` indica mensaje paralelo.

**Aplicabilidad:**
- ⚠️ Timing-specific (no UC típicas)
- ❌ Probablemente NO necesario para IACT

---

## 9. Validación: ¿Qué se Centraliza vs. Documenta?

### 9.1 Centralizables en plantuml-styles.puml

| Característica | Parámetro | Ubicación |
|---|---|---|
| **Arrow thickness** | `sequenceArrowThickness` | skinparam sequence |
| **Round corners** | `roundcorner` | skinparam |
| **Max message size** | `maxmessagesize` | skinparam |
| **Lifeline style** | `lifelineStrategy` | skinparam |
| **UML compliance** | `style strictuml` | skinparam |
| **Participant padding** | `ParticipantPadding` | skinparam |
| **Actor colors** | `ActorBackgroundColor` | skinparam sequence |
| **Lifeline colors** | `LifeLineBackgroundColor` | skinparam sequence |

### 9.2 Documentables en Guidelines (NO centralizados)

| Característica | Razón | Documentación |
|---|---|---|
| **Arrow variants** | Depende del diagrama | Guía de cuáles se permiten |
| **Estereotipos** | Uso específico | Si se usan, cómo y cuándo |
| **Títulos HTML** | Potencial fragmentación | Restringir colores inline |
| **Color grupo mensajes** | Depende del flujo | Documentar cuando se usa alt/else |
| **Hide unlinked** | Depende del diagrama | Usar solo si válido semanticamente |
| **Mainframe/slanted/parallel** | Raramente usado | Solo si explícitamente necesario |

---

## 10. Síntesis: Capacidades Avanzadas

### 10.1 Características Útiles para IACT

✅ **RECOMENDADO usar:**
- Estereotipos (si se documentan)
- Títulos multi-línea con Creole
- Box para agrupar participantes
- Skinparam sequence completo (colors, fonts, sizes)
- lifelineStrategy solid (para claridad)
- strictuml para UML compliance

⚠️ **USAR CON CUIDADO:**
- Colores grupo mensajes (documentar)
- Hide unlinked (validar semántica)
- Flechas especiales (mantener estándar)

❌ **NO USAR:**
- Mainframe (no aplicable)
- Parallel messages/teoz (timing, no UC)
- Slanted arrows (complejidad innecesaria)

---

## 11. Impacto en plantuml-styles.puml

### 11.1 Secciones Adicionales Requeridas

```plantuml
' SECTION: SEQUENCE DIAGRAM ADVANCED STYLING
' ==========================================

skinparam sequence {
  ArrowColor TEXT_COLOR
  ArrowThickness 1.5
  LifeLineBorderColor PRIMARY_COLOR
  LifeLineBackgroundColor #F5F5F5
  ParticipantBorderColor PRIMARY_COLOR
  ParticipantBackgroundColor SECONDARY_COLOR
  ParticipantFontColor #FFFFFF
  ActorBackgroundColor PRIMARY_COLOR
  ActorBorderColor SECONDARY_COLOR
  ActorFontColor #FFFFFF
}

' Lifeline strategy: nosolid vs. solid
' Default: nosolid (dashed)
' For clarity: solid
skinparam lifelineStrategy solid

' UML compliance
skinparam style strictuml

' Global settings
skinparam sequenceArrowThickness 1.5
skinparam roundcorner 20
skinparam maxmessagesize 50
skinparam ParticipantPadding 15
skinparam BoxPadding 8
```

---

## 12. Conclusión: Advanced Features son Supportados

**Hallazgo:** PlantUML 1.2025.0 soporta **amplia gama de características avanzadas**.

**Implicación:**
- ✅ Estrategia de centralización es viable
- ✅ La mayoría de features se pueden controlar via skinparam
- ⚠️ Algunos features requieren documentación explícita
- ❌ Algunos features (timing, mainframe) se pueden excluir

**Para Phase 1 Setup:**
- Definir skinparam sequence **completo** en styles.puml
- Incluir lifelineStrategy solid + strictuml
- Documentar en guidelines: cuáles features se permiten/prohíben

---

**Análisis Completado:** 2026-04-23 23:15:00  
**Hallazgo clave:** Advanced features abundantes — casi todo centralizable via skinparam  
**Confianza:** 0.90 (bien documentado en guía)
