# Hallazgos IACT-db — Cierre Plan v2.1 — 2026-05-09

**Resultado:** 66/66 PASS

## Área 1 — Entorno sandbox

### H-SBX-001
Arrancar MariaDB sin --skip-grant-tables y con --event-scheduler=ON.
DEFINER correcto en todos los objetos.

### H-SBX-002
Event Scheduler Error 1577 con skip-grant-tables.
Solución: modo normal.

### H-SBX-003
T-019 requiere sesión continua de MariaDB (Popen).

## Área 2 — Pipeline ETL

### H-ETL-001 — T-082
manage.py run_etl: RC=0, 24.7s, 3 checkpoints, status=success.

### H-ETL-002 — T-083
Benchmark Q01_25 (5215 filas):
- centros: 88ms < 3000ms
- centros-segmento: 500ms < 8000ms
- Todos los endpoints dentro del umbral.

### H-ETL-003 — Estado ivr_legacy al cierre
6 quarters, ~32k filas, evt_etl_diario ENABLED,
vw_monitor_dias_semana 0 alertas.

## Área 3 — Arquitectura configuración IACT-api

### H-ARCH-001
Principio: decisiones → settings files, secretos → .env.

### H-ARCH-002
PostgreSQL socket Unix requiere pg_hba.conf scram-sha-256
para django_user antes de la línea peer genérica.

## Estado tests al cierre

| Suite | Resultado |
|---|---|
| tests/unit/ | 686 passed, 4 skipped |
| tests/integration/pipeline/ | 39 passed |
