```yml
project: IACT-docs
work_package: 2026-04-30-00-07-08-rbac-functions-count-audit
sub_wp_of: 2026-04-29-17-52-15-modelo-rbac-improvement
program_id: Z.1.C
created_at: 2026-04-30 00:07:08
reopened_at: 2026-04-30 01:15:00
closed_at: 2026-04-30 02:00:00
current_phase: Phase 11 — TRACK
flow: thyrox
methodology_step: cerrado
author: NestorMonroy
status: Cerrado v2.0.0 — Camino C aplicado, segmento descartado, 3 archivos eliminados
```

# Z.1.C — RBAC Functions Count Audit

## Origen

Sospecha del ejecutor (2026-04-30):

   "Tenemos un analisis mal acerca del numero de las funciones."

El conteo "**42 funciones**" se hereda del modelo
`modelo-rbac-iact.rst` v5.2.1 y se cita en multiples artefactos:

- :doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact` (modelo)
- :doc:`/arquitectura-tecnica/rbac/raci-rbac-iact` (matriz RACI
  recien creada en Z.1)
- :doc:`/normativa/gobernanza/adr-gob-009-rbac-modelo-conceptual`
  (ADR conceptual recien creado en Z.1)
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`
- :doc:`/normativa/restricciones/cnst-029-rbac-modelo-plano`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`

Si el conteo "42" es incorrecto, **toda esta cascada de
artefactos esta mal calibrada**. Critico para implementabilidad.

## Objetivo

Auditar exhaustivamente:

1. **Cuantas funciones** declara el modelo v5.2.1 vigente
   (`modelo-rbac-iact.rst`)?
2. **Cuantas funciones** suman las distribuciones por modulo
   (Auth=4, Users=9, Access=5, Pipeline=4, Reports=8, Alerts=6,
   Audit=4, Logs=2 = 42 segun cita; verificar)?
3. **Cuantas funciones** se mencionan en los UCs
   (UC_ACC_01..09 + UC_PERM_01..10 + UC_AUD_01..04)?
4. **Cuantas funciones** se mencionan en los grupos AGR-001..010
   (suman las funciones por grupo del modelo)?
5. **Hay funciones** mencionadas en alguno de estos artefactos
   que NO esten en el catalogo principal?
6. **Hay discrepancias** entre el modelo conceptual + el modulo
   ARQ_MOD_003 + los UCs?

## Acceptance criteria

- [ ] Inventario exhaustivo de funciones citadas en el modelo
      v5.2.1.
- [ ] Verificacion de la distribucion por modulo (suman
      exactamente al total declarado).
- [ ] Cross-check con UCs (UC_ACC, UC_PERM, UC_AUD).
- [ ] Cross-check con grupos AGR.
- [ ] Cross-check con material historico
      (`gestion/evidencia/rbac-historia/`).
- [ ] Identificacion de la cifra **correcta** (42 o N).
- [ ] Si el numero es distinto a 42, plan de actualizacion en
      cascada de los artefactos afectados.

## Riesgos

| Riesgo | Mitigacion |
|--------|-----------|
| Si el conteo cambia, hay que actualizar 6+ artefactos en cascada | Lista exhaustiva de menciones primero, plan de update despues |
| El modelo v5.2.1 puede tener inconsistencias internas (cita 42 en titulos pero suma N en detalle) | Auditar todas las cifras y subtotales |
| Los UCs pueden referenciar funciones que NO estan en el catalogo | Cross-check explicito |

## Out of scope

- NO modificar el modelo v5.2.1 en este WP — solo auditar.
- Si se detecta error, abrir WP propio (Z.2) para correccion.

## Estimacion

~1-2h. Mostly inspection + grep, minimal new files.

## Proximo paso

T-001: extraer cifras citadas en el modelo v5.2.1 + sumar
distribucion por modulo + cross-check.
