```yml
created_at: 2026-04-29 04:45:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 11 — TRACK (audit cross-WP master)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Audit cross-WP master — Hallazgos a resolver en iteraciones

## Premisa

Tras pregunta del ejecutor: "iterar mas para encontrar otros problemas
y documentar TODO en el WP correspondiente". Audit exhaustivo
ejecutado via `/tmp/deep_audit.py` sobre los 6 WPs cerrados +
source global.

**16 hallazgos detectados** distribuidos en 6 WPs.

## Tabla maestra de hallazgos (por WP)

| ID | Severidad | Hallazgo | WP afectado | Documento de remediation |
|----|-----------|----------|-------------|--------------------------|
| **B-1** | CRITICO | MTM_03 declara "18 roles" (modelo v4.0 legacy) | #1 base_cognitiva | `analyze/v3-pending-fixes.md` |
| **B-2** | ALTO | glosario.rst NO contiene 7 terminos canonicos del RBAC (Grupo de Permisos, Agrupador, Permiso Excepcional, Regla SoD, Verificacion de Permiso, Menu Dinamico, AuditoriaPermiso) | #1 base_cognitiva | `analyze/v3-pending-fixes.md` |
| **E-1** | MEDIO | STD_007 NO menciona convencion ingles/espanol (MODELO_RBAC_v5.2.1 § ESTANDAR DE NOMENCLATURA) | #2 estandares | `analyze/v2-pending-fixes.md` |
| **P-1** | MEDIO | PROC_Excepciones_CNST.rst pendiente (W-4 del cross-wp-debt-summary del WP #4) | #3 procedimientos | `analyze/v2-pending-fixes.md` |
| **R-1** | ALTO | CNST nuevo "Menu Dinamico Obligatorio" (D-RBAC-5 aprobada) NO existe | #4 restricciones | `analyze/v3-pending-fixes.md` |
| **R-2** | ALTO | CNST nuevo "Vocabulario Unificado RBAC" (D-RBAC-6 aprobada) NO existe | #4 restricciones | `analyze/v3-pending-fixes.md` |
| **R-3** | ALTO | CNST_029 NO menciona los 10 grupos predefinidos AGR-001..010 | #4 restricciones | `analyze/v3-pending-fixes.md` |
| **R-4** | MEDIO | CNST_029 NO declara distincion "system groups" vs "custom groups" (D-RBAC-4) | #4 restricciones | `analyze/v3-pending-fixes.md` |
| **R-5** | ALTO | CNST_030 NO declara las 3 reglas SoD atomicas (SOD-001/002/003) | #4 restricciones | `analyze/v3-pending-fixes.md` |
| **G-1** | ALTO | ADR-GOB-008 "RBAC Coexistencia ACC ↔ PERM" NO existe (Hipotesis 1 aprobada lo requiere) | #5 gobernanza | `analyze/v2-pending-fixes.md` |
| **Q-1** | ALTO | 571 refs CNST legacy (CNST-NNN format) en bodies de UCs (script v1 solo arreglo metadata) | #6 requisitos | `track/v2-pending-fixes.md` |
| **Q-2** | ALTO | 118 ocurrencias "Capacidad" en UC_PERM (D-RBAC-1 dice "Funcion") | #6 requisitos | `track/v2-pending-fixes.md` |
| **Q-3** | MEDIO | 0 cross-refs entre UC_ACC ↔ UC_PERM (coexistencia invisible) | #6 requisitos | `track/v2-pending-fixes.md` |
| **Q-4** | MEDIO | source/requisitos/reglas_negocio/ NO existe (BRs no generados) | #6 requisitos | `track/v2-pending-fixes.md` |
| **Q-5** | MEDIO | source/requisitos/requisitos_funcionales/ NO existe (FRs no generados) | #6 requisitos | `track/v2-pending-fixes.md` |
| **Q-6** | MEDIO | source/requisitos/requisitos_no_funcionales/ NO existe (NFRs no generados) | #6 requisitos | `track/v2-pending-fixes.md` |

## Resumen por WP

| WP | Hallazgos | Severidades | Iteracion requerida |
|----|-----------|-------------|---------------------|
| #1 base_cognitiva | 2 | 1 CRITICO + 1 ALTO | **v3** |
| #2 normativa-estandares | 1 | 1 MEDIO | **v2** |
| #3 normativa-procedimientos | 1 | 1 MEDIO | **v2** |
| #4 normativa-restricciones | 5 | 3 ALTO + 1 MEDIO | **v3** |
| #5 normativa-gobernanza | 1 | 1 ALTO | **v2** |
| #6 requisitos | 6 | 2 ALTO + 4 MEDIO | **v2** |
| **Total** | **16** | 1 CRITICO + 8 ALTO + 7 MEDIO | **6 iteraciones** |

## Distribucion por severidad

```
CRITICO (1):   B-1 MTM_03 drift "18 roles"
ALTO (8):      B-2, R-1, R-2, R-3, R-5, G-1, Q-1, Q-2
MEDIO (7):     E-1, P-1, R-4, Q-3, Q-4, Q-5, Q-6
```

## Plan de remediation en cascada

### Fase 1 — CRITICO + 6 ALTOs en RBAC (orden topologico)

1. **WP #1 v3** (B-1, B-2): MTM_03 fix + glosario unificado
2. **WP #4 v3** (R-1..R-5): 2 CNSTs nuevos + enriquecer CNST_029/030
3. **WP #5 v2** (G-1): ADR-GOB-008
4. **WP #6 v2** (Q-1, Q-2): refs CNST en bodies + Capacidad → Funcion

### Fase 2 — MEDIOs

5. **WP #2 v2** (E-1): STD_007 con convencion idioma
6. **WP #3 v2** (P-1): PROC_Excepciones_CNST
7. **WP #6 v2** (Q-3, Q-4, Q-5, Q-6): cross-refs + BRs + FRs + NFRs

### Estimacion total

~10-15 horas de trabajo distribuido en 6 iteraciones.

## Hallazgo metodologico

El cierre prematuro de WP #6 ocurrio por NO verificar
`analyze/cross-wp-rbac-audit.md` antes de Phase 11 TRACK. Para
prevenir esto:

> **Protocolo nuevo:** antes de cerrar cualquier WP, ejecutar
> `/tmp/deep_audit.py` (o equivalente futuro como skill THYROX)
> sobre TODO el source/ + WPs cerrados. Si hay hallazgos
> CRITICOS o ALTOs en WPs dependientes, NO cerrar — primero
> resolver via iteracion correspondiente.

Documentar este protocolo como guideline en `.claude/rules/` o como
step explicito en `workflow-track` skill.

## Documentos derivados (uno por WP)

Cada WP afectado recibe su propio documento `pending-fixes` con
detalle de su sub-conjunto de hallazgos:

- `WP-1/analyze/v3-pending-fixes.md` (B-1, B-2)
- `WP-2/analyze/v2-pending-fixes.md` (E-1)
- `WP-3/analyze/v2-pending-fixes.md` (P-1)
- `WP-4/analyze/v3-pending-fixes.md` (R-1..R-5)
- `WP-5/analyze/v2-pending-fixes.md` (G-1)
- `WP-6/track/v2-pending-fixes.md` (Q-1..Q-6)

## Script reproducible

`/tmp/deep_audit.py` (no commiteable porque vive en /tmp). Voy a
copiarlo a `standardize/deep_audit.py` del WP padre para preservarlo
y permitir re-ejecucion futura.
