# `fn_normalizar_menu`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `VARCHAR(100)`

---

## Propósito

Normaliza el valor raw de cMenu: reemplaza NULL, vacío y 'sin cMenu' por el sentinel 'VACIO'. Cualquier otro valor se pasa tal cual (mixed case, el ETL no aplica UPPER — los SPs de reporte lo hacen para presentación).

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_menu` | VARCHAR(100) | Valor raw de cMenu del sistema IVR |

---

## Lógica

```sql
IF p_menu IS NULL OR TRIM(p_menu) = '' OR p_menu = 'sin cMenu'
    RETURN 'VACIO';
RETURN p_menu;
```

---

## Usada por

- sp_etl_base_detalle (ETL)

---

## Notas

El sentinel 'VACIO' representa llamadas sin identificación de menú y es uno de los tres valores de abandono en UC_RPT_13 (junto con 'cliente_colgo' y 'SinOpcion_Cabecera'). Los SPs de reporte aplican `UPPER(TRIM(b.menu))` para presentación; el ETL almacena mixed case para preservar el valor original.
