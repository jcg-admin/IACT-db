# Hallazgos — Ejecución FASE 1 (Plan deuda cero)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Fuente:** `PLAN-DEUDA-CERO-202605102315.md` FASE 1

---

## Resumen de tareas

| Tarea | Descripción | Estado | Observación |
|---|---|---|---|
| T-1.1 | `my.cnf`: `event_scheduler=ON` | COMPLETO | |
| T-1.2 | `start.sh`: verificación de persistencia post-arranque | COMPLETO | |
| T-1.3 | `install.sh` postgres: repo PGDG dinámico | YA IMPLEMENTADO | H-F1-001 |
| T-1.4 | `pg_hba.conf`: regla `scram-sha-256` para socket | YA IMPLEMENTADO | H-F1-002 |
| T-1.5 | `bootstrap.sh`: guard BASH_SOURCE en `setup.sh` | YA IMPLEMENTADO | H-F1-003 |
| T-1.6 | `bootstrap.sh`: normalizar `DB_POSTGRES_NAME` | YA IMPLEMENTADO | H-F1-004 |
| T-1.7 | `postgresql-contrib`: instalar | YA INSTALADO | H-F1-005 |

---

## Hallazgos de la ejecución

| ID | Hallazgo | Tipo | Estado |
|---|---|---|---|
| H-F1-001 | T-1.3 ya implementado en `install.sh` v1.0.5 — codename dinámico presente | Plan desactualizado | DOCUMENTADO |
| H-F1-002 | T-1.4 ya implementado — `pg_hba.conf` tiene `local all django_user scram-sha-256` | Plan desactualizado | DOCUMENTADO |
| H-F1-003 | T-1.5 ya implementado — `setup.sh` tiene guard `BASH_SOURCE[0] == 0` | Plan desactualizado | DOCUMENTADO |
| H-F1-004 | T-1.6 ya implementado — `bootstrap.sh` usa `DB_POSTGRES_NAME` consistentemente | Plan desactualizado | DOCUMENTADO |
| H-F1-005 | T-1.7 ya instalado — `postgresql-contrib 16+257build1.1` estaba presente | Plan desactualizado | DOCUMENTADO |

---

## H-F1-001..H-F1-005 — Plan desactualizado en 5 de 7 tareas

**Tipo:** El plan fue redactado en base a hallazgos documentados sin verificar
el estado real del repositorio en el momento de la ejecución.

Las cinco tareas marcadas como PENDIENTE en los documentos de hallazgos ya
habían sido implementadas en sesiones anteriores al plan pero antes de que
el plan fuera escrito:

| Tarea | Implementado en | Commit/versión |
|---|---|---|
| T-1.3 (PGDG dinámico) | `install.sh` v1.0.5 | referencia H-PG-003 |
| T-1.4 (pg_hba scram) | `provisioners/postgres/setup.sh` | sesión 2026-05-09 |
| T-1.5 (BASH_SOURCE guard) | `setup.sh` línea 141, H-PG-005 | sesión 2026-05-09 |
| T-1.6 (DB_POSTGRES_NAME) | `bootstrap.sh` línea 43..65 | sesión 2026-05-09 |
| T-1.7 (postgresql-contrib) | `postgresql-contrib 16+257build1.1` | instalación base |

**Lección:** Antes de ejecutar cualquier tarea de un plan, verificar el estado
real del artefacto en la BD/FS/repositorio. La verificación cuesta segundos;
reimplementar algo ya hecho cuesta minutos y puede introducir regresiones.

---

## Tareas realmente implementadas en FASE 1

### T-1.1 — `my.cnf`: `event_scheduler=ON` (H-SRV-001)

Agregado en `/etc/mysql/mariadb.conf.d/50-server.cnf` sección `[mariadb-10.11]`:

```ini
event_scheduler = ON
```

Verificación post-reinicio:
```
SHOW GLOBAL VARIABLES LIKE 'event_scheduler';
→ event_scheduler | ON
```

El valor ahora persiste en todos los reinicios del servidor. `evt_etl_diario`
disparará automáticamente a las 02:00 AM sin intervención manual.

### T-1.2 — `start.sh`: verificación de persistencia (H-SRV-002)

Agregado `sleep 2 + mariadb_is_running` después de `service mariadb start`
y `systemctl start mariadb`. Si el proceso muere en los 2 segundos siguientes,
el script emite WARN y cae al siguiente nivel de la cadena de arranque en lugar
de marcar `started=true` con un proceso ya muerto.

```
service mariadb start → sleep 2 → mariadb_is_running?
  SÍ → started=true, log "persistencia OK"
  NO → log WARN "no persistió", caer a systemctl
```

Esto cierra el escenario H-PROV-001 documentado en múltiples sesiones:
en contenedores sin systemd, `service` retorna 0 pero el proceso muere
inmediatamente. El fallback a arranque directo (`nohup mariadbd`) ya existía
en la cadena — ahora se activa correctamente.

---

## Estado del entorno al cierre de FASE 1

```
event_scheduler:     ON (my.cnf + verificado en tiempo real)
MariaDB:             10.11.14 — corriendo, evt_etl_diario ENABLED
PostgreSQL:          16 — corriendo, scram-sha-256 para socket Unix
postgresql-contrib:  16+257build1.1 — instalado
pg_hba.conf:         local django_user scram-sha-256 — presente
start.sh:            persistencia verificada tras service/systemctl
verify.sh:           27 OK, 0 WARN, 0 ERR, EXIT 0
```
