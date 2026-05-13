```yml
created_at: 2026-04-30 22:45:55
project: IACT-docs
work_package: 2026-04-30-22-45-55-rm-uc-relationships-analysis
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Hipótesis — pendiente de validación
version: 0.1.0
```

> **AVISO — documento prematuro.** Este artefacto se
> redactó antes de validar la base sobre la cual
> opera (modelo de dominio + inventario UC contra
> stakeholders). Se conserva como hipótesis no
> verificada hasta que exista un diagrama de clases
> canónico del proyecto y se reconcilien los 61 UCs
> del inventario con los 97 UCs declarados en
> ``analisis-dominio.rst § 11``. Las relaciones
> aquí inferidas dependen de UCs cuya correctitud
> no fue confirmada — riesgo R-02 del WP
> materializado.
>
> Stage 1 DISCOVER del WP debe re-orientarse
> previamente. Ver decisión pendiente al cierre de
> ``risk-register.md``.

# UC Relationships Analysis — Catálogo IACT (HIPÓTESIS)


Análisis de relaciones entre casos de uso del catálogo
IACT (61 UCs en 9 clusters), extraído del corpus
``source/requisitos/casos-uso/`` y clasificado en
include / extend / generalización / dependencia.

## Método de extracción

Las relaciones se cosecharon de tres fuentes dentro
de cada ``uc-*.rst``:

1. **Tabla "Trazabilidad" — fila "UC Relacionados"**
   (presente en 51 de los 61 UCs). Es la
   declaración canónica formal del autor.
2. **Diagrama PlantUML del § "3. Diagrama de Caso
   de Uso"** — flechas etiquetadas con
   ``<<include>>`` o ``<<extend>>``.
3. **Cuerpo textual** del flujo principal,
   precondiciones y postcondiciones — referencias
   explícitas a otro ``UC_*_NN``.

Los listados en este documento citan la fuente con
``[T]`` (Trazabilidad), ``[D]`` (Diagrama) o ``[F]``
(Flujo / cuerpo textual).

## Cobertura del campo "UC Relacionados"

| Cluster | UCs | Con UC Relacionados | Faltantes |
|---------|-----|---------------------|-----------|
| AUTH    | 5   | 5  | — |
| USR     | 4   | 4  | — |
| ACC     | 7   | 7  | — |
| PERM    | 10  | 0  | UC_PERM_01..10 |
| RPT     | 15  | 9  | UC_RPT_04, 07, 09, 10, 11 |
| ALR     | 5   | 5  | — |
| PIP     | 4   | 4  | — |
| AUD     | 4   | 4  | — |
| LOG     | 7   | 7  | — |
| **Total** | **61** | **45** | **16** |

> Hallazgo H-06 (OBSERVABLE): los 10 UCs PERM y
> 5 UCs RPT (04, 07, 09, 10, 11) no exponen "UC
> Relacionados" en su tabla de Trazabilidad. Esto
> rompe la trazabilidad uniforme. CRÍTICO para
> Stage 12 STANDARDIZE — definir si ese campo es
> obligatorio en la plantilla canónica.

## Relaciones intra-cluster — datos

Datos extraídos verbatim del campo "UC Relacionados"
de la Trazabilidad (fuente: ``[T]``).

### Cluster AUTH

| Origen | Relacionados |
|--------|--------------|
| UC_AUTH_01 | UC_AUTH_02, UC_AUTH_03, UC_AUTH_04 |
| UC_AUTH_02 | UC_AUTH_01, UC_AUTH_05 |
| UC_AUTH_03 | UC_AUTH_01, UC_AUTH_04, UC_USR_03 |
| UC_AUTH_04 | UC_AUTH_01, UC_AUTH_03 |
| UC_AUTH_05 | UC_AUTH_01, UC_AUTH_02 |

Relaciones cross-cluster: UC_AUTH_03 → UC_USR_03
(modificar usuario al recuperar contraseña).

### Cluster USR

| Origen | Relacionados |
|--------|--------------|
| UC_USR_01 | UC_AUTH_01, UC_ACC_01, **UC_ACC_07** |
| UC_USR_02 | UC_USR_01, UC_USR_03 |
| UC_USR_03 | UC_USR_02, UC_USR_04, UC_AUTH_05 |
| UC_USR_04 | UC_USR_02, UC_USR_03, UC_AUTH_05 |

Cross-cluster: USR ↔ AUTH (USR_03/04 → AUTH_05;
USR_01 → AUTH_01) y USR ↔ ACC (USR_01 → ACC_01).

> Hallazgo H-07 (OBSERVABLE): UC_USR_01 referencia
> **UC_ACC_07** ("Asignar Segmento") que no existe
> en el inventario (cluster ACC tiene IDs 01–05,
> 08, 09 — falta 07). Es referencia a un UC
> documentado pero no implementado, o renumerado.
> CRÍTICO — bloquea consistencia de catálogo.

### Cluster ACC

| Origen | Relacionados |
|--------|--------------|
| UC_ACC_01 | UC_ACC_02, UC_ACC_03, UC_ACC_04 |
| UC_ACC_02 | UC_ACC_01, UC_ACC_03 |
| UC_ACC_03 | UC_ACC_01, UC_ACC_02, UC_ACC_08 |
| UC_ACC_04 | UC_ACC_01, UC_ACC_03 |
| UC_ACC_05 | UC_ACC_01, UC_ACC_02, UC_ACC_04 |
| UC_ACC_08 | UC_ACC_01, UC_ACC_03 |
| UC_ACC_09 | UC_AUD_01, UC_AUD_02, UC_AUD_03 |

Cross-cluster: UC_ACC_09 (auditar cambios de
acceso) → AUD_01/02/03 — no auto-referencia, todo
el "auditar" pasa por AUD.

### Cluster PERM (Trazabilidad ausente)

Los 10 UCs PERM no exponen "UC Relacionados" en
su Trazabilidad. Sin embargo:

- ADR-GOB-008 declara coexistencia ACC ↔ PERM
  (cabecera de UC_PERM_07).
- Cada UC_PERM_NN cita una **función RBAC backing**
  del cluster ACC en su sección "Funcion RBAC
  backing" — esto define una correspondencia
  funcional 1:1 entre la vista PERM y la vista ACC.

Mapeo declarativo (fuente: ``[F]``, cabecera de
cada UC_PERM):

| UC_PERM | ACC backing |
|---------|-------------|
| UC_PERM_01 | ACC-004 ``assign_function_groups`` |
| UC_PERM_02 | ACC-010 ``revoke_function_group`` |
| UC_PERM_03 | ACC-008 ``grant_exceptional_permission`` |
| UC_PERM_04 | ACC-009 ``revoke_exceptional_permission`` |
| UC_PERM_05 | ACC-006 ``create_function_group`` |
| UC_PERM_06 | ACC-007 ``assign_functions_to_group`` |
| UC_PERM_07 | ACC-003 ``view_assignments`` |
| UC_PERM_08 | CNST-032 (SQL ``get_user_menu``) |
| UC_PERM_09 | AUD-001 ``view_audit_log`` |
| UC_PERM_10 | AUD-002 ``search_audit_log`` |

> Hallazgo H-08 (OBSERVABLE): la coexistencia
> ACC ↔ PERM declarada por ADR-GOB-008 produce
> 9 pares de UCs equivalentes (PERM_NN ≡ función
> RBAC ACC). Si se modela como **generalización a
> nivel actor** (PERM como vista usuario, ACC
> como vista RBAC) es coherente. Si se modela
> como duplicación, es deuda técnica de catálogo.
> Decisión de Stage 5 STRATEGY.

### Cluster RPT

| Origen | Relacionados |
|--------|--------------|
| UC_RPT_01 | UC_RPT_02, UC_RPT_03 |
| UC_RPT_02 | UC_RPT_01, UC_ALR_01, UC_ALR_02 |
| UC_RPT_03 | UC_RPT_01, UC_RPT_04 |
| UC_RPT_08 | UC_RPT_07 |
| UC_RPT_12 | UC_RPT_13, UC_RPT_14 |
| UC_RPT_13 | UC_RPT_12, UC_RPT_14 |
| UC_RPT_14 | UC_RPT_12, UC_RPT_13 |
| UC_RPT_15 | uc-rpt-03, uc-rpt-04, uc-rpt-12/13/14 |
| UC_RPT_16 | uc-rpt-03, uc-rpt-04 |
| UC_RPT_17 | uc-rpt-03, uc-rpt-04 |

Sin "UC Relacionados": UC_RPT_04, _07, _09, _10, _11.

Cross-cluster: UC_RPT_02 → ALR_01/02 (métricas
tiempo real con umbrales).

> Hallazgo H-09 (OBSERVABLE): los UCs RPT_15/16/17
> usan formato ``uc-rpt-NN`` (kebab) en su
> Trazabilidad, mientras los demás usan
> ``UC_RPT_NN`` (canónico). Mezcla de
> nomenclaturas pendiente de normalizar.

### Cluster ALR

| Origen | Relacionados |
|--------|--------------|
| UC_ALR_01 | UC_ALR_02, UC_ALR_03 |
| UC_ALR_02 | UC_ALR_01, UC_ALR_03, UC_ALR_04 |
| UC_ALR_03 | UC_ALR_02, UC_ALR_04 |
| UC_ALR_04 | UC_ALR_02, UC_ALR_03 |
| UC_ALR_05 | UC_ALR_01, UC_ALR_02 |

ALR es un cluster cerrado — sin referencias
cruzadas en su Trazabilidad. Pero ALR_03
(reconocer) escribe en AuditLog (CNST_025)
implícitamente.

### Cluster PIP

| Origen | Relacionados |
|--------|--------------|
| UC_PIP_01 | UC_PIP_02, UC_PIP_03, UC_PIP_04 |
| UC_PIP_02 | UC_PIP_01, UC_PIP_04 |
| UC_PIP_03 | UC_PIP_01, UC_PIP_04 |
| UC_PIP_04 | UC_PIP_01, UC_PIP_02, UC_PIP_03 |

Cluster cerrado — UCs PIP sólo se referencian
entre sí. Pero LOG_02 → PIP_01 (cross-cluster
desde LOG hacia PIP, ver más abajo).

### Cluster AUD

| Origen | Relacionados |
|--------|--------------|
| UC_AUD_01 | UC_AUD_02, UC_AUD_03 |
| UC_AUD_02 | UC_AUD_01, UC_AUD_03 |
| UC_AUD_03 | UC_AUD_01, UC_AUD_02 |
| UC_AUD_04 | UC_AUD_01, UC_AUD_03 |

Cluster cerrado en su Trazabilidad. Sin embargo
recibe referencias entrantes desde ACC_09
(auditar cambios de acceso).

### Cluster LOG

| Origen | Relacionados |
|--------|--------------|
| UC_LOG_01 | UC_LOG_02, UC_LOG_03, UC_LOG_04 |
| UC_LOG_02 | UC_LOG_01, UC_PIP_01 |
| UC_LOG_03 | UC_LOG_01, UC_LOG_04 |
| UC_LOG_04 | UC_LOG_01, UC_LOG_03 |
| UC_LOG_05 | uc-log-01, uc-log-02, uc-log-06, uc-log-07 |
| UC_LOG_06 | uc-log-05, uc-log-07 |
| UC_LOG_07 | uc-log-05, uc-log-06 |

Cross-cluster: UC_LOG_02 → UC_PIP_01 (consultar
logs ETL referencia supervisar ETL).

> Hallazgo H-10 (OBSERVABLE): LOG_05/06/07 usan
> formato kebab ``uc-log-NN`` igual que RPT_15-17
> (mismo patrón de H-09). Indica una migración
> de nomenclatura incompleta — los UCs creados
> después de cierta fecha usan kebab; los previos
> usan ``UC_*_NN``.

## Matriz cross-cluster (consolidada)

Aristas entre clusters (origen → destino) que
aparecen en alguna Trazabilidad ``[T]``:

| Origen | Destino | Vía |
|--------|---------|-----|
| AUTH | USR | UC_AUTH_03 → UC_USR_03 |
| USR | AUTH | UC_USR_01 → UC_AUTH_01; USR_03/04 → AUTH_05 |
| USR | ACC | UC_USR_01 → UC_ACC_01, UC_ACC_07* |
| ACC | AUD | UC_ACC_09 → UC_AUD_01/02/03 |
| RPT | ALR | UC_RPT_02 → UC_ALR_01/02 |
| LOG | PIP | UC_LOG_02 → UC_PIP_01 |

(*) UC_ACC_07 es referencia a UC inexistente —
ver H-07.

Aristas implícitas (declaradas en cuerpo, no en
Trazabilidad):

- **Todos los UCs** dependen transversalmente de
  UC_AUTH_01 (sesión activa requerida) y de
  UC_PERM_07 (verificar permiso) — no aparecen en
  la Trazabilidad pero son pre-condición universal
  citada por CNST_003 + CNST_030.
- UCs con auditoría (CNST_025) escriben evento que
  AUD_01-04 consulta — relación de productor /
  consumidor implícita.

## Clasificación formal de relaciones (UML)

Aplicando la semántica UML a las aristas
identificadas:

### Include — invocación obligatoria

Patrón canónico de uso del catálogo: cada UC
operativo *incluye* UC_AUTH_01 (autenticación
previa) y UC_PERM_07 (verificación de permiso).
Estas no aparecen como aristas explícitas en la
Trazabilidad porque se modelan como
pre-condiciones de seguridad transversales —
documentadas en CNST_003 y CNST_030, no como
``<<include>>`` por cada UC.

Includes explícitos cross-cluster:

| Origen | Include | Justificación |
|--------|---------|---------------|
| UC_USR_01 | UC_ACC_01 | Crear usuario incluye asignar funciones iniciales |
| UC_AUTH_03 | UC_USR_03 | Recuperar contraseña incluye modificar usuario (cambia hash) |
| USR_03/04 | UC_AUTH_05 | Modificar/eliminar usuario incluye cerrar sus sesiones |
| UC_RPT_02 | UC_ALR_01 | Métricas tiempo real incluye evaluar contra umbrales |
| UC_LOG_02 | UC_PIP_01 | Consultar logs ETL incluye contexto de supervisar ETL |

### Extend — variación condicional

No se identificaron ``<<extend>>`` formales en la
Trazabilidad. Los flujos alternativos (FA-NN) y
excepciones (EX-NN) viven *dentro* de la
especificación de cada UC, no como UCs separados.
Esto coincide con el patrón observado en
UC_AUTH_01 (FA-01 Primer Login, FA-02 Password
Expirado) — son secciones del UC, no UCs
extendidos.

### Generalización

Casos plausibles a modelar como generalización a
**nivel UC**:

- UC_RPT_12, UC_RPT_13, UC_RPT_14 (Ver Reporte
  Agentes / Colas / Campanas) son especializaciones
  de un UC abstracto "Ver Reporte por Categoría"
  no documentado. Comparten estructura idéntica.
- UC_RPT_15, UC_RPT_16, UC_RPT_17 (Transferencias /
  Menus IVR / Clientes Únicos) — mismo patrón.

Generalización a **nivel actor**:

- AGR-001 ``agr_operador_basico`` ⊂ AGR-002
  ``agr_operador_reportes`` ⊂ AGR-003
  ``agr_supervisor`` (jerarquía implícita por
  inclusión de funciones).
- AGR-006 ``agr_admin_usuarios`` y AGR-007
  ``agr_admin_acceso`` son perfiles paralelos
  (no-jerárquicos), separados por SoD CNST_030.

> Hallazgo H-11 (OBSERVABLE): la jerarquía
> AGR-001 ⊂ AGR-002 ⊂ AGR-003 está implícita en
> los actores asignados a UCs de RPT pero no
> declarada formalmente. Documentar como
> generalización en Stage 7 DESIGN.

### Dependencia

Dependencia transversal universal: todos los UCs
operativos dependen de UC_AUTH_01 (sesión) y de
UC_PERM_07 (verificación de permiso). Se modela
como **CNST_003** (sesión única) + **CNST_030**
(SoD enforcement) — no como ``<<include>>`` por
UC, para mantener legibilidad del diagrama.

Dependencia de auditoría: UCs con CNST_025
producen eventos consumidos por UC_AUD_01..04 —
relación productor/consumidor declarada en CNST_025.

## Diagrama PlantUML — overview cross-cluster

Diagrama de alto nivel que muestra clusters,
UCs ancla y dependencias transversales (no
descomposición completa).

.. uml::

   @startuml
   !include ../../_static/plantuml-styles.puml

   left to right direction

   actor "Usuario" as U
   actor "Supervisor" as S
   actor "Admin" as A
   actor "Auditor" as Aud

   rectangle "AUTH" {
     usecase "UC_AUTH_01\nIniciar Sesion" as AUTH01
     usecase "UC_AUTH_05\nGestionar Sesiones" as AUTH05
   }

   rectangle "USR" {
     usecase "UC_USR_01\nCrear Usuario" as USR01
   }

   rectangle "ACC / PERM (vistas)" {
     usecase "UC_ACC_01\nAsignar Funciones" as ACC01
     usecase "UC_PERM_07\nVerificar Permiso" as PERM07
   }

   rectangle "RPT / ALR" {
     usecase "UC_RPT_02\nMetricas Tiempo Real" as RPT02
     usecase "UC_ALR_01\nConfigurar Umbrales" as ALR01
   }

   rectangle "PIP / LOG" {
     usecase "UC_PIP_01\nSupervisar ETL" as PIP01
     usecase "UC_LOG_02\nConsultar Logs ETL" as LOG02
   }

   rectangle "AUD" {
     usecase "UC_AUD_01\nConsultar Auditoria" as AUD01
   }

   U     --> AUTH01
   S     --> RPT02
   A     --> USR01
   Aud   --> AUD01

   USR01 ..> ACC01  : <<include>>
   USR01 ..> AUTH01 : <<include>>
   RPT02 ..> ALR01  : <<include>>
   LOG02 ..> PIP01  : <<include>>

   AUTH01 ..> PERM07 : (CNST_030)
   RPT02  ..> PERM07 : (CNST_030)
   USR01  ..> PERM07 : (CNST_030)

   AUTH05 ..> AUD01 : (CNST_025)
   USR01  ..> AUD01 : (CNST_025)
   @enduml

## Verificación de hipótesis del wp-state

| Hipótesis | Resultado | Evidencia |
|-----------|-----------|-----------|
| H1: cada cluster tiene un UC ancla con includes desde el resto | **PARCIAL (INFERRED)** | Vale para AUTH (01), USR (01), PIP (01), AUD (01), LOG (01). No vale para RPT (sin ancla clara), PERM (vista paralela a ACC), ALR (estructura horizontal). |
| H2: UC_AUTH_01 dependencia transversal | **OBSERVABLE** | Citado en CNST_003 + flujos pre-condicionales de los 9 clusters. |
| H3: generalizaciones raras a nivel UC, comunes a nivel actor | **OBSERVABLE** | Confirmado: 0 generalizaciones UC explícitas; jerarquía AGR-001 ⊂ AGR-002 ⊂ AGR-003 implícita en RPT. |
| H4: aparecerán UCs huérfanos | **OBSERVABLE** | UC_RPT_04, _07, _09, _10, _11 no exponen UC Relacionados. UC_ACC_07 referenciado pero inexistente (H-07). |

## Hallazgos consolidados (Stage 1 + Stage 3)

| ID | Tipo | Descripción | Stage | Próximo paso |
|----|------|-------------|-------|--------------|
| H-01 | OBSERVABLE | Gaps de IDs en ACC/RPT | 1 | Cruzar con ``casos-uso-diagramas.rst § 15`` |
| H-02 | OBSERVABLE | wp-state cita CNST_002, corpus cita CNST_003 | 1 | Verificar definición CNST_002/003 |
| H-03 | OBSERVABLE | PERM no expone Actor Principal en meta | 1 | Normalizar plantilla |
| H-04 | OBSERVABLE | UC_ACC_09 usa AGR-008 vs AUD usa AGR-006 | 1 | Verificar catálogo agrupadores |
| H-05 | OBSERVABLE | Colisión id AGR-007 ACC vs LOG | 1 | CRÍTICO — verificar CNST_030 |
| H-06 | OBSERVABLE | 16 UCs sin "UC Relacionados" en Trazabilidad | 3 | STD plantilla obligatoria |
| H-07 | OBSERVABLE | UC_USR_01 referencia UC_ACC_07 inexistente | 3 | CRÍTICO — gap de catálogo |
| H-08 | OBSERVABLE | ACC ↔ PERM coexistencia (10 pares) — modelar como generalización? | 3 | Decisión Stage 5 STRATEGY |
| H-09 | OBSERVABLE | RPT_15/16/17 usan kebab ``uc-rpt-NN`` mientras el resto usa ``UC_RPT_NN`` | 3 | Normalizar nomenclatura |
| H-10 | OBSERVABLE | LOG_05/06/07 mismo patrón kebab que H-09 | 3 | Mismo fix que H-09 |
| H-11 | OBSERVABLE | Jerarquía AGR-001⊂002⊂003 implícita en RPT | 3 | Documentar como generalización en Stage 7 |

Ningún hallazgo SPECULATIVE — gate I-012
satisfecho.

## Próximo paso

Stage 3 ANALYZE — elaborar diagrama consolidado
por cluster en ``analyze/uc-catalog-diagram.md``
(uno PlantUML por cluster + el overview de este
documento). Antes, decidir con el ejecutor:

1. ¿Cómo modelar la coexistencia ACC ↔ PERM en
   el diagrama consolidado? (H-08, decisión de
   Stage 5 STRATEGY).
2. ¿Cerrar el gap UC_ACC_07 (H-07) creando el UC
   o eliminando la referencia desde UC_USR_01?
3. ¿Normalizar nomenclatura ``uc-rpt-NN``
   (kebab) → ``UC_RPT_NN`` (H-09, H-10) en este
   WP o diferirlo a un WP de saneamiento?
