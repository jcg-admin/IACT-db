# `sp_etl_validar`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE

---

## Propósito

Validación post-carga del pipeline ETL. Verifica la integridad de los datos
cargados en `base_ivr_detalle` y `base_ivr_clientes` para el quarter indicado.
Retorna un booleano y un mensaje de diagnóstico, además de emitir un result set
para consulta directa.

---

## Firma

```sql
CALL sp_etl_validar(
    IN  p_quarter  VARCHAR(10),  -- 'Q02_26'
    OUT p_ok       BOOLEAN,      -- TRUE si todos los checks pasan
    OUT p_mensaje  TEXT          -- Mensaje de éxito o detalle de fallos
);
```

---

## Quién lo invoca

| Invocador | Contexto |
|---|---|
| `sp_etl_maestro` | PASO 6 — validación automática post-carga |
| `sp_etl_historico` | Validación post-carga histórica |

`django_user` **no tiene** `GRANT EXECUTE` en este SP — es interno del pipeline.

---

## Checks ejecutados

| # | Check | Fallo si... |
|---|---|---|
| 1 | `base_ivr_detalle` tiene datos | `COUNT(*) = 0` para el quarter |
| 2 | `base_ivr_clientes` tiene exactamente 3 filas | `COUNT(*) ≠ 3` |
| 3 | `total_llamadas > 0` | `SUM(total_llamadas) = 0` (INSERT sin datos útiles) |

`p_ok = TRUE` solo si los tres checks pasan simultáneamente.

---

## Result set emitido

```sql
SELECT
    p_quarter         AS quarter,
    v_count_det       AS filas_detalle,
    v_count_cli       AS filas_clientes,
    FORMAT(v_sum, 0)  AS total_llamadas,
    p_ok              AS validacion_ok,
    p_mensaje         AS mensaje;
```

---

## Tablas que lee

| Tabla | Operación |
|---|---|
| `base_ivr_detalle` | SELECT COUNT(*), SUM(total_llamadas) |
| `base_ivr_clientes` | SELECT COUNT(*) |

No escribe en ninguna tabla.

---

## Uso directo para diagnóstico

```sql
CALL sp_etl_validar('Q02_26', @ok, @msg);
SELECT @ok AS validacion_ok, @msg AS mensaje;
```
