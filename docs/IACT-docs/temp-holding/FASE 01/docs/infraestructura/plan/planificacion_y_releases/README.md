---
id: DOC-REL-INDEX
estado: borrador
propietario: pmo
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-VIS-INDEX", "DOC-REQ-INDEX", "DOC-GOB-INDEX"]
---
# Planificación y releases

Coordina roadmap, releases y compromisos financieros. Vincula directamente la visión estratégica con resultados medibles y evidencia los acuerdos listos para implementación.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- _Pendiente de registrar subpáginas; se activarán al publicar planes específicos de release._

## Información clave
### Rol dentro del flujo de documentación
- Recibe objetivos definidos en [`../../vision_y_alcance/README.md`](../../vision_y_alcance/README.md) para construir el roadmap macro.
- Utiliza action items y seguimiento capturados en [`../gobernanza/README.md`](../gobernanza/README.md) para actualizar entregables por release.
- Complementa los criterios de salida documentados en [`../../qa/estrategia_qa.md`](../../qa/estrategia_qa.md).

### Artefactos esperados
- Roadmap macro trimestral.
- Calendario de releases con criterios de aceptación (apoyarse en `../../plantillas/plantilla_release_plan.md`).
- Business case detallado por release (usar `../../plantillas/plantilla_business_case.md`).

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio de planificación | Sí | Este archivo replica la jerarquía y metadatos corporativos. |
| Roadmap macro del año en curso | No | Debe derivarse una vez priorizados los requisitos iniciales. |
| Calendario de releases con criterios | No | Requiere completar insumos desde QA y Gobernanza. |
| Business case detallado por release | No | Se documentará conforme se definan las ventanas de entrega. |

## Integración con el flujo documental principal
- Traduce la visión en compromisos calendarizados.
- Requiere decisiones de aprobación y gobierno documentadas en [`../gobernanza/README.md`](../gobernanza/README.md).
- Define ventanas de implementación para [`../../backend/arquitectura/README.md`](../../backend/arquitectura/README.md) y [`../../backend/diseno_detallado/README.md`](../../backend/diseno_detallado/README.md).

## Acciones prioritarias
- [ ] WKF-SDLC-150 – Definir calendario R1-R3 _(Pendiente; depende de la priorización de requisitos)_.
- [ ] WKF-SDLC-151 – Establecer métricas de éxito por release _(Pendiente; consultar a equipo de datos)_.
- [ ] WKF-SDLC-152 – Integrar flujo de actividades con tablero de releases _(En progreso; revisar automatización futura)_.
