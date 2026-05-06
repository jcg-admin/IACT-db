# Datos reales de producción

Resultados de ejecución de los scripts de análisis sobre las tablas
históricas del IVR. Son la fuente más directa para calibrar el diseño
del ETL — reemplazan estimaciones con números reales.

---

## Directorios

| Directorio | Contenido |
|---|---|
| `q01-2025/` | Resultados sobre `tbl_historico_t1_2025` (Q1 2025) |

---

## Cómo interpretar estos datos

Los resultados son snapshots en un momento dado. Si los scripts se
ejecutan de nuevo sobre los mismos datos, los números deben ser idénticos.
Si hay diferencias, indica que la tabla fuente fue modificada.

Cada directorio de quarter tiene su propio `README.md` con el análisis
e implicaciones para el ETL.
