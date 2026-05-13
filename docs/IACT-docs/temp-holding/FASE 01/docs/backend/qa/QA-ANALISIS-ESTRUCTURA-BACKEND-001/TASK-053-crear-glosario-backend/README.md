---
id: TASK-REORG-BACK-053
tipo: tarea
categoria: varios
titulo: Crear GLOSARIO-BACKEND.md
fase: FASE_3
prioridad: BAJA
duracion_estimada: 25min
estado: pendiente
dependencias: []
---

# TASK-REORG-BACK-053: Crear GLOSARIO-BACKEND.md

**Fase:** FASE 3 - Documentacion Varia
**Prioridad:** BAJA
**Duracion Estimada:** 25 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear glosario de terminos tecnicos del backend para facilitar onboarding de nuevos miembros y clarificar terminologia del proyecto.

---

## Pasos de Ejecucion

### Paso 1: Crear GLOSARIO-BACKEND.md

```bash
cat > /home/user/IACT/docs/backend/GLOSARIO-BACKEND.md << 'EOF'
# Glosario Backend

Definiciones de terminos tecnicos usados en el backend.

---

## A

**ADR (Architecture Decision Record)**
Documento que captura una decision arquitectonica importante, incluyendo contexto, opciones consideradas, decision tomada y consecuencias.

**API (Application Programming Interface)**
Conjunto de endpoints que exponen funcionalidad del backend a clientes externos.

**API Gateway**
Punto de entrada unico para todas las peticiones a microservicios, manejando routing, autenticacion, rate limiting, etc.

---

## B

**Bounded Context**
Concepto de DDD que define limites explicitos donde un modelo de dominio aplica.

**BFF (Backend For Frontend)**
Patron donde se crea un backend especifico para cada tipo de frontend (web, mobile, etc.).

---

## C

**CQRS (Command Query Responsibility Segregation)**
Patron que separa operaciones de lectura (queries) y escritura (commands).

**Circuit Breaker**
Patron de resiliencia que previene llamadas a servicios que estan fallando.

**Clean Architecture**
Arquitectura en capas propuesta por Robert C. Martin que enfatiza independencia de frameworks y bases de datos.

---

## D

**DTO (Data Transfer Object)**
Objeto simple usado para transferir datos entre capas o servicios.

**DDD (Domain-Driven Design)**
Enfoque de diseño de software que pone el dominio del negocio en el centro.

**Dependency Injection**
Patron de diseño donde las dependencias de una clase son inyectadas externamente en lugar de ser creadas internamente.

---

## E

**Entity**
Objeto de dominio con identidad unica que persiste en el tiempo.

**Event Sourcing**
Patron donde el estado se deriva de una secuencia de eventos en lugar de almacenar estado actual.

---

## H

**HPA (Horizontal Pod Autoscaler)**
Componente de Kubernetes que escala automaticamente pods basado en metricas.

---

## I

**IaC (Infrastructure as Code)**
Practica de gestionar infraestructura mediante codigo versionado (ej: Terraform).

**Idempotencia**
Propiedad de una operacion que produce el mismo resultado si se ejecuta una o multiples veces.

---

## M

**Microservicio**
Servicio pequeño, independiente, desplegable de forma autonoma que hace una cosa bien.

**Middleware**
Componente que intercepta requests/responses en un pipeline HTTP.

**MTTR (Mean Time To Repair)**
Tiempo promedio para reparar un sistema tras una falla.

---

## O

**ORM (Object-Relational Mapping)**
Tecnica de mapear objetos de codigo a tablas de base de datos relacional.

**Observability**
Capacidad de entender el estado interno de un sistema basado en sus outputs (logs, metrics, traces).

---

## R

**Repository Pattern**
Patron que abstrae acceso a datos, proporcionando interfaz de coleccion.

**REST (Representational State Transfer)**
Estilo arquitectonico para APIs basado en HTTP y recursos.

---

## S

**SOLID**
5 principios de diseño orientado a objetos: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.

**SLA (Service Level Agreement)**
Acuerdo formal sobre nivel de servicio esperado.

**SLO (Service Level Objective)**
Objetivo medible de nivel de servicio (ej: 99.9% uptime).

**SLI (Service Level Indicator)**
Metrica que mide un aspecto del nivel de servicio (ej: latencia, error rate).

---

## T

**TDD (Test-Driven Development)**
Practica de escribir tests antes que codigo de produccion.

**Throughput**
Cantidad de operaciones procesadas por unidad de tiempo.

---

## U

**Use Case**
Logica de aplicacion especifica que orquesta entidades de dominio para cumplir un objetivo.

**Uptime**
Porcentaje de tiempo que un sistema esta disponible y funcionando.

---

## V

**Value Object**
Objeto de dominio sin identidad, definido por sus valores (ej: Email, Money).

---

**Ultima actualizacion:** 2025-11-18
EOF
```

**Resultado Esperado:** GLOSARIO-BACKEND.md creado

---

## Criterios de Exito

- [ ] GLOSARIO-BACKEND.md creado en docs/backend/
- [ ] 30+ terminos definidos
- [ ] Organizacion alfabetica
- [ ] Definiciones claras y concisas
- [ ] Terminos relevantes al proyecto

---

**Tarea creada:** 2025-11-18
**Estado:** PENDIENTE
