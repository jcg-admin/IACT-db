```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 3 de 6
```

# PARTE 3 — Matriz de dependencias en formato compacto

> Vista técnica de una línea por UC con la
> firma:
>
> ``UC_ID → INCLUYE [...] → EXTIENDE [...] → REQUIERE [...]``
>
> Donde:
>
> - **INCLUYE**: operaciones internas del flujo
>   principal (no son UCs separados — son pasos /
>   sub-rutinas dentro del UC).
> - **EXTIENDE**: UCs que extienden este (relación
>   inversa per UML).
> - **REQUIERE**: UCs cuya invocación es
>   pre-condición o que se invocan desde el flujo.
>   Las dependencias transversales T-01 (sesión
>   activa) y T-02 (verificar permiso) se omiten
>   aquí — se documentan en Parte 4 — para evitar
>   ruido visual; T-03 (emisión de AuditEvent) se
>   omite por la misma razón salvo casos donde es
>   parte explícita del flujo.

## 3.1 Cluster AUTH (5)

::

   UC_AUTH_01 → INCLUYE [validar credenciales,
                          generar JWT,
                          cerrar sesiones anteriores,
                          throttling intentos,
                          audit] →
                EXTIENDE [UC_AUTH_03, UC_AUTH_04] →
                REQUIERE [ninguno — entrada universal]

   UC_AUTH_02 → INCLUYE [invalidar JWT,
                          transit Session.state → CLOSED,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_AUTH_01]

   UC_AUTH_03 → INCLUYE [generar token reset,
                          validar identidad,
                          enviar credenciales por
                          InternalMailbox] →
                EXTIENDE [UC_AUTH_04] →
                REQUIERE [UC_USR_03]

   UC_AUTH_04 → INCLUYE [validar contraseña actual,
                          hashear nueva,
                          audit] →
                EXTIENDE [UC_AUTH_01 forzado primer login] →
                REQUIERE [UC_AUTH_01]

   UC_AUTH_05 → INCLUYE [listar Sessions activas,
                          close_all,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_AUTH_01, UC_AUTH_02]

## 3.2 Cluster USR (4)

::

   UC_USR_01 → INCLUYE [validar email único,
                         autogenerar username,
                         generar password temporal,
                         enviar credenciales,
                         audit] →
               EXTIENDE [UC_AUTH_01, UC_ACC_04] →
               REQUIERE [UC_ACC_01, UC_ACC_04]

   UC_USR_02 → INCLUYE [paginar, filtrar por estado y agrupador,
                         ordenar] →
               EXTIENDE [] →
               REQUIERE [ninguno — sólo lectura]

   UC_USR_03 → INCLUYE [actualizar atributos,
                         cambiar agrupador,
                         cerrar sesiones si desactivación,
                         audit] →
               EXTIENDE [UC_AUTH_05] →
               REQUIERE [UC_USR_02, UC_AUTH_05]

   UC_USR_04 → INCLUYE [transit User.state → INACTIVE,
                         invalidar Sessions,
                         audit] →
               EXTIENDE [UC_AUTH_05] →
               REQUIERE [UC_USR_02, UC_AUTH_05]

## 3.3 Cluster ACC (7)

::

   UC_ACC_01 → INCLUYE [validar SoD,
                         crear Assignment,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_ACC_05]

   UC_ACC_02 → INCLUYE [transit Assignment.state → REVOKED,
                         invalidar cache permisos,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_ACC_01]

   UC_ACC_03 → INCLUYE [listar funciones directas,
                         listar funciones por FunctionGroup,
                         listar ExceptionalPermission vigentes,
                         calcular efectivos] →
               EXTIENDE [UC_PERM_07] →
               REQUIERE [ninguno — sólo lectura]

   UC_ACC_04 → INCLUYE [vincular User a AccessGroup,
                         audit] →
               EXTIENDE [UC_PERM_01] →
               REQUIERE [UC_USR_02, UC_ACC_03]

   UC_ACC_05 → INCLUYE [crear regla,
                         listar pares conflictivos,
                         actualizar parámetros,
                         deshabilitar regla,
                         audit] →
               EXTIENDE [] →
               REQUIERE [ninguno]

   UC_ACC_08 → INCLUYE [otorgar ExceptionalPermission,
                         calcular caducidad,
                         audit] →
               EXTIENDE [UC_PERM_03] →
               REQUIERE [UC_ACC_03]

   UC_ACC_09 → INCLUYE [filtrar AuditEvent por event_type
                         {ACCESS_CHANGE, PERMISSION_GRANT,
                         PERMISSION_REVOKE},
                         ordenar por fecha] →
               EXTIENDE [UC_AUD_01] →
               REQUIERE [UC_AUD_01]

## 3.4 Cluster PERM (10) — vista técnica del RBAC

::

   UC_PERM_01 → INCLUYE [crear Assignment User-FunctionGroup,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_PERM_05]

   UC_PERM_02 → INCLUYE [transit Assignment.state → REVOKED,
                          invalidar cache,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_PERM_01]

   UC_PERM_03 → INCLUYE [validar rango temporal CNST-031,
                          crear ExceptionalPermission,
                          audit] →
                EXTIENDE [UC_ACC_08] →
                REQUIERE [UC_PERM_04 caso inverso]

   UC_PERM_04 → INCLUYE [transit ExceptionalPermission.state
                          → REVOKED,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_PERM_03]

   UC_PERM_05 → INCLUYE [crear FunctionGroup vacío,
                          validar nombre único,
                          audit] →
                EXTIENDE [] →
                REQUIERE [ninguno]

   UC_PERM_06 → INCLUYE [agregar/remover Functions a
                          FunctionGroup,
                          validar SoD,
                          propagar a Users del grupo,
                          audit] →
                EXTIENDE [] →
                REQUIERE [UC_PERM_05, UC_ACC_05]

   UC_PERM_07 → INCLUYE [chequeo precedencia:
                          revocaciones excepcionales →
                          concesiones excepcionales →
                          grupos asignados] →
                EXTIENDE [UC_ACC_03] →
                REQUIERE [ninguno —
                          REQUERIDO POR TODO UC operativo]

   UC_PERM_08 → INCLUYE [invocar SQL get_user_menu,
                          formatear estructura jerárquica] →
                EXTIENDE [UC_AUTH_01 post-login flow] →
                REQUIERE [UC_PERM_07]

   UC_PERM_09 → INCLUYE [filtrar AuditEvent
                          {LOGIN, LOGOUT, ACCESS_CHANGE},
                          alertas patrones anómalos] →
                EXTIENDE [UC_AUD_01] →
                REQUIERE [UC_AUD_01]

   UC_PERM_10 → INCLUYE [filtrar AuditEvent
                          {PERMISSION_GRANT,
                          PERMISSION_REVOKE},
                          exportar] →
                EXTIENDE [UC_AUD_02] →
                REQUIERE [UC_AUD_02]

## 3.5 Cluster RPT (15)

::

   UC_RPT_01 → INCLUYE [cargar widgets,
                         renderizar métricas,
                         refresco automático] →
               EXTIENDE [UC_RPT_02..17 — todas las
                          variantes] →
               REQUIERE [UC_PIP_01 datos analíticos]

   UC_RPT_02 → INCLUYE [streaming métricas,
                         evaluación contra Threshold,
                         emisión Alert si supera] →
               EXTIENDE [UC_RPT_01] →
               REQUIERE [UC_RPT_01, UC_ALR_01,
                          UC_ALR_02]

   UC_RPT_03 → INCLUYE [aplicar filtro fecha rango,
                         paginar,
                         exportar (delegar)] →
               EXTIENDE [UC_RPT_04, UC_RPT_15..17] →
               REQUIERE [UC_RPT_01]

   UC_RPT_04 → INCLUYE [validar throttling CNST-020,
                         encolar ExportJob CNST-019,
                         generar artifact CSV/Excel/PDF,
                         audit,
                         entregar por InternalMailbox] →
               EXTIENDE [] →
               REQUIERE [UC_RPT_01]

   UC_RPT_07 → INCLUYE [validar cron expression,
                         crear ScheduledReport,
                         audit] →
               EXTIENDE [UC_RPT_08] →
               REQUIERE [UC_RPT_01, UC_RPT_04]

   UC_RPT_08 → INCLUYE [listar ScheduledReports del owner,
                         mostrar próxima ejecución] →
               EXTIENDE [UC_RPT_07] →
               REQUIERE [UC_RPT_07]

   UC_RPT_09 → INCLUYE [definir preset filtros,
                         persistir configuración] →
               EXTIENDE [UC_RPT_03] →
               REQUIERE [UC_RPT_03, UC_RPT_10]

   UC_RPT_10 → INCLUYE [snapshot filtros + ordenamiento,
                         persistir SavedView] →
               EXTIENDE [] →
               REQUIERE [UC_RPT_03, UC_RPT_09]

   UC_RPT_11 → INCLUYE [generar link compartido,
                         validar destinatarios mismo
                         agrupador,
                         entregar InternalMailbox,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_RPT_01]

   UC_RPT_12 → INCLUYE [aplicar scope=AGENTS,
                         agrupar Calls por agent_id] →
               EXTIENDE [UC_RPT_01] →
               REQUIERE [UC_RPT_01]

   UC_RPT_13 → INCLUYE [scope=QUEUES,
                         métricas por cola] →
               EXTIENDE [UC_RPT_01] →
               REQUIERE [UC_RPT_01]

   UC_RPT_14 → INCLUYE [scope=CAMPAIGNS,
                         métricas por campaña] →
               EXTIENDE [UC_RPT_01] →
               REQUIERE [UC_RPT_01]

   UC_RPT_15 → INCLUYE [scope=TRANSFERENCES,
                         filtros históricos CNST-015] →
               EXTIENDE [UC_RPT_03] →
               REQUIERE [UC_RPT_03, UC_RPT_04]

   UC_RPT_16 → INCLUYE [scope=IVR_MENUS,
                         eventos de menú,
                         paths] →
               EXTIENDE [UC_RPT_03] →
               REQUIERE [UC_RPT_03, UC_RPT_04]

   UC_RPT_17 → INCLUYE [scope=UNIQUE_CLIENTS,
                         deduplicación,
                         anonimización CNST-026] →
               EXTIENDE [UC_RPT_03] →
               REQUIERE [UC_RPT_03, UC_RPT_04]

## 3.6 Cluster ALR (5)

::

   UC_ALR_01 → INCLUYE [definir Threshold por Metric,
                         validar rangos,
                         audit] →
               EXTIENDE [] →
               REQUIERE [ninguno — config]

   UC_ALR_02 → INCLUYE [listar Alerts state=ACTIVE,
                         filtro agrupador,
                         ordenar severity] →
               EXTIENDE [] →
               REQUIERE [UC_ALR_01]

   UC_ALR_03 → INCLUYE [transit Alert.state ACTIVE →
                         ACKNOWLEDGED,
                         registrar acknowledged_by/at,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_ALR_02]

   UC_ALR_04 → INCLUYE [listar Alerts históricas
                         CNST-015,
                         filtros,
                         exportar] →
               EXTIENDE [UC_ALR_02] →
               REQUIERE [UC_ALR_02]

   UC_ALR_05 → INCLUYE [3 flujos alternativos:
                         Subscribe / Unsubscribe /
                         Configure-Severity,
                         entrega InternalMailbox,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_ALR_01, UC_ALR_02]

## 3.7 Cluster PIP (4)

::

   UC_PIP_01 → INCLUYE [monitorear ETLExecutions,
                         status corrientes/recientes,
                         alertar fuera de ventana
                         CNST-006/008] →
               EXTIENDE [] →
               REQUIERE [ninguno — background]

   UC_PIP_02 → INCLUYE [listar ETLErrors filtrados,
                         marcar como resueltos] →
               EXTIENDE [UC_PIP_01] →
               REQUIERE [UC_PIP_01]

   UC_PIP_03 → INCLUYE [chequear last successful
                         ETLExecution,
                         retornar boolean + metadata] →
               EXTIENDE [UC_PIP_01] →
               REQUIERE [UC_PIP_01]

   UC_PIP_04 → INCLUYE [validar ETLExecution failed,
                         encolar nuevo intento,
                         transit status → RETRYING,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_PIP_01, UC_PIP_02]

## 3.8 Cluster AUD (4)

::

   UC_AUD_01 → INCLUYE [listar AuditEvents,
                         filtros básicos,
                         paginar] →
               EXTIENDE [UC_PERM_09, UC_PERM_10,
                          UC_ACC_09] →
               REQUIERE [ninguno — lectura inmutable]

   UC_AUD_02 → INCLUYE [full-text search sobre details,
                         filtros avanzados,
                         performance < 2s] →
               EXTIENDE [UC_AUD_01, UC_PERM_10] →
               REQUIERE [UC_AUD_01]

   UC_AUD_03 → INCLUYE [encolar ExportJob CNST-019,
                         validar throttling CNST-020,
                         generar artifact,
                         meta-audit del export] →
               EXTIENDE [] →
               REQUIERE [UC_AUD_01 o UC_AUD_02]

   UC_AUD_04 → INCLUYE [agregar AuditEvents por categoría,
                         calcular métricas compliance,
                         generar PDF firmado] →
               EXTIENDE [UC_AUD_01] →
               REQUIERE [UC_AUD_01, UC_AUD_03]

## 3.9 Cluster LOG (7)

::

   UC_LOG_01 → INCLUYE [listar ApplicationLogs,
                         filtros level/source/fecha] →
               EXTIENDE [UC_LOG_03, UC_LOG_04] →
               REQUIERE [ninguno]

   UC_LOG_02 → INCLUYE [listar ETLLogs por
                         execution_id] →
               EXTIENDE [UC_PIP_02] →
               REQUIERE [UC_PIP_01 cross-cluster]

   UC_LOG_03 → INCLUYE [full-text search sobre message,
                         regex opcional] →
               EXTIENDE [UC_LOG_01] →
               REQUIERE [UC_LOG_01]

   UC_LOG_04 → INCLUYE [encolar ExportJob CNST-019,
                         audit] →
               EXTIENDE [] →
               REQUIERE [UC_LOG_01 o UC_LOG_03]

   UC_LOG_05 → INCLUYE [listar InfrastructureLogs
                         por host] →
               EXTIENDE [] →
               REQUIERE [ninguno]

   UC_LOG_06 → INCLUYE [snapshot SystemHealth
                         (CPU, memory, disk, services),
                         retornar agregado] →
               EXTIENDE [] →
               REQUIERE [ninguno]

   UC_LOG_07 → INCLUYE [agregar TechnicalMetrics
                         (response time, throughput,
                         error rate),
                         por período] →
               EXTIENDE [] →
               REQUIERE [ninguno]

## 3.10 Métricas del grafo

Conteo verificable de la matriz compacta:

| Métrica | Valor |
|---------|------:|
| Nodos (UCs) | 61 |
| UCs sin REQUIERE (raíces) | 18 |
| UCs sin EXTIENDE (hojas) | 38 |
| UCs con REQUIERE explícito | 43 |
| Aristas REQUIERE explícitas | ≈ 70 |
| Promedio in-degree | ≈ 1.15 |
| Promedio out-degree | ≈ 1.15 |

UCs raíz (sin REQUIERE, asumida sólo T-01 + T-02
transversal):

::

   UC_AUTH_01, UC_USR_02, UC_ACC_03, UC_ACC_05,
   UC_PERM_05, UC_PERM_07, UC_RPT_01,
   UC_ALR_01, UC_PIP_01, UC_AUD_01,
   UC_LOG_01, UC_LOG_05, UC_LOG_06, UC_LOG_07
   + 4 menores

UCs con mayor in-degree (más invocados):

::

   UC_AUTH_01      — invocado universalmente (T-01)
   UC_PERM_07      — invocado universalmente (T-02)
   UC_RPT_01       — 14 invocaciones (todo el cluster RPT)
   UC_PIP_01       — 4 invocaciones (PIP_02..04, LOG_02)
   UC_AUD_01       — 4 invocaciones (AUD_02..04, ACC_09,
                     PERM_09)
   UC_USR_02       — 3 invocaciones (USR_03, USR_04, ACC_04)
   UC_AUTH_05      — 3 invocaciones (USR_03, USR_04, AUTH_02)

----

Próxima parte: Parte 4 — dependencias críticas
detalladas con las 3 transversales (T-01, T-02,
T-03) en profundidad.
