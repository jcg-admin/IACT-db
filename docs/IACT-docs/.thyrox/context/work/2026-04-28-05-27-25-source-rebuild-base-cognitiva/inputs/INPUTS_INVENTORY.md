```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-27-25-source-rebuild-base-cognitiva
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP base-cognitiva

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **234**
- Variantes: **41**
- Duplicados colapsados: **60**

- Tamano total stage: 6,850,411 bytes (6689.9 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/ACCIONES_INMEDIATAS.md` | `temp-holding/FASE 02/tmp_work/ACCIONES_INMEDIATAS.md` | 05031016 | 4,163 | 0 |
| `canonical/ANALISIS_ACTUALIZACION_CNST_v1_1_0_PARTE1.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_ACTUALIZACION_CNST_v1_1_0_PARTE1.md` | 4b2b5cf2 | 3,469 | 0 |
| `canonical/ANALISIS_BREQ_EN_DOCUMENTO.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_BREQ_EN_DOCUMENTO.md` | ea93c8aa | 7,218 | 0 |
| `canonical/ANALISIS_CALIDAD_v1_2_0.txt` | `temp-holding/FASE 02/tmp_work/ANALISIS_CALIDAD_v1_2_0.txt` | 11ab4616 | 4,923 | 0 |
| `canonical/ANALISIS_COHERENCIA_PLAN_vs_MODELO_v2_2_0.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_COHERENCIA_PLAN_vs_MODELO_v2_2_0.md` | 4a9a8a68 | 18,123 | 1 |
| `canonical/ANALISIS_COHERENCIA_PLAN_vs_MODELO_v2_2_1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/ANALISIS_COHERENCIA_PLAN_vs_MODELO_v2_2_1.md` | 4a9a8a68 | 18,123 | 0 |
| `canonical/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA.md` | d7e0f996 | 15,759 | 0 |
| `canonical/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA__v_0.0.1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA__v_0.0.1.md` | d7e0f996 | 15,759 | 0 |
| `canonical/ANALISIS_COMPLETO_PARTE_0.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_COMPLETO_PARTE_0.md` | 5d5b7d24 | 27,396 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_1.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_1.md` | 00df2c49 | 37,463 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_1_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_1_0_1_0.md` | 00df2c49 | 37,463 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_2.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_2.md` | 55dabfed | 26,645 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_2_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_2_0_1_0.md` | 55dabfed | 26,645 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_3.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_3.md` | d7b3ec5a | 26,832 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_3_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_3_0_1_0.md` | d7b3ec5a | 26,832 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_4.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_4.md` | cd7d3d62 | 24,465 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_4_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_4_0_1_0.md` | cd7d3d62 | 24,465 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_5.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_5.md` | 76fd9080 | 23,691 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_5_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_5_0_1_0.md` | 76fd9080 | 23,691 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_6.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_6.md` | 81a700ab | 32,106 | 1 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_6_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_6_0_1_0.md` | 81a700ab | 32,106 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_COMPLETO_v2_UNIFICADO.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CONSOLIDADO_COMPLETO_v2_UNIFICADO.md` | 5e86127b | 171,202 | 2 |
| `canonical/ANALISIS_CONSOLIDADO_DEFINITIVO_PROYECTO_IACT_v_0_1_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_DEFINITIVO_PROYECTO_IACT_v_0_1_0.md` | 0077699a | 59,870 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_DEFINITIVO_PROYECTO_IACT_v_0_2_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_DEFINITIVO_PROYECTO_IACT_v_0_2_0.md` | 0077699a | 59,870 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_PARTE_0.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_PARTE_0.md` | 7d9b53c4 | 44,404 | 0 |
| `canonical/ANALISIS_CONSOLIDADO_PARTE_1.md` | `temp-holding/FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/ANALISIS_CONSOLIDADO_PARTE_1.md` | d08caaca | 28,950 | 0 |
| `canonical/ANALISIS_CORREGIDO_PARTE2_CON_UC_REALES.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CORREGIDO_PARTE2_CON_UC_REALES.md` | 3065d6e1 | 28,798 | 0 |
| `canonical/ANALISIS_CRITICO_MODELO_vs_PEDAGOGIA.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CRITICO_MODELO_vs_PEDAGOGIA.md` | caa5a894 | 24,287 | 0 |
| `canonical/ANALISIS_CRITICO_PARTE2_vs_IACT.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_CRITICO_PARTE2_vs_IACT.md` | 839a2826 | 31,404 | 0 |
| `canonical/ANALISIS_ESTRUCTURA_ACTUAL_UC.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_ESTRUCTURA_ACTUAL_UC.md` | ed1ca877 | 5,439 | 0 |
| `canonical/ANALISIS_ESTRUCTURA_BASE_COGNITIVA.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_ESTRUCTURA_BASE_COGNITIVA.md` | 93fd5eae | 21,864 | 1 |
| `canonical/ANALISIS_ESTRUCTURA_SPHINX_IACT.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_ESTRUCTURA_SPHINX_IACT.md` | 59b3f219 | 20,961 | 0 |
| `canonical/ANALISIS_FUNDAMENTOS_CONCEPTUALES.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_FUNDAMENTOS_CONCEPTUALES.md` | 535c9243 | 5,610 | 0 |
| `canonical/ANALISIS_INTEGRADO_PARTES_0_1_2_vs_IACT.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_INTEGRADO_PARTES_0_1_2_vs_IACT.md` | 9771bd03 | 49,161 | 0 |
| `canonical/ANALISIS_METADATA.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_METADATA.md` | 7402a864 | 1,519 | 0 |
| `canonical/ANALISIS_METAMODELOS.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_METAMODELOS.md` | a4d99532 | 5,582 | 0 |
| `canonical/ANALISIS_ONTOLOGIA_SBVR.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_ONTOLOGIA_SBVR.md` | 1d9e2aac | 1,709 | 0 |
| `canonical/ANALISIS_PARTE1_COMPLETO_EJEMPLOS.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_PARTE1_COMPLETO_EJEMPLOS.md` | acd3dd2c | 41,142 | 0 |
| `canonical/ANALISIS_PARTE1_EJEMPLOS_PEDAGOGICOS.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_PARTE1_EJEMPLOS_PEDAGOGICOS.md` | a1e00537 | 21,643 | 0 |
| `canonical/ANALISIS_PARTE1_ESTRUCTURA.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_PARTE1_ESTRUCTURA.md` | dd873e82 | 19,425 | 1 |
| `canonical/ANALISIS_PARTE_0.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_PARTE_0.md` | 02c8d203 | 15,888 | 1 |
| `canonical/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` | 44da353e | 41,177 | 0 |
| `canonical/ANALISIS_REAL_ESTRUCTURA_EXISTENTE.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_REAL_ESTRUCTURA_EXISTENTE.md` | e06069e3 | 11,448 | 0 |
| `canonical/ANALISIS_TAXONOMIAS.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_TAXONOMIAS.md` | 2781241f | 6,892 | 0 |
| `canonical/ANALISIS_TEMPLATES_VERSIONES.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_TEMPLATES_VERSIONES.md` | 40fb4b40 | 8,428 | 0 |
| `canonical/ANEXO_A_ARBOL_COMPLETO_PARTE1.md` | `temp-holding/FASE 02/originales/ANEXO_A_ARBOL_COMPLETO_PARTE1.md` | b8d24bf2 | 13,345 | 0 |
| `canonical/ANEXO_A_ARBOL_COMPLETO_PARTE2.md` | `temp-holding/FASE 02/originales/ANEXO_A_ARBOL_COMPLETO_PARTE2.md` | 1f4cc232 | 15,991 | 0 |
| `canonical/ANÁLISIS PARTE 2A - FUNDAMENTOS Y PATRONES (Secciones 1-3).md` | `temp-holding/FASE 01/BASE_COGNITIVA/ANÁLISIS PARTE 2A - FUNDAMENTOS Y PATRONES (Secciones 1-3).md` | cbea5b00 | 21,991 | 0 |
| `canonical/BASE COGNITIVA ACTUALIZADA Y COMPLETA.txt` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/BASE COGNITIVA ACTUALIZADA Y COMPLETA.txt` | f7e1ef39 | 3,873 | 0 |
| `canonical/Buscar estructura de PARTE 2 en transcripción.txt` | `temp-holding/FASE 01/BASE_COGNITIVA/Buscar estructura de PARTE 2 en transcripción.txt` | 75f8210f | 101,248 | 0 |
| `canonical/CHANGELOG.md` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/CHANGELOG.md` | 7af05ecd | 8,224 | 0 |
| `canonical/CHECKPOINT_FASE_1_COMPLETA.md` | `temp-holding/FASE 02/tmp_work/CHECKPOINT_FASE_1_COMPLETA.md` | 97619f34 | 2,911 | 0 |
| `canonical/CHECKPOINT_FASE_2_COMPLETA.md` | `temp-holding/FASE 02/tmp_work/CHECKPOINT_FASE_2_COMPLETA.md` | 8257642b | 1,220 | 0 |
| `canonical/COMPLEMENTO_ANALISIS_NOMENCLATURA_REAL.md` | `temp-holding/FASE 02/tmp_work/COMPLEMENTO_ANALISIS_NOMENCLATURA_REAL.md` | 457b567e | 10,009 | 0 |
| `canonical/CONTENIDO_DEL_BACKUP.md` | `temp-holding/GENERACION_DOCUMENTACION/CONTENIDO_DEL_BACKUP.md` | d6a32211 | 10,247 | 0 |
| `canonical/CONTEO_COMPLETO_ARCHIVOS_48H.md` | `temp-holding/FASE 02/tmp_work/CONTEO_COMPLETO_ARCHIVOS_48H.md` | e124309e | 6,944 | 1 |
| `canonical/CONTRASTE_ANALISIS_VS_ACTUAL.txt` | `temp-holding/FASE 02/tmp_work/CONTRASTE_ANALISIS_VS_ACTUAL.txt` | 515df534 | 20,729 | 0 |
| `canonical/CRUD_P1.rst` | `temp-holding/FASE 02/tmp_work/CRUD_P1.rst` | 22940f15 | 13,572 | 0 |
| `canonical/CRUD_P2.rst` | `temp-holding/FASE 02/tmp_work/CRUD_P2.rst` | a5a4b280 | 21,740 | 0 |
| `canonical/Crear directorios individuales.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 0/Crear directorios individuales.txt` | bc8aeaa9 | 788 | 0 |
| `canonical/Crear estructura base_cognitiva.txt` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/Crear estructura base_cognitiva.txt` | ac7f14ed | 7,953 | 0 |
| `canonical/Crear estructura de directorios para regeneración.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 0/Crear estructura de directorios para regeneración.txt` | 3a85719a | 406 | 0 |
| `canonical/Crear y mostrar estructura completa - MATERIAL PEDAGÓGICO COMPLETO.txt` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/Crear y mostrar estructura completa - MATERIAL PEDAGÓGICO COMPLETO.txt` | 3604b8de | 17,552 | 0 |
| `canonical/DIAGNOSTICO_REGENERACION.md` | `temp-holding/FASE 02/tmp_work/DIAGNOSTICO_REGENERACION.md` | efad5c41 | 5,070 | 0 |
| `canonical/EJEMPLOS_REALES_IACT_COMPLETO.md` | `temp-holding/FASE 02/tmp_work/EJEMPLOS_REALES_IACT_COMPLETO.md` | 339de40f | 37,294 | 0 |
| `canonical/EJEMPLOS_REALES_IACT_COMPLETO_0_0_1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/EJEMPLOS_REALES_IACT_COMPLETO_0_0_1.md` | 63b2e7d1 | 38,426 | 0 |
| `canonical/ESTADISTICAS_ESTRUCTURA.txt` | `temp-holding/FASE 02/tmp_work/ESTADISTICAS_ESTRUCTURA.txt` | 5430c4f8 | 17,038 | 0 |
| `canonical/ESTADO_REAL_PARTES_0_a_4.md` | `temp-holding/FASE 02/tmp_work/ESTADO_REAL_PARTES_0_a_4.md` | a00c2fa9 | 8,065 | 1 |
| `canonical/ESTRUCTURA_DOCUMENTAL_COMPLETA.txt` | `temp-holding/FASE 02/tmp_work/ESTRUCTURA_DOCUMENTAL_COMPLETA.txt` | d90b1057 | 6,109 | 0 |
| `canonical/EXTRACCION_ANALISIS.txt` | `temp-holding/FASE 02/tmp_work/EXTRACCION_ANALISIS.txt` | ed70f9a9 | 1,509 | 0 |
| `canonical/FASE_0B_Renombrado_Archivos_base_cognitiva_v4_0_0.md` | `temp-holding/FASE 02/tmp_work/FASE_0B_Renombrado_Archivos_base_cognitiva_v4_0_0.md` | 2ee6f138 | 11,063 | 0 |
| `canonical/FND_02_Reglas_de_Negocio.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_02_Reglas_de_Negocio.rst` | 4f2c0ce7 | 20,503 | 0 |
| `canonical/GUIA_PASO_A_PASO_IMPLEMENTACION.md` | `temp-holding/FASE 02/tmp_work/GUIA_PASO_A_PASO_IMPLEMENTACION.md` | 77928a18 | 16,355 | 0 |
| `canonical/IACT_Glossary_v1_0_0.rst` | `temp-backup/source-2026-04-28/base_cognitiva/IACT_Glossary_v1_0_0.rst` | e0c795cb | 1,648 | 0 |
| `canonical/INDICE_COMPLETO_PAQUETE.md` | `temp-holding/FASE 02/tmp_work/INDICE_COMPLETO_PAQUETE.md` | 36ad4d09 | 7,237 | 0 |
| `canonical/INDICE_RAPIDO.md` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/INDICE_RAPIDO.md` | 208363f5 | 6,958 | 0 |
| `canonical/INVENTARIO_COMPLETO_DOCUMENTACION_IACT_1_0_0.md` | `temp-holding/FASE 02/tmp_work/INVENTARIO_COMPLETO_DOCUMENTACION_IACT_1_0_0.md` | 895d434f | 9,668 | 1 |
| `canonical/LEEME_PRIMERO.txt` | `temp-holding/FASE 02/tmp_work/LEEME_PRIMERO.txt` | 5f57c721 | 7,040 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md` | `temp-holding/FASE 02/originales/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE1.md` | 936ea78a | 17,178 | 0 |
| `canonical/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md` | `temp-holding/FASE 02/originales/MODELO_DOCUMENTAL_IACT_v2_2_0_PARTE2.md` | 47b90af4 | 13,155 | 0 |
| `canonical/MODELO_RBAC_IACT_v5_1_1.md` | `temp-holding/FASE 02/originales/MODELO_RBAC_IACT_v5_1_1.md` | eecae723 | 57,558 | 0 |
| `canonical/MTM_01_Metamodelo_Requisitos.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_01_Metamodelo_Requisitos.rst` | f645590b | 17,915 | 0 |
| `canonical/NOM_001_Nomenclatura_Proyecto_2_0_0.rst` | `temp-holding/FASE 02/originales/NOM_001_Nomenclatura_Proyecto_2_0_0.rst` | c280a974 | 16,634 | 0 |
| `canonical/NOM_01_Nomenclatura_Proyecto_IACT_1_0_0.rst` | `temp-holding/FASE 02/tmp_work/NOM_01_Nomenclatura_Proyecto_IACT_1_0_0.rst` | 6e6e776b | 15,192 | 0 |
| `canonical/NOTA_IMPORTANTE.txt` | `temp-holding/GENERACION_DOCUMENTACION/NOTA_IMPORTANTE.txt` | bf1ae698 | 426 | 0 |
| `canonical/NOTA_REGENERACION.txt` | `temp-holding/FASE 02/tmp_work/NOTA_REGENERACION.txt` | d1de8772 | 2,255 | 0 |
| `canonical/PARTE 3D COMPLETADA! - PARTE 3 AL 100.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE 3D COMPLETADA! - PARTE 3 AL 100.md` | 1121b8fd | 5,738 | 0 |
| `canonical/PARTE3B_TECNICA_LARMAN_COMPLETA.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE3B_TECNICA_LARMAN_COMPLETA.md` | d90f611a | 120,695 | 0 |
| `canonical/PARTE3C_UI_STAKEHOLDERS_COMPLETA.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE3C_UI_STAKEHOLDERS_COMPLETA.md` | d26b3fe7 | 74,967 | 0 |
| `canonical/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA.md` | 6ef4c8da | 47,945 | 0 |
| `canonical/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA__1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA__1.md` | 6ef4c8da | 47,945 | 0 |
| `canonical/PARTE3_ESTADO_ACTUALIZADO.md` | `temp-holding/FASE 02/tmp_work/PARTE3_ESTADO_ACTUALIZADO.md` | c675ba82 | 5,685 | 0 |
| `canonical/PARTE3_ESTRUCTURA_FALTANTE.md` | `temp-holding/FASE 02/tmp_work/PARTE3_ESTRUCTURA_FALTANTE.md` | 2b9d3690 | 3,736 | 1 |
| `canonical/PARTE4_ESTADO_COMPLETO.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE4_ESTADO_COMPLETO.md` | 0131e02c | 5,826 | 0 |
| `canonical/PARTE4_SECCION1_INTRODUCCION_COMPLETA.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE4_SECCION1_INTRODUCCION_COMPLETA.md` | 77cde37a | 52,801 | 0 |
| `canonical/PARTE4_SECCION2_PLANTILLA_ESTANDAR.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION2_PLANTILLA_ESTANDAR.md` | 497c8aee | 49,154 | 1 |
| `canonical/PARTE4_SECCION3_PROCESO_DERIVACION.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION3_PROCESO_DERIVACION.md` | 6bda7ecc | 35,256 | 1 |
| `canonical/PARTE4_SECCION4_5_CLASIFICACION_CRITERIOS.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION4_5_CLASIFICACION_CRITERIOS.md` | 6871ac89 | 21,225 | 1 |
| `canonical/PARTE4_SECCION6_UC40_FR_COMPLETOS.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION6_UC40_FR_COMPLETOS.md` | 55a49736 | 17,016 | 1 |
| `canonical/PARTE4_SECCION7_8_UC61_UC110.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION7_8_UC61_UC110.md` | cd689001 | 18,744 | 1 |
| `canonical/PARTE4_SECCION9_21_COMPLEMENTOS.md` | `temp-holding/FASE 02/tmp_work/PARTE4_SECCION9_21_COMPLEMENTOS.md` | 4a72b21e | 11,957 | 1 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md` | `temp-holding/FASE 02/tmp_work/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md` | e79ee1db | 94,737 | 1 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_1.md` | `temp-holding/FASE 02/tmp_work/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_1.md` | 3f777ce9 | 29,577 | 0 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_2.md` | `temp-holding/FASE 02/tmp_work/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_2.md` | 9672be5f | 24,256 | 0 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_3.md` | `temp-holding/FASE 02/tmp_work/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_3.md` | ba80f78f | 20,855 | 0 |
| `canonical/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_4.md` | `temp-holding/FASE 02/tmp_work/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0_SECCION_4.md` | f87a4fcb | 20,049 | 0 |
| `canonical/PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md` | e79ee1db | 94,737 | 0 |
| `canonical/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` | 7659d846 | 31,570 | 1 |
| `canonical/PARTE_2A_FUNDAMENTOS_IACT.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE_2A_FUNDAMENTOS_IACT.md` | 464e4a04 | 144,723 | 0 |
| `canonical/PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md` | 31c81611 | 145,027 | 1 |
| `canonical/PARTE_2A_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_2A_temp.md` | 324d5f4f | 144,846 | 0 |
| `canonical/PARTE_2B_CONSTRUCCION_IACT.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE_2B_CONSTRUCCION_IACT.md` | 75403abe | 159,061 | 0 |
| `canonical/PARTE_2B_Construccion_Detallada_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_2B_Construccion_Detallada_IACT_1_0_0.md` | b2d22e93 | 159,246 | 1 |
| `canonical/PARTE_2B_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_2B_temp.md` | 75403abe | 159,061 | 0 |
| `canonical/PARTE_2C_CASOS_ESPECIALES_IACT.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE_2C_CASOS_ESPECIALES_IACT.md` | 850fe253 | 115,820 | 0 |
| `canonical/PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md` | 837897da | 116,101 | 1 |
| `canonical/PARTE_2C_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_2C_temp.md` | ecd84fd5 | 115,939 | 0 |
| `canonical/PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md` | 0ad151f3 | 25,185 | 1 |
| `canonical/PARTE_3A_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_3A_temp.md` | b7fdd88a | 25,013 | 0 |
| `canonical/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_3B_Tecnica_Larman_IACT_1_0_0.md` | 7d91274e | 120,882 | 1 |
| `canonical/PARTE_3B_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_3B_temp.md` | d90f611a | 120,695 | 0 |
| `canonical/PARTE_3C_UI_Stakeholders_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_3C_UI_Stakeholders_IACT_1_0_0.md` | 088138dc | 75,164 | 1 |
| `canonical/PARTE_3C_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_3C_temp.md` | d26b3fe7 | 74,967 | 0 |
| `canonical/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | 1084a799 | 48,256 | 1 |
| `canonical/PARTE_3D_temp.md` | `temp-holding/FASE 02/tmp_work/PARTE_3D_temp.md` | 5614c51e | 48,068 | 0 |
| `canonical/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md` | cc694bf2 | 206,450 | 1 |
| `canonical/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md` | 01f218ef | 28,245 | 1 |
| `canonical/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md` | `temp-holding/FASE 02/base_cognitiva/_fundamentos_conceptuales/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md` | 552a2df4 | 35,530 | 1 |
| `canonical/PLANTILLAS_PARTE3_COMPLETAS.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PLANTILLAS_PARTE3_COMPLETAS.md` | 84d725f9 | 42,733 | 0 |
| `canonical/PLAN_ACCION_EXACTO_IACT.md` | `temp-holding/FASE 02/tmp_work/PLAN_ACCION_EXACTO_IACT.md` | b80f6dd1 | 8,534 | 0 |
| `canonical/PLAN_ACTUALIZACION_ACCESS.md` | `temp-holding/FASE 02/tmp_work/PLAN_ACTUALIZACION_ACCESS.md` | c7568fa1 | 6,708 | 0 |
| `canonical/PLAN_IMPLEMENTACION_SPHINX_IACT.md` | `temp-holding/FASE 02/tmp_work/PLAN_IMPLEMENTACION_SPHINX_IACT.md` | 01c6c4b2 | 21,508 | 0 |
| `canonical/PLAN_MAESTRO_-_Regeneración_de_Casos_de_Uso_v4_0.md` | `temp-holding/FASE 02/originales/PLAN_MAESTRO_-_Regeneración_de_Casos_de_Uso_v4_0.md` | 8078bea3 | 20,610 | 0 |
| `canonical/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0.md` | ea9d19fd | 24,224 | 0 |
| `canonical/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0_SIN_EMOJIS.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0_SIN_EMOJIS.md` | 4be1ad04 | 24,419 | 0 |
| `canonical/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL.md` | d8967b69 | 46,502 | 1 |
| `canonical/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL_1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PLAN_MAESTRO_BASE_COGNITIVA_v3_FINAL_1.md` | d8967b69 | 46,502 | 0 |
| `canonical/PLAN_MAESTRO_GENERACION_DOCUMENTACION_IACT_1_0_0.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_GENERACION_DOCUMENTACION_IACT_1_0_0.md` | 5982c0e4 | 16,989 | 1 |
| `canonical/PLAN_MAESTRO_RBAC_v1_0_0.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_RBAC_v1_0_0.md` | 3fbdd3b6 | 32,926 | 0 |
| `canonical/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA.md` | 25c666a1 | 35,344 | 1 |
| `canonical/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO_v_1.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO_v_1.md` | 0dcd0296 | 36,169 | 0 |
| `canonical/PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md` | `temp-holding/FASE 02/tmp_work/PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md` | 537f5685 | 28,062 | 1 |
| `canonical/PLAN_TEMPLATES_3_12_v1_2_0.md` | `temp-holding/FASE 02/tmp_work/PLAN_TEMPLATES_3_12_v1_2_0.md` | 23e60b05 | 18,451 | 0 |
| `canonical/PROBLEMA_NOMENCLATURA_ACCESS.md` | `temp-holding/FASE 02/tmp_work/PROBLEMA_NOMENCLATURA_ACCESS.md` | 0e1c6425 | 3,245 | 0 |
| `canonical/PROGRESO_ACTUALIZADO.md` | `temp-holding/FASE 02/tmp_work/PROGRESO_ACTUALIZADO.md` | 89b99e88 | 5,005 | 0 |
| `canonical/PROPUESTA_TEMPLATE_01.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_01.txt` | cce654e3 | 3,177 | 0 |
| `canonical/PROPUESTA_TEMPLATE_02.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_02.txt` | 62d94ef0 | 2,867 | 0 |
| `canonical/PROPUESTA_TEMPLATE_03.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_03.txt` | 340d6f8b | 1,054 | 0 |
| `canonical/PROPUESTA_TEMPLATE_04.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_04.txt` | 75036370 | 1,069 | 0 |
| `canonical/PROPUESTA_TEMPLATE_05.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_05.txt` | 282642ae | 1,011 | 0 |
| `canonical/PROPUESTA_TEMPLATE_06.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_06.txt` | f188d4e9 | 1,057 | 0 |
| `canonical/PROPUESTA_TEMPLATE_07.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_07.txt` | 988dc267 | 1,102 | 0 |
| `canonical/PROPUESTA_TEMPLATE_08.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_08.txt` | 96ee6a0b | 1,026 | 0 |
| `canonical/PROPUESTA_TEMPLATE_09.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_09.txt` | 4d75c4cd | 1,049 | 0 |
| `canonical/PROPUESTA_TEMPLATE_10.txt` | `temp-holding/FASE 02/tmp_work/PROPUESTA_TEMPLATE_10.txt` | 763805a6 | 952 | 0 |
| `canonical/PROXIMOS_PASOS.txt` | `temp-holding/FASE 02/tmp_work/PROXIMOS_PASOS.txt` | f13b5de4 | 1,252 | 0 |
| `canonical/README.md` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/README.md` | 0f5dac75 | 7,549 | 0 |
| `canonical/README.txt` | `temp-holding/FASE 02/tmp_work/iact_templates_v1_3_0/iact_templates_v1_3_0/README.txt` | ddda16d1 | 1,081 | 0 |
| `canonical/RECONCILIACION_PARTES_vs_ESTRUCTURA.md` | `temp-holding/FASE 02/tmp_work/RECONCILIACION_PARTES_vs_ESTRUCTURA.md` | 5fd60d2a | 12,808 | 1 |
| `canonical/REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` | `temp-holding/FASE 02/originales/REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` | 8f647774 | 21,863 | 0 |
| `canonical/REFERENCIA_RAPIDA_COMANDOS.md` | `temp-holding/FASE 02/tmp_work/REFERENCIA_RAPIDA_COMANDOS.md` | 14765134 | 5,978 | 0 |
| `canonical/REPORTE_COMPLETO_ARTEFACTOS.txt` | `temp-holding/FASE 02/tmp_work/REPORTE_COMPLETO_ARTEFACTOS.txt` | 2bb43698 | 55,839 | 0 |
| `canonical/RESUMEN_EJECUTIVO.md` | `temp-holding/GENERACION_DOCUMENTACION/ESTRUCTURA CREADA/RESUMEN_EJECUTIVO.md` | afab5b06 | 9,148 | 0 |
| `canonical/RESUMEN_EJECUTIVO_ANALISIS.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_EJECUTIVO_ANALISIS.md` | b9f017e9 | 4,741 | 1 |
| `canonical/RESUMEN_EJECUTIVO_ANALISIS_COMPLETO.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_EJECUTIVO_ANALISIS_COMPLETO.md` | d30cda5f | 11,633 | 0 |
| `canonical/RESUMEN_FINAL_VERIFICACION.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_FINAL_VERIFICACION.md` | e3d7bb73 | 7,510 | 0 |
| `canonical/RESUMEN_GENERACION.txt` | `temp-holding/FASE 02/tmp_work/RESUMEN_GENERACION.txt` | 10b21123 | 1,507 | 0 |
| `canonical/RESUMEN_PAQUETE_COMPLETO.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_PAQUETE_COMPLETO.md` | 03b7177e | 9,743 | 0 |
| `canonical/RESUMEN_PLAN_BASE_COGNITIVA.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_PLAN_BASE_COGNITIVA.md` | 871e55c2 | 4,743 | 1 |
| `canonical/RESUMEN_REGENERACION_v1_2_0_FINAL.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_REGENERACION_v1_2_0_FINAL.md` | 47bcc33e | 1,402 | 0 |
| `canonical/RESUMEN_SITUACION_ACTUAL.md` | `temp-holding/FASE 02/tmp_work/RESUMEN_SITUACION_ACTUAL.md` | 99ae5f24 | 5,169 | 0 |
| `canonical/SBVR_01_Conceptos_Nucleares.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/SBVR_01_Conceptos_Nucleares.rst` | baf4d3de | 16,630 | 0 |
| `canonical/SBVR_02_Fact_Types.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/SBVR_02_Fact_Types.rst` | 0a7ea5a3 | 18,426 | 0 |
| `canonical/SBVR_03_Reglas_Estructurales.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/SBVR_03_Reglas_Estructurales.rst` | 97e17553 | 15,029 | 0 |
| `canonical/SBVR_04_Reglas_Operativas.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/SBVR_04_Reglas_Operativas.rst` | 0e5a65eb | 18,200 | 0 |
| `canonical/SBVR_05_Vocabulario_Controlado.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/SBVR_05_Vocabulario_Controlado.rst` | 94fba027 | 13,212 | 0 |
| `canonical/STD_001_Estandares_Documentacion_1_1_0.rst` | `temp-holding/FASE 02/originales/STD_001_Estandares_Documentacion_1_1_0.rst` | f6418977 | 10,171 | 0 |
| `canonical/STD_01_Estandares_Documentacion_Sin_Emojis_1_0_0.rst` | `temp-holding/FASE 02/tmp_work/STD_01_Estandares_Documentacion_Sin_Emojis_1_0_0.rst` | 1ffd1207 | 10,921 | 0 |
| `canonical/T01_Decision_Tipo_BR.md` | `temp-holding/FASE 01/BASE_COGNITIVA/T01_Decision_Tipo_BR.md` | 87d36b83 | 7,771 | 0 |
| `canonical/T02_Construccion_UC_7_Pasos.md` | `temp-holding/FASE 01/BASE_COGNITIVA/T02_Construccion_UC_7_Pasos.md` | cc1f65f6 | 7,826 | 0 |
| `canonical/T03_Identificacion_Actor_Primario.md` | `temp-holding/FASE 01/BASE_COGNITIVA/T03_Identificacion_Actor_Primario.md` | 4eadfc07 | 6,242 | 0 |
| `canonical/T04_Documentacion_FR_10_Componentes.md` | `temp-holding/FASE 01/BASE_COGNITIVA/T04_Documentacion_FR_10_Componentes.md` | 58e651d9 | 7,522 | 0 |
| `canonical/T09_Checklist_Calidad_UC_26_Puntos.md` | `temp-holding/FASE 01/BASE_COGNITIVA/T09_Checklist_Calidad_UC_26_Puntos.md` | b1e32c1d | 8,786 | 0 |
| `canonical/TABLA_VERSIONADO_COMPLETA.md` | `temp-holding/FASE 02/tmp_work/TABLA_VERSIONADO_COMPLETA.md` | 7144fa72 | 11,459 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_BR_Decision_Tipo_1_2_0.rst` | 3bcad517 | 56,132 | 0 |
| `canonical/TPL_BR_Decision_Tipo_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/iact_templates_v1_3_0/iact_templates_v1_3_0/TPL_BR_Decision_Tipo_1_3_0.rst` | 3bcad517 | 56,132 | 0 |
| `canonical/TPL_BR_v1_2_0_P1.rst` | `temp-holding/FASE 02/tmp_work/TPL_BR_v1_2_0_P1.rst` | 395a3001 | 17,135 | 0 |
| `canonical/TPL_BR_v1_2_0_P2.rst` | `temp-holding/FASE 02/tmp_work/TPL_BR_v1_2_0_P2.rst` | 426dca61 | 20,620 | 0 |
| `canonical/TPL_BR_v1_2_0_P3.rst` | `temp-holding/FASE 02/tmp_work/TPL_BR_v1_2_0_P3.rst` | 99b996e1 | 20,287 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_FR_Documentacion_10_Componentes_1_2_0.rst` | 4a6af0cf | 21,405 | 0 |
| `canonical/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_FR_Documentacion_10_Componentes_1_3_0.rst` | abfa5488 | 34,827 | 1 |
| `canonical/TPL_FR_Query_SQL_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_FR_Query_SQL_1_2_0.rst` | ae6560d1 | 11,545 | 0 |
| `canonical/TPL_FR_Query_SQL_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_FR_Query_SQL_1_3_0.rst` | a790c31d | 23,520 | 1 |
| `canonical/TPL_FR_Validacion_Reglas_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_FR_Validacion_Reglas_1_3_0.rst` | 2446300a | 30,883 | 1 |
| `canonical/TPL_TRZ_Matriz_RTM_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_TRZ_Matriz_RTM_1_3_0.rst` | bd41a9a2 | 17,580 | 1 |
| `canonical/TPL_UC_Actor_Secundario_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Actor_Secundario_1_2_0.rst` | fa0daa45 | 4,985 | 0 |
| `canonical/TPL_UC_Actor_Secundario_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Actor_Secundario_1_3_0.rst` | 4f9f5957 | 21,791 | 1 |
| `canonical/TPL_UC_CRUD_Operaciones_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_CRUD_Operaciones_1_2_0.rst` | 2e57b8b4 | 35,312 | 1 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Construccion_7_Pasos_1_2_0.rst` | b4139fa7 | 17,830 | 0 |
| `canonical/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Construccion_7_Pasos_1_3_0.rst` | 9d3033eb | 32,007 | 1 |
| `canonical/TPL_UC_Larman_Contratos_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Larman_Contratos_1_2_0.rst` | 9f7cfe74 | 28,232 | 1 |
| `canonical/TPL_UC_Stakeholder_Driven_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Stakeholder_Driven_1_2_0.rst` | d8644251 | 5,369 | 0 |
| `canonical/TPL_UC_Stakeholder_Driven_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Stakeholder_Driven_1_3_0.rst` | c7c36c51 | 22,316 | 1 |
| `canonical/TPL_UC_Temporal_Schedulers_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Temporal_Schedulers_1_2_0.rst` | 5c23b63b | 9,442 | 0 |
| `canonical/TPL_UC_Temporal_Schedulers_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_Temporal_Schedulers_1_3_0.rst` | ade365dc | 20,983 | 1 |
| `canonical/TPL_UC_UI_Driven_1_2_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_UI_Driven_1_2_0.rst` | fec4154b | 17,508 | 0 |
| `canonical/TPL_UC_UI_Driven_1_3_0.rst` | `temp-holding/FASE 02/tmp_work/TPL_UC_UI_Driven_1_3_0.rst` | ca208b17 | 25,847 | 1 |
| `canonical/TXM_01_Taxonomia_Requisitos.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/TXM_01_Taxonomia_Requisitos.rst` | 9967613f | 15,454 | 0 |
| `canonical/TXM_02_Taxonomia_Artefactos.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/TXM_02_Taxonomia_Artefactos.rst` | b7471c2a | 13,145 | 0 |
| `canonical/TXM_03_Taxonomia_Reglas_Negocio.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/TXM_03_Taxonomia_Reglas_Negocio.rst` | 50a417d3 | 15,524 | 0 |
| `canonical/VERIFICACION_PLAN.txt` | `temp-holding/FASE 02/tmp_work/VERIFICACION_PLAN.txt` | 064a8b0d | 1,222 | 0 |
| `canonical/analisis_parte2b_construccion_integracion.md` | `temp-holding/FASE 02/tmp_work/analisis_parte2b_construccion_integracion.md` | 67956413 | 32,650 | 1 |
| `canonical/analisis_parte2c_casos_especiales_validacion.md` | `temp-holding/FASE 02/tmp_work/analisis_parte2c_casos_especiales_validacion.md` | 662a0bd7 | 43,729 | 1 |
| `canonical/analisis_parte3_completa_con_larman.md` | `temp-holding/FASE 02/tmp_work/analisis_parte3_completa_con_larman.md` | 2ec36446 | 19,235 | 1 |
| `canonical/analisis_parte3_consolidado_plan_vs_realidad.md` | `temp-holding/FASE 02/tmp_work/analisis_parte3_consolidado_plan_vs_realidad.md` | e83c10db | 30,995 | 1 |
| `canonical/analisis_parte3a_introduccion_crud.md` | `temp-holding/FASE 02/tmp_work/analisis_parte3a_introduccion_crud.md` | 10f71f67 | 24,762 | 1 |
| `canonical/analisis_parte4_completo.md` | `temp-holding/FASE 02/tmp_work/analisis_parte4_completo.md` | 0fc63c74 | 22,470 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 0/estado_generacion.txt` | 2b1a4081 | 2,470 | 0 |
| `canonical/glosario_babok_pmbok_iso.rst` | `temp-backup/source-2026-04-28/base_cognitiva/glosario_babok_pmbok_iso.rst` | aeb5f66c | 15,427 | 0 |
| `canonical/glossary.rst` | `temp-backup/source-2026-04-28/base_cognitiva/glossary.rst` | 44ab922c | 3,608 | 0 |
| `canonical/index_access_v4.rst` | `temp-holding/FASE 02/tmp_work/index_access_v4.rst` | cb0d66ad | 5,961 | 0 |
| `canonical/index_actualizado.rst` | `temp-holding/FASE 02/tmp_work/index_actualizado.rst` | b7a0e19f | 1,721 | 0 |
| `canonical/inventario_completo.txt` | `temp-holding/FASE 02/tmp_work/inventario_completo.txt` | 632765e1 | 1,929 | 0 |
| `canonical/mnt_zip_md5.txt` | `temp-holding/FASE 02/tmp_work/mnt_zip_md5.txt` | 3b23ffcc | 85 | 0 |
| `canonical/mnt_zip_sha256.txt` | `temp-holding/FASE 02/tmp_work/mnt_zip_sha256.txt` | d14291c2 | 117 | 0 |
| `canonical/mnt_zip_sha512.txt` | `temp-holding/FASE 02/tmp_work/mnt_zip_sha512.txt` | da2737a1 | 181 | 0 |
| `canonical/nota_fin_fase_0.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 0/nota_fin_fase_0.txt` | 64611ba6 | 1,695 | 0 |
| `canonical/parte2.txt` | `temp-holding/FASE 02/tmp_work/parte2.txt` | 9db2c00c | 572 | 0 |
| `canonical/referencias_maestro.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 0/referencias_maestro.txt` | 78c8648e | 5,759 | 0 |
| `canonical/resumen_ejecutivo_parte3_completa.md` | `temp-holding/FASE 02/tmp_work/resumen_ejecutivo_parte3_completa.md` | 8f15f56c | 8,020 | 1 |
| `canonical/resumen_ejecutivo_parte4.md` | `temp-holding/FASE 02/tmp_work/resumen_ejecutivo_parte4.md` | 5fe2e074 | 7,551 | 0 |
| `canonical/script_conversion_masiva.sh` | `temp-holding/FASE 02/tmp_work/script_conversion_masiva.sh` | 6a934918 | 9,261 | 0 |
| `canonical/validar_nomenclatura.sh` | `temp-holding/FASE 02/tmp_work/validar_nomenclatura.sh` | 80d00643 | 1,959 | 1 |
| `canonical/validar_referencias.sh` | `temp-holding/FASE 02/tmp_work/validar_referencias.sh` | 4698cb0d | 2,965 | 1 |

## Variantes

| Destino | Origen | Hash | Bytes |
|---------|--------|------|-------|
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_01_Concepto_Requisito.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_01_Concepto_Requisito.rst` | 5d78fac8 | 12,350 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_03_Casos_de_Uso.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_03_Casos_de_Uso.rst` | 91a6005a | 21,954 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_04_Trazabilidad.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_04_Trazabilidad.rst` | 0ea914ea | 16,274 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_05_Jerarquia_4_Niveles.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_05_Jerarquia_4_Niveles.rst` | 012d1f07 | 17,813 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_06_Derivacion_vs_Transformacion.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_06_Derivacion_vs_Transformacion.rst` | a8d6fce5 | 13,471 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_07_Requerimientos_Funcionales.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/FND_07_Requerimientos_Funcionales.rst` | e900e70c | 14,676 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_fundamentos_conceptuales/index.rst` | fed75c46 | 5,017 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_01_Identidad_Proyecto.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_01_Identidad_Proyecto.rst` | b8712475 | 5,838 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_02_Clasificacion_Documental.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_02_Clasificacion_Documental.rst` | 04b6957d | 6,828 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_03_Fases_SDLC.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_03_Fases_SDLC.rst` | 4bb75dfa | 8,247 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_04_Contexto_IACT.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_04_Contexto_IACT.rst` | 995e9aba | 7,992 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_05_Estructura_Documental.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/META_05_Estructura_Documental.rst` | 03888edd | 9,651 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_metadata/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_metadata/index.rst` | 8367f9bd | 1,547 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_ontologia_sbvr/index.rst` | 5c86dffd | 10,633 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/index.rst` | aff86226 | 7,035 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_02_Metamodelo_Trazabilidad.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_02_Metamodelo_Trazabilidad.rst` | d202b597 | 16,286 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst` | 54e00915 | 24,704 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/index.rst` | e56db01e | 159 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/_taxonomias_y_metamodelos/taxonomias/index.rst` | c5d1cf3c | 162 |
| `variants/temp-backup/source-2026-04-28/base_cognitiva/index.rst` | `temp-backup/source-2026-04-28/base_cognitiva/index.rst` | 7ddb5b5f | 1,184 |
| `variants/temp-holding/FASE 01/ANALISIS_COMPLETO_PROYECTO_RST_PURO.md` | `temp-holding/FASE 01/ANALISIS_COMPLETO_PROYECTO_RST_PURO.md` | b12e91d9 | 24,797 |
| `variants/temp-holding/FASE 01/BASE_COGNITIVA/FND_00_Contexto_y_Jerarquia.rst` | `temp-holding/FASE 01/BASE_COGNITIVA/FND_00_Contexto_y_Jerarquia.rst` | d4f3b94b | 28,705 |
| `variants/temp-holding/FASE 01/BASE_COGNITIVA/PARTE3_ESTADO_FINAL_COMPLETO.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PARTE3_ESTADO_FINAL_COMPLETO.md` | ebd9821d | 17,350 |
| `variants/temp-holding/FASE 01/BASE_COGNITIVA/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO.md` | `temp-holding/FASE 01/BASE_COGNITIVA/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO.md` | 0a34930f | 37,943 |
| `variants/temp-holding/FASE 02/originales/FND_01_Concepto_Requisito.rst` | `temp-holding/FASE 02/originales/FND_01_Concepto_Requisito.rst` | c96ba8e5 | 12,502 |
| `variants/temp-holding/FASE 02/originales/FND_03_Casos_de_Uso.rst` | `temp-holding/FASE 02/originales/FND_03_Casos_de_Uso.rst` | baf551d5 | 22,131 |
| `variants/temp-holding/FASE 02/originales/FND_04_Trazabilidad.rst` | `temp-holding/FASE 02/originales/FND_04_Trazabilidad.rst` | e6de134d | 16,548 |
| `variants/temp-holding/FASE 02/originales/FND_05_Jerarquia_4_Niveles.rst` | `temp-holding/FASE 02/originales/FND_05_Jerarquia_4_Niveles.rst` | a3db77bf | 18,030 |
| `variants/temp-holding/FASE 02/originales/FND_06_Derivacion_vs_Transformacion.rst` | `temp-holding/FASE 02/originales/FND_06_Derivacion_vs_Transformacion.rst` | 622875ef | 13,608 |
| `variants/temp-holding/FASE 02/originales/FND_07_Requerimientos_Funcionales.rst` | `temp-holding/FASE 02/originales/FND_07_Requerimientos_Funcionales.rst` | 857096c9 | 14,715 |
| `variants/temp-holding/FASE 02/originales/META_01_Identidad_Proyecto.rst` | `temp-holding/FASE 02/originales/META_01_Identidad_Proyecto.rst` | ebcf5b26 | 6,592 |
| `variants/temp-holding/FASE 02/originales/META_02_Clasificacion_Documental.rst` | `temp-holding/FASE 02/originales/META_02_Clasificacion_Documental.rst` | 30c04725 | 7,559 |
| `variants/temp-holding/FASE 02/originales/META_03_Fases_SDLC.rst` | `temp-holding/FASE 02/originales/META_03_Fases_SDLC.rst` | e896966b | 8,861 |
| `variants/temp-holding/FASE 02/originales/META_04_Contexto_IACT.rst` | `temp-holding/FASE 02/originales/META_04_Contexto_IACT.rst` | f0e15dc9 | 8,775 |
| `variants/temp-holding/FASE 02/originales/META_05_Estructura_Documental.rst` | `temp-holding/FASE 02/originales/META_05_Estructura_Documental.rst` | 1a52d023 | 10,384 |
| `variants/temp-holding/FASE 02/originales/MTM_02_Metamodelo_Trazabilidad.rst` | `temp-holding/FASE 02/originales/MTM_02_Metamodelo_Trazabilidad.rst` | e040f4bb | 16,427 |
| `variants/temp-holding/FASE 02/originales/MTM_03_Metamodelo_RBAC.rst` | `temp-holding/FASE 02/originales/MTM_03_Metamodelo_RBAC.rst` | 6cc0e740 | 24,637 |
| `variants/temp-holding/FASE 02/tmp_work/ANALISIS_COMPLETO_PROYECTO_RST_PURO.md` | `temp-holding/FASE 02/tmp_work/ANALISIS_COMPLETO_PROYECTO_RST_PURO.md` | 80e4c452 | 24,653 |
| `variants/temp-holding/FASE 02/tmp_work/FND_00_Contexto_y_Jerarquia.rst` | `temp-holding/FASE 02/tmp_work/FND_00_Contexto_y_Jerarquia.rst` | b3434572 | 25,686 |
| `variants/temp-holding/FASE 02/tmp_work/PARTE3_ESTADO_FINAL_COMPLETO.md` | `temp-holding/FASE 02/tmp_work/PARTE3_ESTADO_FINAL_COMPLETO.md` | 5aa92719 | 8,649 |
| `variants/temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO.md` | `temp-holding/FASE 02/tmp_work/PLAN_MAESTRO_REESCRITURA_BASE_COGNITIVA_CORREGIDO.md` | f0496c21 | 13,628 |

