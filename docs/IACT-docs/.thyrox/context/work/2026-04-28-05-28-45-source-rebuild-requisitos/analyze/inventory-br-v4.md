```yml
created_at: 2026-04-28 23:05:52
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inventario de Business Rules (BR) — IACT real, depurado v4.0.0

Filtrado de los 384 BRs detectados originalmente. Solo se documentan los BRs
del dominio IACT (call-center analytics, auth/sesion/RBAC/ETL/reportes/alertas/
auditoría). Los BRs pedagógicos (química/OSHA, presupuesto, inventario)
se listan al final por ID y se descartan.

## Catálogo v4.0.0 detectado

**Hallazgo:** No existe nomenclatura modular `BR_USR_*`/`BR_ACC_*`/`BR_RPT_*`
análoga a la migración UC v2.0 → v4.0.0 (UC_ACC_01, UC_RPT_XX). El plan
maestro v4.0.0 (`PLAN_MAESTRO_Actualizacion_Referencias_v4_0_0.md`) cubre
exclusivamente UC y FR — `grep` por `BR_USR_|BR_ACC_|BR_RPT_|BR_ALR_|
BR_PIP_|BR_AUD_` retorna 0 resultados en ese plan.

**Sí existe** una convención v4-compatible documentada en
`PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` (líneas 212-243):

- ID interno: `BR-IACT-NNN`
- Nombre de archivo: `BR_IACT_NNN_<Nombre>_X_Y_Z.rst`
- Ejemplos citados: `BR_IACT_028`, `BR_IACT_031`, `BR_IACT_046`,
  `BR_IACT_053`, `BR_IACT_087`

Esta convención es **plana** (`BR-IACT-NNN`), no modular. No hay tabla
de mapeo BR legacy (`BR_001`...`BR_020`) → `BR-IACT-NNN`. La fuente
canónica vigente sigue siendo `BR_NNN` (las 20 BR del sistema IACT,
catalogadas en `las 20 BR.txt` y materializadas en `BR_001_*.rst` …
`BR_020_*.rst`).

## BRs IACT reales (20 totales — todos están dentro del límite de 50)

Agrupados por módulo. Datos extraídos de `las 20 BR.txt`,
`BR_NNN_*.rst` (meta + Resumen Ejecutivo) y `CATALOGO_BR.md`.
Modalidad inferida del tipo: Restricción/Hecho → Obligatoria;
Desencadenador/Cálculo → Obligatoria; Inferencia → Obligatoria.
Todas son obligatorias; ninguna es permisiva ni prohibitiva pura
(las "Restricciones" son obligaciones negativas — equivalentes a
prohibitorias en SBVR pero documentadas como Restricción).

### Módulo MOD_Pipeline (ETL / Datos)

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_001 | (no migrado) | Fuente Operacional Inmutable | Hecho/Restricción | Obligatoria | — | CNST_003 |
| BR_002 | (no migrado) | ETL Batch Nocturno | Desencadenador | Obligatoria | UC_PIP_* | CNST_004 |
| BR_019 | (no migrado) | Retención 2 Años | Restricción | Obligatoria | — | CNST_006 |
| BR_020 | (no migrado) | Clasificación Datos | Restricción | Obligatoria | — | CNST_010 |

### Módulo MOD_Users (Auth / Usuarios)

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_003 | (no migrado) | Usuario Inactivo 90 días | Inferencia | Obligatoria | — | — |
| BR_005 | (no migrado) | Sesión Única por Usuario | Restricción | Obligatoria | UC_AUTH_* | CNST_002 |
| BR_012 | (no migrado) | Usuario-Segmento Único | Hecho | Obligatoria | — | — |
| BR_013 | (no migrado) | Username Único | Hecho | Obligatoria | UC_USR_* | — |
| BR_015 | (no migrado) | Bloqueo Intentos Fallidos | Desencadenador | Obligatoria | UC_AUTH_* | CNST_005 |

### Módulo MOD_Access (RBAC / Permisos)

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_006 | (no migrado) | RBAC Flat NIST | Hecho | Obligatoria | UC_ACC_* | CNST_005 |
| BR_007 | (no migrado) | Separación de Funciones (SoD) | Restricción | Obligatoria | UC_ACC_* | CNST_005 |
| BR_008 | (no migrado) | Permisos con Vencimiento (Auditoría Accesos) | Restricción | Obligatoria | — | CNST_005 |
| BR_009 | (no migrado) | Bajas Lógicas | Restricción | Obligatoria | — | CNST_005 |

### Módulo MOD_Comms / Política

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_004 | (no migrado) | Comunicaciones Internas Only | Restricción | Obligatoria | — | CNST_001 |

### Módulo MOD_Alerts

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_014 | (no migrado) | Alerta por Umbral | Desencadenador | Obligatoria | UC_ALR_01 | — |

### Módulo MOD_Audit

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_010 | (no migrado) | Auditoría Inmutable | Restricción | Obligatoria | UC_AUD_* | CNST_009 |

### Módulo MOD_Reports (Métricas)

| BR legacy | BR v4.0.0 | Título | Tipo | Modalidad | UC origen | CNST |
|-----------|-----------|--------|------|-----------|-----------|------|
| BR_011 | (no migrado) | Límites de Exportación | Restricción | Obligatoria | UC_RPT_* | CNST_007 |
| BR_016 | (no migrado) | Tasa de Abandono | Cálculo | Obligatoria | UC_RPT_* | — |
| BR_017 | (no migrado) | Tiempo Promedio de Espera | Cálculo | Obligatoria | UC_RPT_* | — |
| BR_018 | (no migrado) | Índice de Eficiencia | Cálculo | Obligatoria | UC_RPT_* | — |

**Total BRs IACT reales: 20** (bajo el límite de 50).

## BRs pedagógicos descartados

Detectados en `ANALISIS_REGLAS_NEGOCIO_SISTEMA_COMPLETO.md` y
`De Reglas de Negocio a Sistema Completo.md`. Provienen del documento
metodológico genérico (química/OSHA, presupuesto, inventario) — NO
pertenecen al dominio IACT.

- `BR_028` — Aprobación de solicitudes >$500 (presupuesto)
- `BR_029` — Flujo de aprobación (presupuesto)
- `BR_030` — Notificaciones (presupuesto)
- `BR_045` — Desencadenador inventario
- `BR_046` — Inferencia inventario
- `BR_052` — Cálculo inventario
- `BR_087` — OSHA 1910.1200 (químicos)
- `BR_088` — EPA 40 CFR Part 262 (químicos)
- `BR_089` — State Chemical Safety Act (químicos)
- `BR_CHEM_001` — Restricción química (hojas seguridad)
- `BR_CHEM_002` — Desencadenador químico
- `BR_CHEM_003` — Cálculo químico (CAS)
- `BR_CHEM_004` — Inferencia química

Estos NO son BRs del producto IACT — son ejemplos de la metodología.

## Referencias documentadas vagas (no listables)

Los ejemplos `BR-IACT-028`, `BR-IACT-031`, `BR-IACT-046`, `BR-IACT-053`,
`BR-IACT-087` aparecen en `PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md`
como **muestras ilustrativas**, sin definición de contenido completa en
los inputs canónicos. No se cuentan como BRs IACT reales documentados
hasta que existan los archivos `BR_IACT_NNN_*.rst` correspondientes.

## Hallazgos

**H-01 — No existe catálogo modular v4.0.0 para BRs.** La migración v4.0.0
del proyecto cubre UC y FR pero NO BR. Las 20 BR canónicas siguen
nombrándose `BR_NNN` (plano, sin prefijo modular).

**H-02 — Existe convención `BR-IACT-NNN` propuesta pero no aplicada.**
`PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md` define la
nomenclatura `BR-IACT-NNN` con archivos `BR_IACT_NNN_<Nombre>_X_Y_Z.rst`.
No se ha aplicado a las 20 BR vigentes.

**H-03 — Recomendación de nomenclatura modular para BRs (si se decide
aplicar v4.0.0):** seguir el patrón UC para preservar trazabilidad módulo
↔ artefacto:

| Prefijo propuesto | Módulo | BRs sugeridos |
|-------------------|--------|---------------|
| `BR_USR_*` | MOD_Users | BR_003, BR_005, BR_012, BR_013, BR_015 |
| `BR_ACC_*` | MOD_Access (RBAC) | BR_006, BR_007, BR_008, BR_009 |
| `BR_PIP_*` | MOD_Pipeline (ETL/datos) | BR_001, BR_002, BR_019, BR_020 |
| `BR_RPT_*` | MOD_Reports | BR_011, BR_016, BR_017, BR_018 |
| `BR_ALR_*` | MOD_Alerts | BR_014 |
| `BR_AUD_*` | MOD_Audit | BR_010 |
| `BR_POL_*` | Política/Comms | BR_004 |

La numeración secuencial `BR_USR_01`, `BR_USR_02` se asignaría en orden
del catálogo legacy. Esta tabla es **propuesta** — NO está validada en
los inputs canónicos. Requiere decisión de arquitectura (ADR) antes de
aplicarla.

**H-04 — Reducción del universo:** de 384 BRs detectados originalmente
en la fase de scraping, sólo **20 son del dominio IACT** (5,2%). El
resto son ruido pedagógico (química/OSHA, presupuesto/inventario,
metodología genérica). Se recomienda excluir esos 364 del scope de
documentación de requisitos.
