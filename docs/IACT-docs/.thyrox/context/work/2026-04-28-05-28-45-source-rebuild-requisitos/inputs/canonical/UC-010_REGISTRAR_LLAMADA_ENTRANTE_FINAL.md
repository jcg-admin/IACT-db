# UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md

## Caso de Uso Completo IACT (UC-V2)

| Campo | Valor |
| :--- | :--- |
| **ID del Caso de Uso** | UC-010 |
| **Nombre** | Registrar Llamada Entrante |
| **Módulo Principal** | `llamadas` |
| **Versión** | 1.1.0 (Final, con BR-SEG y RNF consolidados) |
| **Objetivo** | Registrar una interacción telefónica, garantizando autorización previa, captura de metadatos del cliente y auditoría conforme al estándar IACT. |

---

## Actores y Reglas Asociadas

| Rol | Tipo | Descripción |
| :--- | :--- | :--- |
| **Agente** | Primario | Atiende y registra la llamada (`agente_id`). |
| **Sistema IVR** | Secundario | Puede iniciar la solicitud de registro. |
| **PermisoService** | Soporte | Motor de autorización (BR-SEG). |
| **AuditService / @audit_action** | Soporte | Registra la postcondición de auditoría (RNF-AUD-001). |

**Reglas de Negocio Relacionadas (BR-XXX)**

| ID BR | Tipo | Descripción |
| :--- | :--- | :--- |
| **BR-SEG-007** | Seguridad/Autorización | El actor debe contar con la capacidad `sistema.operaciones.llamadas.registrar` antes de ejecutar la acción (ver `CATALOGO_BR_SEGURIDAD`). |
| **BR-NEG-012** | Negocio/Validación | El `numero_telefono` debe cumplir el formato de contacto admitido por el call center. |

**Requisitos No Funcionales (RNF) Vinculados**

| ID RNF | Alcance | Implementación |
| :--- | :--- | :--- |
| **RNF-AUD-001** | Auditoría forense | Registro obligatorio del evento `LLAMADA_REGISTRO` con `AuditLog` (ver `RNF/RNF-AUD-001_AUDITORIA.md`). |
| **RNF-PERF-001** | Métricas/Desempeño | Datos generados alimentan `obtener_estadisticas_agente` para dashboards internos. |

---

## Flujo Normal (Registrar con Éxito)

| Paso | Acción del Actor | Respuesta del Sistema |
| :--- | :--- | :--- |
| **1.** | El actor envía la solicitud con `agente_id`, `numero_telefono`, `tipo_id` y metadatos opcionales. | |
| **2.** |  | **Autoriza**: se invoca `PermisoService.usuario_tiene_permiso` con la capacidad `sistema.operaciones.llamadas.registrar` (BR-SEG-007). Si falla, se lanza `PermissionDenied`. |
| **3.** |  | **Valida**: el `agente_id` existe y está activo; el `TipoLlamada` está habilitado. |
| **4.** |  | **Inicializa estado**: obtiene el estado `en_curso`; si no existe, se crea para mantener continuidad operativa. |
| **5.** |  | **Registra llamada**: crea `Llamada` con `fecha_inicio = timezone.now()` y datos del cliente. |
| **6.** |  | **Audita**: registra el evento `LLAMADA_REGISTRO`/`llamada_registrada` conforme a RNF-AUD-001 (decorador de vista o `PermisoService.registrar_acceso`). |
| **7.** |  | **Retorna** el objeto `Llamada` con identificador y metadatos iniciales. |

---

## Artefactos de Trazabilidad

| Tipo de Artefacto | ID de Referencia | Servicios/Clases Implementadoras |
| :--- | :--- | :--- |
| **Servicio Principal** | UC-010 | `LlamadaService.registrar_llamada_entrante` |
| **Regla de Seguridad** | BR-SEG-007 | `PermisoService.usuario_tiene_permiso` (capacidad `sistema.operaciones.llamadas.registrar`) |
| **Catálogo de Seguridad** | CATALOGO_BR_SEGURIDAD | `Capacidad`/`FuncionCapacidad` (origen de BR-SEG) |
| **Postcondición RNF** | RNF-AUD-001 | `AuditLog` vía `@audit_action` o `AuditService.log` | 
| **Postcondición Métrica** | RNF-PERF-001 | `LlamadaService.obtener_estadisticas_agente` | 

---

## Validación y evidencia mínima

- **Tests**: Deben cubrir la autorización fallida y exitosa, creación de `Llamada` y generación de auditoría (mín. 80% coverage del flujo). 
- **CI/CD**: Integrar validadores de trazabilidad que comprueben referencias UC ↔ BR-SEG ↔ RNF en RTM-IACT.
- **Evidencia**: Registrar en la matriz RTM el enlace a pruebas, APIs y artefactos de auditoría generados.
