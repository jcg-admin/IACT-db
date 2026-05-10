# Hallazgos — Event Scheduler y DEFINER — 2026-05-09

**Contexto:** Plan v2.1 — T-081, modo de arranque MariaDB

## H-081-01 — Error 1577 con --skip-grant-tables

```
ERROR 1577: Cannot proceed because system tables used by Event Scheduler
were found damaged at start of server
```

Con `--skip-grant-tables`, las tablas de sistema del Event Scheduler no
están disponibles. `CREATE EVENT` falla.

## H-081-02 — Error 1227 — SET GLOBAL requiere SUPER

```
ERROR 1227: Access denied; you need SUPER privilege for this operation
```

`django_user` no tiene SUPER. `SET GLOBAL event_scheduler = ON` debe ser
activado por el DBA en `my.cnf`, no desde Django.

## H-081-03 — DEFINER vacío @ bajo skip-grant-tables

Los objetos creados bajo `--skip-grant-tables` tienen `DEFINER=@`.
En producción fallará con:
```
ERROR 1449: The user specified as a definer (@) does not exist
```

## H-081-04 — Solución definitiva

Arrancar MariaDB sin `--skip-grant-tables` con `--event-scheduler=ON`:

```python
subprocess.Popen([
    '/usr/sbin/mariadbd', '--user=mysql',
    '--socket=/run/mysqld/mysqld.sock',
    '--datadir=/var/lib/mysql',
    '--pid-file=/run/mysqld/mysqld.pid',
    '--innodb-buffer-pool-size=64M',
    '--event-scheduler=ON',
    # SIN --skip-grant-tables
])
```

Resultado: `evt_etl_diario` con `DEFINER=django_user@localhost`.

## H-DEFINER-01 — Redespliegue de los 19 objetos

Todos los objetos redespleguados con `django_user` autenticado en modo normal.
Resultado: DEFINER=django_user@localhost en los 19 objetos.

## H-DEFINER-02 — Inventario de fuentes corregidas

| Fuente | Acción |
|---|---|
| `mariadb_ensure.sh` | Corregido — modo normal |
| `conftest.py` tests | Corregido — sin skip-grant-tables |
| `tests/fixtures/ivr.py` | Corregido — credenciales explícitas |
| `backup_ivr_legacy.sh` | Se mantiene (solo mysqldump, BK-003) |
