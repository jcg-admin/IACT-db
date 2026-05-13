# CATALOGO_BR_SEGURIDAD.md

## 1. Propósito y Alcance

El Catálogo de Reglas de Seguridad (BR-SEG-XXX) consolida las capacidades de autorización que gobiernan el acceso a funcionalidades críticas del producto de dashboards y analíticas. Cada BR-SEG se deriva de las **capacidades** definidas en `callcentersite.apps.permissions.models.Capacidad` y se verifica en tiempo de ejecución a través de `PermisoService.usuario_tiene_permiso`.

- **Nivel IACT:** Nivel 1 (Reglas de Negocio – Seguridad)
- **Módulos fuente:** `permissions/models.py`, `permissions/services.py`
- **Artefactos dependientes:** Casos de Uso UC-V2, APIs, pruebas funcionales y auditoría (RNF-AUD-001)

## 2. Estructura formal de una BR-SEG

| Campo | Definición | Fuente en el código |
| :--- | :--- | :--- |
| **ID BR-SEG** | Identificador único (ej.: BR-SEG-007). | Catálogo estático, citado por UC-V2. |
| **Capacidad asociada** | `Capacidad.nombre_completo` (ej.: `sistema.operaciones.llamadas.registrar`). | `permissions.models.Capacidad` |
| **Función/Módulo** | Agrupador funcional de la capacidad. | `permissions.models.Funcion` vía `FuncionCapacidad` |
| **Implementación** | Servicio que evalúa la autorización. | `permissions.services.PermisoService.usuario_tiene_permiso` |
| **Excepciones** | Concesiones o revocaciones puntuales. | `permissions.models.PermisoExcepcional` |
| **Auditoría** | Registro obligatorio cuando la capacidad lo requiere. | `permissions.models.AuditoriaPermiso` + RNF-AUD-001 |

## 3. Reglas de Seguridad priorizadas

Las siguientes BR-SEG controlan las capacidades críticas de negocio y deben citarse como precondición en los UC-V2 relevantes.

| ID BR-SEG | Capacidad (código) | Función/Contexto | Uso en UC/Servicio | Implementación en código |
| :--- | :--- | :--- | :--- | :--- |
| **BR-SEG-007** | `sistema.operaciones.llamadas.registrar` | Operaciones → Llamadas | Precondición del **UC-010 Registrar Llamada Entrante**. | `PermisoService.usuario_tiene_permiso` en `llamadas/services.py` |
| **BR-SEG-021** | `sistema.operaciones.llamadas.finalizar` | Operaciones → Llamadas | Controla el cierre de llamadas y cálculo de métricas de tiempo. | `PermisoService.usuario_tiene_permiso` en `LlamadaService.finalizar_llamada` |
| **BR-SEG-105** | `sistema.analytics.reportes.ver` | Analíticas → Dashboards | Restringe la visualización de reportes con PII y métricas internas. | Uso esperado en vistas de reportes (`@audit_action` recomendado) |

## 4. Gobernanza y versionado

| Flujo | Servicio/Modelo | Implicación de trazabilidad |
| :--- | :--- | :--- |
| **Creación/Actualización de capacidad** | `Capacidad` + `FuncionCapacidad` | Cambios requieren actualización del ID BR-SEG y su cita en UC-V2/API/Tests. |
| **Asignación por grupos** | `UsuarioGrupo` + `GrupoCapacidad` | Determina quién puede ejercer la capacidad; debe reflejarse en matrices RTM-IACT. |
| **Permiso excepcional** | `PermisoExcepcional` | Permite concesión/revocación temporal; el BR-SEG debe documentar el escenario de excepción. |
| **Auditoría obligatoria** | `AuditoriaPermiso` | Si `Capacidad.requiere_auditoria=True`, registrar el evento enlazado a RNF-AUD-001. |

## 5. Checklist de cumplimiento para UC-V2

1) **Precondición**: El UC cita el ID BR-SEG y la capacidad exacta (`nombre_completo`).
2) **Implementación**: El servicio invoca `PermisoService.usuario_tiene_permiso` antes de ejecutar la lógica de negocio.
3) **Excepciones**: Documentar si existe `PermisoExcepcional` para el actor.
4) **Auditoría**: Si la capacidad requiere auditoría, invocar el flujo definido en RNF-AUD-001.
5) **RTM**: Actualizar la matriz de trazabilidad para reflejar UC ↔ BR-SEG ↔ Código ↔ Tests.
