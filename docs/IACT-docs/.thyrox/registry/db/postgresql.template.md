<!-- SKILL_START -->
```yml
name: db-postgresql
description: "Skill de tecnología para bases de datos PostgreSQL. Usar cuando se trabaje en migraciones, queries, índices, o schema en el proyecto {{PROJECT_NAME}}. Invocar durante Phase 4 STRUCTURE para especificar el schema y relaciones, durante Phase 6 EXECUTE para implementar migraciones y queries, y durante Phase 7 TRACK para revisar performance y consistencia de la base de datos."
layer: db
framework: postgresql
project: {{PROJECT_NAME}}
```

# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — SKILL

Guía fase-por-fase para trabajar con PostgreSQL en el proyecto {{PROJECT_NAME}}.

---

## Phase 1: ANALYZE — Qué investigar en features con PostgreSQL

Al analizar un feature que toca la base de datos, cubrir:
- Tablas afectadas — ¿nuevas, modificadas, eliminadas?
- Relaciones — ¿nuevas foreign keys, cambios en cardinalidad?
- Volumen de datos — ¿cuántos registros esperados? ¿crece rápido?
- Queries principales — ¿qué consultas hará este feature con más frecuencia?
- Índices necesarios — ¿qué columnas se filtran o se ordenan?

## Phase 4: STRUCTURE — Qué especificar para features de DB

En `requirements-spec.md`, incluir por cada tabla nueva/modificada:
- Nombre (snake_case), propósito, columnas con tipo y constraints
- Foreign keys y comportamiento en cascade (ON DELETE, ON UPDATE)
- Índices necesarios con justificación
- Migraciones requeridas: UP (aplicar) y DOWN (revertir)

## Phase 6: EXECUTE — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Migración UP — crear/modificar tablas e índices
2. Verificar con `\d tabla` en psql
3. Queries de la aplicación usando la nueva estructura
4. Migración DOWN — revertir todo lo del UP
5. Test: aplicar UP, verificar, aplicar DOWN, verificar

## Phase 7: TRACK — Qué revisar al cerrar

- Todas las migraciones tienen UP y DOWN funcionales
- Queries nuevas tienen `EXPLAIN ANALYZE` verificado (sin Seq Scan en tablas grandes)
- No hay queries con `SELECT *` en código de producción
- Índices nuevos no duplican índices existentes
- Columnas `NOT NULL` tienen `DEFAULT` o la app siempre las provee
<!-- SKILL_END -->

<!-- INSTRUCTIONS_START -->
# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — Guidelines

Reglas siempre activas para el proyecto {{PROJECT_NAME}}. Aplicar en todo trabajo con PostgreSQL.

---

## Regla 1: Naming snake_case para todo — tablas, columnas, índices

PostgreSQL es case-insensitive por defecto. Usar snake_case evita comillas dobles.

```sql
-- CORRECTO
CREATE TABLE user_profiles (
  id          SERIAL PRIMARY KEY,
  user_id     INTEGER NOT NULL REFERENCES users(id),
  full_name   VARCHAR(255) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- INCORRECTO
CREATE TABLE "UserProfiles" (
  "Id"        SERIAL PRIMARY KEY,
  "UserId"    INTEGER NOT NULL,
  "FullName"  VARCHAR(255)
);
```

## Regla 2: Migraciones versionadas con UP y DOWN

Cada migración tiene rollback. Sin DOWN, no existe migración.

```sql
-- migrations/0042_add_user_profiles.sql

-- UP
CREATE TABLE user_profiles (
  id         SERIAL PRIMARY KEY,
  user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  bio        TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- DOWN
DROP INDEX IF EXISTS idx_user_profiles_user_id;
DROP TABLE IF EXISTS user_profiles;
```

## Regla 3: Índices en columnas filtradas — no indexar todo

Crear índice cuando la columna aparece en WHERE, JOIN ON, o ORDER BY con tablas > 10k filas.

```sql
-- CORRECTO — índice justificado por query frecuente
-- Query: SELECT * FROM orders WHERE customer_id = $1 AND status = 'pending'
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);

-- INCORRECTO — indexar todo por si acaso
CREATE INDEX idx_orders_created_at ON orders(created_at);     -- si no se filtra por fecha
CREATE INDEX idx_orders_notes ON orders(notes);               -- texto libre, usar FTS en su lugar
```

## Regla 4: Evitar N+1 — usar JOINs o carga por lotes

No hacer queries en bucles. Un query por colección, no uno por elemento.

```js
// CORRECTO — un query con JOIN
const orders = await db.query(`
  SELECT o.*, u.name as customer_name
  FROM orders o
  JOIN users u ON u.id = o.customer_id
  WHERE o.status = $1
`, ['pending']);

// INCORRECTO — N+1
const orders = await db.query("SELECT * FROM orders WHERE status = 'pending'");
for (const order of orders.rows) {
  const user = await db.query('SELECT * FROM users WHERE id = $1', [order.customer_id]);
  order.customer = user.rows[0]; // un query por order
}
```

## Regla 5: Transacciones explícitas para operaciones multi-tabla

Cuando se escriben 2+ tablas relacionadas, usar transacción.

```js
// CORRECTO
const client = await pool.connect();
try {
  await client.query('BEGIN');
  const order = await client.query('INSERT INTO orders (...) VALUES (...) RETURNING id', [...]);
  await client.query('INSERT INTO order_items (order_id, ...) VALUES ($1, ...)', [order.rows[0].id, ...]);
  await client.query('COMMIT');
} catch (err) {
  await client.query('ROLLBACK');
  throw err;
} finally {
  client.release();
}

// INCORRECTO — dos inserts sin transacción
await db.query('INSERT INTO orders ...'); // si falla el siguiente, queda huérfano
await db.query('INSERT INTO order_items ...');
```

## Regla 6: SELECT con columnas explícitas — nunca SELECT * en producción

```sql
-- CORRECTO
SELECT id, email, full_name, created_at FROM users WHERE id = $1;

-- INCORRECTO — en código de producción
SELECT * FROM users WHERE id = $1;
-- Razones: trae columnas innecesarias, rompe si se agrega columna sensitive,
-- impide usar índices covering
```
<!-- INSTRUCTIONS_END -->
