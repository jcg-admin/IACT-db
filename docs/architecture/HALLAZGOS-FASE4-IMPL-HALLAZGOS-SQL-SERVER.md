# Hallazgos — Ejecución FASE 4 (fórmula O(1) para funciones de calendario)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Plan de referencia:** `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` FASE 4  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Archivos modificados

| Archivo | Objeto | Versión anterior | Versión nueva | Hallazgo resuelto |
|---|---|---|---|---|
| `objetos/funciones/ivr_contar_dias_semana.sql` | `ivr_contar_dias_semana` | 2.0.0 | 3.0.0 | H-IACT-001 |
| `objetos/funciones/ivr_agregar_dias_semana.sql` | `ivr_agregar_dias_semana` | 2.0.0 | 3.0.0 | H-IACT-001 |

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-4.1 | Suite de tests de referencia: 112 + 105 casos del WHILE | CONSTRUIDA | — |
| T-4.2 | `ivr_contar_dias_semana_v2` (fórmula O(1)) | COMPLETO | H-F4-001 |
| T-4.3 | Gate de calidad `contar`: 112/112 OK en MariaDB real | PASA | — |
| T-4.4 | Reemplazar `ivr_contar_dias_semana` con fórmula validada | COMPLETO | H-F4-002 |
| T-4.5 | `ivr_agregar_dias_semana_v2` + gate: 105/105 OK | COMPLETO | H-F4-003 |
| T-4.6 | Reemplazar `ivr_agregar_dias_semana` con fórmula validada | COMPLETO | — |
| T-4.7 | `ivr_es_dia_semana` eliminada como prerequisito de ambas funciones | COMPLETO | — |
| T-4.8 | `sp_rpt_centros_xsegmento`: resultados de calendario idénticos pre/post | PASA | H-F4-004 |

---

## H-F4-001 — El intento anterior de fórmula O(1) tenía un off-by-one

**Detectado en:** T-4.2, durante el análisis previo a la implementación  
**Severidad:** ALTA — una fórmula incorrecta produce resultados silenciosamente erróneos  
**Estado:** RESUELTO con una fórmula derivada correctamente y verificada en Python + MariaDB

### Descripción

Una iteración anterior de la fórmula O(1) para `ivr_contar_dias_semana` (registrada en
sesiones previas) produjo 65 para Q1 2025 cuando el WHILE da 64. El error provenía de
una aritmética incorrecta sobre `DAYOFWEEK()`.

Para FASE 4 se derivó la fórmula desde cero con un razonamiento explícito:

**Mapeo de día de la semana:**
```
DAYOFWEEK MariaDB: 1=Dom, 2=Lun, 3=Mar, 4=Mié, 5=Jue, 6=Vie, 7=Sáb
v_pos = (DAYOFWEEK(p_ini) + 5) MOD 7  →  Lun=0, Mar=1, Mié=2, Jue=3, Vie=4, Sáb=5, Dom=6
```

**Fórmula:**
```
v_N    = DATEDIFF(p_fin, p_ini) + 1      -- días totales inclusive
v_w    = FLOOR(v_N / 7)                  -- semanas completas
v_rem  = v_N MOD 7                       -- días sobrantes de la semana parcial
v_wrem = GREATEST(0, 5 - v_pos)          -- huecos hábiles en la semana parcial de inicio
resultado = v_w * 5
          + LEAST(v_rem, v_wrem)          -- hábiles en la semana parcial de inicio
          + GREATEST(0, v_rem + v_pos - 7) -- hábiles que "desbordan" al lunes siguiente
```

**Verificación manual para Q1 2025 (2025-01-01, Mié → 2025-03-31, Lun):**
```
v_pos  = (4 + 5) MOD 7 = 2  (Mié)
v_N    = 90 días
v_w    = 12, v_rem = 6
v_wrem = GREATEST(0, 5-2) = 3  (Mié,Jue,Vie)
adj    = LEAST(6, 3) + GREATEST(0, 6+2-7) = 3 + 1 = 4
total  = 12×5 + 4 = 64  ✓ (WHILE da 64)
```

La fórmula se validó en Python contra 112 casos (7 días de inicio × 16 rangos) con 0 fallos
antes de escribir una línea de SQL. Luego se confirmó en MariaDB 10.11 real: 112/112 OK.

---

## H-F4-002 — `ivr_contar_dias_semana` v3.0.0 elimina la dependencia de `ivr_es_dia_semana`

**Detectado en:** T-4.4, al analizar el `COMMENT` y el `Prerequisito` del archivo original  
**Severidad:** INFORMATIVO — mejora de la arquitectura, no un bug  
**Estado:** RESUELTO

### Descripción

La versión WHILE de `ivr_contar_dias_semana` dependía de `ivr_es_dia_semana` para
cada iteración del bucle. La fórmula O(1) usa únicamente `DAYOFWEEK()` (función nativa
de MariaDB) — sin dependencia de ninguna función almacenada.

Consecuencias:
- El campo `Prerequisito` del archivo cambia de `ivr_es_dia_semana` a `Ninguno`.
- La función puede desplegarse en cualquier orden sin preocuparse por dependencias.
- `ivr_es_dia_semana` sigue existiendo (la usa el ETL para pre-computar
  `llamadas_entre_semana` en `base_ivr_detalle`), pero ya no es requisito de las
  funciones de calendario.

---

## H-F4-003 — `ivr_agregar_dias_semana`: el caso de inicio en fin de semana requería manejo especial

**Detectado en:** T-4.5, durante la derivación de la fórmula para `ivr_agregar_dias_semana`  
**Severidad:** ALTA — sin el manejo de Sáb/Dom, la fórmula producía resultados incorrectos  
**Estado:** RESUELTO

### Descripción

La fórmula general para agregar días hábiles es:
```
v_w     = FLOOR(p_n / 5)         -- semanas completas
v_r     = p_n MOD 5              -- días hábiles restantes
v_extra = v_r + IF(v_r > 0 AND v_pos + v_r >= 5, 2, 0)  -- cruce del fin de semana
resultado = p_fecha + 7*v_w + v_extra días
```

Esta fórmula funciona correctamente cuando `p_fecha` es un día hábil (Lun-Vie). Para
días de fin de semana, la aritmética produce un resultado incorrecto porque `5 weekdays
= 7 calendar days` asume que la semana empieza en un día hábil.

**Ejemplo que falla sin el caso especial:**
```
p_fecha = Sáb 2025-01-11, p_n=5
v_pos=5, v_w=1, v_r=0, v_extra=0
resultado = Sáb + 7 días = Sáb 2025-01-18  ← INCORRECTO
Esperado (WHILE): Vie 2025-01-17  (Lun+Mar+Mié+Jue+Vie de la semana siguiente)
```

**Solución implementada:** Si `v_pos >= 5` (Sáb o Dom), avanzar al lunes siguiente
antes de aplicar la fórmula. El lunes de llegada cuenta como el primer día hábil:

```sql
IF v_pos >= 5 THEN
    SET v_advance = 7 - v_pos;   -- Sáb→+2 días, Dom→+1 día
    SET p_n       = p_n - 1;     -- el lunes ya es el día hábil 1
    SET v_pos     = 0;           -- posición de inicio: Lunes
END IF;
```

**Verificación del caso corregido:**
```
p_fecha = Sáb, p_n=5:
v_advance=2, p_n→4, v_pos→0
v_w=0, v_r=4, v_extra=4
resultado = Sáb+2+4 = Sáb+6 = Vie  ✓
```

La suite de 105 casos (7 días de inicio × 15 valores de p_n, incluyendo Sáb y Dom)
pasó con 0 fallos en Python y en MariaDB 10.11 real.

---

## H-F4-004 — `total_llamadas` en `sp_rpt_centros_xsegmento` difiere del snapshot de FASE 2

**Detectado en:** T-4.8, durante la verificación post-despliegue  
**Severidad:** NINGUNA — el cambio es esperado y no indica un error en las funciones  
**Estado:** DOCUMENTADO — no requiere acción

### Descripción

El snapshot de referencia tomado en FASE 2 mostraba `total_llamadas=4580` para el
centro `10728487` en Q01_25. Después de FASE 4, el mismo SP muestra `total_llamadas=5493`.

La causa: entre FASE 2 y FASE 4 se ejecutaron varias llamadas a `sp_etl_maestro` y
`sp_etl_base_detalle` durante las pruebas de FASE 3 (verificación de atomicidad e
idempotencia). El seed de `tbl_historico_t1_2025` se ejecutó en cada una, añadiendo
registros al histórico. Al re-procesar el ETL, `base_ivr_detalle` refleja el histórico
creciente.

**Lo que SÍ es idéntico pre/post FASE 4 (lo que depende de las funciones de calendario):**

| Columna | Pre-FASE 4 | Post-FASE 4 | Compara |
|---|---|---|---|
| `dias_semana_periodo` | 64 | 64 | ✓ idéntico |
| `dias_semana_sin_actividad` | 293 | 293 | ✓ idéntico |
| `clasificacion_sla` | FUERA_SLA | FUERA_SLA | ✓ idéntico |
| `fecha_seguimiento_1_dia` | 2025-04-01 | 2025-04-01 | ✓ idéntico |
| `fecha_seguimiento_3_dias` | 2025-04-03 | 2025-04-03 | ✓ idéntico |
| `fecha_escalamiento` | 2025-04-07 | 2025-04-07 | ✓ idéntico |
| Total filas del resultado | 84 | 84 | ✓ idéntico |

Todas las columnas producidas por `ivr_contar_dias_semana` e `ivr_agregar_dias_semana`
son idénticas. La función O(1) es semánticamente equivalente al WHILE.

---

## Fórmulas implementadas

### `ivr_contar_dias_semana` v3.0.0

```
Entrada : p_ini DATE, p_fin DATE
Salida  : INT (días L-V en [p_ini, p_fin] inclusive)
Variables:
  v_pos  = (DAYOFWEEK(p_ini) + 5) MOD 7  → Lun=0 .. Dom=6
  v_N    = DATEDIFF(p_fin, p_ini) + 1
  v_w    = FLOOR(v_N / 7)
  v_rem  = v_N MOD 7
  v_wrem = GREATEST(0, 5 - v_pos)
Resultado:
  v_w * 5 + LEAST(v_rem, v_wrem) + GREATEST(0, v_rem + v_pos - 7)
```

### `ivr_agregar_dias_semana` v3.0.0

```
Entrada : p_fecha DATE, p_n INT
Salida  : DATE (fecha del p_n-ésimo día hábil estrictamente después de p_fecha)
Variables:
  v_pos = (DAYOFWEEK(p_fecha) + 5) MOD 7  → Lun=0 .. Dom=6
  Si v_pos >= 5 (fin de semana):
    v_advance = 7 - v_pos   (Sáb→+2, Dom→+1 días para llegar al Lunes)
    p_n       = p_n - 1     (el Lunes ya es el día hábil 1)
    v_pos     = 0           (ahora somos Lunes)
  v_w     = FLOOR(p_n / 5)
  v_r     = p_n MOD 5
  v_extra = v_r + IF(v_r > 0 AND v_pos + v_r >= 5, 2, 0)
Resultado:
  DATE_ADD(DATE_ADD(p_fecha, INTERVAL v_advance DAY), INTERVAL 7*v_w + v_extra DAY)
```

---

## Suite de tests (fuente de verdad: WHILE original)

| Suite | Casos | Aciertos Python | Aciertos MariaDB |
|---|---|---|---|
| `ivr_contar_dias_semana` (7 días inicio × 16 rangos) | 112 | 112 | 112 |
| `ivr_agregar_dias_semana` (7 días inicio × 15 n_dias) | 105 | 105 | 105 |
| **Total** | **217** | **217** | **217** |

---

## Impacto en `sp_rpt_centros_xsegmento`

Con 84 filas de resultado (Q01_25, validado):

| Métrica | WHILE (v2.0.0) | Fórmula O(1) (v3.0.0) |
|---|---|---|
| `ivr_contar_dias_semana` por fila | 2 llamadas × O(n iteraciones) | 2 llamadas × O(1) |
| `ivr_agregar_dias_semana` por fila | 3 llamadas × O(n iteraciones) | 3 llamadas × O(1) |
| Iteraciones WHILE por ejecución (84 filas, ~45 iter/llamada) | ~18,900 | 0 |
| Dependencia de `ivr_es_dia_semana` | Sí (1 call por WHILE iter) | No |

---

## Verificación funcional final

```
Gate ivr_contar_dias_semana_v2 en MariaDB: 112/112 OK
Gate ivr_agregar_dias_semana_v2 en MariaDB: 105/105 OK
Funciones v3.0.0 vs v2 en MariaDB: 91/91 OK (subset de verificación post-despliegue)
ivr_contar_dias_semana: ya no depende de ivr_es_dia_semana (verificado en information_schema)
sp_rpt_centros_xsegmento Q01_25: columnas de calendario idénticas pre/post FASE 4
verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```
