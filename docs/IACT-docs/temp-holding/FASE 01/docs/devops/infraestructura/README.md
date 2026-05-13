---
id: DOC-DEVOPS-INFRA
estado: borrador
propietario: equipo-devops
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-ARQ-BACKEND", "DOC-GOB-INDEX"]
---
# DevOps e infraestructura

Centraliza runbooks, bitácoras y lineamientos operativos para mantener los entornos del monolito modular. Conecta las decisiones técnicas con procedimientos repetibles ejecutados por el equipo de Infraestructura.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`contenedores_devcontainer.md`](contenedores_devcontainer.md)
- [`runbooks/`](runbooks/)

## Información clave
### Artefactos disponibles
- Runbooks (`runbooks/`):
  - [`github_copilot_codespaces.md`](runbooks/github_copilot_codespaces.md).
  - [`instalacion_mkdocs.md`](runbooks/instalacion_mkdocs.md).
  - [`post_create.md`](runbooks/post_create.md).
  - [`verificar_servicios.md`](runbooks/verificar_servicios.md).
- Playbooks operativos (`runbooks/playbooks_operativos/`):
  - [`README.md`](runbooks/playbooks_operativos/README.md).
  - [`copilot_codespaces.md`](runbooks/playbooks_operativos/copilot_codespaces.md).
  - [`github_copilot_cli.md`](runbooks/playbooks_operativos/github_copilot_cli.md).
  - [`github_copilot_cli_403_forbidden.md`](runbooks/playbooks_operativos/github_copilot_cli_403_forbidden.md).
- Guías de contenedores (`contenedores_devcontainer.md`).
- Bitácora de ejecución (pendiente, crear `bitacora.md`).

### Integraciones operativas
- Sincroniza despliegues con [`../planificacion_y_releases/README.md`](../planificacion_y_releases/README.md).
- Comparte evidencias de pruebas técnicas con [`../../backend/checklists/checklist_testing.md`](../../backend/checklists/checklist_testing.md).
- Consume lineamientos de [`../../backend/arquitectura/README.md`](../../backend/arquitectura/README.md) para asegurar consistencia técnica.

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio DevOps | Sí | Este archivo replica la jerarquía y metadatos oficiales para Infraestructura. |
| Catálogo de runbooks operativos | Parcial | Directorio [`runbooks/`](runbooks/) con guías iniciales; falta índice maestro. |
| Guía de entornos de desarrollo | Sí | Documentada en [`contenedores_devcontainer.md`](contenedores_devcontainer.md). |
| Bitácora operativa consolidada | No | Debe crearse `bitacora.md` para registrar ejecuciones y SLAs. |

## Acciones prioritarias
- [ ] Documentar procedimientos de recuperación y monitoreo.
- [ ] Crear un índice de runbooks con propietarios y SLAs.
- [ ] Sincronizar evidencias de despliegue con QA y Planificación (`../planificacion_y_releases/README.md`, `../../backend/checklists/checklist_testing.md`).
