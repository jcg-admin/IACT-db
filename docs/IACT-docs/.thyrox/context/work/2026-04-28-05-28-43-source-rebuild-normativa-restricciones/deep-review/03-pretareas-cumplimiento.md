```yml
created_at: 2026-04-28 13:45:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 1 — DISCOVER
author: claude
status: Aprobado
version: 1.0.0
```

# Deep-Review 03 — Cumplimiento de pre-tareas y D-CNST

**Alcance:** verificar que las 5 pre-tareas declaradas en `wp-state.md`, las 5
sub-decisiones D-CNST y los 2 riesgos heredados están cubiertos por los
artefactos del WP y reflejados en `source/normativa/restricciones/`.

**Fuentes consultadas (PROVEN):**
- `wp-state.md` (líneas 39-66)
- `discover/normativa-restricciones-analysis.md` (129 líneas)
- `discover/mapeo-viejo-nuevo.md` (55 líneas)
- `source/normativa/restricciones/` (11 .rst + index.rst — verificado con `ls | wc -l = 12`)
- `source/normativa/index.rst` (línea 39 incluye `restricciones/index`)
- grep `CNST_012|CNST-012` en `source/`

## Tabla de cumplimiento

### Pre-tareas (5)

| # | Pre-tarea | Cubierta en | Estado |
|---|-----------|-------------|--------|
| 1 | Lectura doc maestro RESTRICCIONES_COMPLETAS | analysis.md líneas 19, 25-38, 40-43 | Cumplida |
| 2 | Lectura propuesta ACTUALIZACION_DEL_ARBOL | analysis.md línea 20; deep-review 01 §"Ampliaciones v1.1.0" | Cumplida |
| 3 | Inspección v2.0.0 standalone | analysis.md líneas 21, 69-77 (D-CNST-3) | Cumplida |
| 4 | Mapeo source ↔ temp-holding ↔ doc maestro | analysis.md tabla "Mapeo conceptual" (líneas 25-38) | Cumplida |
| 5 | Tabla mapeo viejo→nuevo (input WP #6) | `discover/mapeo-viejo-nuevo.md` completo | Cumplida |

### Sub-decisiones D-CNST (5)

| ID | Decisión | Resolución registrada | Aplicada en source/ |
|----|----------|----------------------|---------------------|
| D-CNST-1 | Numeración nueva o backup | Backup canónico, gap cerrado por renumerado 012→011 (analysis.md:50-58) | Sí — 11 archivos consecutivos 001-011 |
| D-CNST-2 | CNSTs huérfanas | Ninguna huérfana conceptual; temp-holding subsumida (analysis.md:60-67) | Sí — no hay archivos extra |
| D-CNST-3 | v2.0.0 standalone | Descartado (regla de proceso, no del sistema) (analysis.md:69-77) | Sí — archivo no presente |
| D-CNST-4 | Llenar gap CNST_011 | Gap cerrado por renumerado 012→011, sin contenido inventado (analysis.md:79-84) | Sí — `CNST_011_RBAC_Flat_SoD_Permisos.rst` ocupa el slot |
| D-CNST-5 | Sub-categorías flat o agrupadas | Flat por número; agrupación por dominio en index.rst (analysis.md:86-93) | Sí — directorio plano + index con secciones por dominio (líneas 47-85) |

### Riesgos heredados (2)

| ID | Riesgo | Verificación |
|----|--------|--------------|
| R1 | WP #6 consume mapeo viejo→nuevo | `discover/mapeo-viejo-nuevo.md` entregado; sección "Cambios de referencia obligatorios para WP #6" explícita |
| R2 | Pérdida de CNST huérfana | D-CNST-2 valida no hay huérfanas conceptuales; tabla mapeo conceptual cubre 100% categorías del doc maestro (H-1 analysis.md:40) |

## Resoluciones aplicadas — verificación física

- **11 archivos .rst** en `source/normativa/restricciones/` (verificado: `ls *.rst | wc -l = 11`)
- **Numeración 001–011 sin gap** (verificado por listado de archivos)
- **`source/normativa/index.rst:39`** incluye `restricciones/index` en toctree
- **`source/normativa/restricciones/index.rst:32-42`** lista los 11 entries del toctree

## Hallazgos (≤8)

### F-1 — Referencia residual a `CNST_012` fuera del cajón [Medio]

`source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst:701`
contiene la cadena `CNST_012` — debería ser `CNST_011` tras la renumeración (D-CNST-1).

- Origen: grep `CNST_012` en `source/` retorna 1 hit fuera del cajón restricciones.
- Impacto: R1 — referencia rota cross-dominio que WP #6 (o el actual lector de RBAC)
  encontrará si no se corrige.
- Estado en analysis.md:126-128: declara "ningún archivo en `source/` actual referencia
  CNST_012" — claim contradicho por la evidencia.
- Acción recomendada: corregir `MTM_03_Metamodelo_RBAC.rst:701` a `CNST_011` en este
  WP antes de cierre, o documentar como dependencia hard a WP #6 / WP de base_cognitiva.

### F-2 — Claim de R3 en analysis.md no verificado [Bajo]

analysis.md:126-128 afirma "ningún archivo en `source/` actual referencia CNST_012"
sin grep registrado. Es claim INFERRED no PROVEN — y, como muestra F-1, es falso.

- Acción: re-clasificar claim a PROVEN con grep ejecutado, y actualizar conclusión.

### F-3 — Versión metadata declarada 1.1.0 sin confirmación física [Bajo]

`mapeo-viejo-nuevo.md:51` afirma "Versión metadata: 1.1.0". El bloque `.. meta::`
del index.rst muestra `:version: 1.1.0` (línea 7) — confirmado para el index, pero
no se incluyó muestreo de los 11 archivos individuales en este review.

- Acción: opcional — verificar consistencia 1.1.0 en los 11 .rst si no fue cubierto
  por deep-review 01.

## Recomendación final del agente

**NO CERRAR el WP** hasta resolver F-1.

Justificación:
- 5/5 pre-tareas cumplidas, 5/5 D-CNST resueltas y aplicadas, R2 mitigado.
- R1 (mapeo entregado a WP #6) está parcialmente mitigado: el documento de mapeo
  existe y es correcto, pero queda una referencia rota `CNST_012` en
  `MTM_03_Metamodelo_RBAC.rst:701` que invalida el supuesto de "todas las refs
  resueltas en migración" (analysis.md:128).
- Cerrar el WP con F-1 sin resolver propaga el riesgo R1 al WP #6 y al dominio
  base_cognitiva, contradiciendo el propósito de entregar un mapeo limpio.

**Acción mínima para cerrar:**
1. Corregir `MTM_03_Metamodelo_RBAC.rst:701` (`CNST_012` → `CNST_011`) o registrar
   explícitamente como out-of-scope con ticket cross-WP.
2. Actualizar analysis.md §"Riesgos identificados" R3 con el grep PROVEN y la nota
   sobre la referencia cross-dominio encontrada.

Tras estas dos acciones, el WP cumple las pre-condiciones de cierre y puede
avanzar al gate Stage 1 → Stage 2.
