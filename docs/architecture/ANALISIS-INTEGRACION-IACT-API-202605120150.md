# Análisis de integración — IACT-api con IACT-db

**Fecha:** 2026-05-11  
**Propósito:** Inventario completo de los planes de IACT-api, su relación
con IACT-db, y el estado actual de la integración verificado en el entorno.

---

## Resultado de la verificación (2026-05-11)

| Componente | Estado | Detalle |
|---|---|---|
| MariaDB 10.11.14 | ACTIVO | Puerto 3306, socket /run/mysqld/mysqld.sock |
| PostgreSQL 16 | ACTIVO | Puerto 5432 |
| Django → ivr_legacy (`ivr`) | CONECTADO | django_user, READ-ONLY (CNST-003) |
| Django → iact_analytics (`default`) | CONECTADO | django_user, READ+WRITE |
| tbl_historico_t1_2025 | 86,098 filas | Seed aplicado (IACT-db FASE 4-5) |
| base_ivr_detalle | 16,548 filas | 6 quarters procesados por ETL |
| base_ivr_clientes | 18 filas | Agregados por quarter |
| etl_runs | 3 filas | Historial de ejecuciones del job |
| SPs disponibles para Django | 12 | 5 ETL + 7 reporte |
| iact_analytics tablas | 0 | `python manage.py migrate` pendiente |

---

## Planes de IACT-api — inventario

IACT-api tiene 7 planes propios en `documentos/planes/`, todos anteriores
a la sesión actual. No fueron considerados en los análisis de IACT-db
porque son de un repositorio distinto con su propio ciclo de vida.

### plan_implementacion_v1.0.0 (708L)

**Fecha:** 2026-03-21  
**Estado:** Superado por v2.0.0

Plan fundacional. Identifica brechas iniciales: PostgreSQL no disponible
en el entorno de desarrollo, `manage.py migrate` pendiente, tests sin BD.

**Relación con IACT-db:** Menciona que PostgreSQL y MariaDB son prerequisitos
pero no estaban disponibles en ese momento.

---

### plan_implementacion_v2.0.0 (511L)

**Fecha:** 2026-03-21  
**Estado:** Superado por v2.0.1

Primer plan con BDs activas verificadas. Introduce brecha B-20: django_user
no tiene permisos `ALTER` en `test_ivr_legacy` — la BD de test de MariaDB.

**Relación con IACT-db:** B-20 es una brecha de permisos que IACT-db
controla. La decisión tomada en v2.3.0 fue Opción D (corregir el router
Django) en lugar de `GRANT ALTER` — sin cambios en IACT-db.

---

### plan_implementacion_v2.0.1 (437L)

**Fecha:** 2026-03-21  
**Estado:** Superado por v2.2.1

Diagnóstico de tests: 119 passed / 59 failed / 344 errors con BDs activas.
Introduce B-21 (`test_ivr_legacy` stale), B-22 (`KeyError: submenus`),
B-23 (validators).

**Relación con IACT-db:** B-21 es `test_ivr_legacy` ya existente en MariaDB
con esquema Django <1.8. IACT-db no crea ni gestiona `test_ivr_legacy` —
es la BD de test que Django crea automáticamente. Requiere
`mysql -u root -e "DROP DATABASE IF EXISTS test_ivr_legacy;"` manual.

---

### plan_implementacion_v2.2.1 (564L)

**Fecha:** 2026-03-21  
**Estado:** Superado por v2.3.0

Documenta la decisión sobre los 344 errores de setup de BD en tests de
MariaDB. Verifica que django_user tiene `CREATE, DROP` pero NO `ALTER`
en `test_ivr_legacy`.

**Relación con IACT-db:** Los grants de django_user en IACT-db son:
`GRANT SELECT ON ivr_legacy.*` (CNST-003, READ-ONLY). El grant
`CREATE, DROP ON test_ivr_legacy.*` es histórico y puede estar obsoleto.
IACT-db no gestiona `test_ivr_legacy`.

---

### plan_implementacion_v2.3.0 (657L)

**Fecha:** 2026-03-21  
**Estado:** ACTIVO — última versión del plan de implementación de IACT-api

**Decisión clave:** Opción D para resolver B-20/B-21:
- Corregir `db_router.allow_migrate` para que retorne `False` para `ivr`
  en lugar de `None` — evita migrations innecesarias en IVR
- `TEST: NAME: None` en la configuración de BD `ivr` — Django no crea
  `test_ivr_legacy` si NAME es None
- Eliminar `test_ivr_legacy` stale manualmente
- Sin cambios en permisos de IACT-db

**Relación con IACT-db:** Solo requiere que IACT-db tenga provisionado
correctamente ivr_legacy con los SPs y datos. Verificado: OK.

---

### PLAN_IVR_SIMPLIFICACION_20260321 (320L)

**Fecha:** 2026-03-21  
**Estado:** COMPLETADO

Simplifica la integración IVR: Python solo hace `SELECT` en
`tbl_temp_prueba_ivr`. Todo el código de administración de schema
MariaDB se marca como DEUDA TÉCNICA y se comenta.

**Relación con IACT-db:** Define explícitamente la separación:
- IACT-db: dueño del schema MariaDB (ivr_legacy), seed, SPs
- IACT-api: solo consume (`SELECT`) via `django_user`

**Estado en el código actual:** `tbl_temp_prueba_ivr` tiene 3000 filas
(verificado en IACT-db verify.sh). Django puede leerla.

---

### PLAN_REPARACION_TESTS_20260321 (213L)

**Fecha:** 2026-03-21  
**Estado:** COMPLETADO (13/13 passing en tests ivr_legacy)

Repara los tests de `tests/unit/ivr_legacy/` que fallaban por
`ModuleNotFoundError: apps.ivr_legacy` (módulo renombrado a `apps.ivr`).

**Relación con IACT-db:** Sin dependencia directa.

---

## Puntos de integración entre IACT-api e IACT-db

### 1. Conexión a ivr_legacy (READ-ONLY)

CNST-003 establece que `django_user` tiene solo `SELECT` en `ivr_legacy.*`.
Esto se aprovisiona en `IACT-db/provisioners/mariadb/setup.sh`.

**Estado actual:** ACTIVO. Django conecta correctamente.

### 2. Tablas que IACT-api lee en ivr_legacy

| Tabla | Filas actuales | Gestionada por |
|---|---|---|
| `tbl_historico_t1_2025`..`t4_2025`, `t1_2026`, `t2_2026` | 86K-99K c/u | IACT-db schema_historico.sh |
| `base_ivr_detalle` | 16,548 | IACT-db sp_etl_maestro |
| `base_ivr_clientes` | 18 | IACT-db sp_etl_maestro |
| `tbl_temp_prueba_ivr` | 3,000 | IACT-db schema_seed.sh |
| `job_config` | 1 | IACT-db schema_base_ivr.sql |
| `etl_runs` | 3 | IACT-api run_etl.py |
| `job_execution_log` | 35 | IACT-db sp_etl_maestro |

### 3. SPs que IACT-api llama (via `callproc`)

| SP | Propósito | Firma |
|---|---|---|
| `sp_etl_maestro` | Disparo ETL diario | `()` |
| `sp_rpt_clientes` | Reporte clientes únicos | `(p_quarter, p_did_segmento)` |
| `sp_rpt_centros_transferencia` | Centros de transferencia | `(p_quarter, p_menu)` |
| `sp_rpt_centros_xsegmento` | Centros por segmento DID | `(p_quarter, p_menu)` |
| `sp_rpt_menu_centro` | Menú → centro | `(p_quarter)` |
| `sp_rpt_menu_redirigidos` | Menús redirigidos | `(p_quarter)` |
| `sp_rpt_llamadas_abandonadas` | Llamadas abandonadas | `(p_quarter)` |
| `sp_rpt_cMENU_ERROR` | Errores cMENU | `(p_quarter)` |

**Nota:** Todos requieren que `base_ivr_detalle` tenga datos.
Con el ETL ejecutado (IACT-db FASE 4), los SPs ya tienen datos.

### 4. manage.py migrate — iact_analytics

`iact_analytics` en PostgreSQL tiene 0 tablas actualmente.
`python manage.py migrate` en IACT-api crea las tablas Django
(users, access, alerts, pipeline, etc.).

**Prerequisito:** IACT-db debe haber aprovisionado PostgreSQL con
`CREATE DATABASE iact_analytics OWNER django_user`. Verificado: OK.

---

## Pendiente en la integración

### P-1: `python manage.py migrate` no ejecutado

iact_analytics tiene 0 tablas. Los tests de `apps/` que usan PostgreSQL
fallan porque no existe el schema.

**Acción:** Ejecutar `python manage.py migrate` desde IACT-api.

### P-2: `test_ivr_legacy` stale en MariaDB

La BD `test_ivr_legacy` existe en MariaDB con esquema Django <1.8.
Bloquea la creación de la BD de test cuando Django intenta crearla.

**Acción (manual, requiere root):**
```sql
DROP DATABASE IF EXISTS test_ivr_legacy;
```

### P-3: DB router `allow_migrate` retorna None para `ivr`

El router Django para la BD `ivr` (MariaDB) debe retornar `False`
(no `None`) para evitar que Django intente ejecutar migrations en
`ivr_legacy`. Ver plan_implementacion_v2.3.0 Opción D.

**Acción:** Corregir `config/db_router.py` en IACT-api.

### P-4: `TEST: NAME: None` no configurado para BD `ivr`

Sin esta configuración, Django intenta crear `test_ivr_legacy`
durante los tests, lo que falla por permisos.

**Acción:** Agregar `'TEST': {'NAME': None}` en DATABASES['ivr']
de los settings de IACT-api.

---

## Estado del CNST-003 en el contexto actual

CNST-003 define: `django_user` tiene READ-ONLY en `ivr_legacy`.
IACT-db lo implementa via `GRANT SELECT ON ivr_legacy.* TO 'django_user'@...`.

Verificado en el entorno actual:
- Django puede leer todas las tablas de ivr_legacy
- Django NO puede escribir en ivr_legacy (correcto por diseño)
- El ETL escribe en ivr_legacy via stored procedures ejecutados como root
  (sp_etl_maestro corre con DEFINER = root@localhost)
- `etl_runs` es escritura de IACT-api — pero usa la conexión `ivr` READ-ONLY

**Problema identificado:** `etl_runs` es una tabla en `ivr_legacy` donde
IACT-api necesita hacer INSERT/UPDATE (para registrar las ejecuciones del
management command `run_etl`). Con CNST-003 (READ-ONLY), esto no es posible
con los permisos actuales.

Las opciones documentadas en IACT-api:
- `etl_runs` se mueve a `iact_analytics` (PostgreSQL, READ+WRITE)
- O se agrega un GRANT específico: `GRANT INSERT, UPDATE ON ivr_legacy.etl_runs`
