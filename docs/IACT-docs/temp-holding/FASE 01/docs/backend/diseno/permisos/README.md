---
title: Diseño Sistema de Permisos Granular - Backend IACT
date: 2025-11-18
domain: backend
status: active
---

# Diseño Sistema de Permisos Granular - Backend IACT

**Propósito**: Documentación completa del diseño del sistema de permisos granular
**Última actualización**: 2025-11-18

## Contenido

Este directorio contiene:

- **Arquitectura de Permisos**: Diseño del sistema de permisos granular
- **API de Permisos**: Especificación de endpoints y contratos
- **Análisis de Restricciones**: Evaluación de limitaciones y mejoras
- **Optimizaciones**: Estrategias de performance y mejoras
- **PromptOps**: Metodologías de desarrollo con AI

## Archivos

### Documentos de Arquitectura

- `arquitectura_permisos_granular.md`: Arquitectura general del sistema de permisos
- `ARQUITECTURA_PERMISOS_UML.md`: Diagramas UML y diseño detallado
- `API-permisos.md`: Especificación de API para permisos

### Análisis y Mejoras

- `ANALISIS_RESTRICCIONES_VS_MEJORAS.md`: Análisis de restricciones y propuestas de mejora
- `MEJORAS_MIDDLEWARE_PROPUESTAS.md`: Propuestas de mejora para middleware de permisos
- `OPTIMIZACIONES_PERFORMANCE.md`: Estrategias de optimización de rendimiento

### PromptOps

El subdirectorio `promptops/` contiene metodologías y técnicas de desarrollo asistido por AI:

- **Técnicas de Prompting**: Métodos avanzados para interacción con AI
- **TDD con AI**: Implementación de Test-Driven Development con agentes AI
- **Gates de Calidad**: Validaciones automáticas (route_lint, etc.)
- **Metadocumentación**: Documentación sobre el proceso de desarrollo

Ver [promptops/README.md](./promptops/README.md) para más detalles.

## Sistema de Permisos Granular

### Características Principales

1. **RBAC (Role-Based Access Control)**
 - Grupos de permisos jerárquicos
 - Capacidades (capabilities) granulares
 - Herencia de permisos

2. **ABAC (Attribute-Based Access Control)**
 - Permisos basados en atributos de usuario
 - Contexto de ejecución
 - Políticas dinámicas

3. **Permisos Excepcionales**
 - Concesión temporal de permisos
 - Revocación automática
 - Auditoría completa

### Componentes

```
Permisos/
 Models
 Group (Grupo de permisos)
 Capability (Capacidad/permiso)
 UserGroupAssignment (Asignación usuario-grupo)
 ExceptionalPermission (Permiso excepcional)
 Middleware
 PermissionMiddleware (Verificación de permisos)
 AuditMiddleware (Auditoría de accesos)
 Decorators
 @require_permission (Requerir permiso)
 @require_any_permission (Requerir algún permiso)
 Services
 PermissionChecker (Verificación de permisos)
 PermissionManager (Gestión de permisos)
 MenuGenerator (Generación de menú dinámico)
```

## Casos de Uso

Los casos de uso principales están documentados en:

- UC-PERM-001: Asignar grupo a usuario
- UC-PERM-002: Revocar grupo a usuario
- UC-PERM-003: Conceder permiso excepcional
- UC-PERM-004: Revocar permiso excepcional
- UC-PERM-005: Crear grupo de permisos
- UC-PERM-006: Asignar capacidades a grupo
- UC-PERM-007: Verificar permiso de usuario
- UC-PERM-008: Generar menú dinámico
- UC-PERM-010: Consultar auditoría

Ubicación: `/home/user/IACT/docs/backend/UC-PERM-*.md`

## API de Permisos

### Endpoints Principales

```
POST /api/v1/permissions/assign-group/ # Asignar grupo
POST /api/v1/permissions/revoke-group/ # Revocar grupo
POST /api/v1/permissions/grant-exceptional/ # Conceder excepcional
POST /api/v1/permissions/revoke-exceptional/ # Revocar excepcional
GET /api/v1/permissions/check/ # Verificar permiso
GET /api/v1/permissions/menu/ # Obtener menú dinámico
GET /api/v1/permissions/audit/ # Consultar auditoría
```

Ver `API-permisos.md` para especificación completa.

## Optimizaciones de Performance

### Estrategias Implementadas

1. **Caching de Permisos**
 - Cache en memoria de permisos frecuentes
 - Invalidación selectiva
 - TTL configurable

2. **Lazy Loading**
 - Carga diferida de grupos
 - Prefetch de relaciones
 - Select related optimizado

3. **Índices de Base de Datos**
 - Índices compuestos en lookups frecuentes
 - Índices parciales para consultas específicas

Ver `OPTIMIZACIONES_PERFORMANCE.md` para detalles.

## Restricciones y Mejoras

### Restricciones Actuales

- Limitaciones de escalabilidad con alto volumen
- Complejidad en permisos jerárquicos profundos
- Performance en verificaciones complejas

### Mejoras Propuestas

- Implementación de permission inheritance cache
- Optimización de queries con materialized views
- Refactoring de middleware para mejor performance

Ver `ANALISIS_RESTRICCIONES_VS_MEJORAS.md` y `MEJORAS_MIDDLEWARE_PROPUESTAS.md`.

## Gobernanza

Consulta **primero** la gobernanza global:
- [Diseño Global](../../../gobernanza/diseno/)
- [ADRs Backend](../../gobernanza/adr/)
- [Guías de Seguridad](../../../gobernanza/guias/)

## Testing

```bash
# Ejecutar tests de permisos
pytest api/tests/permissions/

# Con coverage
pytest --cov=api.permissions api/tests/permissions/

# Tests de performance
pytest api/tests/permissions/test_performance.py -v
```

## Referencias

- [Django Permissions](https://docs.djangoproject.com/en/5.0/topics/auth/default/#permissions-and-authorization)
- [RBAC Pattern](https://en.wikipedia.org/wiki/Role-based_access_control)
- [ABAC Pattern](https://en.wikipedia.org/wiki/Attribute-based_access_control)
- [OWASP Access Control](https://owasp.org/www-project-proactive-controls/v3/en/c7-enforce-access-controls)

## Ownership

Maintainer: Arquitecto de Seguridad + Tech Lead
Review: Security Team + Arquitecto Senior
