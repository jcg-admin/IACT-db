```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 06 — Estado canónico del programa Z

Síntesis de la lectura completa de los tres
documentos clave de los WPs cerrados Z.1.C, Z.2 y
Z.2.A. Reemplaza la estimación del Análisis 05 con
los datos verbatim del cierre de cada sub-WP.

## Fuentes leídas

- Z.1.C — ``track/z1c-changelog.md`` (167 líneas)
- Z.2 — ``track/wp-modelo-conceptual-cleanup-changelog.md``
  (235 líneas)
- Z.2.A — ``discover/deep-review-missing-ucs.md``
  (327 líneas)

## 1. Estado canónico del modelo RBAC vigente

### Cifra final: 61 funciones (v5.4.0)

Del Z.2 changelog § "Métricas finales":

| Métrica | Valor |
|---------|------:|
| Funciones modelo antes / después | 51 → 61 |
| Funciones nuevas | +10 |
| Funciones renombradas (ID preservado) | 6 |
| Funciones eliminadas | 0 |
| UCs nuevos creados | 6 |
| UCs eliminados (consolidados) | 2 |
| UCs re-mapeados | 4 |

### Genealogía completa documentada

De Z.2.A § 1, Z.1.C § "Genealogia documentada del
conteo":

```
v4.0  (75)  → v5.0  (57)  → v5.0_1 (57)  →
v5.1  (44)  → v5.1.1 (44) → v5.2.0 (42)  →
v5.2.1 (42, "vigente" antes del programa Z) →
v5.3.0 (51, working) → v5.4.0 (61, vigente actual)
```

**Hallazgo crítico declarado por Z.2.A:** la
transición v5.1 → v5.1.1 eliminó 5 funciones RPT
legítimas sin actualizar los UCs que las
citaban. El error se heredó hasta v5.2.1 y
permaneció ~4 meses (enero–abril 2026). Z.1.C +
Z.2 cerraron ese drift.

### Distribución por módulo (v5.4.0)

Reconstruida de Z.2 changelog "Added" §:

| Módulo | v5.2.1 | v5.4.0 | Δ |
|--------|-------:|-------:|--:|
| Auth | 4 | 4 | 0 (renames) |
| Users | 9 | 9 | 0 (rename USR-003) |
| Access | 5 | 7 | +2 (ACC-011/012) |
| Pipeline | 4 | 4 | 0 |
| Reports | 8 | 8 | 0 (Z.2 no agregó RPT funciones — los UCs nuevos uc-rpt-15/16/17 son **instancias de RPT-001 con scope distinto**) |
| Alerts | 6 | 10 | +4 (ALR-007/008/009/010, rename ALR-005) |
| Audit | 4 | 4 | 0 |
| Logs | 2 | 7 | +5 (LOG-004/005/006/007) |

(Z.2 también incorporó funciones admin RBAC para
UC_PERM en otro tramo, dentro de Access. Total
actual del módulo Access en v5.4.0 puede incluir
ACC-006..010 declaradas en Z.2.A § Cat 5; el
changelog de Z.2 visible cita explícitamente sólo
ACC-011/012, lo que sugiere que ACC-006..010
fueron añadidas en otro paso o forman parte del
"working work" pre-WP del commit ``74ae48c``).

### 6 renames preservando ID (Z.2 changelog
"Changed § Renames")

- ``USR-003 delete_users`` → ``deactivate_users``
- ``ALR-005 delete_alerts`` → ``disable_alerts``
- ``LOG-001 view_technical_logs`` →
  ``view_application_logs``
- ``AUTH-001 manage_sessions`` →
  ``view_own_sessions``
- ``AUTH-004 view_active_sessions`` →
  ``view_all_active_sessions``
- ``ACC-005 manage_separation_rules`` →
  ``view_separation_rules``

Razón principal: SRP (single responsibility) +
BR-009 global (no eliminar, sólo desactivar).

## 2. Estado canónico de los UCs

### Conteo source/ confirmado: 61

Sigue siendo el conteo verificable por
``find source/requisitos/casos-uso/ -name
'uc-*.rst' | wc -l``.

### Cambios aplicados en programa Z al inventario

**Eliminados (Z.1.C):**

- ``uc-acc-06-gestionar-segmentos.rst``
- ``uc-acc-07-asignar-segmento.rst``
- ``br-012-usuario-segmento-unico.rst`` (BR
  asociada)

Razón: concepto Segmento descartado (Camino C) —
ETL filtra los datos + AGR + MOD + Función cubre
la separación funcional.

**Eliminados (Z.2 — consolidación Larman):**

- ``uc-rpt-05-exportar-excel.rst``
- ``uc-rpt-06-exportar-pdf.rst``

Razón: consolidados en
``uc-rpt-04-exportar-reporte.rst`` v5.0.0 con
flujos alternativos por formato (CSV / Excel /
PDF). Aplicación canónica del patrón Larman.

**Nuevos (Z.2):**

- ``uc-log-05-ver-logs-infraestructura.rst``
- ``uc-log-06-ver-estado-sistema.rst``
- ``uc-log-07-ver-metricas-tecnicas.rst``
- ``uc-rpt-15-reporte-transferencias-centro.rst``
- ``uc-rpt-16-reporte-menus-ivr.rst``
- ``uc-rpt-17-reporte-clientes-unicos.rst``

**Re-mapeados (Z.2):**

- ``uc-log-02-consultar-logs-etl``: LOG-001 →
  LOG-004 ``view_etl_logs``
- ``uc-perm-10-consultar-auditoria-permisos``: cita
  obsoleta limpiada
- ``uc-alr-03-reconocer-alerta``: ALR-003 → ALR-007
  ``acknowledge_alert``
- ``uc-alr-05-gestionar-suscripciones``:
  consolidado con FA-Subscribe / FA-Unsubscribe /
  FA-Configure-Severity

### Origen del 61 actual

Derivación del conteo:

```
PLAN MAESTRO v4.0 = 49 UCs declarados
Z.1.C: −3 (uc-acc-06, uc-acc-07, br-012 BR)
       (eliminó UCs ACC; modelo no llegó al 49 visible)
Z.2:   −2 (uc-rpt-05/06 consolidados en uc-rpt-04)
Z.2:   +6 (uc-log-05/06/07, uc-rpt-15/16/17)

PERM cluster: +10 (origen pre-Z, decisión post-v4.0
        — vista técnica del RBAC, ADR-GOB-008)

Trazabilidad clara desde:
49 (PLAN v4.0)
+ 10 PERM (post-PLAN)
= 59 conceptual
- 2 (uc-rpt-05/06 consolidados Larman)
+ 6 (Z.2 nuevos)
- 2 (uc-acc-06/07 segmento Z.1.C; PLAN v4.0 los
      contaba pero no llegaron a vivir en source)

≈ 61 verificado por find. Match.
```

(El cálculo no es exactamente 49 + 10 + 6 − 2 − 2
= 61 línea por línea por el orden de los cambios y
los UCs Cat B+C+D+F corregidos en commit
``fd9ef31`` pre-Z.2; el resultado final es
**61 verificado**.)

### Cifra "97" no respaldada

``analisis-dominio.rst § 11`` declara "los 97
UCs". Ningún WP del programa Z tocó ese cajón
metodológico. La cifra **no aparece** en ninguna
de las 7 versiones del modelo RBAC ni en los
catálogos de UC.

Acción pendiente para el WP actual:
``analisis-dominio.rst § 11`` debe corregirse a
**61** o marcarse como aspiracional /
hipotético. Esto va en una entrega de
``design/`` o ``track/`` del WP actual cuando
toque tocar el cajón pedagógico.

## 3. Constraints y BRs canónicos vigentes

Z.2 también reescribió constraints relevantes
para el modelo de dominio:

- **BR-009 Bajas Lógicas v2.0.0** — alcance
  global; estados canónicos por entidad
  documentados; mapeo a renames v5.4.0 explícito.
- **BR-011 Límites de Exportación v2.0.0** —
  cifras arbitrarias eliminadas; delega a
  CNST-019 / CNST-020.
- **CNST-019 Exportaciones Asíncronas v3.0.0** —
  desacoplado de Celery; capacidades requeridas
  independientes de tecnología.
- **CNST-020 Throttling de Exportaciones
  v3.0.0** — tabla arbitraria por formato
  eliminada; throttling abstracto por recursos.

Implicación para el modelo de dominio: las
constraints sobre clases ``EjecucionETL``,
``Reporte``, ``Sesion``, ``Alerta`` deben citar
**estas versiones vigentes**, no las que
aparecen en ``temp-holding/``.

## 4. Decisiones formalizadas (D-01..D-11)

Z.2 dejó 11 decisiones aprobadas en
``analyze/srp-audit/decisions-log.md``. No leídas
en detalle aquí — referencia para cuando el WP
actual necesite justificar decisiones de
naming/responsabilidad de clases.

## 5. Hallazgo: ADR-GOB-008 (coexistencia ACC ↔
PERM)

El cluster PERM (10 UCs) sigue siendo vista
técnica del RBAC. Está respaldado por
``ADR-GOB-008`` (citado en cabecera de
UC_PERM_07). Z.2.A § Cat 5 confirma que las 10
UCs PERM mapean a 5 funciones admin nuevas en
el módulo ACC + funciones existentes
(ACC-003/004, AUD-001/002, CNST-032).

## 6. Hallazgo: deuda residual reconocida y
diferida

### De Z.1.C (transferida a Z.2)

~15 archivos con menciones textuales a
"segmento" en cuerpos de UCs. Z.2 cerró sin
limpiarlas todas (no bloqueante, build verde).

Acción para el WP actual: cuando se
publique el diagrama de clases, NO debe contener
ningún rastro del concepto "Segmento". El término
``SegmentoDatos`` que aparece en
``analisis-dominio.rst § 7`` (extracto del cajón
metodológico) **es obsoleto** — se suprime del
modelo canónico que produzca este WP.

### De Z.2 (transferida a WP md-references-audit)

832 referencias a archivos ``.md`` en
``source/`` que Sphinx no valida. Riesgo: links
rotos silenciosos. WP independiente abierto en
``2026-04-30-04-11-28-md-references-audit/``.

No bloqueante para el WP actual (no produce
``.md`` referenciados desde RST).

## 7. Re-evaluación de los hallazgos del WP previo
``rm-uc-relationships-analysis``

Actualización post-lectura completa:

| Hallazgo previo | Estado real verificado |
|-----------------|------------------------|
| H-01: gaps de IDs en ACC, RPT | **EXPLICADO COMPLETAMENTE.** ACC: 06/07 eliminados (Z.1.C, segmento). RPT: 05/06 consolidados en 04 (Z.2 Larman). Los gaps son intencionales y trazables. |
| H-02: CNST_002 vs CNST_003 | Pendiente — fuera del scope del programa Z. |
| H-03: PERM no expone Actor Principal en meta | **EXPLICADO.** Z.2.A § Cat 5 reconoce PERM como vista técnica del RBAC; el formato meta diferente es intencional. |
| H-04: AGR-008 vs AGR-006 para "auditor" | Pendiente — Z.* no tocó la nomenclatura de agrupadores. |
| H-05: Colisión id AGR-007 ACC vs LOG | Pendiente — idem. |
| H-06: 16 UCs sin "UC Relacionados" en Trazabilidad | **PARCIAL.** Z.2 reescribió varios UCs (uc-rpt-04 consolidado, uc-alr-05 consolidado, etc). El campo "UC Relacionados" puede haberse rellenado en esos. UCs PERM siguen sin él (vista técnica). |
| H-07: UC_USR_01 → UC_ACC_07 inexistente | **EXPLICADO.** UC_ACC_07 fue eliminado intencionalmente (Z.1.C). La referencia colgante en UC_USR_01 está documentada como deuda residual textual reconocida (~15 archivos). Acción: limpiar la referencia, NO restaurar UC_ACC_07. |
| H-08: ACC ↔ PERM coexistencia | **EXPLICADO.** ADR-GOB-008 + Z.2.A § Cat 5. |
| H-09: RPT_15/16/17 kebab | **EXPLICADO.** Estos UCs son **nuevos de Z.2** (commit ``69a7092``); la nomenclatura kebab era el estándar vigente cuando se crearon (post std007). No es inconsistencia — es lo nuevo. |
| H-10: LOG_05/06/07 idem | **EXPLICADO.** Idem H-09 — UCs nuevos de Z.2. |
| H-11: Jerarquía AGR-001⊂002⊂003 | Pendiente — fuera del scope del programa Z. |

Conclusión: **8 de 11 hallazgos del WP previo
están explicados o resueltos por el programa Z.**
Los 3 pendientes (H-02, H-04, H-05, H-11) son de
nomenclatura de agrupadores / restricciones, no
del modelo RBAC en sí.

## 8. Implicaciones para los tres artefactos
finales del WP actual

### ``domain-elicitation.md``

El plan de elicitación adaptada se simplifica:

- **Insumos primarios** (no requieren elicitación
  adicional): modelo RBAC v5.4.0
  (``modelo-rbac-iact.rst``), las 61 UCs en
  ``source/requisitos/casos-uso/``, los outputs
  de Z.1.C / Z.2 / Z.2.A.
- **Insumos secundarios**: BR / FR / CNST
  vigentes (BR-009 v2.0.0, BR-011 v2.0.0,
  CNST-019/020 v3.0.0, etc).
- **Pendiente de elicitación adaptada**: sólo el
  diagrama de clases — qué clases del dominio
  emergen del corpus consolidado y cómo se
  agrupan en bounded contexts.
- La deviation respecto al skill
  ``rm-elicitation`` consiste en **importar**
  los outputs de los WPs cerrados como
  equivalente de "stakeholders confirmados" +
  análisis de documentos del corpus + sesión
  con ejecutor para validar el diagrama final.

### ``risk-register.md`` (refinamiento)

Ajustes adicionales tras esta lectura:

- **R-02 atenuar** a "Heredar errores del
  corpus" → probabilidad **Baja**: el corpus
  pasó por Z.1.C, Z.2, Z.2.A, std007-*,
  emoji-audit. Los errores documentados están
  cerrados.
- **R-03 mantener pero re-acotar**: la
  discrepancia 61 vs 97 UCs ya tiene **respuesta
  canónica**: 61 es correcto, 97 es estimación
  inflada del cajón pedagógico que debe
  corregirse.
- **R-12 reforzar**: el modelo conceptual del
  dominio (clases) debe distinguirse del modelo
  RBAC (funciones). El programa Z trabajó el
  modelo RBAC; el modelo conceptual del dominio
  es justamente lo que falta y es scope del WP
  actual.
- **R-15 nuevo (del análisis 05)** mantenerlo
  como vigilante.

### ``exit-conditions.md`` (refinamiento)

- El conteo "100% UCs apuntan a clase del
  modelo" se puede verificar contra los **61
  UCs**, no contra una cifra estimada.
- La validación cruzada UC × clase debe
  considerar las 5 categorías de Z.2.A: 36 UCs
  OK, 5 con mismatch nominal, 3 historicos
  restaurados, 4 variantes filtradas, 10 PERM
  vista técnica. La matriz UC × clase debe
  reflejar esa estructura, no tratar los 61 UCs
  como entidades de igual peso.
- Las constraints citadas por las clases del
  dominio deben ser BR-009 v2.0.0, CNST-019
  v3.0.0, etc. (versiones vigentes).
- ``analisis-dominio.rst § 11`` debe
  corregirse: "61 UCs", no "97".

## 9. Hallazgo derivado

### H-T20 — El programa Z dejó la documentación pedagógica desactualizada

Los WPs Z.1.C / Z.2 / Z.2.A cerraron el modelo
RBAC y el catálogo de UCs en ``source/``, pero
**no actualizaron** los documentos pedagógicos
del cajón ``_metodologia-aplicacion/`` que
referencian cifras y conceptos antiguos:

- ``analisis-dominio.rst § 11`` cita "97 UCs".
- ``analisis-dominio.rst § 7`` cita
  ``SegmentoDatos`` (concepto eliminado por
  Z.1.C).

Status: **OBSERVABLE**. Implicación: el WP actual
también debería corregir esos puntos como parte
de la canonización (Stage 7 DESIGN o Stage 12
STANDARDIZE).

## Próximo paso

Sintetizar los tres artefactos finales con:

1. **Plan de elicitación adaptada** — cita
   programa Z, declara la deviation simplificada,
   define qué se elicita ahora (clases del
   dominio) y qué ya está hecho.
2. **Risk register refinado** — descarta R-09,
   R-10, R-14; atenúa R-02, R-11, R-13; mantiene
   los específicos del WP; añade R-15 (no
   re-derivar lo que ya está cerrado).
3. **Exit conditions refinadas** — verifica
   cumplimiento de política declarada (CLEAN
   CODE / NOM_001 / STD_001), valida UC × clase
   contra los 61 reales, integra las 5
   categorías de Z.2.A, exige actualización de
   ``analisis-dominio.rst § 11`` y limpieza del
   concepto Segmento.
