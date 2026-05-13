# UC-010_REGISTRAR_LLAMADA_ENTRANTE.md

## Caso de Uso Completo IACT (UC-V2)

| Campo | Valor |
| :--- | :--- |
| **ID del Caso de Uso** | UC-010 |
| **Nombre** | Registrar Llamada Entrante |
| **Módulo Principal** | `llamadas` |
| **Versión** | 1.0.0 (Basado en `llamadas/services.py`) |
| **Objetivo** | Iniciar el registro de una nueva interacción telefónica en el sistema, asegurando que todos los metadatos esenciales y la trazabilidad de Agente/Cliente queden establecidos. |

---

## Actores y Reglas Asociadas

| Rol | Tipo | Descripción |
| :--- | :--- | :--- |
| **Agente** | Primario | Actor que atiende y registra la llamada (es el `agente_id`). |
| **Sistema IVR** | Secundario | Puede generar la solicitud inicial (iniciador de la llamada). |
| **`PermisoService`** | Secundario | Motor de **Autorización** que valida el privilegio del Agente. |

**Reglas de Negocio Relacionadas (BR-XXX)**

| ID BR (Pendiente de formalizar) | Tipo | Descripción |
| :--- | :--- | :--- |
| **BR-SEG-007** | Seguridad/Autorización | El Agente debe poseer el permiso `sistema.operaciones.llamadas.registrar` antes de iniciar el registro. Implementado con `PermisoService`. |
| **BR-NEG-012** | Negocio/Validación | El campo `numero_telefono` debe seguir el formato estándar nacional o internacional definido para el call center. |

---

## Flujo Normal (Registrar con Éxito)

| Paso | Acción del Actor | Respuesta del Sistema |
| :--- | :--- | :--- |
| **1.** | El Agente (o IVR) envía la solicitud de registro con `agente_id`, `numero_telefono`, `tipo_id` y metadatos opcionales. | |
| **2.** | | Verifica `BR-SEG-007` vía `PermisoService`. Si falla, lanza `PermissionDenied`. |
| **3.** | | Valida que el `agente_id` exista y esté activo. |
| **4.** | | Obtiene el `EstadoLlamada` inicial con código `en_curso`; si no existe, lo crea para asegurar continuidad operativa. |
| **5.** | | Crea un nuevo objeto `Llamada` con `fecha_inicio = timezone.now()` y metadatos de cliente. |
| **6.** | | Registra el evento de auditoría `llamada_registrada` asociado al permiso usado y retorna el objeto `Llamada`. |

---

## Artefactos de Trazabilidad

| Tipo de Artefacto | ID de Referencia | Servicios/Clases Implementadoras |
| :--- | :--- | :--- |
| **Servicio Principal** | UC-010 | `LlamadaService.registrar_llamada_entrante` |
| **Motor de Autorización** | BR-SEG-007 | `callcentersite.apps.permissions.services.PermisoService` |
| **Postcondición RNF** | RNF-AUD-001 | Registrar auditoría del evento `llamada_registrada` para el recurso `llamada.codigo`, siguiendo el estándar de `AuditLog`. |
| **Postcondición Métrica** | RNF-PERF-001 | La llamada registrada alimenta `obtener_estadisticas_agente` para `total_llamadas` y `promedio_duracion`. |
