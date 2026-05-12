# `fn_did_segmento`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `VARCHAR(20)`

---

## Propósito

Mapea un número DID 800 al nombre del segmento IVR correspondiente. Es la función de dominio más fundamental del sistema — define la partición de todos los datos en tres segmentos de negocio.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_did` | VARCHAR(20) | Número DID 800: '19020084', '19028031' o '19020001' |

---

## Lógica

```sql
RETURN CASE p_did
    WHEN '19028031' THEN 'nacional_A'
    WHEN '19020001' THEN 'nacional_B'
    WHEN '19020084' THEN 'puebla'
    ELSE                 'desconocido'
END;
```

---

## Usada por

- sp_etl_base_detalle (ETL)
- sp_etl_base_clientes (ETL)

---

## Notas

Si el DID no es ninguno de los tres conocidos, retorna `'desconocido'`. En producción este caso no debería ocurrir porque el ETL filtra por `cDID_800Transfer IN ('19020084', '19028031', '19020001')` antes de llamar a esta función.
