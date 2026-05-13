---
id: DOC-FRONTEND-BFF-STRATEGY
tipo: estrategia
estado: borrador
propietario: equipo-frontend
ultima_actualizacion: 2025-11-08
relacionados: ["DOC-ARQ-FRONTEND", "DOC-FRONTEND-INDEX"]
date: 2025-11-13
---

# Estrategia de integración frontend-backend

## Resumen ejecutivo

El repositorio mantiene actualmente una única rama activa (`work`), sin líneas paralelas de desarrollo que introduzcan integraciones adicionales. La API de `api/callcentersite` expone únicamente los módulos de dashboard, permisos y llamadas; el resto de aplicaciones (autenticación, usuarios, analítica, notificaciones, reportes) aún no publica endpoints y varios servicios devuelven datos estáticos o nulos. En consecuencia, el frontend debe operar de forma autónoma, utilizando mocks locales (`ui/src/mocks`) y lógica propia para cubrir los huecos del backend hasta que exista persistencia real.

## Panorama del backend `api/callcentersite`

### Rutas disponibles

- `api/v1/dashboard/`: Devuelve widgets con valores predeterminados en cero mediante `DashboardService`, lo que confirma la ausencia de métricas reales mientras la capa de datos no exista.【F:api/callcentersite/callcentersite/urls.py†L20-L25】【F:api/callcentersite/callcentersite/apps/dashboard/widgets.py†L18-L24】
- `api/v1/permissions/`: Implementa middleware, modelos y vistas completos; se espera que funcione con una base de datos PostgreSQL, pero requiere datos que hoy no están disponibles fuera de ambiente de pruebas.【F:api/callcentersite/callcentersite/urls.py†L21-L22】【F:api/callcentersite/callcentersite/apps/permissions/views.py†L1-L200】
- `api/v1/llamadas/`: Ofrece CRUD completo para llamadas, transcripciones y grabaciones, siempre que exista persistencia y datos en la base de datos configurada.【F:api/callcentersite/callcentersite/urls.py†L23-L24】【F:api/callcentersite/callcentersite/apps/llamadas/views.py†L1-L120】

### Módulos sin endpoints operativos

- **Autenticación y usuarios**: Solo cuentan con modelos y servicios; no existen vistas ni URL patterns asociados, por lo que la UI no puede delegar flujos de login, MFA o gestión de usuarios al backend.【F:api/callcentersite/callcentersite/apps/authentication/models.py†L1-L44】【F:api/callcentersite/callcentersite/apps/authentication/services.py†L1-L36】
- **Analítica, notificaciones, reportes, tickets y otros dominios**: Tienen modelos o generadores, pero carecen de vistas/serializadores expuestos; las funcionalidades asociadas deben simularse desde la UI hasta nuevo aviso.【F:api/callcentersite/callcentersite/apps/analytics/models.py†L1-L120】【F:api/callcentersite/callcentersite/apps/reports/generators/pdf_generator.py†L1-L80】
- **Configuración de aplicación**: No existe endpoint para `/api/config`, aunque el frontend intenta consumirlo desde `useAppConfig`. La configuración inicial debe poblarse localmente.【F:ui/src/hooks/useAppConfig.js†L18-L36】

### Dependencias de datos y estado

El backend está parametrizado para usar PostgreSQL (principal) y MySQL (lectura IVR) pero no se han entregado migraciones ni fixtures finales para poblar entornos; en ejecución local recurre a datos en memoria o falla al no encontrar tablas. Por ello, las funcionalidades habilitadas en UI dependen de mocks ubicados en `ui/src/mocks`, particularmente para llamadas y permisos.【F:api/callcentersite/callcentersite/settings/base.py†L68-L106】【F:ui/src/mocks/llamadas.json†L1-L68】【F:ui/src/mocks/permissions.json†L1-L48】

## Impacto y brechas en el frontend

1. **Carga de configuración**: `useAppConfig` falla al no encontrar `/api/config`, dejando la aplicación en estado de carga permanente. Se requiere bootstrapping interno de configuración y fallback a mocks configurables.【F:ui/src/hooks/useAppConfig.js†L18-L36】
2. **Gestión de permisos**: Aunque el backend define permisos, la UI debe derivar el menú y las capacidades desde `permissions.json` hasta que el endpoint esté disponible. Necesitamos una capa de servicios que homogenice la fuente de datos.【F:ui/src/mocks/permissions.json†L1-L48】
3. **Módulo de llamadas**: Las vistas del backend dependen de una base de datos poblada; la UI seguirá usando `llamadas.json` para listados, métricas y dashboards relacionados.【F:api/callcentersite/callcentersite/apps/llamadas/views.py†L1-L120】【F:ui/src/mocks/llamadas.json†L1-L68】
4. **Widgets de dashboard**: Hasta que el backend entregue métricas, el frontend debe calcular KPIs a partir de mocks o data agregada localmente, evitando mostrar valores vacíos al usuario final.【F:api/callcentersite/callcentersite/apps/dashboard/widgets.py†L18-L24】

## Estrategia propuesta para el frontend

### 1. Capa de servicios adaptable

- Crear un directorio `ui/src/services` con adaptadores por dominio (config, permisos, llamadas, métricas).
- Cada servicio expondrá una interfaz común (`fetchFromApi` + `fetchFromMock`) y decidirá la fuente según feature flag o resultado de health check.
- Implementar un proveedor de contexto que exponga el estado de conectividad backend para que los módulos puedan reaccionar dinámicamente.

### 2. Gestión centralizada de mocks

- Migrar los mocks actuales a esquemas tipados (por ejemplo usando Zod o TypeScript cuando se habilite) para validar datos antes de inyectarlos en Redux.
- Documentar en cada mock su origen esperado y fecha de actualización.
- Automatizar la sincronización generando factories que permitan simular escenarios (errores, datos vacíos, alta carga).

### 3. Feature flags y degradación controlada

- Introducir flags (`process.env` + configuración UI) para habilitar rutas que dependan del backend. Si el flag detecta backend inoperante, la UI mostrará vistas read-only con datos mockeados.
- Añadir indicadores visuales en dashboards cuando se esté usando datos simulados.
- Registrar métricas de uso de mocks para priorizar qué endpoints deben habilitarse primero.

### 4. Plan de transición a backend real

1. **Fase 0 – Mock only**: Default actual. Servicios apuntan a mocks y guardan acciones del usuario en memoria.
2. **Fase 1 – Backend verificable**: Se habilita health check (`/health`). Si responde, los servicios hacen intento de API y fallback automático.
3. **Fase 2 – Data híbrida**: Endpoints críticos (permisos, llamadas) consumen backend y complementan con mocks para campos faltantes.
4. **Fase 3 – Backend completo**: Se retiran mocks y se activa persistencia real; los servicios mantendrán capa de resiliencia para incidencias puntuales.

### 5. Consideraciones de TDD

- Cada servicio debe nacer con pruebas unitarias que cubran ambos caminos (API y mock) asegurando al menos 80 % de cobertura.
- Simular respuestas del backend usando MSW o fetch-mock para validar degradaciones controladas.
- Añadir pruebas de integración en Jest para `useAppConfig` y módulos que consuman la nueva capa.

## Acciones priorizadas

- [ ] Crear capa de servicios adaptable en `ui/src/services`.
- [ ] Implementar fallback local para `/api/config` con pruebas de contrato.
- [ ] Exponer flag visual cuando los widgets usen datos simulados.
- [ ] Incorporar métricas de uso de mocks para reportar dependencia del backend.

## Riesgos y mitigaciones

| Riesgo | Impacto | Mitigación |
| --- | --- | --- |
| Divergencia entre esquemas mock y backend | Alto | Validar mocks con contratos compartidos y sincronizar con backend vía ADRs |
| Técnicos confían en mocks indefinidamente | Medio | Feature flags con fechas de expiración y alertas de CI |
| Errores silenciosos al degradar funcionalidades | Alto | Probar rutas de fallback en CI con escenarios de backend caído |

## Seguimiento

- Registrar avances en ADRs específicos cuando se habiliten endpoints reales.
- Revisar esta estrategia en cada release planning hasta que el backend esté plenamente funcional.
