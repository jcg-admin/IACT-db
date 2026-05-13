```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-27-25-source-rebuild-base-cognitiva
phase: Phase 11 — TRACK (v3 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #1 base_cognitiva — Fixes pendientes para iteracion v3

Hallazgos detectados en audit cross-WP del 2026-04-29 (ver
`source-rebuild-strategy/track/cross-wp-deep-audit-2026-04-29.md`).

## B-1 [CRITICO] Drift MTM_03 "18 roles" legacy

**Archivo:** `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst`

**Linea problema (~684):**
```
CATALOGO CERRADO (18 roles):
```

**Modelo correcto (v5.2.1 vigente):**
- 42 funciones atomicas (no 18 roles)
- 10 grupos predefinidos AGR-001..010
- 3 reglas SoD (SOD-001, SOD-002, SOD-003)
- Permisos temporales

**Accion v3:**
1. Localizar la seccion completa "CATALOGO CERRADO (18 roles)" en
   MTM_03 (probablemente §6 o §7).
2. Reescribir como "CATALOGO de 42 funciones + 10 grupos predefinidos"
   citando el `MODELO_RBAC_IACT_v5_2_1.md` (cuando se migre a source
   en WP #7 arquitectura-tecnica).
3. Agregar tabla con los 10 grupos AGR-001..010 (ver `analyze/cnst-id-drift-remediation.md` § Mapeo legacy → SRP-31 para vinculo).
4. Actualizar refs internas si aplican.

**Estimacion:** 30 min.

## B-2 [ALTO] glosario.rst incompleto — faltan 7 terminos canonicos

**Archivo:** `source/base_cognitiva/glosario.rst`

**Terminos canonicos del RBAC formalizado (rbac-formalization.md §2)
que deben agregarse:**

| Termino | Definicion |
|---------|------------|
| Grupo de Permisos | Set de funciones asignables como bloque, predefinido (AGR-001..010) o creable. |
| Agrupador | Sinonimo de "Grupo predefinido AGR-001..010" (legacy v5.2.1). |
| Permiso Excepcional | Override one-off de funciones a un usuario con justificacion >=20 ch + vencimiento <=6 meses. |
| Regla SoD | Restriccion de mutual exclusion entre dos grupos (Separation of Duties). |
| Verificacion de Permiso | Funcion SQL nativa que evalua en runtime si un usuario tiene una funcion. |
| Menu Dinamico | Estructura de navegacion calculada en runtime segun las funciones del usuario. |
| AuditoriaPermiso | Tabla append-only que registra cada verificacion de permiso runtime. |

**Accion v3:**
1. Editar `glosario.rst` agregando los 7 terminos en orden alfabetico.
2. Cada entrada incluye definicion + ref `:doc:` al UC o CNST relacionado.
3. Build verde.

**Estimacion:** 20 min.

## Total iteracion v3

- 2 hallazgos (1 CRITICO + 1 ALTO)
- Estimacion: ~50 min de trabajo
- Build verification al final
- Commit + push

## Pre-condicion

Esta iteracion v3 debe ejecutarse ANTES de las iteraciones v3 del
WP #4 y v2 del WP #5/#6 (cascada documentada en cross-wp-deep-audit
del WP padre).

## Cross-refs

- `analyze/cnst-id-drift-remediation.md` (v2, mantiene historia)
- `analyze/base-cognitiva-cnst-references.md` (v2)
- WP #6 `analyze/rbac-formalization.md` (vocabulario unificado fuente)
