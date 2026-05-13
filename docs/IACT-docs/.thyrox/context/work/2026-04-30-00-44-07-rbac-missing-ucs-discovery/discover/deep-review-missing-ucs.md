```yml
created_at: 2026-04-30 01:00:00
project: IACT-docs
work_package: 2026-04-30-00-44-07-rbac-missing-ucs-discovery
phase: Phase 1 — DISCOVER (deep review)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep Review — UCs faltantes y drifts (audit completo temp-holding)

## Calibracion

- **OBSERVABLE:** 56 claims (cross-check de 49 UCs source + 81 UCs
  temp-holding + 6 versiones del modelo + 12 docs analisis).
- **INFERRED:** 14 claims (categorizacion semantica de drifts).
- **SPECULATIVE:** 0.
- **Ratio:** 70/70 = 1.0 ≥ 0.75 ✓

## 1. Genealogia evolutiva del catalogo de funciones

| Version | Total | RPT | LOG | ACC | USR | Cambios clave |
|---------|------:|----:|----:|----:|----:|---------------|
| v4.0 (oct 2025) | 75+ | (con namespace ``identity:``, ``epm:``, ``base``) | — | — | — | Granular puro con namespaces |
| v5.0 (ene 2026) | 57 | — | — | — | — | Consolidacion inicial |
| v5.0_1 (ene 2026) | 57 | **10** | **2** | 6 | 10 | RPT-001..010 incluyendo programar/compartir |
| v5.1 (ene 2026) | 44 | **10** | **2** | 6 | 10 | Adaptacion 8 modulos IACT (rama "COMPLETO" alterna) |
| **v5.1.1** | **44** | **8** | **2** | 6 | 10 | **Consolidacion: RPT 10->8** (eliminadas programa_reportes, comparte_reportes; agregadas view_kpis, view_charts) |
| v5.2.0 (13 ene) | 42 | 8 | 2 | 5 | 9 | "Sin segmentos" (eliminadas USR-010, ACC-006) |
| v5.2.1 (vigente) | 42 | 8 | 2 | 5 | 9 | Correccion vocabulario (87 errores v5.2.0) |

**Hallazgo critico:** la transicion **v5.1 → v5.1.1** elimino 2
funciones RPT (``programa_reportes``, ``comparte_reportes``)
sin actualizar los UCs uc-rpt-07/10/11 que las citaban. Drift
introducido en enero 2026.

## 2. UCs en source/ vs temp-holding (cross-check)

### MOD_Reports (14 UCs source ↔ 14 UCs temp-holding)

Los **mismos 14 UCs** existen en ambos lados con identicos IDs:

| UC source | UC temp-holding | Funcion citada | Existe en v5.2.1? |
|-----------|-----------------|----------------|:-----------------:|
| uc-rpt-01-ver-dashboard | UC_RPT_01_Ver_Dashboard | RPT-001 view_reports | ✓ |
| uc-rpt-02-ver-metricas-tiempo-real | UC_RPT_02_Ver_Metricas_Tiempo_Real | RPT-002 view_dashboard | ✓ (mismatch nombre) |
| uc-rpt-03-ver-reportes-historicos | UC_RPT_03_Ver_Reportes_Historicos | RPT-003 filter_reports | ✓ (mismatch nombre) |
| uc-rpt-04-exportar-csv | UC_RPT_04_Exportar_CSV | RPT-004 export_csv | ✓ |
| uc-rpt-05-exportar-excel | UC_RPT_05_Exportar_Excel | RPT-005 export_excel | ✓ |
| uc-rpt-06-exportar-pdf | UC_RPT_06_Exportar_PDF | RPT-006 export_pdf | ✓ |
| uc-rpt-07-programar-reporte | UC_RPT_07_Programar_Reporte | RPT-007 ``programa_reportes`` (legacy v5.0_1/v5.1) | ❌ **eliminada en v5.1.1** |
| uc-rpt-08-ver-reportes-programados | UC_RPT_08_Ver_Reportes_Programados | RPT-008 ``crea_reportes`` (legacy) | ❌ renombrada a view_charts |
| uc-rpt-09-configurar-filtros | UC_RPT_09_Configurar_Filtros | RPT-009 ``configura_filtros`` | ❌ nunca en modelo |
| uc-rpt-10-guardar-vista | UC_RPT_10_Guardar_Vista | RPT-010 ``guarda_vistas`` | ❌ nunca en modelo |
| uc-rpt-11-compartir-reporte | UC_RPT_11_Compartir_Reporte | RPT-011 (originalmente RPT-010 comparte_reportes) | ❌ |
| uc-rpt-12-ver-reporte-agentes | UC_RPT_12 | RPT-012 | ❌ variante filtrada |
| uc-rpt-13-ver-reporte-colas | UC_RPT_13 | RPT-013 | ❌ variante filtrada |
| uc-rpt-14-ver-reporte-campanas | UC_RPT_14 | RPT-014 | ❌ variante filtrada |

### MOD_Logs (4 UCs source ↔ 4 UCs temp-holding)

| UC source | UC temp-holding | Funcion citada | Existe? |
|-----------|-----------------|----------------|:-------:|
| uc-log-01-consultar-logs-sistema | UC_LOG_01 | LOG-001 view_technical_logs | ✓ |
| uc-log-02-consultar-logs-etl | UC_LOG_02 | LOG-002 export_logs | ✓ (mismatch — UC dice consultar pero modelo dice exportar) |
| uc-log-03-buscar-logs | UC_LOG_03 | LOG-003 ``busca_logs`` | ❌ nunca en modelo |
| uc-log-04-exportar-logs | UC_LOG_04 | LOG-004 ``exporta_logs`` | ❌ duplicado nominal con LOG-002 |

### MOD_Permissions (10 UCs source ↔ 10 UCs temp-holding)

| UC source | UC temp-holding | Estado |
|-----------|-----------------|--------|
| uc-perm-01..10 | UC-PERM-001..010.md | UCs migrados, pero ``Funcion RBAC: NONE`` (vista tecnica del RBAC) |

10 UCs PERM vivos sin funcion backing del modelo conceptual.
Originalmente se sustentaban con vocabulario "Capacidad" del
sistema PERM legacy (proibido por CNST-033). Falta agregar
funciones admin canonicas al modelo.

## 3. Mapping recomendado (5 categorias)

### Categoria 1 — UCs OK (29 UCs sin accion)

Pipeline (4) + Audit (4) + Auth (5) + Users (4) + Access (7) +
Alerts (5) + Reports OK (6: RPT-01..06) = **35 UCs**.

Wait — recalibracion. UCs que CITAN funciones existentes
correctamente:

- 4 UC_AUTH (sin funcion declarada — patron OK para auth de
  usuario sobre si mismo)
- 4 UC_USR (citan USR-001..004 OK)
- 7 UC_ACC (citan ACC-001..005 OK; uc-acc-08 reusa ACC-001;
  uc-acc-09 cita AUD-001)
- 4 UC_PIP (citan PIP-001..004 OK)
- 4 UC_AUD (citan AUD-001..004 OK)
- 5 UC_ALR (citan ALR-001..005 OK)
- 6 UC_RPT (uc-rpt-01..06 citan RPT-001..006 OK)
- 2 UC_LOG (uc-log-01 cita LOG-001 OK; uc-log-02 cita LOG-002
  con mismatch nominal pero ID OK)

**Total: 36 UCs OK**.

### Categoria 2 — UCs con mismatch nominal (renombrar funcion del modelo)

5 UCs con funcion existente pero nombre diferente al UC:

- RPT-002 ``view_dashboard`` ↔ uc-rpt-02 ``ver-metricas-tiempo-real``
- RPT-003 ``filter_reports`` ↔ uc-rpt-03 ``ver-reportes-historicos``
- RPT-007 ``view_kpis`` ↔ uc-rpt-07 ``programar-reporte``
- RPT-008 ``view_charts`` ↔ uc-rpt-08 ``ver-reportes-programados``
- LOG-002 ``export_logs`` ↔ uc-log-02 ``consultar-logs-etl``

**Decision Camino C:** los nombres del modelo deben describir
la **accion canonica** (que hace), no el caso de uso particular.
RPT-002 ``view_dashboard`` es generico (dashboard puede ser
metricas tiempo real); el UC concreta esa accion.

### Categoria 3 — UCs con funciones que existieron historicamente y se eliminaron en v5.1.1

3 UCs con respaldo conceptual en v5.0_1/v5.1 pero eliminadas:

| UC source | Funcion historica | Status v5.2.1 | Recomendacion |
|-----------|-------------------|:-------------:|---------------|
| uc-rpt-07-programar-reporte | RPT-009 ``programa_reportes`` (v5.0_1, v5.1) | Eliminada | **Restaurar como funcion nueva** (slot disponible: RPT-009 era ``programa_reportes`` originalmente) |
| uc-rpt-10-guardar-vista | (similar a "save view" feature, no en modelos historicos) | NO existe | **Agregar funcion nueva** ``save_view`` |
| uc-rpt-11-compartir-reporte | RPT-010 ``comparte_reportes`` (v5.0_1, v5.1) | Eliminada | **Restaurar** ``share_report`` |

### Categoria 4 — UCs que son variantes filtradas (Camino C — no funciones)

4 UCs que NO requieren funcion nueva — son **variantes de
view_reports filtradas por scope de datos**:

- uc-rpt-08-ver-reportes-programados: filter scheduled = true
- uc-rpt-09-configurar-filtros: subset/preset de filter_reports
- uc-rpt-12-ver-reporte-agentes: filter scope = "agentes"
- uc-rpt-13-ver-reporte-colas: filter scope = "colas"
- uc-rpt-14-ver-reporte-campanas: filter scope = "campanas"

**Decision recomendada:**

- **Reescribir UCs** para citar funcion correcta del modelo
  (RPT-001/RPT-003) + clarificar que son "ejemplos de aplicacion"
  con filtros concretos, NO funciones distintas.
- **Alternativa:** eliminar UCs 12/13/14 y dejar solo 1-2
  representativos (por ejemplo uc-rpt-12 como ejemplo
  pedagogico de "view_reports filtrado por scope").

### Categoria 5 — UC_PERM admin functions (5 funciones nuevas)

10 UCs PERM sin funcion backing. Necesitan agregar al modelo:

- ``revoke_function_group`` (uc-perm-02)
- ``grant_exceptional_permission`` (uc-perm-03)
- ``revoke_exceptional_permission`` (uc-perm-04)
- ``create_function_group`` (uc-perm-05)
- ``assign_functions_to_group`` (uc-perm-06)

Slots disponibles tras Z.1.C (ACC-006 libre):

- ACC-006 ``create_function_group``
- ACC-007 ``assign_functions_to_group``
- ACC-008 ``revoke_function_group``
- ACC-009 ``grant_exceptional_permission``
- ACC-010 ``revoke_exceptional_permission``

UCs adicionales:

- uc-perm-01: ya cubierto por ACC-004 ``assign_function_groups``
- uc-perm-07: cubierto por ACC-003 ``view_assignments``
- uc-perm-08: CNST-032 (funcion SQL ``get_user_menu``, no RBAC)
- uc-perm-09: AUD-001 ``view_audit_log``
- uc-perm-10: AUD-002 ``search_audit_log``

## 4. Reframing: el modelo v5.2.1 vigente HEREDA un error de v5.1.1

**Observacion critica del ejecutor:**

   "Si tu modelo viene de v5.1.1, tiene el mismo error."

**Validado:** la transicion v5.1 → v5.1.1 elimino 5 funciones RPT
legitimas (``ve_reportes_avanzados``, ``ve_reportes_consolidados``,
``crea_reportes``, ``programa_reportes``, ``comparte_reportes``)
y reasigno IDs a otras funciones (``ve_dashboard``,
``filtra_reportes``, ``ve_kpis``, ``ve_graficos``) **sin
actualizar los UCs que las citaban**.

Ese error se hereda al modelo vigente:

::

   v5.0_1 / v5.1     v5.1.1 (ERROR)    v5.2.1 (HEREDA ERROR)
   10 funciones RPT  -> 8 funciones    -> 8 funciones (vigente)
   + UCs alineados   -> UCs huerfanos  -> UCs siguen huerfanos

**No se trata de "agregar funciones nuevas a un modelo
correcto".** Se trata de **restaurar funciones legitimas que el
modelo elimino erroneamente** + agregar las realmente nuevas
requeridas.

## 4.b Reformulacion del bump propuesto (con correccion)

### Funciones a RESTAURAR (eliminadas erroneamente en v5.1.1)

Comparing v5.0_1/v5.1 vs v5.2.1:

| Funcion legacy v5.0_1/v5.1 | Status v5.2.1 | UC vivo que la reclama |
|----------------------------|:-------------:|------------------------|
| RPT-009 ``programa_reportes`` | Eliminada | uc-rpt-07-programar-reporte |
| RPT-010 ``comparte_reportes`` | Eliminada | uc-rpt-11-compartir-reporte |
| RPT-008 ``crea_reportes`` | Renombrada a ``view_charts`` | (sin UC vivo, podria descartarse) |
| RPT-002 ``ve_reportes_avanzados`` | Renombrada a ``view_dashboard`` | uc-rpt-02-ver-metricas-tiempo-real |
| RPT-003 ``ve_reportes_consolidados`` | Renombrada a ``filter_reports`` | uc-rpt-03-ver-reportes-historicos |

**Restaurar minimo 2** (las que tienen UC vivo y no fueron
absorbidas conceptualmente por otras funciones):

- ``schedule_report`` (era ``programa_reportes``) ← uc-rpt-07
- ``share_report`` (era ``comparte_reportes``) ← uc-rpt-11

### Funciones realmente nuevas (no historicas)

- ``save_view`` ← uc-rpt-10-guardar-vista (concepto nuevo,
  feature UI/UX no en v5.0_1)
- ``search_logs`` ← uc-log-03-buscar-logs

### Funciones admin para UC_PERM (no historicas — vista tecnica)

5 funciones admin para sustentar UC_PERM (Cat 5).

### Cifra final

| Cambio | Funciones |
|--------|----------:|
| Estado actual v5.2.1 (con error heredado de v5.1.1) | 42 |
| + RESTAURAR RPT-009 ``schedule_report`` | +1 |
| + RESTAURAR RPT-010 (era 011) ``share_report`` | +1 |
| + NUEVA ``save_view`` | +1 |
| + NUEVA ``search_logs`` | +1 |
| + 5 admin ACC-006..010 (UC_PERM backing) | +5 |
| **Total v5.3.0** | **51** |

**Bump v5.2.1 → v5.3.0 (MAJOR)** — agrega 9 funciones (21%
incremento), de las cuales **2 son restauraciones** (correccion
del error v5.1.1) y **7 son funciones realmente nuevas**.

### Mismatches de Categoria 2 (a resolver con renaming)

Algunos UCs citan funciones existentes pero con nombre que NO
matchea. Decision Camino C-style:

- **Renombrar las funciones** del modelo para alinear con UCs
  (uc-rpt-02 ``ver-metricas-tiempo-real`` → renombrar RPT-002
  de ``view_dashboard`` a algo mejor como
  ``view_realtime_metrics``).

O bien:

- **Reescribir UCs** para usar el nombre canonico (uc-rpt-02
  reescrito como "Ver Dashboard" ya que RPT-002 = view_dashboard).

**Recomendacion:** evaluar caso por caso en Z.2 ejecucion.

## 5. UCs que requieren ELIMINAR (Cat 4)

3 UCs sin valor agregado al corpus (son variantes filtradas):

- ``uc-rpt-12-ver-reporte-agentes``
- ``uc-rpt-13-ver-reporte-colas``
- ``uc-rpt-14-ver-reporte-campanas``

**Alternativa preservativa:** mantener uno como ejemplo
pedagogico del concepto "view_reports con filtro de scope"
y eliminar los otros 2.

## 6. UCs que requieren REESCRIBIR (Cat 2 + parte Cat 4)

5 UCs con mismatch nominal (citar funcion correcta + clarificar
nombre):

- uc-rpt-02-ver-metricas-tiempo-real → RPT-002 view_dashboard
- uc-rpt-03-ver-reportes-historicos → RPT-003 filter_reports
- uc-rpt-08-ver-reportes-programados → RPT-001 view_reports +
  filter scheduled
- uc-rpt-09-configurar-filtros → RPT-003 filter_reports
- uc-log-02-consultar-logs-etl → LOG-001 view_technical_logs
  (no LOG-002)

## 7. Decision pendiente del ejecutor

Z.2.A entrega esta clasificacion de 5 categorias. La ejecucion
de los cambios va en Z.2.

Decisiones que Z.2 debe confirmar:

1. **¿Bumpeo del modelo a v5.3.0** (+9 funciones, total 51)?
2. **¿Eliminar uc-rpt-12/13/14** (variantes filtradas) o
   preservar 1?
3. **¿Reescribir 5 UCs con mismatch nominal**?
4. **¿Agregar 5 funciones admin ACC-006..010** para UC_PERM?

## 8. Outputs Z.2.A

- ``wp-state.md`` — cierre del WP.
- ``discover/deep-review-missing-ucs.md`` — este documento.

NO hay cambios en ``source/`` desde Z.2.A (es discovery puro).

## 9. Lecciones aprendidas

1. **Auditar genealogia evolutiva** revela patrones que
   auditorias puntuales no detectan. La transicion v5.1 → v5.1.1
   introdujo el drift que persistio 4 meses.

2. **temp-holding tiene UCs con mismos IDs** que source/. Los
   UCs no se inventaron en source/; vienen de los modelos
   tempranos del corpus.

3. **Funciones eliminadas en v5.1.1** sin actualizar UCs es el
   patron raiz del drift. Igual que segmentos en Z.1.C, pero a
   nivel diferente (RPT y LOG, no segmentos).

4. **UC_PERM como vista tecnica del RBAC**, sin funciones
   backing, es un drift estructural mas profundo: implica que
   el modelo conceptual no cubre las operaciones de
   administracion del RBAC mismo. Requiere expansion canonica.
