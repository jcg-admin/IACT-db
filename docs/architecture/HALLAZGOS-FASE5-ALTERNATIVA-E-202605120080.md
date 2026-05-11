# Hallazgos — Ejecución FASE 5 (Seguridad + archivado + documentación)

**Versión:** 1.0.0  
**Fecha:** 2026-05-11  
**Plan de referencia:** `PLAN-ALTERNATIVA-E-CONSOLIDADO-202605120030.md` FASE 5  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo |
|---|---|---|---|
| T-5.1 | `.env.example` — agregar variables faltantes | COMPLETO | H-F5-001 |
| T-5.2 | `mariadb/install.sh` — documentar securización TCP root | COMPLETO | — |
| T-5.3 | Archivar `seed_historico_real.sql` | COMPLETO | — |
| T-5.4 | `FLUJO-ETL-V2.1.md` — corregir H-ARCH-002 (3 errores + DDL) | COMPLETO | H-F5-002 |

---

## H-F5-001 — `.env.example` tenía 7 variables faltantes (no solo MARIADB_SOCK)

**Detectado en:** Pre-análisis de T-5.1  
**Severidad:** ALTA  
**Estado:** RESUELTO — T-5.1

El plan original (T-5.1) solo mencionaba documentar `MARIADB_SOCK`. La auditoría
cruzando `require_vars` de todos los scripts contra las variables en `.env.example`
reveló 7 variables faltantes:

| Variable | Script que la requiere | Razón de omisión |
|---|---|---|
| `ADMINER_IP` | `adminer/bootstrap.sh`, `adminer/config.sh` | No estaba en .env.example original |
| `ADMINER_HTTP_PORT` | `adminer/bootstrap.sh` | No estaba en .env.example original |
| `ADMINER_HTTPS_PORT` | `adminer/bootstrap.sh` | No estaba en .env.example original |
| `POSTGRES_PASSWORD` | `postgres/config.sh` | Agregado en FASE 1 pero no documentado en .env.example |
| `SSL_CN` | `adminer/ssl.sh` | No estaba en .env.example original |
| `MARIADB_SOCK` | `schema_historico.sh` | H-SEC-001 del plan |
| `RUN_ETL_BACKFILL` | `scripts/provision-mariadb.sh` | Agregado en FASE 4 pero no documentado |

Un operador que clonara el repo y copiara `.env.example` a `.env` habría recibido
errores crípticos de `require_vars` al aprovisionar Adminer o configurar PostgreSQL.

**Resolución:** Todas las variables agregadas con documentación de su propósito,
dónde se usa, y si es obligatoria u opcional.

---

## H-F5-002 — `FLUJO-ETL-V2.1.md` tenía 4 errores, no 3

**Detectado en:** Pre-análisis de T-5.4  
**Severidad:** MEDIA  
**Estado:** RESUELTO — T-5.4

El plan documentaba 3 errores en H-ARCH-002. La revisión del documento reveló
un cuarto error: el `CREATE TABLE etl_runs` en el documento tenía los mismos
nombres de columna incorrectos que el código Python.

Los 4 errores corregidos:

**Error 1 (L849):** Descripción de `sp_etl_historico`:
```
Antes: "habilita temporalmente etl_historico en job_config,
        corre el ETL, y deshabilita el job al terminar"
Después: "Escribe en job_execution_log (NO toca job_config).
          Flujo: sp_etl_base_detalle → sp_etl_base_clientes → sp_etl_validar"
```

**Error 2 (L242-290 Python, L548-562 DDL):** Nombres de columna incorrectos:

| Incorrecto (documento) | Correcto (BD real) |
|---|---|
| `iniciado_en` | `inicio_at` |
| `finalizado_en` | `fin_at` |
| `estado` | `status` |
| `mensaje_error` | `error_message` |
| `ejecutado_por` | `trigger_source` |
| idx_estado_inicio | `idx_status_inicio` |
| Faltaba `heartbeat_at` | Columna presente en BD |

**Error 3 (L269):** Heartbeat:
```
Antes:  while not stop_event.wait(timeout=120):  # check cada 2 min
Después: while not stop_event.wait(timeout=60):   # check cada 60s
```

**Error 4 (L548-562):** CREATE TABLE con columnas incorrectas — mismo problema
que Error 2 pero en el DDL de referencia. Corregido junto con Error 2.

---

## Cambios implementados — resumen

### `.env.example`

Agregadas 7 variables con documentación completa:
- Sección Adminer: `ADMINER_IP`, `ADMINER_HTTP_PORT`, `ADMINER_HTTPS_PORT`
- Sección SSL: `SSL_CN`
- Sección nueva PostgreSQL superusuario: `POSTGRES_PASSWORD`
- Sección configuración general: `MARIADB_SOCK` (comentada, opcional),
  `RUN_ETL_BACKFILL` (comentada, opcional)

### `provisioners/mariadb/install.sh`

Versión bump 2.1.0 → 2.2.0. Sección nueva en el header:

```
EFECTOS POST-INSTALACIÓN ejecutados por config.sh/_secure_mariadb():
  1. Usuarios anónimos eliminados
  2. root@TCP bloqueado (solo localhost/socket)
  3. Base de datos 'test' eliminada
  4. Password de root establecido
```

### `docs/referencias/scripts-sql/historico/seed_historico_real.sql`

Archivado desde `provisioners/mariadb/seed_historico_real.sql`.
No referenciado en ningún script activo.
Motivo: referenciaba `@FORCE_RESEED` y `sp_seed_historico_real` eliminados en
`seed_historico.sql` v3.0.0.

Creado `docs/referencias/scripts-sql/historico/README.md` con documentación
de la razón del archivado y los reemplazos actuales.

### `docs/architecture/FLUJO-ETL-V2.1.md`

4 correcciones (H-ARCH-002):
- L849: descripción sp_etl_historico
- L242-290: columnas en código Python de run_etl
- L269: heartbeat timeout 120→60
- L548-562: DDL CREATE TABLE etl_runs con columnas correctas

---

## Estado de hallazgos del plan tras FASE 5

| Hallazgo | Descripción | Estado |
|---|---|---|
| H-SEC-001 | `MARIADB_SOCK` no documentada en `.env.example` | RESUELTO — T-5.1 |
| H-SEC-002 | Securización TCP root no documentada en `install.sh` | RESUELTO — T-5.2 |
| H-SEC-003 | Efectos de `_secure_mariadb` no documentados | RESUELTO — T-5.2 |
| H-ARCH-001 | `seed_historico_real.sql` obsoleto en `provisioners/` | RESUELTO — T-5.3 |
| H-ARCH-002 | `FLUJO-ETL-V2.1.md` con 3 errores (sp_etl_historico, columnas, heartbeat) | RESUELTO — T-5.4 |
| H-F5-001 | 7 variables faltantes en `.env.example` (no solo MARIADB_SOCK) | RESUELTO — T-5.1 |
| H-F5-002 | 4 errores en FLUJO-ETL-V2.1.md (no 3): DDL de etl_runs también incorrecto | RESUELTO — T-5.4 |
