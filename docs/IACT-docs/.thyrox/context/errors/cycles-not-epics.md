```yml
id: ERR-019
created_at: 2026-03-28
type: Inconsistencia estructura/práctica
severity: Media
status: Detectado
```

# ERR-019: Ciclos de trabajo como análisis sueltos, no epics

## Qué pasó

Los 3 ciclos de correcciones (covariancia, spec-kit adoption, spec-kit deep) se documentaron como archivos sueltos en `context/analysis/` en vez de crear un directorio en `context/epics/` con la estructura formal (epic.md + tasks.md).

## Impacto

15 archivos en analysis/ mezclando diagnósticos con planes de trabajo. Difícil distinguir "qué encontramos" de "qué planeamos hacer."

## Corrección propuesta

Definir regla: si un trabajo tiene las 7 fases completas (analysis + strategy + structure + tasks + execute + track), es un epic, no un análisis.
