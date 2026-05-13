```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-46-source-rebuild-arquitectura-tecnica
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP arquitectura-tecnica

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **117**
- Variantes: **7**
- Duplicados colapsados: **7**

- Tamano total stage: 2,102,357 bytes (2053.1 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ANALISIS_ACTUALIZACION_MODELO_v2_2_0.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/ANALISIS_ACTUALIZACION_MODELO_v2_2_0.md` | 24f75155 | 12,545 | 0 |
| `canonical/ANALISIS_BR_REVISION_INTEGRAL_v1.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.4/ANALISIS_BR_REVISION_INTEGRAL_v1.md` | 52825f9f | 20,956 | 0 |
| `canonical/ANALISIS_COMPLETO_MODELO_OFICIAL.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/ANALISIS_COMPLETO_MODELO_OFICIAL.md` | 1803f3cb | 16,341 | 0 |
| `canonical/ANALISIS_CORREGIDO_ESTRUCTURA_v2.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/ANALISIS_CORREGIDO_ESTRUCTURA_v2.md` | ef031279 | 14,869 | 0 |
| `canonical/ANALISIS_CRITICO_DISCREPANCIA_FND.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/ANALISIS_CRITICO_DISCREPANCIA_FND.md` | 06eacf9c | 10,514 | 0 |
| `canonical/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md` | `temp-holding/FASE 01/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md` | f1715f14 | 14,257 | 1 |
| `canonical/ANALISIS_ERRORES_v2_0_9_vs_v2_0_8.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.9/ANALISIS_ERRORES_v2_0_9_vs_v2_0_8.md` | 669b6701 | 5,065 | 0 |
| `canonical/ANALISIS_FND_vs_MODELO_v2_0_4.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.4/ANALISIS_FND_vs_MODELO_v2_0_4.md` | c20873d3 | 18,565 | 0 |
| `canonical/ANALISIS_FND_vs_MODELO_v2_0_4_borrador.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.4/ANALISIS_FND_vs_MODELO_v2_0_4_borrador.md` | ab882fe8 | 17,802 | 0 |
| `canonical/ANALISIS_NAMING_MODULOS_CLEAN_CODE.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ANALISIS_NAMING_MODULOS_CLEAN_CODE.md` | 3cf26827 | 6,061 | 0 |
| `canonical/ANALISIS_NOMENCLATURA_TPL.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.1.x/MODELO DOCUMENTAL IACT v2.1.1/ANALISIS_NOMENCLATURA_TPL.md` | 1a1ff2ed | 6,746 | 0 |
| `canonical/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT.md` | 6e266606 | 10,426 | 0 |
| `canonical/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ANALISIS_PROFUNDO_DECISIONES_MODULOS_IACT_v2.md` | 65905224 | 20,942 | 0 |
| `canonical/ANALISIS_PROFUNDO_METODOLOGIA_UC.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/ANALISIS_PROFUNDO_METODOLOGIA_UC.md` | 7bddb8ad | 37,020 | 0 |
| `canonical/ANALISIS_PROFUNDO_PROC_05.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/ANALISIS_PROFUNDO_PROC_05.md` | 02099cfe | 26,275 | 0 |
| `canonical/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` | `temp-holding/GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` | 44da353e | 41,177 | 0 |
| `canonical/ANALISIS_PROFUNDO_TAXONOMIAS_METAMODELOS_IACT.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/ANALISIS_PROFUNDO_TAXONOMIAS_METAMODELOS_IACT.md` | edadc9c4 | 14,874 | 0 |
| `canonical/ANALISIS_QUE_SIGUE_SEGUN_METODOLOGIA.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/ANALISIS_QUE_SIGUE_SEGUN_METODOLOGIA.md` | 4c53a250 | 11,784 | 0 |
| `canonical/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1.md` | b8d24bf2 | 13,345 | 0 |
| `canonical/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1__borrador.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE1__borrador.md` | 9e835e85 | 13,031 | 0 |
| `canonical/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE2.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/ANEXO_A_ARBOL_COMPLETO_v2_2_0_PARTE2.md` | 1f4cc232 | 15,991 | 0 |
| `canonical/ARQUITECTURA_DOCUMENTAL_TRADUCCION.md` | `temp-holding/FASE 01/ARQUITECTURA_DOCUMENTAL_TRADUCCION.md` | 8f953a45 | 19,303 | 0 |
| `canonical/ARQ_MOD_001_AUTH.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_001_AUTH.rst` | 9594f2bb | 12,911 | 0 |
| `canonical/ARQ_MOD_002_USER_IDENTITY.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_002_USER_IDENTITY.rst` | d30aca7b | 8,473 | 0 |
| `canonical/ARQ_MOD_003_RBAC_CORE.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_003_RBAC_CORE.rst` | 6d5f009e | 9,535 | 0 |
| `canonical/ARQ_MOD_004_ETL_MONITORING.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_004_ETL_MONITORING.rst` | dd0cc183 | 8,701 | 0 |
| `canonical/ARQ_MOD_005_VIS_REPORTS.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_005_VIS_REPORTS.rst` | 03d30cfe | 9,675 | 0 |
| `canonical/ARQ_MOD_006_ALERTS.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_006_ALERTS.rst` | a96d056e | 9,112 | 0 |
| `canonical/ARQ_MOD_007_AUDIT (1).rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_007_AUDIT (1).rst` | c90183fb | 9,297 | 0 |
| `canonical/ARQ_MOD_007_AUDIT.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_007_AUDIT.rst` | c90183fb | 9,297 | 0 |
| `canonical/ARQ_MOD_008_SYS_LOGS.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ARQ_MOD_008_SYS_LOGS.rst` | 0c41d1d7 | 9,002 | 0 |
| `canonical/BR_001_Fuente_Inmutable.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_001_Fuente_Inmutable.rst` | 944f41af | 7,088 | 0 |
| `canonical/BR_001_Inmutabilidad_Fuente.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BR_001_Inmutabilidad_Fuente.rst` | bd7371a0 | 7,762 | 0 |
| `canonical/BR_002_ETL_Batch_Nocturno.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_002_ETL_Batch_Nocturno.rst` | 56d2e1fe | 9,036 | 0 |
| `canonical/BR_002_ETL_Nocturno.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BR_002_ETL_Nocturno.rst` | fabb8bbb | 8,908 | 0 |
| `canonical/BR_003_RBAC_Flat.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BR_003_RBAC_Flat.rst` | 41a1e8b5 | 11,359 | 0 |
| `canonical/BR_003_RBAC_Flat_v1.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BR_003_RBAC_Flat_v1.rst` | 41a1e8b5 | 11,359 | 0 |
| `canonical/BR_003_Usuario_Inactivo_90d.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_003_Usuario_Inactivo_90d.rst` | 7e6ae4a1 | 8,499 | 0 |
| `canonical/BR_004_Comunicaciones_Internas.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_004_Comunicaciones_Internas.rst` | 27475d86 | 8,856 | 0 |
| `canonical/BR_005_Sesion_Unica.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_005_Sesion_Unica.rst` | 0da82578 | 9,336 | 0 |
| `canonical/BR_006_RBAC_Flat_NIST.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_006_RBAC_Flat_NIST.rst` | 9e3f0f32 | 10,013 | 0 |
| `canonical/BR_007_Separacion_Funciones_SoD.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_007_Separacion_Funciones_SoD.rst` | e4d145bb | 9,635 | 0 |
| `canonical/BR_008_Permisos_Vencimiento.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_008_Permisos_Vencimiento.rst` | ad2bd617 | 8,706 | 0 |
| `canonical/BR_009_Bajas_Logicas.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_009_Bajas_Logicas.rst` | 8bb29a88 | 6,701 | 0 |
| `canonical/BR_010_Auditoria_Inmutable.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_010_Auditoria_Inmutable.rst` | cb0ec611 | 8,406 | 0 |
| `canonical/BR_011_Limites_Exportacion.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_011_Limites_Exportacion.rst` | 35e73358 | 8,262 | 0 |
| `canonical/BR_012_Usuario_Segmento_Unico.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_012_Usuario_Segmento_Unico.rst` | 76672106 | 5,491 | 0 |
| `canonical/BR_013_Username_Unico.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_013_Username_Unico.rst` | e8233483 | 4,647 | 0 |
| `canonical/BR_014_Alerta_Umbral.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_014_Alerta_Umbral.rst` | f6f56e2a | 8,438 | 0 |
| `canonical/BR_015_Bloqueo_Intentos_Fallidos.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_015_Bloqueo_Intentos_Fallidos.rst` | 99138abd | 9,725 | 0 |
| `canonical/BR_016_Tasa_Abandono.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_016_Tasa_Abandono.rst` | 7b75b554 | 5,623 | 0 |
| `canonical/BR_017_Tiempo_Promedio_Espera.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_017_Tiempo_Promedio_Espera.rst` | 07e746e8 | 3,546 | 0 |
| `canonical/BR_018_Indice_Eficiencia.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/BR_018_Indice_Eficiencia.rst` | ee417f0d | 5,928 | 0 |
| `canonical/BReq_001_Visualizar_Metricas.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BReq_001_Visualizar_Metricas.rst` | f7565bb3 | 7,866 | 0 |
| `canonical/BReq_002_Exportar_Datos.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BReq_002_Exportar_Datos.rst` | 5f37bfeb | 9,616 | 0 |
| `canonical/BReq_003_Gestionar_Accesos.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/BReq_003_Gestionar_Accesos.rst` | df6c09cb | 9,386 | 0 |
| `canonical/CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/CAPACIDADES_ATOMICAS_VS_PERMISOS_GRANULARES.md` | 2039551a | 18,870 | 0 |
| `canonical/Call Center Dashboard - Arquitectura Completa y Definitiva - 271025 - df3c.md` | `temp-holding/FASE 01/Call Center Dashboard - Arquitectura Completa y Definitiva - 271025 - df3c.md` | 7ce44e77 | 79,223 | 0 |
| `canonical/Copiar y actualizar referencias PARTE_2B.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/Copiar y actualizar referencias PARTE_2B.txt` | 97bd8434 | 1,318 | 0 |
| `canonical/Crear archivo final con nombre correcto.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/Crear archivo final con nombre correcto.txt` | 86587913 | 922 | 0 |
| `canonical/DESIGN_PATTERNS_GUIDE.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/patrones/DESIGN_PATTERNS_GUIDE.rst` | cc53c051 | 18,467 | 0 |
| `canonical/DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/DISCREPANCIA_RBAC_Y_PROPUESTA_CORRECCION.md` | 63c3d799 | 9,071 | 0 |
| `canonical/Diagramas de Referencia - README.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/Diagramas de Referencia - README.rst` | 18fabddc | 10,599 | 0 |
| `canonical/ESTRUCTURA_COMPLETA_MODELO_DOCUMENTAL_IACT_v2_0_2.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/ESTRUCTURA_COMPLETA_MODELO_DOCUMENTAL_IACT_v2_0_2.md` | 1c846d67 | 35,308 | 0 |
| `canonical/FND_02_Reglas_de_Negocio.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/FND_02_Reglas_de_Negocio.rst` | b300849e | 20,662 | 0 |
| `canonical/GUIDELINES.rst` | `temp-backup/source-2026-04-28/plantuml-guide/GUIDELINES.rst` | 5bcade2e | 13,414 | 0 |
| `canonical/MAPA_RBAC_COMPLETO_v1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/MAPA_RBAC_COMPLETO_v1_0_0.md` | a908e24f | 32,069 | 0 |
| `canonical/METADATA-STANDARD.rst` | `temp-backup/source-2026-04-28/plantuml-guide/METADATA-STANDARD.rst` | 023c4ceb | 5,514 | 0 |
| `canonical/MODELO RBAC COMPLETO - v5.0 - incompleto.txt` | `temp-holding/FASE 01/RBAC/MODELO RBAC COMPLETO - v5.0 - incompleto.txt` | f8a2615a | 72,898 | 1 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_3.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/MODELO_DOCUMENTAL_IACT_v2_0_3.md` | 3e2bd40c | 21,917 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_3_ACTUALIZADO.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/MODELO_DOCUMENTAL_IACT_v2_0_3_ACTUALIZADO.md` | e04f88c4 | 28,738 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_4.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.4/MODELO_DOCUMENTAL_IACT_v2_0_4.md` | 0d252dda | 36,452 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_4_borrador.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.4/MODELO_DOCUMENTAL_IACT_v2_0_4_borrador.md` | 927b208b | 36,450 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_5.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.5/MODELO_DOCUMENTAL_IACT_v2_0_5.md` | 3e626d89 | 42,280 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_6.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.6/MODELO_DOCUMENTAL_IACT_v2_0_6.md` | 2b3703db | 48,630 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_7.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.7/MODELO_DOCUMENTAL_IACT_v2_0_7.md` | bb4cddea | 47,967 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_8.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.8/MODELO_DOCUMENTAL_IACT_v2_0_8.md` | 008eb253 | 35,488 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_0_9.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.9/MODELO_DOCUMENTAL_IACT_v2_0_9.md` | c4220b84 | 24,742 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_1_0.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.1.x/MODELO DOCUMENTAL IACT v2.1.0/MODELO_DOCUMENTAL_IACT_v2_1_0.md` | a3084559 | 44,399 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_1_1.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.1.x/MODELO DOCUMENTAL IACT v2.1.1/MODELO_DOCUMENTAL_IACT_v2_1_1.md` | 61ddce71 | 33,259 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md` | 936ea78a | 17,178 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.2.0/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md` | 47b90af4 | 13,155 | 0 |
| `canonical/MODELO_RBAC_COMPLETO_v5.0_1.md` | `temp-holding/FASE 01/RBAC/MODELO_RBAC_COMPLETO_v5.0_1.md` | 0655847b | 46,836 | 1 |
| `canonical/MODELO_RBAC_IACT_v5.1.1.md` | `temp-holding/FASE 01/RBAC/MODELO_RBAC_IACT_v5.1.1.md` | eecae723 | 57,558 | 1 |
| `canonical/MODELO_RBAC_IACT_v5.1.md` | `temp-holding/FASE 01/RBAC/MODELO_RBAC_IACT_v5.1.md` | 670de8c1 | 57,555 | 1 |
| `canonical/MODELO_RBAC_IACT_v5_2_0.md` | `temp-holding/RBAC/MODELO_RBAC_IACT_v5_2_0.md` | 5338b0cd | 55,122 | 0 |
| `canonical/MODELO_RBAC_IACT_v5_2_1.md` | `temp-holding/FASE 01/RBAC/MODELO_RBAC_IACT_v5_2_1.md` | ebb3d1b0 | 57,734 | 1 |
| `canonical/Modelo RBAC Sin Pretensiones v4.0.txt` | `temp-holding/FASE 01/RBAC/Modelo RBAC Sin Pretensiones v4.0.txt` | 0ba12a44 | 99,188 | 1 |
| `canonical/OBSERVABILITY_LAYERS.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/OBSERVABILITY_LAYERS.rst` | fe867940 | 17,235 | 0 |
| `canonical/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` | 7659d846 | 31,570 | 0 |
| `canonical/PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/PARTE_1_Identificar_Reglas_Negocio_IACT_1_1_0.md` | 7659d846 | 31,570 | 0 |
| `canonical/PLAN_FR_v2_PLANTUML_GRANULAR_v1_0_0.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.7/PLAN_FR_v2_PLANTUML_GRANULAR_v1_0_0.md` | eafad1e3 | 11,949 | 0 |
| `canonical/PLAN_GENERACION_TPL_v1_0_0.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.1.x/MODELO DOCUMENTAL IACT v2.1.1/PLAN_GENERACION_TPL_v1_0_0.md` | bd966ef8 | 9,379 | 0 |
| `canonical/PROC_05_Elaboracion_Completa_Requisitos.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/PROC_05_Elaboracion_Completa_Requisitos.rst` | d58d7a31 | 30,927 | 0 |
| `canonical/README.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/README.rst` | f4636a6c | 6,673 | 0 |
| `canonical/README_diseno_detallado.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/diseño_detallado/README_diseno_detallado.rst` | 35c083e2 | 10,436 | 0 |
| `canonical/RESUMEN_FASE_2.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/RESUMEN_FASE_2.md` | 969cd231 | 3,044 | 0 |
| `canonical/STORAGE_ARCHITECTURE.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/STORAGE_ARCHITECTURE.rst` | 6e597658 | 23,877 | 0 |
| `canonical/TASK-010-logging_estructurado_json.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/TASK-010-logging_estructurado_json.rst` | ff9710c5 | 12,362 | 0 |
| `canonical/TASK-011-data_centralization_layer.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/TASK-011-data_centralization_layer.rst` | 6fbb84dc | 16,343 | 0 |
| `canonical/TASK-029-data_quality_framework.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/TASK-029-data_quality_framework.rst` | 605f2a54 | 6,220 | 0 |
| `canonical/TPL_001_Plantilla_BR.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/TPL_001_Plantilla_BR.rst` | f045dfb4 | 7,598 | 0 |
| `canonical/TPL_002_Plantilla_UC.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/TPL_002_Plantilla_UC.rst` | 5043ef49 | 9,251 | 0 |
| `canonical/TPL_003_Plantilla_ADR.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/TPL_003_Plantilla_ADR.rst` | b29d01d2 | 6,289 | 0 |
| `canonical/TPL_004_Plantilla_CNST.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/TPL_004_Plantilla_CNST.rst` | 13991980 | 7,015 | 0 |
| `canonical/TPL_005_Plantilla_ARQ_MOD.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.2/TPL_005_Plantilla_ARQ_MOD.rst` | da5285f1 | 6,963 | 0 |
| `canonical/Thought process fase 2.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/Thought process fase 2.txt` | 76204150 | 4,227 | 0 |
| `canonical/Validar y copiar PARTE_2B.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/Validar y copiar PARTE_2B.txt` | 5d9245c7 | 875 | 0 |
| `canonical/color-palette.rst` | `temp-backup/source-2026-04-28/plantuml-guide/color-palette.rst` | d152e866 | 7,202 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/estado_generacion.txt` | 2b1a4081 | 2,470 | 0 |
| `canonical/etl-pipeline.rst` | `temp-backup/source-2026-04-28/plantuml-guide/ejemplos/etl-pipeline.rst` | 81626e54 | 6,041 | 0 |
| `canonical/lineamientos_codigo.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/lineamientos_codigo.rst` | 1bb9c29f | 12,297 | 0 |
| `canonical/nota_FASE 2 PARTE_1 - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 2/nota_FASE 2 PARTE_1 - COMPLETADA.txt` | 4343769b | 2,177 | 0 |
| `canonical/sistema-completo.rst` | `temp-backup/source-2026-04-28/plantuml-guide/ejemplos/sistema-completo.rst` | f062827d | 4,293 | 0 |
| `canonical/test-component-diagram.rst` | `temp-backup/source-2026-04-28/plantuml-guide/ejemplos/test-component-diagram.rst` | 915a8076 | 1,574 | 0 |
| `canonical/test-uc-diagram.rst` | `temp-backup/source-2026-04-28/plantuml-guide/ejemplos/test-uc-diagram.rst` | 1316c6d3 | 1,461 | 0 |
| `canonical/ÁRBOL COMPLETO v2.0.6.md` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.6/ÁRBOL COMPLETO v2.0.6.md` | e6030b2d | 17,068 | 0 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/index.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/index.rst` | f45bf4ad | 1,390 |
| `variants/temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/patrones/index.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/arquitectura/patrones/index.rst` | 03358005 | 86 |
| `variants/temp-backup/source-2026-04-28/arquitectura_tecnica/despliegue/index.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/despliegue/index.rst` | b177ca78 | 1,400 |
| `variants/temp-backup/source-2026-04-28/arquitectura_tecnica/diseño_detallado/index.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/diseño_detallado/index.rst` | b6f5def6 | 1,515 |
| `variants/temp-backup/source-2026-04-28/arquitectura_tecnica/index.rst` | `temp-backup/source-2026-04-28/arquitectura_tecnica/index.rst` | 7921441f | 1,352 |
| `variants/temp-backup/source-2026-04-28/plantuml-guide/index.rst` | `temp-backup/source-2026-04-28/plantuml-guide/index.rst` | 52a40a7d | 1,844 |
| `variants/temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/index.rst` | `temp-holding/FASE 01/MODELO DOCUMENTAL IACT/MODELO DOCUMENTAL IACT v2.0.x/MODELO DOCUMENTAL IACT v2.0.3/br/index.rst` | 6c81d7b0 | 5,317 |

