# Hallazgos Fase O — Tests de integración IVR

**Repositorio afectado:** IACT-api  
**Detectado durante:** Plan v2.0.0, Fase O — Tests de integración endpoints IVR  
**Fecha:** 2026-05-08  
**Documentado en:** IACT-db — los hallazgos involucran MariaDB, los SPs y la
configuración de la BD de tests

---

## Resumen ejecutivo

La Fase O implementó 13 tests de integración que ejercitan los endpoints IVR
contra MariaDB real. Durante el proceso se encontraron 3 bugs de producción
y 4 hallazgos de infraestructura de tests. Todos resueltos. Resultado final:
**13/13 tests passing**.

---

## Bugs de producción encontrados

### H-O-001 — `ivr_views.py` llamaba funciones con nombres en español

**Severidad:** CRÍTICA — el endpoint retornaba `AttributeError 500` en producción  
**Estado:** RESUELTO en IACT-api  
**Archivo:** `apps/reports/ivr_views.py`

#### Problema

Durante la Fase I (hardening IVR), `ivr_services.py` fue renombrado para
cumplir RA-011 (identificadores en inglés). Las funciones cambiaron:

| Nombre anterior | Nombre corregido |
|---|---|
| `get_clientes` | `get_clients` |
| `get_centros_transferencia` | `get_transfer_centers` |
| `get_llamadas_abandonadas` | `get_abandoned_calls` |
| `get_cmenu_error` | `get_cmenu_errors` |
| `get_centros_xsegmento` | `get_centers_by_segment` |
| `get_menu_redirigidos` | `get_redirected_menus` |
| `get_menu_centro` | `get_center_menus` |

`ivr_views.py` no fue actualizado. Resultado: cualquier petición a los
endpoints de reporte IVR retornaba:

```
AttributeError: module 'apps.reports.ivr_services' has no attribute 'get_clientes'
```

Este error no era visible en los tests unitarios porque los tests unitarios
mockeaban el servicio. Solo se detectó al ejercitar el endpoint real en Fase O.

#### Corrección

```python
# ivr_views.py — reemplazar todas las llamadas a svc
return _ivr_response(svc.get_clients, quarter, extra={'quarter': quarter})
return _ivr_response(svc.get_transfer_centers, quarter, segment, ...)
# ... resto de endpoints
```

#### Lección

Los tests unitarios que mockean el servicio no detectan renombrados en la
capa de integración view→service. Los tests de integración son necesarios
para cubrir este gap.

---

### H-O-002 — `MAX_EXECUTION_TIME` es variable de MySQL, no de MariaDB

**Severidad:** ALTA — todos los endpoints IVR retornaban 503 en MariaDB  
**Estado:** RESUELTO en IACT-api  
**Archivos:** `apps/reports/ivr_services.py`, `apps/pipeline/views.py`

#### Problema

En la Fase I se agregó control de timeout para las queries IVR usando
`SET SESSION MAX_EXECUTION_TIME`. Esta variable existe en MySQL pero
**no en MariaDB**. Al intentar ejecutar esa sentencia, MariaDB retorna:

```
(1193, "Unknown system variable 'MAX_EXECUTION_TIME'")
```

El endpoint capturaba `OperationalError` y retornaba 503. Esto afectaba a:
- `GET /api/pipeline/status/` — `_get_pipeline_runs()`
- Todos los endpoints de reporte IVR — `_call_sp()`

El error no fue detectado antes porque los tests corrían con mocks de la
capa de BD o con SQLite, nunca contra MariaDB real.

#### Variables de timeout en MySQL vs MariaDB

| Motor | Variable | Unidad |
|---|---|---|
| MySQL 5.7+ | `MAX_EXECUTION_TIME` | milisegundos |
| MariaDB 10.1+ | `MAX_STATEMENT_TIME` | segundos |

#### Corrección

```python
# Antes (MySQL)
timeout_ms = getattr(settings, 'IVR_QUERY_TIMEOUT_SEC', 30) * 1000
cursor.execute(f"SET SESSION MAX_EXECUTION_TIME={timeout_ms}")

# Después (MariaDB)
timeout_sec = getattr(settings, 'IVR_QUERY_TIMEOUT_SEC', 30)
cursor.execute(f"SET SESSION MAX_STATEMENT_TIME={timeout_sec}")
```

#### Impacto en producción

Si el entorno de producción usa MariaDB (como documenta IACT-db),
este bug haría que todos los endpoints IVR fallen silenciosamente con 503
desde el momento en que se desplegó la Fase I. El timeout se configuró para
proteger contra queries largas, pero el bug lo convertía en un fallo garantizado.

---

### H-O-003 — Collation mismatch entre el SP y las tablas de `test_ivr_legacy`

**Severidad:** MEDIA — tests de SP fallaban con error de collation  
**Estado:** RESUELTO en la infraestructura de tests  
**Scope:** Solo afecta `test_ivr_legacy` — en `ivr_legacy` el SP se creó con
el collation correcto desde el provisioner

#### Problema

Al recrear `sp_rpt_clientes` en `test_ivr_legacy` para los tests (Escenario A),
el SP se creaba con el collation por defecto del servidor de MariaDB
(`utf8mb4_general_ci`), mientras que las tablas se creaban con
`utf8mb4_unicode_ci`. Al ejecutar el SP:

```
(1267, "Illegal mix of collations (utf8mb4_general_ci,IMPLICIT) and
(utf8mb4_unicode_ci,IMPLICIT) for operation '='")
```

#### Causa raíz

`CREATE DATABASE test_ivr_legacy CHARACTER SET utf8mb4` sin especificar
`COLLATE` usa la collation por defecto del servidor, que puede ser
`utf8mb4_general_ci`. Las tablas se creaban con `COLLATE utf8mb4_unicode_ci`
explícito (como en el schema de producción de IACT-db), pero el SP heredaba
el collation de la base de datos donde fue creado.

#### Corrección

Crear `test_ivr_legacy` con el collation explícito que coincide con las tablas:

```sql
CREATE DATABASE IF NOT EXISTS test_ivr_legacy
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
```

Y aplicar `COLLATE=utf8mb4_unicode_ci` a todas las tablas al crearlas en el
fixture.

#### Regla para futuros SPs en tests

Cuando se recrea un SP en una BD de tests, la BD debe crearse con el mismo
`COLLATE` que usa `ivr_legacy` en producción. El provisioner
`provisioners/mariadb/schema_seed.sh` usa `utf8mb4_unicode_ci` — ese es
el valor canónico para todo `test_ivr_legacy`.

---

## Hallazgos de infraestructura de tests

### H-O-004 — `subprocess.Popen` con `runuser` produce proceso huérfano

**Severidad:** ALTA — MariaDB moría antes de que los tests corrieran  
**Estado:** RESUELTO en conftest de integración  
**Scope:** Solo afecta entornos sin systemd (sandbox, CI sin init)

#### Problema

El primer enfoque para mantener MariaDB vivo durante pytest usaba:

```python
proc = subprocess.Popen([
    'runuser', '-u', 'mysql', '--',
    '/usr/sbin/mariadbd', ...
])
```

`Popen` tenía referencia a `runuser`, no a `mariadbd`. El ciclo es:
1. `runuser` arranca, hace fork interno para crear `mariadbd`
2. `mariadbd` queda como proceso hijo de `runuser`
3. `runuser` termina (su trabajo fue lanzar el fork)
4. `mariadbd` queda huérfano — el entorno sandbox lo mata

El resultado: MariaDB arrancaba (el log registraba `ready for connections`),
`Popen.poll()` retornaba `None` (runuser seguía vivo brevemente), pero
el socket dejaba de responder segundos después.

#### Corrección

Usar `preexec_fn` para bajar privilegios directamente en el proceso hijo,
eliminando la capa de `runuser`:

```python
def drop_privs():
    os.setgid(mysql_gid)
    os.setuid(mysql_uid)

proc = subprocess.Popen(
    ['/usr/sbin/mariadbd', '--user=mysql', ...],
    preexec_fn=drop_privs,
    stderr=open('/tmp/mdb_conftest.log', 'w'),
)
```

`Popen` ahora tiene referencia directa a `mariadbd`. El proceso es hijo
de pytest y vive mientras el fixture `ensure_mariadb` (scope='session')
esté activo — es decir, durante toda la sesión de pytest.

#### Nota sobre `/tmp/mariadb_ensure.sh`

El script existente en `/tmp/mariadb_ensure.sh` usa el patrón `runuser ... &`
y es adecuado para uso interactivo en shell (el proceso persiste porque
el shell que lo invoca permanece activo). Para pytest, donde el proceso
padre (el fixture) termina al hacer `yield`, el patrón `preexec_fn`
es el correcto.

---

### H-O-005 — `MIGRATE=False` + `CREATE_DB=False` es la configuración correcta para BDs legacy

**Severidad:** N/A — hallazgo de arquitectura, no bug  
**Estado:** Implementado en `testing_local.py`

#### Problema original

`testing_local.py` tenía la configuración `TEST` de la BD `ivr` sin
`MIGRATE` ni `CREATE_DB`:

```python
'TEST': {
    'NAME': 'test_ivr_legacy',
},
```

pytest-django interpretaba `test_ivr_legacy` como una BD gestionada por
Django y la destruía y recreaba al inicio de cada sesión. Esto causaba:

1. **Race condition:** pytest-django intentaba crear `test_ivr_legacy` al
   inicio de la sesión, antes de que cualquier fixture corriera. Si MariaDB
   no respondía en ese momento, todos los tests con `databases=['ivr']`
   fallaban con error 2002.

2. **Ineficiencia:** el schema se perdía entre sesiones y los fixtures
   debían recrear tablas y SPs en cada ejecución.

#### Corrección

```python
'TEST': {
    'NAME': 'test_ivr_legacy',
    'MIGRATE': False,   # No hay migraciones Django para ivr_legacy
    'CREATE_DB': False, # IACT-db provee y gestiona esta BD
},
```

`MIGRATE=False` le dice a pytest-django que no intente ejecutar migraciones
en esta BD (correcto: `ivr_legacy` no tiene migraciones Django).
`CREATE_DB=False` le dice que no intente crear ni destruir la BD de tests
(correcto: la BD la gestiona IACT-db, no Django).

#### Por qué `ivr_legacy` es diferente

`iact_analytics` (PostgreSQL) es una BD que Django creó y gestiona con
migraciones. `ivr_legacy` (MariaDB) es una BD preexistente que Django
solo lee. La distinción es la misma que Django documenta en el concepto
de "legacy databases": Django no la posee.

#### Estado persistente de `test_ivr_legacy`

Con `CREATE_DB=False`, `test_ivr_legacy` persiste entre sesiones de pytest.
El schema (tablas, SPs) lo crea el fixture `ivr_schema` con
`CREATE TABLE IF NOT EXISTS` al inicio de cada sesión, si las tablas
no existen. Los fixtures de datos (`ivr_quarter_data`,
`ivr_job_execution_data`) insertan al inicio de cada test y limpian
al final — la estructura de la BD se preserva, solo los datos son efímeros.

---

### H-O-006 — `sp_rpt_clientes` no tiene prefijo de schema: Escenario A confirmado

**Severidad:** N/A — verificación de arquitectura, decisión de diseño  
**Estado:** Verificado y documentado

#### Verificación

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "SELECT ROUTINE_DEFINITION FROM information_schema.ROUTINES
        WHERE ROUTINE_NAME='sp_rpt_clientes';" 2>/dev/null \
    | grep -c "ivr_legacy\."
# Resultado: 0
```

El SP usa `FROM base_ivr_clientes c` sin prefijo `ivr_legacy.`. Esto significa
que el SP ejecuta contra la BD seleccionada en la conexión al momento de
la llamada. En tests, `connections['ivr']` apunta a `test_ivr_legacy`,
por lo que el SP lee los datos sembrados por el fixture.

#### Consecuencia para los tests

El fixture `ivr_schema` recrea `sp_rpt_clientes` en `test_ivr_legacy`
usando exactamente el mismo body que tiene en `ivr_legacy`. Los datos
sembrados por `ivr_quarter_data` son visibles para el SP porque:
1. Están en `test_ivr_legacy`
2. El SP ejecuta contra `test_ivr_legacy`
3. Los fixtures usan subprocess (commit inmediato, no transacción Django)

#### Regla para futuros SPs de reporte

Si en el futuro se agrega un SP de reporte que use prefijo `ivr_legacy.`
(Escenario B), no será testeable con este enfoque. En ese caso, hay dos
opciones:

- **Opción 1:** Quitar el prefijo del SP y que el schema sea un parámetro
  implícito (conexión). Recomendado — es más portable.

- **Opción 2:** Agregar una conexión `ivr_admin` en `testing_local.py`
  que apunte a `ivr_legacy` real, y sembrar los datos de test directamente
  en la BD de producción. Solo aplica cuando hay datos seed persistentes
  que el fixture puede usar.

---

### H-O-007 — Los fixtures de datos deben usar subprocess, no `connections['ivr']`

**Severidad:** N/A — patrón de diseño, no bug  
**Estado:** Implementado en `tests/fixtures/ivr.py`

#### Problema con `connections['ivr']`

Django envuelve las operaciones de BD en transacciones durante los tests.
Los datos insertados con `connections['ivr']` dentro de un fixture no son
visibles para el endpoint Django que se invoca en el test, porque el endpoint
corre en una conexión diferente y la transacción del fixture no está commiteada.

```python
# Esto NO funciona — datos no visibles para el endpoint
@pytest.fixture
def ivr_quarter_data(ivr_schema):
    with connections['ivr'].cursor() as cursor:
        cursor.execute("INSERT INTO base_ivr_clientes ...")
    yield
    # Los datos fueron insertados en una transacción no commiteada
    # El endpoint corre en otra conexión y no los ve
```

Agregar `transaction=True` al marker del test tampoco resuelve el problema
de forma confiable porque el fixture y el test pueden tener distintos
niveles de aislamiento.

#### Solución: subprocess con commit implícito

```python
def _sql(statements: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        ['mysql', f'--socket={SOCKET}', DB],
        input=statements, text=True, capture_output=True,
    )

@pytest.fixture
def ivr_quarter_data(ivr_schema):
    _sql("""
        INSERT INTO base_ivr_clientes (trimestre, segmento, clientes_unicos)
        VALUES ('Q01_25', 'nacional_A', 1500), ...;
    """)
    yield
    _sql("DELETE FROM base_ivr_clientes WHERE trimestre = 'Q01_25';")
```

El cliente `mysql` hace autocommit por defecto. Los datos son visibles
inmediatamente para cualquier conexión, incluida la que usa el endpoint
en el request Django del test.

#### Por qué `test_ivr_legacy` puede usar este patrón

`ivr_legacy` es una BD legacy de solo lectura para Django en producción
(CNST-003). Los fixtures pueden escribir en `test_ivr_legacy` porque:
1. `--skip-grant-tables` en el entorno de tests permite cualquier operación
2. Django no gestiona esta BD — no hay conflicto con el ciclo de vida ORM

En una BD gestionada por Django (como `iact_analytics`), usar subprocess
para insertar datos en tests rompería el aislamiento transaccional y
causaría interferencias entre tests.

---

## Matriz de bugs vs detección

| Bug | Detectable con tests unitarios | Detectable con mocks | Requiere integración real |
|---|---|---|---|
| H-O-001 (`get_clientes`) | No — los mocks no renombran | No | Sí |
| H-O-002 (`MAX_EXECUTION_TIME`) | No — SQLite no tiene esta variable | No | Sí |
| H-O-003 (collation mismatch) | No — sin MariaDB real | No | Sí |

Los tres bugs de producción solo eran detectables con tests de integración
contra MariaDB real. Este es el argumento concreto de por qué Fase O
es necesaria: los tests unitarios no pueden encontrar bugs que dependen
del motor de BD real.

---

## Ver también

- `HALLAZGOS-ENTORNO.md` — H-001-01: MariaDB no persiste entre invocaciones shell
- `HALLAZGOS-IACT-API-2026-05-07.md` — hallazgos de Fases A–N
- `SEPARACION-IACT-API.md` — separación de responsabilidades IACT-db/IACT-api
- IACT-api: `tests/integration/pipeline/conftest.py` — implementación `ensure_mariadb`
- IACT-api: `tests/fixtures/ivr.py` — implementación de los fixtures
- IACT-api: `config/settings/testing_local.py` — `MIGRATE=False`, `CREATE_DB=False`
