---
id: TASK-QA-INFRA-004
tipo: tarea
categoria: diseno
nombre: Diseñar plantillas por componente
titulo: Diseñar plantillas por componente
fase: FASE_2
prioridad: P1
duracion_estimada: 1h
estado: pendiente
dependencias: [TASK-QA-INFRA-003]
---

# TASK-QA-INFRA-004: Diseñar plantillas por componente

**Objetivo:** Bosquejar contenido mínimo de cada subcarpeta (`box`, `cpython`, `vagrant`, `workspace`) incluyendo propósito, prerequisitos, comandos clave, pruebas asociadas y riesgos/rollback.

**Responsable:** @devops-lead  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Plantilla de README/INDEX por componente con secciones de propósito, prerequisitos, comandos, pruebas y rollback.
- Checklists de verificación específicos (p.ej., conectividad DB en `box`, provisión en `vagrant`, setup en `workspace`).
- Enlaces a ADRs cuando se documenten decisiones de proveedor o plataforma.

## Pasos principales
1. Derivar estructura de cada README/INDEX a partir del árbol aprobado en TASK-QA-INFRA-003.
2. Redactar placeholders de comandos y validaciones (TDD, cobertura, sin Redis/correo).
3. Documentar riesgos y acciones de rollback mínimas por componente.

## Entregables
- Plantillas de README/INDEX listas para ser copiadas a cada subcarpeta en fase de ejecución.
- Checklists y notas de pruebas mínimas asociadas a cada componente.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (borradores o snippets validados).

## Checklist de salida
- [ ] Plantilla para cada componente redactada y alineada al plan QA.
- [ ] Secciones de pruebas y rollback incluidas con referencias a restricciones.
- [ ] Enlaces/espacios para ADRs definidos.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Registrar las plantillas y validaciones previas en `./evidencias/evidencia-ejecucion.md`, anexando enlaces o hashes de archivos generados.
