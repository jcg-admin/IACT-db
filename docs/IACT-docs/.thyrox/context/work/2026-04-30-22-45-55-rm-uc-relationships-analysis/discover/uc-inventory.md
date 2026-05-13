```yml
created_at: 2026-04-30 22:45:55
project: IACT-docs
work_package: 2026-04-30-22-45-55-rm-uc-relationships-analysis
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# UC Inventory — Catálogo IACT

Inventario completo de casos de uso del catálogo IACT
por cluster. Extraído directamente del corpus
``source/requisitos/casos-uso/`` (61 archivos
``uc-*.rst``).

**Método de extracción** — `find` + `grep` sobre los
campos `:artefacto:`, "Actor Principal", `:normativa:`
y "Funcion RBAC backing" del meta de cada `.rst`. La
fuente está citada por archivo en cada fila.

**Total UCs:** 61 (verificado:
`find source/requisitos/casos-uso/ -name 'uc-*.rst' | wc -l`).

## Conteo por cluster

| Cluster | UCs | Rango IDs |
|---------|-----|-----------|
| AUTH    | 5   | 01–05 |
| USR     | 4   | 01–04 |
| ACC     | 7   | 01–05, 08, 09 |
| PERM    | 10  | 01–10 |
| RPT     | 15  | 01–04, 07–17 |
| ALR     | 5   | 01–05 |
| PIP     | 4   | 01–04 |
| AUD     | 4   | 01–04 |
| LOG     | 7   | 01–07 |
| **Total** | **61** | |

> Hallazgo H-01 (OBSERVABLE): los rangos no son
> contiguos en ACC (saltan 06, 07), RPT (salta 05, 06)
> y PERM (consume todo). Indica UCs deprecados o
> renumerados en versiones previas — pendiente
> contrastar con `casos-uso-diagramas.rst § 15` en
> Stage 3 ANALYZE.

## Cluster AUTH — Autenticación y sesiones

Fuente: `source/requisitos/casos-uso/auth/uc-auth-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_AUTH_01 | Iniciar Sesion | Usuario (cualquier registrado) | CNST_003, CNST_025 |
| UC_AUTH_02 | Cerrar Sesion | Usuario autenticado | CNST_025 |
| UC_AUTH_03 | Recuperar Contrasena | AGR-006 agr_admin_usuarios | CNST_001, CNST_025 |
| UC_AUTH_04 | Cambiar Contrasena | Usuario autenticado | CNST_003, CNST_025 |
| UC_AUTH_05 | Gestionar Sesiones | AGR-006 agr_admin_usuarios | CNST_003, CNST_025 |

> Nota: el wp-state hipotetiza CNST_002 sesión única
> para AUTH; el corpus real cita **CNST_003** en
> UC_AUTH_01/04/05. Hallazgo H-02 (OBSERVABLE) — la
> hipótesis del wp-state está desactualizada
> respecto al corpus actual; verificar la
> definición de CNST_003 en el cajón normativa
> antes de afirmar equivalencia.

## Cluster USR — Gestión de usuarios

Fuente: `source/requisitos/casos-uso/users/uc-usr-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_USR_01 | Crear Usuario | AGR-006 agr_admin_usuarios | CNST_001, CNST_029, CNST_025 |
| UC_USR_02 | Consultar Usuarios | AGR-006 agr_admin_usuarios | CNST_025 |
| UC_USR_03 | Modificar Usuario | AGR-006 agr_admin_usuarios | CNST_001, CNST_029, CNST_025 |
| UC_USR_04 | Eliminar Usuario | AGR-006 agr_admin_usuarios | CNST_029, CNST_025 |

## Cluster ACC — Asignación de funciones (RBAC granular)

Fuente: `source/requisitos/casos-uso/access/uc-acc-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_ACC_01 | Asignar Funciones | AGR-007 agr_admin_acceso | CNST_029, CNST_025 |
| UC_ACC_02 | Revocar Funciones | AGR-007 agr_admin_acceso | CNST_029, CNST_025 |
| UC_ACC_03 | Consultar Permisos | AGR-007 agr_admin_acceso | CNST_029 |
| UC_ACC_04 | Asignar Agrupador | AGR-007 agr_admin_acceso | CNST_029, CNST_025 |
| UC_ACC_05 | Gestionar SoD | AGR-007 agr_admin_acceso | CNST_029, CNST_025 |
| UC_ACC_08 | Permiso Temporal | AGR-007 agr_admin_acceso | CNST_029, CNST_025 |
| UC_ACC_09 | Auditar Cambios de Acceso | AGR-008 agr_auditor | CNST_025 |

## Cluster PERM — Vista alternativa de permisos

Fuente: `source/requisitos/casos-uso/permissions/uc-perm-*.rst`

> ADR-GOB-008 declara coexistencia ACC ↔ PERM (citado
> en cabecera de UC_PERM_07). PERM presenta el mismo
> modelo RBAC desde la vista de permisos asignados a
> usuario; ACC desde la vista de funciones RBAC.

| ID | Título | Función RBAC backing |
|----|--------|----------------------|
| UC_PERM_01 | Asignar Grupo a Usuario | ACC-004 `assign_function_groups` |
| UC_PERM_02 | Revocar Grupo a Usuario | ACC-010 `revoke_function_group` |
| UC_PERM_03 | Conceder Permiso Excepcional | ACC-008 `grant_exceptional_permission` (CNST-031) |
| UC_PERM_04 | Revocar Permiso Excepcional | ACC-009 `revoke_exceptional_permission` |
| UC_PERM_05 | Crear Grupo de Permisos | ACC-006 `create_function_group` |
| UC_PERM_06 | Asignar Funciones a Grupo | ACC-007 `assign_functions_to_group` |
| UC_PERM_07 | Verificar Permiso de Usuario | ACC-003 `view_assignments` |
| UC_PERM_08 | Generar Menu Dinamico | CNST-032 (SQL `get_user_menu`, no función RBAC) |
| UC_PERM_09 | Auditar Acceso | AUD-001 `view_audit_log` |
| UC_PERM_10 | Consultar Auditoria de Permisos | AUD-002 `search_audit_log` |

> Hallazgo H-03 (OBSERVABLE): los UCs PERM no exponen
> "Actor Principal" en su meta; el actor se infiere
> vía la función RBAC backing (quién tiene esa
> función). Esto difiere del patrón de los otros
> 8 clusters y debería normalizarse o documentarse
> como excepción explícita en Stage 3 ANALYZE.

## Cluster RPT — Reportes y dashboards

Fuente: `source/requisitos/casos-uso/reports/uc-rpt-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_RPT_01 | Ver Dashboard | AGR-001 agr_operador_basico | CNST_007, CNST_008 |
| UC_RPT_02 | Ver Metricas Tiempo Real | AGR-001 agr_operador_basico | CNST_007, CNST_008 |
| UC_RPT_03 | Ver Reportes Historicos | AGR-002 agr_operador_reportes | CNST_007, CNST_008, CNST_015 |
| UC_RPT_04 | Exportar Reporte | AGR-004 data_exporter_group | CNST_008, CNST_019, CNST_020, CNST_025 |
| UC_RPT_07 | Programar Reporte | AGR-003 agr_supervisor | CNST_001, CNST_008, CNST_025 |
| UC_RPT_08 | Ver Reportes Programados | AGR-003 agr_supervisor | CNST_008 |
| UC_RPT_09 | Configurar Filtros | AGR-003 agr_supervisor | CNST_008, CNST_025 |
| UC_RPT_10 | Guardar Vista | AGR-002 agr_operador_reportes | CNST_008 |
| UC_RPT_11 | Compartir Reporte | AGR-003 agr_supervisor | CNST_001, CNST_008, CNST_025 |
| UC_RPT_12 | Ver Reporte Agentes | AGR-003 agr_supervisor | CNST_007, CNST_008 |
| UC_RPT_13 | Ver Reporte Colas | AGR-003 agr_supervisor | CNST_007, CNST_008 |
| UC_RPT_14 | Ver Reporte Campanas | AGR-003 agr_supervisor | CNST_007, CNST_008 |
| UC_RPT_15 | Reporte Transferencias Centro | AGR-002 report_viewer_group | CNST_007, CNST_008, CNST_015 |
| UC_RPT_16 | Reporte Menus IVR | AGR-002 report_viewer_group | CNST_007, CNST_008, CNST_015 |
| UC_RPT_17 | Reporte Clientes Unicos | AGR-002 report_viewer_group | CNST_007, CNST_008, CNST_015, CNST_026 |

## Cluster ALR — Alertas

Fuente: `source/requisitos/casos-uso/alerts/uc-alr-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_ALR_01 | Configurar Umbrales | AGR-005 agr_gestor_alertas | CNST_008, CNST_025 |
| UC_ALR_02 | Ver Alertas Activas | AGR-001 agr_operador_basico | CNST_001, CNST_007, CNST_008 |
| UC_ALR_03 | Reconocer Alerta | AGR-003 agr_supervisor | CNST_001, CNST_025 |
| UC_ALR_04 | Ver Historial Alertas | AGR-003 agr_supervisor | CNST_007, CNST_008, CNST_015 |
| UC_ALR_05 | Gestionar Suscripciones | AGR-005 agr_gestor_alertas | CNST_001, CNST_008, CNST_025 |

## Cluster PIP — Pipeline ETL

Fuente: `source/requisitos/casos-uso/pipeline/uc-pip-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_PIP_01 | Supervisar ETL | AGR-009 agr_admin_pipeline | CNST_007, CNST_025 |
| UC_PIP_02 | Consultar Errores ETL | AGR-009 agr_admin_pipeline | CNST_007, CNST_025 |
| UC_PIP_03 | Consultar Disponibilidad | AGR-009 agr_admin_pipeline | CNST_007 |
| UC_PIP_04 | Solicitar Reintento | AGR-009 agr_admin_pipeline | CNST_007, CNST_025 |

## Cluster AUD — Auditoría

Fuente: `source/requisitos/casos-uso/audit/uc-aud-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_AUD_01 | Consultar Auditoria | AGR-006 agr_auditor | CNST_025, CNST_027 |
| UC_AUD_02 | Buscar Auditoria | AGR-006 agr_auditor | CNST_025, CNST_027 |
| UC_AUD_03 | Exportar Auditoria | AGR-006 agr_auditor | CNST_017, CNST_025, CNST_027 |
| UC_AUD_04 | Generar Reporte Compliance | AGR-006 agr_auditor | CNST_025, CNST_027 |

> Hallazgo H-04 (OBSERVABLE): UC_ACC_09 (auditar
> cambios de acceso) usa AGR-008 mientras AUD_01-04
> usa AGR-006. Posible inconsistencia de
> nomenclatura del agrupador "auditor" — verificar
> en Stage 3 contra catálogo CNST_030.

## Cluster LOG — Logs operativos y técnicos

Fuente: `source/requisitos/casos-uso/logs/uc-log-*.rst`

| ID | Título | Actor primario | Restricciones |
|----|--------|----------------|---------------|
| UC_LOG_01 | Consultar Logs Sistema | AGR-007 agr_operador_logs | CNST_024 |
| UC_LOG_02 | Consultar Logs ETL | AGR-007 agr_operador_logs | CNST_007, CNST_024 |
| UC_LOG_03 | Buscar Logs | AGR-007 agr_operador_logs | CNST_024 |
| UC_LOG_04 | Exportar Logs | AGR-007 agr_operador_logs | CNST_024, CNST_025 |
| UC_LOG_05 | Ver Logs Infraestructura | AGR-010 system_admin_group | CNST_024, CNST_025 |
| UC_LOG_06 | Ver Estado Sistema | AGR-010 system_admin_group | CNST_025 |
| UC_LOG_07 | Ver Metricas Tecnicas | AGR-010 system_admin_group | CNST_025 |

> Hallazgo H-05 (OBSERVABLE): el agrupador AGR-007
> aparece como "agr_admin_acceso" en cluster ACC y
> como "agr_operador_logs" en cluster LOG — colisión
> de id de agrupador. CRÍTICO de validar contra
> CNST_030 antes de Stage 3.

## Hallazgos consolidados de Stage 1

| ID | Tipo | Descripción | Próximo paso |
|----|------|-------------|--------------|
| H-01 | OBSERVABLE | IDs no contiguos en ACC, RPT | Cruzar con `casos-uso-diagramas.rst § 15` |
| H-02 | OBSERVABLE | Hipótesis wp-state cita CNST_002, corpus cita CNST_003 | Verificar CNST_002/003 en cajón normativa |
| H-03 | OBSERVABLE | UCs PERM no exponen Actor Principal en meta | Documentar excepción o normalizar |
| H-04 | OBSERVABLE | UC_ACC_09 usa AGR-008 vs AUD usa AGR-006 para "auditor" | Verificar catálogo agrupadores |
| H-05 | OBSERVABLE | Colisión id AGR-007 entre clusters ACC y LOG | CRÍTICO — verificar CNST_030 |

Ningún hallazgo SPECULATIVE en Stage 1 (gate I-012
satisfecho para esta phase).

## Próximo paso

Stage 3 ANALYZE — extraer relaciones include /
extend / generalización / dependencia leyendo el
flujo principal y secciones "Inclusiones" / "Casos
de uso relacionados" de cada `.rst`. Output:
`discover/uc-relationships-analysis.md`.
