```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP normativa-restricciones

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **35**
- Variantes: **0**
- Duplicados colapsados: **0**

- Tamano total stage: 1,026,716 bytes (1002.7 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ACTUALIZACION_DEL_ARBOL_SECCION_RESTRICCIONES.md` | 7400fac2 | 8,565 | 0 |
| `canonical/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_0.md` | 365ddca6 | 44,593 | 0 |
| `canonical/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_1.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_ACTUALIZACION_CNST_DEFINITIVO_v1_1_1.md` | ca96774c | 44,223 | 0 |
| `canonical/ANALISIS_GAPS_CNST.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_GAPS_CNST.md` | df7b7c55 | 13,180 | 0 |
| `canonical/ANALISIS_GAPS_CNST_borrador.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ANALISIS_GAPS_CNST_borrador.md` | b7835d51 | 13,181 | 0 |
| `canonical/ANÁLISIS REAL DE ACTUALIZACIÓN CNST v1.0.0.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ANÁLISIS REAL DE ACTUALIZACIÓN CNST v1.0.0.md` | 0e402920 | 5,879 | 0 |
| `canonical/ARBOL_COMPLETO_v2_0_6_actualizacion_cnst.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ARBOL_COMPLETO_v2_0_6_actualizacion_cnst.md` | fd338fec | 13,140 | 0 |
| `canonical/ARBOL_COMPLETO_v2_0_7_borrador.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/ARBOL_COMPLETO_v2_0_7_borrador.md` | fc3c6a05 | 13,120 | 0 |
| `canonical/CNST_001_Comunicaciones_Prohibidas.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_001_Comunicaciones_Prohibidas.rst` | b7858ecc | 18,470 | 0 |
| `canonical/CNST_001_No_Email_Sistema_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_001_No_Email_Sistema_1_0_0.rst` | c3de5d95 | 42,922 | 0 |
| `canonical/CNST_002_Gestion_Sesiones_BD.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_002_Gestion_Sesiones_BD.rst` | 77a14d81 | 19,930 | 0 |
| `canonical/CNST_002_Sesiones_BD_Timeout_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_002_Sesiones_BD_Timeout_1_0_0.rst` | e8e02244 | 45,830 | 0 |
| `canonical/CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_003_BD_IVR_Readonly_ETL_1_0_0.rst` | 16a1e212 | 41,108 | 0 |
| `canonical/CNST_003_Base_Datos_Dual_Inmutable.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_003_Base_Datos_Dual_Inmutable.rst` | 8cae2bd5 | 28,331 | 0 |
| `canonical/CNST_004_Actualizacion_Datos_ETL.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_004_Actualizacion_Datos_ETL.rst` | d23c82dc | 28,614 | 0 |
| `canonical/CNST_004_Alertas_Buzon_Interno_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_004_Alertas_Buzon_Interno_1_0_0.rst` | 9366648b | 40,662 | 0 |
| `canonical/CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_005_RBAC_Flat_SoD_Permisos_1_0_0.rst` | 41db3c94 | 72,038 | 0 |
| `canonical/CNST_005_Seguridad_DRF_Checklist.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_005_Seguridad_DRF_Checklist.rst` | e049b562 | 45,623 | 0 |
| `canonical/CNST_006_Antipatrones_Arquitectura.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_006_Antipatrones_Arquitectura.rst` | 3cdee8be | 53,704 | 0 |
| `canonical/CNST_006_Reportes_Limites_Rango_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_006_Reportes_Limites_Rango_1_0_0.rst` | 14167c9e | 32,500 | 0 |
| `canonical/CNST_007_Limites_Exportacion_Throttling_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_007_Limites_Exportacion_Throttling_1_0_0.rst` | 797c2f6d | 32,904 | 0 |
| `canonical/CNST_007_Limites_Performance_SLA.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_007_Limites_Performance_SLA.rst` | 84af33f7 | 29,475 | 0 |
| `canonical/CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst` | `temp-holding/FASE 02/base_cognitiva/normativa/restricciones/CNST_008_Audit_Inmutable_Logs_PII_1_0_0.rst` | 58a6d391 | 32,945 | 0 |
| `canonical/CNST_008_Infraestructura_Deployment.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_008_Infraestructura_Deployment.rst` | c4cdfb01 | 33,191 | 0 |
| `canonical/CNST_009_Logging_Auditoria_Inmutable.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_009_Logging_Auditoria_Inmutable.rst` | 92a3919e | 32,219 | 0 |
| `canonical/CNST_010_Clasificacion_Proteccion_Datos.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_010_Clasificacion_Proteccion_Datos.rst` | 8bdab0fd | 32,207 | 0 |
| `canonical/CNST_012_RBAC_Flat_SoD_Permisos.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/CNST_012_RBAC_Flat_SoD_Permisos.rst` | b04cbc71 | 31,592 | 0 |
| `canonical/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst` | `temp-holding/FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst` | 49bebc23 | 18,998 | 0 |
| `canonical/PROPUESTA_AMPLIACIONES_CNST_005-006.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/PROPUESTA_AMPLIACIONES_CNST_005-006.md` | 52cec7ba | 33,213 | 0 |
| `canonical/PROPUESTA_AMPLIACIONES_CNST_borrador.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/PROPUESTA_AMPLIACIONES_CNST_borrador.md` | 49755ab1 | 33,214 | 0 |
| `canonical/REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/REPORTE_REVISION_CNST_COMPLETO_v1_0_0.md` | de279ef7 | 33,413 | 0 |
| `canonical/RESTRICCIONES COMPLETAS DEL SISTEMA IACT.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/RESTRICCIONES COMPLETAS DEL SISTEMA IACT.md` | f8e09cab | 23,737 | 0 |
| `canonical/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | `temp-holding/FASE 02/originales/RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md` | 2a77efa3 | 24,076 | 0 |
| `canonical/Sin Referencias Externas.md` | `temp-holding/FASE 01/CNST RESTRICCIONES/Sin Referencias Externas.md` | 5a6b1b09 | 3,034 | 0 |
| `canonical/index.rst` | `temp-backup/source-2026-04-28/normativa/restricciones/index.rst` | 49d81507 | 6,885 | 0 |

