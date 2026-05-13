---
id: TASK-REORG-BACK-052
tipo: tarea
categoria: varios
titulo: Crear Ejemplos de Codigo
fase: FASE_3
prioridad: MEDIA
duracion_estimada: 30min
estado: pendiente
dependencias: [TASK-048, TASK-049]
---

# TASK-REORG-BACK-052: Crear Ejemplos de Codigo

**Fase:** FASE 3 - Documentacion Varia
**Prioridad:** MEDIA
**Duracion Estimada:** 30 minutos
**Responsable:** Tech Lead / Desarrollador Senior
**Estado:** PENDIENTE
**Dependencias:** TASK-048 (TDD), TASK-049 (Clean Architecture)

---

## Objetivo

Crear carpeta de ejemplos de codigo (code-examples/) con snippets reutilizables y ejemplos practicos de patrones comunes en el backend.

---

## Pasos de Ejecucion

### Paso 1: Crear Estructura de Ejemplos

```bash
mkdir -p /home/user/IACT/docs/backend/code-examples/{patterns,testing,api,database}

# Crear README principal
cat > /home/user/IACT/docs/backend/code-examples/README.md << 'EOF'
# Ejemplos de Codigo - Backend

Snippets y ejemplos practicos de patrones comunes.

## Categorias

- **patterns/** - Patrones de diseño (Repository, Factory, Strategy)
- **testing/** - Ejemplos de tests (unit, integration, e2e)
- **api/** - Ejemplos de REST endpoints, middleware
- **database/** - Queries, migrations, repository patterns

## Como Usar

1. Copiar snippet relevante
2. Adaptar a tu caso de uso
3. Seguir convenciones del proyecto

Ver documentacion detallada en cada carpeta.
EOF
```

### Paso 2: Crear Ejemplos de Patrones

```bash
cat > /home/user/IACT/docs/backend/code-examples/patterns/repository-pattern.ts << 'EOF'
// Repository Pattern Example

// Interface (Domain Layer)
interface UserRepository {
 findById(id: string): Promise<User | null>;
 findByEmail(email: string): Promise<User | null>;
 save(user: User): Promise<User>;
 delete(id: string): Promise<void>;
}

// Implementation (Infrastructure Layer)
class PostgresUserRepository implements UserRepository {
 constructor(private db: Database) {}

 async findById(id: string): Promise<User | null> {
 const row = await this.db.query('SELECT * FROM users WHERE id = $1', [id]);
 return row ? this.mapToDomain(row) : null;
 }

 async save(user: User): Promise<User> {
 await this.db.query(
 'INSERT INTO users (id, email, name) VALUES ($1, $2, $3) ON CONFLICT (id) DO UPDATE SET email = $2, name = $3',
 [user.id, user.email, user.name]
 );
 return user;
 }

 private mapToDomain(row: any): User {
 return new User(row.id, row.email, row.name);
 }
}

// Usage
const repository = new PostgresUserRepository(db);
const user = await repository.findById('123');
EOF

cat > /home/user/IACT/docs/backend/code-examples/patterns/factory-pattern.ts << 'EOF'
// Factory Pattern Example

interface Notification {
 send(message: string): Promise<void>;
}

class EmailNotification implements Notification {
 async send(message: string): Promise<void> {
 // Send email
 }
}

class SMSNotification implements Notification {
 async send(message: string): Promise<void> {
 // Send SMS
 }
}

class NotificationFactory {
 static create(type: 'email' | 'sms'): Notification {
 switch (type) {
 case 'email':
 return new EmailNotification();
 case 'sms':
 return new SMSNotification();
 default:
 throw new Error(`Unknown notification type: ${type}`);
 }
 }
}

// Usage
const notification = NotificationFactory.create('email');
await notification.send('Hello!');
EOF
```

### Paso 3: Crear Ejemplos de Testing

```bash
cat > /home/user/IACT/docs/backend/code-examples/testing/unit-test-example.spec.ts << 'EOF'
// Unit Test Example with Mocks

describe('OrderService', () => {
 let service: OrderService;
 let mockPaymentGateway: jest.Mocked<PaymentGateway>;
 let mockOrderRepo: jest.Mocked<OrderRepository>;

 beforeEach(() => {
 mockPaymentGateway = {
 charge: jest.fn(),
 refund: jest.fn(),
 } as any;

 mockOrderRepo = {
 save: jest.fn(),
 findById: jest.fn(),
 } as any;

 service = new OrderService(mockPaymentGateway, mockOrderRepo);
 });

 it('should process order successfully', async () => {
 // Arrange
 const order = { id: '1', total: 100, status: 'pending' };
 mockOrderRepo.findById.mockResolvedValue(order);
 mockPaymentGateway.charge.mockResolvedValue({ success: true });

 // Act
 const result = await service.processOrder('1');

 // Assert
 expect(result.success).toBe(true);
 expect(mockPaymentGateway.charge).toHaveBeenCalledWith(100);
 expect(mockOrderRepo.save).toHaveBeenCalled();
 });
});
EOF
```

### Paso 4: Crear Ejemplos de API

```bash
cat > /home/user/IACT/docs/backend/code-examples/api/rest-endpoint-example.ts << 'EOF'
// REST API Endpoint Example

import { Router } from 'express';

const router = Router();

// GET /users/:id
router.get('/users/:id', async (req, res) => {
 try {
 const user = await userService.findById(req.params.id);
 if (!user) {
 return res.status(404).json({ error: 'User not found' });
 }
 res.json(user);
 } catch (error) {
 res.status(500).json({ error: 'Internal server error' });
 }
});

// POST /users
router.post('/users', async (req, res) => {
 try {
 const user = await userService.create(req.body);
 res.status(201).json(user);
 } catch (error) {
 res.status(400).json({ error: error.message });
 }
});

export default router;
EOF
```

**Resultado Esperado:** Ejemplos de codigo creados

---

## Criterios de Exito

- [ ] Carpeta code-examples/ creada
- [ ] README.md en code-examples/
- [ ] 2+ ejemplos de patrones (Repository, Factory)
- [ ] 1+ ejemplo de testing
- [ ] 1+ ejemplo de API endpoint
- [ ] Codigo funcional y comentado

---

**Tarea creada:** 2025-11-18
**Estado:** PENDIENTE
