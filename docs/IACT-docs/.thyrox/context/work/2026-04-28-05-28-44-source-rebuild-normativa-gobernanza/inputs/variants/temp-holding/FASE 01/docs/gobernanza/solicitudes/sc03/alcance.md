---
id: DOC-SOL-SC03-ALCANCE
fecha: 2025-11-04
estado: borrador
---

# Alcance de SC03 - Documentación Individual de Apps Django

## 1. Descripción General

Esta solicitud documenta cada una de las **10 aplicaciones Django** del backend de forma individual y detallada, siguiendo las plantillas especializadas y los patrones arquitectónicos identificados en SC02.

## 2. Objetivo

Crear documentación técnica completa que permita a cualquier desarrollador:
- Entender la función y arquitectura de cada app
- Conocer los modelos de datos y sus relaciones
- Comprender la lógica de negocio implementada
- Identificar patrones de diseño utilizados
- Resolver problemas comunes (troubleshooting)

## 3. Alcance

### 3.1 Dentro del Alcance

**Para cada una de las 10 apps**:

1. **Información General**
   - Nombre y propósito
   - Dependencias con otras apps
   - Configuración requerida
   - Patrón arquitectónico utilizado

2. **Modelos de Datos**
   - Descripción de cada modelo
   - Campos y sus tipos
   - Relaciones (ForeignKey, ManyToMany)
   - Managers custom
   - Métodos y propiedades

3. **Servicios y Lógica de Negocio**
   - Services.py (si existe)
   - Lógica compleja
   - API contracts
   - Casos de uso

4. **Vistas y Endpoints**
   - Views.py
   - URLs
   - Endpoints REST (si existen)
   - Serializers (si existen)

5. **Diagramas**
   - Diagrama de clases (modelos)
   - Diagrama ER (relaciones de BD)
   - Diagramas de secuencia (flujos principales)
   - Diagrama de componentes

6. **Testing**
   - Tests existentes
   - Fixtures
   - Coverage

7. **Troubleshooting**
   - Problemas comunes
   - Soluciones
   - Logs relevantes

### 3.2 Fuera del Alcance

-  Creación de nuevos tests (solo documentar existentes)
-  Refactorización de código
-  Implementación de nuevas funcionalidades
-  Migración de bases de datos
-  Optimización de queries
-  Documentación de frontend (fuera de backend)

## 4. Apps a Documentar

### Fase 1: Apps Críticas (Prioridad Alta)

#### 4.1 ETL
- **Complejidad**: Alta
- **Patrón**: ETL Pipeline
- **Plantilla**: plantilla_etl_job.md
- **Razón**: Pipeline crítico que alimenta analytics
- **Estimación**: 2-3 días

#### 4.2 Analytics
- **Complejidad**: Media
- **Patrón**: Data Sink
- **Plantilla**: plantilla_django_app.md
- **Razón**: Destino de ETL, fuente de métricas
- **Estimación**: 1-2 días

#### 4.3 Reports
- **Complejidad**: Media-Alta
- **Patrón**: Strategy Pattern
- **Plantilla**: plantilla_django_app.md
- **Razón**: Generación de reportes críticos
- **Estimación**: 2 días

### Fase 2: Apps de Soporte (Prioridad Media)

#### 4.4 Audit
- **Complejidad**: Media
- **Patrón**: Service Layer
- **Plantilla**: plantilla_django_app.md
- **Razón**: Sistema transversal de auditoría
- **Estimación**: 1 día

#### 4.5 Dashboard
- **Complejidad**: Media-Alta
- **Patrón**: Service Layer + Registry
- **Plantilla**: plantilla_django_app.md
- **Razón**: Orquestación de widgets, REST API
- **Estimación**: 2 días

#### 4.6 Authentication
- **Complejidad**: Media
- **Patrón**: Mixto (Service + Active Record)
- **Plantilla**: plantilla_django_app.md
- **Razón**: Seguridad y autenticación
- **Estimación**: 1-2 días

#### 4.7 Users
- **Complejidad**: Alta
- **Patrón**: Service Layer (custom)
- **Plantilla**: plantilla_django_app.md
- **Razón**: Sistema custom de permisos
- **Estimación**: 2 días

### Fase 3: Apps de Integración (Prioridad Baja)

#### 4.8 IVR Legacy
- **Complejidad**: Media
- **Patrón**: Adapter Pattern
- **Plantilla**: plantilla_django_app.md
- **Razón**: Integración con BD externa
- **Estimación**: 1 día

#### 4.9 Notifications
- **Complejidad**: Baja
- **Patrón**: Active Record
- **Plantilla**: plantilla_django_app.md (simplificada)
- **Razón**: Mensajería simple
- **Estimación**: 1 día

#### 4.10 Common
- **Complejidad**: Baja
- **Patrón**: Utilidades
- **Plantilla**: plantilla_django_app.md (simplificada)
- **Razón**: Modelos abstractos y utilidades
- **Estimación**: 1 día

## 5. Entregables

### 5.1 Por cada app

1. **Documento técnico completo** siguiendo plantilla
   - Ubicación trabajo: `docs/solicitudes/sc03/entregables/{app_name}.md`
   - Ubicación final: `docs/implementacion/backend/diseno_detallado/apps/{app_name}.md`

2. **Diagramas**
   - Diagrama de clases (PlantUML)
   - Diagrama ER (PlantUML)
   - Diagramas de secuencia (PlantUML)
   - Ubicación: Embebidos en el documento markdown

3. **Índice actualizado**
   - Actualizar `docs/implementacion/backend/diseno_detallado/readme.md`
   - Actualizar navegación en `docs/mkdocs.yml`

### 5.2 Documento consolidado

- **Guía de APIs REST**: Consolidado de endpoints de todas las apps
- **Mapa de dependencias**: Diagrama de cómo se relacionan las apps
- **Troubleshooting general**: Problemas comunes del backend

## 6. Metodología

### 6.1 Para cada app

1. **Análisis del código**
   - Leer models.py, services.py, views.py
   - Identificar patrones utilizados
   - Mapear dependencias

2. **Creación de diagramas**
   - Diagrama de clases de modelos
   - Diagrama ER de base de datos
   - Diagramas de secuencia de flujos principales

3. **Redacción del documento**
   - Usar plantilla apropiada
   - Incluir ejemplos de código real
   - Documentar decisiones de diseño

4. **Revisión**
   - Auto-revisión
   - Revisión por equipo
   - Ajustes

5. **Publicación**
   - Mover a ubicación final
   - Actualizar índices
   - Actualizar navegación

### 6.2 Control de calidad

Cada documento debe cumplir:
-  Sigue la plantilla apropiada
-  Incluye todos los diagramas requeridos
-  Los diagramas renderizan correctamente
-  El código de ejemplo compila
-  Las referencias cruzadas funcionan
-  Está en la navegación de MkDocs

## 7. Timeline Estimado

| Fase | Apps | Días estimados | Semanas |
|------|------|----------------|---------|
| Fase 1 | etl, analytics, reports | 5-7 días | 1-2 |
| Fase 2 | audit, dashboard, authentication, users | 6-8 días | 2 |
| Fase 3 | ivr_legacy, notifications, common | 3 días | 1 |
| Consolidación | Guías, índices, revisiones | 2 días | - |
| **TOTAL** | 10 apps | **16-20 días** | **4-5 semanas** |

**Nota**: Timeline asume 1 desarrollador dedicado. Puede acelerarse con más recursos.

## 8. Dependencias y Bloqueadores

### 8.1 Dependencias

**Requiere completar (de SC02)**:
-  Análisis funcional de apps
-  Documentación de patrones arquitectónicos
-  Plantillas especializadas

**Requiere acceso a**:
-  Código fuente en `api/callcentersite/`
-  Tests en `api/callcentersite/tests/`
-  Settings en `api/callcentersite/callcentersite/settings/`

### 8.2 Bloqueadores potenciales

-  Código sin comentarios (requiere análisis profundo)
-  Lógica compleja sin documentar (requiere consulta con autores)
-  Tests faltantes (dificulta entender casos de uso)
-  Configuración no documentada (requiere experimentación)

### 8.3 Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Código muy complejo sin documentar | Media | Alto | Consultar con desarrolladores originales |
| Tiempo insuficiente | Media | Medio | Priorizar apps críticas primero |
| Plantillas no se ajustan a todas las apps | Baja | Medio | Adaptar plantillas según necesidad |
| Diagramas muy grandes | Media | Bajo | Dividir en sub-diagramas |

## 9. Criterios de Aceptación

### 9.1 Por cada app

-  Documento completo siguiendo plantilla
-  Todos los modelos documentados
-  Todos los servicios documentados (si existen)
-  Diagramas incluidos y renderizando
-  Sección de troubleshooting completa
-  Referencias cruzadas funcionando
-  En navegación de MkDocs

### 9.2 Global

-  Las 10 apps documentadas
-  Guía de APIs REST creada
-  Mapa de dependencias creado
-  Índices actualizados
-  MkDocs build exitoso
-  Revisión por equipo completada
-  Pull Request aprobado

## 10. Métricas de Éxito

- **Completitud**: 10/10 apps documentadas
- **Calidad**: 0 broken links, 0 diagramas rotos
- **Utilidad**: Feedback positivo del equipo
- **Onboarding**: Nuevo desarrollador puede entender una app en < 2 horas
- **Mantenibilidad**: Documentación puede actualizarse fácilmente

## 11. Próximos Pasos

1. Aprobar este alcance
2. Crear checklist detallado de seguimiento
3. Comenzar con app **etl** (más crítica)
4. Documentar en paralelo **analytics** y **reports**
5. Revisión incremental con equipo
6. Continuar con Fase 2 y Fase 3

---

**Aprobaciones requeridas**:
- [ ] Equipo Backend
- [ ] Equipo de Arquitectura
- [ ] Product Owner (opcional)

**Fecha de aprobación**: _Pendiente_
