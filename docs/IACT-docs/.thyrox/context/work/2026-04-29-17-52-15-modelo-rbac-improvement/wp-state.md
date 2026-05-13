```yml
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
type: Programa padre (multi-WP)
created_at: 2026-04-29 17:52:15
current_phase: Phase 5 — STRATEGY (decided Mode B)
flow: thyrox
methodology_step: program-coordinator
author: NestorMonroy
status: Activo (programa padre — cierra cuando Z.1..Z.5 cierren)
sub_wps:
  - Z.1: rbac-adr-superseding (pending open)
  - Z.2: rbac-modelo-conceptual-cleanup (blocked by Z.1)
  - Z.3: rbac-arq-mod-003-reconciliation (blocked by Z.2)
  - Z.4: rbac-bidirectional-traceability (blocked by Z.3)
  - Z.5: rbac-final-adversarial-validation (blocked by Z.4)
```

# WP — Modelo RBAC IACT Improvement

## Origen

Solicitud del ejecutor: mejorar
`source/arquitectura-tecnica/rbac/modelo-rbac-iact.rst` (2558 líneas).
Es el documento autoritativo del modelo de control de acceso del
proyecto, referenciado desde múltiples artefactos del corpus.

## Objetivo

Mejorar el documento. Antes de proponer cambios concretos, este WP
ejecuta un análisis del estado actual:

- **Qué contiene** hoy (mapa de secciones, longitud, profundidad).
- **Qué se espera** que tenga (per CNST_*, ADR_GOB_008, GOB_*,
  convenciones de arquitectura técnica).
- **Brechas observables** entre uno y otro.
- **Refs entrantes** desde otros artefactos (qué partes son
  consumidas externamente y NO se pueden remover sin cascading
  break).

## Acceptance criteria (Phase 1 DISCOVER)

- [ ] Mapa de secciones del documento actual con líneas y tipo.
- [ ] Inventario de refs `:doc:`, `:ref:`, menciones textuales
      entrantes.
- [ ] Lista de artefactos del corpus que el modelo cita y que lo
      citan (cross-refs bidireccionales).
- [ ] Análisis de cumplimiento contra:
  - STD_007 v2.0.2 (filename/dir kebab-lowercase, schema metadata)
  - STD_001 v2.1.0 (sin emojis, ASCII)
  - CNST_029 (RBAC modelo plano)
  - CNST_032 (menú dinámico obligatorio)
  - CNST_033 (vocabulario unificado RBAC)
  - ADR_GOB_008 (RBAC coexistencia ACC ↔ PERM)
- [ ] Gap analysis: qué falta, qué está obsoleto, qué está correcto.
- [ ] Decisión del ejecutor sobre el plan de mejora antes de
      Phase 5 STRATEGY.

## Riesgos identificados

| Riesgo | Mitigación |
|--------|-----------|
| Romper refs entrantes al reorganizar secciones | Inventory previo + preservar `.. _label:` actuales |
| Modelo está vivo (CNSTs cambian) — el doc puede divergir | Identificar qué partes están versionadas en CNSTs (autoritativas) vs documentadas en el modelo (descriptivas) |
| Documento de 2558 líneas — refactor masivo es de alto costo | Phase 1 DISCOVER define scope antes de planear |

## Estructura del WP

```
2026-04-29-17-52-15-modelo-rbac-improvement/
├── wp-state.md
├── discover/
│   ├── current-structure-map.md        # mapa de secciones actuales
│   ├── inbound-refs-inventory.md       # quién cita al modelo
│   ├── expected-content-spec.md        # qué debería contener
│   └── modelo-rbac-gap-analysis.md     # síntesis Phase 1
├── analyze/                            # (Phase 3)
├── plan/                               # (Phase 6)
├── plan-execution/                     # (Phase 8)
└── track/                              # cierre
```

## Próximo paso

Bloque DISCOVER:

- T-001 Inspeccionar estructura actual del modelo (secciones, líneas,
  metadata).
- T-002 Inventariar refs entrantes (`:doc:`, `:ref:`, menciones
  textuales).
- T-003 Identificar contenido esperado per convenciones del proyecto.
- T-004 Producir gap analysis.
- T-005 Síntesis para revisión del ejecutor.
