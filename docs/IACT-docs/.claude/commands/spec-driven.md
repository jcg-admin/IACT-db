---
name: Spec-Driven (SDD)
description: Full Specification-Driven Development cycle (TDD + DbC). Produce especificaciones completas combinando collaborative tests (Given/When/Then) con contratos formales (precondiciones, postcondiciones, invariantes) en tres niveles de rigor — Spec-First, Spec-Anchored, Spec-as-Source. Usar cuando se necesita especificar el comportamiento de un componente, feature o UC con lógica de negocio compleja, APIs públicas, o múltiples variantes de input.
---

# /thyrox:spec-driven — Specification-Driven Development

Produce una especificación **completa** que combina:
- **TDD layer**: Collaborative tests (escenarios concretos Given/When/Then)
- **DbC layer**: Contratos formales (precondiciones, postcondiciones, invariantes)

La spec resultante es más completa que una requirements-spec pura (TDD solo):
los contratos cubren todos los inputs posibles; los tests capturan comportamiento
traza que los contratos no pueden expresar.

---

## Cuándo usar este comando vs /thyrox:structure vs /thyrox:test-driven-development

| `/thyrox:structure` | `/thyrox:spec-driven` | `/thyrox:test-driven-development` |
|---------------------|----------------------|-----------------------------------|
| Phase 4 completa del WP activo | Especificación SDD de un UC, feature o componente | Acceptance criteria TDD (sin contratos) |
| Produce requirements-spec.md del WP | Produce spec SDD standalone (TDD + DbC) | Produce escenarios Given/When/Then únicamente |
| TDD (Given/When/Then) como acceptance criteria | TDD + DbC (tests + contratos formales) | TDD puro — flujos nominal, alternativo, error |
| Ligado al work package activo | Puede usarse independientemente de fases | Para infraestructura, config, lógica simple |
| Para cualquier tipo de WP | Lógica de negocio compleja, APIs públicas | Sin necesidad de contratos DbC |

---

## Paso 0 — Selección de nivel de rigor

Antes de comenzar, determinar el nivel SDD apropiado según el contexto:

| Nivel | Cuándo usar | Relación spec-código |
|-------|-------------|---------------------|
| **Spec-First** | Desarrollo inicial, spec guía la implementación | Spec escrita antes; puede divergir con el tiempo |
| **Spec-Anchored** | Feature en evolución, specs como docs vivos | Tests enforzan alineación; spec y código coevolucionan |
| **Spec-as-Source** | Generación de código desde specs | Solo humanos editan specs; código generado automáticamente |

Si el usuario no especifica el nivel, preguntar antes de continuar. El nivel determina
el workflow de los pasos 4-5 (Specify → Plan → Implement → Validate).

---

## Ciclo SDD — Protocolo (6 pasos)

### 1. Input

El usuario provee: feature, componente o UC a especificar + nivel de rigor deseado.
Si no se provee, preguntar antes de continuar.

### 2. Análisis previo

Leer documentación relevante existente:
- Si hay WP activo: leer `*-analysis.md` y `*-solution-strategy.md`
- Si es standalone: leer la descripción del usuario y hacer preguntas de clarificación

### 3. Collaborative Specifications (TDD layer)

Para CADA UC o comportamiento identificado, escribir escenarios:

```
Given [estado inicial — precondición implícita]
When  [acción o evento]
Then  [resultado verificable]
And   [condición adicional]

# Escenarios requeridos:
- Flujo nominal (happy path)
- Flujos alternativos (variantes válidas)
- Escenarios de error (precondición violada, input inválido)
- Propiedades traza si aplica (comportamiento entre llamadas)
```

### 4. Contractual Specifications (DbC layer)

Para CADA componente/operación, definir contratos:

```
Precondiciones (require):
  - [condición que debe ser verdadera ANTES de la operación]
  - Nota: los escenarios de error del paso 3 deben mapear a precondiciones violadas

Postcondiciones (ensure):
  - [condición que debe ser verdadera DESPUÉS de la operación]
  - Incluir relaciones entre estado nuevo y estado anterior (old value)
  - Los escenarios nominales del paso 3 deben verificar estas postcondiciones

Invariantes (invariant):
  - [condición que debe ser verdadera SIEMPRE]
  - Aplica antes Y después de cualquier operación sobre el componente
```

### 5. Workflow por nivel (Specify → Plan → Implement → Validate)

**Spec-First:**
- Specify: escribir spec completa (pasos 3-4)
- Plan: identificar componentes a implementar desde la spec
- Implement: desarrollar guiado por spec (TDD clásico: test falla → código → pasa)
- Validate: verificar que la implementación cumple la spec; aceptar divergencia controlada

**Spec-Anchored:**
- Specify: escribir spec (pasos 3-4)
- Plan: mapear specs a tests ejecutables
- Implement: código coevoluciona con spec; tests enforzan alineación
- Validate: ejecutar suite; si test falla → actualizar spec O código (decidir cuál)

**Spec-as-Source:**
- Specify: spec formal con contratos DbC precisos (pasos 3-4 en máxima precisión)
- Plan: definir generador / template de código desde contratos
- Implement: solo editar la spec; código generado automáticamente
- Validate: verificar código generado contra contratos; regenerar si contratos cambian

### 6. Test Amplification — Validación de consistencia

⏸ **Pausa obligatoria**: verificar consistencia entre TDD y DbC layers:

```
Checks:
□ Cada precondición tiene ≥1 escenario de error que la viola
□ Cada postcondición tiene ≥1 escenario nominal que la verifica
□ Los contratos no contradicen los tests
□ Los contratos no son más débiles que lo que los tests demuestran
□ Las propiedades traza están en tests (no en contratos)
□ No hay escenarios sin cobertura contractual
□ El nivel de rigor (Spec-First / Spec-Anchored / Spec-as-Source) está declarado
```

Si faltan escenarios: agregar tests para ejercitar los contratos no cubiertos.
Si los contratos son débiles: refinar hasta que capturen toda la intención.

---

## Formato de salida

```markdown
# Spec SDD — [Nombre del feature/componente]

## Contexto
[Descripción breve del qué y por qué]
**Nivel SDD:** [Spec-First | Spec-Anchored | Spec-as-Source]

## Collaborative Specifications (TDD)

### [UC-001 / Escenario nombre]
Given [estado inicial]
When  [acción]
Then  [resultado]

### [UC-001 — error]
Given [precondición violada]
When  [acción]
Then  [error específico]

## Contractual Specifications (DbC)

### [Componente / Operación]

**Precondiciones:**
- [condición 1]

**Postcondiciones:**
- [resultado garantizado]
- [relación con estado anterior]

**Invariantes:**
- [siempre verdadero]

## Workflow (Specify → Plan → Implement → Validate)
[Pasos específicos según el nivel seleccionado]

## Check de consistencia SDD
□ Cada precondición cubierta por escenario de error
□ Cada postcondición verificada por escenario nominal
□ Contratos no contradicen tests
□ Propiedades traza en tests
□ Nivel de rigor declarado
```

---

## Referencia metodológica

Ver [`sdd.md`](../references/sdd.md) para el fundamento teórico completo:
- Ostroff, Makalsky, Paige — *Agile Specification-Driven Development*
- Tres niveles de rigor y framework Specify → Plan → Implement → Validate
