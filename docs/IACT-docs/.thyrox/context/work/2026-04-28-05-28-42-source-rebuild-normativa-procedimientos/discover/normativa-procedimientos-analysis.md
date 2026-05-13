```yml
created_at: 2026-04-28 08:05:00
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 1 DISCOVER — Source Rebuild: normativa/procedimientos

## 1. Propósito del WP-hijo

Reconstruir `source/normativa/procedimientos/` (PROCs y PROCEDs).
Procedimientos operacionales del proyecto IACT que rigen el cómo
se hacen las cosas en cada disciplina (DEV, DEVOPS, OPS, QA, GOB,
DOC).

## 2. Inventario verificado

### 2.1 Backup canónico (`temp-backup/source-2026-04-28/normativa/procedimientos/`)

**78 archivos** distribuidos en patrones distintos:

#### Patrón A — Kebab-case con módulo (cumple STD_007 §4.2): 25 archivos

- ``PROC-001-gobernanza_sdlc.rst`` (sin MOD, falla parcial)
- ``PROC-DEV-001-pipeline_trabajo_iact.rst``
- ``PROC-DEV-002-sdlc_process.rst``
- ``PROC-DEVOPS-001-devops_automation.rst``
- ``PROC-GOB-001-mapeo_procesos_templates.rst``
- ``PROC-GOB-008-reorganizacion-estructura-documental.rst``
- ``PROC-OPS-001-deployment.rst``
- ``PROC-OPS-002-setup-entorno-desarrollo.rst``
- ``PROC-QA-001-actividades_garantia_documental.rst``
- ``PROC-QA-002-estrategia_qa.rst``
- ``PROCED-DEV-001-crear_pull_request.rst``
- ``PROCED-DEV-002-code_review.rst``
- ``PROCED-DEV-003-resolver_conflictos_merge.rst``
- ``PROCED-DEVOPS-001-deploy_staging.rst``
- ``PROCED-GOB-001..009`` (9 archivos)
- ``PROCED-QA-001-ejecutar_tests.rst``

Estado: la mayoría conformes; algunos usan separador mixto
``_`` en la descripción (permitido por STD_007 §4.2 "mixed
permitido").

#### Patrón B — Versión en filename (viola STD_006): 30 archivos

Todos con sufijo ``_X_Y_Z.rst``:

- ``PROC_Actualizacion_Modelo_Documental_1_0_0.rst``
- ``PROC_Aprobacion_Documentos_1_0_0.rst``
- ``PROC_Auditoria_Documental_1_0_0.rst``
- ``PROC_Cambio_Requisitos_1_0_0.rst``
- ``PROC_Congelamiento_Subdominio_1_0_0.rst``
- ``PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst``
- ``PROC_Crear_Plan_Analisis_1_0_0.rst``
- ``PROC_Derivacion_BR_UC_1_0_0.rst``
- ``PROC_Derivacion_BReq_BR_1_0_0.rst``
- ``PROC_Derivacion_FR_CODE_1_0_0.rst``
- ``PROC_Derivacion_FR_TST_1_1_0.rst``
- ``PROC_Derivacion_UC_FR_1_0_0.rst``
- ``PROC_Descongelamiento_Subdominio_1_0_0.rst``
- ``PROC_Generacion_*_1_0_0.rst`` (15 procedimientos de generación
  por tipo de artefacto: ADR, API, BR, BReq, CNST, FD, FR, Index,
  MOD, NFR, POL, RTM, STD, TST, UC, VIEW)
- ``PROC_Identificar_Gaps_Huerfanos_1_0_0.rst``
- ``PROC_Publicacion_Documentacion_1_0_0.rst``
- ``PROC_Revision_Artefactos_1_0_0.rst``
- ``PROC_Revision_TPL_Previo_Generacion_1_0_0.rst``
- ``PROC_Revision_UC_Previo_Derivacion_1_0_0.rst``
- ``PROC_Validacion_Sphinx_1_0_0.rst``
- ``PROC_Verificacion_Cobertura_1_0_0.rst``
- ``PROC_Versionado_Semantico_1_0_0.rst``

#### Patrón C — Snake_case sin prefijo (viola STD_007 §4.4): 9 archivos

- ``guia_completa_desarrollo_features.rst``
- ``procedimiento_analisis_seguridad.rst``
- ``procedimiento_desarrollo_local.rst``
- ``procedimiento_diseno_tecnico.rst``
- ``procedimiento_gestion_cambios.rst``
- ``procedimiento_instalacion_entorno.rst``
- ``procedimiento_qa.rst``
- ``procedimiento_release.rst``
- ``procedimiento_revision_documental.rst``
- ``procedimiento_trazabilidad_requisitos.rst``

#### Patrón D — Filenames con espacios/tildes (viola STD_007 §3.2): 4 archivos

- ``Deployment del Backend IACT- README.rst`` (espacios + tilde
  + README)
- ``Procedimientos - frontend-README.rst`` (espacios + README)
- ``Procesos de Gobernanza-README.rst`` (espacios + README)
- ``procedimientos operacionales-readme.rst`` (espacios)

#### Patrón E — Decorativos / no procedimientos: 2 archivos

- ``GAPS-CRITICOS-SOLUCIONADOS-PROCED-GOB-009.rst`` — documenta
  la resolución de gaps de PROCED-GOB-009; no es un procedimiento
  en sí.
- ``RESUMEN_SDLC_AI_DOCS.rst`` — resumen, no procedimiento.

#### Patrón F — index.rst: 1 archivo (toctree del dominio)

### 2.2 Material complementario (`temp-holding/`)

**Archivos PROC en temp-holding (mayoría .md duplicados):**

- ``temp-holding/FASE 01/docs/infraestructura/procesos/`` —
  6 archivos PROC-INFRA-*.md (procesos de infra). NO están en
  el backup canónico; aportan contenido nuevo. **Pero son MD,
  no aplica directamente per Decision 14 strategy v2.0 (RST
  puro).**
- ``temp-holding/FASE 01/docs/infraestructura/procedimientos/`` —
  6 archivos PROCED-INFRA-*.md (procedimientos detallados de
  infra). Mismo issue: MD no se incorpora.
- ``temp-holding/FASE 01/docs/backend/procesos/`` — PROC-BACK-*.md
- ``temp-holding/FASE 01/docs/backend/procedimientos/`` —
  PROCED-BACK-*.md
- ``temp-holding/FASE 01/docs/gobernanza/procesos/`` — PROC-*.md
  (mayoría duplicados de los que están en temp-backup como .rst)
- ``temp-holding/FASE 01/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/PROC_05_Elaboracion_Completa_Requisitos.rst``
  — único .rst, namespace distinto.

**Decisión sobre temp-holding:** 

- Los .md de gobernanza son duplicados; descartar.
- Los .md de infra/backend/devops aportan contenido nuevo pero
  son específicos de tier técnico — **deberían incorporarse en
  los WPs técnicos** (#8 backend, #10 infrastructure) con
  conversión MD→RST. Para este WP de procedimientos
  metodológicos, **NO se incorporan** (fuera de scope dominio).
- ``PROC_05_Elaboracion_Completa_Requisitos.rst`` (1 archivo
  .rst): inspeccionar contenido. Si aporta valor único, agregar.

## 3. Hallazgos

### F-NP-1: PROC_*_X_Y_Z.rst (30 archivos) — versión en filename

Migración obligatoria: strip ``_X_Y_Z`` y mantener versión solo
en metadata YAML.

### F-NP-2: PROC_*Desc.rst sin patrón STD_007 §4.2

STD_007 §4.2 dice ``PROC-MOD-NNN-desc-kebab.rst``. Estos archivos
usan ``PROC_Desc_PascalCase.rst`` (sin MOD, sin NNN). Opciones:

- **A)** Refactor a pattern §4.2: requiere asignar MOD y NNN.
  Ejemplo: ``PROC_Generacion_UC.rst`` →
  ``PROC-GEN-001-generacion-uc.rst``. Trabajo intensivo (~30
  archivos), rompe refs externas si las hay.
- **B)** Aceptar como variante de §4.4 (guías): renombrar a
  kebab-case. Ejemplo: ``proc-generacion-uc.rst``. Pierde el
  prefijo PROC visible.
- **C)** Mantener pattern actual (PROC_Desc.rst) como variante
  documentada en STD_007. Decisión pragmática para no romper
  refs.

**Resolución del agente (auto-didacta): C condicional** —
mantener ``PROC_Desc.rst`` (sin versión). Documentar en STD_007
como excepción para procedimientos sin módulo asignable. Esto
desbloquea el rebuild rápido sin pérdida de contenido.

### F-NP-3: Patrón C (procedimiento_*.rst) — kebab obligatorio

10 archivos en snake_case que deben ir a kebab per STD_007 §4.4.

### F-NP-4: Patrón D (espacios/tildes) — renombrado obligatorio

4 archivos con espacios/tildes/READMEs. Renombrado obligatorio
+ contenido revisable (algunos son READMEs que pueden absorberse
al index).

### F-NP-5: Patrón E (decorativos) — descartar

2 archivos no son procedimientos. Descartar:

- ``GAPS-CRITICOS-SOLUCIONADOS-PROCED-GOB-009.rst`` — el "GAPS
  resueltos" se documenta en el changelog, no como artefacto
  publicable.
- ``RESUMEN_SDLC_AI_DOCS.rst`` — un resumen de SDLC ya está
  en META_03_Fases_SDLC.

### F-NP-6: PROC-001-gobernanza_sdlc.rst sin módulo

El único PROC con NNN pero sin MOD. Patron incompleto §4.2.
Decisión: agregarle MOD. ``PROC-001`` → ``PROC-GOB-001`` (asumir
gobernanza por descripción "gobernanza_sdlc"). Pero ya existe
``PROC-GOB-001-mapeo_procesos_templates.rst``. Conflicto de NNN.

**Resolución:** renombrar este a ``PROC-GOB-002-gobernanza-sdlc.rst``.
Pero PROC-GOB-008 ya existe. Hueco entre 001 y 008.
``PROC-GOB-002-gobernanza-sdlc.rst`` es libre.

### F-NP-7: temp-holding/MODELO DOCUMENTAL IACT/ESTRUCTURA v2.0.0/PROC_05_Elaboracion_Completa_Requisitos.rst

Inspeccionar contenido para decidir incorporar/descartar.

## 4. Plan de ejecución (Phase 10)

1. Strip versión de los 30 archivos PROC_*_X_Y_Z.rst → PROC_*.rst
   (F-NP-1).
2. Rename Patrón C (10 archivos snake_case → kebab) (F-NP-3).
3. Rename Patrón D (4 archivos con espacios) o convertir a
   kebab + absorber READMEs en index (F-NP-4).
4. Descartar Patrón E (2 archivos decorativos) (F-NP-5).
5. Renombrar PROC-001 a PROC-GOB-002 (F-NP-6).
6. Inspeccionar PROC_05 en temp-holding (F-NP-7), decidir.
7. Reescribir index.rst con nuevo toctree organizado por
   módulo (DEV, DEVOPS, GOB, OPS, QA, DOC, GEN).
8. Build verify 0 warnings.
9. Lanzar 3 deep-reviews paralelos.
10. Fix findings.
11. Build verify 0 warnings final.

## 5. Resultado esperado

| Categoría | Cantidad final estimada |
|-----------|------------------------:|
| Patrón A (kebab con MOD) | 25 |
| PROC_*.rst (sin versión, mantener pattern por F-NP-2 res.C) | 30 |
| Kebab-case (renombrado de Patrón C) | 10 |
| Renombrado/absorbido (Patrón D) | 0-4 |
| index.rst | 1 |
| **Total final** | **~66-70** |

Descartados: 2 (Patrón E).
