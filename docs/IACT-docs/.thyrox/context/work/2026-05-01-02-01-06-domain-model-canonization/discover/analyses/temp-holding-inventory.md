```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 01 — Inventario de ``temp-holding/``

Mapeo del material disponible en
``./temp-holding/`` (raíz del repo, fuera del
corpus publicable ``source/``) que sirve de
insumo para los tres artefactos pendientes de
Stage 1 DISCOVER:

- ``discover/domain-elicitation.md`` (plan de
  elicitación adaptada con deviation explícita)
- ``discover/risk-register.md`` (refinamiento)
- ``discover/exit-conditions.md`` (refinamiento)

## Volumen y método

Verificado por ``find ./temp-holding -maxdepth 3
-type f``: **622 archivos**, **65 MB**, **63
directorios**. Material acumulado entre 2025-10
y 2026-01 según los timestamps de los nombres de
archivo.

Método de análisis: lectura *no exhaustiva*
guiada por nombre de archivo + tamaño + heading
de cada documento. Material de detalle se
consultará bajo demanda cuando un artefacto
final lo requiera.

## Estructura de primer nivel

| Directorio | Naturaleza |
|------------|-----------|
| ``FASE 01/`` | Material consolidado de la primera fase de proyecto: análisis, BR, CNST, casos de uso, planes de regeneración, modelo documental versionado v2.0 → v2.2 |
| ``FASE 02/`` | Segunda fase: ``base_cognitiva/``, originales, plantillas v1.3.0 |
| ``GENERACION_DOCUMENTACION/`` | Plan maestro de generación, FASE 0–13 numeradas, backups completos del 2026-01-11 y 2026-01-13 |
| ``Modules/`` | Código Python: ``call_center_privilege_models``, ``module_system_*`` (modelo RBAC encarnado en código) |
| ``RBAC/`` | 7 versiones del modelo RBAC v4.0 → v5.2.1 + análisis de errores v5.2.0 |
| ``project/`` | 3 archivos plantilla (``risks.md``, ``decisions.md``, ``quality.md``) — **vacíos** salvo encabezado |

## Mapeo a artefactos del WP

### Para ``discover/domain-elicitation.md``

Material que documenta **cómo se hizo la
documentación previa** — qué fuentes existieron,
cómo se elicitaron requisitos en la práctica, qué
versión de qué cosa es vigente.

| Archivo | Por qué informa la elicitación |
|---------|--------------------------------|
| ``FASE 01/Ingeniería de Requerimientos/PARTE 0 - CONTEXTO Y FUNDAMENTOS - 661ca8.md`` | Contexto y método declarado para extraer requisitos |
| ``FASE 01/Ingeniería de Requerimientos/PARTE 1 - IDENTIFICAR REGLAS DE NEGOCIO - 661ca8.md`` | Procedimiento de extracción de BR |
| ``FASE 01/Ingeniería de Requerimientos/PARTE 2 - TRANSFORMAR REGLAS DE NEGOCIO EN CASOS DE USO - 661ca8 - v.0.1.1.md`` | Cómo BR → UC se hizo |
| ``FASE 01/Ingeniería de Requerimientos/PARTE 3 - IDENTIFICAR CASOS DE USO ADICIONALES - 661ca8.md`` | Por qué hay UCs no derivados de BR |
| ``FASE 01/Ingeniería de Requerimientos/PARTE 3 - TÉCNICA 2 - MODELO DE LARMAN - 661ca8.md`` | Técnica formal aplicada (Larman) |
| ``FASE 01/Ingeniería de Requerimientos/PARTE 4 - ESPECIFICAR REQUERIMIENTOS FUNCIONALES - 661ca8.md`` | UC → FR derivados |
| ``FASE 01/Ingeniería de Requerimientos/Identificación y Modelado Avanzado de Casos de Uso - 5b45.md`` | Modelado avanzado de UC |
| ``FASE 01/Ingeniería de Requerimientos/Introducción a las Técnicas de Larman.md`` | Marco teórico Larman |
| ``FASE 01/Casos de Uso/PLAN MAESTRO - Regeneración de Casos de Uso v4.0.md`` | Plan formal de cómo se generaron los UCs |
| ``FASE 01/Casos de Uso/FASE 2..8 - MOD_*.txt`` | Bitácoras por módulo (MOD_Users, MOD_Access, MOD_Pipeline, MOD_Reports, MOD_Alerts, MOD_Audit, MOD_Logs) |
| ``GENERACION_DOCUMENTACION/PLAN_MAESTRO_GENERACION_DOCUMENTACION_IACT_1_0_0.md`` | Plan maestro general de la documentación |
| ``GENERACION_DOCUMENTACION/PLAN_REGENERACION_COMPLETA_DESDE_CERO_1_0_0.md`` | Plan de regeneración (cuando la documentación previa se descartó) |
| ``FASE 01/BR_ Busines Requirements/las 20 BR.txt`` | Catálogo declarado de 20 BR |
| ``FASE 01/CNST RESTRICCIONES/`` | Carpeta con CNST originales |
| ``FASE 01/PROC_Procedimientos/`` | 4 análisis de PROC + ``Catálogo Completo de 38 PROC`` |

> Nota: la presencia de planes "regeneración desde
> cero" (PLAN_REGENERACION_*.md, "Plan de
> Regeneración v4.0") sugiere **al menos una
> iteración de descarte+rehecho** del corpus
> documental. Esto es información histórica
> relevante para la elicitación adaptada — los
> 61 UCs actuales son producto de ≥1 ciclo de
> regeneración, no de elicitación original con
> stakeholders.

### Para ``discover/risk-register.md``

Material que documenta **riesgos / errores /
problemas reales** ya enfrentados en el proyecto.

| Archivo | Riesgos que documenta |
|---------|----------------------|
| ``RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md`` (471 líneas, 14 KB) | Errores detectados en el modelo RBAC durante v5.2.0 — riesgos de modelado mal hecho ya materializados |
| ``RBAC/`` (7 versiones v4.0 → v5.2.1) | El versionado mismo es evidencia: el modelo se rehace 7 veces. Riesgo de inestabilidad del modelo de dominio. |
| ``FASE 01/ANALISIS_COMPLETO_PROYECTO_RST_PURO.md`` (24 KB) | Análisis general que probablemente lista deficiencias del proyecto |
| ``GENERACION_DOCUMENTACION/ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md`` (41 KB) | Análisis profundo RBAC + módulos — riesgos de acoplamiento, inconsistencias |
| ``FASE 01/PROC_Procedimientos/ANALISIS_PROC_COMPLETO_v2.md`` | Análisis de PROC (procedimientos) — riesgos de gobernanza |
| ``FASE 01/PROC_Procedimientos/ANALISIS_PROCEDIMIENTOS_PENDIENTES_v2.md`` | Procedimientos no documentados — gap |
| ``project/risks.md`` | **Plantilla vacía** — confirma que el registro formal de riesgos del proyecto no se materializó |

### Para ``discover/exit-conditions.md``

Material que documenta **criterios de calidad
declarados** que pueden formalizarse como exit
conditions del WP actual.

| Archivo | Criterios que aporta |
|---------|----------------------|
| ``FASE 01/CLEAN CODE NAMING PRINCIPLES.md`` | Principios de naming aplicables al modelo de dominio |
| ``FASE 01/STD_001_Estandares_Documentacion_Sin_Emojis_2_0_0.rst`` | Estándar de documentación |
| ``FASE 01/NOM_001_Nomenclatura_Proyecto_IACT_2_0_0.rst`` | Nomenclatura canónica del proyecto |
| ``FASE 01/CNST_05_Restriccion_Creacion_Iterativa_2_0_0.rst`` | Restricción procesal sobre creación iterativa de artefactos |
| ``FASE 01/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0_SIN_EMOJIS.md`` (24 KB) | Plan formal de actualización de referencias — define qué cuenta como "actualizado" |
| ``FASE 01/MODELO DOCUMENTAL IACT/`` (estructura v2.0.0 → v2.2.0) | Múltiples versiones del modelo documental — la última (v2.2.0) marca el target de calidad |
| ``project/quality.md`` | **Plantilla vacía** — confirma que los criterios formales no se consolidaron |

### Material complementario (no asignado a artefacto)

| Archivo | Por qué no se asigna |
|---------|---------------------|
| ``FASE 01/Call Center Dashboard - Arquitectura ... 271025 - df3c.md`` (79 KB) | Documento de arquitectura — relevante para diagrama de clases (Stage 7) pero no para Stage 1 DISCOVER |
| ``FASE 01/ETL - Documentación Completa - IACT ... 271025 - df3c.md`` (73 KB) | Idem — referencia para clases de pipeline ETL en Stage 7 |
| ``FASE 01/ANÁLISIS CONSOLIDADO COMPLETO DEL PROYECTO IACT v2.0/PARTES/`` | 4 partes de análisis consolidado v2.0 — útil como contexto general |
| ``Modules/*.py`` | Código Python — referencia para responsabilidades de clases en Stage 7 |
| ``GENERACION_DOCUMENTACION/IACT_Backup_*`` y ``TMP_COMPLETO_*`` | Backups y trabajo temporal — material redundante |

## Hallazgos del inventario

| ID | Tipo | Descripción |
|----|------|-------------|
| H-T01 | OBSERVABLE | El proyecto ya pasó por **≥1 ciclo de regeneración completa** (``PLAN_REGENERACION_COMPLETA_DESDE_CERO_*``). Los 61 UCs actuales no son fruto de elicitación inicial con stakeholders sino de regeneración. |
| H-T02 | OBSERVABLE | Existe un análisis declarado de **20 BR** (``BR_ Busines Requirements/las 20 BR.txt``). Verificar contra los BR que viven en ``source/requisitos/business-requirements/`` actual. |
| H-T03 | OBSERVABLE | Existe un catálogo declarado de **38 PROC** (``PROC_Procedimientos/Catálogo Completo de 38 PROC.txt``). Cruzarlos contra ``source/normativa/procedimientos/`` actual. |
| H-T04 | OBSERVABLE | El modelo RBAC tiene **7 iteraciones** (v4.0, v5.0, v5.0_1, v5.1, v5.1.1, v5.2.0, v5.2.1) + un análisis explícito de errores. Es evidencia de inestabilidad histórica del modelo. |
| H-T05 | OBSERVABLE | El modelo documental (``MODELO DOCUMENTAL IACT/``) tiene **9 sub-versiones de v2.0** (v2.0.2 → v2.0.9) + v2.1.x (2 versiones) + v2.2.0. Indica fuerte iteración del meta-modelo. |
| H-T06 | OBSERVABLE | Las técnicas de Larman se citan explícitamente como base metodológica en ``Ingeniería de Requerimientos/Introducción a las Técnicas de Larman.md`` y ``PARTE 3 - TÉCNICA 2 - MODELO DE LARMAN``. |
| H-T07 | OBSERVABLE | ``project/{risks,decisions,quality}.md`` son plantillas vacías. El registro formal de riesgos / decisiones / calidad del proyecto **no existió** o no se consolidó en ese path. |

## Próximo paso

Tres análisis específicos:

1. **Análisis 02** —
   ``discover/analyses/elicitation-history.md``:
   leer ``Ingeniería de Requerimientos/PARTE 0..4``
   y los planes de regeneración. Documentar
   método real usado para producir los 61 UCs.
2. **Análisis 03** —
   ``discover/analyses/historical-risks.md``:
   leer ``ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md``
   y resumir errores ya documentados.
3. **Análisis 04** —
   ``discover/analyses/quality-criteria.md``:
   extraer criterios de calidad de
   ``CLEAN CODE NAMING``, ``STD_001``,
   ``NOM_001`` y modelo documental v2.2.0.

Cada análisis se commitea individualmente. Al
final, los tres se sintetizan en
``domain-elicitation.md`` y se refinan los ya
existentes ``risk-register.md`` y
``exit-conditions.md``.
