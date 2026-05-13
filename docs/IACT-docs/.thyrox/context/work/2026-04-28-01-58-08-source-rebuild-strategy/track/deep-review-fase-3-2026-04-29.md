```yml
created_at: 2026-04-29 06:00:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 11 — TRACK (deep-review independiente Fase 3)
author: claude (deep-review agent independiente)
status: Aprobado
version: 1.0.0
```

# Deep-Review independiente — Remediation Fase 3 (2026-04-29)

## Resumen ejecutivo

**Veredicto: PARTIAL.**

Los 7 fixes de Fase 3 cierran correctamente sus puntos focales (MTM_03
§3.2/§4.3/§8.2, glosario:334, conteo 42 en los 9 sitios listados,
metadata FR-index, nota BR_016, ADR-GOB-008 calibracion). Sin embargo:

- F-DR-1 fue interpretado **estrictamente como "MTM_03"** y dejo intacto
  el mismo drift v4.0 en **5 docs hermanos** del cajon
  `_ontologia_sbvr/` y `_taxonomias_y_metamodelos/`.
- La nota BR_016 ("reservado / no asignado") **contradice** documentacion
  viva en FND_05 y TPL_BR que afirman BR_016 = "Tasa Abandono".

Ningun fix introduce refs Sphinx rotas, pero la cohesion cross-doc del
modelo RBAC sigue rota fuera del set de 9 sitios atendidos.

## Verificación de fixes Fase 3

| ID | Estado | Comentario |
|----|--------|-----------|
| F-DR-1 | **Parcial** | MTM_03:193, 404-410, 654-680 OK. Pero 5 docs hermanos conservan R001-R018, USERS_FULL_MANAGER, SYSTEM_ADMIN — drift v4.0 idéntico al diagnosticado. |
| F-DR-2 | **Completo** | glosario:331-335 ahora `:doc:` directo a CNST_033. |
| F-DR-3 | **Completo** | grep "44 funciones" → 0 hits. "42 funciones" en 11 sitios. |
| F-DR-4 | **Completo** | metadata 10 campos en `requisitos_funcionales/index.rst:1-11`. |
| F-DR-5 (deferido) | **Razonable** | UsuarioGrupo/AuditoriaPermiso son nombres de tablas Django reales canonificados en CNST_033 §2. Diferir es defendible. |
| F-DR-6 | **Incompleto / contradictorio** | Nota dice "BR_016 reservado" pero FND_05:183, TPL_BR:84/95/125, BR_018:230 lo citan como "BR_016 = Tasa Abandono". |
| F-DR-7 | **Completo** | filename CNST_031 verificable. |
| F-DR-8 | **Completo** | "75% completa" reformulado a "estado documentado en GAP_ANALYSIS". |

## Hallazgos del deep-review

### F3-DR-1 (ALTO) — Drift v4.0 sigue en 5 docs hermanos de MTM_03

`SBVR_02:117, 269-270`, `SBVR_03:130, 364-366, 464, 467-472`,
`SBVR_04:249-250, 410, 418, 424`, `SBVR_05:78, 277-278, 322,
334-335, 447`, `MTM_01:587, 593`, `TXM_01:122`, `TXM_03:205, 222`
contienen R001-R018, USERS_FULL_MANAGER, SYSTEM_ADMIN, SECURITY_ADMIN.

Mismo patron que F-DR-1 original. El fix se interpreto como "purgar
MTM_03" en vez de "purgar drift v4.0 en `base_cognitiva/`".

### F3-DR-2 (ALTO) — BR_016 contradiccion semantica activa

`reglas_negocio/index.rst:48-53` afirma "reservado / no asignado".
`FND_05:183` y `TPL_BR_Business_Rules.rst:84, 95, 125` afirman
"BR_016 = Tasa Abandono" como ejemplo canonico. `BR_018:230` lo cita
como complementario.

La nota describe ausencia fisica pero ignora referencias semanticas
activas. Decision necesaria: crear el archivo BR_016 o cambiar las
refs.

### F3-DR-3 (MEDIO) — MTM_03 §8.2 incompleta

`MTM_03_Metamodelo_RBAC.rst:651-684` "Funciones por Grupo Predefinido"
lista solo **5** de los 10 grupos (AGR-001, 002, 004, 006, 010),
faltando AGR-003, 005, 007, 008, 009.

La tabla §3.2:226-239 si lista los 10. Inconsistencia interna del
mismo doc.

### F3-DR-4 (BAJO) — Version RBAC mixta v5.1.1 vs v5.2.x

`FND_00:232, 268` y `MTM_03:732` usan "v5.1.1". `MTM_03:207, 404`,
`ADR-GOB-008` usan "v5.2.x". Mismo modelo, dos etiquetas.

### F3-DR-5 (BAJO) — `requisitos_funcionales/index.rst` toctree categorial

Aunque metadata fue agregada (F-DR-4 cerrado), `requisitos_funcionales/`
sigue exponiendo subdirectorios UC en su toctree (issue heredado del
deep-review previo, no parte del fix). Reservar para futuro WP.

## Aciertos detectados

1. **Conteo 42 funciones** propaga uniformemente — grep "44" da 0
   hits.
2. **F-DR-2 fix elegante** — `:doc:` directo a CNST_033 elimina la
   nota stale.
3. **MTM_03 §3.2 reescrita con tabla AGR-001..AGR-010 completa** y
   SoD-001/002/003 — supera el scope minimo del fix.
4. **F-DR-8 reformulacion** evita numero no calibrado, redirige a
   GAP_ANALYSIS — consistente con `calibration-verified-numbers.md`.

## Recomendaciones (Fase 4)

| Hallazgo | Acción concreta |
|----------|----------------|
| F3-DR-1 | Crear Fase 4 con scope explícito: `grep -rn "R0[0-1][0-9]\|USERS_FULL_MANAGER\|SYSTEM_ADMIN\|SECURITY_ADMIN" source/base_cognitiva/` y purgar las ~25 ocurrencias en SBVR_02..05, MTM_01, TXM_01, TXM_03 con la misma plantilla aplicada a MTM_03 §3.2. |
| F3-DR-2 | Decidir entre dos vías: (a) crear `BR_016_Tasa_Abandono.rst`; (b) actualizar FND_05:183 y TPL_BR para usar otro BR de cálculo. La nota actual no puede coexistir con las refs activas. |
| F3-DR-3 | Completar tabla `MTM_03 §8.2` con los 5 AGR faltantes (003, 005, 007, 008, 009). |
| F3-DR-4 | Adoptar una version canonica (recomendado v5.2.x) y propagar a FND_00:232, 268, MTM_03:732. |
| F3-DR-5 | Diferir a un WP de reorganizacion categorial. |

## Trazabilidad

Archivos analizados (9) + greps complementarios:

- `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst`
- `source/base_cognitiva/glosario.rst`
- `source/base_cognitiva/_fundamentos_conceptuales/FND_00_Contexto_y_Jerarquia.rst`
- `source/requisitos/casos_uso/access/UC_ACC_01_Asignar_Funciones.rst`
- `source/requisitos/reglas_negocio/BR_006_RBAC_Flat_NIST.rst`
- `source/requisitos/reglas_negocio/index.rst`
- `source/requisitos/requisitos_funcionales/index.rst`
- `source/normativa/gobernanza/ADR-GOB-008-rbac-coexistencia-acc-perm.rst`
- `track/deep-review-fases-1-2-2026-04-29.md` (referencia)

Greps de verificacion ejecutados:

- drift R001-R018/USERS_FULL_MANAGER en `source/`
- conteo 42 vs 44 en docs
- BR_016 cross-references
- versiones v5.x mezcladas
