---
id: DOC-PLANTILLAS-INDEX
estado: borrador
propietario: equipo-documentacion
ultima_actualizacion: 2025-11-06
relacionados: ["DOC-INDEX-GENERAL", "DOC-REQ-INDEX", "PLANTILLA-SPEC", "PLANTILLA-PLAN", "DOC-GOB-CONSTITUTION-AI"]
---
# Plantillas

Colección de formatos reutilizables para discovery, análisis, diseño, QA y operación. Las plantillas se mantienen en Markdown para facilitar su adaptación.

## Página padre
- [`../index.md`](../index.md)

## Páginas hijas
- [`plantilla_project_charter.md`](plantilla_project_charter.md)
- [`plantilla_business_case.md`](plantilla_business_case.md)
- [`plantilla_srs.md`](plantilla_srs.md)
- [`plantilla_sad.md`](plantilla_sad.md)
- [`plantilla_tdd.md`](plantilla_tdd.md)
- [`plantilla_django_app.md`](plantilla_django_app.md)
- [`plantilla_etl_job.md`](plantilla_etl_job.md)
- [`plantilla_database_design.md`](plantilla_database_design.md)
- [`plantilla_api_reference.md`](plantilla_api_reference.md)
- [`plantilla_plan_pruebas.md`](plantilla_plan_pruebas.md)
- [`plantilla_runbook.md`](plantilla_runbook.md)
- [`plantilla_espacio_documental.md`](plantilla_espacio_documental.md)
- [`desarrollo/plantilla_spec.md`](desarrollo/plantilla_spec.md) [NUEVO 2025-11-06]
- [`desarrollo/plantilla_plan.md`](desarrollo/plantilla_plan.md) [NUEVO 2025-11-06]

## Información clave
### Uso recomendado
1. Clonar el archivo correspondiente y registrar la relación en el front matter del nuevo documento.
2. Actualizar campos resaltados con `TODO` o comentarios antes de compartir el artefacto.
3. Notificar cambios relevantes en [`../gobernanza/readme.md`](../gobernanza/readme.md) para asegurar que todos los equipos utilicen la versión vigente.

### Categorías destacadas
- **Producto y alcance:** `plantilla_project_charter.md`, `plantilla_business_case.md`.
- **Requisitos y análisis:** `plantilla_srs.md`, `plantilla_regla_negocio.md`, `plantilla_caso_de_uso.md` (ver [Guía de Casos de Uso](../gobernanza/casos_de_uso_guide.md) para estándares completos).
- **Diseño y arquitectura:** `plantilla_sad.md`, `plantilla_tdd.md`, `plantilla_database_design.md`, `plantilla_api_reference.md`.
- **Django y Python:** `plantilla_django_app.md` (documentación de aplicaciones Django), `plantilla_etl_job.md` (documentación de jobs ETL).
- **Desarrollo de features:** [NUEVO] `desarrollo/plantilla_spec.md` (especificación formal de features), `desarrollo/plantilla_plan.md` (plan de implementación detallado).
- **QA y soporte:** `plantilla_plan_pruebas.md`, `plantilla_caso_prueba.md`, `plantilla_runbook.md`.
- **Documentación corporativa:** `plantilla_espacio_documental.md` para replicar portadas y jerarquías alineadas con la base maestra.

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio de plantillas | Sí | Este archivo replica metadatos y navegación requeridos. |
| Plantillas de discovery y negocio | Sí | Incluyen Project Charter y Business Case. |
| Plantillas de ingeniería y QA | Sí | Están disponibles las guías de SRS, SAD, plan de pruebas y runbooks. |
| Plantilla para espacios documentales | Sí | Documentada en [`plantilla_espacio_documental.md`](plantilla_espacio_documental.md). |
| Plantillas específicas de Django | OK Sí | ⭐ Creadas `plantilla_django_app.md` y `plantilla_etl_job.md` para SC02 (2025-11-04). |
| Registro de versiones y owners | No | Falta crear un inventario que detalle responsables y fecha de vigencia. |

## Acciones prioritarias
- [ ] Elaborar inventario maestro de plantillas con responsables y fechas de revisión.
- [ ] Automatizar la verificación de enlaces rotos dentro de las plantillas.
- [ ] Coordinar con Gobernanza la publicación de la guía de adopción de plantillas en rituales oficiales.
- [x] Crear plantillas específicas para Django (completado 2025-11-04).

## Nuevas plantillas 2025-11-04

### plantilla_django_app.md
Plantilla especializada para documentar aplicaciones Django con estructura completa de 13 secciones:
1. Información general
2. Modelos (models.py)
3. Servicios (services.py)
4. Vistas (views.py)
5. URLs (urls.py)
6. Comandos de management
7. Signals y receivers
8. Tests
9. Configuración adicional
10. Diagramas
11. Flujos principales
12. Troubleshooting
13. Referencias

**Uso recomendado**: Documentación de apps Django en `api/callcentersite/callcentersite/apps/`

### plantilla_etl_job.md
Plantilla especializada para documentar jobs ETL con estructura completa de 12 secciones:
1. Información del Job (programación, SLA, configuración)
2. Fuente de datos (Extract)
3. Transformaciones (Transform)
4. Destino (Load)
5. Dependencias y orden de ejecución
6. Monitoreo y métricas
7. Recuperación ante fallos
8. Diagramas de flujo
9. Testing y validación
10. Changelog y versionado
11. Referencias
12. Notas adicionales

**Uso recomendado**: Documentación de jobs ETL en `api/callcentersite/callcentersite/apps/etl/jobs/`

## Nuevas plantillas 2025-11-06: Desarrollo Spec-Driven

### desarrollo/plantilla_spec.md
Plantilla formal para especificación de features siguiendo ISO 29148:2018, con estructura completa de 14 secciones:

1. Metadata y trazabilidad
2. Resumen ejecutivo
3. Contexto y motivación
4. Requisitos funcionales (casos de uso, reglas de negocio, criterios de aceptación)
5. Requisitos no funcionales (performance, seguridad, disponibilidad, escalabilidad)
6. Diseño de solución (arquitectura, modelos, API endpoints)
7. Dependencias (técnicas, features, infraestructura)
8. Plan de testing
9. Plan de despliegue
10. Plan de rollout
11. Riesgos e impacto
12. Documentación requerida
13. Criterios de completitud
14. Aprobaciones y historial

**Uso recomendado**: Especificación formal de features complejas antes de implementación, especialmente cuando:
- Afectan múltiples componentes
- Requieren cambios arquitectónicos
- Necesitan aprobación de stakeholders
- Tienen requisitos de negocio complejos

**Workflow**: Ver [Guía de desarrollo de features](../gobernanza/procesos/guia_completa_desarrollo_features.md) para integración en proceso.

### desarrollo/plantilla_plan.md
Plantilla detallada para planificación de implementación, con estructura completa de 11 secciones:

1. Metadata y trazabilidad (link a spec)
2. Resumen del plan y alcance
3. Pre-requisitos (conocimientos, setup, documentación)
4. Plan de tareas detallado por fases con:
   - Estimaciones de tiempo por tarea
   - Asignaciones de responsables
   - Criterios de completitud por tarea
   - Código de ejemplo esperado
   - Tests requeridos
5. Plan de deploy (staging y production)
6. Riesgos y mitigaciones
7. Rollback plan
8. Métricas de éxito
9. Checklist final
10. Lecciones aprendidas (post-implementación)
11. Historial de cambios del plan

**Uso recomendado**: Plan de implementación paso a paso para features especificadas, especialmente cuando:
- Feature toma más de 2 días de desarrollo
- Múltiples desarrolladores trabajan en paralelo
- Se requiere coordinación con otros equipos
- Existe una especificación formal (spec)

**Workflow**: Crear después de aprobación de spec, actualizar durante implementación como documento vivo.

**Integración con Constitution AI**: Ambas plantillas están alineadas con [Constitution para agentes AI](../gobernanza/agentes/constitution.md) para garantizar que agentes AI generen especificaciones y planes que cumplan estándares del proyecto.
