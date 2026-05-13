```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 11 — TRACK (v3 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #4 normativa-restricciones — Fixes pendientes para iteracion v3

5 hallazgos detectados en audit cross-WP (2026-04-29).

## R-1 [ALTO] CNST nuevo "Menu Dinamico Obligatorio" NO existe

**Decision aprobada:** D-RBAC-5 (rbac-formalization § 12).

**CNST a crear:** `source/normativa/restricciones/CNST_032_Menu_
Dinamico_Obligatorio.rst`

**Enunciado:** El frontend DEBE invocar la funcion SQL
`obtener_menu_usuario(user_id)` para construir la navegacion en cada
sesion + on permission change. Esta prohibido renderizar menu estatico
o calculado en frontend basado en roles.

**Justificacion:** sin este CNST, el RBAC plano (CNST_029) no tiene
efecto UX — un usuario con permisos restringidos veria el mismo menu
completo y obtendria 403 al hacer click.

**Estructura:** 9 secciones del template TPL_CNST.

**Estimacion:** 30 min.

## R-2 [ALTO] CNST nuevo "Vocabulario Unificado RBAC" NO existe

**Decision aprobada:** D-RBAC-6 (rbac-formalization § 12).

**CNST a crear:** `source/normativa/restricciones/CNST_033_
Vocabulario_Unificado_RBAC.rst`

**Enunciado:** En la documentacion del proyecto IACT (.rst, .md,
glosario) se DEBE usar el termino canonico **"Funcion"** (no
"Capacidad", no "Capability"). En codigo (Django models, SQL,
funciones, variables) se DEBE usar el termino **"Function"** (no
"Capacidad", no "Capability"). Esta prohibida la coexistencia
de "Capacidad" y "Funcion" en docs o codigo del mismo modulo.

**Justificacion:** elimina drift de vocabulario entre el modelo
legacy v5.2.1 (Funcion) y el sistema PERM granular (Capacidad). Es
parte de la decision arquitectonica D-RBAC-1.

**Estimacion:** 30 min.

## R-3 [ALTO] CNST_029 NO menciona los 10 grupos AGR-001..010

**Archivo:** `source/normativa/restricciones/CNST_029_RBAC_Modelo_
Plano.rst`

**Problema:** CNST_029 declara el modelo plano pero NO lista los
grupos predefinidos especificos. Un lector necesita ir a
`MODELO_RBAC_IACT_v5_2_1.md` (no en source) para conocerlos.

**Accion v3:** agregar tabla en CNST_029 § 2.1 Descripcion Detallada:

| ID | Nombre | # funciones | Tipo |
|----|--------|-------------|------|
| AGR-001 | basic_operator_group | 6 | system |
| AGR-002 | report_viewer_group | 8 | system |
| AGR-003 | quality_supervisor_group | 11 | system |
| AGR-004 | data_exporter_group | 14 | system |
| AGR-005 | alert_manager_group | 6 | system |
| AGR-006 | user_admin_group | 9 | system |
| AGR-007 | permission_admin_group | 5 | system |
| AGR-008 | auditor_group | 4 | system |
| AGR-009 | pipeline_admin_group | 4 | system |
| AGR-010 | system_admin_group | 6 | system |

**Estimacion:** 20 min.

## R-4 [MEDIO] CNST_029 NO declara distincion system vs custom groups

**Decision aprobada:** D-RBAC-4.

**Accion v3:** agregar a CNST_029 § 2.1 una nota explicita:

```
Los 10 grupos AGR-001..010 son **system groups** (inmutables, no
editables por admin). El sistema permite ademas crear **custom
groups** via UC_PERM_05 con flag `is_custom=true`. Las reglas SoD
(CNST_030) aplican tanto a system como a custom groups.
```

**Estimacion:** 10 min (una pequena nota).

## R-5 [ALTO] CNST_030 NO declara las 3 reglas SoD especificas

**Archivo:** `source/normativa/restricciones/CNST_030_Reglas_de_
Separacion_de_Funciones_SoD.rst`

**Problema:** CNST_030 declara la convencion abstracta de SoD pero
NO lista las 3 reglas concretas del modelo v5.2.1.

**Accion v3:** agregar tabla en CNST_030 § 2.1 Descripcion Detallada:

| ID | Nombre | Grupo A | Grupo B | Razon |
|----|--------|---------|---------|-------|
| SOD-001 | pipeline_audit_separation | Pipeline (PIP-001..004) | Audit (AUD-001..004) | Quien opera ETL no debe auditarlo |
| SOD-002 | user_audit_separation | Gestion Users criticas (USR-001/003/004/007) | Audit parcial (AUD-001..003) | Quien gestiona usuarios no debe auditar sus acciones |
| SOD-003 | access_audit_separation | Gestion Acceso (ACC-001/002/004) | Audit (AUD-001/002) | Quien gestiona acceso no debe auditar cambios de permisos |

**Tambien agregar:** D-RBAC-7 — las 3 reglas aplican TAMBIEN a
custom groups creados via UC_PERM_05.

**Estimacion:** 30 min.

## Total iteracion v3

- 5 hallazgos (3 ALTO + 2 MEDIO)
- 2 CNSTs nuevos (CNST_032, CNST_033)
- 3 enriquecimientos (CNST_029 x2, CNST_030)
- Estimacion: ~2 h
- Build verification al final
- Actualizar `index.rst` con CNST_032/033 nuevos
- Commit + push

## Pre-condicion

WP #1 v3 debe completarse PRIMERO (vocabulario unificado en glosario
sera referenciado por CNST_033).

## Cross-refs

- WP padre `track/cross-wp-deep-audit-2026-04-29.md`
- WP #6 `analyze/rbac-formalization.md` § 11 (CNSTs aplicables)
- `analyze/cross-wp-debt-summary.md` (deudas previas + estos)
