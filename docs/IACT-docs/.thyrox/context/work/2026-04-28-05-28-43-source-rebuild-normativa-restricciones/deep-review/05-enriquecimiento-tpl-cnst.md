```yml
created_at: 2026-04-28 14:45:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 11 — TRACK (deep-review post enriquecimiento)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep-Review 05 — Enriquecimiento estructura TPL_CNST

## Premisa

Tras el deep-review 04 que confirmó atomicidad SRP, se detectó que los
31 CNSTs no aplicaban las **9 secciones obligatorias** que la
plantilla `TPL_CNST_Restricciones.rst` declara como standard
canónico. El usuario solicitó enriquecer cada archivo con la
estructura completa, manteniendo el SRP.

Este deep-review verifica el resultado del enriquecimiento.

## Insumos consumidos para el enriquecimiento

| Documento | Hallazgos integrados |
|-----------|----------------------|
| `analyze/single-responsibility-analysis.md` | Atomicidad por dominio (10 dominios) |
| `analyze/temp-holding-exhaustive-search.md` | Verificación que no hay CNSTs adicionales |
| `analyze/base-cognitiva-cnst-references.md` | Tipología 3 ejes (TXM_01), trazabilidad CNST→BR |
| `analyze/temp-holding-cross-wp-debt.md` | UCs (14), MODs, parámetros cuantitativos (23), excepciones |
| `analyze/cross-wp-debt-summary.md` | Síntesis y plan de remediación |

## Verificación de las 9 secciones obligatorias

| Sección obligatoria de TPL_CNST | Cumplimiento (31 archivos) |
|----------------------------------|---------------------------|
| 0. Resumen Ejecutivo (tabla con ID/Categoria/Tipo/Criticidad/Negociable/Estado) | 31/31 ✓ |
| 1.1 Enunciado | 31/31 ✓ |
| 1.2 Justificación | 31/31 ✓ |
| 1.3 Origen (Fuente/Documento/Fecha) | 31/31 ✓ |
| 2.1 Descripción Detallada | 31/31 ✓ |
| 2.2 Parámetros | 31/31 ✓ |
| 2.3 Tecnologías Involucradas | 31/31 ✓ |
| 3.1 Módulos Afectados | 31/31 ✓ |
| 3.2 Casos de Uso Afectados | 31/31 ✓ |
| 3.3 Lo que NO se puede hacer | 31/31 ✓ |
| 4. Business Rules Derivadas | 31/31 ✓ (con placeholder cross-WP cuando no documentado) |
| 5.1 Código de Referencia | 31/31 ✓ |
| 5.2 Validación de Cumplimiento | 31/31 ✓ |
| 6.1 Excepciones Permitidas | 31/31 ✓ |
| 6.2 Proceso de Excepción | 31/31 ✓ (con referencia a PROC_Excepciones_CNST pendiente) |
| 7.1 Criterios de Cumplimiento | 31/31 ✓ |
| 7.2 Método de Verificación (Tipo/Frecuencia/Herramienta) | 31/31 ✓ |
| 8. Trazabilidad (CNST/BR/UC/MOD/ADR) | 31/31 ✓ |
| 9. Historial de Cambios | 31/31 ✓ |

## Tipología canónica TXM_01 (Técnica/Negocio/Regulatoria)

Distribución asignada en el "Resumen Ejecutivo" de cada CNST:

| Tipo | CNSTs | Cantidad |
|------|-------|----------|
| Negocio | 001, 002 | 2 |
| Técnica | 003-024, 029-031 | 26 |
| Regulatoria | 025, 026, 027, 028 | 3 |
| **Total** | | **31** |

## Métricas de enriquecimiento

| Métrica | Valor |
|---------|-------|
| Archivos | 31 |
| Líneas totales | 6 959 (vs 1 766 pre-enriquecimiento, +293 %) |
| Líneas promedio por CNST | 224 |
| Versión metadata | 2.0.0 (todos los archivos bumped) |
| 9 secciones obligatorias | 31/31 ✓ |
| Refs `:doc:` rotas | 0 |
| Build | 0 warnings, 0 errors |

## Comparación de profundidad informativa

| Métrica | Pre-enriquecimiento (1.0.0) | Post-enriquecimiento (2.0.0) | Backup legacy (referencia) |
|---------|------------------------------|------------------------------|---------------------------|
| Archivos | 31 | 31 | 11 |
| Líneas totales | 1 766 | 6 959 | 10 982 |
| Líneas/archivo | 57 | 224 | 998 |
| Concerns/archivo | 1 (SRP) | 1 (SRP) | 4 (combinados) |
| Secciones/archivo | 4-5 | 9 | 9 |

**Conclusión cuantitativa:** los 31 atómicos enriquecidos cubren el
100 % de las secciones obligatorias con 224 ln promedio (vs 998 ln
del backup legacy). La reducción del 78 % vs legacy se debe a:

- Eliminación de duplicación de boilerplate (Aprobaciones, Historial
  por concern duplicado).
- Implementación detallada movida al codebase (no es responsabilidad
  del cajón normativo).
- Atomicidad: cada concern es ahora self-contained sin "secciones
  vacías" para concerns ajenos.

## Hallazgos de cobertura (análisis cross-WP)

### Para enriquecer en este WP — TODOS RESUELTOS

- E-1 Tipología 3 ejes ✓ (campo "Tipo (TXM_01)" en Resumen Ejecutivo)
- E-2 23 parámetros cuantitativos ✓ (integrados en 2.2 Parámetros)
- E-3 14 UCs afectados ✓ (integrados en 3.2 Casos de Uso Afectados)
- E-4 Trazabilidad inversa CNST→BR ✓ (placeholder explícito cuando
  no documentado en base cognitiva)
- E-5 HSTS específico ✓ (asignado a CNST_028 Cifrado)
- E-6 3 patrones de excepciones ✓ (integrados en 6.1/6.2)

### Para WPs futuros — DOCUMENTADOS COMO DEUDA EXPLÍCITA

Cada CNST referencia explícitamente la deuda diferida:

- W-1 ID realignment base_cognitiva ↔ rebuild → WP `cnst-id-realignment-base-cognitiva`
- W-2 Catálogo BRs IACT → WP `requisitos`
- W-3 Catálogo UCs IACT formal → WP `requisitos`
- W-4 PROC_Excepciones_CNST → WP `gobernanza` (referenciado en
  cada sección 6.2)
- W-5 ADRs RBAC v5.x → WP `arquitectura-tecnica`
- W-6 Guía de Patrones Recomendados → WP `arquitectura-tecnica`
- W-7 Conteos de CNSTs en estadísticas → ver W-1
- W-8 BR_011↔CNST_007 ejemplo profundo → WP `requisitos`

## Hallazgos identificados durante el enriquecimiento

| ID | Severidad | Descripción | Estado |
|----|-----------|-------------|--------|
| F-05-1 | Bajo | El parser inicial dejó la línea de subrayado dentro de Parametros (artefacto rst que generó "Block quote" warnings) | RESUELTO antes de commit (parser corregido) |
| F-05-2 | Informativo | Sección "BR Derivadas" tiene placeholder en 27/31 archivos por falta de catálogo BR IACT | DOCUMENTADO (deuda W-2) |
| F-05-3 | Informativo | Sección "ADRs relacionados" siempre placeholder | DOCUMENTADO (deuda W-5) |

## Recomendación final

**Cerrar el WP** — todos los criterios cumplidos:

- 31/31 CNSTs atómicos SRP (100 %).
- 31/31 con las 9 secciones obligatorias de TPL_CNST.
- 31/31 con tipología 3 ejes (TXM_01) declarada.
- 0 referencias `:doc:` rotas.
- Build limpio: 0 warnings, 0 errors.
- 8 hallazgos cross-WP documentados con WP destino sugerido.
- Trazabilidad mantenida via `analyze/cross-wp-debt-summary.md`.

Próximo: WP #5 source-rebuild-base-cognitiva (per Decision 1 order),
con el insumo W-1 (ID realignment) ya identificado para integrar
allí.
