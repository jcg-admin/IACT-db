# `base_ivr_detalle`

**Schema:** `ivr_legacy`  
**Motor:** InnoDB  
**Grain:** quarter × mes × segmento × centro_transferencia × menu × opcion

---

## Propósito

Tabla analítica principal del sistema IVR. Contiene datos de llamadas agregados
por el ETL desde `tbl_historico_tN_YYYY`. Es la fuente de 6 de los 7 SPs de
reporte. El grain es la combinación única de los 6 campos de agrupación.

---

## Quién escribe

`sp_etl_base_detalle` como `DEFINER=root` — `django_user` **no tiene** INSERT/UPDATE directo.

---

## Quién lee

Todos los SPs de reporte excepto `sp_rpt_clientes`. `django_user` tiene
`SELECT` vía el grant global `GRANT SELECT ON ivr_legacy.*`.

---

## Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT AUTO_INCREMENT PK | Identificador interno |
| `trimestre` | VARCHAR(10) NOT NULL | Quarter: `'Q01_25'`...`'Q02_26'` |
| `fecha` | VARCHAR(6) NOT NULL | Mes YYYYMM: `'202501'`...`'202605'` |
| `segmento` | VARCHAR(20) NOT NULL | `nacional_A` \| `nacional_B` \| `puebla` |
| `centro_transferencia` | VARCHAR(100) NOT NULL | VDN normalizado o sentinel |
| `menu` | VARCHAR(100) NOT NULL | cMenu raw normalizado (mixed case) |
| `opcion` | VARCHAR(100) NOT NULL | cOpcion o `'SIN_OPCION'` |
| `total_llamadas` | INT NOT NULL DEFAULT 0 | COUNT(*) del grupo |
| `misma_linea` | INT NOT NULL DEFAULT 0 | cTelefono_Origen = cTelefono_Digitado |
| `linea_diferente` | INT NOT NULL DEFAULT 0 | cTelefono_Origen ≠ cTelefono_Digitado |
| `no_digito_telefono` | INT NOT NULL DEFAULT 0 | cTelefono_Digitado IS NULL |
| `llamadas_entre_semana` | INT NOT NULL DEFAULT 0 | Lunes a viernes |
| `llamadas_fines_semana` | INT NOT NULL DEFAULT 0 | Sábado y domingo |
| `cargado_en` | DATETIME DEFAULT CURRENT_TIMESTAMP | Timestamp de la última carga |

---

## Índice único

```sql
UNIQUE KEY (trimestre, fecha, segmento, centro_transferencia, menu, opcion)
```

Permite el `ON DUPLICATE KEY UPDATE` idempotente del ETL.

---

## Sentinels en `centro_transferencia`

| Valor | Origen |
|---|---|
| `CASO_NULL` | cDID_Centro_Transferencia NULL o vacío |
| `CLIENTE_COLGO` | cDID = 'cliente_colgo' |
| `CASO_ERROR_CEROS` | cDID solo contiene ceros |
| `ERROR_CARACTER_INICIAL` | cDID empieza con carácter no numérico |

Los SPs de reporte excluyen estos sentinels en sus filtros WHERE.

---

## Volumen de referencia

~16,500 filas por quarter completo. Con 6 quarters cargados: ~100K filas.
