```yml
created_at: 2026-04-28 15:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-53-source-rebuild-quality
phase: Phase 1 — DISCOVER (input staging)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Inputs Inventory — WP quality

Documentos pre-staged desde `temp-backup/` y `temp-holding/`. Solo estos archivos deben consultarse para el analisis de este WP — evita buscar en todo `temp-*`.

## Convencion

- `canonical/` — un solo archivo por concepto (MD5 deduplicado, preferencia: temp-backup > FASE 02 > FASE 01).
- `variants/` — archivos con mismo nombre pero contenido distinto, ruta espejo del origen para desambiguar.

## Resumen

- Canonicos: **6**
- Variantes: **0**
- Duplicados colapsados: **0**

- Tamano total stage: 39,211 bytes (38.3 KB)

## Canonicos

| Destino | Origen elegido | Hash | Bytes | Dups colapsados |
|---------|---------------|------|-------|----------------|
| `canonical/FASE 11 PARTE_5 - COMPLETADA.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 11/FASE 11 PARTE_5 - COMPLETADA.txt` | b3de54f6 | 2,581 | 0 |
| `canonical/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 11/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md` | 01f218ef | 28,245 | 0 |
| `canonical/RESUMEN_FASE_11.md` | `temp-holding/GENERACION_DOCUMENTACION/FASE 11/RESUMEN_FASE_11.md` | 1504b812 | 5,069 | 0 |
| `canonical/estado_generacion.txt` | `temp-holding/GENERACION_DOCUMENTACION/FASE 11/estado_generacion.txt` | 2b1a4081 | 2,470 | 0 |
| `canonical/pytest.ini` | `temp-holding/FASE 01/docs/pytest.ini` | a66c129d | 652 | 0 |
| `canonical/quality.md` | `temp-holding/project/quality.md` | b3690bb2 | 194 | 0 |

