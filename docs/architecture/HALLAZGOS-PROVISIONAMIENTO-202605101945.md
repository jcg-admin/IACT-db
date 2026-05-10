# Hallazgos — Provisionamiento final IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Detectados durante ejecución de provisioners contra bases de datos reales

---

## Resumen del provisionamiento

| Componente | Estado | Observaciones |
|---|---|---|
| MariaDB — arranque | OK | Via `nohup su -s /bin/bash mysql` (persistente) |
| MariaDB — `ivr_legacy` BD + usuario | OK | Idempotente — ya existía |
| MariaDB — tablas históricas (6) | OK | `CREATE TABLE IF NOT EXISTS` via root |
| MariaDB — seed `tbl_historico_*` | FALLA | H-F3-003: `ERROR 1308 LEAVE` (bug pre-existente) |
| MariaDB — `tbl_temp_prueba_ivr` | OK | 3000 registros (idempotente) |
| MariaDB — funciones de utilidad | OK | 5/5 presentes |
| MariaDB — SPs ETL | OK | 5/5 presentes |
| MariaDB — SPs reporte | OK | 7/7 presentes |
| MariaDB — tablas analíticas | OK | 5/5 presentes |
| PostgreSQL — `iact_analytics` BD + usuario | OK | Idempotente — ya existía |
| PostgreSQL — extensiones opcionales | WARN | uuid-ossp, pg_trgm, hstore, citext no disponibles |
| verify.sh final | **26 OK, 0 WARN, 0 ERR** | EXIT 0 |

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-PROV-001 | `service mariadb` no mantiene el proceso vivo en contenedor sin init system | Infraestructura | ALTA | DOCUMENTADO |
| H-PROV-002 | PostgreSQL no tiene extensiones opcionales instaladas | Infraestructura | BAJA | DOCUMENTADO |
| H-PROV-003 | H-F3-003 confirmado en provisionamiento real (ERROR 1308) | Bug pre-existente | CRÍTICA | PENDIENTE |

---

## H-PROV-001 — `service mariadb` no mantiene el proceso vivo en contenedor

**Tipo:** Infraestructura — comportamiento de contenedor sin init system completo  
**Severidad:** ALTA  
**Estado:** DOCUMENTADO — workaround aplicado

### Descripción

El arranque via `service mariadb start` inicia el proceso pero no lo supervisa.
En este entorno de contenedor (sin systemd activo), el proceso `mariadbd` muere
cuando el subshell que lo inició termina. El patrón observado:

```
bash start.sh mariadb          → MariaDB arranca OK
bash setup.sh mariadb --full   → provisiona OK (MariaDB sigue vivo en el mismo proceso)
bash setup.sh postgres         → verify.sh interno detecta MariaDB caído
bash verify.sh                 → ERROR: MariaDB no responde
```

Entre la llamada a `setup.sh mariadb --full` y `setup.sh postgres`, la instancia
iniciada por `service mariadb start` muere silenciosamente. No hay mensaje de
error — el proceso simplemente ya no existe.

### Causa

`service mariadb start` en un contenedor Debian/Ubuntu sin systemd usa el script
`/etc/init.d/mariadb`. Este script hace `start-stop-daemon --start` con
`--background`, que arranca el proceso pero no lo supervisa. Sin un init system
como systemd o runit gestionando el ciclo de vida, el proceso no tiene supervisor
que lo relance si muere.

La raíz es que el entorno de contenedor no tiene un init system completo. El PID 1
es `bash` (o el proceso del entorno de ejecución), no `systemd` ni `runit`. Sin
el supervisor, mariadbd es un proceso huérfano que puede morir por cualquier señal
o límite de recursos sin reiniciarse.

### Workaround aplicado

Arranque directo con `nohup su -s /bin/bash mysql -c 'mariadbd ...' &`:

```bash
nohup su -s /bin/bash mysql -c '
mariadbd \
    --datadir=/var/lib/mysql \
    --socket=/run/mysqld/mysqld.sock \
    --pid-file=/run/mysqld/mysqld.pid \
    --log-error=/var/log/mysql/error.log \
    --bind-address=127.0.0.1 \
    --port=3306 \
    --innodb-use-native-aio=0
' > /tmp/mdb_persistent.log 2>&1 &
```

`nohup` desacopla el proceso del terminal. El `&` lo envía al background. El
proceso se convierte en huérfano y es adoptado por PID 1, persistiendo
independientemente del shell que lo inició.

### Impacto en `start.sh`

`start.sh` ya implementa este mismo patrón en su tercer nivel de arranque
(después de `service` y `systemctl`). El problema es que `service mariadb start`
(nivel 1) tiene éxito en el exit code pero no produce un proceso estable en este
entorno. `start.sh` devuelve 0 sin saber que el proceso morirá momentos después.

### Corrección requerida en `start.sh`

Detectar que el proceso iniciado por `service` no persiste y escalar al nivel
de arranque directo. Una forma es verificar el proceso tras un breve delay:

```bash
if service mariadb start 2>/dev/null; then
    sleep 2
    if mariadb_is_running; then
        log_info "start_mariadb: iniciado via service (estable)"
        started=true
    else
        log_warn "start_mariadb: service reportó OK pero el proceso no persiste"
        log_warn "start_mariadb: escalando a arranque directo"
    fi
fi
```

---

## H-PROV-002 — PostgreSQL sin extensiones opcionales

**Tipo:** Infraestructura  
**Severidad:** BAJA — extensiones marcadas como opcionales en `provisioners/postgres/setup.sh`  
**Estado:** DOCUMENTADO

### Descripción

El provisionamiento de PostgreSQL emitió 4 WARN:

```
WARN: Extensión uuid-ossp: no disponible (opcional)
WARN: Extensión pg_trgm: no disponible (opcional)
WARN: Extensión hstore: no disponible (opcional)
WARN: Extensión citext: no disponible (opcional)
```

Estas extensiones no están instaladas en el entorno de contenedor. El
provisioner las marca como opcionales y continúa sin error.

### Impacto

En el entorno de desarrollo de contenedor, sin estas extensiones:
- UUIDs generados por la BD no están disponibles (usar Python `uuid` en su lugar)
- Búsqueda trigram (`LIKE` eficiente) no disponible
- Tipos `hstore` y `citext` no disponibles

Para el flujo de `python manage.py migrate` del backend IACT-api, las
extensiones no bloquean la migración si los modelos Django no las usan
directamente. Verificar en `IACT-api` si algún modelo usa `HStoreField`,
`CITextField` o `UUIDField` con generación a nivel de BD.

### Instalación en entorno real (Vagrant/servidor)

```bash
apt-get install -y postgresql-contrib
# Luego en psql como superuser:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS citext;
```

---

## H-PROV-003 — H-F3-003 confirmado en provisionamiento real

**Tipo:** Confirmación de bug pre-existente documentado  
**Severidad:** CRÍTICA  
**Estado:** PENDIENTE — requiere plan de corrección activo

### Descripción

El provisionamiento real confirmó que `ERROR 1308: LEAVE with no matching label:
sp_seed_historico` ocurre en producción, no solo en tests aislados. El stored
procedure `sp_seed_historico` usa `DELIMITER $$` para su definición, que mysql
ignora en modo `--batch` con input desde pipe — el cuerpo del SP se divide en
sentencias separadas y `LEAVE sp_seed_historico` queda fuera de cualquier bloque.

Las 6 tablas `tbl_historico_*` existen con la estructura correcta pero tienen
0 registros. El pipeline ETL no tiene datos históricos sobre los que operar.

### Estado actual del entorno

```
tbl_historico_t1_2025: 0 registros
tbl_historico_t2_2025: 0 registros
tbl_historico_t3_2025: 0 registros
tbl_historico_t4_2025: 0 registros
tbl_historico_t1_2026: 0 registros
tbl_historico_t2_2026: 0 registros
```

verify.sh reporta las tablas como presentes (estructura OK) pero no verifica
contenido (H-F5-003: pendiente de evaluación de alcance).

### Corrección requerida

Ver `HALLAZGOS-FASE3-202605101800.md` — H-F3-003 tiene tres opciones
documentadas. La más directa: reemplazar el pipe en `my_exec_vars_root` por
escritura a archivo temporal y ejecución directa, preservando el procesamiento
de `DELIMITER` por el cliente mysql.

---

## Estado final del entorno

```
MariaDB  10.11.14  ivr_legacy     — 13 tablas, 19 routines
PostgreSQL 16      iact_analytics — BD lista para migrate

verify.sh: 26 OK, 0 WARN, 0 ERR, EXIT 0
```

El entorno está listo para:
- `python manage.py migrate` en IACT-api
- Pruebas de conectividad desde el backend Django
- Desarrollo de los endpoints que leen `ivr_legacy` (tablas analíticas y de prueba)

No está listo para:
- Endpoints que requieran datos en `tbl_historico_*` (H-F3-003 pendiente)
- Uso de extensiones PostgreSQL opcionales (H-PROV-002)
