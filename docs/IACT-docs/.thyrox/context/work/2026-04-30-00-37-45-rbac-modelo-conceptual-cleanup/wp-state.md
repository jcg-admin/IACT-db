```yml
project: IACT-docs
work_package: 2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup
sub_wp_of: 2026-04-29-17-52-15-modelo-rbac-improvement
program_id: Z.2
created_at: 2026-04-30 00:37:45
closed_at: 2026-04-30 04:30:00
current_phase: Phase 11 — TRACK (closed)
flow: thyrox
methodology_step: workflow-track
author: NestorMonroy
status: Closed
```

# Z.2 — RBAC Modelo Conceptual Cleanup (CLOSED)

## Resumen de cierre

WP cerrado tras ejecutar plan v5.4.0-implementation-plan.md
en 6 bloques. Modelo RBAC bumpeado de v5.3.0 a v5.4.0
(51 → 61 funciones; +10 nuevas; 6 renames preservando IDs;
0 eliminadas). 6 UCs nuevos, 2 consolidados, 4 re-mapeados,
4 constraints reescritos.

**Hallazgos derivados:** WP hijo
`2026-04-30-04-11-28-md-references-audit` abierto para
auditar 832 referencias `.md` en source/ que Sphinx no valida.

**Build final:** 1 warning preexistente (br-012 en archivo
histórico, fuera del scope), 0 errores.

**Trazabilidad completa:** ver
`track/wp-modelo-conceptual-cleanup-changelog.md`.

## Origen

Z.1.C confirmo el patron: hay drift estructural entre el modelo
v5.2.1 (42 funciones, 8 modulos) y los UCs/BRs/FRs vivos del
corpus que se crearon en epocas anteriores (v5.1.x con 44
funciones + segmentos).

**Cross-check inicial (Phase 1 DISCOVER preview):**

.. list-table::
 :header-rows: 1
 :widths: 18 20 16 16 30

 * - Modulo
   - Funciones (modelo)
   - UCs (source)
   - Delta
   - Status preliminar
 * - auth
   - 6
   - 5
   - -1
   - Posible AUTH-005/006 fantasma
 * - users
   - 9
   - 4
   - -5
   - UCs subdimensionados (1 UC cubre N funciones)
 * - access
   - 5
   - 7
   - +2
   - Drift residual post-Z.1.C
 * - pipeline
   - 4
   - 4
   - 0
   - OK
 * - reports
   - 8
   - **14**
   - **+6**
   - **Drift mayor — atender prioridad**
 * - alerts
   - 6
   - 5
   - -1
   - 1 funcion sin UC
 * - audit
   - 4
   - 4
   - 0
   - OK
 * - logs
   - 2
   - **4**
   - **+2**
   - **Drift — UCs sin funcion**

**6 de 8 modulos** tienen drift. Reports y Logs son los mas
criticos (UCs huerfanos sin funcion backing).

## Scope (Phase 1 DISCOVER)

### Foco prioritario (per peticion del ejecutor)

**MOD_Reports** (RPT-001..008): ``view_reports``,
``view_dashboard``, ``filter_reports``, ``export_csv``,
``export_excel``, ``export_pdf``, ``view_kpis``, ``view_charts``.

vs 14 UCs vivos:

- uc-rpt-01-ver-dashboard
- uc-rpt-02-ver-metricas-tiempo-real
- uc-rpt-03-ver-reportes-historicos
- uc-rpt-04-exportar-csv
- uc-rpt-05-exportar-excel
- uc-rpt-06-exportar-pdf
- uc-rpt-07-programar-reporte
- uc-rpt-08-ver-reportes-programados
- uc-rpt-09-configurar-filtros
- uc-rpt-10-guardar-vista
- uc-rpt-11-compartir-reporte
- uc-rpt-12-ver-reporte-agentes
- uc-rpt-13-ver-reporte-colas
- uc-rpt-14-ver-reporte-campanas

**Hallazgo preliminar:** UCs 7, 8, 9, 10, 11 no tienen funcion
backing obvia (no hay schedule_report, view_scheduled_reports,
configure_filters, save_view, share_report). UCs 12, 13, 14
parecen variantes de view_reports (¿drill-down vs vistas
genericas?).

### Foco sistematico

Auditar los 8 modulos completos con la misma lente:

1. ¿Cuantas funciones tiene declaradas el modelo?
2. ¿Cuantos UCs viven en source/?
3. ¿Cada UC tiene funcion backing? Si no, drift.
4. ¿Cada funcion tiene UC asociado? Si no, funcion fantasma o
   privada.
5. ¿Hay nombres legacy (capacidad, segmento) en cuerpos de UCs?
6. ¿Hay refs cruzadas a artefactos eliminados?

### Deuda residual de Z.1.C

~15 archivos con menciones textuales a "segmento" en cuerpos de
UCs (no :doc: refs, son texto narrativo + diagramas). Limpiar
sistematicamente.

### 21 findings del gap-analysis previo

El gap-analysis del modelo (en programa padre WP) identifico 21
findings (CRITICAL=1, MAJOR=10, MINOR=6, OK=4). Algunos ya se
resolvieron en Z.1 (metadata, vocabulario, cross-refs). Quedan:

- E-01: 39% del modelo es codigo embebido (decision de diseño:
  reference design — preservar pero etiquetar).
- E-02: versionado interno duplicado.
- E-04: seccion "12. Resumen" pertenece a metadata.
- N-02/03/04: distincion system vs custom groups, menu dinamico,
  permisos excepcionales (parcialmente cubierto en adr-gob-009).
- N-06: mapeo UC restringido a UC_ACC (debe expandirse).

## Acceptance criteria

- [ ] Cross-check completo modulo por modulo (matrix
      funcion <-> UC).
- [ ] Para cada drift identificado, decision Camino A/B/C.
- [ ] Aplicacion de decisiones (eliminar UCs huerfanos, agregar
      funciones faltantes, o reescribir UCs como variantes).
- [ ] Limpieza sistematica de menciones textuales a "segmento".
- [ ] Findings residuales del gap-analysis previo abordados.
- [ ] Build verde 0/0/0 con SPHINX_NITPICKY=1.
- [ ] Sin nueva deuda diferida.

## Riesgos

| Riesgo | Mitigacion |
|--------|-----------|
| Eliminar UCs huerfanos puede romper cross-refs en otros UCs | grep antes de cada eliminacion |
| Agregar funciones nuevas implica bump v5.2.1 -> v5.3.0 (MAJOR) | Documentar en ADR-GOB-NNN si es necesario |
| Renombrar UCs cambia anchors :ref: | Verify build despues de cada cambio |
| Scope creep — 14 UCs reports + 6 modulos drift | Particionar por bloques modulares |

## Estructura del WP

```
2026-04-30-00-37-45-rbac-modelo-conceptual-cleanup/
├── wp-state.md
├── discover/
│   ├── functions-vs-ucs-cross-check.md      (T-001 sistematico)
│   └── reports-deep-audit.md                (T-002 RPT prioritario)
├── measure/
├── analyze/
│   └── per-module-decisions.md              (Camino A/B/C por drift)
├── plan/
├── plan-execution/
└── track/
```

## Estimacion

~4-6h. Particionado en bloques por modulo:

- Bloque MOD_Reports (prioritario): 1.5-2h
- Bloque MOD_Logs + MOD_Auth + MOD_Users (drifts menores): 1-1.5h
- Bloque MOD_Access + MOD_Alerts (drift residual): 0.5-1h
- Bloque cleanup textual segmento: 1h
- Bloque findings gap-analysis residuales: 0.5-1h

## Proximo paso

T-001: cross-check sistematico funciones vs UCs en los 8 modulos
+ identificacion exacta de drifts.
