```yml
created_at: 2026-04-30 04:30:00
project: IACT-docs
work_package: 2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup
phase: Phase 11 — TRACK
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP Changelog — rbac-modelo-conceptual-cleanup

> Registro completo de cambios producidos por este WP siguiendo el
> formato Keep a Changelog. Cubre el bump del modelo RBAC de v5.3.0
> a v5.4.0 más todos los artefactos asociados.

## v5.4.0 — 2026-04-30

### Added

#### Modelo RBAC (10 funciones nuevas)

- `ACC-011 update_separation_rule` — actualiza parámetros de regla
  SoD existente. Split SRP de ACC-005.
- `ACC-012 disable_separation_rule` — toggle on/off de regla SoD
  (BR-009 global, no eliminar). Split SRP de ACC-005.
- `ALR-007 acknowledge_alert` — state transition de alerta
  ACTIVE → ACKNOWLEDGED. Closed-loop alerts.
- `ALR-008 subscribe_to_alert` — split SRP de gestión de
  suscripciones.
- `ALR-009 unsubscribe_from_alert` — split SRP de gestión.
- `ALR-010 configure_subscription_severity` — split SRP de gestión.
- `LOG-004 view_etl_logs` — split SRP de LOG-001 genérico.
- `LOG-005 view_infrastructure_logs` — split SRP, cubre logs
  de infraestructura.
- `LOG-006 view_system_health` — gap UC_081 declarado en
  ARQ-MOD-008.
- `LOG-007 view_technical_metrics` — gap UC_083 declarado en
  ARQ-MOD-008.

#### Casos de Uso nuevos (6 UCs)

- `uc-log-05-ver-logs-infraestructura.rst` (función LOG-005).
- `uc-log-06-ver-estado-sistema.rst` (función LOG-006).
- `uc-log-07-ver-metricas-tecnicas.rst` (función LOG-007).
- `uc-rpt-15-reporte-transferencias-centro.rst` (instancia
  RPT-001 scope=transferencias).
- `uc-rpt-16-reporte-menus-ivr.rst` (instancia RPT-001
  scope=menus_ivr).
- `uc-rpt-17-reporte-clientes-unicos.rst` (instancia RPT-001
  scope=clientes_unicos).

#### Documentación de análisis (artefactos del WP)

- `analyze/srp-audit/srp-violations-analysis.md` — 8 hallazgos.
- `analyze/srp-audit/decisions-log.md` — 11 decisiones (D-01..D-11).
- `plan/v5.4.0-implementation-plan.md` — 24 tareas en 6 bloques.

### Changed

#### Renames preservando IDs (modelo RBAC)

- `USR-003 delete_users` → `deactivate_users` (BR-009 global,
  no eliminar).
- `ALR-005 delete_alerts` → `disable_alerts` (BR-009 toggle on/off).
- `LOG-001 view_technical_logs` → `view_application_logs`
  (SRP — ya no cubre ETL ni infra).
- `AUTH-001 manage_sessions` → `view_own_sessions` (SRP scope
  propio; distinción con AUTH-004).
- `AUTH-004 view_active_sessions` → `view_all_active_sessions`
  (SRP scope sistema; admin).
- `ACC-005 manage_separation_rules` → `view_separation_rules`
  (split SRP B2; las operaciones de modificar/desactivar son
  ahora ACC-011 y ACC-012).

#### Constraints reescritas

- `BR-009 Bajas Lógicas` v1.0.0 → v2.0.0:
  - **Alcance global**: ahora cubre todos los módulos (antes
    solo MOD_Users).
  - Estados canónicos por entidad documentados.
  - Mapeo a renames v5.4.0 explícito.
- `BR-011 Límites de Exportación` v1.0.0 → v2.0.0:
  - Eliminada cifra arbitraria "100,000 registros máximo".
  - Delega a CNST-019 (async) y CNST-020 (recursos).
  - UCs alineados a uc-rpt-04 consolidado (Larman).
- `CNST-019 Exportaciones Asíncronas` v2.0.0 → v3.0.0:
  - Desacoplado de Celery (era prescripción tecnológica).
  - Reemplazado por "cola asíncrona dedicada con worker pool".
  - Capacidades requeridas independientes de tecnología.
  - Lista de alternativas viables documentadas (Celery, RQ,
    Dramatiq, asyncio, PostgreSQL LISTEN/NOTIFY, AWS SQS).
- `CNST-020 Throttling de Exportaciones` v2.0.0 → v3.0.0:
  - **Eliminada tabla arbitraria por formato** (CSV 100K,
    Excel 50K, PDF 10K).
  - Eliminada quota diaria por formato (10/5/3).
  - Reemplazada por throttling abstracto por recursos del
    sistema: concurrent jobs por usuario, daily quota total,
    aislamiento de pool, tamaño máximo del artefacto.
  - Cifras concretas movidas a ADR de implementación.
  - Stack tecnológico movido a ADR de implementación.

#### UCs actualizados (re-mapeos)

- `uc-rpt-04` v4.0.0 → v5.0.0: **consolidación Larman** —
  unifica antiguas uc-rpt-04 CSV + uc-rpt-05 Excel + uc-rpt-06
  PDF en un solo UC con flujos alternativos por formato.
  Renombrado a `uc-rpt-04-exportar-reporte.rst`.
- `uc-log-02-consultar-logs-etl`: re-mapeado de
  LOG-001 view_technical_logs (instancia) → LOG-004 view_etl_logs
  (función dedicada).
- `uc-perm-10-consultar-auditoria-permisos`: cita obsoleta
  "Excel <10K registros" reemplazada por referencia a
  CNST-019/020 corregidos.
- `uc-alr-03-reconocer-alerta`: ALR-003 reconoce_alertas
  → ALR-007 acknowledge_alert.
- `uc-alr-05-gestionar-suscripciones`: ALR-005 gestiona →
  1 UC con flujos alternativos (FA-Subscribe, FA-Unsubscribe,
  FA-Configure-Severity) usando ALR-008/009/010.

#### Documentos vivos actualizados

- `modelo-rbac-iact.rst` v5.3.0 → v5.4.0: catálogo de 51 →
  61 funciones; sección "Cambios v5.3.0 → v5.4.0"; SQL canónico
  de 61 funciones; tabla de mapeo funciones→UCs actualizada;
  fixes de title underlines + block quotes.
- `raci-rbac-iact.rst` v1.1.0 → v1.2.0: 10 filas RACI nuevas,
  títulos de sección actualizados con conteos por módulo.
- `adr-gob-009-rbac-modelo-conceptual.rst` v1.1.0 → v1.2.0:
  cifras 51/10/3 → 61/10/3; drivers del bump v5.4.0
  documentados; nota histórica preservada.
- `reports/index.rst`, `logs/index.rst`: agregadas entradas
  para los 6 UCs nuevos; eliminadas uc-rpt-05/06.

#### Cat B+C+D+F preexistentes (commit fd9ef31)

Estos cambios fueron ejecutados antes del bump v5.4.0 pero
forman parte del scope del WP:

- 9 UCs corregidos por mismatch ID/concepto en MOD_Users,
  MOD_Alerts, MOD_Access, MOD_Auth.
- Vocabulario español reemplazado por inglés canónico
  (CNST-033) en los UCs corregidos.

### Removed

- `uc-rpt-05-exportar-excel.rst` (consolidado en uc-rpt-04
  v5.0.0; preservado en git history).
- `uc-rpt-06-exportar-pdf.rst` (consolidado en uc-rpt-04
  v5.0.0; preservado en git history).

**Sin eliminación de funciones RBAC** (principio "no eliminar
nada" de BR-009 global).

### Fixed

- `modelo-rbac-iact.rst` línea 815-816 y 1041-1042: bloques
  `**CAMBIO vN.x:**` ahora tienen línea en blanco antes de la
  lista (eliminados ERROR de Unexpected indentation y WARNING
  de Block quote).
- `raci-rbac-iact.rst` líneas 409, 513, 657: title underlines
  alineadas a longitud del título.
- `modelo-rbac-iact.rst` línea 744: title underline alineada.
- `uc-auth-03-recuperar-contrasena.rst` línea 374: title
  underline 8.1 EX-01 alineada.

### Aceptado / no fixeado

- `discrepancia-rbac-correccion-ene-2026.rst:159`: warning
  `unknown document: br-012-usuario-segmento-unico`. Este
  archivo es histórico (carpeta `gestion/evidencia/rbac-historia/`)
  que documenta la decisión de eliminar el concepto Segmento
  (br-012). El archivo br-012 ya no existe porque se aplicó
  Camino C (Segmento eliminado del modelo). El warning es
  consistente con la decisión histórica. **No se fixea**: el
  documento histórico debe preservar la mención al artefacto
  eliminado para trazabilidad. Resolverse en otro WP de
  saneamiento de docs históricos.

### Hallazgos derivados (WPs hijos abiertos)

- **WP md-references-audit** (commit 8d4a8a8): durante la
  auditoría final se detectaron 832 referencias a archivos
  `.md` en source/ que Sphinx NO valida (hyperlinks RST
  externos). Riesgo: links rotos silenciosos en sitio
  publicado. WP independiente abierto en
  `2026-04-30-04-11-28-md-references-audit/`.

## Status de promoción a CHANGELOG.md raíz

Este WP NO promociona aún a `CHANGELOG.md` raíz porque el branch
`feature/solve-problem-docs` no se ha mergeado a `main`. Cuando
ocurra el merge con bump de versión, las entradas relevantes
(modelo RBAC v5.4.0, constraints reescritas, Larman consolidación)
deben promoverse bajo `## [X.Y.Z] — YYYY-MM-DD`.

## Métricas finales

| Métrica | Valor |
|---------|-------|
| Funciones modelo (antes/después) | 51 → 61 |
| Funciones nuevas | +10 |
| Funciones renombradas (ID preservado) | 6 |
| Funciones eliminadas | 0 |
| UCs nuevos creados | 6 |
| UCs eliminados (consolidados) | 2 (uc-rpt-05, uc-rpt-06) |
| UCs re-mapeados | 4 (uc-log-02, uc-perm-10, uc-alr-03, uc-alr-05) |
| UCs corregidos previamente Cat B+C+D+F | 9 |
| Constraints reescritas | 4 (BR-009, BR-011, CNST-019, CNST-020) |
| Decisiones aprobadas | 11 (D-01..D-11) |
| Bloques de implementación | 6 |
| Commits | 9 (`74ae48c`, `fd9ef31`, `f4adadf`, `7f94006`, `cc529de`, `43b10c4`, `69a7092`, `f217ffe`, este) |
| Build status final | succeeded, 1 warning preexistente |

## Trazabilidad de commits

| Bloque | Commit | Descripción |
|--------|--------|-------------|
| Pre-WP | `74ae48c` | Bump v5.2.1 → v5.3.0 (working work) |
| Pre-WP | `fd9ef31` | Cat B+C+D+F (9 UCs) |
| Doc | `f4adadf` | Análisis SRP + decisions log + plan |
| 1 | `7f94006` | Modelo + RACI + ADR v5.3.0 → v5.4.0 |
| 2 | `cc529de` | Constraints abstractos (CNST-019/020 + BR-009/011) |
| 3 | `43b10c4` | Consolidación Larman uc-rpt-04 |
| 4 | `69a7092` | 6 UCs nuevos + fixes title underlines |
| 5 | `f217ffe` | Re-mapeos UCs |
| Hijo | `8d4a8a8` | Open WP md-references-audit |
| 6 | (este) | Cierre WP + changelog + fixes block quote |

## Cierre

WP completado según plan v5.4.0-implementation-plan.md. Todas las
24 tareas T-NNN ejecutadas. Build sin warnings derivados del
scope del WP. Hallazgos derivados documentados en WP hijo
independiente (md-references-audit).
