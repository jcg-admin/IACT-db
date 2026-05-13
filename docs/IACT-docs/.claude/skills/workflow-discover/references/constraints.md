```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo identificar QUÉ LIMITA el sistema (técnico, plataforma, org, regulatorio, negocio).
goal: Documentar todas las limitaciones que afectan el diseño.
updated_at: 2026-03-25
owner: workflow-discover
```

# Constraints

## Propósito

Guía de cómo identificar QUÉ LIMITA el sistema (técnico, plataforma, org, regulatorio, negocio).

> Objetivo: Documentar todas las limitaciones que afectan el diseño.

---

## Estructura Pura de Constraints

### Categorías de Restricciones

#### 1. Technical Constraints (Restricciones Técnicas)

Limitaciones técnicas impuestas.

**Preguntas:**
- ¿Tecnologías prohibidas?
- ¿Frameworks predefinidos?
- ¿Versiones específicas de lenguajes?
- ¿Estándares o protocolos obligatorios?

**Ejemplo:**
```
C-1: Java Only
- Constraint: Sistema debe estar implementado en Java
- Razón: Organización tiene expertise en Java
- Impacto: No podemos usar Go, Rust, Node.js
```

#### 2. Platform Constraints (Restricciones de Plataforma)

Limitaciones de infraestructura/plataforma.

**Preguntas:**
- ¿Dónde debe correr el sistema?
- ¿On-premises o cloud?
- ¿Qué sistemas operativos?
- ¿Qué bases de datos?

**Ejemplo:**
```
C-2: AWS Only
- Constraint: Infraestructura debe estar en AWS
- Razón: Acuerdo corporativo con AWS
- Impacto: No podemos usar GCP, Azure, On-Premises
```

#### 3. Organizational Constraints (Restricciones Organizacionales)

Limitaciones impuestas por la organización.

**Preguntas:**
- ¿Procesos que debemos seguir?
- ¿Presupuesto limitado?
- ¿Equipo específico?
- ¿Timeline apretado?

**Ejemplo:**
```
C-3: Team Size Limited
- Constraint: Máximo 3 desarrolladores en el proyecto
- Razón: Otras prioridades corporativas
- Impacto: Arquitectura debe ser simple de mantener
```

#### 4. Regulatory Constraints (Restricciones Regulatorias)

Limitaciones por leyes/regulaciones.

**Preguntas:**
- ¿Leyes de protección de datos (GDPR, CCPA)?
- ¿Cumplimiento de industria (HIPAA, PCI)?
- ¿Auditoría requerida?
- ¿Retención de datos?

**Ejemplo:**
```
C-4: GDPR Compliance
- Constraint: Sistema debe cumplir GDPR
- Razón: Usuarios europeos
- Impacto: Encriptación, derecho al olvido, consentimiento
```

#### 5. Business Constraints (Restricciones de Negocio)

Limitaciones impuestas por el negocio.

**Preguntas:**
- ¿Presupuesto?
- ¿Costo de hosting?
- ¿Licencias de software?
- ¿Retorno de inversión esperado?

**Ejemplo:**
```
C-5: Low Budget
- Constraint: Presupuesto máximo $10k
- Razón: Startup sin funding
- Impacto: No podemos usar soluciones enterprise costosas
```

---

## Estructura Recomendada

### Matriz de Restricciones

```
Category | Constraint | Reason | Impact
---------|-----------|--------|--------
Technical | Java only | Expertise | Limita lenguajes
Platform | AWS | Agreement | Limita cloud
Org | 3 devs | Budget | Arquitectura simple
Reg | GDPR | Law | Encriptación
Business | $10k | Budget | Open source only
```

---

## Ejemplo: Ecommerce

### Technical Constraints

```
C-1: Language: Python
- Razón: Team expertise, rapid development
- Impacto: No usar Java, C#, Go

C-2: Framework: Django
- Razón: Corporate standard
- Impacto: Arquitectura basada en Django

C-3: Database: PostgreSQL
- Razón: Open source, compliance
- Impacto: No SQL Server, Oracle
```

### Platform Constraints

```
C-4: Cloud: AWS
- Razón: Corporate agreement, cost
- Impacto: EC2, RDS, S3 como base

C-5: Containerization: Docker
- Razón: Standard deployment
- Impacto: Todas las aplicaciones containerizadas
```

### Organizational Constraints

```
C-6: Team: 2 backend + 1 DevOps
- Razón: Limited resources
- Impacto: Arquitectura debe ser mantenible

C-7: Timeline: 6 months to MVP
- Razón: Funding deadline
- Impacto: Priorizar features core, aplazar nice-to-have
```

### Regulatory Constraints

```
C-8: PCI-DSS Compliance
- Razón: Payment processing
- Impacto: Encrypt payment data, audit logs

C-9: Acceptable Use Policy
- Razón: AWS requirements
- Impacto: No puede ser usado para cosas ilegales
```

### Business Constraints

```
C-10: Cost: <$2k/month
- Razón: Budget approval
- Impacto: usar AWS free tier + cheap instances

C-11: License: Open Source Only
- Razón: No licensing budget
- Impacto: No software comercial (JetBrains, etc)
```

---

## Cómo Guían Decisiones Arquitectónicas

Las constraints **limitan** qué soluciones son posibles:

```
Constraint: "Java only"
     ↓
Impact: No podemos usar Node.js, Go, Python
     ↓
Solution Strategy debe usar Java

Constraint: "AWS only"
     ↓
Impact: Arquitectura basada en AWS services
     ↓
Solution Strategy usa EC2, RDS, S3, Lambda

Constraint: "3 developers"
     ↓
Impact: Arquitectura debe ser simple de mantener
     ↓
Solution Strategy: Monolito bien estructurado, no microservicios
```

---

## Checklist para Constraints

### Contenido
- [ ] Constraints bien categorizados
- [ ] Razón clara para cada constraint
- [ ] Impacto documentado
- [ ] No confundir con Quality Goals
- [ ] Todas las categorías consideradas

### Estructura
- [ ] Matriz clara
- [ ] Lenguaje consistente
- [ ] Completo
- [ ] Prioridades si aplica
- [ ] Trazabilidad

### Trazabilidad
- [ ] Conectado a Quality Goals (1.2)
- [ ] Conectado a Requirements (1.1)
- [ ] Impacto en Solution Strategy (3)

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Confundir con Quality Goals ("sistema debe ser rápido")
- Constraints que pueden cambiar (son impuestos, no elegidos)
- Demasiados constraints (pierde enfoque)
- Constraints sin razón (documentar por qué)
- Ignorar impacto en arquitectura
```

### HACER:
```
- Categorizar por tipo
- Documentar razón clara
- Documentar impacto
- Usar como guía para Solution Strategy
- Revisar periódicamente (pueden cambiar)
```

---

## Diferencias con Otras Secciones

**Constraints (2) vs Quality Goals (1.2):**
- Quality Goals: Lo que DESEAMOS
- Constraints: Lo que NOS LIMITA

**Constraints (2) vs Requirements (1.1):**
- Requirements: QUÉ hace el sistema
- Constraints: QUÉ LIMITA cómo lo hace

**Constraints (2) vs Solution Strategy (3):**
- Constraints: Las limitaciones
- Solution Strategy: CÓMO trabajamos dentro de ellas

---

## Template para Constraints

Usar: [constraints.md.template](../assets/constraints.md.template)

**Estructura del documento:**
```
# Constraints: [Nombre del proyecto]

## Technical Constraints
[Tabla con constraint, razón, impacto]

## Platform Constraints
[Tabla con constraint, razón, impacto]

## Organizational Constraints
[Tabla con constraint, razón, impacto]

## Regulatory Constraints
[Tabla con constraint, razón, impacto]

## Business Constraints
[Tabla con constraint, razón, impacto]

## Validation
[Checklist]
```

---

## Próximo Paso

Una vez completado: → Pasar a [context](./context.md)

---

**Última actualización**: 2026-02-01
