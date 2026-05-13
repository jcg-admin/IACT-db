---
id: PLANTILLA-INFRA-OBS
estado: pendiente
responsable: definir
fecha: 2025-11-18
version: 1.0.0
trazabilidad:
  tareas: ["TASK-INFRA-QA-002"]
  adrs: []
---

# Checklist de observabilidad

## Alcance
Establecer métricas, logs y trazas mínimos para operar servicios de infraestructura con retroalimentación rápida.

## Checklist base
- [ ] Métricas de infraestructura publicadas en colector central (CPU, memoria, disco, red).
- [ ] Logs estructurados con retención definida y sin datos sensibles.
- [ ] Trazas distribuidas para rutas críticas.
- [ ] Alertas configuradas con umbrales y responsables claros.
- [ ] Dashboards alineados a SLOs publicados en `requisitos/`.

## Evidencias esperadas
- Capturas o exportaciones de dashboards con fecha.
- Configuración de alertas y reglas de retención documentadas en `qa/registros/`.
- Referencias a pipelines de observabilidad y validaciones automatizadas.

## Validaciones automáticas
- Scripts de chequeo de endpoints de métricas y disponibilidad de colectores.
- Asegurar pruebas automatizadas con cobertura mínima de 80% para componentes instrumentados.

## Trazabilidad
- Vincular SLOs y requisitos en `qa/tareas_activas.md` y ADRs relevantes.
- Actualizar bitácoras de observabilidad en `qa/registros/`.
