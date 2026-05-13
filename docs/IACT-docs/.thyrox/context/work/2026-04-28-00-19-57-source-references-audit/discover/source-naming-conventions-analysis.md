```yml
created_at: 2026-04-28 00:50:00
project: IACT-docs
work_package: 2026-04-28-00-19-57-source-references-audit
phase: Phase 1 — DISCOVER (sub-análisis)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Sub-Análisis: Convenciones de Naming en source/

## Contexto

Adicional al análisis de referencias, el ejecutor solicitó identificar
**todos los formatos de naming** que conviven actualmente en archivos
y directorios bajo ``source/``. Ejemplos citados:

- ``README_diseno_detallado.rst`` (UPPERCASE + snake_case)
- ``GUIA_ESTILO.rst`` (UPPER_SNAKE)
- ``Architecture Decision Records (ADRs) - Indice Maestro.rst`` (Title Case + spaces + parens + hyphens)

## Inventario por convención

Auditados **377 archivos `.rst`** distribuidos en **34 patrones distintos**.

### Por patrón (frecuencia descendente)

| # | Patrón | Cant | Ejemplo |
|---|--------|------|---------|
| 1 | ``UC_<MOD>_<NN>_PascalCase`` (underscore-only) | 49 | ``UC_ACC_01_Asignar_Funciones.rst`` |
| 2 | ``mixed-separators`` (hyphen + underscore en mismo nombre) | 46 | ``PROC-001-gobernanza_sdlc.rst``, ``FR-010.01_Listar_funciones.rst`` |
| 3 | ``index.rst`` (lowercase, no separador) | 45 | ``arquitectura_tecnica/arquitectura/index.rst`` |
| 4 | ``PROC_PascalCase_X_Y_Z`` (versión sufijo) | 37 | ``PROC_Actualizacion_Modelo_Documental_1_0_0.rst`` |
| 5 | ``ADR-<MOD>-<NNN>-kebab`` (PascalKebab + hyphen) | 23 | ``ADR-BACK-001-grupos-funcionales-sin-jerarquia.rst`` |
| 6 | ``lower_snake`` simple | 20 | ``lineamientos_codigo.rst``, ``glosario_babok_pmbok_iso.rst`` |
| 7 | ``BR_NNN_PascalCase`` | 19 | ``BR_001_Fuente_Operacional_Inmutable.rst`` |
| 8 | ``TPL_<KEY>_<DESC>_X_Y_Z`` | 17 | ``TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst`` |
| 9 | underscore-only (sin patrón claro) | 16 | ``IACT_Glossary_v1_0_0.rst``, ``ACCESS_diagrama_casos_uso.rst`` |
| 10 | ``CNST_NNN_PascalCase`` | 11 | ``CNST_001_Comunicaciones_Prohibidas.rst`` |
| 11 | **``contains-spaces`` + hyphen** | **9** | ``Diagramas de Referencia - README.rst`` |
| 12 | ``GOB_NN_PascalCase`` | 9 | ``GOB_01_Modelo_Gobernanza_IACT.rst`` |
| 13 | ``FND_NN_PascalCase`` | 7 | ``FND_01_Concepto_Requisito.rst`` |
| 14 | ``PROCED-<MOD>-<NNN>-mixed`` | 7 | ``PROCED-DEV-001-crear_pull_request.rst`` |
| 15 | ``PROCED-<MOD>-<NNN>-kebab`` | 7 | ``PROCED-GOB-003-documentar-regla-negocio.rst`` |
| 16 | ``PROC-<MOD>-<NNN>-mixed`` | 6 | ``PROC-DEV-001-pipeline_trabajo_iact.rst`` |
| 17 | ``kebab-case`` simple | 6 | ``git-workflow.rst``, ``color-palette.rst`` |
| 18 | ``BReq_NNN_PascalCase`` | 5 | ``BReq_001_Visibilidad_Metricas.rst`` |
| 19 | ``META_NN_PascalCase`` | 5 | ``META_01_Identidad_Proyecto.rst`` |
| 20 | ``SBVR_NN_PascalCase`` | 5 | ``SBVR_01_Conceptos_Nucleares.rst`` |
| 21 | ``lowercase`` (single word) | 4 | ``glossary.rst``, ``actores.rst`` |
| 22 | ``UPPER_SNAKE`` | 4 | ``OBSERVABILITY_LAYERS.rst`` |
| 23 | ``MTM_NN_PascalCase`` | 3 | ``MTM_01_Metamodelo_Requisitos.rst`` |
| 24 | ``TXM_NN_PascalCase`` | 3 | ``TXM_01_Taxonomia_Requisitos.rst`` |
| 25 | ``TASK-NNN_snake`` (mixed) | 3 | ``TASK-010-logging_estructurado_json.rst`` |
| 26 | ``RNF-PROC-NNN_UPPER_SNAKE`` | 2 | ``RNF-PROC-001_PROCESO_SDLC.rst`` |
| 27 | ``README`` (UPPERCASE) | 2 | ``arquitectura_tecnica/arquitectura/README.rst`` |
| 28 | ``README_lowercase`` | 1 | ``README_diseno_detallado.rst`` |
| 29 | ``GUIA_UPPER`` | 1 | ``GUIA_ESTILO.rst`` |
| 30 | ``STD_NNN_PascalCase`` | 1 | ``STD_006_Versionado_Semantico.rst`` |
| 31 | ``TPL_NNN_PascalCase`` | 1 | ``TPL_002_Plantilla_UC_v2.rst`` |
| 32 | **``README-(ADR) - Backend``** parens + spaces | **1** | mismo |
| 33 | **``Architecture Decision Records (ADRs) - Indice Maestro``** | **1** | mismo |
| 34 | ``UPPER`` simple | 1 | ``GUIDELINES.rst`` |

## Casos críticos identificados

### 1. Archivos con espacios en el nombre (9 archivos)

Problemáticos para shell, URLs, refs, autocompletado:

```
arquitectura_tecnica/arquitectura/Diagramas de Referencia - README.rst
gestion/pm/Planificación y releases del frontend-README.rst
gestion/pm/checklists/Checklists del backend- README.rst
normativa/gobernanza/Architecture Decision Records (ADRs) - Indice Maestro.rst
normativa/gobernanza/Ejemplos - GOBERNANZA.rst
normativa/gobernanza/Gobernanza del Frontend-README.rst
normativa/gobernanza/README-(ADR) - Backend.rst
normativa/procedimientos/Deployment del Backend IACT- README.rst
normativa/procedimientos/Procedimientos - frontend-README.rst
normativa/procedimientos/Procesos de Gobernanza-README.rst
normativa/procedimientos/procedimientos operacionales-readme.rst
```

### 2. Archivos con paréntesis (2 archivos)

```
normativa/gobernanza/README-(ADR) - Backend.rst
normativa/gobernanza/Architecture Decision Records (ADRs) - Indice Maestro.rst
```

### 3. Archivos con tildes/ñ en path (3 archivos)

```
arquitectura_tecnica/diseño_detallado/index.rst         (ñ en directorio)
arquitectura_tecnica/diseño_detallado/README_diseno_detallado.rst  (ñ en dir)
gestion/pm/Planificación y releases del frontend-README.rst  (acento)
```

### 4. Mismo prefijo, formato distinto

- ``PROCED-`` aparece en 14 archivos: 7 con mixed-separators (``PROCED-DEV-001-crear_pull_request.rst``) + 7 con kebab puro (``PROCED-GOB-003-documentar-regla-negocio.rst``).
- ``PROC-`` aparece como ``PROC_001_descrito.rst`` (con underscore) Y ``PROC-DEV-001-mixed.rst`` (con hyphen). Son convenciones distintas para el mismo concepto.
- ``README`` aparece como ``README.rst`` (mayúscula), ``README_diseno_detallado.rst`` (con sufijo) y dentro de archivos con espacios (``Architecture Decision Records (ADRs) - Indice Maestro.rst`` actuando como README de directorio).

### 5. Convenciones por dominio

Algunos dominios SÍ tienen convención interna consistente:

| Dominio | Convención | Cumplimiento |
|---------|------------|--------------|
| ``casos_uso/<mod>/UC_<MOD>_<NN>_<Desc>.rst`` | UC + UPPERCASE módulo + 2 dígitos + PascalCase | ✅ 49/49 |
| ``reglas_negocio/BR_NNN_<Desc>.rst`` | BR + 3 dígitos + PascalCase | ✅ 19/19 |
| ``restricciones/CNST_NNN_<Desc>.rst`` | CNST + 3 dígitos + PascalCase | ✅ 11/11 |
| ``_metadata/META_NN_<Desc>.rst`` | META + 2 dígitos + PascalCase | ✅ 5/5 |
| ``_fundamentos_conceptuales/FND_NN_<Desc>.rst`` | FND + 2 dígitos + PascalCase | ✅ 7/7 |
| ``_ontologia_sbvr/SBVR_NN_<Desc>.rst`` | SBVR + 2 dígitos + PascalCase | ✅ 5/5 |
| ``_taxonomias_y_metamodelos/{tax,meta}/`` | TXM/MTM + 2 dígitos + PascalCase | ✅ 6/6 |
| ``objetivos/BReq_NNN_<Desc>.rst`` | BReq + 3 dígitos + PascalCase | ✅ 5/5 |

### 6. Convenciones inconsistentes (mismo dominio)

| Dominio | Problema |
|---------|----------|
| ``normativa/procedimientos/`` | Conviven ``PROC_``, ``PROC-``, ``PROCED-`` con sub-formatos kebab vs mixed |
| ``normativa/gobernanza/`` | Conviven ``ADR-`` (kebab), ``GOB_NN_`` (snake numerado), README con espacios y paréntesis |
| ``arquitectura_tecnica/`` | Conviven ``OBSERVABILITY_LAYERS.rst`` (UPPER_SNAKE), ``Diagramas de Referencia - README.rst`` (espacios), ``TASK-010-logging_estructurado_json.rst`` (mixed) |
| ``normativa/estandares/`` | ``GUIA_ESTILO.rst`` (UPPER_SNAKE) vs ``STD_006_Versionado_Semantico.rst`` (numerado) vs ``estandares_codigo.rst`` (lower_snake) vs ``shell_scripting_guide.rst`` (lower_snake) |
| ``gestion/`` | ``git-workflow.rst`` (kebab) vs ``plantilla_adr.rst`` (lower_snake) vs ``Planificación y releases del frontend-README.rst`` (Title con tildes y espacios) |

## Inventario de directorios

54 directorios bajo ``source/``. Convenciones detectadas:

### Por convención

| Patrón | Cant | Ejemplo |
|--------|------|---------|
| ``snake_case`` | 28 | ``arquitectura_tecnica``, ``casos_uso``, ``reglas_negocio`` |
| ``_snake_case`` (con prefijo ``_`` para "interno") | 5 | ``_metadata``, ``_fundamentos_conceptuales``, ``_ontologia_sbvr`` |
| ``kebab-case`` | 1 | ``plantuml-guide`` |
| ``lowercase`` simple | 13 | ``access``, ``alerts``, ``audit``, ``auth``, ``logs`` |
| ``UC_NNN_PascalCase`` | 9 | ``UC_001_Iniciar_Sesion``, ``UC_006_Crear_Usuario`` |
| ``UPPERCASE`` | 1 | ``rtm`` (en realidad lowercase) |
| **Con tildes/ñ** | 1 | ``diseño_detallado`` |

### Caso crítico de directorio

```
source/arquitectura_tecnica/diseño_detallado/
```

La ``ñ`` en el nombre del directorio:

- Crea problemas en URLs HTML rendered (``%C3%B1`` en path)
- Posibles incompatibilidades en filesystems no-UTF8 (Windows con encoding default)
- Inconsistencia con otros dirs (``arquitectura_tecnica`` sin tildes)

## Hallazgos clave (sub-análisis naming)

| ID | Hallazgo | Severidad |
|----|----------|-----------|
| **F-NMG-01** | 34 patrones distintos de naming en 377 archivos → caos para nuevo autor | Alta |
| **F-NMG-02** | 9 archivos con espacios en nombre → frágiles en shell, URLs, autocompletado | Alta |
| **F-NMG-03** | 2 archivos con paréntesis ``(ADR)``, ``(ADRs)`` → invalido en rutas web sin escapar | Media |
| **F-NMG-04** | 1 directorio con ``ñ`` (``diseño_detallado``) → encoding issues cross-platform | Media |
| **F-NMG-05** | Mezcla de separadores: hyphen + underscore en mismo nombre (46 archivos) | Media |
| **F-NMG-06** | Convención **consistente** en dominios bien definidos (UC, BR, CNST, BReq, META, FND, SBVR, TXM, MTM) — patrón a generalizar | INFO ✅ |
| **F-NMG-07** | Convención **inconsistente** en dominios "amplios" (procedimientos, gobernanza, arquitectura técnica, estándares, gestión) | Alta |
| **F-NMG-08** | Algunos archivos tienen versión en filename (``_1_0_0.rst``, ``_v1_0_0.rst``) — anti-patrón (la versión va en metadata, no en filename) | Media |
| **F-NMG-09** | Archivos ``index.rst`` y ``README.rst`` son ambos usados como punto de entrada de directorio (Sphinx prefiere ``index.rst``) | Media |
| **F-NMG-10** | Convención de prefijo ``_`` para directorios "internos" (``_metadata``, ``_fundamentos_conceptuales``) los excluye del toctree público — comportamiento intencional pero inconsistente | INFO |

## Patrones recomendados (input para Phase 5 STRATEGY del WP de cleanup)

Basado en lo que YA es consistente y funciona, propuesta de convenciones:

### Convención propuesta de archivos `.rst`

```
<PREFIX>_<NN>_<descripcion>.rst        ← para artefactos numerados (UC, BR, CNST, ...)
<PREFIX>-<MOD>-<NNN>-<descripcion>.rst ← para procedimientos con módulo (ADR, PROCED)
<descripcion-en-kebab-case>.rst        ← para guías generales (git-workflow, color-palette)
index.rst                              ← punto de entrada de directorio (NO README)
```

### Reglas

1. **Nunca espacios** en nombres de archivo o directorio.
2. **Nunca paréntesis** en nombres.
3. **Nunca tildes ni ñ** en nombres de archivo o directorio (sí en contenido).
4. **No mezclar** hyphen y underscore en el mismo nombre — elegir uno por dominio.
5. **No incluir versión** en filename (``_1_0_0.rst`` es deuda); la versión va en metadata YAML.
6. **Separadores recomendados:**
   - ``-`` (hyphen) para palabras descriptivas en dominios sin numeración (``git-workflow``).
   - ``_`` (underscore) para separar partes estructurales (``UC_ACC_01_Asignar_Funciones``).
7. **PascalCase** para parte descriptiva en filenames numerados (después del último ``_``).
8. **Index.rst SIEMPRE** como punto de entrada de directorio. README.rst → renombrar a index.rst (Sphinx default).

### Filenames a renombrar (estimación inicial)

- 9 archivos con espacios → renombrar removiendo espacios (kebab o snake).
- 2 archivos con paréntesis → eliminar paréntesis.
- 1 directorio ``diseño_detallado`` → ``diseno_detallado`` (sin tilde).
- 11 archivos ``README*.rst`` → ``index.rst`` o renombrar conceptualmente.
- 17 archivos ``TPL_*_X_Y_Z.rst`` → eliminar versión del filename.
- ~46 archivos con mixed-separators → estandarizar.

**Total estimado de renombres:** ~80-100 archivos.

**Impacto:** cada renombre requiere actualizar todas las refs ``:doc:``, ``:ref:`` y links que apunten al archivo, además del toctree.

## Riesgo del cleanup (anticipado)

Cualquier renombre masivo:

1. **Rompe URLs HTML publicadas** (los lectores tienen bookmarks).
2. **Rompe refs de Git history** (PRs apuntando al archivo viejo).
3. **Requiere actualización en cascada** de toctrees, ``:doc:`` refs, y links.
4. **Si se hace en bloques chicos** (5-10 archivos por commit), es trazable.

## Plan de acción propuesto (input para WP cleanup futuro)

### Fase 1 — Quick wins (riesgo bajo)

- Renombrar los 9 archivos con espacios.
- Renombrar los 2 archivos con paréntesis.
- Renombrar 1 directorio con ñ.
- Eliminar versiones de filenames (TPL, IACT_Glossary, etc.).
- Actualizar refs en cascada.

**Esfuerzo estimado:** 3-5 horas.

### Fase 2 — Estandarizar dominios inconsistentes

Caso por caso:

- ``normativa/procedimientos/`` — decidir: ¿``PROC_NN_*`` o ``PROC-MOD-NNN-*``? Migrar al elegido.
- ``normativa/gobernanza/`` — separar ADRs de docs generales; consolidar README → index.
- ``arquitectura_tecnica/`` — decidir convención para TASK-NNN, OBSERVABILITY_LAYERS, etc.

**Esfuerzo estimado:** 4-8 horas.

### Fase 3 — Documentar convención

Crear ``source/normativa/estandares/STD_NNN_Convencion_Naming.rst`` con las
reglas. Agregar al CI un script que valide los nombres nuevos.

## Próximo paso

Este WP **termina aquí en Phase 1 DISCOVER** (audit-only). Las dos
sub-secciones (referencias + naming) producen un inventario completo
documentado.

**El cleanup ejecutivo** (renombres, fixes de refs) corresponde a un
**WP separado** posterior, con Phase 5 STRATEGY que decida convención
final por dominio.

## Decisiones pendientes (input para futuro WP cleanup)

1. ¿**Documentar convención canónica** en ``STD_NNN_Convencion_Naming.rst``
   antes de renombrar?
2. ¿**Renombrar todo en un WP** o **dividir por dominio** (uno por
   procedimientos, otro por gobernanza, etc.)?
3. ¿**Validar naming en CI** con un script post-renombre?
4. ¿**¿Aplicar a directorios también?** (caso ``diseño_detallado`` con
   ñ).
