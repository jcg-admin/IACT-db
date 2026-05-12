# `provisioners/mariadb/schema_historico.sh`

**Requiere root:** Sí  
**Idempotente:** Sí (acción APPEND por defecto)

---

## Propósito

Crea las tablas `tbl_historico_tN_YYYY` en `ivr_legacy` y las siembra con
datos sintéticos generados por `poblar_historico.py`. Las tablas son la
fuente de datos del pipeline ETL.

---

## Tablas que genera

| Tabla | Quarter | Periodo |
|---|---|---|
| `tbl_historico_t1_2025` | Q1 2025 | 2025-01-01 → 2025-03-31 |
| `tbl_historico_t2_2025` | Q2 2025 | 2025-04-01 → 2025-06-30 |
| `tbl_historico_t3_2025` | Q3 2025 | 2025-07-01 → 2025-09-30 |
| `tbl_historico_t4_2025` | Q4 2025 | 2025-10-01 → 2025-12-31 |
| `tbl_historico_t1_2026` | Q1 2026 | 2026-01-01 → 2026-03-31 |
| `tbl_historico_t2_2026` | Q2 2026 | 2026-04-01 → en curso |

---

## Acciones disponibles

| Acción | Descripción |
|---|---|
| `APPEND` (default) | Solo inserta filas faltantes — no toca las existentes |
| `TRUNCATE` | Vacía la tabla antes de insertar |
| `SKIP` | No hace nada si la tabla tiene datos |
