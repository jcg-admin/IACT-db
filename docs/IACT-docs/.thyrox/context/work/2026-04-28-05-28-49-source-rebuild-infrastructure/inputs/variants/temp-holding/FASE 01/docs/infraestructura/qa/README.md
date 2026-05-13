# QA en Infraestructura

Este espacio consolida el aseguramiento de calidad documental y operativo de la infraestructura que soporta el monolito modular. Aquí se coordinan los análisis de brechas, planes de reorganización, y verificaciones de cumplimiento alineados con las prácticas de gobernanza.

## Propósito
- Garantizar que la documentación de infraestructura mantenga trazabilidad, consistencia y cobertura mínima (tests ≥ 80 %) para cualquier cambio automatizado.
- Orquestar revisiones cruzadas con backend y frontend cuando los cambios de infraestructura impacten pipelines, IaC o runbooks.
- Registrar decisiones y planes en un solo lugar para facilitar auditorías y preparación de releases.

## Artefactos clave
- **Plan activo de reorganización:** [`QA-ANALISIS-ESTRUCTURA-INFRA-001`](./QA-ANALISIS-ESTRUCTURA-INFRA-001/INDICE.md) consolida el inventario pendiente y el plan para homogeneizar la estructura con Gobernanza.
- **Tareas y backlog:** [`tareas_activas.md`](./tareas_activas.md) centraliza las actividades en curso; nuevas acciones de infraestructura se deben vincular ahí.

## Próximos pasos inmediatos
1. Validar la estructura de `docs/infraestructura/` contra el modelo de `docs/gobernanza/` siguiendo el plan del análisis de estructura.
2. Definir responsables y fechas de los entregables (README/INDEX alineados, plantillas QA, checklists de provisión y hardening).
3. Ejecutar validaciones automáticas de documentación una vez que se creen las nuevas secciones y plantillas.
