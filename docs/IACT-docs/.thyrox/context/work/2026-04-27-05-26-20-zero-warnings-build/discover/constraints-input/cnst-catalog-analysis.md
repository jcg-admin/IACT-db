```yml
created_at: 2026-04-27 05:55:00
project: IACT-docs
work_package: 2026-04-27-05-26-20-zero-warnings-build
phase: Phase 3 — DIAGNOSE (CNST inventory)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis del Catálogo de Restricciones (CNST_*)

## Contexto

Este análisis compara las **restricciones existentes** en `source/normativa/restricciones/`
con las **restricciones nuevas** que el ejecutor está pasando como input (CNST_001 a
CNST_006 hasta el momento). Sirve para tomar decisión de integración antes de
modificar `source/`.

---

## Inventario actual del repositorio

**Path:** `source/normativa/restricciones/`
**Estado declarado en `index.rst`:** v1.1.0, 2026-01-03, 10,993 líneas totales.
**Integración RBAC declarada:** v5.1.1 (44 funciones atómicas).

| ID | Filename | Título | Líneas | Versión actual | Origen |
|----|----------|--------|--------|----------------|--------|
| CNST-001 | `CNST_001_Comunicaciones_Prohibidas.rst` | Comunicaciones Prohibidas (NO email/SMTP) | 698 | 1.0.1 | Cliente |
| CNST-002 | `CNST_002_Gestion_Sesiones_BD.rst` | Gestión de Sesiones en BD (NO Redis) | 731 | 1.0.1 | Cliente |
| CNST-003 | `CNST_003_Base_Datos_Dual_Inmutable.rst` | Base de Datos Dual Inmutable (IVR readonly) | 904 | 1.1.0 | Cliente |
| CNST-004 | `CNST_004_Actualizacion_Datos_ETL.rst` | Actualización de Datos ETL (NO real-time) | 921 | 1.0.1 | Cliente |
| CNST-005 | `CNST_005_Seguridad_DRF_Checklist.rst` | Seguridad DRF Checklist | 1,500 | 1.1.0 | Mejores prácticas |
| CNST-006 | `CNST_006_Antipatrones_Arquitectura.rst` | Antipatrones de Arquitectura | 1,948 | 1.1.0 | Estándares calidad |
| CNST-007 | `CNST_007_Limites_Performance_SLA.rst` | Límites Performance & SLA | 1,064 | 1.0.1 | Requerimientos cliente |
| CNST-008 | `CNST_008_Infraestructura_Deployment.rst` | Infraestructura & Deployment | 1,022 | 1.0.1 | Cliente |
| CNST-009 | `CNST_009_Logging_Auditoria_Inmutable.rst` | Logging y Auditoría Inmutable | 1,080 | 1.0.1 | Seguridad |
| CNST-010 | `CNST_010_Clasificacion_Proteccion_Datos.rst` | Clasificación y Protección de Datos | 1,012 | 1.1.0 | Cliente |
| — | `index.rst` | Índice del catálogo | 268 | — | — |

**Total:** 10 restricciones + 1 index = 11 archivos.
**Tamaño total:** ~11,150 líneas (verificado con `wc -l`; el index dice 10,993 — desfase menor).

### Categorización oficial (del index.rst)

- **Críticas no negociables:** CNST-001, 002, 003, 004
- **Seguridad:** CNST-005, 010
- **Arquitectura:** CNST-006
- **Performance:** CNST-007
- **Infraestructura:** CNST-008
- **Auditoría:** CNST-009

### Templates / procedimientos relacionados (fuera de `restricciones/`)

- `source/normativa/estandares/plantillas/TPL_CNST_Restricciones_1_0_0.rst` — plantilla canónica.
- `source/normativa/procedimientos/PROC_Generacion_CNST_1_0_0.rst` — procedimiento para crear nuevas.

---

## Inventario nuevo (provisto por el ejecutor — entrada de Phase 1)

| ID nuevo | Título nuevo | Versión | Estado |
|----------|--------------|---------|--------|
| CNST_001 | NO Email bajo Ninguna Circunstancia | 1.0.0 | Recibido |
| CNST_002 | Sesiones BD, Única, Timeout 15 Minutos | 1.0.0 | Recibido |
| CNST_003 | BD IVR Readonly, ETL 6-12h, NO Real-Time | 1.0.0 | Recibido |
| CNST_004 | Alertas Buzón Interno, Máximo 50 Destinatarios | 1.0.0 | Recibido |
| CNST_005 | Modelo RBAC Flat + SoD + Permisos Temporales | 1.0.0 | Recibido |
| CNST_006 | Reportes: Rango Máximo 2 Años | 1.0.0 | Recibido |

Mencionados pero **no recibidos todavía** (referenciados en los textos):
- CNST_007 — Límites de exportación, throttling
- CNST_008 — Audit inmutable, logs sin PII

---

## Mapeo: nuevo ↔ existente

Para evitar pérdida de información, cada CNST_ nuevo se compara contra el catálogo existente:

| Nuevo (input) | Tema central | Existente más cercano | Coincidencia | Decisión recomendada |
|---------------|--------------|----------------------|--------------|---------------------|
| **CNST_001** "NO Email" | Prohibición de SMTP, todo por buzón interno | **CNST-001** "Comunicaciones Prohibidas" | **Total** — mismo tema, ámbito y origen | **Merge / actualizar in-place**: incorporar lo nuevo del input al archivo existente, bumpeando versión a 1.2.0 |
| **CNST_002** "Sesiones BD timeout 15m" | MySQL único almacén, sesión única, timeout 15min | **CNST-002** "Gestión Sesiones en BD" | **Alta** — el existente cubre BD/sesión única; el nuevo agrega "timeout 15min" explícito y modelo de datos detallado | **Merge in-place**: enriquecer el existente con el detalle nuevo |
| **CNST_003** "BD IVR readonly + ETL 6-12h" | Readonly del IVR, ETL batch, NO real-time | **CNST-003** "BD Dual Inmutable" + **CNST-004** "Actualización Datos ETL" | **Cubre dos archivos** | **NO merge directo**: el nuevo concentra dos áreas. Decidir: (a) dejar dividido como en el repo (CNST-003 = readonly, CNST-004 = ETL) e incorporar el contenido nuevo a ambos; (b) replantear como un solo archivo (más invasivo). Recomiendo **(a)** — preserva estructura |
| **CNST_004** "Alertas max 50" | Buzón interno + límite 50 destinatarios + consolidación + 15-min eval | **Sin equivalente directo** en el catálogo | **Nueva área** | **Crear archivo nuevo**: `CNST_011_Alertas_Buzon_Interno.rst` (siguiente número libre). Actualizar `index.rst` |
| **CNST_005** "RBAC Flat + SoD" | 44 funciones atómicas, 10 agrupadores, 3 SoD, 5 segmentos, permisos temporales | **CNST-005** "Seguridad DRF Checklist" — **DIFERENTE** | **Sin coincidencia** — CNST-005 actual es checklist DRF, no RBAC. RBAC está implícito en el `index.rst` ("Modelo RBAC v5.1.1") pero **no tiene archivo CNST propio** | **Crear archivo nuevo**: `CNST_012_RBAC_Flat_SoD_Permisos.rst`. Es **fundacional** — referenciado por todos los demás. Actualizar `index.rst`. Mantener CNST-005 actual sin tocar (es DRF, otro tema) |
| **CNST_006** "Reportes max 2 años" | Validación de rango temporal en reportes/exportaciones | **Sin equivalente directo**. CNST-007 (Performance SLA) y CNST-006 (Antipatrones) abordan otros aspectos | **Nueva área** | **Crear archivo nuevo**: `CNST_013_Reportes_Rango_Temporal.rst`. Actualizar `index.rst` |

### Resumen de la decisión propuesta

| Nuevo | Acción | Archivo destino |
|-------|--------|-----------------|
| CNST_001 (NO Email) | **Merge** | `CNST_001_Comunicaciones_Prohibidas.rst` (existente, bump 1.0.1 → 1.2.0) |
| CNST_002 (Sesiones 15m) | **Merge** | `CNST_002_Gestion_Sesiones_BD.rst` (existente, bump 1.0.1 → 1.1.0) |
| CNST_003 (IVR readonly + ETL) | **Merge en dos archivos** | `CNST_003_Base_Datos_Dual_Inmutable.rst` + `CNST_004_Actualizacion_Datos_ETL.rst` (ambos existentes) |
| CNST_004 (Alertas 50) | **Crear nuevo** | `CNST_011_Alertas_Buzon_Interno.rst` |
| CNST_005 (RBAC Flat) | **Crear nuevo** | `CNST_012_RBAC_Flat_SoD_Permisos.rst` |
| CNST_006 (Reportes 2y) | **Crear nuevo** | `CNST_013_Reportes_Rango_Temporal.rst` |

**Resultado tras integración:** 13 archivos CNST + index actualizado + posibles CNST_014, CNST_015 según lo que pase con CNST_007/CNST_008 pendientes del ejecutor.

---

## Conflicto de numeración (importante)

| ID en input | ID en repo | ¿Son lo mismo? |
|-------------|------------|----------------|
| CNST_001 | CNST-001 | Sí |
| CNST_002 | CNST-002 | Sí |
| CNST_003 | CNST-003 + CNST-004 | Cubre ambos |
| CNST_004 | (nuevo) | NO — `CNST-004` actual es ETL, distinto al "Alertas" del input |
| CNST_005 | (nuevo) | NO — `CNST-005` actual es DRF, distinto al "RBAC" del input |
| CNST_006 | (nuevo) | NO — `CNST-006` actual es Antipatrones, distinto al "Reportes" del input |

Los IDs del input **a partir del 4** colisionan con IDs ya tomados en el repo
con otros temas. **Por eso el plan es asignarles IDs nuevos (CNST_011+)**, no
sobrescribir los existentes ni renumerar (renumerar romperia los `:ref:` del
catálogo y de UCs/FRs/BRs que apuntan a `CNST-005`, `CNST-006` con sus
significados actuales).

---

## Consistencia con `:ref:` y links rotos

El input nuevo tiene referencias a:

- `:ref:` a UCs (`UC-003`, `UC-005`, `UC-006`, `UC-022`, `UC-036`, `UC-040`, `UC-050-053`, `UC-061-063`, `UC-070-072`)
- `:ref:` a funciones RBAC (`AUT-001..004`, `USR-001..010`, `ACC-001..006`, `PIP-001..004`, `RPT-001..008`, `ALR-001..006`, `AUD-001..004`, `LOG-001..002`)
- `:ref:` a CNST hermanos (`CNST_001`..`CNST_010`)
- Tablas ER y diagramas SQL — varios

De los **131 errores `Unknown target name`** identificados en Phase 1 DISCOVER del WP,
una parte significativa está aquí: el contenido nuevo declara refs que pueden no existir
en el repo. **Phase 4 CONSTRAINTS** decidirá: crear stubs vs corregir refs vs ambos.

---

## Riesgos del plan de integración

| ID | Riesgo | Severidad | Mitigación |
|----|--------|-----------|------------|
| RI-01 | Merge in-place borra contenido existente útil del repo (más detallado en algunos casos) | Alta | Para cada merge, hacer diff sección-por-sección; preservar lo del repo donde sea más completo |
| RI-02 | Renombrar IDs de input (CNST_004→CNST_011) confunde a quien lee solo el input | Media | Mantener tabla de mapeo en el archivo nuevo, en `index.rst`, y como "alias histórico" en metadata |
| RI-03 | Los 6 nuevos referencian funciones RBAC que el repo no tiene archivo dedicado para el RBAC en sí (solo en `index.rst` lo nombra) | Media | El nuevo CNST_012 (RBAC Flat) se vuelve fundacional; refs apuntarán a él |
| RI-04 | Bump de versión a 1.2.0 puede romper compatibilidad con tooling externo que assume 1.x estable | Baja | Documentar en CHANGELOG del WP la justificación |
| RI-05 | Los archivos nuevos del input incluyen modelo de datos SQL muy detallado — choque con docs ya existentes en `arquitectura_tecnica/` | Media | Phase 4 CONSTRAINTS define dónde va cada cosa: el modelo SQL puede pertenecer a `arquitectura_tecnica/`, no a `restricciones/` |

---

## Plantilla canónica

`source/normativa/estandares/plantillas/TPL_CNST_Restricciones_1_0_0.rst` define
la plantilla oficial. Cualquier CNST nuevo (incluido CNST_011, 012, 013) **debe
seguirla**. Phase 4 CONSTRAINTS confirmará la plantilla y comparará con el formato
del input para detectar desviaciones antes de Phase 10 EXECUTE.

---

## Próximos pasos sugeridos

1. **Esperar** los CNST_007 / CNST_008 pendientes del ejecutor (mencionados en el
   input). Repetir este análisis con el set completo.
2. **Phase 3 ANALYZE** completa: leer plantilla canónica, los 10 CNST existentes
   completos, mapear `:ref:` actuales del repo para conocer qué labels existen.
3. **Phase 4 CONSTRAINTS:** documentar las reglas de integración (merge vs
   create-new), política de numeración, política de `:ref:` no resueltas.
4. **Phase 5 STRATEGY:** decidir orden de integración (¿primero arregla refs
   rotas, luego mergea contenido? ¿en paralelo?). Diseñar el output esperado
   para alcanzar 0 warnings.
5. **Phase 6 SCOPE:** delimitar exactamente qué entra a este WP y qué se difiere.

---

## Pregunta abierta para el ejecutor

Antes de Phase 4 necesito tu confirmación sobre 3 puntos:

1. **¿Confirmás el plan de mapeo arriba?** (merge en CNST_001/002/003/004 existentes
   + crear CNST_011/012/013 para los nuevos).
2. **¿Está bien usar IDs CNST_011+ para los inputs sin equivalente?** Alternativa:
   pisar los actuales (CNST-005 DRF y CNST-006 Antipatrones) — riesgo alto.
3. **¿El input nuevo es la fuente de verdad final?** Si difiere del repo, ¿gana el
   input siempre o caso por caso?
