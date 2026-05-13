```yml
created_at: 2026-04-30 03:06:29
project: IACT-docs
work_package: 2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Auditoría SRP del modelo RBAC v5.3.0 + hallazgos asociados

## Contexto

Tras el bump a v5.3.0 (51 funciones), el ejecutor identificó violaciones
de Single Responsibility Principle (SRP) en varias funciones cuyo verbo
era `manage_*` o cuyo alcance cubría múltiples responsabilidades.
Además detectó violaciones del principio "no eliminar nada" (BR-009)
en funciones con verbo `delete_*`.

Esta auditoría documenta los hallazgos completos antes de la
implementación v5.4.0.

## Hallazgo 1 — Violaciones del principio "no eliminar nada"

| Función | Violación | Decisión |
|---------|-----------|----------|
| USR-003 `delete_users` | Nombre sugiere hard delete; descripción dice "Baja lógica" | Rename → `deactivate_users` |
| ALR-005 `delete_alerts` | Hard delete real; modelo no declara soft | Rename → `disable_alerts` (toggle on/off) |

**Causa raíz:** BR-009 Bajas Lógicas tiene alcance estrecho ("MOD_Users"
solamente). El principio se aplicaba parcialmente en la documentación,
incluso cuando otros módulos también requerían soft delete.

**Acción:** reescribir BR-009 con alcance global a todos los módulos.
Prohibir DELETE físico salvo excepciones declaradas explícitamente.

## Hallazgo 2 — Violaciones SRP por verbo `manage_*`

### 2.1 AUTH-001 `manage_sessions` (borderline)

**Problema:** "Gestiona sesiones activas del sistema" cubre ver propias +
cerrar propias + listar todas. Solape con AUTH-004 `view_active_sessions`.

**Decisión:** A2 — split semántico con renames preservando IDs:
- AUTH-001 `manage_sessions` → `view_own_sessions`
- AUTH-004 `view_active_sessions` → `view_all_active_sessions`

Distinción clara: scope propio (operador) vs scope sistema (admin).

### 2.2 ACC-005 `manage_separation_rules` (viola SRP)

**Problema:** una función cubre create + view + update + disable
de reglas SoD.

**Decisión:** B2 — split estricto:
- ACC-005 `manage_separation_rules` → `view_separation_rules`
- + ACC-011 `update_separation_rule` (NUEVA)
- + ACC-012 `disable_separation_rule` (NUEVA)

Justificación: aunque las 3 reglas SoD son fijas (SOD-001/002/003),
las operaciones de gobernanza sobre ellas (modificar parámetros,
desactivar temporalmente) son distintas de la consulta.

### 2.3 ALR-008 `manage_alert_subscriptions` (split desde el origen)

**Problema:** la función propuesta inicialmente (Cat E) cubría
subscribe + unsubscribe + configure_severity.

**Decisión:** C2 — split en 3 funciones nuevas:
- ALR-008 `subscribe_to_alert`
- ALR-009 `unsubscribe_from_alert`
- ALR-010 `configure_subscription_severity`

Justificación: consistencia metodológica con SRP aplicado a Logs.

## Hallazgo 3 — Violación SRP en MOD_Logs

### 3.1 LOG-001 `view_technical_logs` cubre 3 conceptos

**Problema:** una función cubre logs de aplicación + logs de ETL +
logs de infraestructura. ARQ-MOD-008 declara los 3 conceptos como
distintos en el alcance del módulo.

**Decisión:** L4-SRP — split semántico:

| ID | Función v5.4.0 | Responsabilidad única |
|----|---------------|------------------------|
| LOG-001 | `view_application_logs` (rename) | Logs de aplicación (errores 500, INFO/WARN/ERROR) |
| LOG-002 | `export_logs` (sin cambio) | Exportar paquete de logs |
| LOG-003 | `search_logs` (sin cambio) | Búsqueda full-text |
| LOG-004 | `view_etl_logs` (NUEVA) | Logs ejecución ETL (IVR→Analytics) |
| LOG-005 | `view_infrastructure_logs` (NUEVA) | Logs infraestructura (timeouts, up/down) |
| LOG-006 | `view_system_health` (NUEVA) | Health endpoints, estado servicios |
| LOG-007 | `view_technical_metrics` (NUEVA) | Métricas agregadas (CPU, latencia) |

**MOD_Logs: 3 → 7 funciones** (+4 nuevas, 1 rename)

### 3.2 UCs faltantes (gap análisis)

ARQ-MOD-008 declara 4 UCs implícitos. Solo 2 existen en source/:

| UC implícito | UC en source | Acción |
|--------------|--------------|--------|
| UC_080 logs aplicación | uc-log-01 ✓ | Re-mapear a LOG-001 (rename) |
| UC_081 health/estado | ❌ FALTA | **Crear uc-log-06** (LOG-006) |
| UC_082 paquete logs | uc-log-04 ✓ | Sin cambio |
| UC_083 métricas técnicas | ❌ FALTA | **Crear uc-log-07** (LOG-007) |

Adicionalmente:
- **Crear uc-log-05** infraestructura (LOG-005) — gap previamente no detectado.
- Re-mapear uc-log-02 ETL de LOG-001 (instancia) a LOG-004 (función propia).

## Hallazgo 4 — Falsos positivos descartados

Se evaluaron y descartaron como **NO violación SRP** las siguientes:

| Función | Aparente violación | Justificación de descarte |
|---------|---------------------|----------------------------|
| RPT-001 `view_reports` (instancias múltiples) | Cubre uc-rpt-08/12/13/14 (filtrado por scope) | Filtros UI son parámetros, no responsabilidades. Datos del MISMO dominio. |
| USR-004/005/009 list/search/view | 3 ops de lectura | Operativamente distintas (paginado vs criterio vs detalle individual) |
| AUD-001..004 view/search/export/generate | Múltiples ops sobre audit log | Cada una con responsabilidad atómica clara |
| ACC-001 vs ACC-004 (assign_*) | "Asignar" en ambos | Targets distintos (function vs group) |
| Multiple `view_*` | Aparente overlap | Cada uno consulta entidad distinta |

## Hallazgo 5 — Anti-patrón Larman en MOD_Reports

### 5.1 UCs por formato (uc-rpt-04/05/06)

**Problema:** uc-rpt-04 (CSV) + uc-rpt-05 (Excel) + uc-rpt-06 (PDF) son
3 UCs separados por formato. Viola principio Larman documentado en
temp-holding:

> "Un UC por tipo de reporte, NO por formato. Correcto: UC-601
> Generar Reporte OSHA — puede exportar PDF/Excel/Word. Incorrecto:
> UC-601a en PDF, UC-601b en Excel, UC-601c en Word
> (innecesariamente fragmentado)."

**Decisión:** consolidar uc-rpt-04/05/06 → uc-rpt-04 "Exportar Reporte"
con flujos alternativos por formato. **Eliminar** uc-rpt-05 y uc-rpt-06.

### 5.2 Mantener funciones RBAC separadas (Opción A)

A nivel RBAC, las funciones RPT-004 export_csv / RPT-005 export_excel /
RPT-006 export_pdf SÍ se mantienen separadas. Justificación:
- Cumplen SRP estricto (un permiso por formato).
- Permiten SoD operacional ("Bob puede CSV pero no PDF").
- CSV/Excel/PDF tienen perfiles de recursos distintos (CSV ligero,
  PDF render-heavy) — separar es correcto.

**Resolución:** Larman aplica a UCs (capa business), SRP aplica a
funciones RBAC (capa permisos). Son ortogonales.

## Hallazgo 6 — Límites arbitrarios de exportación

### 6.1 CNST-020 actual viola "principio de no acoplamiento"

**Problema 1 — Tabla arbitraria por formato:**

| Formato | Max registros | Max/día | Timeout |
|---------|---------------|---------|---------|
| CSV | 100,000 | 10 | 60s |
| Excel | 50,000 | 5 | 90s |
| PDF | 10,000 | 3 | 120s |

El ejecutor identificó: "el problema de la cantidad de registros no
está en los formatos, un reporte ya sea Excel/PDF/CSV puede tener más
de 100K registros. Lo que importa es que el sistema tenga recursos
para la descarga sin afectar otros recursos."

**Problema 2 — Acoplamiento tecnológico:** CNST-020 declara
"Mecanismo: Celery + Redis broker", forzando una tecnología en la
spec normativa cuando debería estar en ADR de implementación.

**Decisión:** reescribir CNST-020 abstracto:
- Eliminar tabla "100K/50K/10K por formato" (arbitrario sin medición empírica).
- Eliminar quota diaria por formato (10/5/3) — también arbitrario.
- Reemplazar con principios:
  - Async para >umbral (CNST-019).
  - Aislamiento de recursos (worker pool dedicado).
  - Throttling anti-abuse genérico (concurrent + daily, sin distinguir formato).
  - Cifras concretas en ADR de implementación, revisable según uso real.
- Tecnología de cola declarada en ADR, NO en CNST.

### 6.2 Inconsistencias internas en source/

| Documento | Decía | Estado |
|-----------|-------|--------|
| CNST-020 | 100K/50K/10K por formato + max/día/usuario | A reescribir (eliminar cifras arbitrarias) |
| BR-011 | "100,000 registros máximo por exportación" (genérico) | A reescribir alineando con CNST-019/020 |
| uc-perm-10 | "Excel <10K" | A corregir (cita obsoleta) |
| uc-aud-03 | "100K (CNST_017)" | Verificar contexto (audit log puede tener su propio límite) |

## Hallazgo 7 — Tipos de reporte faltantes (gap)

ARQ-MOD-008 + temp-holding histórico mencionan tipos de reporte
NO cubiertos por UCs en source/:

| UC nuevo | Domain | Justificación |
|----------|--------|---------------|
| uc-rpt-15 Reporte Transferencias por Centro | Transferencias entre centros | UC-019 histórico (temp-holding); domain distinto a llamadas |
| uc-rpt-16 Reporte Menús IVR | Análisis de menús problemáticos | Mencionado en frontend/analisis_api_frontend |
| uc-rpt-17 Reporte Clientes Únicos | Métricas de cliente (recurrencia) | Mencionado en frontend/analisis_api_frontend |

Tipos cubiertos por UCs existentes (NO crear):
- Trimestral / mensual / anual → uc-rpt-03 históricos (rango + agregación)
- Métricas agentes / colas / campañas → uc-rpt-12/13/14

## Hallazgo 8 — Cat B+C+D+F resueltos previamente

Como referencia, los 9 UCs corregidos en commit fd9ef31:

| UC | ID antes → después | Función |
|----|-------------------|---------|
| uc-usr-02 | USR-002/005/006 → USR-009/004/005 | view, list, search users |
| uc-usr-03 | USR-003/007/008/009 → USR-002/006/007/008 | update, block, unblock, reactivate |
| uc-usr-04 | USR-004 → USR-003 | delete (será deactivate) |
| uc-alr-01 | ALR-001 → ALR-002 | configure_alerts |
| uc-alr-02 | ALR-002 → ALR-001 | view_alerts |
| uc-alr-04 | ALR-004 → ALR-006 | view_alert_history |
| uc-acc-08 | ACC-001 → ACC-008 | grant_exceptional_permission |
| uc-auth-03 | AUT-003 → AUTH-003 | reset_password |
| uc-auth-05 | AUT-001/002/004 → AUTH-001/002/004 | manage→view sessions |

## Resumen de cambios v5.3.0 → v5.4.0

| Categoría | Cantidad | Detalle |
|-----------|----------|---------|
| Renames de funciones | 6 | USR-003, ALR-005, LOG-001, AUTH-001, AUTH-004, ACC-005 |
| Funciones nuevas | 12 | ALR-007/008/009/010, ACC-011/012, LOG-004/005/006/007 + 0 RPT |
| Funciones eliminadas | 0 | Principio "no eliminar nada" |
| UCs nuevos | 6 | uc-log-05/06/07 + uc-rpt-15/16/17 |
| UCs consolidados | 3→1 | uc-rpt-04/05/06 → uc-rpt-04 |
| UCs re-mapeados | 4 | uc-log-02, uc-perm-10, uc-alr-03, uc-alr-05 |
| Constraints reescritas | 3 | BR-009 (alcance global), BR-011, CNST-020 |
| Constraints actualizadas | 1 | CNST-019 (desacoplar Celery) |

**Total funciones v5.4.0:** 51 + 12 = **63 funciones**.
