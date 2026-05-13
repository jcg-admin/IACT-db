```yml
created_at: 2026-04-29 03:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (formalizacion arquitectonica)
author: NestorMonroy
status: Aprobado (decisiones D-RBAC tomadas 2026-04-29)
version: 1.0.0
```

# Formalizacion del RBAC IACT

## Premisa

Tras decision arquitectonica aprobada (Hipotesis 1 — Coexistencia
ACC ↔ PERM), el siguiente paso es **formalizar el modelo RBAC IACT**:
consolidar el modelo legacy `MODELO_RBAC_IACT_v5_2_1` (42 funciones,
10 grupos predefinidos, 3 SoD, permisos temporales) con la
**implementacion PERM granular** del backend (8 modelos Django, 5
funciones SQL, menu dinamico) en un solo modelo coherente con
vocabulario unificado.

## Objetivo

Producir el modelo formal que sera la **fuente de verdad** del RBAC
IACT, integrando:

1. **Filosofia** — funciones describen acciones, no titulos.
2. **Vocabulario unificado** — diccionario de terminos canonico.
3. **Modelo de datos formal** — 7+ tablas backend.
4. **Catalogo cerrado** (10 grupos predefinidos AGR-001..010) +
   **catalogo abierto** (grupos creables admin).
5. **3 reglas SoD** atomicas declarativas.
6. **Permisos temporales** con justificacion + vencimiento.
7. **Menu dinamico** runtime basado en capacidades del usuario.
8. **Auditoria** runtime + admin.
9. **Mapeo UCs** (ACC funcional + PERM tecnico).
10. **CNSTs aplicables** del rebuild SRP.

## 1. Filosofia del Modelo

> **Los nombres describen QUE HACE, NO QUIEN es.**

| Anti-patron (Con Pretensiones) | Patron correcto (Sin Pretensiones) |
|---------------------------------|-----------------------------------|
| `USERS_FULL_MANAGER` (cargo) | `manage_users` (accion) |
| `SYSTEM_ADMIN` (jerarquia) | `view_audit_log + manage_sessions` (capabilities) |
| `REPORT_VIEWER` (rol) | `view_reports + filter_reports` (capabilities) |

Origen: `MODELO_RBAC_IACT_v5_2_1.md` § 1.2.

## 2. Vocabulario unificado (CANONICO)

Reconciliacion del vocabulario entre modelo legacy y PERM granular.
**Esta tabla es la fuente unica de verdad** para todo el rebuild.

| Concepto | Termino canonico | Termino legacy v5.2.1 | Termino PERM backend | Definicion |
|----------|------------------|----------------------|----------------------|------------|
| Capacidad atomica | **Funcion** | Funcion (`functions`) | Capacidad (`Capacidad`) | Una accion concreta verificable (verbo + recurso). Ej: `view_audit_log`. |
| Conjunto agrupado de capacidades | **Grupo** | Grupo (`function_groups`) | GrupoPermiso (`GrupoPermiso`) | Set de funciones asignables como bloque. Puede ser predefinido (AGR-001..010) o creable. |
| Modelo de asignacion grupo → funciones | **Membresia** | `function_group_membership` | `GrupoCapacidad` | Tabla M2M que define que funciones contiene cada grupo. |
| Asignacion grupo → usuario | **Asignacion de Grupo** | `user_function_group_assignments` | `UsuarioGrupo` | Asocia un usuario con uno o mas grupos. |
| Asignacion directa funcion → usuario | **Asignacion Directa** | `user_function_assignments` | (parte de `PermisoExcepcional`) | Asignacion de capabilities individuales a un usuario fuera de grupos. |
| Override one-off temporal | **Permiso Excepcional / Temporal** | (asignacion directa con `expires_at`) | `PermisoExcepcional` | Capabilities con justificacion + vencimiento <= 6 meses. |
| Restriccion de mutual exclusion | **Regla SoD** | `function_separation_rules` | (sin equivalente PERM, hereda de v5.2.1) | Prohibicion de tener simultaneamente funciones de grupo A y grupo B. |
| Validacion runtime | **Verificacion de Permiso** | `usuario_tiene_permiso()` SQL | `verificar_permiso_y_auditar()` SQL | Funcion SQL nativa que evalua si un usuario tiene una capability en runtime. |
| UI adaptativa | **Menu Dinamico** | (no existia en v5.2.1) | `obtener_menu_usuario()` SQL | Estructura jerarquica calculada en runtime segun las capabilities del usuario. |
| Registro de cada acceso | **Auditoria runtime** | (no existia formalmente) | `AuditoriaPermiso` | Registro append-only de cada verificacion de permiso. |

**Decision documentar en `glosario.rst`** del rebuild base_cognitiva
(W-1 cross-WP debt — base_cognitiva ya cerrado v2, requiere nueva
iteracion v3 para integrar este vocabulario).

## 3. Modelo de Datos formal

### 3.1 Diagrama conceptual (textual)

```
┌─────────────────────┐                ┌──────────────────────┐
│      Usuario        │                │       Funcion        │
│ (django auth user)  │                │  (capability atomic) │
└──────────┬──────────┘                └──────────┬───────────┘
           │ N:M                                  │ N:M
           ▼                                      ▼
┌─────────────────────────┐              ┌──────────────────────┐
│ Asignacion de Grupo     │              │ Membresia de Grupo   │
│ (UsuarioGrupo)          │◄────N:M──────┤ (function_group_     │
└──────────┬──────────────┘              │  membership)         │
           │ N:1                          └──────────┬───────────┘
           ▼                                         │ N:1
┌─────────────────────────┐                          ▼
│         Grupo           │              ┌──────────────────────┐
│  (function_groups +     │◄─────────────┤ Categoria del Grupo  │
│   GrupoPermiso)         │              │ - predefinido (AGR-) │
│                         │              │ - creable (admin)    │
└─────────────────────────┘              └──────────────────────┘

         ┌──────────────────────┐
         │  Asignacion Directa  │  ← Capability asignada al usuario
         │  (PermisoExcepcional)│    sin pasar por grupo (con
         │  - justificacion     │    justificacion + vencimiento)
         │  - expires_at        │
         └──────────────────────┘

         ┌──────────────────────┐
         │      Regla SoD       │  ← Prohibicion: si Usuario tiene
         │  - grupo_a, grupo_b  │    funcion de A, no puede tener
         │  - razon             │    funcion de B
         └──────────────────────┘

         ┌──────────────────────┐
         │   AuditoriaPermiso   │  ← Append-only: registro de cada
         │  - usuario, capability│    verificacion runtime
         │  - resultado, ts     │
         └──────────────────────┘
```

### 3.2 Tablas backend (consolidado)

| Tabla | Origen | Proposito |
|-------|--------|-----------|
| `functions` | v5.2.1 | Catalogo de las 42 funciones atomicas |
| `function_groups` | v5.2.1 | Catalogo de grupos (10 predefinidos + creables) |
| `function_group_membership` | v5.2.1 | M2M funciones-grupos |
| `user_function_assignments` | v5.2.1 | Asignaciones directas (legacy) |
| `user_function_group_assignments` | v5.2.1 | Asignaciones de grupos a usuarios |
| `function_separation_rules` | v5.2.1 | 3 reglas SoD |
| `function_separation_rule_details` | v5.2.1 | Detalle SoD (grupos A vs B) |
| `Capacidad` (Django model) | PERM backend | Vista granular de funcion |
| `PermisoExcepcional` | PERM backend | Override one-off con justificacion + vencimiento |
| `AuditoriaPermiso` | PERM backend | Audit log runtime de cada verificacion |
| `UserFunctionAssignment` (Django) | v5.2.1 (UC_ACC_08) | Asignaciones temporales con vencimiento |

**Nota:** `Capacidad` ≡ `Funcion` en el modelo legacy (vista distinta
del mismo concepto). Decision Phase 2: usar **un solo nombre** en
codigo y documentacion (`Funcion`).

## 4. Catalogo de Funciones (42 atomicas)

Distribucion por modulo (de `MODELO_RBAC_IACT_v5_2_1.md` § 3):

| Modulo | Codigo prefix | Cantidad | Ejemplos |
|--------|---------------|----------|----------|
| MOD_Auth | AUTH-NNN | 4 | manage_sessions, view_active_sessions |
| MOD_Users | USR-NNN | 10 | create_users, modify_users, delete_users, list_users, view_users, unblock_users, configure_security_questions |
| MOD_Access | ACC-NNN | 6 | assign_functions, revoke_functions, query_permissions, manage_sod, manage_segments |
| MOD_Reports | RPT-NNN | 8 | view_reports, view_dashboard, view_kpis, view_charts, filter_reports, export_csv, export_excel, export_pdf |
| MOD_Alerts | ALR-NNN | 6 | view_alerts, configure_alerts, manage_subscriptions, view_alert_history |
| MOD_Pipeline | PIP-NNN | 4 | view_pipeline_status, view_pipeline_errors, view_data_availability, request_pipeline_retry |
| MOD_Audit | AUD-NNN | 4 | view_audit_log, search_audit_log, export_audit_log, generate_compliance_report |
| MOD_Logs | LOG-NNN | 2 | view_system_logs, search_logs |
| **TOTAL (estado actual)** | | **44** (v5.1.1) o **42** (v5.2.1 corregido) | catalogo evolutivo |

**Catalogo evolutivo:** el numero exacto puede variar (v5.1.1 = 44,
v5.2.1 = 42 tras eliminar 2 funciones redundantes). El rebuild
Phase 2 debe inventariar el set vigente.

## 5. Catalogo de Grupos predefinidos (AGR-001..010)

10 grupos del modelo legacy, todos `_group` suffix en ingles
(v5.2.1):

| ID | Nombre | # funciones | Actor tipico | Descripcion |
|----|--------|-------------|--------------|-------------|
| AGR-001 | basic_operator_group | 6 | Operador | Visualizacion basica |
| AGR-002 | report_viewer_group | 8 | Analista | Analisis sin exportar |
| AGR-003 | quality_supervisor_group | 11 | Supervisor | Analisis + filtros + alertas |
| AGR-004 | data_exporter_group | 14 | Data Analyst | Exportacion autorizada |
| AGR-005 | alert_manager_group | 6 | Gestor Alertas | Gestion completa alertas |
| AGR-006 | user_admin_group | 9 | Admin Usuarios | Gestion identidades |
| AGR-007 | permission_admin_group | 5 | Admin Permisos | Gestion RBAC |
| AGR-008 | auditor_group | 4 | Auditor | Solo auditoria (SoD) |
| AGR-009 | pipeline_admin_group | 4 | Admin Pipeline | Supervision ETL |
| AGR-010 | system_admin_group | 6 | Sysadmin | Administracion completa |

**Nota PERM:** ademas de estos 10 predefinidos, admin puede crear
grupos custom via UC_PERM_05 (Crear Grupo de Permisos). Los
predefinidos quedan como "system groups" no editables.

## 6. Reglas SoD (3 atomicas)

Origen: `MODELO_RBAC_IACT_v5_2_1.md` § 5.

| ID | Nombre v5.2.1 | Grupo A | Grupo B | Razon |
|----|---------------|---------|---------|-------|
| **SOD-001** | pipeline_audit_separation | Pipeline (PIP-001..004) | Auditoria (AUD-001..004) | Quien opera ETL no debe auditarlo |
| **SOD-002** | user_audit_separation | Gestion Users criticas (USR-001/003/004/007) | Auditoria parcial (AUD-001..003) | Quien gestiona usuarios no debe auditar sus acciones |
| **SOD-003** | access_audit_separation | Gestion Acceso (ACC-001/002/004) | Auditoria (AUD-001/002) | Quien gestiona acceso no debe auditar cambios |

**Enforcement:** signal `pre_save` de `UserGroup` valida en runtime
y rechaza con `ValidationError` si la asignacion crea conflicto.
Vinculo a CNST_030 (SoD Reglas Atomicas).

## 7. Permisos Temporales

Origen: v5.2.1 § 6 + PERM `PermisoExcepcional`.

**Restricciones:**
- Vigencia maxima: **6 meses** (180 dias).
- Justificacion obligatoria: minimo **20 caracteres**.
- Revocacion automatica al vencer (cron diario).
- Sin auto-renovacion: cada renovacion = nueva justificacion + nueva
  aprobacion.
- Validacion SoD aplica tambien a permisos temporales.
- Cada uso del permiso temporal genera registro en AuditoriaPermiso.

**Mapeo a UCs:**
- UC_ACC_08 Permiso Temporal (vista admin del catalogo cerrado)
- UC_PERM_03 Conceder Permiso Excepcional (vista admin granular)
- UC_PERM_04 Revocar Permiso Excepcional

**CNST canonico:** CNST_031 (Permisos Temporales Maximo 6 Meses).

## 8. Menu Dinamico (CORE)

Origen: PERM backend, funcion SQL `obtener_menu_usuario()`.

**Algoritmo:**

```
1. Obtener todas las capacidades del usuario:
   - Via grupos asignados (UsuarioGrupo → GrupoCapacidad → Capacidad)
   - Via permisos excepcionales vigentes (PermisoExcepcional)
2. Para cada capacidad con formato "dominio.subdominio.funcion.accion":
   - Agrupar por dominio → subdominio → funcion → [acciones]
3. Construir estructura jerarquica tipo arbol
4. Retornar JSON navegable
```

**Endpoint:** `GET /api/permisos/verificar/<user_id>/menu/`.

**Consumidor:** Frontend invoca al renderizar navegacion (cada
sesion + on permission change).

**Mapeo a UC:** UC_PERM_08 Generar Menu Dinamico.

**Sin CNST canonico actual** — requiere nuevo CNST en proxima
iteracion del rebuild restricciones (deuda W-X).

## 9. Auditoria

**Dual:** runtime granular + admin general.

| Capa | Tabla | UC | Foco |
|------|-------|----|----|
| Runtime granular | `AuditoriaPermiso` | UC_PERM_09 Auditar Acceso | Cada verificacion de capability |
| Admin permisos | (vista de `AuditoriaPermiso`) | UC_PERM_10 Consultar Auditoria de Permisos | Vista admin de logs PERM |
| Cambios de acceso | `AuditLog` | UC_ACC_09 Auditar Cambios Acceso | Asignaciones/revocaciones de funciones/grupos |
| Sistema general | `AuditLog` | UC_AUD_01..04 | Todos los eventos sensibles del sistema |

**CNST canonico:** CNST_025 (Auditoria Inmutable Append-Only),
CNST_026 (PII Prohibida en Logs).

**Decision pendiente D-RBAC-3:** ¿`AuditoriaPermiso` y `AuditLog`
son tablas separadas o unificadas? Recomendacion: tablas separadas
con foreign key a entidad raiz (Usuario), pero **misma politica
inmutable**.

## 10. Mapeo UCs ↔ Modelo RBAC

### Vista funcional (MOD_Access — admin no-tech)

| UC | Operacion en modelo |
|----|---------------------|
| UC_ACC_01 Asignar Funciones | INSERT en `user_function_assignments` |
| UC_ACC_02 Revocar Funciones | DELETE de `user_function_assignments` |
| UC_ACC_03 Consultar Permisos | SELECT a vista `vista_capacidades_usuario` |
| UC_ACC_04 Asignar Agrupador | INSERT en `user_function_group_assignments` con grupo predefinido AGR-NNN |
| UC_ACC_05 Gestionar SoD | CRUD sobre `function_separation_rules` |
| UC_ACC_06 Gestionar Segmentos | (modelo de datos separado, ortogonal al RBAC) |
| UC_ACC_07 Asignar Segmento | (idem) |
| UC_ACC_08 Permiso Temporal | INSERT en `user_function_assignments` con `expires_at` |
| UC_ACC_09 Auditar Cambios Acceso | SELECT a `AuditLog` filtrado por entidad |

### Vista tecnica (MOD_Permissions — admin tech / runtime)

| UC | Operacion en modelo |
|----|---------------------|
| UC_PERM_01 Asignar Grupo a Usuario | INSERT en `UsuarioGrupo` con grupo (predefinido o custom) |
| UC_PERM_02 Revocar Grupo | DELETE de `UsuarioGrupo` |
| UC_PERM_03 Conceder Permiso Excepcional | INSERT en `PermisoExcepcional` con justificacion + vencimiento |
| UC_PERM_04 Revocar Permiso Excepcional | UPDATE `PermisoExcepcional` (revocado=true) |
| UC_PERM_05 Crear Grupo de Permisos | INSERT en `function_groups` con flag `is_custom=true` |
| UC_PERM_06 Asignar Capacidades a Grupo | INSERT en `function_group_membership` |
| UC_PERM_07 Verificar Permiso de Usuario | CALL `usuario_tiene_permiso(user_id, capability_code)` |
| UC_PERM_08 Generar Menu Dinamico | CALL `obtener_menu_usuario(user_id)` |
| UC_PERM_09 Auditar Acceso | INSERT en `AuditoriaPermiso` (automatico tras `verificar_permiso_y_auditar`) |
| UC_PERM_10 Consultar Auditoria de Permisos | SELECT a `AuditoriaPermiso` con filtros |

## 11. CNSTs canonicos aplicables (rebuild SRP-31)

| CNST | Descripcion | Aplicable a |
|------|-------------|-------------|
| CNST_025 | Auditoria Inmutable Append-Only | AuditoriaPermiso, AuditLog |
| CNST_026 | PII Prohibida en Logs | logs SQL, JSON, audit |
| CNST_029 | RBAC Modelo Plano (sin jerarquia) | function_groups, GrupoPermiso |
| CNST_030 | Reglas SoD Atomicas Declarativas | function_separation_rules |
| CNST_031 | Permisos Temporales Maximo 6 Meses | PermisoExcepcional, user_function_assignments |

**CNSTs adicionales necesarios (deuda):**

- **CNST-NEW-1** Menu Dinamico Obligatorio — el frontend DEBE invocar
  `obtener_menu_usuario()` en cada renderizacion de navegacion. Sin
  este CNST, RBAC no tiene efecto UX.
- **CNST-NEW-2** Vocabulario Unificado — funcion ≡ capacidad,
  grupo ≡ grupopermiso. Codigo y docs deben usar UN solo termino.

## 12. Decisiones D-RBAC pendientes

- **D-RBAC-1**: ¿`Capacidad` (PERM) y `Funcion` (v5.2.1) se renombran
  a UN solo termino canonico (sugerido: `Funcion`)?
- **D-RBAC-2**: ¿`UsuarioGrupo` (PERM) y `user_function_group_
  assignments` (v5.2.1) son LA misma tabla con dos nombres? Sugerido:
  unificar en migracion.
- **D-RBAC-3**: ¿`AuditoriaPermiso` y `AuditLog` separadas o
  unificadas? Sugerido: separadas con misma politica inmutable.
- **D-RBAC-4**: ¿Los 10 grupos predefinidos AGR-001..010 son
  inmutables (system groups) o pueden modificarse via UC_PERM_05?
  Sugerido: inmutables (system) + posibilidad de crear custom adicional.
- **D-RBAC-5**: ¿Crear CNST-NEW-1 (menu dinamico obligatorio)?
- **D-RBAC-6**: ¿Crear CNST-NEW-2 (vocabulario unificado) o vive en
  `glosario.rst` como convencion?
- **D-RBAC-7**: ¿`function_separation_rules` aplican tambien a grupos
  custom creados por admin (UC_PERM_05)? Sugerido: si.
- **D-RBAC-8**: ¿Migracion de modelos: `Capacidad` → `Funcion`
  reemplazo o coexisten temporalmente?

## 13. Tareas para Phase 2 (formalizacion en source/)

| # | Tarea | Destino |
|---|-------|---------|
| T-RBAC-1 | Crear `source/base_cognitiva/glosario.rst` con vocabulario unificado (10 terminos canonicos) | base_cognitiva |
| T-RBAC-2 | Crear `source/normativa/restricciones/CNST-NEW-1_Menu_Dinamico_Obligatorio.rst` | restricciones |
| T-RBAC-3 | Crear `source/normativa/restricciones/CNST-NEW-2_Vocabulario_RBAC_Unificado.rst` (opcional) | restricciones |
| T-RBAC-4 | Crear `source/normativa/gobernanza/ADR-GOB-008_RBAC_Coexistencia_ACC_PERM.rst` | gobernanza |
| T-RBAC-5 | Crear `source/arquitectura_tecnica/rbac/MODELO_RBAC_IACT.rst` (re-autoria del v5.2.1 + PERM unificado) | arquitectura_tecnica |
| T-RBAC-6 | Crear `source/arquitectura_tecnica/rbac/Catalogo_Funciones.rst` (las 42 atomicas) | arquitectura_tecnica |
| T-RBAC-7 | Crear `source/arquitectura_tecnica/rbac/Grupos_Predefinidos.rst` (AGR-001..010) | arquitectura_tecnica |
| T-RBAC-8 | Crear `source/arquitectura_tecnica/rbac/Reglas_SoD.rst` (3 reglas atomicas) | arquitectura_tecnica |
| T-RBAC-9 | Crear `source/arquitectura_tecnica/rbac/Modelo_Datos.rst` (7 tablas + diagrama UML) | arquitectura_tecnica |
| T-RBAC-10 | Generar UCs de MOD_Access (9) y MOD_Permissions (10) en `source/requisitos/casos_uso/` | requisitos |

## 14. Cross-WP impacto

| WP | Impacto |
|----|---------|
| WP base_cognitiva (cerrado v2) | Requiere v3 para integrar vocabulario unificado del § 2 |
| WP normativa-restricciones (cerrado v2) | Requiere v3 para CNST-NEW-1 (Menu Dinamico) y CNST-NEW-2 (Vocabulario) |
| WP normativa-gobernanza (cerrado) | Requiere ADR-GOB-008 (T-RBAC-4) |
| WP arquitectura-tecnica (#7 pendiente) | Recibe T-RBAC-5 a T-RBAC-9 (5 documentos del modelo formal) |
| WP requisitos (este — #6 en curso) | Recibe T-RBAC-10 (generar UCs ACC + PERM) |

## 15. Estado actual del catalogo (NO decisivo)

El catalogo evoluciona con discovery. **Estado actual**:

- **9 modulos funcionales** (Auth, Users, Access, Permissions,
  Reports, Alerts, Pipeline, Audit, Logs).
- **2 vistas del RBAC**: ACC (funcional) y PERM (tecnico).
- **42 funciones atomicas** (catalogo cerrado v5.2.1, puede crecer).
- **10 grupos predefinidos** AGR-001..010 + grupos custom creables
  via UC_PERM_05.
- **3 reglas SoD** atomicas (catalogo cerrado v5.2.1).
- **Permisos temporales** maximo 6 meses con justificacion >= 20 ch.

Este conteo se documenta como **referencia**, no como compromiso
inmutable.
