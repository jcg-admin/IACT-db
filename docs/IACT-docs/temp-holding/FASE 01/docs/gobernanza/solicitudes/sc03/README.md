---
id: DOC-SOL-SC03
estado: en_progreso
propietario: equipo-backend
fecha_creacion: 2025-11-04
ultima_actualizacion: 2025-11-04
relacionados: ["DOC-SOL-SC02", "DOC-BACKEND-INDEX", "DOC-ARQ-BACKEND"]
---

# Solicitud SC03 - Documentación Individual de Apps Django

Esta solicitud documenta el proceso de creación de documentación técnica detallada para cada una de las 10 aplicaciones Django del backend.

## Página padre
- [`../readme.md`](../readme.md)

## Páginas hijas
- [`alcance.md`](alcance.md) - Definición del alcance y objetivos
- [`checklist.md`](checklist.md) - Lista de verificación y seguimiento
- [`entregables/`](entregables/) - Documentación técnica de cada app

## Contexto

La solicitud SC02 estableció la **base arquitectónica** del proyecto:
-  Análisis estructural y funcional de las apps
-  Documentación de patrones arquitectónicos existentes
-  Guías de decisión para nuevos desarrollos
-  Plantillas especializadas (Django App, ETL Job)

**SC03 construye sobre esa base** para documentar cada app individual con:
- Modelos de datos y relaciones
- Servicios y lógica de negocio
- Vistas y endpoints
- Diagramas (clases, secuencia, ER)
- Guías de troubleshooting

## Objetivo

Crear documentación técnica completa para las **10 aplicaciones Django**:

1. **analytics** - Almacenamiento de métricas y KPIs
2. **audit** - Sistema de auditoría inmutable
3. **authentication** - Autenticación y seguridad
4. **common** - Utilidades compartidas
5. **dashboard** - Orquestación de widgets
6. **etl** - Pipeline de datos IVR → Analytics
7. **ivr_legacy** - Integración read-only con BD legacy
8. **notifications** - Mensajería interna
9. **reports** - Generación de reportes
10. **users** - Sistema custom de permisos

## Enfoque de documentación

Cada app será documentada según su **patrón arquitectónico identificado**:

| App | Patrón principal | Plantilla a usar |
|-----|------------------|------------------|
| analytics | Data Sink | plantilla_django_app.md |
| audit | Service Layer | plantilla_django_app.md |
| authentication | Mixto (Service + Active Record) | plantilla_django_app.md |
| common | Utilidades | plantilla_django_app.md (simplificada) |
| dashboard | Service Layer + Registry | plantilla_django_app.md |
| etl | ETL Pipeline | plantilla_etl_job.md |
| ivr_legacy | Adapter Pattern | plantilla_django_app.md |
| notifications | Active Record | plantilla_django_app.md (simplificada) |
| reports | Strategy Pattern | plantilla_django_app.md |
| users | Service Layer | plantilla_django_app.md |

## Priorización

### Fase 1: Apps Críticas (Semana 1-2)
- **etl**: Pipeline crítico de datos
- **analytics**: Destino del ETL
- **reports**: Generación de reportes

### Fase 2: Apps de Soporte (Semana 3-4)
- **audit**: Sistema de auditoría
- **dashboard**: Visualización
- **authentication**: Seguridad
- **users**: Permisos

### Fase 3: Apps de Integración (Semana 5)
- **ivr_legacy**: Integración con BD legacy
- **notifications**: Mensajería
- **common**: Utilidades

## Beneficios esperados

- **Onboarding acelerado**: Nuevos desarrolladores entienden cada app rápidamente
- **Mantenibilidad mejorada**: Decisiones de diseño documentadas
- **Troubleshooting eficiente**: Guías específicas para cada app
- **Base para APIs**: Documentación preparada para exposición REST
- **Calidad documental**: Cumplimiento con estándares del proyecto

## Ubicación de entregables

Los documentos técnicos finales se publicarán en:
- `docs/implementacion/backend/diseno_detallado/apps/` - Documentación de cada app
- `docs/solicitudes/sc03/entregables/` - Versiones de trabajo

## Estado actual

| App | Estado | Responsable | Fecha estimada |
| --- | --- | --- | --- |
| etl |  Pendiente | Equipo Backend | Por definir |
| analytics |  Pendiente | Equipo Backend | Por definir |
| reports |  Pendiente | Equipo Backend | Por definir |
| audit |  Pendiente | Equipo Backend | Por definir |
| dashboard |  Pendiente | Equipo Backend | Por definir |
| authentication |  Pendiente | Equipo Backend | Por definir |
| users |  Pendiente | Equipo Backend | Por definir |
| ivr_legacy |  Pendiente | Equipo Backend | Por definir |
| notifications |  Pendiente | Equipo Backend | Por definir |
| common |  Pendiente | Equipo Backend | Por definir |

## Checklist operativo

- [ ] Definir alcance y objetivos detallados
- [ ] Crear checklist de seguimiento
- [ ] Documentar apps Fase 1 (etl, analytics, reports)
- [ ] Documentar apps Fase 2 (audit, dashboard, authentication, users)
- [ ] Documentar apps Fase 3 (ivr_legacy, notifications, common)
- [ ] Crear diagramas para cada app
- [ ] Revisar con equipo de arquitectura
- [ ] Publicar en docs/implementacion/backend/diseno_detallado/
- [ ] Actualizar índice de backend
- [ ] Cerrar solicitud

## Dependencias

**Requiere completar (de SC02)**:
-  Análisis funcional de apps
-  Documentación de patrones arquitectónicos
-  Plantillas especializadas (Django App, ETL Job)

**Bloquea**:
- Documentación de API REST (necesita conocer endpoints)
- Guías de desarrollo (necesita entender arquitectura)

## Referencias cruzadas

- [SC02 - Documentación de API](../sc02/readme.md)
- [Planificación Detallada](../../backend/planificacion_documentacion.md)  **NUEVO** - Plan completo de ejecución
- [Patrones Arquitectónicos](../../backend/arquitectura/patrones_arquitectonicos.md)
- [Guía de Decisión de Patrones](../../backend/arquitectura/guia_decision_patrones.md)
- [Análisis Funcional de Apps](../sc02/analisis_funcion_real_apps.md)
- [Plantilla Django App](../../plantillas/plantilla_django_app.md)
- [Plantilla ETL Job](../../plantillas/plantilla_etl_job.md)

## Próximos pasos

1. Crear documento de alcance detallado
2. Crear checklist de seguimiento
3. Comenzar con app **etl** (Fase 1, crítica)
4. Continuar con **analytics** y **reports**
5. Iterar con revisiones del equipo
