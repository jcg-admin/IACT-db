```yml
created_at: 2026-04-28 23:32:35
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario Detallado de Módulos IACT

Documento extraído de los tres canónicos:
- `REFERENCIA_GLOBAL_MODULOS_IACT_v1.md` (REF-GLOBAL)
- `ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md` (ANL-RBAC)
- `GAP_ANALYSIS_SISTEMA_PERMISOS.md` (GAP-PERM)

---

## 1. Tabla maestra de los 8 módulos canónicos

| Código | Nombre Doc | Nombre Código | Funciones | % | Descripción |
|--------|------------|---------------|-----------|----|-------------|
| MOD_Auth | Auth | auth | 4 | 9.1% | Autenticación y Sesiones |
| MOD_Users | Users | users | 10 | 22.7% | Gestión de Identidades |
| MOD_Access | Access | access | 6 | 13.6% | Roles, Permisos, Segmentos + SEC_RULES |
| MOD_Pipeline | Pipeline | pipeline | 4 | 9.1% | Supervisión del ETL |
| MOD_Reports | Reports | reports | 8 | 18.2% | Dashboards y Reportes |
| MOD_Alerts | Alerts | alerts | 6 | 13.6% | Alertas y Notificaciones |
| MOD_Audit | Audit | audit | 4 | 9.1% | Auditoría Funcional |
| MOD_Logs | Logs | logs | 2 | 4.5% | Bitácoras Técnicas |
| **TOTAL** | — | — | **44** | **100%** | — |

Fuente: REF-GLOBAL §"DECISIÓN FINAL: 8 MÓDULOS FUNCIONALES" + ANL-RBAC §2.2.

Observación clave (ANL-RBAC L131): "MOD_Reports + MOD_Alerts (31.8% de funciones) es el núcleo operativo del sistema."

---

## 2. Detalle por módulo

### 2.1 MOD_Auth — Autenticación y Sesiones

**Propósito:** Controlar el acceso inicial al sistema y la vigencia de las sesiones.

**PUEDE hacer:**
- Login con credenciales (usuario + contraseña)
- Logout (cierre de sesión)
- Generación y validación de JWT (access + refresh)
- Gestión de sesiones en BD; timeout 15 min
- Throttling de intentos fallidos (5/5min); validación IP+User-Agent
- Recuperación de contraseña vía buzón interno; cambio de contraseña

**NO PUEDE hacer:**
- Definir roles ni permisos (eso es MOD_Access)
- Gestionar datos de usuario más allá de credenciales (MOD_Users)
- Enviar emails
- Lógica de alertas por intentos fallidos (MOD_Alerts)

**Casos de Uso:** UC-001 Inicio de sesión (Must), UC-002 Cierre (Must), UC-003 Recuperación (Must), UC-004 Cambio password (Must), UC-005 Sesiones BD (Must).

**Restricciones:** CNST_001 (NO email — solo buzón); CNST_002 (sesiones BD, única, timeout 15min); CNST_007 (throttling 5/5min).

**Dependencias:** Consume MOD_Users (identidad) y MOD_Access (permisos iniciales). Produce eventos a MOD_Audit.

---

### 2.2 MOD_Users — Gestión de Identidades

**Propósito:** Gestionar la existencia, estado y datos básicos de las cuentas de usuario.

**PUEDE hacer:**
- Alta de usuario; modificación de datos
- Baja lógica (nunca física)
- Listar usuarios con filtros
- Gestionar estados (activo, bloqueado, pendiente_configuración)
- Configurar preguntas de seguridad; password temporal
- Notificar vía buzón interno

**NO PUEDE hacer:**
- Asignar roles/segmentos/permisos directos (MOD_Access)
- Calcular permisos efectivos ni validar SoD (MOD_Access)
- Enviar emails

**Casos de Uso:** UC-006 Crear (Must), UC-007 Modificar (Must), UC-008 Baja lógica (Must), UC-009 Listar (Must).

**Restricciones:** CNST_001 (buzón interno); CNST_005 (bajas lógicas, username autogenerado, estado inicial PENDIENTE_CONFIGURACION).

**Dependencias:** Productor para MOD_Auth. Consume MOD_Access. Produce a MOD_Audit. Consume MOD_Alerts (buzón).

---

### 2.3 MOD_Access — Roles, Permisos, Segmentos + SEC_RULES

**Propósito:** Definir y administrar qué puede hacer cada usuario y aplicar reglas de seguridad en runtime.

**Sub-componentes internos** (único módulo con sub-componentes en REF-GLOBAL):
1. **RBAC_CORE (Administración) — visible al usuario:** pantallas admin de roles, CRUD roles/permisos/segmentos, configuración permisos por rol, asignación roles, gestión segmentos (DataSegment), permisos directos con justificación + vencimiento, configuración SoD.
2. **SEC_RULES (Enforcement) — automático, no visible:** middleware de validación, decoradores DRF, cálculo de permisos efectivos, precedencia (Directo>Rol>Segmento), validación SoD en tiempo real, enforcement de restricciones globales (NO email, BD IVR readonly, límites exportación, throttling, NO real-time).

**PUEDE hacer:**
- Administrar catálogo de roles (R001–R018)
- Asignar/quitar roles a usuarios; configurar permisos por rol
- Gestionar segmentos (DataSegment) y permisos directos (DirectPermission)
- Aplicar reglas SoD; calcular permisos efectivos por usuario/contexto
- Bloquear acciones que violen restricciones; aplicar precedencia

**NO PUEDE hacer:**
- Mostrar UI funcional de negocio (reportes, dashboards)
- Crear/modificar datos de usuario (MOD_Users)
- Autenticar usuarios (MOD_Auth)
- Ejecutar lógica de negocio de otros dominios

**Casos de Uso:** UC-010 Asignar roles, UC-011 Permisos por rol, UC-041 Segmentos, UC-042 Permisos directos, UC-045 Catálogo roles, UC-046 Catálogo permisos, UC-047 Auditar cambios (Must); UC-043 SoD, UC-044 Permisos efectivos (Should).

**Restricciones:** CNST_005 (Flat RBAC NIST sin jerarquías; máx 18 roles; precedencia Directo>Rol>Segmento; SoD obligatorio; permisos directos con justificación ≥20 chars y vencimiento ≤6 meses).

**Dependencias:** Consume MOD_Users. Productor para MOD_Auth. Produce a MOD_Audit. TODOS los módulos consumen vía SEC_RULES.

---

### 2.4 MOD_Pipeline — Supervisión del ETL

**Propósito:** Supervisar, monitorear y validar el estado del proceso ETL y la disponibilidad de datos.

**PUEDE hacer:**
- Consultar histórico ETLExecution y ETLError
- Ver última ejecución exitosa / próxima programada
- Consultar disponibilidad de datos por período (qué trimestres/fechas cargados)
- Identificar desfasajes (>48h sin carga); indicadores de calidad
- Solicitar reintento controlado (roles autorizados)

**NO PUEDE hacer:**
- Ejecutar el ETL directamente (lo hace el scheduler)
- Modificar configuración del pipeline; transformar datos
- Hacer reportes de negocio (MOD_Reports)
- Consultar BD IVR directamente; exponer logs crudos

**Casos de Uso:** UC-050 Supervisar (Must), UC-051 Errores (Must), UC-052 Disponibilidad (Must), UC-053 Reintento (Should).

**Restricciones:** CNST_003 (BD IVR solo SELECT; ETL no escribe MySQL; frecuencia 6–12h; NO real-time/WS/SSE; mostrar "Última/Próxima actualización").

**Dependencias:** Produce a MOD_Logs. Productor para MOD_Reports. Externo: Scheduler (APScheduler/Celery).

---

### 2.5 MOD_Reports — Dashboards y Reportes

**Propósito:** Entregar información visual y tabular vía dashboards predefinidos, reportes operativos y exportaciones controladas.

**PUEDE hacer:**
- Dashboards operativos predefinidos; reportes tabulares SQL
- Filtros por fecha/centro/servicio; gráficos por hora/día/centro; KPIs estáticos
- Exportar CSV/Excel/PDF con límites
- Respetar segmentos de datos del usuario; mostrar "Última actualización"

**NO PUEDE hacer:**
- Ejecutar ETL ni agendar jobs; consultar BD IVR; real-time
- Personalizar dashboards por usuario; query builder ad-hoc; OLAP/drill-down dinámico
- Enviar reportes por email

**Casos de Uso (Must):** UC-017 trimestral, UC-018 problemas menú, UC-019 transferencias, UC-020 filtro fecha, UC-021 filtro centro, UC-022 CSV, UC-023 Excel, UC-025 dashboard. **(Should):** UC-024 PDF, UC-027 hora, UC-028 día, UC-029 centro.

**Restricciones:** CNST_003 (datos desfasados, no real-time); CNST_006 (rango máx 2 años; tiempos máximos); CNST_007 (límites exportación: CSV 100k/10 día; Excel 50k/5 día; PDF 10k/3 día); CNST_001 (sin email).

**Dependencias:** Consume MOD_Access (VIEW/EXPORT) y MOD_Pipeline (datos ETL). Produce a MOD_Audit.

---

### 2.6 MOD_Alerts — Alertas y Notificaciones

**Propósito:** Detectar condiciones sobre datos/eventos y notificar usuarios mediante buzón interno.

**PUEDE hacer:**
- Crear/configurar alertas con reglas; umbrales (threshold, trend)
- Configurar destinatarios (máx. 50); evaluación periódica
- Notificar vía buzón interno; pausar/snooze; historial; consolidar repetidas
- Severidades: INFO, WARNING, CRITICAL

**NO PUEDE hacer:**
- Enviar emails; consultar BD IVR; evaluación real-time extremo
- Generar reportes (MOD_Reports); lógica de permisos

**Casos de Uso:** UC-036 Crear (Must), UC-037 Notificación interna (Must), UC-039 Historial (Must), UC-040 Destinatarios (Must); UC-038 Snooze (Should).

**Restricciones:** CNST_001 (TODO buzón interno); CNST_004 (máx 50 destinatarios; consolidación; frecuencias definidas; severidades).

**Dependencias:** Consume MOD_Pipeline (métricas) y MOD_Access (permisos). Produce a MOD_Audit.

---

### 2.7 MOD_Audit — Auditoría Funcional

**Propósito:** Registrar y consultar acciones de negocio para cumplimiento, trazabilidad y seguridad funcional.

**PUEDE hacer:**
- Registrar eventos de negocio (append-only)
- Capturar: quién/qué/cuándo/sobre qué/resultado
- Almacenar valores antes/después en cambios críticos
- Consultar con filtros (usuario/acción/período); reportes de auditoría
- Mantener registros por años (cumplimiento)

**NO PUEDE hacer:**
- Modificar registros existentes (inmutable); eliminar
- Registrar logs técnicos (MOD_Logs); definir reglas de acceso

**Casos de Uso:** UC-060 Registrar (Must), UC-061 Consultar (Must); UC-062 Reporte auditoría (Should), UC-063 Exportar (Should).

**Restricciones:** CNST_008 (registros inmutables append-only; retención 2+ años; SoD auditores ≠ administradores; sin PII innecesaria).

**Dependencias:** TODOS los módulos producen eventos a MOD_Audit. Consume MOD_Access (permisos visualización).

---

### 2.8 MOD_Logs — Bitácoras Técnicas

**Propósito:** Registrar y consultar eventos técnicos para debugging, monitoreo y soporte operativo.

**PUEDE hacer:**
- Logs estructurados JSON; niveles DEBUG/INFO/WARN/ERROR/CRIT
- Stack traces; métricas de performance; eventos de infraestructura
- Rotar 30–90 días; consultar con filtros técnicos; integrar ELK/Loki

**NO PUEDE hacer:**
- Registrar eventos de negocio (MOD_Audit)
- Exponer PII sin enmascarar; retener indefinidamente; reglas de seguridad

**Casos de Uso:** UC-070 Consultar (Should), UC-071 Filtrar (Should); UC-072 Exportar (Could).

**Restricciones:** CNST_008 (no loggear contraseñas/tokens; PII enmascarada; JSON estructurado; retención 30–90 días).

**Dependencias:** TODOS los módulos envían logs. MOD_Pipeline es la fuente principal (mayor volumen).

---

## 3. Reglas SoD definidas (3)

Fuente: ANL-RBAC §6.

| ID | Nombre | Grupo A | Grupo B | Razón |
|----|--------|---------|---------|-------|
| **SOD-001** | sod_admin_auditoria | Pipeline (4 func: ve_estado_etl, ve_errores_etl, ve_disponibilidad_datos, solicita_reintento_etl) | Auditoría (4 func: ve_auditoria, busca_auditoria, exporta_auditoria, genera_reporte_compliance) | Quien opera el sistema NO debe auditarlo |
| **SOD-002** | sod_usuarios_auditoria | Gestión Users críticas (4 func: crea_usuarios, modifica_usuarios, elimina_usuarios, bloquea_usuarios) | Auditoría parcial (3 func: ve_auditoria, busca_auditoria, exporta_auditoria) | Quien gestiona usuarios NO debe auditar sus propias acciones |
| **SOD-003** | sod_acceso_auditoria | Gestión Acceso (3 func: asigna_funciones, revoca_funciones, gestiona_sod) | Auditoría (2 func: ve_auditoria, busca_auditoria) | Quien gestiona acceso NO debe auditar cambios de permisos |

Base normativa: CNST_005 (Flat RBAC NIST + SoD obligatorio: SYSTEM_ADMIN ⚔️ AUDIT_VIEWER, REPORT_ADMIN ⚔️ REPORT_EXPORTER, USER_ADMIN ⚔️ PERMISSION_ADMIN).

Enforcement (SOD-001): "SEC_RULES valida en tiempo real / Bloquea asignación si viola SoD / Registra intento en MOD_Audit" (ANL-RBAC L454–457).

---

## 4. Sistema PERM — Evolución

Fuente: GAP-PERM (estado al 2025-11-09; "Estado general: 75% completado").

### 4.1 Estado de implementación (PROVEN)

**Implementado (100%):**
- Base de datos: 8 modelos Django (`models_permisos_granular.py`, 378 ln) — Funcion, Capacidad, FuncionCapacidad, GrupoPermiso, GrupoCapacidad, UsuarioGrupo, PermisoExcepcional, AuditoriaPermiso.
- 2 vistas SQL (`vista_capacidades_usuario`, `vista_grupos_usuario`).
- 5 funciones SQL nativas PostgreSQL: `usuario_tiene_permiso()`, `obtener_capacidades_usuario()`, `obtener_grupos_usuario()`, `verificar_permiso_y_auditar()`, **`obtener_menu_usuario()`**.
- Service layer (`UserManagementService`, 6 métodos, 450 ln).
- REST API: 6 serializers (550 ln) + 6 ViewSets (700 ln) + URLs router DRF.
- Endpoints clave: `/api/permisos/verificar/:id/capacidades/`, `/tiene-permiso/`, **`/menu/`**, `/grupos/`.
- Tests: 50+ casos REST API (800 ln).

**Pendiente:**
- Tests integración SQL, performance, carga (Calidad 80%).
- Documentación: 10 UCs detallados (UC-PERM-001…010), 32 diagramas UML, OpenAPI spec, guía frontend (Documentación 40%).
- Herramientas (0%): seed script, management commands (`seed_permisos`, `assign_admin_permisos`, `audit_permisos`, `export_permisos`, `import_permisos`), decorators (`@require_permission`), Permission Mixin, Django Admin.
- Operaciones (0%): Prometheus, Grafana, alertas, runbook.

### 4.2 Menú dinámico como pieza CORE — SÍ (PROVEN)

El menú dinámico aparece como capacidad central en tres puntos del GAP-PERM:
- Función SQL nativa: `obtener_menu_usuario()` (L34).
- Endpoint REST: `GET /api/permisos/verificar/:id/menu/` (L81, L390).
- UC-PERM-008: "Generar Menú Dinámico por Permisos" (L146).
- §4 "Menú Dinámico" en guía de integración frontend pendiente (L389–404, con cliente TS `getMenu(userId): Promise<MenuNode[]>`).

Conclusión PROVEN: el menú dinámico es funcionalidad CORE del sistema PERM, no add-on.

### 4.3 ¿PERM reemplaza o coexiste con RBAC original?

**Clasificación de evidencia: INFERRED.** El GAP-PERM no contiene la frase "reemplaza" ni "coexiste"; tampoco discute relación explícita con MOD_Access/RBAC_CORE.

**Razonamiento (INFERRED):**
1. El modelo PERM introduce ocho entidades (Funcion, Capacidad, FuncionCapacidad, GrupoPermiso, GrupoCapacidad, UsuarioGrupo, PermisoExcepcional, AuditoriaPermiso) — vocabulario distinto a CNST_005 (Role, DirectPermission, DataSegment, SoD-Rule).
2. `PermisoExcepcional` (permisos temporales) cumple semánticamente el rol de `DirectPermission` de MOD_Access (justificación + vencimiento — L53).
3. `AuditoriaPermiso` duplica responsabilidad del MOD_Audit canónico (UC-047 "Auditar cambios de permisos").
4. El modelo PERM no menciona los 18 roles funcionales (R001–R018) de CNST_005 ni las 3 reglas SoD; usa el concepto "GrupoPermiso" (genérico) en su lugar.

**Conclusión INFERRED:** PERM parece ser una **evolución/reemplazo parcial** del subcomponente RBAC_CORE de MOD_Access, no una capa coexistente. Sin embargo, la canonicidad de esta interpretación está pendiente de validación (no hay ADR que la fije; gap real para Phase 4 CONSTRAINTS o Phase 5 STRATEGY).

---

## 5. Gaps detectados respecto al modelo de 8 módulos

### 5.1 ¿Dónde encajaría MOD_Permissions?

**Interpretación INFERRED:** Si el sistema PERM se formaliza como módulo independiente (`MOD_Permissions`), absorbería:
- RBAC_CORE de MOD_Access (administración de roles → grupos de permisos).
- Subcomponente "permisos directos" (→ `PermisoExcepcional`).
- Auditoría específica de permisos (→ `AuditoriaPermiso`, hoy responsabilidad de MOD_Audit vía UC-047).

Quedaría en MOD_Access únicamente SEC_RULES (enforcement runtime). Esto sugiere que la decomposición correcta sería renombrar MOD_Access → MOD_Enforcement y separar MOD_Permissions.

### 5.2 ¿Dónde encajaría MOD_Call?

**No hay evidencia.** Ni REF-GLOBAL, ni ANL-RBAC, ni GAP-PERM mencionan `MOD_Call`. La cadena `callcentersite` aparece solo como nombre del proyecto Django en GAP-PERM (`api/callcentersite/...`), no como módulo funcional.

**Clasificación: SPECULATIVE.** No es propagable como decisión de arquitectura; requiere observable de origen.

### 5.3 Riesgos de divergencia

- **Doble auditoría:** MOD_Audit (canónico, transversal, CNST_008 inmutable) vs `AuditoriaPermiso` (específico al sistema PERM). Riesgo de fuente de verdad dividida.
- **Menú dinámico sin contraparte canónica:** REF-GLOBAL no menciona menú dinámico en ningún módulo; aparece solo en PERM como pieza CORE. Es funcionalidad nueva, no migración.
- **18 roles vs grupos genéricos:** CNST_005 fija catálogo cerrado (R001–R018); PERM usa `GrupoPermiso` configurable. Posible incompatibilidad con la restricción "18 roles funcionales máximo" (CNST_005).

---

## Trazabilidad

- §1, §2: REF-GLOBAL líneas 11–658 (transcripción literal de campos).
- §3: ANL-RBAC §6 líneas 421–502.
- §4.1: GAP-PERM §1 líneas 18–130 + §6 líneas 656–664.
- §4.2: GAP-PERM líneas 34, 81, 146, 389–404 (PROVEN).
- §4.3, §5: INFERRED — no hay claim textual literal en los tres docs; razonamiento explícito documentado.
