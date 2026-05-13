```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 6 de 6
```

# PARTE 6 — Patrones de diseño aplicados a IACT

> Análisis cross-cutting de los patrones de
> diseño que emergen del catálogo de UCs y del
> modelo de dominio. Identifica qué patrones se
> aplican, en qué UCs, y por qué cada uno
> resuelve un problema concreto del proyecto.
> Sirve como guía para Stage 7 DESIGN del próximo
> WP de implementación (clases reales en
> Django).

## 6.1 Inventario consolidado de patrones

Cosechados de las 61 fichas de Parte 2,
agrupados por familia GoF/POSA/DDD:

### 6.1.1 Patrones estructurales

| Patrón | UCs que lo usan | Función en IACT |
|--------|-----------------|-----------------|
| **Facade** | UC_AUTH_05, UC_USR_02, UC_ACC_03, UC_ALR_02, UC_ALR_04, UC_RPT_01, UC_RPT_08, UC_LOG_01..02, UC_LOG_05, UC_AUD_01, UC_AUD_02, UC_PERM_08, UC_PERM_09, UC_PERM_10, UC_PIP_01, UC_PIP_03 | Vista unificada para consultas que agregan datos de múltiples clases (e.g. ``Assignment`` + ``Function`` + ``ExceptionalPermission`` en ``UC_ACC_03``) |
| **Composite** | UC_PERM_08 (menu tree), UC_RPT_01 (widgets), UC_RPT_16 (menu tree IVR), UC_LOG_06 (services_status) | Estructuras jerárquicas — menús dinámicos, dashboards, árboles de servicios |
| **Decorator** | UC_AUTH_01 (rate limit), UC_PERM_07 (cache), UC_ACC_08 (TTL), UC_PERM_03 (TTL) | Comportamiento aditivo no intrusivo — cache, rate limiting, caducidad |

### 6.1.2 Patrones de comportamiento

| Patrón | UCs que lo usan | Función en IACT |
|--------|-----------------|-----------------|
| **Strategy** | UC_AUTH_01 (auth provider), UC_RPT_04 (formato CSV/Excel/PDF), UC_RPT_12..17 (scope), UC_ALR_01 (operadores comparación), UC_USR_02 (sort), UC_RPT_03 (sort), UC_LOG_03 (search engine), UC_AUD_02 (search), UC_PERM_07 (cache strategy), UC_LOG_07 (período), UC_RPT_07 (scheduler), UC_RPT_09 (preset), UC_ACC_05 (políticas SoD), UC_ACC_04 (perfiles AGR) | Algoritmos intercambiables — formato de export, motores de búsqueda, cache backends |
| **Observer** | UC_AUTH_05 (cierre cascada), UC_USR_03 (Sessions invalidation), UC_USR_04 (idem), UC_ACC_02 (cache invalidation), UC_PERM_02 (idem), UC_PERM_06 (propagación a Users), UC_ALR_03 (post-acknowledge), UC_ALR_05 (delivery), UC_RPT_01 (refresh), UC_RPT_02 (streaming), UC_RPT_04 (notificación cuando listo), UC_RPT_07 (trigger), UC_RPT_11 (delivery), UC_PIP_01 (status updates), UC_PERM_09 (alertas) | Eventos cross-cutting — invalidación de caches, propagación de cambios, streaming |
| **Command** | UC_AUTH_02 (audit trail), UC_AUTH_04, UC_USR_03, UC_USR_04, UC_ACC_01, UC_ACC_02, UC_ACC_04, UC_ACC_05, UC_ACC_08, UC_PERM_01..06, UC_RPT_10, UC_RPT_11, UC_ALR_03, UC_PIP_04, UC_PIP_02 (mark resolved), UC_LOG_06 | Audit trail — toda escritura es un Command que se serializa como AuditEvent |
| **State** | UC_AUTH_01 (Session lifecycle), UC_USR_04 (User), UC_ACC_02 (Assignment), UC_ACC_05 (SeparationRule), UC_PIP_04 (ETLExecution), UC_PIP_01, UC_ALR_03 (Alert) | Toda clase con state enum y BR-009 v2.0.0 (no eliminar) — soft-delete via state transition |
| **Template Method** | UC_AUTH_03 (workflow recuperación), UC_AUD_04 (workflow compliance) | Workflows con pasos fijos y partes variables |
| **Chain of Responsibility** | UC_AUTH_01 (validaciones), UC_PERM_07 (precedencia revocación → concesión → grupo) | Cadena de validaciones / precedencia de permisos |
| **Visitor** | UC_ACC_01 (validación SoD), UC_ACC_05 (chequeo conflictos), UC_PERM_06 (idem), UC_ACC_03 (resolución permisos), UC_AUD_04 (agregaciones), UC_LOG_07 (agregaciones técnicas) | Operaciones agregadas sobre estructuras complejas — resolución RBAC, métricas |
| **Memento** | UC_RPT_09 (preset filtros), UC_RPT_10 (SavedView), UC_LOG_06 (snapshot SystemHealth) | Snapshots persistentes |
| **Specification** | UC_USR_02 (filtros), UC_ACC_03 (filtros), UC_RPT_03 (filtros fecha), UC_RPT_15..17 (scope), UC_AUD_01..02 (filtros), UC_LOG_01..03 (filtros), UC_ALR_02 (filtros), UC_ALR_04 (filtros), UC_PIP_02 (filtros), UC_PERM_09..10 (filtros) | Encapsulación de criterios de búsqueda compuestos |

### 6.1.3 Patrones de creación

| Patrón | UCs que lo usan | Función en IACT |
|--------|-----------------|-----------------|
| **Factory** | UC_USR_01 (User entity), UC_PERM_05 (FunctionGroup) | Construcción centralizada de entidades complejas |
| **Builder** | UC_USR_01 (username generator), UC_ALR_01 (Threshold builder), UC_AUD_04 (PDF builder), UC_RPT_09 (preset builder) | Construcción paso a paso de objetos con muchos parámetros |

### 6.1.4 Patrones arquitectónicos / DDD / async

| Patrón | UCs que lo usan | Función en IACT |
|--------|-----------------|-----------------|
| **Saga** | UC_RPT_04 (export async), UC_AUD_03 (idem), UC_LOG_04 (idem) | Transacciones distribuidas de larga duración (CNST-019 v3.0.0 cola asíncrona abstracta) |
| **Repository** (DDD) | implícito en todas las clases del modelo | Capa de persistencia entre clases del dominio y BD MySQL |
| **Domain Event** (DDD) | implícito en T-03 (AuditEvent emission) | Eventos del dominio publicados al guardar entidades con cambio de state |
| **Bounded Context** (DDD) | 7 contextos del modelo de dominio (Auth, RBAC, Calls, Reports, ETL, Alerts, Audit, Logs) | Aislamiento conceptual entre clusters |

## 6.2 Patrones cross-cutting de IACT (no del catálogo GoF)

Patrones específicos del proyecto que emergen
del análisis y aparecen en múltiples UCs.

### 6.2.1 Patrón "RBAC Decorator"

**Problema**: cada UC operativo (59 de 61) debe
verificar permiso antes de ejecutar su flujo
(T-02). Repetir la verificación en cada
controller produce código duplicado y propenso
a errores.

**Solución**: decorador de método sobre cada
controller / endpoint:

::

   @require_function('RPT-001')
   def view_dashboard(request):
       ...

El decorador resuelve la función RBAC, llama a
``UC_PERM_07``, y aborta con 403 si no autoriza.

**UCs afectados**: 59 de 61 (todos no públicos).

**Trazabilidad**: este patrón es la
materialización de T-02 a nivel de código.

### 6.2.2 Patrón "Audit Emitter"

**Problema**: T-03 exige que toda escritura
emita un AuditEvent inmutable, pero el código de
negocio no debe contener llamadas explícitas
``audit_log.write(...)`` repartidas — eso
genera olvidos y duplicaciones.

**Solución**: middleware observer que se
suscribe a los métodos de servicio de escritura.
Cada método declara su EventType vía decorador
``@audits('PERMISSION_GRANT')``. El middleware
crea el AuditEvent post-commit (no pre-commit)
para garantizar que sólo eventos efectivamente
persistidos generen audit.

**UCs afectados**: los 35 UCs que escriben.

**Trazabilidad**: materialización de T-03.

### 6.2.3 Patrón "BR-009 Soft Delete"

**Problema**: BR-009 v2.0.0 es alcance global —
ninguna entidad del dominio se elimina, sólo
desactiva.

**Solución**: cada clase con ciclo de vida
expone:

- atributo ``state`` con enum específico
  (UserState, SessionState, AlertState,
  AssignmentState, RuleState, ScheduleState,
  ViewState, ExecutionStatus,
  PermissionState, ReportState, JobState,
  SubscriptionState).
- operación ``deactivate()`` o ``disable()``
  (renombrada per Z.2 D-01); nunca ``delete()``.

**UCs afectados**: todos los UCs con escritura
sobre clases con ciclo de vida (≈ 35).

**Trazabilidad**: H-D05 del WP predecesor de
canonización.

### 6.2.4 Patrón "Filtered Variant" (Camino C)

**Problema**: las variantes de un mismo concepto
(reportes por agentes / colas / campañas) no
deben ser funciones RBAC distintas — son la
misma operación con scope distinto.

**Solución**: una única función RBAC
(``view_reports``) más un atributo ``scope`` en
``Report``. Los UCs UC_RPT_08, _09, _12, _13,
_14 son **variantes filtradas** de UC_RPT_01,
no UCs autónomos.

**UCs afectados**: UC_RPT_08, _09, _12, _13,
_14 (5 UCs Cat 4 per Z.2.A).

**Trazabilidad**: Z.2 D-10 + Z.2.A § Cat 4.

### 6.2.5 Patrón "ACC-PERM Coexistence"

**Problema**: dos vistas del mismo modelo RBAC —
funcional (cluster ACC) y técnica (cluster PERM)
— generan documentación duplicada si no se
modela bien.

**Solución**: cada UC_PERM_NN cita la función
RBAC backing del cluster ACC (1:1 mapping).
Operacionalmente operan sobre las **mismas
clases del dominio** (Assignment, FunctionGroup,
ExceptionalPermission) — no clases nuevas.

**UCs afectados**: 10 UCs PERM (Cat 5 Z.2.A).

**Trazabilidad**: ADR-GOB-008.

### 6.2.6 Patrón "Larman Consolidation"

**Problema**: tres operaciones de negocio
(exportar CSV / Excel / PDF) son **un solo UC
business** para el usuario final, pero
**tres funciones RBAC** distintas para SoD.

**Solución**: un solo UC (UC_RPT_04
"Exportar Reporte") con flujos alternativos por
formato; tres funciones RBAC (RPT-004, RPT-005,
RPT-006) que el sistema valida según el flujo
seleccionado. Capa UC y capa RBAC son
ortogonales.

**UCs afectados**: UC_RPT_04 (consolidación de
los antiguos 04/05/06); UC_ALR_05 (3 ops de
suscripción consolidadas en 1 UC).

**Trazabilidad**: Z.2 D-04, D-07.

### 6.2.7 Patrón "Async Throttled Export"

**Problema**: exportar reportes / auditoría /
logs grandes bloquea HTTP requests si se hace
síncrono; consume recursos sin límite.

**Solución**:

- Cola asíncrona (CNST-019 v3.0.0, abstracta —
  no acopla tecnología).
- Throttling abstracto por recursos (CNST-020
  v3.0.0): concurrent jobs por usuario, daily
  quota total, aislamiento de pool.
- Notificación al usuario via InternalMailbox
  cuando el artifact está listo.

**UCs afectados**: UC_RPT_04, UC_AUD_03,
UC_LOG_04 (los tres exportadores).

**Trazabilidad**: BR-011 v2.0.0, CNST-019/020
v3.0.0, Z.2 D-08, D-09.

### 6.2.8 Patrón "Internal Mailbox Delivery"

**Problema**: notificaciones al usuario no
deben usar email externo (CNST-001 — privacidad +
control).

**Solución**: clase ``InternalMailbox`` 1:1 con
``User``. Toda notificación (export listo,
recovery password, alerta suscrita, reporte
compartido) se entrega vía
``InternalMailbox.deliver_message()``.

**UCs afectados**: UC_USR_01 (credenciales
iniciales), UC_AUTH_03 (recovery), UC_RPT_04
(export listo), UC_RPT_07 (scheduled output),
UC_RPT_11 (compartir), UC_ALR_05 (notificación).

**Trazabilidad**: CNST-001.

## 6.3 Resumen cuantitativo de patrones

::

   Strategy           14 UCs
   Observer           14 UCs
   Facade             16 UCs
   Command            17 UCs
   Specification      14 UCs
   State              7 UCs
   Visitor            6 UCs
   Decorator          4 UCs
   Composite          4 UCs
   Memento            3 UCs
   Builder            4 UCs
   Factory            2 UCs
   Template Method    2 UCs
   Chain of Resp      2 UCs
   Saga               3 UCs

   Cross-cutting IACT-específicos:
   RBAC Decorator             59 UCs (T-02)
   Audit Emitter              35 UCs (T-03)
   BR-009 Soft Delete         ≈ 35 UCs
   Filtered Variant           5 UCs
   ACC-PERM Coexistence       10 UCs
   Larman Consolidation       2 UCs (UC_RPT_04, UC_ALR_05)
   Async Throttled Export     3 UCs
   Internal Mailbox Delivery  6 UCs

## 6.4 Implicaciones para Stage 7 DESIGN futuro

Para la fase de implementación real (próximo WP
fuera de este análisis), Stage 7 DESIGN debe
producir:

- **Una clase decorador ``@require_function``**
  que materialice T-02 (~30 LOC, reutilizada
  por 59 UCs).
- **Un middleware ``AuditEmitter``** que
  materialice T-03 (~50 LOC, reutilizado por
  35 UCs).
- **Una clase base ``LifecycleEntity``** o un
  mixin con ``state`` + ``deactivate()`` que
  materialice BR-009 v2.0.0 para ≈ 35 clases.
- **Un servicio ``ExportJobScheduler``** que
  materialice CNST-019/020 v3.0.0, reutilizado
  por UC_RPT_04, UC_AUD_03, UC_LOG_04.
- **Un servicio ``InternalMailbox``** que
  materialice CNST-001, reutilizado por 6 UCs.

Estos cinco componentes capturan ≈ 80 % de la
infraestructura cross-cutting del sistema.

----

Próxima parte: Conclusión + métricas globales +
próximos pasos.
