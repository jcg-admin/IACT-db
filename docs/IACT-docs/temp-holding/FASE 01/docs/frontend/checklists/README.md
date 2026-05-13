---
id: DOC-CHECKLISTS-FRONTEND
estado: activo
propietario: equipo-frontend
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-FRONTEND-INDEX", "DOC-QA-FRONTEND"]
date: 2025-11-13
---
# Checklists del frontend

Listas de verificación para asegurar la calidad y completitud de tareas de desarrollo frontend.

## Página padre
- [`../README.md`](../README.md)

## Páginas hijas
- [`checklist_desarrollo.md`](checklist_desarrollo.md) - Verificación de desarrollo
- [`checklist_testing.md`](checklist_testing.md) - Verificación de pruebas
- [`checklist_cambios_documentales.md`](checklist_cambios_documentales.md) - Verificación de documentación
- [`checklist_trazabilidad_requisitos.md`](checklist_trazabilidad_requisitos.md) - Verificación de trazabilidad

## Información clave

### Checklists disponibles

#### Desarrollo frontend
- Componentes siguen convenciones de naming
- Props están tipadas correctamente
- Estado local vs global apropiado
- Manejo de efectos secundarios
- Optimización de renders
- Accesibilidad implementada

#### Testing frontend
- Unit tests de componentes
- Integration tests de flujos
- E2E tests de casos críticos
- Tests de accesibilidad
- Performance tests
- Cross-browser testing

#### Code review frontend
- Estructura de componentes clara
- Lógica separada de presentación
- Hooks personalizados reutilizables
- Manejo de errores apropiado
- Loading states implementados
- Estilos responsive

#### Pre-deployment
- Build sin warnings
- Bundle size optimizado
- Assets optimizados
- Environment variables configuradas
- Error boundaries implementados
- Analytics configurado

## Estado de cumplimiento
| Elemento en la base maestra | ¿Existe en repositorio? | Observaciones |
| --- | --- | --- |
| Portada de Checklists frontend | Sí | Este archivo documenta las listas de verificación disponibles |
| Checklist de desarrollo | Pendiente | Crear checklist específico para tareas de desarrollo frontend |
| Checklist de testing | Pendiente | Crear checklist para verificación de pruebas frontend |
| Checklist de deployment | Pendiente | Crear checklist para proceso de despliegue |

## Acciones prioritarias
- [ ] Crear checklist_desarrollo.md con verificaciones de desarrollo
- [ ] Crear checklist_testing.md con verificaciones de QA
- [ ] Crear checklist_deployment.md con verificaciones pre-producción
- [ ] Integrar checklists con proceso de PR review
