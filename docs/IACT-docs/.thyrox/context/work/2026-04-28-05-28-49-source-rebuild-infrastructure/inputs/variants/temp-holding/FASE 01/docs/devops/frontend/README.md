---
id: DOC-DEVOPS-FRONTEND
estado: activo
propietario: equipo-frontend
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-DEVOPS-INFRA", "DOC-ARQ-FRONTEND"]
date: 2025-11-13
---
# DevOps del frontend

Procedimientos operativos específicos del frontend que complementan los runbooks de Infraestructura. Aquí se documentan tareas recurrentes que afectan a la aplicación web, build process y despliegues del frontend.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`runbooks/`](runbooks/) - Procedimientos operativos específicos del frontend

## Información clave

### Artefactos disponibles
- Build y despliegue de aplicación web
- Gestión de assets estáticos
- Configuración de entornos de desarrollo

### Integraciones operativas
- Coordina despliegues con [`../../infrastructure/planificacion_y_releases/README.md`](../../infrastructure/planificacion_y_releases/README.md)
- Requiere lineamientos de build publicados en [`../../infrastructure/devops/README.md`](../../infrastructure/devops/README.md)
- Reporta métricas de performance a [`../qa/README.md`](../qa/README.md) para garantizar calidad

### Procesos clave
- Build y optimización de bundle
- Despliegue a entornos de staging y producción
- Gestión de cache y CDN
- Monitoreo de métricas de rendimiento frontend

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada del espacio DevOps del frontend | Sí | Este archivo documenta el alcance y las dependencias clave con Infraestructura |
| Runbooks del frontend | Pendiente | Deben crearse procedimientos para build, despliegue y troubleshooting |
| Bitácora de despliegues | Pendiente | Debe generarse `runbooks/bitacora.md` para registrar despliegues |

## Acciones prioritarias
- [ ] Crear runbook de proceso de build y optimización
- [ ] Documentar proceso de despliegue a producción
- [ ] Integrar métricas de performance con tablero de releases
- [ ] Establecer procedimiento de rollback de despliegues
