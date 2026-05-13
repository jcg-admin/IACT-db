---
id: TASK-QA-INFRA-002
tipo: tarea
categoria: descubrimiento
nombre: Revisar restricciones en backend y frontend
titulo: Revisar restricciones en backend y frontend
fase: FASE_1
prioridad: P1
duracion_estimada: 0.35h
estado: pendiente
dependencias: [TASK-QA-INFRA-001]
---

# TASK-QA-INFRA-002: Revisar restricciones en backend y frontend

**Objetivo:** Confirmar que `api/callcentersite` y `ui` no habilitan Redis ni envío de correo, y registrar rutas de configuración relevantes para la documentación de infraestructura.

**Responsables:** @backend-lead, @frontend-lead  
**Restricciones:** TDD con cobertura ≥80 %, commits convencionales, sin Redis, sin envío de correo.  
**Técnica de prompting sugerida:** Auto-CoT + Self-Consistency (`docs/ai/prompting`).

---

## Alcance
- Revisar settings, variables de entorno y providers en backend y frontend que pudieran activar Redis o correo.
- Documentar ubicaciones de configuraciones y mecanismos de mock/flag usados para desactivar servicios prohibidos.
- Incorporar hallazgos en la sección de riesgos/controles del plan QA.

## Pasos principales
1. Inspeccionar configuraciones en `api/callcentersite` (envs, settings, docker-compose si aplica) y anotar referencias a Redis/correo.
2. Revisar `ui` para detectar SDKs, hooks o endpoints de correo; verificar que existan mocks o flags de desactivación.
3. Documentar resultados y adjuntar rutas exactas y comandos de validación usados.

## Entregables
- Resumen de restricciones verificadas incorporado al plan QA o addendum dedicado.
- Lista de rutas/archivos con notas de control (ej. variables de entorno obligatorias).
- Evidencias en `./evidencias/evidencia-ejecucion.md` (salidas de grep, capturas de config, timestamps).

## Checklist de salida
- [ ] Validación backend sin Redis/correo registrada con rutas exactas.
- [ ] Validación frontend sin correo/Redis registrada con rutas exactas.
- [ ] Riesgos/controles actualizados en el plan QA.
- [ ] Evidencias cargadas en la carpeta correspondiente.

## Evidencias
Registrar pruebas y resultados en `./evidencias/evidencia-ejecucion.md`, incluyendo comandos ejecutados y archivos inspeccionados.
