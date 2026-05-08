# Hallazgos IACT-api — 2026-05-07

**Repositorio afectado:** IACT-api  
**Detectado durante:** Implementación plan v2.0.0 (Fases A–N)  
**Documentado en:** IACT-db — porque los hallazgos involucran la capa de base de datos

---

## H-A-001 — IACT-api usaba SQLite en lugar de PostgreSQL + MariaDB

**Severidad:** ALTA  
**Estado:** RESUELTO en IACT-api

### Problema

`config/settings_local.py` en IACT-api definía SQLite como motor de
base de datos para desarrollo:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': Path(__file__).resolve().parent.parent / 'db.sqlite3',
    }
}
```

La configuración dual que provee IACT-db (PostgreSQL + MariaDB) no
se usaba durante el desarrollo local de IACT-api.

### Consecuencia

Diferencias de comportamiento entre SQLite y PostgreSQL no se detectaban
hasta llegar a un ambiente con la base de datos real. Ver H-A-003 para
un caso concreto.

### Corrección aplicada en IACT-api

`config/settings_local.py` ahora importa desde `settings.development`
que usa las credenciales del `.env` (PostgreSQL + MariaDB):

```python
from .settings.development import *
```

### Acción requerida en IACT-db

Ninguna. IACT-db ya provee PostgreSQL en `localhost:5432` con el usuario
`django_user` y la base de datos `iact_analytics`. La corrección fue
solo en IACT-api.

---

## H-A-002 — Base de datos PostgreSQL con schema desactualizado

**Severidad:** MEDIA  
**Estado:** RESUELTO — DB recreada limpia

### Problema

La base de datos `iact_analytics` en PostgreSQL tenía tablas creadas por
una versión anterior del código que no definía `db_table` en `Meta`.
Las tablas se llamaban:

| Nombre en DB | Nombre esperado por Django |
|---|---|
| `functions` | `access_function` |
| `modules` | `access_module` |
| `user_function_assignments` | `access_user_function_assignment` |
| `user_module_accesses` | `access_user_module_access` |

Django marcaba las migraciones 0001 y 0002 de `access` como `[X]`
aplicadas, pero las tablas no coincidían con los `db_table` definidos en
los modelos actuales. La migración 0003 fallaba al hacer `ALTER TABLE
access_function` porque la tabla `access_function` no existía.

### Causa raíz

La base de datos fue creada con una versión del código sin `db_table`
en `Meta`. Al agregar `db_table` en el código, las migraciones existentes
registraban los nombres nuevos pero las tablas físicas conservaban los
nombres viejos.

### Corrección aplicada

Base de datos `iact_analytics` recreada completamente:

```bash
PGPASSWORD=django_pass dropdb -h localhost -U django_user iact_analytics
PGPASSWORD=django_pass createdb -h localhost -U django_user iact_analytics
python manage.py migrate  # 36 migraciones aplicadas desde cero
```

### Recomendación para IACT-db

Documentar en `provisioners/postgres/setup.sh` que si ya existe la base
de datos `iact_analytics`, verificar que las tablas sigan los nombres
`db_table` de los modelos Django antes de ejecutar `migrate`. Si hay
discrepancia, la opción más segura es recrear la DB.

---

## H-A-003 — Campo `permission_django` con `unique=True` y `blank=True` sin `null=True`

**Severidad:** ALTA (bug silencioso en SQLite, falla en PostgreSQL)  
**Estado:** RESUELTO en IACT-api

### Problema

El modelo `Function` en IACT-api definía:

```python
permission_django = models.CharField(
    max_length=100,
    unique=True,
    blank=True,  # permite '' como valor
    # null=True  ← faltaba
)
```

La migración `0003` hace `AddField` para este campo. Durante la migración,
el campo se agrega con `default=''` para las filas existentes.

**Comportamiento en SQLite:** múltiples filas con `''` en un campo
`UNIQUE` son aceptadas. La migración pasa sin error.

**Comportamiento en PostgreSQL:** el constraint `UNIQUE` rechaza múltiples
filas con el mismo valor vacío `''`. La migración falla con:
```
psycopg2.errors.UniqueViolation: duplicate key value violates unique constraint
```

### Corrección aplicada en IACT-api

Se agregó `null=True` al campo y a la migración:

```python
permission_django = models.CharField(
    max_length=100,
    unique=True,
    blank=True,
    null=True,  # ← agregado para compatibilidad con PostgreSQL
)
```

La migración usa `NULL` en lugar de `''` como valor por defecto, lo que
PostgreSQL acepta correctamente para campos `UNIQUE` (múltiples `NULL`
no violan el constraint).

### Lección general

Un campo `CharField` con `unique=True` y `blank=True` **siempre** debe
tener `null=True` para ser compatible con PostgreSQL. Sin `null=True`,
solo puede existir una fila con el campo vacío.

Esta diferencia SQLite/PostgreSQL es un argumento adicional para no usar
SQLite en desarrollo cuando el destino de producción es PostgreSQL.

---

## H-A-004 — MariaDB requiere arranque manual en el entorno local

**Severidad:** BAJA  
**Estado:** CONOCIDO — documentado en HALLAZGOS-ENTORNO.md de IACT-db

### Observación

Durante el trabajo en IACT-api, MariaDB requirió arranque manual en
varias sesiones:

```bash
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
runuser -u mysql -- /usr/sbin/mariadbd \
    --user=mysql --socket=/run/mysqld/mysqld.sock \
    --datadir=/var/lib/mysql \
    --skip-grant-tables \
    >> /tmp/mdb.log 2>&1 &
```

Este hallazgo ya está documentado en `HALLAZGOS-ENTORNO.md`. Se registra
aquí para correlación con los hallazgos de IACT-api.

---

## Impacto en IACT-db

| Hallazgo | Acción en IACT-db | Estado |
|---|---|---|
| H-A-001 SQLite en IACT-api | Ninguna — la corrección fue en IACT-api | Ninguna |
| H-A-002 Schema desactualizado | Documentar en provisioners/postgres/setup.sh | Pendiente |
| H-A-003 unique+blank sin null | Documentar como práctica en DEVELOPMENT.md | Pendiente |
| H-A-004 MariaDB arranque manual | Ya documentado en HALLAZGOS-ENTORNO.md | Cerrado |

---

## Recomendación

Para evitar H-A-001 y H-A-003 en nuevos desarrolladores:

1. El `QUICKSTART.md` de IACT-db debería incluir una sección
   "Configurar IACT-api para usar las BDs reales" con el paso de
   editar `settings_local.py`.

2. El `DEVELOPMENT.md` debería documentar la regla:
   > En Django, un `CharField` con `unique=True` y `blank=True` siempre
   > necesita `null=True` para ser compatible con PostgreSQL.
