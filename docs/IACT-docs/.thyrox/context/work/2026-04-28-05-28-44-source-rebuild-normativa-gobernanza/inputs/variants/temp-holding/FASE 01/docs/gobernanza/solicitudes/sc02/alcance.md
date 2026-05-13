---
id: DOC-SOL-SC02-ALCANCE
estado: en_progreso
propietario: equipo-backend
ultima_actualizacion: 2025-11-04
relacionados: ["DOC-SOL-SC02", "DOC-BACKEND-INDEX"]
---
# SC02 - Alcance de la documentación API

## Resumen ejecutivo

Esta solicitud busca crear documentación técnica completa para el backend Django del proyecto IACT ubicado en `api/callcentersite/`. Actualmente, el proyecto carece de documentación formal sobre su arquitectura interna, modelos de datos, servicios y APIs.

## Objetivos

### Objetivo general
Documentar completamente la carpeta `api/` para facilitar el desarrollo, mantenimiento y onboarding de nuevos miembros del equipo.

### Objetivos específicos

1. **Documentar arquitectura de aplicaciones**
   - Describir cada app Django y su responsabilidad
   - Identificar dependencias entre apps
   - Documentar patrones de diseño utilizados

2. **Documentar modelos de datos**
   - Describir cada modelo Django
   - Documentar relaciones entre modelos
   - Crear diagramas ER
   - Documentar database router y multi-database setup

3. **Documentar servicios y lógica de negocio**
   - Describir servicios en cada app
   - Documentar flujos de negocio principales
   - Identificar puntos de integración

4. **Documentar APIs**
   - Documentar endpoints existentes
   - Preparar documentación para APIs futuras (DRF)
   - Documentar autenticación y permisos

5. **Crear guías de desarrollo**
   - Convenciones de código específicas del proyecto
   - Guías para agregar nuevas apps
   - Guías para trabajar con ETL
   - Guías para testing

## Alcance incluido

### Aplicaciones Django a documentar

1. **analytics**
   - Modelos de métricas y KPIs
   - Servicios de agregación
   - Generadores de reportes analíticos

2. **etl**
   - Extractores de datos (IVR → PostgreSQL)
   - Transformadores de datos
   - Loaders y batch processing
   - Scheduler y jobs
   - Comandos de management

3. **reports**
   - Modelos de reportes
   - Generadores (PDF, Excel, CSV)
   - Templates y formatos

4. **dashboard**
   - Widgets y componentes
   - Servicios de dashboard
   - Vistas y URLs

5. **authentication**
   - Modelos de autenticación
   - Servicios de autenticación
   - Integración con Django auth

6. **users**
   - Modelo de usuarios extendido
   - Servicios de gestión de usuarios
   - Permisos y roles

7. **audit**
   - Sistema de auditoría
   - Decoradores de auditoría
   - Modelos de logs
   - Servicios de auditoría

8. **ivr_legacy**
   - Adaptadores para sistema IVR
   - Modelos read-only MariaDB
   - Servicios de integración

9. **notifications**
   - Sistema de notificaciones
   - Modelos de notificaciones
   - Servicios de envío

10. **common**
    - Utilidades compartidas
    - Permisos base
    - Modelos abstractos
    - Helpers y utils

### Componentes de infraestructura

1. **Database Router**
   - Lógica de enrutamiento multi-database
   - Conexión a PostgreSQL (analytics)
   - Conexión a MariaDB (IVR read-only)

2. **Middleware**
   - Session security middleware
   - Otros middlewares personalizados

3. **Settings**
   - Configuración por ambiente (development, testing, production)
   - Variables de entorno
   - Configuración de databases

4. **Tests**
   - Estructura de tests
   - Fixtures y conftest
   - Tests de infraestructura
   - Tests por app

## Alcance excluido

- Documentación de frontend (fuera del alcance actual)
- Documentación de infraestructura de despliegue (cubierta en docs/implementacion/infrastructure/)
- Documentación de bases de datos IVR heredadas (sistema externo)
- Manuales de usuario final
- Documentación de herramientas third-party (Django, DRF, etc.)

## Entregables

### Documentos principales

1. **docs/implementacion/backend/arquitectura/arquitectura_apps.md**
   - Visión general de todas las apps
   - Diagrama de dependencias
   - Patrones arquitectónicos

2. **docs/implementacion/backend/diseno_detallado/modelos_datos.md**
   - Catálogo completo de modelos
   - Diagramas ER
   - Documentación del database router

3. **docs/implementacion/backend/diseno_detallado/api_analytics.md**
   - Documentación completa app analytics

4. **docs/implementacion/backend/diseno_detallado/api_etl.md**
   - Documentación completa app ETL
   - Flujos de procesamiento
   - Comandos disponibles

5. **docs/implementacion/backend/diseno_detallado/api_reports.md**
   - Documentación completa app reports
   - Formatos soportados
   - Templates disponibles

6. **docs/implementacion/backend/diseno_detallado/api_dashboard.md**
   - Documentación completa app dashboard

7. **docs/implementacion/backend/diseno_detallado/api_authentication.md**
   - Documentación completa app authentication
   - Flujos de autenticación

8. **docs/implementacion/backend/diseno_detallado/api_users.md**
   - Documentación completa app users
   - Sistema de permisos

9. **docs/implementacion/backend/diseno_detallado/api_audit.md**
   - Documentación completa app audit
   - Uso de decoradores

10. **docs/implementacion/backend/diseno_detallado/api_ivr_legacy.md**
    - Documentación completa app ivr_legacy
    - Adaptadores disponibles

11. **docs/implementacion/backend/diseno_detallado/api_notifications.md**
    - Documentación completa app notifications

12. **docs/implementacion/backend/diseno_detallado/api_common.md**
    - Documentación completa app common
    - Utilidades disponibles

### Guías complementarias

1. **docs/implementacion/backend/arquitectura/guia_desarrollo.md**
   - Convenciones del proyecto
   - Cómo agregar nuevas apps
   - Cómo trabajar con multi-database

2. **docs/implementacion/backend/arquitectura/guia_etl.md**
   - Cómo crear nuevos extractors
   - Cómo crear nuevos transformers
   - Cómo programar jobs

3. **docs/implementacion/backend/arquitectura/guia_testing.md**
   - Estrategias de testing por capa
   - Uso de fixtures
   - Tests de integración

## Criterios de aceptación

1. Cada aplicación Django tiene su documento de diseño detallado
2. Los modelos de datos están completamente documentados con diagramas
3. Los servicios principales están documentados con ejemplos
4. Las guías de desarrollo están probadas y validadas
5. La documentación sigue las plantillas establecidas en docs/plantillas/
6. Todos los documentos tienen front matter completo
7. Los enlaces cruzados están verificados
8. La documentación ha sido revisada por al menos 2 miembros del equipo

## Priorización

### Fase 1 - Apps críticas (Prioridad Alta)
1. ETL (crítico para el negocio)
2. Analytics (core del producto)
3. Reports (funcionalidad principal)

### Fase 2 - Apps de soporte (Prioridad Media)
4. Dashboard
5. Authentication
6. Users
7. Audit

### Fase 3 - Apps de integración (Prioridad Media-Baja)
8. IVR Legacy
9. Notifications
10. Common

## Dependencias

- Acceso al código fuente en `api/callcentersite/`
- Conocimiento del equipo de desarrollo actual
- Plantillas documentales en `docs/plantillas/`
- Estructura de backend en `docs/implementacion/backend/`

## Riesgos y mitigaciones

| Riesgo | Impacto | Probabilidad | Mitigación |
| --- | --- | --- | --- |
| Falta de conocimiento del código legacy | Alto | Media | Entrevistas con desarrolladores originales |
| Código sin documentar en comentarios | Medio | Alta | Análisis de código y reverse engineering |
| Cambios en el código durante documentación | Medio | Media | Versionado de documentación |
| Falta de tiempo del equipo | Alto | Media | Priorización por fases |

## Recursos necesarios

- **Tiempo estimado**: 40-60 horas de trabajo
- **Personas**: 2-3 desarrolladores backend
- **Herramientas**:
  - Editor Markdown
  - Generador de diagramas (PlantUML)
  - MkDocs para preview
  - Git para versionado

## Cronograma tentativo

- **Semana 1**: Análisis de código y estructura (Fase 1)
- **Semana 2**: Documentación apps Fase 1 (ETL, Analytics, Reports)
- **Semana 3**: Documentación apps Fase 2 (Dashboard, Auth, Users, Audit)
- **Semana 4**: Documentación apps Fase 3 y guías complementarias
- **Semana 5**: Revisión, correcciones y publicación final

## Métricas de éxito

1. 100% de apps documentadas según plantillas
2. Al menos 2 diagramas por app (arquitectura, secuencia)
3. Tiempo de onboarding reducido en 50%
4. 0 preguntas frecuentes sin respuesta en la documentación
5. Aprobación de revisión QA documental

## Referencias

- [Plantilla API Reference](../../plantillas/plantilla_api_reference.md)
- [Plantilla Database Design](../../plantillas/plantilla_database_design.md)
- [Plantilla SAD](../../plantillas/plantilla_sad.md)
- [Arquitectura Backend](../../backend/arquitectura/readme.md)
- [Diseño Detallado Backend](../../backend/diseno_detallado/readme.md)
