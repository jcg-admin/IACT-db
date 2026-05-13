```yml
project: IACT-docs
work_package: 2026-05-01-15-42-45-business-requirements-backfill
created_at: 2026-05-01 15:42:45
closed_at: 2026-05-01 15:44:20
current_phase: CERRADO (subsumido)
status: Cerrado — subsumido por WP 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
author: NestorMonroy
flow: rm
predecessor_wp: 2026-05-01-08-00-00-uc-auth-05-spec-completa
successor_wp: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
target: Backfill de 52 BReqs huerfanos referenciados por UCs
```

# WP — Business Requirements Backfill (CERRADO — subsumido)

## Estado de cierre

Este WP se cierra sin entregables generados. La iniciativa de
"backfill de 52 BReqs" se subsume en el WP sucesor
``2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo`` que
encuadra la falta de BReqs como un sintoma especifico de un gap
mas amplio: la metodologia documentada en
``source/base-cognitiva/`` (FND/TXM/MTM/SBVR/META) no esta
mapeada uniformemente al proyecto.

El analisis de inventario y las decisiones DEC-01..05 producidas
en este WP (ver abajo) se preservan como insumo del WP sucesor.

---

# WP — Business Requirements Backfill (contenido pre-cierre)

## Contexto

Auditoria del cajon
``source/requisitos/business-requirements/`` revela un gap
critico: existe **1** archivo (`breq-001-visibilidad-metricas.rst`)
pero los UCs referencian **52 BRQs distintos** en sus secciones de
trazabilidad. Cada UC declara `BReq origen: BRQ-AUTH-002` u
similar — pero el artefacto no existe.

**Origen del hallazgo**: revision durante la sesion de spec
completa de UCs (UC_AUTH_01..05). El usuario identifica que
estamos referenciando BReqs que no han sido formalizados.

## Inventario de BRQs huerfanos

Extraidos via:
``grep -rh "BRQ-" source/requisitos/casos-uso/ | grep -oE "BRQ-[A-Z]+-[0-9]+" | sort -u``

### Por cluster (52 BRQs total)

| Cluster | BRQs | IDs (huecos en numeracion) |
|---------|------|----------------------------|
| AUTH | 5 | 001, 002, 003, 004, 005 |
| USR | 4 | 001, 002, 003, 009 |
| ACC | 7 | 001, 002, 003, 004, 005, 008, 009 |
| RPT | 16 | 001..005, 007..017 |
| ALR | 5 | 001, 002, 003, 005, 006 |
| PIP | 4 | 001, 002, 003, 004 |
| AUD | 4 | 001, 002, 003, 004 |
| LOG | 7 | 001..007 |
| PERM | 0 | (cluster no usa convencion BRQ — usa PRIORIDAD/RNF/N) |

**Total a generar**: 52 BReqs.

### Huecos en numeracion (preservados)

Los huecos detectados (USR-004..008, ACC-006/007, RPT-006, ALR-004)
sugieren que durante creacion de los UCs hubo BReqs descartados. Se
preservan los huecos — NO renumerar — para mantener trazabilidad
historica.

## Anomalia: cluster PERM

Los 9 UCs de PERM cluster usan otro modelo de trazabilidad
("PRIORIDAD_01", "RNF-002", "N-001") — no BRQ-PERM-NNN. Decision:

- **Backfill de 52 BReqs no incluye PERM** en este WP.
- Hallazgo H-01: la convencion BRQ-{cluster}-NNN no se aplico
  uniformemente al cluster PERM.
- Resolucion futura (otro WP): normalizar PERM o documentar
  convencion alternativa explicitamente.

## Naming inconsistente con convencion existente

El archivo existente `breq-001-visibilidad-metricas.rst` NO sigue
el patron `BRQ-{cluster}-NNN` que usan los UCs. Decision tomada:

- **DEC-01**: nomenclar archivos como
  `breq-{cluster-lc}-NNN-{descripcion-kebab}.rst` para alinear con
  el ID `BRQ-{CLUSTER}-NNN` que usan los UCs.
- **DEC-02**: el archivo legacy `breq-001-visibilidad-metricas.rst`
  se renombra a `breq-rpt-006-visibilidad-metricas-globales.rst` —
  rellena el hueco RPT-006 que dejaron los UCs y se alinea con la
  convencion. Si se determina que su contenido no calza con un BRQ
  RPT especifico, queda como BRQ-RPT-006 con scope ampliado.

## Estructura propuesta

::

   source/requisitos/business-requirements/
   ├── index.rst                          (actualizado: toctree por cluster)
   ├── auth/
   │   ├── index.rst
   │   ├── breq-auth-001-iniciar-sesion.rst
   │   ├── breq-auth-002-cerrar-sesion.rst
   │   ├── breq-auth-003-recuperar-contrasena.rst
   │   ├── breq-auth-004-cambiar-contrasena.rst
   │   └── breq-auth-005-gestionar-sesiones.rst
   ├── users/
   │   ├── index.rst
   │   ├── breq-usr-001-...rst
   │   └── ... (4)
   ├── access/
   │   ├── index.rst
   │   └── ... (7)
   ├── reports/
   │   ├── index.rst
   │   └── ... (16, sin 006 → ese es el legacy renombrado)
   ├── alerts/
   │   ├── index.rst
   │   └── ... (5)
   ├── pipeline/
   │   ├── index.rst
   │   └── ... (4)
   ├── audit/
   │   ├── index.rst
   │   └── ... (4)
   └── logs/
       ├── index.rst
       └── ... (7)

## Plantilla por BReq (esqueleto)

Cada `breq-{cluster}-NNN-{...}.rst` contiene:

1. Meta directive con identificador
2. Identificacion (ID, nombre, cluster, version, autor, estado)
3. Necesidad de negocio (justificacion narrativa)
4. Stakeholders (quien lo demanda, quien beneficia)
5. Outcome esperado (que cambia en el negocio)
6. Reglas de negocio (BR) derivadas (lista, posiblemente vacia
   inicialmente)
7. UCs que lo realizan (back-reference)
8. Trazabilidad (CNST aplicables, ADRs, etc.)
9. Historial de cambios

Plantilla aplicable:
``source/normativa/estandares/plantillas/tpl-breq-objetivos-negocio``
(verificar si existe).

## Definicion de exito

- 52 archivos breq creados en estructura por cluster.
- 8 indices por cluster + index padre actualizado.
- 1 archivo legacy renombrado (DEC-02).
- TODOS los UCs que referencian un BRQ tienen artefacto resoluble
  (cross-reference Sphinx funciona).
- Build incremental sin nuevas warnings de tipo
  "unknown document" para BRQs.
- Commit unico convencional.

## Decisiones registradas

- **DEC-01**: nomenclar `breq-{cluster}-NNN-{desc}.rst` alineado con
  `BRQ-{CLUSTER}-NNN`.
- **DEC-02**: renombrar `breq-001-visibilidad-metricas.rst` a
  `breq-rpt-006-visibilidad-metricas-globales.rst`.
- **DEC-03**: preservar huecos en numeracion (no renumerar).
- **DEC-04**: PERM cluster fuera de scope de este WP (H-01).
- **DEC-05**: contenido inicial de cada BReq sera **stub
  estructurado** — meta + identificacion + necesidad esbozada +
  trazabilidad a UC. NO se inventaran reglas de negocio detalladas
  (BR) ni stakeholders fuera de los identificables desde el UC.
  Refinamiento posterior.

## Hallazgos

- **H-01**: Cluster PERM no usa la convencion BRQ.
- **H-02**: Huecos en numeracion sugieren BRQs descartados durante
  creacion de UCs (preservados, no renumerar).
- **H-03**: Plantilla `tpl-breq-objetivos-negocio` puede no existir
  o estar incompleta — verificar antes de aplicar.
- **H-04**: Algunos BReq pueden tener varios UCs como realizadores
  (ej. BRQ-AUTH-001 → UC_AUTH_01 unico; BRQ-LOG-001 → posible
  fan-out a varios UCs). Documentar relacion many-to-many cuando
  aplique.
