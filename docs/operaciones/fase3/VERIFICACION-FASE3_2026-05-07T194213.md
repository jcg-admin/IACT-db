# Verificacion Fase 3 — Backfill historico

**Fecha:** 2026-05-07
**Plan de referencia:** `PLAN-IMPLEMENTACION-V2.1.md`
**Entorno:** Sandbox Ubuntu 24.04, MariaDB 10.11.14
**Datos fuente:** 5,793,156 filas totales (seed 1M base con variacion por quarter)

---

## Resumen ejecutivo

| Tarea | Descripcion | Estado |
|---|---|---|
| T-040 | Backfill Q01_25 | PASA |
| T-041 | Backfill Q02_25 | PASA |
| T-042 | Backfill Q03_25 | PASA |
| T-043 | Backfill Q04_25 + Q01_26 | PASA |
| T-044 | Integridad del backfill completo | PASA CON NOTA |
| T-044b | Deshabilitar etl_historico en job_config | PASA |

**6/6 tareas verificadas. Se puede proceder a Fase 4.**

---

## Hallazgo transversal — H-F3-001: MariaDB cae entre llamadas

El arranque manual fue necesario antes de cada tarea.

```bash
rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
runuser -u mysql -- /usr/sbin/mariadbd \
    --user=mysql \
    --socket=/run/mysqld/mysqld.sock \
    --datadir=/var/lib/mysql \
    --pid-file=/run/mysqld/mysqld.pid \
    --skip-grant-tables \
    --innodb-buffer-pool-size=256M \
    >> /tmp/mdb_f3.log 2>&1 &
for i in $(seq 1 30); do
    mysql --socket=/run/mysqld/mysqld.sock -e "SELECT 1;" >/dev/null 2>&1 && break
    sleep 1
done
mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;" 2>/dev/null
```

Se agrego `--innodb-buffer-pool-size=256M` para mejor rendimiento con 1M filas.

---

## Estado inicial del sandbox

```
base_ivr_detalle:  Q01_25 (5153 filas, enero) + Q02_26 (3700 filas)
base_ivr_clientes: Q01_25 (3) + Q02_26 (3)
job_execution_log: 3 registros (checkpoints Q02_26 de T-037 en Fase 2)
job_config:        etl_historico is_enabled=0
```

---

## T-040 — Backfill Q01_25

**Comando:**
```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "CALL sp_etl_historico(2025, 1);"
```

**Parametros que construye sp_etl_historico internamente:**
```
v_quarter = 'Q01_25'
v_table   = 'tbl_historico_t1_2025'
v_inicio  = '2025-01-01'
v_fin     = '2025-03-31'
```

**Salida del SP:**
```
quarter_procesado   ok   resultado
Q01_25              1    OK — 5215 filas detalle, 3 filas clientes, 1,031,847 llamadas totales.
```

**Tiempos:**
```
INICIO: 2026-05-07 19:37:13
FIN:    2026-05-07 19:37:47   (34 segundos total)
  etl_base_detalle:  18s (incluye DELETE mes a mes + INSERT)
  SLEEP(5):           5s
  etl_base_clientes: 11s
```

**Verificacion de resultado:**
```
trimestre   filas_grain   total_llamadas   segmentos   meses   mes_ini   mes_fin
Q01_25      5215          1,031,847        3           3       202501    202503

clientes:
Q01_25  nacional_A  463,809
Q01_25  nacional_B  309,134
Q01_25  puebla      257,622

job_execution_log:
etl_base_detalle  SUCCESS  records=5215    duracion=18s
etl_base_clientes SUCCESS  records=3       duracion=11s
```

**Nota sobre diferencia de filas grain vs Fase 2:**
En Fase 2 (solo enero): 5,153 filas grain. Con el quarter completo (3 meses): 5,215 filas.
La diferencia (+62) corresponde a combinaciones unicas de grain que aparecen en
febrero y marzo pero no en enero.

**Criterio del plan:** `SUM(total_llamadas) ≈ 1,031,847` (sandbox). 3 meses. Validacion OK.
**Estado: PASA**

---

## T-041 — Backfill Q02_25

**Parametros internos:**
```
v_quarter = 'Q02_25'
v_table   = 'tbl_historico_t2_2025'
v_inicio  = '2025-04-01'
v_fin     = '2025-06-30'
```

**Salida del SP:**
```
quarter_procesado   ok   resultado
Q02_25              1    OK — 6629 filas detalle, 3 filas clientes, 1,172,834 llamadas totales.
```

**Tiempos:**
```
INICIO: 2026-05-07 19:38:00
FIN:    2026-05-07 19:38:33   (33 segundos total)
  etl_base_detalle:  19s
  SLEEP(5):           5s
  etl_base_clientes:  9s
```

**Verificacion:**
```
trimestre   filas_grain   total_llamadas   segmentos   meses   mes_ini   mes_fin
Q02_25      6629          1,172,834        3           3       202504    202506

clientes:
Q02_25  nacional_A  527,546
Q02_25  nacional_B  350,270
Q02_25  puebla      293,353
```

**Nota:** Q02_25 tiene 6,629 filas grain vs 5,215 de Q01_25 porque el perfil
de Q02_25 tiene 50 menus y 47 VDNs (vs 44 y 39 de Q01_25). Mas combinaciones
unicas de grain es esperado con un IVR mas maduro en Q2.

**Criterio:** `SUM(total_llamadas) ≈ 1,172,834`. Es el pico del anio.
**Estado: PASA**

---

## T-042 — Backfill Q03_25

**Parametros internos:**
```
v_quarter = 'Q03_25'
v_table   = 'tbl_historico_t3_2025'
v_inicio  = '2025-07-01'
v_fin     = '2025-09-30'
```

**Salida del SP:**
```
quarter_procesado   ok   resultado
Q03_25              1    OK — 5889 filas detalle, 3 filas clientes, 983,741 llamadas totales.
```

**Tiempos:**
```
INICIO: 2026-05-07 19:38:43
FIN:    2026-05-07 19:39:11   (28 segundos total)
  etl_base_detalle:  16s
  SLEEP(5):           5s
  etl_base_clientes:  7s
```

**Verificacion:**
```
trimestre   filas_grain   total_llamadas   segmentos   meses   mes_ini   mes_fin
Q03_25      5889          983,741          3           3       202507    202509

clientes:
Q03_25  nacional_A  442,279
Q03_25  nacional_B  294,238
Q03_25  puebla      246,044
```

**Estado: PASA**

---

## T-043 — Backfill Q04_25 y Q01_26

**Q04_25:**
```
v_quarter = 'Q04_25'
v_table   = 'tbl_historico_t4_2025'
v_inicio  = '2025-10-01'
v_fin     = '2025-12-31'
```

```
resultado: OK — 5990 filas detalle, 3 filas clientes, 1,074,193 llamadas totales.
Tiempo: 31s (18s + SLEEP(5) + 8s)

trimestre   filas_grain   total_llamadas   mes_ini   mes_fin
Q04_25      5990          1,074,193        202510    202512
```

**Q01_26:**
```
v_quarter = 'Q01_26'
v_table   = 'tbl_historico_t1_2026'
v_inicio  = '2026-01-01'
v_fin     = '2026-03-31'
```

```
resultado: OK — 5429 filas detalle, 3 filas clientes, 1,041,623 llamadas totales.
Tiempo: 28s (16s + SLEEP(5) + 7s)

trimestre   filas_grain   total_llamadas   mes_ini   mes_fin
Q01_26      5429          1,041,623        202601    202603
```

**Clientes Q04_25 y Q01_26:**
```
Q01_26  nacional_A  468,299
Q01_26  nacional_B  312,383
Q01_26  puebla      259,661
Q04_25  nacional_A  482,224
Q04_25  nacional_B  322,665
Q04_25  puebla      267,900
```

**Estado: PASA**

---

## T-044 — Verificar integridad del backfill completo

**Comando:**
```sql
SELECT trimestre, COUNT(*) AS filas,
       FORMAT(SUM(total_llamadas),0) AS total,
       COUNT(DISTINCT segmento) AS segmentos
FROM base_ivr_detalle GROUP BY trimestre ORDER BY trimestre;

SELECT trimestre, segmento, clientes_unicos
FROM base_ivr_clientes ORDER BY trimestre, segmento;
```

**Salida — base_ivr_detalle:**
```
trimestre   filas_grain   total_llamadas   seg   meses   mes_ini   mes_fin   pct_semana
Q01_25      5215          1,031,847        3     3       202501    202503    71.1%
Q01_26      5429          1,041,623        3     3       202601    202603    71.1%
Q02_25      6629          1,172,834        3     3       202504    202506    71.5%
Q02_26      3700          462,000          3     2       202604    202605    72.3%
Q03_25      5889          983,741          3     3       202507    202509    71.8%
Q04_25      5990          1,074,193        3     3       202510    202512    71.7%
```

**Salida — base_ivr_clientes (18 filas):**
```
Q01_25  nacional_A  463,809  |  Q02_25  nacional_A  527,546
Q01_25  nacional_B  309,134  |  Q02_25  nacional_B  350,270
Q01_25  puebla      257,622  |  Q02_25  puebla      293,353
Q01_26  nacional_A  468,299  |  Q03_25  nacional_A  442,279
Q01_26  nacional_B  312,383  |  Q03_25  nacional_B  294,238
Q01_26  puebla      259,661  |  Q03_25  puebla      246,044
Q02_26  nacional_A  207,273  |  Q04_25  nacional_A  482,224
Q02_26  nacional_B  138,743  |  Q04_25  nacional_B  322,665
Q02_26  puebla      115,735  |  Q04_25  puebla      267,900
```

**Verificaciones de calidad:**
```
quarters_en_detalle:  6     (criterio: 5 del backfill + Q02_26 del maestro)
filas_clientes:       18    (criterio plan: 15 — ver H-F3-002)
filas_error suma:     0     (llamadas_entre_semana + fines = total en cada fila)
nk90_crudos:          0     (normalizacion correcta)
registros_failed:     0     (ningun checkpoint fallido)
running_abiertos:     0     (ningun checkpoint abierto)
```

**Total global de llamadas en backfill:**
```
SELECT SUM(total_llamadas) FROM base_ivr_detalle
WHERE trimestre IN ('Q01_25','Q02_25','Q03_25','Q04_25','Q01_26');

Resultado: 5,304,238
```

**Hallazgo H-F3-002 — base_ivr_clientes tiene 18 filas en lugar de 15:**

El plan espera `15 filas (5 quarters x 3 segmentos)`. Hay 18 porque `Q02_26`
ya estaba en la tabla desde la ejecucion del `sp_etl_maestro` en T-037 de
Fase 2 (proceso el quarter actual automaticamente).

Las 18 filas son correctas y esperadas en el sandbox. En produccion, al
ejecutar el backfill el maestro nocturno ya habra estado corriendo, por
lo que esta situacion es normal. El criterio del plan estaba escrito
asumiendo un sandbox completamente limpio antes del backfill.

**Criterio del plan:** 5 quarters en detalle + ningún FAILED + integridad suma = 0.
Los 5 quarters del backfill estan presentes. Q02_26 es adicional y legitimo.

**Estado: PASA CON NOTA** (H-F3-002 documentado)

---

## T-044b — Deshabilitar etl_historico en job_config

**Comando:**
```sql
SELECT job_name, is_enabled FROM job_config ORDER BY job_name;
UPDATE job_config SET is_enabled = FALSE WHERE job_name='etl_historico';
SELECT job_name, is_enabled FROM job_config ORDER BY job_name;
```

**Salida antes:**
```
etl_diario      1
etl_historico   0   <- ya estaba deshabilitado desde el schema inicial
```

**Salida despues (sin cambio efectivo):**
```
etl_diario      1
etl_historico   0
```

El `UPDATE` no tuvo efecto porque `etl_historico` ya estaba en `is_enabled=0`
desde que `schema_base_ivr.sql` inserta los datos iniciales de `job_config`.
Esto es el comportamiento correcto — el schema lo protege desde el inicio.

**Criterio:** `etl_historico.is_enabled = 0`.
**Estado: PASA**

---

## Resumen de tiempos de backfill (sandbox con ~1M filas/quarter)

| Quarter | Filas fuente | Tiempo detalle | SLEEP | Tiempo clientes | Total |
|---|---|---|---|---|---|
| Q01_25 | 1,031,847 | 18s | 5s | 11s | 34s |
| Q02_25 | 1,172,834 | 19s | 5s | 9s | 33s |
| Q03_25 | 983,741 | 16s | 5s | 7s | 28s |
| Q04_25 | 1,074,193 | 18s | 5s | 8s | 31s |
| Q01_26 | 1,041,623 | 16s | 5s | 7s | 28s |
| **Total** | **5,304,238** | | | | **~154s** |

En produccion (~11.6M filas/quarter): escalar x11.3 → ~5.4 min por quarter.
Total estimado de backfill en produccion: ~27 minutos para 5 quarters.

---

## Estado del sandbox al finalizar Fase 3

```
base_ivr_detalle:
  Q01_25: 5215 filas, 1,031,847 llamadas  (202501-202503)
  Q02_25: 6629 filas, 1,172,834 llamadas  (202504-202506)  <- pico
  Q03_25: 5889 filas,   983,741 llamadas  (202507-202509)
  Q04_25: 5990 filas, 1,074,193 llamadas  (202510-202512)
  Q01_26: 5429 filas, 1,041,623 llamadas  (202601-202603)
  Q02_26: 3700 filas,   462,000 llamadas  (202604-202605)  <- maestro
  TOTAL:  32852 filas, 5,766,238 llamadas

base_ivr_clientes:
  18 filas: 6 quarters x 3 segmentos

job_execution_log:
  10 registros etl_historico (5 quarters x 2 pasos): todos SUCCESS
  3 registros etl_diario (de T-037 Fase 2)

job_config:
  etl_diario:     is_enabled=1
  etl_historico:  is_enabled=0
```

---

## Hallazgos de la fase

| ID | Severidad | Descripcion |
|---|---|---|
| H-F3-001 | INFO | MariaDB cae entre llamadas — arranque manual con innodb-buffer-pool-size=256M |
| H-F3-002 | INFO | base_ivr_clientes tiene 18 filas (vs 15 del plan) — Q02_26 del maestro de Fase 2 |

---

## Conclusion

Los 5 quarters historicos (Q01_25..Q01_26) cargados correctamente.
`sp_etl_historico` funciona como se esperaba: construye los parametros
dinamicamente, registra checkpoints en `job_execution_log` y valida
al terminar. Todos los checkpoints quedaron en SUCCESS.

**Se puede proceder a Fase 4 (Django).**
