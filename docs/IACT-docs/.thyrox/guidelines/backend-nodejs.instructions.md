# Backend Node.js — Guidelines

Reglas siempre activas para el proyecto thyrox. Aplicar en toda implementación Node.js.

---

## Regla 1: Estructura en capas — sin lógica de negocio en handlers

Los handlers solo orquestan. La lógica vive en services.

```js
// CORRECTO
async function createUserHandler(req, res) {
  const dto = validate(createUserSchema, req.body); // valida
  const user = await userService.create(dto);        // delega
  res.status(201).json(user);                        // responde
}

// INCORRECTO — lógica de negocio en el handler
async function createUserHandler(req, res) {
  const hashedPassword = await bcrypt.hash(req.body.password, 10);
  const existing = await db.query('SELECT * FROM users WHERE email = $1', [req.body.email]);
  if (existing.rows.length > 0) return res.status(409).json({ error: 'Email ya existe' });
  const user = await db.query('INSERT INTO users ...', [...]);
  res.status(201).json(user.rows[0]);
}
```

## Regla 2: Async/await con manejo de errores explícito

Toda operación async usa try/catch o pasa errores al middleware con `next(err)`.

```js
// CORRECTO
async function getUser(req, res, next) {
  try {
    const user = await userService.findById(req.params.id);
    if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(user);
  } catch (err) {
    next(err); // pasa al error middleware
  }
}

// INCORRECTO — promesas sin catch
async function getUser(req, res) {
  const user = await userService.findById(req.params.id); // sin try/catch
  res.json(user);
}
```

## Regla 3: Validación de input en el boundary — nunca confiar en el cliente

Todo input externo se valida antes de llegar al service.

```js
// CORRECTO — schema de validación explícito
const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  role: z.enum(['user', 'admin']).default('user'),
});

// INCORRECTO — usar req.body directamente
const user = await userService.create(req.body); // req.body sin validar
```

## Regla 4: Variables de entorno para toda configuración externa

Sin valores hardcodeados para hosts, puertos, secrets, o URLs.

```js
// CORRECTO
const dbUrl = process.env.DATABASE_URL;
const jwtSecret = process.env.JWT_SECRET;
const port = parseInt(process.env.PORT, 10) || 3000;

// INCORRECTO
const dbUrl = 'postgresql://admin:password123@localhost:5432/mydb';
const jwtSecret = 'super-secret-key';
```

## Regla 5: Errores al cliente sin detalles internos

Los errores de producción no exponen stack traces ni mensajes internos.

```js
// CORRECTO — error handler centralizado
app.use((err, req, res, next) => {
  const status = err.status || 500;
  const message = status < 500 ? err.message : 'Error interno del servidor';
  res.status(status).json({ error: message });
  if (status >= 500) logger.error(err); // log interno
});

// INCORRECTO — exponer stack trace al cliente
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message, stack: err.stack });
});
```

## Regla 6: Naming en kebab-case para archivos, camelCase para variables

```js
// CORRECTO
// archivo: user-service.js
function getUserById(userId) { ... }
const userRepository = require('./user-repository');

// INCORRECTO
// archivo: UserService.js o userService.js
function GetUserById(userId) { ... }
const UserRepository = require('./UserRepository');
```
