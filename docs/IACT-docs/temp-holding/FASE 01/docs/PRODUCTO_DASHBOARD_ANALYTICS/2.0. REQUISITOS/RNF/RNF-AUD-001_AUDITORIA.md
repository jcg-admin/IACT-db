# RNF-AUD-001_AUDITORIA.md

## Requisito No Funcional: Trazabilidad y Registro de Auditoría

| Campo | Valor |
| :--- | :--- |
| **ID RNF** | RNF-AUD-001 |
| **Dominio** | Seguridad/Forensía (Nivel 3 de Trazabilidad IACT) |
| **Alcance** | Todas las interacciones de los Actores Primarios que modifiquen el estado del sistema o accedan a Información de Identificación Personal (PII). |
| **Implementación** | Módulo `callcentersite.apps.audit` |

---

## 1. Estructura y Reglas del Registro

El registro de auditoría debe seguir la estructura del modelo **`AuditLog`** y cumplir con las siguientes reglas inmutables:

| Campo de `AuditLog` | Propósito en Trazabilidad | Regla de Contenido |
| :--- | :--- | :--- |
| **`event_type`** | **Enlace al UC-V2.** Describe la acción funcional. | Debe ser un `str` definido y citarse en la **Postcondición** del UC (Ej: `CALL_START` para UC-010). |
| **`user`** | **Identidad del Actor.** | Debe ser el `User` autenticado. (Permite `NULL` para eventos de sistema/cronjobs). |
| **`resource`** | **Módulo/Recurso afectado.** | Nombre del Módulo o Recurso (Ej: `llamada`, `usuario`, `politica`). |
| **`ip_address`** | **Contexto de Seguridad.** | IP de origen de la solicitud. |
| **`timestamp`** | **Secuencia Forense.** | Fecha y hora de creación (automática e inmutable). |
| **`result`** | **Resultado de la Acción.** | `success` o `failure`. (Manejado automáticamente por `@audit_action`). |
| **`details`** | **Metadata Específica.** | `JSONField` para almacenar datos relevantes (Ej: `{'session_key': 'abc'}` en caso de `SESSION_TIMEOUT`). |

## 2. Implementación Obligatoria

Todos los Casos de Uso (UC-V2) deben asegurar que el registro de auditoría ocurre mediante uno de los siguientes mecanismos:

### A. Decorador de Vista (Para Vistas DRF)
- **Uso:** En las `views.py` (Vistas de DRF) o métodos `ViewSet` que ejecuten lógica de negocio.
- **Artefacto de Soporte:** `audit/decorators.py`
- **Ejemplo de UC-010:** Si `registrar_llamada_entrante` tiene una vista asociada, se usa:
  ```python
  @audit_action(action='LLAMADA_REGISTRO', resource='llamada')
  def post(self, request):
      # ... llama a LlamadaService.registrar_llamada_entrante
  ```

### B. Llamada Directa (Para Servicios Internos)

- **Uso:** Dentro de los métodos de servicio (`services.py`) donde el contexto de la solicitud no está presente.
- **Artefacto de Soporte:** `audit/services.py` (`AuditService.log`)
- **Ejemplo:** El servicio **UC-010** debe invocar a `AuditService.log` al finalizar el registro, o delegar esta responsabilidad a la capa de vista a través del decorador.
