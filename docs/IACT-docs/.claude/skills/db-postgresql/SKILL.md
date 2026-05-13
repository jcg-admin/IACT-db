```yml
name: db-postgresql
description: "Skill de tecnología para bases de datos PostgreSQL. Usar cuando se trabaje en migraciones, queries, índices, o schema en el proyecto thyrox. Invocar durante Phase 7 DESIGN/SPECIFY para especificar el schema y relaciones, durante Phase 10 EXECUTE para implementar migraciones y queries, y durante Phase 11 TRACK/EVALUATE para revisar performance y consistencia de la base de datos."
layer: db
framework: postgresql
project: thyrox
```

# DB PostgreSQL — SKILL

Guía fase-por-fase para trabajar con PostgreSQL en el proyecto thyrox.

---

## Stage 3: DIAGNOSE — Qué investigar en features con PostgreSQL

Al analizar un feature que toca la base de datos, cubrir:
- Tablas afectadas — ¿nuevas, modificadas, eliminadas?
- Relaciones — ¿nuevas foreign keys, cambios en cardinalidad?
- Volumen de datos — ¿cuántos registros esperados? ¿crece rápido?
- Queries principales — ¿qué consultas hará este feature con más frecuencia?
- Índices necesarios — ¿qué columnas se filtran o se ordenan?

## Phase 7: DESIGN/SPECIFY — Qué especificar para features de DB

En `requirements-spec.md`, incluir por cada tabla nueva/modificada:
- Nombre (snake_case), propósito, columnas con tipo y constraints
- Foreign keys y comportamiento en cascade (ON DELETE, ON UPDATE)
- Índices necesarios con justificación
- Migraciones requeridas: UP (aplicar) y DOWN (revertir)

## Stage 10: IMPLEMENT — Convenciones de implementación

Ver sección INSTRUCTIONS para reglas específicas.

Orden de implementación recomendado:
1. Migración UP — crear/modificar tablas e índices
2. Verificar con `\d tabla` en psql
3. Queries de la aplicación usando la nueva estructura
4. Migración DOWN — revertir todo lo del UP
5. Test: aplicar UP, verificar, aplicar DOWN, verificar

## Phase 11: TRACK/EVALUATE — Qué revisar al cerrar

- Todas las migraciones tienen UP y DOWN funcionales
- Queries nuevas tienen `EXPLAIN ANALYZE` verificado (sin Seq Scan en tablas grandes)
- No hay queries con `SELECT *` en código de producción
- Índices nuevos no duplican índices existentes
- Columnas `NOT NULL` tienen `DEFAULT` o la app siempre las provee
