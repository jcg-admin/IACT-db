```yml
created_at: 2026-05-01 15:55:00
project: IACT-docs
work_package: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Survey profundo de `temp-holding/`

## 1. Estructura general descubierta

`/home/user/IACT-docs/temp-holding/` contiene **6 sub-arboles**:

| Sub-arbol | Contenido | Relevante para metodologia? |
|-----------|-----------|------------------------------|
| ``FASE 01/`` | Material de la primera generacion: BR oficiales, plan FR, PARTEs pedagogicas | SI — extensivo |
| ``FASE 02/`` | originales (FND, MTM, META, NOM), templates, tmp_work con analisis | SI — extensivo |
| ``GENERACION_DOCUMENTACION/`` | Backups iterativos: FASE 0, FASE 1, FASE 2, FASE 3-9, FASE 10..13 | SI — TPLs |
| ``Modules/`` | Codigo Python (privilege models/services) | NO — fuera de scope docs |
| ``RBAC/`` | Material RBAC | Parcial — ya esta en source/ |
| ``project/`` | decisions/quality/risks legacy | NO — antiguo |

## 2. Inventario por categoria de la metodologia

### 2.1 Templates encontrados (no integrados a `source/`)

Ubicacion: ``temp-holding/FASE 02/base_cognitiva/normativa/templates/`` y
``temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/``

| Template | Versiones disponibles | Existe en source? |
|----------|----------------------|-------------------|
| TPL_BReq_Objetivos_Negocio | v1.0.0 | SI — `source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst` |
| TPL_BR_Decision_Tipo | v1.1.0, v1.3.0, v1.3.1 | SI — `tpl-br-decision-tipo.rst` |
| TPL_FR_Documentacion_10_Componentes | v1.1.0..v1.3.1 | SI — `tpl-fr-documentacion-10-componentes.rst` |
| TPL_FR_Query_SQL | v1.1.0..v1.3.1 | SI — `tpl-fr-query-sql.rst` |
| TPL_FR_Validacion_Reglas | v1.1.0..v1.3.1 | SI — `tpl-fr-validacion-reglas.rst` |
| **TPL_TRZ_Matriz_RTM** | v1.1.0, v1.3.0, v1.3.1 | **NO en source/normativa/estandares/plantillas/** — falta integrar |
| TPL_UC_Construccion_7_Pasos | v1.1.0..v1.3.1 | SI |
| TPL_UC_Larman_Contratos | v1.1.0..v1.2.1 | SI? — verificar |
| TPL_UC_Stakeholder_Driven | v1.1.0..v1.3.1 | SI? — verificar |
| TPL_UC_Temporal_Schedulers | v1.1.0..v1.3.1 | SI? — verificar |
| TPL_UC_UI_Driven | v1.1.0..v1.3.1 | SI? — verificar |
| TPL_UC_CRUD_Operaciones | v1.1.0..v1.2.1 | SI? — verificar |
| TPL_UC_Actor_Secundario | v1.1.0..v1.3.1 | SI? — verificar |

Hallazgo: **TPL_TRZ_Matriz_RTM no esta integrado** — es la plantilla de la
matriz de trazabilidad central. Es el artefacto unico que conecta todos
los niveles BR/BReq/UC/FR/CODE/TEST.

### 2.2 Procedimientos encontrados (no integrados a `source/`)

Ubicacion: ``temp-holding/GENERACION_DOCUMENTACION/TMP_COMPLETO_IACT_2026-01-13_2/procedimientos/``

| Procedimiento | Existe en source? |
|---------------|-------------------|
| PROC_Generacion_BReq_1_0_0.rst | NO — falta integrar (procedimiento operativo critico) |
| PROC_Derivacion_BReq_BR_1_0_0.rst | NO — falta integrar |

Hallazgo: **2 procedimientos clave para BReq no estan integrados**.

### 2.3 Material pedagogico (PARTEs)

Ubicacion: ``temp-holding/FASE 01/Ingeniería de Requerimientos/``

7 documentos pedagogicos organizan la metodologia en 6 PARTES:

```
PARTE 0: Contexto y Fundamentos (puente)
PARTE 1: Identificar Reglas de Negocio (BR)
PARTE 2: Transformar BR -> UC
PARTE 3: Identificar UC adicionales (Larman)
PARTE 3B: Tecnica Larman completa
PARTE 3C: UI Stakeholders
PARTE 4: Especificar Requerimientos Funcionales (FR)
```

Existen tambien analisis derivados:
- ``EJEMPLOS_REALES_IACT_COMPLETO_0_0_1.md``
- ``ANALISIS_COMPLETO_PARTE0_vs_BASE_COGNITIVA__v_0.0.1.md``

Estado en source: **parcialmente integrado** en
``source/base-cognitiva/_fundamentos-conceptuales/`` (FND_00..FND_07).
Las PARTEs detalladas (Larman, UI Stakeholders, etc.) NO estan
integradas como contenido pedagogico extenso.

### 2.4 Inventario de BR oficiales (las 20 BR)

Ubicacion: ``temp-holding/FASE 01/BR_ Busines Requirements/las 20 BR.txt``

Las **20 BR canonicas del proyecto** estan documentadas con:

- ID (BR_001..BR_020)
- Nombre
- Tipo (Restriccion/Desencadenador/Hecho/Inferencia/Calculo) — **TXM_03**
- CNST relacionado

| Tipo | # | BR |
|------|---|-----|
| Restriccion | 10 | BR_001, 004, 005, 007, 008, 009, 010, 011, 019, 020 |
| Desencadenador | 3 | BR_002, 014, 015 |
| Hecho | 3 | BR_006, 012, 013 |
| Inferencia | 1 | BR_003 |
| Calculo | 3 | BR_016, 017, 018 |

Estado en source: verificar si `source/requisitos/reglas-negocio/`
contiene los 20 BR con esta clasificacion taxonomica.

### 2.5 Plan FR (393 FR estimados)

Ubicacion: ``temp-holding/FASE 01/FR_Requisitos_Funcionales/``

Tres documentos clave:

- ``PLAN_MAESTRO_FR_NFR_v1_0_0_borrador.md``
- ``ESTRUCTURA_COMPLETA_FR_ANEXO_V.0.0.1.md`` — **arbol detallado de
  393 FR organizados por UC**
- ``PLAN_FR_ANALISIS_REAL_v1_0_0.md``

Distribucion:

| Modulo | UCs | FRs | FRs/UC promedio |
|--------|-----|-----|-----------------|
| Auth | 5 | 38 | 7.6 |
| Users | 4 | 32 | 8.0 |
| Access | 9 | 89 | 9.9 |
| Pipeline | 4 | 32 | 8.0 |
| Reports | 14 | 112 | 8.0 |
| Alerts | 5 | 40 | 8.0 |
| Audit | 4 | 32 | 8.0 |
| Logs | 4 | 32 | 8.0 |
| **Total** | **49** | **407** | **8.3** |

Nomenclatura propuesta (no aplicada en source): ``FR_[MOD]_[UC]_[NN]``,
ej: ``FR_AUTH_01_03``.

Estado en source: ``source/requisitos/requisitos-funcionales/`` existe
pero **cobertura no medida en este WP** — verificar Phase 2 MEASURE.

### 2.6 BReq oficiales (5 vs 8 vs 52 — inconsistencia)

Hallazgo grave de coherencia metodologica — ver seccion 3.

## 3. Tres modelos contradictorios de BReq

La metodologia documentada y aplicada usa **TRES esquemas distintos** de
BReq sin reconciliacion. Esta es la causa raiz del gap.

### 3.1 Modelo A — FND_05 (canonico documentado)

Ubicacion: ``source/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles.rst`` § 3.5

Define **5 BReqs transversales** (no asociados a modulos):

| ID | Nombre | Metrica de exito |
|----|--------|------------------|
| BReq-001 | Visibilidad Metricas IVR | Dashboard actualizado cada 5 min |
| BReq-002 | Reduccion Tiempo Incidentes | Reduccion >= 40% vs baseline |
| BReq-003 | Decisiones Informadas | 100% decisiones con datos |
| BReq-004 | Cumplimiento Seguridad | 0 accesos no autorizados |
| BReq-005 | Integridad Datos | 0 escrituras no autorizadas |

Ratio: BReq:UC = 1:10 (5 BReq → 49-61 UC).

### 3.2 Modelo B — TPL_BReq (plantilla)

Ubicacion: ``source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio.rst``
+ version mas completa en
``temp-holding/.../TPL_BReq_Objetivos_Negocio_1_0_0.rst``

Define **8 BReqs por modulo** con formato ``BReq_[MOD]``:

| ID | Modulo |
|----|--------|
| BReq_AUTH | MOD_Auth |
| BReq_USR | MOD_Users |
| BReq_ACC | MOD_Access |
| BReq_PIP | MOD_Pipeline |
| BReq_RPT | MOD_Reports |
| BReq_ALR | MOD_Alerts |
| BReq_AUD | MOD_Audit |
| BReq_LOG | MOD_Logs |

Ratio implicito: 1 BReq por modulo.

### 3.3 Modelo C — UCs reales (observado)

Aplicado en los 56 UCs monoliticos + 5 splitted. Formato
``BRQ-{cluster}-NNN`` con multiples BReqs por cluster:

| Cluster | # BRQs |
|---------|--------|
| AUTH | 5 |
| USR | 4 |
| ACC | 7 |
| RPT | 16 |
| ALR | 5 |
| PIP | 4 |
| AUD | 4 |
| LOG | 7 |
| **Total** | **52** |

**Ningun documento de la metodologia documenta ni respalda este
modelo C.** Es un invento aplicado durante la creacion de UCs.

### 3.4 Resumen de inconsistencias

| # | Inconsistencia | Severidad |
|---|----------------|-----------|
| INC-01 | Modelo A (5 BReqs transversales) vs Modelo B (8 BReqs por modulo) — la metodologia se contradice consigo misma | ALTA |
| INC-02 | Modelo C (52 BRQ-{cluster}-NNN) no esta documentado en ningun lado — invento durante creacion UCs | ALTA |
| INC-03 | Naming: ``BReq-NNN`` (FND_05) vs ``BReq_[MOD]`` (TPL) vs ``BRQ-{cluster}-NNN`` (UCs) — tres conventions | ALTA |
| INC-04 | Cluster PERM no usa BRQ — usa PRIORIDAD/RNF/N (cuarto modelo, parcial) | MEDIA |
| INC-05 | Archivo existente ``breq-001-visibilidad-metricas.rst`` sigue Modelo A pero la plantilla TPL_BReq sigue Modelo B | MEDIA |

## 4. Decisiones de integracion necesarias

Para avanzar este WP necesitamos decidir antes de Phase 2 MEASURE:

### D-01: ¿Que modelo de BReq adoptar?

Opciones:

- **D-01.A**: Modelo A (5 BReq transversales). Reescribir las
  referencias en 61 UCs de ``BRQ-{cluster}-NNN`` a ``BReq-NNN``.
  Costo: alto (61 archivos modificados). Beneficio: alineamiento
  total con FND_05.

- **D-01.B**: Modelo B (8 BReq por modulo). Reescribir referencias
  ``BRQ-{cluster}-NNN`` a ``BReq_AUTH``, ``BReq_USR``, etc.
  Costo: alto. Beneficio: 1:1 con modulos, mas operativo.

- **D-01.C**: Hibrido A+B. 5 BReqs estrategicos + 8 BReqs de
  modulo. UCs declaran ambos: ``estrategico=BReq-001,
  modulo=BReq_AUTH``. Costo: muy alto (introducir 2 ejes).
  Beneficio: completo.

- **D-01.D** (RECOMENDADO): adoptar **Modelo A** y aceptar que el
  cluster sea informacion adicional (NO ID de BReq). Los UCs
  declaran: ``BReq satisfecho: BReq-001`` y opcionalmente ``modulo:
  MOD_Auth``. Esto resuelve INC-01 (Modelo A gana) e INC-02
  (Modelo C se descarta como deuda historica).

- **D-01.E**: aceptar **Modelo C** (52 BRQ-{cluster}-NNN) y crear
  los 52 BReqs como esta. La metodologia FND_05/TPL queda como
  deuda documental — su modelo A/B no se aplica. Costo: bajo
  (no reescribir UCs). Beneficio: cero alineamiento con metodologia.

### D-02: ¿Integrar templates faltantes?

- TPL_TRZ_Matriz_RTM no esta en source. **RECOMIENDO integrarlo**
  — es central para la trazabilidad.

### D-03: ¿Integrar procedimientos PROC_Generacion_BReq y PROC_Derivacion_BReq_BR?

**RECOMIENDO integrarlos** en
``source/normativa/procedimientos/`` — son operativos para crear
los BReqs sistematicamente.

### D-04: ¿Integrar el plan FR de 393 FR?

NO en este WP — fuera de scope. Documentar como WP futuro.

### D-05: ¿Integrar las PARTEs pedagogicas detalladas (Larman, etc.)?

NO en este WP — fuera de scope. Documentar como WP futuro.

### D-06: Cluster PERM (INC-04)

NO normalizar en este WP — fuera de scope. WP futuro.

## 5. Recomendacion ejecutiva

Aplicar las decisiones siguientes en este WP:

1. **D-01.D**: Adoptar Modelo A (5 BReqs transversales). Crear los 4
   BReqs faltantes (BReq-002..005). Modelo C (52 BRQs) se reconcilia
   en una tabla de mapping ``BRQ-{cluster}-NNN -> BReq-NNN`` que
   queda como anexo en el indice de business-requirements/, sin
   reescribir las referencias en UCs (son legibles humanamente
   mientras el mapping exista).

2. **D-02**: Integrar TPL_TRZ_Matriz_RTM como
   ``source/normativa/estandares/plantillas/tpl-trz-matriz-rtm.rst``.

3. **D-03**: Integrar PROC_Generacion_BReq y PROC_Derivacion_BReq_BR
   como
   ``source/normativa/procedimientos/proc-generacion-breq.rst``
   y
   ``source/normativa/procedimientos/proc-derivacion-breq-br.rst``.

4. **D-04 / D-05 / D-06**: registrar como WPs futuros, fuera de
   este alcance.

Costo total de la recomendacion en archivos producidos:

- 4 BReqs nuevos (BReq-002..005)
- 1 mapping table (anexo en index BReq)
- 1 template TPL_TRZ
- 2 procedimientos PROC_*

= **8 archivos nuevos / migrados** + actualizacion de indices.

## 6. Hallazgos consolidados

| ID | Hallazgo |
|----|----------|
| H-13 | TPL_TRZ_Matriz_RTM falta en source — pieza central de trazabilidad |
| H-14 | PROC_Generacion_BReq y PROC_Derivacion_BReq_BR faltan en source — operativos clave |
| H-15 | Tres modelos contradictorios de BReq coexisten (INC-01..05) — ninguna reconciliacion documentada |
| H-16 | Las 20 BR canonicas con clasificacion TXM_03 estan documentadas en temp-holding pero verificacion en source pendiente |
| H-17 | Plan FR de 393 FR existe en temp-holding como propuesta — no aplicado |
| H-18 | Material pedagogico Larman/UI Stakeholders existe pero no integrado al cajon ``source/base-cognitiva/`` (las PARTEs detalladas) |
| H-19 | TPL_BReq en source es la version v1.0.0 — alineado con la version en temp-holding |
| H-20 | El archivo legacy ``breq-001-visibilidad-metricas.rst`` sigue Modelo A correctamente |

## 7. Proximos pasos

Antes de Phase 2 MEASURE, este WP requiere:

- Aprobacion del usuario sobre las **D-01..D-06**.
- Especificamente confirmacion de **D-01.D** como modelo a adoptar.

Sin esa confirmacion, no se puede generar contenido en `source/` ya
que cualquier eleccion entre A/B/C/D/E afecta multiples archivos.
