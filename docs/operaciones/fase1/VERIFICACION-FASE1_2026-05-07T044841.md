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

## Hallazgo transversal — H-F1-001: MariaDB cae entre llamadas

**Severidad:** INFO (comportamiento conocido del sandbox)
**Afecta:** T-010, T-020 y todas las tareas de esta fase.

MariaDB no persiste entre llamadas de herramienta. Antes de cada bloque
de SQL fue necesario rearrancarla con:

```bash
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
runuser -u mysql -- /usr/sbin/mariadbd \
    --user=mysql \
    --socket=/run/mysqld/mysqld.sock \
    --datadir=/var/lib/mysql \
    --pid-file=/run/mysqld/mysqld.pid \
    --skip-grant-tables >> /tmp/mdb_f1.log 2>&1 &

for i in $(seq 1 20); do
    mysql --socket=/run/mysqld/mysqld.sock -e "SELECT 1;" > /dev/null 2>&1 && break
    sleep 1
done
mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;" 2>/dev/null
```

Tiempo de arranque observado: 1-3 segundos.
En produccion MariaDB corre como servicio systemd — no aplica.
Referencia: HALLAZGOS-BACKUP.md BK-001, HALLAZGOS-ENTORNO.md H-001-03.

---

## T-010 — Desplegar funciones_utilidad.sql

**Comando:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/funciones_utilidad.sql
```

**Salida completa:**
```
funcion                         resultado
fn_did_segmento                 nacional_A
fn_did_segmento_b               nacional_B
fn_normalizar_menu_null         VACIO
fn_normalizar_menu_vacio        VACIO
fn_normalizar_menu_ok           RES-FallaInternet
fn_normalizar_centro_null       CASO_NULL
fn_normalizar_centro_cc         CLIENTE_COLGO
fn_normalizar_centro_nk90       19010000
fn_normalizar_centro_vdn        10828091
fn_duracion_seg_normal          330
fn_duracion_seg_g29             2220
ivr_es_dia_semana_lunes         1
ivr_es_dia_semana_sabado        0
ivr_es_dia_semana_1enero        1
ivr_es_dia_semana_mayo1         1
ivr_contar_dias_semana_enero    23
ivr_contar_dias_semana_q2       65
ivr_contar_dias_semana_q3       66
ivr_agregar_dias_semana         2025-02-05
```

**Criterio del plan:** Script ejecuta sin errores. Seccion de verificacion
interna retorna todos los valores esperados.
**Estado: PASA**

---

## T-011 — Verificar fn_did_segmento

**Comando:**
```sql
SELECT
    fn_did_segmento('19028031') AS r1,
    fn_did_segmento('19020001') AS r2,
    fn_did_segmento('19020084') AS r3,
    fn_did_segmento('99999999') AS r4;
```

**Salida:**
```
r1          r2          r3       r4
nacional_A  nacional_B  puebla   desconocido
```

**Criterio del plan:** Los 4 valores coinciden exactamente.
**Estado: PASA**

---

## T-012 — Verificar fn_normalizar_menu

**Comando:**
```sql
SELECT
    fn_normalizar_menu(NULL)                AS r1,
    fn_normalizar_menu('')                  AS r2,
    fn_normalizar_menu('sin cMenu')         AS r3,
    fn_normalizar_menu('RES-FallaInternet') AS r4;
```

**Salida:**
```
r1     r2     r3     r4
VACIO  VACIO  VACIO  RES-FallaInternet
```

**Criterio del plan:** 3 casos VACIO + pass-through exacto.
**Estado: PASA**

---

## T-013 — Verificar fn_normalizar_centro

**Comando:**
```sql
SELECT
    fn_normalizar_centro(NULL)                 AS c1,
    fn_normalizar_centro('')                   AS c2,
    fn_normalizar_centro('cliente_colgo')      AS c3,
    fn_normalizar_centro('00000000')           AS c4,
    fn_normalizar_centro('@1234567')           AS c5,
    fn_normalizar_centro('190100008190983030') AS c6,
    fn_normalizar_centro('13090048190983030')  AS c7,
    fn_normalizar_centro('3090048190983030')   AS c8,
    fn_normalizar_centro('10828091')           AS c9;

SELECT fn_normalizar_centro('cliente_colgo') = 'CLIENTE_COLGO' AS orden_correcto;
```

**Salida:**
```
c1         c2         c3             c4                  c5
CASO_NULL  CASO_NULL  CLIENTE_COLGO  CASO_ERROR_CEROS    ERROR_CARACTER_INICIAL

c6        c7       c8      c9
19010000  1309004  309004  10828091

orden_correcto
1
```

**Criterio del plan:** 9 casos exactos + `orden_correcto = 1`.
`'cliente_colgo'` (13 chars) evaluado ANTES que `LENGTH > 10`.

**Estado: PASA**

---

## T-014 — Verificar fn_duracion_seg

**Comando:**
```sql
SELECT
    fn_duracion_seg('2025-01-15 14:00:00', '2025-01-15 14:05:30') AS normal,
    fn_duracion_seg('2025-01-15 14:35:00', '2025-01-15 13:58:00') AS g29,
    fn_duracion_seg(NULL, '2025-01-15 14:00:00')                   AS con_null;
```

**Salida:**
```
normal  g29   con_null
330     2220  0
```

**Criterio del plan:** `normal=330`, `g29=2220` (positivo, G-29 corregido), `con_null=0`.
**Estado: PASA**

---

## T-015 — Verificar ivr_es_dia_semana (v2.1)

**Comando — dias basicos:**
```sql
SELECT
    ivr_es_dia_semana('2025-01-06') AS lunes,
    ivr_es_dia_semana('2025-01-07') AS martes,
    ivr_es_dia_semana('2025-01-04') AS sabado,
    ivr_es_dia_semana('2025-01-05') AS domingo;
```

**Salida:**
```
lunes  martes  sabado  domingo
1      1       0       0
```

**Comando — festivos nacionales en dia de semana:**
```sql
SELECT
    ivr_es_dia_semana('2025-01-01') AS anio_nuevo,
    ivr_es_dia_semana('2025-02-05') AS constitucion,
    ivr_es_dia_semana('2025-03-21') AS juarez,
    ivr_es_dia_semana('2025-05-01') AS dia_trabajo,
    ivr_es_dia_semana('2025-09-16') AS independencia,
    ivr_es_dia_semana('2025-11-20') AS revolucion,
    ivr_es_dia_semana('2025-12-25') AS navidad;
```

**Salida:**
```
anio_nuevo  constitucion  juarez  dia_trabajo  independencia  revolucion  navidad
1           1             1       1            1              1           1
```

**Criterio del plan v2.1:** lun-vie = TRUE. sab-dom = FALSE.
Festivos en dia de semana = TRUE (IVR opera esos dias). P-Semana-Santa CERRADO.
**Estado: PASA**

---

## T-016 — Verificar ivr_contar_dias_semana

**Comando:**
```sql
SELECT
    ivr_contar_dias_semana('2025-01-01','2025-01-31') AS enero_2025,
    ivr_contar_dias_semana('2025-04-01','2025-06-30') AS q2_2025,
    ivr_contar_dias_semana('2025-07-01','2025-09-30') AS q3_2025,
    ivr_contar_dias_semana('2025-01-15','2025-01-15') AS mismo_dia_h,
    ivr_contar_dias_semana('2025-01-11','2025-01-11') AS mismo_dia_f,
    ivr_contar_dias_semana('2025-03-31','2025-01-01') AS rango_inv;
```

**Salida:**
```
enero_2025  q2_2025  q3_2025  mismo_dia_h  mismo_dia_f  rango_inv
23          65       66       1            0            0
```

**Criterio del plan v2.1:**
- `enero_2025 = 23` (1 ene=mier, 5 feb=mier, 21 mar=vie cuentan como dias de semana)
- `q2_2025 = 65` (corregido en v2.1 desde 64 en v2.0)
- `q3_2025 = 66` (corregido en v2.1 desde 65 en v2.0)
- `rango_inv = 0`

**Estado: PASA**

---

## T-017 — Verificar ivr_agregar_dias_semana

**Comando:**
```sql
SELECT
    ivr_agregar_dias_semana('2025-01-31', 1) AS sig_dia,
    ivr_agregar_dias_semana('2025-01-31', 3) AS tres_dias,
    ivr_agregar_dias_semana('2025-01-31', 5) AS cinco_dias,
    ivr_agregar_dias_semana('2025-01-15', 0) AS cero_dias;

SELECT
    ivr_es_dia_semana(ivr_agregar_dias_semana('2025-01-31',1)) AS sig_es_semana,
    ivr_es_dia_semana(ivr_agregar_dias_semana('2025-01-31',3)) AS tres_es_semana,
    ivr_es_dia_semana(ivr_agregar_dias_semana('2025-01-31',5)) AS cinco_es_semana;
```

**Salida:**
```
sig_dia     tres_dias   cinco_dias  cero_dias
2025-02-03  2025-02-05  2025-02-07  2025-01-15

sig_es_semana  tres_es_semana  cinco_es_semana
1              1               1
```

**Analisis:**
- `sig_dia = 2025-02-03` (lunes — 31 ene es viernes)
- `tres_dias = 2025-02-05` (miercoles — 5 feb era festivo en v2.0, ahora dia de semana)
- `cinco_dias = 2025-02-07` (viernes)
- `cero_dias = 2025-01-15` (sin cambio)
- Los 3 resultados validados con `ivr_es_dia_semana()` = 1

**Criterio del plan:** Resultados son fechas de semana validas.
**Estado: PASA**

---

## T-018 — Integridad llamadas_entre_semana + llamadas_fines_semana

**Estado: DIFERIDA**

**Motivo:** `base_ivr_detalle` existe pero esta vacia — los datos se
generan en T-031/T-032 de Fase 2.

**Verificacion del estado:**
```sql
SELECT COUNT(*) FROM base_ivr_detalle;
-- Resultado: 0
```

Se ejecuta inmediatamente despues de T-032, antes de continuar con T-033.

---

## T-019 — Test fallo silencioso ivr_es_dia_semana

**Estado: DIFERIDA**

Misma dependencia que T-018. Se ejecuta junto con T-018 en Fase 2.

---

## T-020 — Desplegar schema_base_ivr.sql

**Comando:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/schema_base_ivr.sql
```

**Salida (seccion de verificacion interna del script):**
```
TABLE_NAME          filas_estimadas  CREATE_TIME
base_ivr_clientes   0                2026-05-07 03:50:24
base_ivr_detalle    0                2026-05-07 04:04:09
etl_runs            0                2026-05-07 03:50:24
job_config          2                2026-05-07 03:50:24
job_execution_log   0                2026-05-07 03:50:24
```

5 tablas presentes. `job_config` ya tiene 2 filas (datos iniciales del script).
**Estado: PASA**

---

## T-021 — Verificar base_ivr_detalle (schema v2)

**Comando:**
```sql
DESCRIBE base_ivr_detalle;
SHOW INDEX FROM base_ivr_detalle;
```

**Salida — DESCRIBE:**
```
column_name            column_type    is_nullable
id                     int(11)        NO
trimestre              varchar(10)    NO
fecha                  varchar(6)     NO
segmento               varchar(20)    NO
centro_transferencia   varchar(100)   NO
menu                   varchar(100)   NO
opcion                 varchar(100)   NO
total_llamadas         int(11)        NO
misma_linea            int(11)        NO
linea_diferente        int(11)        NO
no_digito_telefono     int(11)        NO
llamadas_entre_semana  int(11)        NO
llamadas_fines_semana  int(11)        NO
cargado_en             datetime       NO
```

**Salida — SHOW INDEX:**
```
Key_name            Non_unique  Column_name(s)
PRIMARY             0           id
uk_grain            0           trimestre, fecha, segmento,
                                centro_transferencia(50), menu(50), opcion(50)
idx_trim_seg_fecha  1           trimestre, segmento, fecha
idx_trim_menu       1           trimestre, menu
idx_trim_centro     1           trimestre, centro_transferencia
idx_fecha_seg       1           fecha, segmento
```

**Criterio del plan v2.1:** 14 columnas incluyendo `llamadas_entre_semana`,
`llamadas_fines_semana` y `cargado_en`. 6 indices incluyendo `uk_grain`.
**Estado: PASA**

---

## T-022 — Verificar etl_runs con timeout_at

**Comando:**
```sql
DESCRIBE etl_runs;

INSERT INTO etl_runs (trimestre, iniciado_en, timeout_at, estado, ejecutado_por)
VALUES ('TEST_T022', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE),
        'en_ejecucion', 'test_fase1');

SELECT id, trimestre, estado, timeout_at
FROM etl_runs WHERE trimestre='TEST_T022';

DELETE FROM etl_runs WHERE trimestre='TEST_T022';

SHOW INDEX FROM etl_runs;
```

**Salida — DESCRIBE (campos clave):**
```
Field          Type                                                    Null  Key
id             int(11)                                                 NO    PRI
trimestre      varchar(20)                                             NO    MUL
iniciado_en    datetime                                                NO
finalizado_en  datetime                                                YES
timeout_at     datetime                                                NO
estado         enum('en_ejecucion','exitoso','fallido','timeout','skip') NO  MUL
...
```

**Salida — INSERT + SELECT:**
```
id  trimestre   estado          timeout_at
2   TEST_T022   en_ejecucion    2026-05-07 05:17:48
```

**Salida — SHOW INDEX (idx_timeout):**
```
Key_name     Column_name  Comment
idx_timeout  estado       Usado por el heartbeat de Django para detectar timeouts
idx_timeout  timeout_at   Usado por el heartbeat de Django para detectar timeouts
```

**Criterio del plan:** INSERT exitoso. `timeout_at` presente. `idx_timeout` existe.
**Estado: PASA**

---

## T-023 — Verificar job_config con datos iniciales

**Comando:**
```sql
SELECT job_name, is_enabled, timeout_seconds, notas
FROM job_config ORDER BY job_name;
```

**Salida:**
```
job_name       is_enabled  timeout_seconds  notas
etl_diario     1           1800             ETL nocturno automatico. Procesa el quarter actual.
etl_historico  0           7200             Carga historica manual. Habilitar solo durante backfill inicial.
```

**Criterio del plan:** 2 filas. `etl_historico.is_enabled = 0` (deshabilitado).
**Estado: PASA**

---

## Hallazgos de la fase

| ID | Severidad | Descripcion | Accion |
|---|---|---|---|
| H-F1-001 | INFO | MariaDB cae entre llamadas — arranque ~3s por sesion | Conocido / BK-001 |
| H-F1-002 | INFO | T-018 y T-019 diferidas — requieren datos de T-032 | Se retoman en Fase 2 |

---

## Conclusion

12 de 14 tareas: PASA.
2 tareas diferidas (T-018, T-019) por dependencia de datos de Fase 2.
Sin hallazgos bloqueantes.

**Se puede proceder a Fase 2.**
