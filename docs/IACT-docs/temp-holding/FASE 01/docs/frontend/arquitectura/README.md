---
id: DOC-ARQ-FRONTEND
estado: activo
propietario: equipo-frontend
ultima_actualizacion: 2025-11-09
relacionados: ["DOC-FRONTEND-INDEX", "DOC-ARQ-INFRA"]
date: 2025-11-13
---
# Arquitectura del frontend

Decisiones arquitectónicas, patrones de diseño y lineamientos técnicos específicos de la aplicación frontend.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`adr/`](adr/) - Architecture Decision Records específicos del frontend
- [`lineamientos_codigo.md`](lineamientos_codigo.md) - Guías de desarrollo frontend
- [`estrategia_integracion_backend.md`](estrategia_integracion_backend.md) - Plan de integración y fallback frente a brechas del backend
- [`TODO.md`](TODO.md) - Backlog arquitectónico para absorber brechas del backend
- [`validacion_callcentersite_api.md`](validacion_callcentersite_api.md) - Validación del backend real frente a los lineamientos y mocks del frontend
- [`ejemplos-ui-design.md`](ejemplos-ui-design.md) - Prompt engineering avanzado para diseño de UI
- [`shared_webpack_configs.md`](shared_webpack_configs.md) - Guía de configuraciones Webpack compartidas para microfrontends single-spa
- [`microfrontends_canvas.md`](microfrontends_canvas.md) - Canvas de decisión para seleccionar arquitecturas de microfrontends

## Información clave

### Stack tecnológico
- Framework principal y versión
- Librerías de gestión de estado
- Herramientas de build y bundling
- Testing frameworks

### Patrones arquitectónicos
- Organización de componentes
- Gestión de estado global
- Enrutamiento y navegación
- Comunicación con APIs

### Principios de diseño
- Component composition
- State management patterns
- Performance optimization
- Accesibilidad (a11y)
- Responsive design

## Actualizaciones recientes
- 2025-11-09: Se habilitó la capa `ui/src/services/*` con `AppConfigService`, `PermissionsService` y `CallsService` incluyendo fallback automático a mocks y pruebas de resiliencia.
- 2025-11-09: Se añadió banner global de datos simulados y menú dinámico derivado de permisos normalizados.

## Decisiones arquitectónicas

### ADRs disponibles
- [ADR-0001 - Capa de servicios resilientes con contratos y telemetria](adr/ADR_2025_020-servicios-resilientes.md)
- [ADR-0002 - Arquitectura de microfrontends basada en App Shell unificado](adr/ADR_2025_021-arquitectura-microfrontends.md) _(rechazado: se mantiene el monolito modular descrito en [ADR_011](../../adr/ADR_2025_015-frontend-modular-monolith.md) y el frontend continúa pospuesto según [ADR_2025_009](../../adr/ADR_2025_009-frontend-postponement.md))_

### Lineamientos de código
- Estructura de directorios
- Convenciones de naming
- Gestión de estilos (CSS/SCSS/CSS-in-JS)
- Testing strategies

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada de Arquitectura frontend | Sí | Este archivo documenta decisiones y lineamientos arquitectónicos |
| ADRs de frontend | Parcial | ADR-0001 y ADR-0002 publicados; faltan decisiones sobre state management y testing |
| Lineamientos de código | Pendiente | Crear documento con guías específicas de desarrollo frontend |

## Acciones prioritarias
- [x] Documentar ADR de selección de framework
- [ ] Crear lineamientos de código frontend
- [ ] Definir patrones de componentes reutilizables
- [ ] Establecer estrategia de testing frontend
