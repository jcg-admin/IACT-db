# Hallazgos del entorno de implementación

**Fecha de análisis:** 2026-05-07
**Generado en:** Fase 0 — Verificación del entorno (T-001..T-005)
**Referencia:** BITACORA-IMPLEMENTACION.md, Fase 0

Este documento consolida los hallazgos del entorno que no estaban
en el plan v2 y que afectan las fases siguientes.

---

## 1. MariaDB — Diferencias con el plan

### Versión: 10.11.14, no 10.1.48

El plan v2 y toda la documentación de arquitectura (CNST-ETL-007,
FLUJO-ETL-V2.md, ANALISIS-ARQUITECTURA-ETL.md) asumen MariaDB 10.1.48
sin window functions. La versión real instalada es 10.11.14.

| Característica | 10.1.48 (plan) | 10.11.14 (real) |
|---|---|---|
| Window functions | No | **Sí** |
| `ROW_NUMBER() OVER()` | No | **Sí** |
| `RANK() OVER()` | No | **Sí** |
| JSON functions | Básico | Completo |
| `RETURNING` clause | No | **Sí** |

**Impacto en los SPs:** Los SPs diseñados con subconsultas en lugar
de `OVER(PARTITION BY)` siguen siendo válidos. No se reescriben —
la decisión D-001-02 mantiene las subconsultas por compatibilidad
hacia atrás con posibles entornos del cliente.

**Actualización requerida en arquitectura:**
`CNST-ETL-007` debe decir: "Diseño compatible con MariaDB 10.1+.
La instancia de implementación es 10.11.14. Window functions disponibles
pero no usadas para mantener compatibilidad."

---

### MariaDB corre sin autenticación (--skip-grant-tables)

El proceso arranca con `--skip-grant-tables` en este entorno.
Cualquier usuario puede conectarse sin password. En producción
la autenticación estará activa y los grants del T-002 aplican.

**Consecuencias para las pruebas:**
- Los tests de permisos (T-002) confirman los grants configurados
  pero no los validan en ejecución real
- Los SPs que se crean aquí son accesibles sin restricciones
- En producción, `django_user` necesitará `EXECUTE` en los SPs además
  de `SELECT/INSERT/DELETE` en las tablas

**Pendiente para producción:** Verificar que `django_user` tiene
`GRANT EXECUTE ON PROCEDURE ivr_legacy.sp_rpt_* TO django_user@host`.

---

### MariaDB no persiste entre llamadas de herramienta

El proceso background MariaDB no sobrevive entre invocaciones del
sandbox de herramienta. El socket desaparece y la siguiente conexión
falla con `ERROR 2002 (HY000)`.

**Workaround implementado:** Script `/tmp/mariadb_ensure.sh` que verifica
si la conexión es posible y reinicia MariaDB si no lo es. Se llama
al inicio de cada task que requiera la BD.

**En producción:** MariaDB corre como servicio systemd — este problema
no existe. El workaround es exclusivo del entorno de desarrollo del sandbox.

### Arranque de MariaDB en pytest — `preexec_fn` vs `runuser`

**Detectado en:** Fase O — Tests de integración IVR (2026-05-08)

El script `/tmp/mariadb_ensure.sh` es adecuado para uso interactivo.
Para tests de integración con pytest, el patrón correcto es diferente.

`runuser ... &` crea un proceso huérfano: `Popen` tiene referencia
a `runuser`, que termina después del fork. El hijo `mariadbd` queda
sin padre y el sandbox lo mata.

La solución es usar `preexec_fn` para bajar privilegios directamente:

```python
proc = subprocess.Popen(
    ['/usr/sbin/mariadbd', '--user=mysql', '--skip-grant-tables', ...],
    preexec_fn=drop_privs,  # setgid + setuid a mysql
)
```

`Popen` tiene referencia directa a `mariadbd`. El proceso vive mientras
el fixture `ensure_mariadb` (scope='session') está activo.

Ver: `TESTS-INTEGRACION-IVR.md` para el contexto completo.

---

## 2. Datos: seed vs producción

### Tamaños reales de las tablas fuente

| Tabla | Filas reales (producción) | Filas en entorno (seed) |
|---|---|---|
| tbl_historico_t1_2025 | ~11,643,679 | 50,000 |
| tbl_historico_t2_2025 | ~13,612,375 | 58,450 |
| tbl_historico_t3_2025 | ~11,482,117 | 49,300 |
| tbl_historico_t4_2025 | ~11,560,000 | 49,490 |
| tbl_historico_t1_2026 | ~11,600,000 | 49,684 |
| tbl_historico_t2_2026 | ~5,300,000 | 0 (vacía) |

**El seed replica fielmente:**
- Las proporciones entre segmentos (45% nacional_A, 30% nacional_B, 25% puebla)
- Los tipos de anomalías (G-29, NK90, CASO_ERROR_CEROS, etc.)
- La distribución de menús por quarter
- Los cambios de VDN entre quarters

**Lo que el seed no replica:** el volumen absoluto y el tiempo de
ejecución. Los tests de rendimiento del plan (T-083) deben
interpretarse como "< X ms con 50K filas" en lugar de "< X ms con 14M".

### tbl_historico_t2_2026 está vacía

El seed no generó datos para Q02_2026 (`tbl_historico_t2_2026` = 0 filas).
Los tests que usen Q02_26 devolverán resultados vacíos hasta que se
pueble esta tabla. El ETL nocturno (evt_etl_diario) la procesaría
si tuviera datos.

**Workaround:** Para testear Q02_26, usar:
```sql
INSERT INTO tbl_historico_t2_2026 SELECT * FROM tbl_historico_t2_2025 LIMIT 1000;
```
O simplemente usar Q01_25 para todos los tests que requieran datos.

---

## 3. Proyecto Django — Estado real vs plan

### Apps que ya existen con lógica relevante

**`apps/pipeline/`** — La app más relevante:
- `scheduler.py` — `ETLScheduler` usando APScheduler, corre cada 12h
- `services/etl_service.py` — `ETLService` con `extract()`, `transform()`, `load()`
- `models.py` — `ETLExecution`, `CallRecord`, `CallNote`, `Center`, `Service`
- `views.py` — `etl_status` (GET endpoint para estado del ETL)
- `viewsets.py` — ViewSets para `Center`, `Service`, `CallRecord`, `CallNote`
- `urls.py` — `/api/v1/pipeline/status/` y endpoints CRUD

**`apps/ivr/`** — App de acceso al IVR legacy:
- `adapters.py` — `IVRAdapter` (desactivado desde 2026-03-21)
- `models.py` — `TblTempPruebaIvr` (tabla de prueba, gestionada=False)
- `views.py`, `viewsets.py` — Existentes pero sin implementación activa

**`apps/ivr_legacy/`** — Solo `__init__.py` (vacía)

### ETLService y ETLScheduler son stubs

`ETLService.extract()` retorna `[]` — el IVRAdapter fue desactivado
cuando la tabla `call_logs` fue eliminada del schema IVR.

El scheduler ejecuta cada 12h pero llama a `ETLService` que no hace nada.
Hay logs de `WARNING: ETL Extract: IVRAdapter desactivado`.

**Estrategia de integración (Fase 4):**

En lugar de reemplazar `ETLService` completo, añadir método dedicado:

```python
# apps/pipeline/services/etl_service.py
class ETLService:
    # ... método existente (mantener para compatibilidad) ...

    def run_sp_pipeline(self, quarter: str) -> dict:
        """
        Ejecuta el pipeline ETL via stored procedures MariaDB.
        Reemplaza la lógica extract/transform/load con SPs directos.
        """
        from django.db import connections
        with connections['ivr'].cursor() as cursor:
            cursor.callproc('sp_etl_maestro', [])
            ...
```

Esto evita romper la interfaz existente mientras integramos los SPs.

### Bug: `django_migrations` existe en ivr_legacy

La tabla `django_migrations` en ivr_legacy tiene 34 entradas de
`contenttypes` y `auth`, lo que indica que `manage.py migrate --database=ivr`
se ejecutó en algún momento.

El `DatabaseRouter.allow_migrate()` tiene un bug:
```python
if app_label in self.ivr_apps:  # ivr_apps = {'ivr'}
    return db == 'ivr'           # ← debería ser False siempre
```

Esto permite migrar el app `ivr` en la BD `ivr_legacy`, cuando el
intent era bloquear TODAS las migraciones en esa BD.

**Impacto en nuestro trabajo:** Las tablas IACT que creamos con SQL directo
(`schema_base_ivr.sql`) no usan el sistema de migraciones de Django.
El bug no nos afecta directamente. Se documenta como deuda técnica
en IACT-api para resolverse en sprint siguiente.

**Corrección futura (no aplicar ahora):**
```python
def allow_migrate(self, db, app_label, **hints):
    # NUNCA migrar en ivr_legacy — tablas se crean con SQL directo
    if db == 'ivr':
        return False
    return db == 'default'
```

---

## 4. Cambios aplicados en el entorno

### `IACT-api/callcentersite/config/settings/base.py`

Agregado `unix_socket` en la configuración de la BD `ivr`:

```python
# Antes (no conectaba en este entorno):
'ivr': {
    'OPTIONS': {
        'charset': 'utf8mb4',
        'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
    },
},

# Después (conecta vía socket Unix):
'ivr': {
    'OPTIONS': {
        'charset': 'utf8mb4',
        'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        'unix_socket': config('IVR_DB_SOCKET',
                              default='/run/mysqld/mysqld.sock'),
    },
},
```

### `IACT-api/callcentersite/.env`

Agregada variable:
```
IVR_DB_SOCKET=/run/mysqld/mysqld.sock
```

---

## 5. Implicaciones para fases siguientes

| Fase | Implicación identificada |
|---|---|
| Fase 1 | Despliegue con `< archivo.sql`. Nunca con `-e`. |
| Fase 1 | Llamar `mariadb_ensure.sh` antes de cada mysql |
| Fase 2 | Los SPs se testean con seed (50K filas). Los tiempos son menores que en prod. |
| Fase 2 | Q02_26 vacía — usar Q01_25 para tests |
| Fase 3 | Backfill durará segundos (no 50 min) por volumen del seed |
| Fase 4 | Integrar en `ETLService.run_sp_pipeline()`, no reemplazar `ETLService` |
| Fase 4 | No correr `migrate --database=ivr` — las tablas se crean con SQL directo |
| Fase 4 | `apps/pipeline/scheduler.py` ya tiene APScheduler — reutilizar |
| Fase 5 | `apps/pipeline/views.py` ya tiene `etl_status` — extender |
| Fase 6 | `etl_historico` en `job_config` debe quedar `is_enabled=FALSE` post-backfill |

---

## Ver también

- `BITACORA-IMPLEMENTACION.md` — registro detallado de cada task ejecutada
- `PLAN-IMPLEMENTACION-V2.md` — plan de 66 tareas que este análisis actualiza
- `FLUJO-ETL-V2.md` — arquitectura (CNST-ETL-007 requiere actualización)

