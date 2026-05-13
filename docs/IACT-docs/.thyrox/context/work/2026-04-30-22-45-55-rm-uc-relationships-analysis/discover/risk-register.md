```yml
created_at: 2026-04-30 22:45:55
project: IACT-docs
work_package: 2026-04-30-22-45-55-rm-uc-relationships-analysis
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Risk Register — UC Relationships Analysis

Riesgos identificados al inicio del WP. Se reevalúan al cierre de cada
phase y al gate de entrega.

## R-01 — Inventario incompleto frente al catálogo real

- **Descripción:** Algún UC del corpus `source/requisitos/casos-uso/`
  no aparece en el inventario por gap de glob o por nombre fuera del
  patrón `uc-{cluster}-{nn}-*.rst`.
- **Probabilidad:** Media.
- **Impacto:** Alto — relaciones documentadas se construyen sobre el
  inventario; un UC omitido genera diagrama incoherente.
- **Mitigación:** Inventario se construye con `find ... -name 'uc-*.rst'`
  + verificación cruzada con `index.rst` de cada cluster.
- **Trigger de reapertura:** Gate phase 1 → 3 detecta UC mencionado en
  `index.rst` que no figura en `uc-inventory.md`.

## R-02 — Relaciones inferidas sin lectura del UC

- **Descripción:** Asignar `<<include>>` o `<<extend>>` por intuición
  del nombre del UC sin leer el cuerpo del `.rst` correspondiente.
- **Probabilidad:** Alta si no se enforce.
- **Impacto:** Alto — clasifica como SPECULATIVE y bloquea I-012.
- **Mitigación:** Cada relación documentada cita la línea del
  `uc-*.rst` que la justifica (`pre-condiciones`, `flujo principal`,
  `post-condiciones`). Sin cita, la relación queda en sección
  "Relaciones candidatas — pendientes de verificación".

## R-03 — Inflación de extends

- **Descripción:** Convertir cada flujo alterno en un UC `<<extend>>`
  separado, generando ruido sin valor analítico.
- **Probabilidad:** Media.
- **Impacto:** Medio — el diagrama consolidado se vuelve ilegible.
- **Mitigación:** Solo se modela `<<extend>>` cuando el flujo alterno
  está formalizado como UC propio en el catálogo. Variaciones internas
  del UC base permanecen en su especificación textual.

## R-04 — Sobre-uso de generalización

- **Descripción:** Modelar generalización entre UCs cuando lo correcto
  es include o cuando no hay relación realmente jerárquica.
- **Probabilidad:** Media.
- **Impacto:** Medio.
- **Mitigación:** Generalización solo cuando un UC realmente
  especializa el flujo de otro (LSP a nivel UC). Default a `<<include>>`
  cuando se duda.

## R-05 — Conflicto con CNST_030 (SoD) sin detectarlo

- **Descripción:** Documentar un par de UCs como ejecutables por el
  mismo actor cuando CNST_030 los marca como conflictivos.
- **Probabilidad:** Baja (CNST_030 está en cajón normativa).
- **Impacto:** Alto — invalidaría hallazgos para downstream.
- **Mitigación:** Sección de validación en
  `uc-relationships-analysis.md` cruza actores asignados con catálogo
  CNST_030.

## R-06 — Documento se vuelve enciclopedia en vez de análisis

- **Descripción:** El entregable replica la especificación de cada UC
  en lugar de centrarse en relaciones.
- **Probabilidad:** Alta sin disciplina.
- **Impacto:** Medio — duplica trabajo del cajón
  `casos-uso-especificacion.rst`.
- **Mitigación:** Inventario es 1 línea por UC (id + título + actor
  primario). Detalle textual queda fuera del scope (declarado en OUT).

## R-07 — Diagrama consolidado ilegible por densidad

- **Descripción:** 61 UCs con todas sus relaciones en un solo PlantUML
  produce un grafo no consumible.
- **Probabilidad:** Alta.
- **Impacto:** Medio.
- **Mitigación:** El diagrama consolidado de phase 3 se descompone por
  cluster + un overview cross-cluster que solo muestra UCs ancla y
  dependencias transversales (UC_AUTH_01, UC_PERM_07).

## R-08 — Hipótesis SPECULATIVE no se descienden

- **Descripción:** Las 4 hipótesis iniciales del WP-state quedan en
  SPECULATIVE al cierre, violando exit condition.
- **Probabilidad:** Media.
- **Impacto:** Alto — bloquea cierre por I-012.
- **Mitigación:** Phase 3 ANALYZE incluye sección explícita
  "Verificación de hipótesis iniciales" con resultado por hipótesis:
  OBSERVABLE / INFERRED / DESCARTADA.
