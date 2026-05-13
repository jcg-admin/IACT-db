# TASK-006: Identificación de Decisiones Arquitectónicas Existentes

**Fecha:** 2025-11-18
**Estado:** Completado
**Fase:** FASE 2 - Subcarpeta adr/

---

## Objetivo

Identificar decisiones arquitectónicas existentes en la documentación de backend (subcarpetas permisos/, arquitectura/, diseno/) que serán formalizadas como ADRs.

---

## Metodología

Se realizó un análisis exhaustivo de la documentación existente en:
- `/home/user/IACT/docs/backend/permisos/`
- `/home/user/IACT/docs/backend/arquitectura/`
- `/home/user/IACT/docs/backend/diseno_detallado/`

---

## Decisiones Arquitectónicas Identificadas

### 1. Sistema de Permisos con Grupos Funcionales Sin Jerarquía

**Fuente:** `docs/backend/permisos/arquitectura_permisos_granular.md`

**Decisión Clave:**
Implementar sistema de permisos basado en grupos funcionales combinables SIN jerarquías (no usar RBAC tradicional con roles tipo Admin/Supervisor/Agent).

**Contexto:**
- Sistema requiere control fino sobre 130+ capacidades
- 19 funciones diferentes del sistema
- Necesidad de flexibilidad organizacional sin etiquetas pretenciosas

**Alternativas Consideradas:**
- RBAC Tradicional (Role-Based Access Control)
- ABAC (Attribute-Based Access Control)
- ACL (Access Control Lists)

**Impacto:**
- 8 tablas en base de datos
- N:M usuarios-grupos (múltiples grupos por usuario)
- Performance < 50ms para verificación de permisos

**ADR Asociado:** ADR-BACK-001

---

### 2. Sistema de Configuración Dinámica

**Fuente:** `docs/backend/arquitectura/configuration.md`

**Decisión Clave:**
Implementar app Django custom `configuration` para gestionar parámetros del sistema con historial inmutable de cambios, en lugar de usar variables de entorno o librerías de terceros.

**Contexto:**
- Modificación de parámetros sin redespliegue
- Requisitos de auditoría ISO 27001
- Trazabilidad completa de cambios

**Alternativas Consideradas:**
- Django-constance (librería 3rd party)
- Variables de Entorno + Admin Custom
- Django Settings Database

**Impacto:**
- 2 modelos: Configuracion y ConfiguracionHistorial
- Historial inmutable de todos los cambios
- Metadata completa (IP, user agent, timestamp)
- Import/Export de configuraciones

**ADR Asociado:** ADR-BACK-002

---

### 3. Patrones Arquitectónicos Pragmáticos (Multi-Patrón)

**Fuente:** `docs/backend/arquitectura/patrones_arquitectonicos.md`

**Decisión Clave:**
Adoptar enfoque pragmático usando múltiples patrones arquitectónicos según el contexto de cada app Django, en lugar de imponer un único patrón global.

**Contexto:**
- Monolito modular Django con 10+ apps
- Diferentes responsabilidades por app
- Balance entre simplicidad y arquitectura

**Patrones Implementados:**
- **Service Layer Pattern**: Apps con lógica compleja (permissions, configuration, authentication)
- **Adapter Pattern**: Integración con sistemas legacy (ivr_legacy)
- **Strategy Pattern**: Procesamiento flexible (etl, reports)
- **Active Record Pattern**: Apps CRUD simples (notifications)
- **Registry Pattern**: Dashboards con widgets dinámicos

**Principios Guía:**
1. Pragmatismo sobre dogmatismo
2. Explícito es mejor que implícito
3. Simple es mejor que complejo
4. YAGNI (You Aren't Gonna Need It)

**ADR Asociado:** ADR-BACK-003

---

### 4. Sistema de Autenticación con JWT y Sesiones Híbridas

**Fuente:**
- `docs/backend/diseno_detallado/diseno_tecnico_autenticacion.md`
- `docs/backend/arquitectura/authentication.md`

**Decisión Clave:**
Implementar sistema híbrido de autenticación usando JWT para API y Django Sessions para auditoría, control de concurrencia y cierre de sesiones remotas.

**Contexto:**
- API REST stateless con JWT
- Requisitos de auditoría y control de sesiones
- Prevención de ataques de fuerza bruta
- Recuperación de contraseña sin email

**Componentes:**
- **JWT**: Autenticación de API (access token + refresh token)
- **Django Sessions**: Control de sesiones activas
- **UserSession Model**: Tracking de sesiones con metadata
- **LoginAttempt**: Auditoría de intentos de login
- **SecurityQuestion**: Recuperación sin email

**Features de Seguridad:**
- Rate limiting por IP
- Bloqueo temporal tras N intentos fallidos
- Cierre remoto de sesiones
- Token blacklisting
- APScheduler para cierre de sesiones inactivas

**ADR Asociado:** ADR-BACK-004

---

### 5. Middleware y Decoradores para Permisos Granulares

**Fuente:**
- `docs/backend/permisos/MEJORAS_MIDDLEWARE_PROPUESTAS.md`
- `docs/backend/arquitectura/decoradores_y_middleware_permisos.md`

**Decisión Clave:**
Implementar decoradores, middleware y permission classes DRF para integración transparente del sistema de permisos granulares en vistas Django y ViewSets.

**Contexto:**
- Sistema de permisos granulares debe integrarse con Django/DRF
- Necesidad de auditoría automática
- Soporte para FBV, CBV y ViewSets DRF

**Componentes:**
- **Decoradores**:
 - `@verificar_permiso`: Verificar una o más capacidades
 - `@require_permission`: Verificar permiso único
 - `@require_any_permission`: Lógica OR
 - `@require_all_permissions`: Lógica AND

- **Permission Classes DRF**:
 - `GranularPermission`: Permission class para ViewSets
 - `GranularPermissionMixin`: Helpers adicionales

- **Middleware**:
 - `PermissionAuditMiddleware`: Auditoría automática de requests

**Performance:**
- Verificación de permisos: 5-10ms
- Cache en request: < 1ms para verificaciones subsecuentes
- Auditoría asíncrona: < 1ms overhead

**ADR Asociado:** ADR-BACK-005

---

## Resumen de Archivos Analizados

### Subcarpeta permisos/

| Archivo | Contenido Relevante |
|---------|-------------------|
| `arquitectura_permisos_granular.md` | Arquitectura completa del sistema de permisos |
| `ARQUITECTURA_PERMISOS_UML.md` | Diagramas UML del sistema |
| `MEJORAS_MIDDLEWARE_PROPUESTAS.md` | Propuestas de mejora de middleware |
| `API-permisos.md` | API REST de permisos |
| `OPTIMIZACIONES_PERFORMANCE.md` | Optimizaciones de rendimiento |

### Subcarpeta arquitectura/

| Archivo | Contenido Relevante |
|---------|-------------------|
| `patrones_arquitectonicos.md` | Patrones arquitectónicos del backend |
| `configuration.md` | Sistema de configuración dinámica |
| `authentication.md` | App de autenticación |
| `decoradores_y_middleware_permisos.md` | Implementación de decoradores |
| `permisos_granular.md` | Diseño de permisos granulares |
| `guia_decision_patrones.md` | Guía para elegir patrones |

### Subcarpeta diseno_detallado/

| Archivo | Contenido Relevante |
|---------|-------------------|
| `diseno_tecnico_autenticacion.md` | Diseño técnico completo de autenticación |

---

## Decisiones para Formalización

Se han identificado **5 decisiones arquitectónicas principales** que serán formalizadas como ADRs:

1. **ADR-BACK-001**: Sistema de Permisos con Grupos Funcionales Sin Jerarquía
2. **ADR-BACK-002**: Sistema de Configuración Dinámica con Historial Inmutable
3. **ADR-BACK-003**: Patrones Arquitectónicos Pragmáticos Multi-Patrón
4. **ADR-BACK-004**: Sistema de Autenticación Híbrido JWT + Sessions
5. **ADR-BACK-005**: Middleware y Decoradores para Permisos Granulares

---

## Próximos Pasos

- [x] TASK-006: Identificación completada
- [ ] TASK-007: Crear ADR-BACK-001 a ADR-BACK-005
- [ ] TASK-008: Agregar metadatos YAML
- [ ] TASK-009: Crear INDICE_ADRs.md
- [ ] TASK-010: Validar con Chain-of-Verification

---

**Evidencia generada:** 2025-11-18
**Responsable:** Claude Code Agent
**Estado:** Completado
