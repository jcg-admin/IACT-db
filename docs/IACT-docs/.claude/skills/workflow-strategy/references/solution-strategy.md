```yml
type: Referencia PHASE 2: SOLUTION_STRATEGY
category: Estrategia
version: 1.0
purpose: Guía de cómo crear plan arquitectónico que satisface requisitos dentro de constraints.
goal: Transformar análisis en decisiones arquitectónicas implementables.
updated_at: 2026-03-25
owner: workflow-strategy
```

# Solution Strategy

## Propósito

Guía de cómo crear plan arquitectónico que satisface requisitos dentro de constraints.

> Objetivo: Transformar análisis en decisiones arquitectónicas implementables.

---

## Estructura Pura de Solution Strategy

### 1. Key Ideas (Ideas Clave)

Conceptos fundamentales que guían la solución.

**Preguntas:**
- ¿Cuál es la idea central de la arquitectura?
- ¿Qué concepto es fundamental?
- ¿Cuál es el patrón central?

**Formato:**
```
Idea: [Nombre]
Descripción: [Qué es, por qué es importante]
Impacto: [Cómo afecta el resto de la arquitectura]
```

**Ejemplo:**
```
Idea: Microservices
- Descripción: Descomponer aplicación en servicios independientes
- Impacto: Escalabilidad por servicio, equipos independientes

Idea: Event-Driven
- Descripción: Comunicación asíncrona vía eventos
- Impacto: Desacoplamiento entre servicios, resiliencia
```

---

### 1b. Research Step (antes de decidir)

Antes de tomar decisiones, investigar los unknowns.

**Proceso:**
1. Listar assumptions y unknowns del análisis (Phase 1)
2. Por cada unknown: investigar alternativas, benchmarks, best practices
3. Documentar hallazgos con pros/cons
4. Justificar la elección con evidencia

**Formato por decisión investigada:**
```
Unknown: [Qué no sabemos]
Alternativas:
  - [Opción A] — Pros: ... Cons: ...
  - [Opción B] — Pros: ... Cons: ...
Decisión: [Opción elegida]
Justificación: [Por qué, con evidencia]
```

> No decidir sin investigar. Si no hay tiempo para investigar, documentar la assumption como riesgo.

---

### 2. Fundamental Decisions (Decisiones Fundamentales)

Las decisiones arquitectónicas más importantes.

**Formato:**
```
Decision: [Qué decidimos]
Alternatives: [Qué otras opciones consideramos]
Justification: [Por qué esta decisión]
Implications: [Consecuencias de esta decisión]
```

**Ejemplo:**
```
Decision: Use Hexagonal Architecture
Alternatives: Layered, MVC, CQRS
Justification: Decouples business logic from frameworks
Implications: More complex structure, easier to test and change
```

---

### 3. Technology Stack

El stack de tecnologías seleccionado.

**Categorías:**
```
Language         → Java 17
Framework        → Spring Boot 3
Database         → PostgreSQL 15
Cache            → Redis 7
Message Broker   → RabbitMQ 3.12
Deployment       → Docker + Kubernetes
Monitoring       → Prometheus + Grafana
```

**Características:**
- Específico (no solo "Java", sino "Java 17")
- Justificado (por qué estas tecnologías)
- Coherente (tecnologías que trabajan bien juntas)

---

### 4. Architecture Patterns

Patrones arquitectónicos seleccionados.

**Categorías:**
```
Structural Patterns:
- Hexagonal Architecture
- Repository Pattern
- Dependency Injection

Behavioral Patterns:
- Command Pattern (CLI)
- Observer Pattern (events)
- Strategy Pattern (algorithms)

Architectural Styles:
- REST API
- Event Sourcing
- CQRS (Command Query Responsibility Segregation)
```

---

### 5. Concepts for Handling Quality Goals

CÓMO lograremos cada Quality Goal.

**Formato:**
```
Quality Goal: [Objetivo]
Approach: [CÓMO lo lograremos]
Mechanisms: [Mecanismos específicos]
Technologies: [Tech stack que lo soporta]
```

**Ejemplo:**
```
Quality Goal: High Correctness
Approach: Exhaustive testing + type safety
Mechanisms: Unit tests, integration tests, contract testing
Technologies: JUnit 5, Testcontainers, Pact

Quality Goal: High Security
Approach: End-to-end encryption + audit logs
Mechanisms: TLS 1.3, encrypted data at rest, audit trail
Technologies: AWS KMS, PostgreSQL encryption, ELK stack
```

---

## Relación Entre Secciones

### Requirements → Solution Strategy

```
Requirement: "System validates HTML"
     ↓
Solution Strategy: "Use dedicated validation library + multi-pass validation"
     ↓
Design Decision: "Use jsoup for HTML parsing, custom validator for semantics"
```

### Quality Goals → Solution Strategy

```
Quality Goal: "Every broken link is found"
     ↓
Solution Strategy: "Multiple checking algorithms, comprehensive test coverage"
     ↓
Technology: "JUnit, test fixtures, checkstyle, spotbugs"
```

### Constraints → Solution Strategy

```
Constraint: "Java only"
     ↓
Solution Strategy: "Use Java ecosystem, Spring Boot"
     ↓
Technology Stack: "Java 17 + Spring Boot 3"

Constraint: "AWS only"
     ↓
Solution Strategy: "Leverage AWS services"
     ↓
Technology Stack: "EC2, RDS, S3, Lambda"
```

---

## Ejemplo: Ecommerce

### Key Ideas

```
Idea 1: Microservices Architecture
- Product Catalog Service
- Order Service
- Payment Service
- Inventory Service
- Shipping Service
- User Service

Idea 2: Event-Driven Communication
- Services communicate via async events
- OrderCreated → triggers Inventory Update, Payment, Shipping
- Decoupling: services don't know about each other

Idea 3: API-First Design
- All services expose REST APIs
- Mobile apps, Web apps, Partners all use same APIs
```

### Fundamental Decisions

```
Decision 1: Microservices vs Monolith
Alternatives: Monolith (simpler), Monolith-first (migrate later)
Justification: 
- Scale services independently
- Teams can work independently
- Technology diversity per service
Implications: 
- Distributed system complexity
- Need for orchestration (Kubernetes)
- More operational overhead

Decision 2: REST vs GraphQL
Alternatives: GraphQL (complex), gRPC (not public)
Justification:
- REST widely understood
- Cache-friendly (HTTP caching)
- Simpler for third-party integrations
Implications:
- Over-fetching sometimes
- Multiple endpoints for similar data

Decision 3: PostgreSQL vs NoSQL
Alternatives: MongoDB (document), DynamoDB (managed)
Justification:
- ACID transactions (payments!)
- Complex queries (analytics)
- Strong consistency (correctness)
Implications:
- Scaling write-heavy is harder
- Need connection pooling
```

### Technology Stack

```
Language:           Python 3.11 / Node.js 20
API Framework:      FastAPI / Express.js
Database:           PostgreSQL 15 (Primary)
                    Redis 7 (Cache)
Message Broker:     RabbitMQ 3.12
Search:             Elasticsearch 8.x
Monitoring:         Prometheus + Grafana
Logging:            ELK Stack (Elasticsearch, Logstash, Kibana)
Deployment:         Docker + Kubernetes
API Gateway:        Kong
Load Balancing:     NGINX
CDN:                CloudFront (AWS)
```

### Architecture Patterns

```
Structural:
- Repository Pattern (data access)
- Dependency Injection (loose coupling)
- Factory Pattern (object creation)

Behavioral:
- Observer Pattern (event handling)
- Command Pattern (async operations)
- Strategy Pattern (payment methods)

Architectural:
- REST API (service communication)
- SAGA Pattern (distributed transactions)
- Circuit Breaker (resilience)
```

### Quality Goals Strategies

```
QG1: Correctness
Approach: Exhaustive testing + validation
Mechanisms: Unit tests, integration tests, end-to-end tests
Technologies: pytest, Jest, Postman

QG2: Security
Approach: Encryption + authentication + audit
Mechanisms: OAuth2, TLS 1.3, audit logs
Technologies: Auth0, AWS KMS

QG3: Performance
Approach: Caching + CDN + async processing
Mechanisms: Redis cache, CloudFront, async queues
Technologies: Redis, RabbitMQ, CloudFront

QG4: Scalability
Approach: Horizontal scaling + load balancing
Mechanisms: Kubernetes auto-scaling, NGINX
Technologies: Kubernetes, NGINX, CloudWatch metrics

QG5: Reliability
Approach: Circuit breakers + retries + redundancy
Mechanisms: Exponential backoff, health checks
Technologies: Hystrix, Kubernetes, monitoring
```

---

## Checklist para Solution Strategy

### Contenido
- [ ] Key ideas identificadas y articuladas
- [ ] Decisiones fundamentales documentadas
- [ ] Alternativas consideradas
- [ ] Justificaciones claras
- [ ] Technology stack completo
- [ ] Patrones seleccionados
- [ ] Cómo lograr cada Quality Goal
- [ ] Cómo trabajar dentro de Constraints

### Estructura
- [ ] Coherencia entre decisiones
- [ ] Alineamiento con Requirements
- [ ] Alineamiento con Quality Goals
- [ ] Respeto a Constraints
- [ ] Completitud

### Trazabilidad
- [ ] Conectado a Requirements (1.1)
- [ ] Conectado a Quality Goals (1.2)
- [ ] Conectado a Constraints (2)
- [ ] Conectado a Context (3)
- [ ] Guía para PHASE 4: STRUCTURE

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Ser demasiado específico (detalles de implementación)
- Ignorar Quality Goals
- Violar Constraints
- No justificar decisiones
- Decisiones sin considerar alternativas
- Strategy que no guía implementación
```

### HACER:
```
- Ideas clave y conceptos
- Decisiones con justificación
- Alineadas con Analysis (PHASE 1)
- Respetan Constraints
- Claras para guiar implementación
- Documentadas para comunidad
```

---

## Template para Solution Strategy

Usar: [solution-strategy.md.template](../assets/solution-strategy.md.template)

**Estructura del documento:**
```
# Solution Strategy: [Nombre del proyecto]

## Key Ideas
[Ideas arquitectónicas fundamentales]

## Fundamental Decisions
[Decisiones principales con justificaciones]

## Technology Stack
[Stack tecnológico completo]

## Architecture Patterns
[Patrones seleccionados]

## How We Achieve Quality Goals
Para cada Quality Goal:
[Enfoque, mecanismos, tecnologías]

## Adherence to Constraints
Cómo respetamos cada constraint:
[Constraint - Cómo lo cumplimos]

## Validation
[Checklist]
```

---

## Próximo Paso

Una vez completado PHASE 2: SOLUTION_STRATEGY:
→ Continuar a PHASE 4: STRUCTURE (especificaciones detalladas)

---

**Última actualización**: 2026-02-01
