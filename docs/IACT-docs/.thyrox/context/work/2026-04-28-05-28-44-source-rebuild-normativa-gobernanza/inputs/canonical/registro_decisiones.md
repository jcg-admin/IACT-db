---
id: DOC-GOB-REGISTRO
estado: activo
propietario: pmo
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-GOB-INDEX"]
---
# Registro de decisiones de documentación

## 2025-02-17 - Normalización de nombres
- Se reemplazaron guiones medios por guiones bajos en directorios y archivos dentro de `docs/`.
- Se actualizaron enlaces internos en los principales documentos.
- Se habilitaron plantillas y checklists en carpetas dedicadas.

## 2025-02-18 - Consolidación en `docs/spaces`
- Se trasladó toda la documentación principal a `docs/spaces/` eliminando la numeración heredada.
- Se añadieron portadas (`readme.md`) para DevOps, anexos, plantillas y checklists.
- Se creó la configuración `mkdocs.yml` utilizando `docs/spaces` como `docs_dir`.

## 2025-11-02 - Eliminación de carpeta `docs/spaces`
- Se distribuyó correctamente todo el contenido de `docs/spaces/` a la estructura principal `docs/`.
- Archivos únicos identificados y movidos:
  - Checklists: `checklist_desarrollo.md`, `checklist_testing.md`, `checklist_trazabilidad_requisitos.md`, `checklist_cambios_documentales.md`
  - Gobernanza: `lineamientos_gobernanza.md`, `plan_general.md`, `registro_decisiones.md`, `documentacion_corporativa.md`
  - Solicitudes: `scientific_computing_projects/` (movido a `docs/solicitudes/`)
- Se actualizaron todas las referencias de `docs/spaces/` a `docs/` en archivos movidos.
- Estructura final consolidada en `docs/` con subcarpetas por dominio funcional.
- Se eliminó la carpeta redundante `docs/spaces/` para simplificar la navegación.

## Próximos pasos
- Revisar nuevas contribuciones para validar que respetan la convención.
- Completar anexos con ejemplos reales a medida que estén disponibles.
- Registrar futuras decisiones en este mismo archivo para mantener trazabilidad.
