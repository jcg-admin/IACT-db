```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo estructurar requisitos en dos niveles (general y específico).
goal: Crear estructura clara y verificable de requisitos del sistema.
updated_at: 2026-03-25
owner: workflow-discover
```

# Requirements Analysis

## Propósito

Guía de cómo estructurar requisitos en dos niveles (general y específico).

> Objetivo: Crear estructura clara y verificable de requisitos del sistema.

---

## Estructura Pura de Requirements

Basado en el ejemplo HtmlSanityCheck:

### Nivel 1: Requisitos Generales

Requisitos de alto nivel que describen **funcionalidad general**.

**Formato:**
```
ID | Requirement | Explanation
---|-------------|-------------
R-1| [Nombre]   | [Explicación concisa]
R-2| [Nombre]   | [Explicación concisa]
```

**Características:**
- ID único (R-1, R-2, etc.)
- Nombre breve y claro
- Explicación concisa
- Orientado al negocio/usuario
- Verificable

**Ejemplo:**
```
R-1: User Registration
     → Sistema permite a usuarios crear cuenta con email y contraseña

R-2: Product Browsing
     → Sistema permite buscar y navegar catálogo de productos

R-3: Shopping Cart
     → Sistema permite agregar/remover productos a carrito
```

---

### Nivel 2: Requisitos Específicos

Detalles de **cómo se implementan** los requisitos generales.

**Formato:**
```
Para R-N (Requisito General):
  - [Verificación específica 1]
    Descripción de qué verificar
    
  - [Verificación específica 2]
    Descripción de qué verificar
```

**Características:**
- Muy específicos y concretos
- Describen acción medible
- Son implementables
- Verificables
- Automatizables

**Ejemplo:**
```
Para R-1 (User Registration):
  - Email validation
    Verificar que email es válido y no duplicado
    
  - Password strength validation
    Verificar que contraseña cumple criterios de seguridad
    
  - Account confirmation
    Enviar email de confirmación antes de activar
    
  - Data encryption
    Almacenar datos sensibles encriptados
```

---

## Elementos Puros de Requirements

### 1. Estructura de Identificadores
- ID único (R-N para requisitos)
- Nombres descriptivos pero breves

### 2. Forma de Expresar Requisitos
- Verbo activo (Check, Verify, Process, Allow, Enable)
- Sujeto claro (who/what?)
- Propósito claro (why?)

### 3. Dos Niveles Jerárquicos
- Nivel superior: requisitos generales de alto nivel
- Nivel inferior: implementación específica

### 4. Granularidad Adecuada
- Ni demasiado genéricos ni demasiado específicos
- Suficientemente claro para guiar desarrollo
- Suficientemente flexible para múltiples implementaciones

### 5. Verificabilidad
- Cada requisito debe ser observable/medible
- Posible demostrar si se cumple

---

## Matriz de Trazabilidad

Opcional pero recomendado: Mostrar relación entre requisitos y otros elementos.

**Formato:**
```
Requisito | Stakeholder | Priority | Status | Quality Goal
-----------|-------------|----------|--------|-------------
R-1        | User        | High     | Done   | Usability
R-2        | User        | High     | Done   | Performance
R-3        | User        | High     | Done   | Correctness
```

---

## Template para Requirements Analysis

Usar: [requirements-analysis.md.template](../assets/requirements-analysis.md.template)

**Estructura del documento:**
```
# Requirements Analysis: [Nombre del proyecto]

## Requisitos Generales (Level 1)
[Tabla R-1, R-2, R-3, ...]

## Requisitos Específicos (Level 2)
Para cada R-N, detallar:
- Verificación 1
- Verificación 2
- ...

## Matriz de Trazabilidad
[Conectar a Stakeholders, Priority, Status]

## Validación
[Checklist de completitud]
```

---

## Checklist para Requirements

### Contenido
- [ ] Requisitos con ID único
- [ ] Nombres breves y claros
- [ ] Explicación concisa
- [ ] Dos niveles de detalle
- [ ] Verificables y medibles
- [ ] Orientado al negocio

### Estructura
- [ ] Formato consistente
- [ ] Organización lógica
- [ ] Sin redundancias
- [ ] Claridad
- [ ] Completitud

### Trazabilidad
- [ ] Conectado a Stakeholders
- [ ] Conectado a Quality Goals (sección 1.2)
- [ ] Conectado a Constraints (sección 2)
- [ ] Prioridades claras

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Requisitos demasiado vagos ("sistema debe ser bueno")
- Requisitos demasiado técnicos (detalles de implementación)
- Requisitos no verificables ("sistema será rápido")
- Mezclar funcional con no-funcional sin diferenciar
- Requisitos contradictorios sin resolución
```

### HACER:
```
- Requisitos claros y verificables
- Dos niveles de abstracción
- ID único para cada requisito
- Nombres consistentes
- Conectado a stakeholders
- Orientado al negocio
```

---

## Diferencias con Otras Secciones

**Requirements (1.1) vs Quality Goals (1.2):**
- Requirements: QUÉ debe hacer
- Quality Goals: QUÉ TAN BIEN debe hacerlo

**Requirements (1.1) vs Constraints (2):**
- Requirements: Lo que sistema DEBE hacer
- Constraints: Lo que LIMITA cómo lo hace

**Requirements (1.1) vs Design (Section 4):**
- Requirements: Qué (abstract)
- Design: Cómo (concrete)

---

## Próximo Paso

Una vez completado: → Pasar a [use-cases](./use-cases.md)

---

**Última actualización**: 2026-02-01
