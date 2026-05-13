---
id: DOC-SOL-SC02-ANALISIS-ESTRUCTURA
estado: completado
propietario: equipo-backend
fecha: 2025-11-04
relacionados: ["DOC-SOL-SC02", "DOC-ARQ-BACKEND"]
---
# SC02 - Análisis de estructura de la carpeta API

## Resumen ejecutivo

Análisis completo de la estructura del directorio `api/callcentersite` para evaluar si cumple con las mejores prácticas de Django y identificar oportunidades de mejora.

**Resultado**:  **BUENA ESTRUCTURA GENERAL** con algunas oportunidades de mejora.

---

## 1. Estructura actual

```
api/
└── callcentersite/                    # Proyecto Django
    ├── manage.py                      # Script de gestión Django
    ├── pyproject.toml                 # Configuración del proyecto Python
    ├── pytest.ini                     # Configuración pytest
    ├── coveragerc                     # Configuración de cobertura
    ├── env.example                    # Ejemplo de variables de entorno
    │
    ├── requirements/                  #  EXCELENTE: requirements separados
    │   ├── base.txt
    │   ├── dev.txt
    │   └── test.txt
    │
    ├── callcentersite/               # Paquete principal del proyecto
    │   ├── __init__.py
    │   ├── urls.py                   # URLs principales
    │   ├── wsgi.py                   # Punto de entrada WSGI
    │   ├── database_router.py        #  EXCELENTE: Router multi-database
    │   │
    │   ├── settings/                 #  EXCELENTE: Settings por ambiente
    │   │   ├── __init__.py
    │   │   ├── base.py
    │   │   ├── development.py
    │   │   ├── testing.py
    │   │   ├── production.py
    │   │   └── infrastructure_test.py
    │   │
    │   ├── middleware/               #  BUENO: Middleware personalizado
    │   │   ├── __init__.py
    │   │   └── session_security.py
    │   │
    │   └── apps/                     #  EXCELENTE: Apps organizadas
    │       ├── __init__.py
    │       ├── analytics/
    │       ├── audit/
    │       ├── authentication/
    │       ├── common/
    │       ├── dashboard/
    │       ├── etl/
    │       ├── ivr_legacy/
    │       ├── notifications/
    │       ├── reports/
    │       └── users/
    │
    ├── test/                         # Fixtures y mocks de Django
    │   ├── __init__.py
    │   ├── contrib/
    │   │   ├── auth/
    │   │   └── sessions/
    │   ├── http/
    │   └── test/
    │
    └── tests/                        #  EXCELENTE: Tests pytest organizados
        ├── conftest.py
        ├── devcontainer/
        ├── infrastructure/
        ├── middleware/
        ├── routers/
        └── users/
```

---

## 2. Evaluación por componente

### 2.1 Estructura de proyecto:  EXCELENTE

| Aspecto | Estado | Comentario |
|---------|--------|------------|
| Separación de concerns |  Excelente | Apps separadas por dominio funcional |
| Settings por ambiente |  Excelente | `settings/` con base, dev, test, prod |
| Requirements separados |  Excelente | base.txt, dev.txt, test.txt |
| Configuración de tests |  Bueno | pytest.ini + coveragerc presentes |
| Ejemplo de variables |  Bueno | env.example para onboarding |

**Cumple con**: Django best practices 
**Patrón**: Monolito modular bien estructurado

---

### 2.2 Organización de apps:  BUENA con mejoras menores

#### Apps encontradas (10 apps)

| App | Archivos encontrados | Evaluación |
|-----|---------------------|------------|
| **analytics** | models, apps, migrations |  Falta services.py |
| **audit** | models, apps, services, decorators, migrations |  Completa |
| **authentication** | models, apps, services, migrations |  Completa |
| **common** | models, apps, permissions, utils, migrations |  Completa |
| **dashboard** | views, urls, services, widgets, apps, migrations |  Completa |
| **etl** | extractors, transformers, loaders, jobs, scheduler, management/commands, migrations |  Muy completa |
| **ivr_legacy** | models, apps, adapters, migrations |  Completa |
| **notifications** | models, apps, migrations |  Falta services.py |
| **reports** | models, apps, generators/ (4 archivos), migrations |  Muy completa |
| **users** | models, apps, services, migrations |  Completa |

#### Estructura típica encontrada

```python
app/
├── __init__.py
├── apps.py               #  Presente en todas
├── models.py             #  Presente en casi todas
├── services.py           #  Solo en algunas (audit, auth, dashboard, users)
├── views.py              #  Solo dashboard
├── urls.py               #  Solo dashboard
├── decorators.py         # Solo audit
├── adapters.py           # Solo ivr_legacy
├── widgets.py            # Solo dashboard
├── permissions.py        # Solo common
├── utils.py              # Solo common
├── migrations/           #  En todas
└── management/           # Solo etl
    └── commands/
```

**Observaciones**:
-  **Buena práctica**: Uso de `services.py` en varias apps (service layer pattern)
-  **Excelente**: App `etl` con estructura completa (extractors, transformers, loaders)
-  **Excelente**: App `reports` con generadores organizados en subdirectorio
-  **Falta**: `views.py`, `serializers.py` en la mayoría ( ver sección 2.5)
-  **Inconsistencia**: Solo algunas apps tienen `services.py`

---

### 2.3 Settings y configuración:  EXCELENTE

#### Puntos fuertes

1. **Settings separados por ambiente** 
   ```
   settings/
   ├── base.py          # Configuración compartida
   ├── development.py   # Para desarrollo local
   ├── testing.py       # Para tests
   ├── production.py    # Para producción
   └── infrastructure_test.py  # Para tests de infra
   ```

2. **Multi-database correctamente configurado** 
   ```python
   DATABASES = {
       "default": {  # PostgreSQL Analytics
           "ENGINE": "django.db.backends.postgresql",
           ...
       },
       "ivr_readonly": {  # MariaDB IVR (read-only)
           "ENGINE": "django.db.backends.mysql",
           ...
       }
   }
   ```

3. **Database Router implementado** 
   - Archivo: `database_router.py`
   - Protege IVR de escrituras accidentales
   - Enruta lecturas correctamente
   - Previene migraciones en IVR

4. **Middleware personalizado** 
   - `session_security.py` para seguridad de sesiones

5. **REST Framework configurado** 
   ```python
   INSTALLED_APPS = [
       ...
       "rest_framework",
       "rest_framework_simplejwt",
       "django_filters",
       "drf_spectacular",  # Para OpenAPI/Swagger
   ]
   ```

---

### 2.4 Testing:  BUENO

#### Estructura de tests

1. **Dos enfoques** (ambos válidos):
   ```
   test/          # Fixtures y mocks de Django
   tests/         # Tests pytest organizados
   ```

2. **Configuración presente** :
   - `pytest.ini`
   - `coveragerc`
   - `conftest.py`

3. **Tests organizados por tema** :
   ```
   tests/
   ├── conftest.py              # Fixtures globales
   ├── infrastructure/          # Tests de infra
   ├── middleware/              # Tests de middleware
   ├── routers/                 # Tests de database router
   ├── users/                   # Tests de users app
   └── devcontainer/            # Tests de devcontainer
   ```

**Observación**:  Faltan tests de apps individuales (analytics, etl, reports, etc.)

---

### 2.5 APIs y endpoints:  ÁREA DE OPORTUNIDAD

#### Estado actual

**ENCONTRADO**:
-  REST Framework instalado
-  JWT authentication configurado
-  `drf_spectacular` (OpenAPI) instalado
-  Una app con URLs: `dashboard/urls.py`

**NO ENCONTRADO** (esperado para API REST):
-  `serializers.py` en apps
-  `views.py` o `viewsets.py` en la mayoría de apps
-  `urls.py` en apps (solo dashboard tiene)
-  `api/` subdirectorio en apps para versioning

**Conclusión**:
- El proyecto tiene las bases para APIs REST (DRF instalado)
-  **Implementación pendiente o mínima** de endpoints REST
- Probablemente en fase de desarrollo o usando principalmente Django views

**Recomendación**: Si se planea exponer APIs REST:
```
app/
├── api/
│   ├── __init__.py
│   ├── views.py         # o viewsets.py
│   ├── serializers.py
│   ├── permissions.py
│   └── urls.py
```

---

### 2.6 Seguridad:  EXCELENTE

| Aspecto | Implementación | Estado |
|---------|---------------|--------|
| IVR read-only | Database router con protección |  Excelente |
| Session security | Middleware personalizado |  Bueno |
| JWT authentication | rest_framework_simplejwt |  Bueno |
| Variables de entorno | env.example + os.getenv() |  Bueno |
| ALLOWED_HOSTS | Configurado desde env var |  Bueno |
| SECRET_KEY | Configurado desde env var |  Bueno |

**Puntos fuertes**:
1.  IVR database protegido contra escrituras con `ValueError` explícito
2.  Configuración sensible en variables de entorno
3.  Middleware de seguridad de sesiones

---

## 3. Comparación con mejores prácticas de Django

### 3.1 Cumplimiento de Two Scoops of Django

| Práctica | Cumple | Comentario |
|----------|--------|------------|
| Settings separados por ambiente |  Sí | Excelente implementación |
| Apps reutilizables |  Sí | Apps bien separadas |
| Service layer |  Parcial | Solo en algunas apps |
| Fat models, thin views |  Desconocido | Requiere revisar código |
| Use Django forms |  Desconocido | No se encontraron forms.py |
| Use Django REST Framework |  Parcial | Instalado pero poco usado |
| Tests organizados |  Sí | pytest + estructura por tema |

### 3.2 Cumplimiento de 12 Factor App

| Factor | Cumple | Implementación |
|--------|--------|----------------|
| I. Codebase |  Sí | Git |
| II. Dependencies |  Sí | requirements/*.txt |
| III. Config |  Sí | Variables de entorno |
| IV. Backing services |  Sí | Databases configurables |
| V. Build, release, run |  Parcial | Falta verificar CI/CD |
| VI. Processes |  Sí | Stateless (Django) |
| VII. Port binding |  Sí | WSGI |
| VIII. Concurrency |  Desconocido | Falta verificar |
| IX. Disposability |  Sí | Django graceful shutdown |
| X. Dev/prod parity |  Sí | Settings por ambiente |
| XI. Logs |  Desconocido | Falta verificar logging config |
| XII. Admin processes |  Sí | Management commands |

---

## 4. Análisis por patrones arquitectónicos

### 4.1 Patrón: Monolito Modular 

**Implementado correctamente**:
- Apps separadas por dominio (analytics, reports, etl, etc.)
- Cada app tiene responsabilidad única
- Apps se comunican via servicios compartidos (`common`)
- Database routing para separación de datos

**Score**: 9/10 

### 4.2 Patrón: Service Layer 

**Implementación inconsistente**:
-  Presente en: audit, authentication, dashboard, users
-  Ausente en: analytics, notifications
-  ETL usa patrón diferente: extractors/transformers/loaders

**Recomendación**: Estandarizar uso de `services.py` en todas las apps

**Score**: 6/10 

### 4.3 Patrón: Repository ❓

**No encontrado explícitamente**:
- No hay archivos `repositories.py`
- Probablemente se accede directamente a modelos via ORM

**Recomendación**: Considerar para queries complejas

**Score**: N/A

### 4.4 Patrón: Adapter (para IVR) 

**Bien implementado**:
- `ivr_legacy/adapters.py` presente
- Aísla lógica de integración con sistema heredado

**Score**: 9/10 

---

## 5. Problemas identificados

### 5.1 Críticos:  NINGUNO

No se identificaron problemas críticos. La estructura es sólida.

### 5.2 Importantes:  2 ENCONTRADOS

####  1. Inconsistencia en uso de Service Layer

**Problema**:
- Algunas apps tienen `services.py` (audit, auth, dashboard, users)
- Otras no (analytics, notifications)
- No hay estándar claro de cuándo usar services

**Impacto**: Medio
- Dificulta mantenibilidad
- Inconsistencia en arquitectura
- Código de negocio puede estar en lugares inesperados

**Recomendación**:
```python
# Crear services.py en todas las apps con lógica de negocio
analytics/services.py
notifications/services.py
reports/services.py  # si tiene lógica además de generators
```

####  2. APIs REST no completamente desarrolladas

**Problema**:
- DRF instalado pero poco usado
- Faltan serializers, viewsets, urls en apps
- Solo dashboard tiene urls.py

**Impacto**: Medio (si se planea exponer APIs)
- Falta infraestructura para APIs REST
- No hay endpoints documentados

**Recomendación**:
Si se planea exponer APIs:
```
app/
└── api/
    ├── serializers.py
    ├── views.py
    ├── urls.py
    └── permissions.py
```

### 5.3 Menores:  4 ENCONTRADOS

####  1. Tests de apps faltantes

**Problema**: Tests organizados por tema (infraestructura, routers) pero no por app individual

**Recomendación**:
```
tests/
├── analytics/
│   ├── test_models.py
│   ├── test_services.py
│   └── conftest.py
├── etl/
│   ├── test_extractors.py
│   ├── test_transformers.py
│   └── test_loaders.py
...
```

####  2. Falta documentación inline

**Problema**: No se encontraron README.md en apps individuales

**Recomendación**:
```
etl/
├── README.md  # Explicar qué hace la app
├── models.py
├── extractors.py
...
```

####  3. No hay `admin.py` visible

**Problema**: No se encontraron archivos `admin.py` en apps (pueden estar vacíos o no creados)

**Impacto**: Bajo (si se usa Django Admin)

**Recomendación**: Registrar modelos en Django Admin para facilitar gestión

####  4. Estructura de ETL podría mejorarse

**Sugerencia**: La app ETL es grande y compleja
```
etl/
├── extractors/
│   ├── __init__.py
│   ├── base.py
│   ├── ivr_extractor.py
│   └── ...
├── transformers/
│   ├── __init__.py
│   ├── base.py
│   └── ...
├── loaders/
│   ├── __init__.py
│   ├── base.py
│   └── ...
├── jobs/
│   ├── __init__.py
│   └── specific_jobs.py
└── management/
    └── commands/
```

Beneficios:
- Mejor organización
- Facilita testing
- Más escalable

---

## 6. Comparación con proyectos similares

### 6.1 Django típico (e-commerce, CMS)

| Aspecto | Típico | Este proyecto | Evaluación |
|---------|--------|---------------|------------|
| Apps | 5-15 | 10 |  Apropiado |
| Settings | Separados |  Separados |  Bien |
| Tests | pytest |  pytest |  Bien |
| API REST | Sí |  Parcial |  Pendiente |
| Service layer | A veces |  Inconsistente |  Mejorable |

### 6.2 Django analytics/data (similar a este)

| Aspecto | Proyectos data | Este proyecto | Evaluación |
|---------|---------------|---------------|------------|
| ETL pipeline | Sí |  Sí (completo) |  Excelente |
| Multi-database | Sí |  Sí |  Excelente |
| Reportes | Sí |  Sí (generators) |  Excelente |
| Dashboards | Sí |  Sí |  Bien |
| Celery/tasks | A veces | ❓ Desconocido | ❓ Verificar |

**Conclusión**: Proyecto bien estructurado para analytics/data processing

---

## 7. Recomendaciones priorizadas

### 7.1 Corto plazo (1-2 sprints)

1.  **Estandarizar Service Layer**
   - Crear `services.py` en analytics
   - Crear `services.py` en notifications
   - Documentar cuándo usar services vs métodos de modelo

2.  **Mejorar estructura de tests**
   - Crear `tests/analytics/`
   - Crear `tests/etl/`
   - Crear `tests/reports/`
   - Mover tests de apps a subdirectorios

3.  **Agregar admin.py**
   - Registrar modelos principales en Django Admin
   - Facilita gestión y troubleshooting

### 7.2 Mediano plazo (1-2 meses)

4.  **Completar APIs REST** (si es requerimiento)
   - Crear `serializers.py` en apps
   - Crear `api/` subdirectorios
   - Implementar endpoints
   - Documentar con drf-spectacular

5.  **Reorganizar ETL**
   - Separar extractors/ transformers/ loaders/ en subdirectorios
   - Facilita mantenibilidad

6.  **Agregar README por app**
   - Documentación inline en cada app
   - Explicar responsabilidad de cada app

### 7.3 Largo plazo (3-6 meses)

7. 🔮 **Considerar Repository Pattern**
   - Para queries complejas
   - Mejor testabilidad

8. 🔮 **Considerar Celery**
   - Para jobs ETL asíncronos
   - Si scheduler.py no es suficiente

9. 🔮 **Microservicios** (solo si es necesario)
   - Si el monolito crece mucho
   - Separar ETL como servicio independiente

---

## 8. Score final

| Categoría | Score | Comentario |
|-----------|-------|------------|
| **Estructura de proyecto** | 9/10 |  Excelente organización |
| **Organización de apps** | 8/10 |  Buena, mejorable |
| **Settings y configuración** | 10/10 |  Excelente multi-env |
| **Testing** | 7/10 |  Bien organizado, faltan tests de apps |
| **APIs REST** | 5/10 |  Instalado pero no desarrollado |
| **Seguridad** | 9/10 |  Muy buena (IVR read-only) |
| **Documentación** | 3/10 |  Inexistente (razón de SC02) |
| **Patrones arquitectónicos** | 7/10 |  Bien, inconsistencias menores |

**SCORE TOTAL**: **7.2/10**  **BUENO**

---

## 9. Conclusión

### Veredicto:  LA ESTRUCTURA ESTÁ **BIEN**

El proyecto tiene una **excelente base arquitectónica**:
-  Monolito modular bien organizado
-  Apps separadas por dominio
-  Settings por ambiente
-  Multi-database correctamente implementado
-  Security por diseño (IVR read-only)
-  ETL bien estructurado

### Áreas de mejora identificadas:

**Corto plazo** (crítico):
1.  Estandarizar Service Layer
2.  Mejorar cobertura de tests

**Mediano plazo** (importante):
3.  Completar implementación de APIs REST (si es requerimiento)
4.  Reorganizar estructura interna de ETL

**Largo plazo** (nice to have):
5. 🔮 Considerar patrones adicionales (Repository, CQRS)

### Recomendación final:

**NO se requieren cambios estructurales mayores**. La arquitectura es sólida y permite escalar.

Se recomienda:
1.  **Mantener** la estructura actual (monolito modular con apps)
2.  **Mejorar** consistencia en uso de Service Layer
3.  **Completar** implementación de APIs REST si es requerimiento
4.  **Documentar** (razón de SC02)

---

## 10. Comparativa: Antes vs Recomendado

### ANTES (actual - ya está bien)
```
api/callcentersite/callcentersite/apps/
├── analytics/
│   ├── models.py
│   └── apps.py
├── etl/
│   ├── extractors.py
│   ├── transformers.py
│   ├── loaders.py
│   └── jobs.py
└── notifications/
    ├── models.py
    └── apps.py
```

### DESPUÉS (recomendado - mejoras opcionales)
```
api/callcentersite/callcentersite/apps/
├── analytics/
│   ├── models.py
│   ├── services.py          #  AGREGAR
│   ├── admin.py             #  AGREGAR
│   ├── README.md            #  AGREGAR
│   └── api/                 #  AGREGAR (si REST)
│       ├── serializers.py
│       ├── views.py
│       └── urls.py
├── etl/
│   ├── extractors/          #  REORGANIZAR
│   │   ├── base.py
│   │   └── ivr_extractor.py
│   ├── transformers/        #  REORGANIZAR
│   │   └── ...
│   ├── loaders/             #  REORGANIZAR
│   │   └── ...
│   ├── jobs/                #  REORGANIZAR
│   │   └── ...
│   └── management/
│       └── commands/
└── notifications/
    ├── models.py
    ├── services.py          #  AGREGAR
    ├── admin.py             #  AGREGAR
    └── README.md            #  AGREGAR
```

---

**Fecha de análisis**: 2025-11-04
**Analista**: Claude (AI Assistant)
**Herramientas**: find, tree, file analysis
**Alcance**: Estructura de directorios y arquitectura de alto nivel
**Próxima revisión**: Después de implementar recomendaciones de corto plazo
