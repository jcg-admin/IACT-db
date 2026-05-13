---
id: SCP-SC00-CHECKLIST-FLUJO
estado: borrador
propietario: coordinacion-sc00
ultima_actualizacion: 2025-11-02
relacionados: ["SCP-SC00-DOCS", "SCP-SC00-DOCS-GUIA-INTEGRADA", "DOC-REQ-INDEX", "DOC-SOL-INDEX"]
---
# SC00 · Checklist de cumplimiento del flujo integrado

Esta checklist formaliza los puntos de control que aseguran que ninguna entrega vinculada a SC00 rompa el flujo obligatorio **Reglas → Solicitudes → Requisitos → Tareas → Validación**. Cada ítem debe marcarse durante las revisiones semanales y antes de cerrar cualquier solicitud o requisito.

## 1. Reglas de negocio
- [ ] Cada regla de negocio activa relacionada con SC00 está registrada en el catálogo oficial con ID RN-XXX y fuente vigente.
- [ ] Cada regla RN registrada incluye el campo `relacionados` apuntando a la solicitud SC00 correspondiente.
- [ ] Cada regla cuenta con criterios de verificación documentados y enlazados desde la SRS aplicable.

## 2. Solicitudes
- [ ] Toda solicitud en curso en `docs/solicitudes/sc00/` referencia explícitamente las reglas que la originan.
- [ ] Toda solicitud en curso documenta dueños, entregables esperados y vínculos hacia `docs/requisitos/` y `sc00_task_report`.
- [ ] Toda solicitud en curso actualiza su estado en el front matter (`estado: abierto/cerrado`) conforme avanza el cumplimiento.

## 3. Requisitos
- [ ] Cada requisito aprobado en `docs/requisitos/` traza hacia la solicitud SC00 y sus reglas madre.
- [ ] Cada requisito aprobado en `docs/requisitos/` mantiene criterios de aceptación verificables y evidencia adjunta.
- [ ] Cada requisito aprobado en `docs/requisitos/` replica el ID de la tarea responsable dentro de `sc00_task_report`.

## 4. Tareas y ejecución
- [ ] Cada tarea en ejecución dentro de `sc00_task_report` enlaza al requisito y la solicitud correspondiente.
- [ ] Cada tarea en ejecución dispone de evidencia operativa (enlaces a artefactos o commits) antes de moverse a `Done`.
- [ ] Cada tarea en ejecución registra la validación de la regla de negocio que satisface (pruebas, auditorías o revisiones).

## 5. Verificación continua
- [ ] El equipo agenda revisión semanal de esta checklist y documenta hallazgos en `docs/qa/registros/`.
- [ ] La revisión semanal registra quién verificó cada punto y la fecha exacta de la evidencia adjunta.
- [ ] La bitácora de cada solicitud o requisito incluye enlaces a los artefactos que comprueban la verificación manual del flujo.

> **Recordatorio:** Si alguno de los puntos queda sin marcar, no se debe cerrar la solicitud ni dar por cumplida la regla hasta resolver el faltante.
