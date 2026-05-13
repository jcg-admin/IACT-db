---
id: DOC-GOB-PLAN
estado: activo
propietario: pmo
ultima_actualizacion: 2025-11-02
relacionados:
  - "DOC-GOB-INDEX"
  - "DOC-ROOT-001"
  - "DOC-INDEX-GENERAL"
  - "DOC-QA-DOC-CONTROL"
  - "DOC-QA-001"
---
# Plan general de documentación

Guía maestra para coordinar la evolución del espacio `docs/` bajo los lineamientos de QA descritos en [`qa/`](qa/). Este plan
conecta la gobernanza documental con las rutinas de control descritas para asegurar trazabilidad, consistencia editorial y
evidencias auditables.

## Propósito (qué resuelve)
- Mantener un inventario actualizado de artefactos publicados y su correspondencia con el repositorio corporativo.
- Visibilizar dependencias entre espacios documentales y las iniciativas de QA.
- Exponer un backlog único de sincronización con responsables definidos.

## Enfoque operativo (cómo se ejecuta)
1. Ejecutar el checklist editorial de [`documentacion_corporativa.md`](documentacion_corporativa.md) antes de aceptar
   modificaciones.
2. Validar que cada archivo nuevo o actualizado conserve metadatos y jerarquía según la
   [`plantilla_espacio_documental.md`](plantillas/plantilla_espacio_documental.md).
3. Registrar en [`qa/registros/`](qa/registros/) cualquier hallazgo o incumplimiento detectado durante las revisiones.
4. Sincronizar relaciones en [`requisitos/trazabilidad.md`](requisitos/trazabilidad.md) cuando el contenido impacte requisitos,
   casos de uso o pruebas.

## Alcance y limitaciones
- **Incluye:** Documentación funcional, técnica y operativa ubicada en `docs/` y publicada mediante MkDocs.
- **Excluye:** Archivos temporales, borradores personales y documentación fuera del control del repositorio.
- **Limitaciones:** La automatización de validaciones aún no está integrada a la canalización CI; las verificaciones son
  manuales siguiendo este plan.

## Inventario actual

| Ruta | Observaciones | Estado QA |
| --- | --- | --- |
| docs/vision_y_alcance/glossary.md | Glosario oficial alineado con negocio. | Vigente |
| docs/vision_y_alcance/readme.md | Portada estratégica con backlog de visión. | Vigente |
| docs/implementacion/backend/readme.md | Índice técnico inicial del monolito backend. | Revisar enlaces cruzados |
| docs/implementacion/frontend/readme.md | Índice técnico inicial del frontend. | Vigente |
| docs/implementacion/infrastructure/readme.md | Portada y backlog operativo de infraestructura. | Vigente |
| docs/gobernanza/lineamientos_gobernanza.md | Lineamientos vigentes para comités y RACI. | En actualización |
| docs/gobernanza/readme.md | Portada de gobernanza y backlog operativo. | Vigente |
| docs/requisitos/rq_plantilla.md | Plantilla estándar de requisitos. | Vigente |
| docs/requisitos/trazabilidad.md | Registro maestro de trazabilidad. | Actualización semanal |
| docs/requisitos/readme.md | Índice funcional y catálogo de pendientes. | Vigente |
| docs/arquitectura/adr/ADR_2025_001-vagrant-mod-wsgi.md | ADR publicado con convenciones vigentes. | Vigente |
| docs/arquitectura/adr/plantilla_adr.md | Plantilla base para nuevas decisiones. | Vigente |
| docs/arquitectura/lineamientos_codigo.md | Guía de estilo para el monolito modular. | Vigente |
| docs/arquitectura/readme.md | Índice técnico y backlog arquitectónico. | Vigente |
| docs/diseno_detallado/readme.md | Portada de especificaciones por módulo. | Vigente |
| docs/planificacion_y_releases/readme.md | Roadmap y calendario de releases. | Vigente |
| docs/qa/estrategia_qa.md | Línea base de QA y bitácora de pruebas. | Vigente |
| docs/qa/registros/2025_02_16_ejecucion_pytest.md | Registro histórico de ejecución Pytest. | Vigente |
| docs/devops/runbooks/post_create.md | Runbook para aprovisionamiento Vagrant. | Vigente |
| docs/anexos/catalogo_reglas_negocio.md | Catálogo de reglas de negocio del call center. | Vigente |
| docs/plantillas/ | Colección de plantillas reutilizables. | Vigente |
| docs/checklists/ | Checklists operativos y de control. | Vigente |
| docs/solicitudes/scientific_computing_projects/index.md | Índice del espacio corporativo SCP. | Vigente |

## Convenciones de nomenclatura
- Directorios en minúsculas con guiones bajos (`vision_y_alcance`, `planificacion_y_releases`).
- Archivos `readme.md` como portadas con front matter en YAML.
- Referencias relativas entre espacios para compatibilidad con GitHub y MkDocs (`../gobernanza/readme.md`).
- Identificadores de tareas con prefijo `WKF-SDLC-XXX` para mantener trazabilidad.

## Estructura objetivo
```text
docs/
├── vision_y_alcance/
├── gobernanza/
├── requisitos/
├── arquitectura/
├── diseno_detallado/
├── planificacion_y_releases/
├── qa/
├── devops/
├── anexos/
├── plantillas/
├── checklists/
├── backend/
├── frontend/
├── infrastructure/
└── solicitudes/
    └── scientific_computing_projects/
```

## Backlog de sincronización

| Identificador | Actividad | Responsable | Estado | Comentarios |
| --- | --- | --- | --- | --- |
| DOC-SYNC-001 | Completar checklist editorial para `docs/implementacion/backend/`. | QA documental | En progreso | Validar secciones de limitaciones. |
| DOC-SYNC-002 | Publicar reporte de cobertura en `qa/registros/`. | Equipo QA | Pendiente | Depende de métricas de `pytest --cov`. |
| DOC-SYNC-003 | Revisar enlaces relativos para navegación MkDocs. | Equipo documentación | Pendiente | Priorizar antes del primer release. |

## Procedimiento de revisión cruzada
1. QA valida que el documento cumpla con metadatos, secciones obligatorias y trazabilidad (QUÉ).
2. Documentación confirma que el contenido describe el flujo operativo y evidencia reproducible (CÓMO).
3. Producto y arquitectura revisan implicaciones de requisitos y ADR relacionados.
4. Cualquier hallazgo se registra en `qa/registros/` y se actualiza el backlog anterior.

## Próximos pasos sugeridos
1. Completar portadas pendientes en `devops/`, `anexos/`, `plantillas/` y `checklists/`.
2. Crear `bitacora.md` en `devops/` para registrar ejecuciones de runbooks.
3. Migrar artefactos adicionales desde repositorios externos manteniendo la convención de enlaces relativos.
4. Revisar mensualmente que la configuración de `mkdocs.yml` refleje esta estructura.

## Próximas acciones
- [ ] Documentar criterios de salida de despliegue y vincularlos desde `qa/estrategia_qa.md`.
- [ ] Incorporar mediciones de cobertura automática y publicar resumen mensual.
- [ ] Automatizar validaciones de front matter en CI una vez disponible la canalización.

## Integración con MkDocs
- El directorio `docs/` contiene toda la documentación del proyecto organizada por espacios estratégicos.
- Las nuevas páginas deben estructurarse siguiendo las convenciones de nomenclatura establecidas.
- Los anexos y plantillas sirven como material de referencia y apoyo a los espacios principales.

## Evidencias y enlaces relevantes
- [`qa/actividades_garantia_documental.md`](qa/actividades_garantia_documental.md): políticas aplicadas a cada revisión.
- [`qa/registros/2025_11_02_ejecucion_pytest.md`](qa/registros/2025_11_02_ejecucion_pytest.md): ejemplo de bitácora alineada a
  este plan.
- [`registro_decisiones.md`](registro_decisiones.md): catálogo de ADR que deben relacionarse con cambios documentales clave.
