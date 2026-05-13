```yml
created_at: 2026-04-28 16:00:00
project: IACT-docs
work_package: 2026-04-28-05-27-25-source-rebuild-base-cognitiva
phase: Phase 3 — ANALYZE (v2 remediation)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# CNST ID Drift — base_cognitiva ↔ rebuild

## Origen

Hallazgos W-1 y W-7 detectados durante WP #4
(`source-rebuild-normativa-restricciones`, deep-review 05). Estaban
documentados en `cross-wp-debt-summary.md` con destino "WP
base-cognitiva".

## Diagnostico

`source/base_cognitiva/` (cerrado en WP-hijo #1 v1) tiene 31 referencias
a CNSTs con semantica del set legacy (10 CNSTs). El rebuild de WP #4
produjo un set de 31 CNSTs atomicos con numeracion completamente nueva.
Las referencias en base_cognitiva quedaron rotas a nivel semantico —
los IDs siguen existiendo pero apuntan a conceptos distintos.

### Drift de conceptos por CNST

| Ref legacy | Sentido legacy | Ref correcta en rebuild | Cambio |
|------------|----------------|--------------------------|--------|
| CNST_001 | Email/Comunicaciones | **CNST_001** Prohibicion Email | Sin cambio (alineado) |
| CNST_003 | BD Dual | **CNST_006** Arquitectura BD Dual | Renumeracion |
| CNST_004 | ETL nocturno | **CNST_008** Sincronizacion ETL 6-12h | Renumeracion |
| CNST_007 | Performance / Limites Exportacion | **CNST_017-020** (SLA + Rango + Async + Throttling Export) | Concepto ahora distribuido en 4 CNSTs atomicos |
| CNST_009 | Auditoria Inmutable | **CNST_025** Auditoria Inmutable | Renumeracion (CNST_009 ahora es Auth DRF) |

### Conteos desactualizados

| Documento | Linea | Texto actual | Texto correcto |
|-----------|-------|--------------|----------------|
| `_metadata/META_04_Contexto_IACT.rst` | 250 | "CNST_001-010" | "CNST_001-031" |
| `_fundamentos_conceptuales/FND_00_Contexto_y_Jerarquia.rst` | 231 | "10 Restricciones arquitectónicas (CNST)" | "31 Restricciones arquitectonicas (CNST)" |
| `_taxonomias_y_metamodelos/taxonomias/TXM_01_Taxonomia_Requisitos.rst` | 541-542 | "Constraints (CNST) = 4 / Conocidas actualmente" | "Constraints (CNST) = 31 / Set canonico tras rebuild SRP (WP #4)" |

## Inventario de archivos afectados

| Archivo | Refs CNST | Drift detectado |
|---------|-----------|-----------------|
| `_fundamentos_conceptuales/FND_00_Contexto_y_Jerarquia.rst` | 17 | Si — concepto BR_011↔CNST_007 |
| `_fundamentos_conceptuales/FND_07_Requerimientos_Funcionales.rst` | 2 | No (solo CNST_001) |
| `_metadata/META_04_Contexto_IACT.rst` | 1 | Si — rango "CNST_001-010" |
| `_ontologia_sbvr/SBVR_01_Conceptos_Nucleares.rst` | 1 | No (solo CNST_001) |
| `_ontologia_sbvr/SBVR_04_Reglas_Operativas.rst` | 5 | No (todas CNST_001) |
| `_taxonomias_y_metamodelos/taxonomias/TXM_01_Taxonomia_Requisitos.rst` | 4 | Si — ejemplos legacy |
| `_taxonomias_y_metamodelos/taxonomias/TXM_02_Taxonomia_Artefactos.rst` | 4 | Si — tabla legacy |
| **Total** | **34** | **6 archivos con drift, 4 archivos limpios (solo CNST_001)** |

## Mapping de correcciones a aplicar

### Correcciones literales (texto exacto a substituir)

| Archivo | Linea | Buscar | Reemplazar |
|---------|-------|--------|------------|
| FND_00 | 151 | `**CNST_003:** BD Dual - MySQL IVR readonly + PostgreSQL Analytics` | `**CNST_006:** Arquitectura BD Dual - MySQL IVR + PostgreSQL Analytics` |
| FND_00 | 152 | `**CNST_004:** ETL nocturno (datos no son tiempo real)` | `**CNST_008:** Sincronizacion ETL en ventana de 6 a 12 horas (no real-time)` |
| FND_00 | 287 | `(CNST_007)` | `(CNST_020 — Throttling de Exportaciones)` |
| FND_00 | 298 | `:CNST Relacionado: CNST_007 (Performance)` | `:CNST Relacionado: CNST_020 (Throttling de Exportaciones por Formato)` |
| FND_00 | 379 | `(BR_011 - CNST_007)` | `(BR_011 - CNST_020)` |
| FND_00 | 382 | `UserActionLog (CNST_009)` | `UserActionLog (CNST_025 — Auditoria Inmutable)` |
| FND_00 | 458 | `BR_011 y CNST_007` | `BR_011 y CNST_020` |
| FND_00 | 488 | `cnst_code='CNST_007'` | `cnst_code='CNST_020'` |
| FND_00 | 514 | `auditoría (CNST_009)` | `auditoria (CNST_025 — Auditoria Inmutable)` |
| FND_00 | 562 | `Relación con CNST_007` | `Relacion con CNST_020 (Throttling)` |
| FND_00 | 565 | `**CNST_007: Límites de Exportación**` | `**CNST_020: Throttling de Exportaciones por Formato**` (nota: el concepto "Limites de Exportacion" se descompuso en CNST_017 SLA + CNST_018 Rango + CNST_019 Async + CNST_020 Throttling. Se elige CNST_020 por la cita BR_011 sobre limites cuantitativos por formato) |
| FND_00 | 575 | `CNST_007 (Constraint)` | `CNST_020 (Constraint)` |
| FND_00 | 593 | `CNST_007 (restricciones_arquitectonicas/)` | `CNST_020 (normativa/restricciones/)` |
| FND_00 | 599 | `CNST_007 (Restricción Arquitectónica)` | `CNST_020 (Restriccion Arquitectonica)` |
| FND_00 | 800 | `restricciones_arquitectonicas/CNST_007_Limites_Exportacion.rst` | `normativa/restricciones/CNST_020_Throttling_de_Exportaciones_por_Formato.rst` |
| TXM_01 | 412 | `CNST_003: Sesion Unica por Usuario` | `CNST_004: Sesion Unica por Usuario` |
| TXM_01 | 416 | `CNST_004: Auditoria Inmutable` | `CNST_025: Auditoria Inmutable` |
| TXM_01 | 541-542 | `Constraints (CNST) / 4 / Conocidas actualmente` | `Constraints (CNST) / 31 / Set canonico tras rebuild SRP (WP #4)` |
| TXM_02 | 269 | `* - CNST_003 / Sesion Unica por Usuario` | `* - CNST_004 / Sesion Unica por Usuario` |
| TXM_02 | 271 | `* - CNST_004 / Auditoria Inmutable` | `* - CNST_025 / Auditoria Inmutable` |
| META_04 | 250 | `CNST_001-010` | `CNST_001-031` |
| FND_00 | 231 | `10 Restricciones arquitectónicas (CNST)` | `31 Restricciones arquitectonicas (CNST)` |

### Refs sin drift (mantener)

- 5 refs a CNST_001 (Email) en SBVR_04, SBVR_01, FND_07, MTM_03, FND_00:153 → todas correctas, alineadas con rebuild
- 2 refs en FND_07 a CNST_001 → correctas

## Verificacion post-fix

- Build verde sin warnings
- 0 references a CNST_007 con sentido "Performance/Limites Exportacion"
- 0 references a CNST_009 con sentido "Auditoria"
- Conteos actualizados (31 en lugar de 4 / 10)
- Refs cruzadas via `:doc:` apuntan a archivos existentes en
  `source/normativa/restricciones/`

## Trazabilidad

- Origen del hallazgo: `cross-wp-debt-summary.md` § E-1, W-1, W-7
- WP que produjo el rebuild de CNSTs: WP #4 normativa-restricciones
- WP que aplica esta correccion: este (WP base-cognitiva v2)
- Insumo que documenta el mapeo viejo→nuevo:
  `2026-04-28-05-28-43-source-rebuild-normativa-restricciones/discover/mapeo-viejo-nuevo.md`
