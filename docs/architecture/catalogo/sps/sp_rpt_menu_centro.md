# `sp_rpt_menu_centro`

**Archivo fuente:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Caso de uso:** UC_RPT_16

---

## Propósito

Perspectiva inversa: centro de transferencia → menús y opciones que lo alimentan. Responde: ¿qué combinaciones de menú+opción llegan a cada centro y con qué volumen? Complemento de sp_rpt_menu_redirigidos.

---

## Firma

```sql
CALL sp_rpt_menu_centro(
    p_quarter  VARCHAR(10),
    p_segmento VARCHAR(20)
);
```

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_rpt_menu_centro`.

---

## Result set

| Columna | Tipo | Descripción |
|---|---|---|
| `trimestre` | VARCHAR(10) | Quarter |
| `segmento` | VARCHAR(20) | Segmento IVR |
| `centro_transferencia` | VARCHAR(100) | Centro receptor |
| `menu` | VARCHAR(100) | Menú que alimenta al centro |
| `opcion` | VARCHAR(100) | Opción del menú |
| `total_llamadas` | BIGINT | Volumen menú+opción→centro |
| `pct_del_centro` | DECIMAL(6,2) | % de ese centro que viene de este menú+opción |
| `misma_linea` | BIGINT | SUM misma_linea |
| `linea_diferente` | BIGINT | SUM linea_diferente |
| `no_digito_telefono` | BIGINT | SUM no_digito_telefono |

---

## Tabla fuente

`base_ivr_detalle` (excluye sentinels: CASO_NULL, CASO_ERROR_CEROS, ERROR_CARACTER_INICIAL)

---

## Notas

Grain fino: trimestre × segmento × centro × menu × opcion.
