# Bitácora sesión 2026-05-09 — Plan v2.1 IACT-db

**Fecha:** 2026-05-09  
**Resultado:** 66/66 PASS

## Resumen

Sesión de verificación empírica y cierre del plan v2.1.
Todas las 66 tareas verificadas contra ivr_legacy real.

## Decisiones

### D-NOM-001 — Nomenclatura bilingüe

Tablas de infraestructura del pipeline usan inglés (coherente con
job_execution_log). Tablas de negocio IVR usan español.

ALTER TABLE etl_runs ejecutado:
```sql
ALTER TABLE etl_runs
  CHANGE iniciado_en   inicio_at      DATETIME NOT NULL,
  CHANGE finalizado_en fin_at         DATETIME NULL,
  CHANGE estado        status         ENUM('en_ejecucion','success','failed','timeout','skip'),
  CHANGE ejecutado_por trigger_source VARCHAR(100) DEFAULT 'scheduler',
  CHANGE mensaje_error error_message  TEXT NULL,
  ADD    heartbeat_at  DATETIME NULL AFTER timeout_at;
```

## Hallazgos clave

### H-SBX-001 — skip-grant-tables produce DEFINER vacío

MariaDB arrancado con `--skip-grant-tables` produce `DEFINER=@` en todos
los objetos creados. Fix: arrancar en modo normal con `--event-scheduler=ON`.

### H-SBX-002 — Event Scheduler requiere modo normal

Error 1577 con skip-grant-tables. Solución: `--event-scheduler=ON` en
flags del servidor + sin skip-grant-tables.

### H-ETL-001 — T-082 end-to-end verificado

`manage.py run_etl` → 24.7s → etl_runs.status=success → 3 checkpoints.

### H-ETL-002 — T-083 benchmark

centros-segmento: 500ms (WHILE O(n días)) < umbral 8000ms. OK.

## Estado final

- 7 funciones SQL — DEFINER=django_user@localhost
- 5 SPs ETL — DEFINER=django_user@localhost
- 7 SPs reporte — DEFINER=django_user@localhost
- evt_etl_diario — ENABLED, EVERY 1 DAY, 02:00:00
- vw_monitor_dias_semana — 0 alertas
- 6 quarters en base_ivr_detalle (~32k filas)
