---
title: Revisión integral de inconsistencias del repositorio (2025-11-12)
date: 2025-11-13
domain: general
status: active
---

# Revisión integral de inconsistencias del repositorio (2025-11-12)

## Contexto y enfoque
- **Scope**: análisis de la raíz del repositorio y de los directorios `docs/`, `scripts/`, `infrastructure/`, `logs_data/` y `respaldo/`, excluyendo `api/` y `ui/`.
- **Metodología**: recorridos sistemáticos con `ls`, `find` y `rg` para confirmar la existencia o ausencia de archivos referenciados; clasificación por temática para facilitar su resolución posterior.
- **Técnicas de prompting aplicadas**: descomposición iterativa por clústeres, verificación cruzada de hallazgos (self-consistency) y reflexión posterior para identificar duplicidades o rutas obsoletas.

## Hallazgos principales

### 1. Documentación raíz desalineada
- `README.md` menciona un `Makefile` con comandos (`make help`, `make docs-serve`, etc.) que no existe, por lo que las instrucciones son inejecutables.
- Se instruye ejecutar `./scripts/verificar_servicios.sh`, pero el archivo no está presente; la guía asociada apunta a `docs/devops/runbooks/verificar_servicios.md` cuando la ruta real es `docs/operaciones/verificar_servicios.md`.
- La guía de frontend del README sigue referenciando un directorio `frontend/` inexistente desde el renombrado a `ui/`.

### 2. Índices y estructura de `docs/`
- Coexisten `docs/index.md`, `docs/INDEX.md` y `docs/INDICE.md`, con contenido redundante y sin estrategia de idioma definida.
- `docs/index.md` enlaza a archivos inexistentes (`docs/proyecto/ONBOARDING.md`, `proyecto/TASK-012-ai-guidelines-onboarding.md`, `../TAREAS_ACTIVAS.md`, `../PLAN_EJECUCION_COMPLETO.md`).
- Tanto `docs/index.md` como `docs/README.md` describen una “estructura v4.0” con carpeta raíz `implementacion/` que nunca se materializó; subsisten directorios que la documentación considera eliminados (`docs/gobernanza`, `docs/desarrollo`, `docs/operaciones`, `docs/scripts`, `docs/features`, `docs/backend`).
- Persisten requisitos dentro de `docs/backend/requisitos` y `docs/frontend/requisitos`, contradiciendo la supuesta migración.
- Directorios duplicados por idioma (`docs/infraestructura/` vs `docs/infraestructura/`) mantienen contenidos divergentes y enlaces rotos hacia rutas que nunca se crearon (`docs/infraestructura/devops/`, `docs/frontend/componentes/`, etc.).

### 3. Documentación de scripts vs realidad
- `scripts/README.md` describe estructuras y comandos (`scripts/requisitos/`, `generar_indices.py`, `contar_requisitos.sh`) que no existen físicamente.
- Continúa refiriendo a documentación inexistente (`../docs/implementacion/README.md`, `../docs/plantillas/readme.md`, `../docs/PROPUESTA_FINAL_REESTRUCTURACION.md`).
- `docs/scripts/README.md`, `docs/scripts/SCRIPTS_MATRIX.md` y `docs/scripts/metrics-and-reporting.md` listan scripts supuestamente operativos (`scripts/sdlc_agent.py`, `scripts/ci/backend_test.sh`, `scripts/dora_metrics.py`, `scripts/ai/agents/...`, `scripts/testing/unit/`, `scripts/validation/compliance/check_no_emojis.py`) que no están en el repositorio.
- Duplicación de directorios (`scripts/validation/` documentado en inglés y `scripts/validacion/` con scripts reales) sin un flujo oficial declarado.
- `scripts/run_all_tests.sh` invoca scripts inexistentes y aún apunta a `frontend/` en lugar de `ui/`.
- `scripts/validar_estructura_docs.sh` valida supuestos post-migración que hoy no se cumplen, produciendo falsos positivos masivos.

### 4. Infraestructura y CPython
- `docs/infraestructura/README.md` enumera subcarpetas (`arquitectura`, `checklists`, `planificacion_y_releases`, `qa`, etc.) que están vacías o con placeholders.
- `infrastructure/cpython/README.md` instruye ejecutar `./infrastructure/cpython/scripts/validate-cpython.sh`, pero el script real se llama `validate_build.sh`.
- Existe un archivo con nombre anómalo `'Install prebuilt cpython.sh'` en `infrastructure/cpython/scripts/`, no documentado.
- `docs/infraestructura/CHANGELOG-cpython.md` describe utilidades (`utils/logging.sh`, `utils/common.sh`, `config/versions.conf`) y pruebas Ruby que no existen.

### 5. Carpeta `respaldo/`
- `respaldo/docs_legacy/README.md` afirma que todo fue migrado a `implementacion/*`, pero la estructura nunca se completó; la documentación activa convive con la archivada sin señalización clara.
- Las guías en `respaldo/docs_legacy` (gobernanza, devops, QA, etc.) carecen de etiquetas de obsolescencia visibles.

### 6. Datos temporales y reportes
- `logs_data/SCHEMA.md` depende de scripts (`scripts/dora_metrics.py`) que no existen, dejando los JSON sin automatización ni rotación.
- `backend_analysis_results.json` sigue apuntando a rutas antiguas en `api/callcentersite/...`, generando ruido en la raíz.

### 7. Riesgos operativos
- El uso extendido de `git push --no-verify` evita que los hooks detecten inconsistencias; la cantidad de rutas rotas sugiere que los checks no se ejecutan.
- La coexistencia de documentación contradictoria obliga a improvisar procesos, aumentando el riesgo en despliegues y soporte.

## Recomendaciones prioritarias
1. Congelar la documentación oficial (`docs/index.md`, `docs/README.md`) hasta eliminar duplicados (`INDEX.md` vs `index.md`) y actualizar enlaces con rutas reales.
2. Auditar `scripts/` para documentar únicamente lo existente; mover la visión futura a un backlog o ADRs.
3. Definir una migración controlada entre `docs/` y `respaldo/docs_legacy`, con tabla de equivalencias y eliminación de duplicados.
4. Alinear las guías de infraestructura/CPython corrigiendo nombres de scripts y eliminando características no implementadas.
5. Restablecer hooks de calidad y prohibir `git push --no-verify` hasta que las rutas críticas estén verificadas.
