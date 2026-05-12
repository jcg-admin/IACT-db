# `fn_duracion_seg`

**Archivo fuente:** `provisioners/mariadb/funciones_utilidad.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** FUNCTION  
**Retorna:** `INT`

---

## Propósito

Calcula la diferencia en segundos entre dos valores DATETIME. Usa ABS para manejar casos donde el orden no está garantizado.

---

## Firma

| Parámetro | Tipo | Descripción |
|---|---|---|
| `p_ini` | DATETIME | Fecha/hora de inicio |
| `p_fin` | DATETIME | Fecha/hora de fin |

---

## Lógica

```sql
IF p_ini IS NULL OR p_fin IS NULL THEN RETURN 0; END IF;
RETURN ABS(TIME_TO_SEC(TIME(p_fin)) - TIME_TO_SEC(TIME(p_ini)));
```

---

## Usada por

- Disponible para consultas analíticas — no usada directamente en los SPs actuales

---

## Notas

Retorna 0 si cualquiera de los parámetros es NULL. El uso de `TIME()` extrae solo la parte horaria — no calcula duraciones de más de 24 horas correctamente. Adecuada para duraciones de llamadas IVR que son siempre < 1 hora.
