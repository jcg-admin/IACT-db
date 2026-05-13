```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo definir límites del sistema y sistemas externos que se integran.
goal: Clarificar dónde se inserta el sistema en el ecosistema.
updated_at: 2026-03-25
owner: workflow-discover
```

# Context

## Propósito

Guía de cómo definir límites del sistema y sistemas externos que se integran.

> Objetivo: Clarificar dónde se inserta el sistema en el ecosistema.

---

## Estructura Pura de Context

### Dos Subsecciones Principales

#### 1. Business Context (Contexto Empresarial)

Identifica sistemas vecinos desde perspectiva de negocio.

**Preguntas que responde:**
- ¿Quiénes interactúan con el sistema?
- ¿Qué datos intercambian?
- ¿Cuál es el valor de negocio de cada interacción?

**Formato:**
```
External System | Data Exchange | Business Value
----------------|---------------|-----------------
Customer Portal | Orders        | Generate revenue
ERP System      | Inventory     | Stock management
Payment Gateway | Transactions  | Process payments
```

**Características:**
- Foco en negocio, no técnica
- Sistemas externos específicos
- Datos concretos intercambiados
- Valor claro de cada relación

#### 2. Technical Context (Contexto Técnico)

Identifica dependencias técnicas del sistema.

**Preguntas que responde:**
- ¿Qué sistemas técnicos dependen de nosotros?
- ¿Qué sistemas técnicos de los que dependemos?
- ¿Protocolos de comunicación?
- ¿APIs usadas/ofrecidas?

**Formato:**
```
External System | Interface | Technology | Direction
----------------|-----------|------------|----------
Payment Gateway | REST API  | HTTPS      | Outbound
User Portal     | REST API  | HTTP       | Inbound
Analytics DB    | SQL       | TCP 5432   | Outbound
```

**Características:**
- Foco técnico
- Protocolos específicos
- Dirección clara (inbound/outbound)
- Tecnologías específicas

---

## Diagrama de Contexto

### Formato Visual

```
┌─────────────────────────────────────────────────────┐
│                   OUR SYSTEM                        │
│                                                     │
│  [Core Application]                                 │
│                                                     │
└─────────────────────────────────────────────────────┘
         ↑↑         ↓↓         ↑↑         ↓↓
         ║║         ║║         ║║         ║║
    Customer    Payment    Inventory   Analytics
    Portal      Gateway    System      Service
```

**Características:**
- Sistema central claramente dibujado
- Sistemas externos alrededor
- Flechas muestran dirección de comunicación
- Simple pero completo

---

## Ejemplo: Ecommerce

### Business Context

```
External System | Data Exchange | Business Value
----------------|---------------|-----------------

Customer (User)
"Customers browse and purchase products"
Orders, Reviews, Payments
| Generates revenue, customer insights

Supplier System
"Suppliers manage inventory"
Stock levels, Replenishment
| Ensures product availability

Payment Provider
"Third-party payment processing"
Transactions, Authorization
| Secures payment processing

Shipping Partner
"Fulfillment and logistics"
Order details, Tracking
| Delivers products to customers

Analytics Service
"Data warehouse for insights"
Purchase data, User behavior
| Business intelligence
```

### Technical Context

```
External System | Interface | Technology | Direction
----------------|-----------|------------|----------

Customer Portal
REST API
HTTP/HTTPS, JSON
← Inbound (customers call us)

Supplier System
SOAP API
SOAP/XML, TCP 5432
→ Outbound (we call them)

Payment Gateway
REST API
HTTPS, OAuth2
→ Outbound (we call them)

Warehouse System
Message Queue
RabbitMQ, async
← → Bidirectional

Data Warehouse
SQL/Spark
PostgreSQL TCP, Parquet
→ Outbound (we send data)
```

### Diagrama de Contexto

```
┌───────────────────────────────────────────────────────────────┐
│                     ECOMMERCE PLATFORM                         │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐   │
│  │  Product Catalog                                       │   │
│  │  Shopping Cart                                         │   │
│  │  Order Management                                      │   │
│  │  Payment Processing                                    │   │
│  │  Inventory Sync                                        │   │
│  └────────────────────────────────────────────────────────┘   │
│                                                                │
└───────────────────────────────────────────────────────────────┘
     ↓↓↓                  ↑↑↑                 ↓↓↓
     ↓↓↓                  ↑↑↑                 ↓↓↓
     ↓↓↓                  ↑↑↑                 ↓↓↓

┌─────────────┐  ┌──────────────┐  ┌─────────────┐
│Customer Web │  │Payment Stripe │  │Inventory    │
│Portal       │  │Gateway        │  │System (SAP) │
└─────────────┘  └──────────────┘  └─────────────┘

┌─────────────┐  ┌──────────────┐  ┌─────────────┐
│Mobile App   │  │Shipping API  │  │Analytics    │
│             │  │(FedEx, UPS)  │  │Data Warehouse
└─────────────┘  └──────────────┘  └─────────────┘
```

---

## Scope / Boundaries (Límites)

Documentar explícitamente QUÉ ESTÁ DENTRO vs AFUERA:

### Dentro del Sistema

```
+User authentication and authorization
+Product catalog management
+Shopping cart functionality
+Order processing
+Payment integration
+Inventory tracking
```

### Fuera del Sistema (External Dependencies)

```
-Payment processing (Stripe/PayPal)
-Shipping logistics (FedEx/UPS)
-Email delivery (SendGrid)
-Analytics (Google Analytics)
-Authentication (Auth0)
```

---

## Checklist para Context

### Contenido
- [ ] Business context identificado
- [ ] Sistemas externos específicos
- [ ] Datos intercambiados claros
- [ ] Valor de negocio documentado
- [ ] Technical context completo
- [ ] Protocolos específicos
- [ ] Direcciones de comunicación (inbound/outbound)

### Estructura
- [ ] Diagrama de contexto
- [ ] Tablas claras
- [ ] Límites explícitos
- [ ] Scope documentado
- [ ] Completitud

### Trazabilidad
- [ ] Conectado a Requirements (1.1)
- [ ] Conectado a Constraints (2)
- [ ] Conectado a Solution Strategy (3)

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Incluir detalles técnicos en Business Context
- Sistemas demasiado genéricos ("External API")
- No documentar dirección de comunicación
- Olvidar sistemas importantes
- No diferenciar Business vs Technical
- Confundir con interno architecture
```

### HACER:
```
- Específico: nombre sistema externo real
- Documentar protocolos y tecnologías
- Mostrar dirección clara (inbound/outbound)
- Incluir todos los sistemas
- Separar Business y Technical
- Diagram visual + tablas
```

---

## Diferencias con Otras Secciones

**Context (3) vs Introduction (1):**
- Introduction: QUÉ es el sistema, por qué
- Context: DÓNDE está, quiénes interactúan

**Context (3) vs Section 5 (Building Block View):**
- Context: Sistemas externos
- Building Blocks: Componentes internos

**Context (3) vs Section 6 (Runtime View):**
- Context: Límites y sistemas externos
- Runtime: Interacciones entre componentes internos

---

## Template para Context

Usar: [context.md.template](../assets/context.md.template)

**Estructura del documento:**
```
# Context: [Nombre del proyecto]

## Scope / Boundaries
[Qué está dentro vs afuera]

## Business Context
[Tabla de sistemas externos de negocio]

## Technical Context
[Tabla de dependencias técnicas]

## Diagram de Contexto
[Visual del sistema y dependencias]

## Data Flows
[Cómo fluyen los datos entre sistemas]

## Validation
[Checklist]
```

---

## Próximo Paso

Una vez completado PHASE 1: ANALYZE (introduction → context):
→ Continuar a PHASE 2: SOLUTION_STRATEGY

---

**Última actualización**: 2026-02-01
