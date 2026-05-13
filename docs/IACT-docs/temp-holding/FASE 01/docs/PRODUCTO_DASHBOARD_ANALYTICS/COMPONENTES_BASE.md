# Componentes base reutilizables para PRODUCTO_DASHBOARD_ANALYTICS

## Propósito
Este documento resume los módulos técnicos ya disponibles en el backend (callcentersite) que sirven como cimientos para el producto de dashboards y analíticas. El objetivo es acelerar la adopción del estándar de trazabilidad IACT (TRZ-001) en el dominio de datos analíticos, asegurando que las capacidades de seguridad, auditoría y métrica estén listas antes de construir nuevas vistas o APIs.

## Mapeo de módulos a necesidades del Dashboard
| Dominio | Módulo / Servicio | Cómo aporta al producto analítico | Artefactos de trazabilidad relacionados |
| :--- | :--- | :--- | :--- |
| Autenticación | `authentication` (JWT, bloqueo y validadores) | Expone inicio de sesión y refresco seguro para el frontend del dashboard. El bloqueo de usuarios protege el consumo de APIs de datos sensibles. | **UC-010** (precondición de autenticación); futuras vistas deben citar **RNF-AUD-001** para eventos de login. |
| Autorización | `permissions` (`PermisoService`, `Capacidad`, `GrupoPermisos`) | Permite modelar capacidades específicas de reportes, por ejemplo `sistema.analisis.dashboard.ver_ventas` y `sistema.analisis.reportes.exportar`. Controla quién puede ver, filtrar o exportar datos. | **CATALOGO_BR_SEGURIDAD.md** (BR-SEG-007 como patrón), **INDICE_TRAZABILIDAD_MAESTRA_IACT.md**. |
| Auditoría | `audit` (`AuditLog`, decorador `@audit_action`) | Registra accesos y acciones sobre datos PII/financieros. Asegura trazabilidad forense de consultas, exportaciones y cambios de configuración. | **RNF-AUD-001_AUDITORIA.md** y referencias en **UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md**. |
| Métricas y datos crudos | `llamadas.services.LlamadaService.obtener_estadisticas_agente` | Ejemplo existente de cálculo de KPIs (totales, promedios). Sirve como plantilla para crear un `AnalyticsService` que produzca métricas del dashboard (ventas, atención) sin depender de DORA. | **UC-010** (métricas de llamadas), **INDICE_TRAZABILIDAD_MAESTRA_IACT.md**. |

## Recomendaciones de adaptación al dominio de analíticas
1. **Definir capacidades por reporte**: Crear capacidades con prefijo `sistema.analisis.*` y asociarlas a grupos funcionales (visualización, exportación, administración). Actualizar **CATALOGO_BR_SEGURIDAD.md** con las nuevas BR-SEG derivadas.
2. **Forzar auditoría en exportaciones**: Toda ruta que exponga PII o datos financieros debe usar `@audit_action` o `AuditService.log` y citar **RNF-AUD-001** en la especificación de API/UC correspondiente.
3. **Modelar KPIs en servicios**: Replicar el patrón de `obtener_estadisticas_agente` en un módulo `analytics.services` para aislar la lógica de cálculo de KPIs y habilitar pruebas unitarias TDD.
4. **Trazabilidad en APIs**: Al documentar endpoints de dashboards, incluir referencias `uc_refs`, `br_refs` y `rnf_refs` en los esquemas (p. ej. `@extend_schema`) para mantener la cadena **BR → UC → Código → Evidencia**.
5. **CI/CD y cobertura**: Mantener pruebas para las nuevas capacidades y servicios con cobertura mínima de 80%, siguiendo el ciclo Red→Green→Refactor. Incorporar validaciones de permisos y auditoría en los tests para cada CU.

## Próximos pasos sugeridos
- Diseñar la matriz de capacidades del dashboard y actualizar **CATALOGO_BR_SEGURIDAD.md** con BR-SEG específicas de reportes y exportaciones.
- Crear casos de uso UC-V2 para reportes clave (ej. UC-REP-001: Generar reporte de agentes) citando las BR y RNF anteriores.
- Extender **INDICE_TRAZABILIDAD_MAESTRA_IACT.md** con los nuevos artefactos una vez que se publiquen los UC y servicios correspondientes.
