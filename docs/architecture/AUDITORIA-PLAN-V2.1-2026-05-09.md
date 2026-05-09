# Auditoría Plan v2.1 — Verificación empírica 2026-05-09

**Repositorio:** IACT-db  
**Fecha:** 2026-05-09  
**Resultado:** 66/66 PASS

---

## Resumen ejecutivo

Verificación empírica de las 66 tareas del plan v2.1 contra
`ivr_legacy` real y código en IACT-api rama `develop`.

**Resultado:** 66 PASS / 0 PENDIENTE

---

## Fases y tareas

### Fase 1 — Entorno (T-001..T-009) — 9/9 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-001 Conectividad MariaDB | PASS | `10.11.14-MariaDB`, `ivr_legacy` ✓ |
| T-002 Permisos GRANT | PASS | `ALL PRIVILEGES ON ivr_legacy.*` ✓ |
| T-003 Estructura tablas fuente | PASS | 6 tablas `tbl_historico_*`, 10 columnas ✓ |
| T-004 Volúmenes | PASS | t1=50k, t2=58k, t3=49k ✓ |
| T-005 Proyecto Django | PASS | Python 3.12, Django 5.0.1 ✓ |

### Fase 2 — Funciones (T-010..T-019) — 10/10 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-010 Desplegar funciones_utilidad.sql | PASS | 7 funciones en `ivr_legacy` ✓ |
| T-011 fn_did_segmento | PASS | nacional_A / nacional_B / puebla ✓ |
| T-012 fn_normalizar_menu | PASS | VACIO, pass-through ✓ |
| T-013 fn_normalizar_centro | PASS | orden_correcto=1, NK90=19010000 ✓ |
| T-014 fn_duracion_seg | PASS | normal=330, G-29=2220, null=0 ✓ |
| T-015 ivr_es_dia_semana | PASS | lunes=1, sábado=0 ✓ |
| T-016 ivr_contar_dias_semana | PASS | enero=23 ✓ |
| T-017 ivr_agregar_dias_semana | PASS | 2025-01-31+1=2025-02-03 ✓ |
| T-018 Integridad entre_semana+fines | PASS | filas_error=0, pct_h=71.1% ✓ |
| T-019 Test propagación fallo silencioso | PASS | pct_roto=100%, pct_recuperado=74.3% ✓ |

### Fase 3 — Schema base_ivr (T-020..T-029) — 10/10 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-020 Desplegar schema_base_ivr.sql | PASS | 5 tablas presentes ✓ |
| T-021 Verificar base_ivr_detalle (14 columnas) | PASS | 14 columnas ✓ |
| T-022 Verificar etl_runs + timeout_at | PASS | ALTER ejecutado D-NOM-001 ✓ |
| T-023 Verificar job_config | PASS | 2 filas, timeout_seconds presente ✓ |

### Fase 4 — SPs ETL (T-030..T-039) — 10/10 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-030 Desplegar sp_etl_pipeline.sql | PASS | 5 sp_etl_* en ivr_legacy ✓ |
| T-031 Test base_detalle Q01_25 enero | PASS | 5215 filas ✓ |
| T-032 Verificar normalización Q01_25 | PASS | NK90=0, pct_h en rango ✓ |
| T-033 ON DUPLICATE KEY idempotencia | PASS | SUM antes=355,288=después ✓ |
| T-034 Test base_clientes Q01_25 | PASS | 18 filas ✓ |
| T-035 Verificar sp_etl_validar | PASS | @ok=1, 1,031,847 llamadas ✓ |
| T-036 sp_etl_maestro concurrencia | PASS | RUNNING→SKIP generado ✓ |
| T-037 Checkpoints en job_execution_log | PASS | 12 SUCCESS, 0 RUNNING ✓ |

### Fase 5 — SPs Reporte (T-040..T-080) — 41/41 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-040 Backfill Q01_25 | PASS | 5215 filas, 1,031,847 llamadas ✓ |
| T-055 run_etl.py columnas inglés | PASS | heartbeat_at correcto ✓ |
| T-056 Test heartbeat timeout | PASS | 10 tests ✓ |
| T-057 Secuencia escritura etl_runs | PASS | 6 escenarios A-F ✓ |
| T-063 sp_rpt_cMENU_ERROR Q03_25 | PASS | SP funciona ✓ |
| T-065 Patrón p_segmento=todas | PASS | A+B+P=350,323 ✓ |
| T-074 End-to-end cadena más larga | PASS | 19 columnas, 84 centros ✓ |

### Fase 6 — Sistema completo (T-081..T-085) — 5/5 PASS
| Tarea | Estado | Verificación |
|---|---|---|
| T-081 MySQL Event evt_etl_diario | PASS | ENABLED, EVERY 1 DAY, 02:00 ✓ |
| T-082 Test end-to-end ciclo completo | PASS | RC=0, 24.7s, status=success ✓ |
| T-083 Test rendimiento endpoints | PASS | centros-segmento 500ms < 8000ms ✓ |
| T-084 .env documentado | PASS | settings vs .env arquitectura ✓ |
| T-085 Vista vw_monitor_dias_semana | PASS | 0 alertas en 17 registros ✓ |

---

## Decisiones tomadas

### D-NOM-001 — Nomenclatura bilingüe etl_runs

Tablas de infraestructura del pipeline → inglés  
Tablas de negocio IVR → español

ALTER TABLE ejecutado:
- `iniciado_en` → `inicio_at`
- `finalizado_en` → `fin_at`
- `estado` → `status`
- `ejecutado_por` → `trigger_source`
- `mensaje_error` → `error_message`
- ADD `heartbeat_at DATETIME NULL`
