```yml
project: IACT-docs
work_package: 2026-04-30-04-11-28-md-references-audit
created_at: 2026-04-30 04:11:28
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Open
```

# WP — Auditoría de referencias `.md` en source/

## Estado actual

**Phase 1 DISCOVER iniciado.** Inventario completado.

## Objetivo

Identificar y remediar las 832 referencias a archivos `.md` en
source/ (sitio Sphinx publicado) que Sphinx NO valida y pueden
producir links rotos silenciosos en el sitio publicado.

## Hallazgos clave (línea base)

- **832 ocurrencias** de `.md` en source/
- **107 archivos `.rst`** afectados
- **511 paths `.md` únicos** referenciados
- **89% concentrado en `normativa/`** (ADRs y procedimientos)
- **Sphinx NO falla** el build aunque los archivos no existan
  porque trata hyperlinks RST a `.md` como links externos

## Categorización (análisis en discover/md-references-discovery.md)

| TIPO | Sintaxis | Cantidad | Riesgo |
|------|----------|----------|--------|
| A | `` `Texto <file.md>`__ `` | 150 | ALTO — link clickeable rota → 404 |
| B | `` ``file.md`` `` | 177 | MEDIO — confusión si nombre obsoleto |
| C | Texto plano | ~505 | BAJO — narrativa |

## Origen probable

1. Migración incompleta `.md` → `.rst`: refs internas no actualizadas.
2. Convivencia con templates/checklists `.md` fuera de source/.
3. Referencias a `temp-holding/` (4 ocurrencias).
4. Referencias a artefactos externos (README, CHANGELOG: 33 ocurrencias).

## Plan de remediación

Detallado en `discover/md-references-discovery.md` § "Plan de
remediación propuesta".

Resumen de fases:

1. **MEASURE** (Phase 2): script para validar existencia real
   de cada uno de los 511 paths únicos.
2. **ANALYZE** (Phase 3): clasificar por motivo de rote.
3. **CONSTRAINTS** (Phase 4): declarar política de refs en STD-007.
4. **STRATEGY** (Phase 5): decidir crear vs reemplazar.
5. **PLAN-EXECUTE** (Phase 6-8): task plan + ejecución.

## Métricas de éxito

- 0 hyperlinks RST a `.md` inexistentes en source.
- 0 referencias citacionales rotas.
- Política documentada en STD.
- CI checker que detecta hyperlinks a `.md` rotos.

## Relación con WP padre

Este WP se abrió como hallazgo del WP rbac-modelo-conceptual-cleanup
durante la auditoría final v5.4.0. Es **independiente**: el WP padre
puede cerrarse antes de completar éste.

## Riesgos

| Riesgo | Mitigación |
|--------|------------|
| Volumen alto (511 paths) | Triaje automatizado con script |
| 89% concentrado en `normativa/` | Fixes pueden requerir auditoría de procesos documentales |
| Algunos `.md` referenciados pueden ser legítimos | Política debe permitir excepciones declaradas explícitamente |

## Próximo paso

Cuando se reanude: Phase 2 MEASURE — script Python que valida
existencia de cada uno de los 511 paths y produce reporte de
"existen vs no existen vs ambiguos".

## Trazabilidad

- WP padre: `2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup`
- Documento DISCOVER: `discover/md-references-discovery.md`
