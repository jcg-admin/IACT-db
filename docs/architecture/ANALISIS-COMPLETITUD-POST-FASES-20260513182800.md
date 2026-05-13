# Análisis Minucioso — Completitud Post-Implementación FASE 1-4

**Versión:** 1.0.0
**Fecha:** 2026-05-13
**Método:** Verificación programática de cada pendiente contra el código
real en disco. Sin inferencias — solo lo que el código contiene.
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR.
Provision: 25 objetos, 34 grants (17 routines × 2 hosts).

---

## Veredicto general

**El plan P1-P11 está implementado al 100%.** No quedan pendientes
funcionales. Existe un artefacto de disco que debe eliminarse.

---

## Verificación programática P1-P11

Cada check busca evidencia directa en el código fuente en disco.

| ID | Descripción | Evidencia en código | Estado |
|---|---|---|---|
| P1 | sp_etl_maestro — 4 INSERTs pipeline_event_log | `count("INSERT INTO pipeline_event_log") = 4` | ✓ IMPLEMENTADO |
| P2 | 7 SPs reporte — pipeline_event_log antes de SIGNAL | `"pipeline_event_log" in` todos 7 SPs | ✓ IMPLEMENTADO |
| P3 | sp_rpt_cMENU_ERROR — `OVER()` sin PARTITION BY | `"OVER()"` presente + v2.1.0 | ✓ IMPLEMENTADO |
| P4 | sp_rpt_menu_centro — `OVER(PARTITION BY centro)` | `"PARTITION BY b.centro_transferencia"` | ✓ IMPLEMENTADO |
| P5 | sp_rpt_clientes — `SUM() OVER()` | `"OVER()"` presente + v2.1.0 | ✓ IMPLEMENTADO |
| P6 | sp_rpt_menu_redirigidos — `OVER(PARTITION BY menu)` + variable | `"PARTITION BY b.menu"` + `"v_total_scope"` | ✓ IMPLEMENTADO |
| P7 | v_etl_rendimiento — `LAG(duracion_seg)` | `"LAG(duracion_seg)"` en vista | ✓ IMPLEMENTADO |
| P8 | sp_rpt_resumen_abandono_rollup — WITH ROLLUP | `"WITH ROLLUP"` + v1.0.0 | ✓ IMPLEMENTADO |
| P9 | sp_rpt_centros_xsegmento — PERCENT_RANK + FIRST_VALUE | `"PERCENT_RANK"` + `"FIRST_VALUE"` | ✓ IMPLEMENTADO |
| P10 | sp_rpt_centros_transferencia — NTILE(4) | `"NTILE(4)"` + `"LEFT JOIN"` | ✓ IMPLEMENTADO |
| P11 | Query monitoreo centros | Documentada en HALLAZGOS-FASE4 | ✓ DOCUMENTADA |

### Nota: P3 y P5 — falso negativo inicial

Un check intermedio buscó `"OVER ()"` con espacio. El código real usa
`"OVER()"` sin espacio. El check era incorrecto — la implementación sí
está presente. Verificado leyendo el contexto exacto:

```
sp_rpt_cMENU_ERROR: ...b.total_llamadas)) OVER()  AS total_anomalias_quarter...
sp_rpt_clientes:    ...NULLIF(SUM(c.clientes_unicos) OVER(), 0) * 100, 2)...
```

---

## Cobertura adicional al plan original

Tres elementos implementados que el plan original (PENDIENTES-IMPLEMENTACION)
no cubría explícitamente — identificados durante el análisis de cobertura.

### Extra-1 — sp_etl_historico v2.1.0 (GAP 2)

El plan listaba P1-P11. sp_etl_historico no tenía ningún EXIT HANDLER
ni INSERT a pipeline_event_log — identificado como GAP 2 en
ANALISIS-COBERTURA-IVR-ERROR-LOG. Implementado como T1.4.

```
EXIT HANDLERs:               2   (sp_etl_base_detalle + sp_etl_base_clientes)
INSERTs pipeline_event_log:  4   (SIGNAL + ETL_FALLO×2 + VALIDACION)
v_detalle_cargado guard:     Sí  (evita continuar si base_detalle falló)
SIGNAL con log:              Sí  (p_quarter_num inválido)
```

Estado: **IMPLEMENTADO ✓** (commit d45a440)

### Extra-2 — PASO 7 de sp_etl_maestro: error_type VALIDACION (GAP 1)

Cuando sp_etl_validar retorna `v_ok=FALSE` (validación de negocio, sin
excepción técnica), el plan original no cubría el INSERT a pipeline_event_log.
Identificado como GAP 1. Extendido en T1.2.

Evidencia:
```sql
IF NOT COALESCE(v_ok, FALSE) THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, ...) VALUES ('VALIDACION', 'ALTA', 'sp_etl_validar', ...);
    END;
END IF;
```

Estado: **IMPLEMENTADO ✓** (parte de commit 768a7b2)

### Extra-3 — sp_rpt_resumen_abandono_rollup: incluye pipeline_event_log desde v1.0.0

El SP nuevo fue diseñado directamente con la validación SIGNAL + INSERT
a pipeline_event_log — no requirió una tarea separada de conexión.

---

## sp_etl_validar — diseño de delegación (no es un pendiente)

sp_etl_validar tiene EXIT HANDLER pero no inserta en pipeline_event_log.
El handler retorna `p_ok=FALSE` + `p_mensaje` via OUT params al caller.

Este es el **patrón de delegación correcto**:

```
sp_etl_validar EXIT HANDLER → p_ok=FALSE, p_mensaje=error
    → sp_etl_maestro PASO 6 handler captura la excepción → ETL_PARTIAL en PEL
    → sp_etl_maestro PASO 7 detecta v_ok=FALSE → VALIDACION en PEL
```

Si sp_etl_validar logeara directamente, habría dos entradas para el mismo
evento (una desde el SP interno con contexto parcial, otra desde el caller
con contexto completo del pipeline). El diseño actual es correcto.

**No es un pendiente.**

---

## El único artefacto pendiente real: `schema_error_log.sql` sin rastrear

### Estado en git

```
git status provisioners/mariadb/schema_error_log.sql
→ ?? provisioners/mariadb/schema_error_log.sql  (untracked)

git ls-files provisioners/mariadb/schema_error_log.sql
→ (vacío — no está en el índice de git)
```

### Origen

El commit `6e92ca4` renombró el archivo via Python (`os.rename`), que crea
el nuevo archivo y deja el original físico en disco. Git registró el rename
correctamente. El archivo físico nunca fue eliminado del filesystem.

### Contenido peligroso

```sql
-- schema_error_log.sql — nombre antiguo antes del renombre
CREATE TABLE IF NOT EXISTS ivr_error_log ( ... );    ← tabla que ya no existe
CREATE OR REPLACE VIEW v_errores_recientes AS ...;   ← vista con nombre antiguo
```

Si se ejecuta manualmente:
- Crea `ivr_error_log` — ningún SP inserta en ella; quedaría como tabla huérfana
- Crea `v_errores_recientes` — ningún código la referencia; crearía confusión

provision-mariadb.sh no lo referencia. El riesgo de ejecución accidental
es bajo, pero el archivo existe y representa una trampa para cualquier
desarrollador que haga limpieza manual.

### Acción requerida

```bash
rm provisioners/mariadb/schema_error_log.sql
```

No requiere commit separado — el archivo no está rastreado por git. Puede
eliminarse directamente o incluirse como `git clean -f` antes del siguiente
push. No afecta verify.sh ni provision.

---

## Archivos en disco sin registrar en provision que son correctos

`schema_historico.sql` y `seed_historico.sql` están excluidos de
`sql_files` intencionalmente:

- Son gestionados por `_run_etl_backfill()`, activado solo con
  `RUN_ETL_BACKFILL=1`.
- Crean y pueblan `tbl_historico_tN_YYYY` — tablas fuente del IVR.
- Están rastreados por git (commits `34c1770`, `c2890f0`).
- verify.sh los verifica con `LIKE 'tbl_historico_%'`.

**No requieren acción.**

---

## Documentos históricos con nombre antiguo (informativo)

No generan riesgo operacional — ningún SP o script los usa. Son registros
del proceso de análisis y diseño. Se listan por completitud:

| Documento | Nombre antiguo presente | Acción sugerida |
|---|---|---|
| `ANALISIS-DISENO-IVR-ERROR-LOG-20260513092720.md` | `ivr_error_log`, `v_errores_recientes` en todo el cuerpo | Agregar nota de estado al inicio si se quiere claridad |
| `PENDIENTES-IMPLEMENTACION-20260513094501.md` | `ivr_error_log`, P1-P11 como pendientes | Agregar nota de estado al inicio |
| `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO-20260513082312.md` | OVER() specs de P3/P6 eran incorrectas; corregidas en implementación | Agregar nota de correcciones aplicadas |

---

## Resumen ejecutivo

| Categoría | Estado | Acción |
|---|---|---|
| Plan P1-P11 | ✓ 100% IMPLEMENTADO | Ninguna |
| Cobertura adicional (T1.4, GAP 1, GAP 2) | ✓ IMPLEMENTADO | Ninguna |
| sp_etl_validar — delegación sin PEL directo | ✓ DISEÑO CORRECTO | Ninguna |
| provision-mariadb.sh — 25 objetos | ✓ SINCRONIZADO | Ninguna |
| Grants EXECUTE — 17 routines × 2 hosts | ✓ APLICADOS | Ninguna |
| verify.sh — 27 OK | ✓ PASA | Ninguna |
| `schema_error_log.sql` (untracked) | ⚠ ARTEFACTO OBSOLETO | `rm` del archivo |
| `schema_historico.sql` / `seed_historico.sql` | ✓ CORRECTO — excluidos intencionalmente | Ninguna |
| Documentos históricos con nombre antiguo | INFO | Opcional: agregar nota de estado |
