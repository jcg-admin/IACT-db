---
id: TASK-REORG-BACK-049
tipo: tarea
categoria: metodologias
titulo: Crear clean-architecture.md
fase: FASE_3
prioridad: BAJA
duracion_estimada: 25min
estado: pendiente
dependencias: []
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-049: Crear clean-architecture.md

**Fase:** FASE 3 - Metodologias y Mejores Practicas
**Prioridad:** BAJA
**Duracion Estimada:** 25 minutos
**Responsable:** Arquitecto de Software / Tech Lead
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT (Auto-Chain of Thought), Self-Consistency

---

## Objetivo

Crear guia de Clean Architecture (Arquitectura Limpia) adaptada al backend del proyecto, explicando principios SOLID, separacion en capas, dependency inversion, y como aplicar estos conceptos en Node.js/Python/Go.

---

## Prerequisitos

- [ ] Conocimiento de principios SOLID
- [ ] Comprension de arquitectura en capas
- [ ] Lectura de "Clean Architecture" de Robert C. Martin (recomendado)
- [ ] Revision de arquitectura actual del proyecto

---

## Pasos de Ejecucion

### Paso 1: Crear Archivo clean-architecture.md

```bash
touch /home/user/IACT/docs/backend/metodologias/clean-architecture.md
```

Contenido (versión resumida para brevedad):

```markdown
---
id: METODOLOGIA-CLEAN-ARCHITECTURE
tipo: metodologia
categoria: arquitectura
titulo: Clean Architecture para Backend
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Clean Architecture - Backend

Guia de Arquitectura Limpia para desarrollo backend basada en principios de Robert C. Martin (Uncle Bob).

## Principios Fundamentales

### 1. Independencia de Frameworks
El core del negocio NO debe depender de frameworks externos.

### 2. Testabilidad
La logica de negocio es testeable sin UI, DB, o servicios externos.

### 3. Independencia de UI
La UI puede cambiar sin afectar reglas de negocio.

### 4. Independencia de Base de Datos
Las reglas de negocio no estan atadas a una DB especifica.

### 5. Independencia de Agentes Externos
La logica de negocio no sabe nada de APIs, queues, etc.

---

## Capas de Clean Architecture

```

 Entities (Core Domain) ← Reglas de negocio
 • User, Product, Order mas estables
 • Business rules 

 ↑ depends on

 Use Cases (Application Logic) ← Logica especifica
 • CreateUser, ProcessPayment de la aplicacion
 • Orchestration 

 ↑ depends on

 Interface Adapters (Controllers, ← Traduccion entre
 Presenters, Gateways) casos de uso y
 • REST Controllers, GraphQL Resolvers mundo externo
 • Repository implementations 

 ↑ depends on

 Frameworks & Drivers (External) ← Detalles de
 • Express, Fastify, NestJS implementacion
 • PostgreSQL, MongoDB, Redis 
 • AWS SDK, SendGrid, Stripe 

```

**Regla de Dependencias:**
→ Las dependencias apuntan **HACIA ADENTRO**
→ Capas internas NO conocen capas externas
→ Inversion de dependencias via interfaces

---

## Estructura de Carpetas Backend

### Opcion A: Por Capas
```
src/
 domain/ # Entities + Business Rules
 entities/
 value-objects/
 interfaces/ # Port interfaces
 application/ # Use Cases
 use-cases/
 dto/
 infrastructure/ # Adapters & External
 database/ # Repository implementations
 http/ # Controllers, routes
 external/ # APIs, queues
 config/
 main/ # Dependency injection, server bootstrap
```

### Opcion B: Por Features (Screaming Architecture)
```
src/
 users/
 domain/
 application/
 infrastructure/
 interfaces/
 orders/
 domain/
 application/
 infrastructure/
 interfaces/
 shared/ # Shared kernel
```

---

## SOLID Principles

### S - Single Responsibility Principle
**Una clase debe tener una sola razon para cambiar.**

```typescript
// [ERROR] WRONG: Multiple responsibilities
class UserService {
 createUser(data) { /* ... */ }
 sendEmail(user) { /* ... */ }
 logActivity(activity) { /* ... */ }
}

// [OK] CORRECT: Single responsibility per class
class UserService {
 createUser(data) { /* ... */ }
}

class EmailService {
 sendEmail(user) { /* ... */ }
}

class ActivityLogger {
 logActivity(activity) { /* ... */ }
}
```

### O - Open/Closed Principle
**Abierto a extension, cerrado a modificacion.**

### L - Liskov Substitution Principle
**Subtipos deben ser sustituibles por sus tipos base.**

### I - Interface Segregation Principle
**Clientes no deben depender de interfaces que no usan.**

### D - Dependency Inversion Principle
**Depender de abstracciones, no de concreciones.**

```typescript
// [ERROR] WRONG: Depende de concreción
class OrderService {
 constructor() {
 this.repository = new PostgresOrderRepository(); // Hardcoded!
 }
}

// [OK] CORRECT: Depende de abstracción
interface OrderRepository {
 save(order: Order): Promise<Order>;
 findById(id: string): Promise<Order>;
}

class OrderService {
 constructor(private repository: OrderRepository) {} // Injected!
}
```

---

## Ejemplo Practico: Feature "Create User"

### 1. Entity (Domain Layer)
```typescript
// src/domain/entities/user.entity.ts
export class User {
 constructor(
 public readonly id: string,
 public email: Email, // Value Object
 public name: string,
 public status: UserStatus
 ) {}

 activate(): void {
 if (this.status === UserStatus.Active) {
 throw new Error('User already active');
 }
 this.status = UserStatus.Active;
 }
}
```

### 2. Use Case (Application Layer)
```typescript
// src/application/use-cases/create-user.use-case.ts
export class CreateUserUseCase {
 constructor(
 private userRepository: UserRepository,
 private emailService: EmailService
 ) {}

 async execute(dto: CreateUserDto): Promise<UserDto> {
 const user = new User(
 generateId(),
 new Email(dto.email),
 dto.name,
 UserStatus.Pending
 );

 await this.userRepository.save(user);
 await this.emailService.sendWelcome(user.email);

 return UserDto.fromEntity(user);
 }
}
```

### 3. Repository Interface (Domain Layer)
```typescript
// src/domain/interfaces/user.repository.ts
export interface UserRepository {
 save(user: User): Promise<User>;
 findById(id: string): Promise<User | null>;
 findByEmail(email: Email): Promise<User | null>;
}
```

### 4. Repository Implementation (Infrastructure Layer)
```typescript
// src/infrastructure/database/postgres-user.repository.ts
export class PostgresUserRepository implements UserRepository {
 constructor(private db: Database) {}

 async save(user: User): Promise<User> {
 const result = await this.db.query(
 'INSERT INTO users (id, email, name, status) VALUES ($1, $2, $3, $4)',
 [user.id, user.email.value, user.name, user.status]
 );
 return user;
 }

 async findById(id: string): Promise<User | null> {
 const row = await this.db.queryOne('SELECT * FROM users WHERE id = $1', [id]);
 return row ? this.toDomain(row) : null;
 }

 private toDomain(row: any): User {
 return new User(row.id, new Email(row.email), row.name, row.status);
 }
}
```

### 5. Controller (Infrastructure Layer)
```typescript
// src/infrastructure/http/controllers/user.controller.ts
export class UserController {
 constructor(private createUserUseCase: CreateUserUseCase) {}

 async create(req: Request, res: Response): Promise<void> {
 try {
 const dto = CreateUserDto.fromRequest(req.body);
 const user = await this.createUserUseCase.execute(dto);
 res.status(201).json(user);
 } catch (error) {
 res.status(400).json({ error: error.message });
 }
 }
}
```

### 6. Dependency Injection (Main Layer)
```typescript
// src/main/di-container.ts
const db = new PostgresDatabase(config.database);
const userRepository = new PostgresUserRepository(db);
const emailService = new SendGridEmailService(config.sendgrid);
const createUserUseCase = new CreateUserUseCase(userRepository, emailService);
const userController = new UserController(createUserUseCase);

// src/main/server.ts
app.post('/users', (req, res) => userController.create(req, res));
```

---

## Beneficios de Clean Architecture

1. **Testabilidad:** Tests sin DB, sin HTTP, sin frameworks
2. **Flexibilidad:** Cambiar DB de Postgres a Mongo sin tocar domain
3. **Mantenibilidad:** Cambios localizados en una capa
4. **Independencia:** No lock-in con frameworks
5. **Claridad:** Separacion clara de responsabilidades

---

## Trade-offs

### Ventajas
- [OK] Codigo altamente testeable
- [OK] Bajo acoplamiento
- [OK] Facil de refactorizar

### Desventajas
- [ERROR] Mas boilerplate inicial
- [ERROR] Curva de aprendizaje
- [ERROR] Puede ser overkill para apps simples

**Cuando usar Clean Architecture:**
- Proyectos grandes (>10k LOC)
- Multiples bounded contexts
- Equipo grande (>5 devs)
- Larga vida esperada del proyecto

**Cuando NO usar:**
- MVPs rapidos
- Proyectos pequeños (<1k LOC)
- Prototipos

---

## Referencias

- **Libro:** "Clean Architecture" - Robert C. Martin
- **Video:** [Clean Architecture in Node.js](https://www.youtube.com/watch?v=CnailTcJV_U)
- **Ejemplo:** [Node.js Clean Architecture](https://github.com/jbuget/nodejs-clean-architecture-app)

---

**Documento creado:** 2025-11-18
**Version:** 1.0.0
```

**Resultado Esperado:** clean-architecture.md creado

---

## Criterios de Exito

- [ ] clean-architecture.md creado en docs/backend/metodologias/
- [ ] Principios fundamentales explicados
- [ ] Diagrama de capas incluido
- [ ] SOLID principles documentados
- [ ] Ejemplo practico completo (Create User)
- [ ] Estructura de carpetas sugerida
- [ ] Beneficios y trade-offs listados
- [ ] Referencias incluidas

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] clean-architecture.md creado
- [ ] Contenido completo y validado
- [ ] Ejemplos de codigo incluidos
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
