# Glosarios - Backend

Este directorio contiene glosarios de terminos tecnicos y acronimos del backend.

## Proposito

Definir y documentar:
- Terminos tecnicos del dominio
- Acronimos utilizados
- Conceptos especificos del proyecto
- Nomenclatura estandarizada

## Nomenclatura

```
GLOSARIO-dominio.md
```

**Ejemplos:**
- `GLOSARIO-BACKEND.md` (glosario principal)
- `GLOSARIO-PERMISOS.md` (glosario del sistema de permisos)
- `GLOSARIO-ETL.md` (glosario de procesos ETL)

## Contenido del Glosario

### Estructura

```markdown
## [Termino]

**Definicion:** [Definicion clara y concisa]

**Contexto:** [Como se usa en el proyecto]

**Sinonimos:** [Terminos alternativos]

**Ver tambien:** [Referencias cruzadas]

**Ejemplo:** [Ejemplo de uso]
```

## Categorias de Terminos

### Arquitectura
- Middleware
- ViewSet
- Serializer
- Manager
- Signal
- ORM

### Base de Datos
- IVR Database (read-only)
- Analytics Database (write)
- Migration
- QuerySet
- Transaction

### Autenticacion y Permisos
- Token-based auth
- Permission
- Role
- Capability
- Grupo Funcional

### Testing
- Unit Test
- Integration Test
- Fixture
- Factory
- Mock
- Coverage

### DevOps
- CI/CD
- Pipeline
- Deployment
- Rollback
- Health Check

## Acronimos Comunes

| Acronimo | Significado | Contexto |
|----------|-------------|----------|
| DRF | Django REST Framework | Framework de APIs |
| ORM | Object-Relational Mapping | Django ORM |
| TDD | Test-Driven Development | Metodologia de desarrollo |
| API | Application Programming Interface | Interfaces REST |
| ETL | Extract-Transform-Load | Procesos de datos |
| CRUD | Create-Read-Update-Delete | Operaciones basicas |

## Restricciones del Proyecto

**Terminos PROHIBIDOS en el proyecto:**
- Redis (no usado)
- SMTP (no usado)
- Email backend (no implementado)

**Terminos ESPECIFICOS del proyecto:**
- Dual Database: IVR (read) + Analytics (write)
- MySQL Sessions: Sesiones en base de datos
- Permisos Granulares: Sistema de permisos del proyecto

## Actualizacion

El glosario debe actualizarse cuando:
- Se introduce un nuevo termino tecnico
- Se necesita clarificar un concepto existente
- Se detectan ambiguedades en nomenclatura

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend
