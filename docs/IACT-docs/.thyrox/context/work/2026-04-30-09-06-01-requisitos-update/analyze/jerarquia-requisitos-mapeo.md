```yml
created_at: 2026-04-30 09:30:00
project: IACT-docs
work_package: 2026-04-30-09-06-01-requisitos-update
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Mapeo de jerarquías de requisitos — BABOK / ADR-GOB-003 / source/

## Resumen ejecutivo

En el proyecto IACT coexisten **tres esquemas distintos** para la
jerarquía de requisitos, con inconsistencias internas:

1. **ADR-GOB-003** — declara una jerarquía de 5 niveles canónica
   pero usa nomenclatura `RN-/RNEG-/UC-/RF-/RNF-` que **no coincide
   con lo implementado en `source/`**.
2. **Glosario § E** (`/base-cognitiva/glosario.rst`) — declara la
   jerarquía BABOK + ISO 29148 con prefijos `OE-/N-/RN-/RS-/RSi-/
   RF-/RNF-/TC-` que **nunca se implementó**.
3. **source/requisitos/`** — usa prefijos `breq-/br-/uc-/fr-/rnf-`
   con metadata declarando "BReq nivel 1" (contradice a
   ADR-GOB-003 § Nivel 1 = REGLAS DE NEGOCIO).

Este documento mapea los tres esquemas, identifica los gaps de
nivel BABOK y propone qué hacer.

## 1. Tabla maestra de mapeo

.. (tabla en formato markdown ya que este doc vive fuera de source/)

| Concepto BABOK / ISO 29148 | Glosario § E | ADR-GOB-003 | source/ actual | Estado |
|---|---|---|---|---|
| Strategic Objective | `OE-XXX` | (no menciona) | (no existe) | **GAP** — falta cajón |
| Business Need (BABOK) | `N-XXX` | (no menciona) | (no existe) | **GAP** — falta cajón |
| Business Requirement (BABOK) / BRS (ISO 9.3) | `RN-XXX` | "N2: Requerimientos de Negocio" `RNEG-DOMINIO-###` | `breq-NNN` (cajón `business-requirements/`) | **OK conceptual / inconsistente nomenclatura + nivel** |
| Business Rule (BABOK secundario) | (en § I como "BR = also Business Rule en contextos de reglas de negocio") | "N1: Reglas de Negocio" `BR-DOMINIO-###` o `RN-DOMINIO-###` | `br-NNN` (cajón `reglas-negocio/`) | **OK conceptual / nomenclatura sin DOMINIO** |
| Stakeholder Requirement / StRS (ISO 9.4) | `RS-XXX` | (no menciona) | (no existe) | **GAP** — falta cajón (existen plantillas `tpl-rs-*` y `tpl-stk-*`) |
| System Requirement / SyRS (ISO 9.5) | `RSi-XXX` | (no menciona) | (no existe) | **GAP** — falta cajón |
| Use Case (BABOK) | (no menciona en § E) | "N3: Requerimientos de Usuario" `UC-DOMINIO-###` | `uc-NNN-{desc}` o `uc-{MOD}-NN-{desc}` (61 UCs) | **OK conceptual / dos esquemas conviven** |
| Functional Requirement / SRS (ISO 9.6) | `RF-XXX` | "N4: Requerimientos Funcionales" `RF-DOMINIO-###` | `fr-NNN-NN-{desc}` (45 FRs) | **OK conceptual / nomenclatura sin DOMINIO** |
| Non-Functional Requirement / ISO 25010 | `RNF-XXX` | "N5: Atributos de Calidad" `RNF-DOMINIO-###` | `rnf-{MOD}-NNN-{desc}` (2 NFRs) | **OK conceptual / cobertura mínima** |
| Test Case | `TC-XXX` | (no menciona) | (no existe en `requisitos/`) | **GAP** — falta cajón (existe `gestion/evidencia/` para EV_CP_) |

## 2. Gaps de cajón — qué falta crear en source/requisitos/

Si se decide implementar la jerarquía BABOK completa, faltan **5
niveles** que no tienen cajón:

| Cajón a crear | Prefijo | Propósito | Esfuerzo aproximado |
|---|---|---|---|
| `requisitos/objetivos-estrategicos/` | `oe-NNN` | Objetivos de la organización que justifican el proyecto | Bajo (1-3 OE típicos) |
| `requisitos/necesidades-negocio/` | `n-NNN` | Necesidades de negocio que el proyecto satisface | Bajo (3-8 N típicos) |
| `requisitos/requisitos-stakeholders/` | `rs-NNN` | Lo que cada stakeholder espera del sistema | Medio (depende de # de stakeholders) |
| `requisitos/requisitos-sistema/` | `rsi-NNN` | Capacidades del sistema agregado (no atómicas como FR) | Medio |
| `requisitos/rtm/` | `rtm-NNN` | Requirements Traceability Matrix (mencionado en glosario § D pero no creado) | Bajo (1 índice + matrices generadas) |

Tests (`TC-XXX`) probablemente deberían vivir en `gestion/evidencia/`
(donde ya existe el cajón) y no duplicarse en `requisitos/`.

## 3. Inconsistencias internas a resolver

### 3.1 Conflicto de nivel BReq

- **BReq-001** (`/source/requisitos/business-requirements/breq-001`)
  declara en metadata: *"Business Requirement nivel 1 (más alto de
  la jerarquía de 5 niveles per ADR-GOB-003)"*.
- **ADR-GOB-003** declara: *"Nivel 1: REGLAS DE NEGOCIO"* y *"Nivel
  2: REQUERIMIENTOS DE NEGOCIO"*.

BReq-001 contradice a ADR-GOB-003 — el nivel correcto según ADR
debería ser **N2**, no N1. O bien BReq-001 está mal o ADR-GOB-003
está mal.

**Hipótesis probable:** BReq-001 fue creado durante el WP md-cleanup
basándose en una interpretación intuitiva ("BReq = nivel más alto")
sin re-leer ADR-GOB-003 al detalle.

**Resolución:** decidir cuál es la fuente de verdad y alinear el
otro doc.

### 3.2 Nomenclatura ADR-GOB-003 vs source/

ADR-GOB-003 prescribe `BR-DOMINIO-###`, `RNEG-DOMINIO-###`,
`UC-DOMINIO-###`, `RF-DOMINIO-###`, `RNF-DOMINIO-###`.

source/ usa `br-NNN`, `breq-NNN`, `uc-NNN` o `uc-MOD-NN`,
`fr-NNN-NN`, `rnf-MOD-NNN` — **sin `DOMINIO`** en la mayoría.

Esto es coherente con STD-007 v2.0.0+ (que omite `DOMINIO` en favor
de un patrón unificado kebab) pero **contradice a ADR-GOB-003**.

**Resolución:** o ADR-GOB-003 se actualiza para reflejar la
convención post-STD-007, o STD-007 hereda del ADR. Como STD-007 fue
revisado más recientemente (v2.0.2, 2026-04-29), **STD-007 es la
fuente de verdad vigente** y ADR-GOB-003 debe re-redactarse.

### 3.3 Glosario § E nunca se implementó

La jerarquía BABOK + ISO 29148 con prefijos `OE/N/RN/RS/RSi/RF/RNF/
TC` aparece en `glosario.rst:244-269` como referencia académica,
pero **ningún archivo en source/ usa esos prefijos**. Es una
declaración de intención sin ejecución.

**Opciones:**

- **Opción A (mantener):** dejar el § E como referencia conceptual
  (qué dice BABOK) y que el proyecto siga con `breq/br/uc/fr/rnf`
  como nomenclatura propia.
- **Opción B (alinear):** renombrar prefijos del proyecto a los
  BABOK (`breq → rn`, `br → ?`, `uc → uc`, `fr → rf`,
  `rnf → rnf`). Costo alto: 148 archivos + ~340 refs.
- **Opción C (mapeo explícito):** mantener `breq/br/uc/fr/rnf` como
  nombres físicos pero documentar en cada archivo el mapeo a su
  equivalente BABOK en metadata (`:babok_equivalent: RN`).

### 3.4 Cifras desactualizadas en TXM-02

`TXM-02 § 4` declara:

- "38 UCs identificados" — realidad: **61 UCs**.
- "~300 FRs estimados" — realidad: **45 FRs**.
- "ubicación `requisitos/funcionales/`" — realidad:
  `requisitos/requisitos-funcionales/`.
- "ubicación `requisitos/no_funcionales/`" — realidad:
  `requisitos/requisitos-no-funcionales/`.

**Resolución:** actualizar TXM-02 a las rutas + cifras reales (es
update mecánico, sin decisión arquitectónica).

## 4. Recomendación: mapeo bidireccional canónico

Sin tomar decisión todavía sobre crear los cajones faltantes,
propongo establecer **un mapeo canónico bidireccional** que vive en
`/base-cognitiva/glosario.rst` (extender § E o crear § E.1) y se
referencia desde TXM-01 + TXM-02 + ADR-GOB-003:

```
┌────────────────────────────────────────────────────────────────┐
│ Concepto BABOK / ISO 29148   ID en source/    Estado          │
├────────────────────────────────────────────────────────────────┤
│ Strategic Objective          (no implementado) ─── opcional   │
│ Business Need                (no implementado) ─── opcional   │
│ Business Requirement         breq-NNN          ─── implement. │
│ Business Rule                br-NNN            ─── implement. │
│ Stakeholder Requirement      (no implementado) ─── pendiente  │
│ System Requirement           (no implementado) ─── pendiente  │
│ Use Case                     uc-{MOD}-NN-...   ─── implement. │
│ Functional Requirement       fr-NNN-NN-...     ─── implement. │
│ Non-Functional Requirement   rnf-{MOD}-NNN-... ─── implement. │
│ Test Case                    EV_CP_NNN         ─── otro cajón │
└────────────────────────────────────────────────────────────────┘
```

## 5. Decisiones requeridas del ejecutor

| Decisión | Opciones | Implicación |
|---|---|---|
| **D-1** Crear cajones BABOK faltantes (`OE/N/RS/RSi`) | (a) Sí — todos / (b) Sólo `RS` (hay plantillas) / (c) No, dejar como aspiracional | (a) crea ~4 cajones nuevos / (b) crea 1 / (c) marca como "out of scope MVP" |
| **D-2** Conflicto BReq-001 nivel 1 vs ADR-GOB-003 | (a) Cambiar BReq-001 a nivel 2 / (b) Actualizar ADR-GOB-003 para que BReq sea N1 | (a) edit menor en BReq + actualizar metadata / (b) edit ADR-GOB-003 + revisar 5 niveles |
| **D-3** Nomenclatura ADR-GOB-003 (`BR-DOMINIO-###`) vs STD-007 (`br-NNN`) | (a) ADR-GOB-003 cede a STD-007 / (b) Migrar a `BR-DOMINIO-###` | (a) edit ADR-GOB-003 / (b) rename masivo (~150 archivos) |
| **D-4** Glosario § E (jerarquía BABOK no implementada) | (a) Mantener como referencia conceptual / (b) Implementar / (c) Mapeo explícito en metadata | Define cómo se documenta la relación BABOK ↔ source/ |
| **D-5** Cifras desactualizadas en TXM-02 | (acción mecánica, no requiere decisión) | Update directo |

## 6. Trazabilidad

- **Skill aplicada:** `workflow-analyze` (Phase 3 ANALYZE).
- **WP origen:** `2026-04-30-09-06-01-requisitos-update`.
- **Análisis previo:**
  `discover/requisitos-update-analysis.md` (DISCOVER).
- **Fuentes consultadas:**
  - `source/normativa/gobernanza/adr-gob-003-jerarquia-requerimientos-5-niveles.rst`
  - `source/base-cognitiva/glosario.rst` § E
  - `source/base-cognitiva/_taxonomias-y-metamodelos/taxonomias/txm-01-taxonomia-requisitos.rst`
  - `source/base-cognitiva/_taxonomias-y-metamodelos/taxonomias/txm-02-taxonomia-artefactos.rst` § 4
  - `source/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-01-metamodelo-requisitos.rst`
  - `source/normativa/estandares/std-007-convencion-naming.rst` (v2.0.2)
  - Inventario real: `find source/requisitos -name '*.rst'`
