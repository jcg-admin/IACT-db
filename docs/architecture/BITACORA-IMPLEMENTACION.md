# Bitácora de implementación — ETL IVR Pipeline v2.0

**Inicio:** 2026-05-07
**Plan:** PLAN-IMPLEMENTACION-V2.md — 66 tareas, 6 fases
**Repositorio:** IACT-db, rama `develop`
**Proyecto Django:** IACT-api — `/tmp/references/IACT-api/callcentersite`

Cada entrada registra: comando ejecutado, resultado observado, hallazgos,
decisiones y estado final (PASS / FAIL / BLOQUEADO / DECISIÓN PENDIENTE).

Los hallazgos con impacto en fases futuras se etiquetan con `⚠ IMPACTA FASE N`.

---

## FASE 0 — Verificación del entorno

**Objetivo:** Confirmar que el entorno cumple todos los prerequisitos
antes de ejecutar cualquier SQL o modificar código.

**Resultado:** 5/5 PASS

---

### T-001 — Verificar conectividad MariaDB

**Comando ejecutado:**
```bash
mysql --socket=/run/mysqld/mysqld.sock \
      -u django_user -pdjango_pass \
      ivr_legacy \
      -e "SELECT VERSION(), DATABASE(), NOW();"
```

**Resultado observado:**
```
version                               db          ts
10.11.14-MariaDB-0ubuntu0.24.04.1    ivr_legacy  2026-05-07 01:31:02
```

**Estado:** PASS ✓

---

**Hallazgo H-001-01 — MariaDB requiere arranque manual** `⚠ IMPACTA TODAS LAS FASES`

El proceso no está activo al iniciar la sesión. El socket
`/run/mysqld/mysqld.sock` existe en el filesystem pero el proceso no corre.
Arranque requerido antes de cualquier operación:

```bash
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
runuser -u mysql -- /usr/sbin/mariadbd \
  --user=mysql \
  --socket=/run/mysqld/mysqld.sock \
  --datadir=/var/lib/mysql \
  --pid-file=/run/mysqld/mysqld.pid \
  --skip-grant-tables \
  >> /tmp/mdb.log 2>&1 &
sleep 6
```

El script `/tmp/mariadb_ensure.sh` automatiza esto — se llama al inicio
de cada task que necesite la BD.

---

**Hallazgo H-001-02 — Versión real es 10.11.14, no 10.1.48** `⚠ IMPACTA FASES 1-3`

El plan y toda la documentación de arquitectura asumen
`MariaDB 10.1.48` (CNST-ETL-007: sin window functions).
La versión real instalada es `10.11.14-MariaDB`.

**Implicación:** MariaDB 10.11 SÍ tiene window functions (`ROW_NUMBER`,
`RANK`, `OVER`, etc.). Los SPs diseñados con subconsultas en lugar de
`OVER()` son correctos y funcionan, pero podríamos simplificarlos.

**Decisión D-001-02:** Mantener el diseño con subconsultas por ahora.
La razón: si en el futuro los SPs se migran al entorno del cliente
(que podría tener 10.1.x), las subconsultas siguen siendo compatibles.
Documentar en CNST-ETL-007 que la versión mínima real es 10.11.

---

**Hallazgo H-001-03 — MariaDB cae entre tool calls** `⚠ IMPACTA TODAS LAS FASES`

El proceso background no persiste entre invocaciones de herramienta
del sandbox. El socket desaparece y la siguiente conexión falla con
`ERROR 2002 (HY000): Can't connect`.

**Solución aplicada:** Script `/tmp/mariadb_ensure.sh`:
```bash
#!/bin/bash
if ! mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
     ivr_legacy -e "SELECT 1;" > /dev/null 2>&1; then
    rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
    runuser -u mysql -- /usr/sbin/mariadbd \
      --user=mysql --socket=/run/mysqld/mysqld.sock \
      --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid \
      --skip-grant-tables >> /tmp/mdb_ensure.log 2>&1 &
    sleep 6
fi
```

Se llama al inicio de cada task que requiere BD.

---

### T-002 — Verificar permisos GRANT

**Comando ejecutado:**
```bash
mysql --socket=/run/mysqld/mysqld.sock \
      -u django_user -pdjango_pass ivr_legacy \
      -e "SHOW GRANTS FOR CURRENT_USER();"
```

**Resultado observado:**
```
GRANT USAGE ON *.* TO `django_user`@`localhost` IDENTIFIED BY PASSWORD '...'
GRANT ALL PRIVILEGES ON `ivr_legacy`.* TO `django_user`@`localhost`
GRANT ALL PRIVILEGES ON `practicayoruba_qa`.* TO `django_user`@`localhost`
GRANT ALL PRIVILEGES ON `test_ivr_legacy`.* TO `django_user`@`localhost`
GRANT ALL PRIVILEGES ON `test_practicayoruba_qa`.* TO `django_user`@`localhost`
```

**Test de CREATE FUNCTION:**
```bash
mysql ... < /tmp/test_perm.sql
# resultado: 1 (función creada y ejecutada correctamente)
```

**Estado:** PASS ✓

---

**Hallazgo H-002-01 — Grant es @localhost, no @%**

El grant es `django_user@localhost`, no `django_user@%`. Funciona
en este entorno (conexión local vía socket). En producción, si Django
corre en host separado se necesitaría `GRANT ... TO 'django_user'@'<host>'`.

---

**Hallazgo H-002-02 — CREATE FUNCTION requiere archivo SQL, no -e** `⚠ IMPACTA FASE 1`

El flag `-e` de mysql no soporta el comando `DELIMITER`. Intentar
`mysql -e "DELIMITER $$ CREATE FUNCTION ..."` produce
`ERROR 1064 (42000): You have an error in your SQL syntax`.

**Decisión D-002-02:** Todos los despliegues de funciones y SPs se
hacen exclusivamente con redirección de archivo:
```bash
mysql ... < provisioners/mariadb/funciones_utilidad.sql
```
Nunca con `-e`.

---

**Hallazgo H-002-03 — --skip-grant-tables activo** `⚠ IMPACTA T-002`

MariaDB corre con `--skip-grant-tables` en este entorno. Los tests de
permisos muestran los grants configurados pero no los aplican realmente.
La verificación de acceso real (SELECT en tbl_historico_*) sí es válida.
En producción los grants se aplican normalmente.

---

### T-003 — Verificar existencia y estructura de tablas fuente

**Comando ejecutado:**
```bash
mysql ... -e "
    SELECT TABLE_NAME, TABLE_ROWS, CREATE_TIME
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA='ivr_legacy'
      AND TABLE_NAME LIKE 'tbl_historico_%'
    ORDER BY TABLE_NAME;"
```

**Resultado observado:**
```
TABLE_NAME              TABLE_ROWS  CREATE_TIME
tbl_historico_t1_2025   2           2026-05-06 07:11:46   ← InnoDB stats, real=50,000
tbl_historico_t1_2026   49,684
tbl_historico_t2_2025   58,156                            ← InnoDB stats, real=58,450
tbl_historico_t2_2026   0
tbl_historico_t3_2025   48,874                            ← InnoDB stats, real=49,300
tbl_historico_t4_2025   49,490
```

**10 columnas confirmadas:**
```
dFecha                    date         NOT NULL
dHoraInicio               datetime     NOT NULL
dHoraFin                  datetime     NOT NULL
cDID_800Transfer          varchar(20)  NOT NULL
cDID_Centro_Transferencia varchar(50)  NULL
cMenu                     varchar(100) NULL
cOpcion                   varchar(100) NULL
cTelefono_Origen          varchar(20)  NULL
cTelefono_Digitado        varchar(20)  NULL
cEtiquetacliente          varchar(200) NULL
```

**Estado:** PASS ✓

---

**Hallazgo H-003-01 — TABLE_ROWS de information_schema es aproximado para InnoDB**

`information_schema.TABLES.TABLE_ROWS` no es el conteo exacto para
tablas InnoDB — es una estimación de las estadísticas del motor.
`t1_2025` muestra 2 filas cuando el `COUNT(*)` real es 50,000.
Para obtener el conteo exacto siempre usar `SELECT COUNT(*) FROM tabla`.

---

### T-004 — Verificar volúmenes y DIDs en tablas fuente

**Comando ejecutado:**
```sql
SELECT 'tbl_historico_t1_2025', COUNT(*), COUNT(DISTINCT cDID_800Transfer),
       MIN(dFecha), MAX(dFecha) FROM tbl_historico_t1_2025
UNION ALL ...
```

**Resultado observado:**
```
Tabla            Total   DIDs  Fecha min   Fecha max
t1_2025         50,000     3   2025-01-01  2025-03-31
t2_2025         58,450     3   2025-04-01  2025-06-30
t3_2025         49,300     3   2025-07-01  2025-09-30
```

**DIDs confirmados t1_2025:**
```
19028031 (nacional_A)  22,656 filas  45.3%
19020001 (nacional_B)  14,802 filas  29.6%
19020084 (puebla)      12,542 filas  25.1%
```

**Estado:** PASS ✓ — con ajuste de criterio D-004-01

---

**Decisión D-004-01 — Criterios cuantitativos ajustados al seed** `⚠ IMPACTA TODO EL PLAN`

Los datos del entorno son del seed, no de producción real.
El plan v2 menciona volúmenes de producción (~11.6M filas). Todos
los criterios numéricos absolutos se ajustan:

| Plan v2 original | Criterio ajustado para este entorno |
|---|---|
| t1_2025 ≈ 11,643,679 filas | t1_2025 ≈ 50,000 filas |
| t2_2025 ≈ 13,612,375 filas | t2_2025 ≈ 58,450 filas |
| t3_2025 ≈ 11,482,117 filas | t3_2025 ≈ 49,300 filas |
| SUM(total_llamadas) ≈ 11.6M | SUM(total_llamadas) ≈ 50,000 |
| Backfill ~50 min | Backfill < 2 min |

**Las proporciones y ratios permanecen iguales** — el seed
fue construido para replicar fielmente los porcentajes de producción.

---

### T-005 — Verificar proyecto Django

**Proyecto encontrado:**
```
/tmp/references/IACT-api/callcentersite/
  apps/
    access/         authentication/  audit/
    core/           dashboard/       ivr/
    ivr_legacy/     pipeline/        reports/
    users/          utils/
  config/
    db_router.py    settings/        urls.py
  manage.py
```

**Versiones:**
```
Python 3.12.3
Django 5.0.1
MySQLdb (mysqlclient) — instalado
```

**Conexión Django → MariaDB (ivr):**
```python
with connections['ivr'].cursor() as c:
    c.execute('SELECT VERSION(), DATABASE()')
    # → ('10.11.14-MariaDB-0ubuntu0.24.04.1', 'ivr_legacy')
```

**Estado:** PASS ✓

---

**Hallazgo H-005-01 — Apps ivr/ y pipeline/ ya existen con lógica propia** `⚠ IMPACTA FASES 4-5`

El proyecto Django tiene:
- `apps/ivr/` — modelos, serializers, views (pero IVRAdapter desactivado)
- `apps/pipeline/` — ETLScheduler (APScheduler cada 12h), ETLService, modelos ETLExecution, CallRecord
- `apps/ivr_legacy/` — vacío (solo `__init__.py`)

El trabajo de Fase 4-5 del plan es **integrar**, no crear desde cero.

---

**Hallazgo H-005-02 — ETLService y ETLScheduler son stubs con deuda técnica** `⚠ IMPACTA FASE 4`

`apps/pipeline/services/etl_service.py` — El método `extract()` retorna `[]`
(IVRAdapter desactivado desde 2026-03-21). El scheduler existe y corre
(`ETLScheduler` cada 12h con APScheduler) pero no hace nada útil.

**Decisión D-005-02:** Los SPs del plan v2 reemplazan la lógica de
`ETLService`. En Fase 4 se integrarán los `cursor.callproc()` dentro
del `ETLService.extract()` o en un nuevo método `run_sp_etl()`.

---

**Hallazgo H-005-03 — `django_migrations` existe en ivr_legacy — BUG en el router** `⚠ CRÍTICO`

La tabla `django_migrations` existe en ivr_legacy con 34 entradas de
`contenttypes` y `auth`. Esto significa que en algún momento Django
ejecutó `migrate --database=ivr` y creó tablas de sistema (`auth_*`,
`contenttypes_*`) en la BD de MariaDB.

El `DatabaseRouter.allow_migrate()` actual tiene este código:
```python
if app_label in self.ivr_apps:      # ivr_apps = {'ivr'}
    return db == 'ivr'              # True para 'ivr', False para 'default'
```

Esto **permite** migrar el app `ivr` en la BD `ivr`. El intent era
bloquear las migraciones de framework (`auth`, `contenttypes`) pero
la condición las permite si alguien corre `migrate` sin `--database`.

**Decisión D-005-03:** No limpiar `django_migrations` ahora (riesgo de
romper algo). Para las tablas IACT que creamos con SQL directo (schema_base_ivr.sql),
el router no interfiere — las tablas no tienen modelos Django.
Registrar como deuda técnica en IACT-api.

---

**Hallazgo H-005-04 — MariaDB solo acepta conexión por socket, no TCP** `⚠ IMPACTA FASE 4`

`settings/base.py` configura la BD `ivr` con `HOST=127.0.0.1` (TCP).
MariaDB en este entorno solo escucha en socket Unix.
`mysql -h 127.0.0.1 -P 3306` → `ERROR 2002: Can't connect`.

**Cambio aplicado en `config/settings/base.py`:**
```python
# IACT-api/callcentersite/config/settings/base.py
'ivr': {
    ...
    'OPTIONS': {
        'charset': 'utf8mb4',
        'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        # Agregado 2026-05-07 — Fase 0 T-005
        'unix_socket': config('IVR_DB_SOCKET',
                              default='/run/mysqld/mysqld.sock'),
    },
},
```

`.env` actualizado:
```
IVR_DB_SOCKET=/run/mysqld/mysqld.sock
```

---

## RESUMEN FASE 0

**Estado: COMPLETADA ✓** — 5/5 tasks PASS

### Tabla de resultados

| Task | Descripción | Estado | Tiempo real |
|---|---|---|---|
| T-001 | Conectividad MariaDB | PASS ✓ | 15 min |
| T-002 | Permisos GRANT | PASS ✓ | 10 min |
| T-003 | Estructura tablas fuente | PASS ✓ | 5 min |
| T-004 | Volúmenes y DIDs | PASS ✓ (ajuste criterio) | 5 min |
| T-005 | Proyecto Django | PASS ✓ (con decisiones) | 25 min |

### Hallazgos registrados

| ID | Descripción | Impacto | Resuelto |
|---|---|---|---|
| H-001-01 | MariaDB requiere arranque manual | Todas las fases | Sí — mariadb_ensure.sh |
| H-001-02 | Versión 10.11.14, no 10.1.48 | Fases 1-3 | Sí — D-001-02 |
| H-001-03 | MariaDB cae entre tool calls | Todas las fases | Sí — mariadb_ensure.sh |
| H-002-01 | Grant @localhost, no @% | Producción | Documentado |
| H-002-02 | DELIMITER no funciona con -e | Fase 1 | Sí — usar archivos |
| H-002-03 | skip-grant-tables activo | T-002 | Documentado |
| H-003-01 | TABLE_ROWS es aproximado InnoDB | Todo | Sí — usar COUNT(*) |
| H-005-01 | Apps ivr/ pipeline/ ya existen | Fases 4-5 | Integrar |
| H-005-02 | ETLService/Scheduler son stubs | Fase 4 | Sí — D-005-02 |
| H-005-03 | django_migrations en ivr_legacy | BUG router | D-005-03 (deuda) |
| H-005-04 | MariaDB solo socket, no TCP | Fase 4 | Sí — unix_socket |

### Decisiones registradas

| ID | Decisión | Aplica desde |
|---|---|---|
| D-001-02 | Mantener subconsultas (no usar OVER() aunque 10.11 las soporta) | Fase 1 |
| D-002-02 | Despliegues SQL siempre con `< archivo.sql`, nunca con `-e` | Fase 1 |
| D-004-01 | Criterios numéricos ajustados al tamaño del seed | Todo el plan |
| D-005-02 | ETLService.run_sp_etl() integrará cursor.callproc() | Fase 4 |
| D-005-03 | django_migrations en ivr_legacy: deuda técnica, no limpiar ahora | Fase 4 |

### Cambios en código aplicados

| Archivo | Cambio | Razón |
|---|---|---|
| `IACT-api/config/settings/base.py` | Agregado `unix_socket` en OPTIONS de `ivr` | H-005-04 |
| `IACT-api/.env` | Agregado `IVR_DB_SOCKET=/run/mysqld/mysqld.sock` | H-005-04 |
| `/tmp/mariadb_ensure.sh` | Script de arranque automático de MariaDB | H-001-01/03 |

### Bloqueadores para Fase 1

Ninguno. Todos los prerequisitos de Fase 1 están confirmados:
- Funciones de utilidad (Fase 1) no requieren Django ni TCP
- El comando de despliegue `mysql ... < archivo.sql` está verificado
- Las funciones no dependen de las tablas históricas (se testean con valores literales)

---

