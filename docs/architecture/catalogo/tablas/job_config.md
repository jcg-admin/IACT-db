# `job_config`

**Schema:** `ivr_legacy`  
**Motor:** InnoDB

---

## Propósito

Configuración operacional de los jobs ETL. Permite habilitar/deshabilitar
el pipeline y ajustar parámetros sin tocar el código. `sp_etl_maestro` lee
esta tabla en PASO 0 antes de ejecutar cualquier operación.

---

## Quién escribe

Solo el DBA (root) directamente. No hay SP ni comando de aplicación que
escriba en `job_config`.

---

## Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `job_name` | VARCHAR(100) PK | Nombre del job: `'etl_diario'` |
| `is_enabled` | TINYINT(1) NOT NULL DEFAULT 1 | FALSE → sp_etl_maestro hace SKIP |
| `timeout_seconds` | INT NOT NULL DEFAULT 1800 | Timeout del job (30 min por defecto) |
| `ventana_inicio` | TIME NULL DEFAULT '02:00:00' | Hora de inicio de la ventana |
| `ventana_fin` | TIME NULL DEFAULT '04:00:00' | Hora de fin de la ventana |
| `min_intervalo_h` | INT NOT NULL DEFAULT 6 | Mínimo de horas entre ejecuciones |
| `notas` | TEXT NULL | Comentarios operacionales |
| `actualizado_en` | DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP | Timestamp de última modificación |

---

## Configuración inicial

```sql
INSERT INTO job_config (job_name, is_enabled, timeout_seconds, min_intervalo_h)
VALUES ('etl_diario', TRUE, 1800, 6);
```

---

## Operaciones frecuentes

```sql
-- Deshabilitar el ETL (mantenimiento, incidente):
UPDATE job_config SET is_enabled = FALSE WHERE job_name = 'etl_diario';

-- Rehabilitar:
UPDATE job_config SET is_enabled = TRUE WHERE job_name = 'etl_diario';

-- Verificar configuración actual:
SELECT * FROM job_config WHERE job_name = 'etl_diario';
```

---

## Nota

`min_intervalo_h` define la ventana de protección contra concurrencia en
`sp_etl_maestro` PASO 1. Con el valor predeterminado de 6 horas, si hay
un maestro en RUNNING de las últimas 6 horas, la nueva ejecución hace SKIP.
