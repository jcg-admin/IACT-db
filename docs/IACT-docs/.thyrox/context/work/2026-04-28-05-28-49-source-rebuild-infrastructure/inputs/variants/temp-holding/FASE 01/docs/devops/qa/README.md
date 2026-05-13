---
id: DEVOPS-QA-INDEX
estado: borrador
propietario: equipo-devops
ultima_actualizacion: 2025-11-18
relacionados: ["DOC-QA-INDEX", "DOC-DEVOPS-INDEX"]
---
# Gestión de calidad DevOps

Centraliza lineamientos, hallazgos y evidencias de QA para los flujos CI/CD y automatización del dominio DevOps. Mantiene la trazabilidad de análisis, pruebas y riesgos vinculados a pipelines, contenedores de desarrollo y dependencias compartidas.

## Página padre
- [`../INDEX.md`](../INDEX.md)

## Páginas hijas
- [`INDICE.md`](INDICE.md) – estructura y ubicación de artefactos
- [`QA-ANALISIS-DEVCONTAINER-CODESPACES-SIN-DOCKER-001/`](QA-ANALISIS-DEVCONTAINER-CODESPACES-SIN-DOCKER-001/) – análisis de paridad DevContainer sin Docker en el host
- [`analisis/QA-ANALISIS-PIPELINE-CI-CD-001/`](analisis/QA-ANALISIS-PIPELINE-CI-CD-001/) – verificación integral del pipeline CI/CD
- [`analisis/`](analisis/) – nuevos análisis con prefijo `QA-ANALISIS-*`
- [`registros/`](registros/) – métricas y bitácoras de pipelines
- [`estrategia/`](estrategia/) – criterios y umbrales de QA DevOps

## Información clave
### Rol dentro del flujo de documentación
- Alinea criterios de QA con los pipelines descritos en [`../README.md`](../README.md) y los quality gates en `scripts/ci/`.
- Integra hallazgos de infraestructura CI/CD con la gobernanza general (ver [`../../gobernanza/qa/README.md`](../../gobernanza/qa/README.md)).
- Sirve como hub para evidencias de pruebas y diagnósticos que deban compartirse con DevOps y QA.

### Artefactos obligatorios
- Índice actualizado con rutas a análisis, tareas y evidencias (`INDICE.md`).
- Carpetas de análisis específicas por tema (prefijo `QA-ANALISIS-*`).
- Evidencias asociadas a cada tarea o análisis (subcarpeta `evidencias/` dentro de cada análisis).

## Estado de cumplimiento
| Elemento | ¿Existe? | Observaciones |
| --- | --- | --- |
| Índice del espacio QA | Parcial | `INDICE.md` inicial lista el primer análisis y reserva espacio para nuevos temas. |
| Estrategia de QA DevOps | No | Se requiere documento que traduzca los quality gates a criterios medibles. |
| Registro de ejecuciones y métricas | Parcial | Las evidencias viven dentro de cada análisis; falta un registro transversal. |
| Cobertura mínima ≥ 80 % para automatización | Parcial | Existen pruebas del DevContainer; falta cobertura completa de pipelines. |

## Acciones prioritarias
- [ ] Publicar la estrategia de QA específica para DevOps y pipelines CI/CD.
- [ ] Consolidar un registro transversal de ejecuciones (métricas de cobertura, fallas, tiempos).
- [ ] Añadir nuevos análisis temáticos siguiendo el prefijo `QA-ANALISIS-*` (ej. integraciones de agentes, limpieza de ramas).
- [ ] Mantener enlaces cruzados con Gobernanza y Scripts (`../scripts/`) para reflejar cambios en workflows.
