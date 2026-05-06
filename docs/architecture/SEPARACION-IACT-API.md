# Separación de responsabilidades — IACT-db e IACT-api

**Fecha:** 2026-05-05  
**Estado:** Completado

---

## Propósito de este documento

Describe la relación entre los repositorios `IACT-db` e `IACT-api`,
qué gestiona cada uno, y cómo `IACT-api` consume las bases de datos
que `IACT-db` provee.

---

## División de responsabilidades

```
IACT-db                              IACT-api
──────────────────────────────────   ──────────────────────────────────
Instalar MariaDB y PostgreSQL        Instalar Python y dependencias pip
Crear BDs, usuarios, privilegios     Ejecutar migraciones Django
Sembrar datos de prueba              Ejecutar tests con pytest
Verificar conectividad               Configurar Apache para la API
Arrancar los servicios               Verificar implementación Django
```

IACT-db **no sabe nada** de Django, modelos, ni migraciones.
IACT-api **no gestiona** la instalación ni configuración de las BDs.

---

## Qué consume IACT-api de IACT-db

IACT-api consume exactamente dos bases de datos:

### PostgreSQL — `iact_analytics` (BD principal)

```
Host:     127.0.0.1
Puerto:   5432
BD:       iact_analytics
Usuario:  django_user
Password: django_pass
Permisos: READ + WRITE + CREATEDB (para que pytest cree test_iact_analytics)
```

Configurado en: `IACT-db/provisioners/postgres/setup.sh`  
Usado en: `IACT-api/callcentersite/config/settings/testing_local.py` → `'default'`

### MariaDB — `ivr_legacy` (BD legada, READ-ONLY)

```
Host:     127.0.0.1
Puerto:   3306
BD:       ivr_legacy
Usuario:  django_user
Password: django_pass
Permisos: SELECT únicamente (CNST-003)
          CREATE/DROP sobre test_ivr_legacy (para pytest)
```

Configurado en: `IACT-db/provisioners/mariadb/setup.sh`  
Usado en: `IACT-api/callcentersite/config/settings/testing_local.py` → `'ivr'`

El alias `'ivr'` es requerido por `config/db_router.py` de IACT-api.
Si se usara otro alias las queries a `apps.ivr` fallarían silenciosamente.

### Datos de prueba — `tbl_temp_prueba_ivr`

```
BD:         ivr_legacy
Tabla:      tbl_temp_prueba_ivr
Columnas:   id (PK), numero (CHAR 10)
Registros:  3000 (configurable con SEED_ROWS en .env)
```

Sembrado por: `IACT-db/provisioners/mariadb/schema_seed.sh`  
Consumido por: queries SELECT de `apps.ivr` en IACT-api

---

## Scripts de IACT-api que IACT-db reemplaza

Antes de que existiera IACT-db, los scripts de BD vivían en IACT-api.
La tabla siguiente muestra la correspondencia y las mejoras:

| Script original en IACT-api | Equivalente en IACT-db | Mejoras en IACT-db |
|---|---|---|
| `provisioners/mariadb/db_setup.sh` | `provisioners/mariadb/setup.sh` | Verificación CNST-003 post-GRANT |
| `provisioners/mariadb/schema_temp_prueba.sh` | `provisioners/mariadb/schema_seed.sh` | Verificación de longitud + muestra representativa |
| `provisioners/postgres/db_setup.sh` | `provisioners/postgres/setup.sh` | Equivalentes |
| `utils/database.sh` | `utils/database.sh` v1.1.0 | Arranque robusto, socket Unix, cleanup de stale |
| `bootstrap.sh phase_databases` | `setup.sh` | 7 verificaciones, contadores OK/WARN/ERR |

Los scripts originales de IACT-api se eliminarán en la siguiente iteración,
dejando solo los de ciclo de vida de la aplicación.

---

## Orden de ejecución en una sesión nueva

El entorno no tiene systemd como proceso 1, por lo que las BDs no
arrancan solas al iniciar la sesión. El orden correcto es:

```
Paso 1 — Arrancar MariaDB y PostgreSQL
  bash /ruta/a/IACT-db/start.sh
  # Maneja automáticamente: stale PIDs, socket, systemd/directo

Paso 2 — Configurar las BDs (idempotente)
  bash /ruta/a/IACT-db/setup.sh
  # Si no hay root: se re-ejecuta con sudo automáticamente

# O en un solo comando desde IACT-api (v2.0.0):
  sudo bash scripts/bootstrap.sh --iact-db=/ruta/a/IACT-db

Paso 3 — IACT-api: migrar y testear
  cd /ruta/a/IACT-api/callcentersite
  DJANGO_SETTINGS_MODULE=config.settings.testing_local \
    python manage.py migrate
  DJANGO_SETTINGS_MODULE=config.settings.testing_local \
    python -m pytest .
```

---

## Verificación del entorno antes de correr tests

```bash
# Desde IACT-db — verifica los 7 puntos del entorno de BD
bash verify.sh

# Salida esperada cuando todo está bien:
#   OK:           21
#   Advertencias: 0
#   Errores:      0
#   Entorno listo para desarrollo.
```

---

## Configuración de IACT-api en relación a IACT-db

Las credenciales en `IACT-db/.env` y en `IACT-api/config/settings/testing_local.py`
deben coincidir. Los valores por defecto de ambos repositorios ya coinciden
sin necesidad de ajuste manual.

Si se cambian credenciales en `IACT-db/.env`, hay que reflejar el mismo
cambio en `testing_local.py` de IACT-api.

### Configuración actual que funciona (verificada 2026-05-05)

```
IACT-db/.env              testing_local.py IACT-api
──────────────────────    ──────────────────────────────────
DB_POSTGRES_NAME=iact_analytics  → NAME: 'iact_analytics'
DB_POSTGRES_USER=django_user     → USER: 'django_user'
DB_POSTGRES_PASSWORD=django_pass → PASSWORD: 'django_pass'
POSTGRES_HOST=127.0.0.1          → HOST: '127.0.0.1'
POSTGRES_PORT=5432               → PORT: '5432'

DB_MARIADB_NAME=ivr_legacy       → NAME: 'ivr_legacy'
DB_MARIADB_USER=django_user      → USER: 'django_user'
DB_MARIADB_PASSWORD=django_pass  → PASSWORD: 'django_pass'
MARIADB_HOST=127.0.0.1           → HOST: '127.0.0.1'
MARIADB_PORT=3306                → PORT: '3306'
```

---

## Estado de la implementación

| Tarea | Estado |
|---|---|
| Crear IACT-db con todos los scripts de BD | Completado |
| Migrar de Vagrant a shell scripts puros | Completado |
| Cerrar gaps respecto a IACT-api/scripts | Completado |
| Verificar que IACT-api funciona con BDs de IACT-db | Completado |
| Eliminar scripts de BD duplicados en IACT-api | Completado — archivados en scripts/archive/ |
| Refactorizar `phase_databases` en IACT-api/bootstrap.sh | Completado — delega en IACT-db/setup.sh v2.0.0 |

---

## Referencias

- `IACT-api/scripts/documents/relacion_con_iact_db.md` — visión desde IACT-api
- `docs/architecture/MIGRACION-VAGRANT-A-SHELL.md` — cómo se llegó aquí
- `docs/getting-started/QUICKSTART.md` — cómo levantar el entorno
- `verify.sh` — verificación completa de las 7 secciones
