---
id: QA-PLANTILLAS-INFRA
estado: activo
version: 1.0.0
ultima_actualizacion: 2025-11-18
propietario: qa-lead
relacionados: ["docs/infraestructura/qa/tareas_activas.md", "docs/gobernanza/plantillas"]
---

# Plantillas QA - Infraestructura

Este catálogo concentra plantillas y checklists para QA de infraestructura, alineadas con el modelo de `docs/gobernanza/plantillas`. Todas las piezas comparten frontmatter homogéneo para permitir trazabilidad con Task tool y con `qa/tareas_activas.md`.

## Frontmatter requerido

```yaml
id: PLANTILLA-INFRA-XXX
estado: pendiente|en_progreso|hecho|bloqueado
responsable: alias-equipo
fecha: AAAA-MM-DD
version: 1.0.0
metricas_objetivo:
  cobertura: 
  evidencia: 
trazabilidad:
  tareas: ["TASK-INFRA-QA-00X"]
  adrs: []
```

## Plantillas disponibles

- `plantilla_provision.md`: checklist de provisión y bootstrap de infraestructura.
- `plantilla_hardening.md`: controles mínimos de endurecimiento por sistema operativo y contenedor.
- `plantilla_observabilidad.md`: requisitos de métricas, logs y trazas.
- `plantilla_continuidad.md`: verificaciones de respaldo, restauración y continuidad operativa.

## Uso recomendado
1. Copiar la plantilla requerida a la ruta del dominio (p. ej., `docs/infraestructura/checklists/`).
2. Completar el frontmatter con el ID de la tarea activa y responsables registrados en Task tool.
3. Registrar evidencias en `qa/registros/` con fecha y resultados de validación.
4. Actualizar `qa/tareas_activas.md` marcando el estado y la ruta del entregable.
