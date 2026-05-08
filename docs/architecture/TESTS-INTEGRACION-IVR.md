# Tests de integración IVR — Guía de referencia

**Fecha:** 2026-05-08  
**Repositorio de tests:** IACT-api  
**BD requerida:** MariaDB — `test_ivr_legacy`

---

## Propósito

Este documento describe cómo funciona la infraestructura de tests de
integración IVR, qué decisiones se tomaron y por qué. Está en IACT-db
porque las decisiones de arquitectura de tests afectan directamente
cómo se gestiona `ivr_legacy` y su BD de tests.

---

## Arquitectura de la BD de tests

### Por qué `test_ivr_legacy` es diferente a `test_iact_analytics`

`iact_analytics` (PostgreSQL) es una BD que Django creó con migraciones.
pytest-django puede destruirla y recrearla libremente porque la información
canónica de su schema vive en las migraciones Django.

`ivr_legacy` (MariaDB) es una BD preexistente que Django solo lee.
Su schema lo define IACT-db (tablas, SPs, índices). Django no sabe
cómo recrearla — no hay migraciones para ella.

Consecuencia: dejar que pytest-django gestione `test_ivr_legacy` es incorrecto.
La configuración correcta en `testing_local.py`:

```python
'ivr': {
    'ENGINE': 'django.db.backends.mysql',
    'NAME': 'ivr_legacy',
    'USER': 'root',
    'PASSWORD': '',
    'HOST': '',
    'PORT': '',
    'OPTIONS': {
        'charset': 'utf8mb4',
        'unix_socket': '/run/mysqld/mysqld.sock',
    },
    'TEST': {
        'NAME': 'test_ivr_legacy',
        'MIGRATE': False,   # No hay migraciones Django para esta BD
        'CREATE_DB': False, # La BD la gestiona IACT-db, no Django
    },
},
```

Con `MIGRATE=False` y `CREATE_DB=False`, pytest-django se conecta a
`test_ivr_legacy` sin intentar crearla, destruirla ni migrarla.

### Qué crea cada capa

```
ensure_mariadb (conftest)
    MariaDB arranca como proceso hijo de pytest
    test_ivr_legacy creada con utf8mb4_unicode_ci

ivr_schema (fixture session-scoped)
    CREATE TABLE IF NOT EXISTS job_execution_log
    CREATE TABLE IF NOT EXISTS base_ivr_detalle
    CREATE TABLE IF NOT EXISTS base_ivr_clientes
    DROP + CREATE PROCEDURE sp_rpt_clientes

ivr_job_execution_data (fixture function-scoped)
    INSERT en job_execution_log
    yield
    DELETE en job_execution_log

ivr_quarter_data (fixture function-scoped)
    INSERT en base_ivr_detalle, base_ivr_clientes
    yield
    DELETE en base_ivr_detalle, base_ivr_clientes
```

### Por qué los fixtures de datos usan subprocess

Django envuelve las operaciones de BD en transacciones durante los tests.
Los datos insertados con `connections['ivr']` en un fixture no son visibles
para el endpoint (que corre en otra conexión) porque la transacción
del fixture no está commiteada al momento del request.

Los fixtures usan `mysql` CLI que hace autocommit:

```python
def _sql(statements: str):
    subprocess.run(
        ['mysql', f'--socket={SOCKET}', 'test_ivr_legacy'],
        input=statements, text=True, capture_output=True,
    )
```

Commit inmediato → datos visibles para el endpoint en cualquier conexión.

---

## Estado de `test_ivr_legacy` entre sesiones

`test_ivr_legacy` persiste entre sesiones de pytest. La estructura de la
tabla no se pierde al terminar pytest. Solo los datos de tests son efímeros:
los fixtures los borran en teardown.

Si MariaDB reinicia (lo que ocurre en el sandbox entre invocaciones),
`test_ivr_legacy` todavía existe en el datadir. `ensure_mariadb` ejecuta
`CREATE DATABASE IF NOT EXISTS` — si ya existe, no hace nada. `ivr_schema`
ejecuta `CREATE TABLE IF NOT EXISTS` — si ya existen, no hace nada.

El SP `sp_rpt_clientes` se recrea en cada sesión con `DROP + CREATE`
porque es la forma más segura de garantizar que está actualizado.

---

## Arranque de MariaDB en el sandbox

El sandbox no tiene systemd. MariaDB debe arrancarse manualmente al inicio
de cada sesión que necesite la BD. Ver `HALLAZGOS-ENTORNO.md` H-001-01.

Para los tests de integración, el conftest `tests/integration/pipeline/conftest.py`
arranca MariaDB automáticamente con `subprocess.Popen` directo a `mariadbd`:

```python
def drop_privs():
    os.setgid(mysql_gid)
    os.setuid(mysql_uid)

proc = subprocess.Popen(
    ['/usr/sbin/mariadbd', '--user=mysql',
     '--socket=/run/mysqld/mysqld.sock', ...],
    preexec_fn=drop_privs,
)
```

La clave es `preexec_fn` en lugar de `runuser`. Con `runuser`, `Popen`
tiene referencia a `runuser` y cuando este termina el hijo queda huérfano.
Con `preexec_fn`, `Popen` tiene referencia directa a `mariadbd` y el
proceso vive mientras el fixture `ensure_mariadb` (scope=session) está
activo.

Para uso interactivo (fuera de pytest), usar `/tmp/mariadb_ensure.sh`.

---

## Escenario A del SP confirmado

`sp_rpt_clientes` y los demás SPs de reporte **no tienen prefijo `ivr_legacy.`**
en el body. El SP ejecuta contra la BD seleccionada en la conexión.

Verificación:

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "SELECT ROUTINE_DEFINITION FROM information_schema.ROUTINES
        WHERE ROUTINE_NAME='sp_rpt_clientes';" 2>/dev/null \
    | grep -c "ivr_legacy\."
# Resultado esperado: 0
```

Consecuencia para los tests: `ivr_schema` recrea el SP en `test_ivr_legacy`
y los datos sembrados por `ivr_quarter_data` son visibles para él.

Si en el futuro un SP se crea con prefijo `ivr_legacy.` hardcodeado
(Escenario B), los tests de datos de ese SP necesitarán otra estrategia.
Ver `HALLAZGOS-FASE-O-2026-05-08.md` H-O-006.

---

## Collation canónica

Toda `test_ivr_legacy` debe crearse con:

```sql
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
```

Este es el mismo collation que usa `ivr_legacy` en producción
(ver `provisioners/mariadb/schema_seed.sh`). Si la BD de tests tiene
un collation diferente, los SPs que comparan strings fallan con:

```
(1267, "Illegal mix of collations ...")
```

---

## Checklist para agregar un nuevo test de integración IVR

- [ ] El test tiene `@pytest.mark.django_db(databases=['default', 'ivr'])`
- [ ] El test declara `ivr_schema` como fixture si necesita tablas IVR
- [ ] Los datos de test se siembran y limpian en un fixture de función
- [ ] Los fixtures de datos usan `_sql()` (subprocess), no `connections['ivr']`
- [ ] Si el test ejerce un SP nuevo, verificar que el SP no tiene `ivr_legacy.`
- [ ] Si el SP tiene `ivr_legacy.` hardcodeado, documentar el Escenario B
      antes de implementar el test

---

## Ver también

- `HALLAZGOS-FASE-O-2026-05-08.md` — bugs encontrados durante Fase O
- `HALLAZGOS-ENTORNO.md` — H-001-01: MariaDB no persiste entre invocaciones
- `SEPARACION-IACT-API.md` — qué gestiona IACT-db vs IACT-api
