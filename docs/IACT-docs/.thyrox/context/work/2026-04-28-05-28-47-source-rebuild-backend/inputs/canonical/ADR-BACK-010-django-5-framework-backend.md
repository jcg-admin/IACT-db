---
id: ADR-BACK-010-django-5-framework-backend
estado: aprobado
propietario: equipo-backend
ultima_actualizacion: 2025-01-17
relacionados: ["RNF-BACK-061", "ADR-BACK-011", "ADR-QA-010"]
date: 2025-01-17
---

# ADR-BACK-010: Django 5.2 como Framework Backend

**Estado:** aprobado

**Fecha:** 2025-01-17

**Decisores:** equipo-backend, arquitecto-principal

**Contexto técnico:** Backend

---

## Contexto y Problema

El proyecto IACT requiere un framework web robusto para construir una API REST que soporte:

1. **Sistema complejo de permisos:** 130+ capacidades granulares con 3 niveles de evaluación
2. **Múltiples módulos:** 19 funciones diferentes (usuarios, dashboards, llamadas IVR, tickets, reportes, etc.)
3. **Integración con bases de datos legacy:** Conexión read-only a sistema IVR existente
4. **Requisitos de seguridad estrictos:** ISO 27001, STRIDE threat modeling
5. **Mantenibilidad a largo plazo:** Código limpio, documentado y testeable

**Preguntas clave:**
- ¿Qué framework nos permite construir APIs REST de forma rápida y segura?
- ¿Qué framework tiene el mejor soporte para ORM multi-database?
- ¿Qué framework ofrece el mejor ecosistema de seguridad y autenticación?
- ¿Qué framework tiene la curva de aprendizaje más accesible para el equipo?

**Restricciones actuales:**
- Lenguaje: Python 3.12+ (restricción corporativa)
- Base de datos: PostgreSQL (primary) + MariaDB (legacy IVR)
- Sin servicios externos: NO Redis, NO Sentry
- Infraestructura: Apache + mod_wsgi (entorno corporativo)

**Impacto del problema:**
- La elección del framework define la arquitectura del proyecto completo
- Afecta velocidad de desarrollo, seguridad, mantenibilidad y escalabilidad
- Determina el ecosistema de librerías y herramientas disponibles

---

## Factores de Decisión

- **Productividad:** Framework con "batteries included" para acelerar desarrollo
- **Seguridad:** Sistema de autenticación robusto y protección contra vulnerabilidades comunes
- **ORM Avanzado:** Soporte nativo para múltiples bases de datos
- **Ecosistema:** Amplia disponibilidad de paquetes y extensiones
- **Mantenibilidad:** Código estructurado, convenciones claras
- **Documentación:** Documentación oficial completa y comunidad activa
- **Estabilidad:** Framework maduro con LTS (Long Term Support)
- **Performance:** Rendimiento adecuado para aplicaciones empresariales

---

## Opciones Consideradas

### Opción 1: Django 5.2 (ELEGIDA)

**Descripción:**
Framework web full-stack con "batteries included". Incluye ORM, sistema de autenticación, panel admin, sistema de plantillas, validación de formularios, protección CSRF/XSS, y más.

**Pros:**
- **ORM Potente:** Soporte nativo para múltiples databases con routers personalizados
- **Admin Incluido:** Panel de administración automático ahorra semanas de desarrollo
- **Seguridad Built-in:** Protección contra CSRF, XSS, SQL Injection, Clickjacking
- **Django REST Framework:** DRF es el estándar de oro para APIs REST en Python
- **Ecosistema Rico:** 5000+ paquetes third-party (django-filter, drf-spectacular, etc.)
- **Documentación Excelente:** Documentación oficial completa y detallada
- **Comunidad Grande:** 20+ años de desarrollo, comunidad muy activa
- **Batteries Included:** Sistema de migraciones, caché, sesiones, autenticación incluidos
- **Estabilidad:** Django 5.2 LTS con soporte extendido hasta abril 2026
- **Type Hints:** django-stubs oficial para MyPy, mejora mantenibilidad

**Contras:**
- **Monolítico:** Framework completo, no minimalista (pero esto es ventaja para nuestro caso)
- **Curva de Aprendizaje:** ORM tiene conceptos propios (vs SQL directo)
- **Overhead:** Más pesado que microframeworks (irrelevante con mod_wsgi)
- **Convenciones:** Estructura opinionada (positivo para consistencia)

**Ejemplo/Implementación:**
```python
# requirements/base.txt
Django>=5.2,<5.3
djangorestframework>=3.15.1
djangorestframework-simplejwt>=5.3.0
django-filter>=23.5
drf-spectacular>=0.27.0

# Multi-database con router personalizado
DATABASES = {
 "default": {"ENGINE": "django.db.backends.postgresql", ...},
 "ivr_readonly": {"ENGINE": "mysql.connector.django", ...},
}

# Admin automático para todos los modelos
# Panel en /admin/ sin código adicional
```

---

### Opción 2: FastAPI

**Descripción:**
Framework moderno y minimalista basado en type hints de Python 3.6+. Muy rápido, diseñado para APIs asíncronas.

**Pros:**
- **Performance:** Altamente performante (comparable a Node.js/Go)
- **Async Nativo:** Diseñado desde cero para async/await
- **OpenAPI Automático:** Documentación Swagger generada automáticamente
- **Type Hints:** Validación basada en Pydantic
- **Moderno:** Aprovecha últimas features de Python

**Contras:**
- **Sin ORM Incluido:** Requiere SQLAlchemy, Tortoise ORM o Piccolo
- **Sin Admin:** No incluye panel de administración
- **Sin Sistema de Auth:** Requiere implementar OAuth2/JWT manualmente
- **Sin Migraciones:** Requiere Alembic (extra dependency)
- **Ecosistema Menor:** Menos paquetes third-party que Django
- **Multi-Database Complejo:** SQLAlchemy multi-db routing no tan maduro
- **Curva de Aprendizaje Async:** Equipo debe dominar async/await desde el inicio

**Razón del rechazo:**
Requiere mucho trabajo custom para features que Django provee out-of-the-box (admin, auth, migraciones, multi-db routing). El performance extra no justifica el esfuerzo adicional para nuestro caso de uso.

---

### Opción 3: Flask

**Descripción:**
Microframework minimalista. Provee solo routing y templates, el resto es por extensiones.

**Pros:**
- **Minimalista:** Solo incluye lo esencial
- **Flexibilidad:** Total control sobre arquitectura
- **Lightweight:** Muy ligero y rápido de iniciar
- **Extensiones:** Flask-SQLAlchemy, Flask-Login, Flask-Admin disponibles

**Contras:**
- **Requiere Muchas Extensiones:** Flask-SQLAlchemy, Flask-Migrate, Flask-Login, Flask-Admin, etc.
- **Sin Convenciones:** Cada proyecto tiene estructura diferente
- **Multi-Database Difícil:** SQLAlchemy multi-db routing menos robusto
- **Seguridad Manual:** CSRF protection requiere Flask-WTF
- **Sin Admin Built-in:** Flask-Admin no tan completo como Django admin
- **Más Código Boilerplate:** Mucho código custom para features básicas

**Razón del rechazo:**
Para un proyecto empresarial con 19 módulos y requisitos de seguridad estrictos, la flexibilidad de Flask se convierte en una desventaja. Django nos ahorra meses de desarrollo.

---

## Decisión

**Opción elegida:** "Django 5.2"

**Justificación:**

1. **Productividad Máxima:** Django Admin ahorra 2-3 semanas solo en interfaces de administración. Sistema de autenticación robusto incluido.

2. **Multi-Database Native:** Database routers permiten conectar a PostgreSQL (primary) y MariaDB (IVR legacy) con control granular de lectura/escritura.

3. **Seguridad Empresarial:** Protección built-in contra OWASP Top 10. Django es usado por Instagram, Mozilla, NASA, Pinterest.

4. **DRF para APIs REST:** Django REST Framework es el estándar de industria para APIs REST en Python. Serializers, ViewSets, Permissions, Pagination todo incluido.

5. **Ecosistema Maduro:** Paquetes críticos disponibles: django-filter (filtrado complejo), drf-spectacular (OpenAPI 3.0), django-stubs (type checking).

6. **LTS Support:** Django 5.2 LTS con soporte extendido, actualizaciones de seguridad garantizadas.

7. **Equipo Familiarizado:** Curva de aprendizaje conocida, documentación excelente.

**Trade-offs aceptados:**
- Framework más pesado que FastAPI (pero irrelevante con Apache+mod_wsgi)
- Estructura opinionada (positivo para consistencia del equipo)
- Async no nativo (pero no es requisito crítico para nuestro caso)

---

## Consecuencias

### Positivas

- **Admin Panel Automático:** Gestión de usuarios, permisos, configuración sin desarrollar UI
- **ORM Robusto:** QuerySets, prefetch_related, select_related optimizan queries
- **Migraciones Automáticas:** Sistema de migraciones detecta cambios en modelos
- **Seguridad by Default:** CSRF, XSS, SQL Injection, Clickjacking protegidos automáticamente
- **DRF Integration:** Serializers validan datos, ViewSets reducen código boilerplate
- **Testing Framework:** Django TestCase, fixtures, factory_boy se integran perfectamente
- **Type Safety:** django-stubs + MyPy detectan errores antes de runtime
- **Ecosistema Rico:** django-filter, drf-spectacular, APScheduler integration sin problemas
- **Documentación Oficial:** 5000+ páginas de docs oficiales, tutoriales, guías

### Negativas

- **Curva de Aprendizaje ORM:** Equipo debe aprender QuerySets, F(), Q(), prefetch_related
- **Opinionado:** Estructura de proyecto definida (apps, models, views, serializers)
- **Overhead Inicial:** Configuración inicial más compleja que Flask
- **Async Limitado:** Async views disponibles pero no es el paradigma principal

### Neutrales

- **Versioning:** Django 5.2 requiere Python 3.10+ (ya cumplido con Python 3.12)
- **Compatibilidad:** Requiere mysqlclient para MariaDB, psycopg2 para PostgreSQL
- **Deployment:** Compatible con Apache mod_wsgi, Gunicorn, uWSGI

---

## Plan de Implementación

### Fase 1: Setup Inicial - COMPLETADO

```bash
# requirements/base.txt
Django>=5.2,<5.3
djangorestframework>=3.15.1
djangorestframework-simplejwt>=5.3.0
django-filter>=23.5
drf-spectacular>=0.27.0
django-cors-headers>=4.4.0

# Database drivers
psycopg2-binary>=2.9.9
mysqlclient>=2.2.0

# Type checking
django-stubs>=5.0.0
djangorestframework-stubs>=3.15.0
```

### Fase 2: Configuración Multi-Database - COMPLETADO

```python
# settings/base.py
DATABASES = {
 "default": {
 "ENGINE": "django.db.backends.postgresql",
 "NAME": "iact_analytics",
 "CONN_MAX_AGE": 300,
 },
 "ivr_readonly": {
 "ENGINE": "mysql.connector.django",
 "NAME": "ivr_legacy",
 "CONN_MAX_AGE": 300,
 },
}

DATABASE_ROUTERS = ["callcentersite.database_router.IVRReadOnlyRouter"]
```

### Fase 3: REST Framework Setup - COMPLETADO

```python
# settings/base.py
REST_FRAMEWORK = {
 "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.IsAuthenticated"],
 "DEFAULT_AUTHENTICATION_CLASSES": ["rest_framework_simplejwt.authentication.JWTAuthentication"],
 "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
 "PAGE_SIZE": 50,
 "DEFAULT_FILTER_BACKENDS": ["django_filters.rest_framework.DjangoFilterBackend"],
 "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
}
```

### Fase 4: Apps Desarrolladas - COMPLETADO

```
OK authentication - JWT tokens, login, logout
OK users - Gestión usuarios y permisos
OK permissions - Sistema de permisos granulares
OK ivr_legacy - Integración con IVR (read-only)
OK llamadas - Gestión de llamadas
OK dashboard - Dashboards personalizados
OK notifications - Buzón interno
OK analytics - Métricas y reportes
OK audit - Auditoría completa
OK etl - Sincronización de datos
OK 10+ apps adicionales (tickets, clientes, equipos, etc.)
```

---

## Validación y Métricas

### Criterios de Éxito

| Métrica | Target | Actual | Estado |
|---------|--------|--------|--------|
| Apps creadas | 15+ | 19 | OK OK |
| Admin funcional | 100% modelos | 100% | OK OK |
| API endpoints | 50+ | 80+ | OK OK |
| Multi-database routing | Funcional | Funcional | OK OK |
| Tests con Django TestCase | 80% coverage | En progreso | → |
| Type hints con django-stubs | 60%+ | En progreso | → |
| Tiempo respuesta API | <200ms p95 | ~150ms | OK OK |

### KPIs de Productividad

```yaml
Desarrollo:
 - Admin panel: 0 horas desarrollo (automático)
 - CRUD endpoints: ~2 horas por modelo (con ViewSets)
 - Migraciones: Automáticas al cambiar modelos
 - Validaciones: Automáticas con serializers

Seguridad:
 - CSRF protection: Built-in
 - SQL Injection: ORM protege automáticamente
 - XSS protection: Template engine escapa HTML
 - Clickjacking: X-Frame-Options middleware
```

---

## Alternativas Descartadas

### Pyramid

**Por qué se descartó:**
- Menos popular que Django/Flask
- Ecosistema menor
- Admin no incluido
- ORM multi-database más complejo

### Tornado

**Por qué se descartó:**
- Diseñado para WebSockets/long-polling
- No es requisito para nuestro caso
- Menos features built-in que Django

### Sanic

**Por qué se descartó:**
- Async-first (no necesario para nuestro caso)
- Ecosistema muy limitado
- Sin ORM built-in
- Framework relativamente nuevo (menos maduro)

---

## Referencias

### Documentación Oficial

- [Django 5.2 Documentation](https://docs.djangoproject.com/en/5.2/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [Django Multi-Database](https://docs.djangoproject.com/en/5.2/topics/db/multi-db/)
- [Django Security](https://docs.djangoproject.com/en/5.2/topics/security/)
- [django-stubs](https://github.com/typeddjango/django-stubs)

### Estudios de Caso

- [Instagram on Django](https://instagram-engineering.com/web-service-efficiency-at-instagram-with-python-4976d078e366)
- [Mozilla Add-ons on Django](https://blog.mozilla.org/addons/2015/01/09/performance/)
- [Django vs FastAPI Comparison](https://testdriven.io/blog/fastapi-vs-django/)

### Documentos del Proyecto

- `api/callcentersite/requirements/base.txt` - Dependencias Django
- `api/callcentersite/callcentersite/settings/base.py` - Configuración Django
- `api/callcentersite/callcentersite/database_router.py` - Multi-database router
- ADR-BACK-011: PostgreSQL + MariaDB Multi-Database
- ADR-QA-010: Pytest Framework Testing

---

## Notas Adicionales

### Experiencia del Equipo

**Feedback del equipo (post-implementación):**
- "Django Admin nos ahorró semanas de desarrollo de interfaces CRUD"
- "Database router funciona perfectamente para IVR read-only"
- "DRF ViewSets reducen mucho el boilerplate"
- "Documentación oficial es excelente, resuelve dudas rápidamente"

### Decisiones Técnicas Relacionadas

**Django Apps Structure:**
- Adoptamos estructura por dominio (users, permissions, llamadas, etc.)
- Cada app tiene models, views, serializers, services, tests
- `common` app para utilities compartidas

**Database Routing:**
- `default` (PostgreSQL): READ + WRITE para todos los modelos Django
- `ivr_readonly` (MariaDB): READ-ONLY para modelos ivr_legacy
- Router bloquea writes a IVR, levanta ValueError si se intenta

**API Versioning:**
- Actualmente sin versionado explícito (v1 implícito)
- Futuro: considerar `/api/v2/` cuando sea necesario breaking change

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2025-01-17 | ADR inicial documentando decisión Django 5.2 |

---

**Documento:** ADR-BACK-010
**Fecha:** 17 de Enero, 2025
**Estado:** Aprobado
**Próxima revisión:** 2026-01-17 (anual)
