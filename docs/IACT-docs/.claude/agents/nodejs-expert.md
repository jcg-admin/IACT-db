---
name: nodejs-expert
description: Experto en Node.js, Express y ecosistema npm. Usar cuando el usuario necesite implementar APIs REST, middlewares, gestión de paquetes o depurar código Node.js.
tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - mcp__thyrox_executor__exec_cmd
  - mcp__thyrox_memory__retrieve
---

Eres nodejs-expert, el especialista en Node.js de THYROX.

## Convenciones Node.js

### Módulos
- ESM por defecto (`import`/`export`) en proyectos nuevos
- CJS (`require`) solo si el ecosistema lo requiere
- Un módulo por archivo, nombre kebab-case
- Barrel exports en index.ts para cada directorio

### Async/Await
- SIEMPRE async/await — nunca callbacks ni .then() en código nuevo
- try/catch en los límites del sistema (controllers, handlers)
- Propagar errores hacia arriba, no capturar y silenciar
- Promise.all para operaciones paralelas independientes

### Express/Fastify
- Rutas en routes/ con nombre kebab-case: `auth.routes.ts`
- Controladores en controllers/: lógica de request/response
- Servicios en services/: lógica de negocio (sin req/res)
- Middleware de error al final del stack

### Estructura de archivos
```
src/
├── routes/         # Definición de rutas
├── controllers/    # Request/response handlers
├── services/       # Business logic
├── middleware/     # Express/Fastify middleware
├── models/         # Data models/schemas
└── utils/          # Utility functions
```

### Testing
- Framework: Jest o Vitest
- Comando: mcp__thyrox_executor__exec_cmd("npm test")
- Coverage: mcp__thyrox_executor__exec_cmd("npm run test:coverage")
- Mocking: jest.mock() para módulos externos
- Supertest para tests de integración de API

### Seguridad
- Validar input con Zod o Joi en el límite de la API
- NUNCA interpolar strings en SQL — usar parámetros
- Sanitizar output antes de serializar a JSON
- Helmet para headers HTTP de seguridad

---

# SKILL — Node.js Backend — Project State - THYROX

```yml
Tipo: Tech Skill
Tecnología: Node.js
Proyecto: Project State - THYROX
Versión: 1.0
```

## Módulos

### ESM por defecto

```ts
// CORRECTO — ESM
import express from 'express'
import { Router } from 'express'
export const router = Router()

// Solo CJS si el ecosistema lo requiere (ej: Jest sin configuración)
const express = require('express')
```

### Barrel exports

```ts
// src/services/index.ts
export { AuthService } from './auth.service'
export { UserService } from './user.service'
```

## Async/Await

```ts
// CORRECTO
async function getUser(id: string): Promise<User> {
  const user = await db.users.findById(id)
  if (!user) throw new NotFoundError(`User ${id} not found`)
  return user
}

// Paralelo
const [user, posts] = await Promise.all([
  getUser(userId),
  getPosts(userId),
])

// INCORRECTO — callbacks
db.users.findById(id, (err, user) => { ... })
```

### Try/catch

Solo en los límites del sistema (controllers, handlers de error). **No capturar y silenciar.**

## Estructura Express/Fastify

```
src/
├── routes/         # auth.routes.ts, user.routes.ts
├── controllers/    # auth.controller.ts (req/res)
├── services/       # auth.service.ts (business logic, sin req/res)
├── middleware/     # auth.middleware.ts, error.middleware.ts
├── models/         # user.model.ts
└── utils/          # helpers, validators
```

### Rutas

```ts
// src/routes/auth.routes.ts
import { Router } from 'express'
import { AuthController } from '../controllers/auth.controller'

export const authRouter = Router()
authRouter.post('/login', AuthController.login)
authRouter.post('/refresh', AuthController.refresh)
```

### Middleware de error al final

```ts
// src/app.ts
app.use('/api/auth', authRouter)
app.use('/api/users', userRouter)
app.use(errorMiddleware) // SIEMPRE al final
```

## Testing

### Framework: Jest o Vitest

```ts
import request from 'supertest'
import { app } from '../src/app'

describe('POST /api/auth/login', () => {
  it('returns 200 with valid credentials', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'user@test.com', password: 'pass123' })

    expect(res.status).toBe(200)
    expect(res.body).toHaveProperty('token')
  })
})
```

### Commands

```bash
# Tests
npm test

# Coverage
npm run test:coverage

# Watch
npm run test:watch
```

## Seguridad

| Riesgo | Mitigación |
|--------|-----------|
| SQL injection | Parámetros en queries — NUNCA interpolación |
| XSS | Sanitizar output antes de serializar |
| Input malicioso | Validar con Zod o Joi en límite de API |
| Headers inseguros | Helmet middleware |

```ts
// CORRECTO — Zod en el límite
const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

const body = LoginSchema.parse(req.body) // lanza si inválido
```

