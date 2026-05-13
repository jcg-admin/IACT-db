---
title: Guía de Navegación Backend
date: 2025-11-18
domain: backend
status: active
author: IACT Team
---

# Guía de Navegación Backend

Esta guía te ayudará a navegar eficientemente la documentación del backend del proyecto IACT.

## Tabla de Contenidos

- [Inicio Rápido](#inicio-rápido)
- [Estructura de Carpetas](#estructura-de-carpetas)
- [Navegación por Rol](#navegación-por-rol)
- [Documentos Clave](#documentos-clave)
- [Flujos de Trabajo Comunes](#flujos-de-trabajo-comunes)
- [Recursos Adicionales](#recursos-adicionales)

---

## Inicio Rápido

### Para Nuevos Desarrolladores

1. **Comienza aquí**: [`README.md`](README.md) - Visión general del backend
2. **Entiende la arquitectura**: [`ARQUITECTURA-MODULOS-COMPLETA.md`](ARQUITECTURA-MODULOS-COMPLETA.md)
3. **Revisa módulos implementados**: [`MODULOS_IMPLEMENTADOS_20251111.md`](MODULOS_IMPLEMENTADOS_20251111.md)
4. **Aprende TDD**: [`TDD_IMPLEMENTACION.md`](TDD_IMPLEMENTACION.md)

### Para Code Review

1. **Arquitectura**: [`arquitectura/`](arquitectura/) - Patrones y diseño
2. **Testing**: [`testing/`](testing/) - Estrategias de prueba
3. **Requisitos**: [`requisitos/`](requisitos/) - Especificaciones de negocio

---

## Estructura de Carpetas

### Carpetas Principales

```
docs/backend/
 README.md # Punto de entrada
 INDEX.md # Índice navegable
 arquitectura/ # Diseño y patrones arquitectónicos
 testing/ # Tests y estrategias de QA
 requisitos/ # Requisitos de negocio y técnicos
 procedimientos/ # Guías operacionales
 sesiones/ # Notas de sesiones de trabajo
 solicitudes/ # Feature requests y cambios
 qa/ # Quality Assurance
 gobernanza/ # Políticas y estándares backend
 deployment/ # Procedimientos de despliegue
 diseno/ # Diseño detallado
 diseno_detallado/ # Especificaciones técnicas
 guias/ # Guías de desarrollo
 plans/ # Planes de implementación
 planificacion_y_releases/ # Roadmap y releases
 checklists/ # Listas de verificación
 tareas/ # Tareas específicas

### Archivos de Documentación Especial

 api/ # Especificaciones OpenAPI
 2025-11-11/ # Sesión histórica específica
```

### Documentos en la Raíz

| Documento | Propósito | Cuándo Usarlo |
|-----------|-----------|---------------|
| `README.md` | Visión general del backend | Primer punto de entrada |
| `INDEX.md` | Índice navegable completo | Buscar documentación específica |
| `ARQUITECTURA-MODULOS-COMPLETA.md` | Arquitectura detallada | Entender diseño del sistema |
| `MODULOS_IMPLEMENTADOS_20251111.md` | Estado de implementación | Verificar qué está implementado |
| `TDD_IMPLEMENTACION.md` | Guía TDD | Desarrollar nuevas features |
| `TODO.md` | Backlog técnico | Ver trabajo pendiente |

---

## Navegación por Rol

### Desarrollador Backend Junior

**Ruta de aprendizaje sugerida:**

1. [`README.md`](README.md) - Introducción
2. [`TDD_IMPLEMENTACION.md`](TDD_IMPLEMENTACION.md) - Metodología de desarrollo
3. [`guias/`](guias/) - Guías prácticas
4. [`testing/`](testing/) - Cómo escribir tests
5. [`requisitos/`](requisitos/) - Entender requisitos de negocio

### Desarrollador Backend Senior

**Documentos clave:**

1. [`ARQUITECTURA-MODULOS-COMPLETA.md`](ARQUITECTURA-MODULOS-COMPLETA.md) - Arquitectura completa
2. [`arquitectura/`](arquitectura/) - Patrones y decisiones
3. [`gobernanza/`](gobernanza/) - Estándares y políticas
4. [`deployment/`](deployment/) - Estrategias de despliegue
5. [`qa/`](qa/) - Estrategia de calidad

### Tech Lead / Arquitecto

**Documentos estratégicos:**

1. [`ARQUITECTURA-MODULOS-COMPLETA.md`](ARQUITECTURA-MODULOS-COMPLETA.md)
2. [`gobernanza/`](gobernanza/) - Decisiones arquitectónicas
3. [`planificacion_y_releases/`](planificacion_y_releases/) - Roadmap
4. [`requisitos/`](requisitos/) - Análisis de requisitos
5. [`TODO.md`](TODO.md) - Backlog técnico

### QA Engineer

**Documentos de testing:**

1. [`testing/`](testing/) - Estrategias de testing
2. [`qa/`](qa/) - Procedimientos de QA
3. [`checklists/`](checklists/) - Listas de verificación
4. [`TDD_IMPLEMENTACION.md`](TDD_IMPLEMENTACION.md) - Enfoque TDD
5. Archivos `TASK-*` - Tests específicos por tarea

### DevOps / SRE

**Documentos operacionales:**

1. [`deployment/`](deployment/) - Procedimientos de despliegue
2. [`procedimientos/`](procedimientos/) - Runbooks
3. [`qa/`](qa/) - Gates de calidad
4. Archivos `TASK-*` relacionados con infraestructura

---

## Documentos Clave

### Arquitectura

| Documento | Descripción |
|-----------|-------------|
| [`ARQUITECTURA-MODULOS-COMPLETA.md`](ARQUITECTURA-MODULOS-COMPLETA.md) | Arquitectura completa del sistema |
| [`arquitectura/`](arquitectura/) | Patrones de diseño y decisiones |
| [`diseno/`](diseno/) | Diseño de alto nivel |
| [`diseno_detallado/`](diseno_detallado/) | Especificaciones técnicas detalladas |

### Implementación

| Documento | Descripción |
|-----------|-------------|
| [`MODULOS_IMPLEMENTADOS_20251111.md`](MODULOS_IMPLEMENTADOS_20251111.md) | Estado actual de implementación |
| [`TDD_IMPLEMENTACION.md`](TDD_IMPLEMENTACION.md) | Guía TDD completa |
| [`SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md`](SDLC_COMPLETE_RUN_TDD_PROMPTING_TECHNIQUES.md) | SDLC con técnicas de prompting |

### Testing

| Documento | Descripción |
|-----------|-------------|
| [`testing/`](testing/) | Estrategias y casos de prueba |
| [`qa/`](qa/) | Procedimientos de QA |
| [`REPORTE_EJECUCION_TASK_001_004.md`](REPORTE_EJECUCION_TASK_001_004.md) | Reporte de ejecución de tests |

### API

| Documento | Descripción |
|-----------|-------------|
| [`api/openapi_permisos.yaml`](api/openapi_permisos.yaml) | Especificación OpenAPI de permisos |
| [`api/openapi_prioridad_02.yaml`](api/openapi_prioridad_02.yaml) | API Prioridad 02 |
| [`GUIA_USO_PRIORIDAD_02.md`](GUIA_USO_PRIORIDAD_02.md) | Guía de uso API Prioridad 02 |

### Casos de Uso

Archivos `UC-PERM-*` documentan casos de uso de permisos:

- [`UC-PERM-001_asignar_grupo_a_usuario.md`](UC-PERM-001_asignar_grupo_a_usuario.md)
- [`UC-PERM-002_revocar_grupo_a_usuario.md`](UC-PERM-002_revocar_grupo_a_usuario.md)
- [`UC-PERM-003_conceder_permiso_excepcional.md`](UC-PERM-003_conceder_permiso_excepcional.md)
- Y más...

### Tareas (TASK-*)

Archivos `TASK-*` documentan tareas específicas del proyecto:

- [`TASK-002-validar_restricciones_criticas.md`](TASK-002-validar_restricciones_criticas.md)
- [`TASK-003-verificar_sessionengine_en_settings.md`](TASK-003-verificar_sessionengine_en_settings.md)
- [`TASK-005-sistema_de_metrics_interno_mysql.md`](TASK-005-sistema_de_metrics_interno_mysql.md)
- Y más...

---

## Flujos de Trabajo Comunes

### 1. Implementar una Nueva Feature

```
1. Revisar requisitos en requisitos/
2. Consultar arquitectura en ARQUITECTURA-MODULOS-COMPLETA.md
3. Seguir TDD según TDD_IMPLEMENTACION.md
4. Escribir tests en testing/
5. Documentar en la carpeta correspondiente
6. Actualizar TODO.md si es necesario
```

### 2. Code Review

```
1. Verificar cumplimiento con gobernanza/
2. Revisar tests en testing/
3. Validar contra requisitos/
4. Verificar patrones en arquitectura/
5. Usar checklists/ para validación
```

### 3. Bug Fix

```
1. Identificar módulo afectado en MODULOS_IMPLEMENTADOS_20251111.md
2. Revisar tests existentes en testing/
3. Consultar arquitectura en ARQUITECTURA-MODULOS-COMPLETA.md
4. Aplicar fix siguiendo TDD_IMPLEMENTACION.md
5. Actualizar documentación si es necesario
```

### 4. Deploy a Producción

```
1. Revisar deployment/
2. Ejecutar checklists/
3. Verificar qa/
4. Seguir procedimientos en procedimientos/
5. Documentar en sesiones/
```

### 5. Análisis de Requisitos

```
1. Documentar en requisitos/
2. Crear ADR si hay decisiones arquitectónicas
3. Actualizar ARQUITECTURA-MODULOS-COMPLETA.md
4. Agregar a planificacion_y_releases/
5. Actualizar TODO.md
```

---

## Recursos Adicionales

### Documentación Externa

- **Repositorio principal**: `/home/user/IACT/`
- **README principal**: [`../../README.md`](../../README.md)
- **Índice general**: [`../INDEX.md`](../INDEX.md)
- **Documentación de infraestructura**: [`../infraestructura/`](../infraestructura/)
- **Documentación de operaciones**: [`../operaciones/`](../operaciones/)

### Gobernanza General

- **Guía de estilo**: [`../gobernanza/GUIA_ESTILO.md`](../gobernanza/GUIA_ESTILO.md)
- **ADRs generales**: [`../gobernanza/adr/`](../gobernanza/adr/)
- **Changelog general**: [`../CHANGELOG.md`](../CHANGELOG.md)

### Scripts y Herramientas

- **Scripts de testing**: `../../scripts/run_all_tests.sh`
- **Validaciones**: `../../scripts/validation/`
- **CI/CD**: `../../scripts/ci/`

---

## Convenciones

### Nomenclatura

- Carpetas: `snake_case`
- Archivos: `snake_case.md` o `UPPERCASE.md`
- Casos de uso: `UC-{MODULO}-{NUM}_{descripcion}.md`
- Tareas: `TASK-{NUM}-{descripcion}.md`

### Metadatos YAML

Todos los documentos deben incluir frontmatter YAML:

```yaml
---
title: Título del Documento
date: YYYY-MM-DD
domain: backend
status: active|draft|deprecated
author: Nombre
---
```

### Enlaces

- Usar rutas relativas para enlaces internos
- Verificar que los enlaces funcionen antes de commit
- Usar formato markdown: `[texto](ruta/archivo.md)`

---

## Mantenimiento de esta Guía

Esta guía debe actualizarse cuando:

- Se agreguen nuevas carpetas importantes
- Cambien los flujos de trabajo principales
- Se creen nuevos tipos de documentos
- Se reorganice la estructura

**Última actualización**: 2025-11-18

**Mantenedor**: IACT Backend Team

---

## Ayuda y Soporte

Si tienes dudas sobre dónde encontrar o colocar documentación:

1. Consulta el [`INDEX.md`](INDEX.md)
2. Revisa esta guía de navegación
3. Pregunta al equipo en el canal de backend
4. Crea un issue en el repositorio

Para contribuir a la documentación, consulta [`../../CONTRIBUTING.md`](../../CONTRIBUTING.md)
