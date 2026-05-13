# DB MySQL — Guidelines

Reglas siempre activas para trabajar con MySQL en thyrox.

## Naming

```sql
-- CORRECTO
CREATE TABLE order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_items_users FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_order_items_user_id (user_id)
);

-- INCORRECTO
CREATE TABLE OrderItem (
  ID INT,
  UserId INT,
  -- sin FK, sin índice, sin charset
);
```

## Prepared statements siempre

```javascript
// CORRECTO — prepared statement (knex)
const users = await db('users').where({ email }).select('id', 'name');

// INCORRECTO — interpolación directa
const users = await db.raw(`SELECT * FROM users WHERE email = '${email}'`);
```

## Charset explícito en tablas con texto

```sql
-- CORRECTO
CREATE TABLE posts (
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- INCORRECTO — charset implícito puede variar por servidor
CREATE TABLE posts (
  title VARCHAR(255),
  body TEXT
);
```

## Índice en cada foreign key

```sql
-- CORRECTO
ALTER TABLE orders ADD CONSTRAINT fk_orders_users
  FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE orders ADD INDEX idx_orders_user_id (user_id);  -- índice explícito

-- INCORRECTO — FK sin índice en MySQL = full scan al hacer JOIN
ALTER TABLE orders ADD CONSTRAINT fk_orders_users
  FOREIGN KEY (user_id) REFERENCES users(id);
-- sin índice → JOIN lento
```

## EXPLAIN antes de indexar

```sql
-- CORRECTO — analizar antes de crear índice
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1 AND status = 'pending';
-- Revisar "Using filesort" o "Full table scan" → candidatos a índice

-- Solo entonces crear el índice
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```

## Transacciones para operaciones multi-tabla

```javascript
// CORRECTO (knex)
await db.transaction(async (trx) => {
  const [orderId] = await trx('orders').insert({ user_id, total });
  await trx('order_items').insert(items.map(i => ({ order_id: orderId, ...i })));
});

// INCORRECTO — sin transacción, inconsistencia si falla el segundo insert
await db('orders').insert({ user_id, total });
await db('order_items').insert(items);
```
