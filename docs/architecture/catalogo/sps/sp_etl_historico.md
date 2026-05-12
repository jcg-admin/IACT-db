# `sp_etl_historico`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE

---

## Propósito

Wrapper para la carga histórica de quarters pasados. Ejecuta el pipeline completo
(`sp_etl_base_detalle` + `sp_etl_base_clientes` + `sp_etl_validar`) para un
quarter específico identificado por año y número de quarter.

Diseñado para backfill manual: permite procesar quarters históricos sin modificar
la lógica del SP automático (`sp_etl_maestro`).

---

## Firma

```sql
CALL sp_etl_historico(
    p_year        INT,  -- 2025
    p_quarter_num INT   -- 1 a 4  (1=Q1, 2=Q2, 3=Q3, 4=Q4)
);
```

---

## Quién lo invoca

| Invocador | Contexto |
|---|---|
| `run_etl.py` (IACT-api) | `ETLReintentarView` — carga histórica manual |
| DBA | Invocación directa para backfill |

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_etl_historico`.

---

## Algoritmo

```
1. Validar p_quarter_num IN (1, 2, 3, 4)
2. Calcular v_quarter = 'Q0{q}_{year_2d}'
3. Calcular v_table   = 'tbl_historico_t{q}_{year}'
4. Calcular v_inicio y v_fin (MAKEDATE + INTERVAL)
5. INSERT RUNNING en job_execution_log (job_name='etl_historico')
6. CALL sp_etl_base_detalle(...)
7. DO SLEEP(5)   ← pausa para no saturar el servidor en backfill
8. INSERT RUNNING en job_execution_log
9. CALL sp_etl_base_clientes(...)
10. CALL sp_etl_validar(...)
11. SELECT resultado (quarter, ok, mensaje)
```

No tiene EXIT HANDLERs propios — las excepciones propagan al invocador.

---

## Diferencias con `sp_etl_maestro`

| Aspecto | `sp_etl_maestro` | `sp_etl_historico` |
|---|---|---|
| Quarter | Calculado automáticamente (CURDATE) | Parámetro explícito |
| Concurrencia | Check de 6h + `job_config.is_enabled` | Sin check |
| Checkpoints | Completos (PASO 0..7) | Mínimos (solo paso detalle y clientes) |
| Pausa | Sin pausa | `SLEEP(5)` entre detalle y clientes |
| Manejo de errores | EXIT HANDLERs en PASO 4 y PASO 5 | Sin handlers — propaga |
| `job_name` en log | `etl_diario` | `etl_historico` |

---

## Tablas que lee / escribe

| Tabla | Operación |
|---|---|
| `tbl_historico_tN_YYYY` | SELECT (vía sub-SPs) |
| `base_ivr_detalle` | DELETE + INSERT (vía `sp_etl_base_detalle`) |
| `base_ivr_clientes` | DELETE + INSERT (vía `sp_etl_base_clientes`) |
| `job_execution_log` | INSERT (inicio detalle y clientes) |

---

## Ejemplo

```sql
-- Procesar Q1 2025
CALL sp_etl_historico(2025, 1);

-- Verificar resultado
SELECT quarter_name, step_name, status, records_procesados
FROM job_execution_log
WHERE job_name = 'etl_historico'
ORDER BY id DESC LIMIT 3;
```
