# Investigación: Tabla temporal de análisis multi-quarter

**Script:** `REPTRIM001-WS.sql`
**Título interno:** "ANÁLISIS_TRIMESTRES_ÚNICOS_DUPLICADOS"
**Tipo:** Workbench — script de análisis combinado, no reporte de producción

---

## Qué hace

Crea una tabla temporal `temp_historical_quarter` que consolida los tres
quarters en una sola tabla, con índices, para facilitar análisis
combinados. El sufijo `-WS` probablemente indica "WorkbenchSheet" o
"WorkSession".

```sql
CREATE TEMPORARY TABLE temp_historical_quarter ENGINE=InnoDB AS
  SELECT ... FROM tbl_historico_t1_2025 WHERE ... UNION ALL
  SELECT ... FROM tbl_historico_t2_2025 WHERE ... UNION ALL
  SELECT ... FROM tbl_historico_t3_2025 WHERE ...

ALTER TABLE temp_historical_quarter
  ADD INDEX idx_phone_origin_trimestre (cTelefono_Origen, trimestre),
  ADD INDEX idx_quarter (trimestre),
  ADD INDEX idx_phone_origin (cTelefono_Origen);
```

## Fechas de análisis específicas (no quarters completos)

Las fechas usadas **no son quarters completos** — son rangos acotados
para un análisis específico:

```sql
-- Q1: Feb-Mar 2025 (no Enero — arranca en 2025-02-01)
SET @Q1_inicio = '2025-02-01';  SET @Q1_fin = '2025-03-31';

-- Q2: Abril-Junio 2025 (completo)
SET @Q2_inicio = '2025-04-01';  SET @Q2_fin = '2025-06-30';

-- Q3: Solo Julio 2025 (no Agosto ni Septiembre)
SET @Q3_inicio = '2025-07-01';  SET @Q3_fin = '2025-07-31';
```

## Inconsistencia de DIDs por trimestre

```sql
-- Q1: usa los 3 DIDs (incluyendo @ONacional02 = 1902001 — incorrecto)
AND cDID_800Transfer IN (@OPuebla, @ONacional, @ONacional02)

-- Q2 y Q3: solo 2 DIDs
AND cDID_800Transfer IN (@OPuebla, @ONacional)
```

Q1 incluye (incorrectamente) `@ONacional02 = 1902001`. Q2 y Q3 solo
usan Nacional A. Nacional B (19020001) queda excluido de todos los quarters.

## Por qué se conserva

Documenta el patrón de tabla temporal con índices — útil como referencia
para análisis ad-hoc complejos. La advertencia en el header del script
sobre `ENGINE=MEMORY` vs `ENGINE=InnoDB` es conocimiento operativo válido.
