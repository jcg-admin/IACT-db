---
id: TASK-QA-INFRA-006
tipo: tarea
categoria: ejecucion
nombre: QA y validaciones automáticas
titulo: QA y validaciones automáticas
fase: FASE_3
prioridad: P1
duracion_estimada: 1.25h
estado: pendiente
dependencias: [TASK-QA-INFRA-005]
---

# TASK-QA-INFRA-006: QA y validaciones automáticas

**Objetivo:** Definir y documentar la suite mínima de pruebas automatizadas para scripts de infraestructura, asegurando cobertura ≥80 % y alineación con pipelines existentes.

**Responsable:** @qa-lead  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Seleccionar herramientas de validación (shellcheck, linters, pruebas de idempotencia) aplicables a scripts de `infrastructure/`.
- Definir comandos de ejecución y métricas esperadas (incluyendo cobertura para nuevas pruebas).
- Alinear la suite con `scripts/run_all_tests.sh` u otro pipeline existente.

## Pasos principales
1. Identificar scripts críticos en cada módulo y pruebas que requieren (lint, unitarias, integración simulada sin Redis/correo).
2. Redactar comandos y criterios de aceptación, incluyendo cobertura objetivo ≥80 %.
3. Registrar pasos de rollback o mitigación ante fallos en validaciones automáticas.

## Entregables
- Sección de pruebas automatizadas documentada y enlazada desde el plan QA.
- Conjunto de comandos listos para integrarse al pipeline.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (salidas de herramientas, configuración propuesta, timestamps).

## Checklist de salida
- [ ] Pruebas y herramientas definidas para cada script crítico.
- [ ] Cobertura objetivo ≥80 % documentada y asociada al pipeline.
- [ ] Pasos de rollback descritos.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Registrar salidas y configuraciones en `./evidencias/evidencia-ejecucion.md`. Adjuntar capturas o logs de linters/pruebas ejecutadas en seco si aplica.
