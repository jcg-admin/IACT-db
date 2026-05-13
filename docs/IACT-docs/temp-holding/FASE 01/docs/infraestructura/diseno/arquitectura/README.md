---
id: DOC-ARQ-INFRA
estado: borrador
propietario: equipo-infraestructura
ultima_actualizacion: 2025-02-18
relacionados: ["ADR-2025-001", "DOC-DEVOPS-INFRA"]
---
# Arquitectura de infraestructura

Inventario de decisiones y topologías que sostienen la plataforma de infraestructura. Este espacio aloja los ADR, configuraciones de referencia y dependencias externas que habilitan el monolito backend.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`adr/`](adr/)
- [`devcontainer-host-vagrant.md`](devcontainer-host-vagrant.md) – canvas de arquitectura para operar DevContainers y runners CI/CD en una VM Vagrant cuando el workstation no puede instalar Docker.
- [`devcontainer-host-vagrant-pipeline.md`](devcontainer-host-vagrant-pipeline.md) – pipeline CI/CD basado en la imagen de DevContainer ejecutada dentro del host Vagrant sin Docker en el workstation.

## Información clave
- Los ADR documentan lineamientos como el uso de Vagrant y Apache con mod_wsgi (`adr/adr_2025_001_vagrant_mod_wsgi.md`).
- Mantiene enlaces hacia scripts y configuraciones ubicadas en `infrastructure/` dentro del repositorio.
- Sirve como punto de coordinación con [`../devops/README.md`](../devops/README.md) para el ciclo de vida de ambientes.

## Acciones prioritarias
- [ ] Publicar inventario de diagramas de red y topologías de despliegue.
- [ ] Registrar dependencias externas (certificados, VPN, proveedores).
- [ ] Alinear métricas de disponibilidad con Gobernanza (`../gobernanza/README.md`).
