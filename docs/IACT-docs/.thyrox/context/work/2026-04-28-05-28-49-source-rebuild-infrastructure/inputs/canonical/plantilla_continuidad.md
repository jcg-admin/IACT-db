---
id: PLANTILLA-INFRA-CONTINUIDAD
estado: pendiente
responsable: definir
fecha: 2025-11-18
version: 1.0.0
trazabilidad:
  tareas: ["TASK-INFRA-QA-002"]
  adrs: []
---

# Checklist de continuidad y resiliencia

## Alcance
Confirmar que la infraestructura soporta escenarios de falla y recuperación alineados a los SLOs y requisitos del negocio.

## Checklist base
- [ ] Plan de respaldo y restauración probado con frecuencia definida.
- [ ] Documentación de RPO/RTO acordados y validados.
- [ ] Procedimientos de conmutación por error y retorno a operación establecidos.
- [ ] Ensayos de contingencia registrados y evaluados.
- [ ] Monitoreo de capacidad y saturación con alertas preventivas.

## Evidencias esperadas
- Resultados de simulacros o pruebas de restauración documentados en `qa/registros/`.
- Registros de cumplimiento de RPO/RTO medidos.
- Planes de comunicación y responsables en caso de contingencia.

## Validaciones automáticas
- Pruebas de restauración automatizadas cuando aplique.
- Validaciones de integridad de respaldo y consistencia de datos.

## Trazabilidad
- Enlazar resultados con `qa/tareas_activas.md` y ADRs de continuidad.
- Mantener histórico de ensayos en `qa/registros/`.
