```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 2 de 6
```

# PARTE 2 — Tabla maestra de los 61 UCs

> Ficha por UC organizada por los 9 clusters
> funcionales del catálogo IACT. Cada ficha
> incluye los campos clave para análisis de
> dependencias: criticidad, complejidad estimada,
> actor primario, operaciones incluidas,
> patrones de diseño aplicables, clase de
> dominio canónica, función RBAC vigente, y
> dependencias hacia otros UCs.

## 2.0 Convenciones de la ficha

Cada UC se documenta con los siguientes campos:

| Campo | Significado |
|-------|-------------|
| **Criticidad** | CRÍTICO / ALTO / MEDIO / BAJO (per Parte 1) |
| **Complejidad** | ALTA / MEDIA / BAJA — proxy de esfuerzo, basado en líneas del UC, número de flujos alternos, y constraints citadas |
| **Días estimados** | Estimación person-days para implementar (Parte 5 detalla método) |
| **Actor** | Actor primario per la sección "Actor Principal" del UC |
| **Incluye** | Operaciones internas del flujo principal |
| **Extiende** | Otros UCs que extienden este (relación inversa) |
| **Patrones** | Patrones de diseño aplicables (ver Parte 6) |
| **Clase Dominio** | Clase canónica de ``modelo-dominio-iact.rst`` v1.0.0 |
| **Función RBAC** | Funciones de ``modelo-rbac-iact.rst`` v5.4.0 |
| **Dependencias** | UCs que este invoca o requiere |
| **Cat Z.2.A** | Categoría asignada por el WP Z.2.A (1..5) |

----

## 2.1 Cluster AUTH (5 UCs) — autenticación y sesiones

Responsabilidad: gate de entrada al sistema, gestión del ciclo
de vida de Session, y notificación de cambios sensibles vía
InternalMailbox.

Criticidad por cluster: **2 CRÍTICOS + 2 ALTOS + 1 MEDIO**.

### UC_AUTH_01 — Iniciar Sesion

- **Criticidad**: CRÍTICO
- **Complejidad**: MEDIA · 5 días
- **Actor**: Usuario (cualquier registrado)
- **Incluye**: validar credenciales, generar tokens JWT, cerrar sesiones anteriores (CNST-003), throttling intentos, registro auditoría
- **Extiende**: UC_AUTH_03 (recuperar contraseña), UC_AUTH_04 (cambio forzado primer login)
- **Patrones**: Strategy (auth provider), Decorator (rate limiting), Chain of Responsibility (validaciones)
- **Clase Dominio**: ``Session`` (primaria), ``User``, ``AuditEvent``
- **Función RBAC**: público (post-login establece AUTH-001 ``view_own_sessions``)
- **Dependencias**: ninguna (entrada universal)
- **Cat Z.2.A**: 1

### UC_AUTH_02 — Cerrar Sesion

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 1 día
- **Actor**: Usuario autenticado
- **Incluye**: invalidar tokens JWT, transitar Session.state → CLOSED, registro auditoría
- **Extiende**: ninguno
- **Patrones**: Command (audit trail)
- **Clase Dominio**: ``Session`` (primaria), ``AuditEvent``
- **Función RBAC**: sesión propia (no requiere función explícita)
- **Dependencias**: UC_AUTH_01
- **Cat Z.2.A**: 1

### UC_AUTH_03 — Recuperar Contrasena

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_admin_usuarios`` (admin reset)
- **Incluye**: generar token reset, validar identidad, enviar credenciales temporales vía InternalMailbox (CNST-001)
- **Extiende**: UC_AUTH_04
- **Patrones**: Template Method (workflow), Observer (notificación)
- **Clase Dominio**: ``User`` (primaria), ``InternalMailbox``, ``AuditEvent``
- **Función RBAC**: AUTH-003 ``reset_password``
- **Dependencias**: UC_USR_03 (modificar usuario para hash)
- **Cat Z.2.A**: 1

### UC_AUTH_04 — Cambiar Contrasena

- **Criticidad**: CRÍTICO
- **Complejidad**: BAJA · 2 días
- **Actor**: Usuario autenticado
- **Incluye**: validar contraseña actual, hashear nueva, registro auditoría
- **Extiende**: UC_AUTH_01 (forzado en primer login per CNST-003)
- **Patrones**: Command (audit trail)
- **Clase Dominio**: ``User`` (primaria), ``AuditEvent``
- **Función RBAC**: usuario sobre sí mismo (sin función externa)
- **Dependencias**: UC_AUTH_01
- **Cat Z.2.A**: 1

### UC_AUTH_05 — Gestionar Sesiones

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_admin_usuarios``
- **Incluye**: listar sesiones activas del sistema, cerrar sesiones de otros usuarios (close_all), audit
- **Extiende**: ninguno
- **Patrones**: Facade (vista unificada de Sessions), Observer
- **Clase Dominio**: ``Session`` (primaria), ``User``, ``AuditEvent``
- **Función RBAC**: AUTH-001 ``view_own_sessions``, AUTH-002 ``close_user_session``, AUTH-004 ``view_all_active_sessions``
- **Dependencias**: UC_AUTH_01, UC_AUTH_02
- **Cat Z.2.A**: 1

----

## 2.2 Cluster USR (4 UCs) — gestión de usuarios

Responsabilidad: CRUD del catálogo de usuarios. Toda
modificación con ciclo de vida soft-delete (BR-009 v2.0.0).

Criticidad por cluster: **1 CRÍTICO + 3 ALTOS**.

### UC_USR_01 — Crear Usuario

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-006 ``agr_admin_usuarios``
- **Incluye**: validar unicidad email, autogenerar username (CNST-029), generar password temporal, asignar agrupador inicial (opcional, BR-USR-04 re-semantizada), enviar credenciales por InternalMailbox (CNST-001), audit
- **Extiende**: UC_AUTH_01 (login posterior), UC_ACC_04 (asignar agrupador)
- **Patrones**: Template Method (workflow validación), Factory (User entity), Builder (username)
- **Clase Dominio**: ``User`` (primaria), ``Assignment``, ``AccessGroup``, ``AuditEvent``
- **Función RBAC**: USR-001 ``create_users``
- **Dependencias**: UC_ACC_01 (asignar funciones iniciales si aplica), UC_ACC_04
- **Cat Z.2.A**: 1

### UC_USR_02 — Consultar Usuarios

- **Criticidad**: CRÍTICO
- **Complejidad**: BAJA · 3 días
- **Actor**: AGR-006 ``agr_admin_usuarios``
- **Incluye**: listar paginado, filtrar por estado y agrupador, ordenar
- **Extiende**: ninguno
- **Patrones**: Facade, Specification (filtros), Strategy (sort)
- **Clase Dominio**: ``User`` (primaria), ``Assignment``, ``AccessGroup``
- **Función RBAC**: USR-005 ``search_users``, USR-009 ``view_users``
- **Dependencias**: ninguna (sólo lectura)
- **Cat Z.2.A**: 1

### UC_USR_03 — Modificar Usuario

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_admin_usuarios``
- **Incluye**: actualizar atributos, cambiar agrupador (opcional), cerrar sesiones activas si se desactiva, audit
- **Extiende**: UC_AUTH_05 (close_all)
- **Patrones**: Command (audit trail), Observer (cierre cascada de Sessions)
- **Clase Dominio**: ``User`` (primaria), ``Session``, ``AuditEvent``
- **Función RBAC**: USR-002 ``update_users``
- **Dependencias**: UC_USR_02 (selección previa), UC_AUTH_05
- **Cat Z.2.A**: 1

### UC_USR_04 — Eliminar Usuario (Deactivate)

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-006 ``agr_admin_usuarios``
- **Incluye**: transitar User.state → INACTIVE (soft delete BR-009 v2.0.0), invalidar Sessions, audit
- **Extiende**: UC_AUTH_05
- **Patrones**: Command (soft delete), Observer (cascada)
- **Clase Dominio**: ``User`` (primaria), ``Session``, ``AuditEvent``
- **Función RBAC**: USR-003 ``deactivate_users``
- **Dependencias**: UC_USR_02, UC_AUTH_05
- **Cat Z.2.A**: 1

----

## 2.3 Cluster ACC (7 UCs) — acceso y RBAC granular

Responsabilidad: asignar/revocar funciones, agrupadores
predefinidos, permisos excepcionales y reglas SoD.

Criticidad por cluster: **1 CRÍTICO + 4 ALTOS + 1 MEDIO + 1 BAJO**.

### UC_ACC_01 — Asignar Funciones

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: validar SoD (CNST-030), crear Assignment User-Function, audit
- **Extiende**: ninguno
- **Patrones**: Command, Visitor (validación SoD)
- **Clase Dominio**: ``Assignment`` (primaria), ``Function``, ``User``, ``AuditEvent``
- **Función RBAC**: ACC-001 ``assign_functions``
- **Dependencias**: UC_PERM_07 (verify_permission para auto-validación), UC_ACC_05 (consulta SoD)
- **Cat Z.2.A**: 1

### UC_ACC_02 — Revocar Funciones

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: transitar Assignment.state → REVOKED, audit
- **Extiende**: ninguno
- **Patrones**: Command, Observer (invalidación cache permisos)
- **Clase Dominio**: ``Assignment`` (primaria), ``Function``, ``User``, ``AuditEvent``
- **Función RBAC**: ACC-002 ``revoke_functions``
- **Dependencias**: UC_ACC_01
- **Cat Z.2.A**: 1

### UC_ACC_03 — Consultar Permisos

- **Criticidad**: CRÍTICO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: listar funciones directas + heredadas de FunctionGroups + ExceptionalPermissions vigentes, calcular efectivos
- **Extiende**: ninguno
- **Patrones**: Facade (3 fuentes), Composite (jerarquía Group-Function), Visitor (resolución)
- **Clase Dominio**: ``Assignment`` (primaria), ``Function``, ``User``
- **Función RBAC**: ACC-003 ``view_assignments``
- **Dependencias**: ninguna (sólo lectura)
- **Cat Z.2.A**: 1

### UC_ACC_04 — Asignar Agrupador

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: vincular User a AccessGroup (AGR-001..010), audit
- **Extiende**: ninguno
- **Patrones**: Command, Strategy (perfiles AGR)
- **Clase Dominio**: ``Assignment`` (primaria), ``AccessGroup``, ``User``, ``AuditEvent``
- **Función RBAC**: ACC-004 ``assign_function_groups``
- **Dependencias**: UC_USR_02 (User existe), UC_ACC_03
- **Cat Z.2.A**: 1

### UC_ACC_05 — Gestionar SoD

- **Criticidad**: ALTO
- **Complejidad**: ALTA · 5 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: crear regla, listar pares conflictivos, actualizar parámetros, deshabilitar regla (BR-009)
- **Extiende**: ninguno
- **Patrones**: State (RuleState), Visitor (chequeo conflictos), Strategy (políticas SoD)
- **Clase Dominio**: ``SeparationRule`` (primaria), ``Function``, ``AuditEvent``
- **Función RBAC**: ACC-005 ``view_separation_rules``, ACC-011 ``update_separation_rule``, ACC-012 ``disable_separation_rule``
- **Dependencias**: ninguna (configuración)
- **Cat Z.2.A**: 1

### UC_ACC_08 — Permiso Temporal

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-007 ``agr_admin_acceso``
- **Incluye**: otorgar ExceptionalPermission con rango temporal (CNST-031), expirar automáticamente, audit
- **Extiende**: UC_PERM_03 (vista PERM)
- **Patrones**: Command, Decorator (caducidad)
- **Clase Dominio**: ``ExceptionalPermission`` (primaria), ``User``, ``Function``, ``AuditEvent``
- **Función RBAC**: ACC-001 (reuso para otorgar) o ACC-009 (vía vista PERM)
- **Dependencias**: UC_ACC_03
- **Cat Z.2.A**: 1

### UC_ACC_09 — Auditar Cambios de Acceso

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-008 ``agr_auditor``
- **Incluye**: filtrar AuditEvent por event_type ∈ {ACCESS_CHANGE, PERMISSION_GRANT, PERMISSION_REVOKE}, ordenar por fecha
- **Extiende**: UC_AUD_01
- **Patrones**: Specification (filtro), Facade
- **Clase Dominio**: ``AuditEvent`` (primaria), ``User``, ``Assignment``
- **Función RBAC**: AUD-001 ``view_audit_log``
- **Dependencias**: UC_AUD_01 (vista canónica)
- **Cat Z.2.A**: 1

----

## 2.4 Cluster PERM (10 UCs) — vista técnica del RBAC

Responsabilidad: vista técnica de las operaciones RBAC,
coexistencia con ACC declarada en ADR-GOB-008. Toda Cat 5
(vista alternativa, no operaciones nuevas salvo PERM_03/04 que
introducen ExceptionalPermission).

Criticidad por cluster: **1 CRÍTICO + 5 ALTOS + 2 MEDIOS + 2 BAJOS**.

### UC_PERM_01 — Asignar Grupo a Usuario

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: técnico admin (vista técnica per ADR-GOB-008)
- **Incluye**: crear Assignment User-FunctionGroup, audit
- **Extiende**: ninguno
- **Patrones**: Command
- **Clase Dominio**: ``Assignment`` (primaria), ``FunctionGroup``, ``User``, ``AuditEvent``
- **Función RBAC**: ACC-004 ``assign_function_groups``
- **Dependencias**: UC_PERM_05 (Group existe)
- **Cat Z.2.A**: 5

### UC_PERM_02 — Revocar Grupo a Usuario

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: técnico admin
- **Incluye**: transitar Assignment.state → REVOKED, audit
- **Extiende**: ninguno
- **Patrones**: Command, Observer (cache invalidation)
- **Clase Dominio**: ``Assignment`` (primaria), ``FunctionGroup``, ``AuditEvent``
- **Función RBAC**: ACC-008 ``revoke_function_group``
- **Dependencias**: UC_PERM_01
- **Cat Z.2.A**: 5

### UC_PERM_03 — Conceder Permiso Excepcional

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: técnico admin
- **Incluye**: validar rango temporal (CNST-031), crear ExceptionalPermission con justificación, audit
- **Extiende**: ninguno
- **Patrones**: Command, Decorator (TTL)
- **Clase Dominio**: ``ExceptionalPermission`` (primaria), ``User``, ``Function``, ``AuditEvent``
- **Función RBAC**: ACC-009 ``grant_exceptional_permission``
- **Dependencias**: UC_PERM_07 (auto-verify), UC_PERM_04 (caso inverso)
- **Cat Z.2.A**: 5

### UC_PERM_04 — Revocar Permiso Excepcional

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 1 día
- **Actor**: técnico admin
- **Incluye**: transitar ExceptionalPermission.state → REVOKED, audit
- **Extiende**: ninguno
- **Patrones**: Command
- **Clase Dominio**: ``ExceptionalPermission`` (primaria), ``AuditEvent``
- **Función RBAC**: ACC-010 ``revoke_exceptional_permission``
- **Dependencias**: UC_PERM_03
- **Cat Z.2.A**: 5

### UC_PERM_05 — Crear Grupo de Permisos

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: técnico admin
- **Incluye**: crear FunctionGroup vacío, validar nombre único, audit
- **Extiende**: ninguno
- **Patrones**: Factory
- **Clase Dominio**: ``FunctionGroup`` (primaria), ``AuditEvent``
- **Función RBAC**: ACC-006 ``create_function_group``
- **Dependencias**: ninguna
- **Cat Z.2.A**: 5

### UC_PERM_06 — Asignar Funciones a Grupo

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: técnico admin
- **Incluye**: agregar/remover Functions a un FunctionGroup, validar SoD, audit, propagar a Users del grupo
- **Extiende**: ninguno
- **Patrones**: Command, Observer (propagación a Users), Visitor (SoD)
- **Clase Dominio**: ``FunctionGroup`` (primaria), ``Function``, ``AuditEvent``
- **Función RBAC**: ACC-007 ``assign_functions_to_group``
- **Dependencias**: UC_PERM_05, UC_ACC_05 (chequeo SoD)
- **Cat Z.2.A**: 5

### UC_PERM_07 — Verificar Permiso de Usuario

- **Criticidad**: CRÍTICO
- **Complejidad**: ALTA · 4 días
- **Actor**: sistema (transversal)
- **Incluye**: orden de precedencia: revocaciones excepcionales → concesiones excepcionales → grupos asignados; performance < 50ms
- **Extiende**: ninguno (es invocado por todos)
- **Patrones**: Chain of Responsibility (precedencia), Strategy (cache)
- **Clase Dominio**: ``Assignment``, ``ExceptionalPermission``, ``User``, ``Function``
- **Función RBAC**: ACC-003 ``view_assignments``
- **Dependencias**: ninguna (consumida por todos los UCs operativos)
- **Cat Z.2.A**: 5

### UC_PERM_08 — Generar Menu Dinamico

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: sistema (post-login)
- **Incluye**: invocar SQL ``get_user_menu(user_id)`` (CNST-032), formatear estructura jerárquica
- **Extiende**: UC_AUTH_01 (post-login flow)
- **Patrones**: Composite (menu tree), Facade
- **Clase Dominio**: ``Assignment``, ``Function``
- **Función RBAC**: CNST-032 SQL ``get_user_menu`` (no es función RBAC, enforcement automático)
- **Dependencias**: UC_PERM_07 (filtrado de items)
- **Cat Z.2.A**: 5

### UC_PERM_09 — Auditar Acceso

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 1 día
- **Actor**: AGR-008 ``agr_auditor``
- **Incluye**: filtrar AuditEvent por event_type ∈ {LOGIN, LOGOUT, ACCESS_CHANGE}, alertas de patrones anómalos
- **Extiende**: UC_AUD_01
- **Patrones**: Specification (filtro), Observer (alertas)
- **Clase Dominio**: ``AuditEvent``
- **Función RBAC**: AUD-001 ``view_audit_log``
- **Dependencias**: UC_AUD_01
- **Cat Z.2.A**: 5

### UC_PERM_10 — Consultar Auditoria de Permisos

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-008 ``agr_auditor``
- **Incluye**: filtrar AuditEvent por event_type ∈ {PERMISSION_GRANT, PERMISSION_REVOKE}, exportar
- **Extiende**: UC_AUD_02
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``AuditEvent``
- **Función RBAC**: AUD-002 ``search_audit_log``
- **Dependencias**: UC_AUD_02
- **Cat Z.2.A**: 5

----

## 2.5 Cluster RPT (15 UCs) — reportes y métricas

Responsabilidad: visualización de métricas del call center,
exportación, programación, vistas guardadas, instancias por
scope. Cluster con la consolidación Larman aplicada (uc-rpt-04
unifica CSV/Excel/PDF con flujos alternativos).

Criticidad por cluster: **1 CRÍTICO + 3 ALTOS + 9 MEDIOS + 2 BAJOS**.

### UC_RPT_01 — Ver Dashboard

- **Criticidad**: CRÍTICO
- **Complejidad**: MEDIA · 5 días
- **Actor**: AGR-001 ``agr_operador_basico``
- **Incluye**: cargar widgets, renderizar métricas tiempo real, refresco automático
- **Extiende**: UC_RPT_02 (drill-down)
- **Patrones**: Facade, Composite (widgets), Observer (refresh), Decorator (cache)
- **Clase Dominio**: ``Report`` (scope=GENERAL primaria), ``Metric``, ``Call`` (lectura)
- **Función RBAC**: RPT-001 ``view_reports``
- **Dependencias**: UC_PIP_01 (datos analíticos disponibles)
- **Cat Z.2.A**: 1

### UC_RPT_02 — Ver Metricas Tiempo Real

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-001 ``agr_operador_basico``
- **Incluye**: streaming de métricas, evaluación contra Threshold, generación de Alert si supera
- **Extiende**: UC_RPT_01 (origen del drill-down)
- **Patrones**: Observer (streaming), Strategy (umbrales)
- **Clase Dominio**: ``Report``, ``Metric``
- **Función RBAC**: RPT-002 ``view_dashboard``
- **Dependencias**: UC_RPT_01, UC_ALR_01 (Thresholds), UC_ALR_02 (Alerts)
- **Cat Z.2.A**: 2

### UC_RPT_03 — Ver Reportes Historicos

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-002 ``agr_operador_reportes``
- **Incluye**: aplicar filtro fecha rango, paginar resultados, exportar (delegar a UC_RPT_04)
- **Extiende**: UC_RPT_04
- **Patrones**: Specification (filtros), Facade, Strategy (sort)
- **Clase Dominio**: ``Report``, ``Metric``, ``Call`` (lectura)
- **Función RBAC**: RPT-003 ``filter_reports``
- **Dependencias**: UC_RPT_01
- **Cat Z.2.A**: 2

### UC_RPT_04 — Exportar Reporte

- **Criticidad**: ALTO
- **Complejidad**: ALTA · 6 días
- **Actor**: AGR-004 ``data_exporter_group``
- **Incluye**: validar throttling (CNST-020 v3.0.0), encolar ExportJob (CNST-019 v3.0.0 cola asíncrona abstracta), generar artifact (CSV/Excel/PDF según flujo alternativo, Larman D-07), audit
- **Extiende**: ninguno (es consolidado de los antiguos uc-rpt-04/05/06)
- **Patrones**: Saga (transacción async), Strategy (formato), Observer (notificación cuando listo via InternalMailbox)
- **Clase Dominio**: ``ExportJob`` (primaria), ``Report``, ``AuditEvent``
- **Función RBAC**: RPT-004 ``export_csv`` | RPT-005 ``export_excel`` | RPT-006 ``export_pdf`` (validación según flujo)
- **Dependencias**: UC_RPT_01, BR-011 v2.0.0 (límites delegados a CNST)
- **Cat Z.2.A**: 1 (post-Larman)

### UC_RPT_07 — Programar Reporte

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: crear ScheduledReport con cron expression, validar permisos owner, audit
- **Extiende**: UC_RPT_08
- **Patrones**: Strategy (scheduler), Observer (trigger)
- **Clase Dominio**: ``ScheduledReport`` (primaria), ``Report``, ``InternalMailbox``, ``AuditEvent``
- **Función RBAC**: RPT-009 ``schedule_report`` (RESTAURADA en v5.4.0 per Z.2.A § Cat 3)
- **Dependencias**: UC_RPT_01, UC_RPT_04 (delivery)
- **Cat Z.2.A**: 3

### UC_RPT_08 — Ver Reportes Programados

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: listar ScheduledReports del owner, mostrar próxima ejecución
- **Extiende**: UC_RPT_07
- **Patrones**: Facade
- **Clase Dominio**: ``ScheduledReport``, ``Report``
- **Función RBAC**: RPT-001 ``view_reports`` (filtrar scheduled=true — Cat 4 variante filtrada)
- **Dependencias**: UC_RPT_07
- **Cat Z.2.A**: 4

### UC_RPT_09 — Configurar Filtros

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: definir preset de filtros, guardar como configuración reutilizable
- **Extiende**: UC_RPT_03 (instancia)
- **Patrones**: Memento, Builder
- **Clase Dominio**: ``Report`` (atributo filters)
- **Función RBAC**: RPT-003 ``filter_reports`` (variante preset)
- **Dependencias**: UC_RPT_03, UC_RPT_10 (savedview)
- **Cat Z.2.A**: 4

### UC_RPT_10 — Guardar Vista

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-002 ``agr_operador_reportes``
- **Incluye**: snapshot de filtros + ordenamiento + columnas, persistir SavedView
- **Extiende**: ninguno
- **Patrones**: Memento (snapshot)
- **Clase Dominio**: ``SavedView`` (primaria), ``Report``
- **Función RBAC**: RPT-010 ``save_view`` (NUEVA v5.4.0)
- **Dependencias**: UC_RPT_03, UC_RPT_09
- **Cat Z.2.A**: 3

### UC_RPT_11 — Compartir Reporte

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: generar link compartido, validar destinatarios mismo agrupador, entregar por InternalMailbox (CNST-001), audit
- **Extiende**: ninguno
- **Patrones**: Command, Observer (delivery)
- **Clase Dominio**: ``Report`` (operación share), ``InternalMailbox``, ``AuditEvent``
- **Función RBAC**: RPT-010 ``share_report`` (RESTAURADA en v5.4.0)
- **Dependencias**: UC_RPT_01
- **Cat Z.2.A**: 3

### UC_RPT_12 — Ver Reporte Agentes

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: aplicar scope=AGENTS, agrupar Calls por agent_id, calcular métricas
- **Extiende**: UC_RPT_01 (instancia filtrada)
- **Patrones**: Strategy (scope), Facade
- **Clase Dominio**: ``Report`` (scope=AGENTS), ``Call``
- **Función RBAC**: RPT-001 ``view_reports`` (variante filtrada Camino C)
- **Dependencias**: UC_RPT_01
- **Cat Z.2.A**: 4

### UC_RPT_13 — Ver Reporte Colas

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: scope=QUEUES, métricas por cola
- **Extiende**: UC_RPT_01
- **Patrones**: Strategy, Facade
- **Clase Dominio**: ``Report`` (scope=QUEUES), ``Call``
- **Función RBAC**: RPT-001 (variante)
- **Dependencias**: UC_RPT_01
- **Cat Z.2.A**: 4

### UC_RPT_14 — Ver Reporte Campanas

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: scope=CAMPAIGNS, métricas por campaña
- **Extiende**: UC_RPT_01
- **Patrones**: Strategy, Facade
- **Clase Dominio**: ``Report`` (scope=CAMPAIGNS), ``Campaign``, ``Call``
- **Función RBAC**: RPT-001 (variante)
- **Dependencias**: UC_RPT_01
- **Cat Z.2.A**: 4

### UC_RPT_15 — Reporte Transferencias Centro

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-002 ``report_viewer_group``
- **Incluye**: scope=TRANSFERENCES, métricas históricas (≤2 años, CNST-015), filtro por agrupador
- **Extiende**: UC_RPT_03
- **Patrones**: Strategy, Specification
- **Clase Dominio**: ``Report`` (scope=TRANSFERENCES), ``Call``
- **Función RBAC**: RPT-001 (instancia D-10)
- **Dependencias**: UC_RPT_03, UC_RPT_04 (export)
- **Cat Z.2.A**: 1

### UC_RPT_16 — Reporte Menus IVR

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-002 ``report_viewer_group``
- **Incluye**: scope=IVR_MENUS, eventos de menú, paths
- **Extiende**: UC_RPT_03
- **Patrones**: Strategy, Composite (menu tree)
- **Clase Dominio**: ``Report`` (scope=IVR_MENUS), ``Call``
- **Función RBAC**: RPT-001 (instancia D-10)
- **Dependencias**: UC_RPT_03, UC_RPT_04
- **Cat Z.2.A**: 1

### UC_RPT_17 — Reporte Clientes Unicos

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-002 ``report_viewer_group``
- **Incluye**: scope=UNIQUE_CLIENTS, deduplicación, agregaciones, anonimización (CNST-026)
- **Extiende**: UC_RPT_03
- **Patrones**: Strategy, Specification
- **Clase Dominio**: ``Report`` (scope=UNIQUE_CLIENTS), ``Call``
- **Función RBAC**: RPT-001 (instancia D-10)
- **Dependencias**: UC_RPT_03, UC_RPT_04
- **Cat Z.2.A**: 1

----

## 2.6 Cluster ALR (5 UCs) — alertas

Responsabilidad: closed-loop alerting (configurar umbrales,
disparar alertas al exceder, reconocer, gestionar
suscripciones).

Criticidad por cluster: **0 CRÍTICOS + 3 ALTOS + 2 MEDIOS**.

### UC_ALR_01 — Configurar Umbrales

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-005 ``agr_gestor_alertas``
- **Incluye**: definir Threshold por Metric + agrupador, validar rangos, audit
- **Extiende**: ninguno
- **Patrones**: Strategy (operadores), Builder
- **Clase Dominio**: ``Threshold`` (primaria), ``Metric``
- **Función RBAC**: ALR-002 ``configure_thresholds``
- **Dependencias**: ninguna (config)
- **Cat Z.2.A**: 1

### UC_ALR_02 — Ver Alertas Activas

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-001 ``agr_operador_basico``
- **Incluye**: listar Alerts state=ACTIVE filtradas por agrupador, ordenar por severity
- **Extiende**: ninguno
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``Alert`` (primaria), ``Threshold``
- **Función RBAC**: ALR-001 ``view_alerts``
- **Dependencias**: UC_ALR_01 (Thresholds existentes)
- **Cat Z.2.A**: 1

### UC_ALR_03 — Reconocer Alerta

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: transitar Alert.state ACTIVE → ACKNOWLEDGED, registrar acknowledged_by/at, audit
- **Extiende**: ninguno
- **Patrones**: State, Command
- **Clase Dominio**: ``Alert`` (primaria), ``AuditEvent``
- **Función RBAC**: ALR-007 ``acknowledge_alert`` (NUEVA v5.4.0 per Z.2 D-02)
- **Dependencias**: UC_ALR_02
- **Cat Z.2.A**: 1

### UC_ALR_04 — Ver Historial Alertas

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-003 ``agr_supervisor``
- **Incluye**: listar Alerts históricas (≤2 años CNST-015), filtros, exportación
- **Extiende**: UC_ALR_02
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``Alert``, ``AuditEvent``
- **Función RBAC**: ALR-006 ``view_alert_history``
- **Dependencias**: UC_ALR_02
- **Cat Z.2.A**: 1

### UC_ALR_05 — Gestionar Suscripciones

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-005 ``agr_gestor_alertas``
- **Incluye**: 3 flujos alternativos (Larman per Z.2 D-04): Subscribe / Unsubscribe / Configure-Severity, entrega por InternalMailbox (CNST-001), audit
- **Extiende**: ninguno
- **Patrones**: Command (3 ops), Strategy (severity filter), Observer (delivery)
- **Clase Dominio**: ``Subscription`` (primaria, split per Z.2 D-03), ``Alert``, ``User``, ``InternalMailbox``
- **Función RBAC**: ALR-008 ``subscribe_to_alert``, ALR-009 ``unsubscribe_from_alert``, ALR-010 ``configure_subscription_severity``
- **Dependencias**: UC_ALR_01, UC_ALR_02
- **Cat Z.2.A**: 1

----

## 2.7 Cluster PIP (4 UCs) — pipeline ETL

Responsabilidad: supervisión del pipeline ETL que carga datos
de la BD operativa a la BD analítica dentro de la ventana
CNST-006/007/008.

Criticidad por cluster: **1 CRÍTICO + 3 ALTOS**.

### UC_PIP_01 — Supervisar ETL

- **Criticidad**: CRÍTICO
- **Complejidad**: MEDIA · 4 días
- **Actor**: AGR-009 ``agr_admin_pipeline``
- **Incluye**: monitorear ETLExecutions corrientes/recientes, mostrar status, alertar si fuera de ventana
- **Extiende**: ninguno
- **Patrones**: Observer (status updates), Facade
- **Clase Dominio**: ``ETLExecution`` (primaria)
- **Función RBAC**: PIP-001 ``view_etl_executions``
- **Dependencias**: ninguna (background)
- **Cat Z.2.A**: 1

### UC_PIP_02 — Consultar Errores ETL

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-009 ``agr_admin_pipeline``
- **Incluye**: listar ETLErrors filtrados por execution_id y severity, marcar como resueltos
- **Extiende**: UC_PIP_01
- **Patrones**: Specification, Command (mark resolved)
- **Clase Dominio**: ``ETLError`` (primaria), ``ETLExecution``
- **Función RBAC**: PIP-002 ``view_etl_errors``
- **Dependencias**: UC_PIP_01
- **Cat Z.2.A**: 1

### UC_PIP_03 — Consultar Disponibilidad

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-009 ``agr_admin_pipeline``
- **Incluye**: chequear last successful ETLExecution, retornar boolean + metadata
- **Extiende**: UC_PIP_01
- **Patrones**: Facade, Specification
- **Clase Dominio**: ``ETLExecution`` (lectura status)
- **Función RBAC**: PIP-003 ``check_availability``
- **Dependencias**: UC_PIP_01
- **Cat Z.2.A**: 1

### UC_PIP_04 — Solicitar Reintento

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-009 ``agr_admin_pipeline``
- **Incluye**: validar ETLExecution failed, encolar nuevo intento, transitar status → RETRYING, audit
- **Extiende**: ninguno
- **Patrones**: Command, State
- **Clase Dominio**: ``ETLExecution`` (operación retry), ``AuditEvent``
- **Función RBAC**: PIP-004 ``request_retry``
- **Dependencias**: UC_PIP_01, UC_PIP_02
- **Cat Z.2.A**: 1

----

## 2.8 Cluster AUD (4 UCs) — auditoría inmutable

Responsabilidad: consulta y exportación de AuditEvents
inmutables (CNST-025), reporte de compliance.

Criticidad por cluster: **1 CRÍTICO + 2 ALTOS + 1 MEDIO**.

### UC_AUD_01 — Consultar Auditoria

- **Criticidad**: CRÍTICO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_auditor``
- **Incluye**: listar AuditEvents con filtros básicos, paginar
- **Extiende**: ninguno (consumido por UC_PERM_09, UC_PERM_10, UC_ACC_09)
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``AuditEvent`` (primaria)
- **Función RBAC**: AUD-001 ``view_audit_log``
- **Dependencias**: ninguna (lectura inmutable)
- **Cat Z.2.A**: 1

### UC_AUD_02 — Buscar Auditoria

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_auditor``
- **Incluye**: full-text search sobre details JSON, filtros avanzados, performance < 2s
- **Extiende**: UC_AUD_01
- **Patrones**: Specification, Strategy (search engine)
- **Clase Dominio**: ``AuditEvent``
- **Función RBAC**: AUD-002 ``search_audit_log``
- **Dependencias**: UC_AUD_01
- **Cat Z.2.A**: 1

### UC_AUD_03 — Exportar Auditoria

- **Criticidad**: ALTO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-006 ``agr_auditor``
- **Incluye**: encolar ExportJob (CNST-019 v3.0.0), validar throttling (CNST-020 v3.0.0), generar artifact, audit (meta-audit del export)
- **Extiende**: ninguno
- **Patrones**: Saga, Strategy (formato)
- **Clase Dominio**: ``AuditEvent``, ``ExportJob``
- **Función RBAC**: AUD-003 ``export_audit_log``
- **Dependencias**: UC_AUD_01 o UC_AUD_02
- **Cat Z.2.A**: 1

### UC_AUD_04 — Generar Reporte Compliance

- **Criticidad**: MEDIO
- **Complejidad**: ALTA · 5 días
- **Actor**: AGR-006 ``agr_auditor``
- **Incluye**: agregar AuditEvents por categoría, calcular métricas de compliance, generar PDF firmado
- **Extiende**: UC_AUD_01
- **Patrones**: Template Method (workflow), Builder (PDF), Visitor (agregaciones)
- **Clase Dominio**: ``AuditEvent``
- **Función RBAC**: AUD-004 ``generate_compliance_report``
- **Dependencias**: UC_AUD_01, UC_AUD_03
- **Cat Z.2.A**: 1

----

## 2.9 Cluster LOG (7 UCs) — logs y monitoring

Responsabilidad: logs aplicativos / ETL / infraestructura más
SystemHealth (snapshot) y TechnicalMetric (agregación, no log
per Z.2 D-05). Retención per CNST-024.

Criticidad por cluster: **0 CRÍTICOS + 2 ALTOS + 2 MEDIOS + 3 BAJOS**.

### UC_LOG_01 — Consultar Logs Sistema

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-007 ``agr_operador_logs``
- **Incluye**: listar ApplicationLogs filtrados por level/source_module/fecha
- **Extiende**: ninguno
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``ApplicationLog`` (primaria)
- **Función RBAC**: LOG-001 ``view_application_logs`` (renombrada v5.4.0 per Z.2 D-05)
- **Dependencias**: ninguna
- **Cat Z.2.A**: 1

### UC_LOG_02 — Consultar Logs ETL

- **Criticidad**: ALTO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-007 ``agr_operador_logs``
- **Incluye**: listar ETLLogs por execution_id
- **Extiende**: UC_PIP_02 (correlación con ETLErrors)
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``ETLLog`` (primaria), ``ETLExecution``
- **Función RBAC**: LOG-004 ``view_etl_logs`` (NUEVA v5.4.0)
- **Dependencias**: UC_PIP_01 (cross-cluster)
- **Cat Z.2.A**: 1

### UC_LOG_03 — Buscar Logs

- **Criticidad**: BAJO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-007 ``agr_operador_logs``
- **Incluye**: full-text search sobre message, regex opcional
- **Extiende**: UC_LOG_01
- **Patrones**: Specification, Strategy (engine)
- **Clase Dominio**: ``ApplicationLog`` (operación search)
- **Función RBAC**: LOG-003 ``search_logs`` (NUEVA v5.3.0)
- **Dependencias**: UC_LOG_01
- **Cat Z.2.A**: 3

### UC_LOG_04 — Exportar Logs

- **Criticidad**: MEDIO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-007 ``agr_operador_logs``
- **Incluye**: encolar ExportJob (CNST-019 v3.0.0), audit
- **Extiende**: ninguno
- **Patrones**: Saga
- **Clase Dominio**: ``ApplicationLog``, ``ExportJob``
- **Función RBAC**: LOG-002 ``export_logs``
- **Dependencias**: UC_LOG_01 o UC_LOG_03
- **Cat Z.2.A**: 1

### UC_LOG_05 — Ver Logs Infraestructura

- **Criticidad**: MEDIO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-010 ``system_admin_group``
- **Incluye**: listar InfrastructureLogs por host
- **Extiende**: ninguno
- **Patrones**: Specification, Facade
- **Clase Dominio**: ``InfrastructureLog`` (primaria)
- **Función RBAC**: LOG-005 ``view_infrastructure_logs`` (NUEVA v5.4.0)
- **Dependencias**: ninguna
- **Cat Z.2.A**: 1

### UC_LOG_06 — Ver Estado Sistema

- **Criticidad**: BAJO
- **Complejidad**: BAJA · 2 días
- **Actor**: AGR-010 ``system_admin_group``
- **Incluye**: snapshot SystemHealth (CPU, memory, disk, services), retornar agregado
- **Extiende**: ninguno
- **Patrones**: Memento (snapshot), Composite (services_status)
- **Clase Dominio**: ``SystemHealth`` (primaria; D-05: snapshot, no log)
- **Función RBAC**: LOG-006 ``view_system_health`` (NUEVA v5.4.0)
- **Dependencias**: ninguna
- **Cat Z.2.A**: 1

### UC_LOG_07 — Ver Metricas Tecnicas

- **Criticidad**: BAJO
- **Complejidad**: MEDIA · 3 días
- **Actor**: AGR-010 ``system_admin_group``
- **Incluye**: agregar TechnicalMetrics (response time, throughput, error rate) por período
- **Extiende**: ninguno
- **Patrones**: Visitor (agregaciones), Strategy (período)
- **Clase Dominio**: ``TechnicalMetric`` (primaria; D-05: agregación, distinta de Metric de negocio)
- **Función RBAC**: LOG-007 ``view_technical_metrics`` (NUEVA v5.4.0)
- **Dependencias**: ninguna
- **Cat Z.2.A**: 1

----

## 2.10 Verificación cuantitativa

Suma de UCs por criticidad coincide con Parte 1 § 1.2.5:

| Cluster | C | A | M | B | Total |
|---------|--:|--:|--:|--:|------:|
| AUTH | 2 | 2 | 1 | 0 | 5 |
| USR | 1 | 3 | 0 | 0 | 4 |
| ACC | 1 | 4 | 1 | 1 | 7 |
| PERM | 1 | 5 | 2 | 2 | 10 |
| RPT | 1 | 3 | 9 | 2 | 15 |
| ALR | 0 | 3 | 2 | 0 | 5 |
| PIP | 1 | 3 | 0 | 0 | 4 |
| AUD | 1 | 2 | 1 | 0 | 4 |
| LOG | 0 | 2 | 2 | 3 | 7 |
| **Total** | **8** | **27** | **18** | **8** | **61** |

Coincide con Parte 1: 8 + 27 + 18 + 8 = 61. ✓
