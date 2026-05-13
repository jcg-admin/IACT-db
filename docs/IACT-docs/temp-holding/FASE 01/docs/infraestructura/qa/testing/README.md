---
id: QA-TESTING-INFRA
estado: activo
version: 1.0.0
ultima_actualizacion: 2025-11-18
propietario: devops-lead
relacionados: ["docs/infraestructura/qa/tareas_activas.md", "scripts/run_all_tests.sh"]
---

# Testing y validación de infraestructura

Este espacio documenta los comandos y evidencias de validación utilizados para infraestructura. Las suites deben seguir TDD (Red → Green → Refactor) y mantener cobertura mínima de 80%.

## Objetivos
- Registrar comandos de validación y su responsable.
- Mantener evidencia de cobertura y resultados por fecha.
- Sincronizar cada ejecución con Task tool y `qa/tareas_activas.md`.

## Artefactos
- [`comandos_validacion.md`](./comandos_validacion.md): catálogo de comandos y expectativas de evidencia.
- `registros/`: bitácora de ejecuciones y resultados.

## Flujo sugerido
1. Definir casos de prueba antes de modificar scripts o documentación automatizada.
2. Ejecutar los comandos descritos en `comandos_validacion.md` y capturar evidencias en `qa/registros/`.
3. Actualizar `qa/tareas_activas.md` con estado y cobertura alcanzada.
4. Registrar desviaciones y acciones correctivas.
