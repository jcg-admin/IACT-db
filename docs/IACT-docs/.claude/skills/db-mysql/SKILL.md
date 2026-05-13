```yml
name: db-mysql
description: "Skill de tecnología para bases de datos MySQL. Usar cuando se trabaje en migraciones, queries, índices, o schema en el proyecto thyrox. Invocar durante Phase 7 DESIGN/SPECIFY para especificar el schema y relaciones, durante Phase 10 EXECUTE para implementar migraciones y queries, y durante Phase 11 TRACK/EVALUATE para revisar performance y consistencia de la base de datos."
layer: db
framework: mysql
project: thyrox
```

# DB MySQL — SKILL

Guía fase-por-fase para trabajar con MySQL en el proyecto thyrox.

---

## Stage 3: DIAGNOSE — Qué investigar en features con MySQL

Al analizar un feature que toca la base de datos, cubrir:
- Tablas afectadas — ¿nuevas, modificadas, eliminadas?
- Relaciones — ¿nuevas foreign keys, cambios en cardinalidad? (MySQL no crea índices en FK automáticamente)
- Volumen de datos — ¿cuántos registros esperados? ¿crece rápido?
- Queries principales — ¿qué consultas hará este feature con más frecuencia?
- Índices necesarios — ¿qué columnas se filtran, ordenan, o usan en JOIN?

## Phase 7: DESIGN/SPECIFY — Qué especificar para features de DB

En `requirements-spec.md`, incluir por cada tabla nueva/modificada:
- Nombre (snake_case plural), propósito, columnas con tipo y constraints
- Foreign keys con comportamiento ON DELETE / ON UPDATE
- Índices necesarios con justificación (incluir índice en cada FK)
- Charset: `utf8mb4 COLLATE utf8mb4_unicode_ci` por defecto
- Migraciones requeridas: UP (aplicar) y DOWN (revertir si posible)

## Stage 10: IMPLEMENT — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Migración UP — crear/modificar tablas con charset correcto
2. Migración de índices separada para tablas grandes (evita lock prolongado)
3. Verificar estructura: `DESCRIBE tabla` o `SHOW CREATE TABLE tabla`
4. Queries de la aplicación usando la nueva estructura
5. Migración DOWN — revertir todo lo del UP

## Phase 11: TRACK/EVALUATE — Qué revisar al cerrar

- Todas las FKs tienen índice explícito
- Queries nuevas tienen `EXPLAIN ANALYZE` verificado (sin Full Table Scan en tablas grandes)
- No hay queries con `SELECT *` en código de producción
- Charset `utf8mb4` en tablas y columnas de texto
- Migraciones son idempotentes o tienen DOWN funcional
- Credenciales no hardcodeadas — usar variables de entorno
