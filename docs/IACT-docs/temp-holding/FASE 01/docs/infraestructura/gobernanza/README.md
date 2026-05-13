---
id: DOC-GOB-INDEX
estado: borrador
propietario: pmo
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-GOB-001", "DOC-VIS-INDEX", "DOC-REQ-INDEX"]
---
# Gobernanza

Define el marco de decisión y coordinación que sostiene el flujo documental. Aquí se asignan responsables, cadencias y tableros de seguimiento para transformar acuerdos en acciones.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`lineamientos_gobernanza.md`](lineamientos_gobernanza.md)

## Información clave
### Rol dentro del flujo de documentación
- **Documentar logística.** Centraliza calendarios, foros y enlaces permanentes.
- **Roles y responsabilidades.** Mantiene la matriz RACI y los comités activos.
- **Action items.** Consolida el backlog operativo y da seguimiento a compromisos originados en otros espacios.

### Artefactos obligatorios
- Lineamientos vigentes (`lineamientos_gobernanza.md`).
- Matriz RACI (pendiente, basarse en `../../plantillas/plantilla_stakeholder_analysis.md`).
- Calendario de rituales con enlaces a registros (`../../plantillas/plantilla_registro_actividad.md`).

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio de gobernanza | Sí | Este archivo mantiene metadatos, jerarquía y enlaces principales. |
| Lineamientos vigentes | Sí | Documentados en [`lineamientos_gobernanza.md`](lineamientos_gobernanza.md). |
| Matriz RACI actualizada | No | Debe generarse usando la plantilla corporativa. |
| Calendario de rituales con enlaces | No | Aún no se documenta el calendario detallado. |

## Integración con el flujo documental principal
- Recibe objetivos estratégicos desde [`../../vision_y_alcance/README.md`](../../vision_y_alcance/README.md).
- Retroalimenta la priorización de [`../../backend/requisitos/README.md`](../../backend/requisitos/README.md).
- Escala decisiones técnicas hacia [`../../backend/arquitectura/README.md`](../../backend/arquitectura/README.md) mediante ADR gestionados en Infraestructura.

## Acciones prioritarias
- [ ] WKF-SDLC-110 – Crear matriz RACI _(Pendiente; requiere insumos de Visión y Requisitos)_.
- [ ] WKF-SDLC-111 – Definir plantilla para comités _(Pendiente; basarse en el flujo de logística)_.
- [ ] WKF-SDLC-112 – Conectar action items con tablero operativo _(En progreso; evaluar integración con roadmap)_.
