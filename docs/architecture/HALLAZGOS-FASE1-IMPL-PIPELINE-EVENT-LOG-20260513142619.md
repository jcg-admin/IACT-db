# Hallazgos — Implementación FASE 1

**Versión:** 1.0.0
**Fecha:** 2026-05-13
**Alcance:** FASE 1 del plan PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resumen de tareas ejecutadas

| Tarea | Descripción | Estado | Hallazgos |
|---|---|---|---|
| T1.1 | provision-mariadb.sh y verify.sh | COMPLETO | H-T1.1-001 |
| T1.2 | sp_etl_maestro v2.5.0 | COMPLETO | — |
| T1.3 | 7 SPs de reporte vX.X.2 | COMPLETO | — |
| T1.4 | sp_etl_historico v2.1.0 | COMPLETO | H-T1.4-001 |

---

## H-T1.1-001 — El contador de OK permanece en 27, no sube a 28

**Tarea:** T1.1
**Severidad:** Informativo — sin impacto operacional
**Estado:** Documentado — comportamiento correcto

### Descripción

El plan estimaba "OK: 28" tras agregar `pipeline_event_log` al check de
tablas de verify.sh. El contador quedó en 27.

### Causa

verify.sh emite una sola llamada `ok()` para el bloque completo de tablas
analíticas, independientemente de cuántas tablas se verifiquen en el bucle:

```bash
for tbl in base_ivr_detalle ... pipeline_event_log; do
    # fail() si no existe — no ok() individual
done
if [[ $tbl_miss -eq 0 ]]; then
    ok "Tablas analíticas completas (${tbl_ok}/6)"  # UN solo ok()
fi
```

Agregar una tabla al bucle no agrega un `ok()` nuevo — expande el criterio
del check existente. El contador de 27 refleja 27 grupos de verificación
que pasaron, no 27 tablas individuales.

### Evidencia

```
2026-05-13 [SUCCESS] Tablas analíticas completas (6/6)
2026-05-13 [SUCCESS] OK: 27
```

El `6/6` confirma que `pipeline_event_log` fue encontrada. El `27` es correcto.

### Corrección

Ninguna. El comportamiento es correcto. El plan fue actualizado en memoria:
la métrica de éxito de T1.1 es `6/6` en el mensaje de tablas, no el
contador total de checks.

---

## H-T1.4-001 — sp_etl_historico continuaba a base_clientes tras fallo de base_detalle

**Tarea:** T1.4
**Severidad:** ALTA — generaba entradas redundantes en pipeline_event_log
y registros FAILED innecesarios en job_execution_log
**Estado:** RESUELTO en el mismo commit de T1.4

### Descripción

Durante la prueba de T1.4 — simulando fallo de `sp_etl_base_detalle`
renombrando la tabla fuente — se obtuvo:

```
pipeline_event_log delta: 3 (esperado: 1)
```

Las 3 filas eran:
- Fila 1: `ETL_FALLO / sp_etl_historico / Falló etl_base_detalle: ...`
- Fila 2: `ETL_FALLO / sp_etl_historico / Falló etl_base_clientes: ...`
- Fila 3: `VALIDACION / sp_etl_validar / ERROR: base_ivr_clientes tiene 0 filas...`

Y en `job_execution_log`:
- `etl_base_detalle FAILED` (correcto)
- `etl_base_clientes FAILED` (innecesario — no debería haberse intentado)

### Causa

La primera versión de T1.4 no incluía el guard `v_detalle_cargado`.
El EXIT HANDLER del bloque `BEGIN...END` que envuelve `CALL sp_etl_base_detalle`
capturaba el error, registraba en `pipeline_event_log` y actualizaba
`job_execution_log`, pero la ejecución **continuaba** en el cuerpo del SP
hacia `DO SLEEP(5)`, el INSERT del step de clientes, y el `CALL sp_etl_base_clientes`.

Este es el mismo gap que originalmente tenía `sp_etl_maestro` antes de la
FASE de manejo de errores. `sp_etl_maestro` lo resolvió con `v_detalle_cargado`.
`sp_etl_historico` no tenía ese patrón en su primera versión de T1.4.

### Corrección aplicada

```sql
-- Variable guard (mismo patrón que sp_etl_maestro):
DECLARE v_detalle_cargado BOOLEAN DEFAULT TRUE;

-- En el EXIT HANDLER de sp_etl_base_detalle:
SET v_detalle_cargado = FALSE;

-- Bloque de sp_etl_base_clientes envuelto:
IF v_detalle_cargado THEN
    ...
    CALL sp_etl_base_clientes(...);
END IF;

-- Validación solo si base_detalle cargó:
IF v_detalle_cargado THEN
    CALL sp_etl_validar(v_quarter, v_ok, v_msg);
    ...
ELSE
    SET v_ok  = FALSE;
    SET v_msg = 'ETL abortado: base_ivr_detalle no se cargó correctamente.';
END IF;
```

### Verificación post-corrección

```
pipeline_event_log delta: 1 (esperado: 1)  ✓
job_execution_log: solo etl_base_detalle FAILED para el test actual  ✓
SELECT final retorna: ok=0, resultado='ETL abortado: ...'  ✓
verify.sh: 27 OK, 0 WARN, 0 ERR  ✓
```

---

## Estado final de objetos al cerrar FASE 1

| Objeto | Versión anterior | Versión final | Cambios |
|---|---|---|---|
| `scripts/provision-mariadb.sh` | — | — | +schema_pipeline_event_log + vistas + 23 objetos |
| `verify.sh` | — | — | pipeline_event_log en bucle tablas analíticas, /5→/6 |
| `sp_etl_maestro` | 2.4.0 | 2.5.0 | INSERT pipeline_event_log PASO 4/5/6 + PASO 7 |
| `sp_rpt_clientes` | 2.0.1 | 2.0.2 | INSERT pipeline_event_log antes de SIGNAL quarter |
| `sp_rpt_cMENU_ERROR` | 2.0.1 | 2.0.2 | INSERT pipeline_event_log antes de SIGNAL quarter + segmento |
| `sp_rpt_centros_transferencia` | 2.1.1 | 2.1.2 | Idem |
| `sp_rpt_centros_xsegmento` | 2.2.1 | 2.2.2 | INSERT pipeline_event_log antes de SIGNAL quarter |
| `sp_rpt_llamadas_abandonadas` | 2.2.1 | 2.2.2 | INSERT pipeline_event_log antes de SIGNAL quarter + segmento |
| `sp_rpt_menu_centro` | 2.0.1 | 2.0.2 | Idem |
| `sp_rpt_menu_redirigidos` | 2.0.1 | 2.0.2 | Idem |
| `sp_etl_historico` | 2.0.0 | 2.1.0 | EXIT HANDLERs + v_detalle_cargado + pipeline_event_log |

---

## Verificaciones realizadas por tarea

### T1.1 — provision-mariadb.sh y verify.sh

```bash
# 2026-05-13: provision despliega schema correctamente
bash scripts/provision-mariadb.sh
# → "23 objetos aplicados"

# pipeline_event_log creada
mysql ivr_legacy -e "SELECT COUNT(*) FROM pipeline_event_log;"
# → 0

# verify.sh refleja la nueva tabla
bash verify.sh
# → Tablas analíticas completas (6/6)
# → OK: 27, Errores: 0
```

### T1.2 — sp_etl_maestro v2.5.0

```bash
# 2026-05-13: simular fallo PASO 4 (RENAME tabla fuente)
RENAME TABLE tbl_historico_t2_2026 TO _tbl_historico_backup_t1;
CALL sp_etl_maestro();
# pipeline_event_log: ETL_FALLO / CRITICA / sp_etl_maestro
# job_execution_log: status=FAILED (step y maestro)
RENAME TABLE _tbl_historico_backup_t1 TO tbl_historico_t2_2026;
```

### T1.3 — 7 SPs de reporte

```bash
# 2026-05-13: quarter inválido
CALL sp_rpt_clientes('INVALIDO');
# → ERROR 1644 (22023) + pipeline_event_log +1 (PARAM_INVALIDO/MEDIA)

# segmento inválido
CALL sp_rpt_llamadas_abandonadas('Q01_25','SEG_MALO');
# → ERROR 1644 (22023) + pipeline_event_log +1 (PARAM_INVALIDO/MEDIA, p_segmento='SEG_MALO')

# parámetro válido — sin entrada en el log
CALL sp_rpt_clientes('Q01_25');
# → resultado normal, pipeline_event_log sin cambio
```

### T1.4 — sp_etl_historico v2.1.0

```bash
# 2026-05-13: p_quarter_num inválido
CALL sp_etl_historico(2025, 5);
# → ERROR 1644 (45000) + pipeline_event_log +1 (PARAM_INVALIDO/MEDIA)

# fallo de base_detalle (tabla no existe)
RENAME TABLE tbl_historico_t1_2025 TO _tbl_backup_hist_t1;
CALL sp_etl_historico(2025, 1);
# → pipeline_event_log delta=1 (ETL_FALLO/CRITICA)
# → job_execution_log: solo etl_base_detalle=FAILED (base_clientes no intentado)
# → SELECT retorna: ok=0, resultado='ETL abortado: ...'
RENAME TABLE _tbl_backup_hist_t1 TO tbl_historico_t1_2025;
```

---

## Commits de la FASE 1

| Hash | Mensaje | Tarea |
|---|---|---|
| `377b01d` | fix(provision): T1.1 — schema_pipeline_event_log y vistas | T1.1 |
| `768a7b2` | feat(errores): T1.2 — sp_etl_maestro v2.5.0 | T1.2 |
| `cecbba9` | feat(errores): T1.3 — 7 SPs reporte vX.X.2 | T1.3 |
| `d45a440` | feat(errores): T1.4 — sp_etl_historico v2.1.0 | T1.4 |
