---
id: DOC-QA-INDEX
estado: borrador
propietario: lider-qa
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-QA-001", "DOC-CHECKLISTS-INDEX", "DOC-REL-INDEX"]
---
# Gestión de calidad

Centraliza la estrategia, métricas y evidencias de aseguramiento de calidad para el monolito modular. Permite rastrear la cobertura de pruebas y coordinar la liberación de entregables siguiendo TDD.

## Página padre
- [`../index.md`](../index.md)

## Páginas hijas
- [`estrategia_qa.md`](estrategia_qa.md)
- [`actividades_garantia_documental.md`](actividades_garantia_documental.md)
- [`registros/`](registros/)
- [`guia_estructura_qa.md`](guia_estructura_qa.md)

## Información clave
### Rol dentro del flujo de documentación
- Define la línea base de pruebas automatizadas y manuales.
- Coordina métricas de cobertura y criterios de salida con [`../planificacion_y_releases/readme.md`](../planificacion_y_releases/readme.md).
- Vincula lecciones aprendidas y hallazgos operativos con [`../devops/readme.md`](../devops/readme.md).

### Artefactos obligatorios
- Estrategia de QA (`estrategia_qa.md`).
- Actividades de control documental (`actividades_garantia_documental.md`).
- Registro de ejecuciones y evidencias (`registros/`).

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio QA | Sí | Este archivo replica la jerarquía y metadatos corporativos. |
| Estrategia de QA documentada | Sí | Disponible en [`estrategia_qa.md`](estrategia_qa.md). |
| Registro de ejecuciones y métricas | Parcial | Directorio [`registros/`](registros/) requiere actualización de casos recientes. |
| Reporte de cobertura ≥ 80 % | No | Debe consolidarse conforme avanza el desarrollo siguiendo TDD. |

## Acciones prioritarias
- [ ] Consolidar suite `pytest` con cobertura mínima de 80 %.
- [ ] Documentar criterios de salida para despliegues APScheduler y reportes.
- [ ] Mantener bitácora de ejecuciones actualizada en `registros/` y enlazarla con Planificación y DevOps.
