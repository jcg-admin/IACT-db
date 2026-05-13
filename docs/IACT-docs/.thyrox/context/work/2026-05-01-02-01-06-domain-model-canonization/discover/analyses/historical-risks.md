```yml
created_at: 2026-05-01 02:01:06
project: IACT-docs
work_package: 2026-05-01-02-01-06-domain-model-canonization
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis 03 — Riesgos históricos materializados

Extrae los riesgos **ya materializados** en
iteraciones previas del proyecto (especialmente
del modelo RBAC) para enriquecer
``risk-register.md`` con riesgos *verificados con
evidencia*, no solo proyecciones.

## Fuentes consultadas

- ``temp-holding/RBAC/ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md``
  (471 líneas, 14 KB) — análisis explícito de
  errores encontrados en la versión v5.2.0 del
  modelo RBAC.
- Estructura de
  ``temp-holding/RBAC/`` — siete versiones del
  modelo RBAC (v4.0, v5.0, v5.0_1, v5.1, v5.1.1,
  v5.2.0, v5.2.1) como evidencia indirecta.

## Resumen de errores documentados en RBAC v5.2.0

El propio análisis de errores de la versión 5.2.0
declara 87+ errores en cuatro categorías,
clasificados con su gravedad (datos verbatim de
``§ 1`` del documento fuente):

| Categoría | Errores | Gravedad |
|-----------|---------|----------|
| Nombres de funciones (dominio) | 42 | CRÍTICA |
| Nombres de grupos | 10 | CRÍTICA |
| Campos SQL mezclados | 15+ | ALTA |
| Inconsistencias en ejemplos | 20+ | ALTA |
| **Total** | **87+** | **INACEPTABLE** |

## Tipología de errores → riesgos del WP actual

Mapeo de cada categoría de error histórico a un
riesgo aplicable al WP actual (canonización del
modelo de dominio).

### E-01 → Inconsistencia entre estándar declarado y aplicado

**Evidencia histórica** (``§ 2``): el documento
v5.2.0 declaró un estándar de nomenclatura
(código en inglés, comentarios en español,
*nombres de funciones del dominio en español*) y
aplicó esa última regla mientras el ejecutor
había pedido **inglés también para nombres del
dominio**. El estándar declarado y el estándar
real divergieron sin que el desfase se detectara
hasta el análisis post-mortem.

**Riesgo derivado para el WP actual:** R-09 —
*Estándar declarado en
``discover/exit-conditions.md`` no se aplica
uniformemente al modelo de clases producido*. El
WP debe verificar al cierre que las
clases/atributos/operaciones del modelo siguen
**el mismo** estándar que el WP declara, no uno
inferido.

### E-02 → Renombrado masivo cuando una decisión cambia tarde

**Evidencia histórica** (``§ 3.2`` — 42 funciones
+ ``§ 4.2`` — 10 grupos): un cambio tardío en la
decisión idiomática obligó a renombrar 52
identificadores en cascada (con tabla
``incorrecto → correcto``), tocando SQL, modelos
Django, decorators, docstrings, ejemplos.

**Riesgo derivado:** R-10 — *Decisión sobre
nomenclatura del modelo (kebab vs canonical,
Spanish vs English) debe quedar firme antes de
escribir las clases*. Cualquier cambio
posterior multiplica el coste por el número de
clases × atributos × operaciones × asociaciones.
Mitigación: gate explícito en Stage 5
STRATEGY antes de pasar a Stage 7 DESIGN.

### E-03 → Pérdida de IDs estables a través de iteraciones

**Evidencia histórica:** las 7 versiones del
modelo RBAC (v4.0 → v5.2.1) implican
renumeraciones internas. Combinado con H-T11 del
análisis 02 (renumeración RPT 14 consecutivos →
15 con gaps), demuestra que IDs no se trataron
como contrato estable.

**Riesgo derivado:** R-11 — *Los IDs de las
clases del modelo (no IDs numéricos sino el
nombre canónico) deben registrarse como
contrato*. Si una clase se renombra, debe
crearse alias en el glosario y mantenerse el
nombre antiguo deprecado durante una ventana
explícita. No re-bautizar sin trazabilidad.

### E-04 → Convenciones SQL inconsistentes

**Evidencia histórica** (``§ 6``): nombres de
columnas SQL mezclados sin convención
(``assigned_date`` vs ``assigned_at``,
``separation_group`` vs ``rule_group``).

**Riesgo derivado:** R-12 — *El modelo
conceptual de dominio debe diferenciar
explícitamente atributos del dominio (que viven
en la clase como concepto) de columnas SQL (que
viven en la tabla como implementación)*. Los
primeros no deben adoptar convenciones SQL
(``*_at``, ``*_id``) — eso confunde el modelo de
dominio con el modelo de datos.

### E-05 → Documentación con ejemplos inconsistentes con el código

**Evidencia histórica** (``§§ 7, 8``):
decorators y docstrings con nombres distintos a
los del SQL real, ejemplos cruzados,
``help_text`` mezclando idiomas.

**Riesgo derivado:** R-13 — *El diagrama de
clases del WP actual y los UCs que lo invocan
deben usar exactamente los mismos identificadores*.
Si una clase es ``Sesion``, no aparece como
``Session`` en un UC y como ``user_session`` en
una nota. El glosario de lenguaje ubicuo (R-05
existente) cubre esto pero sólo si se aplica
materialmente.

### E-06 → Contar errores como evidencia de inestabilidad metodológica

**Evidencia indirecta:** la categoría
"INACEPTABLE" (87+ errores en una sola versión)
en un documento de 471 líneas indica que el
método de revisión que detectó esos errores no
se aplicó *durante* la redacción sino *después*.

**Riesgo derivado:** R-14 — *Aplicar el
checklist de calidad
(``exit-conditions.md``) durante la redacción de
cada artefacto, no al final*. Cada vez que se
agrega una clase al modelo, se verifica el
estándar antes de seguir, no se acumulan
violaciones para corregir en lote.

## Riesgos heredados del WP previo (validados)

Los hallazgos del WP previo ``rm-uc-relationships-analysis``
encuentran respaldo histórico:

| Hallazgo previo | Evidencia histórica que lo confirma |
|-----------------|--------------------------------------|
| H-09: RPT_15/16/17 usan kebab; resto canónico | E-04 (mezcla de convenciones) |
| H-10: LOG_05/06/07 mismo patrón que H-09 | E-04 + E-05 |
| H-04: AGR-008 vs AGR-006 para "auditor" | E-02 (decisión tardía sobre nomenclatura) |
| H-05: Colisión id AGR-007 ACC vs LOG | E-03 (IDs sin contrato estable) |
| H-07: UC_USR_01 → UC_ACC_07 inexistente | E-03 (renumeración perdió ACC_07 entre v4.0 y source/) |

Esto eleva los hallazgos previos de OBSERVABLE
*aislado* a OBSERVABLE *con patrón histórico
recurrente*.

## Hallazgos del análisis

### H-T13 — El proyecto tiene siete versiones del modelo RBAC

Sólo en ``temp-holding/RBAC/`` hay v4.0, v5.0,
v5.0_1, v5.1, v5.1.1, v5.2.0, v5.2.1. Es **siete
iteraciones** del mismo modelo, con un análisis de
errores explícito sobre v5.2.0. Las decisiones
de modelado han cambiado entre versiones.

Status: **OBSERVABLE**. Implicación para el WP
actual: el modelo de dominio que se canonice
**será al menos v8** del modelo conceptual. La
canonización tiene que ser firme — no va a ser
"otra iteración más".

### H-T14 — El método de revisión post-redacción ha sido reactivo

El documento ``ANALISIS_ERRORES_MODELO_RBAC_v5_2_0.md``
encontró 87+ errores. Eso indica que la revisión
de calidad se aplicó como auditoría *post* y no
como gate *durante*. Para canonizar el modelo de
dominio del proyecto, ese mismo error
metodológico no se puede repetir.

Status: **OBSERVABLE**. Acción concreta:
``exit-conditions.md`` debe incluir el checklist
de calidad como gate por clase, no como gate
final.

### H-T15 — Los riesgos materializados se concentran en nomenclatura

5 de 6 errores tipificados (E-01 a E-05) son de
nomenclatura. La sexta (E-06) es metodológica
sobre la nomenclatura. Esto indica que la
**ambigüedad del lenguaje** ha sido el vector
dominante de error en el proyecto.

Status: **OBSERVABLE**. Refuerza la importancia
del lenguaje ubicuo (DDD) declarado como
principio del WP. R-05 existente del WP
(*Lenguaje ubicuo no consensuado*) sube de
prioridad: pasa de probabilidad Media → Alta.

## Refinamientos propuestos a ``risk-register.md``

| ID actual | Acción |
|-----------|--------|
| R-01 (Elicitación adaptada) | Mantener; adicionar evidencia de H-T09 (PLAN v4.0 sin elicitación). |
| R-02 (Heredar errores del corpus) | Mantener; reforzar con E-04, E-05. |
| R-05 (Lenguaje ubicuo) | **Subir prob. Media → Alta** (H-T15). |
| **R-09 nuevo** | Estándar declarado vs aplicado divergen (E-01). |
| **R-10 nuevo** | Renombrado masivo si decisión cambia tarde (E-02). |
| **R-11 nuevo** | IDs sin contrato estable (E-03, H-T08). |
| **R-12 nuevo** | Atributo de dominio vs columna SQL — no confundir (E-04). |
| **R-13 nuevo** | Identificadores cruzados entre artefactos (E-05). |
| **R-14 nuevo** | Revisión reactiva en lugar de gate por unidad (E-06). |

## Próximo paso

Análisis 04 — leer ``CLEAN CODE NAMING
PRINCIPLES.md``, ``STD_001 Estandares
Documentacion 2.0.0``, ``NOM_001 Nomenclatura
2.0.0`` y la estructura del modelo documental
v2.2.0 para extraer criterios de calidad
publicables como ``exit-conditions.md`` refinado.
