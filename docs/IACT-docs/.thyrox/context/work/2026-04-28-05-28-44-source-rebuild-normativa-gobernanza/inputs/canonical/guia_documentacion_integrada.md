---
id: SCP-SC00-DOCS-GUIA-INTEGRADA
estado: borrador
propietario: coordinacion-sc00
ultima_actualizacion: 2025-11-02
relacionados: ["SCP-SC00-INDEX", "DOC-SOL-INDEX", "DOC-REQ-INDEX", "DOC-REQS-PIPELINE"]
---
# Guía de documentación integrada: reglas, solicitudes, requisitos y tareas

Esta guía consolida el análisis previo sobre cómo se relacionan las reglas de negocio, las solicitudes documentales, los requisitos y las tareas
operativas dentro del marco integrado descrito para SC00. Su objetivo es ofrecer un instructivo reproducible para mantener la trazabilidad y la
consistencia entre los distintos espacios documentales que conviven en el repositorio.

## 1. Taxonomía y ubicaciones

| Concepto      | Propósito | Ubicación base | Artefactos clave |
| --- | --- | --- | --- |
| Reglas de negocio | Punto de partida normativo que origina necesidades y requisitos | `../..` (según dominio) | Catálogos RN-XXX, matrices de impacto |
| Solicitudes documentales | Peticiones transversales de información o entregables, independientes de los tableros operativos | `../../readme.md` y subdirectorios `scXX/` | Bitácoras SC00/SC01, guías de preparación |
| Requisitos | Especificaciones funcionales y no funcionales con trazabilidad completa | `../../gobernanza/marco_integrado/` | BRD, SRD, SRS, matrices de trazabilidad |
| Tareas | Actividades puntuales con responsables y estados de avance | `../sc00_task_report/` | Tablero Kanban, reportes de seguimiento |

> **Nota:** El directorio `docs/requirements/` continúa reservado para dependencias técnicas de MkDocs y no debe utilizarse para albergar requisitos
> de negocio.

## 2. Flujo documental recomendado

1. **Identificar reglas de negocio**
   - Registrar cada regla con su ID RN-XXX, fuente y nivel de obligatoriedad.
   - Enlazar la regla a la solicitud que detona (por ejemplo, SC00) usando el campo `relacionados` en el front matter.

2. **Generar la solicitud correspondiente**
   - Crear o actualizar la página de la solicitud en `docs/solicitudes/scXX/` con objetivos, responsables y entregables esperados.
   - Documentar la relación con los directorios de requisitos y tareas para conservar trazabilidad bidireccional.

3. **Derivar requisitos**
   - Capturar en `docs/requisitos/` los requisitos de negocio, stakeholders y solución que surgen de la solicitud.
   - Completar los criterios de aceptación, matrices de trazabilidad y plantillas SRS.

4. **Planificar y ejecutar tareas**
   - Registrar en `sc00_task_report` las tareas necesarias para satisfacer la solicitud y los requisitos asociados.
   - Mantener el enlace a evidencias y resultados de validación.

## 3. Checklists operativos

> **Control obligatorio:** Cada revisión del flujo debe apoyarse en [`checklist_control_flujo.md`](./checklist_control_flujo.md), que consolida los puntos de verificación manual descritos en esta guía.

### 3.1 Alta de nueva regla vinculada a SC00

- [ ] RN documentada con fuente, tipo y vigencia.
- [ ] Solicitud SC00 actualizada con referencia a la regla.
- [ ] Requisito derivado capturado en la SRS correspondiente.
- [ ] Tarea(s) creadas en `sc00_task_report` para implementar o validar el requisito.
- [ ] Matriz de trazabilidad regenerada con los vínculos RN → N → RB → RS → RF.

### 3.2 Cierre de solicitud

- [ ] Todas las tareas marcadas como `Done` con evidencias adjuntas.
- [ ] Requisitos validados y con estado actualizado en el BRD/SRS.
- [ ] Reglas cumplidas con verificación documentada (pruebas o auditorías).
- [ ] Archivo de la solicitud movido a estado `cerrado` en el front matter.
- [ ] Actualización de métricas en el tablero consolidado de solicitudes.

## 4. Referencias cruzadas

| Documento | Rol en la guía |
| --- | --- |
| `../../readme.md` | Define los lineamientos globales de solicitudes documentales |
| `../../gobernanza/marco_integrado/plantillas/srs.md` | Plantilla base para especificaciones de requisitos |
| `../sc00_task_report/readme.md` | Tablero que centraliza las tareas vinculadas a SC00 |
| `../../../requirements.txt` | Dependencias técnicas necesarias para compilar la documentación |

Mantener esta guía actualizada garantiza que cualquier integrante del equipo pueda replicar el proceso de análisis desde la identificación de una
regla hasta la validación de su cumplimiento a través de solicitudes, requisitos y tareas documentadas.
