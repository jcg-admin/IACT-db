```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 2.0.0
```

# Risk Register — Canonización del modelo de dominio

> Versión 2.0.0 — refinada tras los seis análisis
> de Stage 1 DISCOVER. Riesgos descartados,
> atenuados y nuevos están explícitos en su
> entrada. Los riesgos R-09..R-14 que aparecen
> nominalmente en el Análisis 03 quedan
> reclasificados según el Análisis 05 (re-mapping
> contra WPs cerrados); ver sección final
> "Riesgos descartados".

## R-01 — Elicitación adaptada sin stakeholders reales

- **Descripción:** El skill ``rm-elicitation``
  exige confirmación con stakeholders reales.
  Este WP trabaja con el ejecutor como proxy y
  con el corpus existente como fuente. La
  adaptación puede ocultar gaps que sólo
  aparecerían en conversaciones con product /
  negocio reales.
- **Probabilidad:** Alta.
- **Impacto:** Medio — el modelo será suficiente
  para anclar UCs internamente, insuficiente para
  validar que el dominio refleje el negocio real
  del call center.
- **Mitigación:** Documentación de la deviation
  como artefacto formal en
  ``discover/domain-elicitation.md``. Marcar el
  modelo final como "validado contra corpus, no
  contra stakeholders externos".

## R-02 — Heredar errores del corpus existente

- **Descripción:** Si los 61 UCs del catálogo
  contienen errores semánticos (clases mal
  identificadas, responsabilidades en la entidad
  equivocada), el modelo de dominio extraído
  hereda esos errores.
- **Probabilidad:** **Baja** (atenuada de Alta).
  Justificación del Análisis 05 + 06: el corpus
  pasó por Z.1.C (segmento descartado), Z.2
  (modelo RBAC v5.4.0 con 61 funciones,
  consolidación Larman, 4 constraints
  reescritas), Z.2.A (61 UCs clasificados en 5
  categorías), std007-rename-cleanup (315
  archivos migrados, build 0/0/0) y
  emoji-tables-audit (source/ libre de
  prohibiciones STD_001).
- **Impacto:** Medio.
- **Mitigación:** Cruzar candidatos a clase con
  los outputs del programa Z (Z.2.A 5 categorías
  + Z.2 11 decisiones) antes de promover.

## R-03 — Cifra "97 UCs" en cajón pedagógico desincronizada

- **Descripción:** ``analisis-dominio.rst § 11``
  declara "los 97 UCs". El inventario verificable
  es **61** y ningún WP del programa Z ni
  ninguna versión histórica del modelo soporta
  la cifra 97. Es estimación inflada o
  aspiracional residual del cajón pedagógico.
- **Probabilidad:** **Cierta** (la cifra está en
  el archivo).
- **Impacto:** Medio — engaña a futuros lectores
  que asumirán 97 como objetivo o catálogo real.
- **Mitigación:** Corregir
  ``analisis-dominio.rst § 11`` a "61 UCs"
  durante este WP (si se autoriza modificar el
  cajón pedagógico) o registrar la corrección
  como TD para WP de saneamiento documental
  posterior.

## R-04 — Inflación de clases

- **Descripción:** Cada sustantivo del corpus
  podría convertirse en una clase, multiplicando
  el modelo a ~50 entidades sin valor analítico.
- **Probabilidad:** Media.
- **Impacto:** Medio — el modelo se vuelve
  ilegible y deja de ser útil como referencia
  compartida.
- **Mitigación:** Aplicar el filtro de Abbott
  (``analisis-dominio.rst § 12``): solo se
  promueven a clase los sustantivos que
  representan conceptos persistentes con
  identidad propia y operaciones de negocio.
  Atributos, relaciones y eventos transitorios
  no son clases.

## R-05 — Lenguaje ubicuo no consensuado

- **Descripción:** El glosario producido aquí
  podría chocar con vocabulario ya enraizado en
  el código de IACT (``auth_app``, ``audit_log``,
  ``rpt_app``) y con la nomenclatura del modelo
  RBAC v5.4.0 (``view_application_logs``,
  ``acknowledge_alert``, etc).
- **Probabilidad:** Media. Justificación del
  Análisis 03: 5 de 6 categorías de error
  documentadas en ``ANALISIS_ERRORES_RBAC_v5_2_0``
  son de nomenclatura. El programa Z corrigió la
  parte RBAC, pero el modelo de **clases
  conceptuales** del dominio aún no existe como
  artefacto canónico.
- **Impacto:** Medio.
- **Mitigación:** El glosario distingue
  explícitamente: módulo de implementación
  (``auth_app``) ≠ función RBAC
  (``view_own_sessions``) ≠ clase del dominio
  (``Sesion``). Cada uno con su uso
  documentado.

## R-06 — El diagrama crece más allá de lo legible

- **Descripción:** ≥14 clases con todas sus
  asociaciones en un solo PlantUML produce un
  diagrama no consumible.
- **Probabilidad:** Alta.
- **Impacto:** Medio.
- **Mitigación:** Descomponer por bounded
  context (DDD): Auth, RBAC, Reportes/Métricas,
  Pipeline ETL, Alertas, Auditoría, Logs. Un
  diagrama por contexto + un overview que sólo
  muestre los puentes inter-contexto.

## R-07 — Sub-modelado del estado dinámico

- **Descripción:** El diagrama de clases captura
  estructura, no transiciones de estado.
  ``Sesion``, ``Alerta`` y ``EjecucionETL``
  tienen estados con transiciones reglamentadas
  (CNST_*, BR-009 v2.0.0).
- **Probabilidad:** Alta — el diagrama de
  clases por definición no muestra estado
  dinámico.
- **Impacto:** Bajo aquí — los diagramas de
  estado son artefactos complementarios; este
  WP sólo produce el de clases.
- **Mitigación:** Documentar al cierre cuáles
  clases requieren un diagrama de estado en un
  WP posterior. Citar BR-009 v2.0.0 (alcance
  global) en las clases que tienen ciclo de
  vida.

## R-08 — Reproducción de material externo

- **Descripción:** Las referencias a DDD (Evans
  2003), Larman (*Applying UML and Patterns*) y
  Schmuller (*Aprendiendo UML en 24 horas*)
  podrían inducir copia de texto literal en el
  artefacto producido.
- **Probabilidad:** Media.
- **Impacto:** Alto — viola política del
  proyecto (cajón metodológico debe ser
  original, citando fuentes).
- **Mitigación:** Toda escritura es original.
  Las fuentes externas se citan por nombre y
  página, sin transcripción ni paráfrasis
  cercana.

## R-12 — Confundir atributo del dominio con columna SQL

- **Descripción:** Las clases del dominio son
  conceptos; las tablas SQL son implementación.
  Aplicar convenciones SQL (``*_at``, ``*_id``,
  ``deleted_at``) a atributos del modelo
  conceptual confunde los niveles.
- **Probabilidad:** Media. Justificación
  Análisis 03 § E-04: el corpus tuvo
  inconsistencias SQL (``assigned_date`` vs
  ``assigned_at``) que motivaron la regla.
- **Impacto:** Medio — el modelo deja de ser
  herramienta conceptual y se convierte en
  esquema técnico.
- **Mitigación:** Atributos del dominio en
  español descriptivo (``fecha_asignacion``,
  ``identificador``); convenciones SQL viven
  sólo en el ADR de implementación de BD, no en
  el diagrama de clases conceptual.

## R-15 — Re-derivar lo que WPs previos ya cerraron

- **Descripción:** El programa Z (Z.0..Z.5),
  std007-* trio y emoji-tables-audit cerraron
  problemas de inventario, conteo, naming y
  conformidad STD_001/STD_007. Re-procesar esos
  análisis como si no existieran duplica
  esfuerzo y puede contradecir decisiones ya
  formalizadas.
- **Probabilidad:** **Confirmada** (ya ocurrió
  parcialmente en los análisis 02 y 03 antes del
  análisis 05 que lo detectó).
- **Impacto:** Medio — desperdicia trabajo y
  riesgo de proponer cambios incoherentes con
  decisiones ya tomadas.
- **Mitigación:** Lectura obligatoria al iniciar
  cada Stage del WP de los outputs:
  - Z.2.A ``deep-review-missing-ucs.md`` (5
    categorías de UCs).
  - Z.2 ``wp-modelo-conceptual-cleanup-changelog.md``
    (10 funciones nuevas, 6 renames, 4
    constraints).
  - Z.1.C ``z1c-changelog.md`` (segmento
    descartado, 42 confirmadas → 51 → 61).

## Riesgos descartados / atenuados (re-mapeo del Análisis 05)

| ID | Descripción original | Estado |
|----|---------------------|--------|
| R-09 | Estándar declarado vs aplicado divergen | **DESCARTADO** — std007-rename-cleanup verificó cumplimiento con build 0/0/0. |
| R-10 | Renombrado masivo si decisión cambia tarde | **DESCARTADO como riesgo vivo; LECCIÓN APRENDIDA**. Ocurrió y se resolvió: 315 archivos + 18 directorios + 370+ refs migrados a kebab. Documentar en ``track/lessons-learned.md``. |
| R-11 | IDs sin contrato estable | **DESCARTADO** — Z.2 demostró disciplina explícita: "6 renames preservando IDs; 0 eliminadas". |
| R-13 | Identificadores cruzados entre artefactos | **DESCARTADO** — std007-rename-cleanup actualizó 370+ refs en cascada con build 0/0/0. |
| R-14 | Revisión reactiva en lugar de gate por unidad | **DESCARTADO** — la práctica THYROX moderna (WPs incrementales con gate I-015 build 0/0/0) lo mitiga estructuralmente. |

## Resumen

| Riesgo | Prob. | Impacto |
|--------|-------|---------|
| R-01 Elicitación adaptada | Alta | Medio |
| R-02 Heredar errores | Baja | Medio |
| R-03 Cifra "97" desincronizada | Cierta | Medio |
| R-04 Inflación de clases | Media | Medio |
| R-05 Lenguaje ubicuo | Media | Medio |
| R-06 Diagrama ilegible | Alta | Medio |
| R-07 Estado dinámico no modelado | Alta | Bajo |
| R-08 Material externo | Media | Alto |
| R-12 Atributo dominio vs SQL | Media | Medio |
| R-15 Re-derivar trabajo ya cerrado | Confirmada | Medio |

10 riesgos vigentes. R-01, R-03, R-15 son los
prioritarios por su probabilidad. R-08 es
prioritario por impacto.
