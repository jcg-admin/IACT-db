<!-- SKILL_START -->
```yml
name: db-mysql
description: "Skill de tecnología para bases de datos MySQL. Usar cuando se trabaje en migraciones, queries, índices, o schema en el proyecto {{PROJECT_NAME}}. Invocar durante Phase 4 STRUCTURE para especificar el schema y relaciones, durante Phase 6 EXECUTE para implementar migraciones y queries, y durante Phase 7 TRACK para revisar performance y consistencia de la base de datos."
layer: db
framework: mysql
project: {{PROJECT_NAME}}
```

# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — SKILL

Guía fase-por-fase para trabajar con MySQL en el proyecto {{PROJECT_NAME}}.

---

## Phase 1: ANALYZE — Qué investigar en features con MySQL

Al analizar un feature que toca la base de datos, cubrir:
- Tablas afectadas — ¿nuevas, modificadas, eliminadas?
- Relaciones — ¿nuevas foreign keys, cambios en cardinalidad? (MySQL no crea índices en FK automáticamente)
- Volumen de datos — ¿cuántos registros esperados? ¿crece rápido?
- Queries principales — ¿qué consultas hará este feature con más frecuencia?
- Índices necesarios — ¿qué columnas se filtran, ordenan, o usan en JOIN?

## Phase 4: STRUCTURE — Qué especificar para features de DB

En `requirements-spec.md`, incluir por cada tabla nueva/modificada:
- Nombre (snake_case plural), propósito, columnas con tipo y constraints
- Foreign keys con comportamiento ON DELETE / ON UPDATE
- Índices necesarios con justificación (incluir índice en cada FK)
- Charset: `utf8mb4 COLLATE utf8mb4_unicode_ci` por defecto
- Migraciones requeridas: UP (aplicar) y DOWN (revertir si posible)

## Phase 6: EXECUTE — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Migración UP — crear/modificar tablas con charset correcto
2. Migración de índices separada para tablas grandes (evita lock prolongado)
3. Verificar estructura: `DESCRIBE tabla` o `SHOW CREATE TABLE tabla`
4. Queries de la aplicación usando la nueva estructura
5. Migración DOWN — revertir todo lo del UP

## Phase 7: TRACK — Qué revisar al cerrar

- Todas las FKs tienen índice explícito
- Queries nuevas tienen `EXPLAIN ANALYZE` verificado (sin Full Table Scan en tablas grandes)
- No hay queries con `SELECT *` en código de producción
- Charset `utf8mb4` en tablas y columnas de texto
- Migraciones son idempotentes o tienen DOWN funcional
- Credenciales no hardcodeadas — usar variables de entorno
<!-- SKILL_END -->

<!-- INSTRUCTIONS_START -->
# {{LAYER_TITLE}} {{FRAMEWORK_TITLE}} — Guidelines

Reglas siempre activas para trabajar con MySQL en {{PROJECT_NAME}}.

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
<!-- INSTRUCTIONS_END -->
