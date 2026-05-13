```yml
created_at: 2026-04-29 19:15:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 5 — STRATEGY
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Program Decision — Mode B (Particionado en 5 sub-WPs)

## Decisión

**Aprobada: Modo B** (Z particionado en 5 sub-WPs encadenados).

Documentación de respaldo: `analyze/z-monolithic-vs-partitioned.md`.

## Este WP se convierte en programa padre

`2026-04-29-17-52-15-modelo-rbac-improvement` deja de ser un WP de
ejecución y pasa a ser **WP padre del programa RBAC hardening**.
Sus artefactos `discover/` + `analyze/` quedan como **fuente
heredable** para los 5 sub-WPs hijos.

Este WP no avanza a Phase 6 PLAN ni Phase 10 EXECUTE — su rol es
ser **el contenedor del programa**. Cierra cuando los 5 hijos cierren.

## Sub-WPs a ejecutar (en orden secuencial estricto)

| Sub-WP | Foco | Inconsistencias | Dependencias |
|--------|------|-----------------|--------------|
| **Z.1** | RBAC ADR Superseding | Inc-01, Inc-02, Inc-03 | Ninguna (puede ejecutar YA) |
| **Z.2** | Modelo Conceptual Cleanup | F-01..F-21 + C-01..C-05 | Z.1 cerrado (necesita vocabulario canónico estable) |
| **Z.3** | Reconciliación modelo ↔ ARQ_MOD_003 | Inc-04 | Z.1 + Z.2 cerrados |
| **Z.4** | Trazabilidad Bidireccional | Inc-05 | Z.1 + Z.2 + Z.3 cerrados |
| **Z.5** | Validación Adversarial Final | (validación) | Z.1 + Z.2 + Z.3 + Z.4 cerrados |

## Z.1 — RBAC ADR Superseding (próximo a abrir)

**Problema que cierra:** los 3 ADR-BACK legacy (001/003/004) violan
CNST-033 vigente y citan cifras divergentes del modelo v5.2.1. Esto
es deuda normativa **activa**, no solo pre-implementación.

**Acceptance criteria preliminar:**

- [ ] ADR(s) nuevos crean superseding formal de ADR-BACK-001/003/004.
- [ ] ADRs nuevos alineados al vocabulario canónico de CNST-033
      ("Función" / "Function").
- [ ] ADRs nuevos consistentes con cifras del modelo v5.2.1
      (42 funciones / 10 grupos AGR).
- [ ] ADR-BACK-001/003/004 marcados como `:estado: Superseded by
      ADR-NNN` (no eliminados — preservar trazabilidad histórica).
- [ ] Notas in-text "pendiente validar" en ADR-BACK-003/004 quedan
      resueltas (ya sea respondiéndolas en los nuevos ADRs o
      formalmente abandonándolas).
- [ ] Cross-refs entre los nuevos ADRs y modelo + CNST-033 + ADR-GOB-008.
- [ ] Build verde 0/0/0.

**Estimación:** 1 sesión (~2-3h).

## Z.2..Z.5 — overview

Los detalles de cada sub-WP se elaborarán en su propia Phase 1
DISCOVER (heredando del program WP). NO se pre-planifica aquí para
preservar el principio THYROX de "DISCOVER antes de planificar"
(I-001).

Lo que sí se sabe hoy:

- **Z.2:** scope tentativo es F-01..F-21 + C-01..C-05 del gap
  analysis. Etiquetado del código embebido como "Reference design".
  Estimación 1 sesión.

- **Z.3:** mayor incertidumbre. Pregunta abierta: ¿modelo conceptual
  PURO (sin código) + ARQ_MOD_003 con la spec técnica? ¿O
  consolidación? Phase 1 DISCOVER de Z.3 lo decide.
  Estimación 1-2 sesiones.

- **Z.4:** mecánico. Cross-refs en ambos sentidos modelo ↔ ADRs ↔
  CNSTs ↔ UCs. Estimación 1 sesión.

- **Z.5:** validación. Re-correr deep-review adversarial completo
  + verificar single source of truth + cierre formal de programa.
  Estimación 0.5 sesión.

## Total estimado del programa

**~5-6 sesiones** distribuidas en Z.1..Z.5.

## Política de cierre del programa padre

Este WP padre cierra cuando se cumplan TODOS:

- Los 5 sub-WPs cerrados con build verde.
- Re-audit final (Z.5) confirma que las 5 inconsistencias
  Inc-01..Inc-05 están en 0 violaciones.
- Changelog del programa padre consolida los 5 changelogs hijos.
- Decisión del ejecutor: "cerrar programa".

## Próximo paso operativo

**Abrir Z.1** con timestamp propio + estructura WP completa.
Z.1 hereda los discover/ + analyze/ de este WP padre por
referencia.
