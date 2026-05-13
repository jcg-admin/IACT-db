---
name: Test-Driven Development (TDD)
description: Protocolo TDD puro — produce collaborative specs (Given/When/Then) con flujos nominal, alternativo y de error. Sin capa contractual DbC. Usar cuando se necesitan acceptance criteria concretos para infraestructura, configuración, features con lógica simple, o comportamiento traza donde los contratos no aplican.
---

# /thyrox:test-driven-development — TDD Puro

Produce **collaborative specifications** (escenarios concretos Given/When/Then) sin capa
contractual DbC. Complementa `/thyrox:spec-driven` cubriendo los casos donde los contratos
formales no son necesarios o donde el comportamiento traza (secuencias, interacciones)
no puede ser expresado con precondiciones/postcondiciones.

---

## Cuándo usar TDD puro vs SDD completo

| TDD puro (`/thyrox:test-driven-development`) | SDD completo (`/thyrox:spec-driven`) |
|----------------------------------------------|--------------------------------------|
| Infraestructura, configuración, setup | Lógica de negocio compleja |
| Comportamiento traza (LIFO, secuencias) | APIs públicas de componentes |
| Features simples con pocos inputs posibles | Múltiples variantes de input |
| Acceptance criteria rápidos | Especificación auto-documentada |
| Integración entre componentes | Contratos de interfaz explícitos |
| TDD clásico (red → green → refactor) | TDD + DbC como amplificadores mutuos |

**Regla simple:** Si el componente tiene una interfaz pública importante o lógica que
aplica a todos los inputs posibles → usar `/thyrox:spec-driven` con contratos DbC.

---

## Protocolo TDD — 4 pasos

### 1. Input

El usuario provee: feature, componente, UC o comportamiento a especificar.
Si no se provee, preguntar antes de continuar.

### 2. Análisis previo

Leer documentación relevante existente:
- Si hay WP activo: leer `*-analysis.md` y `*-solution-strategy.md`
- Si es standalone: usar la descripción del usuario; preguntar si hay ambigüedad

Identificar:
- Actores / roles involucrados
- Estado inicial necesario para cada escenario
- Acciones posibles (incluyendo variantes inválidas)
- Resultados verificables objetivamente

### 3. Collaborative Specifications (escenarios Given/When/Then)

Para CADA UC o comportamiento identificado, escribir los tres tipos de escenarios:

**Flujo nominal (happy path):**
```
Given [estado inicial válido — todas las precondiciones cumplidas]
When  [acción del actor]
Then  [resultado esperado — verificable objetivamente]
And   [condición adicional del estado resultante]
```

**Flujos alternativos (variantes válidas):**
```
Given [estado inicial con variante — sigue siendo un estado válido]
When  [misma acción o variante]
Then  [resultado diferente al nominal]
```

**Escenarios de error (input inválido / precondición violada):**
```
Given [estado que viola una restricción del sistema]
When  [acción que debería ser válida en otro contexto]
Then  [error explícito y específico]
And   [sistema queda en estado consistente — no corrompido]
```

**Propiedades traza (comportamiento entre llamadas — secuencias):**
```
Given [secuencia de acciones previas]
When  [acción N]
Then  [resultado que depende de la historia]

# Ejemplo LIFO: push(A), push(B), pop() → B
```

### 4. Ciclo TDD clásico

Después de producir los escenarios, describir el ciclo de implementación:

```
Para cada escenario (en orden de prioridad nominal → alternativo → error):

  1. RED   — escribir un test que falla (el escenario no está implementado)
  2. GREEN — escribir el mínimo código que hace pasar el test
  3. REFACTOR — limpiar sin romper el test

Punto de cierre: todos los escenarios pasan → UC completo.
```

---

## Formato de salida

```markdown
# TDD Spec — [Nombre del feature/componente]

## Contexto
[Descripción breve del qué y por qué]

## Escenarios — [UC-001: Nombre del caso de uso]

### Flujo nominal
Given [estado inicial]
When  [acción]
Then  [resultado]
And   [condición adicional]

### Flujo alternativo: [nombre variante]
Given [variante del estado inicial]
When  [acción]
Then  [resultado diferente]

### Error: [descripción del error]
Given [estado que viola restricción]
When  [acción]
Then  [error específico]

## Escenarios — [UC-002: ...]
[repetir estructura]

## Escenarios de traza (si aplica)
[secuencias entre llamadas]

## Ciclo TDD
□ Escenario X → test escrito → código mínimo → pasa
□ Escenario Y → ...
□ Todos los UCs cubiertos
```

---

## Referencia metodológica

Ver [`sdd.md`](../references/sdd.md) — sección "Collaborative Specifications (TDD)":
- Ventajas: closure claro (test pasa = listo), collaborative-friendly
- Limitaciones: incompleto (un test = un escenario, no todos los inputs)
- Cuándo complementar con DbC → usar `/thyrox:spec-driven`
