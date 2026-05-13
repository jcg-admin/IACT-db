```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 05 — Hallazgos ya resueltos en WPs previos

Re-evalúa los hallazgos de los análisis 02, 03 y
04 contra los **WPs cerrados** del proyecto. Su
propósito es eliminar duplicación: muchos
problemas que detecté en ``temp-holding/`` ya
fueron tratados y resueltos en ciclos anteriores
de THYROX, por lo que no deben aparecer como
riesgos vivos del WP actual.

## Fuentes consultadas

- ``find .thyrox/context/work/`` filtrado por
  ``rbac|naming|std007|nom|cleanup|saneamiento|emoji|rebuild``.
- ``wp-state.md`` y secciones de cierre de los
  WPs que tocan los temas detectados.

## Programa Z (modelo-rbac-improvement)

Programa padre
``2026-04-29-17-52-15-modelo-rbac-improvement``
con sub-WPs Z.1..Z.5. Estado parcial visto:

| Sub-WP | Estado | Cierre |
|--------|--------|--------|
| Z.1.C ``rbac-functions-count-audit`` | **CERRADO v2.0.0** | 2026-04-30 02:00 |
| Z.2 ``rbac-modelo-conceptual-cleanup`` | **CERRADO** | 2026-04-30 04:30 |
| Z.2.A ``rbac-missing-ucs-discovery`` | **CERRADO v1.0.0** | 2026-04-30 01:30 |

### Z.2 entregables verificados

Cierre de Z.2 (verbatim del wp-state.md):

> "Modelo RBAC bumpeado de v5.3.0 a v5.4.0
> (51 → 61 funciones; +10 nuevas; 6 renames
> preservando IDs; 0 eliminadas). 6 UCs nuevos,
> 2 consolidados, 4 re-mapeados, 4 constraints
> reescritos."

Implicación: el modelo RBAC vigente en
``source/`` es **v5.4.0**, no v5.2.x como
aparece en ``temp-holding/``. La iteración v5.2
(de la cual Análisis 03 extrajo errores) **ya
fue superada** por v5.3.0 → v5.4.0 con cambios
estructurales.

### Z.2.A — discovery de UCs huérfanos completado

Z.2.A clasificó los UCs aparentemente huérfanos
en 5 categorías (verbatim del cierre):

1. **29 UCs vivos correctamente mapeados** — sin
   acción requerida.
2. **5 UCs con mismatch nominal** — renombrar
   función o reescribir UC.
3. **3 UCs con funciones inexistentes en modelo
   pero existentes históricamente en v5.0_1/v5.1**:
   - ``uc-rpt-07``: era ``RPT-009 programa_reportes``
   - ``uc-rpt-10`` y ``uc-rpt-11``: ``RPT-010 comparte_reportes``
   - ``uc-log-03`` y ``uc-log-04``: relacionados con ``LOG-002 export_logs``
4. **4 UCs son variantes filtradas** (Camino C):
   ``uc-rpt-08, 09, 12, 13, 14`` son variantes
   filtradas por agentes/colas/campañas — no
   requieren funciones nuevas.
5. **UC_PERM (10 UCs)** — vista técnica del
   RBAC; requiere ~5 funciones admin nuevas
   (slot ``ACC-006`` disponible post Z.1.C).

Implicación: lo que mi Análisis 02 anotó como
H-T11 (renumeración RPT) y H-T10 (LOG kebab)
**ya fue analizado y catalogado** por Z.2.A.
Las decisiones tomadas (Camino C para variantes
filtradas) son la respuesta canónica del
proyecto.

## STD_007 — naming recalibration

Tres WPs cerrados sobre la convención de
naming:

| WP | Estado | Resultado |
|----|--------|-----------|
| ``2026-04-29-09-17-01-std007-naming-recalibration`` | DISCOVER (origen) | Identificó contradicciones en STD_007 |
| ``2026-04-29-14-56-40-std007-rename-cleanup`` | **CERRADO v1.0.0**, build 0/0/0 | Migración total a kebab-case minúsculas: 315 archivos + 18 directorios públicos + 370+ refs en cascada |
| ``2026-04-29-16-17-35-std007-spec-gaps-cleanup`` | **CERRADO v1.0.0** | F-01..F-13 resueltos |

Implicación directa: lo que mi Análisis 04
señaló como riesgo R-10 (renombrado masivo si
decisión cambia tarde) **ya ocurrió y se
resolvió** — el proyecto migró 315 archivos al
patrón ``<prefix>-<NNN>-<desc>.rst`` minúsculas.
La política está fijada y el cumplimiento se
verificó con build 0/0/0.

## Emoji audit (STD_001)

WP ``2026-04-29-09-39-48-emoji-tables-audit``,
status **Aprobado**. Estado: el corpus
``source/`` fue auditado contra emoji prohibidos
de STD_001. Los emojis que aparecen en
``temp-holding/`` (incluido ``ANALISIS_ERRORES_RBAC``)
son legítimos en su contexto (material
histórico) pero **no aparecen en source/**.

Implicación: H-T18 (STD_001 violado por el
propio análisis de errores) es observación
sobre material histórico, **no sobre el corpus
vigente**. No es un riesgo vivo.

## Mapping detallado: hallazgos previos vs estado real

### Hallazgos del WP previo ``rm-uc-relationships-analysis``

| Hallazgo | Estado real verificado |
|----------|------------------------|
| H-01: gaps de IDs en ACC, RPT | **ACLARADO** — Z.2.A categoría 4: variantes filtradas de RPT (Camino C). Los gaps son intencionales, no error. |
| H-02: wp-state cita CNST_002, corpus cita CNST_003 | Pendiente — no cubierto por Z.* (es asunto del cajón pedagógico, no del modelo RBAC). |
| H-03: PERM no expone Actor Principal en meta | Pendiente — Z.2.A categoría 5 reconoce PERM como vista técnica, pero el formato meta diferente sigue. |
| H-04: AGR-008 vs AGR-006 para "auditor" | Pendiente — no tocado por Z.*. |
| H-05: Colisión id AGR-007 ACC vs LOG | Pendiente — no tocado por Z.*. |
| H-06: 16 UCs sin "UC Relacionados" | Pendiente — no tocado. |
| H-07: UC_USR_01 → UC_ACC_07 inexistente | **POSIBLEMENTE RESUELTO** — Z.1.C eliminó "segmento" como concepto y bumpeó de 51 → 61 funciones. Verificar si UC_ACC_07 fue restaurado o si la referencia en UC_USR_01 fue limpiada. |
| H-08: ACC ↔ PERM coexistencia (10 pares) | **ACLARADO por ADR-GOB-008** y Z.2.A categoría 5 (vista técnica). Es decisión, no riesgo. |
| H-09: RPT_15/16/17 kebab vs canónico | **RESUELTO por std007-rename-cleanup** — todo el corpus fue migrado al patrón kebab. La inconsistencia que detecté es residuo o re-ocurrencia. Verificar. |
| H-10: LOG_05/06/07 idem | **RESUELTO** ídem H-09. |
| H-11: Jerarquía AGR-001⊂002⊂003 | Pendiente — no tocado. |

### Hallazgos del Análisis 02 (elicitation-history)

| Hallazgo | Estado real |
|----------|-------------|
| H-T08: UC_ACC_07 sí existió en PLAN v4.0 | Z.1.C cerró con "segmento descartado" → UC_ACC_07 fue eliminado intencionalmente. La referencia colgante en UC_USR_01 es **deuda residual** declarada por Z.2 ("~15 archivos con menciones textuales a 'segmento' en cuerpos de UCs"). |
| H-T09: PLAN v4.0 sin elicitación | **VIGENTE** — sigue siendo verdad y sigue siendo la deviation que el WP actual debe documentar. |
| H-T10: PERM añadido fuera del PLAN v4.0 | **ACLARADO** — Z.2.A categoría 5: PERM es vista técnica del RBAC, decisión post-v4.0. |
| H-T11: Renumeración RPT no documentada | **ACLARADO** — Z.2.A categoría 4: variantes filtradas Camino C. La renumeración fue intencional. |
| H-T12: Cifra "97 UCs" no coincide con ninguna versión | **VIGENTE** — Z.* no tocó ``analisis-dominio.rst § 11``. La cifra 97 sigue sin respaldo. |

### Hallazgos del Análisis 03 (historical-risks)

| Hallazgo / Riesgo | Estado real |
|-------------------|-------------|
| H-T13: 7 versiones del modelo RBAC | Superado — v5.3.0 y v5.4.0 son posteriores. Modelo vigente es v5.4.0. |
| H-T14: revisión post-redacción reactiva | Atenuado — std007-* y Z.1.C/Z.2 muestran que ahora hay WPs específicos de cleanup. La práctica cambió. |
| H-T15: nomenclatura como vector dominante de error | Atenuado — std007 cleanup completo. |
| R-09: estándar declarado vs aplicado divergen | **NO REPLICAR** — std007-rename-cleanup verificó cumplimiento con build 0/0/0. |
| R-10: renombrado masivo si decisión cambia tarde | **YA OCURRIÓ Y SE RESOLVIÓ** — std007 migró 315 archivos. No es riesgo vivo, es lección aprendida. |
| R-11: IDs sin contrato estable | **ATENUADO** — Z.2 explícita "6 renames preservando IDs; 0 eliminadas" muestra que ahora hay disciplina. |
| R-12: atributo dominio vs columna SQL | **VIGENTE** — Z.* no toca diagrama de clases conceptuales; el riesgo aplica al WP actual. |
| R-13: identificadores cruzados entre artefactos | **ATENUADO** — std007-rename-cleanup actualizó 370+ refs en cascada. |
| R-14: revisión reactiva en lugar de gate por unidad | **ATENUADO** — la práctica THYROX moderna es WPs incrementales con build 0/0/0 por gate. |

### Hallazgos del Análisis 04 (quality-criteria)

| Hallazgo | Estado real |
|----------|-------------|
| H-T16: política de naming declarada | **VIGENTE Y APLICADA** — std007 + STD_001 + NOM_001 son política preexistente y se ejecutan. |
| H-T17: tres documentos de calidad sin gate central | **VIGENTE** — sigue siendo verdad. Recomendación de centralizar persiste. |
| H-T18: STD_001 violado por análisis histórico | **NO APLICA AL CORPUS VIGENTE** — emoji-tables-audit verificó source/ limpio. Los emojis están sólo en temp-holding (material histórico). |

## Riesgos del ``risk-register.md`` actual — re-evaluación

Re-clasificación tras este análisis:

| Riesgo | Mantener / descartar / atenuar |
|--------|-------------------------------|
| R-01 (Elicitación adaptada sin stakeholders) | **MANTENER** — vigente. |
| R-02 (Heredar errores del corpus) | **ATENUAR** — el corpus pasó por Z.1.C, Z.2, std007-*, emoji-audit. La probabilidad de heredar errores es **menor de lo que estimé**. Bajar de Alta a Media. |
| R-03 (Discrepancia 61 vs 97 UCs) | **MANTENER** — ``analisis-dominio.rst § 11`` no fue tocado por Z.*. |
| R-04 (Inflación de clases) | **MANTENER** — vigente, decisión del WP actual. |
| R-05 (Lenguaje ubicuo no consensuado) | **MANTENER** — std007 fijó nombres de **archivos**, no de **clases conceptuales**. |
| R-06 (Diagrama ilegible por densidad) | **MANTENER** — vigente. |
| R-07 (Sub-modelado del estado dinámico) | **MANTENER** — vigente. |
| R-08 (Reproducción de material externo) | **MANTENER** — vigente. |
| R-09 (Estándar declarado vs aplicado) | **DESCARTAR** — resuelto por std007-rename-cleanup. |
| R-10 (Renombrado masivo) | **DESCARTAR como riesgo vivo** — ya ocurrió y se resolvió. Mantener como **lección aprendida** en track/. |
| R-11 (IDs sin contrato estable) | **ATENUAR** — Z.2 demostró disciplina de "renames preservando IDs". Probabilidad baja. |
| R-12 (Atributo dominio vs columna SQL) | **MANTENER** — específico del modelo conceptual del WP actual. |
| R-13 (Identificadores cruzados) | **ATENUAR** — atenuado por std007 + emoji-audit. |
| R-14 (Revisión reactiva) | **DESCARTAR como riesgo del WP actual** — el flujo THYROX moderno mitiga estructuralmente. |

## Implicaciones para los tres artefactos finales

### ``domain-elicitation.md``

- Citar como insumos los WPs cerrados Z.1.C, Z.2,
  Z.2.A, std007-* y emoji-tables-audit. Son
  **fuentes confirmadas** del proyecto, además
  del corpus.
- La deviation del skill ``rm-elicitation`` se
  apoya en que **otros WPs ya hicieron
  elicitación equivalente** (deep review +
  validation cruzada). El WP actual coordina, no
  re-elicita.
- Los entregables del WP deben **importar** los
  resultados de Z.2.A (clasificación de UCs en 5
  categorías) en lugar de re-derivarlos.

### ``risk-register.md``

- Quitar R-09, R-10, R-14 de la lista vigente.
- Atenuar R-02, R-11, R-13 con evidencia.
- Anclar R-01, R-03, R-05, R-12 que sí son
  específicos del WP actual.
- Añadir un nuevo riesgo derivado de este
  análisis:
  - **R-15 nuevo**: *No re-derivar lo que WPs
    previos ya cerraron* — riesgo de duplicar
    trabajo. Mitigación: lectura obligatoria de
    cierres de Z.1.C, Z.2, Z.2.A antes de Stage 3
    ANALYZE.

### ``exit-conditions.md``

- Las exit conditions de calidad son
  **verificación**, no producción de política
  nueva. CLEAN CODE + NOM_001 + STD_001 ya
  vigentes y aplicadas.
- Añadir gate de re-uso: el modelo de clases del
  WP debe incorporar las clasificaciones y
  decisiones de Z.2.A (5 categorías) como
  entrada, no producirlas de nuevo.

## Hallazgo derivado

### H-T19 — Análisis previos hicieron deep review en ``temp-holding/``

Z.2.A se abrió con la instrucción literal del
ejecutor: *"buscar en temp-holding antes de
proponer cambios al modelo"* (verbatim del
wp-state.md). Esto significa que mi Análisis 01
(inventario) y Análisis 02 (elicitation-history)
**recorrieron en parte el mismo camino** que
Z.2.A ya recorrió.

Status: **OBSERVABLE**. Ahorro pendiente: importar
los outputs de Z.2.A (``discover/deep-review-missing-ucs.md``)
como fuente directa, en vez de re-procesar.

## Próximo paso

Antes de sintetizar los tres artefactos
finales, leer el output específico de Z.2.A
(``deep-review-missing-ucs.md``) para no
re-derivar su mapping. También leer Z.1.C
``z1c-changelog.md`` y el cierre de Z.2 para
saber el delta exacto que aplicaron al modelo
RBAC vigente.

Cuando se sinteticen los tres artefactos, el
``risk-register.md`` y ``exit-conditions.md``
quedarán **más cortos y precisos** — las
preocupaciones genéricas heredadas del corpus
histórico ya no aplican.
