---
id: TASK-QA-INFRA-007
tipo: tarea
categoria: gobernanza
nombre: Registrar tareas y responsables en QA
titulo: Registrar tareas y responsables en QA
fase: FASE_4
prioridad: P1
duracion_estimada: 0.4h
estado: pendiente
dependencias: [TASK-QA-INFRA-005, TASK-QA-INFRA-006]
---

# TASK-QA-INFRA-007: Registrar tareas y responsables en QA

**Objetivo:** Incorporar este plan y las tareas asociadas en `tareas_activas.md`, asignando responsables, prioridad y fecha objetivo para seguimiento.

**Responsable:** @arquitecto-senior  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Registrar el plan QA y cada TASK en `docs/infraestructura/qa/tareas_activas.md`.
- Asegurar que prioridad, esfuerzo y responsables queden visibles.
- Establecer cadencia de actualización (semanal) y estado inicial.

## Pasos principales
1. Consolidar IDs de tareas y responsables definidos en el plan.
2. Actualizar `tareas_activas.md` con prioridad, esfuerzo y fecha objetivo.
3. Verificar enlaces a la carpeta QA y a cada TASK creada.

## Entregables
- `tareas_activas.md` actualizado con el plan y tareas de documentación de infraestructura.
- Evidencias en `./evidencias/evidencia-ejecucion.md` (diffs, timestamps, enlaces verificados).

## Checklist de salida
- [ ] Todas las tareas registradas con prioridad y responsables.
- [ ] Enlaces a cada carpeta TASK verificados.
- [ ] Cadencia de actualización definida.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Guardar en `./evidencias/evidencia-ejecucion.md` las pruebas de registro (diffs o capturas) y resultados de verificación de enlaces.
