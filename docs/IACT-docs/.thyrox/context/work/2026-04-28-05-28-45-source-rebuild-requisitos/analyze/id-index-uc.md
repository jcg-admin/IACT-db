```yml
created_at: 2026-04-28 18:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (concentracion: indice maestro de IDs)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Indice Maestro de IDs — UC

Total IDs unicos UC: **401**

Producido por scan automatizado (`/tmp/index_requirements_ids.py`) sobre todos los `inputs/` de los 16 WPs hijos.

## IDs detectados

| ID | # apariciones | WPs distintos | Contexto sample |
|----|---------------|---------------|----------------|
| `UC-000` | 6 | base-cognitiva, arquitectura-tecnica | grep -r "UC-0" .   wc -l  # Debe ser 0 |
| `UC-001` | 562 | base-cognitiva, normativa-estandares, normativa-procedimientos (+7) |   `canonical/UC-001-ejemplo.md`   `temp-holding/FASE 01/docs/frontend/requisitos/requerimientos_usuario/casos_uso/UC-001 |
| `UC-002` | 225 | base-cognitiva, normativa-estandares, normativa-procedimientos (+7) | UC-002: Cerrar Sesión |
| `UC-003` | 184 | base-cognitiva, normativa-estandares, normativa-procedimientos (+7) | UC-003: Refrescar Token |
| `UC-004` | 896 | base-cognitiva, normativa-estandares, normativa-procedimientos (+7) | UC-004: Cambiar Contraseña |
| `UC-005` | 249 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) |   696   UC-005 a UC-011   UC_USR_XX, UC_ACC_XX   Trazabilidad RBAC   |
| `UC-006` | 199 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) |   265-274   UC-006 a UC-009, UC-010, UC-017-024, etc.   UC_USR_XX, UC_ACC_XX, UC_RPT_XX   Tabla agrupadores   |
| `UC-007` | 496 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) |   230   UC-006, UC-007, UC-008   UC_USR_01, 02, 03   Validación permisos   |
| `UC-008` | 81 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) |   230   UC-006, UC-007, UC-008   UC_USR_01, 02, 03   Validación permisos   |
| `UC-009` | 253 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) |   265-274   UC-006 a UC-009, UC-010, UC-017-024, etc.   UC_USR_XX, UC_ACC_XX, UC_RPT_XX   Tabla agrupadores   |
| `UC-010` | 555 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | El proyecto IACT migró de nomenclatura **v2.0** (UC-010, UC-043) a **v4.0.0** (UC_ACC_01, UC_ACC_05) en enero 2026. |
| `UC-011` | 214 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) |   35   9 (UC-010, UC-011...)   9 (UC_ACC_01...)   Resumen   |
| `UC-012` | 94 | base-cognitiva, normativa-estandares, normativa-gobernanza (+4) |   251   UC-012 a UC-016, UC-043   UC_AUD_XX, UC_ACC_05   Administración   |
| `UC-013` | 29 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-013: Validate Python Version |
| `UC-014` | 19 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-014: Validate Node.js Version |
| `UC-015` | 136 | base-cognitiva, normativa-estandares, normativa-gobernanza (+4) |   490   UC-015   UC_RPT_XX   Ejemplo nomenclatura   |
| `UC-016` | 29 | base-cognitiva, normativa-estandares, normativa-gobernanza (+4) |   251   UC-012 a UC-016, UC-043   UC_AUD_XX, UC_ACC_05   Administración   |
| `UC-017` | 146 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) |   265-274   UC-006 a UC-009, UC-010, UC-017-024, etc.   UC_USR_XX, UC_ACC_XX, UC_RPT_XX   Tabla agrupadores   |
| `UC-018` | 112 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-018   UC_RPT_02   Consultar Problemas Menú   |
| `UC-019` | 51 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-019   UC_RPT_03   Consultar Transferencias   |
| `UC-020` | 139 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) |   UC-020   UC_RPT_04   Filtrar Por Fecha   |
| `UC-021` | 79 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) |   UC-021   UC_RPT_05   Filtrar Por Centro   |
| `UC-022` | 101 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) |   220   UC-022   UC_RPT_06   Ejemplo UC Proceso   |
| `UC-023` | 63 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-023   UC_RPT_07   Exportar Excel   |
| `UC-024` | 88 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   239   UC-017 a UC-024   UC_RPT_01-14   Reportes   |
| `UC-025` | 121 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   217   UC-025   UC_RPT_09   Ejemplo UC Consulta   |
| `UC-026` | 29 | base-cognitiva, normativa-estandares, requisitos (+2) |   UC-026   UC_RPT_10   Ver KPIs   |
| `UC-027` | 41 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   UC-027   UC_RPT_11   Ver Tendencias   |
| `UC-028` | 65 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   UC-028   UC_RPT_12   Ver Gráfico Hora   |
| `UC-029` | 50 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   UC-029   UC_RPT_13   Ver Gráfico Día   |
| `UC-030` | 90 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) |   242   UC-025 a UC-030   UC_RPT_09-14 (parcial)   Dashboards   |
| `UC-031` | 68 | base-cognitiva, normativa-estandares, requisitos (+3) |   245   UC-031 a UC-035   (eliminar, no existe en v4.0)   Análisis   |
| `UC-032` | 36 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | ### UC-032: Detect Missing UI Services for New API Endpoint |
| `UC-033` | 32 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | ### UC-033: Detect Missing UI Tests for API Changes |
| `UC-034` | 10 | requisitos, arquitectura-tecnica, infrastructure | ### UC-034: Analyze Django Serializer Changes |
| `UC-035` | 20 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   245   UC-031 a UC-035   (eliminar, no existe en v4.0)   Análisis   |
| `UC-036` | 127 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) |   248   UC-036 a UC-040   UC_ALR_01-05   Alertas   |
| `UC-037` | 57 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   220   UC-037   UC_ALR_01   Ejemplo UC Proceso   |
| `UC-038` | 51 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   309   UC-038   UC_ALR_XX   Disparar alerta   |
| `UC-039` | 52 | base-cognitiva, normativa-estandares, normativa-restricciones (+3) |   UC-039   UC_ALR_04   Eliminar Alerta   |
| `UC-040` | 574 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | UC-40 Paso 6: "Sistema valida formato CAS Number" |
| `UC-041` | 270 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | UC-41: Consultar Productos (simple) |
| `UC-042` | 235 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) | Aplica a: UC-40, UC-42, UC-44, UC-204, UC-208 |
| `UC-043` | 289 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) | El proyecto IACT migró de nomenclatura **v2.0** (UC-010, UC-043) a **v4.0.0** (UC_ACC_01, UC_ACC_05) en enero 2026. |
| `UC-044` | 182 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) | Aplica a: UC-40, UC-42, UC-44, UC-204, UC-208 |
| `UC-045` | 90 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) | **Nota:** UC-042 (Revocar Segmento), UC-045 (Gestionar Agrupadores) eliminados en v4.0 |
| `UC-046` | 70 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-046?   UC_ACC_06   Gestionar Segmentos   |
| `UC-047` | 62 | base-cognitiva, normativa-estandares, normativa-procedimientos (+4) |   59-103   UC-010 a UC-047   UC_ACC_01 a UC_ACC_09   Tabla UC   |
| `UC-048` | 8 | normativa-restricciones, requisitos, arquitectura-tecnica (+1) | ### UC-048: Pre-Push Validation (Comprehensive Mode) |
| `UC-049` | 13 | base-cognitiva, normativa-restricciones, requisitos (+2) | ### UC-049: CI-Local Validation (Full Mode) |
| `UC-050` | 197 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | Deriva de: UC-50 (Registrar Usuario) - Al crear cuenta |
| `UC-051` | 88 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-051   UC_PIP_02   Consultar Errores ETL   |
| `UC-052` | 76 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-052   UC_PIP_03   Consultar Disponibilidad   |
| `UC-053` | 136 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) | #### MOD_Pipeline (UC-050 a UC-053, UC-ETL) |
| `UC-054` | 54 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-054: Handle Job Dependencies |
| `UC-055` | 14 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-055: Fail-Fast on Critical Job Failure |
| `UC-056` | 19 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-056: Timeout Handling for Long-Running Jobs |
| `UC-057` | 1 | infrastructure | ### UC-057: Dry-Run Pipeline Execution |
| `UC-058` | 1 | infrastructure | ### UC-058: Generate Pipeline Execution Report |
| `UC-059` | 7 | base-cognitiva, requisitos, backend (+1) | ### UC-059: Execute Specific Stage Only |
| `UC-060` | 79 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) | #### MOD_Audit (UC-060 a UC-063) |
| `UC-061` | 423 | base-cognitiva, normativa-estandares, normativa-restricciones (+5) | Deriva de: UC-61 (Consultar Solicitudes) - KPI de disponibilidad |
| `UC-062` | 208 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) |   UC-062   UC_AUD_03   Exportar Auditoría   |
| `UC-063` | 187 | base-cognitiva, normativa-estandares, normativa-procedimientos (+6) | Deriva de: UC-63 (Consultar Disponibilidad de Producto) |
| `UC-064` | 1 | infrastructure | ### UC-064: Execute Act Phase - Apply or Revert |
| `UC-065` | 43 | base-cognitiva, requisitos, backend (+1) | ### UC-065: Track Deployment Frequency Metric |
| `UC-066` | 1 | infrastructure | ### UC-066: Track Lead Time for Changes |
| `UC-067` | 1 | infrastructure | ### UC-067: Track Change Failure Rate |
| `UC-068` | 1 | infrastructure | ### UC-068: Track Mean Time to Recovery (MTTR) |
| `UC-069` | 8 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | ### UC-069: Automated PDCA Cycle Execution |
| `UC-070` | 146 | base-cognitiva, normativa-estandares, normativa-procedimientos (+5) | #### MOD_Logs (UC-070 a UC-073) |
| `UC-071` | 63 | base-cognitiva, normativa-estandares, normativa-restricciones (+2) |   UC-071   UC_LOG_02   Filtrar Logs   |
| `UC-072` | 64 | base-cognitiva, normativa-estandares, normativa-restricciones (+2) |   UC-072   UC_LOG_03   Exportar Logs   |
| `UC-073` | 29 | base-cognitiva, normativa-estandares, normativa-procedimientos (+2) | #### MOD_Logs (UC-070 a UC-073) |
| `UC-074` | 4 | requisitos, arquitectura-tecnica | UC-74: Desactivar Proveedor (DELETE - soft) |
| `UC-075` | 6 | requisitos | UC-75: Activar Proveedor (reactivación) |
| `UC-079` | 1 | arquitectura-tecnica |   UC_074-UC_079   (Reserva futura)   Libre   |
| `UC-080` | 35 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | Evento: Notifica envío → UC-80 (NUEVO) |
| `UC-081` | 9 | base-cognitiva, requisitos, arquitectura-tecnica | Evento: Actualiza tracking → UC-81 (NUEVO) |
| `UC-082` | 6 | requisitos, arquitectura-tecnica | - **UC-082 – Descargar paquetes de logs para análisis externo** |
| `UC-083` | 7 | requisitos, arquitectura-tecnica | - **UC-083 – Consultar métricas técnicas agregadas** |
| `UC-084` | 1 | arquitectura-tecnica |   UC_084-UC_099   (Reserva futura)   Libre   |
| `UC-090` | 118 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | Excelente! 1,046 líneas más. Ahora continúo con las Subtécnicas 2.2 y 2.3 de Larman (Operaciones y Responsabilidades) co |
| `UC-091` | 14 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | UC-91: Recalcular Inventario Nocturno |
| `UC-092` | 7 | base-cognitiva, requisitos, arquitectura-tecnica | UC-92: Generar Reporte de Uso |
| `UC-093` | 29 | base-cognitiva, requisitos, backend | Decisión: ✓ GENERAR UC-93 "Recalcular Inventario Nocturno" |
| `UC-094` | 3 | base-cognitiva, requisitos | Operación: ReconciliarDatos → UC-94 (NUEVO) |
| `UC-095` | 24 | base-cognitiva, requisitos, backend | Operación: ConfigurarUmbrales → UC-95 (NUEVO) |
| `UC-096` | 2 | base-cognitiva, requisitos | Operación: DefinirPeriodo → UC-96 (NUEVO) |
| `UC-098` | 2 | base-cognitiva, requisitos | Operación: ImportarExcel → UC-98 (NUEVO) |
| `UC-099` | 9 | base-cognitiva, normativa-procedimientos, requisitos (+1) | - UC_099: Caso de uso futuro, excluido de RTM |
| `UC-100` | 40 | base-cognitiva, requisitos, arquitectura-tecnica (+1) | Catálogo:    UC-100 a UC-199 |
| `UC-101` | 12 | normativa-gobernanza, requisitos, arquitectura-tecnica | UC-101: Consultar Productos |
| `UC-102` | 5 | normativa-gobernanza, requisitos | UC-102: Ver Detalle Producto |
| `UC-103` | 7 | normativa-gobernanza, requisitos | UC-103: Actualizar Producto |
| `UC-104` | 8 | requisitos | UC-104: Desactivar Producto |
| `UC-105` | 4 | requisitos | UC-105: Registrar Proveedor |
| `UC-106` | 4 | requisitos | UC-106: Asociar Producto-Proveedor |
| `UC-107` | 4 | requisitos | UC-107: Consultar Proveedores |
| `UC-108` | 4 | requisitos | UC-108: Actualizar Proveedor |
| `UC-109` | 8 | requisitos | UC-109: Gestionar Categorías |
| `UC-110` | 243 | base-cognitiva, requisitos, arquitectura-tecnica (+2) | UC-110: Iniciar Sesión (complejo, mucha seguridad) |
| `UC-111` | 50 | base-cognitiva, requisitos, backend | UC-111: Cerrar Sesión |
| `UC-112` | 97 | base-cognitiva, requisitos, backend (+1) | Deriva de: UC-112 (Recuperar Password) - Al resetear |
| `UC-113` | 43 | base-cognitiva, requisitos, backend | UC-113: Cambiar Contraseña (ya cubierto en CRUD UC-54) |
| `UC-114` | 25 | base-cognitiva, requisitos, backend | UC-114: Verificar Autenticación MFA (Two-Factor) |
| `UC-119` | 6 | base-cognitiva, requisitos, backend | MÓDULO 1: Autenticación y Seguridad (UC-110 a UC-119) |
| `UC-120` | 40 | base-cognitiva, requisitos, backend | UC-120: Configurar Parámetros del Sistema |
| `UC-121` | 30 | base-cognitiva, requisitos, backend | UC-121: Asignar Roles a Usuario |
| `UC-122` | 2 | base-cognitiva, requisitos | - UC-122: Definir Flujos de Aprobación |
| `UC-129` | 1 | requisitos | MÓDULO 9: Configuración (UC-95, UC-120 a UC-129) |
| `UC-130` | 37 | base-cognitiva, requisitos, backend | UC-130: Consultar Log de Auditoría |
| `UC-131` | 15 | base-cognitiva, requisitos, backend | UC-131: Exportar Log de Auditoría (R especial) |
| `UC-132` | 2 | base-cognitiva, requisitos | - UC-132: Exportar Auditoría |
| `UC-139` | 1 | requisitos | MÓDULO 10: Auditoría (UC-130 a UC-139) |
| `UC-140` | 31 | base-cognitiva, requisitos, backend | - UC-140: Generar Reporte de Inventario |
| `UC-141` | 37 | base-cognitiva, requisitos, backend | Decisión: ✓ GENERAR UC-141 "Generar Reportes Mensuales" |
| `UC-142` | 7 | base-cognitiva, requisitos, backend | - UC-142: Reporte de Vencimientos |
| `UC-143` | 5 | base-cognitiva, backend | UC-143: Exportar Reporte (3 pasos) |
| `UC-149` | 1 | requisitos | MÓDULO 8: Reportes (UC-140 a UC-149, UC-200 a UC-202) |
| `UC-150` | 114 | base-cognitiva, requisitos, backend | #### UC-150: Ver Dashboard Personal (Desarrollado) |
| `UC-151` | 10 | base-cognitiva, requisitos, backend | - UC-151: Filtrar Dashboard por Fecha |
| `UC-152` | 14 | base-cognitiva, requisitos, backend | - UC-152: Exportar Gráficos |
| `UC-153` | 19 | base-cognitiva, requisitos, backend | - UC-153: Configurar Widgets |
| `UC-154` | 8 | base-cognitiva, backend | UC-154: Ver Detalle de KPI Específico |
| `UC-160` | 92 | base-cognitiva, requisitos, backend | #### UC-160: Búsqueda Avanzada de Productos |
| `UC-161` | 10 | base-cognitiva, requisitos, backend | - UC-161: Guardar Búsqueda Favorita |
| `UC-162` | 10 | base-cognitiva, requisitos, backend | - UC-162: Recuperar Búsqueda Guardada |
| `UC-163` | 6 | base-cognitiva, requisitos, backend | - UC-163: Exportar Resultados |
| `UC-165` | 4 | requisitos | UC-165 eliminado (cubierto por UC-150) |
| `UC-170` | 91 | base-cognitiva, requisitos, backend | #### UC-170: Aprobar Múltiples Solicitudes en Lote |
| `UC-181` | 18 | base-cognitiva, requisitos, backend | 6.2.1 UC-53 (CRUD Usuario) vs UC-181 (UI Preferencias) |
| `UC-190` | 73 | base-cognitiva, requisitos, backend | #### UC-190: Ver Notificaciones In-App |
| `UC-191` | 18 | base-cognitiva, backend | │   UC-191: Ver Detalle Notificación                 │ |
| `UC-192` | 13 | base-cognitiva, requisitos, backend | MÓDULO 7: Notificaciones (UC-07, UC-190 a UC-192) |
| `UC-199` | 4 | requisitos | Catálogo:    UC-100 a UC-199 |
| `UC-200` | 147 | base-cognitiva, requisitos, backend | #### UC-200: Generar Reporte OSHA |
| `UC-201` | 11 | base-cognitiva, normativa-gobernanza, requisitos | UC-201: Consultar Mis Solicitudes |
| `UC-202` | 9 | normativa-gobernanza, requisitos | UC-202: Ver Detalle Solicitud |
| `UC-203` | 8 | requisitos | UC-203: Cancelar Solicitud |
| `UC-204` | 20 | base-cognitiva, requisitos, operations | BR-015 → UC-204 → FR-204.3 → Test Case TC-204.3.1 |
| `UC-205` | 4 | requisitos | UC-205: Rechazar Solicitud |
| `UC-206` | 4 | requisitos | UC-206: Aprobar Lote |
| `UC-207` | 8 | requisitos | UC-207: Entregar Producto |
| `UC-208` | 3 | base-cognitiva, operations | Aplica a: UC-40, UC-42, UC-44, UC-204, UC-208 |
| `UC-210` | 92 | base-cognitiva, requisitos, backend | #### UC-210: Sincronizar con Sistema SAP |
| `UC-211` | 3 | base-cognitiva, requisitos | Ejemplo: UC-211 "Recibir Órdenes desde Portal" |
| `UC-217` | 4 | requisitos | UC-217 eliminado (cubierto por UC-220) |
| `UC-219` | 1 | requisitos | MÓDULO 11: Integración (UC-80, UC-210 a UC-219) |
| `UC-220` | 67 | base-cognitiva, requisitos, backend | #### UC-220: Analizar Tendencias de Uso |
| `UC-221` | 2 | base-cognitiva, requisitos | Ejemplo: UC-221 "Predecir Necesidades Futuras" |
| `UC-230` | 30 | base-cognitiva, requisitos, backend | Ejemplo: UC-230 "Realizar Backup Manual" |
| `UC-231` | 58 | base-cognitiva, requisitos, backend | #### UC-231: Administrar Respaldos del Sistema |
| `UC-239` | 1 | requisitos | MÓDULO 12: Administración (UC-230 a UC-239) |
| `UC-240` | 5 | base-cognitiva, requisitos | 5.4.4 UC-240 "Reporte Gastos por Departamento" (COMPLETO) |
| `UC-250` | 5 | base-cognitiva, backend | UC-250: "Gestionar Producto Completo" |
| `UC-299` | 4 | requisitos | Solicitudes: UC-200 a UC-299 |
| `UC-300` | 16 | requisitos | Inventario:  UC-300 a UC-399 |
| `UC-301` | 4 | requisitos | UC-301: Ajustar Stock |
| `UC-302` | 4 | requisitos | UC-302: Registrar Contenedor |
| `UC-303` | 4 | requisitos | UC-303: Marcar Vencimiento |
| `UC-304` | 16 | requisitos | UC-304: Recalcular Inventario |
| `UC-305` | 4 | requisitos | UC-305: Generar Orden de Compra |
| `UC-306` | 4 | requisitos | UC-306: Registrar Recepción |
| `UC-399` | 4 | requisitos | Inventario:  UC-300 a UC-399 |
| `UC-400` | 12 | requisitos | Usuarios:    UC-400 a UC-499 |
| `UC-401` | 4 | requisitos | UC-401: Consultar Usuarios |
| `UC-402` | 4 | requisitos | UC-402: Actualizar Usuario |
| `UC-403` | 4 | requisitos | UC-403: Desactivar Usuario |
| `UC-404` | 4 | requisitos | UC-404: Asignar Roles |
| `UC-405` | 4 | requisitos | UC-405: Gestionar Permisos |
| `UC-499` | 4 | requisitos | Usuarios:    UC-400 a UC-499 |
| `UC-500` | 19 | base-cognitiva, requisitos, operations | UC-500: Reservar Libro en Biblioteca |
| `UC-501` | 4 | requisitos | UC-501: Cerrar Sesión |
| `UC-502` | 4 | requisitos | UC-502: Recuperar Password |
| `UC-503` | 4 | requisitos | UC-503: Cambiar Password |
| `UC-504` | 4 | requisitos | UC-504: Verificar MFA |
| `UC-599` | 4 | requisitos | Admin:       UC-500 a UC-599 |
| `UC-600` | 12 | requisitos | Reportes:    UC-600 a UC-699 |
| `UC-601` | 12 | requisitos | UC-601: Reporte OSHA |
| `UC-602` | 4 | requisitos | UC-602: Reporte Uso por Depto |
| `UC-603` | 4 | requisitos | UC-603: Analizar Tendencias |
| `UC-604` | 4 | requisitos | UC-604: Exportar Datos |
| `UC-605` | 4 | requisitos | UC-605: Programar Reportes |
| `UC-699` | 4 | requisitos | Reportes:    UC-600 a UC-699 |
| `UC-700` | 8 | requisitos | UC-700: Configurar Parámetros |
| `UC-701` | 4 | requisitos | UC-701: Gestionar Respaldos |
| `UC-702` | 4 | requisitos | UC-702: Ver Logs de Auditoría |
| `UC-703` | 8 | requisitos | UC-703: Sincronizar LDAP |
| `UC-704` | 4 | requisitos | UC-704: Sincronizar SAP |
| `UC-705` | 4 | requisitos | UC-705: Importar Datos |
| `UC-706` | 4 | requisitos | UC-706: Limpiar Datos Antiguos |
| `UC-710` | 4 | requisitos | UC-710: API de Consulta de Disponibilidad |
| `UC-999` | 1 | normativa-gobernanza | relative link '../anexos/diagramas/casos_de_uso/UC-999.puml'. |
| `UC-A-001` | 20 | requisitos | UC-A1: Registrar Empleado (CRUD) |
| `UC-A-002` | 11 | requisitos | UC-A2: Dar de Alta Empleado (Stakeholder - RH) |
| `UC-ACC-001` | 248 | base-cognitiva, normativa-estandares, normativa-restricciones (+4) | - Módulo de Control de Acceso (BR-087, UC-ACC-01) |
| `UC-ACC-002` | 50 | base-cognitiva, normativa-estandares, requisitos (+1) |   110-168   UC-010, UC-011, UC-041   UC_ACC_01, UC_ACC_02, etc.   Descripciones   |
| `UC-ACC-003` | 38 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-044   UC_ACC_03   Consultar Permisos   |
| `UC-ACC-004` | 39 | base-cognitiva, normativa-estandares, requisitos (+1) |   -   UC_ACC_04   Asignar Agrupador (nuevo)   |
| `UC-ACC-005` | 114 | base-cognitiva, normativa-estandares, requisitos (+1) | El proyecto IACT migró de nomenclatura **v2.0** (UC-010, UC-043) a **v4.0.0** (UC_ACC_01, UC_ACC_05) en enero 2026. |
| `UC-ACC-006` | 47 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-046?   UC_ACC_06   Gestionar Segmentos   |
| `UC-ACC-007` | 39 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-041   UC_ACC_07   Asignar Segmento   |
| `UC-ACC-008` | 42 | base-cognitiva, normativa-estandares, requisitos (+1) |   -   UC_ACC_08   Permiso Temporal (nuevo)   |
| `UC-ACC-009` | 65 | base-cognitiva, normativa-estandares, normativa-restricciones (+2) |   59-103   UC-010 a UC-047   UC_ACC_01 a UC_ACC_09   Tabla UC   |
| `UC-ADM-010` | 3 | normativa-gobernanza | 2. **UC-AUT-001-Esc-02 (Login fallido con bloqueo)**: crear el UC en `docs/trazabilidad/casos_de_uso/UC-AUT-001.md` con  |
| `UC-ADR-001` | 2 | normativa-gobernanza | - UC-ADR-001: Crear nuevo ADR |
| `UC-ADR-002` | 2 | normativa-gobernanza | - UC-ADR-002: Validar ADRs |
| `UC-ADR-003` | 2 | normativa-gobernanza | - UC-ADR-003: Estandarizar nomenclatura |
| `UC-ADR-004` | 2 | normativa-gobernanza | - UC-ADR-004: Actualizar indice maestro |
| `UC-ADR-005` | 2 | normativa-gobernanza | - UC-ADR-005: Actualizar referencias |
| `UC-AI-002` | 1 | normativa-gobernanza |   RN-AI-H-003   RNE-AI-003   UC-AI-002    RF-AI-003    |
| `UC-AI-010` | 1 | normativa-gobernanza |   RN-AI-H-002   RNE-AI-002   UC-AI-010    RF-AI-012    |
| `UC-ALERT-001` | 4 | backend | - UC-ALERT-001: Configurar alertas |
| `UC-ALERT-002` | 4 | backend | - UC-ALERT-002: Recibir notificaciones |
| `UC-ALR-001` | 273 | base-cognitiva, normativa-estandares, requisitos (+1) |   220   UC-037   UC_ALR_01   Ejemplo UC Proceso   |
| `UC-ALR-002` | 44 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-037   UC_ALR_02   Consultar Alertas   |
| `UC-ALR-003` | 36 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-038   UC_ALR_03   Pausar Alerta   |
| `UC-ALR-004` | 31 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-039   UC_ALR_04   Eliminar Alerta   |
| `UC-ALR-005` | 42 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-040   UC_ALR_05   Gestionar Destinatarios   |
| `UC-ANALYTICS-001` | 2 | backend | - UC-ANALYTICS-001: Consultar Métricas Dashboard |
| `UC-ANALYTICS-002` | 1 | backend | - UC-ANALYTICS-002: Consultar Métricas Complejas |
| `UC-ANALYTICS-003` | 1 | backend | - UC-ANALYTICS-003: Descargar Métricas Período |
| `UC-AUD-001` | 64 | base-cognitiva, normativa-estandares, requisitos (+1) |   audit/   index.rst   UC_AUD_01-04   [NOT_VERIFIED]   |
| `UC-AUD-002` | 27 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-061   UC_AUD_02   Generar Reporte Compliance   |
| `UC-AUD-003` | 51 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-062   UC_AUD_03   Exportar Auditoría   |
| `UC-AUD-004` | 38 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-063   UC_AUD_04   Registrar Evento   |
| `UC-AUT-001` | 17 | normativa-gobernanza, requisitos | 7.1.2 Opción 2: Por Módulo (UC-AUT-01, UC-INV-01, ...) |
| `UC-AUT-002` | 1 | normativa-gobernanza | - `RNF-SEG-002 Complejidad de contraseña`: `validate_password_complexity` en `validators.py`, vinculado a `UC-AUT-002 Ca |
| `UC-AUT-004` | 1 | normativa-gobernanza | - **Nivel 6 API/Vistas**: los endpoints `/auth/login/` y `/auth/refresh/` trazan directamente a `UC-AUT-001` y `UC-AUT-0 |
| `UC-AUTH-001` | 159 | base-cognitiva, normativa-estandares, normativa-gobernanza (+4) | * - UC-AUTH-01 |
| `UC-AUTH-002` | 44 | base-cognitiva, normativa-estandares, requisitos (+2) |   614-616   UC-001, UC-002, UC-003   UC_AUTH_01, UC_AUTH_02, UC_AUTH_03   Ejemplos autenticación   |
| `UC-AUTH-003` | 46 | base-cognitiva, normativa-estandares, requisitos (+2) |   614-616   UC-001, UC-002, UC-003   UC_AUTH_01, UC_AUTH_02, UC_AUTH_03   Ejemplos autenticación   |
| `UC-AUTH-004` | 36 | base-cognitiva, normativa-estandares, requisitos (+2) |   UC-004   UC_AUTH_04   Cambiar Contraseña   |
| `UC-AUTH-005` | 64 | base-cognitiva, normativa-estandares, normativa-gobernanza (+3) | - UC-AUTH-05 (Listar Notificaciones) |
| `UC-AUTH-007` | 14 | base-cognitiva, normativa-gobernanza, operations (+1) | - UC-AUTH-07: Notificar Sesion Proxima a Expirar |
| `UC-AUTH-008` | 30 | base-cognitiva, normativa-gobernanza, operations | Nota: Este UC_AUTH_08 es INTERNO, documenta el proceso cron, |
| `UC-B-001` | 14 | requisitos | UC-B1: Modificar Datos de Empleado (CRUD) |
| `UC-B-002` | 14 | requisitos | UC-B2: Actualizar Información Personal (Larman - Evento) |
| `UC-BACK-001` | 134 | normativa-procedimientos, normativa-gobernanza | UC-BACK-001-iniciar-sesion.md |
| `UC-BACK-002` | 19 | normativa-procedimientos, normativa-gobernanza | - UC-BACK-002: Cerrar Sesión |
| `UC-BACK-003` | 38 | normativa-procedimientos, normativa-gobernanza | - UC-BACK-003: Cambiar Contraseña |
| `UC-BACK-004` | 31 | normativa-procedimientos, normativa-gobernanza | - UC-BACK-004: Recuperar Contraseña |
| `UC-BACK-005` | 8 | normativa-procedimientos, normativa-gobernanza | - UC-BACK-005: Configurar 2FA |
| `UC-BACK-009` | 1 | normativa-procedimientos | # Ejemplo salida: UC-BACK-009-cambiar-contrasena.md |
| `UC-BACK-010` | 19 | normativa-procedimientos, normativa-gobernanza | UC-BACK-010-gestionar-permisos.md |
| `UC-BACK-011` | 1 | normativa-procedimientos | - UC-BACK-011: Editar Usuario |
| `UC-BACK-012` | 1 | normativa-procedimientos | - UC-BACK-012: Desactivar Usuario |
| `UC-BACK-013` | 1 | normativa-procedimientos | - UC-BACK-013: Consultar Usuarios |
| `UC-BACK-014` | 1 | normativa-procedimientos | - UC-BACK-014: Asignar Roles |
| `UC-BACK-015` | 6 | normativa-procedimientos, normativa-gobernanza | UC-BACK-015-solicitar-producto-quimico.md |
| `UC-BACK-016` | 1 | normativa-gobernanza | UC-BACK-016: Revocar Consentimiento de Datos |
| `UC-BACK-017` | 1 | normativa-gobernanza | UC-BACK-017: Consultar Historial de Consentimientos |
| `UC-BACK-018` | 1 | normativa-gobernanza | UC-BACK-018: Exportar Datos Personales (Derecho ARCO) |
| `UC-BACK-020` | 20 | normativa-procedimientos, normativa-gobernanza | UC-BACK-020-generar-reporte-auditoria.md |
| `UC-BACK-021` | 5 | normativa-gobernanza | UC-PERM-001 → UC-BACK-021 (o UC-FRONT-021) |
| `UC-BACK-022` | 2 | normativa-gobernanza | UC-PERM-002 → UC-BACK-022 |
| `UC-BACK-023` | 1 | normativa-gobernanza | UC-PERM-003 → UC-BACK-023 |
| `UC-BACK-030` | 1 | normativa-gobernanza | **Contexto**: UC-BACK-030 Solicitar Producto Químico |
| `UC-BACK-031` | 1 | normativa-gobernanza | UC-CALL-001 → UC-BACK-031 |
| `UC-BACK-032` | 1 | normativa-gobernanza | UC-CALL-002 → UC-BACK-032 |
| `UC-BACK-040` | 4 | normativa-gobernanza | **UC-BACK-040: Solicitar Producto Químico Peligroso** |
| `UC-BACK-041` | 1 | normativa-gobernanza | UC-BACK-041: Registrar Capacitación de Seguridad |
| `UC-BACK-042` | 1 | normativa-gobernanza | UC-BACK-042: Validar Certificación de Usuario |
| `UC-BACK-043` | 1 | normativa-gobernanza | UC-BACK-043: Aprobar Solicitud de Producto Químico |
| `UC-BACK-050` | 3 | normativa-gobernanza | **UC-BACK-050: Procesar Pago** |
| `UC-BACK-051` | 1 | normativa-gobernanza | UC-BACK-051: Consultar Historial de Transacciones |
| `UC-BACK-052` | 1 | normativa-gobernanza | UC-BACK-052: Generar Reporte de Auditoría |
| `UC-BACK-053` | 1 | normativa-gobernanza | UC-BACK-053: Exportar Log de Transacciones |
| `UC-BACK-200` | 1 | normativa-gobernanza | UC-BACK-200: Generar Factura Electrónica |
| `UC-BACK-999` | 1 | normativa-gobernanza | UC-BACK-999: Cambiar Color de Fondo |
| `UC-BACKEND-001` | 1 | backend | **ID**: UC-BACKEND-001 |
| `UC-BANK-001` | 15 | normativa-gobernanza | **UC-BANK-001: Solicitar Apertura de Cuenta** |
| `UC-BUZON-001` | 1 | backend | """UC-BUZON-01: Enviar mensaje de un usuario a otro.""" |
| `UC-C-001` | 10 | requisitos | UC-C1: Consultar Lista de Empleados (CRUD) |
| `UC-C-002` | 14 | requisitos | UC-C2: Buscar Empleado (UI) |
| `UC-CALL-001` | 14 | normativa-gobernanza, backend |   `UC-CALL-001_registrar_llamada_entrante.md`   UC-CALL-001   Dominio inválido (CALL no es válido)   |
| `UC-CALL-002` | 11 | normativa-gobernanza, backend |   `UC-CALL-002_atender_llamada.md`   UC-CALL-002   Dominio inválido (CALL no es válido)   |
| `UC-CALL-003` | 8 | normativa-gobernanza, backend |   `UC-CALL-003_transferir_llamada.md`   UC-CALL-003   Dominio inválido (CALL no es válido)   |
| `UC-CALL-004` | 6 | normativa-gobernanza |   `UC-CALL-004_generar_reporte_rendimiento.md`   UC-CALL-004   Dominio inválido (CALL no es válido)   |
| `UC-CHEM-005` | 3 | requisitos | UC_CHEM_05: Activar Sistema de Emergencia ESD |
| `UC-CHEM-010` | 1 | requisitos | UC_CHEM_10: Gestionar Equipos de Proceso |
| `UC-CHEM-011` | 1 | requisitos | UC_CHEM_11: Gestionar Corrientes de Proceso |
| `UC-CHEM-012` | 1 | requisitos | UC_CHEM_12: Gestionar Instrumentación |
| `UC-CHEM-020` | 1 | requisitos | - Operador ajusta setpoint → UC_CHEM_20 |
| `UC-CHEM-021` | 1 | requisitos | - Operador inicia batch → UC_CHEM_21 |
| `UC-CHEM-022` | 1 | requisitos | - Sistema detecta falla → UC_CHEM_22 |
| `UC-CHEM-030` | 1 | requisitos | - Dashboard de operación → UC_CHEM_30: Monitorear Proceso |
| `UC-CHEM-031` | 1 | requisitos | - Alarmas y eventos → UC_CHEM_31: Gestionar Alarmas |
| `UC-CHEM-032` | 1 | requisitos | - Tendencias históricas → UC_CHEM_32: Analizar Tendencias |
| `UC-CHEM-040` | 1 | requisitos | → UC_CHEM_40: Optimizar Parámetros de Operación |
| `UC-CHEM-041` | 1 | requisitos | → UC_CHEM_41: Simular Cambios de Proceso |
| `UC-D-001` | 16 | requisitos | UC-D1: Calcular Nómina (Stakeholder) |
| `UC-D-002` | 16 | requisitos | UC-D2: Procesar Pago de Nómina (Larman - Operación) |
| `UC-DASH-001` | 4 | backend | - UC-DASH-001: Visualizar métricas en dashboard |
| `UC-DASH-005` | 3 | base-cognitiva, operations | 2. Aplicar patrón de transformación (UC-DASH-05) |
| `UC-DASHBOARD-001` | 2 | backend | - UC-DASHBOARD-001: Cargar Dashboard Analítico |
| `UC-DM-001` | 6 | backend | - UC-DM-001: Calcular métricas DORA |
| `UC-DM-002` | 2 | backend | - UC-DM-002: Ejecutar auto-remediación |
| `UC-DM-003` | 2 | backend | - UC-DM-003: Analizar tendencias con ML |
| `UC-DM-004` | 2 | backend | - UC-DM-004: Integrar datos del ecosistema |
| `UC-DM-005` | 2 | backend | - UC-DM-005: Generar dashboard DORA |
| `UC-DM-006` | 4 | backend | - UC-DM-006: Exportar reportes DORA |
| `UC-DM-010` | 2 | backend | - UC-DM-001 a UC-DM-010 (pendientes de documentar) |
| `UC-DOMINIO-005` | 1 | normativa-gobernanza |   1.1.0   [YYYY-MM-DD]   [Autor]   Agregado UC-DOMINIO-005   +3 RF, +2 RNF   |
| `UC-ETL-001` | 9 | base-cognitiva, backend | Ejemplo: UC-ETL-01 (sincronización desde IVR Legacy) |
| `UC-ETL-002` | 4 | backend | - UC-ETL-002: Validar calidad de datos |
| `UC-ETL-003` | 1 | backend | """UC-ETL-03: Ejecutar ETL exitosamente.""" |
| `UC-FRONT-001` | 21 | normativa-procedimientos, normativa-gobernanza | UC-FRONT-001-registrar-vuelo.md |
| `UC-FRONT-002` | 2 | normativa-gobernanza | UC-FRONT-002: Imprimir Pases de Abordar - UC-FRONT-003: Cambiar Asientos |
| `UC-FRONT-003` | 1 | normativa-gobernanza | UC-FRONT-002: Imprimir Pases de Abordar - UC-FRONT-003: Cambiar Asientos |
| `UC-FRONT-004` | 1 | normativa-gobernanza | - UC-FRONT-004: Registrar Equipaje - UC-FRONT-005: Comprar Actualización |
| `UC-FRONT-005` | 1 | normativa-gobernanza | - UC-FRONT-004: Registrar Equipaje - UC-FRONT-005: Comprar Actualización |
| `UC-FRONT-010` | 1 | normativa-gobernanza | UC-FRONT-010: Consultar Inventario |
| `UC-FRONT-011` | 1 | normativa-gobernanza | UC-FRONT-011: Registrar Entrada de Producto |
| `UC-FRONT-012` | 1 | normativa-gobernanza | UC-FRONT-012: Registrar Salida de Producto |
| `UC-FRONT-013` | 1 | normativa-gobernanza | UC-FRONT-013: Generar Reporte de Inventario |
| `UC-FRONT-014` | 1 | normativa-gobernanza | UC-FRONT-014: Buscar Producto por Código |
| `UC-FRONT-021` | 1 | normativa-gobernanza | UC-PERM-001 → UC-BACK-021 (o UC-FRONT-021) |
| `UC-FRONTEND-001` | 1 | frontend | **ID**: UC-FRONTEND-001 |
| `UC-IACT-001` | 4 | base-cognitiva, backend | - UC-IACT-01: Iniciar Sesión (limpia sesiones expiradas previas) |
| `UC-IACT-002` | 4 | base-cognitiva, backend | - UC-IACT-02: Cerrar Sesión (no aplica si ya EXPIRADA) |
| `UC-IACT-003` | 12 | base-cognitiva, backend | UC-IACT-03: Extender Sesión Manualmente |
| `UC-IACT-004` | 367 | base-cognitiva, backend | │   └── Alinear: UC-IACT-04, UC-IACT-07, etc. |
| `UC-IACT-006` | 36 | base-cognitiva, backend | UC-IACT-06: Revocar Funciones |
| `UC-IACT-007` | 171 | base-cognitiva, backend | - UC-07 (notificar químico) ≠ UC-IACT-07 (notificar sesión) |
| `UC-IACT-008` | 24 | base-cognitiva, backend | ☑ 18. UC relacionados: UC-IACT-08 (expirar) ✅ |
| `UC-IACT-009` | 126 | base-cognitiva, backend | ### Ejemplo Guiado: Construcción de UC-IACT-09 |
| `UC-IACT-010` | 12 | base-cognitiva, backend | 4. Su reacción será otro UC (UC-IACT-10: Renovar Permiso Temporal) |
| `UC-IACT-011` | 24 | base-cognitiva, backend | (UC-IACT-11: Expirar Permisos Automáticamente) |
| `UC-IACT-012` | 16 | base-cognitiva, backend | - UC-IACT-12: Transferir Segmento de Datos |
| `UC-IACT-013` | 4 | base-cognitiva, backend | 2g. UC termina (continuará con UC-IACT-13: Aprobar Transferencia) |
| `UC-IACT-015` | 34 | base-cognitiva, backend | → Usado en: UC-IACT-04, UC-IACT-15, UC-IACT-18 |
| `UC-IACT-016` | 4 | base-cognitiva, backend | Abrir UC-IACT-16 (Consultar Función) |
| `UC-IACT-018` | 51 | base-cognitiva, backend | → Usado en: UC-IACT-04, UC-IACT-15, UC-IACT-18 |
| `UC-IACT-019` | 12 | base-cognitiva, backend | (Continuará con UC-IACT-19: Aprobar Solicitud Masiva) |
| `UC-IACT-020` | 12 | base-cognitiva, backend | - UC-IACT-20: CRUD técnico (OK) |
| `UC-IACT-021` | 18 | base-cognitiva, backend | - UC-IACT-21: CRUD técnico (OK) |
| `UC-IACT-022` | 12 | base-cognitiva, backend | ✓ UC-IACT-22: Consultar Log de Auditoría |
| `UC-IACT-023` | 20 | base-cognitiva, backend | ✓ UC-IACT-23: Generar Reporte de Auditoría |
| `UC-IACT-024` | 16 | base-cognitiva, backend | ✓ UC-IACT-24: Exportar Logs a CSV |
| `UC-IACT-025` | 28 | base-cognitiva, backend | SOLUCIÓN EJERCICIO 1: UC-IACT-25 |
| `UC-IACT-026` | 4 | base-cognitiva, backend | (Manejado por UC-IACT-26: Procesar Confirmaciones Expiradas) |
| `UC-IACT-027` | 4 | base-cognitiva, backend | f"Reactive el usuario primero (UC-IACT-27)." |
| `UC-IACT-040` | 1 | operations | **Sección 6: UC-IACT-40 → FR Completos** |
| `UC-IACT-061` | 1 | operations | **Sección 7-8: UC-IACT-61 y UC-IACT-110** |
| `UC-IACT-110` | 1 | operations | **Sección 7-8: UC-IACT-61 y UC-IACT-110** |
| `UC-INFRA-001` | 2 | infrastructure | - **Casos de uso**: REQ-UC-INFRA-001 |
| `UC-INFRAESTRUCTURA-001` | 1 | infrastructure | **ID**: UC-INFRAESTRUCTURA-001 |
| `UC-INTEGRATION-001` | 1 | backend | - UC-INTEGRATION-001: Conectar con IVR (API keys) |
| `UC-INV-001` | 3 | requisitos | 7.1.2 Opción 2: Por Módulo (UC-AUT-01, UC-INV-01, ...) |
| `UC-LOG-001` | 53 | base-cognitiva, normativa-estandares, requisitos (+1) |   logs/   index.rst   UC_LOG_01-04   [NOT_VERIFIED]   |
| `UC-LOG-002` | 23 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-071   UC_LOG_02   Filtrar Logs   |
| `UC-LOG-003` | 31 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-072   UC_LOG_03   Exportar Logs   |
| `UC-LOG-004` | 58 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-073   UC_LOG_04   Configurar Retención   |
| `UC-PERM-000` | 3 | normativa-gobernanza | **Archivos esperados**: `docs/anexos/diagramas/casos_de_uso/UC-PERM-00{1-10}.puml` (10 archivos) |
| `UC-PERM-001` | 33 | normativa-gobernanza, backend |   `UC-PERM-001_asignar_grupo_a_usuario.md`   UC-PERM-001   Dominio inválido (PERM no es válido)   |
| `UC-PERM-002` | 12 | normativa-gobernanza, backend |   `UC-PERM-002_revocar_grupo_a_usuario.md`   UC-PERM-002   Dominio inválido (PERM no es válido)   |
| `UC-PERM-003` | 14 | normativa-gobernanza, backend |   `UC-PERM-003_conceder_permiso_excepcional.md`   UC-PERM-003   Dominio inválido (PERM no es válido)   |
| `UC-PERM-004` | 12 | normativa-gobernanza, backend |   `UC-PERM-004_revocar_permiso_excepcional.md`   UC-PERM-004   Dominio inválido (PERM no es válido)   |
| `UC-PERM-005` | 11 | normativa-gobernanza, backend |   `UC-PERM-005_crear_grupo_permisos.md`   UC-PERM-005   Dominio inválido (PERM no es válido)   |
| `UC-PERM-006` | 11 | normativa-gobernanza, backend | id: UC-PERM-006 |
| `UC-PERM-007` | 14 | normativa-gobernanza, backend |   `UC-PERM-007_verificar_permiso_usuario.md`   UC-PERM-007   Dominio inválido (PERM no es válido)   |
| `UC-PERM-008` | 10 | normativa-gobernanza, backend | id: UC-PERM-008 |
| `UC-PERM-009` | 8 | normativa-gobernanza, backend, frontend | id: UC-PERM-009 |
| `UC-PERM-010` | 15 | normativa-gobernanza, backend |   `UC-PERM-010_consultar_auditoria.md`   UC-PERM-010   Dominio inválido (PERM no es válido)   |
| `UC-PIP-001` | 139 | base-cognitiva, normativa-estandares, requisitos (+1) |   277   UC-050   UC_PIP_01   Actor TIEMPO   |
| `UC-PIP-002` | 32 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-051   UC_PIP_02   Consultar Errores ETL   |
| `UC-PIP-003` | 30 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-052   UC_PIP_03   Consultar Disponibilidad   |
| `UC-PIP-004` | 53 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-053   UC_PIP_04   Solicitar Reintento   |
| `UC-PIP-005` | 9 | base-cognitiva | Genera: UC_PIP_05 "Notificar Falla Crítica de Pipeline" |
| `UC-REP-001` | 5 | requisitos, backend | - Crear casos de uso UC-V2 para reportes clave (ej. UC-REP-001: Generar reporte de agentes) citando las BR y RNF anterio |
| `UC-REP-004` | 6 | normativa-gobernanza, infrastructure, operations | - UC-REP-004: Caso de uso relacionado con reportes |
| `UC-REPORT-001` | 1 | backend | - UC-REPORT-001: Generar Reporte de Llamadas |
| `UC-REPORT-002` | 1 | backend | - UC-REPORT-002: Exportar Datos a Excel |
| `UC-REPORTE-001` | 1 | backend | """UC-REPORTE-01: Consultar reporte trimestral con filtro de fechas.""" |
| `UC-RPT-000` | 1 | base-cognitiva | grep -o "UC_RPT_0[456]" /tmp/FND_00_Contexto_y_Jerarquia.rst   sort -u |
| `UC-RPT-001` | 573 | base-cognitiva, normativa-estandares, normativa-gobernanza (+4) | **EJEMPLO COMPLETO (UC-RPT-01):** |
| `UC-RPT-002` | 117 | base-cognitiva, normativa-estandares, normativa-gobernanza (+3) | UC-RPT-02: Ejecutar Reporte Aprobado |
| `UC-RPT-003` | 43 | base-cognitiva, normativa-estandares, normativa-gobernanza (+3) | - UC-RPT-03: Exportar Reporte a Excel |
| `UC-RPT-004` | 55 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-020   UC_RPT_04   Filtrar Por Fecha   |
| `UC-RPT-005` | 38 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-021   UC_RPT_05   Filtrar Por Centro   |
| `UC-RPT-006` | 67 | base-cognitiva, normativa-estandares, requisitos (+1) |   220   UC-022   UC_RPT_06   Ejemplo UC Proceso   |
| `UC-RPT-007` | 52 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-023   UC_RPT_07   Exportar Excel   |
| `UC-RPT-008` | 37 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-024   UC_RPT_08   Exportar PDF   |
| `UC-RPT-009` | 53 | base-cognitiva, normativa-estandares, normativa-gobernanza (+3) | - UC-RPT-09 (continuación de FA-2) |
| `UC-RPT-010` | 41 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-026   UC_RPT_10   Ver KPIs   |
| `UC-RPT-011` | 30 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-027   UC_RPT_11   Ver Tendencias   |
| `UC-RPT-012` | 31 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-028   UC_RPT_12   Ver Gráfico Hora   |
| `UC-RPT-013` | 24 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-029   UC_RPT_13   Ver Gráfico Día   |
| `UC-RPT-014` | 44 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-030   UC_RPT_14   Ver Distribución Centro   |
| `UC-S-001` | 1 | normativa-gobernanza | - UC-S01: Gestionar Ciclo de Vida de Cliente |
| `UC-S-002` | 1 | normativa-gobernanza | - UC-S02: Optimizar Operaciones de Call Center |
| `UC-SEG-001` | 2 | requisitos | * Por módulo (UC-INV-001, UC-SEG-001, ...) |
| `UC-USER-001` | 3 | normativa-gobernanza, backend | - UC-USER-001 a UC-USER-010 |
| `UC-USER-010` | 1 | normativa-gobernanza | - UC-USER-001 a UC-USER-010 |
| `UC-USR-001` | 99 | base-cognitiva, normativa-estandares, requisitos (+1) |   214   UC-006   UC_USR_01   Ejemplo UC Gestión   |
| `UC-USR-002` | 52 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-007   UC_USR_02   Consultar Usuarios   |
| `UC-USR-003` | 46 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-008   UC_USR_03   Modificar Usuario   |
| `UC-USR-004` | 59 | base-cognitiva, normativa-estandares, requisitos (+1) |   UC-009   UC_USR_04   Eliminar Usuario   |
| `UC-V-002` | 21 | normativa-gobernanza, requisitos | ## Caso de Uso Completo IACT (UC-V2) |

## Distribucion por modulo (si aplica)

- **(sin modulo)** (194): UC-000, UC-001, UC-002, UC-003, UC-004, UC-005, UC-006, UC-007, UC-008, UC-009...
- **A** (2): UC-A-001, UC-A-002
- **ACC** (9): UC-ACC-001, UC-ACC-002, UC-ACC-003, UC-ACC-004, UC-ACC-005, UC-ACC-006, UC-ACC-007, UC-ACC-008, UC-ACC-009
- **ADM** (1): UC-ADM-010
- **ADR** (5): UC-ADR-001, UC-ADR-002, UC-ADR-003, UC-ADR-004, UC-ADR-005
- **AI** (2): UC-AI-002, UC-AI-010
- **ALERT** (2): UC-ALERT-001, UC-ALERT-002
- **ALR** (5): UC-ALR-001, UC-ALR-002, UC-ALR-003, UC-ALR-004, UC-ALR-005
- **ANALYTICS** (3): UC-ANALYTICS-001, UC-ANALYTICS-002, UC-ANALYTICS-003
- **AUD** (4): UC-AUD-001, UC-AUD-002, UC-AUD-003, UC-AUD-004
- **AUT** (3): UC-AUT-001, UC-AUT-002, UC-AUT-004
- **AUTH** (7): UC-AUTH-001, UC-AUTH-002, UC-AUTH-003, UC-AUTH-004, UC-AUTH-005, UC-AUTH-007, UC-AUTH-008
- **B** (2): UC-B-001, UC-B-002
- **BACK** (32): UC-BACK-001, UC-BACK-002, UC-BACK-003, UC-BACK-004, UC-BACK-005, UC-BACK-009, UC-BACK-010, UC-BACK-011, UC-BACK-012, UC-BACK-013...
- **BACKEND** (1): UC-BACKEND-001
- **BANK** (1): UC-BANK-001
- **BUZON** (1): UC-BUZON-001
- **C** (2): UC-C-001, UC-C-002
- **CALL** (4): UC-CALL-001, UC-CALL-002, UC-CALL-003, UC-CALL-004
- **CHEM** (12): UC-CHEM-005, UC-CHEM-010, UC-CHEM-011, UC-CHEM-012, UC-CHEM-020, UC-CHEM-021, UC-CHEM-022, UC-CHEM-030, UC-CHEM-031, UC-CHEM-032...
- **D** (2): UC-D-001, UC-D-002
- **DASH** (2): UC-DASH-001, UC-DASH-005
- **DASHBOARD** (1): UC-DASHBOARD-001
- **DM** (7): UC-DM-001, UC-DM-002, UC-DM-003, UC-DM-004, UC-DM-005, UC-DM-006, UC-DM-010
- **DOMINIO** (1): UC-DOMINIO-005
- **ETL** (3): UC-ETL-001, UC-ETL-002, UC-ETL-003
- **FRONT** (11): UC-FRONT-001, UC-FRONT-002, UC-FRONT-003, UC-FRONT-004, UC-FRONT-005, UC-FRONT-010, UC-FRONT-011, UC-FRONT-012, UC-FRONT-013, UC-FRONT-014...
- **FRONTEND** (1): UC-FRONTEND-001
- **IACT** (27): UC-IACT-001, UC-IACT-002, UC-IACT-003, UC-IACT-004, UC-IACT-006, UC-IACT-007, UC-IACT-008, UC-IACT-009, UC-IACT-010, UC-IACT-011...
- **INFRA** (1): UC-INFRA-001
- **INFRAESTRUCTURA** (1): UC-INFRAESTRUCTURA-001
- **INTEGRATION** (1): UC-INTEGRATION-001
- **INV** (1): UC-INV-001
- **LOG** (4): UC-LOG-001, UC-LOG-002, UC-LOG-003, UC-LOG-004
- **PERM** (11): UC-PERM-000, UC-PERM-001, UC-PERM-002, UC-PERM-003, UC-PERM-004, UC-PERM-005, UC-PERM-006, UC-PERM-007, UC-PERM-008, UC-PERM-009...
- **PIP** (5): UC-PIP-001, UC-PIP-002, UC-PIP-003, UC-PIP-004, UC-PIP-005
- **REP** (2): UC-REP-001, UC-REP-004
- **REPORT** (2): UC-REPORT-001, UC-REPORT-002
- **REPORTE** (1): UC-REPORTE-001
- **RPT** (15): UC-RPT-000, UC-RPT-001, UC-RPT-002, UC-RPT-003, UC-RPT-004, UC-RPT-005, UC-RPT-006, UC-RPT-007, UC-RPT-008, UC-RPT-009...
- **S** (2): UC-S-001, UC-S-002
- **SEG** (1): UC-SEG-001
- **USER** (2): UC-USER-001, UC-USER-010
- **USR** (4): UC-USR-001, UC-USR-002, UC-USR-003, UC-USR-004
- **V** (1): UC-V-002

## Top archivos con mas IDs UC

| Archivo | # IDs |
|---------|-------|
| `canonical/De Reglas de Negocio a Sistema Completo.md` | 1290 |
| `canonical/PARTE 3 - TÉCNICA 2 - MODELO DE LARMAN - 661ca8.md` | 458 |
| `canonical/Introducción a las Técnicas de Larman.md` | 419 |
| `canonical/PARTE_3D_temp.md` | 305 |
| `canonical/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA.md` | 305 |
| `canonical/PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA__1.md` | 305 |
| `canonical/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | 305 |
| `canonical/PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md` | 305 |
| `canonical/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0_SIN_EMOJIS.md` | 273 |
| `canonical/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0_SIN_EMOJIS.md` | 273 |
| `canonical/PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0.md` | 273 |
| `canonical/PARTE 2 - TRANSFORMAR REGLAS DE NEGOCIO EN CASOS DE USO - 661ca8 - v.0.1.1.md` | 222 |
| `canonical/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA.md` | 160 |
| `canonical/ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA__v_0.0.1.md` | 160 |
| `canonical/ANALISIS_CRITICO_MODELO_vs_PEDAGOGIA.md` | 148 |
