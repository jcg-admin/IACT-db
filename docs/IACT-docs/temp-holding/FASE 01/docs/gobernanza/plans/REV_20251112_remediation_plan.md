---
title: Plan de remediación para hallazgos de la revisión 2025-11-12
date: 2025-11-13
domain: general
status: active
---

# Plan de remediación para hallazgos de la revisión 2025-11-12

> Revisión consolidada: [`docs/analisis/revision_20251112_consolidada.md`](../analisis/revision_20251112_consolidada.md)

## Metodología aplicada
- **Auto-CoT (Chain-of-Thought automatizada)**: descompusimos los hallazgos en clústeres temáticos y, dentro de cada uno, derivamos tareas concretas accionables.
- **Self-Consistency**: validamos cada decisión crítica contrastando la evidencia del repositorio (listados de directorios y contenido real) y verificando que no existan instrucciones contradictorias en otros documentos.
- **Guardrails obligatorios**: mantener TDD (tests antes del código), cobertura mínima esperada ≥80% para los módulos afectados, documentación actualizada y uso de Conventional Commits.

## Clústeres y tareas

### C1. Documentación raíz desalineada
1. **README**
   - Alinear la guía de inicio con el estado real (sin Makefile raíz, con script `verificar_servicios.sh`).
   - Documentar rutas válidas a runbooks vigentes (`docs/operaciones/`).
   - Reforzar política anti `git push --no-verify` con alternativas reales.
2. **Resumen de estructura**
   - Proveer panorama de carpetas reales (docs/, scripts/, infrastructure/, logs_data/, respaldo/).

### C2. Índices y estructura en `docs/`
1. **`docs/index.md`**
   - Reescribir como índice oficial reducido a rutas existentes.
   - Marcar explícitamente directorios activos vs. legado.
2. **`docs/INDEX.md` y `docs/INDICE.md`**
   - Convertirlos en stubs que redirigen al índice oficial.
3. **`docs/README.md`**
   - Actualizar narrativa de estructura para reflejar el estado actual (sin `implementacion/`).

### C3. Documentación de scripts vs realidad
1. **`scripts/README.md`**
   - Enumerar subdirectorios reales y aclarar el estado dual `validation/` vs `validacion/`.
2. **`docs/scripts/*.md` (README, SCRIPTS_MATRIX, metrics-and-reporting)**
   - Reducir a inventario real de scripts existentes y marcar brechas.
3. **`scripts/run_all_tests.sh`**
   - Corregir referencia a `frontend/` → `ui/` y documentar limitaciones actuales.

### C4. Infraestructura / CPython
1. **Renombrar script anómalo**
   - `infrastructure/cpython/scripts/Install prebuilt cpython.sh` → `install_prebuilt_cpython.sh`.
   - Actualizar referencias y tests.
2. **Documentación**
   - Ajustar `docs/infraestructura/README.md` y `CHANGELOG-cpython.md` a nombres reales de scripts/utilidades.
   - Revisar `infrastructure/cpython/README.md` para alinear comandos (`validate_build.sh`, nuevo script de instalación).

### C5. Respaldo y señalización de legado
1. **`respaldo/docs_legacy/README.md`**
   - Explicar el estado mixto actual (convivencia con documentación activa) y cómo identificar material vigente.

### C6. Datos temporales y reportes
1. **`logs_data/SCHEMA.md`**
   - Documentar que actualmente la rotación y escritura son manuales; remover referencias a scripts inexistentes.
2. **`backend_analysis_results.json` + `scripts/analyze_backend.py`**
   - Reubicar resultados en `logs_data/analysis/` y ajustar el script para que escriba allí por defecto.
   - Actualizar documentación que enlace a este artefacto.

## Validaciones y métricas
- Crear tests unitarios que verifiquen:
  - La ausencia/presencia de cadenas clave en README y documentación crítica.
  - Que el script de análisis de backend escriba en la nueva ruta.
  - Que `run_all_tests.sh` referencie `ui/`.
  - Que los stubs de índices mantengan la referencia al índice oficial.
- Ejecutar `pytest` (con configuración existente) asegurando cobertura ≥80% en los módulos Python tocados.

## Entregables
1. Documentación actualizada conforme a la realidad del repositorio.
2. Scripts corregidos y renombrados según corresponda.
3. Tests automatizados que protejan contra regresiones documentales.
4. Registro en commit convencional + PR con resumen ejecutivo de los cambios.

## Riesgos y mitigaciones
- **Riesgo**: referencias en otros documentos a rutas viejas.
  - *Mitigación*: usar `rg` para validar enlaces críticos tras los cambios.
- **Riesgo**: scripts heredados que dependan del JSON en raíz.
  - *Mitigación*: mantener nota de compatibilidad en documentación y permitir sobrescribir la ruta via flag.
- **Riesgo**: pérdida de contexto histórico.
  - *Mitigación*: mover artefactos a `logs_data/analysis/` conservando contenido intacto y documentando la nueva ubicación.

## Próximos pasos futuros (fuera de alcance inmediato)
- Automatizar validación de enlaces Markdown a través de hook CI.
- Diseñar ADR sobre estrategia definitiva de consolidación `docs/` ↔ `respaldo/`.
- Extender el script de verificación de servicios con chequeos adicionales (latencia, usuarios read-only).
