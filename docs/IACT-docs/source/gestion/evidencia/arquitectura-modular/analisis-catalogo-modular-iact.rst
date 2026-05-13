.. meta::
 :artefacto: ANALISIS_CATALOGO_MODULAR_IACT
 :tipo: Evidencia
 :dominio: gestion
 :subdominio: evidencia/arquitectura-modular
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-28
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

==================================================
Análisis del Catálogo Modular IACT (8 módulos)
==================================================

.. note::

 Migrado a source/ desde artefacto histórico de WP
 source-rebuild-requisitos (Phase 3 ANALYZE). Inventario
 detallado extraído de tres canónicos:
 ``REFERENCIA_GLOBAL_MODULOS_IACT_v1.md``,
 ``ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md``,
 ``GAP_ANALYSIS_SISTEMA_PERMISOS.md``. Aplica skill
 ``bpa-analyze``.

1. Tabla maestra de los 8 módulos canónicos
===========================================

.. list-table::
 :widths: 14 12 14 12 10 38
 :header-rows: 1

 * - Código
   - Nombre Doc
   - Nombre Código
   - Funciones
   - %
   - Descripción
 * - MOD_Auth
   - Auth
   - auth
   - 4
   - 9.1%
   - Autenticación y Sesiones
 * - MOD_Users
   - Users
   - users
   - 10
   - 22.7%
   - Gestión de Identidades
 * - MOD_Access
   - Access
   - access
   - 6
   - 13.6%
   - Roles, Permisos, Segmentos + SEC_RULES
 * - MOD_Pipeline
   - Pipeline
   - pipeline
   - 4
   - 9.1%
   - Supervisión del ETL
 * - MOD_Reports
   - Reports
   - reports
   - 8
   - 18.2%
   - Dashboards y Reportes
 * - MOD_Alerts
   - Alerts
   - alerts
   - 6
   - 13.6%
   - Alertas y Notificaciones
 * - MOD_Audit
   - Audit
   - audit
   - 4
   - 9.1%
   - Auditoría Funcional
 * - MOD_Logs
   - Logs
   - logs
   - 2
   - 4.5%
   - Bitácoras Técnicas
 * - **TOTAL**
   - —
   - —
   - **44**
   - **100%**
   - —

Fuente: REF-GLOBAL § "DECISIÓN FINAL: 8 MÓDULOS FUNCIONALES" +
ANL-RBAC § 2.2.

**Observación clave** (ANL-RBAC L131): "MOD_Reports + MOD_Alerts
(31.8% de funciones) es el núcleo operativo del sistema."

2. Detalle por módulo
=====================

2.1 MOD_Auth — Autenticación y Sesiones
---------------------------------------

**Propósito:** Controlar acceso inicial al sistema y vigencia de
sesiones.

**PUEDE:** Login con credenciales, Logout, JWT (access + refresh),
gestión de sesiones en BD; timeout 15 min, throttling de intentos
(5/5min); validación IP + User-Agent, recuperación + cambio de
contraseña vía buzón interno.

**NO PUEDE:** Definir roles ni permisos (MOD_Access), gestionar
datos de usuario (MOD_Users), enviar emails, lógica de alertas
(MOD_Alerts).

**UCs:** UC-001 Inicio (Must), UC-002 Cierre (Must), UC-003
Recuperación, UC-004 Cambio password, UC-005 Sesiones BD.

**Restricciones:** CNST_001 (NO email), CNST_002 (sesiones BD/única/
timeout), CNST_007 (throttling).

**Dependencias:** Consume MOD_Users, MOD_Access. Produce a
MOD_Audit.

2.2 MOD_Users — Gestión de Identidades
--------------------------------------

**Propósito:** Gestionar existencia, estado y datos básicos de
cuentas.

**PUEDE:** Alta, modificación, baja lógica (nunca física), listar
con filtros, gestionar estados (activo, bloqueado,
pendiente_configuración), preguntas de seguridad, password
temporal, notificar vía buzón interno.

**NO PUEDE:** Asignar roles/permisos directos (MOD_Access),
calcular permisos efectivos, validar SoD, enviar emails.

**UCs:** UC-006 Crear, UC-007 Modificar, UC-008 Baja lógica,
UC-009 Listar.

**Restricciones:** CNST_001 (buzón), CNST_005 (bajas lógicas,
username autogenerado, estado inicial PENDIENTE_CONFIGURACION).

**Dependencias:** Productor para MOD_Auth. Consume MOD_Access.

2.3 MOD_Access — Roles, Permisos, Segmentos + SEC_RULES
-------------------------------------------------------

**Propósito:** Definir y administrar qué puede hacer cada usuario
y aplicar reglas de seguridad en runtime.

**Sub-componentes** (único módulo con sub-componentes en
REF-GLOBAL):

1. **RBAC_CORE (Administración) — visible:** pantallas admin de
   roles, CRUD roles/permisos/segmentos, asignación, gestión
   segmentos (DataSegment), permisos directos con justificación +
   vencimiento, configuración SoD.
2. **SEC_RULES (Enforcement) — automático:** middleware de
   validación, decoradores DRF, cálculo de permisos efectivos,
   precedencia (Directo > Rol > Segmento), validación SoD en
   tiempo real, enforcement de restricciones globales.

**PUEDE:** Administrar catálogo de roles (R001–R018), asignar/
quitar roles, gestionar DataSegment + DirectPermission, aplicar
SoD, calcular permisos efectivos, bloquear acciones violatorias.

**NO PUEDE:** Mostrar UI funcional de negocio, crear/modificar
datos de usuario, autenticar, ejecutar lógica de negocio de otros
dominios.

**UCs:** UC-010 Asignar roles, UC-011 Permisos por rol, UC-041
Segmentos, UC-042 Permisos directos, UC-045 Catálogo roles, UC-046
Catálogo permisos, UC-047 Auditar cambios; UC-043 SoD, UC-044
Permisos efectivos.

**Restricciones:** CNST_005 (Flat RBAC NIST sin jerarquías; máx 18
roles; precedencia Directo > Rol > Segmento; SoD obligatorio;
permisos directos con justificación ≥ 20 chars y vencimiento ≤ 6
meses).

**Dependencias:** Consume MOD_Users. Productor para MOD_Auth.
Produce a MOD_Audit. TODOS los módulos consumen vía SEC_RULES.

2.4 MOD_Pipeline — Supervisión del ETL
--------------------------------------

**Propósito:** Supervisar, monitorear y validar estado del ETL y
disponibilidad de datos.

**PUEDE:** Consultar histórico ETLExecution + ETLError, ver última/
próxima ejecución, consultar disponibilidad por período,
identificar desfasajes (>48h), indicadores de calidad, solicitar
reintento controlado.

**NO PUEDE:** Ejecutar ETL directamente, modificar configuración,
hacer reportes de negocio, consultar BD IVR directamente.

**UCs:** UC-050 Supervisar, UC-051 Errores, UC-052 Disponibilidad,
UC-053 Reintento.

**Restricciones:** CNST_003 (BD IVR solo SELECT; ETL no escribe
MySQL; frecuencia 6–12h; NO real-time/WS/SSE).

**Dependencias:** Produce a MOD_Logs. Productor para MOD_Reports.
Externo: Scheduler (APScheduler/Celery).

2.5 MOD_Reports — Dashboards y Reportes
---------------------------------------

**Propósito:** Entregar información visual y tabular vía dashboards
predefinidos, reportes operativos y exportaciones controladas.

**PUEDE:** Dashboards operativos predefinidos, reportes tabulares
SQL, filtros por fecha/centro/servicio, gráficos por hora/día/
centro, KPIs estáticos, exportar CSV/Excel/PDF con límites,
respetar segmentos, mostrar "Última actualización".

**NO PUEDE:** Ejecutar ETL, agendar jobs, consultar BD IVR,
real-time, personalizar dashboards por usuario, query builder
ad-hoc, OLAP/drill-down dinámico, enviar reportes por email.

**UCs (Must):** UC-017 trimestral, UC-018 problemas menú, UC-019
transferencias, UC-020 filtro fecha, UC-021 filtro centro, UC-022
CSV, UC-023 Excel, UC-025 dashboard. **(Should):** UC-024 PDF,
UC-027 hora, UC-028 día, UC-029 centro.

**Restricciones:** CNST_003 (no real-time), CNST_006 (rango max 2
años), CNST_007 (límites: CSV 100k/10 día, Excel 50k/5 día, PDF
10k/3 día), CNST_001 (sin email).

**Dependencias:** Consume MOD_Access (VIEW/EXPORT) y MOD_Pipeline.
Produce a MOD_Audit.

2.6 MOD_Alerts — Alertas y Notificaciones
-----------------------------------------

**Propósito:** Detectar condiciones sobre datos/eventos y notificar
vía buzón interno.

**PUEDE:** Crear/configurar alertas con reglas, umbrales (threshold,
trend), destinatarios (máx. 50), evaluación periódica, notificar
vía buzón, pausar/snooze, historial, consolidar repetidas.
Severidades: INFO, WARNING, CRITICAL.

**NO PUEDE:** Enviar emails, consultar BD IVR, evaluación
real-time extremo, generar reportes, lógica de permisos.

**UCs:** UC-036 Crear, UC-037 Notificación interna, UC-039
Historial, UC-040 Destinatarios; UC-038 Snooze.

**Restricciones:** CNST_001 (TODO buzón interno), CNST_004 (máx 50
destinatarios; consolidación; frecuencias; severidades).

**Dependencias:** Consume MOD_Pipeline (métricas) y MOD_Access.
Produce a MOD_Audit.

2.7 MOD_Audit — Auditoría Funcional
-----------------------------------

**Propósito:** Registrar y consultar acciones de negocio para
cumplimiento, trazabilidad y seguridad funcional.

**PUEDE:** Registrar eventos de negocio (append-only), capturar
quién/qué/cuándo/sobre qué/resultado, almacenar valores antes/
después en cambios críticos, consultar con filtros, reportes de
auditoría, mantener registros por años.

**NO PUEDE:** Modificar registros existentes (inmutable), eliminar,
registrar logs técnicos (MOD_Logs), definir reglas de acceso.

**UCs:** UC-060 Registrar, UC-061 Consultar; UC-062 Reporte,
UC-063 Exportar.

**Restricciones:** CNST_008 (inmutables append-only; retención 2+
años; SoD auditores ≠ administradores; sin PII innecesaria).

**Dependencias:** TODOS los módulos producen eventos a MOD_Audit.
Consume MOD_Access.

2.8 MOD_Logs — Bitácoras Técnicas
---------------------------------

**Propósito:** Registrar y consultar eventos técnicos para
debugging, monitoreo y soporte operativo.

**PUEDE:** Logs estructurados JSON, niveles
DEBUG/INFO/WARN/ERROR/CRIT, stack traces, métricas de performance,
eventos de infraestructura, rotar 30–90 días, consultar con
filtros, integrar ELK/Loki.

**NO PUEDE:** Registrar eventos de negocio (MOD_Audit), exponer
PII sin enmascarar, retener indefinidamente, reglas de seguridad.

**UCs:** UC-070 Consultar, UC-071 Filtrar; UC-072 Exportar.

**Restricciones:** CNST_008 (no loggear contraseñas/tokens; PII
enmascarada; JSON estructurado; retención 30–90 días).

**Dependencias:** TODOS los módulos envían logs. MOD_Pipeline es
fuente principal (mayor volumen).

3. Reglas SoD definidas (3)
===========================

Fuente: ANL-RBAC § 6.

.. list-table::
 :widths: 12 28 22 22 16
 :header-rows: 1

 * - ID
   - Nombre
   - Grupo A
   - Grupo B
   - Razón
 * - **SOD-001**
   - sod_admin_auditoria
   - Pipeline (4 func)
   - Auditoría (4 func)
   - Quien opera el sistema NO debe auditarlo
 * - **SOD-002**
   - sod_usuarios_auditoria
   - Gestión Users críticas (4 func)
   - Auditoría parcial (3 func)
   - Quien gestiona usuarios NO debe auditar sus acciones
 * - **SOD-003**
   - sod_acceso_auditoria
   - Gestión Acceso (3 func)
   - Auditoría (2 func)
   - Quien gestiona acceso NO debe auditar cambios

Base normativa: CNST_005 (Flat RBAC NIST + SoD obligatorio).

Enforcement: SEC_RULES valida en tiempo real, bloquea asignación
si viola SoD, registra intento en MOD_Audit (ANL-RBAC L454–457).

4. Sistema PERM — Evolución
===========================

Fuente: GAP-PERM (estado al 2025-11-09; "Estado general
documentado en GAP_ANALYSIS").

4.1 Estado de implementación (PROVEN)
-------------------------------------

**Implementado (100%):**

- BD: 8 modelos Django (``models_permisos_granular.py``, 378 ln) —
  Funcion, Capacidad, FuncionCapacidad, GrupoPermiso, GrupoCapacidad,
  UsuarioGrupo, PermisoExcepcional, AuditoriaPermiso.
- 2 vistas SQL (``vista_capacidades_usuario``,
  ``vista_grupos_usuario``).
- 5 funciones SQL nativas PostgreSQL:
  ``usuario_tiene_permiso()``, ``obtener_capacidades_usuario()``,
  ``obtener_grupos_usuario()``, ``verificar_permiso_y_auditar()``,
  **``obtener_menu_usuario()``**.
- Service layer (``UserManagementService``, 6 métodos, 450 ln).
- REST API: 6 serializers + 6 ViewSets + URLs router DRF.
- Endpoints clave: ``/api/permisos/verificar/:id/capacidades/``,
  ``/tiene-permiso/``, **``/menu/``**, ``/grupos/``.
- Tests: 50+ casos REST API.

**Pendiente:**

- Tests integración SQL, performance, carga (Calidad).
- Documentación: 10 UCs detallados (UC-PERM-001..010), 32 diagramas
  UML, OpenAPI spec, guía frontend.
- Herramientas: seed script, management commands, decorators,
  Permission Mixin, Django Admin.
- Operaciones: Prometheus, Grafana, alertas, runbook.

4.2 Menú dinámico como pieza CORE — SÍ (PROVEN)
-----------------------------------------------

El menú dinámico aparece como capacidad central:

- Función SQL nativa: ``obtener_menu_usuario()``.
- Endpoint REST: ``GET /api/permisos/verificar/:id/menu/``.
- UC-PERM-008: "Generar Menú Dinámico por Permisos".
- Guía de integración frontend con cliente TS
  ``getMenu(userId): Promise<MenuNode[]>``.

**Conclusión PROVEN:** el menú dinámico es funcionalidad CORE del
sistema PERM, no add-on.

4.3 ¿PERM reemplaza o coexiste con RBAC original?
-------------------------------------------------

**Clasificación: INFERRED.** El GAP-PERM no contiene la frase
"reemplaza" ni "coexiste"; tampoco discute relación explícita con
MOD_Access/RBAC_CORE.

**Razonamiento:**

1. PERM introduce ocho entidades (vocabulario distinto a
   CNST_005).
2. ``PermisoExcepcional`` cumple semánticamente el rol de
   ``DirectPermission`` (justificación + vencimiento).
3. ``AuditoriaPermiso`` duplica responsabilidad del MOD_Audit
   canónico (UC-047 "Auditar cambios de permisos").
4. PERM no menciona los 18 roles funcionales (R001–R018) ni las 3
   reglas SoD; usa "GrupoPermiso" en su lugar.

**Conclusión INFERRED:** PERM parece ser una **evolución/reemplazo
parcial** del subcomponente RBAC_CORE de MOD_Access. Decisión
canonificada en
:doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
y en :doc:`/gestion/evidencia/rbac-historia/decision-coexistencia-acc-perm`
(coexistencia ACC ↔ PERM como vistas distintas del mismo RBAC
plano).

5. Gaps detectados respecto al modelo de 8 módulos
==================================================

5.1 ¿Dónde encajaría MOD_Permissions?
-------------------------------------

**Interpretación INFERRED:** Si el sistema PERM se formaliza como
módulo independiente (``MOD_Permissions``), absorbería:

- RBAC_CORE de MOD_Access (administración de roles → grupos de
  permisos).
- Subcomponente "permisos directos" (→ ``PermisoExcepcional``).
- Auditoría específica de permisos (→ ``AuditoriaPermiso``, hoy
  responsabilidad de MOD_Audit vía UC-047).

Quedaría en MOD_Access únicamente SEC_RULES (enforcement runtime).

5.2 ¿Dónde encajaría MOD_Call?
------------------------------

**No hay evidencia.** Ni REF-GLOBAL, ni ANL-RBAC, ni GAP-PERM
mencionan ``MOD_Call``. La cadena ``callcentersite`` aparece sólo
como nombre del proyecto Django (``api/callcentersite/...``), no
como módulo funcional.

**Clasificación: SPECULATIVE.** No es propagable como decisión
de arquitectura.

5.3 Riesgos de divergencia
--------------------------

- **Doble auditoría:** MOD_Audit (canónico, transversal) vs
  ``AuditoriaPermiso`` (específico al sistema PERM). Riesgo de
  fuente de verdad dividida.
- **Menú dinámico sin contraparte canónica:** REF-GLOBAL no
  menciona menú dinámico en ningún módulo; aparece sólo en PERM.
  Es funcionalidad nueva, no migración. Canonificada en CNST_032.
- **18 roles vs grupos genéricos:** CNST_005 fija catálogo cerrado
  (R001–R018); PERM usa ``GrupoPermiso`` configurable. Incompatib.
  con la restricción "18 roles funcionales máximo" — superada por
  CNST_029 (modelo plano sin jerarquía).

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Skill aplicada**
   - ``bpa-analyze`` (Business Process Analysis — Analyze)
 * - **WP origen**
   - source-rebuild-requisitos (2026-04-28)
 * - **Migrado a source**
   - 2026-04-30 (sub-WP md-references-audit)
 * - **Decisiones derivadas**
   - | :doc:`/gestion/evidencia/rbac-historia/decision-coexistencia-acc-perm`
     | :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
 * - **Modelo conceptual vigente**
   - :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
 * - **Origen documental**
   - | § 1, § 2: REF-GLOBAL líneas 11–658
     | § 3: ANL-RBAC § 6 líneas 421–502
     | § 4.1: GAP-PERM § 1 líneas 18–130 + § 6 líneas 656–664
     | § 4.2: GAP-PERM líneas 34, 81, 146, 389–404 (PROVEN)
     | § 4.3, § 5: INFERRED — razonamiento explícito documentado
