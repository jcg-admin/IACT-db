# Procedimiento: recrear PostgreSQL desde cero para IACT-api

```yml
fecha: 2026-05-07
estado: Vigente
aplica_a: Entorno local sin Vagrant (PostgreSQL en 127.0.0.1)
ejecutado_en: IACT-api plan v2.0.0 Fases A–N
```

---

## Cuándo ejecutar este procedimiento

Ejecutar cuando la base de datos `iact_analytics` tiene un schema
que no coincide con las migraciones Django actuales. Síntomas:

- `python manage.py migrate` falla con `relation "X" does not exist`
- `showmigrations` muestra migraciones como `[X]` pero las tablas
  no existen o tienen nombres distintos a los `db_table` del modelo
- El schema fue creado con una versión anterior del código

**Regla:** ante cualquier inconsistencia entre schema real y migraciones,
recrear la base de datos limpia. No usar `--fake` para resolver
inconsistencias de schema.

---

## Por qué NO usar `--fake`

`--fake` marca una migración como aplicada sin ejecutar su SQL.
Sirve únicamente cuando la DB ya tiene el schema correcto y solo
falta registrar la migración en `django_migrations`. Usarlo para
"resolver" inconsistencias deja el estado de la DB indeterminado:
Django cree que el schema existe pero no necesariamente es así.

---

## Procedimiento

### 1. Verificar que PostgreSQL está corriendo

```bash
pg_isready -h localhost -p 5432
# Si no responde:
pg_ctlcluster 16 main start
```

### 2. Verificar que MariaDB está corriendo

```bash
mysql --socket=/run/mysqld/mysqld.sock -e "SELECT VERSION();" 2>/dev/null
# Si no responde, arrancar según HALLAZGOS-ENTORNO.md
```

### 3. Recrear la base de datos

```bash
# Eliminar y crear limpia
PGPASSWORD=django_pass dropdb  -h localhost -U django_user iact_analytics
PGPASSWORD=django_pass createdb -h localhost -U django_user iact_analytics
```

Si `dropdb`/`createdb` no están disponibles, usar psql:

```bash
su -s /bin/bash postgres -c "psql -c 'DROP DATABASE IF EXISTS iact_analytics;'"
su -s /bin/bash postgres -c "psql -c 'CREATE DATABASE iact_analytics OWNER django_user;'"
```

### 4. Aplicar todas las migraciones desde cero

```bash
cd IACT-api/callcentersite
DJANGO_SETTINGS_MODULE=config.settings.development \
python manage.py migrate
```

Resultado esperado: todas las migraciones en estado `[X]` sin errores.

### 5. Verificar el resultado

```bash
DJANGO_SETTINGS_MODULE=config.settings.development \
python manage.py showmigrations | grep "\[ \]"
# Sin output = todo aplicado correctamente

DJANGO_SETTINGS_MODULE=config.settings.development \
python manage.py check
# System check identified no issues (0 silenced).
```

---

## Contexto histórico — schema desactualizado (2026-05-07)

Al conectar IACT-api contra PostgreSQL real por primera vez
(después de haber usado SQLite), la base de datos tenía tablas
de una versión anterior sin `db_table` en `Meta`:

| Nombre en DB              | Nombre que Django esperaba         |
|---------------------------|------------------------------------|
| `functions`               | `access_function`                  |
| `modules`                 | `access_module`                    |
| `user_function_assignments` | `access_user_function_assignment` |
| `user_module_accesses`    | `access_user_module_access`        |

Se intentaron pasos intermedios (renombrar tablas, `--fake`) antes
de llegar a la solución correcta: recrear la DB limpia.

Migraciones aplicadas en la DB final: **36**, todas reales.

Ver: `HALLAZGOS-IACT-API-2026-05-07.md` — H-A-001, H-A-002, H-A-003.

---

## Campos que requieren `null=True` en PostgreSQL

Durante la recreación se identificó que `Function.permission_django`
definía `unique=True` con `blank=True` pero sin `null=True`.
PostgreSQL rechaza múltiples filas con `''` en un campo `UNIQUE`.

Regla documentada en `DEVELOPMENT.md`:
> Un `CharField` con `unique=True` y `blank=True` siempre
> necesita `null=True` para ser compatible con PostgreSQL.
