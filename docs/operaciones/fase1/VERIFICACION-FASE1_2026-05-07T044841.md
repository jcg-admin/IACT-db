# Verificacion Fase 1 — Plan V2.1

**Fecha:** 2026-05-07T051700
**Plan de referencia:** `docs/architecture/PLAN-IMPLEMENTACION-V2.1.md`
**Entorno:** Sandbox Ubuntu 24.04, MariaDB 10.11.14

---

## Resumen ejecutivo

| Tarea | Descripcion | Estado |
|---|---|---|
| T-010 | Desplegar funciones_utilidad.sql | PASA |
| T-011 | fn_did_segmento — 4 casos | PASA |
| T-012 | fn_normalizar_menu — 4 casos | PASA |
| T-013 | fn_normalizar_centro — 9 casos + orden de ramas | PASA |
| T-014 | fn_duracion_seg — normal / G-29 / null | PASA |
| T-015 | ivr_es_dia_semana — dias de semana + festivos | PASA |
| T-016 | ivr_contar_dias_semana — enero / Q2 / Q3 / edge cases | PASA |
| T-017 | ivr_agregar_dias_semana — 4 casos + validacion | PASA |
| T-018 | Integridad llamadas_entre_semana | DIFERIDA — requiere datos de T-032 |
| T-019 | Test fallo silencioso ivr_es_dia_semana | DIFERIDA — requiere datos de T-032 |
| T-020 | Desplegar schema_base_ivr.sql | PASA |
| T-021 | Verificar base_ivr_detalle — 14 columnas + 6 indices | PASA |
| T-022 | Verificar etl_runs con timeout_at | PASA |
| T-023 | Verificar job_config con datos iniciales | PASA |

**12 PASA / 2 DIFERIDAS. Se puede proceder a Fase 2.**

---

## T-010 — Desplegar funciones_utilidad.sql

**Resultado:** Script ejecutado sin errores. Seccion de verificacion interna:

| funcion | resultado |
|---|---|
| fn_did_segmento | nacional_A |
| fn_did_segmento_b | nacional_B |
| fn_normalizar_menu_null | VACIO |
| fn_normalizar_menu_vacio | VACIO |
| fn_normalizar_menu_ok | RES-FallaInternet |
| fn_normalizar_centro_null | CASO_NULL |
| fn_normalizar_centro_cc | CLIENTE_COLGO |
| fn_normalizar_centro_nk90 | 19010000 |
| fn_normalizar_centro_vdn | 10828091 |
| fn_duracion_seg_normal | 330 |
| fn_duracion_seg_g29 | 2220 |
| ivr_es_dia_semana_lunes | 1 |
| ivr_es_dia_semana_sabado | 0 |
| ivr_es_dia_semana_1enero | 1 |
| ivr_es_dia_semana_mayo1 | 1 |
| ivr_contar_dias_semana_enero | 23 |
| ivr_contar_dias_semana_q2 | 65 |
| ivr_contar_dias_semana_q3 | 66 |
| ivr_agregar_dias_semana | 2025-02-05 |

**Estado: PASA**

---

## T-011 — fn_did_segmento

**Resultado:**

| r1 | r2 | r3 | r4 |
|---|---|---|---|
| nacional_A | nacional_B | puebla | desconocido |

Criterio: los 4 valores coinciden exactamente.
**Estado: PASA**

---

## T-012 — fn_normalizar_menu

**Resultado:**

| r1 (NULL) | r2 ('') | r3 ('sin cMenu') | r4 ('RES-FallaInternet') |
|---|---|---|---|
| VACIO | VACIO | VACIO | RES-FallaInternet |

Criterio: 3 casos VACIO + pass-through exacto.
**Estado: PASA**

---

## T-013 — fn_normalizar_centro

**Resultado — 9 casos:**

| c1 | c2 | c3 | c4 | c5 | c6 | c7 | c8 | c9 |
|---|---|---|---|---|---|---|---|---|
| CASO_NULL | CASO_NULL | CLIENTE_COLGO | CASO_ERROR_CEROS | ERROR_CARACTER_INICIAL | 19010000 | 1309004 | 309004 | 10828091 |

**Test de orden de ramas (critico v2):**

| orden_correcto |
|---|
| 1 |

`'cliente_colgo'` (13 chars) se evalua ANTES que la rama `LENGTH > 10`.
Resultado correcto: `CLIENTE_COLGO`, no un truncado.

**Estado: PASA**

---

## T-014 — fn_duracion_seg

**Resultado:**

| normal | g29 | con_null |
|---|---|---|
| 330 | 2220 | 0 |

- normal = 330 (5m30s calculado correctamente)
- g29 = 2220 (positivo — correccion G-29 con ABS aplicada, 38.8% de registros)
- con_null = 0 (NULL en argumento manejado sin error)

**Estado: PASA**

---

## T-015 — ivr_es_dia_semana (v2.1)

**Resultado — dias basicos:**

| lunes | martes | sabado | domingo |
|---|---|---|---|
| 1 | 1 | 0 | 0 |

**Resultado — festivos nacionales en dia de semana (todos TRUE):**

| anio_nuevo | constitucion | juarez | dia_trabajo | independencia | revolucion | navidad |
|---|---|---|---|---|---|---|
| 1 | 1 | 1 | 1 | 1 | 1 | 1 |

Los 7 festivos nacionales que caen en dias de semana retornan TRUE.
Confirmado que el IVR opera esos dias — P-Semana-Santa CERRADO.

**Estado: PASA**

---

## T-016 — ivr_contar_dias_semana

**Resultado:**

| enero_2025 | q2_2025 | q3_2025 | mismo_dia_h | mismo_dia_f | rango_inv |
|---|---|---|---|---|---|
| 23 | 65 | 66 | 1 | 0 | 0 |

- enero_2025 = 23: correcto (1 ene=mier, 5 feb=mier, 21 mar=vie cuentan)
- q2_2025 = 65: coincide con el plan V2.1 (corregido de 64 en v2.0)
- q3_2025 = 66: coincide con el plan V2.1 (corregido de 65 en v2.0)
- mismo_dia_h = 1 (2025-01-15 es miercoles)
- mismo_dia_f = 0 (2025-01-11 es sabado)
- rango_inv = 0 (rango invertido manejado sin error)

**Estado: PASA**

---

## T-017 — ivr_agregar_dias_semana

**Resultado:**

| sig_dia | tres_dias | cinco_dias | cero_dias |
|---|---|---|---|
| 2025-02-03 | 2025-02-05 | 2025-02-07 | 2025-01-15 |

- sig_dia = 2025-02-03 (lunes — enero 31 es viernes, siguiente dia de semana)
- tres_dias = 2025-02-05 (miercoles — 5 feb es dia de semana con nueva logica)
- cinco_dias = 2025-02-07 (viernes)
- cero_dias = 2025-01-15 (sin cambio)

**Validacion extra — todos los resultados son dias de semana:**

| sig_es_semana | tres_es_semana | cinco_es_semana |
|---|---|---|
| 1 | 1 | 1 |

**Estado: PASA**

---

## T-018 — Integridad llamadas_entre_semana + llamadas_fines_semana

**Estado: DIFERIDA**

Requiere `base_ivr_detalle` con datos de Q01_25 (se genera en T-031/T-032 de Fase 2).
La tabla existe pero esta vacia. Se ejecuta inmediatamente despues de T-032.

---

## T-019 — Test fallo silencioso ivr_es_dia_semana

**Estado: DIFERIDA**

Misma dependencia que T-018. Se ejecuta junto con T-018 despues de T-032.

---

## T-020 — Desplegar schema_base_ivr.sql

**Resultado:** Script ejecutado sin errores. Verificacion interna:

| TABLE_NAME | filas_estimadas | CREATE_TIME |
|---|---|---|
| base_ivr_clientes | 0 | 2026-05-07 03:50:24 |
| base_ivr_detalle | 0 | 2026-05-07 04:04:09 |
| etl_runs | 0 | 2026-05-07 03:50:24 |
| job_config | 2 | 2026-05-07 03:50:24 |
| job_execution_log | 0 | 2026-05-07 03:50:24 |

5 tablas creadas. `job_config` ya tiene 2 filas (datos iniciales).

**Estado: PASA**

---

## T-021 — Verificar base_ivr_detalle (schema v2)

**Columnas (14):**

| Columna | Tipo | NULL |
|---|---|---|
| id | int(11) | NO |
| trimestre | varchar(10) | NO |
| fecha | varchar(6) | NO |
| segmento | varchar(20) | NO |
| centro_transferencia | varchar(100) | NO |
| menu | varchar(100) | NO |
| opcion | varchar(100) | NO |
| total_llamadas | int(11) | NO |
| misma_linea | int(11) | NO |
| linea_diferente | int(11) | NO |
| no_digito_telefono | int(11) | NO |
| llamadas_entre_semana | int(11) | NO |
| llamadas_fines_semana | int(11) | NO |
| cargado_en | datetime | NO |

**Indices (6):**

| Nombre | Unico | Columnas |
|---|---|---|
| PRIMARY | Si | id |
| uk_grain | Si | trimestre, fecha, segmento, centro_transferencia(50), menu(50), opcion(50) |
| idx_trim_seg_fecha | No | trimestre, segmento, fecha |
| idx_trim_menu | No | trimestre, menu |
| idx_trim_centro | No | trimestre, centro_transferencia |
| idx_fecha_seg | No | fecha, segmento |

14 columnas confirmadas incluyendo `llamadas_entre_semana` y `llamadas_fines_semana`.
6 indices incluyendo `uk_grain` que garantiza idempotencia del ETL.

**Estado: PASA**

---

## T-022 — Verificar etl_runs con timeout_at

**Schema confirmado:** 10 campos incluyendo `timeout_at datetime NOT NULL`.

**Indices:**

| Nombre | Columnas | Comentario |
|---|---|---|
| PRIMARY | id | |
| idx_estado_inicio | estado, iniciado_en DESC | |
| idx_trimestre | trimestre | |
| idx_timeout | estado, timeout_at | Usado por el heartbeat de Django |

**Test INSERT/DELETE:**
```
id=2, trimestre=TEST_T022, estado=en_ejecucion,
timeout_at=2026-05-07 05:17:48 (NOW() + 30 min)
```
INSERT exitoso. `timeout_at` acepta DATETIME. DELETE limpio.

**Estado: PASA**

---

## T-023 — Verificar job_config con datos iniciales

**Resultado:**

| job_name | is_enabled | timeout_seconds | notas |
|---|---|---|---|
| etl_diario | 1 | 1800 | ETL nocturno automatico. Procesa el quarter actual. |
| etl_historico | 0 | 7200 | Carga historica manual. Habilitar solo durante backfill inicial. |

2 filas con los valores correctos del plan.
`etl_historico.is_enabled = 0` — deshabilitado por defecto.

**Estado: PASA**

---

## Hallazgos registrados en esta fase

| ID | Severidad | Descripcion |
|---|---|---|
| H-F1-001 | INFO | MariaDB cae entre llamadas de herramienta — arranque adicional ~3s en cada sesion |
| H-F1-002 | INFO | T-018 y T-019 diferidas — dependen de datos de T-032 (Fase 2) |

**H-F1-001** es el comportamiento esperado del sandbox documentado en BK-001.
No afecta la correctitud de los resultados.

---

## Conclusion

12 de 14 tareas: PASA.
2 tareas diferidas (T-018, T-019) por dependencia en datos de Fase 2.
Sin hallazgos bloqueantes.

**Se puede proceder a Fase 2.**
