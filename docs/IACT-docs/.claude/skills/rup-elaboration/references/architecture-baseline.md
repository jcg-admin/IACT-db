# Architecture Baseline — SAD & ADR Reference

> Reference for rup:elaboration. Guía para construir el SAD y documentar decisiones arquitectónicas.

---

## ¿Qué es la Architecture Baseline?

La **Architecture Baseline** es el conjunto de artefactos que documentan la arquitectura al LCA:
1. **SAD (Software Architecture Document)** — descripción de la arquitectura
2. **Architecture Prototype** — código ejecutable que valida la arquitectura
3. **ADRs (Architecture Decision Records)** — registro de cada decisión mayor

---

## SAD — Estructura completa

### Sección 1: Purpose & Scope

```markdown
## 1. Purpose & Scope

**Propósito:** Este documento describe la arquitectura del sistema [nombre] v[versión].
**Audiencia:** Equipo de desarrollo, arquitecto, QA Lead, Project Manager.
**Baseline:** Este SAD representa la architecture baseline al milestone LCA.
```

### Sección 2: Architectural Goals & Quality Attributes

Usar el modelo de Quality Attribute Scenarios para que los goals sean medibles:

| Quality Attribute | Escenario | Estímulo | Respuesta | Medida |
|------------------|-----------|---------|-----------|--------|
| Performance | Usuario hace request en hora pico | 1000 usuarios concurrentes | Sistema responde | p95 < 500ms |
| Availability | Falla un nodo de BD | Nodo primario cae | Sistema failover | Downtime < 30s |
| Security | Ataque de inyección SQL | Input malicioso | Sistema rechaza | 0 datos expuestos |
| Modifiability | Nuevo tipo de reporte | Change request | Feature desplegada | < 2 días dev |

### Sección 3: Architectural Constraints

```markdown
## 3. Architectural Constraints

### Tecnológicos (mandatados)
- Runtime: [Node.js v20 / Java 17 / Python 3.11]
- DBMS: [PostgreSQL 15 / MySQL 8]
- Plataforma de deployment: [AWS / GCP / Azure / on-premises]

### De integración (requeridos)
- Sistema A: [protocolo, versión de API]
- Sistema B: [formato de intercambio]

### Regulatorios
- [GDPR / PCI-DSS / HIPAA / ISO 27001]

### De equipo
- Tecnologías conocidas: [lista]
- Tecnologías nuevas (requieren spike): [lista]
```

### Sección 4: Architectural Patterns & Decisions

Resumir los patrones elegidos con justificación. Ver sección ADR para formato detallado.

| Categoría | Pattern elegido | Alternativa descartada | Razón principal |
|-----------|----------------|----------------------|----------------|
| Arquitectura general | [Layered / Microservices / Modular Monolith] | [alternativa] | [justificación] |
| Persistencia | [Active Record / Repository / CQRS] | [alternativa] | |
| Comunicación | [REST / gRPC / Event-driven] | [alternativa] | |
| Autenticación | [JWT / Sessions / OAuth2] | [alternativa] | |
| Deployment | [Monolith / Containers / Serverless] | [alternativa] | |

### Sección 5: 4+1 View Model

El modelo 4+1 describe la arquitectura desde 4 perspectivas (vistas) más los escenarios:

#### Vista Lógica — ¿qué hace el sistema?

```
Organización de los componentes principales por responsabilidad.

[Subsistema A]           [Subsistema B]
├── Módulo A1            ├── Módulo B1
│   └── Clase/Servicio   │   └── Clase/Servicio
└── Módulo A2            └── Módulo B2
```

> La vista lógica mapea el dominio — cada subsistema tiene una responsabilidad cohesionada.

#### Vista de Proceso — ¿cómo fluye la ejecución?

```
Threads / procesos / goroutines del sistema en tiempo de ejecución.

Request → [API Gateway] → [Service A] → [DB]
                       ↘ [Queue] → [Worker B] → [DB]
```

#### Vista de Desarrollo — ¿cómo está organizado el código?

```
Estructura de módulos / packages / namespaces del repositorio.

src/
├── api/           ← Capa de presentación
├── domain/        ← Lógica de negocio
├── infrastructure/← Adaptadores externos (DB, queues, APIs)
└── shared/        ← Utilities compartidas
```

#### Vista Física — ¿dónde corre el sistema?

```
Nodos de deployment y comunicación entre ellos.

[Load Balancer] → [App Server 1] ──┐
               → [App Server 2] ──┼──→ [DB Primary] ──→ [DB Replica]
                                  └──→ [Cache (Redis)]
```

#### Escenarios — Use Case Realizations (la "+1" vista)

Los escenarios son los UC arquitecturalmente significativos usados para validar las otras 4 vistas.

| UC | Vistas que ejercita | Riesgo que mitiga |
|----|--------------------|--------------------|
| UC-001: [Nombre] | Lógica + Proceso | R-001 |
| UC-002: [Nombre] | Física + Desarrollo | R-002 |

---

## ADR — Architecture Decision Record (formato para RUP)

Cada decisión arquitectónica major debe tener un ADR. Un ADR es inmutable una vez aprobado.

```markdown
# ADR-[NNN]: [Título de la decisión]

**Fecha:** [YYYY-MM-DD]
**Estado:** Propuesto | Aceptado | Deprecado | Supersedido por ADR-[MMM]
**Contexto:** [Situación que requirió tomar la decisión]
**Decisión:** [La decisión tomada — qué se eligió]
**Alternativas consideradas:**
  - [Alternativa A] — descartada porque [razón]
  - [Alternativa B] — descartada porque [razón]
**Consecuencias positivas:**
  - [Beneficio 1]
  - [Beneficio 2]
**Consecuencias negativas (trade-offs aceptados):**
  - [Trade-off 1]
  - [Trade-off 2]
**Riesgos que aborda:** [Risk ID del Risk List]
```

### Cuándo crear un ADR

Crear ADR para:
- Selección de pattern arquitectónico (Microservices vs Monolith, etc.)
- Selección de tecnología de persistencia
- Estrategia de autenticación / autorización
- Protocolo de comunicación entre servicios
- Estrategia de deployment (contenedores, serverless, etc.)
- Decisiones de seguridad con consecuencias de largo plazo

NO crear ADR para:
- Decisiones de naming de variables o funciones
- Elección de librería para parseo de JSON
- Formato interno de logs (excepto en sistemas con compliance)

---

## Architecture Prototype — guía de construcción

### Qué debe demostrar el prototype

El Architecture Prototype debe ejecutar al menos uno de estos escenarios:

| Tipo de escenario | Qué prueba | Criterio mínimo |
|------------------|-----------|----------------|
| **Performance bajo carga** | El path más crítico con N usuarios concurrentes | NFR de performance del Vision Document |
| **Integración externa** | Flujo end-to-end con sistema externo real | Datos correctos fluyen; errores manejados |
| **Tecnología nueva** | Feature con tecnología nunca usada por el equipo | Funciona en el entorno objetivo del equipo |
| **Escalabilidad** | Componente que más crecerá bajo carga | No degrada con 2× el volumen esperado |

### Estructura mínima del prototype

```
architecture-prototype/
├── README.md              ← Instrucciones de setup y ejecución (obligatorio)
├── docker-compose.yml     ← Entorno reproducible (o equivalente)
├── src/
│   └── [código del escenario crítico]
├── tests/
│   └── [test del escenario crítico con métricas]
└── results/
    └── benchmark-[fecha].md  ← Resultados de la ejecución
```

### Anti-patrones del Architecture Prototype

| Anti-patrón | Por qué es incorrecto | Alternativa correcta |
|------------|---------------------|---------------------|
| Solo diagramas | No prueba que la arquitectura funciona | Código ejecutable mínimo |
| Happy path únicamente | No prueba resiliencia | Incluir escenario de falla |
| Datos mockeados en integración | No prueba la integración real | Usar staging del sistema externo |
| Solo el arquitecto puede ejecutarlo | No es reproducible | README con setup completo |
| Prototype de UI | No valida la arquitectura técnica | Prototype de backend/API/DB |
