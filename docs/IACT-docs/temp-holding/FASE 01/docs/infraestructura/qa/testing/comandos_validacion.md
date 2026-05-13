---
id: QA-VALIDACION-COMANDOS-INFRA
estado: activo
version: 1.0.0
ultima_actualizacion: 2025-11-18
propietario: devops-lead
relacionados: ["scripts/run_all_tests.sh", "scripts/validate_critical_restrictions.sh", "scripts/validar_estructura_docs.sh"]
---

# Comandos de validación

Lista consolidada de comandos de validación para infraestructura. Cada ejecución debe registrar fecha, responsable y evidencia en `qa/registros/`.

| Comando | Propósito | Responsable | Evidencia requerida |
|---------|-----------|-------------|---------------------|
| `./scripts/run_all_tests.sh` | Ejecutar suites backend, frontend y validaciones de seguridad con cobertura objetivo ≥80% | @devops-lead | Cobertura reportada y logs de ejecución adjuntos en `qa/registros/` |
| `./scripts/validate_critical_restrictions.sh` | Validar restricciones críticas (sin Redis, sin correo) en configuraciones | @backend-lead | Resultado del comando con timestamp y hallazgos documentados |
| `./scripts/validar_estructura_docs.sh` | Revisar estructura de documentación y enlaces | @tech-writer | Log de validación y tickets abiertos si hay incidencias |
| `npm test -- --coverage` (en `ui/`) | Validar UI con cobertura mínima de 80% | @equipo-frontend | Reporte de cobertura y resumen de suites ejecutadas |
| `pytest` (en `api/`) | Ejecutar pruebas unitarias y de integración del backend | @backend-lead | Resultado en formato JUnit o log con cobertura indicada |

## Política de evidencia
- Capturar salida de cada comando y guardarla bajo `qa/registros/` con nombre `EVIDENCIA-<comando>-<fecha>.md`.
- Registrar desviaciones y acciones correctivas en la misma evidencia.
- Actualizar el estado de la tarea asociada en `qa/tareas_activas.md` y en Task tool.
