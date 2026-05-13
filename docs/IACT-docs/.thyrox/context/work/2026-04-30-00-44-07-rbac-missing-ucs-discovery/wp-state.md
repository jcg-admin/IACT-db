```yml
project: IACT-docs
work_package: 2026-04-30-00-44-07-rbac-missing-ucs-discovery
sub_wp_of: 2026-04-29-17-52-15-modelo-rbac-improvement
program_id: Z.2.A
created_at: 2026-04-30 00:44:07
closed_at: 2026-04-30 01:30:00
current_phase: Phase 11 — TRACK
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado v1.0.0 — deep review completo, hallazgos para Z.2
```

# Z.2.A — Missing UCs Discovery (Deep Review)

## Origen

Z.2 Phase 1 DISCOVER detecto drift en MOD_Reports (+6 UCs huerfanos),
MOD_Logs (+2 UCs huerfanos), UC_PERM (10 UCs sin funcion backing).
El ejecutor pidio buscar en temp-holding antes de proponer
cambios al modelo — quizas los UCs faltantes ya existian
historicamente.

## Resultado: deep review confirmado, mapping completo

Ver ``discover/deep-review-missing-ucs.md``.

## Output: lista accionable para Z.2

Cierre con 4 categorias de UCs:

1. **UCs vivos correctamente mapeados** (29 UCs): no requieren accion.

2. **UCs vivos con funcion correcta en modelo** pero **mismatch
   nominal** (5 UCs): renombrar funcion del modelo o reescribir UC.

3. **UCs vivos con funciones inexistentes en modelo** que
   **historicamente existian en v5.0_1/v5.1** (3 UCs):
   - uc-rpt-07-programar-reporte: era RPT-009 ``programa_reportes``
   - uc-rpt-10-guardar-vista: era similar a RPT-010 ``comparte_reportes`` (mismatch)
   - uc-rpt-11-compartir-reporte: era RPT-010 ``comparte_reportes``
   - uc-log-03-buscar-logs: nunca en modelo (necesidad nueva)
   - uc-log-04-exportar-logs: existe LOG-002 ``export_logs`` (mismatch)

4. **UCs vivos que son variantes filtradas** (Camino C — no funciones
   nuevas) (4 UCs):
   - uc-rpt-08-ver-reportes-programados: variante de view_reports
     filtrado por "scheduled"
   - uc-rpt-09-configurar-filtros: instancia de filter_reports
   - uc-rpt-12/13/14: variantes filtradas por agentes/colas/campanas

5. **UC_PERM** (10 UCs): vista tecnica del RBAC; sus operaciones
   requieren ~5 funciones admin nuevas (slot ACC-006 disponible
   post-Z.1.C).

## Recomendacion para Z.2 ejecutor

Reabrir Z.2 con scope claro per estas 5 categorias.
