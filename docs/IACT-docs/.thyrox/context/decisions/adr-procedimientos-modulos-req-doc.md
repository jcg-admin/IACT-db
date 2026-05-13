```yml
type: ADR (Architecture Decision Record)
project: IACT-docs
status: Aprobado
created_at: 2026-04-29 16:50:00
decision_date: 2026-04-29
deciders: NestorMonroy
related_wp: 2026-04-29-14-56-40-std007-rename-cleanup
related_std: STD_007 v2.0.1
```

# ADR — Procedimientos Transversales: Módulos REQ y DOC

## Contexto

Tras la migración a STD_007 v2.0.0 (patrón universal kebab),
quedaron **39 archivos `proc-*` que no seguían
`proc-<MOD>-<NNN>-<desc>.rst`** sino sólo `proc-<descripcion>.rst`.

Eran los antiguos PROC_<Descripcion>_PascalCase que STD_007 v1.1.0
documentaba como excepción "procedimientos transversales sin módulo
asignable". v2.0.0 olvidó replicar esa excepción al sustituir el
sistema de dialectos.

Dos opciones para alcanzar 100% de cumplimiento contra el patrón
universal:

| Opción | Acción | Costo | Beneficio |
|--------|--------|-------|-----------|
| A | Restaurar la excepción "transversales" en §8 | 1 archivo modificado | Documenta status quo pero perpetúa fragmentación |
| B | Asignar módulos a los 39 (crear si hace falta) | 39 renames + refs | Cumplimiento estructural total + módulos como categorías navegables |

## Distinción importante: Esto NO rompe el commitment de v2.0.0

El commitment de v2.0.0 §8.2 es: *"30 días sin nuevas modificaciones
a STD_007"* — refiriéndose al **patrón universal**, que NO cambia
con esta decisión.

Lo que se agrega es una **tabla de módulos canónicos** dentro de §4
(que ya existe). Es un PATCH (clarificación), no un MAJOR
(modificación de la regla). Análogo a v1.1.0 que clarificó §3.3 sin
contradecir v1.0.0.

## Análisis de los 39 archivos

Los 39 procedimientos transversales se agrupan en 3 buckets
semánticos:

### Bucket 1: Requirements Engineering (18 archivos)

Procedimientos que tratan exclusivamente sobre artefactos de
requisitos: UC, BR, BReq, CNST, FR, NFR. Generación, derivación
entre niveles, revisión, cambio, cobertura.

Ningún módulo existente aplica:
- ``dev`` es software development pipeline.
- ``qa`` es calidad/testing.
- ``gob`` es lifecycle documental (aprobación, publicación, etc.).

**Decisión:** crear módulo **REQ**.

### Bucket 2: Documentation Engineering (14 archivos)

Procedimientos que generan artefactos documentales que NO son
requisitos: STD, ADR, POL, MOD, FD, VIEW, RTM, API, TST, INDEX,
+ revisión de templates y tooling Sphinx.

**Decisión:** crear módulo **DOC**.

### Bucket 3: Lifecycle documental (7 archivos)

Aprobación, publicación, congelamiento, descongelamiento,
auditoría, actualización de modelo, versionado.

**Encaja perfectamente en módulo ``gob`` existente**
(gobernanza). Numeración existente: 001, 002, 008. Llenar gaps
003-007, 009, 010.

## Decisión

1. Crear módulos **REQ** y **DOC**.
2. Asignar 18 + 14 + 7 = 39 archivos a los buckets correspondientes.
3. Bump STD_007 v2.0.0 → **v2.0.1** documentando módulos canónicos
   en §4.
4. Renombrar 39 archivos via ``git mv`` + actualizar refs en cascada.

## Numeración asignada

**REQ-001..018:** generacion-breq, derivacion-breq-br, generacion-br,
generacion-cnst, derivacion-br-uc, revision-uc-previo-derivacion,
generacion-uc, derivacion-uc-fr, generacion-fr, generacion-nfr,
derivacion-fr-tst, derivacion-fr-code, elaboracion-completa-requisitos,
cambio-requisitos, excepciones-cnst, identificar-gaps-huerfanos,
verificacion-cobertura, crear-plan-analisis.

**DOC-001..014:** generacion-std, generacion-adr, generacion-pol,
generacion-mod, generacion-fd, generacion-view, generacion-rtm,
generacion-api, generacion-tst, generacion-index,
revision-tpl-previo-generacion, revision-artefactos,
validacion-sphinx, crear-estructura-directorios-tmp.

**GOB-003..010 (extiende existente):** aprobacion-documentos,
congelamiento-subdominio, descongelamiento-subdominio,
actualizacion-modelo-documental, publicacion-documentacion,
auditoria-documental (009 — 008 ya tomado por
reorganizacion-estructura-documental), versionado-semantico.

El orden dentro de cada módulo refleja un flujo lógico (jerarquía
de requisitos en REQ; orden alfabético/dependencia en DOC).

## Consecuencias

**Positivas:**

- 100% del corpus cumple ``proc-<MOD>-<NNN>-<desc>.rst`` o
  ``<desc-kebab>.rst`` (guías sin prefijo) o ``proced-<MOD>-<NNN>-...``.
- Módulos REQ y DOC dan estructura navegable (un futuro lector
  puede listar todos los procedimientos de Requisitos con
  ``ls proc-req-*``).
- Sin más excepciones documentadas a la regla universal.

**Negativas mitigadas:**

- 39 renames más + ~80 refs actualizadas. Costo único, ya pagado.
- Módulos REQ/DOC nuevos — pueden requerir educación del equipo.
  Mitigación: tabla canónica documentada en STD_007 v2.0.1 §4.

## Salvaguarda anti norm-churn — sigue vigente

El commitment de 30 días (§8.2) NO se reinicia con v2.0.1. La
fecha de cierre sigue siendo **2026-05-29** (30 días desde v2.0.0).
v2.0.1 es PATCH = compatible = no es modificación del patrón.

Si en 30 días aparece evidencia que justifique nueva modificación
del patrón universal, abrir WP propio.

## Referencias

- STD_007 v2.0.1 (este WP).
- ADR ``adr-naming-conventions-kebab-correction.md`` — establece
  v2.0.0.
- Script ``plan-execution/scripts/assign-modules.py`` — mapping
  exacto de los 39 renames.
