# `sp_etl_base_clientes`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Label de bloque:** `etl_clientes`

---

## Propósito

Segundo scan de `tbl_historico_tN_YYYY`: calcula `COUNT(DISTINCT cTelefono_Origen)`
por segmento para el quarter completo y lo carga en `base_ivr_clientes`.

Existe como SP separado de `sp_etl_base_detalle` porque `COUNT DISTINCT` no es
aditivo — no puede calcularse mes a mes y sumarse. Requiere un scan completo del
quarter en una sola operación.

Resultado esperado: exactamente 3 filas (una por segmento).

---

## Firma

```sql
CALL sp_etl_base_clientes(
    p_quarter  VARCHAR(10),   -- 'Q02_26'
    p_inicio   DATE,          -- '2026-04-01'
    p_fin      DATE,          -- '2026-06-30'
    p_table    VARCHAR(100),  -- 'tbl_historico_t2_2026'
    p_log_id   INT            -- ID en job_execution_log
);
```

---

## Quién lo invoca

| Invocador | Contexto |
|---|---|
| `sp_etl_maestro` | PASO 5 — ejecución automática |
| `sp_etl_historico` | Carga histórica manual |

`django_user` **no tiene** `GRANT EXECUTE` en este SP — es interno del pipeline.

---

## Algoritmo

```
1. Validar p_table != NULL
2. DELETE base_ivr_clientes WHERE trimestre = p_quarter  (idempotencia)
3. PREPARE cli_sql = INSERT INTO base_ivr_clientes
       SELECT ?, fn_did_segmento(cDID_800Transfer), COUNT(DISTINCT cTelefono_Origen)
       FROM p_table WHERE dFecha BETWEEN ? AND ?
       GROUP BY segmento
       ON DUPLICATE KEY UPDATE clientes_unicos=VALUES(...)
4. EXECUTE con @cli_q, @cli_i, @cli_f
5. UPDATE job_execution_log con ROW_COUNT()
```

---

## Nota sobre P-NEW-04

El SP usa `cTelefono_Origen` para el COUNT DISTINCT. Pendiente confirmar con el
equipo si debe ser `cTelefono_Digitado` (21% NULL en producción). Los datos
reales con ratio ~3.5 llamadas/cliente apuntan a `cTelefono_Origen`.

---

## Tablas que lee / escribe

| Tabla | Operación |
|---|---|
| `tbl_historico_tN_YYYY` | SELECT (dinámico via PREPARE/EXECUTE) |
| `base_ivr_clientes` | DELETE (idempotencia), INSERT con ON DUPLICATE KEY UPDATE |
| `job_execution_log` | UPDATE (progreso) |
