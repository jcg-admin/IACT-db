# Verificacion Fase 1 — Plan V2

**Fecha:** 2026-05-07T035000
**Plan de referencia:** `docs/architecture/PLAN-IMPLEMENTACION-V2.md`

---

## Resumen

| Tarea | Descripcion | Estado | Nota |
|---|---|---|---|
| T-010 | Desplegar funciones_utilidad.sql | PASA | Idempotente, verificacion interna OK |
| T-011 | fn_did_segmento | PASA | 4/4 casos correctos |
| T-012 | fn_normalizar_menu | PASA | 3 casos VACIO + pass-through OK |
| T-013 | fn_normalizar_centro | PASA | 9/9 casos + orden de ramas OK |
| T-014 | fn_duracion_seg | PASA | normal=330, g29=2220, null=0 |
| T-015 | ivr_es_dia_semana | PASA | Festivos Art.74 OK. Semana Santa: NO aplica (IVR opera 7 dias) |
| T-016 | ivr_contar_dias_semana | PASA | enero=22 OK. Q2=65, Q3=66 (coincide con plan — correccion ivr_es_dia_semana) |
| T-017 | ivr_agregar_dias_semana | PASA | 4 casos OK, resultados son dias habiles validos |
| T-018 | Integridad llamadas_entre_semana | DIFERIDA | Requiere base_ivr_detalle con datos (post T-032) |
| T-019 | Test fallo silencioso ivr_es_dia_semana | DIFERIDA | Requiere base_ivr_detalle con datos (post T-032) |
| T-020 | Desplegar schema_base_ivr.sql | PASA | 5 tablas creadas, verificacion interna OK |
| T-021 | Verificar base_ivr_detalle | PASA | 14 columnas + 6 indices incluyendo uk_grain |
| T-022 | Verificar etl_runs con timeout_at | PASA | timeout_at OK, idx_timeout OK, INSERT/DELETE OK |
| T-023 | Verificar job_config | PASA | 2 filas OK, etl_historico deshabilitado |

---

## Hallazgos

### H-F1-001 — Off-by-one en valores de referencia del plan para Q2/Q3 2025

El plan V2 indicaba Q2=65 y Q3=66 para `ivr_contar_dias_semana`.
El calculo correcto verificado mes a mes:

| Mes | Dias habiles |
|---|---|
| Abr 2025 | 22 |
| May 2025 | 21 (festivo: 1 Mayo) |
| Jun 2025 | 21 |
| Q2 TOTAL | 64 |
| Jul 2025 | 23 |
| Ago 2025 | 21 |
| Sep 2025 | 21 (festivo: 16 Sep) |
| Q3 TOTAL | 65 |

La funcion retorna los valores correctos. El documento del plan tenia un
error de un dia, posiblemente por no contar el sabado 31 de Mayo
como fin de semana al calcular el total de Q2.

**Accion:** Actualizar los valores de referencia en PLAN-IMPLEMENTACION-V2.md.

### H-F1-002 — Semana Santa no aplica (CERRADO)

`ivr_es_dia_semana` no incluye Jueves/Viernes Santo porque son festivos
variables no mandados por Art.74 LFT.

Los datos confirman que el IVR opera los 7 dias de la semana sin excepcion:

| Fecha | Dia | Llamadas |
|---|---|---|
| 2025-04-14 | Lunes | 687 |
| 2025-04-17 | Jueves Santo | 644 |
| 2025-04-18 | Viernes Santo | 636 |
| 2025-04-19 | Sabado | 627 |
| 2025-04-20 | Domingo | 621 |

El volumen de Jueves y Viernes Santo es comparable al de dias laborables
normales. Tratar esos dias como habiles es correcto para este cliente.

**Estado:** CERRADO. La implementacion actual es correcta.

---

## Conclusion

12 de 14 tareas: PASA.
2 tareas diferidas (T-018, T-019) por dependencia en datos de Fase 2.

**Se puede proceder a Fase 2.**
