```yml
created_at: 2026-04-29 06:56:16
project: IACT-docs
work_package: 2026-04-29-06-56-16-source-compliance-audit
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Audit Source Compliance — Reporte Final

Auditoria completa de `source/` (381 archivos `.rst`) contra
3 ejes: STD_007, integracion temp-backup, referencias Sphinx.

## Resumen ejecutivo

| Eje | Status | Severidad |
|-----|--------|-----------|
| STD_007 cumplimiento | **0 violaciones** | OK |
| Integracion temp-backup | **3 gaps reales** + correcta mayoria | Media |
| Referencias Sphinx | **6 hyperlinks markdown** + uso parcial de directivas | Baja-Media |

Conclusion: `source/` esta **mayormente conforme**. Hay
gaps concretos identificados, todos accionables, ninguno
bloquea el build (que esta verde con 0 WARN/ERR/CRIT).

---

## Eje 1 — STD_007 Cumplimiento

### Checks ejecutados

| Check | Conteo | Resultado |
|-------|--------|-----------|
| Archivos con espacios en nombre | 0 | OK |
| Archivos con tildes/eñes | 0 | OK |
| Archivos con prefijo numerico (`01-X.rst`) | 0 | OK |
| Archivos `README.rst` / `TODO.rst` genericos | 0 | OK |
| Archivos con nombre > 100 chars | 0 | OK |
| Archivos con version en nombre (`_v1_0_0`) | 0 | OK |
| Total archivos `.rst` auditados | **381** | — |

### Veredicto

**STD_007: 100% cumplimiento en hard-checks.** La
limpieza de READMEs (commits `dbf1798`, `0e14c10`) y los
renames durante el saneamiento md→rst eliminaron todos los
casos prohibidos.

---

## Eje 2 — Integracion temp-backup

### Diff catalogado

`temp-backup/source-2026-04-28/` vs `source/`:

- 379 archivos `.rst` en temp-backup
- 381 archivos `.rst` en source
- 171 archivos en temp-backup NO estan en source
- 173 archivos en source NO estan en temp-backup (nuevos)

### Clasificacion por categoria

| Categoria | Conteo | Status |
|-----------|--------|--------|
| Renombrados por STD_007 | ~118 normativa + ~13 requisitos + 3 gestion = **~134** | **OK** — files exist with cleaner names |
| Diferidos como DEBT documentado | 14 arquitectura_tecnica/ subdirs (DEBT-004) | **OK — documentado** |
| Skeleton-first nuevos | 14 cajones (backend, frontend, databases, onboarding, quality, risks-technical-debt, gestion+pm) | **OK — creados** |
| **Gaps no documentados** | 3 categorias (ver abajo) | **A resolver** |

### Gap 1 — `plantuml-guide/` no migrado

**Severidad:** Media

8 archivos en `temp-backup/source-2026-04-28/plantuml-guide/`
no migraron a source/:

- `index.rst`
- `GUIDELINES.rst`
- `METADATA-STANDARD.rst`
- `color-palette.rst`
- `ejemplos/etl-pipeline.rst`
- `ejemplos/test-uc-diagram.rst`
- `ejemplos/sistema-completo.rst`
- `ejemplos/test-component-diagram.rst`

**Impacto:** la guia de PlantUML como cajon documentado se
perdio. Solo quedan 2 referencias dispersas
(`PROCED-GOB-006-generar-diagrama-uml-plantuml.rst`,
`ADR-GOB-002-plantuml-para-diagramas.rst`) y
`source/_static/plantuml-styles.puml`.

**No mencionado en `risks-technical-debt/deuda-tecnica-rebuild.rst`.**
Recomendacion: agregar como **DEBT-008** y migrar en iteracion
futura, o explicitamente decidir descartar (con justificacion).

### Gap 2 — ADRs incompletos en gobernanza

**Severidad:** Alta

- `temp-backup/source-2026-04-28/normativa/gobernanza/`: 19 ADRs
- `source/normativa/gobernanza/`: 8 ADRs

11 ADRs de gobernanza no migraron. Los ADRs son **decisiones
arquitectonicas inmutables** — perderlos sin trazabilidad rompe
el historial de razonamiento del proyecto.

**Recomendacion:**

```bash
diff <(ls temp-backup/source-2026-04-28/normativa/gobernanza/ADR*) \
     <(ls source/normativa/gobernanza/ADR*)
```

para identificar cuales y migrarlos. **No mencionado en deuda
tecnica actual.** Agregar como **DEBT-009** prioritario.

### Gap 3 — base_cognitiva glossaries consolidados sin trazabilidad

**Severidad:** Baja

- temp-backup tenia 3 archivos: `IACT_Glossary_v1_0_0.rst`,
  `glosario_babok_pmbok_iso.rst`, `glossary.rst`.
- source tiene 1: `glosario.rst`.

Posible consolidacion correcta (3 → 1) pero **sin nota de
migracion** que confirme que el contenido relevante se
preservo. Verificar que `glosario.rst` cubre los conceptos
de los 3 originales antes de descartar definitivamente.

---

## Eje 3 — Referencias Sphinx

### Inventario

| Tipo | Conteo | Adecuacion |
|------|--------|------------|
| `:doc:` | 217 | Bien usado para refs entre documentos |
| `:ref:` | 126 | Bien usado para anchors/labels |
| `:download:` | 0 | No aplica (no hay archivos para descargar) |
| `:file:` | 0 | **Subutilizado** (374 paths en backticks que podrian usarlo) |
| Hyperlinks markdown `[text](url.md)` | **6** | **INCORRECTO en RST** |
| Refs a `.md` en contenido literal | 795 | Mayormente OK (referencias conceptuales) |

### Problema 1 — Hyperlinks markdown en RST

**Severidad:** Media

6 hyperlinks markdown-style en 3 archivos `.rst`:

- `source/requisitos/casos_uso/permissions/UC_PERM_01_Asignar_Grupo_a_Usuario.rst` (3 ocurrencias)
- `source/normativa/procedimientos/PROCED-GOB-001-crear_adr.rst` (2 ocurrencias)
- `source/normativa/procedimientos/PROCED-GOB-002-actualizar_documentacion.rst` (1 ocurrencia)

**Patron incorrecto:**

```rst
- [Sistema de Permisos Granular](../backend/arquitectura/permisos-granular.md)
```

**Patron correcto** (segun guia del ejecutor):

```rst
- :doc:`Sistema de Permisos Granular </backend/arquitectura/permisos-granular>`
```

(O eliminar la referencia si el documento target no existe en
source/, ya que algunos apuntan a `.md` files que tampoco
existen en `source/`.)

**Por que el build pasa con 0 warnings:** Sphinx **no detecta
hyperlinks markdown como referencias rotas** — los renderiza
como texto literal con corchetes. Por eso no aparecen como
warnings, pero rompen la navegabilidad de la documentacion
HTML.

### Problema 2 — `:file:` subutilizado

**Severidad:** Baja

374 ocurrencias de paths en backticks (`` ``ruta/al/archivo`` ``)
que podrian usar `:file:` para semantica explicita:

```rst
ANTES: ``source/conf.py``
DESPUES: :file:`source/conf.py`
```

`:file:` es solo formateo (no genera link navegable), pero da
semantica clara y permite styling consistente. **No bloquea**
— mejora opcional.

---

## Recomendaciones priorizadas

### P1 — Migrar 11 ADRs faltantes en gobernanza (DEBT-009 propuesto)

Las decisiones arquitectonicas son inmutables; perder 11 de 19
sin trazabilidad rompe el historial. **Priorizar**.

Comando inicial:

```bash
diff <(ls temp-backup/source-2026-04-28/normativa/gobernanza/ | sort) \
     <(ls source/normativa/gobernanza/ | sort)
```

### P2 — Decidir status de plantuml-guide (DEBT-008 propuesto)

3 opciones:
- (a) Migrar los 8 archivos a `source/plantuml-guide/`.
- (b) Consolidar contenido relevante en
  `arquitectura_tecnica/diagrams/` o similar.
- (c) Descartar explicitamente con justificacion en
  `deuda-tecnica-rebuild.rst`.

### P3 — Reemplazar 6 hyperlinks markdown por `:doc:`

Trabajo concreto: editar 3 archivos. Fix manual rapido (~10 min).

### P4 — Verificar consolidacion de glossaries

Comparar `glosario.rst` actual contra los 3 originales en
temp-backup. Si falta contenido, mergear; si esta completo,
documentar la consolidacion.

### P5 — `:file:` adoption (opcional)

No urgente. Aplicable cuando se modifiquen archivos por otra
razon. No requiere WP propio.

---

## Trazabilidad

- WP `2026-04-28-01-58-08-source-rebuild-strategy` — origen
  del rebuild, consigna que algunos archivos quedan diferidos.
- WP `2026-04-28-05-28-46-source-rebuild-arquitectura-tecnica` —
  documenta DEBT-004 (15+ archivos pendientes en v2).
- `source/risks-technical-debt/deuda-tecnica-rebuild.rst` —
  registra DEBT-001..007. Agregar DEBT-008 (plantuml-guide) y
  DEBT-009 (ADRs faltantes) tras decision del ejecutor.

## Notas de auditoria

- Build status post-audit: `make clean && make html` → `build
  succeeded` con 0/0/0 (verificable). Los hallazgos no bloquean
  el build; son brechas de **completitud** y **navegabilidad**,
  no de validez sintactica.
- 173 archivos NUEVOS en source vs temp-backup confirman que
  el rebuild no es un mirror — es una re-arquitectura (skeleton
  cajones + WPs ligeros). Esperado segun strategy v2.0.
