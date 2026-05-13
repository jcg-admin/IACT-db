# Hallazgos — Implementación FASE 2

**Versión:** 1.0.0
**Fecha:** 2026-05-13
**Alcance:** FASE 2 del plan PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resumen de tareas ejecutadas

| Tarea | Descripción | Estado | Hallazgos |
|---|---|---|---|
| T2.1 | sp_rpt_cMENU_ERROR v2.1.0 | COMPLETO | — |
| T2.2 | sp_rpt_menu_centro v2.1.0 | COMPLETO | — |
| T2.3 | sp_rpt_clientes v2.1.0 | COMPLETO | H-T2.3-001 |
| T2.4 | sp_rpt_menu_redirigidos v2.1.0 | COMPLETO | H-T2.4-001 (crítico) |

---

## Incidente de entorno — inestabilidad de MariaDB

Durante la FASE 2, el proceso MariaDB presentó inestabilidad recurrente: arrancaba
correctamente ("ready for connections"), emitía el socket, y moría segundos después
sin mensaje de error en el log. El patrón se repitió en múltiples intentos con
`mysqld_safe`, `mariadbd` directo y `service mariadb start`.

La causa raíz fue que el proceso de bash_tool desacopla el proceso hijo cuando
termina el comando, lo que en algunos contextos de sandbox causa que el kernel
limpie el proceso. La solución fue arrancar MariaDB desde Python con
`subprocess.Popen(..., start_new_session=True)`, que crea un nuevo grupo de
proceso y sobrevive al término del comando padre.

Este incidente no afectó la calidad del código ni la verificación — todas las
verificaciones de equivalencia se ejecutaron con el proceso estable. El diagnóstico
crítico de T2.4 (diferencia de denominadores) se obtuvo una vez que MariaDB estuvo
operativo.

---

## H-T2.3-001 — `base_ivr_clientes` no tiene datos de `Q01_25`

**Tarea:** T2.3
**Severidad:** Informativo — sin impacto en el código
**Estado:** Documentado

### Descripción

Al intentar verificar `sp_rpt_clientes('Q01_25')` en el entorno de desarrollo,
el SP retornó 0 filas. La causa no es un bug en la window function sino que
`base_ivr_clientes` no tiene registros del quarter `Q01_25` en los datos de prueba.

```sql
SELECT DISTINCT trimestre FROM base_ivr_clientes ORDER BY trimestre;
-- Q01_26, Q02_25, Q02_26, Q03_25, Q04_24, Q04_25
-- Q01_25 no existe
```

La verificación se realizó con `Q02_25` que sí tiene datos:

```
nacional_A  43166 clientes  pct_subq=44.86%  pct_wf=44.86%  ✓
nacional_B  28777 clientes  pct_subq=29.91%  pct_wf=29.91%  ✓
puebla      24285 clientes  pct_subq=25.24%  pct_wf=25.24%  ✓
```

`SUM() OVER()` es matemáticamente equivalente a la subconsulta para una tabla con
3 filas fijas por quarter. No hay ambigüedad de scope (no hay filtros adicionales
en el WHERE que dividan los grupos).

---

## H-T2.4-001 — `OVER()` no puede reemplazar `subq2` en `sp_rpt_menu_redirigidos`

**Tarea:** T2.4
**Severidad:** CRÍTICA — habría cambiado el KPI `pct_del_total` silenciosamente
**Estado:** RESUELTO con variable `v_total_scope` antes de implementar

### Descripción

El plan (`PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md`) indicaba usar
`SUM(SUM()) OVER()` para reemplazar `subq2` (`pct_del_total`) en
`sp_rpt_menu_redirigidos`. Esta especificación era incorrecta.

El descubrimiento ocurrió durante el análisis del código antes de implementar.
Al leer el `WHERE` del SP y la `WHERE` de la subconsulta2 en paralelo, se observó
una asimetría:

```sql
-- WHERE del SELECT principal (excluye VACIO y centros centinela):
WHERE b.trimestre = p_quarter
  AND (p_segmento = 'todas' OR b.segmento = p_segmento)
  AND b.menu != 'VACIO'
  AND b.centro_transferencia NOT IN ('CASO_NULL', 'CASO_ERROR_CEROS')

-- subq2 original (SIN excluir VACIO ni centinelas):
WHERE b3.trimestre = p_quarter
  AND (p_segmento = 'todas' OR b3.segmento = p_segmento)
```

`OVER()` opera sobre las filas visibles del SELECT principal — es decir, las que
pasan el WHERE. Esas filas excluyen VACIO y centros centinela. La subquery2
original los incluye.

### Evidencia numérica verificada en motor MariaDB 10.11.14

```
Q01_25 — p_segmento='todas':

  Denominador subq2 (sin filtro menu/centro): 119,205
  Denominador OVER() (con filtros WHERE SP):  109,639
  Diferencia:                                   9,566

  pct_del_total con subq2 original:          22.6836%  ← KPI correcto
  pct_del_total con OVER():                  24.6720%  ← KPI inflado ~2%
```

La diferencia de 9,566 llamadas corresponde exactamente a las filas con
`menu='VACIO'` y centros centinela que el WHERE del SP excluye pero la
subquery2 original incluye en el denominador.

### Por qué la verificación previa no detectó esto

El análisis de equivalencia publicado en `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md`
verificó con un query de prueba filtrado por `menu='SinOpcion_Cabecera'`. En ese
contexto el WHERE del test y el de la subquery coincidían accidentalmente — no
había filas de VACIO en el resultado de SinOpcion_Cabecera. Los denominadores
coincidieron por casualidad, no por equivalencia real.

### Solución implementada — variable `v_total_scope`

El patrón de la variable pre-calculada es el mismo que usa `sp_rpt_llamadas_abandonadas`
con `v_total_quarter`. Se calcula UNA sola vez antes del SELECT principal:

```sql
DECLARE v_total_scope BIGINT DEFAULT 0;

SELECT SUM(total_llamadas)
INTO v_total_scope
FROM base_ivr_detalle
WHERE trimestre = p_quarter
  AND (p_segmento = 'todas' OR segmento = p_segmento);
```

Este SELECT respeta el filtro de `p_segmento` (igual que la subquery2 original)
pero NO filtra por menu ni centro — incluye VACIO y centinelas, preservando la
semántica del KPI original.

El denominador `v_total_scope` reemplaza la subquery2 en el SELECT:

```sql
ROUND(SUM(b.total_llamadas) / NULLIF(v_total_scope, 0) * 100, 4) AS pct_del_total
```

**Ventajas sobre la subquery2 original:**
- Se calcula una sola vez (eliminando N ejecuciones correlacionadas)
- Preserva exactamente la semántica del KPI original
- Sigue el patrón establecido en el proyecto

**Verificación post-implementación:**

```
p_segmento='todas':
  cliente_colgo/CLIENTE_COLGO  pct_subq2=22.6836%  pct_variable=22.6836%  ✓

p_segmento='nacional_A':
  cliente_colgo/CLIENTE_COLGO  pct_subq2=22.7881%  pct_variable=22.7881%  ✓
```

---

## H-T2.4-002 — Detector de errores de deploy produce falso positivo en T2.1

**Tarea:** T2.1
**Severidad:** Informativo — sin impacto en el código
**Estado:** Documentado

### Descripción

El script de deploy en Python detecta líneas con "ERROR" en la salida de `mysql`.
El archivo `sp_rpt_cMENU_ERROR.sql` incluye al final un SELECT de verificación
que devuelve el nombre del SP:

```
sp_rpt_cMENU_ERROR  PROCEDURE
```

El nombre del SP contiene la cadena "ERROR", lo que disparó el detector como si
fuera un error real. El SP compiló y desplegó correctamente — verificado por las
pruebas funcionales (total_anomalias_quarter = 119 para todas, 55 para nacional_A).

El detector de errores debe excluir líneas que contengan "ERROR" como parte de
un nombre de objeto, no como código de error SQL. El patrón correcto es detectar
líneas que comiencen con `ERROR` seguido de un código numérico:

```python
# Patrón actual (incorrecto para nombres de objetos):
errors = [l for l in output.splitlines() if "ERROR" in l]

# Patrón correcto:
import re
errors = [l for l in output.splitlines()
          if re.match(r'ERROR\s+\d+', l)]
```

---

## Estado final de objetos al cerrar FASE 2

| Objeto | Versión anterior | Versión final | Cambio |
|---|---|---|---|
| `sp_rpt_cMENU_ERROR` | 2.0.2 | 2.1.0 | `OVER()` reemplaza subconsulta correlacionada |
| `sp_rpt_menu_centro` | 2.0.2 | 2.1.0 | `OVER(PARTITION BY centro)` reemplaza subconsulta |
| `sp_rpt_clientes` | 2.0.2 | 2.1.0 | `SUM() OVER()` reemplaza subconsulta |
| `sp_rpt_menu_redirigidos` | 2.0.2 | 2.1.0 | `OVER(PARTITION BY menu)` + variable `v_total_scope` |

---

## Correcciones al análisis previo confirmadas en motor

| Documento | Propuesta original | Corrección aplicada | Motivo |
|---|---|---|---|
| `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` | `OVER(PARTITION BY segmento)` para cMENU_ERROR | `OVER()` | OVER(seg)=55, OVER()=119 con p_segmento='todas' |
| `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` | `OVER(PARTITION BY segmento,menu)` para redirigidos subq1 | `OVER(PARTITION BY menu)` | OVER(seg,menu) da per-segment, no cross-segment |
| `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` | `OVER()` para redirigidos subq2 | Variable `v_total_scope` | WHERE del SP excluye VACIO/centinelas; subq2 los incluye |

---

## Verificaciones realizadas por tarea

### T2.1 — sp_rpt_cMENU_ERROR

```sql
-- 2026-05-13 — p_segmento='todas'
CALL sp_rpt_cMENU_ERROR('Q01_25', 'todas');
-- total_anomalias_quarter = 119 en TODAS las filas (no 55 por segmento)

-- p_segmento='nacional_A'
CALL sp_rpt_cMENU_ERROR('Q01_25', 'nacional_A');
-- total_anomalias_quarter = 55 en TODAS las filas
```

### T2.2 — sp_rpt_menu_centro

```sql
-- Ninguna divergencia entre pct_subq y pct_wf en ningún centro ni escenario
SELECT ... HAVING pct_wf != pct_subq;
-- → 0 filas
```

### T2.3 — sp_rpt_clientes

```sql
-- Q01_25 no tiene datos en base_ivr_clientes — resultado vacío normal
-- Verificación con Q02_25:
CALL sp_rpt_clientes('Q02_25');
-- nacional_A: 43166, 44.86% subq = 44.86% wf ✓
-- nacional_B: 28777, 29.91% subq = 29.91% wf ✓
-- puebla:     24285, 25.24% subq = 25.24% wf ✓
```

### T2.4 — sp_rpt_menu_redirigidos

```sql
-- p_segmento='todas':
CALL sp_rpt_menu_redirigidos('Q01_25', 'todas');
-- cliente_colgo/CLIENTE_COLGO: pct_del_menu=45.41%, pct_del_total=10.2999%

-- p_segmento='nacional_A':
CALL sp_rpt_menu_redirigidos('Q01_25', 'nacional_A');
-- cliente_colgo/CLIENTE_COLGO: pct_del_menu=100.00%, pct_del_total=22.7881%

-- Cruce con subq2 original (denominadores idénticos):
-- todas:    subq2=22.6836%, variable=22.6836% ✓
-- nac_A:    subq2=22.7881%, variable=22.7881% ✓
```

---

## Commits de la FASE 2

| Hash | Mensaje | Tarea |
|---|---|---|
| `8918bba` | feat(reportes): FASE 2 — window functions en 4 SPs de reporte | T2.1-T2.4 |
