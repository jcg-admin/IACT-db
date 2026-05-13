```yml
created_at: 2026-04-30 00:50:00
project: IACT-docs
work_package: 2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Cross-check Funciones vs UCs — Auditoría completa

## Metodología

Para cada UC vivo en ``source/requisitos/casos-uso/``, extraer
el campo "Funcion RBAC" declarado en cabecera y validar contra
el catálogo de 42 funciones del modelo v5.2.1.

## Resultado: drifts críticos en 4 módulos

### Modulo MOD_Reports — DRIFT MAYOR (+6 UCs huérfanos)

8 funciones reales vs **14 UCs** vivos:

| UC | Función citada | ¿Existe en modelo? | Análisis |
|----|----------------|:------------------:|----------|
| uc-rpt-01-ver-dashboard | RPT-001 | ✓ view_reports OK |
| uc-rpt-02-ver-metricas-tiempo-real | RPT-002 | ✓ view_dashboard OK |
| uc-rpt-03-ver-reportes-historicos | RPT-003 | ✓ filter_reports OK |
| uc-rpt-04-exportar-csv | RPT-004 | ✓ export_csv OK |
| uc-rpt-05-exportar-excel | RPT-005 | ✓ export_excel OK |
| uc-rpt-06-exportar-pdf | RPT-006 | ✓ export_pdf OK |
| uc-rpt-07-programar-reporte | RPT-007 | ✓ pero modelo lo declara como ``view_kpis`` | **MISMATCH** |
| uc-rpt-08-ver-reportes-programados | RPT-008 | ✓ pero modelo lo declara como ``view_charts`` | **MISMATCH** |
| **uc-rpt-09-configurar-filtros** | **RPT-009** | ❌ NO EXISTE | DRIFT |
| **uc-rpt-10-guardar-vista** | **RPT-010** | ❌ NO EXISTE | DRIFT |
| **uc-rpt-11-compartir-reporte** | **RPT-011** | ❌ NO EXISTE | DRIFT |
| **uc-rpt-12-ver-reporte-agentes** | **RPT-012** | ❌ NO EXISTE | DRIFT |
| **uc-rpt-13-ver-reporte-colas** | **RPT-013** | ❌ NO EXISTE | DRIFT |
| **uc-rpt-14-ver-reporte-campanas** | **RPT-014** | ❌ NO EXISTE | DRIFT |

**Hallazgo crítico:** modelo declara RPT-007=view_kpis,
RPT-008=view_charts. Pero los UCs uc-rpt-07/08 citan los
mismos IDs con semántica DIFERENTE (programar/ver-programados).
**Doble drift.**

### Modulo MOD_Logs — DRIFT (+2 UCs huérfanos)

2 funciones reales vs **4 UCs** vivos:

| UC | Función citada | ¿Existe? | Análisis |
|----|----------------|:--------:|----------|
| uc-log-01-consultar-logs-sistema | LOG-001 | ✓ view_technical_logs OK |
| uc-log-02-consultar-logs-etl | LOG-002 | ✓ pero modelo lo declara como ``export_logs`` | **MISMATCH** |
| **uc-log-03-buscar-logs** | **LOG-003** | ❌ NO EXISTE | DRIFT |
| **uc-log-04-exportar-logs** | **LOG-004** | ❌ NO EXISTE | DRIFT |

### Modulo MOD_Auth — UCs sin función RBAC declarada

4 funciones reales, 5 UCs, **5 UCs sin "Función RBAC"
declarada**:

| UC | Función esperada |
|----|------------------|
| uc-auth-01-iniciar-sesion | (sin función — login es público) |
| uc-auth-02-cerrar-sesion | (sin función — logout es del usuario) |
| uc-auth-03-recuperar-contrasena | AUTH-003 reset_password (admin) |
| uc-auth-04-cambiar-contrasena | (sin función — usuario sobre sí mismo) |
| uc-auth-05-gestionar-sesiones | AUTH-001 manage_sessions (admin) |

**Análisis:** la mayoría de UC_AUTH son operaciones del usuario
sobre sí mismo (sin permisos especiales). Solo UC-03 (admin
resetea password de otro) y UC-05 (admin gestiona sesiones)
requieren función. Los UCs no citaron función intencionalmente.
**No es drift — es patrón válido pero subdocumentado.**

### Modulo permissions (vista PERM, ADR-GOB-008) — UCs sin función declarada

10 UCs, todos sin "Función RBAC" declarada (NONE):

| UC | Función esperada |
|----|------------------|
| uc-perm-01-asignar-grupo-a-usuario | ACC-004 (assign_function_groups) |
| uc-perm-02-revocar-grupo-a-usuario | (variante de assign — falta función "revoke_function_group") |
| uc-perm-03-conceder-permiso-excepcional | (función nueva: grant_exceptional) |
| uc-perm-04-revocar-permiso-excepcional | (función nueva: revoke_exceptional) |
| uc-perm-05-crear-grupo-permisos | (función nueva: create_function_group) |
| uc-perm-06-asignar-funciones-grupo | (función nueva: assign_functions_to_group) |
| uc-perm-07-verificar-permiso-usuario | ACC-003 (view_assignments) |
| uc-perm-08-generar-menu-dinamico | CNST-032 (función SQL, no RBAC) |
| uc-perm-09-auditar-acceso | AUD-001 (view_audit_log) |
| uc-perm-10-consultar-auditoria-permisos | AUD-002 (search_audit_log) |

**Análisis:** UC_PERM es la vista técnica/admin del RBAC.
Necesita ~5 funciones nuevas para sustentar las operaciones
de admin tech (crear grupo, gestionar permisos excepcionales,
asignar funciones a grupos, etc.). **DRIFT — funciones admin
faltantes.**

### Módulos OK ✓

- **MOD_Pipeline:** 4 funciones, 4 UCs, mapeo 1:1 ✓
- **MOD_Audit:** 4 funciones, 4 UCs, mapeo 1:1 ✓
- **MOD_Alerts:** 6 funciones, 5 UCs (1 función sin UC — ALR-006 view_alert_history sin UC propio; OK como sub-acción)
- **MOD_Users:** 9 funciones, 4 UCs (4 UCs CRUD cubren 9 funciones; OK conceptualmente)
- **MOD_Access:** 5 funciones, 7 UCs (post-Z.1.C: uc-acc-08 reusa ACC-001 — OK)

## Síntesis de drifts

| Drift | Severidad | Acción candidata |
|-------|-----------|------------------|
| RPT-009..014 (6 UCs huérfanos) | MAJOR | Decision A/B/C |
| RPT-007/008 mismatch semántico | MAJOR | Reescribir UCs o renombrar funciones |
| LOG-003/004 (2 UCs huérfanos) | MAJOR | Decision A/B/C |
| LOG-002 mismatch (export vs consulta) | MAJOR | Reescribir UC |
| UC_PERM sin funciones backing | MAJOR | Agregar ~5 funciones admin |
| UC_AUTH sin funciones declaradas | MINOR | Documentar patrón |

## Decisiones propuestas (por drift)

### MOD_Reports — Recomendación

Aplicar **lente Camino C** (mismo razonamiento que segmentos):

**Distinción clave:**
- Función RBAC = QUÉ puede hacer el usuario (acción).
- Filtro/vista = SOBRE QUÉ DATOS aplica esa acción.

**Análisis UC por UC:**

| UC | Naturaleza | Acción propuesta |
|----|------------|------------------|
| uc-rpt-09-configurar-filtros | Subset de filter_reports | Reescribir UC para citar **RPT-003** filter_reports + clarificar que "configurar filtro" es preset/save de filter_reports |
| uc-rpt-10-guardar-vista | Acción nueva (persiste config) | **Agregar función nueva**: ``save_view`` (RPT-009) |
| uc-rpt-11-compartir-reporte | Acción nueva (genera URL/link) | **Agregar función nueva**: ``share_report`` (RPT-010) |
| uc-rpt-12-ver-reporte-agentes | Variante filtrada de view_reports | **Eliminar UC** o reescribir como ejemplo de filter_reports |
| uc-rpt-13-ver-reporte-colas | Variante filtrada de view_reports | **Eliminar UC** o reescribir como ejemplo |
| uc-rpt-14-ver-reporte-campanas | Variante filtrada de view_reports | **Eliminar UC** o reescribir como ejemplo |
| uc-rpt-07-programar-reporte | Acción nueva (scheduling) | **Renombrar RPT-007** de view_kpis -> ``schedule_report`` ¿O agregar nueva? |
| uc-rpt-08-ver-reportes-programados | Variante de view_reports + filtro "scheduled" | Reescribir UC para citar RPT-001 + filter scheduled |

**Trade-off importante:** RPT-007 y RPT-008 fueron declarados
como ``view_kpis`` y ``view_charts`` en el modelo, pero los UCs
los reinterpretaron como "programar"/"ver programados". Esto
requiere decisión:

- **Opcion 1**: Mantener nombres del modelo (view_kpis,
  view_charts), reescribir UCs uc-rpt-07/08 con nuevos
  nombres semánticos.
- **Opcion 2**: Renombrar RPT-007 -> ``schedule_report`` y
  RPT-008 -> ``view_scheduled_reports`` (alineado con UCs);
  mover view_kpis y view_charts a nuevas funciones (RPT-009,
  RPT-010 o más).

**Cifra final del modelo según decisión:**

- Si Opción 1 + agregar save_view + share_report = **42 + 2 = 44 funciones**
- Si Opción 2 + agregar save_view + share_report + view_kpis + view_charts = **42 + 4 = 46 funciones** (pero renombrando 2 existentes)

### MOD_Logs — Recomendación

| UC | Acción propuesta |
|----|------------------|
| uc-log-03-buscar-logs | **Agregar función nueva**: ``search_logs`` (LOG-003) |
| uc-log-04-exportar-logs | Ya existe LOG-002 ``export_logs`` en modelo. **Renombrar UC** o **reescribir** para citar LOG-002 |

**Pregunta:** ¿LOG-002 es ``export_logs`` (correcto) o
``view_etl_logs`` (alineado con uc-log-02)?

Verificar en modelo y decidir.

### UC_PERM — Recomendación

Agregar **5 funciones admin nuevas** al modelo:

- ACC-006 ``revoke_function_group`` (asociado a uc-perm-02)
- ACC-007 ``grant_exceptional_permission`` (uc-perm-03)
- ACC-008 ``revoke_exceptional_permission`` (uc-perm-04)
- ACC-009 ``create_function_group`` (uc-perm-05)
- ACC-010 ``assign_functions_to_group`` (uc-perm-06)

**ACC-006 está disponible** post-Z.1.C (eliminado
gestiona_segmentos). Reusar el slot.

Modelo bumpea de 42 → **47 funciones** si aplica.

## Total cambios propuestos al modelo

| Cambio | Funciones |
|--------|----------:|
| Estado actual v5.2.1 | 42 |
| + save_view, share_report (Reports) | +2 |
| + search_logs (Logs) | +1 |
| + 5 funciones admin (UC_PERM) | +5 |
| **Total propuesto v5.3.0** | **50 funciones** |

Más mismatches a resolver (RPT-007/008, LOG-002).

## Calibración

- **OBSERVABLE:** 42 claims (cross-check de 49 UCs vs 42 funciones).
- **INFERRED:** 12 claims (recomendaciones de Camino A/B/C).
- **SPECULATIVE:** 0.
- **Ratio:** 54/54 = 1.0 ≥ 0.75 ✓

## Decisión pendiente del ejecutor

Antes de ejecutar, confirmar:

1. **MOD_Reports**: ¿Opción 1 (mantener view_kpis/view_charts +
   reescribir UCs) o Opción 2 (renombrar 2 funciones existentes
   + agregar nuevas)?
2. **UC_PERM**: ¿Agregar 5 funciones admin nuevas? Esto es bump
   v5.2.1 → v5.3.0 MAJOR.
3. **UCs RPT 12/13/14** (variantes filtradas): ¿eliminar como
   "variantes de view_reports" o preservar como ejemplos
   pedagógicos?
4. **Mismatches RPT-007/008, LOG-002**: ¿reescribir UCs para
   alinear con modelo, o renombrar funciones del modelo?

Z.2 queda en **Phase 1 DISCOVER** hasta estas decisiones.
