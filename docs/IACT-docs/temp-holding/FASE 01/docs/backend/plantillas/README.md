# Catálogo de Plantillas - Backend

Repositorio centralizado de plantillas para desarrollo, documentación, CI/CD e infraestructura del backend.

---

## Propósito

Proveer templates estandarizados para:
- Architecture Decision Records (ADR)
- Procedimientos operacionales
- Especificaciones técnicas
- Diseño de APIs
- Diseño de base de datos
- Planes de desarrollo
- Documentos TDD
- Jobs ETL

---

## Índice de Plantillas

### Documentación
| Plantilla | Propósito | Cuándo Usar |
|-----------|-----------|-------------|
| [`plantilla-adr-backend.md`](./documentacion/plantilla-adr-backend.md) | Architecture Decision Records | Al tomar decisiones arquitectónicas importantes |
| [`plantilla-procedimiento-backend.md`](./documentacion/plantilla-procedimiento-backend.md) | Procedimientos operacionales | Al crear runbooks de deployment, rollback, maintenance |
| [`plantilla_spec.md`](./documentacion/plantilla_spec.md) | Especificaciones técnicas | Al especificar features o módulos nuevos |
| [`plantilla_plan.md`](./documentacion/plantilla_plan.md) | Planes de implementación | Al planificar desarrollo de features |
| [`plantilla_tdd.md`](./documentacion/plantilla_tdd.md) | Tests con TDD | Al crear tests siguiendo TDD |
| [`plantilla_api_reference.md`](./documentacion/plantilla_api_reference.md) | Documentación de APIs | Al documentar endpoints REST/GraphQL |
| [`plantilla_etl_job.md`](./documentacion/plantilla_etl_job.md) | Jobs ETL | Al crear procesos ETL/batch |

### Código
Próximamente: Plantillas de código Python/Django

### CI/CD
Próximamente: Plantillas de workflows GitHub Actions

### Infraestructura
Próximamente: Dockerfiles, docker-compose, etc.

---

## Cómo Usar las Plantillas

### Paso 1: Seleccionar Plantilla
Identifica en la tabla de arriba cuál plantilla necesitas.

### Paso 2: Copiar Plantilla
```bash
# Ejemplo: crear nuevo ADR
cp docs/backend/plantillas/documentacion/plantilla-adr-backend.md \
 docs/backend/arquitectura/decisions/ADR-BACKEND-042-nueva-decision.md

# Ejemplo: crear nuevo procedimiento
cp docs/backend/plantillas/documentacion/plantilla-procedimiento-backend.md \
 docs/backend/procedures/PROC-BACKEND-010-deployment-produccion.md
```

### Paso 3: Completar Plantilla
Abre el archivo copiado y reemplaza:
- `[PLACEHOLDER]` con valores reales
- `XXX` con números/IDs correspondientes
- `YYYY-MM-DD` con fechas actuales
- Secciones de ejemplo con contenido real

### Paso 4: Validar Completitud
Verifica que:
- [ ] No quedan placeholders sin reemplazar
- [ ] Todas las secciones obligatorias están completas
- [ ] Formato markdown es correcto
- [ ] Enlaces y referencias son válidos
- [ ] Frontmatter YAML completo

### Paso 5: Someter a Revisión
- Crear PR con nuevo documento
- Solicitar revisión de al menos 1 peer
- Incorporar feedback
- Mergear

---

## Nomenclatura

### Archivos de Plantilla
- **Documentación:** `plantilla-{tipo}-backend.md` o `plantilla_{tipo}.md`
- **Código:** `template-{componente}.{ext}`
- **Infraestructura:** `template-{recurso}.{ext}`
- **CI/CD:** `template-{tipo}.yml`

### Archivos Creados desde Plantillas
- **ADR:** `ADR-BACKEND-{numero}-{titulo-kebab-case}.md`
- **Procedimiento:** `PROC-BACKEND-{numero}-{titulo}.md`
- **Spec:** `SPEC-{modulo}-{feature}.md`
- **Plan:** `PLAN-{modulo}-{feature}.md`

---

## Estructura de Carpetas

```
docs/backend/plantillas/
 README.md (este archivo)
 documentacion/
 README.md
 plantilla-adr-backend.md
 plantilla-procedimiento-backend.md
 plantilla_spec.md
 plantilla_plan.md
 plantilla_tdd.md
 plantilla_api_reference.md
 plantilla_etl_job.md
 codigo/
 README.md
 cicd/
 README.md
 infraestructura/
 README.md
 colaboracion/
 README.md
```

---

## Metadatos Requeridos

Todas las plantillas deben incluir frontmatter YAML:

```yaml
---
id: PLANTILLA-XXX
tipo: plantilla
categoria: [adr|procedimiento|diseño|testing]
titulo: Nombre de la Plantilla
version: 1.0.0
fecha_creacion: YYYY-MM-DD
responsable: Equipo Backend
---
```

---

## Restricciones del Proyecto

Las plantillas backend deben considerar:
- **Restricciones críticas:** No usar Redis ni SMTP (ver restricciones del proyecto)
- **Configuración de base de datos:** Sistema dual PostgreSQL/MariaDB
- **Sistema de permisos:** Permisos granulares sin roles jerárquicos
- **Autenticación:** Sistema de sesiones basado en base de datos
- **Testing:** TDD y cobertura mínima 80%

---

## Contribuir Nuevas Plantillas

### Criterios de Aceptación
Una plantilla debe:
- [ ] Resolver necesidad recurrente del equipo
- [ ] Incluir comentarios explicativos
- [ ] Tener ejemplos de uso
- [ ] Seguir convenciones del proyecto
- [ ] Ser revisada por al menos 2 personas
- [ ] Estar documentada en este README

### Proceso
1. Crear plantilla en carpeta correspondiente
2. Añadir entrada en tabla de índice
3. Crear PR con título "feat(plantillas): añadir template-{nombre}"
4. Solicitar revisión de Tech Lead
5. Mergear tras aprobación

---

## Referencias

- [Gobernanza - Plantillas](../../../gobernanza/plantillas/README.md)
- [ADRs Backend](../arquitectura/decisions/README.md)
- [Procedimientos Backend](../procedures/README.md)
- [Guía de Estilo](../../../gobernanza/GUIA_ESTILO.md)

---

## Contacto

**Maintainer:** Tech Lead Backend
**Slack:** #backend-docs
**Issues:** Reportar en GitHub con label `plantillas`

---

**Última actualización:** 2025-11-18
**Versión:** 1.0.0
**Responsable:** Equipo Backend
