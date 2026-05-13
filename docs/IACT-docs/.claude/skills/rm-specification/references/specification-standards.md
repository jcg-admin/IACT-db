# Specification Standards — Guía de referencia

> Reference for rm:specification. IEEE 830 estructura, Gherkin avanzado, acceptance criteria patterns.

---

## Selección de formato de especificación

| Formato | Cuándo usar | Fortalezas | Debilidades |
|---------|-------------|-----------|-------------|
| **IEEE 830 SRS** | Sistemas críticos, contratos formales, entornos regulados | Exhaustivo, formal, reconocido internacionalmente | Costoso de mantener, voluminoso |
| **BRD (Business Requirements Document)** | Enfoque en requisitos de negocio, antes del diseño técnico | Orientado al negocio, más ligero que IEEE 830 | Sin cobertura de NFR estándar |
| **User Stories (Agile)** | Proyectos con sprints cortos, requisitos evolutivos | Conversacional, fácil de priorizar, orientado al valor | Requiere criterios de aceptación explícitos |
| **Híbrido (User Stories + SRS ligero)** | Equipos ágiles con requisitos NFR complejos | Balance entre agilidad y rigor | Requiere disciplina para no degradar a ninguno de los dos |

**Regla de selección:**
- Contrato fijo de entrega → IEEE 830 o BRD
- Sprint backlog con entregas iterativas → User Stories con criterios de aceptación
- Sistema con NFR críticos (seguridad, performance) en contexto ágil → Híbrido

---

## IEEE 830 — Estructura estándar

```
1. Introduction
   1.1 Purpose
   1.2 Scope
   1.3 Definitions, Acronyms, Abbreviations
   1.4 References
   1.5 Overview

2. Overall Description
   2.1 Product Perspective
   2.2 Product Functions
   2.3 User Characteristics
   2.4 Constraints
   2.5 Assumptions and Dependencies

3. Specific Requirements
   3.1 External Interface Requirements (User / Hardware / Software / Communications)
   3.2 Functional Requirements (por feature/subsistema)
   3.3 Performance Requirements
   3.4 Logical Database Requirements
   3.5 Design Constraints
   3.6 Software System Attributes (reliability, availability, security, maintainability, portability)
   3.7 Organizing Specific Requirements (por modo / clase de usuario / objeto / feature / estímulo / jerarquía)

4. Appendices
   4.1 Traceability Matrix
   4.2 Glossary
```

**Plantilla de requisito funcional (IEEE 830):**

```
REQ-[ID]: [Nombre descriptivo]
Priority: Must Have / Should Have / Could Have
Source: [stakeholder / document]
Description: The system shall [verb] [object] [condition/constraint]
Input: [what triggers this requirement]
Processing: [what the system does]
Output: [observable result]
Error Handling: [what happens when preconditions are not met]
Rationale: [why this requirement exists — business justification]
```

---

## User Stories — formato y criterios de calidad

### Formato estándar

```
As a [type of user]
I want [some goal/capability]
So that [some reason/benefit]

Acceptance Criteria:
- Given [initial context]
  When [event/action]
  Then [expected outcome]
```

### Criterios INVEST para User Stories

| Criterio | Descripción | Verificación |
|----------|-------------|--------------|
| **I — Independent** | No depende de otra story para ser implementada | Se puede implementar en cualquier orden |
| **N — Negotiable** | Los detalles son negociables (no el valor de negocio) | El equipo puede proponer alternativas de implementación |
| **V — Valuable** | Entrega valor al usuario o al negocio | Tiene un "So that" claro |
| **E — Estimable** | El equipo puede estimar el esfuerzo | Tiene suficiente detalle para estimation |
| **S — Small** | Cabe en un sprint | < 8 story points (o criterio del equipo) |
| **T — Testable** | Los criterios de aceptación son verificables | Criterios Given/When/Then completos |

### Splitting — cómo partir stories demasiado grandes

| Técnica | Cuándo usar | Ejemplo |
|---------|-------------|---------|
| **Por flujo de trabajo** | Story cubre múltiples pasos de un proceso | "Procesar pedido" → Crear / Confirmar / Despachar / Entregar |
| **Por variación de datos** | Story funciona diferente para distintos inputs | "Pagar con tarjeta" → crédito / débito / prepago |
| **Por reglas de negocio** | Story tiene múltiples reglas | "Calcular descuento" → regla A / regla B / regla C |
| **Por operaciones CRUD** | Story cubre crear + leer + actualizar + eliminar | Separar en 4 stories |
| **Por roles** | Story funciona diferente para distintos usuarios | "Ver reporte" → admin (completo) / manager (su área) |
| **Por plataforma** | Story funciona en web + mobile | Separar en web y mobile |
| **Por happy path vs excepción** | Story muy grande con muchos flujos de error | Happy path primero; excepciones en stories separadas |

---

## Gherkin avanzado — criterios de aceptación

### Sintaxis base

```gherkin
Feature: [Nombre de la funcionalidad]
  As a [usuario]
  I want [capacidad]
  So that [beneficio]

  Background:
    Given [estado inicial común a todos los escenarios]

  Scenario: [Nombre descriptivo del escenario]
    Given [contexto inicial específico]
    And [contexto adicional]
    When [acción del actor]
    And [acción adicional]
    Then [resultado observable]
    And [resultado adicional]
    But [excepción o restricción]

  Scenario Outline: [Para múltiples variaciones de datos]
    Given [contexto con <variable>]
    When [acción con <variable>]
    Then [resultado esperado es <resultado>]
    Examples:
      | variable | resultado |
      | valor1   | expected1 |
      | valor2   | expected2 |
```

### Patrones de Acceptance Criteria

**Patrón 1: Estado → Acción → Resultado**
```gherkin
Given the user is logged in as "admin"
When the user clicks "Delete Product" for product ID 123
Then product 123 is removed from the catalog
And the user sees "Product deleted successfully"
And the action is recorded in the audit log
```

**Patrón 2: Regla de negocio con múltiples variaciones**
```gherkin
Scenario Outline: Apply discount based on cart total
  Given the cart total is <cart_total>
  When the user proceeds to checkout
  Then the discount applied is <discount>
  Examples:
    | cart_total | discount |
    | $50        | 0%       |
    | $100       | 5%       |
    | $200       | 10%      |
    | $500       | 15%      |
```

**Patrón 3: Flujo de error**
```gherkin
Scenario: Failed login with invalid credentials
  Given the login page is displayed
  When the user enters "wrong@email.com" and "wrongpassword"
  Then the error message "Invalid credentials" is displayed
  And the account is NOT locked (< 5 attempts)
  And the failed attempt is logged in the security audit
```

**Patrón 4: Performance en criterio de aceptación**
```gherkin
Scenario: Search results load time
  Given 500 concurrent users are using the system
  When a user performs a product search
  Then the search results are displayed within 2 seconds (p95)
  And all 500 concurrent searches complete without error
```

### Anti-patrones en Gherkin

| Anti-patrón | Ejemplo | Corrección |
|------------|---------|-----------|
| Implementación en el criterio | `When the API POST /users is called` | `When the user registers` |
| UI detail en el criterio | `When the user clicks the blue button labeled "Submit"` | `When the user submits the form` |
| Múltiples acciones en When | `When the user enters name AND clicks submit AND confirms` | Separar en múltiples pasos o en una sola acción de alto nivel |
| Then ambiguo | `Then the system works correctly` | `Then the user is redirected to the dashboard` |
| Scenario demasiado largo | Scenario con 20+ pasos | Split en múltiples scenarios |

---

## Acceptance Criteria patterns para NFR

### Performance

```
NFR-P: [Feature name] response time
Given [N] concurrent users are executing [action]
When [specific action that tests the performance]
Then [metric] must be [threshold] at [percentile]
  - Example: p95 response time must be < 500ms
  - Example: throughput must be ≥ 1000 req/s
  - Example: CPU usage must not exceed 70% under load
```

### Seguridad

```
NFR-S: [Security control name]
Given [attack scenario]
When [malicious input / action]
Then [system protection response]
  - Example: Given SQL injection attempt in search field
             When user submits "'; DROP TABLE users; --"
             Then the search returns no results (not an error)
             And the attempt is logged in the security audit
```

### Disponibilidad

```
NFR-A: [System availability]
Given [failure scenario — hardware/software/network]
When [specific failure occurs]
Then [system behavior during and after failure]
  - Example: When the primary database server fails
             Then the system switches to replica within 30 seconds
             And zero data is lost (transactions in progress are either committed or rolled back)
             And users see a "high availability mode" notice, not an error
```
