```yml
created_at: 2026-04-23 22:15:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: En revisión
version: 1.0.0
```

# Análisis: PlantUML Styling Strategy Integration — What's Centralized vs. What's Not

**Input:** Análisis previos de guía PlantUML 1.2025.0 (pp. 1-22, secciones 1.1-1.31)

**Objetivo:** Definir qué elementos de estilización PlantUML pueden centralizarse en `plantuml-styles.puml` vs. cuáles deben documentarse como restricciones/estándares en guidelines.

---

## 1. Elementos CENTRALIZABLES en skinparam Global

### 1.1 Colores Globales (No Inline)

**Centralizable:**
```plantuml
' plantuml-styles.puml
!define PRIMARY_COLOR #1976D2
!define SECONDARY_COLOR #388E3C
!define ACCENT_COLOR #F57C00

skinparam backgroundColor #FFFFFF
skinparam fontColor #000000

' Para Sequence Diagrams
skinparam actor {
  backgroundColor PRIMARY_COLOR
  borderColor SECONDARY_COLOR
}

skinparam participant {
  backgroundColor SECONDARY_COLOR
  borderColor PRIMARY_COLOR
}

skinparam message {
  arrowColor #000000
}

skinparam note {
  backgroundColor ACCENT_COLOR
}
```

**NO Centralizable (Debe restringirse):**
```plantuml
' ❌ PROHIBIDO en UC reales:
Alice -> Bob : hello -[#red]> 
participant Alice #99FF99
<color #FF0000>texto rojo</color>
activate A #FFBBBB
```

**Estrategia:**
- ✅ Definir ALL colores en `plantuml-styles.puml`
- ✅ Usar `!include` para importar antes de cada UC
- ❌ PROHIBIR colores inline en UC documentación

### 1.2 Tamaño y Fuente Global

**Centralizable:**
```plantuml
skinparam defaultFontName Arial
skinparam defaultFontSize 12
skinparam maxMessageSize 50
```

**Beneficio:** Control uniforme de legibilidad sin modificar cada UC.

---

## 2. Elementos DOCUMENTABLES en Guidelines (No Centralizados)

### 2.1 Sintaxis Estándar (Abbreviated Syntax)

**Directiva en guidelines (no en .puml):**

```
ESTÁNDAR IACT-DOCS para Sequence Diagrams:

1. Activación de participantes:
   ✅ USE:    bob -> alice ++
   ❌ AVOID:  activate alice

2. Desactivación:
   ✅ USE:    bob -> alice --
   ❌ AVOID:  deactivate alice

3. Creación de objetos:
   ✅ USE:    alice -> obj **
   ❌ AVOID:  create obj

4. Destrucción:
   ✅ USE:    alice -> obj !!
   ❌ AVOID:  destroy obj
```

**Razón:** Sintaxis abreviada es más legible y compacta.

### 2.2 Estructura de UC (Secciones Lógicas)

**Documentable (no estandarizable en .puml):**

```plantuml
@startuml UC_AUTH_01_Login

== 1. Initialization ==
User -> "Login Interface": Request login page
[Inicialización de sistema]

== 2. Authentication ==
User -> "Login Interface": Enter credentials
"Login Interface" -> "Auth Service": Validate
[Validación de credenciales]

== 3. Response ==
"Auth Service" --> "Login Interface": Success/Failure
[Retorno de resultado]

@enduml
```

**Directiva en guidelines:**
- Uso obligatorio de `== Sección ==` para UC con >5 mensajes
- Naming: `== N. Descripción ==` (número + descripción)
- MAX 3-4 secciones por UC (si más, dividir en sub-UC)

### 2.3 Formato de Texto (Creole Permitido)

**Documentable como estándar de uso:**

```
PERMITIDO:
- **texto en bold** para énfasis crítico
- //texto en itálica// para definiciones
- ""código"" para variables/atributos
- __subrayado__ para términos especiales

NO PERMITIDO:
- ~~texto tachado~~ (cambio semántico, usar nota)
- ~~ondulado~~ (decoración sin propósito)
- <color>, <size>, <u:color> (restricción: evitar inline HTML)
```

---

## 3. Arquitectura de plantuml-styles.puml

### 3.1 Estructura Recomendada

```plantuml
' =============================================================
' PLANTUML CORPORATE STYLING CONFIGURATION
' Version: 1.0.0
' Applies to: All Use Case (UC) & Sequence Diagrams
' =============================================================

' SECTION 1: COLOR PALETTE DEFINITIONS
' ====================================
!define PRIMARY_COLOR #1976D2
!define SECONDARY_COLOR #388E3C
!define ACCENT_COLOR #F57C00
!define BG_COLOR #FFFFFF
!define TEXT_COLOR #000000
!define WARNING_COLOR #FF9800
!define ERROR_COLOR #F44336
!define SUCCESS_COLOR #4CAF50

' SECTION 2: GLOBAL THEME SETTINGS
' =================================
skinparam backgroundColor BG_COLOR
skinparam defaultFontName Arial
skinparam defaultFontSize 12
skinparam fontColor TEXT_COLOR
skinparam maxMessageSize 50
skinparam padding 10
skinparam ArrowColor TEXT_COLOR

' SECTION 3: ACTOR STYLING (Usuarios/Actores Externos)
' ===================================================
skinparam actor {
  backgroundColor PRIMARY_COLOR
  borderColor SECONDARY_COLOR
  borderThickness 2
  fontColor #FFFFFF
}

' SECTION 4: BOUNDARY STYLING (Interfaces/Fronteras)
' ==================================================
skinparam boundary {
  backgroundColor #E3F2FD
  borderColor PRIMARY_COLOR
  fontColor TEXT_COLOR
}

' SECTION 5: CONTROL STYLING (Servicios/Controladores)
' ===================================================
skinparam control {
  backgroundColor SECONDARY_COLOR
  borderColor PRIMARY_COLOR
  fontColor #FFFFFF
}

' SECTION 6: ENTITY STYLING (Datos/Bases de Datos)
' ================================================
skinparam entity {
  backgroundColor ACCENT_COLOR
  borderColor SECONDARY_COLOR
  fontColor #FFFFFF
}

' SECTION 7: DATABASE STYLING
' ===========================
skinparam database {
  backgroundColor ACCENT_COLOR
  borderColor SECONDARY_COLOR
  fontColor #FFFFFF
}

' SECTION 8: PARTICIPANT GENERIC
' =============================
skinparam participant {
  backgroundColor SECONDARY_COLOR
  borderColor PRIMARY_COLOR
  fontColor #FFFFFF
}

' SECTION 9: MESSAGE & ARROWS
' ==========================
skinparam message {
  arrowColor TEXT_COLOR
  arrowFontColor TEXT_COLOR
}

' SECTION 10: NOTES
' ================
skinparam note {
  backgroundColor ACCENT_COLOR
  borderColor SECONDARY_COLOR
  fontColor #FFFFFF
}

' SECTION 11: ACTIVATION BOXES
' ===========================
skinparam sequenceGroup {
  borderColor PRIMARY_COLOR
  backgroundColor #F5F5F5
}

' SECTION 12: SEQUENCE DIAGRAM SPECIFIC
' ====================================
skinparam sequenceMessageAlign center
skinparam sequenceTitleFontSize 14

' SECTION 13: STRICT UML MODE (if needed)
' ======================================
' !define STRICT_MODE true
' strictuml

' =============================================================
' END OF STYLING CONFIGURATION
' DO NOT EDIT BELOW THIS LINE
' =============================================================
```

### 3.2 Cómo Usarlo en UC

**En cada archivo .rst de UC:**

```rst
.. plantuml::

   !include source/_static/plantuml-styles.puml
   
   @startuml UC_AUTH_01_Login
   
   actor Usuario
   boundary "Login UI"
   control "Auth Service"
   entity "User DB"
   
   Usuario -> "Login UI" ++ : Request Login
   "Login UI" -> "Auth Service" ++ : Validate Credentials
   "Auth Service" -> "User DB" ++ : Check User
   "User DB" --> "Auth Service" -- : User Found
   "Auth Service" --> "Login UI" -- : Auth Success
   "Login UI" --> Usuario -- : Grant Access
   
   @enduml
```

**Resultado:**
- ✅ Todos los colores desde `plantuml-styles.puml`
- ✅ Consistent styling sin inline HTML
- ✅ Participantes con color corporativo automático
- ✅ Mensajes con flechas corporativas

---

## 4. Lo que NO se puede Centralizar (Requiere Decisión por UC)

### 4.1 Espaciado Vertical (|||)

**Razón:** Depende de layout del diagrama específico.

**Documentación:**
```
USE ONLY if diagram spacing is unbalanced:
Alice -> Bob: msg1
|||
Alice -> Bob: msg2
||30||
Alice -> Bob: msg3
```

### 4.2 Divisiones de Secciones (==)

**Razón:** Estructura lógica única de cada UC.

**Estándar obligatorio (guidelines):**
- Usar para UC complejos (>5 mensajes)
- Nombrar como: `== 1. Step/Phase Name ==`
- MAX 4 secciones por UC

### 4.3 Referencias de Sub-procesos (ref over)

**Razón:** Depende de qué se quiere documentar en cada UC.

**Documentación:**
```
USE for calling external processes:
ref over Alice, Bob : External UC_AUTH_02

ref over User
  This is a sub-process note
  Can be multiple lines
end ref
```

### 4.4 Retardos (...) y Timing

**Razón:** Específico del flujo del diagrama.

**Documentación:**
```
... : Indica delay/wait indefinido
...N minutes/seconds... : Delay específico (documentar cantidad)
```

**NO usar `teoz pragma` en IACT-docs** (timing diagrams no son UC).

---

## 5. Restricciones OBLIGATORIAS para Centralización

### 5.1 Color Inline — PROHIBIDO ❌

```plantuml
❌ Alice -[#red]> Bob : hello
❌ participant Alice #99FF99
❌ <color #FF0000>texto</color>
❌ activate A #FFBBBB
```

**Razón:** Fragmenta paleta corporativa.

**Alternativa:** Usar skinparam predefinido en estilos.

### 5.2 Tamaño de Fuente Inline — EVITAR ⚠️

```plantuml
⚠️ <size:18>Texto grande</size>
```

**Razón:** `maxMessageSize` está centralizado.

**Si se necesita énfasis:** Usar **bold** Creole.

### 5.3 Decoración sin Propósito — EVITAR ⚠️

```plantuml
⚠️ ~~texto ondulado~~
⚠️ Wavy lines HTML
```

**Razón:** Decoración sin significado semántico.

---

## 6. Validación: ¿Qué se Puede Centralizar?

| Elemento | ¿Centralizable? | Método | Documentación |
|----------|-------|--------|---|
| **Color de fondo** | ✅ | skinparam | Define en .puml |
| **Color de texto** | ✅ | skinparam | Define en .puml |
| **Color de bordes** | ✅ | skinparam | Define en .puml |
| **Fuente por defecto** | ✅ | skinparam defaultFontName | Define en .puml |
| **Tamaño por defecto** | ✅ | skinparam defaultFontSize | Define en .puml |
| **Alineación de texto** | ✅ | skinparam sequenceMessageAlign | Define en .puml |
| **Ancho máx de mensaje** | ✅ | skinparam maxMessageSize | Define en .puml |
| **Espaciado vertical** | ❌ | Manual \|\|\| | Documentar en guidelines |
| **Secciones lógicas** | ❌ | Manual == == | Documentar estándar |
| **Énfasis de texto** | ✅ | Creole **bold** //italics// | Documentar uso permitido |
| **Actores/Boundaries/etc** | ✅ | skinparam {tipo} | Define en .puml |
| **Notas** | ✅ | skinparam note | Define en .puml |
| **Timing/Anclas** | ❌ | teoz pragma (no usar) | Excluir de IACT |

---

## 7. Guía de Decisión: ¿Cómo Elegir Centralización?

**Pregunta 1:** ¿Afecta esta característica a TODOS los diagramas UC?
- ✅ SÍ → Centralizar en skinparam
- ❌ NO → Documentar en guidelines

**Pregunta 2:** ¿Requiere cambios en `!include` para adaptarse a casos específicos?
- ✅ SÍ → Documentar en guidelines (no centralizar)
- ❌ NO → Centralizar en skinparam

**Pregunta 3:** ¿Es parte de la paleta corporativa visual (colores, fuentes)?
- ✅ SÍ → Centralizar en .puml
- ❌ NO → Documentar restricción/estándar en guidelines

---

## 8. Implicaciones para Phase 2 MEASURE Baseline

### 8.1 Nuevos Parámetros a Medir

| Métrica | Baseline | Target | Método |
|---------|----------|--------|--------|
| Archivos .puml centralizados | 0 | 1 (plantuml-styles.puml) | File count |
| Líneas de estilos | 0 | ~150-200 | wc -l |
| Skinparam directivas | 0 | ~30-40 | grep skinparam |
| Colores definidos | 0 | 6+ | grep !define |
| UC with `!include` | 0 | 100+ | grep "!include" in UC files |
| Colores inline (NC) | ~50+ (TBD) | 0 | grep -c "\[#" in UC files |
| Tamaños inline (NC) | ~20+ (TBD) | 0 | grep -c "<size:" in UC files |

---

## 9. Próximas Acciones

### Para Phase 5 STRATEGY
- [ ] Confirmar que `!include` funciona en sphinxcontrib.plantuml
- [ ] Validar que skinparam se aplica correctamente a tipos (actor, boundary, entity, etc.)
- [ ] Decidir si se necesita `strictuml` mode

### Para Phase 7 DESIGN/SPECIFY
- [ ] Mapear UC reales IACT-docs contra estilos centralizados
- [ ] Crear template UC con estilos aplicados
- [ ] Validar sintaxis y colores en 5 UC muestreo

### Para Phase 10 EXECUTE
- [ ] Crear `plantuml-styles.puml` con estructura de Sección 3.1
- [ ] Aplicar `!include` a 5 UC críticos
- [ ] Validar visualización en HTML generado
- [ ] Expansión progresiva a 100+ UC

---

**Análisis Completado:** 2026-04-23 22:15:00  
**Estado:** En revisión  
**Propósito:** Define arquitectura centralizadora de estilos para todas las fases posteriores
