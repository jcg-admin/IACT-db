```yml
created_at: 2026-04-29 09:39:48
project: IACT-docs
work_package: 2026-04-29-09-39-48-emoji-tables-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Emoji & Iconos Audit — STD_001 Compliance

Scan automatizado con `/tmp/emoji_audit.py` sobre 381 archivos
`.rst`. Whitelist tecnica: `→ ← ↑ ↓ ⇒ ⇐ ⇔ °` (flechas estructurales
y signo grado en contextos matematicos).

## Resumen ejecutivo

| Metrica | Valor |
|---------|-------|
| Archivos con emoji/icono no-whitelisted | **78** |
| Ocurrencias totales | **1373** |
| Caracter mas frecuente | `☐` (705 ocurrencias) — checkbox |

## Conteo por caracter (top 20)

| Char | Code point | Frecuencia | STD_001 §  | Veredicto |
|------|-----------|-----------:|-----------|-----------|
| `☐` | U+2610 | 705 | §3.2 (Iconos Unicode) | **PROHIBIDO** — usar `[ ]` o `\ ` (literal) |
| `✓` | U+2713 | 214 | §3.2 | **PROHIBIDO** — usar `OK` o `SI` |
| `✅` | U+2705 | 128 | §3.1 (Emoji) | **PROHIBIDO** |
| `✗` | U+2717 | 60 | §3.2 | **PROHIBIDO** — usar `NO` o `X` |
| `❌` | U+274C | 34 | §3.1 | **PROHIBIDO** |
| `☒` | U+2612 | 31 | §3.2 | **PROHIBIDO** |
| `↔` | U+2194 | 25 | (whitelist?) | flecha — re-evaluar |
| `⚠` | U+26A0 | 23 | §3.1 | **PROHIBIDO** |
| `⏳` | U+23F3 | 15 | §3.1 | **PROHIBIDO** |
| `🔴` | U+1F534 | 12 | §3.1 | **PROHIBIDO** |
| `🔄` | U+1F504 | 8 | §3.1 | **PROHIBIDO** |
| `♦` | U+2666 | 7 | §3.2 | **PROHIBIDO** |
| `🚀` | U+1F680 | 6 | §3.1 | **PROHIBIDO** |
| `📁` | U+1F4C1 | 5 | §3.1 | **PROHIBIDO** |
| `⏰` | U+23F0 | 5 | §3.1 | **PROHIBIDO** |
| `☑` | U+2611 | 5 | §3.2 | **PROHIBIDO** |
| `🟡` | U+1F7E1 | 4 | §3.1 | **PROHIBIDO** |
| `📢` | U+1F4E2 | 4 | §3.1 | **PROHIBIDO** |
| `★` | U+2605 | 4 | §3.2 | **PROHIBIDO** |
| `🟢` | U+1F7E2 | 3 | §3.1 | **PROHIBIDO** |

## Top 20 archivos afectados

| Ocurr. | Archivo |
|-------:|---------|
| 133 | `gestion/pm/checklists/checklists-pm.rst` |
| 107 | `normativa/estandares/STD_001_Estandares_Documentacion_Sin_Emojis.rst` |
|  77 | `normativa/procedimientos/PROCED-GOB-001-crear_adr.rst` |
|  76 | `normativa/procedimientos/PROCED-GOB-003-documentar-regla-negocio.rst` |
|  76 | `gestion/git-workflow.rst` |
|  63 | `normativa/procedimientos/PROC-GOB-008-reorganizacion-estructura-documental.rst` |
|  58 | `normativa/procedimientos/PROCED-GOB-004-crear-caso-uso.rst` |
|  56 | `normativa/procedimientos/PROCED-GOB-005-analisis-impacto-cambios.rst` |
|  49 | `normativa/procedimientos/PROCED-GOB-006-generar-diagrama-uml-plantuml.rst` |
|  39 | `normativa/gobernanza/ADR-FRONT-010-typescript-adopcion-gradual.rst` |
|  36 | `normativa/procedimientos/procedimiento-revision-documental.rst` |
|  36 | `normativa/estandares/estandares-codigo.rst` |
|  34 | `normativa/procedimientos/guia-completa-desarrollo-features.rst` |
|  31 | `normativa/procedimientos/PROCED-DEV-002-code_review.rst` |
|  30 | `normativa/procedimientos/PROCED-GOB-007-consolidacion-ramas-git.rst` |
|  27 | `normativa/procedimientos/procedimiento-release.rst` |
|  26 | `normativa/gobernanza/ADR-GOB-004-clasificacion-reglas-negocio.rst` |
|  25 | `normativa/procedimientos/PROCED-DEVOPS-001-deploy_staging.rst` |
|  24 | `normativa/procedimientos/PROCED-GOB-002-actualizar_documentacion.rst` |
|  24 | `normativa/procedimientos/PROCED-QA-001-ejecutar_tests.rst` |

## Analisis por categoria

### Excepciones legitimas (NO violar STD_001)

- **STD_001 mismo (107 ocurrencias)**: el archivo del estandar
  contiene los caracteres prohibidos como ejemplos dentro de
  bloques `.. code-block:: text`. Esto es valido — el documento
  documenta las prohibiciones citando los caracteres prohibidos.

### Violaciones reales (1266 ocurrencias estimadas)

Quitando STD_001 (107 — excepcion documental), quedan ~1266
ocurrencias en 77 archivos. Categorias dominantes:

1. **Checkboxes en checklists (~705 `☐` + 31 `☒` + 5 `☑`)**:
   - Reemplazo: `[ ]` (no marcado), `[x]` (marcado).
   - Afecta principalmente `checklists-pm.rst`,
     `PROCED-GOB-*`, `procedimiento-*`.

2. **Status indicators (~322 `✓✗✅❌`)**:
   - Reemplazo: `OK / NO / SI / X` literal o tablas con
     columna `Estado`.
   - Afecta procedimientos y ADRs.

3. **Emojis decorativos (~158 ⚠⏳🔴🚀📁⏰📢★🟢🟡 etc.)**:
   - Reemplazo: prefijos textuales segun STD_001 §4.1
     (`[NOTA]`, `[ALERTA]`, `[IMPORTANTE]`, `[FAIL]`).
   - Afecta procedimientos y ADRs nuevos migrados desde
     temp-backup (no fueron limpiados en la migracion).

## Recomendaciones

### P1 — Limpiar 78 archivos en batch (Alta prioridad)

Severidad: el corpus actual viola STD_001 en ~1266 ocurrencias.
La politica esta aprobada y vigente; el corpus no la cumple.

**Estrategia recomendada (siguiendo `mechanical-bulk-edits.md`):**

1. **Diagnose**: regla = sustituir 20 caracteres mas frecuentes
   por equivalente textual.
2. **Pilot**: aplicar a 1 archivo (ej. `checklists-pm.rst`),
   revisar render HTML y diff.
3. **Measure baseline**: 1373 ocurrencias.
4. **Apply + Measure**: aplicar global, contar ocurrencias
   restantes (deberian ser solo las del STD_001 = 107).
5. **Regression check**: build limpio post-fix.

Tabla de sustituciones:

| Antes | Despues |
|-------|---------|
| `☐` | `[ ]` |
| `☒` `☑` | `[x]` |
| `✓` `✅` | `OK` (en tablas), `[OK]` (en texto) |
| `✗` `❌` | `NO` (en tablas), `[NO]` (en texto) |
| `⚠` | `[ALERTA]` |
| `⏳` `⏰` | `[PENDIENTE]` o `[EN_CURSO]` |
| `🔴` | `[CRITICO]` |
| `🟡` | `[MEDIO]` |
| `🟢` | `[BAJO]` o `[OK]` |
| `🚀` | `[INICIO]` |
| `📁` | `[CARPETA]` (raro — re-evaluar) |
| `★` | `[IMPORTANTE]` |
| Otros | re-evaluar caso a caso |

### P2 — Excepcion documental para STD_001

Mantener el archivo `STD_001_Estandares_Documentacion_Sin_Emojis.rst`
intacto. Sus 107 ocurrencias son **legitimas**: documentan los
caracteres prohibidos como ejemplos dentro de
`.. code-block:: text`.

Agregar nota en el frontmatter del archivo o en STD_001 §1
explicando esta excepcion para evitar futuros falsos positivos
en auditorias.

### P3 — Whitelist tecnica documentada

Confirmar/expandir whitelist en STD_001 (actualmente solo flechas
y grado). Candidatos a evaluar:

- `↔` (25 ocurrencias) — flecha bidireccional, posible whitelist.
- `°` — signo grado en contextos tecnicos.
- Caracteres en ecuaciones matematicas dentro de `.. math::`
  (ya excepcion §3.4).

## Trazabilidad

- Politica auditada: `source/normativa/estandares/STD_001_Estandares_Documentacion_Sin_Emojis.rst`
- Detalle JSON: `/tmp/emoji_hits.json` (78 archivos con sus chars)
- Script: `/tmp/emoji_audit.py`
