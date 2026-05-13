```yml
created_at: 2026-04-28 15:30:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 12 — STANDARDIZE (post-cierre — convencion)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Convencion: Pre-staging de inputs por WP

## Problema

En el WP #4 (normativa-restricciones) se invirtio tiempo significativo
buscando informacion relevante en `temp-backup/` y `temp-holding/`
para alimentar el analisis. Los 65 MB de `temp-holding/` con ~3 433
archivos generaban exploraciones repetidas y costosas en tokens
para cada WP-hijo.

## Solucion: pre-staging de inputs por WP

Cada WP-hijo recibe en `inputs/` una copia local de los documentos
relevantes ANTES de iniciar Phase 1 DISCOVER. El analisis del WP
solo consulta `inputs/`, no `temp-holding/` ni `temp-backup/`
directamente.

## Estructura

```
.thyrox/context/work/{wp}/
├── inputs/                       ← pre-staged
│   ├── INPUTS_INVENTORY.md       ← inventario con origen, hash, decision
│   ├── canonical/                ← un archivo por concepto (MD5 dedup)
│   │   └── {basename}.md
│   └── variants/                 ← contenidos diferentes con mismo nombre
│       └── temp-holding/FASE 01/.../{basename}.md
├── discover/
├── analyze/
└── wp-state.md
```

## Reglas de dedup

1. **Hash MD5** de todos los candidatos por nombre.
2. **MD5 identicos** → un solo archivo en `canonical/` con la jerarquia
   de preferencia abajo. Resto se cuenta como `dups_collapsed` en el
   inventario.
3. **MD5 distintos** (mismo nombre, contenido diferente) → todas las
   variantes a `variants/{ruta-espejo-del-origen}` para preservar
   trazabilidad.

## Jerarquia de preferencia para canonicos

1. `temp-backup/source-2026-04-28/` (canonico Idea 1 de la estrategia)
2. `temp-holding/FASE 02/`
3. `temp-holding/FASE 01/`
4. `temp-holding/RBAC/`
5. `temp-holding/GENERACION_DOCUMENTACION/`

## Exclusiones por defecto

Carpetas que NO entran al staging por ser duplicados conocidos o
referencia externa:

- `temp-holding/GENERACION_DOCUMENTACION/IACT_Backup_Completo_2026-01-11-old/`
- `temp-holding/GENERACION_DOCUMENTACION/IACT_Backup_Completo_2026-01-11/`
- `temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_2026-01-13_OK/`
- `temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/`
- `temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_2026-01-13/`
- `temp-holding/Sphinx (documentation generator)/`

## Resultado actual

| WP | Canonicos | Variantes | Total |
|----|-----------|-----------|-------|
| base-cognitiva | 234 | 41 | 275 |
| normativa-estandares | 33 | 2 | 35 |
| normativa-procedimientos | 82 | 0 | 82 |
| normativa-restricciones | 35 | 0 | 35 |
| normativa-gobernanza | 349 | 74 | 423 |
| requisitos | 185 | 20 | 205 |
| arquitectura-tecnica | 117 | 7 | 124 |
| backend | 277 | 126 | 403 |
| frontend | 31 | 15 | 46 |
| infrastructure | 205 | 236 | 441 |
| databases | 5 | 0 | 5 |
| operations | 203 | 4 | 207 |
| onboarding | 8 | 0 | 8 |
| quality | 6 | 0 | 6 |
| risks-technical-debt | 1 | 0 | 1 |
| gestion | 10 | 5 | 15 |
| **Total** | **2 311** | | |

83 duplicados colapsados (mismo MD5, distintos paths).

## Uso

1. **Apertura de WP-hijo:** primer paso de Phase 1 DISCOVER es leer
   `inputs/INPUTS_INVENTORY.md` para conocer el inventario.
2. **Analisis:** consultar SOLO archivos en `inputs/canonical/` y
   `inputs/variants/`. No buscar en `temp-*` directo.
3. **Si falta algo:** documentar el gap en `analyze/inputs-gap.md`,
   actualizar la regla en `/tmp/stage_inputs.py` y re-ejecutar el
   staging para el WP afectado.

## Reglas de mantenimiento

- **Routing map central:** `analyze/inputs-routing-map.md` en el WP
  padre `source-rebuild-strategy`. Documenta qué carpeta va a qué WP.
- **Re-ejecucion:** si `temp-*` cambia o se agregan reglas, re-ejecutar
  `stage_inputs.py` regenera todos los `inputs/` desde cero.
- **No commitear `temp-*`:** las carpetas `temp-backup/` y
  `temp-holding/` siguen existiendo en local pero NO se commitean.
  Los `inputs/` SI se commitean (estan dentro de `.thyrox/context/`).

## Beneficios

- Reduccion de tokens: agentes de analisis solo ven los archivos
  relevantes, no 3 433 archivos de temp-*.
- Trazabilidad: el inventario indica origen exacto de cada archivo.
- Reproducibilidad: si temp-* cambia, los WPs ya cerrados conservan
  su input historico tal como se uso.
- Aislamiento: cada WP tiene su universo de inputs independiente.
