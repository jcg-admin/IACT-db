# `base_ivr_clientes`

**Schema:** `ivr_legacy`  
**Motor:** InnoDB  
**Grain:** quarter × segmento

---

## Propósito

Almacena el COUNT DISTINCT de `cTelefono_Origen` por segmento y quarter.
Existe como tabla separada porque COUNT DISTINCT no es aditivo — no puede
calcularse mes a mes desde `base_ivr_detalle`.

Resultado esperado: exactamente 3 filas por quarter (una por segmento).

---

## Quién escribe

`sp_etl_base_clientes` como `DEFINER=root`.

---

## Quién lee

`sp_rpt_clientes`. También accesible para `django_user` vía SELECT global.

---

## Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT AUTO_INCREMENT PK | Identificador interno |
| `trimestre` | VARCHAR(10) NOT NULL | Quarter: `'Q01_25'`...`'Q02_26'` |
| `segmento` | VARCHAR(20) NOT NULL | `nacional_A` \| `nacional_B` \| `puebla` |
| `clientes_unicos` | INT NOT NULL DEFAULT 0 | COUNT DISTINCT cTelefono_Origen |
| `cargado_en` | DATETIME DEFAULT CURRENT_TIMESTAMP | Timestamp de la última carga |

---

## Índice único

```sql
UNIQUE KEY (trimestre, segmento)
```

---

## Nota P-NEW-04

Pendiente confirmar con el equipo si el denominador correcto es `cTelefono_Origen`
(siempre presente) o `cTelefono_Digitado` (21% NULL en producción). Los datos
reales con ratio ~3.5 llamadas/cliente apuntan a `cTelefono_Origen`.
