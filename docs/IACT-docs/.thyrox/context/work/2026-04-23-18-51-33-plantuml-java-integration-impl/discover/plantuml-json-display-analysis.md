```yml
created_at: 2026-04-24 01:28:00
project: IACT-docs
work_package: 2026-04-23-18-51-33-plantuml-java-integration-impl
phase: Phase 1 — DISCOVER
author: Claude Code Agent
status: Borrador
version: 1.0.0
```

# Análisis: PlantUML JSON Display — Visualización de Datos JSON en Diagramas

**Input:** Guía de Referencia PlantUML 1.2025.0 — pp. 104-105 (Sección 4.8)

**Propósito:** Validar si JSON display es aplicable a IACT-docs.

**Criticidad:** BAJA — Especializado; para desarrolladores, no documentación de requisitos.

---

## 1. Qué es JSON Display

### 1.1 Definición

**JSON display:** capacidad de incrustar y visualizar estructuras JSON directamente en class/object diagrams.

```plantuml
class Class
object Object
json JSON {
   "fruit":"Apple",
   "size":"Large",
   "color": ["Red", "Green"]
}
```

**Propósito:**
- Mostrar estructuras de datos JSON en diagramas
- Visualizar payloads de API
- Documentar formatos de datos

---

## 2. Sintaxis JSON Display (Sección 4.8)

### 2.1 Sintaxis Básica

**Sintaxis:**
```
json [Nombre] [as alias] {
  "key": "value",
  "key": [value1, value2],
  "nested": {
    "key": "value"
  }
}
```

**Ejemplo simple:**
```plantuml
class Class
object Object
json JSON {
   "fruit":"Apple",
   "size":"Large",
   "color": ["Red", "Green"]
}
```

**Características:**
- Sintaxis JSON estándar (comillas, tipos: strings, arrays, objects)
- Integrable con class diagrams
- Integrable con object diagrams
- Anidamiento soportado
- Arrays y valores complejos soportados

### 2.2 Características de Sintaxis

**Tipos soportados:**
- Strings: `"key": "value"`
- Arrays: `"key": ["item1", "item2"]`
- Objects anidados: `"key": { "nested": "value" }`
- Números: `"key": 42`
- Booleanos: `"key": true`

**Interacción con otros diagramas:**
```plantuml
class APIResponse
json JSONPayload {
  "status": "success",
  "data": {
    "id": 123,
    "name": "Alice"
  }
}

APIResponse -- JSONPayload
```

---

## 3. Restricciones y Limitaciones

### 3.1 Limitaciones de PlantUML

**Restricciones identificadas:**
- ⚠️ JSON es principalmente visual (no validable sintácticamente por PlantUML)
- ⚠️ No hay soporte para JSON Schema o tipos estrictos
- ⚠️ Valores grandes hacen el diagrama poco legible
- ⚠️ No hay soporte para comentarios JSON (no estándar)
- ⚠️ JSON se muestra como literal en el diagrama (sin procesamiento)

### 3.2 Centralización de Estilos

**Inline colors en JSON:**
```plantuml
json JSONData {
   "fruit" #FF0000 : "Apple",     ← PROBLEMÁTICO
   "size": "Large"
}
```

❌ **PROBLEMA:** JSON display tiene capacidades limitadas de styling — colores inline NO claramente soportados en sintaxis JSON estándar.

✅ **ALTERNATIVA:** Usar skinparam para JSONBlock (si existe)
```plantuml
skinparam json {
  BackgroundColor #1976D2
  BorderColor #000000
  FontColor #FFFFFF
}
```

**Nota:** PlantUML probablemente NO soporta `skinparam json` específico (basado en documentación incompleta en sección 4.8).

---

## 4. Aplicabilidad a IACT-docs

### 4.1 Evaluación de Uso

| Caso de uso | Aplicabilidad | Razón |
|---|---|---|
| Documentar payloads de API | ❌ BAJA | IACT es doc. de requisitos, no especificación técnica de APIs |
| Mostrar estructura de datos | ❌ BAJA | Mejor en especificaciones técnicas o diagramas de clase |
| Ejemplos de formato de entrada/salida | ⚠️ MEDIA | Posible si IACT documenta interfaces de usuario con datos |
| Flujos de integración | ❌ BAJA | Usar Sequence diagrams en su lugar |

### 4.2 Score de Aplicabilidad

| Aspecto | Score | Razón |
|---------|-------|-------|
| Necesidad en IACT | 0/5 | MUY BAJA — IACT es requisitos funcionales, no especificación técnica |
| Claridad | 4/5 | ALTA — JSON es familiar para desarrolladores |
| Mantenibilidad | 2/5 | BAJA — valores hardcoded, JSON sin validación |
| Valor para requisitos | 0/5 | NULO — No documenta comportamiento funcional |
| Alineación con UML | 0/5 | NULO — JSON display es extensión no estándar de UML |

**Conclusión:** JSON display **definitivamente NO aplicable** a IACT-docs.

---

## 5. Síntesis: JSON Display para IACT-docs

### 5.1 Recomendación

**JSON display en IACT-docs:**
- ❌ **NO recomendado** — fuera de scope de documentación de requisitos
- ❌ **NO aplicable** — IACT documenta comportamiento, no estructura técnica de datos
- ⚠️ **PROHIBIDO** — si se intenta usar, rechazar en Phase 7 DESIGN review

**Alternativas si se necesita documentar datos:**
- ✅ Class diagrams (si es requisito funcional que requiere modelo de datos)
- ✅ Object diagrams (si es ejemplo específico de estado)
- ✅ Notas textuales en UC diagrams (si es simple)

---

## 6. Validación: Cobertura de Sección 4.8

| Sección | Contenido | Status | Aplicabilidad |
|---------|----------|--------|---|
| 4.8 | JSON display simple | ✅ | NULA |
| 4.8.1 | Ejemplo simple | ✅ | NULA |

**Hallazgo:** Sección 4.8 incompleta en documentación proporcionada. Referencia a "JSON page" sugiere documento dedicado en guía original. Análisis basado en sintaxis observada: suficiente para evaluación.

---

## 7. Conclusión y Recomendación Final

### 7.1 Decisión para IACT-docs

**Propuesta:**

1. **Phase 5 STRATEGY:** Decisión binaria
   - JSON display es **explícitamente fuera de scope** para IACT-docs
   - No requiere evaluación condicional (como Class diagrams)
   - Decisión: OMITIR

2. **Phase 7 DESIGN:** Incluir en guidelines
   - Documentar: "JSON display NOT PERMITTED in IACT diagrams"
   - Razón: fuera de scope (requisitos, no especificación técnica)
   - Si necesario documentar datos: usar class diagrams

3. **Phase 10 EXECUTE:** No agregar sección skinparam para json

---

**Análisis Completado:** 2026-04-24 01:28:00  
**Hallazgo clave:** JSON display NO aplicable a IACT-docs; explícitamente prohibido.  
**Confianza:** 0.95 (claidad de no-aplicabilidad muy alta)  
**Recomendación:** Omitir completamente de plantuml-styles.puml y guidelines
