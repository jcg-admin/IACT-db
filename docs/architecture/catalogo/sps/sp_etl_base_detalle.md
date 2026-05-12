# `sp_etl_base_detalle`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Label de bloque:** `etl_detalle`

---

## Propósito

ETL principal del pipeline IVR. Lee `tbl_historico_tN_YYYY`, normaliza los datos
usando las funciones de utilidad y los agrega en `base_ivr_detalle` con grain
`quarter × mes × segmento × centro × menú × opción`.

Procesa mes a mes dentro del quarter (chunks de ~4M filas) para mantener el
tamaño del undo log manejable. Es idempotente: hace `DELETE` del mes antes del
`INSERT`, por lo que re-ejecutar para el mismo quarter es seguro.

---

## Firma

```sql
CALL sp_etl_base_detalle(
    p_quarter  VARCHAR(10),   -- 'Q02_26'
    p_inicio   DATE,          -- '2026-04-01'
    p_fin      DATE,          -- '2026-06-30'
    p_table    VARCHAR(100),  -- 'tbl_historico_t2_2026'
    p_log_id   INT            -- ID en job_execution_log para actualizar progreso
);
```

---

## Quién lo invoca

| Invocador | Contexto |
|---|---|
| `sp_etl_maestro` | PASO 4 — ejecución automática del quarter actual |
| `sp_etl_historico` | Carga manual de quarters históricos |

`django_user` **no tiene** `GRANT EXECUTE` en este SP — es interno del pipeline.

---

## Algoritmo

```
1. Validar p_table != NULL y != ''
2. v_mes_ini = p_inicio
3. WHILE v_mes_ini <= p_fin:
     a. Calcular v_mes_fin = LAST_DAY(v_mes_ini) [truncado a p_fin si necesario]
     b. DELETE base_ivr_detalle WHERE trimestre=p_quarter AND fecha=YYYYMM(v_mes_ini)
     c. PREPARE etl_sql = INSERT INTO base_ivr_detalle ... FROM p_table WHERE fecha BETWEEN ...
     d. EXECUTE con @etl_q, @etl_i, @etl_f
     e. Acumular ROW_COUNT() en v_total_ins
     f. Avanzar: v_mes_ini = primer día del mes siguiente
4. UPDATE job_execution_log (si p_log_id > 0)
```

---

## Normalización aplicada

| Campo fuente | Función aplicada | Campo destino |
|---|---|---|
| `cDID_800Transfer` | `fn_did_segmento()` | `segmento` |
| `cDID_Centro_Transferencia` | `fn_normalizar_centro()` | `centro_transferencia` |
| `cMenu` | `fn_normalizar_menu()` | `menu` |
| `cOpcion` | `COALESCE(NULLIF(TRIM(...), ''), 'SIN_OPCION')` | `opcion` |
| `dFecha` | `ivr_es_dia_semana()` | `llamadas_entre_semana`, `llamadas_fines_semana` |

---

## Tabla fuente — restricciones de DID

Solo procesa llamadas de los tres DIDs del sistema IVR:

```sql
AND cDID_800Transfer IN ('19020084', '19028031', '19020001')
```

| DID | Segmento |
|---|---|
| `19028031` | `nacional_A` |
| `19020001` | `nacional_B` |
| `19020084` | `puebla` |

---

## Tablas que lee / escribe

| Tabla | Operación |
|---|---|
| `tbl_historico_tN_YYYY` | SELECT (nombre dinámico via PREPARE/EXECUTE) |
| `base_ivr_detalle` | DELETE (idempotencia), INSERT con ON DUPLICATE KEY UPDATE |
| `job_execution_log` | UPDATE (progreso al finalizar) |

---

## Por qué usa PREPARE/EXECUTE

El nombre de la tabla fuente (`p_table`) es dinámico — MariaDB no permite
nombre de tabla como parámetro en SQL estático. Obligatorio por CNST-ETL-008.

---

## Notas importantes

`COUNT DISTINCT cTelefono_Origen` (clientes únicos) **no** está en este SP
porque COUNT DISTINCT no es aditivo — no puede calcularse mes a mes y sumarse.
Por eso existe `sp_etl_base_clientes` como segundo scan del mismo conjunto.
