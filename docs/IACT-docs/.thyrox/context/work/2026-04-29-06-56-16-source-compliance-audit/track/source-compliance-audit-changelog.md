```yml
created_at: 2026-04-29 06:56:16
project: IACT-docs
work_package: 2026-04-29-06-56-16-source-compliance-audit
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP-changelog: source-compliance-audit

## Added

- `wp-state.md` — proposito, acceptance criteria, status.
- `analyze/audit-source-compliance.md` — reporte completo
  con 3 ejes de auditoria, hallazgos clasificados por
  severidad, 5 recomendaciones priorizadas (P1-P5).
- `track/source-compliance-audit-changelog.md` — este archivo.

## Hallazgos principales

### Eje 1 — STD_007: 100% cumplimiento

381 archivos `.rst` auditados. 0 violaciones en hard-checks
(espacios, tildes, prefijos numericos, README/TODO genericos,
>100 chars, version en filename).

### Eje 2 — temp-backup integration: 3 gaps reales

- **Gap 1 — plantuml-guide/** (Severidad Media): 8 archivos
  no migrados, no documentados como deuda. Proponer DEBT-008.
- **Gap 2 — ADRs gobernanza** (Severidad Alta): 11 de 19 ADRs
  no migraron. Decisiones arquitectonicas inmutables sin
  trazabilidad. Proponer DEBT-009 prioritario.
- **Gap 3 — base_cognitiva glossaries** (Severidad Baja):
  consolidacion 3→1 sin nota de migracion. Verificar.

Resto de las 171 diferencias temp-backup → source son
renombrados correctos por STD_007 (~134), diferidos
documentados en DEBT-004 (~14), o nuevos skeletons (esperado).

### Eje 3 — Referencias Sphinx

- 217 `:doc:` + 126 `:ref:` — uso correcto de directivas.
- **6 hyperlinks markdown** `[text](url.md)` en 3 archivos
  (UC_PERM_01, PROCED-GOB-001, PROCED-GOB-002). Severidad
  Media — Sphinx los renderiza como texto literal, rompe
  navegabilidad pero no genera warnings.
- 374 paths en backticks que podrian usar `:file:` (mejora
  opcional, no urgente).
- 0 usos de `:download:` (no aplica — no hay archivos
  descargables).

## Status de promocion a CHANGELOG.md raiz

No aplica. Este WP es solo auditoria — no produce cambios en
`source/`. Los hallazgos quedan como inputs para WPs futuros.

## Aceptado / no fixeado

Ningun fix se ejecuta en este WP por diseño. Las 5
recomendaciones (P1-P5) requieren decisiones del ejecutor:
- P1: migrar ADRs (alto valor, 1-2h trabajo)
- P2: decidir destino de plantuml-guide (3 opciones)
- P3: fix de 6 hyperlinks markdown (10 min)
- P4: verificar glossaries
- P5: adopcion `:file:` (opcional)

## Trazabilidad

- WP padre: `2026-04-28-01-58-08-source-rebuild-strategy`
  (origen del rebuild que motivo esta auditoria).
- WP relacionado: `2026-04-29-05-35-11-md-to-rst-saneamiento`
  (saneamiento previo que produjo el corpus actual de
  source/).
- Politica auditada: `source/normativa/estandares/STD_007_Convencion_Naming.rst`.

## Hito meta

Este WP demuestra el patron correcto cuando se necesita
verificar conformidad sin tocar el corpus:

1. DISCOVER ligero (entender ejes a auditar).
2. ANALYZE pesado (ejecutar checks, clasificar hallazgos).
3. **Sin EXECUTE** — el WP cierra con recomendaciones, no
   con cambios.

Las decisiones de ejecutar P1-P5 quedan al ejecutor; cada uno
puede generar su propio mini-WP si requiere coordinacion.
