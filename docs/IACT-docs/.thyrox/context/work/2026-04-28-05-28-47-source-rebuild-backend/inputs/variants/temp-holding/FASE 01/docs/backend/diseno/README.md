# Diseño del Backend - IACT

Diseño arquitectónico consolidado del backend IACT. Contiene toda la documentación de diseño organizada por dominios: APIs, arquitectura, base de datos, permisos, y diseño detallado.

## Estructura

```
diseno/
 api/ ← Especificaciones OpenAPI y diseño de APIs REST
 openapi_permisos.yaml
 openapi_prioridad_02.yaml
 ejemplos_rest_apis.md
 README.md
 arquitectura/ ← Decisiones arquitectónicas y patrones de diseño
 patrones_arquitectonicos.md
 guia_decision_patrones.md
 permisos_granular.md
 decoradores_y_middleware_permisos.md
 analytics.md, audit.md, authentication.md...
 decisions/ ← ADRs específicos de arquitectura
 README.md
 database/ ← Diseño de base de datos y estrategias de migraciones
 migrations_strategy.md
 plantilla_database_design.md
 diagramas/
 permisos_granular_er.puml
 README.md
 permisos/ ← Sistema de permisos granular
 arquitectura_permisos_granular.md
 ARQUITECTURA_PERMISOS_UML.md
 API-permisos.md
 OPTIMIZACIONES_PERFORMANCE.md
 promptops/ ← Metodologías PromptOps y TDD con AI
 README.md
 detallado/ ← Diseño técnico detallado por módulo
 diseno_tecnico_autenticacion.md
 diagramas/
 actividad/ ← Diagramas de actividad
 casos_de_uso/ ← Diagramas de casos de uso
 database/ ← Diagramas ER
 secuencia/ ← Diagramas de secuencia
 README.md
 diagramas/ ← Diagramas generales UML backend (legacy)
 clases/ ← Modelos Django (ER, Clases)
 secuencia/ ← Flujos backend (Secuencia)
 actividad/ ← Procesos backend (Actividad)
 componentes/ ← Arquitectura componentes
```

## Dominios de Diseño

### 1. API (`api/`)
Especificaciones OpenAPI y documentación de APIs REST del backend.

**Contenido clave:**
- Especificaciones OpenAPI 3.0 (YAML)
- Ejemplos de uso de APIs
- Contratos de servicio REST

**Ver:** [api/README.md](./api/README.md)

### 2. Arquitectura (`arquitectura/`)
Decisiones arquitectónicas, patrones de diseño, y arquitectura por módulo.

**Contenido clave:**
- Catálogo de patrones arquitectónicos
- Guías de decisión de patrones
- Arquitectura de módulos (authentication, permissions, analytics, etc.)
- Lineamientos de código

**Ver:** [arquitectura/README.md](./arquitectura/README.md)

### 3. Base de Datos (`database/`)
Diseño de base de datos, estrategias de migraciones, y diagramas ER.

**Contenido clave:**
- Estrategia de migraciones
- Plantillas de diseño de BD
- Diagramas ER (PlantUML)
- Configuración multi-database (MySQL, PostgreSQL, Cassandra)

**Ver:** [database/README.md](./database/README.md)

### 4. Permisos (`permisos/`)
Sistema de permisos granular - diseño completo, APIs, y optimizaciones.

**Contenido clave:**
- Arquitectura de permisos granular (RBAC + ABAC)
- API de permisos
- Análisis de restricciones y mejoras
- Optimizaciones de performance
- PromptOps: Metodologías de desarrollo con AI

**Ver:** [permisos/README.md](./permisos/README.md)

### 5. Diseño Detallado (`detallado/`)
Especificaciones técnicas detalladas por módulo y diagramas UML completos.

**Contenido clave:**
- Diseños técnicos por módulo (autenticación, etc.)
- 15+ diagramas UML (actividad, secuencia, casos de uso, ER)
- Contratos de servicio entre componentes

**Ver:** [detallado/README.md](./detallado/README.md)

## Gobernanza Multi-nivel

Consulta **primero** la gobernanza global:
- [Diseño Global](../../gobernanza/diseno/)
- [ADR-GOB-004: PlantUML para Diagramas](../../gobernanza/adr/ADR-GOB-004-plantuml-para-diagramas.md)
- [GUIA-GOB-008: Crear Diagramas PlantUML](../../gobernanza/guias/GUIA-GOB-008-crear-diagramas-plantuml.md)
- [GUIA-GOB-009: Documentación UML Completa](../../gobernanza/guias/GUIA-GOB-009-documentacion-uml-completa.md)

## Estado Actual

**Última consolidación:** 2025-11-18 (FASE 2 - TASK-011 a TASK-024)

### Estructura Consolidada

[OK] **Completado:**
- Consolidación de directorios dispersos en estructura unificada bajo `diseno/`
- Creación de 5 dominios principales: api/, arquitectura/, database/, permisos/, detallado/
- READMEs completos en cada dominio
- Migración de archivos y preservación de contenido

### Contenido por Dominio

| Dominio | Archivos | Subdirectorios | Estado |
|---------|----------|----------------|---------|
| **api/** | 3 archivos (2 YAML, 1 MD) | - | [OK] Consolidado |
| **arquitectura/** | 17 archivos MD | decisions/ | [OK] Consolidado |
| **database/** | 2 archivos MD | diagramas/ | [OK] Consolidado |
| **permisos/** | 6 archivos MD | promptops/ | [OK] Consolidado |
| **detallado/** | 2 archivos MD | diagramas/ (4 subdirs) | [OK] Consolidado |

### Diagramas UML

| Tipo Diagrama | Cantidad Actual | Objetivo | Gap |
|---------------|-----------------|----------|-----|
| **Diagramas ER** | 1 (permisos) | ~5 (módulos core) | -4 |
| **Diagramas Secuencia** | 4 | ~20 | -16 |
| **Diagramas Actividad** | 3 | ~10 | -7 |
| **Diagramas Casos de Uso** | 9 | ~15 | -6 |
| **Diagramas Componentes** | 0 | ~3 | -3 |

## Prioridades de Diagramación

### Prioridad CRÍTICA

1. **Diagramas ER Módulos Core**
 - `CLASS-BACK-020-modelo-llamadas.puml`: Módulo llamadas (core negocio)
 - `CLASS-BACK-030-modelo-analytics.puml`: Módulo analytics/métricas
 - `CLASS-BACK-040-modelo-etl.puml`: Módulo ETL (integración IVR)

2. **Diagramas Secuencia UC-CALL**
 - `SEQ-CALL-001-registrar-llamada.puml`: UC-CALL-001 flujo completo
 - `SEQ-CALL-002-atender-llamada.puml`: UC-CALL-002 flujo completo
 - `SEQ-CALL-003-transferir-llamada.puml`: UC-CALL-003 flujo completo

### Prioridad ALTA

3. **Diagramas Componentes Arquitectura**
 - `COMP-BACK-001-arquitectura-general.puml`: Vista 10,000 ft backend
 - `COMP-BACK-002-integracion-ivr.puml`: Integración IVR legacy
 - `COMP-BACK-003-analytics-pipeline.puml`: Pipeline analytics

4. **Diagramas Actividad Workflows**
 - `ACT-ETL-001-pipeline-ivr-analytics.puml`: ETL IVR → Analytics
 - `ACT-BACK-010-generacion-reportes.puml`: Workflow reportes

## Nomenclatura Diagramas

Según ADR-GOB-004:

```
TIPO-DOMINIO-###-descripcion.puml

Tipos Backend:
- CLASS: Modelos Django (ER, Clases)
- SEQ: Flujos backend (Secuencia)
- ACT: Procesos (Actividad)
- COMP: Arquitectura componentes
- STATE: Estados (Máquinas estado)
- PKG: Paquetes (Apps Django)

Ejemplos:
- CLASS-BACK-020-modelo-llamadas.puml
- SEQ-CALL-001-registrar-llamada.puml
- COMP-BACK-001-arquitectura-general.puml
```

## Generación Diagramas

```bash
# Generar todos los diagramas backend
plantuml -tsvg docs/backend/diseno/diagramas/**/*.puml

# Generar un diagrama específico
plantuml -tsvg docs/backend/diseno/diagramas/clases/CLASS-BACK-020-modelo-llamadas.puml
```

## Navegación Rápida

### Inicio Rápido por Caso de Uso

**¿Quieres diseñar una nueva API REST?**
→ Ver [api/README.md](./api/README.md) y [api/ejemplos_rest_apis.md](./api/ejemplos_rest_apis.md)

**¿Necesitas aplicar un patrón de diseño?**
→ Ver [arquitectura/patrones_arquitectonicos.md](./arquitectura/patrones_arquitectonicos.md) y [arquitectura/guia_decision_patrones.md](./arquitectura/guia_decision_patrones.md)

**¿Vas a crear una migración de base de datos?**
→ Ver [database/migrations_strategy.md](./database/migrations_strategy.md)

**¿Implementando permisos granulares?**
→ Ver [permisos/arquitectura_permisos_granular.md](./permisos/arquitectura_permisos_granular.md) y [permisos/API-permisos.md](./permisos/API-permisos.md)

**¿Diseñando un módulo nuevo?**
→ Ver [detallado/README.md](./detallado/README.md) y usar plantillas de diseño

**¿Creando diagramas UML?**
→ Ver [detallado/diagramas/](./detallado/diagramas/) y [GUIA-GOB-008](../../gobernanza/guias/GUIA-GOB-008-crear-diagramas-plantuml.md)

## Referencias

- [Procedimiento: Generar Diagrama PlantUML](../../gobernanza/procedimientos/PROCED-GOB-006-generar-diagrama-uml-plantuml.md)
- [Templates PlantUML](../../gobernanza/templates/)
- [Diseño Global](../../gobernanza/diseno/)

---

**Última actualización:** 2025-11-18
**Maintainer:** Arquitecto Senior + Tech Lead Backend
**Estado:** [OK] Consolidado (FASE 2 completada)
