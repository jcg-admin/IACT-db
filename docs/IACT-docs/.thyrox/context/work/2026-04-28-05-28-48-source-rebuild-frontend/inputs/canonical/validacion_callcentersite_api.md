---
id: DOC-FRONTEND-API-VALIDATION
estado: activo
propietario: equipo-frontend
ultima_actualizacion: 2025-11-13
relacionados: ["DOC-FRONTEND-BFF-STRATEGY", "DOC-FRONTEND-ARQ-TODO", "DOC-FRONTEND-INDEX"]
---

# Validación de `api/callcentersite` frente a lineamientos de frontend

## 1. Fuentes revisadas
- **Lineamientos y expectativas**: `analisis_api_frontend.md` (inventario de endpoints y casos de uso esperados), `estrategia_integracion_backend.md` (dependencias de mocks y ausencia de endpoints), `TODO.md` (acciones prioritarias).【F:docs/frontend/arquitectura/analisis_api_frontend.md†L35-L102】【F:docs/frontend/arquitectura/estrategia_integracion_backend.md†L15-L118】【F:docs/frontend/arquitectura/TODO.md†L11-L97】
- **Código backend**: árbol de rutas principal y configuración de datos de `api/callcentersite`.【F:api/callcentersite/callcentersite/urls.py†L15-L38】【F:api/callcentersite/callcentersite/settings/base.py†L97-L136】
- **Configuración de entorno**: plantilla `.env` que define dependencias de base de datos y variables de despliegue.【F:api/callcentersite/env.example†L4-L116】

## 2. Inventario real de APIs expuestas
El `urls.py` principal publica más dominios de los mencionados en la documentación actual. Endpoints detectados:

| Ruta base | Estado observado |
| --- | --- |
| `/api/schema/`, `/api/docs/` | Documentación OpenAPI y Swagger generadas por DRF Spectacular (no referenciadas en docs de frontend).【F:api/callcentersite/callcentersite/urls.py†L17-L22】 |
| `/api/v1/usuarios/` | CRUD de usuarios + registro público mediante `UserViewSet` y `UserRegistrationView`. Requiere base de datos real para operar.【F:api/callcentersite/callcentersite/urls.py†L23-L24】【F:api/callcentersite/callcentersite/apps/users/urls.py†L8-L17】 |
| `/api/v1/permissions/` | Módulo granular de permisos (coincide con lo esperado por frontend).【F:api/callcentersite/callcentersite/urls.py†L33-L34】 |
| `/api/v1/dashboard/` | Widgets con valores `0` por defecto; confirma ausencia de datos operativos reales.【F:api/callcentersite/callcentersite/urls.py†L25-L26】【F:api/callcentersite/callcentersite/apps/dashboard/widgets.py†L13-L18】 |
| `/api/v1/configuracion/` | Dos módulos: `configuration` (restaurar/importar/exportar) y `configuracion` legacy. Ninguno está documentado en los lineamientos vigentes.【F:api/callcentersite/callcentersite/urls.py†L24-L27】【F:api/callcentersite/callcentersite/apps/configuration/urls.py†L13-L18】 |
| `/api/v1/presupuestos/`, `/api/v1/politicas/`, `/api/v1/excepciones/` | CRUD con flujos de aprobación/versionado declarados en los lineamientos, pero no señalados como operativos en la estrategia actual.【F:api/callcentersite/callcentersite/urls.py†L27-L29】 |
| `/api/v1/reportes/` | Rutas presentes para reportes IVR; la documentación de frontend asume ausencia de endpoints reales.【F:api/callcentersite/callcentersite/urls.py†L29-L30】 |
| `/api/v1/notifications/` | API de mensajes internos (`messages`, `mark_read`, `unread`). No aparece en la estrategia de mocks actual.【F:api/callcentersite/callcentersite/urls.py†L30-L31】【F:api/callcentersite/callcentersite/apps/notifications/urls.py†L9-L13】 |
| `/api/v1/etl/` | Consola de jobs y errores ETL; tampoco documentada en el análisis vigente.【F:api/callcentersite/callcentersite/urls.py†L31-L33】 |
| `/api/v1/llamadas/` | CRUD de catálogos, llamadas y grabaciones; depende de datos en BD según la estrategia.【F:api/callcentersite/callcentersite/urls.py†L33-L35】 |
| `/api/dora/` | Métricas DORA expuestas vía módulo dedicado; el análisis las menciona pero no identifica su publicación real.【F:api/callcentersite/callcentersite/urls.py†L35-L37】 |
| `/health/` | Endpoint de health check ya disponible; pendiente de uso por la capa de servicios resilientes descrita en TODO P2.【F:api/callcentersite/callcentersite/urls.py†L9-L38】【F:docs/frontend/arquitectura/TODO.md†L63-L76】 |

## 3. Brechas frente a la documentación de frontend
1. **Cobertura subestimada**: la estrategia de integración indica que sólo existen dashboard, permisos y llamadas, pero el backend publica once dominios adicionales (usuarios, configuración dual, presupuestos, políticas, excepciones, reportes, notificaciones, ETL, DORA, schema/docs, health).【F:docs/frontend/arquitectura/estrategia_integracion_backend.md†L15-L33】【F:api/callcentersite/callcentersite/urls.py†L15-L38】
2. **Persistencia obligatoria**: los settings siguen apuntando a PostgreSQL y MariaDB sin fallback; con bases ausentes las vistas fallarán o devolverán datos vacíos, confirmando la necesidad de mocks indicada en los lineamientos.【F:api/callcentersite/callcentersite/settings/base.py†L97-L126】【F:api/callcentersite/callcentersite/apps/dashboard/widgets.py†L13-L18】
3. **Endpoint `/api/config`**: continúa sin existir; `useAppConfig` seguirá colgando si no se mantiene el bootstrapping con mocks definido en TODO P0.【F:docs/frontend/arquitectura/estrategia_integracion_backend.md†L25-L40】【F:docs/frontend/arquitectura/TODO.md†L25-L36】
4. **Health check desaprovechado**: el backlog P2 pide consumir `/health`, pero el endpoint ya está operativo; falta integrarlo en la capa de servicios para habilitar degradación controlada y métricas de dependencia de mocks.【F:api/callcentersite/callcentersite/urls.py†L9-L38】【F:docs/frontend/arquitectura/TODO.md†L63-L76】
5. **Sin equivalentes mock/contratos**: nuevos dominios (configuración paralela, notificaciones, ETL, reportes) no tienen mocks ni contratos tipados en `ui/src/mocks`, por lo que el App Shell no puede representar su estado de manera consistente con la guía de composición dinámica.【F:docs/frontend/arquitectura/analisis_api_frontend.md†L111-L134】【F:docs/frontend/arquitectura/TODO.md†L49-L62】

## 4. Pasos de ejecución recomendados (ambiente local sin bases externas)
1. **Crear entorno virtual y variables**: `python -m venv .venv && source .venv/bin/activate`; copiar `api/callcentersite/env.example` a `.env` ajustando credenciales locales o flags de desarrollo.【F:api/callcentersite/env.example†L4-L116】
2. **Instalar dependencias**: `pip install -r api/callcentersite/requirements/dev.txt` (incluye base y herramientas de calidad según la cadena de includes).【F:api/callcentersite/requirements/dev.txt†L7-L22】
3. **Configurar bases de datos temporales**: mientras no haya Postgres/MariaDB disponibles, declarar dos bases SQLite (aplicación y IVR) en un settings local que sobreescriba `DATABASES` replicando la topología dual del archivo `base.py`. Esta sobreescritura debe acompañarse de pruebas unitarias para validar el router de lectura y mantener la política TDD del backlog.【F:api/callcentersite/callcentersite/settings/base.py†L97-L126】【F:docs/frontend/arquitectura/TODO.md†L63-L79】
4. **Migrar y poblar datos de prueba**: ejecutar `python manage.py migrate` usando el settings local; cargar fixtures mínimas para usuarios/permisos y llamadas que permitan validar los flujos descritos en `analisis_api_frontend.md` antes de habilitar llamadas reales. Mantener cobertura ≥80 % en nuevas pruebas de regresión.【F:docs/frontend/arquitectura/analisis_api_frontend.md†L35-L102】
5. **Levantar servidor y verificar contratos**: `python manage.py runserver` y revisar `/api/docs/` para confirmar los contratos publicados; validar `/health/` para alimentar la capa de servicios resilientes pendiente en TODO P2.【F:api/callcentersite/callcentersite/urls.py†L17-L38】【F:docs/frontend/arquitectura/TODO.md†L63-L76】

## 5. Cambios propuestos (Clean Code + TDD)
- **Actualizar documentos de estrategia** para reflejar el inventario real de endpoints y aprovechar el health check existente, evitando decisiones basadas en supuestos obsoletos.【F:docs/frontend/arquitectura/estrategia_integracion_backend.md†L15-L33】【F:api/callcentersite/callcentersite/urls.py†L15-L38】
- **Introducir settings locales con SQLite dual** (app + IVR) y pruebas que validen el router `IVRReadOnlyRouter`, permitiendo desarrollo offline sin romper la separación de fuentes de datos.【F:api/callcentersite/callcentersite/settings/base.py†L97-L126】
- **Ampliar mocks y contratos** para nuevos dominios (configuración paralela, notificaciones, ETL, reportes) siguiendo el patrón de `createResilientService` y los feature flags definidos en TODO P1/P2, asegurando degradación explícita y métricas de dependencia de mocks.【F:docs/frontend/arquitectura/TODO.md†L49-L79】
- **Pruebas de smoke automatizadas** sobre `/api/schema/`, `/api/docs/` y `/health/` para detectar regresiones tempranas y alimentar el tablero de métricas requerido por el backlog (cobertura mínima 80 %).【F:api/callcentersite/callcentersite/urls.py†L15-L38】【F:docs/frontend/arquitectura/TODO.md†L63-L79】
