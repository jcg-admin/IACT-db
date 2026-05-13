```yml
created_at: 2026-04-28 23:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (concentracion: inventario UC v4.0.0)
author: NestorMonroy
status: Aprobado
version: 2.0.0
```

# Inventario UC IACT v4.0.0 (autoridad: RSTs canonicos)

> **Versionado:** v1.0.0 (agente) usaba catalogo del PLAN_MAESTRO
>  con 40 UCs y 6 modulos. v2.0.0 (este) usa la verdad de los
>  RSTs en `temp-backup/source-2026-04-28/requisitos/casos_uso/`:
>  **49 UCs reales en 8 modulos**.

## Resumen

- Total UCs IACT v4.0.0: **49**
- Modulos: **8** (USR, AUTH, ACC, ALR, AUD, PIP, RPT, LOG)
- Fuente canonica: `temp-backup/source-2026-04-28/requisitos/casos_uso/`
- Version declarada en metadata RST: 4.0.0

## Distribucion por modulo

| Modulo | Cantidad UCs |
|--------|----|
| MOD_Access | 9 |
| MOD_Alerts | 5 |
| MOD_Audit | 4 |
| MOD_Auth | 5 |
| MOD_Logs | 4 |
| MOD_Pipeline | 4 |
| MOD_Reports | 14 |
| MOD_Users | 4 |
| **Total** | **49** |

## Catalogo completo

### MOD_Access

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_ACC_01` | Asignar Funciones | AGR-007: agr_admin_acceso | BRQ-ACC-001 | ACC-001: asigna_funciones | CNST-005, CNST-009 |
| `UC_ACC_02` | Revocar Funciones | AGR-007: agr_admin_acceso | BRQ-ACC-002 | ACC-002: revoca_funciones | CNST-005, CNST-009 |
| `UC_ACC_03` | Consultar Permisos | AGR-007: agr_admin_acceso | BRQ-ACC-003 | ACC-003: ve_asignaciones | CNST-005 |
| `UC_ACC_04` | Asignar Agrupador | AGR-007: agr_admin_acceso | BRQ-ACC-004 | ACC-004: asigna_agrupadores | CNST-005, CNST-009 |
| `UC_ACC_05` | Gestionar SoD | AGR-007: agr_admin_acceso | BRQ-ACC-005 | ACC-005: gestiona_sod | CNST-005, CNST-009 |
| `UC_ACC_06` | Gestionar Segmentos | AGR-007: agr_admin_acceso | BRQ-ACC-006 | ACC-006: gestiona_segmentos | CNST-005, CNST-009 |
| `UC_ACC_07` | Asignar Segmento | AGR-007: agr_admin_acceso | BRQ-ACC-007 | USR-010: asigna_segmento | CNST-005, CNST-009 |
| `UC_ACC_08` | Permiso Temporal | AGR-007: agr_admin_acceso | BRQ-ACC-008 | ACC-001: asigna_funciones | CNST-005, CNST-009 |
| `UC_ACC_09` | Auditar Cambios Acceso | AGR-008: agr_auditor | BRQ-ACC-009 | AUD-001: ve_auditoria, AUD-002: busca_au | CNST-009 |

### MOD_Alerts

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_ALR_01` | Configurar Umbrales | AGR-005: agr_gestor_alertas | BRQ-ALR-001 | ALR-001: configura_umbrales | CNST-004, CNST-009 |
| `UC_ALR_02` | Ver Alertas Activas | AGR-001: agr_operador_basico | BRQ-ALR-002 | ALR-002: ve_alertas | CNST-001, CNST-003, CNST-004 |
| `UC_ALR_03` | Reconocer Alerta | AGR-003: agr_supervisor | BRQ-ALR-003 | ALR-003: reconoce_alertas | CNST-001, CNST-009 |
| `UC_ALR_04` | Ver Historial Alertas | AGR-003: agr_supervisor | BRQ-ALR-004 | ALR-004: ve_historial_alertas | CNST-003, CNST-004, CNST-006 |
| `UC_ALR_05` | Gestionar Suscripciones | AGR-005: agr_gestor_alertas | BRQ-ALR-005 | ALR-005: gestiona_suscripciones | CNST-001, CNST-004, CNST-009 |

### MOD_Audit

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_AUD_01` | Consultar Auditoria | AGR-006: agr_auditor | BRQ-AUD-001 | AUD-001: consulta_auditoria | CNST-009, CNST-010 |
| `UC_AUD_02` | Buscar Auditoria | AGR-006: agr_auditor | BRQ-AUD-002 | AUD-002: busca_auditoria | CNST-009, CNST-010 |
| `UC_AUD_03` | Exportar Auditoria | AGR-006: agr_auditor | BRQ-AUD-003 | AUD-003: exporta_auditoria | CNST-007, CNST-009, CNST-010 |
| `UC_AUD_04` | Generar Reporte Compliance | AGR-006: agr_auditor | BRQ-AUD-004 | AUD-004: genera_compliance | CNST-009, CNST-010 |

### MOD_Auth

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_AUTH_01` | Iniciar Sesion | Usuario (cualquier usuario registrado) | BRQ-AUTH-001 | (publico) - No requiere funcion previa | CNST-002, CNST-009 |
| `UC_AUTH_02` | Cerrar Sesion | Usuario (cualquier usuario autenticado) | BRQ-AUTH-002 | (publico) - Cualquier usuario autenticad | CNST-009 |
| `UC_AUTH_03` | Recuperar Contrasena | AGR-006: agr_admin_usuarios | BRQ-AUTH-003 | AUT-003: resetea_password | CNST-001, CNST-009 |
| `UC_AUTH_04` | Cambiar Contrasena | Usuario (cualquier usuario autenticado) | BRQ-AUTH-004 | (publico) - Cualquier usuario autenticad | CNST-002, CNST-009 |
| `UC_AUTH_05` | Gestionar Sesiones | AGR-006: agr_admin_usuarios | BRQ-AUTH-005 | AUT-001: gestiona_sesiones, AUT-002: cie | CNST-002, CNST-009 |

### MOD_Logs

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_LOG_01` | Consultar Logs Sistema | AGR-007: agr_operador_logs | BRQ-LOG-001 | LOG-001: consulta_logs_sistema | CNST-008 |
| `UC_LOG_02` | Consultar Logs ETL | AGR-007: agr_operador_logs | BRQ-LOG-002 | LOG-002: consulta_logs_etl | CNST-003, CNST-008 |
| `UC_LOG_03` | Buscar Logs | AGR-007: agr_operador_logs | BRQ-LOG-003 | LOG-003: busca_logs | CNST-008 |
| `UC_LOG_04` | Exportar Logs | AGR-007: agr_operador_logs | BRQ-LOG-004 | LOG-004: exporta_logs | CNST-008, CNST-009 |

### MOD_Pipeline

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_PIP_01` | Supervisar ETL | AGR-009: agr_admin_pipeline | BRQ-PIP-001 | PIP-001: ve_estado_etl | CNST-003, CNST-009 |
| `UC_PIP_02` | Consultar Errores ETL | AGR-009: agr_admin_pipeline | BRQ-PIP-002 | PIP-002: ve_errores_etl | CNST-003, CNST-009 |
| `UC_PIP_03` | Consultar Disponibilidad | AGR-009: agr_admin_pipeline | BRQ-PIP-003 | PIP-003: ve_disponibilidad_datos | CNST-003 |
| `UC_PIP_04` | Solicitar Reintento | AGR-009: agr_admin_pipeline | BRQ-PIP-004 | PIP-004: solicita_reintento_etl | CNST-003, CNST-009 |

### MOD_Reports

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_RPT_01` | Ver Dashboard | AGR-001: agr_operador_basico | BRQ-RPT-001 | RPT-001: ve_reportes | CNST-003, CNST-004 |
| `UC_RPT_02` | Ver Metricas Tiempo Real | AGR-001: agr_operador_basico | BRQ-RPT-002 | RPT-002: ve_dashboard | CNST-003, CNST-004 |
| `UC_RPT_03` | Ver Reportes Historicos | AGR-002: agr_operador_reportes | BRQ-RPT-003 | RPT-003: ve_historicos | CNST-003, CNST-004, CNST-006 |
| `UC_RPT_04` | Exportar CSV | AGR-004: agr_exportador | BRQ-RPT-004 | RPT-004: exporta_csv | CNST-004, CNST-007, CNST-009 |
| `UC_RPT_05` | Exportar Excel | AGR-004: agr_exportador | BRQ-RPT-005 | RPT-005: exporta_excel | CNST-004, CNST-007, CNST-009 |
| `UC_RPT_06` | Exportar PDF | AGR-004: agr_exportador | BRQ-RPT-006 | RPT-006: exporta_pdf | CNST-004, CNST-007, CNST-009 |
| `UC_RPT_07` | Programar Reporte | AGR-003: agr_supervisor | BRQ-RPT-007 | RPT-007: programa_reportes | CNST-001, CNST-004, CNST-009 |
| `UC_RPT_08` | Ver Reportes Programados | AGR-003: agr_supervisor | BRQ-RPT-008 | RPT-008: ve_programados | CNST-004 |
| `UC_RPT_09` | Configurar Filtros | AGR-003: agr_supervisor | BRQ-RPT-009 | RPT-009: configura_filtros | CNST-004, CNST-009 |
| `UC_RPT_10` | Guardar Vista | AGR-002: agr_operador_reportes | BRQ-RPT-010 | RPT-010: guarda_vistas | CNST-004 |
| `UC_RPT_11` | Compartir Reporte | AGR-003: agr_supervisor | BRQ-RPT-011 | RPT-011: comparte_reportes | CNST-001, CNST-004, CNST-009 |
| `UC_RPT_12` | Ver Reporte Agentes | AGR-003: agr_supervisor | BRQ-RPT-012 | RPT-012: ve_agentes | CNST-003, CNST-004 |
| `UC_RPT_13` | Ver Reporte Colas | AGR-003: agr_supervisor | BRQ-RPT-013 | RPT-013: ve_colas | CNST-003, CNST-004 |
| `UC_RPT_14` | Ver Reporte Campanas | AGR-003: agr_supervisor | BRQ-RPT-014 | RPT-014: ve_campanas | CNST-003, CNST-004 |

### MOD_Users

| UC ID | Titulo | Actor | BReq Origen | RBAC | CNSTs (normativa) |
|-------|--------|-------|-------------|------|--------------------|
| `UC_USR_01` | Crear Usuario | AGR-006: agr_admin_usuarios | BRQ-USR-001 | USR-001: crea_usuarios | CNST-001, CNST-005, CNST-009 |
| `UC_USR_02` | Consultar Usuarios | AGR-006: agr_admin_usuarios | BRQ-USR-002 | USR-002: ve_usuarios, USR-005: lista_usu | CNST-009 |
| `UC_USR_03` | Modificar Usuario | AGR-006: agr_admin_usuarios | BRQ-USR-003 | USR-003: modifica_usuarios, USR-007: blo | CNST-001, CNST-005, CNST-009 |
| `UC_USR_04` | Eliminar Usuario | AGR-006: agr_admin_usuarios | BRQ-USR-004 | USR-004: elimina_usuarios | CNST-005, CNST-009 |

## Cobertura de CNSTs (referencia rebuild SRP-31)

CNSTs referenciados por UCs:

- CNST-001: 8 UCs
- CNST-002: 3 UCs
- CNST-003: 13 UCs
- CNST-004: 18 UCs
- CNST-005: 11 UCs
- CNST-006: 2 UCs
- CNST-007: 4 UCs
- CNST-008: 4 UCs
- CNST-009: 34 UCs
- CNST-010: 4 UCs

**Nota:** las referencias usan nomenclatura CNST-NNN legacy (set
anterior de 11 CNSTs). Phase 2 debe mapear a la nueva
numeracion del rebuild SRP-31 (ver `cross-wp-debt-summary.md` § W-1).

## Cobertura de BReqs

Total BReqs unicos referenciados: **49**

- BRQ-ACC-001: UC_ACC_01
- BRQ-ACC-002: UC_ACC_02
- BRQ-ACC-003: UC_ACC_03
- BRQ-ACC-004: UC_ACC_04
- BRQ-ACC-005: UC_ACC_05
- BRQ-ACC-006: UC_ACC_06
- BRQ-ACC-007: UC_ACC_07
- BRQ-ACC-008: UC_ACC_08
- BRQ-ACC-009: UC_ACC_09
- BRQ-ALR-001: UC_ALR_01
- BRQ-ALR-002: UC_ALR_02
- BRQ-ALR-003: UC_ALR_03
- BRQ-ALR-004: UC_ALR_04
- BRQ-ALR-005: UC_ALR_05
- BRQ-AUD-001: UC_AUD_01
- BRQ-AUD-002: UC_AUD_02
- BRQ-AUD-003: UC_AUD_03
- BRQ-AUD-004: UC_AUD_04
- BRQ-AUTH-001: UC_AUTH_01
- BRQ-AUTH-002: UC_AUTH_02
- BRQ-AUTH-003: UC_AUTH_03
- BRQ-AUTH-004: UC_AUTH_04
- BRQ-AUTH-005: UC_AUTH_05
- BRQ-LOG-001: UC_LOG_01
- BRQ-LOG-002: UC_LOG_02
- BRQ-LOG-003: UC_LOG_03
- BRQ-LOG-004: UC_LOG_04
- BRQ-PIP-001: UC_PIP_01
- BRQ-PIP-002: UC_PIP_02
- BRQ-PIP-003: UC_PIP_03
- BRQ-PIP-004: UC_PIP_04
- BRQ-RPT-001: UC_RPT_01
- BRQ-RPT-002: UC_RPT_02
- BRQ-RPT-003: UC_RPT_03
- BRQ-RPT-004: UC_RPT_04
- BRQ-RPT-005: UC_RPT_05
- BRQ-RPT-006: UC_RPT_06
- BRQ-RPT-007: UC_RPT_07
- BRQ-RPT-008: UC_RPT_08
- BRQ-RPT-009: UC_RPT_09
- BRQ-RPT-010: UC_RPT_10
- BRQ-RPT-011: UC_RPT_11
- BRQ-RPT-012: UC_RPT_12
- BRQ-RPT-013: UC_RPT_13
- BRQ-RPT-014: UC_RPT_14
- BRQ-USR-001: UC_USR_01
- BRQ-USR-002: UC_USR_02
- BRQ-USR-003: UC_USR_03
- BRQ-USR-004: UC_USR_04
