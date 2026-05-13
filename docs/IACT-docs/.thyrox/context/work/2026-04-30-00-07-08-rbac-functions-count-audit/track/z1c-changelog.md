```yml
created_at: 2026-04-30 02:00:00
project: IACT-docs
work_package: 2026-04-30-00-07-08-rbac-functions-count-audit
phase: Phase 11 — TRACK
author: NestorMonroy
status: Cerrado
version: 1.0.0
```

# Z.1.C Changelog — RBAC Functions Count Audit

## Resumen

Sub-WP que reabrio investigacion del conteo "42 funciones" tras
sospecha del ejecutor. Inicialmente cerrado como "falsa alarma"
(v1.0.0); reabierto al ampliar busqueda a TODO temp-holding;
detecto drift estructural critico (UCs/BRs vivos sobre
segmentos vs modelo "Sin segmentos").

## Conclusion final: Camino C confirmado por el ejecutor

   "Camino C (Segmento = atributo, NO funcion RBAC) entonces se
   desaparece."

**Razonamiento del ejecutor (2026-04-30):**

1. La granularidad "Segmento" no aplica al contexto IACT.
2. El ETL ya entrega datos limpios y separados por dominio
   (CNST-007 + CNST-008).
3. La separacion funcional ya queda cubierta por la
   combinacion **AGR (perfil operativo) + MOD (categoria
   de informacion) + Funcion (accion especifica)**.

**Decision: el concepto "Segmento" se elimina del corpus
vigente.** El modelo v5.2.1 mantiene 42 funciones (correcto).
Los UCs/BRs vinculados al concepto descartado se eliminan.

## Cambios aplicados

### Outputs del Z.1.C (cerrar drift)

| Accion | Detalle |
|--------|---------|
| Glosario § H actualizado | Definicion de "Segmento de Datos" como **descartado en v5.2.0** + razon (ETL filtra + AGR+MOD+Funcion cubre) |
| 3 archivos eliminados via ``git rm`` | ``uc-acc-06-gestionar-segmentos.rst``, ``uc-acc-07-asignar-segmento.rst``, ``br-012-usuario-segmento-unico.rst`` |
| 2 toctrees actualizados | ``access/index.rst``, ``reglas-negocio/index.rst`` |
| 2 archivos con refs limpiadas (parcial) | ``br-020-clasificacion-datos.rst``, ``uc-usr-01-crear-usuario.rst`` |

### Build verify

- Build verde 0/0/0 con SPHINX_NITPICKY=1.
- 3 huerfanos eliminados sin romper refs entrantes.

## Findings de la auditoria

### Genealogia documentada del conteo

```
v4.0  (75)  -> v5.0  (57)  -> v5.1   (44)  ->
v5.1.1 (44) -> v5.2.0 (42) -> v5.2.1 (42, vigente)
                              ^ aqui se eliminaron USR-010 + ACC-006
                              y se introdujo "Sin segmentos"
```

### Drift detectado (origen del problema)

El cambio v5.1.x -> v5.2.0 elimino las 2 funciones de
segmentos en el modelo conceptual, pero **NO se actualizaron**
los UCs (UC_ACC_06, UC_ACC_07) ni la BR-012. Estos quedaron
como artefactos huerfanos durante 4 meses (enero-abril 2026)
hasta que esta auditoria los detecto.

### Verificacion de hipotesis del ejecutor

Hipotesis: "los grupos AGR + funciones cubren lo que
segmento intentaba resolver".

**Validada con evidencia:**

| Lo que segmento intentaba resolver | Quien lo cubre HOY |
|------------------------------------|---------------------|
| Que tipo de datos ve el usuario | MOD_* (Reports, Audit, Logs, Pipeline) |
| Que acciones puede hacer | Funciones individuales (RPT-001, AUD-001, etc.) |
| Que perfil operativo tiene | AGR-001..010 |
| Mutual exclusion entre dominios | 3 reglas SoD |

### Cifra correcta confirmada

- **42 funciones** es la cifra correcta y vigente.
- Distribucion: Auth(4) + Users(9) + Access(5) + Pipeline(4) +
  Reports(8) + Alerts(6) + Audit(4) + Logs(2) = 42.
- USR-010 y ACC-006 NO se restauran (decision Camino C).

## Deuda residual (transferida a Z.2)

Las refs textuales a "segmento" en el **cuerpo** de varios UCs
no se limpiaron en Z.1.C (scope creep). Se transfieren a Z.2
(rbac-modelo-conceptual-cleanup) que ya cubrira el cleanup
mayor del corpus.

Archivos con menciones residuales (~15):

- ``uc-usr-01-crear-usuario.rst`` (parcialmente limpiado;
  diagrams + flujos detallados pendientes)
- ``uc-usr-02-consultar-usuarios.rst``
- ``uc-usr-03-modificar-usuario.rst``
- ``uc-acc-03-consultar-permisos.rst``
- ``uc-acc-09-auditar-cambios-acceso.rst``
- ``uc-rpt-03/05/07/09/12*.rst`` (5 reports UCs)
- 4 FRs (auth, users, access)
- 3 FNDs (pedagogicos legacy, OK preservar como ejemplos)

**No bloqueante** — son refs textuales (no :doc:); el build
sigue verde.

## Implicaciones para artefactos del programa Z

| Artefacto | Status post-Z.1.C |
|-----------|-------------------|
| ``raci-rbac-iact.rst`` (Z.1) | Correcto en 42 funciones; sin cambios necesarios |
| ``adr-gob-009`` (Z.1) | Correcto en 42; sin cambios |
| ``adr-back-006`` (Z.1) | Correcto; sin cambios |
| Modelo v5.2.1 | Correcto (42 funciones validadas) |

## Lecciones aprendidas

1. **Cierre prematuro del v1.0.0 fue un error.** La busqueda
   inicial limitada a ``temp-holding/RBAC/`` dio 3 fuentes
   consistentes en 42 — pero el contexto completo
   (``temp-holding/`` entero + corpus ``source/`` actual)
   revelo el drift. Lecciones:

   - **Auditorias de conteo deben ampliar a TODO temp-holding,
     no solo el subdominio.**
   - **Auditorias de modelo deben cross-checkear con UCs/BRs
     vivos** (un modelo internamente consistente puede
     conflictuar con requisitos vigentes).

2. **El user tenia razon al sospechar.** Cuando el ejecutor
   senala una sospecha, ampliar el scope de validacion antes
   de declarar "falsa alarma".

3. **Drift detectable temprano** habria evitado 4 meses de
   inconsistencia. La proxima vez que se elimine un concepto
   del modelo, hacer scan inmediato de UCs/BRs/FRs que lo
   citen.

## Commits Z.1.C

```
6649a6d — Z.1.C v1.0.0 falsa alarma (cerrado prematuro)
f089387 — Z.1.C v2.0.0 reabierto, drift critico documentado
+ pending — Z.1.C cierre Camino C (este commit)
```

## Cierre

Z.1.C cierra con:

- 3 archivos huerfanos eliminados.
- Glosario actualizado (Segmento marcado como descartado).
- Build verde 0/0/0.
- 42 funciones validadas como cifra correcta.
- Deuda residual transferida a Z.2.

WP cerrado.
