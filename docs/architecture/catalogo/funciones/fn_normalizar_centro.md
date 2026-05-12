# `fn_normalizar_centro`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `VARCHAR(100)`

---

## Propósito

Normaliza el valor raw de `cDID_Centro_Transferencia` al VDN limpio o a un sentinel que identifica el tipo de anomalía. Garantiza que base_ivr_detalle solo contenga valores procesables.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_centro` | VARCHAR(50) | Valor raw de cDID_Centro_Transferencia |

---

## Lógica

```
SI p_centro IS NULL o vacío  → 'CASO_NULL'
SI p_centro = 'cliente_colgo'→ 'CLIENTE_COLGO'
SI p_centro = '000...0'      → 'CASO_ERROR_CEROS'    (REGEXP '^0+$')
SI p_centro empieza con      → 'ERROR_CARACTER_INICIAL'
   carácter no numérico
SI LENGTH > 10               → LEFT(p_centro, LENGTH-10)  (quitar sufijo)
ELSE                         → p_centro tal cual
```

---

## Usada por

- sp_etl_base_detalle (ETL)

---

## Notas

Los cuatro valores sentinel (`CASO_NULL`, `CLIENTE_COLGO`, `CASO_ERROR_CEROS`, `ERROR_CARACTER_INICIAL`) son excluidos por los SPs de reporte. La lógica de recorte (LENGTH > 10) elimina sufijos de enrutamiento interno que aparecen en producción.
