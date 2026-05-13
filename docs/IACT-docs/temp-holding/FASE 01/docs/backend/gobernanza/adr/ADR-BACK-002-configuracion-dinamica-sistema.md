---
id: ADR-BACK-002-configuracion-dinamica-sistema
estado: aceptada
propietario: equipo-backend
ultima_actualizacion: 2025-11-18
relacionados:
 - docs/backend/arquitectura/configuration.md
 - ADR-BACK-001-grupos-funcionales-sin-jerarquia
tags: [configuracion, auditoria, backend, iso27001]
date: 2025-11-18
---

# ADR-BACK-002: Sistema de Configuración Dinámica con Historial Inmutable

**Estado:** Aceptada

**Fecha:** 2025-11-18

**Decisores:** equipo-backend, arquitecto-principal

**Contexto técnico:** Backend - Sistema de Configuración

---

## Contexto y Problema

El sistema IACT requiere la capacidad de modificar parámetros técnicos y de negocio en tiempo de ejecución sin necesidad de redesplegar la aplicación. Estos parámetros incluyen timeouts de sesión, límites de intentos de login, configuraciones de integración con sistemas externos, y parámetros operativos del sistema.

**Preguntas clave:**
- ¿Cómo permitir modificación de configuraciones sin redespliegue?
- ¿Cómo mantener trazabilidad completa de cambios en configuraciones críticas?
- ¿Cómo garantizar que solo usuarios autorizados modifiquen configuraciones?
- ¿Cómo asegurar la capacidad de rollback a valores anteriores?
- ¿Cómo integrar con el sistema de permisos granulares existente?

**Restricciones actuales:**
- Sistema de permisos granulares ya implementado (ADR-BACK-001)
- Requisitos de auditoría (ISO 27001)
- NO usar variables de entorno para configuración dinámica (solo para infraestructura)
- Necesidad de historial inmutable de cambios

**Impacto:**
- **Operaciones**: Reduce time-to-fix para ajustes operativos
- **Seguridad**: Permite ajustar parámetros de seguridad sin downtime
- **Compliance**: Trazabilidad completa para auditorías
- **DevOps**: Desacopla configuración de código

---

## Factores de Decisión

- **Auditabilidad**: Trazabilidad completa de cambios (ISO 27001)
- **Permisos granulares**: Integración con sistema existente
- **Simplicidad**: Fácil de usar y mantener
- **Flexibilidad**: Soportar múltiples tipos de datos
- **Rollback**: Capacidad de restaurar valores anteriores
- **Performance**: Consulta rápida de configuraciones
- **Seguridad**: Prevenir modificaciones no autorizadas
- **Sin redespliegue**: Modificaciones en caliente

---

## Opciones Consideradas

### Opción 1: Django-constance (3rd party library)

**Descripción:**
Usar django-constance, una librería popular para configuración dinámica en Django con backend de BD o Redis.

**Pros:**
- OK Librería madura y bien documentada
- OK Integración con Django Admin out-of-the-box
- OK Soporta tipos de datos tipados
- OK Cache automático en Redis (opcional)

**Contras:**
- NO Dependencia externa adicional
- NO Historial de cambios básico (no inmutable)
- NO Integración compleja con permisos granulares
- NO No captura metadata de auditoría (IP, user agent)
- NO Limitado control sobre modelo de datos

**Ejemplo:**
```python
# settings.py
CONSTANCE_CONFIG = {
 'TIMEOUT_SESSION': (3600, 'Session timeout in seconds'),
}

# En código
from constance import config
timeout = config.TIMEOUT_SESSION
```

**Razón del rechazo:**
No proporciona historial inmutable ni metadata de auditoría completa requerida por ISO 27001.

---

### Opción 2: Variables de Entorno + Admin Custom

**Descripción:**
Usar variables de entorno editables desde Django Admin custom con actualización en archivo .env y reload de configuración.

**Pros:**
- OK No requiere tabla en BD
- OK Integración natural con Django settings
- OK Familiar para devops

**Contras:**
- NO Requiere reload/restart de aplicación
- NO NO hay historial de cambios
- NO Difícil de auditar cambios
- NO Problemas de concurrencia en multi-worker
- NO Complejidad en deployment (actualizar .env en todos los nodos)
- NO NO cumple requisito de modificación sin redespliegue

**Razón del rechazo:**
No cumple el requisito fundamental de modificación sin redespliegue. No proporciona trazabilidad.

---

### Opción 3: Almacenamiento en PostgreSQL JSONB

**Descripción:**
Almacenar configuraciones en columna JSONB de PostgreSQL.

**Pros:**
- OK Flexibilidad para datos no estructurados
- OK PostgreSQL tiene índices JSONB eficientes

**Contras:**
- NO Dificulta queries y validaciones
- NO NO hay schema enforcement
- NO Historial complejo de implementar
- NO Difícil integración con Django Admin

**Razón del rechazo:**
Dificulta queries y validaciones. No hay schema enforcement nativo.

---

### Opción 4: App Configuration Custom (ELEGIDA)

**Descripción:**
Implementar app Django propia `configuration` con dos modelos:
- `Configuracion`: Almacena configuraciones con tipos de datos tipados
- `ConfiguracionHistorial`: Historial inmutable de cambios con metadata de auditoría

**Pros:**
- OK Control total sobre modelo de datos
- OK Historial inmutable de cambios
- OK Integración nativa con permisos granulares
- OK Captura metadata completa (IP, user agent, timestamp)
- OK Categorización de configuraciones
- OK Import/Export de configuraciones
- OK Restauración a valores por defecto
- OK Sin dependencias externas
- OK Transacciones atómicas garantizadas

**Contras:**
- NO Requiere desarrollo custom
- NO Mantenimiento propio del código
- NO Más código en el proyecto

**Ejemplo/Implementación:**
```python
# Modelo
class Configuracion(models.Model):
 categoria = models.CharField(max_length=50, choices=CATEGORIA_CHOICES)
 clave = models.CharField(max_length=100, unique=True)
 valor = models.TextField()
 tipo_dato = models.CharField(max_length=20) # string, integer, boolean, etc.
 valor_default = models.TextField()
 updated_by = models.ForeignKey(User, ...)

 def get_valor_typed(self):
 """Convierte valor a su tipo correspondiente"""
 if self.tipo_dato == 'integer':
 return int(self.valor)
 elif self.tipo_dato == 'boolean':
 return self.valor.lower() in ['true', '1', 'yes']
 elif self.tipo_dato == 'float':
 return float(self.valor)
 return self.valor

# Uso
from configuration.services import ConfiguracionService

config = ConfiguracionService.editar_configuracion(
 usuario_id=1,
 clave='sistema.timeout_session',
 nuevo_valor='7200',
 ip_address='192.168.1.10'
)
```

**Estructura de Base de Datos:**
```sql
-- Tabla principal
CREATE TABLE configuration_configuracion (
 id BIGINT PRIMARY KEY,
 categoria VARCHAR(50),
 clave VARCHAR(100) UNIQUE,
 valor TEXT,
 tipo_dato VARCHAR(20),
 valor_default TEXT,
 descripcion TEXT,
 updated_by_id BIGINT,
 updated_at TIMESTAMP
);

-- Tabla de historial (inmutable)
CREATE TABLE configuration_configuracion_historial (
 id BIGINT PRIMARY KEY,
 configuracion_id BIGINT,
 valor_anterior TEXT,
 valor_nuevo TEXT,
 usuario_id BIGINT,
 ip_address VARCHAR(50),
 user_agent TEXT,
 timestamp TIMESTAMP,
 motivo TEXT
);
```

---

## Decisión

**Opción elegida:** "App Configuration Custom"

**Justificación:**

1. **Auditoría completa**: ConfiguracionHistorial proporciona trazabilidad inmutable requerida por ISO 27001

2. **Integración perfecta**: Service layer integra directamente con sistema de permisos granulares (ADR-BACK-001)

3. **Control total**: No dependemos de librería externa, tenemos control sobre evolución del sistema

4. **Metadata rica**: Capturamos IP, user agent, timestamp para investigación de incidentes

5. **Flexibilidad**: Import/Export, categorización, restauración a defaults

6. **Trade-offs aceptados**: Desarrollo custom vs dependencia externa - justificado por requisitos de auditoría

---

## Consecuencias

### Positivas

- OK Trazabilidad completa de cambios para auditorías
- OK Modificación de configuraciones sin redespliegue
- OK Rollback simple a valores anteriores
- OK Investigación de incidentes facilitada (IP, user agent)
- OK Exportación/Importación para disaster recovery
- OK Sin dependencias externas
- OK Integración nativa con permisos granulares

### Negativas

- WARNING Código custom a mantener (mitigado con tests comprehensivos)
- WARNING Curva de aprendizaje para nuevos desarrolladores
- WARNING Tabla adicional en BD (ConfiguracionHistorial crece con tiempo)

### Neutrales

- INFO Requiere management command para seed de configuraciones iniciales
- INFO Django Admin debe extenderse para mostrar historial
- INFO Requiere definir categorías y configuraciones iniciales

---

## Plan de Implementación

1. **Fase 1: Modelos y Migrations** (Completado)
 - Crear modelos Configuracion y ConfiguracionHistorial
 - Generar migrations
 - Crear índices para performance
 - Timeframe: 1 día

2. **Fase 2: Service Layer** (Completado)
 - Implementar ConfiguracionService con 5 operaciones
 - Integrar con permisos granulares
 - Auditoría automática en cada operación
 - Timeframe: 2 días

3. **Fase 3: API REST** (Completado)
 - ViewSet DRF para CRUD
 - Endpoints especializados (export, import, restore)
 - Serializers con validaciones
 - Timeframe: 1 día

4. **Fase 4: Admin y Commands** (Completado)
 - Django Admin con inline de historial
 - Management command seed_configuraciones_default
 - Timeframe: 1 día

5. **Fase 5: Testing y Documentación** (Completado)
 - Tests unitarios de service layer
 - Tests de API
 - Documentación técnica
 - Timeframe: 1 día

**Total:** 6 días

---

## Validación y Métricas

**Criterios de Éxito:**
- Historial 100% inmutable: No deletes en ConfiguracionHistorial
- Auditoría 100% completa: Cada cambio genera entrada en historial
- Performance: Consulta de configuración < 50ms (p95)
- Cobertura de tests: > 90%

**Cómo medir:**
- Query analysis para verificar índices funcionan
- Coverage report de pytest
- Audit log review mensual
- Performance monitoring en producción

**Revisión:**
- Fecha de revisión programada: 2026-02-18 (3 meses post-implementación)
- Responsable de seguimiento: equipo-backend

---

## Alternativas Descartadas

### Django Settings Database

**Por qué se descartó:**
- No proporciona historial inmutable
- Difícil integración con permisos granulares
- NO captura metadata de auditoría

---

## Referencias

- [Documentación app configuration](../../arquitectura/configuration.md)
- [ADR-BACK-001: Grupos Funcionales Sin Jerarquía](ADR-BACK-001-grupos-funcionales-sin-jerarquia.md)
- [ISO 27001 Audit Trail Requirements](https://www.iso.org/standard/27001)
- [Django Best Practices for Configuration](https://docs.djangoproject.com/en/stable/topics/settings/)

---

## Notas Adicionales

**Decisión tomada en**: Sprint de implementación de permisos granulares (Prioridad 02)
**Implementación completada**: 2025-11-09

**Configuraciones iniciales**:
- 8 categorías predefinidas (general, seguridad, notificaciones, integraciones, etl, reportes, analytics, ivr)
- ~20 configuraciones seed
- Valores por defecto seguros (timeouts conservadores, max attempts restrictivos)

**Capacidades requeridas para uso**:
- `sistema.tecnico.configuracion.ver`: Ver configuraciones
- `sistema.tecnico.configuracion.editar`: Modificar valores
- `sistema.tecnico.configuracion.exportar`: Exportar configuraciones
- `sistema.tecnico.configuracion.importar`: Importar configuraciones masivamente
- `sistema.tecnico.configuracion.restaurar`: Restaurar a valores por defecto

---

**Documento:** ADR-BACK-002
**Fecha:** 18 de Noviembre, 2025
**Estado:** Aceptada e Implementada
**Próxima revisión:** 2026-02-18
