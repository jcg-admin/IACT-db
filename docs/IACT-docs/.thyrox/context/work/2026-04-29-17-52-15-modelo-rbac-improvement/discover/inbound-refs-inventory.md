```yml
created_at: 2026-04-29 18:00:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inbound References Inventory

## Métricas verificadas

| Tipo de ref | Cantidad |
|-------------|---------:|
| `:doc:` hacia el archivo | **6** (5 únicos externos, 1 self-ref interno) |
| `:ref:` al label `modelo-rbac-iact` | **0** |
| Archivos que mencionan `MODELO_RBAC_IACT` o `modelo-rbac-iact` | **12** |
| Menciones de identificadores del catálogo (MOD_*, AGR-*, SOD-*) en OTROS archivos | **707** |

## Refs `:doc:` directas (6)

```
1. requisitos/casos-uso/permissions/uc-perm-01-asignar-grupo-a-usuario.rst:508
   :doc:`Modelo RBAC IACT </arquitectura-tecnica/rbac/modelo-rbac-iact>`

2. backend/conventions.rst:105
   :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`

3. (self) modelo-rbac-iact.rst:21 — autoreferencia legacy en cabecera

4. normativa/restricciones/cnst-033-vocabulario-unificado-rbac.rst:167
   `:doc:.../modelo-rbac-iact``... § "ESTANDAR DE NOMENCLATURA"

5. normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm.rst:34
   "Documentada en :doc:`.../modelo-rbac-iact`"

6. normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm.rst:182
   "WP #7 (pendiente): migrar :doc:`.../modelo-rbac-iact` a..."
```

## Archivos consumidores (12 distintos)

| # | Archivo | Tipo de uso |
|---|---------|-------------|
| 1 | `requisitos/casos-uso/permissions/uc-perm-01-asignar-grupo-a-usuario.rst` | UC referencia el modelo |
| 2 | `requisitos/reglas-negocio/br-012-usuario-segmento-unico.rst` | BR cita versión histórica `MODELO_RBAC_IACT_v5_2_1` |
| 3 | `requisitos/casos-uso/permissions/uc-perm-01-...` (texto) | mention |
| 4 | `base-cognitiva/_fundamentos-conceptuales/fnd-03-casos-de-uso.rst` | mention contextual |
| 5 | `base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles.rst` | mention contextual |
| 6 | `backend/conventions.rst` | guideline de implementación |
| 7 | `arquitectura-tecnica/rbac/index.rst` | toctree del subdominio |
| 8 | `normativa/estandares/std-007-convencion-naming.rst` | citación legacy en historial |
| 9 | `normativa/restricciones/cnst-029-rbac-modelo-plano.rst` | CNST normativa |
| 10 | `normativa/restricciones/cnst-030-reglas-de-separacion-de-funciones-sod.rst` | CNST normativa |
| 11 | `normativa/restricciones/cnst-031-permisos-temporales-maximo-6-meses.rst` | CNST normativa |
| 12 | `normativa/restricciones/cnst-033-vocabulario-unificado-rbac.rst` | CNST normativa |
| 13 | `normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm.rst` | ADR de gobernanza |

## Identificadores ampliamente referenciados

**707 menciones** de los identificadores del catálogo del modelo
en otros archivos. Esto significa que **cualquier rename de
identificadores (MOD_*, AGR-NNN, SOD-NNN) sería breaking change
masivo**.

Identificadores en uso público:

- **8 módulos:** MOD_Auth, MOD_Users, MOD_Access, MOD_Pipeline,
  MOD_Reports, MOD_Alerts, MOD_Audit, MOD_Logs
- **10 grupos:** AGR-001..AGR-010 (basic_operator_group,
  report_viewer_group, quality_supervisor_group,
  data_exporter_group, alert_manager_group, user_admin_group,
  permission_admin_group, auditor_group, pipeline_admin_group,
  system_admin_group)
- **3 reglas SoD:** SOD-001 (pipeline_audit_separation),
  SOD-002 (user_audit_separation), SOD-003 (access_audit_separation)
- **42 funciones** distribuidas en los 8 módulos

## Implicaciones para el plan de mejora

### Inmutables (NO se pueden cambiar sin breaking masivo)

- IDs de módulos: MOD_Auth, MOD_Users, MOD_Access, MOD_Pipeline,
  MOD_Reports, MOD_Alerts, MOD_Audit, MOD_Logs.
- IDs de grupos: AGR-001..AGR-010 + sus nombres canónicos
  (`basic_operator_group`, etc.).
- IDs de SoD: SOD-001..SOD-003 + nombres canónicos.
- IDs de funciones: los códigos `manage_sessions`, `view_reports`, etc.

### Modificables (sin afectar refs entrantes)

- Texto narrativo y prosa.
- Bloques de código SQL/Django (mientras los nombres de tabla
  se respeten).
- Tabla de mapeo funciones → UCs.
- Sección de migración v5.2.0 → v5.2.1.

### Refs autoritativas a respetar

- `cnst-033-vocabulario-unificado-rbac.rst:167` cita la sección
  "ESTANDAR DE NOMENCLATURA" — esa sección debe **permanecer y
  mantener su nombre/contenido** o actualizar el CNST.
- `adr-gob-008` línea 182 menciona "WP #7 (pendiente)" — el ADR
  ASUME que el modelo va a migrar; este WP podría ser ese WP #7
  o consolidar parte de ese trabajo.

## Próximo paso

T-003: identificar contenido esperado per convenciones del
proyecto (CNST_029/030/031/033, STD_007 v2.0.2 schema, ADR_GOB_008).
