```yml
created_at: 2026-04-28 09:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Búsqueda exhaustiva de CNSTs en temp-holding

## Alcance de la búsqueda

`temp-holding/FASE 01/`, `temp-holding/FASE 02/`, `temp-holding/RBAC/`,
`temp-holding/GENERACION_DOCUMENTACION/` — excluyendo backups
duplicados (`IACT_Backup_Completo_*`, `TMP_COMPLETO_*`).

Patrones grep: `restricc`, `CNST`, `constraint`.

## Hallazgos clasificados

### A. CNSTs físicas como archivos `.rst`

| Ruta | Conteo | Estado |
|------|--------|--------|
| `temp-backup/source-2026-04-28/normativa/restricciones/` | 11 (backup canónico) | Ya integradas en rebuild |
| `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/` | 8 (set divergente) | Analizadas — contenido único en TH-004, TH-006, TH-007 |
| `temp-holding/FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst` | 1 (standalone) | Descartada por D-CNST-3 (es regla de proceso, no de sistema) |
| **Total CNSTs físicas** | **20** | — |

### B. Documentación analítica sobre CNSTs (no son CNSTs)

`temp-holding/FASE 01/CNST RESTRICCIONES/` contiene 13 archivos `.md`
(9 529 líneas total). Son análisis, propuestas y reportes — NO
declaran nuevas restricciones.

| Archivo | Líneas | Conclusión |
|---------|--------|------------|
| `RESTRICCIONES COMPLETAS DEL SISTEMA IACT.md` | 1 118 | Doc maestro consolidado (10 categorías) — ya cubierto por backup |
| `ANALISIS_GAPS_CNST.md` | 462 | Recomendación explícita: **"AMPLIAR, NO CREAR"** |
| `ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_1.md` | 1 499 | Cambios v1.0.0→v1.1.0, no nuevos CNSTs |
| `PROPUESTA_AMPLIACIONES_CNST_005-006.md` | 1 126 | Propuesta de ampliar CNST_005 (permisos temporales) y CNST_006 (patrones) |
| `REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md` | 1 129 | Reporte de revisión, no nuevos CNSTs |
| `ARBOL_COMPLETO_v2_0_*.md` (×2) | 553 | Estructura del árbol del proyecto |
| `ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | 262 | Actualización del árbol, no nuevos CNSTs |
| Resto (5 archivos) | ≈3 380 | Borradores y duplicados de los anteriores |

### C. GAPs identificados en `ANALISIS_GAPS_CNST.md`

| GAP | Descripción | Recomendación previa | Aplica al rebuild? |
|-----|-------------|----------------------|--------------------|
| **GAP #1** Permisos Temporales | Detalle insuficiente en CNST-005 | Ampliar CNST-005 | Capturado en CNST_R03 (descomposición SRP) |
| **GAP #2** Patrones de Diseño Recomendados | 75 ln vs 1 126 ln antipatrones | Ampliar CNST-006 | NO es restricción — pertenece a `estandares/` o guía. Excluido de SRP |
| **GAP #3** Restricciones de Frontend (NO existe) | Frontend sin restricciones | "No es necesario" (recomendación previa) | Diferido — no es restricción técnica del backup |
| **GAP #4** Restricciones de Testing (NO existe) | Cobertura, fixtures, framework | "No es restricción, es proceso" | Va a `procedimientos/` y `estandares/` |
| **GAP #5** Restricciones de Documentación (NO existe) | Cómo documentar | Implícito | Va a `estandares/` (STD_001/006/007) |

**Conclusión sobre GAPs:** ningún GAP del análisis previo corresponde
a una CNST técnica del sistema IACT que falte en el rebuild.
Frontend, Testing y Documentación NO son restricciones del sistema —
son procesos / estándares ya cubiertos en otros cajones de
`normativa/`.

### D. Contenido único en temp-holding NO cubierto por backup canónico

| Concept atómico | Origen TH | Backup actual | ¿En propuesta SRP-30? |
|-----------------|-----------|---------------|------------------------|
| Buzón interno: máximo 50 destinatarios | TH-CNST_004 | No | Sí — CNST_C02 |
| Buzón interno: consolidación 1 h | TH-CNST_004 | No | Sí — CNST_C02 |
| Buzón interno: evaluación 5–15 min | TH-CNST_004 | No | Sí — CNST_C02 |
| Reportes: rango máximo 2 años / 730 días | TH-CNST_006 | Genérico (max_days) | Sí — CNST_P02 |
| **Throttling exportación: tabla por formato (CSV 100k/10d/60s · Excel 50k/5d/90s · PDF 10k/3d/120s)** | TH-CNST_007 | Implementación pero sin tabla concreta | **Parcial** — actualmente integrado en CNST_P03; merece CNST atómica propia |

## Acciones derivadas para la propuesta SRP-30

### Ajuste #1: separar throttling de async

La propuesta original combinaba dos concerns en CNST_P03:

- (a) Exportaciones >10k registros deben ser asíncronas
- (b) Throttling con límites por formato (CSV/Excel/PDF)

Aplicando SRP estricto, son dos restricciones distintas:

- **CNST_P03 Exportaciones_Asincronas** — concern: cuándo el procesamiento debe ser async vs sync
- **CNST_P04 Throttling_Exportacion** — concern: límites cuantitativos por formato y frecuencia

### Ajuste #2: total revisado

**31 CNSTs atómicas** (en lugar de 30).

| Dominio | # CNSTs |
|---------|---------|
| Comunicaciones | 2 |
| Sesiones | 3 |
| Base de datos | 3 |
| Seguridad DRF | 6 |
| Arquitectura | 2 |
| Performance | **4** (era 3) |
| Infraestructura | 3 |
| Logging | 3 |
| Datos | 2 |
| RBAC | 3 |
| **Total** | **31** |

### Identificadores finales (Opción A — flat numérico)

`CNST_001` … `CNST_031` con prefijo de dominio interno solo en metadata
y en index.rst (no en filename).

## Conclusión

Verificación exhaustiva confirma:

1. **NO hay CNSTs adicionales** en temp-holding más allá de las ya
   contempladas en el análisis SRP.
2. **El contenido único de TH (alertas, reportes, throttling)** ya está
   capturado en la propuesta SRP-30, con un ajuste menor (separar
   async de throttling → SRP-31).
3. **Los GAPs identificados en el análisis previo** (Frontend, Testing,
   Documentación) NO son restricciones del sistema IACT — pertenecen a
   `procedimientos/` y `estandares/`, fuera del scope de este WP.

**Recomendación final:** proceder con descomposición a 31 CNSTs
atómicas (SRP-31), con la separación CNST_P03/P04.
